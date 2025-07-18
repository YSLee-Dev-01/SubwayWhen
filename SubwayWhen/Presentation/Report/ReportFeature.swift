//
//  ReportFeature.swift
//  SubwayWhen
//
//  Created by 이윤수 on 7/18/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ReportFeature: Reducer {
    @ObservableState
    struct State: Equatable {
        let reportableLines = SubwayLineData.allCases.filter {$0.allowReport}
        var selectedLine: SubwayLineData?
    }

    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case reportLineSelected(SubwayLineData)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .reportLineSelected(let selectedLine):
                state.selectedLine = selectedLine
                return .none
                
            default: return .none
            }
        }
    }
}
