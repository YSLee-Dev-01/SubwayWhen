//
//  TotalLoadTCADependency.swift
//  SubwayWhenNetworking
//
//  Created by 이윤수 on 8/29/24.
//

import Foundation
import RxSwift

class TotalLoadTCADependency: TotalLoadTCADependencyProtocol {
    private var totalModel : TotalLoadProtocol
    private let bag = DisposeBag()
    
    init(totalModel : TotalLoadProtocol = TotalLoadModel()){
        self.totalModel = totalModel
    }
    
    func scheduleDataFetchAsyncData(searchModel: ScheduleSearch, isDisposable: Bool = false)  async -> [ResultSchdule]  {
        var scheduleResult: Observable<[ResultSchdule]>!
        if searchModel.lineScheduleType  == .Korail{
            scheduleResult = self.totalModel.korailSchduleLoad(scheduleSearch: searchModel, isFirst: false, isNow: false, isWidget: false)
        } else if searchModel.lineScheduleType == .Seoul {
            scheduleResult = self.totalModel.seoulScheduleLoad(searchModel, isFirst: false, isNow: false, isWidget: false)
        } else if searchModel.lineScheduleType == .Shinbundang {
            scheduleResult = self.totalModel.shinbundangScheduleLoad(scheduleSearch: searchModel, isFirst: false, isNow: false, isWidget: false, isDisposable: isDisposable)
        } else {
            return [.init(startTime: "정보없음", type: .Unowned, isFast: "", startStation: "", lastStation: "")]
        }
        
        return await withCheckedContinuation { continuation  in
            scheduleResult
                .subscribe(onNext: { data in
                    continuation.resume(returning: data)
                })
                .disposed(by: self.bag)
        }
    }
    
    func singleLiveAsyncData(requestModel: DetailArrivalDataRequestModel) async ->[TotalRealtimeStationArrival] {
        await withCheckedContinuation { continuation  in
            self.totalModel.singleLiveDataLoad(requestModel: requestModel)
                .subscribe(onNext: { data in
                    continuation.resume(returning: data)
                })
                .disposed(by: self.bag)
        }
    }
    
    func vicinityStationsDataLoad(x: Double, y: Double) async -> [VicinityTransformData] {
        await self.totalModel.vicinityStationsDataLoad(x: x, y: y)
    }
    
    func defaultViewListLoad() async -> [String] {
        await self.totalModel.defaultViewListLoad()
    }
    
    func stationNameSearchReponse(_ stationName : String) async -> [searchStationInfo] {
        await self.totalModel.stationNameSearchReponse(stationName)
    }
    
    func searchQueryRecommendListLoad() async -> [SearchQueryRecommendData] {
        await self.totalModel.searchQueryRecommendListLoad()
    }
}
