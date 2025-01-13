//
//  SearchQueryRecommendView.swift
//  SubwayWhen
//
//  Created by 이윤수 on 1/13/25.
//

import SwiftUI
import ComposableArchitecture

struct SearchQueryRecommendView: View {
    @Binding var store: StoreOf<SearchFeature>
    
    var body: some View {
        MainStyleViewInSUI {
            VStack(spacing: 15) {
                ExpandedViewInSUI(alignment: .leading) {
                    Text("혹시 이 역을 찾으셨나요?")
                        .font(.system(size: ViewStyle.FontSize.largeSize, weight: .heavy))
                }
                    .frame(height: 15)
                
                AnimationButtonInSUI(bgColor: Color.gray.opacity(0.1), tappedBGColor: Color.gray.opacity(0.01), buttonView: {
                    HStack(spacing: 10) {
                        StationTitleViewInSUI(title: "-", lineColor: nil, size: 61, isFill: true, fontSize: ViewStyle.FontSize.smallSize)
                        
                        Text("가산디지털단지")
                            .font(.system(size: ViewStyle.FontSize.mediumSize, weight: .bold))
                        
                        Spacer()
                    }
                    .padding(.horizontal, 5)
                }, tappedAction: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        
                    }
                })
            }
            .padding(15)
        }
    }
}

#Preview {
    SearchQueryRecommendView(store: .constant(.init(initialState: .init(), reducer: {SearchFeature()})))
}
