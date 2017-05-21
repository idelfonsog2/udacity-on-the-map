//
//  StudentLocation.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/9/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import Foundation
import MapKit

struct StudentLocation {
    var objectID:   String?
    var firstName:  String?
    var lastName:   String?
    var mapString:  String?
    var mediaURL:   String?
    var uniqueKey:  String?
    var latitude:   Double?
    var longitude:  Double?
    
    static var studentLocations = [StudentLocation]()
    
    
    init(dictionary: [String:AnyObject]) {
        objectID = dictionary["objectId"] as? String
        firstName = dictionary["firstName"] as? String
        lastName = dictionary["lastName"] as? String
        mapString = dictionary["mapString"] as? String
        mediaURL = dictionary["mediaURL"] as? String
        latitude = dictionary["latitude"] as? Double
        longitude = dictionary["longitude"] as? Double
        uniqueKey = dictionary["uniqueKey"] as? String
    }
    
    static func loadStudentLocations() {
        let parameters: [String: Any] = ["limit": 100]
        PSClient().obtainStudentLocation(parameters: parameters) { (response, success) in
            if !success {
                print(response ?? "nil")
            }
            
            guard let arrayOfStudentLocations = response?["results"] as? [[String: AnyObject]] else {
                print("No 'results' key found in the response")
                return
            }
            
            for student in arrayOfStudentLocations {
                StudentLocation.studentLocations.append(StudentLocation(dictionary: student))
            }
        }
    }
    
    
}
