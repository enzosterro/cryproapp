//
//  NSView+BackgroundColor.swift
//  CryptoApp
//
//  Created by Enzo Sterro on 06/10/2017.
//  Copyright © 2017 Enzo Sterro. All rights reserved.
//

import Cocoa

extension NSView {
    var backgroundColor: NSColor? {
        get {
            if let colorRef = self.layer?.backgroundColor {
                return NSColor(cgColor: colorRef)
            } else {
                return nil
            }
        }
        set {
            self.wantsLayer = true
            self.layer?.backgroundColor = newValue?.cgColor
        }
    }
}
