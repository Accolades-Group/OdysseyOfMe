//
//  AccountView.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/3/22.
//

import SwiftUI

struct AccountView: View {
    
    @EnvironmentObject var userSettings : UserSettings
    //@StateObject var userSettings = UserSettings()
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 20){
                
                //Profile image

                HStack(alignment: .center){
                    Spacer()
                    //TODO: Check if profile image exists, else:
                    Image("zen")
                        .resizable()
                        .frame(width: 130, height: 130)
                        .clipShape(Circle())
                        .shadow(radius: 4, y: 4)
                        .onTapGesture {
                            //TODO: Upload photo
                        }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 5){
                        
                        Text("\(userSettings.name)")
                            .font(Theme.Font(.title2))

                    }.padding(.top, 10)
                    
                    Spacer()
                    
                }
                .frame(height: 150)
                .padding(.horizontal)
                //End Profile Image
                
                //Account
                
                VStack(alignment: .leading, spacing: 15){

                    SectionHeader(section: .account)
                    
                    //Navigation Buttons
                    NavigationLink(destination: PersonalInfoView()){
                        HStack{
                            Text("Personal")
                                .font(Theme.Font(18))
                            Spacer()
                            Image("forward_arrow")
                                .resizable()
                                .frame(width: 12.5, height: 20)
                                .padding(.trailing)
                        }.foregroundColor(Theme.DarkGray)
                    }.padding(.top, 8)
                    
                    NavigationLink(destination: ProviderInfoView()){
                        HStack{
                            Text("Care Provider")
                                .font(Theme.Font(18))
                            Spacer()
                            Image("forward_arrow")
                                .resizable()
                                .frame(width: 12.5, height: 20)
                                .padding(.trailing)
                        }.foregroundColor(Theme.DarkGray)
                    }.padding(.top, 8)
                    
                    NavigationLink(destination: DiagnosisOverView()){
                        HStack{
                            Text("Medical Info")
                                .font(Theme.Font(18))
                            Spacer()
                            Image("forward_arrow")
                                .resizable()
                                .frame(width: 12.5, height: 20)
                                .padding(.trailing)
                        }.foregroundColor(Theme.DarkGray)
                    }.padding(.top, 8)
                    
                    
                    NavigationLink(destination: AvatarView()){
                        HStack{
                            Text("Avatar")
                                .font(Theme.Font(18))
                            Spacer()
                            Image("forward_arrow")
                                .resizable()
                                .frame(width: 12.5, height: 20)
                                .padding(.trailing)
                        }.foregroundColor(Theme.DarkGray)
                    }.padding(.top, 8)
                    
                    
                }.padding([.top, .horizontal], 20)
                //End Account
                
                //TODO: Put section below on scrollable view that only scrolls if all 3 are selected?
                //NOTE: Watch settings currently deleted. All data will be approved upon user selecting Healthkit settings
                /*
                //Watch Settings
                VStack(alignment: .leading, spacing: 0){
                    
                    SectionHeader(section: .watchSettings)
                    
                    //Episode Tracking
                    HStack{
                        Text("Episode Tracking")
                        Spacer()
                        Toggle(isOn: $userSettings.isEpisodeTracking, label: {})
                    }.font(.system(size: 18))
                        .foregroundColor(Theme.DarkGray)
                        .padding(.vertical, 8)
                    
                    if userSettings.isEpisodeTracking{
                        var isSelected = false
                        
                        //Buttons
                        VStack(alignment: .leading, spacing:  10){
                            
                            Button{
                                isSelected.toggle()
                            } label: {
                                HStack(spacing: 25){
                                    Circle()
                                        .fill(isSelected ? .purple : .clear)
                                        .overlay(Circle().stroke(.purple, lineWidth: 1))
                                    Text("Enter Manually")
                                    
                                }
                            }.frame(height: 25)
                            
                            Button{
                                isSelected.toggle()
                            } label: {
                                HStack(spacing: 25){
                                    Circle()
                                        .fill(isSelected ? .purple : .clear)
                                        .overlay(Circle().stroke(.purple, lineWidth: 1))
                                    
                                    Text("Sync with Health app")
                                }
                            }.frame(height: 25)
                            
                        }
                    }
                    //End Episode Tracking
                    
                    //Exercise Tracking
                    HStack{
                        Text("Exercise Tracking")
                        Spacer()
                        Toggle(isOn: $userSettings.isExerciseTracking, label: {})
                    }.font(.system(size: 18))
                        .foregroundColor(Theme.DarkGray)
                        .padding(.vertical, 8)
                    
                    if userSettings.isExerciseTracking{
                        var isSelected = false
                        
                        //Buttons
                        VStack(alignment: .leading, spacing:  10){
                            
                            Button{
                                isSelected.toggle()
                            } label: {
                                HStack(spacing: 25){
                                    Circle()
                                        .fill(isSelected ? .purple : .clear)
                                        .overlay(Circle().stroke(.purple, lineWidth: 1))
                                    Text("Enter Manually")
                                    
                                }
                            }.frame(height: 25)
                            
                            Button{
                                isSelected.toggle()
                            } label: {
                                HStack(spacing: 25){
                                    Circle()
                                        .fill(isSelected ? .purple : .clear)
                                        .overlay(Circle().stroke(.purple, lineWidth: 1))
                                    
                                    Text("Sync with Health app")
                                }
                            }.frame(height: 25)
                            
                        }
                    }
                    //End Exercise Tracking
                    
                    //Sleep Tracking
                    HStack{
                        Text("Sleep Tracking")
                        Spacer()
                        Toggle(isOn: $userSettings.isSleepTracking, label: {})
                    }.font(.system(size: 18))
                        .foregroundColor(Theme.DarkGray)
                        .padding(.vertical, 8)
                    
                    if userSettings.isSleepTracking{
                        var isSelected = false
                        
                        //Buttons
                        VStack(alignment: .leading, spacing:  10){
                            
                            Button{
                                isSelected.toggle()
                            } label: {
                                HStack(spacing: 25){
                                    Circle()
                                        .fill(isSelected ? .purple : .clear)
                                        .overlay(Circle().stroke(.purple, lineWidth: 1))
                                    Text("Enter Manually")
                                    
                                }
                            }.frame(height: 25)
                            
                            Button{
                                isSelected.toggle()
                            } label: {
                                HStack(spacing: 25){
                                    Circle()
                                        .fill(isSelected ? .purple : .clear)
                                        .overlay(Circle().stroke(.purple, lineWidth: 1))
                                    
                                    Text("Sync with Health app")
                                }
                            }.frame(height: 25)
                            
                        }
                    }
                    //End SleepTracking
                    
                }.padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    
                */
                

                
                //End Watch Settings
                
                Spacer()
                
                
                
            }
        }
    }
}

