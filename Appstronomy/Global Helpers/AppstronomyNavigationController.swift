//
//  AppstronomyNavigationController.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 08/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import UIKit

class AppstronomyNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setNavColour(color: UIColor) {
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
        self.navigationBar.tintColor = color
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
