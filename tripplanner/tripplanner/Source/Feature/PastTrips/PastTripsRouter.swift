//
//  PastTripsRouter.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import Foundation
import UIKit

class PastTripRouter: NSObject {
    
    var rootWireFrame: RootWireFrame?
    var presentedView: UIViewController?
    var pastTripsViewController: PastTripsView?
    
    func buildModule(pastTripsView: PastTripsView) {
        
        let pastTripsPresenter = PastTripPresenter()
        let pastTripInteractor = PastTripInteractor()
        
        pastTripsPresenter.pastTripView = pastTripsView
        pastTripsView.presenter = pastTripsPresenter
        pastTripInteractor.output = pastTripsPresenter
        pastTripsPresenter.pastTripInteractorInput = pastTripInteractor
        pastTripsPresenter.pastTripRouter = self
        self.pastTripsViewController = pastTripsView
    }
    
    func presentAddTripView(onView: UIViewController) {
        
    }
    
    func discardView() {
        self.presentedView?.dismiss(animated: true, completion: nil)
    }
}
