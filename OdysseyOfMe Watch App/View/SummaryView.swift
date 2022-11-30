//
//  SummaryView.swift
//  OdysseyOfMe Watch App
//
//  Created by Tanner Brown on 11/23/22.
//

import SwiftUI

struct SummaryView: View {
    
    @EnvironmentObject var episodeManager : EpisodeManager
    @Environment(\.scenePhase) var scenePhase

    @State private var durationFormatter : DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var body: some View {
        ScrollView(.vertical){
            VStack(alignment: .leading){
                
                SummaryMetricView(
                    title: "Total Time",
                    value: durationFormatter.string(for: episodeManager.episodeElapsedTime) ?? "")
                
                Text("Heart Rates")
                    .font(.title2)
                
                SummaryMetricView(title: "Avg", value: "\(Array(episodeManager.hrChecks.values).average.rounded())")
                
                SummaryMetricView(title: "Min", value: "\(Array(episodeManager.hrChecks.values).min() ?? 0)")
                
                SummaryMetricView(title: "Max", value: "\(Array(episodeManager.hrChecks.values).max() ?? 0)")
                
                
                if(!episodeManager.soundChecks.isEmpty){
                    Text("Sound Exposure")
                        .font(.title2)
                    
                    SummaryMetricView(title: "Avg", value: "\(Array(episodeManager.soundChecks.values).average.rounded())")
                    
                    SummaryMetricView(title: "Min", value: "\(Array(episodeManager.soundChecks.values).min() ?? 0)")
                    
                    SummaryMetricView(title: "Max", value: "\(Array(episodeManager.soundChecks.values).max() ?? 0)")
                }
                
                Button("Dismiss"){
                    episodeManager.isShowingSummary = false
                }
                
                
            }
        }
    }
}

struct SummaryMetricView : View {
    var title: String
    var value: String
    
    var body: some View{
        Text(title)
        Text(value)
            .font(.system(.title2, design: .rounded)
                .lowercaseSmallCaps()
            )
            .foregroundColor(.accentColor)
        Divider()
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}
