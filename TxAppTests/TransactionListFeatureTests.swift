//
//  TransactionListFeatureTests.swift
//  TxAppTests
//
//  Created by Alex Smith on 2026-03-20.
//

import ComposableArchitecture
import Foundation
import Testing
@testable import TxApp

struct TransactionListFeatureTests {
    @MainActor @Test func onAppearLoadsTransactions() async throws {
        let mockTransaction = Transaction.mock()

        let store = TestStore(
            initialState: TransactionListFeature.State()
        ) {
            TransactionListFeature()
        } withDependencies: {
            $0.transactionClient.fetchTransactions = { [mockTransaction] }
        }

        await store.send(.onAppear) {
            $0.isLoading = true
        }

        await store.receive(\.transactionsLoaded) {
            $0.isLoading = false
            $0.transactions = [mockTransaction]
        }
    }
}
