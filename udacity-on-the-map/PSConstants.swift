//
//  Constants.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/9/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import Foundation

    //MARK: Websites
struct ParseConstants {
    static let scheme   = "https"
    static let host     = "parse.udacity.com"
    static let path     = "/parse/classes"
    
    static let baseURL  = "https://parse.udacity.com/parse/classes"
}

    //MARK: Methods
struct ParseMethod {
    static let StudentLocation      = "/StudentLocation"      //POST, GET
    static let PUTStudentLocation   = "/StudentLocation/<objectId>"
}

    //MARK: ParameterKeys
struct ParseGETParameterKeys {
    
    //Multiple Students
    static let Limit    = "limit"   //Optional
    static let Skip     = "skip"    //Optional
    static let Order    = "order"   //Optional
    
    //Single students
    static let Where    = "where"   //Required  Escaped SQL query
}

    //MARK: Header Fields

struct ParseHeaderFieldsKeys {
    static let ParseAppIDKey    = "X-Parse-Application-Id"
    static let ParseRestKey     = "X-Parse-REST-API-Key"
    static let ContentType = "Content-Type"
}

struct ParseHeaderFieldsValues {
    static let ParseAppIDValue  = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let RestApiKeyValue  = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    static let ApplicationJSONKey = "application/json"
}

/* NOTES:
 
 PARSE:
 GETting:
    Single:
 https://d17h27t6h515a5.cloudfront.net/topher/2016/June/57583b20_get-student-locations/get-student-locations.json
    Multiple:
 https://d17h27t6h515a5.cloudfront.net/topher/2016/June/57583d8e_get-student-location/get-student-location.json
 
 POSTing:
 *Include application/json headerField
    Create Student
 https://d17h27t6h515a5.cloudfront.net/topher/2016/June/57583e35_post-student-location/post-student-location.json
 
 request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: String.Encoding.utf8)

 PUTing
 
 
 */
