//
//  EpisodeManager.swift
//  OdysseyOfMe Watch App
//
//  Created by Tanner Brown on 11/23/22.
//

import Foundation
import CoreData
import OSLog
import HealthKit
import WatchKit
import Combine
import AVFoundation

final class EpisodeManager: NSObject, ObservableObject {
    
    /**
     Logger Object
     */
    private let LOGGER = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: EpisodeManager.self)
    )
    
    @Published var isShowingSummary : Bool = false
//    @Published var isShowingEpisodeEndAlert = false
    
    var moc : NSManagedObjectContext?
    var startDate : Date = Date()
    
//    //Run State
    @Published var running = false
    @Published var paused = false
    @Published var isCancelled = false

    
    //Timer
    @Published var timer : EpisodeTimer = EpisodeTimer()
    var timerSubscription : Cancellable?
    
    //Audio session tracking for Db levels
    let audioSession = AVAudioSession.sharedInstance()
    var audioRecorder: AVAudioRecorder = AVAudioRecorder()
    
    //Tracked Values
    @Published var currDb : Int = 0
    @Published var currHR : Int = 0
    @Published var steps : Int = 0
    @Published var intervals : [Date] = []
    @Published var soundChecks : [Date:Int] = [:]
    @Published var hrChecks : [Date:Int] = [:]
    
    var heartRateAvg : Double {
        return Array(hrChecks.values).average
    }
    
    
    @Published var workout : HKWorkout?
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    
    let MIN_EPISODE_TIME : Double = 60 * 5 //min 5 minute episode
    
    var episodeElapsedTime : TimeInterval {
        return Date.now.timeIntervalSince(builder?.startDate ?? Date.now)
    }
    
    func startEpisode(moc : NSManagedObjectContext){
        
        self.moc = moc
        
        resetEpisode()
        
        //workout config
        let config = HKWorkoutConfiguration()
        config.activityType = .mindAndBody
        config.locationType = .unknown
        
        //timer
        let runLoop = RunLoop.main
        let loopSeconds = 1
        timerSubscription = runLoop.schedule(
            after: runLoop.now,
            interval: .seconds(loopSeconds),
            tolerance: .microseconds(100)){[self] in
                
                self.timer.tick(seconds: loopSeconds)
                
                if timer.isTimeout{
                    endEpisode()
                }
                
            }
        
        //Audio
        initAudio()
        //
        
        //init session
        
        do {
            
            session = try HKWorkoutSession(
                healthStore : healthStore,
                configuration: config)
            
            builder = session?.associatedWorkoutBuilder()
            
        } catch {
            LOGGER.critical("Error initializing workout session \(error.localizedDescription)")
            return
        }
        
        builder?.dataSource = HKLiveWorkoutDataSource(
            healthStore: healthStore,
            workoutConfiguration: config)
        
        session?.delegate = self
        builder?.delegate = self
        
        session?.startActivity(with: startDate)
        
        builder?.beginCollection(withStart: startDate){ (success, error) in
            //the workout has started
        }

    }
    
    /**
     Resets all the data for the episode to track a new episode
     */
    func resetEpisode(){
        LOGGER.trace("Resetting Episode")
        
        startDate = Date.now
        
        //timerReset()
        timer.reset()
        
        isShowingSummary = false
 //       isShowingEpisodeEndAlert = false
        builder = nil
        session = nil
        

        currHR = 0
        steps = 0
        currDb = 0
        soundChecks = [:]
        hrChecks = [:]
        
    }
    
    /**
     Ends episode tracking
     */
    func endEpisode(){
        
        if episodeElapsedTime < MIN_EPISODE_TIME {
            print("Too short, discarding workout")
            cancelEpisode()
            
        } else {
            print("submitting episode")
            isShowingSummary = true
            
            Task{
                await submitEpisode()
            }
            timerSubscription?.cancel()
            timer.reset()
            audioRecorder.stop()
            
            session?.end()
            self.builder?.discardWorkout()
            running = false
            paused = false
        }
    }
    
    /**
     Ends the current episode and dosn't save it to healthkit
     */
    func cancelEpisode() {
        isCancelled = true
        resetEpisode()
        
        self.builder?.discardWorkout()
        session?.end()
        
        timerSubscription?.cancel()
        audioRecorder.stop()
        running = false
        paused = false
        
    }


    /**
     Checks sound level values and updates the current HR and Sound data
     */
    func updateValues(date: Date){
        if !audioRecorder.isRecording {
            initAudio()
        }
        if audioRecorder.isRecording {

            audioRecorder.updateMeters()
            let current = Double(audioRecorder.averagePower(forChannel: 0) + Float(100))
            
            if current > 0 {
                self.currDb = Int(current)
            }
            
        }
        self.hrChecks[date] = self.currHR
        self.soundChecks[date] = self.currDb
    }
    
    
    func updateForStatistics(_ statistics : HKStatistics?){
        guard let statistics = statistics else { return }
        

        DispatchQueue.main.async {

            switch statistics.quantityType {
                
            //HeartRate
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                
                self.currHR = Int(statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0)
                self.updateValues(date: statistics.endDate)

                
                //Steps
            case HKQuantityType.quantityType(forIdentifier: .stepCount):
                let stepUnit = HKUnit.count()
                self.steps += Int(statistics.sumQuantity()?.doubleValue(for: stepUnit) ?? 0)
                
                
            default:
                return
                
            }
        }
    }
    
    /**
     Inits the audio recorder to allow for Db tracking
     */
    func initAudio(){
        LOGGER.trace("Initializing Audio")
        
        do {

            let recordSettings = [
                AVSampleRateKey : NSNumber(value: Float(44100.0) as Float),
                AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC)),
                AVNumberOfChannelsKey: NSNumber(value: 1 as Int32),
                AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.medium.rawValue) as Int32)
            ]
            
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentDirectory = urls[0] as URL
            let soundURL = documentDirectory.appendingPathComponent("sound.m4a")
            
            
            
            
            try audioSession.setCategory(.playAndRecord) //TODO: Change this to just record? Does that interfere with playing other audio?
            
            audioRecorder = try AVAudioRecorder(url: soundURL, settings: recordSettings)
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            try audioSession.setActive(true)
            audioRecorder.isMeteringEnabled = true
        } catch let error {
            LOGGER.critical("Failed initializing Audio - \(error.localizedDescription)")
        }
    }
    
    
    
    func submitEpisode() async {
        
        //condition check?
        if let moc = moc {
            let bioDataObject = EpisodeBiometricData(context: moc)
            
            bioDataObject.id = UUID()
            bioDataObject.duration = Int32(episodeElapsedTime)
            bioDataObject.startDate = builder?.startDate
            bioDataObject.endDate = builder?.endDate
            bioDataObject.heartRates = hrChecks
            bioDataObject.soundDbs = soundChecks//
            
            bioDataObject.recentHRV = await Int16(loadRecentHRV(startDate: startDate, endDate: startDate))
            bioDataObject.recentWalkingHR = await Int16(loadRecentWalkingHR(startDate: startDate, endDate: startDate))
            bioDataObject.recentRestingHR = await Int16(loadRecentRestingHR(startDate: startDate, endDate: startDate))
            
            
       //     print("Here")
        //    print(hrChecks.sorted(by: {$0.key < $1.key}))
            
            do{
                try moc.save()
            }catch{
                LOGGER.critical("ERROR Saving Episode: \(error.localizedDescription)")
            }
        }
        
    }
}

