//
//  AstronomyPhoto.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 10/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

// Model of APOD Result
struct AstronomyPhoto: Decodable {
    let date: Date
    let explanation: String
    let title: String
    var copyright: String?
    let url: URL
}
