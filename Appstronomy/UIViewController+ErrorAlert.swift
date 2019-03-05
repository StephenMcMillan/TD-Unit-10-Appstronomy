//
//  UIViewController+ErrorAlert.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 05/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func displayAlert(for error: Error) {
        let alertController = UIAlertController(title: "Oops!", message: "Something went wrong. \(error.localizedDescription)", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default)
        
        alertController.addAction(dismiss)
        
        present(alertController, animated: true)

    }
}
