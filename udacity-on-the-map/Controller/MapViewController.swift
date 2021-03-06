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
            displayAlertWithError(message: "Unable to download data")
            return
        }

        //TODO: Another user might have not posted their location or media url
        for student in self.data.studentLocations {
            if student.latitude != nil, student.longitude != nil {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: student.latitude!, longitude: student.longitude!)
                annotation.title = "\(student.firstName ?? "no name") \(student.lastName ?? "no name")"
                annotation.subtitle = "\(student.mediaURL!)"
                self.annotations.append(annotation)
            }
        }
        
        self.mapView.addAnnotations(self.annotations)
    }
    
    func loadMyParseStudentLocationData() {
        //Init myStudentLocation Instance
        let params: [String: Any] = ["order":"-createdAt","where": "{\"\(ParseHTTPBodyKeys.UniqueKey)\":\"\(data.session!.uniqueKey!)\"}"]
        PSClient().obtainStudentLocation(all: false, parameters: params) { (response, sucess) in
            if !sucess {
                print("Error finding the current udacity user in the Parse API")
            } else {
                let lastUpdateDictionary = response as! [String: AnyObject]
                // Init instance
                self.data.myStudentLocation = StudentLocation(dictionary: lastUpdateDictionary)
                //Add to students array
                self.data.studentLocations.append(StudentLocation(dictionary: lastUpdateDictionary))
                UserDefaults.standard.set(true, forKey: kUpdateLocation)
            }
        }
    }
    
    func loadStudentLocationsData() {
        //Obtain 100 student locations
        let indicator = startActivityIndicatorAnimation()
        let parameters: [String: Any] = ["limit": 100, "order": "-updatedAt"]
        PSClient().obtainStudentLocation(all: true, parameters: parameters) { (response, success) in
            if !success {
                DispatchQueue.main.async {
                    self.stopActivityIndicatorAnimation(indicator: indicator)
                    self.displayAlertWithError(message: "Unable To download Data")
                }
            } else {
                self.data.studentLocations = StudentLocation.locationsFromResults(arrayStudentsDictionaries: response!)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                    //Show Map with Annotations
                    self.loadStudentLocationsOnMap()
                    self.stopActivityIndicatorAnimation(indicator: indicator)
                }
            }
        }
    }
    
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadStudentLocationsData), name: Notification.Name(kRefreshLocation), object: nil)
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
            if let toOpen = URL(string:(view.annotation?.subtitle!)!), toOpen.scheme == "https", !toOpen.absoluteString.isEmpty {
                if app.canOpenURL(toOpen) {
                    app.open(toOpen, options: [:], completionHandler: nil)
                }
            } else {
                displayAlertWithError(message: "Not ablet to open URL")
            }
        }
    }
}
