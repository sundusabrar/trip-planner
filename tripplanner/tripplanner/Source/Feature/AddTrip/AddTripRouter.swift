//
//  AddTripRouter.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces

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
        addTripInteractor.output = addTripPresenter
        
        self.presentedView = addTripView
        onView.present(addTripView, animated: true, completion: nil)
    }
    
    func discardView() {
        self.presentedView?.dismiss(animated: true, completion: nil)
    }
    
    func launchAutocomplete() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = presentedView as! GMSAutocompleteViewControllerDelegate
        
        // Specify the place data types to return.
        let fields = GMSPlaceField(rawValue:
            UInt(GMSPlaceField.name.rawValue) |
                UInt(GMSPlaceField.addressComponents.rawValue) |
                UInt(GMSPlaceField.placeID.rawValue) |
                UInt(GMSPlaceField.formattedAddress.rawValue) |
                UInt(GMSPlaceField.photos.rawValue) |
                UInt(GMSPlaceField.coordinate.rawValue))!
        
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        presentedView?.present(autocompleteController, animated: true, completion: nil)
    }
}
