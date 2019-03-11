//
//  AppstronomyTests.swift
//  AppstronomyTests
//
//  Created by Stephen McMillan on 04/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import XCTest
import MapKit
@testable import Appstronomy

class AppstronomyTests: XCTestCase {
    
    fileprivate let apiQueryItem = "api_key=\(apiKey)"

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNASAClient_CreatesCorrectDate() {
        let date = DateComponents(calendar: Calendar.current, year: 2018, month: 10, day: 29).date!
        
        let expectedResult = "2018-10-29"
        XCTAssertEqual(date.nasaAPIStringRepresentation(), expectedResult)
    }
    
    func testNASAClient_YesterdayDate() {
        let date = DateComponents(calendar: Calendar.current, year: 2018, month: 10, day: 29).date!
        let dayBeforeDate = DateComponents(calendar: Calendar.current, year: 2018, month: 10, day: 28).date!.noon
        
        XCTAssertEqual(date.previousDay, dayBeforeDate)
    }
    
    func testNASAClient_LongDateFormatHelper() {
        let testDate = DateComponents(calendar: Calendar.current, year: 2019, month: 3, day: 11).date!
        
        let expectedResult = "Monday 11 March"
        
        XCTAssertEqual(testDate.longFormat(), expectedResult)
    }

}
