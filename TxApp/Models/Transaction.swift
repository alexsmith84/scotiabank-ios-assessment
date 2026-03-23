//
//  Transaction.swift
//  TxApp
//
//  Created by Alex Smith on 2026-03-20.
//

import Foundation

struct TransactionResponse: Decodable {
    let transactions: [Transaction]
}

struct Transaction: Decodable, Equatable, Identifiable {
    let key: String
    let transactionType: TransactionType
    let merchantName: String
    let description: String?
    let amount: Amount
    let postedDate: Date
    let fromAccount: String
    let fromCardNumber: String

    var id: String { key }
}

enum TransactionType: String, Decodable, Equatable {
    case debit = "DEBIT"
    case credit = "CREDIT"
}

struct Amount: Decodable, Equatable {
    let value: Decimal
    let currency: String
}

extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

#if DEBUG
extension Transaction {
    static func mock(
        key: String = "abc123",
        transactionType: TransactionType = .debit,
        merchantName: String = "Test Merchant",
        description: String? = "Bill payment",
        amount: Amount = Amount(value: Decimal(42.00), currency: "CAD"),
        postedDate: Date = DateFormatter.yyyyMMdd.date(from: "2021-05-31")!,
        fromAccount: String = "Momentum Regular Visa",
        fromCardNumber: String = "4537350001688012"
    ) -> Transaction {
        Transaction(
            key: key,
            transactionType: transactionType,
            merchantName: merchantName,
            description: description,
            amount: amount,
            postedDate: postedDate,
            fromAccount: fromAccount,
            fromCardNumber: fromCardNumber
        )
    }
}
#endif

