//
//  MapViewController.swift
//  WaffleHouseNick
//
//  Created by Nicholas Evans on 2016-10-19.
//  Copyright © 2016 Nicholas Evans. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var restaurantHouses = [RestaurantHouse]()
    
    let manager = CLLocationManager()
    
    var userLocation:CLLocation?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation = locations[0]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        restaurantHouses = RestaurantHouse.loadDefaultRestaurantHouses()!
        //load map annotations
        mapView.delegate = self
        let annotations = getAnnotations()
        mapView.addAnnotations(annotations)
        
    }

    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 1
        let identifier = "RestaurantHouse"
        
        // 2
        if annotation is Annotations {
            // 3
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                //4
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                
                // 5
                let btn = UIButton(type: .detailDisclosure)
                annotationView!.rightCalloutAccessoryView = btn
            } else {
                // 6
                annotationView!.annotation = annotation
            }
            
            return annotationView
        }
        
        // 7
        return nil
    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            let theAnnotation = (view.annotation as! Annotations)
            performSegue(withIdentifier: "showDetail", sender: theAnnotation.tag)
            
            
        }

    }
    
    
    
    //FUNCTION: to create and place annotations on the map
    func getAnnotations() -> [Annotations] {
        var annotations:Array = [Annotations]()
        
        var points: NSArray?
        if let path = Bundle.main.path(forResource: "restaurants", ofType: "plist") {
            points = NSArray(contentsOfFile: path)
        }
        
        if let items = points {
            for item in items {
                let latitude = (item as AnyObject).value(forKey: "latitude") as! Double
                let longitude = (item as AnyObject).value(forKey: "longitude") as! Double
                let subtitle = (item as AnyObject).value(forKey: "hours") as! String
                let address = (item as AnyObject).value(forKey: "address") as! String
                let phoneNumber = (item as AnyObject).value(forKey: "phoneNumber") as! String
                let website = (item as AnyObject).value(forKey: "website") as! String
                let annotation = Annotations(subtitle: subtitle, latitude: latitude, longitude: longitude, address: address, phoneNumber: phoneNumber, website: website)
                annotation.title = ((item as AnyObject).value(forKey: "name") as? String)!
                annotation.tag = items.index(of: item)
                annotations.append(annotation)
            }
        }
        return annotations
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            
            
                if let controller = segue.destination as? PancakeHouseViewController {
                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                    controller.navigationItem.leftItemsSupplementBackButton = true
                    let restaurantHouse: RestaurantHouse
                    restaurantHouse = restaurantHouses[sender! as! Int]
                    controller.restaurantHouse = restaurantHouse
                    
            }
        }
    }
    
    
    //FUNCTION: to show the users current location
    @IBAction func zoomToCurrentLocation(_ sender: AnyObject) {
        let userLocation = mapView.userLocation
        
        let region = MKCoordinateRegionMakeWithDistance((userLocation.location!.coordinate), 150, 150)
        mapView.setRegion(region, animated: true)
    }
    
    
}

