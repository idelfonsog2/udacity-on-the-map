//
//  LoginViewController.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/9/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoginViewController: UIViewController {
    
    //MARK: Properties
    var appDelegate: AppDelegate?
    var listOfLocations: [StudentLocation]?

    //MARK: IBOutlets
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    //MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadStudentLocations()
    }

    //MARK: IBActions
    @IBAction func loginToUdacity(_ sender: UIButton) {
        let credentials =
        [
            UdacityHTTPBodyKeys.UdacityKey:
            [
                UdacityHTTPBodyKeys.UsernameKey:emailAddressTextField.text,
                UdacityHTTPBodyKeys.PasswordKey:passwordTextField.text
            ]
        ]
        
        UDClient().getSessionId(httpBody: credentials) { (response, error) in
            guard (error == nil) else {
                //TODO: display pop error alert
                return
            }
            
            guard let session = response?["session"] as? [String: Any] else {
                //TODO: display pop error alert
                return
            }
            
            guard let id = session["id"] as? String else {
                return
            }
            
            self.appDelegate?.sessionId = id
        }
        self.accessGranted()
    }

    @IBAction func signUpToUdacity(_ sender: UIButton) {
        
    }
    
    //MARK: helpers
    func loadStudentLocations() {
        /* Optional Params:
         limit  (Number)
         skip   (Number)
         order  (String)
         */
        let parameters: [String: Any] = ["limit": 100]
        
        PSClient().obtainStudentLocation(parameters: parameters) { (response, error) in
            guard (error == nil) else {
                print("Error in the response")
                return
            }
            
            guard let arrayOfStudentLocations = response?["results"] as? [[String: Any]] else {
                print("No 'results' key found in the response")
                return
            }
            
            for object in arrayOfStudentLocations {
                let student = StudentLocation(dictionary: object as [String : AnyObject])
                print(student)
                self.listOfLocations?.append(student)
            }
        }
    }
    
    func accessGranted() {
        let mapController = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        mapController.listOfLocations = self.listOfLocations
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }
    
}

