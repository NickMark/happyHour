//
//  MasterViewController.swift
//  WaffleHouseNick
//
//  Created by Nicholas Evans on 2016-10-03.
//  Copyright © 2016 Nicholas Evans. All rights reserved.
//

import UIKit
import CoreLocation


class MasterViewController: UITableViewController,CLLocationManagerDelegate  {
    

    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var locationManager = CLLocationManager()
    
    let searchController = UISearchController(searchResultsController: nil)
    let userCoordinate = CLLocationCoordinate2D()
    var userLocation = CLLocation()
    
    var restaurantHouses = [RestaurantHouse]()
    var filteredRestaurantHouses = [RestaurantHouse]()
    var distanceRestaurantHouses = [RestaurantHouse]()
    
    //This function filters the restuarants based on the search text entered, then stores them in the filteredRestaurantHouses array
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredRestaurantHouses = restaurantHouses.filter { restaurantHouse in
            let categoryMatch = (scope == "All") || (restaurantHouse.city == scope)
                return categoryMatch && restaurantHouse.name.lowercased().contains(searchText.lowercased())
    }
        tableView.reloadData()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.scopeButtonTitles = ["All", "West", "Central", "East"]
        searchController.searchBar.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        

    }
    

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        
        animateTable()
        
    }
    
    func sortRestaurantBy(sortUsing : Int) {
        
        restaurantHouses.removeAll()
        
        if let seedRestaurantHouses = RestaurantHouse.loadDefaultRestaurantHouses() {
            restaurantHouses += seedRestaurantHouses
        }
        let finalArray = NSMutableArray()
        for var rawDataItem in restaurantHouses {
            
            print(rawDataItem.name)
            let locationA = CLLocation(latitude: (rawDataItem.location?.latitude)!, longitude: (rawDataItem.location?.longitude)!)
            let dist_a = (locationA.distance(from: self.userLocation))/1000
            let finalDistance = Double(round(10*dist_a)/10)
            rawDataItem.distance = finalDistance
            finalArray.add(rawDataItem)
            
        }
        restaurantHouses = (finalArray as NSArray as? [RestaurantHouse])!
        
        if sortUsing == 1 {
            restaurantHouses = restaurantHouses.sorted { $0.distance < $1.distance }
        }
        else {
            restaurantHouses = restaurantHouses.sorted { $0.name < $1.name }
        }

        tableView.reloadData()
        
    }

    @IBAction func segmentControlPressed(_ sender: Any) {
        
        if segmentedControl.selectedSegmentIndex == 1 {
            
            self.sortRestaurantBy(sortUsing: 2)
        }
        else {
            self.sortRestaurantBy(sortUsing: 1)
        }

    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if let controller = segue.destination as? PancakeHouseViewController {
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                    let restaurantHouse: RestaurantHouse
                    if searchController.isActive && searchController.searchBar.text != "" {
                        restaurantHouse = filteredRestaurantHouses[indexPath.row]
                    } else {
                        restaurantHouse = restaurantHouses[indexPath.row]
                    }
                    controller.restaurantHouse = restaurantHouse

                }
            }
        }
}

    
    // MARK: - Location Delegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        userLocation = locations[0] as CLLocation
        
        manager.stopUpdatingLocation()
        
        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        print(coordinations)
        //1 means by distance and 2 means by A-Z
        self.sortRestaurantBy(sortUsing: 1)
        
    }
    
    
    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //Here we include an if statement saying that if the search controller is active and there is text in the search bar, instead of showing all the restuarant houses, only show the filtered ones
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredRestaurantHouses.count
        }
        return restaurantHouses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let restaurantHouse: RestaurantHouse
        
        if searchController.isActive && searchController.searchBar.text != "" {
            restaurantHouse = filteredRestaurantHouses[indexPath.row]
        }
        else {
            restaurantHouse = restaurantHouses[indexPath.row]
        }
        
        
        if let cell = cell as? PancakeHouseTableViewCell {
 
            cell.restaurantHouse = restaurantHouse
            
        } else {
            cell.textLabel?.text = restaurantHouse.name
        }
        return cell
    }

    
    func animateTable() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        let tableViewHeight = tableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
        
    }
    
    
}

extension MasterViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searchController.searchBar.text!, scope: scope)
    }
    
    //This delegate method gets called when the user switches the scope in the scope bar. When they switch the scope, we want the results to be filtered under the new scope
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
}










