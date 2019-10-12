//
//  FirstViewController.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import UIKit

protocol BookingsViewInterface {
    
}

class BookingsView: UIViewController, BookingsViewInterface {

    
    var presenter: BookingsModuleProtocol?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTripButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Register nib for custom cell class
        tableView.register(UINib(nibName: "TripViewCell", bundle: nil), forCellReuseIdentifier: "TripCell")
        
    }

    @IBAction func addNewTrip(_ sender: Any) {
    }
    

}

extension BookingsView: UITableViewDelegate, UITableViewDataSource {
    
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

