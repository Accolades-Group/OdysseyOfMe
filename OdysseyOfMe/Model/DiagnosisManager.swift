//
//  Diagnosis.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/3/22.
//

import Foundation


class DiagnosisManager : ObservableObject {
    @Published var diagnosis : [Diagnosis] = buildSampleMedHistory()
}

struct Diagnosis : Hashable {
    
    static func == (lhs: Diagnosis, rhs: Diagnosis) -> Bool {
        lhs.name.lowercased() == rhs.name.lowercased()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    
    var diagnosisDate : Date?
    
    var name : String
    
    var medications : [Medication] = []
    
}


func buildSampleMedHistory() -> [Diagnosis] {

    
    var depression = Diagnosis(diagnosisDate: Date.now, name: "Depression", medications: [Medication(name: "Zoloft", frequency: Medication.MedicationFrequency.both.rawValue, changeDate: Date.now)])
    
    var anxiety = Diagnosis(diagnosisDate: Date.distantPast, name: "Anxiety", medications: [Medication(name: "Hydroxyzine", frequency: Medication.MedicationFrequency.am.rawValue, changeDate: Date.now)])
    
    
    return [depression, anxiety]
}

struct Medication : Hashable {
    
    var name : String = ""
    
    var frequency : String = ""
    
    var changeDate : Date?
    
    static func == (lhs: Medication, rhs: Medication) -> Bool {
        lhs.name.lowercased() == rhs.name.lowercased()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    
    enum MedicationFrequency : String {
        case am = "AM",
             pm = "PM",
             both = "AM / PM"
    }
    
}

