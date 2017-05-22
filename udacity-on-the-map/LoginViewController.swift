//
//  LoginViewController.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/9/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    //MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadLocations), name: Notification.Name("refreshLocations"), object: nil)
        
        self.reloadLocations()
    }
    
    //MARK: IBActions
    @IBAction func loginToUdacity(_ sender: UIButton) {
        if let email = emailAddressTextField.text, let password = passwordTextField.text {
            User.getSessionId(email: email, password: password, completionHandler: { (response, success) in
                DispatchQueue.main.async {
                    if success {
                        self.accessGranted()
                    } else {
                        self.displayAlert(message: "Account not found or invalid credentials")
                    }
                }
            })
        } else {
            displayAlert(message: "Empty Field!")
        }
        
    }

    @IBAction func signUpToUdacity(_ sender: UIButton) {
        let url = URL(string: "https://auth.udacity.com/sign-up")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    //TODO: Implement Passwordless with Facebook
    
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
    
    func reloadLocations() {
        StudentLocation.loadStudentLocations()
    }
    
}