struct AvatarView : View {
    
    @EnvironmentObject var userSettings : UserSettings
    
    var body: some View{
        VStack{
            Text("Avatar View")
            Text("Work in progress...")
            
        }.navigationTitle("Avatar")
            .padding(.horizontal)
            .padding(.top, 40)
    }
    
}
                    
struct PersonalInfoView : View {
    
    @EnvironmentObject var userSettings : UserSettings
    
    @State var isEmailSelected : Bool = false
    @State var isPhoneSelected : Bool = false
    
    
    var body: some View{
        VStack(spacing: 20){
            
            VStack(spacing: 0){
                SectionHeader(section: .name)
                CustomTextEditButton(placeholder: "Name", editItem: $userSettings.name)
            }
            
            VStack(spacing:0){
                SectionHeader(section: .email)
                CustomTextEditButton(placeholder: "Email", editItem: $userSettings.email)
            }
            
            VStack(spacing: 0){
                SectionHeader(section: .phone)
                CustomTextEditButton(placeholder: "Phone", editItem: $userSettings.phone)
            }
            
            VStack(spacing: 5){
                SectionHeader(section: .birthday)
                ZStack{
                    
                    HStack{
                        Spacer()
                        DatePicker("label", selection: $userSettings.dateOfBirth, displayedComponents: [.date])
                            .datePickerStyle(CompactDatePickerStyle())
                            .scaleEffect(x: 1.2)
                        
                            .labelsHidden()
                    }.padding(.trailing)

                    SectionContentItemLabel(labelText: userSettings.dateOfBirth.formatted(date: .abbreviated, time: .omitted))
                        .userInteractionDisabled()
                    
                    
                }.frame(height: 30)
                
                
            }
            
            Spacer()
            
        }.navigationTitle("Personal")
            .padding(.horizontal, 20)
            .padding(.top, 40)
    }
}

struct ProviderInfoView : View {
    
    @EnvironmentObject var userSettings : UserSettings
    
