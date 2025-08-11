//
//  ReportFeatureTests.swift
//  SubwayWhenTests
//
//  Created by 이윤수 on 8/11/25.
//

import XCTest
import ComposableArchitecture

@testable import SubwayWhen

final class ReportFeatureTests: XCTestCase {
    
    private let defaultTestLine: SubwayLineData = .three
    private let defaultTestStationName: String = "고속터미널"
    
    func testViewInitWithNoValue() async throws {
        // GIVEN
        let testStore = await self.createStore()
        
        // WHEN
        await testStore.send(.onAppear){ state in
            // THEN -> 뷰가 처음 로드되었을 때 (초기 값 없음)
            state.insertingData = .init() // 초기값은 필수
            state.reportStep = 0 // onAppear 이후 1로 변경 됨
        }
        
        // THEN -> 초기 값이 없을 경우 step을 1로 변경
        await testStore.receive(.reportStepChanged(1)) { state in
            state.reportStep = 1
        }
    }
    
    func testViewInitWithValue() async throws {
        // GIVEN
        let testStore = await self.createStore(line: defaultTestLine, stationName: defaultTestStationName)
        
        // WHEN
        await testStore.send(.onAppear){ state in
            // THEN -> 초기값이 있을 때
            state.insertingData = .init(selectedLine: self.defaultTestLine, nowStation: self.defaultTestStationName)
            state.reportStep = 0 // onAppear 이후 2로 변경 됨
        }
        
        // THEN -> 초기 값이 있을 경우 step을 2로 변경
        await testStore.receive(.reportStepChanged(2)) { state in
            state.reportStep = 2
        }
    }
}

private extension ReportFeatureTests {
    func createStore(line: SubwayLineData? = nil, stationName: String? = nil, exhaustivity: Bool = false) async -> TestStore<ReportFeature.State,  ReportFeature.Action> {
        let store = await TestStore(initialState: ReportFeature.State(selectedLine: line, stationName: stationName), reducer: {
            ReportFeature()
        })
        store.exhaustivity = exhaustivity ? .on : .off(showSkippedAssertions: false)
        return store
    }
}
