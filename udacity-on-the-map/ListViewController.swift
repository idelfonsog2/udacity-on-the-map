//
//  ListViewController.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/12/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Instantiate Models & Properties
    var data = OMData.sharedInstance()
    var arrayOfStudents: [StudentLocation]?
   
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var listBarItem: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(loadStudentsOnTableView), name: Notification.Name(kRefreshLocation), object: nil)
        self.loadStudentsOnTableView()
    }
    
    deinit {
        //FIXME: Do I remove if VC goes off screen?
        //NotificationCenter.default.removeObserver(self)
    }
    @IBAction func logoutFromUdacity(_ sender: UIBarButtonItem) {
        UDClient().logoutFromUdacity { (response, success) in
            if !success {
                print("FAIL to logout")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func loadStudentsOnTableView() {

        if self.data.studentLocations.isEmpty {
            displayError(string: "Unable to download data")
            return
        }
        //refresh table
        self.tableView.reloadData()
    }
    
    func displayError(string: String) {
        let controller = UIAlertController(title: "Error", message: string, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)
    }
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationTableViewCell", for: indexPath)
        let student = self.data.studentLocations[indexPath.row]
        cell.textLabel?.text = "\(student.firstName ?? "[firstname]") \(student.lastName ?? "[lastname]")"
        cell.imageView?.image = UIImage(named: "pin")
        return cell
    }

    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        if let studentUrl = self.data.studentLocations[indexPath.row].mediaURL {
            //FIXME: not opening safari
            if app.canOpenURL(URL(string: studentUrl)!) {
                app.open(URL(string: studentUrl)!, options: [:], completionHandler: nil)
            }
        }
    }

}
