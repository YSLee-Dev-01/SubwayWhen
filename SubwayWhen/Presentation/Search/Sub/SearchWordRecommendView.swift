//
//  SearchWordRecommendView.swift
//  SubwayWhen
//
//  Created by 이윤수 on 12/5/24.
//

import SwiftUI
import ComposableArchitecture

struct SearchWordRecommendView: View {
    @Binding var store: StoreOf<SearchFeature>
    
    var body: some View {
        MainStyleViewInSUI {
            VStack(spacing: 15) {
                ExpandedViewInSUI(alignment: .leading) {
                    Text("자주 검색되는 지하철역")
                        .font(.system(size: ViewStyle.FontSize.largeSize, weight: .heavy))
                }
            
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)]) {
                    ForEach(Array(zip(self.store.state.nowRecommendStationList, self.store.state.nowRecommendStationList.indices)), id: \.1) { data, index in
                        AnimationButtonInSUI(bgColor: Color.gray.opacity(0.1), tappedBGColor: Color.gray.opacity(0.01), buttonView: {
                            ExpandedViewInSUI(alignment: .center) {
                                Text(data)
                                    .foregroundStyle(Color(uiColor: UIColor.label).opacity(0.8))
                                    .font(.system(size: ViewStyle.FontSize.smallSize, weight: .semibold))
                            }
                            .padding(5)
                        }, tappedAction: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                self.store.send(.stationTapped(.init(index: index, type: .recommend)))
                            }
                        })
                        .padding(.vertical, 5)
                    }
                }
            }
            .padding(15)
        }
        .padding(.bottom, 20)
    }
}


#Preview {
    SearchWordRecommendView(store: .constant(.init(initialState: .init(), reducer: {SearchFeature()})))
}
