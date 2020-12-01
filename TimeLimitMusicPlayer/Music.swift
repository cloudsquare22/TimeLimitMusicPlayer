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
    @Published var mediaQuery: MPMediaQuery? = nil
    
    init() {
        self.mediaQuery = MPMediaQuery.albums()
    }
    
    func play(min: Double) {
        mediaQuery = MPMediaQuery.albums()
        let collection = mediaQuery!.collections![1]
        var sumTime: TimeInterval = 0
        for item in collection.items {
            sumTime = sumTime + item.playbackDuration
        }
        print(sumTime)
        print(collection.count)
        
        let playTime: TimeInterval = TimeInterval(Int(min) * 60)
        print(playTime)
        print(playTime / sumTime)
        playRatio = playTime / sumTime
        
        player.setQueue(with: collection)
        player.play()
        
        print(player.nowPlayingItem!.playbackDuration * playRatio)

        Timer.scheduledTimer(timeInterval: player.nowPlayingItem!.playbackDuration * playRatio, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: false)
        
//        let content = UNMutableNotificationContent()
//        content.title = "Next"
//        content.subtitle = "Next"
//        content.body = "Next"
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
//        let request = UNNotificationRequest.init(identifier: "localNotificatoin", content: content, trigger: trigger)
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    @objc private func timerUpdate() {
        player.skipToNextItem()
        print(player.nowPlayingItem?.albumTrackNumber)
        print(player.playbackState.rawValue)
        print("indexOfNowPlayingItem:\(player.indexOfNowPlayingItem)")
        if player.playbackState == .stopped || player.playbackState == .paused || player.indexOfNowPlayingItem == 0 {
            print("stopped")
            player.stop()
            print(player.playbackState.rawValue)
        }
        else {
            print(player.nowPlayingItem!.playbackDuration * playRatio)
            Timer.scheduledTimer(timeInterval: player.nowPlayingItem!.playbackDuration * playRatio, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: false)
        }
        print(#function + " end")
    }

    func stop() {
        player.stop()
    }

}