//MARK: Episode Timer
class EpisodeTimer : ObservableObject {
    
    //Time since timeout began tracking
    @Published var timeoutTimer = 0
    
    // The string representing the timeout alert message
    @Published var timeoutString : String = ""
    
    @Published var isShowingEpisodeEndAlert : Bool = false
    
    @Published var isTimeout : Bool = false
    
    //max minutes the timeout will run until timeout occurs
    private let timeoutTimeInterval = 60 * 3 //3 minutes
    
    //seconds since prompt appeared
    private var episodeAlertTimer = 0
    
    //How often to prompt user for end of episode
    private let episodeAlertTimerInterval = 60 * 10 //10 minutes
    
    func reset(){
        episodeAlertTimer = 0
        timeoutTimer = 0
        timeoutString = ""
        isShowingEpisodeEndAlert = false
    }
    
    func tick(seconds : Int){
        
        episodeAlertTimer += seconds
        
        //Timer has surpassed interval time -> Show alert
        if episodeAlertTimer >= episodeAlertTimerInterval {
            
            isShowingEpisodeEndAlert = true
            
            //increment timeout
            timeoutTimer += seconds
            
            let timeRemaining = timeoutTimeInterval - timeoutTimer
            
            if timeRemaining <= 0 {
                //end episode
                isTimeout = true
            }else if(timeRemaining <= 60){
                
                timeoutString = "Timeout \(timeRemaining)"
                
                //do haptic feedback every 10 seconds
                if timeRemaining % 10 == 0 {
                    WKInterfaceDevice.current().play(.retry)
                }
                
            }else{ //More than 60 seconds left on end episode prompt
                
                //Do haptic feedback every 60 seconds
                if timeRemaining % 60 == 0 {
                    WKInterfaceDevice.current().play(.retry)
                }
                
            }
            
        }
        else {
            isShowingEpisodeEndAlert = false
        }
        
    }
    
}


