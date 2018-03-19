//
//  Group.swift
//  Meetup Events
//
//  Created by Charles von Lehe on 3/18/18.
//  Copyright © 2018 Charles von Lehe. All rights reserved.
//

import Foundation
import CoreLocation

struct Group {
    private var created:Date?
    var name:String?
    private var id:String?
    private var joinMode:JoinMode?
    private var location:CLLocation?
    private var urlName:String?
    private var who:String?
    private var localizedLocation:String?
    
    init(json:[String:Any]) {
        if let created = json[Fields.Group.created] as? TimeInterval {
            self.created = Date(timeIntervalSince1970: created)
        }
        
        if let name = json[Fields.Group.name] as? String {
            self.name = name
        }
        
        if let id = json[Fields.Group.id] as? String {
            self.id = id
        }
        
        //Set enum for join mode
        if let joinMode = json[Fields.Group.join_mode] as? String {
            switch joinMode {
            case Fields.Group.JoinValues.open: self.joinMode = .open
            case Fields.Group.JoinValues.approval: self.joinMode = .approval
            case Fields.Group.JoinValues.closed: self.joinMode = .closed
            default: break
            }
            
        }
        
        //Set location for lat and lon
        if let lat = json[Fields.Group.lat] as? CLLocationDegrees, let lon = json[Fields.Group.lon] as? CLLocationDegrees {
            self.location = CLLocation(latitude: lat, longitude: lon)
        }
        
        if let urlName = json[Fields.Group.urlname] as? String {
            self.urlName = urlName
        }
        
        if let who = json[Fields.Group.who] as? String {
            self.who = who
        }
        
        if let localizedLocation = json[Fields.Group.localized_location] as? String {
            self.localizedLocation = localizedLocation
        }
    }
    
    enum JoinMode {
        case open, approval, closed
    }
}
