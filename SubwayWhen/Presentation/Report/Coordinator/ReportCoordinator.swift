//
//  ReportCoordinator.swift
//  SubwayWhen
//
//  Created by 이윤수 on 2023/03/12.
//

import UIKit
import SwiftUI
import ComposableArchitecture

class ReportCoordinator : Coordinator{
    var childCoordinator: [Coordinator] = []
    var navigation : UINavigationController
    
    var delegate : ReportCoordinatorDelegate?
    var seletedLine: ReportBrandData? = nil
    
    init(navigation : UINavigationController){
        self.navigation = navigation
    }
    
    func start() {
        let reportView = ReportView(store: .init(initialState: .init(), reducer: {
            var reducer = ReportFeature()
            reducer.delegate = self
            return reducer
        }))
        
        let reportVC = UIHostingController(rootView: reportView)
        reportVC.hidesBottomBarWhenPushed = true
        navigation.pushViewController(reportVC, animated: true)
    }
}

extension ReportCoordinator : ReportVCDelegate {
    func pop() {
        self.delegate?.pop()
        self.delegate?.disappear(reportCoordinator: self)
    }
    
    func moveToReportCheck(data: ReportMSGData) {
        let check = ReportCheckModalVC(modalHeight: 520, viewModel: .init(data: data, dismissHandler: { [weak self] in
            self?.pop()
        }))
        check.modalPresentationStyle = .overFullScreen
        self.navigation.present(check, animated: false)
    }
}