// MARK: - HKWorkoutSessionDelegate
extension EpisodeManager: HKWorkoutSessionDelegate {
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        //TODO:
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        
        DispatchQueue.main.async {
            print("Running workout ...")
            self.running = toState == .running
            self.paused = toState == .paused
        }
        
        if toState == .paused {
            self.paused = toState == .paused
        }
        
        //wait for the session to transition states before ending the builder
        if toState == .ended {
            builder?.endCollection(withEnd: date){ (success, error) in
                //self.builder?.discardWorkout()
                /*
                if(!self.isCancelled){
                    
                    self.builder?.finishWorkout(){(workout, error) in
                        DispatchQueue.main.async{
                            self.workout = workout
                            print("Ending Workout...")
                        }
                    }
                }
                 */
            }
        }

    }
}

// MARK: - HKLiveWorkoutBuilderDelegate
extension EpisodeManager: HKLiveWorkoutBuilderDelegate {
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        //
    }
    
    
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else { return }
            let stats = workoutBuilder.statistics(for: quantityType)
            updateForStatistics(stats)
        }
    }
}






//// MARK: - HKWorkoutSessionDelegate
//extension EpisodeManager: HKWorkoutSessionDelegate {
//
//    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
//        //TODO:
//    }
//
//    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
//
//        DispatchQueue.main.async {
//            print("Running workout ...")
//            //self.running = toState == .running
//            //self.paused = toState == .paused
//            if toState == .running { self.runState = .running}
//            else if toState == .paused { self.runState = .paused }
//        }
//
//        if toState == .paused {
//            self.runState = .paused
//        }
//
//        //wait for the session to transition states before ending the builder
//        if toState == .ended {
//            builder?.endCollection(withEnd: date){ (success, error) in
//
//                if(self.runState != .cancelled && self.episodeElapsedTime > self.MIN_EPISODE_TIME){
//
//             //       self.submitEpisode()
//
//                    self.builder?.discardWorkout()
//
////                    self.builder?.finishWorkout(){(workout, error) in
////                        DispatchQueue.main.async{
////                            self.workout = workout
////                            print("Ending Workout...")
////                        }
////                    }
//                }
//            }
//        }
//
//    }
//}
//
//// MARK: - HKLiveWorkoutBuilderDelegate
//extension EpisodeManager: HKLiveWorkoutBuilderDelegate {
//
//    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
//        //
//    }
//
//
//
//    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
//        for type in collectedTypes {
//            guard let quantityType = type as? HKQuantityType else { return }
//            let stats = workoutBuilder.statistics(for: quantityType)
//            updateForStatistics(stats)
//        }
//    }
//}
