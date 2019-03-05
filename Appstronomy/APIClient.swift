//
//  APIClient.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 05/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

enum APIError: Error {
    case transportError(message: String)
    case invalidResponse(statusCode: Int)
    case missingData
    case decodingFailure(reason: String)
}

enum Result<T, E: Error> {
    case success(T)
    case failed(E)
}

protocol APIClient {
    
    // Networking process...
    // An endpoint / url request is needed.
    // Use NSURlSession
    
    // Adopter of this protocol must implemented a defaultDecoder to use when performing decoding operations
    var defaultDecoder: JSONDecoder { get }
    
    // Download methods with default implementations
    func download<Object: Decodable>(from request: URLRequest, completionHandler: @escaping (Result<[Object], APIError>) -> Void)
}

extension APIClient {
    func download<Object: Decodable>(from request: URLRequest, completionHandler: @escaping (Result<Object, APIError>) -> Void) {
        
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

    private func downloadJSON(request: URLRequest, completionHandler: @escaping (Data?, APIError?) -> Void) {
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
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
        
        }
        
        task.resume()
    }
}
