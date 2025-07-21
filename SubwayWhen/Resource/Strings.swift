//
//  Strings.swift
//  SubwayWhen
//
//  Created by 이윤수 on 7/18/25.
//

import Foundation

struct Strings {
    struct Common{}
    struct Report {}
}

extension Strings.Common {
    /// 상행
    static let up = "상행"
    /// 하행
    static let down = "하행"
}

extension Strings.Report {
    /// 지하철 민원
    static let title = "지하철 민원"
    
    /// 민원 호선
    static let oneStepTitle = "민원 호선"
    /// 몇호선 민원을 접수하시겠어요?
    static let oneStepQuestion = "몇호선 민원을 접수하시겠어요?"
    
    /// 호선 정보
    static let twoStepTitle = "호선 정보"
    /// 열차의 행선지를 입력해주세요. (행)
    static let twoStepQuestion1 = "열차의 행선지를 입력해주세요. (행)"
    /// 현재 역을 입력해주세요. (역)
    static let twoStepQuestion2 = "현재 역을 입력해주세요. (역)"
    /// 현재 역이 청량리 ~ 서울역 안에 있나요?
    static let twoStepQuestion3_1 = "현재 역이 청량리 ~ 서울역 안에 있나요?"
    /// 현재 역이 대화 ~ 지축 안에 있나요?
    static let twoStepQuestion3_2 = "현재 역이 대화 ~ 지축 안에 있나요?"
    /// 현재 역이 선바위 ~ 오이도 안에 있나요?
    static let twoStepQuestion3_3 = "현재 역이 선바위 ~ 오이도 안에 있나요?"
    
    /// 상세 정보
    static let threeStepTitle = "상세 정보"
    /// 고유(열차)번호를 입력해주세요.
    static let threeStepQuestion1 = "고유(열차)번호를 입력해주세요."
}
