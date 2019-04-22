//
//  String+Format.swift
//  CryptoApp
//
//  Created by Enzo Sterro on 02/10/2017.
//  Copyright © 2017 Enzo Sterro. All rights reserved.
//

import Foundation


extension String {

    func format(with style: NumberFormatter.Style) -> String {
        guard let timeInterval = TimeInterval(self) else { return "" }

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        numberFormatter.multiplier = 1
        numberFormatter.currencySymbol = "$"
        numberFormatter.maximumFractionDigits = 3

        return numberFormatter.string(from: NSNumber(value: timeInterval)) ?? ""
    }

    var formattedAsStringDate: String {
        guard let timeInterval = TimeInterval(self) else { return "" }
        let date = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let lastUpdatedPrefix = NSLocalizedString("Last updated: ", comment: "Last updated menu item text.")

        return lastUpdatedPrefix + formatter.string(from: date)
    }

}
