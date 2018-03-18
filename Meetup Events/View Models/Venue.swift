//
//  Venue.swift
//  Meetup Events
//
//  Created by Charles von Lehe on 3/18/18.
//  Copyright © 2018 Charles von Lehe. All rights reserved.
//

import Foundation
import CoreLocation

struct Venue {
    private var id:String?
    private var name:String?
    private var location:CLLocation?
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
        if let id = json[Fields.Venue.id] as? String {
            self.id = id
        }
        
        if let name = json[Fields.Venue.name] as? String {
            self.name = name
        }
        
        if let lat = json[Fields.Venue.lat] as? CLLocationDegrees, let lon = json[Fields.Venue.lon] as? CLLocationDegrees {
            self.location = CLLocation(latitude: lat, longitude: lon)
        }
        
        if let repinned = json[Fields.Venue.repinned] as? Bool {
            self.repinned = repinned
        }
        
        if let address1 = json[Fields.Venue.address_1] as? String {
            self.address1 = address1
        }
        
        if let address2 = json[Fields.Venue.address_2] as? String {
            self.address2 = address2
        }
        
        if let address3 = json[Fields.Venue.address_3] as? String {
            self.address3 = address3
        }
        
        if let city = json[Fields.Venue.city] as? String {
            self.city = city
        }
        
        if let state = json[Fields.Venue.state] as? String {
            self.state = state
        }
        
        if let country = json[Fields.Venue.country] as? String {
            self.country = country
        }
        
        if let localizedCountryName = json[Fields.Venue.localized_country_name] as? String {
            self.localizedCountryName = localizedCountryName
        }
        
        if let zip = json[Fields.Venue.zip] as? String {
            self.zip = zip
        }
    }
}
