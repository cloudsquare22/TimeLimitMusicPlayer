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
        print(player.nowPlayingItem?.albumTrackNumber)
        print(player.playbackState.rawValue)
        print("indexOfNowPlayingItem:\(player.indexOfNowPlayingItem)")
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
    
    func updateMediaQuery() {
        self.section = ""
        self.mediaQuery = MPMediaQuery.albums()
        let albumCollections = self.mediaQuery!.collections!
        var minTracks = 6
        if let value = userDefaults.value(forKey: "minTracks") {
            minTracks = value as! Int
        }
        self.collections = albumCollections.filter({collection in collection.items.count > minTracks})
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
        for collection in self.collections {
            print("---------+---------+---------+---------+---------+")
            print(collection.representativeItem?.albumTitle)
            print(collection.representativeItem?.albumArtist)
            print(collection.representativeItem?.title)
            print(collection.representativeItem?.isCloudItem)
        }
    }
    
    func isSection(item: MPMediaItem) -> String {
        var result = ""
        var artist = ""
        if item.albumArtist != nil {
            artist = item.albumArtist!
        }
        else {
            artist = item.artist!
        }
        if section != artist {
            result = artist
            section = artist
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
        self.nowTrack = item.albumTrackNumber
    }
}
