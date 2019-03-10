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
    
    lazy var cloudScoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Cloud Coverage"
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.textColor = .white
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var cloudCoverView: CloudCoverView = {
        let ccV = CloudCoverView()
        ccV.translatesAutoresizingMaskIntoConstraints = false
        return ccV
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
        configureBarButtons()
        
        cloudScoreLabel.alpha = 0.0
        imageView.alpha = 0.0
        
        view.addSubview(imageView)
        view.addSubview(cloudScoreLabel)
        view.addSubview(cloudCoverView)
        
        // Add Constraints for Image View
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9, constant: 0),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0)])
        
        // Add constraints for label
        NSLayoutConstraint.activate([
            cloudScoreLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            cloudScoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        // Add constraints for cloud cover view
         NSLayoutConstraint.activate([
            cloudCoverView.widthAnchor.constraint(equalToConstant: 200),
            cloudCoverView.heightAnchor.constraint(equalToConstant: 200),
            cloudCoverView.topAnchor.constraint(equalTo: cloudScoreLabel.bottomAnchor, constant: 20),
            cloudCoverView.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        downloadImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        UIView.animate(withDuration: 0.4) {
            self.cloudScoreLabel.alpha = 1.0
            self.imageView.alpha = 1.0
        }
    }
    
    func downloadImage() {
        
        imageView.kf.indicatorType = .activity
        
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
        imageView.kf.setImage(with: earthImage.url, options: [.transition(ImageTransition.fade(0.4))])
        
        cloudCoverView.setPercentage(to: earthImage.cloudScore)
    }
    
    func configureBarButtons() {
        let shareButton = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(EarthImageViewerController.shareImage))
        navigationItem.rightBarButtonItem = shareButton
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(EarthImageViewerController.dismissNav))
        navigationItem.leftBarButtonItem = doneButton
    }
    
    @objc func dismissNav() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func shareImage() {
        
        guard let imageToShare = imageView.image else { return }
        
        let activityController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }

}

