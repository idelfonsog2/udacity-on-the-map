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
    var objectId:   String?
    var firstName:  String?
    var lastName:   String?
    var mapString:  String?
    var mediaURL:   String?
    var uniqueKey:  String?
    var latitude:   Double?
    var longitude:  Double?
    
    init(objectId: String?, firstName: String?, lastName: String?, mapString: String?, mediaURL: String?, uniqueKey: String?, latitude: Double, longitude: Double) {
        self.objectId = objectId
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.uniqueKey = uniqueKey
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(dictionary: [String:AnyObject]) {
        objectId = dictionary["objectId"] as? String
        firstName = dictionary["firstName"] as? String
        lastName = dictionary["lastName"] as? String
        mapString = dictionary["mapString"] as? String
        mediaURL = dictionary["mediaURL"] as? String
        latitude = dictionary["latitude"] as? Double
        longitude = dictionary["longitude"] as? Double
        uniqueKey = dictionary["uniqueKey"] as? String
    }
    
    //Functions
    static func locationsFromResults(_ arrayOfStudentsDictionaries: AnyObject) -> [StudentLocation] {
        let jsonObjectArray = arrayOfStudentsDictionaries as! [[String:AnyObject]]
        var locations = [StudentLocation]()
        
        for student in jsonObjectArray {
            locations.append(StudentLocation(dictionary: student))
        }
        
        return locations
    }
}
