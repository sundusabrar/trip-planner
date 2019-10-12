//
//  PastTripsPresenter.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import Foundation

protocol PastTripModuleInterface {

}
protocol PastTripInteractorOutput {
    
}

class PastTripPresenter: NSObject, PastTripModuleInterface, PastTripInteractorOutput {
    var pastTripView: PastTripViewInterface?
    var pastTripInteractorInput: PastTripInteractorInput?
    var pastTripRouter: PastTripRouter?
    
    func discardView() {
       
    }
    
    func addTripDetail() {
        
    }
}
