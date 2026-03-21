//
//  TransactionClientTests.swift
//  TxAppTests
//
//  Created by Alex Smith on 2026-03-21.
//

import ComposableArchitecture
import Foundation
import Testing
@testable import TxApp

struct TransactionClientTests {
    @Test func canReadTransactionListFromDisk() async throws {
        let transactions = try await TransactionClient.live.fetchTransactions()
        #expect(transactions.count == 33)
    }

    @Test func canReadTransactionListFromMemory() async throws {
        let transactions = try await TransactionClient.testValue.fetchTransactions()
        #expect(transactions.count == 1)
    }
}
