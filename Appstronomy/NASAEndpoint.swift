//
//  NASAEndpoint.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 05/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

fileprivate let APIKeyQueryItem = URLQueryItem(name: "api_key", value: "RfTKuHhGpRdbt0kwIulHQvb5UQSi5xG6MWpne9yn")

// Describes the various endpoints that will be accessed.
enum NASAEndpoint {
    
    // Gets all rovers available for querying
    case rovers
    
    // Get the photos associated with a specific rover
    case roverPhotos(from: String, selectedPhotoDate: String, selectedCamera: String)
}

// MARK: Endpoint extension for URL Request Construction
extension NASAEndpoint {
    static var base: String {
        return "https://api.nasa.gov"
    }
    
    private var path: String {
        switch self {
        case .rovers:
            return "/mars-photos/api/v1/rovers"
        case .roverPhotos(let name, _, _):
            return "/mars-photos/api/v1/rovers/\(name)/photos"
        }
    }
    
    private var queryItems: [URLQueryItem] {
        
        // All API Requests must have the API Key at the start.
        var items = [APIKeyQueryItem]
        
        
        switch self {
        case .roverPhotos(_, let selectedPhotoDate, let selectedCamera):
            items += [URLQueryItem(name: "earth_date", value: selectedPhotoDate),
                      URLQueryItem(name: "camera", value: selectedCamera)]
            
        default:
            break
        }
        
        return items
    }
    
    // Use the various components to construct a URL Request
    var request: URLRequest {
        var components = URLComponents(string: NASAEndpoint.base)! // This should not fail as the base URL is very unlikely to change.
        components.path = self.path
        components.queryItems = self.queryItems
        
        return URLRequest(url: components.url!)
    }
    
}
