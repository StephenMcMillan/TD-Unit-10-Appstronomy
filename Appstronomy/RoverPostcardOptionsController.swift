//
//  RoverPostcardOptionsController.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 05/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import UIKit

enum NASAAppError: LocalizedError {
    // Rover Section
    case noPhotosForOptionsSelected
    
    var errorDescription: String? {
        switch self {
        case .noPhotosForOptionsSelected:
            return "These little rovers are amazing but it doesn't seem like there are any pictures for the options you selected. Try selecting a different date or camera and try again."
        }
    }
}

class RoverPostcardOptionsController: UIViewController {
    
    private let expandedSectionHeight: CGFloat = 200.0
    private let coherentAnimationDuration = 0.6

    @IBOutlet weak var backingScrollView: UIScrollView!
    
    @IBOutlet weak var roverSelectionTable: UITableView!
    
    @IBOutlet weak var datePickerContainerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var roverCameraSelectionTableContainer: UIView!
    @IBOutlet weak var roverCameraSelectionTable: UITableView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var roverSectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateSectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cameraSectionHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var roverLoadingActivityIndicator: UIActivityIndicatorView!
    
    var rovers = [Rover]() {
        didSet {
            updateSelectableRovers()
        }
    }
    
    var selectedRoverIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adds a Mars themed gradient.
        configureGradient(colors: AppstronomyUtils.marsColors)
        fetchRoverInfo()
    }
    
    func fetchRoverInfo() {
        // Download Mars rovers from the NASA API
        // Note to self: This VC doesn't hold a reference to the NASAClient so no need for [weak self]...
        NASAClient.sharedClient.getRovers { (result) in
            switch result {
            case .success(let rovers):
                self.rovers = rovers

            case .failed(let error):
                self.displayAlert(for: error)
                
            }
        }
    }
    
    // Call when the rovers are set. Stops activity indicator and expandeds section if needed.
    func updateSelectableRovers() {
        roverSelectionTable.reloadData()
        self.roverLoadingActivityIndicator.stopAnimating()
        self.roverSectionHeightConstraint.constant = self.expandedSectionHeight
        
        UIView.animate(withDuration: self.coherentAnimationDuration, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func configure(selectedRoverIndex: Int) {
        // Set-up for the rover that the user tapped on.
        self.selectedRoverIndex = selectedRoverIndex
        
        print(rovers[selectedRoverIndex])
        
        // Update date picker to reflect the min/max date of the rover
        datePicker.minimumDate = rovers[selectedRoverIndex].landingDate
        datePicker.maximumDate = rovers[selectedRoverIndex].maxDate
        datePicker.date = datePicker.minimumDate! // Start the picker at the launch date
        
        // Cameras changed depending on the rover.
        roverCameraSelectionTable.reloadData()
        
        // Code after this point only needs to happen on the first rover selection.
        guard dateSectionHeightConstraint.constant < expandedSectionHeight else { return }
        
        dateSectionHeightConstraint.constant = expandedSectionHeight
        cameraSectionHeightConstraint.constant = expandedSectionHeight
        
        UIView.animate(withDuration: coherentAnimationDuration) {
            // Fades in the Date Picker and Rover Camera
            self.datePickerContainerView.alpha = 1.0
            self.roverCameraSelectionTableContainer.alpha = 1.0
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: Next Button Action
    @IBAction func finishedSelectingRoverOptions(_ sender: Any) {
        
        // There is a chance that there may be no photos for the options that the user has selected so let's query the API AND THEN transition to the image page.
        guard let selectedRoverIndex = selectedRoverIndex, let selectedCameraIndex = roverCameraSelectionTable.indexPathForSelectedRow else { return }
        
        let rover = rovers[selectedRoverIndex]
        let selectedCamera = rover.cameras[selectedCameraIndex.row].name
        
        print("Rover: \(rover.name), Date: \(datePicker.date), Cam Selected: \(selectedCamera)")
        
        NASAClient.sharedClient.getPhotos(from: rover.name, on: datePicker.date, throughCamera: selectedCamera) { (result) in
            
            switch result {
            case .success(let photos):
                
                guard photos.count > 0 else {
                    // No photos with the specified filter.
                    // Show error.
                    self.displayAlert(for: NASAAppError.noPhotosForOptionsSelected)
                    return
                }
                
                // If there are some photos then we can move to the collection view.
                self.moveToPhotoPicker(withPhotos: photos)
                
            case .failed(let error):
                self.displayAlert(for: error)
            }
        }
    }
    
    // MARK: Dismiss Action
    @IBAction func dismissTapped(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Navigation
    func moveToPhotoPicker(withPhotos photos: [RoverPhoto]) {
        let collectionView = RoverPhotoPickerCollectionView(photos: photos)
        navigationController?.pushViewController(collectionView, animated: true)
    }
}
extension RoverPostcardOptionsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == roverSelectionTable {
            return rovers.count
            
        } else if tableView == roverCameraSelectionTable {
            guard let selectedRoverIndex = selectedRoverIndex else { return 0 }
            
            return rovers[selectedRoverIndex].cameras.count
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionCell", for: indexPath)
        
        if tableView == roverSelectionTable {
            let rover = rovers[indexPath.row]
            cell.textLabel?.text = rover.name
            cell.detailTextLabel?.text = rover.status.capitalized
            
        } else if tableView == roverCameraSelectionTable {
            if let selectedRoverIndex = selectedRoverIndex {
                cell.textLabel?.text = rovers[selectedRoverIndex].cameras[indexPath.row].name
            }
        }
        
        return cell
    }
}

extension RoverPostcardOptionsController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == roverSelectionTable {
            configure(selectedRoverIndex: indexPath.row)
            
        } else if tableView == roverCameraSelectionTable {
            
            backingScrollView.scrollRectToVisible(nextButton.frame, animated: true)
            
            UIView.animate(withDuration: coherentAnimationDuration) {
                self.nextButton.alpha = 1.0
            }
        }
    }
}
