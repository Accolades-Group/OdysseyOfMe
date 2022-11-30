//
//  ControlsView.swift
//  OdysseyOfMe Watch App
//
//  Created by Tanner Brown on 11/23/22.
//

import SwiftUI

struct ControlsView: View {

    @EnvironmentObject var episodeManager : EpisodeManager

    var body: some View {
        HStack{
            
            VStack{
                
                Button{
                    episodeManager.cancelEpisode()
                } label: {
                    Image(systemName: "xmark")
                        .padding()
                }
                .tint(.pink)
                .font(.title2)
                
                Text("Cancel")
                
            }
            
            VStack{
                
                Button{
                    episodeManager.endEpisode()
                } label: {
                    Image(systemName: "checkmark")
                        .padding()
                }
                .tint(.green)
                .font(.title2)
                
                Text("End")
                
            }
            
        }
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView()
    }
}
