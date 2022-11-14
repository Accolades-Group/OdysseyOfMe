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
        case .very_dissatisfied: return "Very Dissatisfied"
        case .dissatisfied: return "Dissatisfied"
        case .neutral: return "Neutral"
        case .satisfied: return "Satisfied"
        case .very_satisfied: return "Very Satisfied"
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
