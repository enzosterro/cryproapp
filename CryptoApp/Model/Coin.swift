//
//  Coin.swift
//  CryptoApp
//
//  Created by Enzo Sterro on 02/10/2017.
//  Copyright © 2017 Enzo Sterro. All rights reserved.
//

import Cocoa

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
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let decode: ((CodingKeys) throws -> String) = {
            return try container.decode(String.self, forKey: $0)
        }

        id = try decode(.id)
        name = try decode(.name)
        symbol = try decode(.symbol)
        rank = try decode(.rank)
        priceUSD = try decode(.priceUSD)
        priceBTC = try decode(.priceBTC)
        dayVolumeUSD = try decode(.dayVolumeUSD)
        marketCapUSD = try decode(.marketCapUSD)
        availableSupply = try decode(.availableSupply)
        percentChange1h = try decode(.percentChange1h)
        percentChange24h = try decode(.percentChange24h)
        percentChange7d = try decode(.percentChange7d)
        lastUpdated = try decode(.lastUpdated)
    }

}
