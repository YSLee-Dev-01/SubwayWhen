//
//  SettingNotiModalVC.swift
//  SubwayWhen
//
//  Created by 이윤수 on 2023/06/20.
//

import UIKit

import Then
import SnapKit
import Lottie

import RxSwift
import RxCocoa

class SettingNotiModalVC: ModalVCCustom {
    var animationIcon : LottieAnimationView?
    let settingNotiStationView = SettingNotiStationView()
    let settingNotiExplanationView = SettingNotiModalExplanationView()
    
    var viewModel: SettingNotiModalViewModel
    let bag = DisposeBag()
    
    private let didDisappearAction =  PublishSubject<Void>()
    private let dismissAction =  PublishSubject<Void>()
    private let stationTap = PublishSubject<Bool>()
    
    
    init(modalHeight: CGFloat, btnTitle: String, mainTitle: String, subTitle: String, viewModel: SettingNotiModalViewModel) {
        self.viewModel = viewModel
        super.init(modalHeight: modalHeight, btnTitle: btnTitle, mainTitle: mainTitle, subTitle: subTitle)
        self.attribute()
        self.bind()
    }
    
    deinit {
        print("SettingNotiModalVC DEINIT")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.didDisappearAction.onNext(Void())
    }
    
    override func viewAnimation() {
        super.viewAnimation()
        self.settingNotiExplanationView.showAnimation()
    }
    
    override func modalDismiss() {
        UIView.animate(withDuration: 0.25, delay: 0, animations: {
            self.mainBG.transform = CGAffineTransform(translationX: 0, y: self.modalHeight)
            self.mainBGContainer.transform = CGAffineTransform(translationX: 0, y: self.modalHeight)
            self.grayBG.backgroundColor = .clear
            self.settingNotiExplanationView.hiddenAnimation()
        }, completion: {_ in
            self.dismissAction.onNext(Void())
        })
    }
}

extension SettingNotiModalVC {
    private func attribute() {
        self.okBtn!.addTarget(self, action: #selector(self.modalDismiss), for: .touchUpInside)
    }
    
    func layout() {
        self.mainBG.addSubview(self.settingNotiStationView)
        self.settingNotiStationView.snp.makeConstraints{
            $0.top.equalTo(self.subTitle.snp.bottom)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.bottom.equalTo(self.okBtn!.snp.top)
        }
        
        self.view.addSubview(self.settingNotiExplanationView)
        self.settingNotiExplanationView.snp.makeConstraints{
            $0.bottom.equalTo(self.mainBG.snp.top).offset(-ViewStyle.padding.mainStyleViewTB)
            $0.leading.trailing.equalToSuperview().inset(5)
            $0.height.equalTo(50)
        }
    }
    
    private func bind() {
        self.settingNotiStationView.groupOneBtn.rx.tap
            .map{_ in true}
            .bind(to: self.stationTap)
            .disposed(by: self.bag)
        
        self.settingNotiStationView.groupTwoLBtn.rx.tap
            .map{_ in false}
            .bind(to: self.stationTap)
            .disposed(by: self.bag)
        
        self.settingNotiExplanationView.goBtn.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.modalDismiss()
            })
            .disposed(by: self.bag)
        
        let input = SettingNotiModalViewModel
            .Input(
                didDisappearAction: self.didDisappearAction,
                dismissAction: self.dismissAction,
                stationTapAction: self.stationTap,
                okBtnTap: self.okBtn!.rx.tap.asObservable(),
                groupTimeGoBtnTap: self.settingNotiExplanationView.goBtn.rx.tap.asObservable(),
                isWeekendNoficationEnabled: self.settingNotiStationView.includeWeekendSwitch.rx.isOn.asObservable()
            )
        let output =  self.viewModel.transform(input: input)
        
        output.authSuccess
            .drive(self.rx.authSwitch)
            .disposed(by: self.bag)
        
        output.notiStationList
            .drive(self.rx.viewSet)
            .disposed(by: self.bag)
        
        output.enableWeekendNotifications
            .drive(self.rx.weekendSwitchSet)
            .disposed(by: self.bag)
    }
    
    func iconLayout(){
        self.animationIcon = LottieAnimationView(name: "Report")
        guard let animationIcon = self.animationIcon else {return}
        
        self.mainBG.addSubview(animationIcon)
        animationIcon.snp.makeConstraints{
            $0.size.equalTo(100)
            $0.top.equalTo(self.subTitle.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
        }
    }
    
    func animationStart() {
        guard let animationIcon = self.animationIcon else {return}
        
        animationIcon.animationSpeed = 2
        animationIcon.play()
    }
    
}

extension Reactive where Base: SettingNotiModalVC {
    var authSwitch: Binder<Bool>{
        return Binder(base){ base, bool in
            if bool{
                base.layout()
            }else{
                base.iconLayout()
                base.animationStart()
                base.subTitle.text = "알림 권한이 설정되어 있지 않아요."
                base.okBtn?.setTitle("닫기", for: .normal)
            }
        }
    }
    
    var viewSet: Binder<[NotificationManagerRequestData]> {
        return Binder(base){ base, data in
            for item in data {
                if item.stationName != "" {
                    base.settingNotiStationView.viewDataSet(
                        data: item, isRemove: item.stationName == "역 선택")
                }
            }
        }
    }
    
    var weekendSwitchSet: Binder<Bool> {
        return Binder(base) { base, isOn in
            base.settingNotiStationView.includeWeekendSwitch.isOn = isOn
            base.settingNotiStationView.weekendTitleSet(isOn: isOn)
        }
    }
}
