//
//  ContentView.swift
//  TimeLimitMusicPlayer
//
//  Created by Shin Inaba on 2020/11/26.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var music: Music
    @State var min: Double = 45

    var body: some View {
        VStack {
            SelectAlbumView()
            TimeControlView(min: $min)
            PlayControlView(min: $min)
            NowPlayingView()
        }
        .padding()
        .onAppear() {
            print(#function)
            print("onAppear()")
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear() {
            print(#function)
            print("onDisappear()")
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Music())
    }
}

struct PlayControlView: View {
    @EnvironmentObject var music: Music
    @Binding var min: Double

    var body: some View {
        HStack {
            if self.music.collection != nil {
                Button(action: {
                    self.music.play(min: min)
                }, label: {
                    Image(systemName: "play.circle.fill")
                        .font(.custom("system", size: 96))
                        .foregroundColor(.primary)
                })
            }
            else {
                Image(systemName: "play.circle.fill")
                    .font(.custom("system", size: 96))
                    .foregroundColor(.gray)
            }
            Button(action: {
                self.music.stop()
            }, label: {
                Image(systemName: "stop.circle.fill")
                    .font(.custom("system", size: 96))
                    .foregroundColor(self.music.nowPlay ? .primary : .gray)
            })
            .disabled(!self.music.nowPlay)
        }
    }
}

struct NowPlayingView: View {
    @EnvironmentObject var music: Music

    var body: some View {
        VStack {
            Text(self.music.artistName)
            Text(self.music.albumTitle)
            Text(self.music.musicTitle)
            Text("\(self.music.nowTrack)/\(self.music.albumTrackCount)")
        }
    }
}

struct SelectAlbumView: View {
    @EnvironmentObject var music: Music
    @State var selectAlbum: Bool = false

    var body: some View {
        VStack {
            Button(action: {
                self.music.updateMediaQuery()
                self.selectAlbum = true
            }, label: {
                Image(systemName: "opticaldisc")
                    .font(.custom("system", size: 96))
                    .foregroundColor(.primary)
            })
            Text(self.music.selectArtistName)
            Text(self.music.selectAlbumTitle)
        }
        .sheet(isPresented: self.$selectAlbum, onDismiss: {}) {
            AlbumSelectView()
        }
    }
}

struct TimeControlView: View {
    @Binding var min: Double

    var body: some View {
        VStack {
            Text("Min:\(Int(self.min))")
            Slider(value: self.$min, in: 10...90, step: 1)
        }
    }
}
