//
//  AppstronomyTests.swift
//  AppstronomyTests
//
//  Created by Stephen McMillan on 04/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import XCTest
@testable import Appstronomy

class AppstronomyTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNASAEndpointGetsAllRovers() {
        let endpoint = NASAEndpoint.rovers
        let request = endpoint.request

        XCTAssertEqual(request.url!.absoluteString, "https://api.nasa.gov/mars-photos/api/v1/rovers?api_key=RfTKuHhGpRdbt0kwIulHQvb5UQSi5xG6MWpne9yn")
    }
    
    func testNASAEndpointCuriosityRoverPhoto() {
        let endpoint = NASAEndpoint.roverPhotos(from: "curiosity", selectedPhotoDate: "2019-03-01", selectedCamera: "fhaz")
        
        let request = endpoint.request
        
        XCTAssertEqual(request.url!.absoluteString, "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?api_key=RfTKuHhGpRdbt0kwIulHQvb5UQSi5xG6MWpne9yn&earth_date=2019-03-01&camera=fhaz")
    }

}
