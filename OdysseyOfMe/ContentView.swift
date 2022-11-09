//
//  ContentView.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/3/22.
//

import SwiftUI

struct ContentView: View {
    
    @FetchRequest(sortDescriptors: []) var stressHistory : FetchedResults<StressDetail>
    
    var body: some View {
        TabNavView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
