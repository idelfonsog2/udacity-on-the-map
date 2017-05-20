//
//  LoginViewController.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/9/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import UIKit

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
        
        UDClient().getSessionId(httpBody: credentials) { (response, success) in
            DispatchQueue.main.async {
                print(response)
                if success && ((response as AnyObject).isEqual(true) != nil) {
                    self.accessGranted()
                } else {
                    self.displayAlert(message: "Incorrect Credentials")
                }
            }
        }
    }

    @IBAction func signUpToUdacity(_ sender: UIButton) {
        
    }
    
    //MARK: helpers
    
    func accessGranted() {
        //TODO: obtain student locations before transitioning to the next VC  
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }
    
    func displayAlert(message: String) {
        let controller = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)

    }
    
}

