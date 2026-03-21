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

struct Amount: Decodable {
    let value: Double
    let currency: String
}

struct Transaction: Decodable {
    let key: String
    let transactionType: String
    let merchantName: String
    let description: String?
    let amount: Amount
    let postedDate: String
    let fromAccount: String
    let fromCardNumber: String
}
