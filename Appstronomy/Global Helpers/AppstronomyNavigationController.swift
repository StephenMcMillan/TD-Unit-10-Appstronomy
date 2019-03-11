//
//  AppstronomyNavigationController.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 08/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import UIKit

class AppstronomyNavigationController: UINavigationController {
    func setNavColour(color: UIColor) {
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
        self.navigationBar.tintColor = color
    }
}
