//
//  Trip.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftDate

final class Trip: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var isDirty = true
    @objc dynamic var creationDate = Date()
    @objc dynamic var tripName = ""
    
    @objc dynamic var tripSource : TripLocation?
    @objc dynamic var tripDest : TripLocation?
    
    var tripDuration: Int64 {     //computed property, will be ignored by realm
        let duration = tripDest?.tripTime.getInterval(toDate: tripSource!.tripTime, component: .hour)
        return duration!
    }

    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(value: TripViMo) {
        self.init()
        self.tripName = value.tripName
        self.tripSource = TripLocation(value: value.source)
        self.tripDest = TripLocation(value: value.dest)
        self.creationDate = value.creationDate
    }
    
}

