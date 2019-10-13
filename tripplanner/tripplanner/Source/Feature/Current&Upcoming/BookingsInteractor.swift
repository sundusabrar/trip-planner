//
//  BookingsInteractor.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import Foundation
import CoreLocation

protocol BookingInteractorInput {
    func loadData()
}

class BookingsInteractor: NSObject, BookingInteractorInput {
    var output: BookingsInteractorOutput?
    
    func loadData() {
        
        // Download latest trips
        NetworkManager.sharedInstance.fetchAllTrips(completion: {
            self.loadOfflineTrips()
        })
    }

    func loadOfflineTrips() {
        let currentTrips = DataManager.sharedInstance.fetchCurrentTrips()
        let upcomingTrips = DataManager.sharedInstance.fetchUpcomingTrips()
        var currTrips = [TripViMo]()
        var upcoming = [TripViMo]()
        
        for t in currentTrips {
            
            let source = TripLocationViMo.createVimo(tripLoc: t.tripSource!)
            let dest = TripLocationViMo.createVimo(tripLoc: t.tripDest!)
            
            let tripvimo = TripViMo(tripName: t.tripName, source: source, dest: dest, creationDate: t.creationDate)
            currTrips.append(tripvimo)
        }
        
        for t in upcomingTrips {
            let source = TripLocationViMo.createVimo(tripLoc: t.tripSource!)
            let dest = TripLocationViMo.createVimo(tripLoc: t.tripDest!)
            
            let tripvimo = TripViMo(tripName: t.tripName, source: source, dest: dest, creationDate: t.creationDate)
            upcoming.append(tripvimo)
        }
        
        let results = [currTrips, upcoming]
        output?.didLoadTripData(trips: results)
    }
}
