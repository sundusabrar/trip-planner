//
//  ViewModels.swift
//  tripplanner
//
//  Created by Sundus Abrar on 13.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import Foundation
import CoreLocation

struct TripViMo {
    var tripName = ""
    var source = TripLocationViMo()
    var dest = TripLocationViMo()
    var creationDate = Date()
}

struct TripLocationViMo {
    var cityName = ""
    var placeName = ""
    var address = ""
    var lat = 0.0
    var lon = 0.0
    var location = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var tripTime = Date()
    
    static func createVimo(tripLoc: TripLocation) -> TripLocationViMo {
        return self.init(cityName: tripLoc.cityName,
                         placeName: "",
                         address: tripLoc.address,
                         lat: tripLoc.lat,
                         lon: tripLoc.lon,
                         location: CLLocationCoordinate2D(latitude:tripLoc.lat, longitude: tripLoc.lon),
                         tripTime: tripLoc.tripTime)
    }
}
