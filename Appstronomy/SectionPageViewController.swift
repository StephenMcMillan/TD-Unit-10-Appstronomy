//
//  SectionPageViewController.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 04/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation
import UIKit

class SectionPageViewController: UIViewController {
    lazy var sectionTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = sectionTitle
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22.0)
        label.sizeToFit()
        label.backgroundColor = UIColor.red
        return label
    }()
    
    // MARK: Initialization and Appropriate Properties
    let sectionTitle: String
    let sectionDescription: String?
    let actionText: String
    
    init(sectionTitle: String, sectionDescription: String?, actionText: String) {
        self.sectionTitle = sectionTitle
        self.sectionDescription = sectionDescription
        self.actionText = actionText
        
        super.init(nibName: nil, bundle: nil)
    }
    
    // This class should not be created from a storyboard.
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Set-up
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = [UIColor.red, UIColor.green, UIColor.blue, UIColor.cyan].randomElement()
        view.layer.cornerRadius = 12.0
        view.addSubview(sectionTitleLabel)
        
        sectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([sectionTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                                     sectionTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                                     sectionTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40)])
        
        self.view.layoutIfNeeded()
    }
}
