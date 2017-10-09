//
//  StatisticMenuView.swift
//  Etherium
//
//  Created by Enzo Sterro on 06/10/2017.
//  Copyright © 2017 Enzo Sterro. All rights reserved.
//

import Cocoa

class StatisticMenuView: NSView {

    @IBOutlet weak var currencyNameLabel: NSTextField!
    
    @IBOutlet weak var percentChange1hView: PercentChangeView!
    @IBOutlet weak var percentChange24hView: PercentChangeView!
    @IBOutlet weak var percentChange7dView: PercentChangeView!
    
    @IBOutlet weak var percentChange1hLabel: NSTextField!
    @IBOutlet weak var percentChange24hLabel: NSTextField!
    @IBOutlet weak var percentChange7dLabel: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    func configureWith(coin: Coin) {
        
        currencyNameLabel.stringValue = coin.name
        
        percentChange1hLabel.stringValue = coin.percentChange1h
        percentChange24hLabel.stringValue = coin.percentChange24h
        percentChange7dLabel.stringValue = coin.percentChange7d
        
        percentChange1hView.setBackgroundColorFor(trend: coin.percentChange1h)
        percentChange24hView.setBackgroundColorFor(trend: coin.percentChange24h)
        percentChange7dView.setBackgroundColorFor(trend: coin.percentChange7d)
    }
}
