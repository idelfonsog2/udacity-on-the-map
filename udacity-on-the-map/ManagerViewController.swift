//
//  ManagerViewController.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/21/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import UIKit

class ManagerViewController: UINavigationController, UINavigationBarDelegate {
    
    //Singleton
    var data = OMData.sharedInstance()
    
    //MARK: IBOutlets
    @IBOutlet weak var leBar: UINavigationBar!
    
    //MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.leBar.delegate = self
        self.setupNavBar()
        // Do any additional setup after loading the view.
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
            //TODO: Check with udacity number of sessions that could be open by the same user
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //MARK: UIBarButtonItems
    func pinSelector() {
        NotificationCenter.default.post(name: Notification.Name(kUpdateLocation), object: self)
        //TODO: Use bool form parse data to confirm user previously posted
        if (UserDefaults.standard.bool(forKey: kUpdateLocation)) { //check if there is active location for user
            showAlerWith(message: "You have already posted a Student Location. Would You like to Overwrite your current Location?")
        } else {
            showAlerWith(message: "No location found. Would You Like to post your location?")
        }
    }
    
    func refreshSelector() {
        NotificationCenter.default.post(name: Notification.Name(kRefreshLocation), object: self)
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
        self.present(controller, animated: true, completion: nil)
    }

}
