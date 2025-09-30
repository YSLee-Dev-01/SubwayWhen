//
//  SettingFeatureTests.swift
//  SubwayWhenTests
//
//  Created by 이윤수 on 9/24/25.
//

import Foundation
import XCTest
import ComposableArchitecture

@testable import SubwayWhen

class SettingFeatureTests: XCTestCase {
    
    override func setUp()  {
        FixInfo.saveSetting.detailAutoReload = false
        FixInfo.saveSetting.detailScheduleAutoTime = false
        FixInfo.saveSetting.liveActivity = false
        FixInfo.saveSetting.mainGroupOneTime = 0
        FixInfo.saveSetting.mainGroupTwoTime = 0
        FixInfo.saveSetting.mainCongestionLabel = "0"
    }
    
    func testSettingInit() async throws {
        // GIVEN
        let testStore = await self.createStore()
        
        // WHEN 
        await testStore.send(.onAppear) { state in
            // THEN - View가 처음 로드 되었을 때 (모든 값은 기본 값, 설정 값)
            state.settingSections = [
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
            state.selectedTimeViewType = nil
            state.savedSettings = FixInfo.saveSetting
        }
    }
    
    func testTimeViewTapped() async throws {
        // GIVEN
        let testStore = await self.createStore()
        
        // WHEN
        await testStore.send(.timeViewTapped(.work)) { state in
            // THEN - 타입이 출근으로 변경되어야 함
            state.selectedTimeViewType = .work
        }
        
        await testStore.send(.timeViewTapped(.leave)) { state in
            // THEN - 타입이 퇴근으로 변경되어야 함
            state.selectedTimeViewType = .leave
        }
        
        await testStore.send(.timeSaveBtnTapped(21)) { state in
            // THEN - 타입이 제거 되어야 하며, 퇴근시간은 아직 이전 시간을 유지함 (퇴근시간의 시간이 21시은 다음 이벤트)
            state.selectedTimeViewType = nil
            state.savedSettings.mainGroupTwoTime = 0
        }
        
        await testStore.receive(.updateSavedSettings) { state in
            // THEN - 퇴근시간의 시간이 21시로 업데이트 되어야 함
            state.savedSettings.mainGroupTwoTime = 21
        }
    }
    
    func testToggleChanged() async throws {
        // GIVEN
        let testStore = await self.createStore()
        
        // WHEN
        await testStore.send(.toggleChanged(\.detailAutoReload, true)) { state in
            //THEN - 이벤트가 발생하여도 FixInfo 먼저 업데이트 후 다음 이벤트를 통해 State를 업데이트
            state.savedSettings.detailAutoReload = false
        }
        
        await testStore.receive(.updateSavedSettings) { state in
            // THEN - detailAutoReload가 true로 변경되어 있어야 함
            state.savedSettings.detailAutoReload = true
            state.savedSettings.liveActivity = false
            state.savedSettings.detailScheduleAutoTime = false
        }
        
        await testStore.send(.toggleChanged(\.liveActivity, true))
        await testStore.receive(.updateSavedSettings) { state in
            // THEN - liveActivity가 활성화 된 경우 detailScheduleAutoTime, detailAutoReload도 true로 변경되어야 함
            state.savedSettings.detailAutoReload = true
            state.savedSettings.liveActivity = true
            state.savedSettings.detailScheduleAutoTime = true
        }
    }
    
    func testTextField() async throws {
        // GIVEN
        let testStore = await self.createStore()
        
        // WHEN
        await testStore.send(.textFieldChanged(\.mainCongestionLabel, "1")) { state in
            // THEN - 이벤트가 발생하여도 FinInfo 먼저 업데이트 후 다음 이벤트를 통해 State를 업데이트
            state.savedSettings.mainCongestionLabel = "0"
        }
        
        await testStore.receive(.updateSavedSettings) { state in
            // THEN - mainCongestionLabel이 1로 변경되어 있어야 함
            state.savedSettings.mainCongestionLabel = "1"
        }
        
        // 아무것도 입력하지 않았을 때
        await testStore.send(.textFieldChanged(\.mainCongestionLabel, ""))
        await testStore.receive(.updateSavedSettings) { state in
            // THEN - mainCongestionLabel이 기본 이모티콘으로 변경되어 있어야 함
            state.savedSettings.mainCongestionLabel = "☹️"
        }
    }
}

private extension SettingFeatureTests {
    func createStore() async -> TestStoreOf<SettingFeature> {
        let store = await TestStore(initialState: SettingFeature.State(), reducer: {
            SettingFeature()
        })
        store.exhaustivity = .off(showSkippedAssertions: false)
        return store
    }
}
