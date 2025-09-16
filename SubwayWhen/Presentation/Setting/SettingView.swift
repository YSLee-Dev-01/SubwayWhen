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
        Text("SettingView")
    }
}

#Preview {
    SettingView(store: .init(initialState: .init(), reducer: {SettingFeature()}))
}
