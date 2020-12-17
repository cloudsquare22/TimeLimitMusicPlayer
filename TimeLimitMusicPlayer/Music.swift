//
//  Music.swift
//  TimeLimitMusicPlayer
//
//  Created by Shin Inaba on 2020/11/27.
//

import SwiftUI
import MediaPlayer

final class Music: ObservableObject {
    var player: MPMusicPlayerController! = MPMusicPlayerController.systemMusicPlayer
    var playRatio: Double = 1.0
    var mediaQuery: MPMediaQuery? = nil
    @Published var collections: [MPMediaItemCollection] = []
    @Published var selectAlbumTitle = "-"
    @Published var selectArtistName = "-"
    @Published var albumTitle = "-"
    @Published var artistName = "-"
    @Published var musicTitle = "-"
    @Published var nowTrack = 0
    @Published var albumTrackCount = 0
    @Published var maxTime = 90
    var collection: MPMediaItemCollection? = nil
    var timer: Timer? = nil
    var section: String = ""
    @Published var nowPlay = false
    let userDefaults = UserDefaults.standard
    
    init() {
        self.mediaQuery = MPMediaQuery.albums()
    }
    
    func play(min: Double) {
//        self.mediaQuery = MPMediaQuery.albums()
//        collection = mediaQuery!.collections![1]
        var sumTime: TimeInterval = 0
        for item in collection!.items {
            sumTime = sumTime + item.playbackDuration
        }
        print(sumTime)
        print(collection!.count)
        
        let playTime: TimeInterval = TimeInterval(Int(min) * 60)
        self.playRatio = playTime / sumTime
        if self.playRatio > 1.0 {
            self.playRatio = 1.0
        }
        print("Play Time:\(playTime), Sum Time:\(sumTime), Play Ratio:\(self.playRatio)")
        
        player.setQueue(with: collection!)
        player.play()
        self.nowPlay = true
        UIApplication.shared.isIdleTimerDisabled = true

        print(player.nowPlayingItem!.playbackDuration * self.playRatio)

        self.albumTrackCount = collection!.count
        self.setMusicDate(item: player.nowPlayingItem!)
        self.timer = Timer.scheduledTimer(timeInterval: player.nowPlayingItem!.playbackDuration * playRatio, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: false)
}

    @objc private func timerUpdate() {
        print(#function + " start")
        player.skipToNextItem()
        self.setMusicDate(item: player.nowPlayingItem!)
//        print(player.nowPlayingItem?.albumTrackNumber)
//        print(player.playbackState.rawValue)
//        print("indexOfNowPlayingItem:\(player.indexOfNowPlayingItem)")
        if let t = self.timer {
            t.invalidate()
        }
        if player.playbackState == .stopped || player.playbackState == .paused || player.indexOfNowPlayingItem == 0 {
            print("stopped")
            player.stop()
            self.nowPlay = false
            UIApplication.shared.isIdleTimerDisabled = false
            print(player.playbackState.rawValue)
        }
        else {
            print(player.nowPlayingItem!.playbackDuration * self.playRatio)
            self.timer = Timer.scheduledTimer(timeInterval: player.nowPlayingItem!.playbackDuration * playRatio, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: false)
        }
        print(#function + " end")
    }

    func stop() {
        player.stop()
        self.nowPlay = false
        UIApplication.shared.isIdleTimerDisabled = false
        if let t = self.timer {
            t.invalidate()
        }
    }

    func setCollection(collection: MPMediaItemCollection) {
        self.collection = collection

        if let playlistName = self.collection?.value(forProperty: MPMediaPlaylistPropertyName) as? String {
            print("Playlists")
            self.selectAlbumTitle = playlistName
            self.selectArtistName = "Playlists"
        }
        else {
            self.selectAlbumTitle = collection.representativeItem?.albumTitle ?? "-"
            var artist = ""
            if let albumArtist = collection.representativeItem?.albumArtist {
                artist = albumArtist
            }
            else {
                artist = collection.representativeItem?.artist ?? "-"
            }
            self.selectArtistName = artist
        }
    }
    
    func updateMediaQuery(sorted: Bool, album: Bool = true, playlist: Bool = false) {
        self.section = ""
        let settingData = self.getSettingData()
        var updateCollections: [MPMediaItemCollection] = []
        if album == true {
            self.mediaQuery = MPMediaQuery.albums()
            updateCollections.append(contentsOf: self.mediaQuery!.collections!)
        }
        if playlist == true {
            if settingData.addPlaylists == true {
                self.mediaQuery = MPMediaQuery.playlists()
                updateCollections.append(contentsOf: self.mediaQuery!.collections!)
            }
        }
        self.collections = updateCollections
            .filter({collection in collection.items.count > settingData.minTracks})
            .filter({ collection in
                var result = false
                if settingData.iCloud == true {
                    result = collection.representativeItem?.isCloudItem == true
                }
                return result
            })
        if sorted == true {
            self.sortCollections()
        }
    }
    
    func getSettingData() -> (minTracks: Int, iCloud: Bool, addPlaylists: Bool) {
        var minTracks = 6
        if let value = userDefaults.value(forKey: "minTracks") {
            minTracks = value as! Int
        }
        let iCloud = userDefaults.bool(forKey: "iCloud")
        let addPlaylists = userDefaults.bool(forKey: "addPlaylists")
        return (minTracks, iCloud, addPlaylists)
    }
    
    func sortCollections() {
        self.collections.sort(by: {
            var result = true
            var artist0 = ""
            var artist1 = ""
            if $0.items[0].albumArtist != nil {
                artist0 = $0.items[0].albumArtist!
            }
            else {
                artist0 = $0.items[0].artist!
            }
            if $1.items[0].albumArtist != nil {
                artist1 = $1.items[0].albumArtist!
            }
            else {
                artist1 = $1.items[0].artist!
            }
            if artist0 == artist1 {
                result = $0.items[0].albumTitle! < $1.items[0].albumTitle!
            }
            else {
                result = artist0 < artist1
            }
            return result
        })
    }
    
    func shuffleAlbum() {
        self.updateMediaQuery(sorted: false, album: true, playlist: true)
        if self.collections.count != 0 {
            let select = Int.random(in: 0..<self.collections.count)
            self.setCollection(collection: self.collections[select])
        }
    }
    
    func isSection(item: MPMediaItem) -> String {
//        if let playlistName = item.value(forProperty: MPMediaPlaylistPropertyName) as? String {
//            print("Playlists:\(playlistName)")
//        }
//        else {
//            print("Album")
//        }

        var result = ""
        var artist = ""
        if item.albumArtist != nil {
            artist = item.albumArtist!
        }
        else {
            artist = item.artist!
        }
        if self.section != artist {
            result = artist
            self.section = artist
        }
        return result
    }
    
    func setMusicDate(item: MPMediaItem) {
        self.albumTitle = item.albumTitle ?? "-"
        var artist = ""
        if let albumArtist = item.albumArtist {
            artist = albumArtist
        }
        else {
            artist = item.artist ?? "-"
        }
        self.artistName = artist
        if let musicTitle = item.title {
            self.musicTitle = musicTitle
        }
        self.nowTrack = player.indexOfNowPlayingItem + 1
    }
}
