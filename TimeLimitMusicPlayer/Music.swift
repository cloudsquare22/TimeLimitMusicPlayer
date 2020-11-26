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
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if let error = error {
                // Handle the error here.
                print(error)
            }
            if granted == true {
                print("許可")
//                center.delegate = self
//                center.getNotificationSettings(completionHandler: { setting in
//                    print(setting)
//                })
            }
            else {
                print("非許可")
            }
        }
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
    }
    
    func stop() {
        player.stop()
    }

}
