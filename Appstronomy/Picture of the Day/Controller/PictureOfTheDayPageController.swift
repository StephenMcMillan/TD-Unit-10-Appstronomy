//
//  PictureOfTheDayPageController.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 10/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import UIKit

class PictureOfTheDayPageController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var todaysImageViewController: CaptionedImageViewController!
    var yesterdaysImageViewController: CaptionedImageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Today"
        
        self.dataSource = self
        self.delegate = self
        
        configureDoneButton()
        
        todaysImageViewController = CaptionedImageViewController(date: Date())
        yesterdaysImageViewController = CaptionedImageViewController(date: Date.yesterday)
        
        setViewControllers([todaysImageViewController!], direction: UIPageViewController.NavigationDirection.reverse, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewController == todaysImageViewController {
            return yesterdaysImageViewController
        } else { return nil }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController == yesterdaysImageViewController {
            return todaysImageViewController
        } else { return nil}
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let lastVC = previousViewControllers.first {
            
            if lastVC == todaysImageViewController {
                title = "Yesterday"
            } else {
                title = "Today"
            }
            
        }
    }
    
    // MARK: - Done Bar Button
    func configureDoneButton() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(PictureOfTheDayPageController.doneViewing))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func doneViewing() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
