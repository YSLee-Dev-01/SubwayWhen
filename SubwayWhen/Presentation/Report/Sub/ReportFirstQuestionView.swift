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
                    
                    if store.selectedLine == nil {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10),  GridItem(.flexible(), spacing: 10)
                        ]) {
                            ForEach(store.reportableLines, id: \.rawValue) { data in
                                Text(data.useLine)
                                    .font(.system(size: ViewStyle.FontSize.smallSize, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .padding(.init(top: 5, leading: 15, bottom: 5, trailing: 15))
                                    .background {
                                        Circle()
                                            .fill(Color(data.rawValue))
                                            .frame(width: 50, height: 50)
                                    }
                                    .frame(height: 60)
                                    .onTapGesture {
                                        store.send(.reportLineSelected(data))
                                    }
                            }
                        }
                    } else {
                        HStack  {
                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundColor(store.selectedLine == nil ? .gray : .init(uiColor: UIColor(named: store.selectedLine!.rawValue) ?? .gray))
                                .overlay {
                                    Text(store.selectedLine!.useLine)
                                        .foregroundStyle(.white)
                                        .font(.system(size: ViewStyle.FontSize.smallSize, weight: .semibold))
                                }
                            
                            Spacer()
                            
                            Text(store.selectedLine!.useLine)
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
