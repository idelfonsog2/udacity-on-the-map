//
//  UdacityUser.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/21/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import Foundation

struct UdacityUser {
    var firstName: String?
    var lastName: String?
    var location: String?
    
    init(firstName: String?, lastName: String?, location: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.location = location
    }
    
    init(dictionary: [String: Any]) {
        guard let userDictionary = dictionary["user"] as? [String: Any] else {
            return
        }
        self.firstName = userDictionary["first_name"] as? String
        self.lastName = userDictionary["last_name"] as? String
        self.location = userDictionary["location"] as? String
    }
}
