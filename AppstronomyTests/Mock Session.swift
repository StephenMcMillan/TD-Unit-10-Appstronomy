//
//  URLSession.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 11/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation
@testable import Appstronomy

class MockURLSession: URLSessionProtocol {
    
    var nextError: Error?
    var nextData: Data?
    var nextResponse: HTTPURLResponse?
    
    var nextDataTask = MockURLSessionDataTask()
    
    private (set) var lastUrl: URL?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lastUrl = request.url
        completionHandler(nextData, nextResponse, nextError)
        return nextDataTask
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeCalled: Bool = false
    
    func resume() {
        resumeCalled = true
    }
}
