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
    @Namespace private var threeStep
    @Namespace private var fourStep
    
    init(store: StoreOf<ReportFeature>) {
        self.store = store
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            NavigationBarScrollViewInSUI(
                title: Strings.Report.title,
                backBtnTapped: {
                    
                },
                backBtnIcon: "arrow.left"
            ) {
                VStack(spacing: 20) {
                    if store.reportStep >= 1 {
                        ReportFirstQuestionView(store: self.$store)
                            .transition(.offset(x: 0, y : -20).combined(with: .opacity))
                    }
                    
                    if store.reportStep >= 2 {
                        ReportSecondQuestionView(store: self.$store)
                            .transition(.offset(x: 0, y : -20).combined(with: .opacity))
                    }
                    
                    if store.reportStep >= 3 {
                        ReportThreeQuestionView(store: self.$store)
                            .id(threeStep)
                            .transition(.offset(x: 0, y : -20).combined(with: .opacity))
                    }
                    
                    if store.reportStep >= 4 {
                        ReportFourQuestionView(store: self.$store)
                            .id(fourStep)
                            .transition(.offset(x: 0, y : -20).combined(with: .opacity))
                    }
                }
            }
            .onChange(of: self.store.reportStep, initial: false) { _, step  in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        switch step {
                        case 3:
                            proxy.scrollTo(threeStep, anchor: .center)
                        case 4:
                            proxy.scrollTo(fourStep, anchor: .center)
                        default:
                            break
                        }
                    }
                }
            }
            .animation(.smooth(duration: 0.3), value: self.store.reportStep)
            .animation(.smooth(duration: 0.3), value: self.store.insertingData)
        }
        .confirmationDialog(self.$store.scope(state: \.dialogState, action: \.dialogAction))
        .onAppear {
            self.store.send(.onAppear)
        }
    }
}

#Preview {
    ReportView(store: .init(initialState: .init(), reducer: {ReportFeature()}))
}
