//
//  ReportView.swift
//  SubwayWhen
//
//  Created by 이윤수 on 7/18/25.
//

import SwiftUI
import ComposableArchitecture

enum ReportFocusType: Hashable {
    case destination, nowStation, trainCar, contants
}

struct ReportView: View {
    @State private var store:  StoreOf<ReportFeature>
    @Namespace private var threeStep
    @Namespace private var fourStep
    
    @FocusState private var focusField: ReportFocusType?
    
    init(store: StoreOf<ReportFeature>) {
        self.store = store
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            NavigationBarScrollViewInSUI(
                title: Strings.Report.title,
                backBtnTapped: {
                    self.store.send(.backBtnTapped)
                },
                backBtnIcon: "arrow.left"
            ) {
                VStack(spacing: 20) {
                    if store.reportStep >= 1 {
                        ReportFirstQuestionView(store: self.$store)
                            .transition(.offset(x: 0, y : -20).combined(with: .opacity))
                    }
                    
                    if store.reportStep >= 2 {
                        ReportSecondQuestionView(store: self.$store, focusField: self.$focusField)
                            .transition(.offset(x: 0, y : -20).combined(with: .opacity))
                    }
                    
                    if store.reportStep >= 3 {
                        ReportThreeQuestionView(store: self.$store, focusField: self.$focusField)
                            .id(threeStep)
                            .transition(.offset(x: 0, y : -20).combined(with: .opacity))
                    }
                    
                    if store.reportStep >= 4 {
                        ReportFourQuestionView(store: self.$store, focusField: self.$focusField)
                            .id(fourStep)
                            .transition(.offset(x: 0, y : -20).combined(with: .opacity))
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
                .animation(.smooth(duration: 0.25), value: self.store.reportStep)
                .animation(.smooth(duration: 0.25), value: self.store.insertingData)
            }
        }
        .onTapGesture {
            self.focusField = nil
        }
        .confirmationDialog(self.$store.scope(state: \.dialogState, action: \.dialogAction))
        .onAppear {
            self.store.send(.onAppear)
        }
        .onDisappear {
            self.store.send(.onDisappear)
        }
    }
}

#Preview {
    ReportView(store: .init(initialState: .init(), reducer: {ReportFeature()}))
}
