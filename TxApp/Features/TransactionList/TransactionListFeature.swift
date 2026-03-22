//
//  TransactionListFeature.swift
//  TxApp
//
//  Created by Alex Smith on 2026-03-21.
//

import ComposableArchitecture
import Foundation

struct TransactionListFeature: Reducer {

    @ObservableState
    struct State: Equatable {
        var transactions: [Transaction] = []
        var isLoading: Bool = false
        var errorMessage: String? = nil
        @Presents var detail: TransactionDetailFeature.State?
    }

    @CasePathable
    enum Action {
        case onAppear
        case transactionsLoaded([Transaction])
        case transactionsFailedToLoad(String)
        case detail(PresentationAction<TransactionDetailFeature.Action>)
        case transactionTapped(Transaction)
    }

    @Dependency(\.transactionClient) var transactionClient

    // Using reduce(into:action:) directly instead of body + Reduce { }
    // to work around a Swift 6.2 compiler bug (Xcode 26) that causes
    // infinite recursion in the Reducer protocol's default _reduce dispatch.
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.isLoading = true
            state.errorMessage = nil
            return .run { send in
                do {
                    let transactions = try await transactionClient.fetchTransactions()
                    await send(.transactionsLoaded(transactions))
                } catch {
                    await send(.transactionsFailedToLoad(error.localizedDescription))
                }
            }

        case .transactionsLoaded(let transactions):
            state.isLoading = false
            state.transactions = transactions
            return .none

        case .transactionsFailedToLoad(let message):
            state.isLoading = false
            state.errorMessage = message
            return .none

        case .transactionTapped(let transaction):
            state.detail = TransactionDetailFeature.State(transaction: transaction)
            return .none

        case .detail(.presented(.closeTapped)):
            state.detail = nil
            return .none

        case .detail(.presented(let detailAction)):
            guard var detailState = state.detail else { return .none }
            let effect = TransactionDetailFeature()
                .reduce(into: &detailState, action: detailAction)
                .map { Action.detail(.presented($0)) }
            state.detail = detailState
            return effect

        case .detail:
            return .none
        }
    }
}

