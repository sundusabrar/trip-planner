//
//  Trip.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import Foundation
import RealmSwift

final class Trip: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var source = ""
    @objc dynamic var destination = ""
    @objc dynamic var departureTime = Date()
    @objc dynamic var arrivalTime = Date()
    @objc dynamic var isDirty = true
    @objc dynamic var creationDate = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(value: TripViMo) {
        self.init()
       // self.id = UUID().uuidString
        self.source = value.source
        self.destination = value.destination
        self.departureTime = value.departureTime
        self.arrivalTime = value.arrivalTime
    }
    
}

