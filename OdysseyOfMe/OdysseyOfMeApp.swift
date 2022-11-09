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
    
    //@StateObject var stressManager : StressManager = StressManager()
    


    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userSettings)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .onAppear{
                    //Initialize global data
                    //stressManager.build(stressData: Array(stressHistory)) //add data from last 30 days
                    
                }
        }
    }
    
}
