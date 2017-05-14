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
    
    func accessGranted() {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }
    
}

