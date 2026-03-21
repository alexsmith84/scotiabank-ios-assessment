//
//  DataModels.swift
//  TxApp
//
//  Created by Alex Smith on 2026-03-20.
//

import Foundation

struct TransactionResponse: Decodable {
    let transactions: [Transaction]
}

struct Transaction: Decodable, Equatable {
    let key: String
    let transactionType: TransactionType
    let merchantName: String
    let description: String?
    let amount: Amount
    let postedDate: String
    let fromAccount: String
    let fromCardNumber: String
}

enum TransactionType: String, Decodable, Equatable {
    case debit = "DEBIT"
    case credit = "CREDIT"
}

struct Amount: Decodable, Equatable {
    let value: Decimal
    let currency: String
}
