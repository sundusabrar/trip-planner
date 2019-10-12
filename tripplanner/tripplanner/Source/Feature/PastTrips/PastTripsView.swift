//
//  SecondViewController.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import UIKit

protocol PastTripViewInterface {
    func didLoadTrips(trips: [TripViMo])
}

class PastTripsView: UIViewController, PastTripViewInterface {

    var presenter: PastTripModuleInterface?
    var dataSource = [TripViMo]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: "TripViewCell", bundle: nil), forCellReuseIdentifier: "TripCell")
        presenter?.loadData()
    }
    
    func didLoadTrips(trips: [TripViMo]) {
        dataSource = trips
        self.tableView.reloadData()
    }
}


extension PastTripsView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as? TripViewCell else {
            fatalError("ERROR: culd not deque cell")
        }
        
        let obj = dataSource[indexPath.row]
        cell.tripName.text = obj.source
        cell.destinationLabel.text = obj.destination
        cell.departureTime.text = obj.arrivalTime.toString()
        cell.arrivalTime.text = obj.arrivalTime.toString()
        
        return cell
    }
}

