//
//  YuzPayTests.swift
//  YuzPayTests
//
//  Created by applebro on 05/12/22.
//

import XCTest
@testable import YuzPay

final class YuzPayTests: XCTestCase {

    func testDateCardExpire() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let cardString = "10/25"
        
        let date = Date.cardExpireDateToDateObject(cardString)
        
        XCTAssertEqual(date?.dateToCardExpireString(), cardString)
    }
    
    func testMaskCard() throws {
        let cardText = "1234 1234 1234 1234"
        
        XCTAssertEqual(cardText.maskAsCardNumber, "1234 12•• •••• ••34")
    }
}
