//
//  TimeLimitMusicPlayerApp.swift
//  TimeLimitMusicPlayer
//
//  Created by Shin Inaba on 2020/11/26.
//

import SwiftUI
import MediaPlayer

@main
struct TimeLimitMusicPlayerApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Music())
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

//        let center = UNUserNotificationCenter.current()
//        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//
//            if let error = error {
//                // Handle the error here.
//                print(error)
//            }
//            if granted == true {
//                print("許可")
//                center.delegate = self
//                center.getNotificationSettings(completionHandler: { setting in
//                    print(setting)
//                })
//            }
//            else {
//                print("非許可")
//            }
//        }
        
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        print(#function)
//        let player: MPMusicPlayerController! = MPMusicPlayerController.systemMusicPlayer
//        player.skipToNextItem()
//    }
}
