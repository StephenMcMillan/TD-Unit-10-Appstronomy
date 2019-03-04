//
//  LandingPageController.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 04/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation
import UIKit

class LandingPageController: UIPageViewController, UIPageViewControllerDataSource {
    
    fileprivate lazy var pages: [UIViewController] = {
        return [SectionPageViewController(sectionTitle: "Mars Cards", sectionDescription: "Create and share a postcard with a picture from one of the three Mars Rovers.", actionText: "Create"),
                SectionPageViewController(sectionTitle: "Eye in the Sky", sectionDescription: "Want to see the world from a different perspective? In this section you get to see what a NASA satelite sees!", actionText: "View"),
                SectionPageViewController(sectionTitle: "AR Rovers", sectionDescription: "Get up close with a realistic model of Curiosity, Opportunity and Spirit in this Augmented Reality mode.", actionText: "Dive In")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        guard let initialPage = pages.first else { return }
        setViewControllers([initialPage], direction: .forward, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        // Get the Index of the Current View Controller in the Pages Array
        guard let indexOfCurrentViewController = pages.firstIndex(of: viewController) else { return nil }
        
        // Check this isn't the last item in the Pages Array
        guard indexOfCurrentViewController != pages.index(before: pages.endIndex) else { return nil }
        
        // If the current view controller is not the last in the pages list then return the subsequent page.
        return pages[pages.index(after: indexOfCurrentViewController)]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let indexOfCurrentViewController = pages.firstIndex(of: viewController) else { return nil }
        
        guard indexOfCurrentViewController != pages.startIndex else { return nil }
        
        return pages[pages.index(before: indexOfCurrentViewController)]
    }
}
