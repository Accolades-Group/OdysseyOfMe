//
//  CheckIn.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/14/22.
//

import Foundation
import SwiftUI

enum Satisfaction_Types : Int, CaseIterable{
    case very_dissatisfied = 0
    case dissatisfied = 1
    case neutral = 2
    case satisfied = 3
    case very_satisfied = 4
    
    var name : String {
        switch self{
        case .very_dissatisfied: return "Awful"
        case .dissatisfied: return "Bad"
        case .neutral: return "Neutral"
        case .satisfied: return "Good"
        case .very_satisfied: return "Amazing"
        }
    }
    
    var icon : Image {
        switch self {
        case .very_dissatisfied : return Image("sentiment_very_dissatisfied")
        case .dissatisfied : return Image("sentiment_dissatisfied")
        case .neutral: return Image("sentiment_neutral")
        case .satisfied: return Image("sentiment_satisfied")
        case .very_satisfied: return Image("sentiment_very_satisfied")
        }
    }
    
}

class CheckinObject : ObservableObject {
    @Published var date : Date
    @Published var rating : Satisfaction_Types
    
    @Published var stressDetails : [StressManager.StressObject]
    
    init(date : Date, rating : Satisfaction_Types, details : [StressManager.StressObject]){
        self.date = date
        self.rating = rating
        self.stressDetails = details
    }
}
