//
//  Event.swift
//  Meetup Events
//
//  Created by Charles von Lehe on 3/18/18.
//  Copyright © 2018 Charles von Lehe. All rights reserved.
//

import Foundation
import Alamofire

class Event {
    private var created:Date?
    private var duration:Int?
    private var id:String?
    var name:String?
    private var status:Status?
    private var time:Date?
    private var localDate:String?
    private var localTime:String?
    private var rsvpCloseOffset:String?
    private var updated:Date?
    private var utcOffset:String?
    private var waitlistCount:Int?
    var yesRsvpCount = 0
    var venue:Venue?
    var group:Group?
    private var link:URL?
    var description:String?
    private var visibility:Visibility?
    private var howToFindUs:String?
    private var featuredPhoto:FeaturedPhoto?
    var plainTextDescription:String?
    
    //Initialization for event with fetched json
    init(json:[String:Any]) {
        
        self.duration = json[Fields.Event.duration] as? Int
        self.id = json[Fields.Event.id] as? String
        self.name = json[Fields.Event.name] as? String
        self.utcOffset = json[Fields.Event.utc_offset] as? String
        self.waitlistCount = json[Fields.Event.waitlist_count] as? Int
        self.localDate = json[Fields.Event.local_date] as? String
        self.localTime = json[Fields.Event.local_time] as? String
        self.rsvpCloseOffset = json[Fields.Event.rsvp_close_offset] as? String
        self.description = json[Fields.Event.description] as? String
        self.plainTextDescription = json[Fields.Event.plain_text_description] as? String
        self.howToFindUs = json[Fields.Event.how_to_find_us] as? String

        
        if let created = json[Fields.Event.created] as? TimeInterval {
            self.created = Date(timeIntervalSince1970: created)
        }
        
        if let time = json[Fields.Event.time] as? TimeInterval {
            self.time = Date(timeIntervalSince1970: time)
        }
        
        if let updated = json[Fields.Event.updated] as? TimeInterval {
            self.updated = Date(timeIntervalSince1970: updated)
        }
        
        if let yesRsvpCount = json[Fields.Event.yes_rsvp_count] as? Int {
            self.yesRsvpCount = yesRsvpCount
        }
        
        if let venue = json[Fields.Event.venue] as? [String:Any] {
            self.venue = Venue(json: venue)
        }
        
        if let group = json[Fields.Event.group] as? [String:Any] {
            self.group = Group(json: group)
        }
        
        if let link = json[Fields.Event.link] as? String, let url = URL(string: link) {
            self.link = url
        }
        
        if let featuredPhoto = json[Fields.Event.featured_photo] as? [String:Any] {
            self.featuredPhoto = FeaturedPhoto(json: featuredPhoto)
        }
        
        //setting enum for event status
        if let status = json[Fields.Event.status] as? String {
            switch status {
            case Fields.Event.StatusValues.cancelled: self.status = .cancelled
            case Fields.Event.StatusValues.upcoming: self.status = .upcoming
            case Fields.Event.StatusValues.past: self.status = .past
            case Fields.Event.StatusValues.proposed: self.status = .proposed
            case Fields.Event.StatusValues.suggested: self.status = .suggested
            case Fields.Event.StatusValues.draft: self.status = .draft
            default:
                break
            }
        }
        
        //setting enum for event visibility
        if let visibility = json[Fields.Event.visibility] as? String {
            switch visibility {
            case Fields.Event.VisibilityValues.public_limited: self.visibility = .publicLimited
            case Fields.Event.VisibilityValues.public_visiblity: self.visibility = .publicVisiblity
            case Fields.Event.VisibilityValues.members: self.visibility = .members
            default: break
            }
        }

    }
    
    
    //Get events from API
    static func getEvents (searchText:String?, city:City?, completion:@escaping (_ events:[Event], _ city:City?)->Void) {
        let url = MeetupAPI.eventsURL
        var parameters = [String:Any]()
        parameters[MeetupAPI.Keys.key] = MeetupAPI.API_KEY
        parameters[MeetupAPI.Keys.sign] = true
        parameters[MeetupAPI.Keys.page] = 11
        parameters[MeetupAPI.Keys.order] = MeetupAPI.Values.time
        
        //If selected location exists, add it to request
        if let lat = city?.lat, let lon = city?.lon {
            parameters[MeetupAPI.Keys.lat] = lat
            parameters[MeetupAPI.Keys.lon] = lon
        }
        
        //If search text exists, add it to request
        if let text = searchText {
            parameters[MeetupAPI.Keys.text] = text
        }
        
        parameters[MeetupAPI.Keys.fields] = [MeetupAPI.Values.featured_photo,MeetupAPI.Values.plain_text_description].joined(separator: ",")
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString),headers: nil)
            .responseJSON { (response) in
                if let error = response.error {
                    print("Request Error:",error)
                }else if
                    let data = response.data,
                    let json = self.convertToDictionary(data: data),
                    let cityJson = json[MeetupAPI.Keys.city] as? [String:Any],
                    let eventsJson = json[MeetupAPI.Keys.events] as? [[String:Any]]{
                    
                    var fetchedEvents = [Event]()
                    for event in eventsJson {
                        fetchedEvents.append(Event(json: event))
                    }
                    
                    completion(fetchedEvents, City(json: cityJson))
                    
                }else {
                    completion([], nil)
                }
        }
    }
    
    //convert response data to array of dictionaries
    private static func convertToDictionary(data:Data)->[String:Any]? {
        do {
            let array = try JSONSerialization.jsonObject(with: data) as? [String : Any]
            return array
        }catch {
            return nil
        }
    }
    
    //Check User Defaults if event has been favorited
    func isFavorite ()->Bool {
        guard let array = UserDefaults.standard.array(forKey: UserDefaultKeys.favorites) as? [String] else {
            UserDefaults.standard.set([String](), forKey: UserDefaultKeys.favorites)
            UserDefaults.standard.synchronize()
            return false
        }
        
        guard let id = self.id else {
            return false
        }
        
        return array.contains(id)
    }
    
    //Get photo url from fetched featured photo
    func getPhotoUrl () -> String? {
        return featuredPhoto?.getPhotoUrl()
    }
    
    func getDateString () -> String? {
        guard let time = self.time else {return nil}
        let df = DateFormatter()
        df.dateFormat = "MM/dd"
        return df.string(from: time)
    }
    
    func getTimeString () -> String? {
        guard let time = self.time else {return nil}
        let df = DateFormatter()
        df.dateFormat = "MM/dd"
        return "\(df.string(from: time)) - \(getLocalTimeString() ?? "")"
    }
    
    //Toggle favorite status for event
    func toggleFavorite () {
        var array = [String]()
        
        // If array already exisits in User Defaults, set the array to stored array
        if let savedArray = UserDefaults.standard.array(forKey: UserDefaultKeys.favorites) as? [String] {
            array = savedArray
        }
        
        if let id = self.id {
            if let index = array.index(of: id) {
                array.remove(at: index)
            }else {
                array.append(id)
                
            }
        }
        UserDefaults.standard.set(array, forKey: UserDefaultKeys.favorites)
        UserDefaults.standard.synchronize()
    }
    
    private func getLocalTimeString ()->String? {
        guard let localTime = localTime else {return nil}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let date = dateFormatter.date(from: localTime)
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date!)
    }
    
    
    enum Visibility {
        case publicVisiblity, members, publicLimited
    }
    
    enum Status {
        case cancelled, upcoming, past, proposed, suggested, draft
    }
    
    
    
    
}
