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
    
    
    @IBAction func logoutFromUdacity(_ sender: UIBarButtonItem) {
        UDClient().logoutFromUdacity { (response, success) in
            if !success {
                self.displayAlertWithError(message: "FAIL to logout")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func loadStudentsOnTableView() {
        if self.data.studentLocations.isEmpty {
            displayAlertWithError(message: "Unable to download data")
            return
        }
        //refresh table
        self.tableView.reloadData()
    }
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationTableViewCell", for: indexPath)
        let student = self.data.studentLocations[indexPath.row]
        cell.textLabel?.text = "\(student.firstName ?? "[firstname]") \(student.lastName ?? "[lastname]")"
        cell.detailTextLabel?.text = "\(student.mediaURL ?? "[no-url]")"
        return cell
    }

    //MARK: UITableViewDelegate
    
    /*
     Reviewer Question:  Why not allow the app open a URL that starts with simple http? Due to new A
     answer: Apple announced that ATS will be REQUIRED of all apps as of January 2017.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        if let studentUrl = self.data.studentLocations[indexPath.row].mediaURL,
            let url = URL(string: studentUrl),
            url.scheme == "https",
            !url.absoluteString.isEmpty {
            tableView.deselectRow(at: indexPath, animated: true)
            if app.canOpenURL(URL(string: studentUrl)!) {
                app.open(URL(string: studentUrl)!, options: [:], completionHandler: nil)
            }
        } else {
            displayAlertWithError(message: "Not able to open URL")
        }
    }

}
