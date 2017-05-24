//
//  UDConstants.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/10/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import Foundation

struct UdacityConstants {
    static let scheme   = "https"
    static let host     = "www.udacity.com"
    static let path     = "/api"
    
    static let baseURL  = "https://www.udacity.com/api/session"
}

struct UdacityMethod {
    static let Session = "/session"
    static let Users = "/users/{user_id}"
}

struct UdacityURLKeys {
    static let UserId = "user_id"
}

struct UdacityHTTPBodyKeys {
    static let UdacityKey   = "udacity"   //root
    static let UsernameKey  = "username"
    static let PasswordKey  = "password"
    
    /*
     request.httpBody = "{\"udacity\": {\"username\": \"account@domain.com\", \"password\": \"********\"}}".data(using: String.Encoding.utf8)
     */
}

struct UdacityHeaderFieldsKeys {
    static let Accept = "Accept"
    static let ContentType = "Content-Type"
}

struct UdacityHeaderFieldValue {
    static let ApplicationJSON = "application/json"
}

/*
 UDACITY:
 SKIP THE FIRST 5 CHARACTERS OF THE RESPONSE
 
 let range = Range(5..<data!.count)
 let newData = data?.subdata(in: range) /* subset response data! */
 print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
 */
