//
//  TripLocation.swift
//  tripplanner
//
//  Created by Sundus Abrar on 13.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

final class TripLocation: Object,  Mappable {
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
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        cityName <- map["cityName"]
        placeName <- map["placeName"]
        lat <- map["lat"]
        lon <- map["lon"]
        address <- map["address"]
        tripTime <- (map["tripTime"], DateFormatterTransform(dateFormatter: ServiceDateFormatter.shared.formatter))
    }
}
