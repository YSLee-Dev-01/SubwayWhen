//
//  MockLoadModel.swift
//  SubwayWhenTests
//
//  Created by 이윤수 on 11/17/25.
//

import Foundation
import RxSwift

@testable import SubwayWhen

class MockLoadModel: LoadModelProtocol {
    
    private var successData: Any!
    private var error: URLError!
    private var korailTrainNumber: [KorailTrainNumber] = []
    
    func stationArrivalRequest(stationName: String) -> RxSwift.Single<Result<SubwayWhen.LiveStationModel, URLError>> {
        return self.toObservableResult()
            .asSingle()
    }
    
    func seoulStationScheduleLoad(scheduleSearch: SubwayWhen.ScheduleSearch) -> RxSwift.Single<Result<SubwayWhen.ScheduleStationModel, URLError>> {
        return self.toObservableResult()
            .asSingle()
    }
    
    func korailTrainNumberLoad() -> RxSwift.Observable<[SubwayWhen.KorailTrainNumber]> {
        return .just(self.korailTrainNumber)
    }
    
    func korailSchduleLoad(scheduleSearch: SubwayWhen.ScheduleSearch) -> RxSwift.Single<Result<SubwayWhen.KorailHeader, URLError>> {
        return self.toObservableResult()
            .asSingle()
    }
    
    func stationSearch(station: String) -> RxSwift.Single<Result<SubwayWhen.SearchStaion, URLError>> {
        return self.toObservableResult()
            .asSingle()
    }
    
    func defaultViewListRequest() -> RxSwift.Observable<[String]> {
        return self.toObservable()
    }
    
    func vicinityStationsLoad(x: Double, y: Double) -> RxSwift.Single<Result<SubwayWhen.VicinityStationsData, URLError>> {
        return self.toObservableResult()
            .asSingle()
    }
    
    func importantDataLoad() -> RxSwift.Observable<SubwayWhen.ImportantData> {
        return self.toObservable()
    }
    
    func shinbundangScheduleReqeust(scheduleSearch: SubwayWhen.ScheduleSearch) -> RxSwift.Observable<[SubwayWhen.ShinbundangScheduleModel]> {
        return self.toObservable()
    }
    
    func shinbundangScheduleVersionRequest() -> RxSwift.Observable<Double> {
        return self.toObservable()
    }
    
    func searchQueryRecommendListRequest() -> RxSwift.Observable<[SubwayWhen.SearchQueryRecommendData]> {
        return self.toObservable()
    }
    
    func subwayNoticeRequest() -> RxSwift.Single<Result<SubwayWhen.SubwayNoticeResponse, URLError>> {
        return self.toObservableResult()
            .asSingle()
    }
}

extension MockLoadModel {
    func setSuccess(_ data: Any) {
        self.successData = data
        self.error = nil
    }
    
    func setFailure(_ error: URLError) {
        self.error = error
        self.successData = nil
    }
    
    func setKorailTrainNumber(_ data: [KorailTrainNumber]) {
        self.korailTrainNumber = data
    }
    
    private func toObservableResult<T>() -> Observable<Result<T, URLError>> {
        if let error = self.error {
            return .just(.failure(error))
        }
        
        if let data = self.successData as? T {
            return .just(.success(data))
        }
        
        return .just(.failure(URLError(.unknown)))
    }
    
    private func toObservable<T>() -> Observable<T> {
        if let data = self.successData as? T {
            return .just(data)
        }
        
        return .never()
    }
}
