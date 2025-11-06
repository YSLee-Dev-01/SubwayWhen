//
//  Notice.swift
//  SubwayWhenNetworking
//
//  Created by 이윤수 on 11/6/25.
//

import Foundation

struct SubwayNoticeResponse: Decodable {
    let response: ResponseData
    
    struct ResponseData: Decodable {
        let body: Body
    }
    
    struct Body: Decodable {
        let items: Items
        
        struct Items: Decodable {
            let item: [SubwayNotice]
        }
    }
}
