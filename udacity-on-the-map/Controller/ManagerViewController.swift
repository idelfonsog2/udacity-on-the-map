//
//  ManagerViewController.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/21/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import UIKit

class ManagerViewController: UINavigationController, UINavigationBarDelegate, UINavigationControllerDelegate {
    
    //Properties
    var data = OMData.sharedInstance()
    var activityIndicator: UIActivityIndicatorView?
    
    //MARK: IBOutlets
    @IBOutlet weak var leBar: UINavigationBar!
    
    //MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.leBar.delegate = self
        self.navigationController?.delegate = self
        self.setupNavBar()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(kRefreshLocation), object: self)
    }
    
    //MARK: Helper func
    func setupNavBar() {
        self.leBar.topItem?.title = "On The Map"
        self.leBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logout))
        
        let pinButton = UIBarButtonItem(image: UIImage(named: "pin"), style: .done, target: self, action: #selector(pinSelector))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshSelector))
        self.leBar.topItem?.rightBarButtonItems = [pinButton, refreshButton]
    }
    
    func logout() {
        UDClient().logoutFromUdacity { (response, success) in
            DispatchQueue.main.async {
                if !success {
                    self.displayAlertWithError(message: "Unable to logout")
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    //MARK: UIBarButtonItems
    func pinSelector() {
        NotificationCenter.default.post(name: Notification.Name(kUpdateLocation), object: self)
        
        //Check if a the user has already a lcation
        if (UserDefaults.standard.bool(forKey: kUpdateLocation)) {
            overwriteLocationWith(instantiateFindLocationViewController, message: "You have already posted a Student Location. Would You like to Overwrite your current Location?")
        } else {
            overwriteLocationWith(instantiateFindLocationViewController, message: "No location found. Would You Like to post your location?")
        }
    }
    
    func refreshSelector() {
        NotificationCenter.default.post(name: Notification.Name(kRefreshLocation), object: self)
    }
    
    //MARK: Instantiate View Controllers
    func instantiateFindLocationViewController() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "FindLocationViewController") as! FindLocationViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    

}
