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

protocol AddTripViewInterface {
    func presentSuccessAlert()
    func didAddTrip()
}

struct TripViMo {
    var tripName = ""
    var source = TripLocationViMo()
    var dest = TripLocationViMo()
    var creationDate = Date()
}

struct TripLocationViMo {
    var cityName = ""
    var placeName = ""
    var address = ""
    var lat = 0.0
    var lon = 0.0
    var location = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var tripTime = Date()
    
    static func createVimo(tripLoc: TripLocation) -> TripLocationViMo {
        return self.init(cityName: tripLoc.cityName,
                         placeName: "",
                         address: tripLoc.address,
                         lat: tripLoc.lat,
                         lon: tripLoc.lon,
                         location: CLLocationCoordinate2D(latitude:tripLoc.lat, longitude: tripLoc.lon),
                        tripTime: tripLoc.tripTime)
    }
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
    
    var sourceLocation: CLLocationCoordinate2D?
    var destinationLocation: CLLocationCoordinate2D?
   
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
        sourceLocation = CLLocationCoordinate2D(latitude: 40.759011, longitude: -73.984472)
        destinationLocation = CLLocationCoordinate2D(latitude: 40.748441, longitude: -73.985564)
        drawPolyLine()
    }
    
    func drawPolyLine() {
        
        // 3. Placemarks
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation!, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation!, addressDictionary: nil)
        
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
                tripViMo.source.tripTime = datePicker.date
            }
            else {
                tripViMo.dest.tripTime = datePicker.date
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
        else {
            launchAutoFillVC()
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
        }
    }
    
    func launchAutoFillVC() {
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

extension AddTripView: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(place.name)")
        print("Coordinate: \(place.coordinate)")
        print("Place attributions: \(place.attributions)")
        print("Formatted Address: \(place.formattedAddress)")
        print("address component: \(place.addressComponents)")
        
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
