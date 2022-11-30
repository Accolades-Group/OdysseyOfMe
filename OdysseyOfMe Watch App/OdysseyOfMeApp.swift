//
//  OdysseyOfMeApp.swift
//  OdysseyOfMe Watch App
//
//  Created by Tanner Brown on 11/3/22.
//

import SwiftUI

@main
struct OdysseyOfMe_Watch_AppApp: App {
    
    @StateObject var dataController : DataController = DataController()
    
    init(){
        authorizeHK()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
