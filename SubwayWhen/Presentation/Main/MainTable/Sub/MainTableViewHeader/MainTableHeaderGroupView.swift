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
    
    private let groupOne = MainTableViewGroupBtn().then{
        $0.setTitle(Strings.Setting.workTime, for: .normal)
        $0.seleted()
    }
    
    private let groupTwo = MainTableViewGroupBtn().then{
        $0.setTitle(Strings.Setting.leaveTime, for: .normal)
        $0.unSeleted()
    }
    
    private let bag = DisposeBag()
    
    // MARK: - LifeCycle
    
    init() {
        super.init(frame: .zero)
        
        self.attribute()
        self.layout()
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
}
