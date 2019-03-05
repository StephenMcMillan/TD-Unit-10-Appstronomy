//
//  NASAClient.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 05/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

class NASAClient: APIClient {
    
    static let sharedClient = NASAClient()
    
    private init() {}
    
    var defaultDecoder: JSONDecoder = JSONDecoder.nasaDecoder
    
    func getRovers(completionHandler: @escaping (Result<[Rover], APIError>) -> Void) {
        
        // All Rovers Endpoint
        let endpoint = NASAEndpoint.rovers

        download(from: endpoint.request) { (result: Result<RoverResult, APIError>) in
            switch result {
                // Do some work to return an array of rovers to the caller instead of the RoverResult which is purely for decoding purposes.
            case .success(let roverResult):
                completionHandler(.success(roverResult.rovers))
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
}

extension JSONDecoder {
    static let nasaDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return decoder
    }()
}
