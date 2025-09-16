//
//  SettingTimeView.swift
//  SubwayWhen
//
//  Created by 이윤수 on 9/16/25.
//

import SwiftUI
import ComposableArchitecture

struct SettingTimeView: View {
    @Bindable private var store: StoreOf<SettingFeature>
    
    init(store: StoreOf<SettingFeature>) {
        self.store = store
    }
    
    var body: some View {
        VStack(spacing: ViewStyle.padding.mainStyleViewTB) {
            HStack(spacing: 15) {
                AnimationButtonInSUI(bgColor: Color("MainColor"), btnPadding: 15, buttonView: {
                    self.timeViewCreate(type: .work, text: "9시")
                }, tappedAction: {
                   
                })
                
                AnimationButtonInSUI(bgColor: Color("MainColor"),  btnPadding: 15, buttonView: {
                    self.timeViewCreate(type: .leave, text: "18시")
                }, tappedAction: {
                   
                })
            }
        }
    }
}

#Preview {
    SettingTimeView(store: .init(initialState: .init(), reducer: {SettingFeature()}))
}

private extension SettingTimeView {
    func timeViewCreate(type: SettingFeature.TimeType, text: String) -> some View {
        return VStack(spacing: 15) {
            ExpandedViewInSUI(alignment: .leading) {
                Text(type == .work ? Strings.Setting.workTime : Strings.Setting.leaveTime)
                    .font(.system(size: ViewStyle.FontSize.mediumSize, weight: .medium))
                    .foregroundStyle(Color(uiColor: UIColor.label.withAlphaComponent(0.7)))
                    
            }
            
            Text(text)
                .font(.system(size: ViewStyle.FontSize.bigTitleSize, weight: .bold))
                .foregroundStyle(Color(uiColor: UIColor.label))
        }
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity)
    }
}
