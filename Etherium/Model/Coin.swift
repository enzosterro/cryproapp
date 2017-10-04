//
//  Coin.swift
//  Etherium
//
//  Created by Enzo Sterro on 02/10/2017.
//  Copyright © 2017 Enzo Sterro. All rights reserved.
//

import Cocoa
import Foundation


struct Coin {
	let id: String
	let name: String
	let price_usd: String
	let symbol: String
	let percent_change_1h: String
	let percent_change_24h: String
	let percent_change_7d: String
	let last_updated: Double
    let icon: NSImage
}

extension Coin {
	
	init?(json: [String: Any]) {
		guard let name = json["name"] as? String,
			let price_usd = json["price_usd"] as? String,
			let symbol = json["symbol"] as? String,
			let id = json["id"] as? String,
			let percent_change_1h = json["percent_change_1h"] as? String,
			let percent_change_24h = json["percent_change_24h"] as? String,
			let percent_change_7d = json["percent_change_7d"] as? String,
			let last_updated = json["last_updated"] as? String,
            let icon = NSImage(named: NSImage.Name(id))
        else { return nil }
		
		self.id = id
		self.name = name
		self.price_usd = price_usd
		self.symbol = symbol
		self.percent_change_1h = percent_change_1h
		self.percent_change_24h = percent_change_24h
		self.percent_change_7d = percent_change_7d
		self.last_updated = Double(last_updated) ?? 0
        self.icon = icon
	}
}
