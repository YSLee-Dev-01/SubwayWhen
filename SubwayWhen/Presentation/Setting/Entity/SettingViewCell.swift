//
//  SettingViewCell.swift
//  SubwayWhen
//
//  Created by 이윤수 on 9/17/25.
//

import Foundation

struct SettingViewCell: Equatable {
    enum CellType: Equatable {
        case newVC, toggle, time, textField
    }
    
    let title: String
    let type: CellType
}
