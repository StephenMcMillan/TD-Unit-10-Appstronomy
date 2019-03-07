//
//  LandingViewController.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 06/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {
    
    private let cornerRadius: CGFloat = 6.0

    @IBOutlet weak var marsRoverBackingView: UIView!
    @IBOutlet weak var earthImageryBackingView: UIView!
    @IBOutlet weak var roverBackingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureGradient(on: marsRoverBackingView, colors: AppstronomyUtils.marsColors)
        configureGradient(on: earthImageryBackingView, colors: AppstronomyUtils.earthColors)
        configureGradient(on: roverBackingView, colors: AppstronomyUtils.roverColors)
        
        [marsRoverBackingView, earthImageryBackingView, roverBackingView].forEach {
            $0?.clipsToBounds = true
            $0?.layer.cornerRadius = cornerRadius
            $0?.alpha = 0.0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5) {
            self.marsRoverBackingView.alpha = 1.0
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.25, animations: {
            self.earthImageryBackingView.alpha = 1.0
        })
        
        UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
            self.roverBackingView.alpha = 1.0
        })
    }
    
    @IBAction func showEyeInTheSkySection(_ sender: Any) {
        
        // Create a Location Search Controller
        let searchController = LocationSearchController(style: .plain)
        
        // Create a Nav Controller to manage the flow of this section.
        let navigationController = UINavigationController(rootViewController: searchController)
        
        present(navigationController, animated: true , completion: nil)
    }
}
