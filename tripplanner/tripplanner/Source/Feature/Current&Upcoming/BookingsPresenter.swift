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
        bookingViewInterface?.presentLoader()
        perform(#selector(fetchData), with: nil, afterDelay: 0.1)
    }
    
    @objc
    func fetchData() {
         bookingInteractorInput!.loadData()
    }
    func didLoadData(trips: [String: [TripViMo]]) {
        print(trips)
    }
    
    func didLoadTripData(trips: [[TripViMo]]) {
        bookingViewInterface?.removeLoader()
        bookingViewInterface?.didLoadTrips(trips: trips)
    }
}
