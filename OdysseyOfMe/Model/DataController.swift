//
//  DataController.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/6/22.
//

import Foundation
import CoreData
import CloudKit
import OSLog
import SwiftUI


/**
 Logger Object
 */
fileprivate let LOGGER = Logger(
    subsystem: Bundle.main.bundleIdentifier!,
    category: String(describing: DataController.self)
)


class DataController : ObservableObject {
    
    let container: NSPersistentContainer
    //Shared instance
    static let shared = DataController()
    
    
    init() {
        container = NSPersistentCloudKitContainer(name: "DataStore")
        
        container.loadPersistentStores { description, error in
            
            if let error = error {
                print("Core data failed to load: \(error.localizedDescription)")
            }else{
#if targetEnvironment(simulator)
                //   self.createSampleData()
                //  self.clearAllData()
#endif
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        
    }
    
    //MARK: Save Requests
    func save(_ checkin : Checkin){
        if checkin.date == nil {
            checkin.date = Date()
        } else if checkin.id == nil {
            checkin.id = UUID()
        }
        saveContext()
    }
    
    func save(_ bio : EpisodeBiometricData){
        var canSave : Bool = true
        var reason : String = ""
        
        if bio.duration < CONSTANTS.MIN_EPISODE_DURATION_SECONDS {
            canSave = false
            reason = "Duration of episode below minimum: \(CONSTANTS.MIN_EPISODE_DURATION_SECONDS)seconds"
        }
        
        if bio.heartRates == nil {
            canSave = false
            reason = "Heart rates didn't record. Was the watch on the user? Did they enable health kit?"
        }
        //TODO: Check further things? Pull more healthkit data here?
        if bio.id == nil {
            bio.id = UUID()
        }
        
        if(canSave){
            saveContext()
        }else {
            LOGGER.critical("Tried to load but failed for reason: \(reason)")
        }
    }
    
    func save(_ stressDetail : StressDetail){
        
        if stressDetail.checkin != nil { //Stress detail must have a checkin?
            
            if stressDetail.rating > 5 { stressDetail.rating = 5 }
            if stressDetail.rating < 0 { stressDetail.rating = 0 }
            if stressDetail.id == nil { stressDetail.id = UUID() }
            if stressDetail.category == nil { stressDetail.category = StressManager.StressCategories.other.name }
            
            saveContext()
        }
    }
    
    func saveContext() {
        do{
            try container.viewContext.save()
        } catch {
            LOGGER.critical("Error saving context: \(error.localizedDescription)")
        }
    }
    
    
    
    //MARK: Fetch Requests
    func getCheckinData() -> [Checkin]  {
        
        let fetchRequest: NSFetchRequest<Checkin> = NSFetchRequest(entityName: "Checkin")
        var retArray : [Checkin] = []
        do {
            let fetch = try container.viewContext.fetch(fetchRequest)
            retArray = Array(fetch)
        } catch {
            print(error.localizedDescription)
        }
        return retArray
    }
    
     
     func getStressDetailData() -> [StressDetail]  {
         
         let fetchRequest: NSFetchRequest<StressDetail> = NSFetchRequest(entityName: "StressDetail")
       //  let sort = NSSortDescriptor(key: "date", ascending: false)
        // fetchRequest.sortDescriptors = [sort]
         var retArray : [StressDetail] = []
         do {
             let fetch = try container.viewContext.fetch(fetchRequest)
             retArray = Array(fetch)
         } catch {
             print(error.localizedDescription)
         }
         return retArray
     }
     
    func getEpisodeData() -> [Episode]  {
        let fetchRequest: NSFetchRequest<Episode> = NSFetchRequest(entityName: "Episode")
        var retArray : [Episode] = []
        do {
            let fetch = try container.viewContext.fetch(fetchRequest)
            retArray = Array(fetch)
        } catch {
            print(error.localizedDescription)
        }
        return retArray
    }
    
    func getEpisodeBioData() -> [EpisodeBiometricData]  {
        let fetchRequest: NSFetchRequest<EpisodeBiometricData> = NSFetchRequest(entityName: "EpisodeBiometricData")
        var retArray : [EpisodeBiometricData] = []
        do {
            let fetch = try container.viewContext.fetch(fetchRequest)
            retArray = Array(fetch)
        } catch {
            print(error.localizedDescription)
        }
        return retArray
    }

    //TODO: Break into sub funcs
    func clearAllData(){
        
        let fetchStressRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "StressDetail")
        let deleteStressRequest = NSBatchDeleteRequest(fetchRequest: fetchStressRequest)
        
        let fetchCheckinRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Checkin")
        let deleteCheckinRequest = NSBatchDeleteRequest(fetchRequest: fetchCheckinRequest)
        
        
        let fetchBioRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "EpisodeBiometricData")
        let deleteBioRequest = NSBatchDeleteRequest(fetchRequest: fetchBioRequest)
        
        let fetchEpisodeRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Episode")
        let deleteEpisodeRequest = NSBatchDeleteRequest(fetchRequest: fetchEpisodeRequest)
        
        do {
            //try myPersistentStoreCoordinator.execute(deleteRequest, with: myContext)
            try container.persistentStoreCoordinator.execute(deleteStressRequest, with: container.viewContext)
            try container.persistentStoreCoordinator.execute(deleteCheckinRequest, with: container.viewContext)
            try container.persistentStoreCoordinator.execute(deleteBioRequest, with: container.viewContext)
            try container.persistentStoreCoordinator.execute(deleteEpisodeRequest, with: container.viewContext)
            
        } catch let error as NSError {
            // TODO: handle the error
            print(error)
        }

    }
    
