//
//  FirstViewController.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import UIKit

protocol BookingsViewInterface {
    func didLoadTrips(trips: [[TripViMo]])
}

class BookingsViewController: UIViewController, BookingsViewInterface {

    var presenter: BookingsModuleInterface?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTripButton: UIButton!
    
    var dataSource = [[TripViMo]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Register nib for custom cell class
        tableView.register(UINib(nibName: "TripViewCell", bundle: nil), forCellReuseIdentifier: "TripCell")
        presenter?.loadData()
    }
    
    @IBAction func addTripButonPressed(_ sender: Any) {
        presenter?.presentAddNewTrips()
    }
    
    func didLoadTrips(trips: [[TripViMo]]) {
        dataSource = trips
        self.tableView.reloadData()
    }
    
}

extension BookingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return String(format: "Current trips: \(dataSource[section].count)")
        }
        else {
            return String(format: "Upcoming Trips: \(dataSource[section].count)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as? TripViewCell else {
            fatalError("ERROR: culd not deque cell")
        }

        let obj = dataSource[indexPath.section][indexPath.row]
        cell.tripName.text = obj.source
        cell.destinationLabel.text = obj.destination
        cell.departureTime.text = obj.arrivalTime.toString()
        cell.arrivalTime.text = obj.arrivalTime.toString()
        
        return cell
    }
}

