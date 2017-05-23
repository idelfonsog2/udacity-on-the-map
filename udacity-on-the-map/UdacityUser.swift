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
    
    init(firsName: String?, lastName: String?, location: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.location = location
    }
    
    init(dictionary: [[String: Any]]) {
        self.firstName = dictionary["first_name"] as? String
        self.lastName = dictionary["last_name"] as? String
        self.location = dictionary["location"] as? String
    }
}




class UserClass {
    
    
    class func getSessionId(email: String, password: String, completionHandler: @escaping(_ response: Any?, _ success: Bool) -> Void) {
        
        //Pass completion handler in case the Object construction fails
       
        
        UDClient().getSessionId(httpBody: credentials) { (response, success) in
            
            guard let accountDictionary = response?["account"] as? [String: Any] else {
                print("no 'account' key found")
                completionHandler(nil, false)
                return
            }
            
            guard let registered = accountDictionary["registered"] as? Bool else {
                print("no 'registered' key found")
                completionHandler(nil, false)
                return
            }
            
            guard let key = accountDictionary["key"] as? String else {
                print("no 'key' key found")
                completionHandler(nil, false)
                return
            }
            
            guard let session = response?["session"] as? [String: Any] else {
                print("no 'session' key found")
                completionHandler(nil, false)
                return
            }
            
            guard let id = session["id"] as? String else {
                print("no 'id' key found")
                completionHandler(nil, false)
                return
            }
            
            //MARK: Init Udacity Session
            User.sessionId = id
            User.uniqueKey = key
            completionHandler(nil, true)
        }
    }
    
    static func loadMyLocation(completionHandler: @escaping(_ response: AnyObject?, _ succes: Bool) -> Void) {
        
        let params = [ParseGETParameterKeys.UniqueKey: User.uniqueKey]

        PSClient().obtainStudentLocation(parameters: params) { (response, success) in
            
            if !success {
                completionHandler(nil, false)
            }
            
            guard let arrayOfStudentLocations = response?["results"] as? [[String: AnyObject]] else {
                print("No 'results' key found in the response")
                completionHandler(nil, false)
                return
            }
            
            //MARK: Init user location with JSON
            User.userLocation = StudentLocation(dictionary: arrayOfStudentLocations[0])
            completionHandler(nil, true)
        }
    }
    
    class func sharedInstance() -> User {
        struct Singleton {
            static var sharedInstance = User()
        }
        return Singleton.sharedInstance
    }
    
}
