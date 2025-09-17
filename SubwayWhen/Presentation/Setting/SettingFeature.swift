//
//  SettingFeature.swift
//  SubwayWhen
//
//  Created by 이윤수 on 9/16/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SettingFeature {
    @ObservableState
    struct State: Equatable {
        var settingSections: [SettingViewSection] = [
            .init(title: Strings.Setting.homeScreen, cellList: [
                SettingViewCell(title: "", type: .time(FixInfo.saveSetting.mainGroupOneTime, FixInfo.saveSetting.mainGroupTwoTime)),
                SettingViewCell(title: Strings.Setting.workAlarm, type: .newVC),
                SettingViewCell(title: Strings.Setting.trafficLightEmoji, type: .textField(\.mainCongestionLabel))
            ]),
            .init(title: Strings.Setting.detailScreen, cellList: [
                SettingViewCell(title: Strings.Setting.autoRefresh, type: .toggle(\.detailAutoReload)),
                SettingViewCell(title: Strings.Setting.autoSortTimeTable, type: .toggle(\.detailScheduleAutoTime)),
                SettingViewCell(title: Strings.Setting.liveActivity, type: .toggle(\.liveActivity))
            ]),
            .init(title: Strings.Setting.searchScreen, cellList: [
                SettingViewCell(title: Strings.Setting.duplicatePrevention, type: .toggle(\.searchOverlapAlert))
            ]),
            .init(title: Strings.Setting.other, cellList: [
                SettingViewCell(title: Strings.Setting.openLicense, type: .newVC),
                SettingViewCell(title: Strings.Setting.other, type: .newVC)
            ])
        ]
        var selectedTimeViewType: TimeType? = nil
    }
    
    enum Action: Equatable {
        case timeViewTapped(TimeType)
        case timeSaveBtnTapped(Int)
    }
    
    enum TimeType: Equatable {
        case work, leave
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .timeViewTapped(let type):
                state.selectedTimeViewType = type
                return .none
                
            case .timeSaveBtnTapped(let time):
                if state.selectedTimeViewType == .work {
                    FixInfo.saveSetting.mainGroupOneTime = time
                } else {
                    FixInfo.saveSetting.mainGroupTwoTime = time
                }
                // 명시적으로 값 업데이트
                state.settingSections[0].cellList[0] = SettingViewCell(title: "", type: .time(FixInfo.saveSetting.mainGroupOneTime, FixInfo.saveSetting.mainGroupTwoTime))
                state.selectedTimeViewType = nil
                return .none
                
            default: return .none
            }
        }
    }
}
