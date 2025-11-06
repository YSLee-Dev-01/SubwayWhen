//
//  ContentsModalVC.swift
//  SubwayWhen
//
//  Created by 이윤수 on 11/6/25.
//

import UIKit
import Then
import SnapKit

class ContentsModalVC: ModalVCCustom {
    
    // MARK: - Properties
    
    private let textView = UITextView().then {
        $0.font = .systemFont(ofSize: ViewStyle.FontSize.smallSize)
        $0.layer.cornerRadius = 15
        $0.backgroundColor = UIColor(named: "MainColor")
        $0.textColor = .label
        $0.isEditable = false
        $0.isSelectable = false
    }
    
    private let contents: String
    
    // MARK: - LifeCycle
    
    init(modalHeight: CGFloat, btnTitle: String, mainTitle: String, subTitle: String, contents: String) {
        self.contents = contents
        
        super.init(modalHeight: modalHeight, btnTitle: btnTitle, mainTitle: mainTitle, subTitle: subTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.attirbute()
        self.layout()
    }
}

// MARK: - Methods

extension ContentsModalVC {
    private func attirbute(){
        self.okBtn!.addTarget(self, action: #selector(self.modalDismiss), for: .touchUpInside)
        self.textView.text = self.contents
    }
    
    private func layout(){
        self.mainBG.addSubview(self.textView)
        self.textView.snp.makeConstraints{
            $0.top.equalTo(self.subTitle.snp.bottom).offset(10)
            $0.bottom.equalTo(self.okBtn!.snp.top).offset(-10)
            $0.leading.trailing.equalToSuperview().inset(ViewStyle.padding.mainStyleViewLR)
        }
    }
}
