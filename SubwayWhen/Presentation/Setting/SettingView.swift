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
            VStack(spacing: ViewStyle.padding.mainStyleViewTB) {
                SettingTimeView(store: self.store)
            }
            .padding(.top, 12.5)
        }
    }
}

#Preview {
    SettingView(store: .init(initialState: .init(), reducer: {SettingFeature()}))
}
