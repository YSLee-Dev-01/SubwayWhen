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
                SettingViewCell(title: "", type: .time),
                SettingViewCell(title: Strings.Setting.workAlarm, type: .navigation(.notiModal)),
                SettingViewCell(title: Strings.Setting.trafficLightEmoji, type: .textField(\.mainCongestionLabel))
            ]),
            .init(title: Strings.Setting.detailScreen, cellList: [
                SettingViewCell(title: Strings.Setting.autoRefresh, type: .toggle(\.detailAutoReload)),
                SettingViewCell(title: Strings.Setting.autoSortTimeTable, type: .toggle(\.detailScheduleAutoTime)),
                SettingViewCell(title: Strings.Setting.liveActivity, type: .toggle(\.liveActivity)),
                SettingViewCell(title: Strings.Setting.trainIcon, type: .navigation(.trainIcon))
            ]),
            .init(title: Strings.Setting.searchScreen, cellList: [
                SettingViewCell(title: Strings.Setting.duplicatePrevention, type: .toggle(\.searchOverlapAlert))
            ]),
            .init(title: Strings.Setting.other, cellList: [
                SettingViewCell(title: Strings.Setting.openLicense, type: .navigation(.licenseModal)),
                SettingViewCell(title: Strings.Setting.other, type: .navigation(.contentsModal))
            ])
        ]
        var savedSettings: SaveSetting = FixInfo.saveSetting
        var selectedTimeViewType: TimeType? = nil
    }
    
    enum Action: Equatable {
        case timeViewTapped(TimeType)
        case timeSaveBtnTapped(Int)
        case navigationTapped(SettingNewVCType)
        case toggleChanged(WritableKeyPath<SaveSetting, Bool>, Bool)
        case textFieldChanged(WritableKeyPath<SaveSetting, String>, String)
        case updateSavedSettings
    }
    
    enum TimeType: Equatable {
        case work, leave
    }
    
    weak var delegate: SettingVCAction?
    
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
                return .send(.updateSavedSettings)
                
            case .toggleChanged(let keyPath, let value):
                var setting = FixInfo.saveSetting
                setting[keyPath: keyPath] = value
                
                if (keyPath == \SaveSetting.detailScheduleAutoTime && !value) ||
                    (keyPath == \SaveSetting.detailAutoReload && !value){
                    setting.liveActivity = false
                } else if keyPath == \SaveSetting.liveActivity && value {
                    setting.detailScheduleAutoTime = true
                    setting.detailAutoReload = true
                }
                
                FixInfo.saveSetting = setting
                return .send(.updateSavedSettings)
                
            case .textFieldChanged(let keyPath, let value):
                var setting = FixInfo.saveSetting
                setting[keyPath: keyPath] = value
                FixInfo.saveSetting = setting
                return .send(.updateSavedSettings)
                
            case .updateSavedSettings:
                state.savedSettings = FixInfo.saveSetting
                return .none
                
            case .navigationTapped(let type):
                switch type {
                case .groupModal:
                    break // 제거 예정
                case .notiModal:
                    self.delegate?.notiModal()
                case .licenseModal:
                    self.delegate?.licenseModal()
                case .trainIcon:
                    self.delegate?.trainIconModal()
                case .contentsModal:
                    self.delegate?.contentsModal()
                }
                return .none
            }
        }
    }
}
