//
//  ImageFlowLayout.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 05/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation
import UIKit

class ImageFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        let size = min(collectionView.bounds.width * 0.80, collectionView.bounds.height * 0.80)
        self.itemSize = CGSize(width: size, height: size)
        
        self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: 0, bottom: 0, right: 0)
        self.sectionInsetReference = .fromSafeArea
    }
}
