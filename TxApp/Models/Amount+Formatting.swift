//
//  Amount+Formatting.swift
//  TxApp
//
//  Created by Alex Smith on 2026-03-20.
//

import Foundation

extension Amount {
    var formatted: String {
        "$\(value.formatted(.number.precision(.fractionLength(2))))"
    }
}
