//
//  SettingNotiStationView.swift
//  SubwayWhen
//
//  Created by 이윤수 on 2023/06/21.
//

import UIKit

import Then
import SnapKit
import RxSwift
import RxCocoa

class SettingNotiStationView: UIView {
    private let includeView = MainStyleUIView()
    
    private let includeWeekendTitle = UILabel().then {
        $0.text = "주말포함"
        $0.font = .systemFont(ofSize: ViewStyle.FontSize.largeSize, weight: .bold)
        $0.textColor = .label
    }
    
    fileprivate lazy var  includeWeekendList = UILabel().then {
        $0.font = .boldSystemFont(ofSize: ViewStyle.FontSize.mediumSize)
        $0.textColor = .gray
    }
    
    let includeWeekendSwitch = UISwitch().then {
        $0.onTintColor = UIColor(named: "AppIconColor")
    }
    
    private let groupOneTitle = UILabel().then {
        $0.text = "출근시간"
        $0.font = .systemFont(ofSize: ViewStyle.FontSize.largeSize, weight: .bold)
        $0.textColor = .label
    }
    
    private let groupOneLine = UILabel().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 30
        $0.backgroundColor = .systemGray
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: ViewStyle.FontSize.mediumSize)
        $0.text = "?"
    }
    
    let groupOneBtn = ModalCustomButton(bgColor: UIColor(named: "MainColor") ?? .gray, customTappedBG: nil)
    
    private let groupOneStation = UILabel().then {
        $0.text = "역 선택"
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: ViewStyle.FontSize.mediumSize, weight: .medium)
        $0.textColor = .label
    }
    
    private let groupTwoTitle = UILabel().then {
        $0.text = "퇴근시간"
        $0.font = .systemFont(ofSize: ViewStyle.FontSize.largeSize, weight: .bold)
        $0.textColor = .label
    }
    
    private let groupTwoLine = UILabel().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 30
        $0.backgroundColor = .systemGray
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: ViewStyle.FontSize.mediumSize)
        $0.text = "?"
    }
    
    let groupTwoLBtn = ModalCustomButton(bgColor: UIColor(named: "MainColor") ?? .gray, customTappedBG: nil)
    
    private  let groupTwoStation = UILabel().then {
        $0.text = "역 선택"
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: ViewStyle.FontSize.mediumSize, weight: .medium)
        $0.textColor = .label
    }
    
    private let border = UIView().then {
        $0.backgroundColor = .gray.withAlphaComponent(0.5)
    }
    
    private let bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layout()
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingNotiStationView {
    private func layout() {
        [self.includeWeekendTitle, self.includeView ,self.groupOneTitle, self.groupTwoTitle, self.groupOneBtn, self.groupTwoLBtn, self.border].forEach {
            self.addSubview($0)
        }
        
        self.includeView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.height.equalTo(60)
            $0.leading.equalTo(self.includeWeekendTitle.snp.trailing).offset(ViewStyle.padding.mainStyleViewLR)
            $0.trailing.equalToSuperview().inset(ViewStyle.padding.mainStyleViewLR)
        }
        
        self.includeWeekendTitle.snp.makeConstraints {
            $0.centerY.equalTo(self.includeView)
            $0.leading.equalToSuperview().inset(ViewStyle.padding.mainStyleViewLR)
        }
        
        [self.includeWeekendList, self.includeWeekendSwitch]
            .forEach {
                self.includeView.addSubview($0)
            }
        
        self.includeWeekendList.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalTo(self.includeWeekendSwitch.snp.leading).offset(-15)
            $0.centerY.equalTo(self.includeWeekendTitle)
        }
        
        self.includeWeekendSwitch.snp.makeConstraints {
            $0.centerY.equalTo(self.includeWeekendTitle)
            $0.trailing.equalToSuperview().offset(-15)
        }
        
        self.groupOneTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(ViewStyle.padding.mainStyleViewLR)
            $0.top.equalTo(includeView.snp.bottom).offset(30)
        }
        
        self.groupOneBtn.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(ViewStyle.padding.mainStyleViewLR)
            $0.trailing.equalTo(self.snp.centerX).offset(-ViewStyle.padding.mainStyleViewLR)
            $0.top.equalTo(self.groupOneTitle.snp.bottom).offset(ViewStyle.padding.mainStyleViewTB)
            $0.height.equalTo(110)
        }
        
        [self.groupOneLine, self.groupOneStation]
            .forEach{
                self.groupOneBtn.addSubview($0)
            }
        
        self.groupOneLine.snp.makeConstraints {
            $0.centerY.equalToSuperview().inset(ViewStyle.padding.mainStyleViewTB)
            $0.leading.equalToSuperview().inset(8)
            $0.size.equalTo(60)
        }
        
        self.groupOneStation.snp.makeConstraints {
            $0.centerY.equalTo(self.groupOneLine)
            $0.leading.equalTo(self.groupOneLine.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-8)
        }
        
        self.groupTwoTitle.snp.makeConstraints {
            $0.leading.equalTo(self.snp.centerX).offset(ViewStyle.padding.mainStyleViewLR)
            $0.top.equalTo(includeView.snp.bottom).offset(30)
        }
        
        self.groupTwoLBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-ViewStyle.padding.mainStyleViewLR)
            $0.leading.equalTo(self.snp.centerX).offset(ViewStyle.padding.mainStyleViewLR)
            $0.top.equalTo(self.groupTwoTitle.snp.bottom).offset(ViewStyle.padding.mainStyleViewTB)
            $0.height.equalTo(110)
        }
        
        [self.groupTwoLine, self.groupTwoStation]
            .forEach{
                self.groupTwoLBtn.addSubview($0)
            }
        
        self.groupTwoLine.snp.makeConstraints {
            $0.centerY.equalToSuperview().inset(ViewStyle.padding.mainStyleViewTB)
            $0.leading.equalToSuperview().inset(8)
            $0.size.equalTo(60)
        }
        
        self.groupTwoStation.snp.makeConstraints {
            $0.centerY.equalTo(self.groupTwoLine)
            $0.leading.equalTo(self.groupTwoLine.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-8)
        }
        
        self.border.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.bottom.equalTo(self.groupOneBtn)
            $0.width.equalTo(0.5)
        }
    }
    
    private func bind() {
        self.includeWeekendSwitch.rx.isOn
            .bind(onNext: self.weekendTitleSet)
            .disposed(by: self.bag)
    }
    
    func viewDataSet(data: NotificationManagerRequestData, isRemove: Bool) {
        if isRemove {
            self.defaultSet(group: data.group)
        } else {
            if data.group == .one {
                self.groupOneStation.text = data.stationName
                self.groupOneLine.text = data.useLine
                self.groupOneLine.backgroundColor = UIColor(named: data.line)
            } else {
                self.groupTwoStation.text = data.stationName
                self.groupTwoLine.text = data.useLine
                self.groupTwoLine.backgroundColor = UIColor(named: data.line)
            }
        }
    }
    
    func weekendTitleSet(isOn: Bool) {
        self.includeWeekendList.text = isOn ?  "월 화 수 목 금 토 일" :  "월 화 수 목 금"
    }
    
    private func defaultSet(group: SaveStationGroup) {
        if group == .one {
            self.groupOneStation.text = "역 선택"
            self.groupOneLine.text = "?"
            self.groupOneLine.backgroundColor = .systemGray
        } else {
            self.groupTwoStation.text = "역 선택"
            self.groupTwoLine.text = "?"
            self.groupTwoLine.backgroundColor = .systemGray
        }
    }
}
