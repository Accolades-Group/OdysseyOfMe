//
//  CheckinView.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/3/22.
//

import SwiftUI

struct CheckinView: View {
    
    @StateObject var viewModel : CheckinViewModel = CheckinViewModel()
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: []) var stressHistory : FetchedResults<StressDetail>

    @FetchRequest(sortDescriptors: []) var checkinHistory : FetchedResults<Checkin>
    
    
    var body: some View {
        
        NavigationStack (path: $viewModel.path) {
            
            VStack{
                //Home view
                HomeView
                
                //Checkin button and route
                CheckinButton
                    .navigationDestination(for: CheckinViewModel.Routing.self){route in
                        
                        //MARK: Navigation Route Page
                        VStack(spacing: 0){
                            //Progress Bar
                            RouteProgress(route: route)

                            //Body
                            GeometryReader{geo in
                                RouteBody(route: route)
                                    .frame(width: geo.size.width, height: geo.size.height)
                            }
                            
                            //Next button
                            if route != .congratulations {
                                Button(route == .summary ? "Submit" : "Continue"){
                                    viewModel.continueButton(route)
                                }.buttonStyle(RoundedButtonStyle())
                            }
                            
                        }
                        .navigationBarBackButtonHidden(true)
                        .navigationTitle(
                            viewModel.getNavigationTitle(route)
                        )
                        .toolbar{
                            ToolbarItem(placement: .navigationBarLeading){
                                
                                Button{
                                    viewModel.backButton(route)
                                } label: {
                                    BackButtonLabel
                                }
                                
                            }
                        }
                        //TODO: Fix toolbar lag?
                        .toolbar(.hidden, for: .tabBar)

                        
                    }
            }
            
        }
        .environmentObject(viewModel)
        .onAppear{
            
            
            viewModel.stressManager.build(stressData: Array(stressHistory))
            
            viewModel.moc = moc
            
            viewModel.setStreak(checkinHistory: Array(checkinHistory))
            
        }
        
    }
  
}


/**
 This is the first view shown that asks a user to rank their day from 0-5
 */
fileprivate struct HowWasYourDayView : View {

    @EnvironmentObject var viewModel : CheckinViewModel
    
    var body: some View {
        
        VStack{

            Spacer()
            
            VStack(spacing: 20){
                if let type = viewModel.selectedType {
                    type.icon
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.blue)
                    
                    
                    Text(type.name)
                        .font(Theme.Font(18))
                        .bold()
                }
                
            }.frame(height: 120)
            
            Spacer()
            
            HStack{
                ForEach(Satisfaction_Types.allCases, id: \.self){type in
                    Spacer()
                    Button{
                        withAnimation{ //TODO: Keep animation? If so, move to vm
                            viewModel.selectType(type)
                        }
                    }label:{
                        type.icon
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(viewModel.selectedType == type ? .blue : .DimGray)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)

            
            Spacer()
            Spacer()


        }
        

    }
}

//MARK: Body Views
fileprivate struct RoseThornBudView : View {
    
    @EnvironmentObject var viewModel : CheckinViewModel
    
    var body: some View{

        VStack(spacing: 50){
            
            //Rose
            VStack(alignment: .leading){
                
                HStack(spacing: 15){
                    
                    Image("rose")
                        .resizable()
                        .frame(width: 50, height: 50)
                    
                   
                    Text("What was your favorite part of today?")
                        .font(Theme.Font())
                    
                   
                }
                
                TextField("Add Note", text: $viewModel.rose)
                    .textFieldStyle(.roundedBorder)
                    .font(Theme.Font())
                
                
            }
            
            //Thorn
            VStack(alignment: .leading){
                
                HStack(spacing: 15){
                    
                    Image("thorn")
                        .resizable()
                        .frame(width: 50, height: 50)
                    
                    
                    
                    Text("What was the most challenging part of today?")
                      //  .font(Theme.Font())
                    
                    
                }
                
                TextField("Add Note", text: $viewModel.thorn)
                    .textFieldStyle(.roundedBorder)
                    //.font(Theme.Font())
                
                
            }//.background(.yellow.opacity(0.25))
            
            //Bud
            VStack(alignment: .leading){
                
                HStack(spacing: 15){
                    
                    Image("bud")
                        .resizable()
                        .frame(width: 50, height: 50)
                    
                    
                    
                    Text("What are you most looking forward to?")
                        .font(Theme.Font())
                    
                    
                }
                
                TextField("Add Note", text: $viewModel.bud)
                    .textFieldStyle(.roundedBorder)
                    .font(Theme.Font())
                
                
            }

            Spacer()
        }.padding(.top, 40)
            .padding(.horizontal, 50)
        

    }
}

fileprivate struct StressCategorySelectionView : View {
    
    @EnvironmentObject var viewModel : CheckinViewModel
    
    var body: some View{
            VStack{

                Spacer()
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10){
                    
                    
                    ForEach(StressManager.StressCategories.allCases.filter({$0 != .none}), id: \.self){category in
                        
                        let isSelected : Bool = viewModel.stressObjects.contains(where: {$0.category == category})
                        

                        StressCategoryButton(category: category, isSelected: isSelected)
                           //.frame(width: 150, height: 150)
                            .onTapGesture {
                                withAnimation{
                                    viewModel.stressButtonSelected(category)
                                }
                            }
                        
      
                        }
                }.padding(.horizontal, 30)
                    
                    
                Spacer()

            }//.background(.pink)
    }
}

