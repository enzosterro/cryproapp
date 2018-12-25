//
//  CryptoAPI.swift
//  CryptoApp
//
//  Created by Enzo Sterro on 02/10/2017.
//  Copyright © 2017 Enzo Sterro. All rights reserved.
//

import Foundation


struct CryptoAPI {
	
    static func fetchRates(currency: String, then: @escaping (CryptoAPIResult<Coin?>) -> Void) {
		let session = URLSession.shared
        let url = Ticker.baseURL.appendingPathComponent(currency)
		session.dataTask(with: url) { data, response, error in
			if let explicitError = error {
				then(.error(explicitError))
			}
			
			if let httpResponce = response as? HTTPURLResponse {
				switch httpResponce.statusCode {
				case 200:
                    guard let data = data else { return }
                    do {
                        let coin = try JSONDecoder().decode([Coin].self, from: data)
                        then(CryptoAPIResult.success(coin.first))
                    }
                    catch {
                        then(.error(error))
                        print(error)
                    }
				case 401:
					then(.customError("CoinAPI returned an 'unauthorized' response. Did you set your API key?"))
                case 404:
                    then(.customError("CoinAPI returned a 'not found' response. Unable to find rate for the \(currency)."))
				default:
					then(.customError("CoinAPI returned response: \(httpResponce.statusCode) \(HTTPURLResponse.localizedString(forStatusCode: httpResponce.statusCode))"))
				}
			}
		}.resume()
	}

    static func fetchTopCurrencies(then: @escaping (CryptoAPIResult<[Coin]>) -> Void) {
        let session = URLSession.shared

        session.dataTask(with: Ticker.baseURLForTopCurrencies) { data, response, error in
            if let httpResponce = response as? HTTPURLResponse {
                switch httpResponce.statusCode {
                case 200:
                    guard let data = data else { return }
                    do {
                        let coins = try JSONDecoder().decode([Coin].self, from: data)
                        then(CryptoAPIResult.success(coins))
                    }
                    catch {
                        print(error)
                    }
                case 401:
                    then(.customError("CoinAPI returned an 'unauthorized' response. Did you set your API key?"))
                default:
                    then(.customError("CoinAPI returned response: \(httpResponce.statusCode) \(HTTPURLResponse.localizedString(forStatusCode: httpResponce.statusCode))"))
                }
            }
        }.resume()
    }

}
