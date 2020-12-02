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
    var collection: MPMediaItemCollection? = nil
    var timelog = Date()
    var timer: Timer? = nil
    
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
        print(playTime)
        print(playTime / sumTime)
        playRatio = playTime / sumTime
        
        player.setQueue(with: collection!)
        player.play()
        
        print(player.nowPlayingItem!.playbackDuration * playRatio)

        timelog = Date()
        self.timer = Timer.scheduledTimer(timeInterval: player.nowPlayingItem!.playbackDuration * playRatio, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: false)
}

    @objc private func timerUpdate() {
        print(#function + " start")
        player.skipToNextItem()
        print(player.nowPlayingItem?.albumTrackNumber)
        print(player.playbackState.rawValue)
        print("indexOfNowPlayingItem:\(player.indexOfNowPlayingItem)")
        if let t = self.timer {
            t.invalidate()
        }
        if player.playbackState == .stopped || player.playbackState == .paused || player.indexOfNowPlayingItem == 0 {
            print("stopped")
            player.stop()
            print(player.playbackState.rawValue)
        }
        else {
            print(player.nowPlayingItem!.playbackDuration * playRatio)
            print("timelog:\(Date().timeIntervalSince(timelog))")
            self.timer = Timer.scheduledTimer(timeInterval: player.nowPlayingItem!.playbackDuration * playRatio, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: false)
            timelog = Date()
        }
        print(#function + " end")
    }

    func stop() {
        player.stop()
        if let t = self.timer {
            t.invalidate()
        }
    }

    func setCollection(collection: MPMediaItemCollection) {
        self.collection = collection
    }
    
    func updateMediaQuery() {
        self.mediaQuery = MPMediaQuery.albums()
        self.collections = self.mediaQuery!.collections!
        self.collections.sort(by: {
            $0.items[0].albumTitle! < $1.items[0].albumTitle!
        })
        for collection in self.collections {
            print(collection.items[0].albumTitle)
        }
    }
}