fileprivate struct StressDetailView : View {
    
    @EnvironmentObject var viewModel : CheckinViewModel
    let tagSpacing : CGFloat = 8
    var body: some View {
        
            VStack{
                
                GeometryReader{geo in
                    ScrollView(showsIndicators: false){
                        VStack(alignment: .leading){
                            
                            //Time Tags
                            Text("What time of day?")
                                

                            FlexibleTagView(
                                availableWidth: geo.size.width,
                                data: viewModel.stressManager.TimeTags,
                                spacing: tagSpacing, alignment: .leading){item in
                                    
                                    TagItemView(tag: item, type: .times)
                                    
                                }
                            
                            
                            //Activity Tags
                            Text("What were you doing?")
                                .padding([.top])
                            FlexibleTagView(
                                availableWidth: geo.size.width,
                                data: viewModel.stressManager.ActivityTags,
                                spacing: tagSpacing, alignment: .leading){item in
                                    
                                    TagItemView(tag: item, type: .activities)
                                    
                                }
                            
                            //Activity Tags
                            Text("What physical symptoms did you experience?")
                                .padding([.top])

                            FlexibleTagView(
                                availableWidth: geo.size.width,
                                data: viewModel.stressManager.PhysicalSymptomTags,
                                spacing: tagSpacing, alignment: .leading ){item in
                                    
                                    TagItemView(tag: item, type: .physicalSymptoms)
                                    
                                }
                            
                            
                            //Activity Tags
                            
                            Text("Who or what was stressful to you?")
                                .padding([.top])

                            FlexibleTagView(
                                availableWidth: geo.size.width,
                                data: viewModel.stressManager.SubjectTypeTags,
                                spacing: tagSpacing, alignment: .leading){item in
                                    
                                    TagItemView(tag: item, type: .subjectTypes)
                                    
                                }
                            
                            //Activity Tags
                            Text("Identify the individual(s)")
                                .padding([.top])

                            FlexibleTagView(
                                availableWidth: geo.size.width,
                                data: viewModel.stressManager.IndividualsTags,
                                spacing: tagSpacing, alignment: .leading){item in
                                    
                                    TagItemView(tag: item, type: .individuals)
                                    
                                }
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            
            Spacer()
            
    }
    
}

struct TagItemView : View {
    
    @EnvironmentObject var viewModel : CheckinViewModel
    
    let tag : String
    let type : StressManager.Details
    @State var newTag : String = ""
    @State var isSelected : Bool = false
    
    //TODO: This not working when first adding new tag. Current solution is to not select new tags when they are added
    
    func checkIsSelected() {
        
        switch type {
            
        case .times :  self.isSelected = viewModel.currentStressObject.times.contains(tag.lowercased())
            
        case .activities :  self.isSelected = viewModel.currentStressObject.activities.contains(tag.lowercased())
            
        case .physicalSymptoms : self.isSelected = viewModel.currentStressObject.symptoms.contains(tag.lowercased())
            
        case .subjectTypes : self.isSelected = viewModel.currentStressObject.subjectTypes.contains(tag.lowercased())
            
        case .individuals : self.isSelected = viewModel.currentStressObject.individuals.contains(tag.lowercased())
        }
        
    }
    
    func toggleTag(_ toggleTag : String?) {
        
        let toggle : String = toggleTag ?? tag

        switch type {
        case .times:
            viewModel.currentStressObject.toggleTimes(toggle.lowercased())
        case .activities:
            viewModel.currentStressObject.toggleActivities(toggle.lowercased())
        case .physicalSymptoms:
            viewModel.currentStressObject.toggleSymptoms(toggle.lowercased())
        case .subjectTypes:
            viewModel.currentStressObject.toggleSubjectTypes(toggle.lowercased())
        case .individuals:
            viewModel.currentStressObject.toggleIndividuals(toggle.lowercased())
        }
    }

    var body: some View {
        
        VStack{
            
            if String(tag) == "+" {
                
                TextField("Add +", text: $newTag)
                    .submitLabel(.done)
                    .autocorrectionDisabled(true)
                    .font(Theme.Font(16))
                    .padding(8)
                    .foregroundColor(Theme.DarkGray)
                    .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Theme.DarkGray, lineWidth: 2)
                                .padding(2)
                        )

                    .onSubmit {
                        
                        if !newTag.isEmpty {
                            
                            var success : Bool = false
                            
                            switch type {
                            case .times:
                                success =  viewModel.stressManager.addTimeTag(newTag.lowercased())

                                
                            case .activities:
                                success =  viewModel.stressManager.addActivityTag(newTag.lowercased())

                                
                            case .physicalSymptoms:
                                success =  viewModel.stressManager.addSymptomTag(newTag.lowercased())

                            case .subjectTypes:
                                success =  viewModel.stressManager.addSubjectTag(newTag.lowercased())
                                
                            case .individuals:
                                success =  viewModel.stressManager.addIndividualsTag(newTag.lowercased())
                            }
                            
                            if success {
                                toggleTag(newTag)
                                checkIsSelected()
                            }
                            newTag.removeAll()
                            
                        }
                    }
            }
            
            else {
                
                Button {
                    
                    switch type {
                    case .times:
                        viewModel.currentStressObject.toggleTimes(tag.lowercased())
                    case .activities:
                        viewModel.currentStressObject.toggleActivities(tag.lowercased())
                    case .physicalSymptoms:
                        viewModel.currentStressObject.toggleSymptoms(tag.lowercased())
                    case .subjectTypes:
                        viewModel.currentStressObject.toggleSubjectTypes(tag.lowercased())
                    case .individuals:
                        viewModel.currentStressObject.toggleIndividuals(tag.lowercased())
                    }
                    
                    checkIsSelected()
                    
                    print(isSelected)
                    
                } label: {
                    
                    Text(String(tag).capitalized)

                }.buttonStyle(TagToggleButtonStyle(isSelected: $isSelected))
            }
        }
        .onAppear{
            checkIsSelected()
        }
    }
}

struct StressLevelView : View {
    
    @EnvironmentObject var viewModel : CheckinViewModel
    
    @State var selectedStressVal : Int = 0
    
    var body: some View {
        
            VStack{
                
                Spacer()
                
                HStack{
                    
                    ForEach(1..<6){ i in
                        Spacer()
                        Button{
                            //TODO: Keep animation?
                            withAnimation{
                                if ( selectedStressVal == i){
                                    selectedStressVal = selectedStressVal - 1
                                } else {
                                    selectedStressVal = i
                                }
                                viewModel.currentStressObject.rating = selectedStressVal
                            }
                        }label: {
                            
                            Image(i <= selectedStressVal ? "flame_filled" : "flame_not_filled")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)

                Spacer()
                
            }
            .onAppear{
                selectedStressVal = viewModel.currentStressObject.rating
            }
            
            Spacer()
    }
}

struct CheckinSummaryView : View {
    
    @EnvironmentObject var viewModel : CheckinViewModel
    
    var body: some View {

        VStack(alignment: .center, spacing: 0){
                    
            
            
            if let type = viewModel.selectedType{
                VStack{
                    Text("You were ")
                    +
                    Text(type.name)
                        .bold()
                    +
                    Text(" with today")
                    
                    
                    type.icon
                        .resizable()
                    //.scaledToFit()
                        .frame(width: 75, height: 75)
                        .foregroundColor(Theme.MainColor)
                    
                    
                }.padding(.bottom, 20)
                
            }
            
            
            Spacer()
            
            if(!viewModel.stressObjects.isEmpty){
                VStack(alignment: .center){
                    Text("Stressors")
                    
                    HStack{
                        let stressors = viewModel.stressObjects
                        
                        Spacer()
                        
                        StressSummaryView(stressor: stressors[0])
                        
                        
                        
                        
                        if(stressors.count > 1){
                            
                            
                            StressSummaryView(stressor: stressors[1])
                            
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

            }
            Spacer()


            
        }
        
        
    }
}

struct StressSummaryView : View {
    
    let stressor : StressManager.StressObject

    var body: some View {
        
        GeometryReader{geo in
            let width = min(geo.size.width , 250)
            
            VStack(spacing: 5){
                
                //Category Icon
                HStack{
                    stressor.category.icon
                    Text(stressor.category.rawValue.capitalized)
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
                        Image(i < stressor.rating ?  "flame_filled" : "flame_not_filled")
                            .resizable()
                            .scaledToFit()

                    }
                }.frame(width: width, height: (width/6))
 
                    
                
                Text("Tags:")
                    .foregroundColor(Theme.DarkGray)
                    .padding(.top, 5)
                
                
                let tags = stressor.getAllTagStringArr()
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
    }
}

extension CheckinView {
    

    private var HomeView : some View {
        VStack{
            
            VStack(spacing: 0){
                
                //Image("avatar")
                Image("journey")
                    .resizable()
                    .frame(width: 300, height: 300)
                
                
            }
            .frame(height: 350)
            .padding()
            
            if viewModel.todayStreak > 0 {
                Text("\(viewModel.todayStreak)")
                    .font(Theme.Font(60))
                    .bold()
                
                Text("day streak!")
                    .font(Theme.Font(30))
            }
            
            Spacer()
        }
    }
    
    private var CheckinButton : some View {
        Button("Check-In"){

            if viewModel.path.isEmpty {
                viewModel.path.append(CheckinViewModel.Routing.allCases.first!)
            }
            
        }.buttonStyle(RoundedButtonStyle())
    }
    
    private var BackButtonLabel : some View {
        Image("back_arrow")
            .resizable()
            .frame(width: 12, height: 20)
            .foregroundColor(Theme.DarkGray)
    }
    
    @ViewBuilder
    func RouteProgress(route : CheckinViewModel.Routing) -> some View{
        ProgressBar(pos: route.pos() + 1 , total: route.totalRoutes - 1)
    }
    
    @ViewBuilder
    func RouteBody(route : CheckinViewModel.Routing) -> some View{
        VStack(spacing: 0){
            //Question
            Text(viewModel.getViewQuestion(route))
                .font(Theme.Font(30))
                .bold()
                .multilineTextAlignment(.center)
            
            Spacer()
            //Route view
            switch route {
                
            case .howWasYourDay :
                HowWasYourDayView()
                
            case .roseThornBud :
                RoseThornBudView()
                
            case .stressCategorySelection :
                StressCategorySelectionView()
                
            case .stressDetail :
                StressDetailView()
                
            case .stressLevel :
                StressLevelView()
                
            case .summary :
                CheckinSummaryView()
                
            case .congratulations:
                GifImage("confetti")
                    .task{
                        try? await Task.sleep(nanoseconds: 3_000_000_000)
                        viewModel.resetData()
                        //Pop to root
                        viewModel.path = .init()
                    }
            }
            Spacer()
            
        }
    }
    

}


struct CheckinView_Previews: PreviewProvider {
    static var previews: some View {
        CheckinView()
        
            .environmentObject(CheckinViewModel())
        
    }
}


//MARK: Depreciated Code:
/*
fileprivate struct CheckinButtonRoute : View {
    @EnvironmentObject var viewModel : CheckinViewModel
    var body: some View{
        
        Button("Check-In"){
            
            viewModel.path.append(CheckinViewModel.Routing.howWasYourDay)
            
        }.navigationDestination(for: CheckinViewModel.Routing.self){route in
            VStack(spacing: 0){
                
                CheckinRouteBody(route: route)
                
                
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle(
                viewModel.getNavigationTitle(route)
                
            )
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button{
                        
                        viewModel.backButton(route)
                        
                    } label: {
                        
                        Image("back_arrow")
                            .resizable()
                            .frame(width: 12, height: 20)
                            .foregroundColor(Theme.DarkGray)
                        
                    }
                }
            }
            //TODO: Fix toolbar lag?
            .toolbar(.hidden, for: .tabBar)
            
        }.buttonStyle(RoundedButtonStyle())
    }
}
*/

/*
 fileprivate struct CheckinRouteBody : View {
     @EnvironmentObject var viewModel : CheckinViewModel
     let route : CheckinViewModel.Routing
     
     var body: some View{
         VStack{
             
             Text(viewModel.getViewQuestion(route))
                 .font(Theme.Font(30))
                 .bold()
                 .multilineTextAlignment(.center)
             
             Spacer()
             
             VStack{
                 switch route {
                     
                 case .howWasYourDay :
                     HowWasYourDayView()
                     
                 case .roseThornBud :
                     RoseThornBudView()
                     
                 case .stressCategorySelection :
                     StressCategorySelectionView()
                     
                 case .stressDetail :
                     StressDetailView()
                     
                 case .stressLevel :
                     StressLevelView()
                     
                 case .summary :
                     CheckinSummaryView()
                     
                 case .congratulations:
                     GifImage("confetti")
                         .task{
                             try? await Task.sleep(nanoseconds: 3_000_000_000)
                             viewModel.resetData()
                             //Pop to root
                             viewModel.path = .init()
                         }
                 }
             }
             Spacer()
         }
     }
 }
 */

///**
// This is the home view that displays above the checkin button.
// */
//fileprivate struct CheckinHomeView : View {
//
//    //@EnvironmentObject var viewModel : CheckinViewModel
//
//    var body : some View {
//        VStack{
//
//            VStack(spacing: 0){
//
//                //Image("avatar")
//                Image("journey")
//                    .resizable()
//                    .frame(width: 300, height: 300)
//
//
//            }
//            .frame(height: 350)
//            .padding()
//
//            if viewModel.todayStreak > 0 {
//                Text("\(viewModel.todayStreak)")
//                    .font(Theme.Font(60))
//                    .bold()
//
//                Text("day streak!")
//                    .font(Theme.Font(30))
//            }
//
//            Spacer()
//        }
//    }
//
//}
