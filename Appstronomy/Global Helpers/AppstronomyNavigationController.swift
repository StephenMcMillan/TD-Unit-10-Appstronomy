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
        
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2117647059, green: 0.2156862745, blue: 0.5843137255, alpha: 1)]
        self.navigationBar.tintColor = #colorLiteral(red: 0.2117647059, green: 0.2156862745, blue: 0.5843137255, alpha: 1)
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
