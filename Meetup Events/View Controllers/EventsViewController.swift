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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Event.getEvents { (events) in
//            print("EVENTS:",events)
            self.events = events
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension EventsViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
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

