//
//  ListViewController.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/12/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
    var locations: [StudentLocation] = StudentLocation.studentLocations
   
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var listBarItem: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(loadStudentsOnTableView), name: Notification.Name("refreshLocations"), object: nil)
        self.loadStudentsOnTableView()
    }
    
    @IBAction func logoutFromUdacity(_ sender: UIBarButtonItem) {
        UDClient().logoutFromUdacity()
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadStudentsOnTableView() {
        if self.locations.isEmpty {
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
        return self.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationTableViewCell", for: indexPath)
        let student = self.locations[indexPath.row]
        cell.textLabel?.text = "\(student.firstName ?? "[firstname]") \(student.lastName ?? "[lastname]")"
        cell.imageView?.image = UIImage(named: "pin")
        return cell
    }

    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        if let studentUrl = self.locations[indexPath.row].mediaURL {
            app.open(URL(string: studentUrl)!, options: [:], completionHandler: nil)
        }
    }

}
