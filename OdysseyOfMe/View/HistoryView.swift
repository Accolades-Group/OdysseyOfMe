//
//  HistoryView.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/3/22.
//

import SwiftUI

final class CalendarViewModel : ObservableObject{
    
    @Published var currentDate : Date = Date()
    
    func hasCheckin(date : Date, checkIns : [Checkin]) -> Bool {
        
        guard (checkIns.first(where: {isSameDay(date1: $0.date!, date2: date)}) != nil) else {  return false }
        
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
    
}

struct HistoryView: View {

    
    
    @StateObject var viewModel : CalendarViewModel = CalendarViewModel()
    
    @FetchRequest(sortDescriptors: []) var stressHistory : FetchedResults<StressDetail>
    
    @FetchRequest(sortDescriptors: []) var checkinHistory : FetchedResults<Checkin>

    var body: some View {

        ScrollView(.vertical, showsIndicators: false){
            
            VStack(spacing: 20){
                
                //Custom Date Picker
                CustomDatePicker()
                
            }
            .padding(.vertical)
            
            
        }.environmentObject(viewModel)
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
            
            //Daily Events
            VStack(spacing: 15){
                
                Text("Events")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical)
                
                //TODO: For each event
                //Checks
                ForEach(viewModel.getChecksInDate(date: viewModel.currentDate, checkIns: Array(checkinHistory))){ check in
                    
                    var isSelected : Bool = false
                    
                    CheckTabView(check: check)
                    
                }
                
            }
            .padding()
        }
        .onChange(of: currentMonth){newValue in
            viewModel.currentDate = getCurrentMonth()
        }
    }
    
    
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
                                
                                //                            Rectangle()
                                //                                .fill(Theme.MainColor)
                                //                                .frame(width: 1)
                                
                                
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
                //            VStack{}
                //                .frame(
                //                minWidth: 0,
                //                maxWidth: .infinity,
                //                minHeight: 0,
                //                maxHeight: .infinity
                //            )
                //                .background(.yellow)
                
                
                
            }
            
            
            
        }
            
            
        
        
    }
    
    struct StressItemView : View {
        
        let detail : StressDetail
        @State var isSelected : Bool = false
        
        var body: some View{
            VStack{
                Spacer()
                HStack(spacing: 10){
                    
                    if let cat = StressManager.StressCategories(rawValue: detail.category ?? "") {
                        
                        VStack(spacing: 5){
                            cat.icon
                                .resizable()
                                .scaledToFit()
                                .scaleEffect(cat.rawValue.contains("relationships") ? 0.75 : 1)
                                .foregroundColor(.white)
                            
                            
                            Text(cat.rawValue.capitalized)
                                .font(.title3)
                                .bold()
                                .foregroundColor(.white)
                        }
                        
                    }
                    
                    let tags = detail.getAllTagsStringArr()
                    
                    Spacer()
                    
                    HStack{
                        let rating = detail.rating
                        ForEach(0..<5){i in
                            
                            Image("fire")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(i < rating ? .red : .DimGray)
                        }
                    }
                    
                    Spacer()
                    

                    
                    
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 80)
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(
                Theme.MainColor.opacity(0.5)
                    .cornerRadius(10)
            )
            .onTapGesture {
                isSelected = true
            }
            .sheet(isPresented: $isSelected){
                
                StressDetailSummaryView(detail: detail)
                
            }
        }
        
    }
    
    fileprivate struct StressDetailSummaryView : View {
        
        let detail : StressDetail

        var body: some View {
            VStack{
                
                Spacer(minLength: 40)
                
                GeometryReader{geo in
                    let width = min(geo.size.width , 250)
                    let category = StressManager.StressCategories.allCases.first(where: {$0.rawValue == detail.category}) ?? .other
                    VStack(spacing: 5){
                        
                        //Category Icon
                        HStack{
                            
                            //stressor.category.icon
                            Text(category.rawValue.capitalized)
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
                                Image("fire")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(i < detail.rating ? .red : Theme.DeselectedGray)
                            }
                        }.frame(width: width, height: (width/6))
                        
                        
                        
                        Text("Tags:")
                            .foregroundColor(Theme.DarkGray)
                            .padding(.top, 5)
                        
                        
                        let tags = detail.getAllTagStringArr()
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
            
            if value.day != -1 {
                
                
                
                if viewModel.hasCheckin(date: value.date, checkIns: Array(checkinHistory)) {
                    
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: value.date, date2: viewModel.currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    Circle()
                        .fill(.pink)
                        .frame(width: 8, height: 8)
                    
                    
                } else {
                    
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: value.date, date2: viewModel.currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                }
                
                
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
