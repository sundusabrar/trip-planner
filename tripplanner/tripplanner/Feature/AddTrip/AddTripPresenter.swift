//
//  AddTripPresenter.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import Foundation

protocol AddTripModuleInterface {
    func discardView()
    func addTripDetail()
}
protocol AddTripInteractorOutput {
    
}

class AddTripPresenter: NSObject, AddTripModuleInterface, AddTripInteractorOutput {
    var addTripView: AddTripViewInterface?
    var addTripInteractorInput: AddTripInteractorInput?
    var addTripRouter: AddTripRouter?
    
    func discardView() {
        addTripRouter!.discardView()
    }
    
    func addTripDetail() {
        
    }
}
