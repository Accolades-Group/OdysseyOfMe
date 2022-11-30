//
//  BiometricDataChartView.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/28/22.
//

import SwiftUI
import Charts
//
//final class BioMetricDataViewModel : ObservableObject {
//
//    @Published var bioData : EpisodeBiometricData
//    @Published var heartRates : [DataPoint] = []
//    @Published var soundRates : [DataPoint] = []
//
//    struct DataPoint : Identifiable {
//        let id = UUID()
//        var date : Date
//        var val : Int
//        var type : DataType
//        enum DataType {
//            case hr, db
//        }
//    }
//
//    init(bioData : EpisodeBiometricData){
//        self.bioData = bioData
//        loadData()
//    }
//
//    //MARK: Chart Dimensions
//    func getChartWidth() -> CGFloat {
//        return max(CGFloat(getIntervals().count * 2), 500)
//    }
//
//
//
//
//
//    func getHeartRates() -> [Date:Int]{
//        return bioData.heartRates ?? [:]
//    }
//
//    func getIntervals() -> [Date] {
//        return bioData.heartRates?.keys.sorted(by: {$0 < $1}) ?? []
//    }
//
//    func getSoundRates() -> [Date:Int]{
//        return bioData.soundDbs ?? [:]
//    }
//
//    func getSoundAvg() -> Int? {
//        if let values = bioData.soundDbs?.values{
//            return Int(Array(values).average)
//        }
//        return 0
//    }
//
//    func getHRAvg() -> Int? {
//        if let values = bioData.heartRates?.values{
//            return Int(Array(values).average)
//        }
//        return 0
//    }
//
//    func getEndSoundVal() -> Int? {
//
//        let last = bioData.soundDbs?.keys.sorted(by: {$0 < $1 }).last
//
//        return bioData.soundDbs?.first(where: {$0.key == last})?.value
//    }
//
//    func getEndHRVal() -> Int? {
//
//        let last = bioData.heartRates?.keys.sorted(by: {$0 < $1 }).last
//
//        return bioData.heartRates?.first(where: {$0.key == last})?.value
//    }
//
//    func loadData() {
//
//        guard let hRates = bioData.heartRates else { return }
//
//        guard let sRates = bioData.soundDbs else { return }
//
//        hRates.forEach{item in
//            heartRates.append(DataPoint(date: item.key, val: item.value, type: .hr))
//        }
//        self.heartRates = heartRates.sorted(by: {$0.date < $1.date})
//
//        sRates.forEach{item in
//            soundRates.append(DataPoint(date: item.key, val: item.value, type: .db))
//        }
//        self.soundRates = soundRates.sorted(by: {$0.date < $1.date})
//
//    }
//
//}
//

struct BioMetricStatisticsView : View {
    
    let bioData : EpisodeBiometricData
    
    var body: some View {
        
        VStack(spacing: 30){
            Spacer()
            //Top Square
            VStack{
                //Text(bioData?.startDate ?? Date.now, formatter: dateFormatter)
                Text( Date.now.formatted(.dateTime.day().month()))
                    .font(.title)
                    .bold()
                
                let (h, m, s) = secondsToHoursMinutesSeconds(Int(bioData.duration))
                if h > 0 {
                    Text("Duration: \(h):\(m)")
                } else {
                    Text("Duration: \(m):\(s)")
                }
                
                if let recent = bioData.recentHRV {
                    Text("Recent HRV: \(recent)")
                }
                
            }
            .font(.title2)
            .padding()
            .frame(width: 300)
            .background(
                Theme.DeselectedGray.opacity(0.8)
                    .cornerRadius(15)
            )
            
          //  ClaraSeperatorBar()
                

            
            VStack{
                Text("Heart Rate")
                    .font(.title2)
                    .underline()
                
                Text("Max: \(bioData.heartRates?.values.max() ?? 182)")

                
                if let avg = getHRAvg(){
                    Text("Avg: \(avg)")
                }
                
                if let endval = getEndHRVal(){
                    Text("End: \(endval)")
                }


            }
            //.font(Theme.Font(.title2))
            .padding()
            .frame(width: 300)
            .background(
                Color.RadicalRed.opacity(0.8)
                    .cornerRadius(15)
            )
            
  
            
            //Noise
            VStack{
                Text("Noise Exposure")
                    .font(.title2)
                    .underline()
                
                Text("Max: \(bioData.soundDbs?.values.max() ?? 182)")
                
                if let avg = getSoundAvg(){
                    Text("Avg: \(avg)")
                }
                
                if let endval = getEndSoundVal(){
                    Text("End: \(endval)")
                }
            }
            .padding()
            .frame(width: 300)
            .background(
                Color.ChartreuseYellow.opacity(0.8)
                    .cornerRadius(15)
            )
            
            Spacer()
        }
    }
    
    func getHRAvg() -> Int? {
        if let values = bioData.heartRates?.values{
            return Int(Array(values).average)
        }
        return 0
    }
    
    func getEndSoundVal() -> Int? {
        
        let last = bioData.soundDbs?.keys.sorted(by: {$0 < $1 }).last
        
        return bioData.soundDbs?.first(where: {$0.key == last})?.value
    }

    func getSoundAvg() -> Int? {
        if let values = bioData.soundDbs?.values{
            return Int(Array(values).average)
        }
        return 0
    }
    
    func getEndHRVal() -> Int? {
        
        let last = bioData.heartRates?.keys.sorted(by: {$0 < $1 }).last
        
        return bioData.heartRates?.first(where: {$0.key == last})?.value
    }
    
}

