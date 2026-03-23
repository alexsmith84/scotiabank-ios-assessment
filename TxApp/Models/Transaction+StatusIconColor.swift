//
//  Transaction+StatusIconColor.swift
//  TxApp
//

import SwiftUI

extension Transaction {
    var statusIconColor: Color {
        transactionType == .credit ? .green : .red
    }
}
