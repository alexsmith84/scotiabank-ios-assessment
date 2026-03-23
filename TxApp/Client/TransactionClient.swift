//
//  TransactionClient.swift
//  TxApp
//
//  Created by Alex Smith on 2026-03-20.
//

import Foundation

struct TransactionClient {
    var fetchTransactions: () async throws -> [Transaction]
}

extension TransactionClient {
    static var live: Self {
        Self {
            guard let url = Bundle.main.url(forResource: "transaction-list", withExtension: "json") else {
                throw URLError(.fileDoesNotExist)
            }
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .formatted(.yyyyMMdd)
            let decoded = try decoder.decode(TransactionResponse.self, from: data)
            return decoded.transactions
        }
    }
}
