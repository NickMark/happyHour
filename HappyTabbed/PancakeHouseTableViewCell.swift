//
//  PancakeHouseTableViewCell.swift
//  WaffleHouseNick
//
//  Created by Nicholas Evans on 2016-10-03.
//  Copyright © 2016 Nicholas Evans. All rights reserved.
//

import UIKit

class PancakeHouseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var priceRangeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    @IBOutlet weak var happyHoursLabel: UILabel!
    @IBOutlet weak var typeBarLabel: UILabel!
    
    @IBOutlet weak var viewCell: UIView!
    
    

    
    var restaurantHouse: RestaurantHouse? {
        didSet {
            if let restaurantHouse = restaurantHouse {
                nameLabel?.text = restaurantHouse.name
                restaurantImage?.image = restaurantHouse.imageArray1 ?? UIImage(named: "placeholder_thumb")
                cityLabel?.text = restaurantHouse.address
                distanceLabel?.text = "\(restaurantHouse.distance)" + "KM"
                typeBarLabel?.text = restaurantHouse.details
                happyHoursLabel?.text = restaurantHouse.happyHour
                restaurantImage.layer.cornerRadius = 10
                viewCell.layer.cornerRadius = 10
                
            }
        }
    }
    
}
