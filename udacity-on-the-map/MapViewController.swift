//
//  MapViewController.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/12/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import UIKit
import MapKit
import NVActivityIndicatorView

class MapViewController: UIViewController, MKMapViewDelegate, UITabBarDelegate, NVActivityIndicatorViewable {

    //TODO: Properties
    var annotations = [MKPointAnnotation]()
    var data = OMData.sharedInstance()
    
    //MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(loadStudentLocationsData), name: Notification.Name("refreshLocations"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addLocationButtonPressed(_:)), name: Notification.Name("updateLocation"), object: nil)
        self.loadStudentLocationsData()
    }
    
    //MARK: Helper Functions
    func loadStudentLocationsOnMap() {
        //TODO: add delays fo UI
        self.startAnimating(self.view.frame.size, message: "hheel", messageFont: nil, type: NVActivityIndicatorType.ballBeat, color: UIColor.black, padding: nil, displayTimeThreshold: 5000, minimumDisplayTime: 2600, backgroundColor: UIColor(red: 255, green: 255, blue: 255, alpha: 0.5), textColor: nil)
        
        self.mapView.removeAnnotations(self.annotations)
        self.annotations.removeAll()
        
        if data.studentLocations.isEmpty {
            displayError(string: "Unable to download data")
            return
        }
        
        for student in self.data.studentLocations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: student.latitude!, longitude: student.longitude!)
            annotation.title = "\(student.firstName!) \(student.lastName!)"
            annotation.subtitle = "\(student.mediaURL!)"
            self.annotations.append(annotation)
        }
        
        stopAnimating()
        self.mapView.addAnnotations(self.annotations)
        
    }
    
    func loadStudentLocationsData() {
        //Remove for refresh purposes
        data.studentLocations.removeAll()
        
        //Obtain 100 student locations
        let parameters: [String: Any] = ["limit": 100]
        PSClient().obtainStudentLocation(parameters: parameters) { (response, success) in
            if !success {
                DispatchQueue.main.async {
                    self.displayError(string: "Unable To download Data")
                }
            } else {
                //FIX: Instantiating singleton??
                self.data.studentLocations = StudentLocation.locationsFromResults(response!)
            }
        }
    }
    
    func displayError(string: String) {
        let controller = UIAlertController(title: "Error", message: string, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)
    }
    
    
    //MARK: IBActions
    
    @IBAction func addLocationButtonPressed(_ sender: UIBarButtonItem) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "FindLocationViewController") as! FindLocationViewController
        //TODO: 
        self.present(controller, animated: true, completion: nil)
    }
    
    //MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
    
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // Use the subtitle with URL(..) to openSafari
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
}
