//
//  MainTableHeaderSubView.swift
//  SubwayWhen
//
//  Created by 이윤수 on 2023/09/18.
//

import UIKit

import SnapKit
import Then

class MainTableHeaderSubView: MainStyleUIView {
    
    // MARK: - Properties
    
    private let mainTitle = UILabel().then{
        $0.font = .boldSystemFont(ofSize: ViewStyle.FontSize.mediumSize)
        $0.textAlignment = .left
        $0.textColor = .label
        $0.adjustsFontSizeToFitWidth = true
    }
    
    let subTitle = UILabel().then{
        $0.font = .boldSystemFont(ofSize: ViewStyle.FontSize.mainTitleSize)
        $0.textAlignment = .left
        $0.adjustsFontSizeToFitWidth = true
    }
    
    // MARK: - LifeCycle
    
    init(title: String, subTitle: String, isImportantMode: Bool = false){
        super.init(frame: .zero)
        
        self.attribute(title: title, subTitle: subTitle, isImportantMode: isImportantMode)
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension MainTableHeaderSubView {
    private func attribute(title: String, subTitle: String, isImportantMode: Bool) {
        self.mainTitle.text = title
        self.subTitle.text = subTitle
        
        if isImportantMode {
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.systemRed.cgColor
        }
    }
    
    private func layout() {
        self.addSubviews(self.mainTitle, self.subTitle)
        self.mainTitle.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.bottom.equalTo(self.snp.centerY).offset(-5)
        }
        self.subTitle.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.top.equalTo(self.snp.centerY)
        }
    }
}
