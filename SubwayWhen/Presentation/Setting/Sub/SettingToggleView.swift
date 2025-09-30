//
//  SettingToggleView.swift
//  SubwayWhen
//
//  Created by 이윤수 on 9/17/25.
//

import SwiftUI

struct SettingToggleView: View {
    let title: String
    @Binding var toggleValue: Bool
    
    var body: some View {
        AnimationButtonInSUI(buttonView: {
            HStack {
                Text(title)
                    .font(.system(size: ViewStyle.FontSize.mediumSize))
                
                Spacer()
                
                Toggle(isOn: self.$toggleValue) {}
                    .tint(Color("AppIconColor"))
            }
            .padding(.horizontal , 10)
            .frame(height: 45)
        }, tappedAction: {
            self.toggleValue.toggle()
        })
    }
}

#Preview {
    @Previewable @State var previewToggle = false
    SettingToggleView(title: "테스트", toggleValue: $previewToggle)
}
