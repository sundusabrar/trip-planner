//
//  AddTripViewController.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import UIKit

protocol AddTripViewInterface {
    
}

class AddTripView: UIViewController, AddTripViewInterface {

    @IBOutlet weak var sourceTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var departureDateTextField: UITextField!
    @IBOutlet weak var arrivalTextField: UITextField!
    
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var saveTripButton: UIButton!
    var eventHandler: AddTripModuleInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    @IBAction func saveTripPressed(_ sender: Any) {
        eventHandler!.discardView()
    }
    
    
    
    
}
