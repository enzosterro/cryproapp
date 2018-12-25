//
//  StatisticMenuView.swift
//  CryptoApp
//
//  Created by Enzo Sterro on 06/10/2017.
//  Copyright © 2017 Enzo Sterro. All rights reserved.
//

import Cocoa


final class StatisticMenuView: NSView {

    // MARK: Outlets

    @IBOutlet private weak var currencyNameLabel: NSTextField!
    
    @IBOutlet private weak var percentChange1hView: PercentChangeView!
    @IBOutlet private weak var percentChange24hView: PercentChangeView!
    @IBOutlet private weak var percentChange7dView: PercentChangeView!
    
    @IBOutlet private weak var percentChange1hLabel: NSTextField!
    @IBOutlet private weak var percentChange24hLabel: NSTextField!
    @IBOutlet private weak var percentChange7dLabel: NSTextField!

    // MARK: Render
        
    func render(_ coin: Coin) {
        currencyNameLabel.stringValue = coin.name
        
        percentChange1hLabel.stringValue = coin.percentChange1h.format(with: .percent)
        percentChange24hLabel.stringValue = coin.percentChange24h.format(with: .percent)
        percentChange7dLabel.stringValue = coin.percentChange7d.format(with: .percent)
        
        percentChange1hView.setBackgroundColor(for: coin.percentChange1h)
        percentChange24hView.setBackgroundColor(for: coin.percentChange24h)
        percentChange7dView.setBackgroundColor(for: coin.percentChange7d)
    }
    
}
