//
//  TripViewCell.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import UIKit

class TripViewCell: UITableViewCell {

    @IBOutlet weak var tripName: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    @IBOutlet weak var destinationCity: UILabel!
    
    @IBOutlet weak var shadowView: ShadowedView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shadowView.setDefaultElevation()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
