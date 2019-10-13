//
//  TripLocation.swift
//  tripplanner
//
//  Created by Sundus Abrar on 13.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import Foundation
import RealmSwift

final class TripLocation: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var cityName = ""
    @objc dynamic var placeName = ""
    @objc dynamic var lat = 0.0
    @objc dynamic var lon = 0.0
    @objc dynamic var address = ""
    @objc dynamic var tripTime = Date()
    
    convenience init(value: TripLocationViMo) {
        self.init()
        self.cityName = value.cityName
        self.placeName = value.placeName
        self.lat = value.location.latitude
        self.lon = value.location.longitude
        self.address = value.address
        self.tripTime = value.tripTime
    }
}
