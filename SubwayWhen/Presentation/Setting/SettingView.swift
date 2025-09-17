//
//  SettingView.swift
//  SubwayWhen
//
//  Created by 이윤수 on 9/16/25.
//

import SwiftUI
import ComposableArchitecture

struct SettingView: View {
    @State private var store: StoreOf<SettingFeature>
    
    init(store: StoreOf<SettingFeature>) {
        self.store = store
    }
    
    var body: some View {
        NavigationBarScrollViewInSUI(title: Strings.Setting.setting) {
            LazyVStack(spacing: ViewStyle.padding.mainStyleViewTB) {
                ForEach(self.store.settingSections, id: \.title) { data in
                    ExpandedViewInSUI(alignment: .leading) {
                        Text(data.title)
                            .foregroundColor(.gray)
                            .font(.system(size: ViewStyle.FontSize.smallSize, weight: .semibold))
                    }
                    .padding(.vertical, 15)
                    
                    LazyVStack(spacing: 10) {
                        ForEach(data.cellList, id: \.title) { cell in
                            switch cell.type {
                            case .newVC: Text("newVC")
                            case .toggle: Text("toggle")
                            case .time: SettingTimeView(store: self.store)
                            case .textField: Text("textField")
                            }
                        }
                    }
                }
            }
            .padding(.top, 12.5)
        }
    }
}

#Preview {
    SettingView(store: .init(initialState: .init(), reducer: {SettingFeature()}))
}
