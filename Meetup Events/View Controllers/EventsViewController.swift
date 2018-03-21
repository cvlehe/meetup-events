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
    private var events = [Event]()
    private var selectedIndexPath:IndexPath?
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    private var selectedCity:City?
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Set status bar to white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

        //Load all events
        
        locationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(EventsViewController.locationViewTapped(_:))))
        locationLabel.text = ""
        Event.getEvents(searchText: nil, city: nil) { (events, city) in
            self.events = events
            self.tableView.reloadData()
            self.setSelectedCity(city: city)
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
    
    func setSelectedCity(city:City?) {
        //Set the selected city and display in the location label
        self.selectedCity = city
        if let cityString = city?.city, let stateString = city?.state {
            locationLabel.text = "\(cityString), \(stateString)"
        }else {
            locationLabel.text = "Select Loction"
        }
    }
    
    @objc func locationViewTapped (_ tap:UITapGestureRecognizer) {
        //Display Location picker
        
        let locationPicker = LocationPickerViewController()
        if let lat = selectedCity?.lat, let lon = selectedCity?.lon {
            let location = CLLocation(latitude: lat, longitude: lon)
            let initalLocaiton = Location(name: selectedCity?.city, location: location, placemark: MKPlacemark(coordinate: location.coordinate))
            locationPicker.location = initalLocaiton
        }
        locationPicker.mapType = .standard
        locationPicker.showCurrentLocationButton = false
        
        locationPicker.completion = {location in
            //If location selected, reload events for selected location
            if let placemark = location?.placemark {
                self.searchBar.text = ""
                self.setSelectedCity(city: City(placemark: placemark))
                Event.getEvents(searchText: nil, city: self.selectedCity) { (events, city) in
                    self.setSelectedCity(city: city)
                    self.events = events
                    self.tableView.reloadData()
                }
            }
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Hide search bar keyboard when scrolled
        searchBar.resignFirstResponder()
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
        
        Event.getEvents(searchText: text, city: selectedCity) { (events, city) in
            self.setSelectedCity(city: city)
            self.events = events
            self.tableView.reloadData()
        }
    }
}

