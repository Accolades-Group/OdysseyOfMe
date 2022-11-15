//
//  ContentView.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/3/22.
//

import SwiftUI

struct ContentView: View {
    
    @FetchRequest(sortDescriptors: []) var stressHistory : FetchedResults<StressDetail>
    
    @EnvironmentObject var userSettings : UserSettings
    
    @State var isShowingTOS : Bool = false
    

    init(){
        
    }
    
    var body: some View {
        
        if !userSettings.isTermsAndPrivacyAccepted{
            
            TermsAndPrivacy()
            
        } else { //All good, go home
            
            TabNavView()
                .onAppear{
                   // userSettings.resetData()
                }
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
