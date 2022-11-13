//
//  UserSettings.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/3/22.
//

import Foundation

final class UserSettings : ObservableObject {
    
    private enum keys : String, CaseIterable {
        //Personal Info
        case name, firstName, lastName, email, phone, dateOfBirth, registrationDate, profileImageString, medicalHistory,
             
             //Care Provider Info
             providerName, providerEmail, providerPhone, providerFrequeny, isProviderCommunication,
        
        //Watch
        isEpisodeTracking, isExerciseTracking, isSleepTracking, isWatchTracking
    }
    
    // Resets all user data
    func resetData(){
        keys.allCases.forEach{
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
    }
    
    // The displayed name for the user
    @Published var name : String {
        didSet{
            UserDefaults.standard.set(name, forKey: keys.name.rawValue)
        }
    }
    
    // The first name of the user
    @Published var firstName : String {
        didSet{
            UserDefaults.standard.set(firstName, forKey: keys.firstName.rawValue)
        }
    }
    
    // The last name of the user
    @Published var lastName : String {
        didSet{
            UserDefaults.standard.set(lastName, forKey: keys.lastName.rawValue)
        }
    }
    
    // The email of the user
    @Published var email: String {
        didSet{
            UserDefaults.standard.set(email, forKey: keys.email.rawValue)
        }
    }
    
    // The phone number of the user
    @Published var phone: String {
        didSet{
            UserDefaults.standard.set(phone, forKey: keys.phone.rawValue)
        }
    }
    
    // The date that the user registered their account
    @Published var dateOfBirth : Date {
        didSet{
            UserDefaults.standard.set(dateOfBirth, forKey: keys.dateOfBirth.rawValue )
        }
    }
    
    // The date that the user registered their account
    @Published var registrationDate : Date {
        didSet{
            UserDefaults.standard.set(registrationDate, forKey: keys.registrationDate.rawValue )
        }
    }
    
    // TODO: Profile Image
    // The date that the user registered their account
    @Published var profileImageString : String {
        didSet{
            UserDefaults.standard.set(profileImageString, forKey: keys.profileImageString.rawValue )
        }
    }

    
//    @Published var medicalHistory : MedicalHistory {
//        didSet{
//            UserDefaults.standard.set(medicalHistory, forKey: keys.medicalHistory.rawValue)
//        }
//    }
    
    //Provider Info
    
    @Published var providerName : String{
        didSet{
            UserDefaults.standard.set(providerName, forKey: keys.providerName.rawValue)
        }
    }

    // The email of the user's care Provider
    @Published var providerEmail: String {
        didSet{
            UserDefaults.standard.set(providerEmail, forKey: keys.providerEmail.rawValue)
        }
    }
    
    // The email of the user's care provider
    @Published var providerPhone: String {
        didSet{
            UserDefaults.standard.set(providerPhone, forKey: keys.providerPhone.rawValue)
        }
    }
    
    //TODO: Frequency? Have user select time of next appointment?
//    // The frequency the user wants their provider contacted
//    @Published var providerFrequeny : DateInterval {
//        return
//    }
    
    // Is the user communicating this data with a provider
    @Published var isProviderCommunication : Bool {
        didSet{
            UserDefaults.standard.set(isProviderCommunication, forKey: keys.isProviderCommunication.rawValue)
        }
    }
    
    //Watch
    
    // Is the user tracking episodes
    @Published var isEpisodeTracking : Bool{
        didSet{
            UserDefaults.standard.set(isEpisodeTracking, forKey: keys.isEpisodeTracking.rawValue)
        }
    }
    
    // Is the user tracking exercise
    @Published var isExerciseTracking : Bool {
        didSet{
            UserDefaults.standard.set(isExerciseTracking, forKey: keys.isExerciseTracking.rawValue)
        }
    }
    
    // Is the user tracking sleep
    @Published var isSleepTracking : Bool {
        didSet{
            UserDefaults.standard.set(isSleepTracking, forKey: keys.isSleepTracking.rawValue)
        }
    }
    
    // Is the watch tracking user data
    @Published var isWatchTracking : Bool {
        didSet{
            UserDefaults.standard.set(isWatchTracking, forKey: keys.isWatchTracking.rawValue)
        }
    }
    
    init(){
        //Name
        self.name = UserDefaults.standard.object(forKey: keys.name.rawValue) as? String ?? ""//PersonNameComponents ?? PersonNameComponents()
        self.firstName = UserDefaults.standard.object(forKey: keys.firstName.rawValue) as? String ?? ""
        self.lastName = UserDefaults.standard.object(forKey: keys.firstName.rawValue) as? String ?? ""
        self.profileImageString = UserDefaults.standard.object(forKey: keys.profileImageString.rawValue) as? String ?? ""
        
        //Contact
        self.email = UserDefaults.standard.object(forKey: keys.email.rawValue) as? String ?? ""
        self.phone = UserDefaults.standard.object(forKey: keys.phone.rawValue) as? String ?? ""
        
        self.dateOfBirth = UserDefaults.standard.object(forKey: keys.dateOfBirth.rawValue) as? Date ?? Date.now
        self.registrationDate = UserDefaults.standard.object(forKey: keys.registrationDate.rawValue) as? Date ?? Calendar.current.date(byAdding: .month, value: -1, to: Date.now)!
        
      //  self.medicalHistory = UserDefaults.standard.object(forKey: keys.medicalHistory.rawValue) as? MedicalHistory ?? MedicalHistory()
        
        
        //Care Provider
        self.providerName = UserDefaults.standard.object(forKey: keys.providerName.rawValue) as? String ?? ""//PersonNameComponents ?? PersonNameComponents()
        self.providerEmail = UserDefaults.standard.object(forKey: keys.providerEmail.rawValue) as? String ?? ""
        self.providerPhone = UserDefaults.standard.object(forKey: keys.providerPhone.rawValue) as? String ?? ""
        self.isProviderCommunication = UserDefaults.standard.object(forKey: keys.isProviderCommunication.rawValue) as? Bool ?? false
        
        //Watch
        self.isEpisodeTracking = UserDefaults.standard.object(forKey: keys.isEpisodeTracking.rawValue) as? Bool ?? false
        self.isExerciseTracking = UserDefaults.standard.object(forKey: keys.isExerciseTracking.rawValue) as? Bool ?? false
        self.isSleepTracking = UserDefaults.standard.object(forKey: keys.isExerciseTracking.rawValue) as? Bool ?? false
        self.isWatchTracking = UserDefaults.standard.object(forKey: keys.isWatchTracking.rawValue) as? Bool ?? false

    }
    
}
