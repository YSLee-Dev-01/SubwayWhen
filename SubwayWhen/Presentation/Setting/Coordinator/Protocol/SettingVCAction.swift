//
//  SettingVCAction.swift
//  SubwayWhen
//
//  Created by 이윤수 on 2023/06/20.
//

import Foundation

protocol SettingVCAction: AnyObject {
    func notiModal()
    func contentsModal()
    func licenseModal()
    func trainIconModal()
}
