//
//  LocationSearchController.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 07/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import UIKit
import MapKit

// Allows the User to search for a location and displays suggested loctions whilst they are doing so.
class LocationSearchController: UITableViewController {
    
    lazy var locationSuggestionsController: LocationSuggestionsController = {
        let locationSuggestionsController = LocationSuggestionsController()
        locationSuggestionsController.tableView.delegate = self
        // TODO: get the users current location here.
        return locationSuggestionsController
    }()

    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: self.locationSuggestionsController)
        searchController.searchResultsUpdater = self.locationSuggestionsController
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = #colorLiteral(red: 0.2117647059, green: 0.2156862745, blue: 0.5843137255, alpha: 1)
        return searchController
    }()
    
    var localSearch: MKLocalSearch? {
        willSet {
            localSearch?.cancel()
        }
    }
    
    var places: [MKMapItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search for a Location"
        configureDismissButton()
        
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.reuseIdentifier)

        // Add the search bar to the navigation and configure so that search bar is always visible.
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.reuseIdentifier, for: indexPath)
        
        let placeForCurrentCell = places[indexPath.row]
        
        cell.textLabel?.text = placeForCurrentCell.name
        cell.detailTextLabel?.text = placeForCurrentCell.placemark.title
        
        return cell
    }
    
    // MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Two scenarios given that this object acts as tableview delegate for itself and the suggestions table view.
        
        if tableView == locationSuggestionsController.tableView {
            // Option A. User tapped a cell in the Suggestions Table View
            
            guard let selectedIndex = locationSuggestionsController.tableView.indexPathForSelectedRow else { return }
            
            let selectedSearchCompletionItem = locationSuggestionsController.searchCompleterResults[selectedIndex.row]
            let searchRequest = MKLocalSearch.Request(completion: selectedSearchCompletionItem)
            dump(searchRequest)
            search(using: searchRequest)
            
            searchController.isActive = false
            searchController.searchBar.text = selectedSearchCompletionItem.title
            
            
        } else if tableView == self.tableView {
            // Option B: User tapped a cell in this table view.
            guard let selectedIndex = self.tableView.indexPathForSelectedRow else { return }
            
            let selectedPlace = places[selectedIndex.row]
            
            let earthImageViewerController = EarthImageViewerController(coordinate: selectedPlace.placemark.coordinate)
            navigationController?.pushViewController(earthImageViewerController, animated: true)
        }
    }
    
    // MARK: Local Search Methods

    /// Creates a search request from a query string and calls the search(using searchRequest: MKLocalSearch.Requet) method.
    ///
    /// - Parameter queryString: The string to search for.
    func search(using queryString: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = queryString
        search(using: request)
    }
    
    /// Uses MKLocalSearch to search for locations near the user.
    ///
    /// - Parameter searchRequest: the request used to conduct the local search.
    func search(using searchRequest: MKLocalSearch.Request) {
        
        // 1. Create a local search using a request.
        localSearch = MKLocalSearch(request: searchRequest)
        
        // 2. Start the local search
        localSearch?.start(completionHandler: { [weak self] (response, error) in
            dump(response)
            // 3. Ensure that there were no errors with the search. If there was, show an alert.
            if let error = error {
                self?.displayAlert(for: error)
                return
            }
            
            // 4. Update the places array with the search results.
            guard let mapItems = response?.mapItems else { return }
            self?.places = mapItems
            print(mapItems)
        })
    }
    
    func configureDismissButton() {
        let dismissBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(LocationSearchController.dismissLocationSearch))
        navigationItem.leftBarButtonItem = dismissBarButton
    }
    
    @objc func dismissLocationSearch() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

}

extension LocationSearchController: UISearchBarDelegate {
    // Respond to the user tapping the search button on the keyboard.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // TODO: Add this feature
        guard let searchBarText = searchController.searchBar.text, searchBarText.count > 0 else { return }
        
        search(using: searchBarText)
    }
}
