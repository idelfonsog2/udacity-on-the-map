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
    var lastUpdated: String?
    
    init(objectId: String?, firstName: String?, lastName: String?, mapString: String?, mediaURL: String?, uniqueKey: String?, latitude: Double?, longitude: Double?, lastUpdated: String?) {
        self.objectId = objectId
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.uniqueKey = uniqueKey
        self.latitude = latitude
        self.longitude = longitude
        self.lastUpdated = lastUpdated
    }
    
    init(dictionary: [String: AnyObject]) {
        objectId = dictionary["objectId"] as? String
        firstName = dictionary["firstName"] as? String
        lastName = dictionary["lastName"] as? String
        mapString = dictionary["mapString"] as? String
        mediaURL = dictionary["mediaURL"] as? String
        latitude = dictionary["latitude"] as? Double
        longitude = dictionary["longitude"] as? Double
        uniqueKey = dictionary["uniqueKey"] as? String
        lastUpdated = dictionary["updatedAt"] as? String
    }
    
    //Functions
    static func locationsFromResults(arrayOfStudentsDictionaries: AnyObject) -> [StudentLocation] {
        var locations = [StudentLocation]()
        let results = arrayOfStudentsDictionaries["results"] as! [[String:AnyObject]]
        
        for student in results {
            locations.append(StudentLocation(dictionary: student))
        }
        
        return locations
    }
}
