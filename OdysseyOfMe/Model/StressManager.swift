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
        
        var tag : String {
            return self.rawValue.lowercased()
        }
        
        var name : String {
            return self.rawValue.capitalized
        }
    }
    
    enum TimesOfDay : String, CaseIterable {
        case morning, afternoon, evening, night
        
        var tag : String {
            return self.rawValue.lowercased()
        }
        
        var name : String {
            return self.rawValue.capitalized
        }
    }
    
    enum Activites : String, CaseIterable {
        case eating, sleeping, socializing, driving, hobbies, exercising
        
        var tag : String {
            return self.rawValue.lowercased()
        }
        
        var name : String {
            return self.rawValue.capitalized
        }
    }
    
    enum PhysicalSymptoms : String, CaseIterable {
        case sweating, increased_HR = "Increased HR", trembling, tension, racing_thoughts = "Racing Thoughts"
        
        var tag : String {
            return self.rawValue.lowercased()
        }
        
        var name : String {
            return self.rawValue.capitalized
        }
    }
    
    enum SubjectType : String, CaseIterable {
        case family, friend, stranger, coworker
        
        var tag : String {
            return self.rawValue.lowercased()
        }
        
        var name : String {
            return self.rawValue.capitalized
        }
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
        
        var name : String {
            return self.rawValue.capitalized
        }
        
        func getSizedIconView(height: CGFloat) -> AnyView {
            return AnyView(self.icon
                .resizable()
                .frame(width: self == .relationships ? height * 1.8 : height, height: height))
        }
        
        func getCategoryFromString(_ categoryString : String) -> StressCategories {
            return Self.allCases.first(where: {$0.rawValue.lowercased() == categoryString.lowercased()}) ?? .other
        }
        
    }
    
    
    var TimeTags : [String]
    var ActivityTags : [String]
    var PhysicalSymptomTags : [String]
    var SubjectTypeTags : [String]
    var StressCategoryTags : [String]
    var IndividualsTags : [String]
    
    init(withTags : Bool = false){
        TimeTags = []
        ActivityTags = []
        PhysicalSymptomTags = []
        SubjectTypeTags = []
        StressCategoryTags = []
        IndividualsTags = []
        
        if withTags {
            TimesOfDay.allCases.forEach{element in
                TimeTags.append(element.tag)
            }
            
            Activites.allCases.forEach{element in
                ActivityTags.append(element.tag)
            }
            
            PhysicalSymptoms.allCases.forEach{element in
                PhysicalSymptomTags.append(element.tag)
            }
            
            SubjectType.allCases.forEach{element in
                SubjectTypeTags.append(element.tag)
            }
            
            StressCategories.allCases.forEach{element in
                StressCategoryTags.append(element.rawValue)
            }
        }
    }
    
    func build(stressData : [StressDetail]) {

        TimeTags = []
        ActivityTags = []
        PhysicalSymptomTags = []
        SubjectTypeTags = []
        StressCategoryTags = []
        IndividualsTags = []
        
        TimesOfDay.allCases.forEach{element in
            TimeTags.append(element.tag)
        }
        
        Activites.allCases.forEach{element in
            ActivityTags.append(element.tag)
        }
        
        PhysicalSymptoms.allCases.forEach{element in
            PhysicalSymptomTags.append(element.tag)
        }
        
        SubjectType.allCases.forEach{element in
            SubjectTypeTags.append(element.tag)
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
                    _ = addTimeTag(time)
                }
            }
            
            if let activities = data.activities{
                activities.forEach{activity in
                  _ = addActivityTag(activity)
                }
            }
            
            if let symptoms = data.symptoms{
                symptoms.forEach{symptom in
                    _ = addSymptomTag(symptom)
                }
            }
            
            if let subjects = data.subjectTypes{
                subjects.forEach{subject in
                    _ = addSubjectTag(subject)
                }
            }
            
            if let individuals = data.individuals{
                individuals.forEach{individual in
                    _ = addIndividualsTag(individual)
                }
            }
            
            if let category = data.category{
                if !StressCategoryTags.contains(category) { StressCategoryTags.append(category) }
            }
        }
    }
    
    
    
    func addTimeTag(_ tag : String) -> Bool{
        if !TimeTags.contains(tag.lowercased()) {
            TimeTags.insert(tag.lowercased(), at: TimeTags.count-1)
            return true
        }
        return false
        
    }
    
    func addActivityTag(_ tag : String) -> Bool {
        if !ActivityTags.contains(tag.lowercased()) {
            ActivityTags.insert(tag.lowercased(), at: ActivityTags.count-1)
            return true
        }
        return false
    }
    func addSymptomTag(_ tag : String) -> Bool{
        if !PhysicalSymptomTags.contains(tag.lowercased()) {
            PhysicalSymptomTags.insert(tag.lowercased(), at: PhysicalSymptomTags.count-1)
            return true
        }
        return false
    }
    func addSubjectTag(_ tag : String) -> Bool{
        if !SubjectTypeTags.contains(tag.lowercased()) {
            SubjectTypeTags.insert(tag.lowercased(), at: SubjectTypeTags.count-1)
            return true
        }
        return false
    }
    func addIndividualsTag(_ tag : String) -> Bool{
        if !IndividualsTags.contains(tag.lowercased()) {
            IndividualsTags.insert(tag.lowercased(), at: IndividualsTags.count-1)
            return true
        }
        return false
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
    
    
    //MARK: Sample Data
    static func getSampleNames() -> [String]{ return ["Sam", "Steeve", "Jim", "Susan", "Sarah", "Mike", "Tim", "Kathy"] }
    
    static func BuildCheckinObjects(_ num : Int) -> (stressors : [StressObject], checks : [CheckinObject]){
        
        var retStressItems : [StressObject] = []
        var retChecks : [CheckinObject] = []
        

        
        for i in 0..<num{
            
            var stressItems : [StressObject] = []
            let date = Calendar.current.date(byAdding: .day, value: -i, to: Date())!

            let isTwoStressors = Bool.random()
            
            var tagArray : [String] = []
            var tagNum : Int = 0
            
            repeat {
                //first stressor in checkin
                let stressor : StressObject = StressObject(category: .other)
                stressor.category = StressCategories.allCases.randomElement() ?? stressor.category
                stressor.rating = Int.random(in: 1..<6)
                
                
                //Times:
                tagArray.removeAll()
                tagNum = Int.random(in: 1..<3)
                for _ in 0..<tagNum{
                    tagArray.append(StressManager.TimesOfDay.allCases.randomElement()!.tag)
                }
                stressor.times = tagArray
                
                //activities:
                tagArray.removeAll()
                tagNum = Int.random(in: 0..<3)
                for _ in 0..<tagNum{
                    tagArray.append(StressManager.Activites.allCases.randomElement()!.tag)
                }
                stressor.activities = tagArray
                
                //symptoms:
                tagArray.removeAll()
                tagNum = Int.random(in: 0..<3)
                for _ in 0..<tagNum{
                    tagArray.append(StressManager.PhysicalSymptoms.allCases.randomElement()!.tag)
                }
                stressor.symptoms = tagArray
                
                //subjects:
                tagArray.removeAll()
                tagNum = Int.random(in: 0..<3)
                for _ in 0..<tagNum{
                    tagArray.append(StressManager.SubjectType.allCases.randomElement()!.tag)
                }
                stressor.subjectTypes = tagArray
                
                //individuals:
                tagArray.removeAll()
                tagNum = Int.random(in: 0..<3)
                for _ in 0..<tagNum{
                    tagArray.append(getSampleNames().randomElement() ?? "Jax")
                }
                stressor.individuals = tagArray
                
                stressItems.append(stressor)
                
            }while(isTwoStressors && stressItems.count < 2)
            
            let dayRating = Int.random(in: 1..<6)
            let check = CheckinObject(date: date, rating: .allCases.first(where: {$0.rawValue == dayRating}) ?? .neutral, details: stressItems)
            
            retStressItems.append(contentsOf: stressItems)
            retChecks.append(check)
        }
        
        return (retStressItems, retChecks)

    }
    
}

