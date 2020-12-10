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
    let userDefaults = UserDefaults.standard

    var body: some View {
        NavigationView {
            Form {
                Section {
                    NumberPlusMinusInputView(title: "Min Tracks", range: 1...20, step: 1, number: self.$minTracks)
                    Toggle("Use iCloud", isOn: self.$iCloud)
                }
            }
            .navigationBarTitle("Setting")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onDisappear() {
            print("Setting onDisapper")
            userDefaults.set(self.minTracks, forKey: "minTracks")
        }
        .onAppear() {
            print("Setting onApper")
            if let value = userDefaults.value(forKey: "minTracks") {
                self.minTracks = value as! Int
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
