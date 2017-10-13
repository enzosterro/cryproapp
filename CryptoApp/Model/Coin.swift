//
//  Coin.swift
//  CryptoApp
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
    let percentChange1h: String
    let percentChange24h: String
    let percentChange7d: String
	let last_updated: Double
}

extension Coin {
	init?(json: [String: Any]) {
		guard let id = json["id"] as? String,
            let name = json["name"] as? String,
            let price_usd = json["price_usd"] as? String,
            let symbol = json["symbol"] as? String,
            let percentChange1h = json["percent_change_1h"] as? String,
            let percentChange24h = json["percent_change_24h"] as? String,
            let percentChange7d = json["percent_change_7d"] as? String,
			let last_updated = json["last_updated"] as? String
        else {
            NSLog("Coulnd't parse Coin: %@", json["name"] as? String ?? "undefined")
            return nil
        }
		
		self.id = id
		self.name = name
		self.price_usd = price_usd
		self.symbol = symbol
        self.percentChange1h = percentChange1h
        self.percentChange24h = percentChange24h
        self.percentChange7d = percentChange7d
		self.last_updated = Double(last_updated) ?? 0
	}
}
