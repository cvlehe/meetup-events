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
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = ""
        eventImageView.image = #imageLiteral(resourceName: "placeholder")
        descriptionLabel.text = ""
        
    }

}
