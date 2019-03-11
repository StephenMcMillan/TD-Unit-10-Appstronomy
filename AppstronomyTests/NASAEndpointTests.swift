//
//  NASAEndpointTests.swift
//  AppstronomyTests
//
//  Created by Stephen McMillan on 11/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import XCTest
import MapKit
@testable import Appstronomy

class NASAEndpointTests: XCTestCase {
    
    fileprivate let apiQueryItem = "api_key=\(apiKey)"

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMarsRoverEndpointFor_AllRovers() {
        // Build an API Call
        let endpoint = NASAEndpoint.rovers
        
        // Test the Endpoint returns what we expect.
        let expectedResult = "https://api.nasa.gov/mars-photos/api/v1/rovers?\(apiQueryItem)"
        XCTAssertEqual(endpoint.request.url!.absoluteString, expectedResult)
    }
    
    func testMarsRoverEndpointFor_SpiritRoverWithOptions() {
        
        // Build an API Call
        let testDate = DateComponents(calendar: Calendar.current, year: 2009, month: 10, day: 12).date!
        let roverName = "spirit"
        let selectedCamera = "fhaz"
        let endpoint = NASAEndpoint.roverPhotos(from: roverName, options: (date: testDate, selectedCamera: selectedCamera))
        
        // Test the Endpoint returns what we expect...
        let expectedResult = "https://api.nasa.gov/mars-photos/api/v1/rovers/\(roverName)/photos?\(apiQueryItem)&earth_date=\(testDate.nasaAPIStringRepresentation())&camera=\(selectedCamera)"
        
        XCTAssertEqual(endpoint.request.url!.absoluteString, expectedResult)
    }
    
    func testMarsRoverEndpointFor_CuriosityWithNoOptions() {
        
        // Build an API Call
        let roverName = "curiosity"
        let endpoint = NASAEndpoint.roverPhotos(from: roverName, options: nil)
        
        // Test the Endpoint returns what we expect...
        let expectedResult = "https://api.nasa.gov/mars-photos/api/v1/rovers/\(roverName)/latest_photos?\(apiQueryItem)"
        XCTAssertEqual(endpoint.request.url!.absoluteString, expectedResult)
    }
    
    func testEarthImageryEndpoint() {
        let testCoordinate = CLLocationCoordinate2D(latitude: 54.5927, longitude: -5.6884)
        let endpoint = NASAEndpoint.earthImage(coordinate: testCoordinate)
        
        let expectedResult = "https://api.nasa.gov/planetary/earth/imagery/?\(apiQueryItem)&lat=\(testCoordinate.latitude.description)&lon=\(testCoordinate.longitude.description)&dim=0.15&cloud_score=True"
        
        XCTAssertEqual(endpoint.request.url!.absoluteString, expectedResult)
    }
    
    func testEarthImageryEndpoint_CoordinateDescriptionReturnsExpectedResult() {
        let coordinate = CLLocationCoordinate2D(latitude: 100.75, longitude: -1.5)
        let expectedLatitude = "100.75"
        let expectedLongitude = "-1.5"
        
        XCTAssertEqual(coordinate.latitude.description, expectedLatitude)
        XCTAssertEqual(coordinate.longitude.description, expectedLongitude)
    }


    func testImageOfTheDayEndpont_LatestImage() {
        let endpoint = NASAEndpoint.imageOfTheDay(date: nil)
        
        let expectedResult = "https://api.nasa.gov/planetary/apod?\(apiQueryItem)"
        XCTAssertEqual(endpoint.request.url!.absoluteString, expectedResult)
    }
    
    func testImageOfTheDayEndpoint_Yesterday() {
        
        let yesterday = Date().previousDay
        
        let endpoint = NASAEndpoint.imageOfTheDay(date: yesterday)
        
        let expectedResult = "https://api.nasa.gov/planetary/apod?\(apiQueryItem)&date=\(yesterday.nasaAPIStringRepresentation())"
        
        XCTAssertEqual(endpoint.request.url!.absoluteString, expectedResult)
    }
}
