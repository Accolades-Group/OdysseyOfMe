//
//  AccountView.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/3/22.
//

import SwiftUI

struct AccountView: View {
    var body: some View {
        Rectangle()
        .fill(.green)
        .overlay{
            Text("Account View")
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
