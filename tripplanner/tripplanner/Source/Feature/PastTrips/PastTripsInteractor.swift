//
//  PastTripsInteractor.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import Foundation

protocol PastTripInteractorInput {
    func loadData()
}

class PastTripInteractor: NSObject, PastTripInteractorInput {
    var output: PastTripInteractorOutput?
    
    func loadData() {
        
        let currentTrips = DataManager.sharedInstance.fetchAllPastTrips()
        var currTrips = [TripViMo]()
        
        for t in currentTrips {
            let tripvimo = TripViMo(source: t.source,
                                    destination: t.destination,
                                    departureTime: t.departureTime,
                                    arrivalTime: t.arrivalTime)
            currTrips.append(tripvimo)
        }
        
        output?.didLoadTripData(trips: currTrips)
    }
}
