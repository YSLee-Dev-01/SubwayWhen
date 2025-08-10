//
//  ReportFeature.swift
//  SubwayWhen
//
//  Created by 이윤수 on 7/18/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ReportFeature: Reducer {
    @ObservableState
    struct State: Equatable {
        let reportableLines = SubwayLineData.allCases.filter {$0.allowReport}
        let reportContetns = ReportContentData.defaultDataList
        var reportStep = 0
        var insertingData: ReportMSGData
        
        @Presents  var dialogState: ConfirmationDialogState<Action.DialogAction>?
        
        init() {
            self.insertingData = ReportMSGData()
        }
        
        init(selectedLine: SubwayLineData?, stationName: String?) {
            self.insertingData = ReportMSGData(selectedLine: selectedLine == nil ? .not : selectedLine!, nowStation: stationName ?? "")
        }
    }

    enum Action: BindableAction, Equatable {
        case onAppear
        case onDisappear
        case backBtnTapped
        case binding(BindingAction<State>)
        case reportSteopChanged(Int)
        case brandBtnTapped(Bool)
        case canNotThreeStepBtnTapped
        
        case reportLineSelected(SubwayLineData)
        case twoStepCompleted
        case threeStepCompleted
        case fourStepCompleted(String)
        
        case dialogAction(PresentationAction<DialogAction>)
        
        enum DialogAction: Equatable {
            case notInsertBtnTapped
            case okBtnTapped
        }
    }
    
    weak var delegate : ReportVCDelegate?
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.reportStep == 0 {
                    return state.insertingData.selectedLine == .not ? self.reportStepChange(1) : self.reportStepChange(2)
                } else {
                    return .none
                }
            
            case .onDisappear:
                self.delegate?.disappear()
                return .none
                
            case .backBtnTapped:
                self.delegate?.pop()
                return .none
                
            case .reportLineSelected(let selectedLine):
                state.insertingData = .init(selectedLine: selectedLine)
                return self.reportStepChange(2)
                
            case .reportSteopChanged(let step):
                state.reportStep = step
                return .none
                
            case .brandBtnTapped(let isYBtn):
                state.insertingData.brand = isYBtn ? "Y" : "N"
                
                if !state.insertingData.destination.isEmpty && !state.insertingData.nowStation.isEmpty {
                    return .send(.twoStepCompleted)
                } else {
                    return .none
                }
                
            case .twoStepCompleted:
                if state.reportStep == 2 {
                    return self.reportStepChange(3)
                } else {
                    return .none
                }
                
            case .canNotThreeStepBtnTapped:
                state.dialogState = .init(title: {
                    TextState("")
                }, actions: {
                    ButtonState(role: .cancel) {
                        TextState(Strings.Report.threeStepPassAlertNo)
                    }
                    
                    ButtonState( action: .notInsertBtnTapped) {
                        TextState(Strings.Report.threeStepPassAlertYes)
                    }
                }, message: {
                    TextState(Strings.Report.threeStepPassAlert)
                })
                return .none
                
            case .dialogAction(let action):
                switch action {
                case .presented(let okBtnAction):
                    switch okBtnAction {
                    case .notInsertBtnTapped:
                        state.dialogState = nil
                        state.insertingData.trainCar = ""
                        return .send(.threeStepCompleted)
                        
                    case .okBtnTapped:
                        return .none
                    }
                default: break
                }
                state.dialogState = nil
                return .none
                
            case .threeStepCompleted:
                return self.reportStepChange(4)
                
            case .fourStepCompleted(let content):
                state.insertingData.contants = content
                
                if state.insertingData.destination.isEmpty || state.insertingData.contants.isEmpty || state.insertingData.nowStation.isEmpty {
                    state.dialogState = .init(title: {
                        TextState("")
                    }, actions: {
                        ButtonState(role: .cancel) {
                            TextState(Strings.Common.cancel)
                        }
                        
                        ButtonState( action: .okBtnTapped) {
                            TextState(Strings.Common.check)
                        }
                    }, message: {
                        TextState(Strings.Report.cannotReportAlertTitle)
                    })
                } else {
                    self.delegate?.moveToReportCheck(data: state.insertingData)
                }
                
                return .none
                
            default: return .none
            }
        }
    }
    
    private func reportStepChange(_ step: Int) -> Effect<Action> {
        return .run { send in
            try? await Task.sleep(for: .milliseconds(250))
            await send(.reportSteopChanged(step))
        }
    }
}
