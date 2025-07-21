//
//  ReportSecondQuestionView.swift
//  SubwayWhen
//
//  Created by 이윤수 on 7/21/25.
//

import SwiftUI
import ComposableArchitecture

struct ReportSecondQuestionView: View {
    @Binding var store: StoreOf<ReportFeature>
    
    var body: some View {
        VStack(spacing: 10) {
            ExpandedViewInSUI(alignment: .leading) {
                Text(Strings.Report.twoStepTitle)
                    .foregroundColor(.gray)
                    .font(.system(size: ViewStyle.FontSize.smallSize, weight: .semibold))
            }
            .padding(.top, 15)
            .padding(.bottom, 5)
            
            VStack(spacing: 15) {
                MainStyleViewInSUI {
                    TextField(text: self.$store.insertingData.brand) {
                        Text(Strings.Report.twoStepQuestion1)
                            .font(.system(size: ViewStyle.FontSize.mediumSize, weight: .semibold))
                    }
                    .multilineTextAlignment(.trailing)
                    .frame(height: 60)
                    .padding(.horizontal, 10)
                    
                    MainStyleViewInSUI {
                        TextField(text: self.$store.insertingData.nowStation) {
                            Text(Strings.Report.twoStepQuestion2)
                                .font(.system(size: ViewStyle.FontSize.mediumSize, weight: .semibold))
                        }
                        .multilineTextAlignment(.trailing)
                        .frame(height: 60)
                        .padding(.horizontal, 10)
                    }
                    
                    if self.store.insertingData.selectedLine.hasTwoOperators {
                        MainStyleViewInSUI {
                            VStack(spacing: 10) {
                                ExpandedViewInSUI(alignment: .leading) {
                                    Text(
                                        self.store.insertingData.selectedLine ==  .one ?
                                        Strings.Report.twoStepQuestion3_1 :
                                        self.store.insertingData.selectedLine == .three ?
                                        Strings.Report.twoStepQuestion3_2 :
                                        Strings.Report.twoStepQuestion3_3
                                    )
                                    .font(.system(size: ViewStyle.FontSize.mediumSize, weight: .semibold))
                                }
                                
                                HStack {
                                    Button {
                                        
                                    } label: {
                                        Text("네")
                                            .font(.system(size: ViewStyle.FontSize.smallSize, weight: .semibold))
                                            .foregroundStyle(.white)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 30)
                                            .background {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color.red)
                                            }
                                    }
                                    
                                    Spacer()
                                        .frame(width: 15)

                                    Button {
                                        
                                    } label: {
                                        Text("아니오")
                                            .font(.system(size: ViewStyle.FontSize.smallSize, weight: .semibold))
                                            .foregroundStyle(.white)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 30)
                                            .background {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color.blue)
                                            }
                                    }
                                }
                            }
                            .padding(15)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ReportSecondQuestionView(store: .constant(.init(initialState: .init(), reducer: {ReportFeature()})))
}
