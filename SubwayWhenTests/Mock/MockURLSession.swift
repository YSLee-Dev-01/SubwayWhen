//
//  MockURLSession.swift
//  SubwayWhenTests
//
//  Created by 이윤수 on 2023/03/02.
//

import Foundation

import RxSwift

@testable import SubwayWhen

typealias Responese = (response: HTTPURLResponse, data: Data)

class MockURLSession: URLSessionProtocol {
    
    // MARK: - Properties
    
    let responese: Responese
    
    // MARK: - LifeCycle
    
    init(_ responese: Responese) {
        self.responese = responese
    }
    
    // MARK: - Methods (Protocol)
    
    func response(request: URLRequest) -> RxSwift.Observable<(response: HTTPURLResponse, data: Data)> {
        return Observable<Responese>.just(self.responese)
    }
}
