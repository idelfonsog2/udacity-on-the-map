//
//  LoginViewController.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/9/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //Properties
    var data = OMData.sharedInstance()
    var activityIndicator: UIActivityIndicatorView?
    
    //MARK: IBOutlets
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    //MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.emailAddressTextField.text = ""
        self.emailAddressTextField.text = ""
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
        
        self.startActivityIndicator()
        UDClient().getSessionId(httpBody: credentials) { (response, success) in
            DispatchQueue.main.async {
                if !success {
                    //access denied
                    self.activityIndicator?.stopAnimating()
                    self.displayAlert(message: "Account not found or invalid credentials")
                } else {
                    //access granted
                    self.data.session = UdacitySession(dictionary: response as! [String : Any])
                    self.loadUdacityUserProfile()
                    self.activityIndicator?.stopAnimating()
                    self.instantiateManagerViewController()
                }
            }
        }
    }

    func loadUdacityUserProfile() {
        UDClient().getUserPublicData() { (response, success) in
            if !success {
                DispatchQueue.main.async {
                    self.displayAlert(message: "Could not find your information")
                }
            } else {
                self.data.user = UdacityUser(dictionary: response as! [String : Any])
            }
        }
    }
    @IBAction func signUpToUdacity(_ sender: UIButton) {
        let url = URL(string: "https://auth.udacity.com/sign-up")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    //MARK: Helpers
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
    
    //TODO: Implement Passwordless with Facebook

    func startActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        activityIndicator?.center = self.view.center
        activityIndicator?.color = UIColor.gray
        self.view.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

