//
//  Date+GetDate.swift
//  Etherium
//
//  Created by Aleksandr Kundelev on 03/10/2017.
//  Copyright © 2017 Aleksandr Kundelev. All rights reserved.
//

import Foundation

extension Double {
	var formattedDate: String {
		let date = Date(timeIntervalSince1970: self)
		let dateFormatter = DateFormatter()
		dateFormatter.locale = NSLocale.current
		dateFormatter.dateStyle = .short
		dateFormatter.timeStyle = .short
		dateFormatter.doesRelativeDateFormatting = true
		let lastUpdatedPrefix = NSLocalizedString("Last updated: ", comment: "Last updated menu item text.")
		return lastUpdatedPrefix + dateFormatter.string(from: date)
	}
}
