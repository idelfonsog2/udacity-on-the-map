//
//  MapViewController.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/12/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UITabBarDelegate {

    //TODO: Properties
    var annotations = [MKPointAnnotation]()
    var data = OMData.sharedInstance()
    
    //MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        subscribeToNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Remove for refresh purposes
        data.studentLocations.removeAll()
        
        self.loadMyParseStudentLocationData()
        
        //The map will show in the exec of the following func
        self.loadStudentLocationsData()
    }
    
    //MARK: Helper Functions
    func loadStudentLocationsOnMap() {
        
        self.mapView.removeAnnotations(self.annotations)
        self.annotations.removeAll()
        
        if data.studentLocations.isEmpty {
            displayError(string: "Unable to download data")
            return
        }
        

        //TODO: Another user might have not posted their location or media url
        for student in self.data.studentLocations {
            if student.latitude != nil, student.longitude != nil {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: student.latitude!, longitude: student.longitude!)
                annotation.title = "\(student.firstName!) \(student.lastName!)"
                annotation.subtitle = "\(student.mediaURL!)"
                self.annotations.append(annotation)
            }
        }
        
        self.mapView.addAnnotations(self.annotations)
    }
    
    func loadMyParseStudentLocationData() {
        //Init myStudentLocation Instance
        let params: [String: Any] = ["order":"-createdAt","where": "{\"\(ParseHTTPBodyKeys.UniqueKey)\":\"\(data.session!.uniqueKey!)\"}"]
        PSClient().obtainStudentLocation(parameters: params) { (response, sucess) in
            if !sucess {
                print("Error finding the current udacity user in the Parse API")
            } else {
                guard let resultsDictionary = response?["results"] as? [[String: Any]] else {
                    return
                }
                
                guard let lastUpdateDictionary = resultsDictionary[0] as? [String: AnyObject] else {
                    return
                }

                // Init instance
                self.data.myStudentLocation = StudentLocation(dictionary: lastUpdateDictionary)
                //Add to students array
                self.data.studentLocations.append(StudentLocation(dictionary: lastUpdateDictionary))
            }
        }
    }
    
    func loadStudentLocationsData() {
        //Obtain 100 student locations
        let parameters: [String: Any] = ["limit": 100, "order": "-updatedAt"]
        PSClient().obtainStudentLocation(parameters: parameters) { (response, success) in
            if !success {
                DispatchQueue.main.async {
                    self.displayError(string: "Unable To download Data")
                }
            } else {
                self.data.studentLocations = StudentLocation.locationsFromResults(arrayOfStudentsDictionaries: response!)
                
                //TODO: Show Map with Annotations
                DispatchQueue.main.async {
                    self.loadStudentLocationsOnMap()
                }
            }
        }
    }
    
    func displayError(string: String) {
        let controller = UIAlertController(title: "Error", message: string, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)
    }
    
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadStudentLocationsData), name: Notification.Name(kRefreshLocation), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addLocationButtonPressed(_:)), name: Notification.Name(kUpdateLocation), object: nil)
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
            let button = UIButton(type: .detailDisclosure)
            button.tintColor = UIColor.blue
            pinView!.rightCalloutAccessoryView = button
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
                if app.canOpenURL(URL(string: toOpen)!) {
                    app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
                }
            }
        }
    }
}
