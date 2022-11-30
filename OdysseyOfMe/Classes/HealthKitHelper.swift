//
//  HealthKitHelper.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/16/22.
//

import Foundation
import OSLog
import HealthKit
import Combine

fileprivate let LOGGER = Logger(
    subsystem: Bundle.main.bundleIdentifier!,
    category: String("HEALTH KIT HELPER")
)

/**
 The metadata key for identifying odyssey mental health episodes
 */
public let METADATAKEY = "IS_ODYSSEY_MENTALHEALTH_EPISODE"

/**
 The HKQuantity types to share to apple healthkit
 */
fileprivate let typesToShare : Set = [
    HKQuantityType.workoutType(),
    HKQuantityType.quantityType(forIdentifier: .environmentalAudioExposure)!,
   // HKQuantityType.characteristicType(forIdentifier: .dateOfBirth), //
   // HKQuantityType.categoryType(forIdentifier: .fainting) //symptom?
]

/**
 The HKQuantity types to read from apple health kit
 */
fileprivate let typesToRead : Set = [
    HKQuantityType.activitySummaryType(),
    HKQuantityType.quantityType(forIdentifier: .heartRate)!,
    HKQuantityType.quantityType(forIdentifier: .restingHeartRate)!,
    HKQuantityType.quantityType(forIdentifier: .walkingHeartRateAverage)!,
    HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
    HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
    HKQuantityType.quantityType(forIdentifier: .stepCount)!,
    HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
    HKQuantityType.quantityType(forIdentifier: .environmentalAudioExposure)!
]

/**
 Sort descriptors for sorting sample queries
 */
fileprivate let sortDescriptors = [
    NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
]

//TODO: predicate from THIS APP source ( or, apple watch )
fileprivate let predicate_MetaData = HKQuery.predicateForObjects(withMetadataKey: METADATAKEY)//HKQuery.predicateForObjects(fromDevices: .)

fileprivate let watch_bundle_ID = "com.Accolades.OdysseyOfMe.watchkitapp"

//fileprivate let predicate_Source = HKQuery.predicateForObjects(from: .init(watch_bundle_ID))

/**
 The apple health store
 */
let healthStore = HKHealthStore()

/**
 Default timeout time for queries
 */
fileprivate let timeoutSeconds : Double = 5

func authorizeHK() {
    
    if HKHealthStore.isHealthDataAvailable() {
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) {(success, error) in
            
            //handle
            if success {
                LOGGER.log("Health Kit Authorized")
                //
            } else if let error{
                LOGGER.critical("Health Kit Not Authorized")
                LOGGER.critical("Error: \(error)")
            }
        }
    } else {
        LOGGER.critical("Health Store Not Available")
    }
    
}

/**
 Returns all workout samples that are related to the app ( Tracked as mental health episodes )
 */
func getEpisodeSamples() async -> [HKWorkout]{
    
    guard HKHealthStore.isHealthDataAvailable() else { return [] }
    

    // get data samples...
    
    let samples = try? await withCheckedThrowingContinuation { (continuation : CheckedContinuation<[HKSample], Error>) in
        
        //query
        let query = HKSampleQuery(sampleType: .workoutType(), predicate: predicate_MetaData, limit: HKObjectQueryNoLimit, sortDescriptors : sortDescriptors, resultsHandler: { query, samples, error in
            
            if let error {
                LOGGER.critical("ERROR GATHERING SAMPLES: \(error)")
                continuation.resume(throwing: error)
                return
            }
            
            guard let samples else {
                LOGGER.critical("ERROR Gathering Samples!")
               // fatalError("*** Invalid State: This can only fail if there was an error. ***")
                return
            }
            
            continuation.resume(returning: samples)
        })
        
        //Execute Query
        healthStore.execute(query)
    }
    
    guard let episodes = samples as? [HKWorkout] else {
        LOGGER.log("No Workout Samples to add")
        return []
    }
    
    //TODO: Timeout?
    
    return episodes
}


/**
 Returns heart rate data from healthkit for a given time interval (during an episode)
 */
