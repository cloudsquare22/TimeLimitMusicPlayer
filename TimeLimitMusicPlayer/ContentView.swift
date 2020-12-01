//
//  ContentView.swift
//  TimeLimitMusicPlayer
//
//  Created by Shin Inaba on 2020/11/26.
//

import SwiftUI


struct ContentView: View {
    let music: Music = Music()
    @State var min: Double = 45

    var body: some View {
        VStack {
            Text("Min:\(Int(self.min))")
            Slider(value: self.$min, in: 10...90, step: 1)
            Button(action: {
                music.play(min: min)
            }, label: {
                Image("play")
            })
            Button(action: {
                music.stop()
            }, label: {
                Image("stop")
            })
        }
        .padding()
        .onAppear() {
            print(#function)
            print("onAppear()")
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear() {
            print(#function)
            print("onDisappear()")
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
