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
        let store = TestStore(
            initialState: TransactionListFeature.State()
        ) {
            TransactionListFeature()
        } withDependencies: {
            $0.transactionClient.fetchTransactions = {
                [
                    Transaction(
                        key: "abc123",
                        transactionType: .debit,
                        merchantName: "Test Merchant",
                        description: nil,
                        amount: Amount(value: Decimal(42.00), currency: "CAD"),
                        postedDate: "2026-07-01",
                        fromAccount: "Momentum Regular Visa",
                        fromCardNumber: "4537350001688012"
                    )
                ]
            }
        }

        await store.send(.onAppear) {
            $0.isLoading = true
        }

        await store.receive(\.transactionsLoaded) {
            $0.isLoading = false
            $0.transactions = [
                Transaction(
                    key: "abc123",
                    transactionType: .debit,
                    merchantName: "Test Merchant",
                    description: nil,
                    amount: Amount(value: Decimal(42.00), currency: "CAD"),
                    postedDate: "2026-07-01",
                    fromAccount: "Momentum Regular Visa",
                    fromCardNumber: "4537350001688012"
                )
            ]
        }
    }
}
