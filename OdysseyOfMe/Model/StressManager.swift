//
//  Stress.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/4/22.
//

import Foundation
import SwiftUI
import CoreData

/**
 The class that manages new stress items/objects
 */
class StressManager : ObservableObject {
    
    //MARK: Default Enum Values
    enum Details : String, CaseIterable {
        case times, activities, physicalSymptoms, subjectTypes, individuals
    }
    
    enum TimesOfDay : String, CaseIterable {
        case morning, afternoon, evening, night
    }
    
    enum Activites : String, CaseIterable {
        case eating, sleeping, socializing, driving, hobbies, exercising
    }
    
    enum PhysicalSymptoms : String, CaseIterable {
        case sweating, increased_HR = "Increased HR", trembling, tension, racing_thoughts = "Racing Thoughts"
    }
    
    enum SubjectType : String, CaseIterable {
        case family, friend, stranger, coworker
    }
    
    enum StressCategories : String, CaseIterable {
        case housing, work, financial, relationships, health, other, none
        
        var icon : Image {
            switch self{
                
            case .housing:
                return Image("home")
                
            case .work:
                return Image("work")
            case .financial:
                return Image("financial")
            case .relationships:
                return Image("relationships")
            case .health:
                return Image("meditation")
            case .other:
                return Image("add")
                
            case .none: return Image("")
            }
        }
        
        func getSizedIconView(height: CGFloat) -> AnyView {
            return AnyView(self.icon
                .resizable()
                .frame(width: self == .relationships ? height * 1.8 : height, height: height))
        }
        
        
    }
    
    
    var TimeTags : [String]
    var ActivityTags : [String]
    var PhysicalSymptomTags : [String]
    var SubjectTypeTags : [String]
    var StressCategoryTags : [String]
    var IndividualsTags : [String]
    
    init(){
        TimeTags = []
        ActivityTags = []
        PhysicalSymptomTags = []
        SubjectTypeTags = []
        StressCategoryTags = []
        IndividualsTags = []
    }
    
    func build(stressData : [StressDetail]){

        
        TimesOfDay.allCases.forEach{element in
            TimeTags.append(element.rawValue)
        }
        
        Activites.allCases.forEach{element in
            ActivityTags.append(element.rawValue)
        }
        
        PhysicalSymptoms.allCases.forEach{element in
            PhysicalSymptomTags.append(element.rawValue)
        }
        
        SubjectType.allCases.forEach{element in
            SubjectTypeTags.append(element.rawValue)
        }
        
        StressCategories.allCases.forEach{element in
            StressCategoryTags.append(element.rawValue)
        }
        
        TimeTags.append("+")
        ActivityTags.append("+")
        PhysicalSymptomTags.append("+")
        SubjectTypeTags.append("+")
        IndividualsTags.append("+")
        
        stressData.forEach{data in
            
            if let times = data.timesOfDay{
                times.forEach{time in
                    addTimeTag(time)
                }
            }
            
            if let activities = data.activities{
                activities.forEach{activity in
                    addActivityTag(activity)
                }
            }
            
            if let symptoms = data.symptoms{
                symptoms.forEach{symptom in
                    addSymptomTag(symptom)
                }
            }
            
            if let subjects = data.subjectTypes{
                subjects.forEach{subject in
                    addSubjectTag(subject)
                }
            }
            
            if let individuals = data.individuals{
                individuals.forEach{individual in
                    addIndividualsTag(individual)
                }
            }
            
            if let category = data.category{
                if !StressCategoryTags.contains(category) { StressCategoryTags.append(category) }
            }
        }
        
    }
    
    
    func addTimeTag(_ tag : String){
        if !TimeTags.contains(tag) { TimeTags.insert(tag, at: TimeTags.count-1)}
    }
    func addActivityTag(_ tag : String){
        if !ActivityTags.contains(tag) { ActivityTags.insert(tag, at: ActivityTags.count-1) }
    }
    func addSymptomTag(_ tag : String){
        if !PhysicalSymptomTags.contains(tag) { PhysicalSymptomTags.insert(tag, at: PhysicalSymptomTags.count-1) }
    }
    func addSubjectTag(_ tag : String){
        if !SubjectTypeTags.contains(tag) { SubjectTypeTags.insert(tag, at: SubjectTypeTags.count-1) }
    }
    func addIndividualsTag(_ tag : String){
        if !IndividualsTags.contains(tag) { IndividualsTags.insert(tag, at: IndividualsTags.count-1) }
    }
    
    
    
