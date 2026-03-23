//
//  TransactionListFeatureTests.swift
//  TxAppTests
//
//  Created by Alex Smith on 2026-03-20.
//

import ComposableArchitecture
import Foundation
import SwiftUI
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

    @MainActor @Test func onAppearSetsErrorOnFailure() async throws {
        struct FetchError: Error, LocalizedError {
            var errorDescription: String? { "Network unavailable" }
        }

        let store = TestStore(
            initialState: TransactionListFeature.State()
        ) {
            TransactionListFeature()
        } withDependencies: {
            $0.transactionClient.fetchTransactions = { throw FetchError() }
        }

        await store.send(.onAppear) {
            $0.isLoading = true
        }

        await store.receive(\.transactionsFailedToLoad) {
            $0.isLoading = false
            $0.errorMessage = "Network unavailable"
        }
    }

    @MainActor @Test func onAppearSkipsRefetchWhenAlreadyLoaded() async throws {
        let store = TestStore(
            initialState: TransactionListFeature.State(
                transactions: [.mock()]
            )
        ) {
            TransactionListFeature()
        }

        await store.send(.onAppear)
        // No state change and no effect — test would fail if an action were received
    }

    @MainActor @Test func transactionTappedPresentsDetail() async throws {
        let transaction = Transaction.mock()

        let store = TestStore(
            initialState: TransactionListFeature.State(
                transactions: [transaction]
            )
        ) {
            TransactionListFeature()
        }

        await store.send(.transactionTapped(transaction)) {
            $0.detail = TransactionDetailFeature.State(transaction: transaction)
        }
    }

    @MainActor @Test func closeTappedDismissesDetail() async throws {
        let transaction = Transaction.mock()

        let store = TestStore(
            initialState: TransactionListFeature.State(
                transactions: [transaction],
                detail: TransactionDetailFeature.State(transaction: transaction)
            )
        ) {
            TransactionListFeature()
        }

        await store.send(.detail(.presented(.closeTapped))) {
            $0.detail = nil
        }
    }

    @MainActor @Test func tooltipToggledUpdatesDetailState() async throws {
        let transaction = Transaction.mock()

        let store = TestStore(
            initialState: TransactionListFeature.State(
                transactions: [transaction],
                detail: TransactionDetailFeature.State(transaction: transaction)
            )
        ) {
            TransactionListFeature()
        }

        await store.send(.detail(.presented(.tooltipToggled(true)))) {
            $0.detail?.isTooltipExpanded = true
        }

        await store.send(.detail(.presented(.tooltipToggled(false)))) {
            $0.detail?.isTooltipExpanded = false
        }
    }

    @Test func statusIconColorIsGreenForCredit() {
        let transaction = Transaction.mock(transactionType: .credit)
        #expect(transaction.statusIconColor == Color.green)
    }

    @Test func statusIconColorIsRedForDebit() {
        let transaction = Transaction.mock(transactionType: .debit)
        #expect(transaction.statusIconColor == Color.red)
    }
}
