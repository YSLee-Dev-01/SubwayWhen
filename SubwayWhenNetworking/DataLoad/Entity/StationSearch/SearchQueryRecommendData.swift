//
//  SearchQueryRecommendData.swift
//  SubwayWhenNetworking
//
//  Created by 이윤수 on 1/13/25.
//

import Foundation

struct SearchQueryRecommendData: Equatable, Decodable {
    let queryName: String
    let stationName: String
    let line: String
}
