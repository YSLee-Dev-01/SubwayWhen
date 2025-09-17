//
//  SettingTextFieldView.swift
//  SubwayWhen
//
//  Created by 이윤수 on 9/17/25.
//

import SwiftUI

struct SettingTextFieldView: View {
    let title: String
    @Binding var textFieldValue: String
    
    var body: some View {
        MainStyleViewInSUI {
            HStack {
                Text(Strings.Setting.trafficLightEmoji)
                    .font(.system(size: ViewStyle.FontSize.mediumSize))
                
                Spacer()
                
                TextField(text: self.$textFieldValue) {
                    Text(Strings.Setting.emojiLimit)
                }
                .multilineTextAlignment(.trailing)
                .font(.system(size: ViewStyle.FontSize.mediumSize))
                .frame(height: 45)
            }
            .padding(.horizontal, 10)
            .padding(10)
        }
    }
}

#Preview {
    @Previewable @State var previewText = ""
    SettingTextFieldView(title: "테스트", textFieldValue: $previewText)
}
