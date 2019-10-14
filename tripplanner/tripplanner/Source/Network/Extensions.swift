//
//  Extensions.swift
//  tripplanner
//
//  Created by Sundus Abrar on 13.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import SwiftIcons

extension UINavigationController {
    override open func viewDidLayoutSubviews() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = UIColor(red: 38/255.0, green: 60/255.0, blue: 121/255.0, alpha: 1)
        self.navigationBar.barTintColor = UIColor.white
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
}

extension UITabBarController {
    override open func viewDidLayoutSubviews() {
        let first = self.tabBar.items![0]
        first.image = UIImage.init(icon: .fontAwesomeSolid(.suitcase), size: CGSize(width: 35, height: 35))
        first.selectedImage = UIImage.init(icon: .fontAwesomeSolid(.suitcase), size: CGSize(width: 35, height: 35))
        
        let second = self.tabBar.items![1]
        second.image = UIImage.init(icon: .fontAwesomeSolid(.history), size: CGSize(width: 35, height: 35))
        second.selectedImage = UIImage.init(icon: .fontAwesomeSolid(.history), size: CGSize(width: 35, height: 35))
    }
}

