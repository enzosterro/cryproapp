//
//  Ticker.swift
//  CryptoApp
//
//  Created by Enzo Sterro on 05/10/2017.
//  Copyright © 2017 Enzo Sterro. All rights reserved.
//

import Foundation

struct Ticker {

    private struct Constants {

        static let baseURLScheme = "https"
        static let baseURLHost = "api.coinmarketcap.com"
        static let APIPath = "/v1/ticker/"

    }

    private static var baseURLComponents: URLComponents = {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.baseURLScheme
        urlComponents.host = Constants.baseURLHost
        urlComponents.path = Constants.APIPath
        return urlComponents
    }()

    static var baseURL: URL = {
        return baseURLComponents.url!
    }()

    static var baseURLForTopCurrencies: URL = {
        var baseURLComponents = Ticker.baseURLComponents
        let queryItem = URLQueryItem(name: "limit", value: "100")
        baseURLComponents.queryItems = [queryItem]
        return baseURLComponents.url!
    }()

}
