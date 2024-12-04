//
//  TestTotalLoadTCADepdency.swift
//  SubwayWhenTests
//
//  Created by 이윤수 on 9/20/24.
//

import Foundation
import ComposableArchitecture

class TestTotalLoadTCADependency: TotalLoadTCADependencyProtocol {
    var resultSchdule: [ResultSchdule] = []
    var realtimeStationArrival: [RealtimeStationArrival] = []
    
    init() {}
    
    func scheduleDataFetchAsyncData(searchModel: ScheduleSearch, isDisposable: Bool) async -> [ResultSchdule]  {
        self.resultSchdule
    }
    
    func singleLiveAsyncData(requestModel: DetailArrivalDataRequestModel) async -> [RealtimeStationArrival] {
        self.realtimeStationArrival
    }
    
    func vicinityStationsDataLoad(x: Double, y: Double) async -> [VicinityTransformData] {
        []
    }
}
