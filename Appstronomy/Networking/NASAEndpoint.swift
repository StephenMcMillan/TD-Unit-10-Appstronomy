//
//  NASAEndpoint.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 05/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation
import MapKit

let apiKey = "RfTKuHhGpRdbt0kwIulHQvb5UQSi5xG6MWpne9yn"
fileprivate let APIKeyQueryItem = URLQueryItem(name: "api_key", value: apiKey)

// Describes the various endpoints that will be accessed.
enum NASAEndpoint {
    
    // Gets all rovers available for querying
    case rovers
    
    // Get the photos associated with a specific rover
    typealias RoverPhotoOptions = (date: Date, selectedCamera: String)
    case roverPhotos(from: String, options: RoverPhotoOptions?)
    
    case earthImage(coordinate: CLLocationCoordinate2D)
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
            
        case .roverPhotos(let name, .none): // If nil photo options use latest_photos
            return "/mars-photos/api/v1/rovers/\(name)/latest_photos"
            
        case .roverPhotos(let name, .some): // If photo options are present then the path is different
            return "/mars-photos/api/v1/rovers/\(name)/photos"
            
        case .earthImage:
            return "/planetary/earth/imagery/"
        }
    }
    
    private var queryItems: [URLQueryItem] {
        
        // All API Requests must have the API Key at the start.
        var items = [APIKeyQueryItem]
        
        switch self {
        case .roverPhotos(_, let .some(photoOptions)):
            items += [URLQueryItem(name: "earth_date", value: photoOptions.date.nasaAPIStringRepresentation()),
                      URLQueryItem(name: "camera", value: photoOptions.selectedCamera)]
            
        case .earthImage(let coordinate):
            
            items += [URLQueryItem(name: "lat", value: coordinate.latitude.description),
                      URLQueryItem(name: "lon", value: coordinate.longitude.description),
                      URLQueryItem(name: "dim", value: "0.15"),
                      URLQueryItem(name: "cloud_score", value: "True")]
            
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
