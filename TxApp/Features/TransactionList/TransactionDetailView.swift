//
//  TransactionDetailView.swift
//  TxApp
//
//  Created by Alex Smith on 2026-03-22.
//

import SwiftUI
import ComposableArchitecture

struct TransactionDetailView: View {
    @Bindable var store: StoreOf<TransactionDetailFeature>

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 24) {
                    // MARK: - Status Header
                    VStack(spacing: 8) {
                        Image("success-icon")
                            .font(.system(size: 64))
                            .foregroundStyle(store.transaction.transactionType == .credit ? .green : .red)

                        Text(store.transaction.transactionType == .credit ? "Credit transaction" : "Debit transaction")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    .padding(.top, 32)

                    // MARK: - Transaction Details
                    VStack(alignment: .leading, spacing: 16) {
                        DetailRowView(label: "From", value: store.transaction.merchantName)
                        DetailRowView(
                            label: "Amount",
                            value: "\(store.transaction.amount.currency) \(store.transaction.amount.value.formatted(.number.precision(.fractionLength(2))))"
                        )
                    }
                    .padding(.horizontal, 38)

                    // MARK: - Tooltip
                    TooltipView(isExpanded: $store.isTooltipExpanded.sending(\.tooltipToggled))
                        .padding(.horizontal, 38)

                    Spacer()

                    // MARK: - Close Button
                    Button {
                        store.send(.closeTapped)
                    } label: {
                        Text("Close")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.red)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
                }
                .frame(minHeight: geometry.size.height)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Detail Row
struct DetailRowView: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.subheadline)
                .multilineTextAlignment(.trailing)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Tooltip
struct TooltipView: View {
    @Binding var isExpanded: Bool

    private let baseMessage = "Transactions are processed Monday to Friday (excluding holidays)."
    private let expandedMessage = "Transactions made before 8:30 pm ET Monday to Friday (excluding holidays) will show up in your account the same day."

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Image("buddy-tip-icon")
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(baseMessage) \(Text(isExpanded ? "" : "Show more").bold().foregroundStyle(.blue))")
                    if isExpanded {
                        Text("\(expandedMessage) \(Text("Show less").bold().foregroundStyle(.blue))")
                            .transition(.opacity)
                    }
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .clipped()
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.systemGray4), lineWidth: 1))
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .onTapGesture {
            withAnimation {
                isExpanded.toggle()
            }
        }
    }
}

#Preview("Detail - Debit") {
    NavigationStack {
        TransactionDetailView(
            store: Store(
                initialState: TransactionDetailFeature.State(
                    transaction: Transaction(
                        key: "abc123",
                        transactionType: .debit,
                        merchantName: "Test Merchant",
                        description: "Bill payment",
                        amount: Amount(value: 42.00, currency: "CAD"),
                        postedDate: "2021-05-31",
                        fromAccount: "Momentum Regular Visa",
                        fromCardNumber: "4537350001688012"
                    )
                )
            ) {
                TransactionDetailFeature()
            }
        )
    }
}

#Preview("Detail - Credit") {
    NavigationStack {
        TransactionDetailView(
            store: Store(
                initialState: TransactionDetailFeature.State(
                    transaction: Transaction(
                        key: "xyz456",
                        transactionType: .credit,
                        merchantName: "Refund - Apple Store",
                        description: nil,
                        amount: Amount(value: 199.99, currency: "CAD"),
                        postedDate: "2021-06-15",
                        fromAccount: "Momentum Regular Visa",
                        fromCardNumber: "4537350001688012"
                    )
                )
            ) {
                TransactionDetailFeature()
            }
        )
    }
}

#Preview("Detail - Tooltip Expanded") {
    NavigationStack {
        TransactionDetailView(
            store: Store(
                initialState: TransactionDetailFeature.State(
                    transaction: Transaction(
                        key: "abc123",
                        transactionType: .debit,
                        merchantName: "Test Merchant",
                        description: "Bill payment",
                        amount: Amount(value: 42.00, currency: "CAD"),
                        postedDate: "2021-05-31",
                        fromAccount: "Momentum Regular Visa",
                        fromCardNumber: "4537350001688012"
                    ),
                    isTooltipExpanded: true
                )
            ) {
                TransactionDetailFeature()
            }
        )
    }
}
