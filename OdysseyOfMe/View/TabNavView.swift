//
//  TabNavView.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/3/22.
//

import SwiftUI

struct TabNavView: View {
    
    
    
    var body: some View {
        TabView{
            CheckinView()
                .tabItem{
                    VStack{
                        Text("CheckIns")
                        Image("inventory")
                    }
                }
            
            
            //Extra view for testing
//            TestingView()
//                .tabItem{
//                    VStack{
//                        Text("Testing")
//                        Image(systemName: "exclamationmark.triangle")
//                    }
//                }
             
            
            HistoryView()
                .tabItem{
                    VStack{
                        Text("Progress")
                        Image("calendar")
                    }
                }
            
            AccountView()
                .tabItem{
                    VStack{
                        Text("Me")
                        Image("account_circle")
                    }
                }
        }
        .font(Theme.Font())
    }
}

struct TabNavView_Previews: PreviewProvider {
    static var previews: some View {
        TabNavView()
            .environmentObject(UserSettings())
    }
}
