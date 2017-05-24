//
//  Constants.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/9/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import Foundation

struct ParseConstants {
    static let scheme   = "https"
    static let host     = "parse.udacity.com"
    static let path     = "/parse/classes"
    
    static let baseURL  = "https://parse.udacity.com/parse/classes"
}

struct ParseMethod {
    static let StudentLocation      = "/StudentLocation"      //POST, GET
}

struct ParseURLKeys {
    static let ObjectId = "objectId"
}

struct ParseHTTPBodyKeys {
    static let UniqueKey    = "uniqueKey"
    static let FirstName    = "firstName"
    static let LastName     = "lastName"
    static let MapString    = "mapString"
    static let MediaUrl     = "mediaURL"
    static let Latitude     = "latitude"
    static let Longitude    = "longitude"
}
struct ParseGETParameterKeys {
    static let UniqueKey = "uniqueKey"
    
    //Multiple Students
    static let Limit    = "limit"   //Optional
    static let Skip     = "skip"    //Optional
    static let Order    = "order"   //Optional
    
    //Single students
    static let Where    = "where"   //Required  Escaped SQL query
}

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

