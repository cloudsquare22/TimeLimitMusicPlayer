//
//  ContentView.swift
//  TimeLimitMusicPlayer
//
//  Created by Shin Inaba on 2020/11/26.
//

import SwiftUI


struct ContentView: View {
    @State var min: Double = 45

    var body: some View {
        VStack {
            Text("Min:\(Int(self.min))")
            Slider(value: self.$min, in: 10...90, step: 1)
            Image(systemName: "play.fill")
                .font(.largeTitle)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
