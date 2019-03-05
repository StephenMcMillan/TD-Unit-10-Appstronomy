//
//  Rover.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 05/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

var testRovers: [Rover] = [
    Rover(name: "Curiosity", landingDate: "2012-08-06", maxDate: "2019-03-01", status: "active", cameras: [
        .fhaz, .navcam, .mast, .chemcam, .mahli, .mardi, .rhaz]),
    Rover(name: "Opportunity", landingDate: "2004-01-25", maxDate: "2004-01-25", status: "active", cameras: [.fhaz, .navcam, .pancam, .minites, .entry, .rhaz])
]

struct Rover {
    let name: String
    let landingDate: String
    let maxDate: String
    let status: String
    
    enum RoverCamera: String, CaseIterable {
        case fhaz
        case rhaz
        case mast
        case chemcam
        case mahli
        case mardi
        case navcam
        case pancam
        case minites
        case entry
    }
    
    let cameras: [RoverCamera]
    
}
