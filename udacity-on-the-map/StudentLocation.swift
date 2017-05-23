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
    
    
//    objectID = student["objectId"] as? String
//    firstName = student["firstName"] as? String
//    lastName = student["lastName"] as? String
//    mapString = student["mapString"] as? String
//    mediaURL = student["mediaURL"] as? String
//    latitude = student["latitude"] as? Double
//    longitude = student["longitude"] as? Double
//    uniqueKey = student["uniqueKey"] as? String

    static func locationsFromResults(_ arrayOfStudentsDictionaries: [[String:AnyObject]]) -> [StudentLocation] {
        var locations = [StudentLocation]()
        
        // iterate through array of dictionaries
        for student in arrayOfStudentsDictionaries {
            let newStudent = StudentLocation(
                objectID:   student["objectId"] as? String,
                firstName:  student["firstName"] as? String,
                lastName:   student["lastName"] as? String,
                mapString:  student["mapString"] as? String,
                mediaURL:   student["mediaURL"] as? String,
                uniqueKey:  student["uniqueKey"] as? String,
                latitude:   student["latitude"] as? Double,
                longitude:  student["longitude"] as? Double)
            locations.append(newStudent)
        }
        return locations
    }
    
    //MARK: Singleton
    static func sharedInstance() -> StudentLocation {
        struct Singleton {
            static var sharedInstance = StudentLocation()
        }
        
        return Singleton.sharedInstance
    }
    
    
}
