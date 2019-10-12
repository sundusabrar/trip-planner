//
//  DataManager.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import Foundation
import RealmSwift

class DataManager {
    private var database:Realm
    static let sharedInstance = DataManager()
    
    private init() {
        database = try! Realm()
    }
    
    func fetchAllTrips() -> Results<Trip> {
        let results: Results<Trip> =   database.objects(Trip.self)
        return results
    }
    
    func fetchCurrentTrips() -> [Trip] {
        let todayStart = Date().dateAtStartOf(.day)
        let todayEnd = Date().dateAtEndOf(.day)
        let results = database.objects(Trip.self).filter("departureTime BETWEEN {%@, %@}", todayStart, todayEnd)
        //filter("departureTime == %@", now)
        return Array(results)
    }
    
    func fetchUpcomingTrips() -> [Trip] {
        let now = Date().dateAtEndOf(.day)
        let results = database.objects(Trip.self).filter("departureTime > %@", now)
        return Array(results)
    }
    
    func fetchAllPastTrips() -> [Trip] {
        let now = Date().dateAtStartOf(.day)
        let results = database.objects(Trip.self).filter("departureTime < %@", now)
        return Array(results)
    }
    
    func addTrip(objects: [Trip])   {
        
        try! database.write {
            database.add(objects, update: true)
            print("Added new objects")
        }
    }
    
    func deleteAllTrips()  {
        try!   database.write {
            database.deleteAll()
        }
    }
    
    func deleteFromDb(trip: Trip)   {
        try!   database.write {
            database.delete(trip)
        }
    }
}
