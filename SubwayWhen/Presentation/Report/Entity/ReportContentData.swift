//
//  ReportContentData.swift
//  SubwayWhen
//
//  Created by 이윤수 on 7/23/25.
//

import Foundation

struct ReportContentData: Equatable {
    let title : String
    let iconName : String
    let message : String
    
    static let defaultDataList : [ReportContentData] = [
        .init(title: Strings.Report.fourStepOptionTitle1, iconName: "thermometer", message: Strings.Report.fourStepOptionSub1),
        .init(title: Strings.Report.fourStepOptionTitle2, iconName: "thermometer.snowflake", message: Strings.Report.fourStepOptionSub2),
        .init(title: Strings.Report.fourStepOptionTitle3, iconName: "cart", message: Strings.Report.fourStepOptionSub3),
        .init(title: Strings.Report.fourStepOptionTitle4, iconName: "figure.wave", message: Strings.Report.fourStepOptionSub4),
        .init(title: Strings.Report.fourStepOptionTitle5, iconName: "figure.fall", message: Strings.Report.fourStepOptionSub5),
        .init(title: Strings.Report.fourStepOptionTitle6, iconName: "tortoise", message: Strings.Report.fourStepOptionSub6)
    ]
}
