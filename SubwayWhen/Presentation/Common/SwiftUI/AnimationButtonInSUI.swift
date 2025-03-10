//
//  AnimationButtonInSUI.swift
//  SubwayWhen
//
//  Created by 이윤수 on 12/2/24.
//

import SwiftUI

struct AnimationButtonInSUI<Contents>: View where Contents: View {
    enum alignment {
        case leading
        case center
        case trailing
    }
    
    var bgColor: Color = Color("MainColor")
    var tappedBGColor: Color = Color("ButtonTappedColor")
    var buttonViewAlignment: alignment = .center
    @ViewBuilder let buttonView: () -> Contents
    let tappedAction: () -> Void
    
    @State private var isTapped = false
    
    var body: some View {
        Button(action: {
            self.isTapped = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.tappedAction()
                self.isTapped = false
            }
        }, label: {
            HStack(spacing: 0) {
                if self.buttonViewAlignment != .leading {
                    Spacer()
                }
                self.buttonView()
                if self.buttonViewAlignment != .trailing {
                    Spacer()
                }
            }
            .contentShape(Rectangle())
        })
        .buttonStyle(.plain)
        .padding(.vertical, 10)
        .onLongPressGesture(
            pressing: { isPressing in
                self.isTapped = isPressing
            },
            perform: {}
        )
        .background(
            RoundedRectangle(cornerRadius: ViewStyle.Layer.radius)
                .fill(self.isTapped ? self.tappedBGColor : self.bgColor)
        )
        .scaleEffect(self.isTapped ? ViewStyle.AnimateView.size : 1)
        .animation(.easeInOut(duration: ViewStyle.AnimateView.speed), value: self.isTapped)
    }
}

#Preview {
    AnimationButtonInSUI(bgColor: Color("MainColor"), tappedBGColor: Color("ButtonTappedColor"), buttonViewAlignment: .leading, buttonView: {Text("버튼").foregroundStyle(.black)}) {}
}
