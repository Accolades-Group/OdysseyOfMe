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
            VStack{
                //Profile image
                HStack(alignment: .top){
                    Spacer()
                    //TODO: Check if profile image exists, else:
                    Image("zen")
                        .resizable()
                        .frame(width: 130, height: 130)
                        .clipShape(Circle())
                        .shadow(radius: 4, y: 4)
                        .overlay{
                            //if profile image !exist
                            //   Image(systemName: "pencil")
                        }
                        .onTapGesture {
                            //TODO: Upload photo
                        }
                    
                    Spacer()
                    
                    VStack(spacing: 10){
                        
                        Text("Barbara Jenkins")
                            .font(.title2)
                        
                        Text("Bjenkins@cox.com")
                        
                        
                    }.padding(.top, 10)
                    Spacer()
                    
                }
                .frame(height: 150)
                .padding(.horizontal)
                //End Profile Image
                
                //Account
                VStack(alignment: .leading, spacing: 5){
                    
                    HStack(alignment: .bottom){
                        Image("manage_account")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        Text("Account")
                            .font(.system(size: 18))
                            .bold()
                        
                        
                        Spacer()
                    }
                    
                    Rectangle()
                        .fill(Theme.MainColor)
                        .frame(height: 2)
                    
                    //Navigation Buttons
                    Button{
                        //path.append personal path
                    } label: {
                        HStack{
                            Text("Personal")
                                .font(.system(size: 18))
                            
                            Spacer()
                            Image("forward_arrow")
                                .resizable()
                                .frame(width: 12.5, height: 20)
                                .padding(.trailing)
                            
                        }.foregroundColor(Theme.DarkGray)
                    }.padding(.vertical, 8)
                    
                    Button{
                        //path.append therapist path
                    } label: {
                        HStack{
                            Text("Therapist")
                                .font(.system(size: 18))
                            
                            Spacer()
                            Image("forward_arrow")
                                .resizable()
                                .frame(width: 12.5, height: 20)
                                .padding(.trailing)
                            
                        }.foregroundColor(Theme.DarkGray)
                    }.padding(.vertical, 8)
                    
                    Button{
                        //path.append medication path
                    } label: {
                        HStack{
                            Text("Medication")
                                .font(.system(size: 18))
                            
                            Spacer()
                            Image("forward_arrow")
                                .resizable()
                                .frame(width: 12.5, height: 20)
                                .padding(.trailing)
                            
                        }.foregroundColor(Theme.DarkGray)
                    }.padding(.vertical, 8)
                    
                    
                }.padding([.top, .horizontal], 20)
                //End Account
                
                //TODO: Put section below on scrollable view that only scrolls if all 3 are selected?
                //Watch Settings
                VStack(alignment: .leading, spacing: 5){
                    
                    HStack(alignment: .bottom){
                        Image("notifications")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        Text("Watch Settings")
                            .font(.system(size: 18))
                            .bold()
                        
                        Spacer()
                    }
                    
                    Rectangle()
                        .fill(Theme.MainColor)
                        .frame(height: 2)
                    
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

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
