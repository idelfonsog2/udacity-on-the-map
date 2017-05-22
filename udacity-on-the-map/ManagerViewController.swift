//
//  ManagerViewController.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/21/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import UIKit

class ManagerViewController: UINavigationController, UINavigationBarDelegate {

    //MARK: Properties
    var myLocation = User.userLocation
    
    //MARK: IBOutlets
    @IBOutlet weak var leBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.leBar.delegate = self
        self.setupNavBar()
        
        // Do any additional setup after loading the view.
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("refreshLocations"), object: self)
    }
    
    func setupNavBar() {
        self.leBar.topItem?.title = "On The Map"
        self.leBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logout))
        
        let pinButton = UIBarButtonItem(image: UIImage(named: "pin"), style: .done, target: self, action: #selector(pinSelector))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshSelector))
        
        self.leBar.topItem?.rightBarButtonItems = [pinButton, refreshButton]
    }
    
    func logout() {
        UDClient().logoutFromUdacity()
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: UIBarButtonItems
    func pinSelector() {
        if (myLocation?.uniqueKey) != nil { //check if there is active location for user
            self.showAlerWith(message: "You have already posted a Student Location. Would You like to Overwrite your current Location?")
        } else {
            self.showAlerWith(message: "No location found. Would You Like to post your location?")
        }
    }
    
    func refreshSelector() {
        NotificationCenter.default.post(name: Notification.Name("refreshLocations"), object: self)
        StudentLocation.loadStudentLocations()
    }
    
    // MARK: Alerts
    func showAlerWith(message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "cancel", style: .destructive, handler: nil)
        let okAction = UIAlertAction(title: "ok", style: .default) { (action) in
            DispatchQueue.main.async {
                self.instantiateFindLocationViewController()
            }
        }
        
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Instantiate View Controllers
    func instantiateFindLocationViewController() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "FindLocationViewController") as! FindLocationViewController
        controller.myLocation = self.myLocation
        self.present(controller, animated: true, completion: nil)
    }

}
