//
//  Rover.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 05/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

//var testRovers: [Rover] = [
//    Rover(name: "Curiosity", landingDate: "2012-08-06", maxDate: "2019-03-01", status: "active", cameras: [
//        .fhaz, .navcam, .mast, .chemcam, .mahli, .mardi, .rhaz]),
//    Rover(name: "Opportunity", landingDate: "2004-01-25", maxDate: "2004-01-25", status: "active", cameras: [.fhaz, .navcam, .pancam, .minites, .entry, .rhaz])
//]

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