func loadHeartRateData( startDate : Date, endDate : Date ) async -> [Date:Int] {
    
    LOGGER.trace("Getting heart rate data from episodes")
    
    
    let predicate : NSPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
    let unit : HKUnit = HKUnit(from: "count/min")
    let sampleType : HKQuantityType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
    
    var isLoaded : Bool = false
    var isTimeout : Bool = false
    var returnData : [Date:Int] = [:]
    
    let query = HKSampleQuery(
        sampleType : sampleType,
        predicate: predicate,
        limit: HKObjectQueryNoLimit,
        sortDescriptors: sortDescriptors,
        resultsHandler: { (query, results, error) in
            
            guard error == nil else {
                LOGGER.error("Error loading HR data from HealthKit \(error)")
                isLoaded = true
                return
            }
            
            for(_, sample) in results!.enumerated() {
                
                guard let currentData : HKQuantitySample = sample as? HKQuantitySample else {return}
                
                returnData[currentData.startDate] = Int(currentData.quantity.doubleValue(for: unit).rounded())
                
            }
            
            isLoaded = true
            
        })
    
    healthStore.execute(query)
    
    //TODO: Better timeout method?
    let timer = TimeoutTimer(timeout: timeoutSeconds)
    timer.run()
    
    while(!isLoaded && !isTimeout){
        isTimeout = timer.check()
    }
    
    return returnData
    
}

/**
 Loads the environmental audio points taken during the episode
 */
func loadAudioExposureData (startDate : Date, endDate : Date) async -> [Date:Int] {
    
    LOGGER.trace("Getting Audio Exposure Data from episode")
    
    let predicate : NSPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
    
    var isLoaded : Bool = false
    var isTimeout : Bool = false
    
    var returnData : [Date:Int] = [:]
    let unit : HKUnit = .decibelAWeightedSoundPressureLevel()
    let sampleType : HKQuantityType = HKQuantityType.quantityType(forIdentifier: .environmentalAudioExposure)!
    
    let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: 0, sortDescriptors: sortDescriptors, resultsHandler:{ (query, results, error) in

        
        guard error == nil else {
            LOGGER.error("Error loading Audio Data from HealthKit \(error.debugDescription)")
            isLoaded = true
            return
        }
        
        for(_, sample) in results!.enumerated(){
            
            guard let currData : HKQuantitySample = sample as? HKQuantitySample else {return}
            
            returnData[currData.startDate] = Int(currData.quantity.doubleValue(for: unit).rounded())
        }
        
        isLoaded = true
    })
    
    healthStore.execute(query)
    
    let timer = TimeoutTimer(timeout: timeoutSeconds)
    timer.run()
    
    while(!isLoaded && !isTimeout){
        isTimeout = timer.check()
    }
    
    return returnData
}


//TODO: Test this function ... it may have not been working on previous iteration
/**
 Loads the amount of steps taken during the time of the episode
 */
func loadStepData(startDate: Date, endDate: Date) async -> Int {
    
    LOGGER.trace("Getting Step Data from episode")

    let predicate : NSPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
    
    var isLoaded : Bool = false
    var isTimeout : Bool = false
    var returnData : Int = 0

    let unit : HKUnit = HKUnit.count()
    let sampleType : HKQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    
    let query = HKStatisticsQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: .cumulativeSum){ query,results,error in
        
        guard error == nil else {
            LOGGER.error("Error loading Step Data from HealthKit \(error!.localizedDescription)")
            isLoaded = true
            return
        }
        
        if results != nil {
            let quantity = results?.sumQuantity()
            let totalSteps = quantity?.doubleValue(for: unit)
            returnData = Int(totalSteps?.rounded() ?? 0)
        }else{
            LOGGER.log("Step data results are nil")
        }
        isLoaded = true
    }
    
    healthStore.execute(query)
    
    let timer = TimeoutTimer(timeout: timeoutSeconds)
    timer.run()
    
    while(!isLoaded && !isTimeout){
        isTimeout = timer.check()
    }
    
    return returnData
}



/**
 Loads and returns the most recent Resting HR recording for a given date window (within 24 hours of given start date)
 */
