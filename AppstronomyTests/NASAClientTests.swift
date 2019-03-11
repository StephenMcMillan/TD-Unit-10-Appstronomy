//
//  NASAClientTests.swift
//  AppstronomyTests
//
//  Created by Stephen McMillan on 11/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import XCTest
@testable import Appstronomy

class NASAClientTests: XCTestCase {
    
    var subject: NASAClient!
    let session = MockURLSession()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        subject = NASAClient(session: session)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testClientCreatesCorrectURL() {
        
        let apodEndpoint = NASAEndpoint.imageOfTheDay(date: nil)
        
        subject.getAstronomyPhoto(for: nil) { (_) in }
        
        XCTAssert(session.lastUrl == apodEndpoint.request.url)
    }
    
    func testClientStartsDownloadTask() {
        // Create a mock data task
        let testDataTask = MockURLSessionDataTask()
        session.nextDataTask = testDataTask
        
        // Perform an API call
        subject.getRovers { (_) in }
        
        // Ensure that the Client starts the data task.
        XCTAssert(testDataTask.resumeCalled)        
    }


}
