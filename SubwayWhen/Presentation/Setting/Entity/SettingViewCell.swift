//
//  SettingViewCell.swift
//  SubwayWhen
//
//  Created by 이윤수 on 9/17/25.
//

import Foundation

struct SettingViewCell: Equatable {
    enum CellType: Equatable {
        case time(Int, Int)
        case toggle(WritableKeyPath<SaveSetting, Bool>)
        case textField(WritableKeyPath<SaveSetting, String>)
        case newVC
    }
    
    let title: String
    let type: CellType
}
