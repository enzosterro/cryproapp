//
//  NSUserDefaults+Settings.swift
//  CryptoApp
//
//  Created by Enzo Sterro on 05/10/2017.
//  Copyright © 2017 Enzo Sterro. All rights reserved.
//

import Cocoa


extension UserDefaults {

    struct Constants {

        static let currentCurrencyKey = "com.enzosterro.cryprocurrency.currentCurrency"

    }

    static var currentCurrency: String {
        get {
            return standard.string(forKey: Constants.currentCurrencyKey) ?? "bitcoin"
        }
        set {
            standard.set(newValue, forKey: Constants.currentCurrencyKey)
        }
    }

}
