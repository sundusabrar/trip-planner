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
import GooglePlaces

import PKHUD
import MaterialComponents.MaterialButtons

protocol AddTripViewInterface {
    func presentSuccessAlert()
    func didAddTrip()
}

class AddTripView: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var sourceTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var departureDateTextField: UITextField!
    @IBOutlet weak var arrivalTextField: UITextField!
    @IBOutlet weak var saveTripButton: RaisedButton!
    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var sourceLocationButton: UIButton!
    @IBOutlet weak var destLocationButton: UIButton!
    
    @IBOutlet weak var backgroundView: ShadowedView!
    
    
    var activeField: UITextField?
    var eventHandler: AddTripModuleInterface?
    
    var tripViMo = TripViMo() {
        didSet {
            if sourceTextField.text != "" && destinationTextField.text != "" {
                drawPolyLine()
            }
        }
    }

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
        
        let dLocation = CLLocation(latitude: 49.489989, longitude: 8.473512)
        let dRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: dLocation.coordinate.latitude,
                                                                        longitude: dLocation.coordinate.longitude),
                                         span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.delegate = self
        mapView.setRegion(dRegion, animated: true)
        backgroundView.setDefaultElevation()
        saveTripButton.setDefaultElevation()
    }
    
    @objc func handleDatePicker() {
        if let a = activeField {
            a.text = dateFormatter.string(from: datePicker.date)
            
            if a == departureDateTextField {
                tripViMo.source.tripTime = datePicker.date
            }
            else {
                tripViMo.dest.tripTime = datePicker.date
            }
        }
    }
    
    @IBAction func getLocation(_ sender: Any) {
        
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
    
    // MARK: UIView Delegate
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sourceTextField.resignFirstResponder()
        destinationTextField.resignFirstResponder()
        departureDateTextField.resignFirstResponder()
        arrivalTextField.resignFirstResponder()
    }
    
    //MARK: TextField Delagtes
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
        
        if textField == departureDateTextField {
            datePicker.date = tripViMo.source.tripTime
            departureDateTextField.inputView = datePicker
            departureDateTextField.inputAccessoryView = toolBar
            datePicker.minimumDate = Date()
        }
        else if textField == arrivalTextField {
            datePicker.date = tripViMo.dest.tripTime
            arrivalTextField.inputView = datePicker
            arrivalTextField.inputAccessoryView = toolBar
            datePicker.minimumDate = tripViMo.source.tripTime
        }
        else if textField == tripNameTextField {
            //do nothing
        }
        else {
            launchAutocomplete()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.text != ""{
            if textField == sourceTextField {
                tripViMo.source.address = textField.text!
            }
            else if textField == destinationTextField {
                tripViMo.dest.address = textField.text!
            }
            else if textField == tripNameTextField {
                tripViMo.tripName = textField.text!
            }
        }
    }
    
    func launchAutocomplete() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
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
        present(autocompleteController, animated: true, completion: nil)
    }
}

//MARK: MKMapView Delegate

extension AddTripView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    func drawPolyLine() {
        
        // 1. Placemarks
        let sourcePlacemark = MKPlacemark(coordinate: tripViMo.source.location, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: tripViMo.dest.location, addressDictionary: nil)
        
        // 2. Routing Information
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // 3. Annotations to be dropped on map
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = tripViMo.source.placeName
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = tripViMo.dest.placeName
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        // 4.
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        // 5.
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // 6.
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
}

//MARK: ViewInterface Implementation

extension AddTripView: AddTripViewInterface {
    func presentSuccessAlert() {
        //show PKHud
        HUD.show(HUDContentType.success)
    }
    
    func didAddTrip() {
        eventHandler!.discardView()
    }
}

//MARK: GMSAutoComplete Delegate
extension AddTripView: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {

        var keys = [String]()
        place.addressComponents?.forEach{keys.append($0.type)}
        
        var values = [String]()
        place.addressComponents?.forEach({ (component) in
            keys.forEach{ component.type == $0 ? values.append(component.name): nil}
        })
        
        let cityName = place.addressComponents?.first(where: { $0.type == kGMSPlaceTypeLocality })?.name
        let placeCoordinates = place.coordinate
        let placeName = place.name!
        let address = place.formattedAddress!
        
        if activeField == sourceTextField {
            tripViMo.source.cityName = cityName!
            tripViMo.source.address = address
            tripViMo.source.location = placeCoordinates
            tripViMo.source.placeName = placeName
            
        }
        else {
            tripViMo.dest.cityName = cityName!
            tripViMo.dest.address = address
            tripViMo.dest.location = placeCoordinates
            tripViMo.dest.placeName = placeName
        }
        
        activeField?.text = placeName
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
