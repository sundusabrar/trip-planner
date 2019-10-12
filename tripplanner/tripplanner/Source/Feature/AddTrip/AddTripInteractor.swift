//
//  AddTripInteractor.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import Foundation
import RealmSwift

protocol AddTripInteractorInput {
    func createNewTrip(vimo: TripViMo)
}
class AddTripInteractor: NSObject, AddTripInteractorInput {
   
    var output: AddTripInteractorOutput?
    
    func createNewTrip(vimo: TripViMo) {
        let trip = Trip(value: vimo)
        DataManager.sharedInstance.addTrip(objects: [trip])
        output?.didAddTripObject()
    }
}
