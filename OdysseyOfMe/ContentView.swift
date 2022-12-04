//
//  ContentView.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/3/22.
//

import SwiftUI

/**
 Main container for the app's content. Initially shows terms of service if the user hasn't agreed to them, otherwise shows the apps main TabNavigationView
 */
struct ContentView: View {
    
    @EnvironmentObject var userSettings : UserSettings
    @State var isShowingTOS : Bool = false
    
    var body: some View {
        
        if !userSettings.isTermsAndPrivacyAccepted{
            
            TermsAndPrivacy()
            
        } else { //All good, go home
            
            TabNavView()
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserSettings())
    }
}
