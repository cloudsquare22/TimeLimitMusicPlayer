//
//  ContentView.swift
//  TimeLimitMusicPlayer
//
//  Created by Shin Inaba on 2020/11/26.
//

import SwiftUI


struct ContentView: View {
    @State private var selection = 2
    @EnvironmentObject var music: Music
    @State var min: Double = 45

    var body: some View {
        TabView(selection: $selection) {
            SettingView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Setting")
                }
                .tag(1)
            VStack {
                SelectAlbumView()
                TimeControlView(min: $min)
                PlayControlView(min: $min)
                NowPlayingView()
            }
            .padding()
            .tabItem {
                VStack {
                    Image(systemName: "music.quarternote.3")
                    Text("Player")
                }
            }
            .tag(2)
            AboutView()
                .tabItem {
                    Image(systemName: "doc")
                    Text("About")
                }
                .tag(3)
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
            Button(action: {
                self.music.play(min: min)
            }, label: {
                Image(systemName: "play.circle.fill")
                    .font(.custom("system", size: 96))
                    .foregroundColor(self.music.collection != nil ? .primary : .gray)
            })
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
    @State var selectPlaylist: Bool = false
    @State var onSheet: Bool = false

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.music.updateMediaQuery(sorted: true, album: false, playlist: true)
                    self.selectPlaylist = true
                    self.onSheet = true
                }, label: {
                    Image(systemName: "music.note.list")
                        .font(.custom("system", size: 96))
                        .foregroundColor(.primary)
                })
                Button(action: {
                    self.music.updateMediaQuery(sorted: true)
                    self.selectAlbum = true
                    self.onSheet = true
                }, label: {
                    Image(systemName: "opticaldisc")
                        .font(.custom("system", size: 96))
                        .foregroundColor(.primary)
                })
                Button(action: {
                    self.music.shuffleAlbum()
                }, label: {
                    ZStack {
                        Image(systemName: "opticaldisc")
                            .font(.custom("system", size: 96))
                            .foregroundColor(.primary)
                        Image(systemName: "shuffle")
                            .font(.custom("system", size: 84))
                            .foregroundColor(.primary)
                    }
                })

            }
            Text(self.music.selectArtistName)
            Text(self.music.selectAlbumTitle)
            Text("All time Min: \(self.music.sumTime / 60)")
        }
        .sheet(isPresented: self.$onSheet, onDismiss: {
            self.selectAlbum = false
            self.selectPlaylist = false
        }) {
            if self.selectAlbum == true {
                AlbumSelectView()
            }
            else if self.selectPlaylist == true {
                PlaylistSelectView()
            }
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
