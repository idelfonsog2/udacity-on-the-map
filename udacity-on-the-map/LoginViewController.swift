//
//  LoginViewController.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/9/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //Singleton
    let udacitySession = UdacitySession.sharedInstance
    
    //MARK: IBOutlets
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    //MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: IBActions
    @IBAction func loginToUdacity(_ sender: UIButton) {
        guard let email = emailAddressTextField.text, let password = passwordTextField.text else {
            displayAlert(message: "Missing field")
            return
        }
        let credentials = [
            UdacityHTTPBodyKeys.UdacityKey: [
                UdacityHTTPBodyKeys.UsernameKey:email,
                UdacityHTTPBodyKeys.PasswordKey:password
            ]
        ]
        
        UDClient().getSessionId(httpBody: credentials) { (response, success) in
            DispatchQueue.main.async {
                if !success {
                    //access denied
                    self.displayAlert(message: "Account not found or invalid credentials")
                } else {
                    //access granted
                    self.instantiateManagerViewController()
                }
            }
        }
        
    }

    @IBAction func signUpToUdacity(_ sender: UIButton) {
        let url = URL(string: "https://auth.udacity.com/sign-up")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    //TODO: Implement Passwordless with Facebook
    
    //MARK: helpers
    func instantiateManagerViewController() {
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

