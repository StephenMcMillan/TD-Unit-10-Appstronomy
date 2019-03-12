//
//  NASAClient.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 05/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation
import MapKit

enum Result<T, E: Error> {
    case success(T)
    case failed(E)
}

class NASAClient {
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
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
    
    fileprivate func download<Object: Decodable>(from request: URLRequest, completionHandler: @escaping (Result<Object, APIError>) -> Void) {
        
        // 1. Attempt to download JSON data from the URL specified.
        downloadJSON(request: request) { (data, error) in
            
            // 2. If the download function returns an error, propogate the error with the result type.
            if let error = error {
                completionHandler(.failed(error))
                return
            }
            
            // 3. If no error was returned, try to unpack the data.
            guard let data = data else {
                completionHandler(.failed(.missingData))
                return
            }
            
            // 4. Try to decode the data to the type that the caller wants using the clients decoder
            do {
                let object = try self.defaultDecoder.decode(Object.self, from: data)
                
                // 5 a. Decoding successful
                completionHandler(.success(object))
                
            } catch {
                // 5 b. Something went wrong during decoding, propogate error.
                completionHandler(.failed(.decodingFailure(reason: error.localizedDescription)))
            }
        }
        
    }
    
    func downloadJSON(request: URLRequest, completionHandler: @escaping (Data?, APIError?) -> Void) {
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completionHandler(nil, APIError.transportError(message: error.localizedDescription))
                return // Error so exit.
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    completionHandler(nil, APIError.invalidResponse(statusCode: httpResponse.statusCode))
                    return // Error so exit.
                }
            }
            
            // No errors and a valid HTTP response = success (hopefully.)
            completionHandler(data, nil)
        }
        
        task.resume()
    }
    
}
