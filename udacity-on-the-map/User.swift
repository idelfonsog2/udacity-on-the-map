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
    static var userLocation: StudentLocation?
    static var userData: User?
    static var sessionId = String()
    static var uniqueKey = String()
    
    //MARK: Class properties
    var firstName: String?
    var lastName: String?
    
    init(dictionary: [String: Any]) {
        self.firstName = dictionary["first_name"] as? String
        self.lastName = dictionary["last_name"] as? String
        //TODO: add more properties if needed from the response
        //https://d17h27t6h515a5.cloudfront.net/topher/2016/June/575840d1_get-user-data/get-user-data.json
    }
    
    
    //MARK: static functions
    static func loadMyData(completionHandler: @escaping(_ response: AnyObject?, _ success: Bool) -> Void) {
        
        //Pass completion handler in case the Object construction fails
        let params = [UdacityHTTPBodyKeys.UdacityKey: User.uniqueKey]
        
        UDClient().getUserPublicData(params: params) { (response, success) in
            if !success {
                completionHandler(nil, false)
            }
            
            guard let userDictionary = response?["user"] as? [String: Any] else {
                completionHandler(nil, false)
                return
            }
            
            //MARK: Init user with JSON
            User.userData = User(dictionary: userDictionary)
            completionHandler(nil, true)
        }
    }
    
    static func getSessionId(email: String, password: String, completionHandler: @escaping(_ response: Any?, _ success: Bool) -> Void) {
        
        //Pass completion handler in case the Object construction fails
        let credentials =
            [
                UdacityHTTPBodyKeys.UdacityKey:
                    [
                        UdacityHTTPBodyKeys.UsernameKey:email,
                        UdacityHTTPBodyKeys.PasswordKey:password
                ]
        ]
        
        UDClient().getSessionId(httpBody: credentials) { (response, success) in
            
            //TODO: remove print statement
            print(response!)
            
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
    
    
}
