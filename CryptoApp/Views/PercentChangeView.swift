//
//  PercentChangeView.swift
//  CryptoApp
//
//  Created by Enzo Sterro on 06/10/2017.
//  Copyright © 2017 Enzo Sterro. All rights reserved.
//

import Cocoa


final class PercentChangeView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        layer?.masksToBounds = true
        layer?.cornerRadius = 4
    }

    func setBackgroundColor(for trend: String) {
        wantsLayer = true
        layer?.backgroundColor = trend.contains("-")
            ? NSColor.red.withAlphaComponent(0.3).cgColor
            : NSColor.green.withAlphaComponent(0.3).cgColor
    }

}
