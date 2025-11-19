//
//  SubwayNotice.swift
//  SubwayWhenNetworking
//
//  Created by 이윤수 on 11/6/25.
//

import Foundation

struct SubwayNotice: Decodable {
    let title: String
    let content: String
    let occurredAt: String
    let lineNames: String?
    let createdDate: String
    let isNonstop: String
    let direction: String?
    let exceptionEndedAt: String?
    
    var endDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        // 1. 상황 종료 일시가 있는 경우
        if let exceptionEndedAt = self.exceptionEndedAt,
            let date = formatter.date(from: exceptionEndedAt) {
            return date
        }
        
        // 2. 상황 종료 일시가 없는 경우 알림 발생일 + 1
        let date = formatter.date(from: self.occurredAt) ?? .now
        let endDate = Calendar.current.startOfDay(for: date)
    
        return Calendar.current.date(byAdding: .day, value: 1, to: endDate) ?? .now
    }
    
    enum CodingKeys: String, CodingKey {
        case title = "noftTtl"
        case content = "noftCn"
        case occurredAt = "noftOcrnDt"
        case lineNames = "lineNmLst"
        case createdDate = "crtrYmd"
        case isNonstop = "nonstopYn"
        case direction = "upbdnbSe"
        case exceptionEndedAt = "xcseSitnEndDt"
    }
}