    var body: some View{
        VStack(spacing: 20){
            
            VStack(spacing: 0){
                SectionHeader(section: .name)
                CustomTextEditButton(placeholder: "Name", editItem: $userSettings.providerName)
            }
            
            VStack(spacing: 0){
                SectionHeader(section: .email)
                CustomTextEditButton(placeholder: "Email", editItem: $userSettings.providerEmail)
            }
            
            VStack(spacing: 0){
                SectionHeader(section: .phone)
                CustomTextEditButton(placeholder: "Phone", editItem: $userSettings.providerPhone)
            }
            
            VStack(spacing: 0){
                SectionHeader(section: .appointmentFrequency)
                SectionContentItemLabel(labelText: "Weekly")
            }
            
            VStack(spacing: 0){
                SectionHeader(section: .therapistCommunication)
                SectionContentItemLabel(labelText: "Send Data")
            }
            
            Spacer()
        }.navigationTitle("Care Provider")
            .padding(.horizontal)
            .padding(.top, 40)
    }
}

//TODO: Combine meds and frequency into single line to share? For multiple different medications
struct DiagnosisIndividualView : View {
    
    var diagnosis : Diagnosis
    
    var body: some View{
        VStack(spacing: 10){
            
            SectionHeader(section: .dateDiagnosed)
            SectionContentItemLabel(labelText: diagnosis.diagnosisDate?.formatted(date: .abbreviated, time: .omitted) ?? "")
            
            SectionHeader(section: .medication)
            ForEach(diagnosis.medications, id: \.self){ med in
                //let label = "\(med.name)"
                SectionContentItemLabel(labelText: med.name)
            }
            
            SectionHeader(section: .medFreq)
            ForEach(diagnosis.medications, id: \.self){ med in
                SectionContentItemLabel(labelText: med.frequency)
            }
            
            SectionHeader(section: .lastChange)
            ForEach(diagnosis.medications, id: \.self){ med in
                SectionContentItemLabel(labelText: med.changeDate?.formatted(date: .abbreviated, time: .omitted) ?? "")
            }
            
            Spacer()
            
            
            
        }.navigationTitle(diagnosis.name)
            .padding(.horizontal)
            .padding(.top, 40)
    }
    
}

struct DiagnosisOverView : View {
    
    @EnvironmentObject var userSettings : UserSettings
    
    @StateObject var diagnosisManager : DiagnosisManager = DiagnosisManager()
    
    @State var isShowingPrompt : Bool = false
    
    var body: some View{
        
        VStack(spacing: 20){
            SectionHeader(section: .currentDiagnoses)
            
            ForEach(diagnosisManager.diagnosis, id: \.self){diagnosis in
                NavigationLink(destination: DiagnosisIndividualView(diagnosis: diagnosis)){
                    
                    SectionContentItemLabel(labelText: diagnosis.name)
                        
                
                }
            }
            
            Spacer()
            
            Text("Demo Mode - Adding Disabled")
                .foregroundColor(isShowingPrompt ? .red : .clear)
            
            Spacer()
            
            Button{
                
                
                Task {
                    isShowingPrompt = true
                    try? await Task.sleep(nanoseconds: 2_500_000_000)
                    isShowingPrompt = false
                }
                
            } label: {
                Text("Add Diagnosis")
            }
            .buttonStyle(RoundedButtonStyle())
            
        }.navigationTitle("Diagnoses")
            .padding(.horizontal)
            .padding(.top, 40)
    }
}

fileprivate enum Sections : String {
    case account, email, phone, birthday, appointmentFrequency = "appointment frequency", watchSettings = "Watch Settings", therapistCommunication = "Therapist Communication", name,
    currentDiagnoses = "Current Diagnoses", dateDiagnosed = "Date Diagnosed", medication, medFreq = "Medication Frequency", lastChange = "Last Changed"
    
    //TODO: Others
    
    var name : String {
        return self.rawValue.capitalized
    }
    
    var iconStr : String {
        switch self{
        case .account: return "manage_account"
        case .email : return "mail"
        case .phone : return "phone"
        case .birthday : return "cake"
        case .appointmentFrequency : return "change-catalog"
        case .therapistCommunication : return "chat"
        case .name : return "badge"
        case .dateDiagnosed : return "time-outlined"
        case .medication : return "medication"
        case .medFreq : return "calendar"
        case .lastChange : return "change-catalog"
        case .currentDiagnoses : return "health-cross"
        default: return "notifications"
        }
    }
    
}

