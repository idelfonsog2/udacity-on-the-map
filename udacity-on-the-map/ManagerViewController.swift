//
//  ManagerViewController.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/21/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import UIKit

class ManagerViewController: UINavigationController, UINavigationBarDelegate {

    //MARK: IBOutlets
    
    @IBOutlet weak var leBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.leBar.delegate = self
        self.setupNavBar()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavBar() {
        self.leBar.topItem?.title = "On The Map"
        self.leBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logout))
        
        let pinButton = UIBarButtonItem(image: UIImage(named: "pin"), style: .done, target: self, action: #selector(pin))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        
        self.leBar.topItem?.rightBarButtonItems = [pinButton, refreshButton]
    }
    
    func logout() {
        UDClient().logoutFromUdacity()
        self.dismiss(animated: true, completion: nil)
    }
    
    func pin() {
        //TODO:
    }
    
    func refresh() {
        //TODO:
    }

}
