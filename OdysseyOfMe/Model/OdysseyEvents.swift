//
//  OdysseyEvent.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/26/22.
//

import Foundation

/**
 This class is a wrapper for the various types of events that this app tracks. This allows for those types of events to be put into the same collections arrays and to be manipulated as similar object types;
 */
class OdysseyEvent : Hashable, Identifiable {
    
    public static func == (lhs: OdysseyEvent, rhs: OdysseyEvent) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }


    var checkin : Checkin?
    var episode : Episode?
    var bioData : EpisodeBiometricData?
    
    var date : Date? {
        switch eventType{
        
        case .episode:
            if let e = episode {
                return e.date
            }
            
        case .episodeBio:
            if let e = bioData {
                return e.startDate
            }
            
        case .checkin:
            if let e = checkin {
                return e.date
            }
        }
        return nil
    }
    
    public var id : UUID {
        
        switch eventType{
        
        case .episode:
            if let e = episode {
                return e.id!
            }
            
        case .episodeBio:
            if let e = bioData {
                return e.id!
            }
            
        case .checkin:
            if let e = checkin {
                return e.id!
            }
        }
        return UUID()
    }
    
    let eventType : EventTypes
    
    enum EventTypes {
        case episode, episodeBio, checkin
    }
    

    init(event : Checkin){
        self.checkin = event
        self.eventType = .checkin
    }
    
    init(event : EpisodeBiometricData){
        self.bioData = event
        self.eventType = .episodeBio
    }
    
    init(event : Episode){
        self.episode = event
        self.eventType = .episode
    }
    
//    init(event: NSObject, eventType: EventTypes){
//        self.event = event
//        self.eventType = eventType
//    }
}


//Extensions to convert each object type into it's wrapper
extension Episode {
    func toOdysseyEvent() -> OdysseyEvent {
        return OdysseyEvent(event: self)
    }
}
extension EpisodeBiometricData {
    func toOdysseyEvent() -> OdysseyEvent {
        return OdysseyEvent(event: self)
    }
}
extension Checkin {
    
    func toOdysseyEvent() -> OdysseyEvent {
        return OdysseyEvent(event: self)
    }
    
    func toCheckinObject() -> CheckinObject{
        
        var stressObjects : [StressManager.StressObject] = []
        if let stressors = self.stressorDetails?.allObjects as? [StressDetail] {
            
            stressors.forEach{stress in
                stressObjects.append(stress.toStressObject())
            }
            
        }
        
        return CheckinObject(date: self.date!, ratingInt: Int(self.dayRating), details: stressObjects )
    }
}



