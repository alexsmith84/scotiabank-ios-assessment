//
//  TxAppTests.swift
//  TxAppTests
//
//  Created by Alex Smith on 2026-03-20.
//

import Foundation
import Testing
@testable import TxApp

private class BundleLocator {}

struct TxAppTests {
    @Test func canReadTransactionListFromDisk() async throws {
        let transactions = try await TransactionClient.readTransactions()
        #expect(transactions.count == 33)
    }
}
