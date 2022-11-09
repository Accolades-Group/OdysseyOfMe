//
//  TestingView.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/6/22.
//


import SwiftUI

struct TestingView: View {
    
    @FetchRequest(sortDescriptors: []) var stressHistory : FetchedResults<StressDetail>
    
    @FetchRequest(sortDescriptors: []) var checkinHistory : FetchedResults<Checkin>
    

    @State var stress : StressManager = StressManager()
    
    var body: some View {
        
      //  StressSummaryView()
        
        
        VStack{
            Text("Stressors: \(stressHistory.count)")
            Text("Checkins: \(checkinHistory.count)")
            if let str = stress {

                GeometryReader{geo in
                    VStack{
                        ForEach(checkinHistory){check in
                            
                            Text("Checkin: ") + Text(check.date ?? Date.distantFuture, style: .date)
                            Text("Day Rating (fires): \(check.dayRating)")
                            
                            Divider()
                            
                            ForEach(check.stressorDetails?.allObjects as [StressDetail]){detail in
                                
                                Text("Time(s) of day:")
                                if let times = detail.timesOfDay {
                                    HStack{
                                        ForEach(times, id: \.self){time in
                                            Text(time)
                                        }
                                    }
                                }
                                
                                //if let times = detail.
                                
                                Divider()
                            }
                            
                        }
                        
                        
                        Divider()
                        
                        
                        ForEach(stressHistory){stressor in
                            
                            Text("Rating: \(stressor.rating)")
                            if let checkdate = stressor.checkin?.date {
                                Text("Checkin Date: ") + Text(checkdate, style: .date)
                            }
                            //Text("Checkin date: \(stressor.che)")
                            
                        }
                        
                    }
                }
                
                
            }
            
        }
        .onAppear{
            //TODO: On appear, have view model update stress object
            stress = StressManager(stressData: Array(stressHistory))
        }
         
    }
}



/*
 

struct FlexibleTagView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    
    let availableWidth : CGFloat
    let data : Data
    let vspacing : CGFloat
    let hspacing : CGFloat
    let content: (Data.Element) -> Content
    @State var elementsSize : [Data.Element : CGSize] = [:]
    
    var body: some View{

            VStack(spacing: vspacing){
                
                ForEach(computeRows(), id: \.self){rowElements in
                    
                    HStack(spacing: hspacing){
                        ForEach(rowElements, id: \.self){element in
                            content(element)
                                .fixedSize()
                                .readSize { size in
                                    elementsSize[element] = size
                                }
                        }
                    }
                    
                }
                
            
        }
    }
    func computeRows() -> [[Data.Element]] {
        var rows: [[Data.Element]] = [[]]
        var currentRow = 0
        var remainingWidth = availableWidth
        
        @State var elementsSize: [Data.Element: CGSize] = [:]

        for element in data {
          let elementSize = elementsSize[element, default: CGSize(width: availableWidth, height: 1)]

          if remainingWidth - (elementSize.width + hspacing) >= 0 {
            rows[currentRow].append(element)
          } else {
            currentRow = currentRow + 1
            rows.append([element])
            remainingWidth = availableWidth
          }

          remainingWidth = remainingWidth - (elementSize.width + hspacing)
        }

        return rows
    }
    
}

*/
struct TestingView_Previews: PreviewProvider {
    static var previews: some View {
        TestingView()
    }
}


