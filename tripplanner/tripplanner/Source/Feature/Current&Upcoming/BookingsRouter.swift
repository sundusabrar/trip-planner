//
//  BookingsWireframe.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import Foundation
import UIKit

class BookingsRouter: NSObject {
    
    var rootWireframe: RootWireFrame?
    
    var bookingViewController: BookingsViewController?
    
    func buildModule(bookingsView: BookingsViewController) {

        let bookingPresenter = BookingsPresenter()
        let bookingInteractor = BookingsInteractor()
        
        bookingPresenter.bookingViewInterface = bookingsView
        bookingsView.presenter = bookingPresenter
        bookingInteractor.output = bookingPresenter
        bookingPresenter.bookingInteractorInput = bookingInteractor
        bookingPresenter.bookingRouter = self
        self.bookingViewController = bookingsView
    }
    
    func presentAddNewTrip() {
        if NetworkManager.sharedInstance.isNetworkConnected {
            let addNewTripRouter = AddTripRouter()
            addNewTripRouter.rootWireFrame = rootWireframe
            addNewTripRouter.presentAddTripView(onView: bookingViewController!)
        }
        else {
            print("no internet available")
            bookingViewController?.presentAlert()
        }
    }
}
