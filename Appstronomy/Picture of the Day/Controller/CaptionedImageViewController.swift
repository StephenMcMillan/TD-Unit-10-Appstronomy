//
//  CaptionedImageViewController.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 10/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import UIKit
import Kingfisher

class CaptionedImageViewController: UIViewController {
        
    var imageDate: Date
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var imageTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    lazy var imageAuthorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    lazy var explanationTextView: UITextView = {
        
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16.0)
        textView.textColor = .white
        return textView
    }()
    
    lazy var effectView: UIVisualEffectView = {
        let effect = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        effect.translatesAutoresizingMaskIntoConstraints = false
        return effect
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var explanationHeightConstraint: NSLayoutConstraint!
    var explanationViewHidden: Bool = true
    
    // MARK: - View Loading
    init(date: Date) {
        self.imageDate = date
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGradient(colors: AppstronomyUtils.apodColors)
        
        // Add Subviews
        view.addSubview(imageView)
        view.addSubview(effectView)
        stackView.addArrangedSubview(imageTitleLabel)
        stackView.addArrangedSubview(imageAuthorLabel)
        stackView.addArrangedSubview(explanationTextView)
        effectView.contentView.addSubview(stackView)
        
        effectView.alpha = 0.0
        
        // Layout Views
        configureConstraints()
            
        downloadImage()
    }
    
    func downloadImage() {
        NASAClient().getAstronomyPhoto(for: imageDate) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let astroPhoto):
                    self.configure(with: astroPhoto)
                case .failed(let error):
                    self.displayAlert(for: error)
                }
            }
        }
    }
    
    func configure(with astronomyPhoto: AstronomyPhoto) {
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: astronomyPhoto.url, options: [.transition(ImageTransition.fade(0.4))])
        
        imageTitleLabel.text = astronomyPhoto.title
        imageAuthorLabel.text = astronomyPhoto.copyright
        explanationTextView.text = astronomyPhoto.explanation
        
        UIView.animate(withDuration: 1.0) {
            self.effectView.alpha = 1.0
        }
    }
    
    // MARK: - AutoLayout
    func configureConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            effectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            effectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            effectView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: effectView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: effectView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: effectView.topAnchor, constant: 16.0),
            stackView.bottomAnchor.constraint(equalTo: effectView.bottomAnchor, constant: -16.0),
            
            explanationTextView.heightAnchor.constraint(equalToConstant: 80.0)
            ])
    }


}
