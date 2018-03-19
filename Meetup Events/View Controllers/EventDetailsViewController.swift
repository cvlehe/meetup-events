//
//  EventDetailsViewController.swift
//  Meetup Events
//
//  Created by Charles von Lehe on 3/18/18.
//  Copyright © 2018 Charles von Lehe. All rights reserved.
//

import UIKit
import MapKit

class EventDetailsViewController: UIViewController {
    private var event:Event!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var venueTitleLabel: UILabel!
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var favoriteContainerView: UIView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var rsvpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        titleLabel.text = event.name
        titleLabel.sizeToFit()
        dateLabel.text = event.getTimeString()
        
        if let photoUrl = event.getPhotoUrl() {
            imageView.sd_setImage(with: URL(string: photoUrl), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        }
        setSavedButton()
        locationLabel.text = event.venue?.getAddressString()
        descriptionLabel.text = event.plainTextDescription
        descriptionLabel.sizeToFit()
        venueLabel.text = event.venue?.name
        if let location = event.venue?.location {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            mapView.addAnnotation(annotation)
            mapView.showAnnotations([annotation], animated: true)
            mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(EventDetailsViewController.mapViewTapped(_:))))
        }
        
        groupNameLabel.text = event.group?.name
        rsvpLabel.text = "\(event.yesRsvpCount) RSVPs"
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func mapViewTapped (_ tap:UITapGestureRecognizer) {
        event.venue?.openInMaps()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: mapView.frame.origin.y + mapView.frame.size.height + favoriteContainerView.frame.size.height)
        scrollView.isScrollEnabled = true
    }
    
    func setSavedButton () {
        saveButton.setImage(event.isFavorite() ? #imageLiteral(resourceName: "saved") : #imageLiteral(resourceName: "save"), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        event.toggleFavorite()
        setSavedButton()
    }
    
    static func display (navigationController:UINavigationController?, event:Event) {
        let detailsView = navigationController!.storyboard!.instantiateViewController(withIdentifier: ViewControllerIDs.EventDetailsViewController) as! EventDetailsViewController
        detailsView.event = event
        navigationController?.pushViewController(detailsView, animated: true)
    }

}
