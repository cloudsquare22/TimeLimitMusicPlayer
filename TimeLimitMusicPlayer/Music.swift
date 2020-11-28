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
        
        player.setQueue(with: collection)
        player.play()

        let content = UNMutableNotificationContent()
        content.title = "Next"
        content.subtitle = "Next"
        content.body = "Next"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
        let request = UNNotificationRequest.init(identifier: "localNotificatoin", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func stop() {
        player.stop()
    }

}
