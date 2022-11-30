//
//  HistoryView.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/3/22.
//

import SwiftUI

final class CalendarViewModel : ObservableObject{
    
    @Published var currentDate : Date = Date()
    
    @Published var calendarEvents : [OdysseyEvent] = []
    
    @Published var path = NavigationPath()
        
    func hasCheckin(date : Date, checkIns : [Checkin]) -> Bool {
        
        guard (checkIns.first(where: {isSameDay(date1: $0.date!, date2: date)}) != nil) else {  return false }
        
        return true

    }
    
    func loadEvents(_ events : [OdysseyEvent]){
        
        
        events.forEach{event in
            if !self.calendarEvents.contains(where: {$0.id == event.id}){
                self.calendarEvents.append(event)
            }
        }
    }
    
    func hasBioData(date : Date, bioData : [EpisodeBiometricData]) -> Bool {
        
        guard (bioData.first(where: {isSameDay(date1: $0.startDate!, date2: date)}) != nil) else {return false}
        
        return true
        
    }
    
    func getStressDetailsFromCheckIn(_ check : Checkin) -> [StressDetail] {
        
        var retArr : [StressDetail] = []
        
        check.stressorDetails?.forEach{detail in
            retArr.append(detail as! StressDetail)
        }
        
        return retArr
        
    }
    
    func getChecksInDate(date : Date, checkIns : [Checkin]) -> [Checkin] {
        
        
        return checkIns.filter({isSameDay(date1: $0.date!, date2: date)})
        
    }
    
    /**
     Returns all of the events on the selected date on the calendar
     */
    func getEventsOnSelectedDate() -> [OdysseyEvent] {
        
        return calendarEvents.filter({isSameDay(date1: $0.date!, date2: currentDate)})
        
        //calendarEvents.values.filter({isSameDay(date1: $0.date!, date2: currentDate)})
    }
    
    /**
     Returns all the events for the given date on the calendar
     */
    func checkForEventsOnDate(date : Date) -> [OdysseyEvent]? {
        
        return calendarEvents.filter({isSameDay(date1: $0.date!, date2: date)})
        
        
//        TODO: Fix this
//        if let event = calendarEvents.first(where: {isSameDay(date1: $0.key, date2: date)})?.value {
//
//
//
//            var isCheckin : Bool = false
//            var isBioData : Bool = false
//
//            if event is Checkin {
//                isCheckin = true
//            }else if event is EpisodeBiometricData{
//                isBioData = true
//            }
//
//            return (event, isCheckin, isBioData)
//        }
        
  //      return nil
        
    }
    
}

struct HistoryView: View {

    
    
    @StateObject var viewModel : CalendarViewModel = CalendarViewModel()
    
    @FetchRequest(sortDescriptors: []) var stressHistory : FetchedResults<StressDetail>
    
    @FetchRequest(sortDescriptors: []) var checkinHistory : FetchedResults<Checkin>
    
    @FetchRequest(sortDescriptors: []) var biometricHistory : FetchedResults<EpisodeBiometricData>


    var body: some View {

        NavigationStack(path: $viewModel.path){
            
        
            ScrollView(.vertical, showsIndicators: false){
                
                VStack(spacing: 20){
                    
                    //Custom Date Picker
                    CustomDatePicker()
                    
                }
                .padding(.vertical)
                
            }
        }
        .onAppear{
            var events : [OdysseyEvent] = []
            
            checkinHistory.forEach{event in
                events.append(event.toOdysseyEvent())
            }
            biometricHistory.forEach{event in
                events.append(event.toOdysseyEvent())
            }
            
            
            viewModel.loadEvents(events)
        }
        .environmentObject(viewModel)
        //safe aera view?
        /*
        .safeAreaInset(edge: .bottom){
            HStack{
                
                HStack{
                    Button{
                        
                    } label: {
                        Text("Add Task")
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .background(.orange, in: Capsule())
                    }
                    
                    Button{
                        
                    } label: {
                        Text("Add Reminder")
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .background(.purple, in: Capsule())
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                .foregroundColor(.white)
                .background(.ultraThinMaterial)
                
            }
        }
        */
        
    }
}

struct CustomDatePicker : View {
    
    @EnvironmentObject var viewModel : CalendarViewModel
    
    @FetchRequest(sortDescriptors: []) var stressHistory : FetchedResults<StressDetail>
    
    @FetchRequest(sortDescriptors: []) var checkinHistory : FetchedResults<Checkin>
    
    @FetchRequest(sortDescriptors: []) var biometricHistory : FetchedResults<EpisodeBiometricData>

    
    //@Binding var currentDate : Date
    
