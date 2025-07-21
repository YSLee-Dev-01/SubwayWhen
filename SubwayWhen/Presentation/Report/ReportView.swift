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
                .padding(.bottom, 20)
            }
            
            if store.reportStep >= 2 {
                Group {
                    ReportSecondQuestionView(store: self.$store)
                        .transition(.offset(x: 0, y : -20).combined(with: .opacity))
                }
                .padding(.bottom, 20)
            }
            
            if store.reportStep >= 3 {
                Group {
                    ReportThreeQuestionView(store: self.$store)
                        .transition(.offset(x: 0, y : -20).combined(with: .opacity))
                }
                .padding(.bottom, 20)
            }
        }
        .animation(.smooth(duration: 0.3), value: self.store.reportStep)
        .animation(.smooth(duration: 0.3), value: self.store.insertingData)
        .confirmationDialog(self.$store.scope(state: \.dialogState, action: \.dialogAction))
        .onAppear {
            self.store.send(.onAppear)
        }
    }
}

#Preview {
    ReportView(store: .init(initialState: .init(), reducer: {ReportFeature()}))
}
