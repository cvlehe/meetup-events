//
//  FeaturedPhoto.swift
//  Meetup Events
//
//  Created by Charles von Lehe on 3/18/18.
//  Copyright © 2018 Charles von Lehe. All rights reserved.
//

import Foundation

struct FeaturedPhoto {
    private var baseUrl:String?
    private var highResLink:String?
    private var id:String?
    private var photoLink:String?
    private var thumbLink:String?
    
    init(json:[String:Any]) {
        self.baseUrl = json[Fields.FeaturedPhoto.base_url] as? String
        self.highResLink = json[Fields.FeaturedPhoto.highres_link] as? String
        self.id = json[Fields.FeaturedPhoto.id] as? String
        self.photoLink = json[Fields.FeaturedPhoto.photo_link] as? String
        self.thumbLink = json[Fields.FeaturedPhoto.thumb_link] as? String
    }
    
    //Get photo url from Featured photo - if photo link doesn't exist, use high res, if that doesn't exist, use thumb link
    func getPhotoUrl()->String? {
        if let photoLink = self.photoLink {
            return photoLink
        }else if let highResLink = self.highResLink {
            return highResLink
        }else {
            return thumbLink
        }
    }
}
