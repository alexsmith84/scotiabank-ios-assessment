//
//  TransactionListFeature.swift
//  TxApp
//
//  Created by Alex Smith on 2026-03-21.
//

import ComposableArchitecture

@Reducer
struct TransactionListFeature {

    @ObservableState
    struct State: Equatable {
        var transactions: [Transaction] = []
        var isLoading: Bool = false
        var errorMessage: String? = nil
    }

    enum Action {
        case onAppear
        case transactionsLoaded(Result<[Transaction], Error>)
        case transactionTapped(Transaction)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in

        }
    }
}

extension Transaction: Equatable {
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        lhs.key == rhs.key
    }
}
