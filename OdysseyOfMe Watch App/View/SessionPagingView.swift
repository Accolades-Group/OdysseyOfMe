//
//  SessionPagingView.swift
//  OdysseyOfMe Watch App
//
//  Created by Tanner Brown on 11/23/22.
//

import SwiftUI

struct SessionPagingView: View {
    
    @Environment(\.isLuminanceReduced) var isLuminenceReduced
    @Environment(\.managedObjectContext) var moc

    @StateObject var episodeManager : EpisodeManager = EpisodeManager()
    
    @FetchRequest(sortDescriptors: []) var bioHistory : FetchedResults<EpisodeBiometricData>

    @State private var selection : Tab = .metrics
    enum Tab {
        case controls, metrics
    }
    
    var body: some View {
            
            NavigationView{
                if episodeManager.running || episodeManager.paused {
                    
                    //Main View
                    TabView(selection: $selection){
                        ControlsView()
                            .tag(Tab.controls)
                        
                        MetricsView()
                            .tag(Tab.metrics)
                        
                        
                    }
                    .toolbar(.hidden)
                    .tabViewStyle(
                        PageTabViewStyle(indexDisplayMode: isLuminenceReduced ? .never : .automatic)
                    )
                    //TODO: Alert:
                    .alert("Are you still having an episode?", isPresented: $episodeManager.timer.isShowingEpisodeEndAlert, actions: {
                        // actions
                        Button("Yes"){
                            episodeManager.timer.reset()
                        }
                        
                        Button("No"){
                            episodeManager.endEpisode()
                        }
                    }, message: {
                        //Text(episodeManager.timer.timeoutString)
                        //TODO: This only loads once and doesn't update...
                    })
                }
                
                else if episodeManager.isShowingSummary {
                    
                    SummaryView()
                    
                } else {
                    VStack{
                        
                        Text("Episodes: \(bioHistory.count)")
                        
                        Button("Record Episode"){
                            episodeManager.startEpisode(moc: moc)
                            selection = .metrics
                        }
                    }
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .ignoresSafeArea(edges: .bottom)
            .scenePadding()
            .environmentObject(episodeManager)
    }
}

struct SessionPagingView_Previews: PreviewProvider {
    static var previews: some View {
        SessionPagingView()
    }
}
