//
//  String+Format.swift
//  CryptoApp
//
//  Created by Enzo Sterro on 02/10/2017.
//  Copyright © 2017 Enzo Sterro. All rights reserved.
//

import Foundation

extension String {
    var formattedWithCurrencySymbol: String {
        return formatWithOptions(initialValue: self, options: (symbol: "$", style: .currency))
    }
    var formattedWithPercentSymbol: String {
        return formatWithOptions(initialValue: self, options: (symbol: "%", style: .percent))
    }
    
    private func formatWithOptions(initialValue: String, options: (symbol: String, style: NumberFormatter.Style)) -> String {
        let defaultValue = initialValue + options.symbol
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = options.style
        numberFormatter.multiplier = 1
        numberFormatter.currencySymbol = options.symbol
        numberFormatter.maximumFractionDigits = 2
        guard let doubled = Double(self) else { return defaultValue }
        return numberFormatter.string(from: NSNumber(value: doubled)) ?? defaultValue
    }
}
