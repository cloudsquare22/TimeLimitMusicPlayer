//
//  NumberPlusMinusInputView.swift
//  TimeLimitMusicPlayer
//
//  Created by Shin Inaba on 2020/12/08.
//

import SwiftUI

struct NumberPlusMinusInputView: View {
    var title: String? = nil
    @Binding var number: Int
    
    var body: some View {
        HStack {
            if let title = self.title {
                Text(title)
            }
            Spacer()
            Text(String(number))
            Image(systemName: "minus.square.fill")
                .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                    self.number = self.number - 1
                })
                .font(.title)
                .foregroundColor(.blue)
            Image(systemName: "plus.square.fill")
                .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                    self.number = self.number + 1
                })
                .font(.title)
                .foregroundColor(.blue)
        }
    }
}

struct NumberPlusMinusInputView_Previews: PreviewProvider {
    @State static var example = 1
    static var previews: some View {
        NumberPlusMinusInputView(title: "Preview",
                                 number: NumberPlusMinusInputView_Previews.$example)
            .padding()
    }
}
