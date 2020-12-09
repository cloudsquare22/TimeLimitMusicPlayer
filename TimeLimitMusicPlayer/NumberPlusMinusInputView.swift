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
            Stepper(value: self.$number, in: 1...100, step: 1, label: {})
                .labelsHidden()
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
