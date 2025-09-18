//
//  SettingTimeView.swift
//  SubwayWhen
//
//  Created by 이윤수 on 9/16/25.
//

import SwiftUI
import ComposableArchitecture

struct SettingTimeView: View {
    private var store: StoreOf<SettingFeature>
    @State fileprivate var stepperValue = 0
    
    init(store: StoreOf<SettingFeature>) {
        self.store = store
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 15) {
                AnimationButtonInSUI(bgColor: Color("MainColor"), btnPadding: 15, buttonView: {
                    self.timeViewCreate(type: .work, text: "\(self.store.selectedTimeViewType == .work ? self.stepperValue : self.store.savedSettings.mainGroupOneTime)")
                }, tappedAction: {
                    self.stepperValue = self.store.savedSettings.mainGroupOneTime
                    self.store.send(.timeViewTapped(.work))
                })
                
                AnimationButtonInSUI(bgColor: Color("MainColor"),  btnPadding: 15, buttonView: {
                    self.timeViewCreate(type: .leave, text: "\(self.store.selectedTimeViewType == .leave ? self.stepperValue : self.store.savedSettings.mainGroupTwoTime)")
                }, tappedAction: {
                    self.stepperValue = self.store.savedSettings.mainGroupTwoTime
                    self.store.send(.timeViewTapped(.leave))
                })
            }
            
            if let type = self.store.selectedTimeViewType {
                ExpandedViewInSUI(alignment: type == .work ? .leading : .trailing) {
                    Triangle()
                        .frame(width: 27, height: 20)
                        .foregroundStyle(Color("MainColor"))
                        .padding(.horizontal, 20)
                }
                
                MainStyleViewInSUI {
                    self.stepperAndButtonViewCreate(type: type)
                        .padding(20)
                }
            }
        }
    }
}

#Preview {
    SettingTimeView(store: .init(initialState: .init(), reducer: {SettingFeature()}))
}

private extension SettingTimeView {
    @ViewBuilder
    func timeViewCreate(type: SettingFeature.TimeType, text: String) -> some View {
        VStack(spacing: 15) {
            ExpandedViewInSUI(alignment: .leading) {
                Text(type == .work ? Strings.Setting.workTime : Strings.Setting.leaveTime)
                    .font(.system(size: ViewStyle.FontSize.mediumSize, weight: .medium))
                    .foregroundStyle(Color(uiColor: UIColor.label.withAlphaComponent(0.7)))
            }
            
            Text(text == "0" ? "-" : "\(text)\(Strings.Common.hour)")
                .font(.system(size: ViewStyle.FontSize.bigTitleSize, weight: .bold))
                .foregroundStyle(Color(uiColor: UIColor.label))
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 5)
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func stepperAndButtonViewCreate(type: SettingFeature.TimeType) -> some View {
         HStack {
            if type == .work {
                stepperView
                Spacer()
                saveButton
            } else {
                saveButton
                Spacer()
                stepperView
            }
        }
        .id(type)
        .transition(.offset(x: type == .work ? -10 : 10, y : 0).combined(with: .opacity))
    }
    
    private var stepperView: some View {
        Stepper("", value: self.$stepperValue, in: 0...23, step: 1)
            .frame(width: 100, height: 50)
    }

    private var saveButton: some View {
        AnimationButtonInSUI(bgColor: Color("AppIconColor"), tappedBGColor: Color("AppIconColor").opacity(0.7), buttonView: {
            Text(Strings.Common.save)
                .font(.system(size: ViewStyle.FontSize.mediumSize, weight: .semibold))
                .foregroundStyle(.white)
        }, tappedAction: {
            self.store.send(.timeSaveBtnTapped(self.stepperValue))
        })
    }
}
