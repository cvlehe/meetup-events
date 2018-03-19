//
//  FeaturedPhoto.swift
//  Meetup Events
//
//  Created by Charles von Lehe on 3/18/18.
//  Copyright © 2018 Charles von Lehe. All rights reserved.
//

import Foundation

class FeaturedPhoto {
    private var baseUrl:String?
    private var highResLink:String?
    private var id:String?
    private var photoLink:String?
    private var thumbLink:String?
    
    init(json:[String:Any]) {
        if let baseUrl = json[Fields.FeaturedPhoto.base_url] as? String {
            self.baseUrl = baseUrl
        }
        
        if let highResLink = json[Fields.FeaturedPhoto.highres_link] as? String {
            self.highResLink = highResLink
        }
        
        if let id = json[Fields.FeaturedPhoto.id] as? String {
            self.id = id
        }
        
        if let photoLink = json[Fields.FeaturedPhoto.photo_link] as? String {
            self.photoLink = photoLink
        }
        
        if let thumbLink = json[Fields.FeaturedPhoto.thumb_link] as? String {
            self.thumbLink = thumbLink
        }
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
