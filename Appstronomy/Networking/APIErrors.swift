//
//  APIErrors.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 06/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

enum APIError: Error, LocalizedError {
    case transportError(message: String)
    case invalidResponse(statusCode: Int)
    case missingData
    case decodingFailure(reason: String)
    
    var errorDescription: String? {
        switch self {
        case .transportError(let message):
            return "The error occured whilst communicating with the server. \(message)."
        case .invalidResponse(let statusCode):
            return "Invalid response returned from server: \(statusCode)."
        case .missingData:
            return "Data was missing during unpack process."
        case .decodingFailure(let reason):
            return "Could not decode the data into the expected result. \(reason)."
        }
        
    }
}
