//
//  GroupView.swift
//  SubwayWhen
//
//  Created by 이윤수 on 2022/12/01.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

class GroupView : UIView{
    let bag = DisposeBag()
    
    let groupOne = GroupCustomButton().then{
        $0.setTitle("출근", for: .normal)
        $0.seleted()
    }
    
    let groupTwo = GroupCustomButton().then{
        $0.setTitle("퇴근", for: .normal)
        $0.unSeleted()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layout()
        self.attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension GroupView{
    private func attribute(){
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }
    
    private func layout(){
        [self.groupOne, self.groupTwo]
            .forEach{self.addSubview($0)}
        
        self.groupOne.snp.makeConstraints{
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(40)
            $0.trailing.equalTo(self.snp.centerX)
        }
        self.groupTwo.snp.makeConstraints{
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(40)
            $0.leading.equalTo(self.snp.centerX)
        }
        
    }
    
    func bind(_ viewModel : GroupViewModel){
        // VIEW -> VIEWMODEL
        let oneClick = self.groupOne.rx.tap
            .map{[weak self] _ -> SaveStationGroup in
                self?.groupOne.seleted()
                self?.groupTwo.unSeleted()
                return .one
            }
        
       let twoClick = self.groupTwo.rx.tap
            .map{[weak self] _ -> SaveStationGroup in
                self?.groupOne.unSeleted()
                self?.groupTwo.seleted()
                return .two
            }
        
        Observable
            .merge(
                oneClick, twoClick
            )
            .bind(to: viewModel.groupSeleted)
            .disposed(by: self.bag)
    }
}