    class StressObject : ObservableObject, Hashable {
        
        static func == (lhs: StressManager.StressObject, rhs: StressManager.StressObject) -> Bool {
            return lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        let id = UUID()
        var times : [String] = []
        var activities : [String] = []
        var symptoms : [String] = []
        var subjectTypes : [String] = []
        var individuals : [String] = []
        var description : String = ""
        var category : StressCategories
        var rating : Int = 0
        
        init(category : StressCategories){
            self.category = category
        }
        
        func dataIsValid() -> Bool {
            return true
        }
        
        func getAllTagStringArr() -> [String]{
            var retArr : [String] = []
            
            times.forEach{tag in
                if !retArr.contains(tag){
                    retArr.append(tag)
                }
            }
            
            activities.forEach{tag in
                if !retArr.contains(tag){
                    retArr.append(tag)
                }
            }
            
            symptoms.forEach{tag in
                if !retArr.contains(tag){
                    retArr.append(tag)
                }
            }
            
            subjectTypes.forEach{tag in
                if !retArr.contains(tag){
                    retArr.append(tag)
                }
            }
            
            individuals.forEach{tag in
                if !retArr.contains(tag){
                    retArr.append(tag)
                }
            }
            
            
            return retArr
        }
        
        /**
         Adds or removes a time of day from the array
         */
        func toggleTimes(_ time : String){
            if self.times.contains(where: {$0.uppercased() == time.uppercased()}){
                self.times.removeAll(where: {$0.uppercased() == time.uppercased()})
            }else{
                self.times.append(time)
            }
        }
        
        /**
         Adds or removes an activity from the array
         */
        func toggleActivities(_ activity : String){
            if self.activities.contains(where: {$0.uppercased() == activity.uppercased()}){
                self.activities.removeAll(where: {$0.uppercased() == activity.uppercased()})
            }else{
                self.activities.append(activity)
            }
        }
        
        /**
         Adds or removes a symptom from the array
         */
        func toggleSymptoms(_ symptom : String){
            if self.symptoms.contains(where: {$0.uppercased() == symptom.uppercased()}){
                self.symptoms.removeAll(where: {$0.uppercased() == symptom.uppercased()})
            }else{
                self.symptoms.append(symptom)
            }
        }
        
        /**
         Adds or removes a subject type from the array
         */
        func toggleSubjectTypes(_ subject : String){
            if self.subjectTypes.contains(where: {$0.uppercased() == subject.uppercased()}){
                self.subjectTypes.removeAll(where: {$0.uppercased() == subject.uppercased()})
            }else{
                self.subjectTypes.append(subject)
            }
        }
        
        /**
         Ads or removes an individual from the array
         */
        func toggleIndividuals(_ individual : String){
            if self.individuals.contains(where: {$0.uppercased() == individual.uppercased()}){
                self.individuals.removeAll(where: {$0.uppercased() == individual.uppercased()})
            }else{
                self.individuals.append(individual)
            }
        }
        
        func addToCoreData(moc : NSManagedObjectContext) {
            
            if dataIsValid() {
                
                //let moc = DataController.shared.container.viewContext
                
                let stressDetail = StressDetail(context: moc)
                
                stressDetail.addDate = Date.now
                stressDetail.id = UUID()
                stressDetail.activities = activities
                stressDetail.category = category.rawValue
                stressDetail.individuals = individuals
                stressDetail.rating = Int16(rating)
                stressDetail.subjectTypes = subjectTypes
                stressDetail.symptoms = symptoms
                stressDetail.timesOfDay = times
                stressDetail.stressDescription = description
                
                
                do {
                    try moc.save()
                }catch let error {
                    print("-----")
                    print("Error saving stress detail!")
                    print(error)
                    print("-----")
                }
                
            }
            
        }
    }
    
    
}

