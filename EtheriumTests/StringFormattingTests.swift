//
//  EtheriumTests.swift
//  EtheriumTests
//
//  Created by Enzo Sterro on 11/10/2017.
//  Copyright © 2017 Enzo Sterro. All rights reserved.
//

import XCTest
import Foundation
@testable import Etherium

class StringFormattingTests: XCTestCase {
    
    func testCheckForPercentSymbol() {
        let stringNumber = "1278.09"
        XCTAssertTrue(stringNumber.formattedWithPercentSymbol.contains("%"), "String should contain %")
    }
    
    func testCheckForCurrencySymbol() {
        let stringNumber = "1278.09"
        XCTAssertTrue(stringNumber.formattedWithCurrencySymbol.contains("$"), "String should contain $")
    }
    
}