/**
 Creates a chart for the data fo a single biometric episode.
 
 Scalable? Create another init func that takes in an array of [EpisodeBioData]
 */
struct BioMetricChartView : View {
    
    @State var isShowingWalkingHR : Bool = true
    var walkingHr : Int
    var heartRates : [DataPoint] = []
    var soundRates : [DataPoint] = []
    var criticalHeartRates : [DataPoint] = []
    var criticalSoundRates : [DataPoint] = []
    @State var criticalNum : Int = 5
    
    /*
     The upper y bound for the chart. Min is set to 120, max is 200, and the upper bound is the highest y value within that range.
     */
    var yUpperBound : Int {
        let minUpperBound = 120
        var maxY = max(
            heartRates.max()?.val ?? minUpperBound,
            soundRates.max()?.val ?? minUpperBound
        )
        //TODO: round up to nearest 20 - up to 200
        maxY = min(maxY + 20, 200)
        return max(maxY, minUpperBound)
    }
    
    /*
     The lower y bound for the chart. Min is set to 40 and the lower bound is the lowest y value above the min (40).
     */
    var yLowerBound : Int {
        let lowerBound = 40
        
        var min = min(
            heartRates.min()?.val ?? lowerBound,
            soundRates.min()?.val ?? lowerBound
        )
        //TODO: Round down to nearest 10
        min = min - 10
        
        return max(lowerBound, min)
    }
    
    
    var chartWidth : CGFloat {
        return max(CGFloat(intervals * 2), 500)
    }
    
    var intervals : Int {
        return max(heartRates.count, soundRates.count)
    }
    
    init(bioData : EpisodeBiometricData){
        
        self.walkingHr = Int(bioData.recentWalkingHR)
        
        if let hr = bioData.heartRates {
            hr.forEach{item in
                self.heartRates.append(DataPoint(date: item.key, val: item.value, type: .hr))
            }
        }
        self.heartRates = self.heartRates.sorted(by: {$0.date < $1.date})
        
        if let sr = bioData.soundDbs{
            sr.forEach{item in
                soundRates.append(DataPoint(date: item.key, val: item.value, type: .db))
            }
        }
        self.soundRates = soundRates.sorted(by: {$0.date < $1.date})
        
        self.criticalSoundRates = getCriticalSoundRates()
        self.criticalHeartRates = getCriticalHR()
    }
    
    struct DataPoint : Identifiable, Comparable {
        static func < (lhs: BioMetricChartView.DataPoint, rhs: BioMetricChartView.DataPoint) -> Bool {
            lhs.val < rhs.val
        }
        
        let id = UUID()
        var date : Date
        var val : Int
        var type : DataType
        enum DataType {
            case hr, db
        }
    }
    
    var body: some View {
        VStack{
            Spacer()
            
            ScrollView(.horizontal){

                Chart {
                    ForEach(heartRates, id: \.date){ item in
                        LineMark(
                            x: .value("Date", item.date),
                            y: .value("hr", item.val),
                            series: .value("", "Heart Rates")
                        )
                        .foregroundStyle(Color.RadicalRed)
                    }
                    
                    ForEach(criticalHeartRates, id: \.date){item in
                        PointMark(
                            x: .value("Date", item.date),
                            y: .value("Crit", item.val)
                        )
                        .foregroundStyle(Color.RadicalRed)
                    }
                    
                    ForEach(soundRates, id: \.date){item in
                        LineMark(
                            x: .value("Date", item.date),
                            y: .value("db", item.val),
                            series: .value("", "Sound Rates")
                        )
                        .foregroundStyle(Color.ChartreuseYellow)
                    }
                    
                    ForEach(criticalSoundRates, id: \.date){item in
                        PointMark(
                            x: .value("Date", item.date),
                            y: .value("Crit", item.val)
                        )
                        .foregroundStyle(Color.ChartreuseYellow)
                    }
                    
                    if isShowingWalkingHR, walkingHr > 0 {
                        RuleMark(y: .value("Walking HR", walkingHr))
                            .foregroundStyle(Color.RadicalRed.opacity(0.5))
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                    }
                    
                }
                .frame(width: chartWidth, height: 400)
                .padding()
//                .chartXScale(domain: ClosedRange(uncheckedBounds: (
//                                        lower: hear//getIntervals().min()!,
//                                        upper: getIntervals().max()!)
//                                )
//                )
                .chartYScale(domain: ClosedRange(uncheckedBounds: (
                    lower : yLowerBound,
                    upper: yUpperBound))
                )
                .chartYAxis(){
                    AxisMarks(position: .leading)
                }
                .background(){
                    Color.DimGray.opacity(0.25).cornerRadius(15)
                }
                .chartXAxis(){
                    AxisMarks(position: .automatic)
                }
            }
            
            Spacer()
        }
        .padding()
    }
    
    
    
    func getCriticalHR() -> [DataPoint] {
        var retArray : [DataPoint] = []
        var hrs = heartRates
        var count = 0
        while (count < criticalNum){
            if let max = hrs.max() {
                retArray.append(max)
                hrs.removeAll(where: {$0.id == max.id})
            }
            count += 1
        }
        return retArray
    }
    
    func getCriticalSoundRates() -> [DataPoint] {
        var retArray : [DataPoint] = []
        var dbs = soundRates
        var count = 0
        while (count < criticalNum){
            if let max = dbs.max(by: {$0.val < $1.val}){
                retArray.append(max)
                dbs.removeAll(where: {$0.id == max.id})
            }
            count += 1
        }
        return retArray
    }
    
}



struct BiometricDataChartView_Previews: PreviewProvider {
    static var previews: some View {
       // BioMetricChartView()
        ContentView()
    }
}
