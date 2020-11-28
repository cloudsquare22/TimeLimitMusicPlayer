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
    
    init() {
    }
    
    func play() {
        let mediaQuery = MPMediaQuery.albums()
        let collection = mediaQuery.collections![0]
        var sumTime: TimeInterval = 0
        for item in collection.items {
            sumTime = sumTime + item.playbackDuration
        }
        print(sumTime)
        print(collection.count)
        
        player.setQueue(with: collection)
        player.play()

        Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: false)
        
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
        print(player.playbackState.rawValue)
        if player.playbackState == .stopped || player.playbackState == .paused{
            print("stopped")
            player.stop()
        }
        else {
            Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: false)
        }
    }

    func stop() {
        player.stop()
    }

}
