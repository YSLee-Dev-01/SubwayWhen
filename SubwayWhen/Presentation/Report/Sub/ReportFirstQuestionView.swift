//
//  ReportFirstQuestionView.swift
//  SubwayWhen
//
//  Created by 이윤수 on 7/18/25.
//

import SwiftUI
import ComposableArchitecture

struct ReportFirstQuestionView: View {
    @Binding var store: StoreOf<ReportFeature>
    
    var body: some View {
        VStack(spacing: 10) {
            ExpandedViewInSUI(alignment: .leading) {
                Text(Strings.Report.oneStepTitle)
                    .foregroundColor(.gray)
                    .font(.system(size: ViewStyle.FontSize.smallSize, weight: .semibold))
            }
            .padding(.top, 15)
            .padding(.bottom, 5)
            
            MainStyleViewInSUI {
                VStack(spacing: 10) {
                    ExpandedViewInSUI(alignment: .leading) {
                        Text(Strings.Report.oneStepQuestion)
                            .font(.system(size: ViewStyle.FontSize.largeSize, weight: .bold))
                    }
                    .padding(.bottom, 10)
                    
                    if self.store.insertingData.selectedLine == .not {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 0), GridItem(.flexible(), spacing: 0),  GridItem(.flexible(), spacing: 0)
                        ], spacing: 7) {
                            ForEach(self.store.reportableLines, id: \.rawValue) { data in
                                HStack {
                                    AnimationButtonInSUI(bgColor: .clear, tappedBGColor: Color.gray.opacity(0.01), btnPadding: 0, buttonView: {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color(data.rawValue))
                                            .padding(.init(top: 5, leading: 0, bottom: 5, trailing: 5))
                                            .frame(height: 30)
                                            .layoutPriority(0)
                                        
                                        Text(data.useLine)
                                            .font(.system(size: ViewStyle.FontSize.smallSize, weight: .semibold))
                                            .layoutPriority(1)
                                    }, tappedAction: {
                                        self.store.send(.reportLineSelected(data))
                                    })
                                }
                            }
                        }
                    } else {
                        HStack  {
                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundColor(self.store.insertingData.selectedLine == .not ? .gray : .init(uiColor: UIColor(named: self.store.insertingData.selectedLine.rawValue) ?? .gray))
                                .overlay {
                                    Text(self.store.insertingData.selectedLine.useLine)
                                        .foregroundStyle(.white)
                                        .font(.system(size: ViewStyle.FontSize.smallSize, weight: .semibold))
                                }
                            
                            Spacer()
                            
                            Text(self.store.insertingData.selectedLine.useLine)
                                .foregroundStyle(.gray)
                                .font(.system(size: ViewStyle.FontSize.mediumSize, weight: .semibold))
                        }
                    }
                }
                .padding(15)
            }
        }
    }
}

#Preview {
    ReportFirstQuestionView(store: .constant(.init(initialState: ReportFeature.State(), reducer: {ReportFeature()})))
}
