//
//  ReportSecondQuestionView.swift
//  SubwayWhen
//
//  Created by 이윤수 on 7/21/25.
//

import SwiftUI
import ComposableArchitecture

enum FocusType: Hashable {
    case destination, nowStation
}

struct ReportSecondQuestionView: View {
    @Binding var store: StoreOf<ReportFeature>
    @FocusState var focusField: FocusType?
    
    var body: some View {
        VStack(spacing: 15) {
            ExpandedViewInSUI(alignment: .leading) {
                Text(Strings.Report.twoStepTitle)
                    .foregroundColor(.gray)
                    .font(.system(size: ViewStyle.FontSize.smallSize, weight: .semibold))
            }
            .padding(.top, 15)
            
            VStack(spacing: 15) {
                MainStyleViewInSUI {
                    TextField(text: self.$store.insertingData.destination) {
                        Text(Strings.Report.twoStepQuestion1)
                            .font(.system(size: ViewStyle.FontSize.mediumSize, weight: .semibold))
                    }
                    .onSubmit {
                        if self.store.insertingData.destination.isEmpty {return}
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            if self.store.insertingData.nowStation.isEmpty {
                                self.focusField = .nowStation
                            } else {
                                self.focusField = nil
                                
                                if !self.store.insertingData.brand.isEmpty || !self.store.insertingData.selectedLine.hasTwoOperators {
                                    self.store.send(.twoStepCompleted)
                                }
                            }
                        }
                    }
                    .focused(self.$focusField, equals: .destination)
                    .multilineTextAlignment(.trailing)
                    .frame(height: 60)
                    .padding(.horizontal, 10)
                    
                    MainStyleViewInSUI {
                        TextField(text: self.$store.insertingData.nowStation) {
                            Text(Strings.Report.twoStepQuestion2)
                                .font(.system(size: ViewStyle.FontSize.mediumSize, weight: .semibold))
                        }
                        .onSubmit {
                            if self.store.insertingData.nowStation.isEmpty {return}
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                if self.store.insertingData.destination.isEmpty {
                                    self.focusField = .destination
                                } else {
                                    self.focusField = nil
                                    
                                    if !self.store.insertingData.brand.isEmpty || !self.store.insertingData.selectedLine.hasTwoOperators {
                                        self.store.send(.twoStepCompleted)
                                    }
                                }
                            }
                        }
                        .focused(self.$focusField, equals: .nowStation)
                        .multilineTextAlignment(.trailing)
                        .frame(height: 60)
                        .padding(.horizontal, 10)
                    }
                    
                    if self.store.insertingData.selectedLine.hasTwoOperators {
                        MainStyleViewInSUI {
                            VStack(spacing: 15) {
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
                                        self.store.send(.brandBtnTapped(true))
                                    } label: {
                                        Text(Strings.Common.yes)
                                            .font(.system(size: ViewStyle.FontSize.smallSize, weight: .semibold))
                                            .foregroundStyle(.white)
                                            .frame(maxWidth: (self.store.insertingData.brand.isEmpty || self.store.insertingData.brand == "Y") ? .infinity : 75)
                                            .frame(height: 35)
                                            .background {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .fill(Color.red)
                                            }
                                    }
                                    
                                    Spacer()
                                        .frame(width: 15)

                                    Button {
                                        self.store.send(.brandBtnTapped(false))
                                    } label: {
                                        Text(Strings.Common.no)
                                            .font(.system(size: ViewStyle.FontSize.smallSize, weight: .semibold))
                                            .foregroundStyle(.white)
                                            .frame(maxWidth: (self.store.insertingData.brand.isEmpty || self.store.insertingData.brand == "N") ? .infinity : 75)
                                            .frame(height: 35)
                                            .background {
                                                RoundedRectangle(cornerRadius: 15)
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
        .onAppear {
            self.focusField = .destination
        }
    }
}

#Preview {
    ReportSecondQuestionView(store: .constant(.init(initialState: .init(), reducer: {ReportFeature()})))
}
