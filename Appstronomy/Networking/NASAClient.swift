//
//  NASAClient.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 05/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation
import MapKit

class NASAClient: APIClient {
    
    // Singleton
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
                    // FIXME: latest_photos & latestPhotos seems to cause an error. FIX.
                } else if let latestPhotos = resultDictionary["latestPhotos"] {
                    completionHandler(.success(latestPhotos))
                } else if let latest_photos = resultDictionary["latest_photos"] {
                    completionHandler(.success(latest_photos))
                } else {
                    completionHandler(.failed(APIError.missingData))
                }
                
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
    
    func getEarthImagery(for coordinate: CLLocationCoordinate2D, completionHandler: @escaping (Result<EarthImage, APIError>) -> Void) {
        let endpoint = NASAEndpoint.earthImage(coordinate: coordinate)
        download(from: endpoint.request, completionHandler: completionHandler)
    }
    
    func getAstronomyPhoto(for date: Date?, completionHandler: @escaping (Result<AstronomyPhoto, APIError>) -> Void) {
        let endpoint = NASAEndpoint.imageOfTheDay(date: date)
        download(from: endpoint.request, completionHandler: completionHandler)
    }
    
}
