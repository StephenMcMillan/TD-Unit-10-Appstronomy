//
//  Rover.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 05/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

struct RoverResult: Decodable {
    let rovers: [Rover]
}

struct Rover: Decodable {
    let name: String
    let landingDate: Date
    let maxDate: Date
    let status: String
    
    let cameras: [Camera]
}

struct Camera: Decodable {
    let name: String
}

struct RoverPhotoResult: Decodable {
    let photos: [RoverPhoto]
}

struct RoverPhoto: Decodable {
    let imgSrc: URL
}
