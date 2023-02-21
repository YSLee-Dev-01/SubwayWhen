//
//  ReportCheckModalVC.swift
//  SubwayWhen
//
//  Created by 이윤수 on 2023/02/21.
//

import UIKit

import RxSwift
import RxCocoa

import MessageUI

class ReportCheckModalVC : ModalVCCustom{
    let mainTitle = UILabel().then{
        $0.text = "지하철 민원"
        $0.font = .systemFont(ofSize: ViewStyle.FontSize.mainTitleMediumSize, weight: .heavy)
        $0.textColor = .label
    }
    
    let subTitle = UILabel().then{
        $0.text = "하단 내용으로 지하철 민원을 접수할까요?"
        $0.numberOfLines = 2
        $0.font = .systemFont(ofSize: ViewStyle.FontSize.smallSize)
        $0.textColor = .gray
    }
    
    let okBtn = ModalCustomButton().then{
        $0.backgroundColor = UIColor(named: "MainColor")
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    let textView = UITextView().then{
        $0.font = .systemFont(ofSize: ViewStyle.FontSize.smallSize)
        $0.textColor = .label
        $0.isEditable = false
    }
    
    let checkModalViewModel : ReportCheckModalViewModel
    
    let bag = DisposeBag()
    
    init(modalHeight: CGFloat, viewModel : ReportCheckModalViewModel) {
        self.checkModalViewModel = viewModel
        super.init(modalHeight: modalHeight)
        self.bind(self.checkModalViewModel)
    }
    
    deinit{
        print("ReportCheckModalVC DEINIT")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layout()
    }
}

extension ReportCheckModalVC {
    private func layout(){
        [self.mainTitle, self.subTitle, self.okBtn, self.textView]
            .forEach{
                self.mainBG.addSubview($0)
            }
        
        self.mainTitle.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(ViewStyle.padding.mainStyleViewLR)
            $0.top.equalToSuperview().inset(30)
            $0.height.equalTo(25)
        }
        
        self.subTitle.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(ViewStyle.padding.mainStyleViewLR)
            $0.top.equalTo(self.mainTitle.snp.bottom).offset(ViewStyle.padding.mainStyleViewTB)
            $0.height.equalTo(13)
        }
        
        self.okBtn.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(ViewStyle.padding.mainStyleViewLR)
            $0.height.equalTo(50)
            $0.bottom.equalTo(self.grayBG).inset(42.5)
        }
        
        self.textView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(ViewStyle.padding.mainStyleViewLR)
            $0.top.equalTo(self.subTitle.snp.bottom).offset(10)
            $0.bottom.equalTo(self.okBtn.snp.top).offset(-10)
        }
    }
    
    private func bind(_ viewModel : ReportCheckModalViewModel){
        // VIEWMODEL -> VIEW
        viewModel.msg
            .drive(self.rx.contentsSet)
            .disposed(by: self.bag)
        
        viewModel.number
            .drive(self.rx.msgVCPresent)
            .disposed(by: self.bag)
        
        // VIEW - > VIEWMODEL
        self.okBtn.rx.tap
            .bind(to: viewModel.okBtnClick)
            .disposed(by: self.bag)
    }
    
    override func modalDismiss() {
        self.checkModalViewModel.close
            .accept(Void())
        super.modalDismiss()
    }
}

extension Reactive where Base : ReportCheckModalVC{
    var contentsSet : Binder<String>{
        return Binder(base){base, text in
            base.textView.text = text
        }
    }
    
    var msgVCPresent : Binder<String>{
        return Binder(base){base, number in
            let msgVC = MFMessageComposeViewController()
            msgVC.recipients = [number]
            msgVC.body = base.textView.text
            
            base.present(msgVC, animated: true)
        }
    }
}
