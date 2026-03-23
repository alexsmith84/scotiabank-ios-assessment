//
//  TransactionListView.swift
//  TxApp
//
//  Created by Alex Smith on 2026-03-21.
//

import SwiftUI
import ComposableArchitecture

struct TransactionListView: View {
    @Bindable var store: StoreOf<TransactionListFeature>

    var body: some View {
        NavigationStack {
            Group {
                if store.isLoading {
                    ProgressView("Loading Transactions...")
                        .font(.caption)
                } else if let errorMessage = store.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    List(store.transactions) { transaction in
                        TransactionRowView(transaction: transaction)
                            .onTapGesture {
                                store.send(.transactionTapped(transaction))
                            }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Transactions")
            .navigationDestination(
                item: $store.scope(state: \.detail, action: \.detail)
            ) { detailStore in
                TransactionDetailView(store: detailStore)
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

struct TransactionRowView: View {
    let transaction: Transaction

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.merchantName)
                    .font(.body)
                    .foregroundStyle(.primary)
                if let description = transaction.description {
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Text(transaction.amount.formatted)
                .font(.body)
                .foregroundStyle(.primary)
        }
        .contentShape(Rectangle())
        .padding(.vertical, 8)
    }
}

#Preview("Transaction List") {
    TransactionListView(
        store: Store(initialState: TransactionListFeature.State(), reducer: {
            TransactionListFeature()
        }, withDependencies: {
            $0.transactionClient.fetchTransactions = {
                // Simulate a network call
                try await Task.sleep(for: .seconds(2))
                return try await TransactionClient.liveValue.fetchTransactions()
            }
        })
    )
}

#Preview("Transaction Row") {
    TransactionRowView(transaction: .mock())
        .padding()
}
