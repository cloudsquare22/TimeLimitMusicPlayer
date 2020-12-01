//
//  AlbumSelectView.swift
//  TimeLimitMusicPlayer
//
//  Created by Shin Inaba on 2020/12/02.
//

import SwiftUI

struct AlbumSelectView: View {
    @EnvironmentObject var music: Music

    var body: some View {
        List {
            ForEach(0..<self.music.mediaQuery!.collections!.count) { index in
                Text(self.music.mediaQuery!.collections![index].items[0].albumTitle!)
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
