//
//  SettingView.swift
//  TimeLimitMusicPlayer
//
//  Created by Shin Inaba on 2020/12/05.
//

import SwiftUI

struct SettingView: View {
    @State var minTracks = 6
    @State var intervalSec = 0
    @State var iCloud = false
    @State var addPlaylists = false
    let userDefaults = UserDefaults.standard

    var body: some View {
        NavigationView {
            Form {
                Section {
                    NumberPlusMinusInputView(title: "Min Tracks", range: 1...20, step: 1, number: self.$minTracks)
                    NumberPlusMinusInputView(title: "Interval Sec", range: 0...5, step: 1, number: self.$intervalSec)
                    Toggle("Use iCloud", isOn: self.$iCloud)
                    Toggle("Add Playlists", isOn: self.$addPlaylists)
                }
            }
            .navigationBarTitle("Setting")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onDisappear() {
            print("Setting onDisapper")
            userDefaults.set(self.minTracks, forKey: "minTracks")
            userDefaults.set(self.intervalSec, forKey: "intervalSec")
            userDefaults.set(self.iCloud, forKey: "iCloud")
            userDefaults.set(self.addPlaylists, forKey: "addPlaylists")
        }
        .onAppear() {
            print("Setting onApper")
            if let value = userDefaults.value(forKey: "minTracks") {
                self.minTracks = value as! Int
            }
            if let value = userDefaults.value(forKey: "intervalSec") {
                self.intervalSec = value as! Int
            }
            self.iCloud = userDefaults.bool(forKey: "iCloud")
            self.addPlaylists = userDefaults.bool(forKey: "addPlaylists")
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
