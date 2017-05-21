//
//  User.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/21/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import Foundation

class User {
    
    //MARK: Properties
    var userLocation: StudentLocation?
    
    static func loadMyLocation() {
        
        let params: [String: Any]
        if let key = User.sharedInstance().userLocation?.uniqueKey {
            params = [ParseGETParameterKeys.UniqueKey: key]
        } else {
            //dummy key
            params = [ParseGETParameterKeys.UniqueKey: "4444"]
        }
        
        PSClient().obtainStudentLocation(parameters: params) { (response, success) in
            
            if !success {
                print(response ?? "nil")
            }
            
            guard let arrayOfStudentLocations = response?["results"] as? [[String: AnyObject]] else {
                print("No 'results' key found in the response")
                return
            }
            
            User.sharedInstance().userLocation = StudentLocation(dictionary: arrayOfStudentLocations[0])
        }
    }
    
    class func sharedInstance() -> User {
        struct Singleton {
            static var sharedInstance = User()
        }
        return Singleton.sharedInstance
    }
}
