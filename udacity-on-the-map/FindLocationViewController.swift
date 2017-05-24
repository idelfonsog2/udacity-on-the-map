//
//  FindLocationViewController.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/20/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import UIKit
import MapKit


class FindLocationViewController: UIViewController, MKMapViewDelegate {

    //MARK: Instantiate Models
    let data = OMData.sharedInstance()
    var myLocation: StudentLocation?
    
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
        self.submitButton.isHidden = true
        self.initMyProfile()
    }

    func initMyProfile() {
        let params: [String: Any] = ["where":
            "{\"\(ParseHTTPBodyKeys.UniqueKey)\:\"\(data.session!.uniqueKey!)\"}"
            ]
        //TODO: Get Student Information
        PSClient().obtainStudentLocation(parameters: params) { (response, sucess) in
            if !sucess {
                print("Error finding the current udacity user in the Parse API")
            } else {
                self.myLocation = StudentLocation(objectId: nil, firstName: self.data.user?.firstName, lastName: self.data.user?.lastName, mapString: nil, mediaURL: nil, uniqueKey: self.data.session?.uniqueKey, latitude: nil, longitude: nil, updatedAt: nil, createdAt: nil)
            }
        }
    }
    
    //MARK: IBActions
    @IBAction func findLocationButtonPressed(_ sender: UIButton) {

        //TODO: Check rubric for this logic
        if (self.locationTextField.text?.isEmpty)! {
            displayError(message: "Missing location")
        }
    
        //Building profile to submit
        self.myLocation?.mapString = self.locationTextField.text!
        
        //Search for location
        self.showMapWith(location: self.locationTextField.text!)
    }

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
 
    @IBAction func submitLocationButtonPressed(_ sender: UIButton) {
        let information: [String: Any] = [
            ParseHTTPBodyKeys.UniqueKey : self.myLocation?.uniqueKey,
            ParseHTTPBodyKeys.FirstName : self.myLocation?.firstName,
            ParseHTTPBodyKeys.LastName  : self.myLocation?.lastName,
            ParseHTTPBodyKeys.MapString : self.locationTextField.text!,
            ParseHTTPBodyKeys.MediaUrl  : self.mediaURLTextField.text!,
            ParseHTTPBodyKeys.Latitude  : self.myLocation?.latitude,
            ParseHTTPBodyKeys.Longitude : self.myLocation?.longitude
        ]
        
        if UserDefaults.standard.bool(forKey: kNewLocation) {
            //it will only run when new user
            self.createStudentLocation(params: information)
        } else {
            self.updateStudentLocation(params: information)
        }
    }
    
    func updateStudentLocation(params: [String: Any]) {
        PSClient().updateStudentLocation(objectId: (self.myLocation?.objectId)!, httpBody: params) { (response, success) in
            DispatchQueue.main.async {
                if !success {
                    self.displayError(message: "Error Your Location")
                } else {
                    self.myLocation?.updatedAt = response?["updatedAt"] as? String
                    NotificationCenter.default.post(name: Notification.Name(kRefreshLocation), object: self)
                    UserDefaults.standard.set(false, forKey: kNewLocation)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func createStudentLocation(params: [String: Any]) {
        //TODO: First time the user opens the app
        PSClient().createStudentLocation(httpBody: params) { (response, success) in
            DispatchQueue.main.async {
                if !success {
                    self.displayError(message: "Error Your Location")
                } else {
                    self.myLocation?.objectId = response?["objectId"] as? String
                    self.myLocation?.createdAt = response?["createdAt"] as? String
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
                self.myLocation?.longitude = myCoordinates?.longitude
                self.myLocation?.latitude = myCoordinates?.latitude
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = myCoordinates!
                annotation.title = "\(self.data.user?.firstName ?? "unknow") \(self.data.user?.lastName ?? "unknow")"
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

}
