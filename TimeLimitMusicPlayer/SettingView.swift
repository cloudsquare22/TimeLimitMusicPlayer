//
//  SettingView.swift
//  TimeLimitMusicPlayer
//
//  Created by Shin Inaba on 2020/12/05.
//

import SwiftUI

struct SettingView: View {
    @State var minTracks = 6
    @State var iCloud = true
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Stepper(value: self.$minTracks, in: 1...100, step: 1) {
                        Text("Min Tracks")
                        Spacer()
                        Text("\(self.minTracks)")
                    }
                    NumberPlusMinusInputView(title: "Min Tracks",  number: self.$minTracks)
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
