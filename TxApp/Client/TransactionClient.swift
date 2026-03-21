//
//  TransactionClient.swift
//  TxApp
//
//  Created by Alex Smith on 2026-03-20.
//

import Foundation

enum TransactionClient {
    static func readTransactions() async throws -> [Transaction] {
        guard let url = Bundle.main.url(forResource: "transaction-list", withExtension: "json") else {
            throw URLError(.fileDoesNotExist)
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decoded = try decoder.decode(TransactionResponse.self, from: data)
        return decoded.transactions
    }
}