func loadRecentRestingHR(startDate: Date, endDate: Date) async -> Int {
    LOGGER.trace("Getting Resting HR Data")

    var isLoaded : Bool = false
    var isTimeout : Bool = false
    
    var returnVal : Int = 0
    
    let start = Calendar.current.date(byAdding: .day, value: -1, to: startDate)
    
    let predicate : NSPredicate = HKQuery.predicateForSamples(withStart: start, end: endDate)
    let sampleType : HKQuantityType = HKQuantityType.quantityType(forIdentifier: .restingHeartRate)!
    let unit : HKUnit = HKUnit(from: "count/min")
    
    let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: 10, sortDescriptors: []){ sampleQuery, results, error in
        
        guard error == nil else {
            LOGGER.error("Error loading Resting HR Data from HealthKit \(error.debugDescription)")
            isLoaded = true
            return
        }
        
        guard let currData : HKQuantitySample = results?.last as? HKQuantitySample else {return}
        
        returnVal = Int(currData.quantity.doubleValue(for: unit).rounded())

        isLoaded = true
        
    }
    
    healthStore.execute(sampleQuery)

    let timer = TimeoutTimer(timeout: timeoutSeconds)
    timer.run()
    
    while(!isLoaded && !isTimeout){
        isTimeout = timer.check()
    }
    
    
    return returnVal
}

/**
 Loads and returns the most recent Resting HR recording for a given date window (within 24 hours of given start date)
 */
func loadRecentWalkingHR(startDate: Date, endDate: Date) async -> Int {
    
    LOGGER.trace("Getting Walking HR Data")

    var isLoaded : Bool = false
    var isTimeout = false
    
    var returnVal : Int = 0
    
    let start = Calendar.current.date(byAdding: .day, value: -1, to: startDate)
    
    let predicate : NSPredicate = HKQuery.predicateForSamples(withStart: start, end: endDate)
    let sampleType : HKQuantityType = HKQuantityType.quantityType(forIdentifier: .walkingHeartRateAverage)!
    let unit : HKUnit = HKUnit(from: "count/min")
    
    let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: 10, sortDescriptors: []){ sampleQuery, results, error in
        
        guard error == nil else {
            LOGGER.error("Error loading Resting HR Data from HealthKit \(error.debugDescription)")
            isLoaded = true
            return
        }
        
        guard let currData : HKQuantitySample = results?.last as? HKQuantitySample else {return}
        
        returnVal = Int(currData.quantity.doubleValue(for: unit).rounded())

        isLoaded = true
        
    }
    
    healthStore.execute(sampleQuery)
    
    let timer = TimeoutTimer(timeout: timeoutSeconds)
    timer.run()
    
    while(!isLoaded && !isTimeout){
        isTimeout = timer.check()
    }
    
    return returnVal
}

/**
 Loads and returns the most recent HRV recording for a given date window (within 24 hours of given start date)
 */
func loadRecentHRV(startDate: Date, endDate: Date) async -> Int {
    
    LOGGER.trace("Getting HRV Data")

    var isLoaded : Bool = false
    var isTimeout = false
    
    var returnVal : Int = 0
    
    let start = Calendar.current.date(byAdding: .day, value: -1, to: startDate)
    
    let predicate : NSPredicate = HKQuery.predicateForSamples(withStart: start, end: endDate)
    let sampleType : HKQuantityType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
    let unit : HKUnit = .secondUnit(with: .milli)
    
    let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: 10, sortDescriptors: []){ sampleQuery, results, error in
        
        guard error == nil else {
            LOGGER.error("Error loading Resting HR Data from HealthKit \(error.debugDescription)")
            isLoaded = true
            return
        }
        
        guard let currData : HKQuantitySample = results?.last as? HKQuantitySample else {return}
        
        
        
        returnVal = Int(currData.quantity.doubleValue(for: unit).rounded())

        isLoaded = true
        
    }
    
    healthStore.execute(sampleQuery)
    
    let timer = TimeoutTimer(timeout: timeoutSeconds)
    timer.run()
    
    while(!isLoaded && !isTimeout){
        isTimeout = timer.check()
    }
    

    return returnVal
}

/**
 Deletes a healthkit sample from healthkit
 */
func deleteFromHK(sample : HKWorkout) async {
    do{
        try await healthStore.delete(sample)
    } catch {
        LOGGER.critical("ERROR deleting workout - \(error.localizedDescription)")
    }
}
