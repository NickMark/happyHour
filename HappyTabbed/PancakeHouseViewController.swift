//
//  PancakeHouseViewController.swift
//  WaffleHouseNick
//
//  Created by Nicholas Evans on 2016-10-03.
//  Copyright © 2016 Nicholas Evans. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Social



class PancakeHouseViewController: UITableViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    var imageArray = [UIImage]()
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var priceGuideLabel: UILabel!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var happyHoursLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuesdayLabel: UILabel!
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var saturdayLabel: UILabel!
    @IBOutlet weak var sundayLabel: UILabel!
    
    @IBOutlet weak var callTodayButton: UIButton!
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var goToWebsiteButton: UIButton!
    
    @IBOutlet weak var twitterButton: UIButton!
    
    @IBOutlet weak var facebookButton: UIButton!
    


    
    
    
    var restaurantHouse: RestaurantHouse? {
        didSet {
            configureView()
        }
    }
    
    
    func configureView() {
        
        if let restaurantHouse = restaurantHouse {
            nameLabel?.text = restaurantHouse.name
            imageView?.image = restaurantHouse.photo ?? UIImage(named: "placeholder")
            detailsLabel?.text = restaurantHouse.details
            hoursLabel?.text = restaurantHouse.hours

            happyHoursLabel?.text = restaurantHouse.happyHour
            phoneNumberLabel?.text = restaurantHouse.phoneNumber
            mondayLabel?.text = restaurantHouse.mondaySpecial
            tuesdayLabel?.text = restaurantHouse.tuesdaySpecial
            wednesdayLabel?.text = restaurantHouse.wednesdaySpecial
            thursdayLabel?.text = restaurantHouse.thursdaySpecial
            fridayLabel?.text = restaurantHouse.fridaySpecial
            saturdayLabel?.text = restaurantHouse.saturdaySpecial
            sundayLabel?.text = restaurantHouse.sundaySpecial
            
            addressLabel?.text = restaurantHouse.address
            priceGuideLabel?.text = "\(restaurantHouse.priceGuide)"
            centreMap(map: mapView, atPosition: restaurantHouse.location)
            
        }
    }
    
    
    func borderStyle(border: UIButton) {
        border.layer.borderWidth = 0.5
        border.layer.borderColor = UIColor.deepPurple.cgColor
        border.layer.cornerRadius = 10
        
        border.layer.shadowColor = UIColor.lightGray.cgColor
        border.layer.shadowOpacity = 1.0
        border.layer.shadowRadius = 1.0
        border.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageSlider()
        self.configureView()
        
        borderStyle(border: callTodayButton)
        callTodayButton.layer.borderWidth = 1
        callTodayButton.layer.borderColor = UIColor.goldAccent.cgColor
        
        borderStyle(border: getDirectionsButton)
        borderStyle(border: goToWebsiteButton)
        borderStyle(border: twitterButton)
        borderStyle(border: facebookButton)
        
    }
    
    
    func imageSlider() {
        
        imageArray = [(restaurantHouse?.imageArray1)!, (restaurantHouse?.imageArray2)!, (restaurantHouse?.imageArray3)!, (restaurantHouse?.imageArray4)!]
        
        for i in 0..<imageArray.count {
            
            let imageViewer = UIImageView()
            
            imageViewer.image = imageArray[i]
            
            imageViewer.contentMode = .scaleAspectFill
            imageViewer.clipsToBounds = true
            
            let xPosition = self.view.frame.width * CGFloat(i)
            
            imageViewer.frame = CGRect(x: xPosition, y: 0 , width: self.view.frame.width, height: self.mainScrollView.frame.height)
            
            mainScrollView.contentSize.width = mainScrollView.frame.width * CGFloat(i + 1)
            
            mainScrollView.addSubview(imageViewer)
            
        }

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
            UIView.animate(withDuration: 1.25, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }

    }
    
    
    private func centreMap(map: MKMapView?, atPosition position: CLLocationCoordinate2D?) {
        guard let map = map, let position = position else {
            return
        }
        map.isZoomEnabled = true
        map.isScrollEnabled = false
        map.isPitchEnabled = true
        map.isRotateEnabled = false
        
        map.setCenter(position, animated: true)
        
        let zoomRegion = MKCoordinateRegionMakeWithDistance(position, 100, 100)
        map.setRegion(zoomRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = position
        map.addAnnotation(annotation)
    }
    
    
    //Buttons
    @IBAction func makeCall(_ sender: AnyObject) {
        let cleanNumber = restaurantHouse?.phoneNumber.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
        guard let number = URL(string: "telprompt://" + cleanNumber!) else { return }
        
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }

    
    @IBAction func showDirections(_ sender: AnyObject) {
        
        let cleanDirection = restaurantHouse?.address.replacingOccurrences(of: " ", with: "+")
        
        guard let direction = URL(string: "comgooglemaps://?saddr=&daddr=" + cleanDirection!) else { return }
        
        UIApplication.shared.open(direction, options: [:], completionHandler: nil)
        
    }
    
    
    
    @IBAction func goToWebsite(_ sender: AnyObject) {
        let cleanWebsite = restaurantHouse?.website
        
        guard let website = URL(string: "http://" + cleanWebsite!) else { return }
        
        UIApplication.shared.open(website)
    }
    
    @IBAction func clickedTwitterButton(_ sender: AnyObject) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
            let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText("Share on Twitter")
            self.present(twitterSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        }
        
        @IBAction func clickedFacebookButton(_ sender: Any) {
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
                let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                facebookSheet.setInitialText("Share on Facebook")
                self.present(facebookSheet, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    
}




