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
    var dataSource = [TripViMo](){
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: "TripViewCell", bundle: nil), forCellReuseIdentifier: "TripCell")
        tableView.tableFooterView = UIView()
        self.navigationItem.title = "Completed Trips"
        presenter?.loadData()
    }
    
    func didLoadTrips(trips: [TripViMo]) {
        dataSource = trips
    }
}


extension PastTripsView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as? TripViewCell else {
            fatalError("ERROR: culd not deque cell")
        }
        
        let obj = dataSource[indexPath.row]
        cell.tripName.text = obj.tripName
        cell.destinationLabel.text = obj.dest.address
        cell.destinationCity.text = obj.dest.cityName
        cell.arrivalTime.text = "\(obj.source.tripTime.day).\(obj.source.tripTime.month) - \(obj.dest.tripTime.day).\(obj.dest.tripTime.month)"
        
        return cell
    }
}

