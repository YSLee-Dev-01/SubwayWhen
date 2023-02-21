//
//  TabbarVC.swift
//  SubwayWhen
//
//  Created by 이윤수 on 2022/11/28.
//

import UIKit

import Then
import SnapKit

class TabbarVC : UITabBarController{
    let loadModel = LoadModel()
    
    let mainVC = MainVC().then{
        $0.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), tag: 0)
    }
    
    let searchVC = SearchVC(nibName: nil, bundle: nil).then{
        $0.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass"), tag: 1)
    }
    
    let settingVC = SettingVC(title: "설정", titleViewHeight: 30).then{
        $0.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "gearshape"), tag: 2)
    }
    
    override func viewDidLoad() {
        self.attribute()
        self.settingLoad()
    }
}


extension TabbarVC{
    private func attribute(){
        self.tabBar.backgroundColor = .systemBackground
        self.viewControllers = [UINavigationController(rootViewController: self.mainVC),
                                UINavigationController(rootViewController: self.searchVC),
                                UINavigationController(rootViewController: self.settingVC)
        ]
        
        self.tabBar.itemWidth = 50.0
        self.tabBar.itemPositioning = .centered
    }
    
    private func settingLoad(){
        let result = self.loadModel.saveSettingLoad()
        
        switch result{
        case .success():
            print("setting load success")
        case .failure(let error):
            FixInfo.saveSetting = SaveSetting(mainCongestionLabel: "😵", mainGroupOneTime: 0, mainGroupTwoTime: 0, detailAutoReload: true)
            print("setting not load, 초기 값 세팅 완료\n", error)
        }
    }
}
