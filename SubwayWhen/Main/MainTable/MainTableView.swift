//
//  MainTableView.swift
//  SubwayWhen
//
//  Created by 이윤수 on 2022/11/30.
//

import Foundation

import Then
import SnapKit
import RxSwift
import RxCocoa

class MainTableView : UITableView{
    let bag = DisposeBag()
    
    lazy var refresh = UIRefreshControl().then{
        $0.backgroundColor = .systemBackground
        $0.attributedTitle = NSAttributedString("🔄 당겨서 새로고침")
    }
    
    let footerView = MainTableViewFooterView(frame: CGRect(x: 0, y: 0, width: 300, height: 75))
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainTableView{
    private func attribute(){
        self.register(MainTableViewCell.self, forCellReuseIdentifier: "MainCell")
        self.register(MainTableViewFooterView.self, forHeaderFooterViewReuseIdentifier: "MainFooter")
        self.dataSource = nil
        self.rowHeight = 185
        self.separatorStyle = .none
        self.refreshControl = self.refresh
        self.tableFooterView = self.footerView
    }
    
    func bind(_ viewModel : MainTableViewModel){
        self.footerView.bind(viewModel.mainTableViewFooterViewModel)
        
        // VIEWMODEl -> VIEW
        viewModel.cellData
            .drive(self.rx.items){tv, row, data in
                guard let cell = tv.dequeueReusableCell(withIdentifier: "MainCell", for: IndexPath(row: row, section: 0)) as? MainTableViewCell else {return UITableViewCell()}
           
                cell.cellSet(data: data, cellModel: viewModel.mainTableViewCellModel)
                
                return cell
            }
            .disposed(by: self.bag)
        
        viewModel.editBtnClick
            .bind(to: self.rx.isEditing)
            .disposed(by: self.bag)

        // VIEW -> VIEWMODEL
        self.rx.itemSelected
            .bind(to: viewModel.cellClick)
            .disposed(by: self.bag)
        
        self.rx.modelDeleted(MainTableViewCellData.self)
            .bind(to: viewModel.cellDelete)
            .disposed(by: self.bag)
        
        self.refreshControl?.rx.controlEvent(.valueChanged)
            .map{[weak self] _ in
                self?.refreshControl?.endRefreshing()
                return Void()
            }
            .asSignal(onErrorJustReturn: ())
            .emit(to: viewModel.refreshOn)
            .disposed(by: self.bag)
    }
}
