//
//  Timer.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/17/22.
//

import Foundation
//import SwiftUI
import Combine

//MARK: Timeout Timer ...
final class TimeoutTimer : ObservableObject  {
    
    var subscription : Cancellable?
    
    var timeout : Double
    
    init(timeout : Double){
        self.timeout = timeout
    }
    
    func tick(){
        timeout -= 1
    }
 
    func check() -> Bool {
        if (timeout <= 0) {
            subscription?.cancel()
            return true
        }
        return false
    }
    
   // func run(onComplete: @escaping () -> Void) {
    func run(){
        
        let runLoop = RunLoop.main
        
        subscription = runLoop.schedule(after: runLoop.now, interval: .seconds(1), tolerance: .microseconds(100)){[self] in
            
            
            tick()

        }
    }
    
    
}

