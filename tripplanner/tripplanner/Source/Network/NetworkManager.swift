//
//  NetworkManager.swift
//  tripplanner
//
//  Created by Sundus Abrar on 13.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import Foundation
import SystemConfiguration
import Alamofire

class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
    var isNetworkConnected = false {
        didSet {
            
        }
    }
    var syncTimer = Timer()
    
    //MARK: Network connectivity
    func listenForReachability() {
        self.reachabilityManager?.listener = { status in
            
            print("Network Status Changed: \(status)")
            
            switch status {
                
            case .notReachable:
                print("The network is not reachable")
                self.isNetworkConnected = false
                
            case .unknown :
                print("It is unknown whether the network is reachable")
                self.isNetworkConnected = false
                
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
                self.isNetworkConnected = true
                
            case .reachable(.wwan):
                print("The network is reachable over the WWAN connection")
                self.isNetworkConnected = true
            }
        }
        self.reachabilityManager?.startListening()
    }

    //MARK: App related startup
    
    func startUp() {
        //initialise sync manager
        syncTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(performSyncInBG), userInfo: nil, repeats: true)
    }
    
    func fetchAllTrips(completion: @escaping () -> Void) {
        if isNetworkConnected {
            Service.instance.fetchAllTrips(completion: { resp in
                guard let trips = resp.value else {
                    print("No trips returned")
                    return
                }
                DataManager.sharedInstance.addTrip(objects: trips.allTrips)
                completion()
            })
        }
        else {
            completion()
        }
    }
    
    @objc func performSyncInBG() {
        
        DispatchQueue.global(qos: .background).async {
            print(" ***** SYNC Started ***** ")
            self.syncDB()
        }
    }
    
    func syncDB() {
        if isNetworkConnected {
            
        }
    }
}
