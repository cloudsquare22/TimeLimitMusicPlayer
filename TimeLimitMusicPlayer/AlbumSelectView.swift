//
//  AlbumSelectView.swift
//  TimeLimitMusicPlayer
//
//  Created by Shin Inaba on 2020/12/02.
//

import SwiftUI

struct AlbumSelectView: View {
    @EnvironmentObject var music: Music
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        List {
            ForEach(0..<self.music.collections.count) { index in
                if let artist = self.music.isSection(item: self.music.collections[index].items[0]), artist != "" {
                    Text(artist)
                }
                Button(action: {
                    self.music.setCollection(collection: self.music.collections[index])
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    HStack {
                        Image(systemName: "opticaldisc")
                        Text(self.music.collections[index].items[0].albumTitle!)
                    }
                    .padding(.leading)
                })
            }
        }
    }
}

struct AlbumSelectView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumSelectView()
            .environmentObject(Music())
    }
}
