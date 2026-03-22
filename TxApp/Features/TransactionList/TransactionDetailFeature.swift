//
//  TransactionDetailFeature.swift
//  TxApp
//
//  Created by Alex Smith on 2026-03-22.
//

import ComposableArchitecture

@Reducer
struct TransactionDetailFeature {

    @ObservableState
    struct State: Equatable {
        let transaction: Transaction
        var isTooltipExpanded: Bool = false
    }

    enum Action {
        case closeTapped
        case tooltipToggled(Bool)
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .closeTapped:
            return .none
        case .tooltipToggled(let isExpanded):
            state.isTooltipExpanded = isExpanded
            return .none
        }
    }
}
