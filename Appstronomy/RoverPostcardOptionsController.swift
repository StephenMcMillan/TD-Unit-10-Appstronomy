//
//  RoverPostcardOptionsController.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 05/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import UIKit



class RoverPostcardOptionsController: UIViewController {
    
    private let expandedSectionHeight: CGFloat = 200.0

    @IBOutlet weak var backingScrollView: UIScrollView!
    
    @IBOutlet weak var roverSelectionTable: UITableView!
    
    @IBOutlet weak var datePickerContainerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var roverCameraSelectionTableContainer: UIView!
    @IBOutlet weak var roverCameraSelectionTable: UITableView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var dateSectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cameraSectionHeightConstraint: NSLayoutConstraint!
    
    var rovers: [Rover] = testRovers
    
    var selectedRoverIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adds a Mars themed gradient.
        configureGradient(colors: AppstronomyUtils.marsColors)
    }
    
    func configure() {
        // Set-up for the rover that the user tapped on.
        
        datePicker.minimumDate = Date(timeInterval: -6000, since: Date())
        datePicker.maximumDate = Date()
        
        // Set the cameras.
        roverCameraSelectionTable.reloadData()
        
        dateSectionHeightConstraint.constant = expandedSectionHeight
        cameraSectionHeightConstraint.constant = expandedSectionHeight
        
        UIView.animate(withDuration: 0.6) {
            self.datePickerContainerView.alpha = 1.0
            self.roverCameraSelectionTableContainer.alpha = 1.0
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: Next Button Action
    @IBAction func finishedSelectingRoverOptions(_ sender: Any) {
        guard let selectedRoverIndex = selectedRoverIndex, let selectedCameraIndex = roverCameraSelectionTable.indexPathForSelectedRow else { return }
        
        let rover = rovers[selectedRoverIndex]
        let dateSelected = datePicker.date
        let cameraSelected = rover.cameras[selectedCameraIndex.row]
        
        print("Rover: \(rover.name), Date: \(dateSelected), Cam Selected: \(cameraSelected)")
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
            
        } else if tableView == roverCameraSelectionTable {
            if let selectedRoverIndex = selectedRoverIndex {
                cell.textLabel?.text = rovers[selectedRoverIndex].cameras[indexPath.row].rawValue.uppercased()
            }
        }
        
        return cell
    }
}

extension RoverPostcardOptionsController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == roverSelectionTable {
            
            selectedRoverIndex = indexPath.row
            configure()
        } else if tableView == roverCameraSelectionTable {
            
            backingScrollView.scrollRectToVisible(nextButton.frame, animated: true)
            
            UIView.animate(withDuration: 0.6) {
                self.nextButton.alpha = 1.0
            }
        }
    }
}

