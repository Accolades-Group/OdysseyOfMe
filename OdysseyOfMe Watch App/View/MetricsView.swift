//
//  MetricsView.swift
//  OdysseyOfMe Watch App
//
//  Created by Tanner Brown on 11/23/22.
//

import SwiftUI

struct MetricsView: View {
    
    @EnvironmentObject var episodeManager : EpisodeManager

    
    var body: some View {
        TimelineView(
            MetricsTimeLineSchedule(from: episodeManager.builder?.startDate ?? Date())
        ){ context in
            
            ScrollView(.vertical){
                
                VStack(alignment: .leading){
                    
                    //Timer
                    ElapsedTimeView(
                        elapsedTime: episodeManager.episodeElapsedTime,//episodeManager.builder?.elapsedTime ?? 0,
                        showSubseconds: context.cadence == .live
                    ).foregroundColor(Color.yellow)
                        
                    //Heart Rate
                    Text(
                        episodeManager.currHR
                            .formatted(
                                .number.precision(.fractionLength(0))
                            )
                        + " bpm"
                    ).foregroundColor(Color.ClaraPink)
                    
//                    Text(
//                        episodeManager.heartRateAvg
//                            .formatted(
//                                .number.precision(.fractionLength(0))
//                            )
//                        + " (avg)"
//                    ).foregroundColor(Color.teal)
                    
                    //DB
                    Text(
                        episodeManager.currDb
                            .formatted(
                                .number.precision(.fractionLength(0))
                            )
                        + " dB"
                    ).foregroundColor(Color.teal)
                    
                }
                .font(.system(.title, design: .rounded).monospacedDigit())
                
            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .ignoresSafeArea(edges: .bottom)
//            .scenePadding()
            
        }
    }
}

private struct MetricsTimeLineSchedule : TimelineSchedule{
    
    var startDate : Date
    init(from startDate: Date){
        self.startDate = startDate
    }
    
    func entries(from startDate: Date, mode: TimelineScheduleMode) -> PeriodicTimelineSchedule.Entries {
        PeriodicTimelineSchedule(from: self.startDate, by: (mode == .lowFrequency ? 1.0 : 1.0/30.0)
        ).entries(from: startDate, mode: mode)
    }
}

struct ElapsedTimeView: View {
    var elapsedTime: TimeInterval = 0
    var showSubseconds : Bool = true
    @State private var timeFormatter = ElapsedTimeFormatter()
    
    var body: some View {
        Text(NSNumber(value: elapsedTime), formatter: timeFormatter)
            .fontWeight(.semibold)
            .onChange(of: showSubseconds){
                timeFormatter.showSubseconds = $0
            }
    }
}

class ElapsedTimeFormatter: Formatter {
    let componentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var showSubseconds = true
    
    override func string(for value: Any?) -> String? {
        guard let time = value as? TimeInterval else {
            return nil
        }
        
        guard let formattedString = componentsFormatter.string(from: time) else {
            return nil
        }
        
        if showSubseconds {
            let hundredths = Int((time.truncatingRemainder(dividingBy: 1)) * 100)
            let decimalSeparator = Locale.current.decimalSeparator ?? "."
            return String(format: "%@%@%0.2d", formattedString, decimalSeparator, hundredths)
            
        }
        return formattedString
    }
}


struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView()
            .environmentObject(EpisodeManager())
    }
}
