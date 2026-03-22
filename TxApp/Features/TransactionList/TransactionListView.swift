//
//  TransactionListView.swift
//  TxApp
//
//  Created by Alex Smith on 2026-03-21.
//

import SwiftUI
import ComposableArchitecture

struct TransactionListView: View {
    let store: StoreOf<TransactionListFeature>

    var body: some View {
        NavigationStack {
            Group {
                if store.isLoading {
                    ProgressView()
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
            Text("\(transaction.amount.currency) \(transaction.amount.value, format: .number.precision(.fractionLength(2)))")
                .font(.body)
                .foregroundStyle(.primary)
        }
        .padding(.vertical, 8)
    }
}

#Preview("Transaction List") {
    TransactionListView(
        store: Store(initialState: TransactionListFeature.State(), reducer: {
            TransactionListFeature()
        }, withDependencies: {
            $0.transactionClient = .liveValue
        })
    )
}

#Preview("Transaction Row") {
    TransactionRowView(
        transaction: Transaction(
            key: "abc123",
            transactionType: .debit,
            merchantName: "Test Merchant",
            description: "Bill payment",
            amount: Amount(value: Decimal(42.00), currency: "CAD"),
            postedDate: "2021-05-31",
            fromAccount: "Momentum Regular Visa",
            fromCardNumber: "4537350001688012"
        )
    )
    .padding()
}
