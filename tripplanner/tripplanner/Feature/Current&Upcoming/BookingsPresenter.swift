//
//  BookingsProtocol.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import Foundation

protocol BookingsModuleInterface {
    func fetchCurrentTrips()
    func fetchUpcomingTrips()
    func presentAddNewTrips()
}

protocol BookingsInteractorOutput {
    
}

class BookingsPresenter: NSObject, BookingsModuleInterface, BookingsInteractorOutput {
    var bookingViewInterface: BookingsViewInterface?
    var bookingInteractorInput: BookingInteractorInput?
    var bookingRouter: BookingsRouter?
    
    func fetchCurrentTrips() {
        
    }
    func fetchUpcomingTrips() {
        
    }
    func presentAddNewTrips() {
        bookingRouter!.presentAddNewTrip()
    }
}
