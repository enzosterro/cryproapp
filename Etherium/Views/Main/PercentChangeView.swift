//
//  PercentChangeView.swift
//  Etherium
//
//  Created by Enzo Sterro on 06/10/2017.
//  Copyright © 2017 Enzo Sterro. All rights reserved.
//

import Cocoa

class PercentChangeView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        wantsLayer = true
        layer?.masksToBounds = true
        layer?.cornerRadius = 4
        self.backgroundColor = .trendGreen
    }
    
    func setBackgroundColorFor(trend: String) {
        self.backgroundColor = !trend.contains("-") ? .trendGreen : .trendRed
    }
}
