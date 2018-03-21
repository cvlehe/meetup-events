//
//  ViewController.swift
//  Meetup Events
//
//  Created by Charles von Lehe on 3/15/18.
//  Copyright © 2018 Charles von Lehe. All rights reserved.
//

import UIKit
import CoreLocation
import LocationPicker
import MapKit

class EventsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var events = [Event]()
    var selectedIndexPath:IndexPath?
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    var selectedLocation:CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Set status bar to white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

        //Load all events
        
        locationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(EventsViewController.locationViewTapped(_:))))
        locationLabel.text = ""
        Event.getEvents(searchText: nil) { (events) in
            self.events = events
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //If indexPath was set, reload - allows for cell to be reloaded when favorited inside of event details
        if let indexPath = selectedIndexPath {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc func locationViewTapped (_ tap:UITapGestureRecognizer) {
        let locationPicker = LocationPickerViewController()
        if let initialLocation = selectedLocation {
            locationPicker.location = Location(name: nil, location: initialLocation, placemark: MKPlacemark(coordinate: initialLocation.coordinate))
        }
        locationPicker.mapType = .standard
        locationPicker.completion = {location in
            
        }
        navigationController?.pushViewController(locationPicker, animated: true)
    }

}

extension EventsViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Set selected indexPath so cell can be reloaded when favorited in event details
        selectedIndexPath = indexPath
        
        EventDetailsViewController.display(navigationController: navigationController, event: events[indexPath.row])
    }
}

extension EventsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIDs.EventTableViewCell, for: indexPath) as? EventTableViewCell else {
            return UITableViewCell()
        }
        
        cell.populate(event: events[indexPath.row])
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension EventsViewController:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Capture search bar text - if search bar is blank, all events will be fetched
        var text:String?
        if let searchText = searchBar.text, searchText.replacingOccurrences(of: " ", with: "") != "" {
            text = searchText
        }
        
        Event.getEvents(searchText: text) { (events) in
            self.events = events
            self.tableView.reloadData()
        }
    }
}

