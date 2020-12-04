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
    @State var selectAlbum = false

    var body: some View {
        VStack {
            Button(action: {
                self.music.updateMediaQuery()
                self.selectAlbum = true
            }, label: {
                Image("cd")
            })
            Text("Min:\(Int(self.min))")
            Slider(value: self.$min, in: 10...90, step: 1)
            HStack {
                if self.music.collection != nil {
                    Button(action: {
                        self.music.play(min: min)
                    }, label: {
                        Image(systemName: "play.circle.fill")
                            .font(.custom("system", size: 96))
                            .foregroundColor(.black)
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
                        .foregroundColor(self.music.nowPlay ? .black : .gray)
                })
                .disabled(!self.music.nowPlay)
            }
            Text(self.music.artistName)
            Text(self.music.albumTitle)
            Text(self.music.musicTitle)
            Text("\(self.music.nowTrack)/\(self.music.albumTrackCount)")
        }
        .padding()
        .sheet(isPresented: self.$selectAlbum, onDismiss: {}) {
            AlbumSelectView()
        }
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
