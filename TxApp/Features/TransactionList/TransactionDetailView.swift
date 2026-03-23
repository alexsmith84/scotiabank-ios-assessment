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
        GeometryReader { geo in
            let bottomInset = geo.safeAreaInsets.bottom

            VStack(spacing: 24) {
                // MARK: - Status Header
                VStack(spacing: 24) {
                    Image("success-icon")
                        .font(.system(size: 64))
                        .foregroundStyle(store.transaction.transactionType == .credit ? .green : .red)

                    Text(store.transaction.transactionType == .credit ? "Credit transaction" : "Debit transaction")
                        .font(.title3)
                }
                .padding(.top, 24)
                .padding(.bottom, 32)

                // MARK: - Transaction Details
                VStack(alignment: .leading, spacing: 16) {
                    DetailRowView(
                        label: "From",
                        value: store.transaction.merchantName,
                        suffix: "(\(store.transaction.fromCardNumber.suffix(4)))"
                    )

                    Divider()
                    DetailRowView(
                        label: "Amount",
                        value: "$\(store.transaction.amount.value.formatted(.number.precision(.fractionLength(2))))"
                    )
                }
                .padding(.horizontal, 20)

                // MARK: - Tooltip
                TooltipView(isExpanded: $store.isTooltipExpanded.sending(\.tooltipToggled))
                    .padding(.horizontal, 20)

                Spacer(minLength: 0)

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
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding(.horizontal, 12)
                .padding(.bottom, bottomInset + 12)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray4), lineWidth: 1)
                    .padding(.bottom, bottomInset)
            )
            .padding(.horizontal, 16)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Transaction Details")
                    .font(.title2)
            }
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .safeAreaInset(edge: .top, spacing: 8) {
            VStack(spacing: 0) {
                Divider()
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color.black.opacity(0.08), Color.clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 4)
            }
        }
    }
}

// MARK: - Detail Row
struct DetailRowView: View {
    let label: String
    let value: String
    var suffix: String? = nil

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.vertical, 2)
            Group {
                if let suffix {
                    Text("\(value) \(Text(suffix).foregroundColor(Color.gray.opacity(0.6)))")
                } else {
                    Text(value)
                }
            }
            .font(.subheadline)
            .foregroundStyle(Color.black.opacity(0.75))
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
                    if isExpanded {
                        Text("\(baseMessage)")
                        Text("\(expandedMessage) **[Show less](action://toggle)**")
                            .transition(.opacity)
                    } else {
                        Text("\(baseMessage) **[Show more](action://toggle)**")
                    }
                }
                .tint(.blue)
                .foregroundColor(Color.black.opacity(0.75))
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
        .environment(\.openURL, OpenURLAction { _ in
            withAnimation {
                isExpanded.toggle()
            }
            return .handled
        })
    }
}

#Preview("Detail - Debit") {
    NavigationStack {
        TransactionDetailView(
            store: Store(
                initialState: TransactionDetailFeature.State(transaction: .mock())
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
                    transaction: .mock(
                        key: "xyz456",
                        transactionType: .credit,
                        merchantName: "Refund - Apple Store",
                        description: nil,
                        amount: Amount(value: 199.99, currency: "CAD"),
                        postedDate: DateFormatter.yyyyMMdd.date(from: "2021-06-15")!
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
                    transaction: .mock(),
                    isTooltipExpanded: true
                )
            ) {
                TransactionDetailFeature()
            }
        )
    }
}
