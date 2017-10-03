//
//  CryptoAPI.swift
//  Etherium
//
//  Created by Enzo Sterro on 02/10/2017.
//  Copyright © 2017 Enzo Sterro. All rights reserved.
//

import Foundation

enum Result<T> {
	case success(T)
	case error(Error)
	case customError(String)
}

class CryptoAPI {

	private let BASE_URL = "https://api.coinmarketcap.com/v1/ticker/?convert=USD&limit=10"
	
	func fetchRates(success: @escaping (Result<[Coin]>) -> Void) {
		let session = URLSession.shared
		let url = URL(string: BASE_URL)
		
		let task = session.dataTask(with: url!) { data, response, error in
			if let explicitError = error {
				success(.error(explicitError))
			}
			
			if let httpResponce = response as? HTTPURLResponse {
				switch httpResponce.statusCode {
				case 200:
					if let data = data {
						do {
							let json = try JSONSerialization.jsonObject(with: data, options: [])
							if let jsonDictionary = self.JSONtoArrayOfDict(json: json) {
								var coins = [Coin]()
								for element in jsonDictionary {
									if let coin = Coin(json: element) {
										coins.append(coin)
									}
								}
								success(Result.success(coins))
							}
						} catch let error {
							success(.error(error))
						}
					}
				case 401:
					success(.customError("CoinAPI returned an 'unauthorized' response. Did you set your API key?"))
				default:
					success(.customError("CoinAPI returned response: \(httpResponce.statusCode) \(HTTPURLResponse.localizedString(forStatusCode: httpResponce.statusCode))"))
				}
			}
		}
		task.resume()
	}
	
	private func JSONtoArrayOfDict(json: Any) -> [[String: Any]]? {
		return json as? [[String: Any]] ?? nil
	}
	
}
