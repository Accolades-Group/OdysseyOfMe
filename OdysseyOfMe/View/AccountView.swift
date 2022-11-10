//
//  AccountView.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/3/22.
//

import SwiftUI

struct AccountView: View {
    
    //@EnvironmentObject var userSettings : UserSettings
    @StateObject var userSettings = UserSettings()
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 20){
                
                //Profile image

                HStack(alignment: .top){
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
                    
                    VStack(spacing: 10){
                        
                        Text("\(userSettings.firstName) \(userSettings.lastName)")
                            .font(.title2)
                        
                        Text("\(userSettings.email)")
                        
                        
                    }.padding(.top, 10)
                    Spacer()
                    
                }
                .frame(height: 150)
                .padding(.horizontal)
                //End Profile Image
                
                //Account
                
                
                VStack(alignment: .leading, spacing: 10){

                    SectionHeader(section: .account)
                    
                    //Navigation Buttons
                    NavigationLink(destination: PersonalInfoView()){
                        HStack{
                            Text("Personal")
                                .font(.system(size: 18))
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
                                .font(.system(size: 18))
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
                                .font(.system(size: 18))
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
                    
                    
                
                

                
                //End Watch Settings
                
                Spacer()
                
                
                
            }
        }
    }
}
                    
struct PersonalInfoView : View {
    
    @EnvironmentObject var userSettings : UserSettings
    
    @State var isEmailSelected : Bool = false
    @State var isPhoneSelected : Bool = false
    
    
    var body: some View{
        VStack(spacing: 20){
            
            SectionHeader(section: .email)
            
            CustomTextEditButton(placeholder: "Email", editItem: $userSettings.email)

            
            SectionHeader(section: .phone)
            
            CustomTextEditButton(placeholder: "Phone", editItem: $userSettings.phone)
//            if isPhoneSelected {
//
//                HStack{
//
//
//                    TextField("Edit Phone", text: $userSettings.phone)
//                        .autocorrectionDisabled()
//                        .textInputAutocapitalization(.never)
//                        .foregroundColor(.black)
//
//
//                    Button{
//                        withAnimation{
//                            isPhoneSelected = false
//                        }
//                    } label: {
//                        Image("check")
//                            .resizable()
//                            .frame(width: 20, height: 20)
//                            .padding(.trailing)
//                    }
//                }
//
//            }
//            else {
//
//                HStack{
//                    Text("\(userSettings.phone)")
//                        .foregroundColor(Theme.DarkGray)
//
//                    Spacer()
//
//                    Button{
//                        withAnimation{
//                            isPhoneSelected = true
//                        }
//                    } label: {
//                        Image("forward_arrow")
//                            .resizable()
//                            .frame(width: 12.5, height: 20)
//                            .padding(.trailing)
//                    }
//                }
//
//            }
            
            SectionHeader(section: .birthday)
            HStack{
                DatePicker(selection: $userSettings.dateOfBirth, in: ...Date(), displayedComponents: .date) {

                }.datePickerStyle(.compact)
                    .frame(width: 100)
                

                
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
            
            SectionHeader(section: .name)
            CustomTextEditButton(placeholder: "Name", editItem: $userSettings.providerName)
            
            SectionHeader(section: .email)
            CustomTextEditButton(placeholder: "Email", editItem: $userSettings.providerEmail)
            
            SectionHeader(section: .phone)
            CustomTextEditButton(placeholder: "Phone", editItem: $userSettings.providerPhone)
            
            SectionHeader(section: .appointmentFrequency)

            
            SectionHeader(section: .therapistCommunication)

            
            Spacer()
        }.navigationTitle("Care Provider")
            .padding(.horizontal)
            .padding(.top, 40)
    }
}
struct DiagnosisIndividualView : View {
    
    var diagnosis : Diagnosis
    
    var body: some View{
        VStack(spacing: 20){
            SectionHeader(section: .dateDiagnosed)
            
            SectionHeader(section: .medication)
            
            SectionHeader(section: .medFreq)
            
            SectionHeader(section: .lastChange)
            
        }.navigationTitle(diagnosis.diagnosisName ?? "Diagnosis")
            .padding(.horizontal)
            .padding(.top, 40)
    }
    
}

struct DiagnosisOverView : View {
    
    @EnvironmentObject var userSettings : UserSettings
    
    var sampleMedHistory : MedicalHistory = buildSampleMedHistory()
    
    var body: some View{
        VStack{
            
            SectionHeader(section: .currentDiagnoses)
            
            
            if let sampleDiagnosis = sampleMedHistory.currentDiagnosis {
                
                ForEach(sampleDiagnosis, id: \.self){diagnosis in
                    
                    NavigationLink(destination: DiagnosisIndividualView(diagnosis: diagnosis)){
                        HStack{
                            Text(diagnosis.diagnosisName ?? "No Name")
                                .font(.system(size: 18))
                            Spacer()
                            Image("forward_arrow")
                                .resizable()
                                .frame(width: 12.5, height: 20)
                                .padding(.trailing)
                        }.foregroundColor(Theme.DarkGray)
                    }.padding(.top, 8)
                    
                    
                }
                
            }
            
            
            Spacer()
        }.navigationTitle("Diagnosis Info")
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
                    .font(.system(size: 18))
                    .bold()
                
                
                Spacer()
            }
            Rectangle()
                .fill(Theme.MainColor)
                .frame(height: 2)
        }
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
                        font: .systemFont(ofSize: 20),
                        autocapitalization: .words,
                        autocorrection: .no,
                        borderStyle: .none
                    )
                } else {
                    
                    Text(localItem)
                        .font(.system(size: 20))
                        
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
        .padding(.horizontal, 20)
            .onAppear{
                localItem = editItem
            }
    }
    
}

/*
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
                    .font(.headline)
                
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
        
        let imageID = UUID()
        do{
            let fileName = getDocumentsD
        }
        
    }
}
*/

struct AccountView_Previews: PreviewProvider {
    
    static var previews: some View {
      //  AccountView()
       // PersonalInfoView()
       // ProviderInfoView()
        DiagnosisOverView()
            .environmentObject(UserSettings())
       // SectionHeader(section: .account)
       // ProfileHeaderView()
    }
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
