//
//  PlaylistSelectView.swift
//  TimeLimitMusicPlayer
//
//  Created by Shin Inaba on 2020/12/18.
//

import SwiftUI
import MediaPlayer

struct PlaylistSelectView: View {
    @EnvironmentObject var music: Music
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        List {
            Section(header: Text("Playlist")) {
                if self.music.collections.count == 0 {
                    Text("No albums.")
                }
                ForEach(0..<self.music.collections.count) { index in
                    Button(action: {
                        self.music.setCollection(collection: self.music.collections[index])
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        HStack {
                            Image(systemName: "music.note.list")
                            Text(self.music.collections[index].value(forProperty: MPMediaPlaylistPropertyName) as! String)
                        }
                        .padding(.leading)
                    })
                }
            }
        }
    }
}

struct PlaylistSelectView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistSelectView()
            .environmentObject(Music())
    }
}
