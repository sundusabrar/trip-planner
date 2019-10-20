//
//  tripplannerTests.swift
//  tripplannerTests
//
//  Created by Sundus Abrar on 14.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import XCTest

@testable import tripplanner

//import ObjectMapper
//import CoreLocation
//import RealmSwift
//import Alamofire
//import AlamofireObjectMapper
//import HTTPStatusCodes

var datamgr: DataManager!

let service: Service = {
    let s = Service.instance
    s.logAllResponseStrings = true
    return s
}()

//let coord = CLLocationCoordinate2DMake(48.235828, 16.356447)


class tripplannerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
//        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
//        datamgr = DataManager.sharedInstance
//        
        //fetchOnlineTrips()
        
        testFirstScreenTitle()
    }
    
    func testFirstScreenTitle() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let bookings = storyboard.instantiateViewController(withIdentifier: "BookingsView") as! BookingsViewController
        //instantiateInitialViewController() as! BookingsViewController
        let _ = bookings.view
        XCTAssertEqual("Current Trips", bookings.navigationItem.title)
    }
    
    func testSecondScreenTitle() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pasttrips = storyboard.instantiateViewController(withIdentifier: "PastTripsView") as! PastTripsView
        let _ = pasttrips.view
        XCTAssertEqual("Completed Trips", pasttrips.navigationItem.title)
    }
    
    
//    func fetchOnlineTrips() {
//        let exp = expectation(description: "fetchAllTrips")
//
//        service.fetchAllTrips(completion: { resp in
//            XCTAssertNil(resp.result.error)
//
//            exp.fulfill()
//        })
//        waitForExpectations(timeout: 20, handler: nil)
//    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
