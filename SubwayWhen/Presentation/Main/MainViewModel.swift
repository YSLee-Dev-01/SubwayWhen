//
//  MainViewModel.swift
//  SubwayWhen
//
//  Created by 이윤수 on 2022/11/30.
//

import Foundation

import RxSwift
import RxCocoa
import RxOptional

import FirebaseAnalytics

enum MainViewAction {
    case cellTap(IndexPath)
    case scheduleTap(IndexPath)
    case refreshEvent
    case groupTap(SaveStationGroup)
    case reportBtnTap
    case editBtnTap
    case importantBtnTap
}

class MainViewModel {
    struct Input {
        let actionList: Observable<MainViewAction>
    }
    
    struct Output {
        let mainTitle: Driver<String>
        let importantData: Driver<ImportantData>
        let tableViewData: Driver<[MainTableViewSection]>
        let peopleData: Driver<String>
        let groupData: Driver<SaveStationGroup>
        let cellData: Driver<(MainTableViewCellData, Int)>
    }
    
    func trasnform(input: Input) -> Output {
        input.actionList
            .bind(onNext: self.actionProcess)
            .disposed(by: self.bag)
        
        self.mainModel.headerImportantDataLoad()
            .bind(to: self.nowImportantData)
            .disposed(by: self.bag)
        
        self.nowImportantData
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                // importantData오면 뷰 자체를 다시 그림
                viewModel.tableViewDataSet()
                viewModel.stationLiveDataLoad()
            })
            .disposed(by: self.bag)
        
        return Output(
            mainTitle: self.nowMainTitle
                .asDriver(onErrorDriveWith: .empty()),
            importantData: self.nowImportantData
                .filterNil()
                .asDriver(onErrorDriveWith: .empty()),
            tableViewData: self.nowTableViewCellData
                .filter {$0.1}
                .map {$0.0}
                .asDriver(onErrorDriveWith: .empty()),
            peopleData: self.nowPeopleData
                .asDriver(),
            groupData: self.nowGroupSet
                .delay(.milliseconds(10), scheduler: MainScheduler.asyncInstance)
                .asDriver(onErrorDriveWith: .empty()),
            cellData: self.nowSingleLiveData
                .filterNil()
                .asDriver(onErrorDriveWith: .empty())
        )
    }
    
    // MODEL
    private let mainModel : MainModelProtocol
    
    private let bag = DisposeBag()
    
    // 현재 데이터
    private let nowTableViewCellData = BehaviorRelay<([MainTableViewSection], Bool)>(value: ([], true))
        // false 로 된 데이터는 MainTableView를 재로딩 하지 않고, 값을 저장하는 용도로만 사용함
    private let nowSaveStationEmptyData = BehaviorRelay<[MainTableViewCellData]>(value: [])
    private let nowGroupData = BehaviorRelay<[MainTableViewCellData]>(value: [])
    private let nowGroupSet = BehaviorRelay<SaveStationGroup>(value: .one)
    private let nowPeopleData = BehaviorRelay<String>(value: "🫥🫥🫥🫥🫥🫥🫥🫥🫥🫥")
    private let nowSingleLiveData = BehaviorRelay<(MainTableViewCellData, Int)?>(value: nil)
    private let nowMainTitle = BehaviorRelay<String>(value: Strings.Main.defaultMessage)
    private let nowImportantData = BehaviorRelay<ImportantData?>(value: nil)
    
    weak var delegate : MainDelegate?
    
    init(
        mainModel : MainModel = .init())
    {
        // Model Init
        self.mainModel = mainModel
    }
}

