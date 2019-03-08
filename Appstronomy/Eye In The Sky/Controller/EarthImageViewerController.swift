//
//  EarthImageViewerController.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 08/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import UIKit
import MapKit
import Kingfisher

class EarthImageViewerController: UIViewController {

    // The Location that the view controller will download imagery for.
    let coordinate: CLLocationCoordinate2D
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.2117647059, green: 0.2156862745, blue: 0.5843137255, alpha: 0.7)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Eye In The Sky"
        configureGradient(colors: AppstronomyUtils.earthColors)
        configureShareButton()
//        navigationController?.navigationBar.tintColor = AppstronomyUtils.earthColors.last
        
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9, constant: 0),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
            ])
        
        // TODO: Make it zoomable.
        
        downloadImage()
    }
    
    func downloadImage() {
        
        NASAClient.sharedClient.getEarthImagery(for: self.coordinate) { (result) in
            switch result {
                
            case .success(let earthImage):
                self.configure(with: earthImage)
                
            case .failed(let error):
                self.displayAlert(for: error)
            }
        }
    }
    
    func configure(with earthImage: EarthImage) {
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: earthImage.url, options: [.transition(ImageTransition.fade(0.2))])
    }
    
    func configureShareButton() {
        let shareButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(EarthImageViewerController.shareImage))
        navigationItem.rightBarButtonItem = shareButtonItem
    }
    
    @objc func shareImage() {
        
        guard let imageToShare = imageView.image else { return }
        
        let activityController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }

}

extension EarthImageViewerController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
