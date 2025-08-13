//
//  ReportCheckModalModel.swift
//  SubwayWhen
//
//  Created by 이윤수 on 2023/03/27.
//

import Foundation

class ReportCheckModalModel : ReportCheckModalModelProtocol{
    func createMsg(data : ReportMSGData) -> String{
                       """
                    \(data.selectedLine.rawValue) \(data.destination)행 \(data.trainCar.isEmpty ? "" : "\(data.trainCar)")
                    현재 \(data.nowStation)역
                    \(data.contants)
                    """
    }
    
    func numberMatching(data : ReportMSGData) -> String{
        if data.selectedLine == .two || data.selectedLine == .five || data.selectedLine == .six || data.selectedLine == .seven || data.selectedLine == .eight || (data.selectedLine == .one && data.brand == "Y") || (data.selectedLine == .three && data.brand == "N") || (data.selectedLine == .four && data.brand == "N"){
            // 서울교통공사
            return "1577-1234"
        }else if data.selectedLine == .nine{
            // 9호선
            return "1544-4009"
        }else if data.selectedLine == .gyeongui || data.selectedLine == .gyeongchun || data.selectedLine == .airport || data.selectedLine == .suinbundang || (data.selectedLine == .one && data.brand == "N") || (data.selectedLine == .three && data.brand == "Y") || (data.selectedLine == .four && data.brand == "Y"){
            // 코레일
            return "1544-7769"
        } else if data.selectedLine == .shinbundang {
            // 신분당선
            return "031-8018-7777"
        } else {
            return ""
        }
    }
}
