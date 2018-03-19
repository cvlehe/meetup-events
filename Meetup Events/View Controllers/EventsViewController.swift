//
//  ViewController.swift
//  Meetup Events
//
//  Created by Charles von Lehe on 3/15/18.
//  Copyright © 2018 Charles von Lehe. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var events = [Event]()
    var selectedIndexPath:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

        Event.getEvents(searchText: nil) { (events) in
            self.events = events
            self.tableView.reloadData()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = selectedIndexPath {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
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

