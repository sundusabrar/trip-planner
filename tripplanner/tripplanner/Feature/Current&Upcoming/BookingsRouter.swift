//
//  BookingsWireframe.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import Foundation
import UIKit

class BookingsRouter: NSObject {
    
    var rootWireframe: RootWireFrame?
    
    var bookingViewController: BookingsViewController?
    
    func presentAddNewTrip() {
        let addNewTripRouter = AddTripRouter()
        addNewTripRouter.rootWireFrame = rootWireframe
        addNewTripRouter.presentAddTripView(onView: bookingViewController!)
    }
}
