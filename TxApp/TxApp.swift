//
//  TxApp.swift
//  TxApp
//
//  Created by Alex Smith on 2026-03-20.
//

import ComposableArchitecture
import SwiftUI

@main
struct TxApp: App {
    var body: some Scene {
        WindowGroup {
            TransactionListView(
                store: Store(initialState: TransactionListFeature.State()) {
                    TransactionListFeature()
                }
            )
        }
    }
}
