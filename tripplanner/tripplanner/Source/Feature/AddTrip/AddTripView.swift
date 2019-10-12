//
//  AddTripViewController.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol AddTripViewInterface {
    func presentSuccessAlert()
    func didAddTrip()
}

struct TripViMo {
    var source = ""
    var destination = ""
    var departureTime = Date()
    var arrivalTime = Date()
}

class AddTripView: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var sourceTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    
    @IBOutlet weak var departureDateTextField: UITextField!
    @IBOutlet weak var arrivalTextField: UITextField!
    
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveTripButton: UIButton!
    
    var activeField: UITextField?
    
    @IBOutlet weak var mapView: MKMapView!
   
    var tripViMo = TripViMo()
    
    var eventHandler: AddTripModuleInterface?
    
    lazy var datePicker: UIDatePicker = {
        var picker = UIDatePicker()
        picker.datePickerMode = UIDatePicker.Mode.dateAndTime
        picker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        return picker
    }()
    
    lazy var toolBar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem:.done, target: nil, action: #selector(dissmissPicker))
        toolbar.setItems([done], animated: false)
        return toolbar
    }()
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm"
        formatter.locale = Locale.current
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mapView.delegate = self
        
        // 2. Locations to be shown on mapview
        let sourceLocation = CLLocationCoordinate2D(latitude: 40.759011, longitude: -73.984472)
        let destinationLocation = CLLocationCoordinate2D(latitude: 40.748441, longitude: -73.985564)
        
        // 3. Placemarks
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        // 4. Routing Information
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // 5. Annotations to be dropped on map
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Times Square"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Empire State Building"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        // 6.
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        // 7.
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // 8.
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    @objc func handleDatePicker() {
        if let a = activeField {
            a.text = dateFormatter.string(from: datePicker.date)
            
            if a == departureDateTextField {
                tripViMo.departureTime = datePicker.date
            }
            else {
                tripViMo.arrivalTime = datePicker.date
            }
        }
    }
    
    @objc func dissmissPicker() {
        activeField?.resignFirstResponder()
    }

    @IBAction func saveTripPressed(_ sender: Any) {
        eventHandler?.addTripDetail(vimo: tripViMo)
    }
    
    @IBAction func discardTripDetails(_ sender: Any) {
        eventHandler!.discardView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sourceTextField.resignFirstResponder()
        destinationTextField.resignFirstResponder()
        departureDateTextField.resignFirstResponder()
        arrivalTextField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
        
        if textField == departureDateTextField {
            datePicker.date = tripViMo.departureTime
            departureDateTextField.inputView = datePicker
            departureDateTextField.inputAccessoryView = toolBar
            datePicker.minimumDate = Date()
        }
        else if textField == arrivalTextField {
            datePicker.date = tripViMo.arrivalTime
            arrivalTextField.inputView = datePicker
            arrivalTextField.inputAccessoryView = toolBar
            datePicker.minimumDate = tripViMo.departureTime
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.text != ""{
            if textField == sourceTextField {
                tripViMo.source = textField.text!
            }
            else if textField == destinationTextField {
                tripViMo.destination = textField.text!
            }
        }
    }
}

extension AddTripView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
}

//extension AddTripView: CLLocationManager {
//    
//}

extension AddTripView: AddTripViewInterface {
    func presentSuccessAlert() {
        //show PKHud
    }
    
    func didAddTrip() {
        eventHandler!.discardView()
    }
}
