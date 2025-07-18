//
//  ReportView.swift
//  SubwayWhen
//
//  Created by 이윤수 on 7/18/25.
//

import SwiftUI
import ComposableArchitecture

struct ReportView: View {
    @State private var store:  StoreOf<ReportFeature>
    
    init(store: StoreOf<ReportFeature>) {
        self.store = store
    }
    
    var body: some View {
        NavigationBarScrollViewInSUI(
            title: Strings.Report.title,
            backBtnTapped: {
                
            },
            backBtnIcon: "arrow.left"
        ) {
            Text("ReportView")
        }
    }
}

#Preview {
    ReportView(store: .init(initialState: .init(), reducer: {ReportFeature()}))
}
