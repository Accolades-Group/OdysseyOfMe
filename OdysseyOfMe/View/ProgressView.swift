//
//  ProgressView.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/15/22.
//

import SwiftUI

struct ProgressView: View {
    
    @StateObject var viewModel : ProgressViewModel = ProgressViewModel()
    
    var body: some View {
        GeometryReader{geo in
            VStack(spacing: 20){
                
                Group{ //Time of day
                    Text("Time of day")
                        .font(Theme.Font(.title2))
                    
                    
                    FlexibleTagView(availableWidth: geo.size.width - 20,
                                    data: StressManager.TimesOfDay.allCases,
                                    spacing: 15,
                                    alignment: .leading){item in
                        
                        VStack{
                            Text(item.name)
                            Text("\(viewModel.getTagOccurance(tag: item.tag, detailCategory: .times))")
                        }
                        
                    }.padding()
                }
                
                Group{//Activities
                    Text("What were you doing?")
                        .font(Theme.Font(.title2))
                    
                    FlexibleTagView(availableWidth: geo.size.width - 20,
                                    data: StressManager.Activites.allCases,
                                    spacing: 15,
                                    alignment: .leading){item in
                        
                        VStack{
                            Text(item.name)
                            Text("\(viewModel.getTagOccurance(tag: item.tag, detailCategory: .activities))")
                        }
                        
                    }.padding()
                }
                
                Group{ //Physical Symptoms
                    Text("What physical symptoms did you experience?")
                        .font(Theme.Font(.title2))
                        .padding(.bottom)
                    
                    FlexibleTagView(availableWidth: geo.size.width - 20,
                                    data: StressManager.PhysicalSymptoms.allCases,
                                    spacing: 15,
                                    alignment: .leading){item in
                        
                        VStack{
                            Text(item.name)
                            Text("\(viewModel.getTagOccurance(tag: item.tag, detailCategory: .physicalSymptoms))")
                        }
                    }
                }
                
                Group{ //Individuals
                    Text("Individuals affecting you:")
                        .font(Theme.Font(.title2))
                        .padding(.bottom)
                    
                    FlexibleTagView(availableWidth: geo.size.width - 20,
                                    data: StressManager.getSampleNames(),
                                    spacing: 15,
                                    alignment: .leading){item in
                        
                        VStack{
                            Text(item)
                            Text("\(viewModel.getTagOccurance(tag: item, detailCategory: .individuals))")
                        }
                    }
                }
                    
//                Group{//Individuals
//                    Text("Individuals who have been influencing you:")
//                        .font(Theme.Font(.title2))
//                        .padding(.bottom)
//
//                    FlexibleTagView(availableWidth: geo.size.width - 20,
//                                    data: StressManager.getSampleNames().allCases,
//                                    spacing: 15,
//                                    alignment: .leading){item in
//
//                        VStack{
//                            Text(item.name)
//                            Text("\(viewModel.getTagOccurance(tag: item.tag, detailCategory: .physicalSymptoms))")
//                        }
//
//                    }.padding()
//                }
                
            }
        }
    }
    
    struct ProgressView_Previews: PreviewProvider {
        static var previews: some View {
            ProgressView()
        }
    }
    
    
    final class ProgressViewModel : ObservableObject{
        
        var stressors : [StressManager.StressObject]
        var checkins : [CheckinObject]
        
        var names : [String] = ["Sam", "Steeve", "Jim", "Susan", "Sarah", "Mike", "Tim", "Kathy"]
        
        init(){
            stressors = []
            checkins = []
            
            let results = StressManager.BuildCheckinObjects(10)
            
            stressors = results.stressors
            checkins = results.checks
            
            
            print("stress cnt: \(stressors.count)")
            print("checks cnt: \(checkins.count)")
            
            
            
            
        }
        
        
        func getTagOccurance(tag : String, detailCategory : StressManager.Details) -> Int {
            
            var count : Int = 0
            switch detailCategory{
                
            case .times:
                stressors.forEach{stress in
                    if stress.times.contains(tag){
                        count += 1
                    }
                }
                
                
            case .activities:
                stressors.forEach{stress in
                    if stress.activities.contains(tag){
                        count += 1
                    }
                }
                
            case .physicalSymptoms:
                stressors.forEach{stress in
                    if stress.symptoms.contains(tag){
                        count += 1
                    }
                }
                
            case .subjectTypes:
                stressors.forEach{stress in
                    if stress.subjectTypes.contains(tag){
                        count += 1
                    }
                }
                
            case .individuals:
                stressors.forEach{stress in
                    if stress.individuals.contains(tag){
                        count += 1
                    }
                }
            }
            
            return count
        }
        
        
    }
    
}
