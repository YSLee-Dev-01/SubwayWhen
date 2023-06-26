//
//  SettingNotiModalViewModel.swift
//  SubwayWhen
//
//  Created by 이윤수 on 2023/06/20.
//

import Foundation

import RxSwift
import RxCocoa

import UserNotifications

class SettingNotiModalViewModel {
    weak var delegate: SettingNotiModalVCAction?
    
    private let auth = PublishSubject<Bool>()
    let oneStationTap = BehaviorSubject<SettingNotiModalData>(value: SettingNotiModalData(id: "?", stationName: "", useLine: "", line: "", group: .one))
    let twoStationTap = BehaviorSubject<SettingNotiModalData>(value: SettingNotiModalData(id: "?", stationName: "", useLine: "", line: "", group: .two))
    
    let bag = DisposeBag()
    
    struct Input {
        let didDisappearAction: PublishSubject<Void>
        let dismissAction: PublishSubject<Void>
        let stationTapAction: PublishSubject<Bool>
    }
    
    struct Output {
        let authSuccess: Driver<Bool>
        let notiStationList: Driver<(SettingNotiModalData, SettingNotiModalData)>
        
    }
    
    func transform(input: Input) -> Output {
        input.didDisappearAction
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.delegate?.didDisappear()
            })
            .disposed(by: self.bag)
        
        input.dismissAction
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.delegate?.dismiss()
            })
            .disposed(by: self.bag)
        
        input.stationTapAction
            .withUnretained(self)
            .subscribe(onNext: { viewModel, type in
                viewModel.delegate?.stationTap(type: type)
            })
            .disposed(by: self.bag)
        
        let total = Observable.combineLatest(self.oneStationTap, self.twoStationTap)        
        
        return Output(
            authSuccess: self.auth
                .asDriver(onErrorDriveWith: .empty()),
            notiStationList: total.asDriver(onErrorDriveWith: .empty())
        )
    }
    
    init() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge],
            completionHandler: { [weak self] (granted, _) in
                self?.auth.onNext(granted)
            }
        )
    }
    
    deinit {
        print("SettingNotiModalViewModel DEINIT")
    }
}
