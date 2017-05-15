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
    
    //MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.loadStudentLocations()
    }
    
    //MARK: Helper Functions
    
    /* network call, UI update
     @params: limit (Number), skip (Number), order (String)
     */
    func loadStudentLocations() {
        
        let parameters: [String: Any] = ["limit": 100]

        PSClient().obtainStudentLocation(parameters: parameters) { (response, error) in
            guard response == nil else {
                let controller = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .actionSheet)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                controller.addAction(okAction)
                self.present(controller, animated: true, completion: nil)
                return
            }
            
            guard let arrayOfStudentLocations = response?["results"] as? [[String: Any]] else {
                print("No 'results' key found in the response")
                return
            }
            
            self.listOfLocations = StudentLocation.studentsLocationFrom(arrayOfStudentLocations as [[String : AnyObject]])
            
            DispatchQueue.main.async {
                for student in self.listOfLocations! {
                    self.loadAnnotations(student: student)
                }
            }
        }
    }
    
    func loadAnnotations(student: StudentLocation) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: student.latitude!, longitude: student.longitude!)
        annotation.title = "\(student.firstName!) \(student.lastName!)"
        annotation.subtitle = "\(student.mediaURL!)"
        self.mapView.addAnnotation(annotation)
    }
    
    //MARK: IBActions
    @IBAction func logouFromUdacity(_ sender: UIBarButtonItem) {
        UDClient().logoutFromUdacity()
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: MKMapViewDelegate

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MapViewController"
        
        if !annotation.isKind(of: MKPointAnnotation.self) {
            return nil
        }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            // Create Annotation
            
            let annotationView = MKAnnotationView(annotation:annotation, reuseIdentifier:identifier)
            annotationView.isEnabled = true
            annotationView.canShowCallout = true
            
            // Here I create the button and add in accessoryView
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView.rightCalloutAccessoryView = btn
            return annotationView
        } else {
            // Reuse Annotationview
            annotationView?.annotation = annotation
            return annotationView
        }
    }
}
