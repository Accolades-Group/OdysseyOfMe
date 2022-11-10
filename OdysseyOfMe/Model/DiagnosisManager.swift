//
//  Diagnosis.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/3/22.
//

import Foundation


class DiagnosisManager : ObservableObject {
    
}

struct Diagnosis : Hashable {
    
    
    static func == (lhs: Diagnosis, rhs: Diagnosis) -> Bool {
        lhs.diagnosisName?.lowercased() == rhs.diagnosisName?.lowercased()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(diagnosisName)
    }
    
    
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

func buildSampleMedHistory() -> MedicalHistory {
    var medHistory : MedicalHistory = MedicalHistory()
    
    var depression = Diagnosis(diagnosisDate: Date.now, diagnosisName: "Depression", medications: [Medication(name: "Zoloft", frequency: .both, changeDate: Date.now)])
    
    var anxiety = Diagnosis(diagnosisDate: Date.distantPast, diagnosisName: "Anxiety", medications: [Medication(name: "Hydroxozone", frequency: .am, changeDate: Date.now)])
    
    medHistory.currentDiagnosis = [depression, anxiety]
    
    return medHistory
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
