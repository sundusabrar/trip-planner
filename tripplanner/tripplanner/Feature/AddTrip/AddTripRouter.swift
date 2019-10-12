//
//  AddTripRouter.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import Foundation
import UIKit

class AddTripRouter: NSObject {
    
    var rootWireFrame: RootWireFrame?

    var presentedView: UIViewController?
    
    func presentAddTripView(onView: UIViewController) {
        let addTripView = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddTripView") as! AddTripView
        let addTripPresenter = AddTripPresenter()
        let addTripInteractor = AddTripInteractor()
        addTripView.eventHandler = addTripPresenter
        addTripPresenter.addTripView = addTripView
        addTripPresenter.addTripRouter = self
        addTripPresenter.addTripInteractorInput = addTripInteractor
        
        self.presentedView = addTripView
        onView.present(addTripView, animated: true, completion: nil)
    }
    
    func discardView() {
        self.presentedView?.dismiss(animated: true, completion: nil)
    }
}
