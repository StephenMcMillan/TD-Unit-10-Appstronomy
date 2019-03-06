//
//  ImageCollectionViewCell.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 05/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: ImageCollectionViewCell.self)
 
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    // Custom View
    func configureView() {
        self.layer.cornerRadius = 12.0
        self.clipsToBounds = true
        self.addSubview(imageView)
    }
}
