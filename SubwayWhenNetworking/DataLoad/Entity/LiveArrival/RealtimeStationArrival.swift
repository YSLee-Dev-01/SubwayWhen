//
//  RealtimeStationArrival.swift
//  SubwayWhen
//
//  Created by 이윤수 on 2022/11/30.
//

import Foundation

struct RealtimeStationArrival : Decodable, Equatable, Hashable {
    let upDown : String
    let arrivalTime : String
    let previousStation : String?
    let subPrevious : String
    let code : String
    let subWayId : String
    let stationName : String
    let lastStation : String
    let lineNumber : String?
    let isFast : String?
    let backStationId : String
    let nextStationId : String
    let trainCode : String
    
    enum CodingKeys : String, CodingKey{
        case upDown = "updnLine"
        case arrivalTime = "barvlDt"
        case previousStation = "arvlMsg3"
        case subPrevious = "arvlMsg2"
        case code = "arvlCd"
        case subWayId = "subwayId"
        case lastStation = "bstatnNm"
        case stationName = "statnNm"
        case lineNumber = "lineNumber"
        case isFast = "btrainSttus"
        case backStationId = "statnFid"
        case nextStationId = "statnTid"
        case trainCode = "btrainNo"
    }
    
    var subwayLineData: SubwayLineData {
        SubwayLineData(subwayId: subWayId)
    }
    
    var useState : String{
        switch self.code{
        case "0":
            return "\(self.stationName) 진입"
        case "1":
            return "\(self.stationName) 도착"
        case "2":
            return "\(self.stationName) 출발"
        case "3":
            return "전역 출발"
        case "4":
            return "전역 진입"
        case "5":
            return "전역 도착"
        case "99":
            return self.previousStation == nil ? "\(self.subPrevious)" : "\(self.previousStation!) 부근"
        default:
            return self.code
        }
    }
}
