//
//  BookingsProtocol.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import Foundation

protocol BookingsModuleProtocol {
    func fetchCurrentTrips()
    func fetchUpcomingTrips()
    func presentAddNewTrips()
}

class BookingsPresenter: NSObject, BookingsModuleProtocol, BookingsInteractorOutput {
    var bookingViewInterface: BookingsViewInterface?
    
    func fetchCurrentTrips() {
        
    }
    func fetchUpcomingTrips() {
        
    }
    func presentAddNewTrips() {
        
    }
}
