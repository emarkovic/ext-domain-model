//
//  DoubleExtensionTest.swift
//  ExtDomainModel
//
//  Created by Personal on 4/13/17.
//  Copyright © 2017 Ena Markovic. All rights reserved.
//

import XCTest

class DoubleExtensionTest: XCTestCase {
    
    func testUSADouble() {
        let usaDouble: Double = 1.99
        let money: Money = usaDouble.USD
        
        XCTAssert(money.amount == 1)
        XCTAssert(money.currency == "USD")
    }
    
    func testEURDouble() {
        let eurDouble: Double = 14.32
        let money: Money = eurDouble.EUR
        
        XCTAssert(money.amount == 21)
        XCTAssert(money.currency == "EUR")
    }
    
    func testGBPDouble() {
        let gbpDouble: Double = 4.5
        let money: Money = gbpDouble.GBP
        
        XCTAssert(money.amount == 2)
        XCTAssert(money.currency == "GBP")
    }
    
    func testCANDouble() {
        let canDouble: Double = 50.0
        let money: Money = canDouble.CAN
        
        XCTAssert(money.amount == 62)
        XCTAssert(money.currency == "CAN")
    }

}