    //MARK: Sample Data
    func createSampleData(){
        clearAllData()
        

        let stressor : StressDetail = StressDetail(context: container.viewContext)
        
        stressor.id = UUID()
        stressor.addDate = Date.now
        stressor.activities = [StressManager.Activites.eating.rawValue, StressManager.Activites.socializing.rawValue]
        stressor.category = StressManager.StressCategories.relationships.rawValue
        stressor.individuals = ["Tom", "Sarah"]
        stressor.rating = 3
        stressor.subjectTypes = [StressManager.SubjectType.family.rawValue]
        stressor.symptoms = [StressManager.PhysicalSymptoms.sweating.rawValue, StressManager.PhysicalSymptoms.tension.rawValue]
        stressor.timesOfDay = [StressManager.TimesOfDay.morning.rawValue]
        
        let checkin : Checkin = Checkin(context: container.viewContext)
        checkin.date = Date.now
        checkin.id = UUID()
        checkin.dayRating = 3
        
        stressor.checkin = checkin
        checkin.stressorDetails = NSSet(array: [stressor])
        
        let bio : EpisodeBiometricData = EpisodeBiometricData(context: container.viewContext)
        bio.id = UUID()
        bio.startDate = Date.now
        bio.duration = 3500
        bio.endDate = Calendar.current.date(byAdding: .second, value: Int(bio.duration), to: bio.startDate!)
        bio.recentHRV = 44
        bio.recentWalkingHR = 112
        bio.recentRestingHR = 52
        
        var hrs : [Date:Int] = [:]
        var dbs : [Date:Int] = [:]
        var interval = 0
        let increase = 5
        var hrBalance = 80
        var dbBalance = 60
        
        while(interval < bio.duration){
            interval = interval + increase
            let date = Calendar.current.date(byAdding: .second, value: interval, to: bio.startDate!)!
            
            var hr = Int.random(in: (hrBalance - 10)...(hrBalance + 10))
            hr = max(hr, 60)
            hr = min(hr, 200)
            if hr == 200 {
                hr -= Int.random(in: 0..<10)
            }
            while(hr <= 60) {
                hr += Int.random(in: 0...5)
            }
            hrBalance = hr
            
            var db = Int.random(in: (dbBalance - 5)...(dbBalance + 5))
            db = max(db, 40)
            db = min(db, 120)
            
            if db == 120 {
                db -= Int.random(in: 0..<5)
            }
            
            dbBalance = db
            
            hrs[date] = hr
            dbs[date] = db
            
        }
        
        bio.heartRates = hrs
        bio.soundDbs = dbs
        
        saveContext()
        
    }
}







// Depreciated

