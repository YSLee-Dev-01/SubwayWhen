//
//  ScheduleType.swift
//  SubwayWhen
//
//  Created by 이윤수 on 2023/01/12.
//

import Foundation

enum ScheduleType: Equatable{
    case Seoul
    case Korail
    case Shinbundang
    case Unowned
    
    static func lineNumberScheduleType(_ line: SubwayLineData) -> ScheduleType {
        if line == .shinbundang {
            return .Shinbundang
        } else if  line == .airport || line == .ui || line == .not || line == .gyeonggang || line == .seohae || line == .gtxA || line == .sillim {
            return .Unowned
        } else if line == .gyeongui || line == .gyeongchun || line ==  .suinbundang  {
            return .Korail
        } else {
            return .Seoul
        }
    }
}
