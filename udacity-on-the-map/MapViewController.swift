//
//  MapViewController.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/12/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    //MARK: Properties
    var sessionId: String?
    var listOfLocations: [StudentLocation]?
    
    //MARK: IBOutlets
    
    //MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(listOfLocations)
    }
    
    //MARK: Helper Functions
    
    func converToStudentLocation(param: [String:Any]) {
        //TODO: fill method
        
    }
    
    func drawAnnotations(coordinates: CLLocationCoordinate2D) {
        //TODO:
    }
    
    //MARK: IBActions
    @IBAction func logouFromUdacity(_ sender: UIBarButtonItem) {
        UDClient().logoutFromUdacity()
        self.dismiss(animated: true, completion: nil)
    }
    
}
