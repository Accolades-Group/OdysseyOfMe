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
    @Published var todayStreak : Int = 0
    @Published var maxStreak : Int = 0
    

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
    @Published var stressManager : StressManager = StressManager(withTags: true)
    @Published var stressObjects : [StressManager.StressObject] = []
    @Published var currentStressIndex : Int = 0
    
    
    var currentStressObject : StressManager.StressObject {
        
        if stressObjects.isEmpty{
            return StressManager.StressObject(category: .none)
        }
        return stressObjects[min(currentStressIndex , stressObjects.count-1)]
    }
    
    //This stress button is selected
    func stressButtonSelected(_ category : StressManager.StressCategories){
        
        //Toggle if category is already selected
        if stressObjects.contains(where: {$0.category == category}){
            stressObjects.removeAll(where: {$0.category == category})
            
            //If 2 selected, remove oldest category selected (max of 2)
        }else if(stressObjects.count == 2){
            stressObjects.removeFirst()
            stressObjects.append(StressManager.StressObject(category: category))
            
            //Append category to array
        }else{
            stressObjects.append(StressManager.StressObject(category: category))
        }
    }
    

    func submitCheckin() {
        
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
        
        func pos() -> Int {
            return Self.allCases.firstIndex(of: self)!
        }
        
        var totalRoutes : Int {
            return Self.allCases.count
        }
        
        func isFirst() -> Bool {
            let all = Self.allCases
            let idx = all.firstIndex(of: self)!
            return idx == 0
        }
        
        func isLast() -> Bool {
            let all = Self.allCases
            let idx = all.firstIndex(of: self)!
            let next = all.index(after: idx)
            return next == all.endIndex
        }
    }
    
    func continueButton(_ route: Routing) {
        
        //This shouldn't ever happen...
        if route.isLast() {
            //Reset the data
            resetData()
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
            resetData()
            path.append(route.next())
            
        } else {
            path.append(route.next())
        }
    }
    
    func backButton(_ route : Routing){
        
        if route == .stressDetail {
            currentStressIndex = max(0, currentStressIndex - 1)
        }
        
        else if route.isFirst(){
            path = .init() //Prevent bug where same gets added twice?
        } else {
            path.removeLast()
        }
    }
    
    func getNavigationTitle(_ route : Routing) -> String {
        
        if route == .stressDetail || route == .stressLevel {
            return "\(currentStressObject.category.rawValue.capitalized) Stressor"
            
        } else { return "" }
        
    }
    
    func getViewQuestion(_ route : Routing) -> String{
        switch route {
        case .howWasYourDay : return "How was your day?"
        case .roseThornBud : return "Rose, Thorn, and Bud"
        case .stressCategorySelection : return "What areas were most stressful today?"
        case .stressLevel : return "How stressful was this experience?"
        case .summary : return "Summary"
            
        default: return ""
        }
    }
    
    func getStreak(checkinHistory : [Checkin]) -> (current: Int, max: Int) {
        
        //get current streak
        //sort by most recent
        var history = checkinHistory.sorted(by: {$0.date! > $1.date!})
        
        var current : Int = 0
        var index : Int = 0
        var todayStreak : Int = 0
        for h in history{
            let compareDate = Calendar.current.date(byAdding: .day, value: -index, to: Date.now)!
            if isSameDay(date1: h.date!, date2: compareDate){
                index = index + 1
                current = current + 1
            }else{
                break
            }
        }
        todayStreak = current
        //TODO: Algorithm for max streak
        
        var streaks : [Int] = []
        index = 0
        current = 0
        
        for h in history{
            
            let compareDate = Calendar.current.date(byAdding: .day, value: -index, to: Date.now)!
            
            if isSameDay(date1: h.date!, date2: compareDate){
                current = current + 1
            }else{//break in streak
                streaks.append(current)
                current = 0
            }
            
            
            index = index + 1
        }
        
        
        print(todayStreak)
        print(streaks)
        let max = streaks.sorted(by: {$0 < $1}).last ?? current
        
        self.todayStreak = todayStreak
        self.maxStreak = max
        
        //don't need return?
        return (current: todayStreak, max: max)
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
