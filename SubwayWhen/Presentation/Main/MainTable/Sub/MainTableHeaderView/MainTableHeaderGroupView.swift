//
//  MainTableHeaderGroupView.swift
//  SubwayWhen
//
//  Created by 이윤수 on 11/4/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class MainTableHeaderGroupView: UIView {
    
    // MARK: - Properties
    
    private let groupView = MainStyleUIView()
    
    private let groupOne = MainTableHeaderGroupBtn().then{
        $0.setTitle(Strings.Setting.workTime, for: .normal)
        $0.seleted()
    }
    
    private let groupTwo = MainTableHeaderGroupBtn().then{
        $0.setTitle(Strings.Setting.leaveTime, for: .normal)
        $0.unSeleted()
    }
    
    private let mainTableViewAction = PublishRelay<MainViewAction>()
    private let bag = DisposeBag()
    
    // MARK: - LifeCycle
    
    init() {
        super.init(frame: .zero)
        
        self.attribute()
        self.layout()
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension MainTableHeaderGroupView {
    private func attribute() {
        self.backgroundColor = .systemBackground
    }
    
    private func layout() {
        self.addSubview(self.groupView)
        self.groupView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(ViewStyle.padding.mainStyleViewLR)
            $0.height.equalTo(40)
            $0.top.bottom.equalToSuperview().inset(ViewStyle.padding.mainStyleViewTB)
        }
        
        self.groupView.addSubviews(self.groupOne, self.groupTwo)
        self.groupOne.snp.makeConstraints{
            $0.leading.equalToSuperview()
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalTo(self.groupView.snp.trailing).inset(100)
        }
        
        self.groupTwo.snp.makeConstraints{
            $0.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(self.groupOne.snp.trailing)
        }
    }
    
    private func bind() {
        Observable.merge(
            self.groupOne.rx.tap.map { _ in SaveStationGroup.one},
            self.groupTwo.rx.tap.map { _ in SaveStationGroup.two}
        )
        .map {.groupTap($0)}
        .bind(to: self.mainTableViewAction)
        .disposed(by: self.bag)
    }
    
    private func updateGroupSelection(_ group: SaveStationGroup) {
        if group == .one {
            self.groupOne.seleted()
            self.groupTwo.unSeleted()
        } else {
            self.groupOne.unSeleted()
            self.groupTwo.seleted()
        }
    }
    
    private func btnClickSizeChange(group : Bool){
        if group {
            self.groupOne.snp.remakeConstraints{
                $0.leading.equalToSuperview()
                $0.top.bottom.equalToSuperview()
                $0.trailing.equalTo(self.groupView.snp.leading).inset(100)
            }
        } else {
            self.groupOne.snp.remakeConstraints{
                $0.leading.equalToSuperview()
                $0.top.bottom.equalToSuperview()
                $0.trailing.equalTo(self.groupView.snp.trailing).inset(100)
            }
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.75) {
            self.layoutIfNeeded()
        }
    }
    
    @discardableResult
    func setDI(action: PublishRelay<MainViewAction>) -> Self {
        self.mainTableViewAction
            .bind(to: action)
            .disposed(by: self.bag)
        
        return self
    }
    
    @discardableResult
    func setDI(selectedGroup: Driver<SaveStationGroup>) -> Self {
        selectedGroup
            .drive(onNext: { [weak self] group in
                self?.updateGroupSelection(group)
                self?.btnClickSizeChange(group: group == .two)
            })
            .disposed(by: self.bag)
        
        return self
    }
}
