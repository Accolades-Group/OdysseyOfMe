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

    
    var body: some View {
        
        NavigationStack (path: $viewModel.path) {
            
            VStack{
                //Home view
                CheckinHomeView()
                
                //Checkin button and route
                CheckinButtonRoute()
                
                
                //Avatar button and route
                //AvatarButtonRoute() Move to profile section?
                
            }
            
        }
        .environmentObject(viewModel)
        .onAppear{
            
            viewModel.stressManager.build(stressData: Array(stressHistory))
            viewModel.moc = moc
            
        }
        
    }
    
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
    
    fileprivate struct AvatarButtonRoute : View {
        @EnvironmentObject var viewModel : CheckinViewModel
        var body: some View{
            Button("Avatar"){
                //TODO: Routing
            }.buttonStyle(RoundedButtonStyle())
        }
    }
    

    
    fileprivate struct CheckinRouteBody : View {
        @EnvironmentObject var viewModel : CheckinViewModel
        let route : CheckinViewModel.Routing
        
        var body: some View{
            VStack{
                ProgressBar(pos: route.pos() + 1 , total: route.totalRoutes - 1 )
                
                Text(viewModel.getViewQuestion(route))
                    .font(.system(size: 30))
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
                        GifImage("congratulations")
                        
                    }
                }
                
                Spacer()
                
                Button(route == .summary ? "Submit" : "Continue"){
                    viewModel.continueButton(route)
                }.buttonStyle(RoundedButtonStyle())
                
            }
        }
    }
}




/**
 This is the home view that displays above the checkin button.
 */
fileprivate struct CheckinHomeView : View {
    
    @EnvironmentObject var viewModel : CheckinViewModel
    
    var body : some View {
        VStack{
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
                        .font(.system(size: 18))
                        .bold()
                }
                
            }.frame(height: 120)
            
            Spacer()
            
            HStack{
                ForEach(CheckinViewModel.Satisfaction_Types.allCases, id: \.self){type in
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

            
            Spacer()
            Spacer()


        }
        

    }
}


fileprivate struct RoseThornBudView : View {
    
    @EnvironmentObject var viewModel : CheckinViewModel
    
    var body: some View{
            VStack{
                Spacer()
                //Questions
                VStack{
                    //Rose
                    HStack{
                        
                        Image("rose")
                        
                        Text("What was your favorite part of today?")
                            .font(.system(size: 18))
                        
                    }
                    TextField("Add Note", text: $viewModel.rose)
                        .frame(width: 275, height: 35)
                        .textFieldStyle(.roundedBorder)
                    
                    Spacer()
                    
                    //Thorn
                    HStack{
                        
                        Image("thorn")
                        
                        Text("What was the most challenging part of today?")
                            .font(.system(size: 18))
                        
                    }
                    TextField("Add Note", text: $viewModel.bud)
                        .frame(width: 275, height: 35)
                        .textFieldStyle(.roundedBorder)
                    
                    Spacer()
                    
                    //Bud
                    HStack{
                        
                        Image("bud")
                        
                        Text("What are you most looking forward to?")
                            .font(.system(size: 18))
                        
                    }
                    TextField("Add Note", text: $viewModel.thorn)
                        .frame(width: 275, height: 35)
                        .textFieldStyle(.roundedBorder)
                    
                    Spacer()
                }.frame(height: 400)
                Spacer()
                
        }
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
                                    
                                    TagItemView(item: item, type: .times)
                                    
                                }.padding(.bottom, 5)
                            
                            //Activity Tags
                            Text("What were you doing?")
                            FlexibleTagView(
                                availableWidth: geo.size.width,
                                data: viewModel.stressManager.ActivityTags,
                                spacing: tagSpacing, alignment: .leading){item in
                                    
                                    TagItemView(item: item, type: .activities)
                                    
                                }
                            
                            //Activity Tags
                            Text("What physical symptoms did you experience?")
                            
                            FlexibleTagView(
                                availableWidth: geo.size.width,
                                data: viewModel.stressManager.PhysicalSymptomTags,
                                spacing: tagSpacing, alignment: .leading ){item in
                                    
                                    TagItemView(item: item, type: .physicalSymptoms)
                                    
                                }.padding(.bottom, 5)
                            
                            
                            //Activity Tags
                            
                            Text("Who or what was stressful to you?")
                            
                            FlexibleTagView(
                                availableWidth: geo.size.width,
                                data: viewModel.stressManager.SubjectTypeTags,
                                spacing: tagSpacing, alignment: .leading){item in
                                    
                                    TagItemView(item: item, type: .subjectTypes)
                                    
                                }.padding(.bottom, 5)
                            
                            //Activity Tags
                            Text("Identify the individual)s)")
                            
                            FlexibleTagView(
                                availableWidth: geo.size.width,
                                data: viewModel.stressManager.IndividualsTags,
                                spacing: tagSpacing, alignment: .leading){item in
                                    
                                    TagItemView(item: item, type: .individuals)
                                    
                                }.padding(.bottom, 5)
                            
                            
                            
                        }
                        //.padding(.leading)
                        
                        
                    }
                    
                }//.padding(.trailing)
            }
            .padding(.horizontal, 10)
            
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
        
        Group{
            if String(item) == "+" {
                
                
                
                TextField("Add +", text: $newTag)
                    .submitLabel(.done)
                    .autocorrectionDisabled(true)
                    .font(.system(size: 16))
                    .padding(8)
                    .foregroundColor(color)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(color, lineWidth: 2)
                            .padding(2)
                    )
                    .onSubmit {
                        if !newTag.isEmpty {
                            switch type {
                            case .times:
                                viewModel.stressManager.addTimeTag(newTag)
                                    viewModel.currentStressObject.times.append(newTag)
                                
                            case .activities:
                                viewModel.stressManager.addActivityTag(newTag)
                                   viewModel.currentStressObject.activities.append(newTag)
                                
                                
                            case .physicalSymptoms:
                                viewModel.stressManager.addSymptomTag(newTag)
                                   viewModel.currentStressObject.symptoms.append(newTag)
                                
                            case .subjectTypes:
                                viewModel.stressManager.addSubjectTag(newTag)
                                  viewModel.currentStressObject.subjectTypes.append(newTag)
                                
                            case .individuals:
                                viewModel.stressManager.addIndividualsTag(newTag)
                                   viewModel.currentStressObject.individuals.append(newTag)
                                
                            }
                        }
                        
                             updateColor()
                        
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
                                .padding(2)
                        )
                    
                }
            }
        }.onAppear{
            updateColor()
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
                            
//                            Rectangle()
//                                .fill(Theme.MainColor)
//                                .frame(width: 1)
                            
                            
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
                        Image("fire")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(i < stressor.rating ? .red : Theme.DeselectedGray)
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






struct CheckinView_Previews: PreviewProvider {
    static var previews: some View {
       // CheckinView()
        VStack{
            HowWasYourDayView()
            // StressDetailView()
            // CheckinSummaryView()
            //RoseThornBudView()
            //CheckinView()
            // CongratsView()
                .environmentObject(CheckinViewModel())
            Button("Continue"){
                
            }.buttonStyle(RoundedButtonStyle())
        }
    }
}
