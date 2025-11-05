//
//  MainTableHeaderView.swift
//  SubwayWhen
//
//  Created by 이윤수 on 11/4/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class MainTableHeaderView: UIView {
    
    // MARK: - Properties
    
    private let congestionLabelBG = MainTableHeaderSubView(
        title: Strings.Main.currentTraffic, subTitle: "🫥🫥🫥🫥🫥🫥🫥🫥🫥🫥"
    )
    
    private var importantLabelBG: MainTableHeaderSubView?
    
    private let reportBtn = MainTableHeaderViewBtn(title: Strings.Report.title, img: "Report")
    private let editBtn = MainTableHeaderViewBtn(title: Strings.Main.edit, img: "List")
    
    private let liveStatusLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: ViewStyle.FontSize.largeSize)
        $0.textColor = UIColor.gray
        $0.text = Strings.Main.liveStatus
    }
    
    private let groupView = MainTableHeaderGroupView()
    
    private let mainTableViewAction = PublishRelay<MainViewAction>()
    private let bag = DisposeBag()
    
    // MARK: - LifeCycle
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100 , height: 300))
        
        self.attribute()
        self.bind()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // 레이아웃 오류 방지
            self.layout()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Methods

extension MainTableHeaderView {
    private func attribute() {
        self.backgroundColor = .systemBackground
    }
    
    private func layout() {
        self.addSubviews(
            self.congestionLabelBG,
            self.editBtn, self.reportBtn,
            self.liveStatusLabel, self.groupView
        )
        self.congestionLabelBG.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(ViewStyle.padding.mainStyleViewLR)
            $0.height.equalTo(90)
        }
        
        self.reportBtn.snp.makeConstraints{
            $0.top.equalTo(self.congestionLabelBG.snp.bottom).offset(10)
            $0.leading.equalTo(self.congestionLabelBG)
            $0.trailing.equalTo(self.congestionLabelBG.snp.centerX).offset(-5)
            $0.height.equalTo(90)
        }
        
        self.editBtn.snp.makeConstraints{
            $0.top.equalTo(self.congestionLabelBG.snp.bottom).offset(10)
            $0.trailing.equalTo(self.congestionLabelBG)
            $0.leading.equalTo(self.congestionLabelBG.snp.centerX).offset(5)
            $0.height.equalTo(90)
        }
        
        self.liveStatusLabel.snp.makeConstraints{
            $0.top.equalTo(self.editBtn.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(ViewStyle.padding.mainStyleViewLR)
        }
        
        self.groupView.snp.makeConstraints{ // height = 40
            $0.top.equalTo(self.liveStatusLabel.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        self.groupView
            .setDI(action: self.mainTableViewAction)
        
        self.reportBtn.rx.tap
            .map {_ in .reportBtnTap}
            .bind(to: self.mainTableViewAction)
            .disposed(by: self.bag)
        
        self.editBtn.rx.tap
            .map {_ in .editBtnTap}
            .bind(to: self.mainTableViewAction)
            .disposed(by: self.bag)
    }
    
    private func setupImportantView(title: String, subTitle: String) {
        self.importantLabelBG = .init(title: title, subTitle: subTitle, isImportantMode: true)
        guard let importantLabelBG = self.importantLabelBG else {return}
        
        self.addSubview(importantLabelBG)
        importantLabelBG.snp.remakeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(ViewStyle.padding.mainStyleViewLR)
            $0.height.equalTo(90)
        }
        
        self.congestionLabelBG.snp.remakeConstraints{
            $0.top.equalTo(importantLabelBG.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(ViewStyle.padding.mainStyleViewLR)
            $0.height.equalTo(90)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8) {
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
    func setDI(peopleData: Driver<String>) -> Self {
        peopleData
            .do(onNext: { [weak self] _ in
                self?.editBtn.iconAnimationPlay()
                self?.reportBtn.iconAnimationPlay()
            })
            .drive(self.congestionLabelBG.subTitle.rx.text)
            .disposed(by: self.bag)
        
        return self
    }
    
    @discardableResult
    func setDI(selectedGroup: Driver<SaveStationGroup>) -> Self {
        self.groupView
            .setDI(selectedGroup: selectedGroup)
        
        return self
    }
    
    @discardableResult
    func setDI(importantData: Driver<ImportantData>) -> Self {
        importantData
            .asObservable()
            .subscribe(onNext: { [weak self] data in
                self?.setupImportantView(title: data.title, subTitle: data.contents)
            })
            .disposed(by: self.bag)
        
        return self
    }
}
