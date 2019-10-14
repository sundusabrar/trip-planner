//
//  FirstViewController.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import UIKit
import PKHUD
import MaterialComponents
import SwiftIcons

protocol BookingsViewInterface {
    func presentLoader()
    func removeLoader()
    func didLoadTrips(trips: [[TripViMo]])
}

class BookingsViewController: UIViewController, BookingsViewInterface {

    var presenter: BookingsModuleInterface?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTripButton: MDCFloatingButton!
    
    var dataSource = [[TripViMo]]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register nib for custom cell class
        tableView.register(UINib(nibName: "TripViewCell", bundle: nil), forCellReuseIdentifier: "TripCell")
        tableView.tableFooterView = UIView()
        self.navigationItem.title = "Current Bookings"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter?.loadData()
    }
    
    @IBAction func addTripButonPressed(_ sender: Any) {
        presenter?.presentAddNewTrips()
    }
    
    func didLoadTrips(trips: [[TripViMo]]) {
        dataSource = trips
    }
    
    func presentLoader() {
        HUD.dimsBackground = true
        HUD.show(HUDContentType.progress)
    }
    
    func removeLoader() {
        HUD.hide()
    }
}

extension BookingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            if dataSource[section].count == 0 {
                return String(format: "You do not have any current trips")
            }
            return String(format: "Your current trips")
        }
        else {
            if dataSource[section].count == 0 {
                return String(format: "You do not have any upcoming trips")
            }
            return String(format: "Your upcoming trips: \(dataSource[section].count)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as? TripViewCell else {
            fatalError("ERROR: culd not deque cell")
        }

        let obj = dataSource[indexPath.section][indexPath.row]
        cell.tripName.text = obj.tripName
        cell.destinationLabel.text = obj.dest.address
        cell.destinationCity.text = obj.dest.cityName
        cell.arrivalTime.text = "\(obj.source.tripTime.day).\(obj.source.tripTime.month) - \(obj.dest.tripTime.day).\(obj.dest.tripTime.month)"
        
        return cell
    }
}

