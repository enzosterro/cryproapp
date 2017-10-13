//
//  NSUserDefaults+Settings.swift
//  Etherium
//
//  Created by Enzo Sterro on 05/10/2017.
//  Copyright © 2017 Enzo Sterro. All rights reserved.
//

import Cocoa

extension UserDefaults {

    static func setCurrentCurrency(_ currency: CoinModel.name) {
        self.standard.set(currency.rawValue, forKey: "com.enzosterro.cryprocurrency.currentCurrency")
    }
    
    static func getCurrentCurrency() -> CoinModel.name {
        if let storedValue = self.standard.value(forKey: "com.enzosterro.cryprocurrency.currentCurrency") as? String,
            let coinModel = CoinModel.name(rawValue: storedValue) {
            return coinModel
        } else {
            return CoinModel.name.bitcoin
        }
    }
}
