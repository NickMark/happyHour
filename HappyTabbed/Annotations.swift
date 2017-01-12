//
//  Annotations.swift
//  WaffleHouseNick
//
//  Created by Nicholas Evans on 2016-10-20.
//  Copyright © 2016 Nicholas Evans. All rights reserved.
//

import Foundation
import MapKit

class Annotations: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    var latitude: Double
    var longitude: Double
    var tag : Int
    
    let address: String
    let phoneNumber: String
    let website: String
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(subtitle: String, latitude: Double, longitude: Double, address: String, phoneNumber: String, website: String) {
        
        self.address = address
        self.phoneNumber = phoneNumber
        self.website = website

        self.subtitle = subtitle
        self.latitude = latitude
        self.longitude = longitude
        self.tag = 0
    }

}
   
