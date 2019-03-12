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
    
    var mockURL = URL(string: "https://google.com")!
    lazy var mockRequest = URLRequest(url: self.mockURL)
    
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
    
    func testClientReturnsData() {
        
        let expectedData = "{}".data(using: .utf8)
        session.nextData = expectedData
        
        var actualData: Data?
        subject.downloadJSON(request: mockRequest) { (data, error) in
            actualData = data
        }
        
        XCTAssertEqual(expectedData, actualData)
    }
    
    func testClientReturnsError() {
        
        let someError = NSError(domain: "Test", code: 2, userInfo: nil)
        session.nextError = someError
        
        var returnedError: APIError?
        subject.downloadJSON(request: mockRequest) { (data, error) in
            returnedError = error
        }
        
        XCTAssertNotNil(returnedError)
    }
    
    func testClientReturnsErrorForStatusCodeOutOfRange() {
        
        let someStatusCode = HTTPURLResponse(url: mockURL, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        session.nextResponse = someStatusCode
        
        print("DATA: \(session.nextData), RESPONSE: \(session.nextResponse), ERROR: \(session.nextError)")
        
        var returnedError: APIError?
        subject.downloadJSON(request: mockRequest) { (data, error) in
            returnedError = error
        }
        
        XCTAssert(returnedError! == APIError.invalidResponse(statusCode: 404))
    }
    
    func testClientAllowsValidStatusCode() {
        
        // If there are no errors and the status code is valid then no error should be returned.
        var returnedError: APIError?
        subject.downloadJSON(request: mockRequest) { (data, error) in
            returnedError = error
        }
        
        XCTAssertNil(returnedError)
    }
    
    func testClientErrorDisplaysAppropriateMessage() {
        
        session.nextResponse = HTTPURLResponse(url: mockURL, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        var returnedError: APIError?
        subject.downloadJSON(request: mockRequest) { (data, error) in
            returnedError = error
        }
        
        XCTAssertEqual(returnedError?.localizedDescription, "Invalid response returned from server: 400.")
    }
}
