//
//  NavigationTest.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/4/22.
//

import SwiftUI

final class NavViewModel : ObservableObject {
    @Published var path = NavigationPath()
    
    @Published var completed : Bool = false
    
    enum Routing : Hashable {
        case view1
        case view2
        case view3
        case view4
        /*
        case HowWasYourDay
        case RoseThornBud
        case StressCategorySelection
        case StressInformation
        */
    }
}

struct NavigationTest: View {
    
    @StateObject var viewModel = NavViewModel()
    
    var body: some View {

        NavigationStack (path: $viewModel.path) {
            
            Text("check complete : \(viewModel.completed.description)")
            
            Button("Go view 1"){
                viewModel.path.append(NavViewModel.Routing.view1)
            }.navigationDestination(for: NavViewModel.Routing.self){route in
                
                switch route {
                    
                case .view1 :
                    TestView1()
                case .view2 :
                    TestView2()
                    
                case .view3 : TestView3()
                    
                case .view4 : TestView4()
                    
                
                }
                
            }
            
        }.environmentObject(viewModel)
        /*
        NavigationStack(path: $viewModel.path){
            VStack{
                
                Spacer()
                Text("This is the home view")
                Spacer()
                
                NavigationLink("Go to view 2", destination: TestView2())
                Spacer()
                
            }.environmentObject(viewModel)
            
            /*
            .navigationDestination(for: String.self){ string in
                VStack{
                    Text(string)
                 
                    Button("Navigate to XYZ"){
                        viewModel.path.append("XYZ")
                    }
                    
                    Button("Pop to root"){
                        viewModel.path = .init()
                    }
                }
        }
        */
               
        }
        */
        
    }
}

struct TestView1 : View {
    @EnvironmentObject var viewModel : NavViewModel
    var body: some View {
        
        VStack{
            Spacer()
            Text("This is view 1")
            Spacer()
            Button("View 2"){
                viewModel.path.append(NavViewModel.Routing.view2)
            }
            Spacer()
        }
        
    }
}

struct TestView2 : View {
    @EnvironmentObject var viewModel : NavViewModel
    var body: some View {
        
        VStack{
            Spacer()
            Text("This is view 2")
            Spacer()
            Button("View 3"){
                viewModel.path.append(NavViewModel.Routing.view3)
            }
            Spacer()
        }
        
    }
}


struct TestView3 : View {
    @EnvironmentObject var viewModel : NavViewModel
    var body: some View {
        
        VStack{
            Spacer()
            Text("This is view 3")
            Spacer()
            Button("View 4"){
                viewModel.path.append(NavViewModel.Routing.view4)
            }
            Spacer()
        }
        
    }
}

struct TestView4 : View {
    @EnvironmentObject var viewModel : NavViewModel
    var body: some View {
        
        VStack{
            Spacer()
            Text("This is view 4")
            
            Button("Check complete"){
                viewModel.completed = true
            }
            
            Spacer()
            Button("Pop to root"){
                viewModel.path = .init()
            }
            Spacer()
        }
        
    }
}



struct NavigationTest_Previews: PreviewProvider {
    static var previews: some View {
        NavigationTest()
    }
}
