//
//  FindLocationViewController.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/20/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import UIKit
import MapKit

class FindLocationViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {

    //MARK: Instantiate Models
    var myStudentLocation: StudentLocation? = OMData.sharedInstance().myStudentLocation
    
    //Properties
    var latitude: Double?
    var longitude: Double?
    
    //MARK: IBOutlets
    @IBOutlet weak var udacityLogoImageView: UIImageView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaURLTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    //MARK: App Lify Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardOffTap()
    }
    
    deinit {
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: UI
    func setupUI() {
        self.mapView.delegate = self
        self.mapView.isHidden = true
        self.locationTextField.delegate = self
        self.mediaURLTextField.delegate = self
        self.submitButton.isHidden = true
    }
    
    //MARK: IBActions
    @IBAction func findLocationButtonPressed(_ sender: UIButton) {
        
        //TODO: Check rubric for this logic
        if (self.locationTextField.text?.isEmpty)! {
            displayAlertWithError(message: "Missing location")
        }
    
        self.view.endEditing(true)

        //Building profile to submit
        self.myStudentLocation?.mapString = self.locationTextField.text!
        
        //Search for location
        self.showMapWith(location: self.locationTextField.text!)
        
    }

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
 
    @IBAction func submitLocationButtonPressed(_ sender: UIButton) {
        submitLocation()
    }
    
    func submitLocation() {
        let information: [String: Any] = [
            ParseHTTPBodyKeys.UniqueKey : self.myStudentLocation?.uniqueKey,
            ParseHTTPBodyKeys.FirstName : self.myStudentLocation?.firstName,
            ParseHTTPBodyKeys.LastName  : self.myStudentLocation?.lastName,
            ParseHTTPBodyKeys.MapString : self.locationTextField.text!,
            ParseHTTPBodyKeys.MediaUrl  : self.mediaURLTextField.text!,
            ParseHTTPBodyKeys.Latitude  : self.myStudentLocation?.latitude,
            ParseHTTPBodyKeys.Longitude : self.myStudentLocation?.longitude
        ]
        
        if UserDefaults.standard.bool(forKey: kNewLocation) {
            //it will only run when new user
            self.createStudentLocation(params: information)
        } else {
            self.updateStudentLocation(params: information)
        }
    }
    
    func updateStudentLocation(params: [String: Any]) {
        PSClient().updateStudentLocation(objectId: (self.myStudentLocation?.objectId)!, httpBody: params) { (response, success) in
            DispatchQueue.main.async {
                if !success {
                    self.displayAlertWithError(message: "Error Updating Your Location")
                } else {
                    self.myStudentLocation?.updatedAt = response?["updatedAt"] as? String
                    NotificationCenter.default.post(name: Notification.Name(kRefreshLocation), object: self)
                    UserDefaults.standard.set(false, forKey: kNewLocation)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func createStudentLocation(params: [String: Any]) {
        //First time the user opens the app
        PSClient().createStudentLocation(httpBody: params) { (response, success) in
            DispatchQueue.main.async {
                if !success {
                    self.displayAlertWithError(message: "Error Posting Your Location")
                } else {
                    self.myStudentLocation?.objectId = response?["objectId"] as? String
                    self.myStudentLocation?.createdAt = response?["createdAt"] as? String
                    NotificationCenter.default.post(name: Notification.Name(kRefreshLocation), object: self)
                    UserDefaults.standard.set(false, forKey: kNewLocation)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    //MARK: Functions
    func showMapWith(location: String) {
        let geoCoder = CLGeocoder()
        let indicator = startActivityIndicatorAnimation()
        geoCoder.geocodeAddressString(location) { (placeMarkArray, error) in
            if error == nil {
                let myCoordinates = placeMarkArray?.first?.location?.coordinate
                let spanCoordinates = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                let region = MKCoordinateRegion(center: myCoordinates!, span: spanCoordinates)
                
                //Building profile to submit
                self.myStudentLocation?.longitude = myCoordinates?.longitude
                self.myStudentLocation?.latitude = myCoordinates?.latitude
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = myCoordinates!
                annotation.title = "\(self.myStudentLocation?.firstName ?? "unknow") \(self.myStudentLocation?.lastName ?? "unknow")"
                annotation.subtitle = "\(self.mediaURLTextField.text ?? "")"
                DispatchQueue.main.async {
                    self.submitButton.isHidden = false
                    self.mapView.isHidden = false
                    self.mapView.setRegion(region, animated: true)
                    self.mapView.addAnnotation(annotation)
                    self.stopActivityIndicatorAnimation(indicator: indicator)
                }
            } else {
                DispatchQueue.main.async {
                    self.displayAlertWithError(message: "Could Not find location")
                }
            }
        }
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.isEmpty)! {
            displayAlertWithError(message: "Please fill the fields")
        }
        
        if textField.restorationIdentifier == "" {
            submitLocation()
        }
        
        return true
    }
}
