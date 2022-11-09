//
//  DataController.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/6/22.
//

import Foundation
import CoreData

class DataController : ObservableObject {
    
    let container = NSPersistentContainer(name: "DataStore")
    //Shared instance
    static let shared = DataController()
    
    init() {
        container.loadPersistentStores { description, error in
            
            if let error = error {
                print("Core data failed to load: \(error.localizedDescription)")
            }else{
                
             //   self.clearAllData()
             //   self.createSampleTags()
             //   self.createSampleCheckin()

            }
            
        }
    }

    
    func clearAllData(){
        
        let fetchStressRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "StressDetail")
        let deleteStressRequest = NSBatchDeleteRequest(fetchRequest: fetchStressRequest)
        
        let fetchCheckinRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Checkin")
        let deleteCheckinRequest = NSBatchDeleteRequest(fetchRequest: fetchCheckinRequest)
        
        do {
            //try myPersistentStoreCoordinator.execute(deleteRequest, with: myContext)
            try container.persistentStoreCoordinator.execute(deleteStressRequest, with: container.viewContext)
            try container.persistentStoreCoordinator.execute(deleteCheckinRequest, with: container.viewContext)
        } catch let error as NSError {
            // TODO: handle the error
            print(error)
        }

    }
    
    //MARK: Sample Data
    func createSampleCheckin(){
        
        let date = Date.now
        
        let stressor1 : StressDetail = StressDetail(context: container.viewContext)
        stressor1.id = UUID()
        stressor1.addDate = date
        stressor1.activities = [StressManager.Activites.eating.rawValue, StressManager.Activites.socializing.rawValue]
        stressor1.category = StressManager.StressCategories.relationships.rawValue
        stressor1.individuals = ["Tom", "Sarah"]
        stressor1.rating = 3
        stressor1.subjectTypes = [StressManager.SubjectType.family.rawValue]
        stressor1.symptoms = [StressManager.PhysicalSymptoms.sweating.rawValue, StressManager.PhysicalSymptoms.tension.rawValue]
        stressor1.timesOfDay = [StressManager.TimesOfDay.morning.rawValue]
        
        
        let stressor2 : StressDetail = StressDetail(context: container.viewContext)
        stressor2.id = UUID()
        stressor1.addDate = date
        stressor2.activities = [StressManager.Activites.exercising.rawValue]
        stressor2.category = StressManager.StressCategories.health.rawValue
        stressor2.individuals = ["Dad", "Tim"]
        stressor2.rating = 4
        stressor2.subjectTypes = [StressManager.SubjectType.stranger.rawValue]
        stressor2.symptoms = [StressManager.PhysicalSymptoms.tension.rawValue, StressManager.PhysicalSymptoms.racing_thoughts.rawValue]
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
    
}
