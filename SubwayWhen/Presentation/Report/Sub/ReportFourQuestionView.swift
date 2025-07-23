//
//  ReportFourQuestionView.swift
//  SubwayWhen
//
//  Created by 이윤수 on 7/23/25.
//

import SwiftUI
import ComposableArchitecture

struct ReportFourQuestionView: View {
    @Binding var store: StoreOf<ReportFeature>
    @FocusState var isFocusField: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            ExpandedViewInSUI(alignment: .leading) {
                Text(Strings.Report.fourStepTitle)
                    .foregroundColor(.gray)
                    .font(.system(size: ViewStyle.FontSize.smallSize, weight: .semibold))
            }
            .padding(.top, 15)
            
            MainStyleViewInSUI {
                VStack(spacing: 10) {
                    ExpandedViewInSUI(alignment: .leading) {
                        Text(Strings.Report.fourStepQuestion)
                            .font(.system(size: ViewStyle.FontSize.mediumSize, weight: .semibold))
                    }
                    .padding(.bottom, 10)
                    
                    LazyVGrid(
                        columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]
                    ) {
                        ForEach(self.store.reportContetns, id: \.title) { data in
                            AnimationButtonInSUI(bgColor: Color.gray.opacity(0.1), buttonView: {
                                VStack(spacing: 10) {
                                    Image(systemName: data.iconName)
                                        .resizable()
                                        .foregroundStyle(Color(uiColor: .label.withAlphaComponent(0.7)))
                                        .frame(width: data.iconSize.width, height: data.iconSize.height, alignment: .center)
                                    
                                    Text(data.title)
                                        .foregroundStyle(Color(uiColor: .label.withAlphaComponent(0.7)))
                                        .font(.system(size: ViewStyle.FontSize.smallSize))
                                    
                                }
                                .padding(5)
                            }, tappedAction: {
                                self.store.send(.fourStepCompleted(data.message))
                            })
                            .padding(.bottom, 5)
                        }
                    }
                    
                    TextField(text: self.$store.insertingData.contants) {
                        Text(Strings.Report.fourStepOptionTitle7)
                            .font(.system(size: ViewStyle.FontSize.smallSize, weight: .semibold))
                    }
                    .onSubmit {
                        self.isFocusField = false
                        self.store.send(.fourStepCompleted(nil))
                    }
                    .focused(self.$isFocusField, equals: true)
                    .frame(height: 40)
                    .padding(.horizontal, 10)
                    .background {
                        RoundedRectangle(cornerRadius: ViewStyle.Layer.radius)
                            .fill(Color.gray.opacity(0.1))
                    }
                    .multilineTextAlignment(.center)
                }
                .padding(15)
            }
        }
    }
}

#Preview {
    ReportFourQuestionView(store: .constant(.init(initialState: .init(), reducer: {ReportFeature()})))
}
