//
//  HistoryView.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/3/22.
//

import SwiftUI

struct HistoryView: View {
    var body: some View {
        Rectangle()
        .fill(.blue)
        .overlay{
            Text("History View")
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