    // Month update on arrow button clicks
    @State var currentMonth = 0
    
    var body: some View {
        
        

            VStack{
                
                //Days
                let days : [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                
                //Month title view
                HStack(spacing: 20){
                    
                    VStack(alignment: .leading, spacing: 10){
                        
                        Text(extraDate()[0])
                            .font(.caption)
                            .fontWeight(.semibold)
                        
                        Text(extraDate()[1])
                            .font(.title.bold())
                        
                    }
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        withAnimation{
                            currentMonth -= 1
                        }
                    } label : {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                    }
                    
                    Button {
                        withAnimation{
                            currentMonth += 1
                        }
                    } label : {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                    }
                    
                }
                .padding()
                
                //Days view
                HStack(spacing: 0){
                    ForEach(days, id: \.self){day in
                        
                        Text(day)
                            .font(.callout)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                        
                    }
                }
                
                //Dates
                //Week day cols
                let cols = Array(repeating: GridItem(.flexible()), count: 7)
                
                //Lazy grid...
                LazyVGrid(columns: cols, spacing: 15){
                    
                    ForEach(extractDate()){value in
                        
                        DayView(value: value)
                            .background(
                                Capsule()
                                    .fill(Theme.MainColor)
                                    .padding(.horizontal, 8)
                                    .opacity(isSameDay(date1: value.date, date2: viewModel.currentDate) ? 1 : 0)
                            )
                            .onTapGesture {
                                viewModel.currentDate = value.date
                            }
                    }
                }
                
                //MARK: Events
                //Daily Events
                
                
                VStack(spacing: 15){
                    
                    Text("Events")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical)
                    
                    //TODO: For each event
                    //LEFT OFF HERE
                    
                    ForEach(viewModel.getEventsOnSelectedDate(), id: \.self){event in
                        
                        if event.eventType == .checkin, let check = event.checkin {
                            
                            CheckTabView(check: check)
                            
                        } else if event.eventType == .episodeBio, let bio = event.bioData {
                            
                            EpisodeBioDataTabView(bioData: bio)

                            
                            
                        }
                        
                        
                    }
                }
                .padding()
        }
        .onChange(of: currentMonth){newValue in
            viewModel.currentDate = getCurrentMonth()
        }

    }
    
    /**
     Displays the tab for episode bio data that shows on the calendar when a day is selected
     */
    struct EpisodeBioDataTabView : View {
        
        @State var isSelected : Bool = false
        @State var isPresenting : Bool = false
        
        @EnvironmentObject var viewModel : CalendarViewModel
        
        var bioData : EpisodeBiometricData
        
        
        var body: some View {
            
            VStack(alignment: .leading, spacing: 10){
                
                //
                HStack{
                    
                    VStack(spacing: 0){
                        
                        Image(systemName: "clock.arrow.circlepath")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .padding(5)
                        
                        let (h, m, s) = secondsToHoursMinutesSeconds(Int(bioData.duration))
                        if h > 0 {
                            Text("\(h):\(m)")
                        } else {
                            Text("\(m):\(s)")
                        }
                        
                    }.foregroundColor(.white)
                        .padding(.leading, 5)
                        .padding(.trailing, 10)
                    
                    
                    
                    Text(bioData.startDate!.formatted(date: .omitted, time: .shortened))
                        .padding(.leading)
                        .font(Theme.Font(.title2))
                        .foregroundColor(.white)
                        .bold()
                    
                    Spacer()

                    //Image("forward_arrow")
                    
                    NavigationLink{
                        
                        //EpisodeReflectionView(bioData: bioData)
                        BioDataReflectionView(bioData: bioData)
                        
                    } label: {
                        Image(systemName: "arrowtriangle.forward.fill")
                            .resizable()
                            .foregroundColor(isSelected ? .white : .clear)
                            .frame(width: 15, height: 25)
                            .padding(.trailing)
                        
                    }.disabled(!isSelected)
  
                }
                .padding(.vertical, 10)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 80)
                    .background(
                        
                        
                        Color.red.opacity(0.8)
                            .cornerRadius(10)
                    )
                    .onTapGesture {
                        withAnimation{
                            isSelected.toggle()
                        }
                    }

            }
            
        }
        
        
    }
    
    /**
     Displays the tab for a checkin that shows on the calendar when a day is selected
     */
    struct CheckTabView : View{
        
        @State var isSelected : Bool = false
        @State var isPresenting : Bool = false
        
        @EnvironmentObject var viewModel : CalendarViewModel
        
        var check : Checkin
        
        var body: some View{

            VStack(alignment: .leading, spacing: 10){
                
                //Initial Stres Object
                HStack{
                    
                    if let satisfaction = Satisfaction_Types(rawValue: Int(check.dayRating)){
                        
                        satisfaction.icon
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .padding(5)
                        
                    } else {
                        
                        Text("Check In")
                        
                    }
                    Text(check.date!.formatted(date: .omitted, time: .shortened))
                        .padding(.leading)
                        .font(.title2)
                        .foregroundColor(.white)
                        .bold()
                    
                    Spacer()

                    //Image("forward_arrow")
                    Button{
                        isPresenting = true
                    } label: {
                        Image(systemName: "arrowtriangle.forward.fill")
                            .resizable()
                            .foregroundColor(isSelected ? .white : .clear)
                            .frame(width: 15, height: 25)
                            .padding(.trailing)
                    }.disabled(!isSelected)
                    //Text(check.date!, style: .time)
                }
                .padding(.vertical, 10)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 80)
                    .background(
                        
                        
                        Theme.MainColor.opacity(1)
                            .cornerRadius(10)
                    )
                    .onTapGesture {
                        withAnimation{
                            isSelected.toggle()
                        }
                    }
                
                if isSelected, let details = viewModel.getStressDetailsFromCheckIn(check) {
                    VStack(spacing: 10){
                        ForEach(details, id: \.self){detail in
                            
                            StressItemView(detail: detail)

                            
                        }
                    }
                }
            }
            .sheet(isPresented: $isPresenting){
                CheckinDetailSummaryView(check: check.toCheckinObject())
            }
        }
    }
    
    
    fileprivate struct CheckinDetailSummaryView : View {
        
        let check : CheckinObject
        
        var body: some View{
            
            
            VStack(alignment: .center, spacing: 0){
                
                Spacer()
                
                VStack{
                    Text("You were ")
                    +
                    Text(check.rating.name)
                        .bold()
                    +
                    Text(" with today")
                    
                    
                    check.rating.icon
                        .resizable()
                    //.scaledToFit()
                        .frame(width: 75, height: 75)
                        .foregroundColor(Theme.MainColor)
                    
                    
                }.padding(.bottom, 20)
                
                
                Spacer()
                
                if(!check.stressDetails.isEmpty){
                    
                    VStack(alignment: .center){
                        Text("Stressors")
                        
                        HStack{
                            
                            
                            Spacer()
                            
                            StressSummaryView(stressor: check.stressDetails[0])
                            
                            
                            
                            
                            if(check.stressDetails.count > 1){
                                
                                StressSummaryView(stressor: check.stressDetails[1])
                                
                            }
                            
                            Spacer()
                            
                        }.padding(.horizontal)
                        
                        
                        
                    }
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: 425
                    )
                    //  .background(.pink)
                    
                    
                }
                Spacer()

            }
            
            
            
        }
    }
    
    fileprivate struct StressItemView : View {
        
        //let detail : StressDetail
        var stressObject : StressManager.StressObject
        
        @State var isSelected : Bool = false
        
        let frameHeight : CGFloat = 80
        
        init(detail : StressDetail){
            self.stressObject = detail.toStressObject()
        }
        
        var body: some View{
            VStack{
                Spacer()
                
                
                HStack(spacing: 10){
                    
                    //Category icon & name
                    VStack(spacing: 5){
                        self.stressObject.category.icon
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(self.stressObject.category == .relationships ? 0.75 : 1)
                            .foregroundColor(.white)
                        
                        
                        Text(self.stressObject.category.rawValue.capitalized)
                        //.font(.title3)
                            .font(Theme.Font(500))
                            .minimumScaleFactor(0.01)
                            .bold()
                            .foregroundColor(.white)
                        
                    }
                    .frame(width: 80, height: frameHeight)

                    Spacer()
                    
                    //Rating
                    HStack{
                        //let rating = detail.rating
                        ForEach(0..<5){i in
                            
                            Image(i < self.stressObject.rating ? "flame_filled" : "flame_not_filled")
                                .resizable()
                                .scaledToFit()

                        }
                    }
                    .frame(height: frameHeight)
                    
                    Spacer()
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: frameHeight)
            //.padding(.vertical, 10)
            .padding(.horizontal)
            .background(
                Theme.MainColor.opacity(0.5)
                    .cornerRadius(10)
            )
            .onTapGesture {
                isSelected = true
            }
            .sheet(isPresented: $isSelected){
                StressDetailSummaryView(stressObject: self.stressObject )
            }
        }
        
    }
    
    fileprivate struct StressDetailSummaryView : View {
        
        let stressObject : StressManager.StressObject

        var body: some View {
            VStack{
                
                Spacer(minLength: 40)
                
                GeometryReader{geo in
                    let width = min(geo.size.width , 250)
                    
                    VStack(spacing: 5){
                        
                        //Category Icon
                        HStack{
                            
                            //stressor.category.icon
                            Text(stressObject.category.name)
                        }
                        .foregroundColor(Theme.DarkGray)
                        .padding(8)
                        .frame(width: width)
                        .overlay(
                            Capsule(style: .circular)
                                .stroke(Theme.DarkGray, lineWidth: 2)
                                .padding(2)//Prevents Cutoff
                        )
                        
                        
                        
                        //Stress Level
                        HStack{
                            ForEach(0..<5){i in
                                Image(i < stressObject.rating ? "flame_filled" : "flame_not_filled")
                                    .resizable()
                                    .scaledToFit()

                            }
                        }.frame(width: width, height: (width/6))
                        
                        
                        
                        Text("Tags:")
                            .foregroundColor(Theme.DarkGray)
                            .padding(.top, 5)
                        
                        
                        let tags = stressObject.getAllTagStringArr()
                        //TODO: Be more specific with vertical axis
                        ScrollView(tags.count > 7 ? .vertical : [],showsIndicators: false){
                            
                            VStack(spacing: 3){
                                ForEach(tags, id: \.self){tag in
                                    Text(tag.capitalized)
                                        .padding(8)
                                        .foregroundColor(Theme.DarkGray)
                                        .frame(width: width)
                                        .overlay(
                                            Capsule(style: .circular)
                                                .stroke(Theme.DeselectedGray, lineWidth: 2)
                                                .padding(2)//Prevents cutoff
                                        )
                                }
                            }
                            
                        }
                        .frame(width: width)
                        
                    }.frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: .top
                    )
                }
                .padding(20)
            }
        }
    }
    
    @ViewBuilder
    func DayView(value : DateValue) -> some View{
        
        VStack{
            let isToday = isSameDay(date1: value.date, date2: viewModel.currentDate)
            
            if value.day != -1 {
                
                Text("\(value.day)")
                    .font(.title3.bold())
                    .foregroundColor(isToday ? .white : .primary)
                    .frame(maxWidth: .infinity)
                
                Spacer()
                
                //Bottom square
                VStack{
                    if let events = viewModel.checkForEventsOnDate(date: value.date), !events.isEmpty{
                        
                        
                        //MARK: Design icons for what happened in date
                        
                        //If there is an episodeBio & not episode...
                        if events.contains(where: {$0.eventType == .episodeBio}){
                            
                            Image(systemName: "exclamationmark.bubble.fill")
                                .foregroundColor(isToday ? .white : .red)
                                .frame(width: 8, height: 8)
                            
                            
                        } else {
                            
                            Circle()
                                .fill(.pink)
                                .frame(width: 8, height: 8)
                            
                        }
                        
                        
                        
                    }

                    
                    
                }
                .frame(height: 10)
                
                
            }
            
        }
        .padding(.vertical, 8)
        .frame(height: 60, alignment: .top)
        
    }
    
    
    // extracting year and month for display
    func extraDate() -> [String]{
        let formatter = DateFormatter()
        
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: viewModel.currentDate)
        return date.components(separatedBy: " ")
    }
    
    func extractDate() -> [DateValue]{
        let calendar = Calendar.current
        
        //getting current month date
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllMonthDates().compactMap{ date -> DateValue in
            
            //getting day ...
            let day = calendar.component(.day, from: date)
            
            return DateValue(day: day, date: date)
            
        }
        
        let firstWeekDay = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekDay - 1{
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
    
    func getCurrentMonth() -> Date{
        let calendar = Calendar.current
        //getting current month date
        
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else { return Date() }
        
        return currentMonth
    }
    
    
}

//Date value model...
struct DateValue : Identifiable{
    var id = UUID().uuidString
    var day : Int
    var date : Date
}

// Extending Date to get current month dates...
extension Date{
    
    func getAllMonthDates() -> [Date] {
        let calendar = Calendar.current
        
        //getting start date
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        //range.removeLast()
        
        return range.compactMap{ day -> Date in
            
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
    //TODO: Test this
    func getAllWeekDates() -> [Date] {
        let calendar = Calendar.current
        
        //getting start date
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .weekOfMonth, for: startDate)!
        
        //range.removeLast()
        
        return range.compactMap{ day -> Date in
            
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            
    }
}
