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
        self.view.backgroundColor = UIColor(red: 109, green: 199, blue: 254, alpha: 1.0)
        self.udacityLogoImageView.tintColor = UIColor.red
        self.mapView.delegate = self
        self.mapView.isHidden = true
        self.locationTextField.delegate = self
        self.mediaURLTextField.delegate = self
        self.submitButton.isHidden = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToNotifications()
    }
    
    //MARK: IBActions
    @IBAction func findLocationButtonPressed(_ sender: UIButton) {
        
        //TODO: Check rubric for this logic
        if (self.locationTextField.text?.isEmpty)! {
            displayError(message: "Missing location")
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
                    self.displayError(message: "Error Updating Your Location")
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
                    self.displayError(message: "Error Posting Your Location")
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
                }
            } else {
                DispatchQueue.main.async {
                    self.displayError(message: "Could Not find location")
                }
            }
        }
    }
    
    func displayError(message: String) {
        let controller = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)
    }
    
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        self.view.frame.origin.y = 30 * -1
    }
    
    func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardFrame.cgRectValue.height
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }

}