/*
func createSampleCheckin(){
    
    let date = Calendar.current.date(byAdding: .day, value: -3, to: Date.now)
    
    let stressor1 : StressDetail = StressDetail(context: container.viewContext)
    stressor1.id = UUID()
    stressor1.addDate = date
    stressor1.activities = [StressManager.Activites.eating.rawValue, StressManager.Activites.socializing.rawValue]
    stressor1.category = StressManager.StressCategories.relationships.rawValue
    stressor1.individuals = ["Tom", "Sarah"]
    stressor1.rating = 3
    stressor1.subjectTypes = [StressManager.SubjectType.family.tag]
    stressor1.symptoms = [StressManager.PhysicalSymptoms.sweating.tag, StressManager.PhysicalSymptoms.tension.tag]
    stressor1.timesOfDay = [StressManager.TimesOfDay.morning.tag]
    
    
    let stressor2 : StressDetail = StressDetail(context: container.viewContext)
    stressor2.id = UUID()
    stressor1.addDate = date
    stressor2.activities = [StressManager.Activites.exercising.tag]
    stressor2.category = StressManager.StressCategories.health.rawValue
    stressor2.individuals = ["Dad", "Tim"]
    stressor2.rating = 4
    stressor2.subjectTypes = [StressManager.SubjectType.stranger.tag]
    stressor2.symptoms = [StressManager.PhysicalSymptoms.tension.tag, StressManager.PhysicalSymptoms.racing_thoughts.rawValue]
    stressor2.timesOfDay = ["Lunch"]
    
    
    

    let checkin : Checkin = Checkin(context: container.viewContext)
    checkin.id = UUID()
    checkin.date = date
    checkin.dayDescription = "Blah blah probably won't use"
    checkin.dayRating = 3

    checkin.stressorDetails = NSSet(array: [stressor1, stressor2])
    
    do {
       try container.viewContext.save()
    } catch let err {
        print(err)
    }
    
}


func createSampleTags(){
    let stressor : StressDetail = StressDetail(context: container.viewContext)
    

    
    stressor.id = UUID()
    stressor.addDate = Date.now
    stressor.activities = [StressManager.Activites.eating.rawValue, StressManager.Activites.socializing.rawValue]
    stressor.category = StressManager.StressCategories.relationships.rawValue
    stressor.individuals = ["Tom", "Sarah"]
    stressor.rating = 3
    stressor.subjectTypes = [StressManager.SubjectType.family.rawValue]
    stressor.symptoms = [StressManager.PhysicalSymptoms.sweating.rawValue, StressManager.PhysicalSymptoms.tension.rawValue]
    stressor.timesOfDay = [StressManager.TimesOfDay.morning.rawValue, "Lunch"]
    
    do {
       try container.viewContext.save()
    } catch let err {
        print(err)
    }
}

func buildEmptyStressData(){
    let object : StressManager.StressObject = StressManager.StressObject(category: .other)
    object.addToCoreData(moc: container.viewContext)
}

func buildSampleData(){
    
    let stressor : StressDetail = StressDetail(context: container.viewContext)
    
    stressor.id = UUID()
    stressor.addDate = Date.now
    stressor.activities = [StressManager.Activites.eating.rawValue, StressManager.Activites.socializing.rawValue]
    stressor.category = StressManager.StressCategories.relationships.rawValue
    stressor.individuals = ["Tom", "Sarah"]
    stressor.rating = 3
    stressor.subjectTypes = [StressManager.SubjectType.family.rawValue]
    stressor.symptoms = [StressManager.PhysicalSymptoms.sweating.rawValue, StressManager.PhysicalSymptoms.tension.rawValue]
    stressor.timesOfDay = [StressManager.TimesOfDay.morning.rawValue]
    
    do {
       try container.viewContext.save()
    } catch let err {
        print(err)
    }
    
    
}

func buidSampleDataFromStressObject() {
    
    let object : StressManager.StressObject = StressManager.StressObject(category: .housing)
    object.times = [StressManager.TimesOfDay.evening.rawValue]
    object.activities = [StressManager.Activites.socializing.rawValue]
    object.symptoms = [StressManager.PhysicalSymptoms.increased_HR.rawValue, StressManager.PhysicalSymptoms.racing_thoughts.rawValue]
    object.subjectTypes = [StressManager.SubjectType.friend.rawValue]
    object.individuals = ["Tom", "Sarah"]
    object.rating = 3
    
    object.addToCoreData(moc: container.viewContext)
    
}
*/
