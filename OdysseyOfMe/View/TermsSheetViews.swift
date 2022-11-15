//
//  TermsSheetViews.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/15/22.
//

import Foundation
import SwiftUI


struct TermsAndPrivacy : View {
    
    @EnvironmentObject var userSettings : UserSettings
    
    var body: some View{
        VStack(alignment: .leading, spacing: 20){
            
            HStack{
                Image("skylar1")
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(.degrees(22))
                
                Spacer(minLength: 0)
                
            }
            .frame(width: .infinity, height: 60)
            .padding([.horizontal, .bottom])
            
            
            
            Text("Terms and Privacy")
                .font(Theme.Font(.title1))
                .bold()
            
            Text("Enabling Health Kit Tracking allows Odyssey to create graphs that display your metrics over time and or send your health data directly to your therapist to better understanding your patterns.")
                .font(Theme.Font(16))
            
            Spacer(minLength: 0)
            
            Text("Your Data")
                .font(.system(size: 36))
                .bold()
            
            Text("The data from your daily check-ins is stored on your device and not sold to others without your permission. For research purposes, we collect non-identifying information to improve the customer expereince.")
                .font(Theme.Font(16))
            
            Spacer()
            
            Text("By continuing you agree to our **Terms of Services** and **Privacy Policy.** ")
                .font(Theme.Font(16))
                .padding(.bottom)
            
            Button{
                userSettings.isTermsAndPrivacyAccepted = true
            } label: {
                Text("I Accept")
            }.buttonStyle(RoundedButtonStyle())
            
            
        }.padding(30)
    }
}

struct CheckinReminderAndAffirmations : View {
    @EnvironmentObject var userSettings : UserSettings

    var body: some View{
        VStack(alignment: .leading, spacing: 30){
            
            Text("Terms and Privacy")
                .font(Theme.Font(36))
                .bold()
            
            Text("We recommend completing check-ins in the evening as your day winds down. You can, however, decide any time that you would like to get reminded to complete a checkin.")
                .font(Theme.Font(16))

            Spacer()
            
            Text("Daily Check-in")
                .font(Theme.Font(36))
                .bold()
            
            Text("TODO Wheel")
            
            
            Text("Daily Affirmations")
                .font(Theme.Font(36))
                .bold()
            
            Text("TODO:")
            
        }.padding(30)
    }
    
}

struct TermsSheetView_Previews: PreviewProvider {
    static var previews: some View {
        //TermsAndPrivacy()
        CheckinReminderAndAffirmations()
    }
}