private extension MainViewModel {
    func actionProcess(type: MainViewAction) {
        switch type {
        case .editBtnTap:
            self.delegate?.pushTap(action: .Edit)
            
        case .reportBtnTap:
            self.delegate?.pushTap(action: .Report(nil, nil))
            
        case .cellTap(let index):
            if index.section != 0 {return}
            
            let nowValue = nowTableViewCellData.value.0[0].items
            if nowValue.count <= index.row {return}
            let cellData = nowValue[index.row]
            
            if cellData.id == "NoData" {
                self.delegate?.plusStationTap()
            } else if cellData.id != "header" && cellData.id != "group" {
                self.delegate?.pushDetailTap(data: cellData)
            }
            
        case .refreshEvent:
            self.mainModel.emptyLiveData(stations: FixInfo.saveStation)
                .bind(to: self.nowSaveStationEmptyData)
                .disposed(by: self.bag)
            
           // 시간에 맞는 그룹 set
           self.mainModel.timeGroup(
               oneTime: FixInfo.saveSetting.mainGroupOneTime,
               twoTime: FixInfo.saveSetting.mainGroupTwoTime,
               nowHour: Calendar.current.component(.hour, from: Date())
               )
           .bind(to: self.nowGroupSet)
           .disposed(by: self.bag)
            
            // 메인 타이틀 업데이트
            self.mainModel.mainTitleLoad()
                .bind(to: self.nowMainTitle)
                .disposed(by: self.bag)
            
            // 혼잡도 세팅
            self.mainModel.congestionDataLoad()
                .map { count in
                    let emoji = count == 0 ? "🫥" : FixInfo.saveSetting.mainCongestionLabel
                    let filledCount = count == 0 ? 10 : count
                    let emptyCount = max(0, 10 - filledCount)
                    
                    return String(repeating: emoji, count: filledCount)
                    + String(repeating: "🫥", count: emptyCount)
                }
                .bind(to: self.nowPeopleData)
                .disposed(by: self.bag)
            
            // 데이터 로드
            self.tableViewDataSet()
            self.stationLiveDataLoad()
                
        case .scheduleTap(let index):
            scheduleBtnAction(index: index)
            
        case .groupTap(let group):
            self.nowGroupSet.accept(group)
            
            // 데이터 로드
            self.tableViewDataSet()
            self.stationLiveDataLoad()
            
        case .importantBtnTap:
            guard let importantData = self.nowImportantData.value else {return}
            self.delegate?.importantTap(data: importantData)
        }
    }
    
    func tableViewDataSet() {
        let data = self.nowSaveStationEmptyData.value.filter {$0.group == self.nowGroupSet.value.rawValue}
        self.nowGroupData.accept(data)
        
        self.nowGroupData
            .withUnretained(self)
            .map { viewModel, data in
                (viewModel.mainModel.createMainTableViewSection(data), true)
            }
            .bind(to: self.nowTableViewCellData)
            .disposed(by: self.bag)
    }
    
    func stationLiveDataLoad() {
        let liveData = self.mainModel.arrivalDataLoad(
            stations: FixInfo.saveStation.filter {$0.group ==  self.nowGroupSet.value}
        )
            .withUnretained(self)
            .filter { viewModel, data in
                let nowSecionData = viewModel.nowTableViewCellData.value.0
                
                guard data.0.group == viewModel.nowGroupSet.value.rawValue,
                   nowSecionData[0].items.count > data.1,
                   nowSecionData[0].items[data.1].id == data.0.id
                else {return false}
                
                return true
            }
            .share()

        liveData
            .map {$0.1}
            .bind(to: self.nowSingleLiveData)
            .disposed(by: self.bag)
        
        liveData
            .map { viewModel, data -> ([MainTableViewSection], Bool)? in
                var nowSecionData = viewModel.nowTableViewCellData.value.0
                
                nowSecionData[0].items[data.1] = data.0
                return (nowSecionData, false)
            }
            .filterNil()
            .bind(to: self.nowTableViewCellData)
            .disposed(by: self.bag)
    }
    
    func scheduleBtnAction(index: IndexPath) {
        // 시간표 버튼 클릭
        let clickCellRow = self.nowTableViewCellData.value.0[0].items[index.row]
        var nowSecionData = self.nowTableViewCellData.value.0
        
        // 구글 애널리틱스
        Analytics.logEvent("MainVC_cellTimeChangeBtnTap", parameters: [
            "Change" : "BTNTAP"
        ])
        
        // 시간표 검색 구조체로 변환
        guard let searchInfo = self.mainModel.mainCellDataToScheduleData(clickCellRow) else {return}
        
        // 시간표 통신 후 TableView에 전달
        let scheduleData = self.mainModel.scheduleLoad(searchInfo)
            .withUnretained(self)
            .map { viewModel, scheduleData -> (MainTableViewCellData, Int)?  in
                guard let scheduleData = scheduleData.first else {return nil}
                let newData = viewModel.mainModel.scheduleDataToMainTableViewCell(data: scheduleData, nowData: clickCellRow)
                
                guard newData.group == viewModel.nowGroupSet.value.rawValue,
                      nowSecionData[0].items.count > index.row,
                      nowSecionData[0].items[index.row].id == newData.id
                else {return nil}
                
                return (newData, index.row)
            }
            .filterNil()
            .share()
        
        scheduleData
            .bind(to: self.nowSingleLiveData)
            .disposed(by: self.bag)
        
        scheduleData
            .withUnretained(self)
            .map { viewModel, data -> ([MainTableViewSection], Bool)? in
                nowSecionData[0].items[data.1] = data.0
                return (nowSecionData, false)
            }
            .filterNil()
            .bind(to: self.nowTableViewCellData)
            .disposed(by: self.bag)
       
    }
}
