//
//  PastTripsInteractor.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import Foundation
import CoreLocation

protocol PastTripInteractorInput {
    func loadData()
}

class PastTripInteractor: NSObject, PastTripInteractorInput {
    var output: PastTripInteractorOutput?
    
    func loadData() {
        
        let currentTrips = DataManager.sharedInstance.fetchAllPastTrips()
        var currTrips = [TripViMo]()
        
        for t in currentTrips {
            let source = TripLocationViMo.createVimo(tripLoc: t.tripSource!)
            let dest = TripLocationViMo.createVimo(tripLoc: t.tripDest!)
            
            let tripvimo = TripViMo(tripName: t.tripName, source: source, dest: dest, creationDate: t.creationDate)
            currTrips.append(tripvimo)
        }
        
        output?.didLoadTripData(trips: currTrips)
    }
}
