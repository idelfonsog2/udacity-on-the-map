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
    var udacityAuthentication = UdacitySessionClass.sharedInstance()
    
    //MARK: IBOutlets
    @IBOutlet weak var udacityLogoImageView: UIImageView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaURLTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: App Lify Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 109, green: 199, blue: 254, alpha: 1.0)
        self.mapView.delegate = self
        self.mapView.isHidden = true
        self.loadUdacityUserData()
    }

    //MARK: IBActions
    @IBAction func findLocationButtonPressed(_ sender: UIButton) {
        
        //TODO: Check rubric for this logic
        if (self.locationTextField.text?.isEmpty)! {
            displayError(message: "Missing location")
        }
    
        let address = self.locationTextField.text!
        self.showMapWith(location: address)
    }
    
    //MARK: load Data
    func loadUdacityUserData() {
        
        //Pass completion handler in case the Object construction fails
        let params = [UdacityHTTPBodyKeys.UdacityKey: udacityAuthentication.uniqueKey]
        
        UDClient().getUserPublicData(params: params) { (response, success) in
            if !success {
                completionHandler(nil, false)
            }
            
            guard let userDictionary = response?["user"] as? [String: Any] else {
                completionHandler(nil, false)
                return
            }
            
            //MARK: Init user with JSON
            User.userData = User(dictionary: userDictionary)
            completionHandler(nil, true)
        }

    
    func showMapWith(location: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(location) { (placeMarkArray, error) in
            if error == nil {
                let myCoordinates = placeMarkArray?.first?.location?.coordinate
                let spanCoordinates = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                let region = MKCoordinateRegion(center: myCoordinates!, span: spanCoordinates)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = myCoordinates!
                annotation.title = "\(self.profile?.firstName) \(self.profile?.lastName)"
                annotation.subtitle = "\(self.mediaURLTextField.text ?? "")"
                DispatchQueue.main.async {
                    self.mapView.isHidden = false
                    self.mapView.setRegion(region, animated: true)
                    //TODO: place marker
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
    

    /*
     if let location = self.locationTextField.text {
     let request = MKLocalSearchRequest()
     request.naturalLanguageQuery = location
     
     let localSearch = MKLocalSearch(request: request)
     self.mapView.isHidden = true
     localSearch.start(completionHandler: { (response, error) in
     if error = nil {
     let coordinates = response?.mapItems[0].placemark.coordinate
     let spanCoordinates = MKCoordinateSpan(latitudeDelta: 200, longitudeDelta: 200)
     let region = MKCoordinateRegion(center: coordinates!, span: spanCoordinates)
     DispatchQueue.main.async {
     self.mapView.setRegion(region, animated: true)
     }
     } else {
     print("not able to find location \(String(describing: error))")
     }
     })
     }
     */

}
