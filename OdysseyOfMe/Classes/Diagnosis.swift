//
//  Diagnosis.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/3/22.
//

import Foundation


struct Diagnosis {
    
    var diagnosisDate : Date?
    
    var diagnosisName : String?
    
    var medications : [Medication]?
    
}

struct MedicalHistory {
    
    var currentDiagnosis : [Diagnosis]?
    
}

func test() {
    
    var medHistory : MedicalHistory = MedicalHistory()
    
    var depression = Diagnosis(diagnosisDate: Date.now, diagnosisName: "Depression", medications: [Medication(name: "Zoloft", frequency: .both, changeDate: Date.now)])
    
    var anxiety = Diagnosis(diagnosisDate: Date.distantPast, diagnosisName: "Anxiety", medications: [Medication(name: "Hydroxozone", frequency: .am, changeDate: Date.now)])
    
    medHistory.currentDiagnosis = [depression, anxiety]
    
}

struct Medication {
    
    var name : String?
    
    var frequency : MedicationFrequency?
    
    var changeDate : Date?
    
    enum MedicationFrequency : String {
        case am = "AM",
             pm = "PM",
             both = "AM / PM"
    }
    
}
