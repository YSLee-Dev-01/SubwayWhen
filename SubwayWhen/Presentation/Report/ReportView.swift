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
            if store.reportStep >= 1 {
                Group {
                    ReportFirstQuestionView(store: self.$store)
                        .transition(.offset(x: 0, y : -20).combined(with: .opacity))
                }
            }
        }
        .animation(.smooth(duration: 0.3), value: self.store.reportStep)
        .animation(.smooth(duration: 0.3), value: self.store.insertingData)
        .onAppear {
            self.store.send(.onAppear)
        }
    }
}

#Preview {
    ReportView(store: .init(initialState: .init(), reducer: {ReportFeature()}))
}
