//
//  Extensions.swift
//  TxApp
//
//  Created by Alex Smith on 2026-03-21.
//

import ComposableArchitecture
import Foundation

extension TransactionClient: DependencyKey {
    static var liveValue: Self { .live }

    static var testValue: Self {
        Self {
            [
                Transaction(
                    key: "abc123",
                    transactionType: .debit,
                    merchantName: "Test Merchant",
                    description: "Bill Payment",
                    amount: Amount(value: Decimal(42.00), currency: "CAD"),
                    postedDate: "2026-07-01",
                    fromAccount: "Momentum Regular Visa",
                    fromCardNumber: "4537350001688012"
                )
            ]
        }
    }
}

extension DependencyValues {
    var transactionClient: TransactionClient {
        get { self[TransactionClient.self] }
        set { self[TransactionClient.self] = newValue }
    }
}

