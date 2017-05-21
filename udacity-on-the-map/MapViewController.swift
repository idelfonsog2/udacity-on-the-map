//
//  MapViewController.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/12/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    //MARK: Properties
    var sessionId: String?
    var listOfLocations: [StudentLocation]?
    var annotations = [MKPointAnnotation]()
    
    //MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.mapView.removeAnnotations(self.annotations)
        self.loadStudentLocations()
    }
    
    //MARK: Helper Functions
    
    /* network call, UI update
     @params: limit (Number), skip (Number), order (String)
     */
    func loadStudentLocations() {
        
        let parameters: [String: Any] = ["limit": 100]

        PSClient().obtainStudentLocation(parameters: parameters) { (response, success) in
            if !success {
                DispatchQueue.main.async {
                    self.displayError(string: "Download Failed")
                }
            }
            
            guard let arrayOfStudentLocations = response?["results"] as? [[String: Any]] else {
                print("No 'results' key found in the response")
                return
            }
            
            
            self.listOfLocations = StudentLocation.studentsLocationFrom(arrayOfStudentLocations as [[String : AnyObject]])
            
            for student in self.listOfLocations! {
                
                self.loadAnnotations(student: student)
            }
            
            //Update the UI
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.annotations)
            }
        }
    }
    
    func loadAnnotations(student: StudentLocation) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: student.latitude!, longitude: student.longitude!)
        annotation.title = "\(student.firstName!) \(student.lastName!)"
        annotation.subtitle = "\(student.mediaURL!)"
        annotations.append(annotation)
    }
    
    func displayError(string: String) {
        let controller = UIAlertController(title: "Error", message: string, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)
    }
    
    
    //MARK: IBActions
    @IBAction func logouFromUdacity(_ sender: UIBarButtonItem) {
        UDClient().logoutFromUdacity()
        self.dismiss(animated: true, completion: nil)
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
