//
//  LoginViewController.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/9/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    //Properties
    var data = OMData.sharedInstance()
    
    //MARK: IBOutlets
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    //MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToKeyboardNotifications()
        subscribeToKeyboardOffTap()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Clear text fields
        self.emailAddressTextField.text = ""
        self.passwordTextField.text = ""
    }
    
    //MARK: IBActions
    @IBAction func loginToUdacity(_ sender: UIButton) {
       getUdacitySession()
    }

    @IBAction func signUpToUdacity(_ sender: UIButton) {
        let url = URL(string: "https://auth.udacity.com/sign-up")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    //MARK: Network calls
    func getUdacitySession() {
        
        guard let email = emailAddressTextField.text, let password = passwordTextField.text else {
            displayAlertWithError(message: "Missing field")
            return
        }
        let indicator = startActivityIndicatorAnimation()

        let credentials = [
            UdacityHTTPBodyKeys.UdacityKey: [
                UdacityHTTPBodyKeys.UsernameKey:email,
                UdacityHTTPBodyKeys.PasswordKey:password
            ]
        ]
        
        UDClient().getSessionId(httpBody: credentials) { (response, success) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                if !success {
                    //access denied
                    self.stopActivityIndicatorAnimation(indicator: indicator)
                    if response as! Int == 403 {
                        self.displayAlertWithError(message: "Wrong email or password")
                    } else {
                        self.displayAlertWithError(message: "Connection Error")
                    }
                } else {
                    //access granted
                    self.data.session = UdacitySession(dictionary: response as! [String : Any])
                    self.loadUdacityUserProfile()
                    self.stopActivityIndicatorAnimation(indicator: indicator)
                    self.instantiateManagerViewController()
                }
            }
        }
    }
    
    func loadUdacityUserProfile() {
        UDClient().getUserPublicData() { (response, success) in
            if !success {
                DispatchQueue.main.async {
                    self.displayAlertWithError(message: "Could not find your information")
                }
            } else {
                self.data.user = UdacityUser(dictionary: response as! [String : Any])
            }
        }
    }
    
    //MARK: Helpers
    func instantiateManagerViewController() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }

    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.restorationIdentifier == "passwordTextField" {
            getUdacitySession()
            textField.endEditing(true)
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
}

