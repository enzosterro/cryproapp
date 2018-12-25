//
//  Coin.swift
//  CryptoApp
//
//  Created by Enzo Sterro on 02/10/2017.
//  Copyright © 2017 Enzo Sterro. All rights reserved.
//

import Cocoa
import Foundation

struct Coin: Decodable {

    let id: String
    let name: String
    let symbol: String
    let rank: String
    let priceUSD: String
    let priceBTC: String
    let dayVolumeUSD: String
    let marketCapUSD: String
    let availableSupply: String
    let percentChange1h: String
    let percentChange24h: String
    let percentChange7d: String
    let lastUpdated: String

    private enum CodingKeys: String, CodingKey {

        case id, name, symbol, rank
        case priceUSD = "price_usd"
        case priceBTC = "price_btc"
        case dayVolumeUSD = "24h_volume_usd"
        case marketCapUSD = "market_cap_usd"
        case availableSupply = "available_supply"
        case totalSupply = "total_supply"
        case percentChange1h = "percent_change_1h"
        case percentChange24h = "percent_change_24h"
        case percentChange7d = "percent_change_7d"
        case lastUpdated = "last_updated"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        symbol = try values.decode(String.self, forKey: .symbol)
        rank = try values.decode(String.self, forKey: .rank)
        priceUSD = try values.decode(String.self, forKey: .priceUSD)
        priceBTC = try values.decode(String.self, forKey: .priceBTC)
        dayVolumeUSD = try values.decode(String.self, forKey: .dayVolumeUSD)
        marketCapUSD = try values.decode(String.self, forKey: .marketCapUSD)
        availableSupply = try values.decode(String.self, forKey: .availableSupply)
        percentChange1h = try values.decode(String.self, forKey: .percentChange1h)
        percentChange24h = try values.decode(String.self, forKey: .percentChange24h)
        percentChange7d = try values.decode(String.self, forKey: .percentChange7d)
        lastUpdated = try values.decode(String.self, forKey: .lastUpdated)
    }

}
