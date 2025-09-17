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
        let settingSections: [SettingViewSection] = [
            .init(title: Strings.Setting.homeAndSearchScreen, cellList: [
                SettingViewCell(title: "", type: .time),
                SettingViewCell(title: Strings.Setting.workAlarm, type: .newVC),
                SettingViewCell(title: Strings.Setting.trafficLightEmoji, type: .textField),
                SettingViewCell(title: Strings.Setting.duplicatePrevention, type: .toggle)
            ]),
            .init(title: Strings.Setting.detailScreen, cellList: [
                SettingViewCell(title: Strings.Setting.autoRefresh, type: .toggle),
                SettingViewCell(title: Strings.Setting.autoSortTimeTable, type: .toggle),
                SettingViewCell(title: Strings.Setting.liveActivity, type: .toggle)
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
                state.selectedTimeViewType = nil
                return .none
                
            default: return .none
            }
        }
    }
}
