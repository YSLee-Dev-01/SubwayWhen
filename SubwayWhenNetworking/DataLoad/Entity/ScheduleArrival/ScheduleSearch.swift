//
//  ScheduleSearch.swift
//  SubwayWhen
//
//  Created by 이윤수 on 2022/12/05.
//

import Foundation

struct ScheduleSearch: Equatable {
    var stationCode : String
    let upDown : String
    let exceptionLastStation : String
    let line : String
    let korailCode : String
    let stationName: String
    
    var lineScheduleType: ScheduleType {
        if line == "신분당선" {
            return .Shinbundang
        } else if  line == "공항철도" || line == "우이신설경전철" || line == "" || line == "경강선" || line == "서해선" || line == "GTX-A" || line == "신림선" {
            return .Unowned
        } else if line == "경의선" || line == "경춘선" || line == "수인분당선" {
            return .Korail
        } else {
            return .Seoul
        }
    }
}
