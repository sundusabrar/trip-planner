//
//  BookingsProtocol.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import Foundation

protocol BookingsModuleInterface {
    func loadData() 
    func presentAddNewTrips()
}

protocol BookingsInteractorOutput {
    func didLoadData(trips: [String: [TripViMo]])
    func didLoadTripData(trips: [[TripViMo]])
}

class BookingsPresenter: NSObject, BookingsModuleInterface, BookingsInteractorOutput {

    var bookingViewInterface: BookingsViewInterface?
    var bookingInteractorInput: BookingInteractorInput?
    var bookingRouter: BookingsRouter?
    
    func presentAddNewTrips() {
        bookingRouter!.presentAddNewTrip()
    }
    
    func loadData() {
        bookingInteractorInput!.loadData()
    }
    
    func didLoadData(trips: [String: [TripViMo]]) {
        print(trips)
    }
    
    func didLoadTripData(trips: [[TripViMo]]) {
        bookingViewInterface?.didLoadTrips(trips: trips)
    }
}
