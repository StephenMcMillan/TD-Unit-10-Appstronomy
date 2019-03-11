//
//  RoverPostcardBuilderController.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 06/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import UIKit

class RoverPostcardBuilderController: UIViewController {
    
    static let storyboardIdentifier = String(describing: RoverPostcardBuilderController.self)
    
    var image: UIImage?

    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var captionTextField: PaddedTextField!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureGradient(colors: AppstronomyUtils.marsColors)
        configureDoneBarButton()
        
        // Set up the preview image with the inital, unedited image.
        previewImageView.image = image
        
        // Register for Keyboard notifications so the scrollView cane be adjusted to keep the text-field in view.
        NotificationCenter.default.addObserver(self, selector: #selector(RoverPostcardBuilderController.keyboardStatusChanged), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RoverPostcardBuilderController.keyboardStatusChanged), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    /// Creates an image with a text caption
    ///
    /// - Parameter text: The text to be drawn on the image.
    func drawImagePreview(text: NSString) {
        
        //  1. Get the size of the image view for easy use later.
        guard let previewSize = previewImageView?.frame.size else { return }
        
        // 2. Create a Graphics Image Renderer
        let renderer = UIGraphicsImageRenderer(size: previewSize)
        
        let newImage = renderer.image { (rendererContext) in
            
            // 1. Draw the original image onto the context as the base layer.
            image?.draw(in: previewImageView.bounds)
            
            // 2. Create a caption box with a semi-transparent background at the bottom of the context.
            let captionHeight: CGFloat = 80.0
            let captionRect = CGRect(x: 0, y: previewSize.height - captionHeight, width: previewSize.width, height: captionHeight)
            
            rendererContext.cgContext.setFillColor(#colorLiteral(red: 0.2941176471, green: 0.07058823529, blue: 0.2823529412, alpha: 0.6973726455).cgColor)
            rendererContext.cgContext.fill(captionRect)
            
            // 3. Set-up some text attributes
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attributes = [
                NSAttributedString.Key.font: UIFont(name: "Futura-Medium", size: 20.0) ?? UIFont.systemFont(ofSize: 20.0),
                NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                NSAttributedString.Key.paragraphStyle: paragraphStyle]
            
            // 4. Define the text rect as the caption rect with 10 points left/right padding and 5 points top/bottom padding.
            let textRect = captionRect.insetBy(dx: 20, dy: 10)
            
            // 5. Draw text that the user typed onto the view.
            text.draw(with: textRect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        }
        
        previewImageView.image = newImage
        
        if !shareButton.isEnabled {
            shareButton.isEnabled = true
        }
    }
    
    // MARK: Share Button
    @IBAction func sharePostcard(_ sender: Any) {
        // TODO: Add a share sheet!
        guard let imageToShare = previewImageView.image else { return }
        
        let activityController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    // MARK: Keyboard helper
    @objc func keyboardStatusChanged(notification: Notification) {
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = UIEdgeInsets.zero
        } else {
            
            if let keyboardEndFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardEndFrame.cgRectValue.height, right: 0)
            }
        }
    }
    
    // MARK: Dismiss Functionaility
    func configureDoneBarButton() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(RoverPostcardBuilderController.returnToMenu))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func returnToMenu() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        // Stop observing keyboard changes when the view is deinitialized.
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
}

// MARK: Respond to changes in the text field.
extension RoverPostcardBuilderController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        drawImagePreview(text: NSString(string: textField.text ?? ""))
    }
}
