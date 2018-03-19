//
//  Constants.swift
//  Meetup Events
//
//  Created by Charles von Lehe on 3/18/18.
//  Copyright © 2018 Charles von Lehe. All rights reserved.
//

import Foundation

// Meetup API Constants
struct MeetupAPI {
    static let API_KEY = "5e162d7314513c7d2b141a437e57515"
    static var eventsURL = "http://api.meetup.com/find/events"
    
    //Keys for events query
    struct Keys {
        static let key = "key"
        static let sign = "sign"
        static let fields = "fields"
        static let text = "text"
    }
    
    //Values for events query
    struct Values {
        static let featured_photo = "featured_photo"
        static let plain_text_description = "plain_text_description"
    }
}

struct UserDefaultKeys {
    static let favorites = "favorites"
}
struct ViewControllerIDs {
    static let EventDetailsViewController = "EventDetailsViewController"
}

struct CellIDs {
    static let EventTableViewCell = "EventTableViewCell"
}

struct Fields {
    //Fields for events json
    struct Event {
        static let created = "created"
        static let duration = "duration"
        static let id = "id"
        static let name = "name"
        static let rsvp_limit = "rsvp_limit"
        static let status = "status"
        static let time = "time"
        static let local_date = "local_date"
        static let local_time = "local_time"
        static let updated = "updated"
        static let utc_offset = "utc_offset"
        static let waitlist_count = "waitlist_count"
        static let yes_rsvp_count = "yes_rsvp_count"
        static let venue = "venue"
        static let group = "group"
        static let link = "link"
        static let description = "description"
        static let how_to_find_us = "how_to_find_us"
        static let visibility = "visibility"
        static let rsvp_close_offset = "rsvp_close_offset"
        static let featured_photo = "featured_photo"
        static let plain_text_description = "plain_text_description"
        
        //Possible values of event status
        struct StatusValues {
            static let cancelled = "cancelled"
            static let upcoming = "upcoming"
            static let past = "past"
            static let proposed = "proposed"
            static let suggested = "suggested"
            static let draft = "draft"
        }
        
        //Possible values for event visibility
        struct VisibilityValues {
            static let public_visiblity = "public"
            static let public_limited = "public_limited"
            static let members = "members"
        }
        
    }
    
    //Fields for Venue json
    struct Venue {
        static let id = "id"
        static let name = "name"
        static let lat = "lat"
        static let lon = "lon"
        static let repinned = "repinned"
        static let address_1 = "address_1"
        static let address_2 = "address_2"
        static let address_3 = "address_3"
        static let city = "city"
        static let state = "state"
        static let country = "country"
        static let localized_country_name = "localized_country_name"
        static let zip = "zip"
    }
    
    //Fields for group json
    struct Group {
        static let created = "created"
        static let name = "name"
        static let id = "id"
        static let join_mode = "join_mode"
        static let lat = "lat"
        static let lon = "lon"
        static let urlname = "urlname"
        static let who = "who"
        static let localized_location = "localized_location"

        //Possible values for join types
        struct JoinValues {
            static let open = "open"
            static let approval = "approval"
            static let closed = "closed"
        }
    }
    
    //Fields for event featured photo
    struct FeaturedPhoto {
        static let base_url = "base_url"
        static let highres_link = "highres_link"
        static let id = "id"
        static let photo_link = "photo_link"
        static let thumb_link = "thumb_link"
    }
}
