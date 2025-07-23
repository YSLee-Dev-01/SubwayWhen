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
    /// 네
    static let yes = "네"
    /// 아니오
    static let no = "아니오"
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
    /// 고유번호를 확인할 수 없어요.
    static let canNotThreeStep = "고유번호를 확인할 수 없어요."
    
    /// 고유번호가 없으면 민원 처리가 원활하지 않을 수 있어요.
    static let threeStepPassAlert = "고유번호가 없으면 민원 처리가 원활하지 않을 수 있어요."
    /// 입력하기
    static let threeStepPassAlertNo = "입력하기"
    /// 입력하지 않고 진행하기
    static let threeStepPassAlertYes = "입력하지 않고 진행하기"
    
    /// 민원 정보
    static let fourStepTitle = "민원 정보"
    /// 민원내용을 선택하거나 입력해주세요.
    static let fourStepQuestion = "민원내용을 선택하거나 입력해주세요."
    
    /// 차내 더움
    static let fourStepOptionTitle1 = "차내 더움"
    /// 차내 추움
    static let fourStepOptionTitle2 = "차내 추움"
    /// 폭력 사건
    static let fourStepOptionTitle3 = "차내 잡상인"
    /// 차내 전도
    static let fourStepOptionTitle4 = "차내 전도"
    /// 차내 취객
    static let fourStepOptionTitle5 = "차내 취객"
    /// 지연 심각
    static let fourStepOptionTitle6 = "지연 심각"
    /// 내용 직접 입력
    static let fourStepOptionTitle7 = "내용 직접 입력"
    
    /// 차내가 덥습니다. 에어컨 조절 부탁드립니다.
    static let fourStepOptionSub1 = "차내가 덥습니다. 에어컨 조절 부탁드립니다."
    /// 차내가 춥습니다. 난방 조절 부탁드립니다.
    static let fourStepOptionSub2 = "차내가 춥습니다. 난방 조절 부탁드립니다."
    /// 차내에서 잡상인이 물건을 팔고 있습니다.
    static let fourStepOptionSub3 = "차내에서 잡상인이 물건을 팔고 있습니다."
    /// 차내에서 전도를 하는 사람이 있습니다.
    static let fourStepOptionSub4 = "차내에서 전도를 하는 사람이 있습니다."
    /// 차내에 취객이 있어 고성방가를 하고 있습니다.
    static let fourStepOptionSub5 = "차내에 취객이 있어 고성방가를 하고 있습니다."
    /// 열차 지연이 심각합니다. 정시운행 부탁드립니다.
    static let fourStepOptionSub6 = "열차 지연이 심각합니다. 정시운행 부탁드립니다."
}
