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
                            case .toggle(let keyPath):
                                SettingToggleView(title: cell.title, toggleValue: bindingForSetting(keyPath))
                            case .time(let work, let leave):
                                SettingTimeView(
                                    workTime: work,
                                    leaveTime: leave,
                                    store: self.store
                                )
                            case .textField(let keyPath): Text("textField")
                            case .navigation(let type):
                                SettingArrowView(title: cell.title) {
                                    self.store.send(.navigationTapped(type))
                                }
                            }
                        }
                    }
                }
            }
            .padding(.top, 12.5)
        }
    }
}

fileprivate extension SettingView {
    private func bindingForSetting<T>(_ keyPath: WritableKeyPath<SaveSetting, T>) -> Binding<T> {
        Binding(
            get: { FixInfo.saveSetting[keyPath: keyPath] },
            set: { newValue in
                var setting = FixInfo.saveSetting
                setting[keyPath: keyPath] = newValue
                FixInfo.saveSetting = setting
            }
        )
    }
}

#Preview {
    SettingView(store: .init(initialState: .init(), reducer: {SettingFeature()}))
}
