//
//  EventTableViewCell.swift
//  Meetup Events
//
//  Created by Charles von Lehe on 3/18/18.
//  Copyright © 2018 Charles von Lehe. All rights reserved.
//

import UIKit
import SDWebImage

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var likedImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate (event:Event) {
        titleLabel.text = event.name
        
        if let photoUrl = event.getPhotoUrl() {
            eventImageView.sd_setImage(with: URL(string: photoUrl), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        }
        descriptionLabel.text = event.plainTextDescription
        
        likedImageView.isHidden = !event.isFavorite()
        
        if let locationString = event.venue?.locationString {
            locationLabel.text = locationString
        }else {
            locationLabel.isHidden = true
            locationImageView.isHidden = true
        }
    
        timeLabel.text = event.getDateString()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = ""
        eventImageView.image = #imageLiteral(resourceName: "placeholder")
        descriptionLabel.text = ""
        likedImageView.isHidden = true
        timeLabel.text = ""
        locationLabel.text = ""
        
    }

}