fileprivate struct SectionHeader : View {

    let section : Sections
    
    var body: some View{
        
        VStack(alignment: .leading, spacing: 5){
            HStack(alignment: .bottom){
                
                Image(section.iconStr)
                    .resizable()
                    .frame(width: 30, height: 30)
                
                Text(section.name)
                    .font(Theme.Font(18))
                    .bold()
                
                
                Spacer()
            }
            Rectangle()
                .fill(Theme.MainColor)
                .frame(height: 2)
        }
    }
}

fileprivate struct SectionContentItemLabel : View {
    
    let labelText : String
    
    var body: some View{
        HStack{
            
            Text(labelText)
                .font(Theme.Font(18))
                .foregroundColor(Theme.DarkGray)
            
            Spacer()
            
            Image("forward_arrow")
                .resizable()
                .scaledToFit()
                .padding(5)
            
        }.frame(height: 30)
    }
}

fileprivate struct CustomTextEditButton : View {
    
    let placeholder : String
    @State var localItem : String = ""
    @State var isEditing = false
    @Binding var editItem : String
    
    
    var body: some View{
        GeometryReader{geo in
            
            HStack{
                
                if isEditing || localItem.isEmpty {
                    CustomTextField(
                        placeholder: placeholder,
                        text: $editItem,
                        isEditing: $isEditing,
                        isFirstResponder: isEditing,
                        font: .systemFont(ofSize: 18),
                        autocapitalization: .words,
                        autocorrection: .no,
                        borderStyle: .none
                    )
                } else {
                    
                    Text(localItem)
                        .font(Theme.Font(18))

                    Spacer()
                    
                }
                
                
                if editItem != localItem {
                    Button(action: {
                        //self.name = ""
                        self.isEditing.toggle()
                        self.localItem = editItem
                    }) {
                        Image("check")
                            .resizable()
                            .scaledToFit()
                            .padding(5)
                            
                            
                    }
                }
                else if editItem == localItem {
                    Button(action: {
                        self.isEditing.toggle()
                        
                    }) {
                        Image(self.isEditing ? "close" : "forward_arrow" )
                            .resizable()
                            .scaledToFit()
                            .padding(8)
                            
                        
                    }
                }
                
            }
            
        }
        .frame(height: 40)
        .foregroundColor(Theme.DarkGray)
            .onAppear{
                localItem = editItem
            }
    }
    
}

//TODO: make this work
struct ProfileHeaderView : View {
    
    @State private var image : Image?
    @State private var showSheet = false
    @State private var inputImage : UIImage?
    
    @EnvironmentObject var userSettings : UserSettings
    
    var body: some View{
        
        VStack{
            
            ZStack{
                Color.purple
                Text("Tap to select picture")
                    .foregroundColor(.white)
                    .font(Theme.Font(.headline))

                image?
                    .resizable()
                    .scaledToFit()
                
            }.clipShape(Circle())
                .onTapGesture {
                    showSheet = true
                }

            
        }
        .sheet(isPresented: $showSheet){
            ImagePicker(image: $inputImage)
        }
        .onChange(of: inputImage) { _ in loadImage() }

    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        save()
    }
    
    func save(){
        guard image != nil else { return }
        
        //TODO: Save to documents, so it can load from documents
        let imageID = UUID()
        do{
           // let fileName = getDocumentsDirectory()??
        }
        
    }
}


struct AccountView_Previews: PreviewProvider {
    
    static var previews: some View {
        AccountView()
      //  PersonalInfoView()
       // ProviderInfoView()
      //  DiagnosisOverView()
            .environmentObject(UserSettings())
       // SectionHeader(section: .account)
       // ProfileHeaderView()
    }
}

//MARK: Extensions for date picker to work behind label
fileprivate struct NoHitTesting: ViewModifier {
    func body(content: Content) -> some View {
        SwiftUIWrapper { content }.allowsHitTesting(false)
    }
}

fileprivate extension View {
    func userInteractionDisabled() -> some View {
        self.modifier(NoHitTesting())
    }
}

fileprivate struct SwiftUIWrapper<T: View>: UIViewControllerRepresentable {
    let content: () -> T
    func makeUIViewController(context: Context) -> UIHostingController<T> {
        UIHostingController(rootView: content())
    }
    func updateUIViewController(_ uiViewController: UIHostingController<T>, context: Context) {}
}



//            Image(uiImage: self.inputImage ??)
//                .resizable()
//                .cornerRadius(50)
//                .padding(.all, 4)
//                .frame(width: 100, height: 100)
//                .background(Color.black.opacity(0.2))
//                .aspectRatio(contentMode: .fill)
//                .clipShape(Circle())
//                .padding(8)
//                .onTapGesture {
//                    showSheet = true
//                }
