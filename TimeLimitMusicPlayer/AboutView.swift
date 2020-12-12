//
//  AboutView.swift
//  TimeLimitMusicPlayer
//
//  Created by Shin Inaba on 2020/12/05.
//

import SwiftUI

struct AboutView: View {
    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    
    var body: some View {
        VStack {
            Image("tlmp")
                .background(Rectangle()
                                .cornerRadius(45)
                                .foregroundColor(.white))
            Text("Version \(self.version)")
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
