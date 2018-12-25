//
//  CryptoAppTests.swift
//  CryptoAppTests
//
//  Created by Enzo Sterro on 11/10/2017.
//  Copyright © 2017 Enzo Sterro. All rights reserved.
//

import XCTest
import Foundation
@testable import CryptoApp


final class StringFormattingTests: XCTestCase {
    
    func testCheckForPercentSymbol() {
        let stringNumber = "1278.09"
        XCTAssertTrue(stringNumber.format(with: .percent).contains("%"), "String should contain %")
    }
    
    func testCheckForCurrencySymbol() {
        let stringNumber = "1278.09"
        XCTAssertTrue(stringNumber.format(with: .currency).contains("$"), "String should contain $")
    }
    
}
