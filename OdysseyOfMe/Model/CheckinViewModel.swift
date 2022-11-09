//
//  CheckinViewModel.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/3/22.
//

import Foundation
import SwiftUI
import CoreData

final class CheckinViewModel : ObservableObject {
    
    var moc : NSManagedObjectContext?
    
    //MARK: Satisfaction
    enum Satisfaction_Types : Int, CaseIterable{
        case very_dissatisfied = 0
        case dissatisfied = 1
        case neutral = 2
        case satisfied = 3
        case very_satisfied = 4
        
        var name : String {
            switch self{
            case .very_dissatisfied:
                return "Very Dissatisfied"
            case .dissatisfied:
                return "Dissatisfied"
            case .neutral:
                return "Neutral"
            case .satisfied:
                return "Satisfied"
            case .very_satisfied:
                return "Very Satisfied"
            }
        }
        
        var icon : Image {
            switch self {
            case .very_dissatisfied : return
                Image("sentiment_very_dissatisfied")
                
            case .dissatisfied : return Image("sentiment_dissatisfied")
                //default: return Image("sentiment_very_dissatisfied")
            case .neutral:
                return Image("sentiment_neutral")
            case .satisfied:
                return Image("sentiment_satisfied")
            case .very_satisfied:
                return Image("sentiment_very_satisfied")
            }
        }
        
    }
    
    @Published var selectedType : Satisfaction_Types? = nil
    
    func selectType(_ type : Satisfaction_Types){
        if type == selectedType {
            selectedType = nil
        }else{
            selectedType = type
        }
    }
    
    //MARK: Rose Bud Thorn
    @Published var rose : String = ""
    @Published var bud : String = ""
    @Published var thorn : String = ""
    
    
    //MARK: Stress
    @Published var stressManager : StressManager = StressManager()
    @Published var stressObjects : [StressManager.StressObject] = []
    @Published var currentStressIndex : Int = 0
    
    
    var currentStressObject : StressManager.StressObject {
        
        if stressObjects.isEmpty{
            return StressManager.StressObject(category: .none)
        }
        return stressObjects[currentStressIndex ?? stressObjects.count-1]
    }
    
    //This stress button is selected
    func stressButtonSelected(_ category : StressManager.StressCategories){
        if isStressCategorySelected(category){
            stressObjects.removeAll(where: {$0.category == category})
        }else if(stressObjects.count == 2){
            
            stressObjects.removeFirst()
            stressObjects.append(StressManager.StressObject(category: category))
            
        }else{
            stressObjects.append(StressManager.StressObject(category: category))
        }
    }
    
    func isStressCategorySelected(_ category : StressManager.StressCategories) -> Bool{
        return stressObjects.contains(where: {$0.category == category})
    }
    
    
    
    func submitCheckin(){
        
        if let unwrappedMoc = moc{
            
            let date : Date = Date.now
            
            let checkin : Checkin = Checkin(context: unwrappedMoc)
            checkin.date = date
            checkin.id = UUID()
            checkin.dayRating = Int16(selectedType?.rawValue ?? 0)
            checkin.rose = rose
            checkin.thorn = thorn
            checkin.bud = bud
            
            var stressors : [StressDetail] = []
            stressObjects.forEach{obj in
                
                let stressDetail : StressDetail = StressDetail(context: unwrappedMoc)
                stressDetail.addDate = date
                stressDetail.id = UUID()
                stressDetail.category = obj.category.rawValue
                stressDetail.rating = Int16(obj.rating)
                stressDetail.activities = obj.activities
                stressDetail.subjectTypes = obj.subjectTypes
                stressDetail.individuals = obj.individuals
                stressDetail.symptoms = obj.symptoms
                stressDetail.timesOfDay = obj.times
                
                stressors.append(stressDetail)
                
            }
            
            checkin.stressorDetails = NSSet(array: stressors)
            
            do {
                try unwrappedMoc.save()
            }catch let err {
                print("Error submitting checkin")
                print(err)
                print("--------------")
            }
        } else {
            //TODO: Handle Error?
        }
    }
    
    func resetData(){
        
        stressObjects = []
        currentStressIndex = 0
        
        rose = ""
        bud = ""
        thorn = ""
        
        selectedType = nil
        
    }
    
    //MARK: Routing
    @Published var path = NavigationPath()
    enum Routing : Hashable, CaseIterable {
        case howWasYourDay
        case roseThornBud
        case stressCategorySelection
        case stressDetail
        case stressLevel
        case summary
        case congratulations
        
        
        func next() -> Self {
            
            let all = Self.allCases
            let idx = all.firstIndex(of: self)!
            let next = all.index(after: idx)
            return all[next == all.endIndex ? all.startIndex : next]
            
        }
        
        func isLast() -> Bool {
            let all = Self.allCases
            let idx = all.firstIndex(of: self)!
            let next = all.index(after: idx)
            return next == all.endIndex
        }
        
        
    }
    
    func continueButton(_ route: Routing) {
        if route.isLast() {
            //Pop to root
            path = .init()
            
        } else if route == .stressCategorySelection && stressObjects.isEmpty {
            // Stress Category skipped and no category selected
            stressObjects.append(StressManager.StressObject(category: .other))
            
            path.append(route.next())
            
        }  else if route == .stressLevel {
            
            //if there is another stress object, loop back{
            if(currentStressIndex < stressObjects.count - 1){
                
                currentStressIndex = currentStressIndex + 1
                
                path.append(Routing.stressDetail)
                
            } else {
                
                //iterate forward to next stress object in array
                path.append(route.next())
                
            }
            
            
        } else if route == .summary {
            
            //submit checkin
            submitCheckin()
            
            path.append(route.next())
            
        } else {
            path.append(route.next())
        }
    }
    
    
    //MARK: Testing funcs
    func buildDemo() {//-> [StressManager.StressObject]{
        
      //  var retArr : [StressManager.StressObject] = []
        
        let stressor = StressManager.StressObject(category: .health)
        stressor.rating = 2
        stressor.toggleTimes("Evening")
        stressor.toggleActivities("Resting")
        stressor.toggleActivities("Eating")
        stressor.toggleSymptoms("Increased HR")
        stressor.toggleSubjectTypes("Family")
        stressor.toggleSubjectTypes("Stranger")
        stressor.toggleIndividuals("Tom")
        stressor.toggleIndividuals("Sarah")
        
        let stressor2 = StressManager.StressObject(category: .relationships)
        stressor2.rating = 3
        stressor2.toggleTimes("Night")
        stressor2.toggleActivities("Eating")
        stressor2.toggleSymptoms("Increased HR")
        stressor2.toggleSubjectTypes("Family")
        stressor2.toggleIndividuals("Tom")
        
        stressObjects.append(stressor)
        stressObjects.append(stressor2)
        
        selectedType = .neutral
       // return retArr
        
    }
    
}
