//
//  DataLoader.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/16/22.
//
// This class is used to load all of the user's data to/from core data or health kit in order to be properly used throughout the app

/*
 DEPRECIATED: Data no longer saved to / loaded from health kit, but instead directly to cloudkit
 
 

import Foundation
import OSLog
import CoreData

/**
 Logger Object
 */
fileprivate let LOGGER = Logger(
    subsystem: Bundle.main.bundleIdentifier!,
    category: String(describing: DataLoader.self)
)

final class DataLoader : ObservableObject {
    
    /**
     The managed object context for the data
     */
    private let moc : NSManagedObjectContext
    
    /**
     Flag for if all the data has been loaded from healthkit into core data
     */
    @Published var isLoaded : Bool = false
    
    /**
     Flag for if the data has been cleaned
     */
    @Published var isCleaned : Bool = false
    
    /**
     Flag for if the data has been sent to the server
     */
    @Published var isSentToServer : Bool = false
    
    private let MIN_EPISODE_DURATION : Double = 120 //2 minutes
    
    /**
     Flag for identifying if all proper steps have been taken and the data is ready for the user to use
     */
    var isReady : Bool {
        return isLoaded && isCleaned && isSentToServer
    }
    
    init(moc : NSManagedObjectContext){
        self.moc = moc
    }

    /**
     
     This function grabs episode data (stored in healthkit as a workout), loops through each sample, adds the data to core data, and deletes the sample from healthkit so it doesn't contribute to the user's workout statistitcal data.
     
     */
    func loadData() async {
        LOGGER.trace("Begin loading data from Health Kit")
        
        //Get episode samples from Health Kit Helper
        let episodeSamples = await getEpisodeSamples()
        
        if episodeSamples.isEmpty {
            LOGGER.log("No samples to add")
            self.isLoaded = true
        } else {
            
            while(!episodeSamples.isEmpty){
                
                guard let sample = episodeSamples.first else { return }
                
                let startDate : Date = sample.startDate
                let endDate : Date = sample.endDate
                
                let duration = endDate.timeIntervalSince(startDate)
                
                //remove any episode under 60 seconds
                if duration > MIN_EPISODE_DURATION {
                    //Episode is longer than min time
                    
                    let heartRateData = await loadHeartRateData(startDate: startDate, endDate: endDate)
                    
                    let soundData = await loadAudioExposureData(startDate: startDate, endDate: endDate)
                    
                    let stepData = await loadStepData(startDate: startDate, endDate: endDate)
                    
                    let recentRestingHR = await loadRecentRestingHR(startDate: startDate, endDate: endDate)
                    
                    let recentWalkingHR = await loadRecentWalkingHR(startDate: startDate, endDate: endDate)
                    
                    let recentHRV = await loadRecentHRV(startDate: startDate, endDate: endDate)
                    
                    //TODO: Create a biometric object and save to it
                    let bioData = EpisodeBiometricData(context: moc)
                    bioData.heartRates = heartRateData
                    bioData.soundDbs = soundData
                    bioData.steps = Int16(stepData)
                    bioData.recentWalkingHR = Int16(recentWalkingHR)
                    bioData.recentRestingHR = Int16(recentRestingHR)
                    bioData.recentHRV = Int16(recentHRV)
                    bioData.startDate = startDate
                    bioData.endDate = endDate
                    bioData.duration = Int32(duration)
                    bioData.id = UUID()
                    
                    do{
                        try moc.save()
                    }catch{
                        LOGGER.error("ERROR saving new EpisodeBioData object: \(error.localizedDescription)")
                    }
                }

                
                await deleteFromHK(sample: sample)

            }
            
        }
    }
    
    
    
    /**
     Removes data from Core data with the following conditions:
        - Heart Rate values are empty
        - Duration of episode is less than 60 seconds
     */
    func cleanData(_ episodeData : [StressDetail]) async {
        
//        for data in episodeData {
//            var delete = false
//            var reason = ""
//            
//
//        }
        
        
        self.isCleaned = true
    }
    
    func sendToServer() async {
        
        
        
        
        self.isSentToServer = true
    }
    
}

*/
