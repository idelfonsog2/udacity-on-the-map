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
    var udacityUser = UdacityUser.sharedInstance
    var udacitySession = UdacitySession.sharedInstance
    
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
                annotation.title = "\(self.udacityUser.firstName ?? "unknow") \(self.udacityUser.lastName ?? "unknow")"
                annotation.subtitle = "\(self.mediaURLTextField.text ?? "")"
                DispatchQueue.main.async {
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
