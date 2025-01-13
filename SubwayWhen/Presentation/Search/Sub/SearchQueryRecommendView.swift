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
            LazyVStack(spacing: 15) {
                ExpandedViewInSUI(alignment: .leading) {
                    Text("혹시 이 역을 찾으셨나요?")
                        .font(.system(size: ViewStyle.FontSize.largeSize, weight: .heavy))
                }
                .padding(.bottom, 10)
                
                ForEach(Array(zip(self.store.filteredSearchQueryRecommendList, self.store.filteredSearchQueryRecommendList.indices)), id: \.1) { data in
                    AnimationButtonInSUI(bgColor: Color.gray.opacity(0.1), tappedBGColor: Color.gray.opacity(0.01), buttonView: {
                        HStack(spacing: 10) {
                            StationTitleViewInSUI(title: data.0.line, lineColor: nil, size: 61, isFill: true, fontSize: ViewStyle.FontSize.smallSize)
                            
                            Text(data.0.stationName)
                                .font(.system(size: ViewStyle.FontSize.mediumSize, weight: .bold))
                            
                            Spacer()
                        }
                        .padding(.horizontal, 5)
                    }, tappedAction: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            self.store.send(.stationTapped(.init(index: data.1, type: .searchQueryRecommend)))
                        }
                    })
                }
                
            }
            .padding(15)
        }
    }
}

#Preview {
    SearchQueryRecommendView(store: .constant(.init(initialState: .init(), reducer: {SearchFeature()})))
}
