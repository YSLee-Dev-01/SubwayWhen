//
//  SettingViewCell.swift
//  SubwayWhen
//
//  Created by 이윤수 on 9/17/25.
//

import Foundation

struct SettingViewCell: Equatable {
    enum CellType: Equatable {
        case newVC, time
        case toggle(WritableKeyPath<SaveSetting, Bool>)
        case textField(WritableKeyPath<SaveSetting, String>)
    }
    
    let title: String
    let type: CellType
}
