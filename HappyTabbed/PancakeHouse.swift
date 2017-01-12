//
//  PancakeHouse.swift
//  WaffleHouseNick
//
//  Created by Nicholas Evans on 2016-10-03.
//  Copyright © 2016 Nicholas Evans. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

//MARK: Write an enum for the price guide to determine if to put $, $$, $$$ based on enum case number
enum PriceGuide : Int {
    case Unknown = 0
    case Low = 1
    case Medium = 2
    case High = 3
}

extension PriceGuide : CustomStringConvertible {
    var description : String {
        switch self {
        case .Unknown: return "?"
        case .Low: return "$"
        case .Medium: return "$$"
        case .High: return "$$$"
        }
    }
}



//MARK: We create a struct to model the details of each pancake house's detail page.

struct RestaurantHouse {
    let name: String
    let photo: UIImage?
    let thumbnail: UIImage?
    let priceGuide: PriceGuide
    let location: CLLocationCoordinate2D?
    let details: String
    let city: String
    let hours: String
    let happyHour: String
    let address: String
    let phoneNumber: String
    let website: String
    var distance: Double = 0
    
    let mondaySpecial: String
    let tuesdaySpecial: String
    let wednesdaySpecial: String
    let thursdaySpecial: String
    let fridaySpecial: String
    let saturdaySpecial: String
    let sundaySpecial: String
    
    //Image Array
    let imageArray1: UIImage?
    let imageArray2: UIImage?
    let imageArray3: UIImage?
    let imageArray4: UIImage?
    
    
}

//We initialize these constants with the information provided from the dictionary pancake_houses.plist. We use optionals after 'as' just in case we don't have information for one of the details.
extension RestaurantHouse {
    init?(dict: [String: AnyObject]) {
        guard let name = dict["name"] as? String,
        let priceGuideRaw = dict["priceGuide"] as? Int,
        let priceGuide = PriceGuide(rawValue: priceGuideRaw),
        let details = dict["details"] as? String,
        let city = dict["city"] as? String,
        let hours = dict["hours"] as? String,
        let happyHour = dict["happyHour"] as? String,
        let address = dict["address"] as? String,
        let phoneNumber = dict["phoneNumber"] as? String,
        let website = dict["website"] as? String,
        let mondaySpecial = dict["mondaySpecial"] as? String,
        let tuesdaySpecial = dict["tuesdaySpecial"] as? String,
        let wednesdaySpecial = dict["wednesdaySpecial"] as? String,
        let thursdaySpecial = dict["thursdaySpecial"] as? String,
        let fridaySpecial = dict["fridaySpecial"] as? String,
        let saturdaySpecial = dict["saturdaySpecial"] as? String,
        let sundaySpecial = dict["sundaySpecial"] as? String else {
                return nil
        }
        
        self.name = name
        self.priceGuide = priceGuide
        self.details = details
        self.city = city
        self.hours = hours
        self.happyHour = happyHour
        self.address = address
        self.phoneNumber = phoneNumber //^^^^we've done 4 of the dicitonary values
        self.website = website
        self.mondaySpecial = mondaySpecial
        self.tuesdaySpecial = tuesdaySpecial
        self.wednesdaySpecial = wednesdaySpecial
        self.thursdaySpecial = thursdaySpecial
        self.fridaySpecial = fridaySpecial
        self.saturdaySpecial = saturdaySpecial
        self.sundaySpecial = sundaySpecial
        
        if let imageName = dict["imageName"] as? String , !imageName.isEmpty {
            photo = UIImage(named: imageName)
        } else {
            photo = nil
        }
        
        //Image Array!!!!
        
        if let image1 = dict["image1"] as? String, !image1.isEmpty {
            imageArray1 = UIImage(named: image1)
        } else {
            imageArray1 = nil
        }
        
        if let image2 = dict["image2"] as? String, !image2.isEmpty {
            imageArray2 = UIImage(named: image2)
        } else {
            imageArray2 = nil
        }
        
        if let image3 = dict["image3"] as? String, !image3.isEmpty {
            imageArray3 = UIImage(named: image3)
        } else {
            imageArray3 = nil
        }
        
        if let image4 = dict["image4"] as? String, !image4.isEmpty {
            imageArray4 = UIImage(named: image4)
        } else {
            imageArray4 = nil
        }
        
        
        
        
        if let thumbnailName = dict["thumbnailName"] as? String , !thumbnailName.isEmpty {
            thumbnail = UIImage(named: thumbnailName)
        } else {
            thumbnail = nil
        }
        
        if let latitude = dict["latitude"] as? Double, let longitude = dict["longitude"] as? Double {
            location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            location = nil
        }
        
    }
}

extension RestaurantHouse {
    static func loadDefaultRestaurantHouses() -> [RestaurantHouse]? {
        return self.loadRestaurantHousesFromPlistNamed(plistName: "restaurants")
    }
    
    static func loadRestaurantHousesFromPlistNamed(plistName: String) -> [RestaurantHouse]? {
        guard let path = Bundle.main.path(forResource: plistName, ofType: "plist"),
            let array = NSArray(contentsOfFile: path) as? [[String : AnyObject]] else {
                return nil
        }
        
        return array.map { RestaurantHouse(dict: $0)}
            .filter { $0 != nil }
            .map { $0! }
    }
    
}

extension RestaurantHouse: CustomStringConvertible {
    var description: String {
        return "\(name) :: \(details)"
    }
}

class RestaurantHouseLocation : NSObject {
    let name : String

    let location : CLLocation
    let image : UIImage?
    
    init(name: String, image: String, longitude: Double, latitude: Double) {
        self.name = name
        self.location = CLLocation(latitude: latitude, longitude: longitude)
        self.image = UIImage(named: image)
    }
}

extension RestaurantHouseLocation: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        get {
            return location.coordinate
        }
    }
    var title: String? {
        get {
            return name
        }
    }
    
}
    






