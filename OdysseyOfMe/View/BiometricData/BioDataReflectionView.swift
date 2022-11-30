//
//  BioDataReflectionView.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/27/22.
//

import SwiftUI
import Charts

/**
 A parent tab view that displays both the biometric chart page and statistics page for a single episode.
 */
struct BioDataReflectionView: View {
    
    let bioData : EpisodeBiometricData

    @State private var selection : Tab = .metrics
    enum Tab {
        case metrics, chart
    }
    
    var body: some View {

        //Main View
        TabView(selection: $selection){
            
            //page 1
            BioMetricStatisticsView(bioData: bioData)
            .tag(Tab.metrics)
            
            BioMetricChartView(bioData: bioData)
                .tag(Tab.chart)
            
        }
        .tabViewStyle(
            PageTabViewStyle()
        )

    }
}

struct BioDataReflectionView_Previews: PreviewProvider {
    static var previews: some View {
        //BioDataReflectionView()
        ContentView()
            .environment(\.colorScheme, .light)
            .environmentObject(UserSettings())
            .environment(\.managedObjectContext, DataController().container.viewContext)
    }
}
