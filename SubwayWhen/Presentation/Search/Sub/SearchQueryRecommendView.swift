//
//  SearchQueryRecommendView.swift
//  SubwayWhen
//
//  Created by 이윤수 on 1/13/25.
//

import SwiftUI
import ComposableArchitecture

struct SearchQueryRecommendView: View {
    @Binding var store: StoreOf<SearchFeature>
    
    var body: some View {
        Text("SearchQueryRecommendView")
    }
}

#Preview {
    SearchQueryRecommendView(store: .constant(.init(initialState: .init(), reducer: {SearchFeature()})))
}
