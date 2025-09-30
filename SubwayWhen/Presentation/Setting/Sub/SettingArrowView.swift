//
//  SettingArrowView.swift
//  SubwayWhen
//
//  Created by 이윤수 on 9/17/25.
//

import SwiftUI

struct SettingArrowView: View {
    let title: String
    let tappedAction: () -> Void
    
    var body: some View {
        AnimationButtonInSUI(buttonView: {
            HStack {
                Text(title)
                    .font(.system(size: ViewStyle.FontSize.mediumSize))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .frame(width: 8, height: 12)
                    .foregroundStyle(Color.gray)
            }
            .padding(.horizontal , 10)
            .frame(height: 45)
        }, tappedAction: {
            self.tappedAction()
        })
    }
}

#Preview {
    SettingArrowView(title: "테스트", tappedAction: {})
}
