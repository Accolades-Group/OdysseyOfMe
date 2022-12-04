//
//  LOGGER.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 12/3/22.
//

import Foundation
import OSLog

//Simpler codewise -- but this has got to be slower during runtime to make a new logger object each time you log
class ODYSSEY_LOGGER {
    
    static let subsystem = Bundle.main.bundleIdentifier!
    

    static func log(source: Any, message : String){
        Logger(subsystem: subsystem, category: String(String(describing: source))).log("\(message)")
    }
    
    static func error(source: Any, message : String){
        Logger(subsystem: subsystem, category: String(String(describing: source))).error("\(message)")
    }
    
    static func critical(source: Any, message : String){
        Logger(subsystem: subsystem, category: String(String(describing: source))).critical("\(message)")
    }
    
    static func trace(source: Any, message : String){
        Logger(subsystem: subsystem, category: String(String(describing: source))).trace("\(message)")
    }
    
    
}

class testClass {
    init(){
        ODYSSEY_LOGGER.log(source: self, message: "Test log")
    }
}


//fileprivate let LOGGER = Logger(
//    subsystem: Bundle.main.bundleIdentifier!,
//    category: String("HEALTH KIT HELPER")
//)
