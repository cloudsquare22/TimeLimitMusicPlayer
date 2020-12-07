//
//  SettingView.swift
//  TimeLimitMusicPlayer
//
//  Created by Shin Inaba on 2020/12/05.
//

import SwiftUI

struct SettingView: View {
    @State var minTracks = "6"
    @State var iCloud = true
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("Title")
                        TextField("Min Tracks", text: self.$minTracks)
                        TextField(
                    }
                    HStack {
                        Text("Title")
                        TextField("MinTracks", text: self.$minTracks)
                    }
                    Toggle("Use iCloud", isOn: self.$iCloud)
                }
            }
            .navigationBarTitle("Setting")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
