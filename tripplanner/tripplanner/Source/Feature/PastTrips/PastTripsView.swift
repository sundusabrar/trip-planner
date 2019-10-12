//
//  SecondViewController.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import UIKit

protocol PastTripViewInterface {
    
}

class PastTripsView: UIViewController, PastTripViewInterface {

    var presenter: PastTripModuleInterface?
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: "TripViewCell", bundle: nil), forCellReuseIdentifier: "TripCell")
        
    }
}


extension PastTripsView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as? TripViewCell else {
            fatalError("ERROR: culd not deque cell")
        }
        
        return cell
    }
}

