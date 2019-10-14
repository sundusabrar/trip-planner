//
//  AppDelegate.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import UIKit
import SwiftDate
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var rootWireFrame = RootWireFrame()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        configureAppDependencies()
        GMSPlacesClient.provideAPIKey("")
        NetworkManager.sharedInstance.startUp()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}


//MARK: Custom methods

extension AppDelegate {
    
    func configureAppDependencies() {
        
        // Configure all initial/root view controllers 
        let tabBar = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController

        // Initialise Booking screen VIPER elements
        let bookingsNavView = tabBar.viewControllers![0] as! UINavigationController
        let bookingsView = bookingsNavView.viewControllers[0] as! BookingsViewController
        let bookingRouter = BookingsRouter()
        bookingRouter.buildModule(bookingsView: bookingsView)

        // Initialise Past trips screen VIPER elements
        let pastTripsNavView = tabBar.viewControllers![1] as! UINavigationController
        let pastTripsView = pastTripsNavView.viewControllers[0] as! PastTripsView
        let pastTripRouter = PastTripRouter()
        pastTripRouter.buildModule(pastTripsView: pastTripsView)

        self.window?.rootViewController = tabBar
        self.window?.makeKeyAndVisible()
        
    }
    
    func generateDummyData() {
        //create past trips
        var tripArr = [Trip]()
        for index in (1..<8).reversed() {
            let d1 = Date() - (index).days
            let d2 = Date() - (index-1).days
            
            let source = TripLocationViMo(cityName: "SCityName", placeName: "Place", address: "", lat: 0.0, lon: 0.0, location: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), tripTime: d1)
            let dest = TripLocationViMo(cityName: "DCityName", placeName: "Place", address: "", lat: 0.0, lon: 0.0, location: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), tripTime: d2)
            
            let pastTrip1 = TripViMo(tripName: "TripName", source: source, dest: dest, creationDate: Date())
            
            let pt1 = Trip(value: pastTrip1)
            
            tripArr.append(pt1)
        }
        
        //create current trips
        for index in (1..<3) {
            let d1 = Date()
            let d2 = Date() + (index).days
            let source = TripLocationViMo(cityName: "SCityName", placeName: "Place", address: "", lat: 0.0, lon: 0.0, location: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), tripTime: d1)
            let dest = TripLocationViMo(cityName: "DCityName",placeName: "Place", address: "", lat: 0.0, lon: 0.0, location: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), tripTime: d2)
            
            let pastTrip1 = TripViMo(tripName: "TripName", source: source, dest: dest, creationDate: Date())
            let pt1 = Trip(value: pastTrip1)
            
            tripArr.append(pt1)
        }
        
        //create upcoming trips
        for index in (1..<6) {
            let d1 = Date() + (index).days
            let d2 = Date() + (index+1).days
            let source = TripLocationViMo(cityName: "SCityName",placeName: "Place", address: "", lat: 0.0, lon: 0.0, location: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), tripTime: d1)
            let dest = TripLocationViMo(cityName: "DCityName",placeName: "Place", address: "", lat: 0.0, lon: 0.0, location: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), tripTime: d2)
            
            let pastTrip1 = TripViMo(tripName: "TripName", source: source, dest: dest, creationDate: Date())
            let pt1 = Trip(value: pastTrip1)
            
            tripArr.append(pt1)
        }
        DataManager.sharedInstance.addTrip(objects: tripArr)
    }
}

