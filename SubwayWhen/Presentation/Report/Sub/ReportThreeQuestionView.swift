//
//  ReportThreeQuestionView.swift
//  SubwayWhen
//
//  Created by 이윤수 on 7/21/25.
//

import SwiftUI
import ComposableArchitecture

struct ReportThreeQuestionView: View {
    @Binding var store: StoreOf<ReportFeature>
    @FocusState var isFocusField: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            ExpandedViewInSUI(alignment: .leading) {
                Text(Strings.Report.threeStepTitle)
                    .foregroundColor(.gray)
                    .font(.system(size: ViewStyle.FontSize.smallSize, weight: .semibold))
            }
            .padding(.top, 15)
            
            MainStyleViewInSUI {
                TextField(text: self.$store.insertingData.trainCar) {
                    Text(Strings.Report.threeStepQuestion1)
                        .font(.system(size: ViewStyle.FontSize.mediumSize, weight: .semibold))
                }
                .onSubmit {
                    if self.store.insertingData.trainCar.isEmpty {return}
                    self.isFocusField = false
                    self.store.send(.threeStepCompleted)
                }
                .focused(self.$isFocusField, equals: true)
                .multilineTextAlignment(.trailing)
                .frame(height: 60)
                .padding(.horizontal, 10)
            }
            
            MainStyleViewInSUI {
                Button {
                    self.store.send(.canNotThreeStepBtnTapped)
                    self.isFocusField = false
                } label: {
                    ExpandedViewInSUI(alignment: .center) {
                        Text(Strings.Report.canNotThreeStep)
                            .foregroundStyle(.red)
                            .font(.system(size: ViewStyle.FontSize.smallSize, weight: .semibold))
                    }
                    .frame(height: 40)
                }
            }
        }
        .onAppear {
            self.isFocusField = true
        }
    }
}

#Preview {
    ReportThreeQuestionView(store: .constant(.init(initialState: .init(), reducer: {ReportFeature()})))
}
