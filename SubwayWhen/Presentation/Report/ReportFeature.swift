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
    }

    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            default: .none
            }
        }
    }
}
