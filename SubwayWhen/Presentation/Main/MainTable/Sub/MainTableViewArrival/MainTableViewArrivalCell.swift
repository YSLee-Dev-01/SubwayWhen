//
//  MainTableViewCell.swift
//  SubwayWhen
//
//  Created by 이윤수 on 2022/11/30.
//

import UIKit

import RxSwift
import RxCocoa
import Then
import SnapKit

class MainTableViewCell: TableViewCellCustom {
    
    // MARK: - Properties
    
    private lazy var line = UILabel().then{
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 30
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: ViewStyle.FontSize.smallSize)
    }
    
    fileprivate var station = UILabel().then{
        $0.font = .systemFont(ofSize: ViewStyle.FontSize.smallSize)
        $0.textColor = .label
    }
    
    fileprivate var now = UILabel().then{
        $0.font = .boldSystemFont(ofSize: ViewStyle.FontSize.mediumSize)
        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        $0.textColor = .label
    }
    
    private var arrivalTime = UILabel().then{
        $0.font = .boldSystemFont(ofSize: ViewStyle.FontSize.largeSize)
        $0.textAlignment = .right
        $0.textColor = .label
    }
    
    private var nowStackView = UIStackView().then{
        $0.distribution = .equalSpacing
        $0.spacing = 5
        $0.axis = .vertical
    }
    
    lazy var changeBtn = UIButton().then{
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = ViewStyle.Layer.radius
        $0.setImage(UIImage(systemName: "timer"), for: .normal)
        $0.tintColor = .white
    }
    
    private lazy var border = UIView().then{
        $0.layer.borderWidth = 1.0
    }
    
    private let refreshIcon = UIActivityIndicatorView().then{
        $0.color = UIColor(named: "AppIconColor")
    }
    
    private var type : MainTableViewCellType = .real
    var bag = DisposeBag()
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.layout()
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 재사용 시 초기화 구문
    override func prepareForReuse() {
        self.bag = DisposeBag()
        self.refreshIcon.stopAnimating()
        self.bind()
    }
}

// MARK: - Methods

extension MainTableViewCell{
    private func layout(){
        self.mainBG.addSubviews(self.line, self.nowStackView, self.arrivalTime, self.changeBtn, self.border)
        self.line.snp.makeConstraints{
            $0.leading.top.equalToSuperview().inset(15)
            $0.size.equalTo(60)
        }
        
        self.nowStackView.snp.makeConstraints{
            $0.leading.equalTo(self.line.snp.trailing).offset(15)
            $0.centerY.equalTo(self.line.snp.centerY)
            $0.trailing.equalToSuperview().offset(-15)
        }
        
        self.nowStackView.addArrangedSubview(self.station)
        self.nowStackView.addArrangedSubview(self.now)
        
        self.changeBtn.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(15)
            $0.width.equalTo(80)
            $0.height.equalTo(30)
            $0.top.equalTo(self.nowStackView.snp.bottom).offset(15)
        }
        
        self.border.snp.makeConstraints{
            $0.leading.equalTo(self.line)
            $0.trailing.equalTo(self.changeBtn.snp.leading)
            $0.top.equalTo(self.changeBtn.snp.bottom).inset(15)
            $0.height.equalTo(1)
        }
        
        self.arrivalTime.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(15)
            $0.leading.equalTo(self.snp.centerX)
            $0.top.equalTo(self.changeBtn.snp.bottom).offset(15)
            $0.height.equalTo(30)
            $0.bottom.equalToSuperview().inset(15)
        }
        
        self.mainBG.addSubview(self.refreshIcon)
        self.refreshIcon.snp.makeConstraints{
            $0.centerY.equalTo(self.arrivalTime)
            $0.trailing.equalTo(self.arrivalTime)
        }
    }
    
   private func bind(){
        self.changeBtn.rx.tap
            .map{[weak self] in
                self?.type ?? .real
            }
            .bind(to: self.rx.loadingLabelShow)
            .disposed(by: self.bag)
    }
    
    func refreshShow(){
        self.refreshIcon.startAnimating()
        self.arrivalTime.text = ""
    }
    
    func cellSet(data : MainTableViewCellData){
        if data.type == .loading {
            self.refreshIcon.startAnimating()
        } else {
            self.refreshIcon.stopAnimating()
        }
        
        self.station.text = "\(data.stationName) | \(data.lastStation)"
        self.line.text = data.subwayLineData.useLine
        
        self.arrivalTime.text = "\(data.useTime)"
        self.now.text = data.type == .schedule ? "⏱️\(data.useFast)\(data.stateMSG)" : "\(data.useFast)\(data.stateMSG)"
        self.lineColor(line: data.subwayLineData.rawValue)
        
        self.type = data.type
    }
    
    func lineColor(line : String){
        self.border.layer.borderColor = UIColor(named: line)?.cgColor
        self.line.backgroundColor = UIColor(named: line)
        self.changeBtn.backgroundColor = UIColor(named: line)
    }
}

// MARK: - extension Reactive

extension Reactive where Base : MainTableViewCell{
    var loadingLabelShow : Binder<MainTableViewCellType>{
        return Binder(base){base, type in
            if type == .real{
                base.now.text = "⏱️"
                base.station.text = Strings.Main.timetableLoding
                base.refreshShow()
            }
        }
    }
}
