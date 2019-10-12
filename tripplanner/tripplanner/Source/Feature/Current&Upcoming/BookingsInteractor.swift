//
//  BookingsInteractor.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import Foundation

protocol BookingInteractorInput {
    func loadData()
}

class BookingsInteractor: NSObject, BookingInteractorInput {
    var output: BookingsInteractorOutput?
    
    func loadData() {
        
        let currentTrips = DataManager.sharedInstance.fetchCurrentTrips()
        let upcomingTrips = DataManager.sharedInstance.fetchUpcomingTrips()
        var currTrips = [TripViMo]()
        var upcoming = [TripViMo]()
        
        for t in currentTrips {
            let tripvimo = TripViMo(source: t.source,
                                    destination: t.destination,
                                    departureTime: t.departureTime,
                                    arrivalTime: t.arrivalTime)
            currTrips.append(tripvimo)
        }
  
        for t in upcomingTrips {
            let tripvimo = TripViMo(source: t.source,
                                    destination: t.destination,
                                    departureTime: t.departureTime,
                                    arrivalTime: t.arrivalTime)
            upcoming.append(tripvimo)
        }
        
        let results = [currTrips, upcoming]
        
        let returnVal = Dictionary(uniqueKeysWithValues: zip(["Current","Upcoming"], [currTrips, upcoming]))
        
        //output?.didLoadData(trips: returnVal)
        
        output?.didLoadTripData(trips: results)
    }

}