/*
 //
 //  CheckinView.swift
 //  OdysseyOfMe
 //
 //  Created by Tanner Brown on 11/3/22.
 //

 import SwiftUI

 struct CheckinView: View {
     
     @StateObject var viewModel : CheckinViewModel = CheckinViewModel()
     
     @FetchRequest(sortDescriptors: []) var stressHistory : FetchedResults<StressDetail>

     
     var body: some View {
         
  

         NavigationStack (path: $viewModel.path) {
             
             Rectangle()
                 .fill(Color.ERROR_COLOR)
                 .overlay{
                     Text("Place holder for the avatar image")
                         .foregroundColor(.white)
                         .font(.title3)
                 }.frame(height: 350)
                 .padding()

             Spacer()
             
             Text("Check-in every day to lower stress, build your streak and style your avatar!")
                 .font(.system(size: 25))
                 .multilineTextAlignment(.center)
                 .padding()
             
             Spacer()
             
             Button("Check-In"){
                 
                 viewModel.path.append(CheckinViewModel.Routing.HowWasYourDay)
                 
             }.navigationDestination(for: CheckinViewModel.Routing.self){route in
                 VStack{
                     switch route {
                         
                     case .HowWasYourDay :
                         HowWasYourDayView()
                             
                     case .RoseThornBud :
                         RoseThornBudView()
                         
                     case .StressCategorySelection :
                         StressCategorySelectionView()
                         
                     case .StressDetail :
                         StressDetailView()


                         
                     case .StressLevel :
                         StressLevelView()
                         
                     case .view6 :
                         SummaryView()
                         
                     }
                     
                     Button("Continue"){
                         viewModel.continueButton(route)
                     }.buttonStyle(RoundedButtonStyle())
                     
                 }//.toolbar(.hidden, for: .tabBar)
                 .navigationBarBackButtonHidden(true)
                 .toolbar{
                     ToolbarItem(placement: .navigationBarLeading){
                         Button{
                             
                             if route == .StressDetail {
                                 viewModel.currentStressIndex = max(0, viewModel.currentStressIndex - 1)
                             }
                             
                             viewModel.path.removeLast()
                         } label: {
                             
                             Image("back_arrow")
                                 .resizable()
                                 .frame(width: 12, height: 20)
                                 .foregroundColor(Theme.DarkGray)
                             
                         }
                     }
                     
                 }
                 //TODO: Fix toolbar lag?
                 //.toolbar(.hidden, for: .tabBar)
                     
                 
             }.buttonStyle(RoundedButtonStyle())
                 
             
             
             Button("Avatar"){
                 //TODO: Routing
             }.buttonStyle(RoundedButtonStyle())
         }
         .environmentObject(viewModel)
             .onAppear{
                 viewModel.stressManager = StressManager(stressData: Array(stressHistory))
             }
             
     }
 }

 fileprivate struct HowWasYourDayView : View {
     
     
     @EnvironmentObject var viewModel : CheckinViewModel
     
     var body: some View {
         

         VStack{
             
             ProgressBar(pos: 1, total: 6)
             
             Text("How was your day?")
                 .font(.system(size: 30))
             
             Spacer()
             
             VStack(spacing: 20){
                 if let type = viewModel.selectedType {
                     type.icon
                         .resizable()
                         .frame(width: 100, height: 100)
                         .foregroundColor(.blue)
                     
                     
                     Text(type.name)
                         .font(.system(size: 18))
                         .bold()
                 }
                 
             }.frame(height: 120)
             
             
             
             HStack{
                 ForEach(CheckinViewModel.Satisfaction_Types.allCases, id: \.self){type in
                     Spacer()
                     Button{
                         viewModel.selectType(type)
                     }label:{
                         type.icon
                             .resizable()
                             .frame(width: 60, height: 60)
                             .foregroundColor(viewModel.selectedType == type ? .blue : .DimGray)
                     }
                 }
                 Spacer()
             }
             .padding(.vertical, 75)
             
             Spacer()
             


         }
         

     }
 }


 fileprivate struct RoseThornBudView : View {
     
     @EnvironmentObject var viewModel : CheckinViewModel
     
     var body: some View{
             VStack{
                 
                 ProgressBar(pos: 2, total: 6)
                 
                 Text("Rose, Thorn, and Bud")
                     .font(.system(size: 30))
                 
                 Spacer()
                 
                 //Questions
                 VStack{
                     HStack{
                         
                         Image("rose")
                         
                         Text("What was your favorite part of today?")
                             .font(.system(size: 18))
                         
                     }
                     TextField("Add Note", text: $viewModel.rose)
                         .frame(width: 275, height: 35)
                         .textFieldStyle(.roundedBorder)
                     
                     HStack{
                         
                         Image("thorn")
                         
                         Text("What was your favorite part of today?")
                             .font(.system(size: 18))
                         
                     }
                     TextField("Add Note", text: $viewModel.bud)
                         .frame(width: 275, height: 35)
                         .textFieldStyle(.roundedBorder)
                     
                     HStack{
                         
                         Image("bud")
                         
                         Text("What was your favorite part of today?")
                             .font(.system(size: 18))
                         
                     }
                     TextField("Add Note", text: $viewModel.thorn)
                         .frame(width: 275, height: 35)
                         .textFieldStyle(.roundedBorder)
                 }
                 Spacer()
                 
         }
     }
 }

 fileprivate struct StressCategorySelectionView : View {
     
     @EnvironmentObject var viewModel : CheckinViewModel
     
     var body: some View{
             VStack{
                 
                 ProgressBar(pos: 3, total: 6)
                 
                 Text("Which areas were the most stressful today?")
                     .font(.system(size: 30))
                     .multilineTextAlignment(.center)
                     .padding(20)
                 
                 Spacer()
                 
                 LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10){
                     
                     
                     ForEach(StressManager.StressCategories.allCases.filter({$0 != .none}), id: \.self){category in
                         
                         let isSelected : Bool = viewModel.isStressCategorySelected(category)
                         
                         ZStack{
                             
                             Circle()
                                 .fill(isSelected ? Theme.ButtonColor : Theme.MainColor)
                             
                             VStack{
                                 
                                 category.icon
                                     .resizable()
                                     .scaledToFit()
                                     .foregroundColor(.white)
                                     .padding(.horizontal, isSelected ? 30 : 40)
                                     
                                     
                                 
                                 if !isSelected{
                                     Text(category.rawValue)
                                         .foregroundColor(isSelected ? .clear : .white)
                                 }
                                     
                                 
                             }
                             
                         }.frame(width: 150, height: 150)
                             .onTapGesture {
                                 withAnimation{
                                     viewModel.stressButtonSelected(category)
                                 }
                             }
                         
       
                         }
                 }.padding(.horizontal, 30)
                     
                 Spacer()

         }
     }
     
 }

 //TODO: Fix hacky bug fix where buttons either go to edge of screen on trailing edge, or are cut off on leading edge. Current fix is using .leading and .trailing padding on different views
 fileprivate struct StressDetailView : View {
     
     @EnvironmentObject var viewModel : CheckinViewModel
     
     var body: some View {
         
             VStack{
                 ProgressBar(pos: 4, total: 6)
                 
                 ScrollView(showsIndicators: false){
                 GeometryReader{geo in
                     
                         VStack(alignment: .leading){
                             
                             //Time Tags
                             Text("What time of day?")
                             
                             
                             FlexibleTagView(
                                 availableWidth: geo.size.width,
                                 data: viewModel.stressManager.TimeTags,
                                 spacing: 15){item in
                                     
                                     TagItemView(item: item, type: .times)
                                     
                                 }.padding(.bottom, 5)
                             
                             //Activity Tags
                             Text("What were you doing?")
                             FlexibleTagView(
                                 availableWidth: geo.size.width,
                                 data: viewModel.stressManager.ActivityTags,
                                 spacing: 8){item in
                                     
                                     TagItemView(item: item, type: .activities)
                                     
                                 }
                             
                             //Activity Tags
                             Text("What physical symptoms did you experience?")
                             
                             FlexibleTagView(
                                 availableWidth: geo.size.width,
                                 data: viewModel.stressManager.PhysicalSymptomTags,
                                 spacing: 8 ){item in
                                     
                                     TagItemView(item: item, type: .physicalSymptoms)
                                     
                                 }.padding(.bottom, 5)
                             
                             
                             //Activity Tags
                             
                             Text("Who or what was stressful to you?")
                             
                             FlexibleTagView(
                                 availableWidth: geo.size.width,
                                 data: viewModel.stressManager.SubjectTypeTags,
                                 spacing: 8){item in
                                     
                                     TagItemView(item: item, type: .subjectTypes)
                                     
                                 }.padding(.bottom, 5)
                             
                             //Activity Tags
                             Text("Identify the individual)s)")
                             
                             FlexibleTagView(
                                 availableWidth: geo.size.width,
                                 data: viewModel.stressManager.IndividualsTags,
                                 spacing: 8){item in
                                     
                                     TagItemView(item: item, type: .individuals)
                                     
                                 }.padding(.bottom, 5)
                             
                             
                             
                         }//.padding(.leading)
                         
                         
                     }
                     
                 }//.padding(.trailing)
             }
             
             Spacer()
             
     }
     
 }

 struct TagItemView : View {
     
     @EnvironmentObject var viewModel : CheckinViewModel
     
     let item : String
     let type : StressManager.Details
     @State var newTag : String = ""
     
     @State var color : Color = Theme.DarkGray
     
     //TODO: This not working when first adding new tag. Current solution is to not select new tags when they are added
     func updateColor() {
         
         let tag = newTag.isEmpty ? item : newTag
         
         switch type {
             
             
         case .times:
             color = viewModel.currentStressObject.times.contains(tag) ? Theme.MainColor : Theme.DarkGray
             
         case .activities:
             color = viewModel.currentStressObject.activities.contains(tag) ? Theme.MainColor : Theme.DarkGray
         case .physicalSymptoms:
             color = viewModel.currentStressObject.symptoms.contains(tag) ? Theme.MainColor : Theme.DarkGray
         case .subjectTypes:
            color = viewModel.currentStressObject.subjectTypes.contains(tag) ? Theme.MainColor : Theme.DarkGray
         case .individuals:
             color = viewModel.currentStressObject.individuals.contains(tag) ? Theme.MainColor : Theme.DarkGray
         }
     }
     
     var body: some View {
         
         
         if String(item).contains("+") {
             
             
             
            TextField("Add +", text: $newTag)
                 .submitLabel(.done)
                 .font(.system(size: 16))
                 .padding(8)
                 .foregroundColor(color)
                 .overlay(
                     RoundedRectangle(cornerRadius: 40)
                         .stroke(color, lineWidth: 2)
                 )
                 .onSubmit {
                     switch type {
                     case .times:
                         viewModel.stressManager.addTimeTag(newTag)
                     //    viewModel.currentStressObject.times.append(newTag)
                         
                     case .activities:
                         viewModel.stressManager.addActivityTag(newTag)
                      //   viewModel.currentStressObject.activities.append(newTag)
                         

                     case .physicalSymptoms:
                         viewModel.stressManager.addSymptomTag(newTag)
                      //   viewModel.currentStressObject.symptoms.append(newTag)
                         
                     case .subjectTypes:
                         viewModel.stressManager.addSubjectTag(newTag)
                       //  viewModel.currentStressObject.subjectTypes.append(newTag)

                     case .individuals:
                         viewModel.stressManager.addIndividualsTag(newTag)
                      //   viewModel.currentStressObject.individuals.append(newTag)

                     }

                    
               //      self.updateColor()
                     
                 }
             
         } else {
             
             Button {
                 
                 switch type {
                 case .times:
                     viewModel.currentStressObject.toggleTimes(item)
                 case .activities:
                     viewModel.currentStressObject.toggleActivities(item)
                 case .physicalSymptoms:
                     viewModel.currentStressObject.toggleSymptoms(item)
                 case .subjectTypes:
                     viewModel.currentStressObject.toggleSubjectTypes(item)
                 case .individuals:
                     viewModel.currentStressObject.toggleIndividuals(item)
                 }
                 
                 updateColor()
                 
             } label : {
                 
                 Text(String(item).capitalized)
                     .font(.system(size: 16))
                     .padding(8)
                     .foregroundColor(color)
                     .overlay(
                         RoundedRectangle(cornerRadius: 40)
                             .stroke(color, lineWidth: 2)
                     )
                 
             }
         }
     }
     
 }

 struct ActivityTagItemView : View {
     
     @EnvironmentObject var viewModel : CheckinViewModel
     
     let item : String
     @State var newTag : String = ""
     
     var body: some View {
         
         if String(item) == "+" {
             
            TextField("Add +", text: $newTag)
                 .submitLabel(.done)
                 .font(.system(size: 16))
                 .padding(8)
                 .foregroundColor(viewModel.activities.contains(newTag) ? Theme.MainColor : Theme.DarkGray)
                 .overlay(
                     RoundedRectangle(cornerRadius: 40)
                         .stroke(viewModel.activities.contains(newTag) ? Theme.MainColor : Theme.DarkGray, lineWidth: 2)
                 )
                 .onSubmit {
                     viewModel.stressManager.addActivityTag(newTag)
                     viewModel.activities.append(newTag)
                 }
             
         } else {
             
             Button {
                 viewModel.timeOptionSelected(item)
             } label : {
                 
                 Text(String(item).capitalized)
                     .font(.system(size: 16))
                     .padding(8)
                     .foregroundColor(viewModel.times.contains(item) ? Theme.MainColor : Theme.DarkGray)
                     .overlay(
                         RoundedRectangle(cornerRadius: 40)
                             .stroke(viewModel.times.contains(item) ? Theme.MainColor : Theme.DarkGray, lineWidth: 2)
                     )
                 
             }
         }
     }
     
 }

 struct StressLevelView : View {
     
     @EnvironmentObject var viewModel : CheckinViewModel
     
     @State var selectedStressVal : Int = 0
     
     
     
     var body: some View {
         
             
             VStack{
                 ProgressBar(pos: 5, total: 6)
                 
                 Text("Stress Item Index \(viewModel.currentStressIndex)")
                 
                 Text("How Stressful was this experience?")
                     .font(.system(size: 30))
                     .multilineTextAlignment(.center)
                 
                 Spacer()

                 HStack{
                     
                     ForEach(1..<6){ i in
                         Spacer()
                         Button{
                             
                             if ( selectedStressVal == i){
                                 selectedStressVal = selectedStressVal - 1
                             } else {
                                 selectedStressVal = i
                             }
                             
                         }label: {
                             Image("fire")
                                 .resizable()
                                 .frame(width: 50, height: 50)
                                 .foregroundColor(i <= selectedStressVal ? .red : .DimGray)
                         }
                     }
                     Spacer()
                 }
                 .padding(.horizontal)

                 Spacer()
                 
             }
             
             Spacer()
     }
 }


 struct SummaryView : View {
     
     @EnvironmentObject var viewModel : CheckinViewModel
     
     var body: some View {

             VStack{
                 ProgressBar(pos: 6, total: 6)
                 
                 HStack{
                     Text("Summary View")
                 }
             }
             Spacer()

     }
 }

 struct CheckinView_Previews: PreviewProvider {
     static var previews: some View {
         //CheckinView()
         StressDetailView()
             .environmentObject(CheckinViewModel())
     }
 }

 */
