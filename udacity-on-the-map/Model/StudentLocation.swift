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
    var updatedAt:  String?
    var createdAt:  String?
    
    init(dictionary: [String: AnyObject]) {
        objectId    = dictionary["objectId"]    as? String
        firstName   = dictionary["firstName"]   as? String
        lastName    = dictionary["lastName"]    as? String
        mapString   = dictionary["mapString"]   as? String
        mediaURL    = dictionary["mediaURL"]    as? String
        latitude    = dictionary["latitude"]    as? Double
        longitude   = dictionary["longitude"]   as? Double
        uniqueKey   = dictionary["uniqueKey"]   as? String
        updatedAt   = dictionary["updatedAt"]   as? String
        createdAt   = dictionary["createdAt"]   as? String
    }
    
    //Functions
    static func locationsFromResults(arrayStudentsDictionaries: AnyObject) -> [StudentLocation] {
        var locations = [StudentLocation]()
        
        for student in arrayStudentsDictionaries as! [[String: AnyObject]] {
            locations.append(StudentLocation(dictionary: student))
        }
        
        return locations
    }
}
