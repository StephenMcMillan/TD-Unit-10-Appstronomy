//
//  LocationSuggestionsController.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 07/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class LocationSuggestionsController: UITableViewController {
    
    // At the time of writing I decided not the specify a defining/bounding region as users may want to view earth imagery from any location in the world so it would not be wise to restrict the region.
    let searchCompleter = MKLocalSearchCompleter()
    
    var searchCompleterResults = [MKLocalSearchCompletion]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    convenience init(region: MKCoordinateRegion? = nil) {
        self.init(style: .plain)
        
        searchCompleter.delegate = self
        
        if let region = region {
            searchCompleter.region = region
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.reuseIdentifier)
        
        searchCompleter.delegate = self
    }
    
    // MARK: Table View Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchCompleterResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.reuseIdentifier, for: indexPath)
        
        let itemForThisCell = searchCompleterResults[indexPath.row]
        cell.textLabel?.text = itemForThisCell.title
        cell.detailTextLabel?.text = itemForThisCell.subtitle
        
        return cell
    }
    
    // MARK: Table View Delegate
}

// MKLocalSearchCompleter returns its suggestions here
extension LocationSuggestionsController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchCompleterResults = completer.results
    }
}

// This controller is responsbile for responding to changes in the search bar text.
extension LocationSuggestionsController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // When the user types something into the search controllers search bar, this method is called and we can access the search bars text.
        
        guard let searchBarText = searchController.searchBar.text, searchBarText.count > 0 else { return }
        
        // With the text, the local search completer can start to make suggestions that the user can tap on.
        self.searchCompleter.queryFragment = searchBarText
    }
}
