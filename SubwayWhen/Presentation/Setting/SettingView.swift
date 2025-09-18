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
    @FocusState private var focusField: Bool
    
    init(store: StoreOf<SettingFeature>) {
        self.store = store
    }
    
    var body: some View {
        NavigationBarScrollViewInSUI(title: Strings.Setting.setting) {
            LazyVStack(spacing: 15) {
                ForEach(self.store.settingSections, id: \.title) { data in
                    ExpandedViewInSUI(alignment: .leading) {
                        Text(data.title)
                            .foregroundColor(.gray)
                            .font(.system(size: ViewStyle.FontSize.smallSize, weight: .semibold))
                    }
                    .padding(.top, 7.5)
                    
                    LazyVStack(spacing: 10) {
                        ForEach(data.cellList, id: \.title) { cell in
                            switch cell.type {
                            case .toggle(let keyPath):
                                SettingToggleView(
                                    title: cell.title,
                                    toggleValue: self.bindingForSetting(keyPath)
                                )
                                
                            case .time:
                                SettingTimeView(store: self.store)
                                
                            case .textField(let keyPath):
                                SettingTextFieldView(
                                    title: cell.title,
                                    textFieldValue: self.bindingForSetting(keyPath),
                                    focusField: self.$focusField
                                )
                                
                            case .navigation(let type):
                                SettingArrowView(title: cell.title) {
                                    self.focusField = false
                                    self.store.send(.navigationTapped(type))
                                }
                            }
                        }
                    }
                }
            }
            .padding(.top, 12.5)
            .ignoresSafeArea(.container, edges: .all)
        }
        .animation(.smooth(duration: 0.25), value: self.store.selectedTimeViewType)
        .onTapGesture {
            self.focusField = false
        }
    }
}

fileprivate extension SettingView {
    private func bindingForSetting<T>(_ keyPath: WritableKeyPath<SaveSetting, T>) -> Binding<T> {
        Binding(
            get: { store.savedSettings[keyPath: keyPath] },
            set: { newValue in
                if let boolValue = newValue as? Bool,
                   let boolKeyPath = keyPath as? WritableKeyPath<SaveSetting, Bool> {
                    store.send(.toggleChanged(boolKeyPath, boolValue))
                } else if let stringValue = newValue as? String,
                          let stringKeyPath =  keyPath as? WritableKeyPath<SaveSetting, String> {
                    store.send(.textFieldChanged(stringKeyPath, stringValue))
                }
            }
        )
    }
}

#Preview {
    SettingView(store: .init(initialState: .init(), reducer: {SettingFeature()}))
}
