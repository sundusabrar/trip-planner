//
//  PastTripsPresenter.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import Foundation

protocol PastTripModuleInterface {
    func loadData()
}
protocol PastTripInteractorOutput {
    func didLoadTripData(trips: [TripViMo])
}

class PastTripPresenter: NSObject, PastTripModuleInterface, PastTripInteractorOutput {
    var pastTripView: PastTripViewInterface?
    var pastTripInteractorInput: PastTripInteractorInput?
    var pastTripRouter: PastTripRouter?

    func loadData() {
        pastTripInteractorInput!.loadData()
    }
    
    func didLoadTripData(trips: [TripViMo]) {
        pastTripView?.didLoadTrips(trips: trips)
    }
}
