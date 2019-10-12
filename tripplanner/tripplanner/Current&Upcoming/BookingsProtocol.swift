//
//  BookingsProtocol.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import Foundation

protocol BookingsProtocol {
    func fetchCurrentTrips()
    func fetchUpcomingTrips()
    func presentAddNewTrips()
}
