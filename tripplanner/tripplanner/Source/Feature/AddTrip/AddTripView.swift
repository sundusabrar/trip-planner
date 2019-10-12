//
//  AddTripViewController.swift
//  tripplanner
//
//  Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import UIKit

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

extension AddTripView: AddTripViewInterface {
    func presentSuccessAlert() {
        //show PKHud
    }
    
    func didAddTrip() {
        eventHandler!.discardView()
    }
}
