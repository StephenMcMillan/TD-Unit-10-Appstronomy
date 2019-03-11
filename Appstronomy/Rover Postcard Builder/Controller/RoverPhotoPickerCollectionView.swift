//
//  RoverPhotoPickerCollectionView.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 05/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import UIKit
import Kingfisher // This Framework makes the download of images much easier and allows for easy caching.

class RoverPhotoPickerCollectionView: UIViewController {
    
    // MARK: Interface Builder Outlets
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Stored Properties
    var roverName: String?
    var photoOptions: NASAEndpoint.RoverPhotoOptions?
    
    var photos = [RoverPhoto]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let client = NASAClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerHeightConstraint.constant = 0.0
        headerLabel.alpha = 0.0
        configureGradient(colors: AppstronomyUtils.marsColors)
        
        // Collection View Set-up
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self

        // Do any additional setup after loading the view.
        attemptPreferredPhotoDownload()
    }
    
    func attemptPreferredPhotoDownload() {
        
        guard let roverName = roverName, let photoOptions = photoOptions else { return }
        
        client.getPhotos(from: roverName, options: photoOptions) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let photos):
                    
                    guard photos.count > 0 else {
                        // If there were no photos for the users preferences then just get the latest photos.
                        self?.getLatestRoverPhotos()
                        return
                    }
                    
                    // If there are some photos then we can move to the collection view.
                    self?.photos = photos
                    
                case .failed(let error):
                    self?.displayAlert(for: error)
                }
            }
        }
    }
    
    func getLatestRoverPhotos() {
        // Options is nil so we can get the latest photos...
        
        guard let roverName = roverName else { return }
        
        self.headerHeightConstraint.constant = 80.0
        self.headerLabel.text = "We couldn't find any photos matching your critera so here are the latest images from \(roverName.capitalized)!"
        UIView.animate(withDuration: 1.0, animations: {
            self.headerLabel.alpha = 0.8
            self.view.layoutIfNeeded()
        })
        
       client.getPhotos(from: roverName, options: nil) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let photos):
                    self?.photos = photos
                    
                case .failed(let error):
                    self?.displayAlert(for: error)
                }
            }
        }
    }
}

extension RoverPhotoPickerCollectionView: UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath) as! ImageCollectionViewCell

        cell.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.07058823529, blue: 0.2823529412, alpha: 0.1986033818)
        
        let imageUrl = photos[indexPath.row].imgSrc
        
        // Set an Indicator on the image view.
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(with: imageUrl, options: [.transition(ImageTransition.fade(0.2))])
        
        return cell
    }
}

extension RoverPhotoPickerCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 1. Get the Collection View Cell that the user tapped.
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell else { return }
        
        // 2. Extract the image from the cell that the user tapped. If the image has not yet been set (in other words it didn't finish downloading) then the method will return and the builder view won't be presented.
        guard let selectedImage = selectedCell.imageView.image else { return }
        
        // 3. Instantiate the Builder View Controller using its storyboard identifier.
        guard let builderVC = storyboard?.instantiateViewController(withIdentifier: RoverPostcardBuilderController.storyboardIdentifier) as? RoverPostcardBuilderController else { return }
        
        // 4. Pass the selected image to the builder controller.
        builderVC.image = selectedImage
        
        // 5. Present the Builder VC
        navigationController?.pushViewController(builderVC, animated: true)
    }
}
