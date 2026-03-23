//
//  TransactionClient+Dependencies.swift
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
            [.mock()]
        }
    }
}

extension DependencyValues {
    var transactionClient: TransactionClient {
        get { self[TransactionClient.self] }
        set { self[TransactionClient.self] = newValue }
    }
}

