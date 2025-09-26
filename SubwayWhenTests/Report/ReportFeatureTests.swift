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
    private let defaultTestDestination = "대화행"
    private let defaultTestCarNumber = "1234"
    private let defaultTestMessage = "차내가 덥습니다."
    
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
    
    func testReportLineSelected() async throws {
        // GIVEN
        let testStore = await self.createStore()
        
        // WHEN
        await testStore.send(.onAppear)
        
        // THEN -> 선택에 따른 값 변화
        await testStore.send(.reportLineSelected(self.defaultTestLine)) { state in
            state.insertingData = .init(selectedLine: self.defaultTestLine)
        }
        
        // THEN -> 노선을 선택한 경우 step 변경
        await testStore.receive(.reportStepChanged(2)) { state in
            state.reportStep = 2
        }
    }
    
    func testTwoStepCompletionBrandSelectedLast() async throws  {
        // GIVEN
        let testStore = await self.createStore()
        
        // WHEN
        await testStore.send(.onAppear)
        await testStore.send(.reportLineSelected(self.defaultTestLine))
        
        await testStore.send(.binding(.set(\.insertingData.nowStation, self.defaultTestStationName))) { state in
            // THEN -> 값을 입력한 경우 바로 바인딩 되어야 함
            state.insertingData.nowStation = self.defaultTestStationName
        }
        
        await testStore.send(.binding(.set(\.insertingData.destination, self.defaultTestDestination))) { state in
            // THEN
            state.insertingData.destination = self.defaultTestDestination
        }
        
        await testStore.send(.brandBtnTapped(false)) {state in
            // THEN
            state.insertingData.brand = "N"
        }
        
        // THEN -> brand가 입력된 경우 값을 판단해서 두번째 질문을 마무리 함
        await testStore.receive(.twoStepCompleted)
    }
    
    func testTwoStepCompletionBrandSelectedFirst() async throws  {
        // GIVEN
        let testStore = await self.createStore()
        
        // WHEN
        await testStore.send(.onAppear)
        await testStore.send(.reportLineSelected(self.defaultTestLine))
        
        await testStore.send(.brandBtnTapped(false)) {state in
            // THEN -> 현재역, 행선지 보다 brand를 먼저 입력 시
            state.insertingData.brand = "N"
        }
        
        await testStore.send(.binding(.set(\.insertingData.destination, self.defaultTestDestination))) { state in
            // THEN -> 값을 입력한 경우 바로 바인딩 되어야 함
            state.insertingData.destination = self.defaultTestDestination
        }
        
        await testStore.send(.binding(.set(\.insertingData.nowStation, self.defaultTestStationName))) { state in
            // THEN
            state.insertingData.nowStation = self.defaultTestStationName
        }
        
        // THEN -> brand를 먼저 입력한 경우, 키보드에서 enter 버튼을 누르지 않는 이상
        // 완료 이벤트가 발생하지 않음
        await testStore.finish()
    }
    
    func testThreeStepCompletion() async throws {
        // GIVEN
        let testStore = await self.createStore()
        
        // WHEN
        await testStore.send(.onAppear)
        await testStore.send(.reportLineSelected(self.defaultTestLine))
        try? await Task.sleep(for: .milliseconds(300)) // Step 변경시간 고려
        
        await testStore.send(.twoStepCompleted)
        await testStore.receive(\.reportStepChanged) { state in
            // THEN -> 2 step이 완료된 경우 3 step으로 변경되어야 함
            state.reportStep = 3
        }
        
        await testStore.send(.binding(.set(\.insertingData.trainCar, self.defaultTestCarNumber))) { state in
            // THEN -> 값을 입력한 경우 바로 바인딩 되어야 함
            state.insertingData.trainCar = self.defaultTestCarNumber
        }
        
        // THEN -> 키보드에서 enter 버튼을 누르지 않는 이상 완료 이벤트가 발생하지 않음
        await testStore.finish()
    }
    
    func testThreeStepNoNumberInserted() async throws {
        // GIVEN
        let testStore = await self.createStore()
        
        // WHEN
        await testStore.send(.onAppear)
        await testStore.send(.reportLineSelected(self.defaultTestLine))
        try? await Task.sleep(for: .milliseconds(300)) // Step 변경시간 고려
        
        await testStore.send(.twoStepCompleted)
        try? await Task.sleep(for: .milliseconds(300)) // Step 변경시간 고려
        
        await testStore.send(.canNotThreeStepBtnTapped) { state in
            // THEN -> 확인할 수 없다는 버튼을 누른 경우 팝업창이 떠야함
            XCTAssertNotNil(state.dialogState)
        }
        
        await testStore.send(.dialogAction(.presented(.notInsertBtnTapped)))
        
        // THEN -> 입력하지 않기를 누른 경우 3 step을 마무리함
        await testStore.receive(.threeStepCompleted)
        await testStore.receive(\.reportStepChanged) { state in
            state.reportStep = 4
        }
    }
    
    func testFourStepCompletion() async throws {
        // GIVEN
        let testStore = await self.createStore()
        
        // WHEN
        await testStore.send(.onAppear)
        await testStore.send(.reportLineSelected(self.defaultTestLine)) // 2 step
        try? await Task.sleep(for: .milliseconds(300)) // Step 변경시간 고려
        
        await testStore.send(.binding(.set(\.insertingData.destination, self.defaultTestDestination)))
        await testStore.send(.binding(.set(\.insertingData.nowStation, self.defaultTestStationName)))
        await testStore.send(.brandBtnTapped(false)) // 3 step
        try? await Task.sleep(for: .milliseconds(300)) // Step 변경시간 고려
        
        await testStore.send(.binding(.set(\.insertingData.trainCar, self.defaultTestCarNumber)))
        await testStore.send(.threeStepCompleted) // 4 step
        try? await Task.sleep(for: .milliseconds(300)) // Step 변경시간 고려
        
        await testStore.send(.fourStepCompleted(self.defaultTestMessage)) { state in
            // THEN -> 값을 입력/누른 경우 바로 바인딩 되어야 함
            state.reportStep = 4
            state.insertingData.contants = self.defaultTestMessage
            state.insertingData = .init(selectedLine: self.defaultTestLine, nowStation: self.defaultTestStationName, destination: self.defaultTestDestination, trainCar: self.defaultTestCarNumber, contants: self.defaultTestMessage, brand: "N")
        }
    }
    
    func testFourStepNoInserted() async throws {
        // GIVEN
        let testStore = await self.createStore()
        
        // WHEN
        await testStore.send(.onAppear)
        await testStore.send(.reportLineSelected(self.defaultTestLine)) // 2 step
        try? await Task.sleep(for: .milliseconds(300)) // Step 변경시간 고려
        
        await testStore.send(.binding(.set(\.insertingData.destination, self.defaultTestDestination)))
        await testStore.send(.binding(.set(\.insertingData.nowStation, self.defaultTestStationName)))
        await testStore.send(.brandBtnTapped(false)) // 3 step
        try? await Task.sleep(for: .milliseconds(300)) // Step 변경시간 고려
        
        await testStore.send(.binding(.set(\.insertingData.trainCar, self.defaultTestCarNumber)))
        await testStore.send(.threeStepCompleted) // 4 step
        try? await Task.sleep(for: .milliseconds(300)) // Step 변경시간 고려
        
        // step이 넘어간 이후로 값 제거
        await testStore.send(.binding(.set(\.insertingData.nowStation, "")))
        
        await testStore.send(.fourStepCompleted(self.defaultTestMessage)) { state in
            // THEN -> trainCar 제외 값이 입력되지 않은 경우 팝업이 떠야함
            XCTAssertNotNil(state.dialogState)
        }
        
        await testStore.send(.dialogAction(.presented(.okBtnTapped)))
        await testStore.send(.binding(.set(\.insertingData.nowStation, self.defaultTestStationName)))
        
        await testStore.send(.fourStepCompleted(self.defaultTestMessage)) { state in
            // THEN
            state.reportStep = 4
            state.insertingData = .init(selectedLine: self.defaultTestLine, nowStation: self.defaultTestStationName, destination: self.defaultTestDestination, trainCar: self.defaultTestCarNumber, contants: self.defaultTestMessage, brand: "N")
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
