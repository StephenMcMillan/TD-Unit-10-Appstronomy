//
//  NASAClient Helpers.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 07/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

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