extension StressDetail {
    
    func getAllTagStringArr() -> [String]{
        var retArr : [String] = []
        
        timesOfDay?.forEach{tag in
            if !retArr.contains(tag){
                retArr.append(tag)
            }
        }
        
        activities?.forEach{tag in
            if !retArr.contains(tag){
                retArr.append(tag)
            }
        }
        
        symptoms?.forEach{tag in
            if !retArr.contains(tag){
                retArr.append(tag)
            }
        }
        
        subjectTypes?.forEach{tag in
            if !retArr.contains(tag){
                retArr.append(tag)
            }
        }
        
        individuals?.forEach{tag in
            if !retArr.contains(tag){
                retArr.append(tag)
            }
        }
        
        
        return retArr
    }
    
    func toStressObject() -> StressManager.StressObject {
        
        let category = StressManager.StressCategories.allCases.first(where: {$0.rawValue == self.category}) ?? .other
        
        let returnObject : StressManager.StressObject = StressManager.StressObject(category: category)
        returnObject.rating = Int(self.rating)
        
        returnObject.times = self.timesOfDay ?? []
        returnObject.activities = self.activities ?? []
        returnObject.symptoms = self.symptoms ?? []
        returnObject.subjectTypes = self.subjectTypes ?? []
        returnObject.individuals = self.individuals ?? []

        
        
        return returnObject
    }
    
}
