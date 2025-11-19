//
//  DummyKorailNumber.swift
//  SubwayWhenTests
//
//  Created by 이윤수 on 11/17/25.
//

import Foundation

@testable import SubwayWhen

struct DummyKorailTrainValue: Decodable {
    var value: [KorailTrainNumber]
}
