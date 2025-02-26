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
    var realtimeStationArrival: [TotalRealtimeStationArrival] = []
    var vicinityStationsData: [VicinityTransformData] = []
    var defaultViewListdata: [String] = []
    var searchStationName: [searchStationInfo] = []
    var queryRecoomendList: [SearchQueryRecommendData] = []
    
    init() {}
    
    func scheduleDataFetchAsyncData(searchModel: ScheduleSearch, isDisposable: Bool) async -> [ResultSchdule]  {
        self.resultSchdule
    }
    
    func singleLiveAsyncData(requestModel: DetailArrivalDataRequestModel) async ->[TotalRealtimeStationArrival] {
        self.realtimeStationArrival.filter {$0.upDown == requestModel.upDown && requestModel.line.lineCode == $0.subwayLineData.lineCode && !(requestModel.exceptionLastStation.contains($0.lastStation))}
    }
    
    func vicinityStationsDataLoad(x: Double, y: Double) async -> [VicinityTransformData] {
        self.vicinityStationsData
    }
    
    func defaultViewListLoad() async -> [String] {
        self.defaultViewListdata
    }
    
    func stationNameSearchReponse(_ stationName : String) async -> [searchStationInfo] {
        self.searchStationName.filter {$0.stationName == stationName} // 임시 데이터가 넘어올 때 체크하기 위함
    }
    
    func searchQueryRecommendListLoad() async -> [SearchQueryRecommendData] {
        self.queryRecoomendList
    }
}
