//
//  Venue.swift
//  Meetup Events
//
//  Created by Charles von Lehe on 3/18/18.
//  Copyright © 2018 Charles von Lehe. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

struct Venue {
    private var id:String?
    var name:String?
    var location:CLLocation?
    private var repinned = false
    private var address1:String?
    private var address2:String?
    private var address3:String?
    private var city:String?
    private var state:String?
    private var country:String?
    private var localizedCountryName:String?
    private var zip:String?
    
    init(json:[String:Any]) {
        self.id = json[Fields.Venue.id] as? String
        self.name = json[Fields.Venue.name] as? String
        self.address1 = json[Fields.Venue.address_1] as? String
        self.address2 = json[Fields.Venue.address_2] as? String
        self.address3 = json[Fields.Venue.address_3] as? String
        self.city = json[Fields.Venue.city] as? String
        self.state = json[Fields.Venue.state] as? String
        self.country = json[Fields.Venue.country] as? String
        self.localizedCountryName = json[Fields.Venue.localized_country_name] as? String
        self.zip = json[Fields.Venue.zip] as? String

        
        if let lat = json[Fields.Venue.lat] as? CLLocationDegrees, let lon = json[Fields.Venue.lon] as? CLLocationDegrees {
            self.location = CLLocation(latitude: lat, longitude: lon)
        }
        
        if let repinned = json[Fields.Venue.repinned] as? Bool {
            self.repinned = repinned
        }
    }
    
    //Get stylized address string
    func getAddressString () -> String? {
        var address = address1
        if let add2 = address2 {
            address = add2
        }
        if let add3 = address3 {
            address = add3
        }
        
        guard let add = address, let city = city, let state = state, let zip = zip else {
            return "\(address ?? "")\n"
        }
        
        return "\(add)\n\(city), \(state) \(zip)"
        
    }
    
    //Open venue location in Maps
    func openInMaps () {
        guard let location = location else {return}
        let placemark = MKPlacemark(coordinate: location.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMaps(launchOptions: nil)
    }
    
    //Get stylized location string
    var locationString:String? {
        if let city = city, let state = state {
            return "\(city), \(state)"
        }else {
            return nil
        }
    }
}
