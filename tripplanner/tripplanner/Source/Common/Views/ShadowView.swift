//
//  ShadowView.swift
//  tripplanner
//
//  Created by Sundus Abrar on 13.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import Foundation
import MaterialComponents

class ShadowedView: UIView {
    
    override class var layerClass: AnyClass {
        return MDCShadowLayer.self
    }
    
    var shadowLayer: MDCShadowLayer {
        return self.layer as! MDCShadowLayer
    }
    
    func setDefaultElevation() {
        self.shadowLayer.elevation = ShadowElevation.cardResting
    }
}

class RaisedButton: MDCButton {
    var shadowLayer: MDCShadowLayer {
        return self.layer as! MDCShadowLayer
    }
    
    func setDefaultElevation() {
        self.shadowLayer.elevation = ShadowElevation.cardPickedUp
        self.setElevation(ShadowElevation(rawValue: 6), for: .normal)
        self.setElevation(ShadowElevation(rawValue: 12), for: .highlighted)
    }
}


