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
        var reportStep = 0
    }

    enum Action: BindableAction, Equatable {
        case onAppear
        case binding(BindingAction<State>)
        case reportSteopChanged(Int)
        case reportLineSelected(SubwayLineData)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.reportStep == 0 {
                    return .run { send in
                        try? await Task.sleep(for: .milliseconds(100))
                        await send(.reportSteopChanged(1))
                    }
                } else {
                    return .none
                }
                
            case .reportLineSelected(let selectedLine):
                state.selectedLine = selectedLine
                return .none
                
            case .reportSteopChanged(let step):
                state.reportStep = step
                return .none
                
            default: return .none
            }
        }
    }
}
