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
    
    func getPhotos(from roverName: String, options: NASAEndpoint.RoverPhotoOptions?, completionHandler: @escaping (Result<[RoverPhoto], APIError>) -> Void) {
        
        let endpoint = NASAEndpoint.roverPhotos(from: roverName, options: options)
        
        download(from: endpoint.request) { (result: Result<[String: [RoverPhoto]], APIError>) in
            
            switch result {
            case .success(let resultDictionary):
                
                // Two wrapper keys are possible for the Photos endpoint, this is a bit hacky but it works >.<
                
                dump(resultDictionary)
                
                if let roverPhotos = resultDictionary["photos"] {
                    completionHandler(.success(roverPhotos))
                    
                } else if let latestPhotos = resultDictionary["latest_photos"] {
                    completionHandler(.success(latestPhotos))
                    
                } else {
                    completionHandler(.failed(APIError.missingData))
                }
                
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
        decoder.dateDecodingStrategy = .formatted(DateFormatter.nasaAPIDateFormatter)
        
        return decoder
    }()
}

extension DateFormatter {
    static var nasaAPIDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter
    }()
}

extension Date {
    // Instance method returns self as a string represented in format 'YYYY-MM-dd' for use by the NASA API
    func nasaAPIStringRepresentation() -> String {
        let formatter = DateFormatter.nasaAPIDateFormatter
        return formatter.string(from: self)
    }
}
