//
//  OdysseyOfMeApp.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/3/22.
//

import SwiftUI

@main
struct OdysseyOfMeApp: App {
    
    //The User's default settings
    @StateObject var userSettings : UserSettings = UserSettings()

    @StateObject var dataController : DataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userSettings)
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
    
}
