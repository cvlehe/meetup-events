//
//  City.swift
//  Meetup Events
//
//  Created by Charles von Lehe on 3/21/18.
//  Copyright © 2018 Charles von Lehe. All rights reserved.
//

import Foundation
import CoreLocation

struct City {
    var city:String?
    var state:String?
    var lat:CLLocationDegrees?
    var lon:CLLocationDegrees?
    
    init(json:[String:Any]) {
        city = json[MeetupAPI.Keys.city] as? String
        state = json[MeetupAPI.Keys.state] as? String
        lat = json[MeetupAPI.Keys.lat] as? CLLocationDegrees
        lon = json[MeetupAPI.Keys.lon] as? CLLocationDegrees
    }
    
    init(placemark:CLPlacemark) {
        city = placemark.locality
        state = placemark.administrativeArea
        lat = placemark.location?.coordinate.latitude
        lon = placemark.location?.coordinate.longitude
    }
}
