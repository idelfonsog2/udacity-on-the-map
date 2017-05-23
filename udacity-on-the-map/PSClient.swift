//
//  PSClient.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/9/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import UIKit

class PSClient: NSObject {
    let network = UMNetworking.sharedInstance()
    
    func obtainStudentLocation(parameters: [String : Any], completionHandlerForGET: @escaping (_ result: AnyObject?, _ success: Bool) -> Void) {
        // GET: StudentLocation
        let url = urlFromParameters(parameters, withPathExtension: nil)
        let request = NSMutableURLRequest(url: url)
        request.addValue(ParseHeaderFieldsValues.ParseAppIDValue, forHTTPHeaderField: ParseHeaderFieldsKeys.ParseAppIDKey)
        request.addValue(ParseHeaderFieldsValues.RestApiKeyValue, forHTTPHeaderField: ParseHeaderFieldsKeys.ParseRestKey)
        
        let _ = network.taskForWithRequest(request) { (response, success) in
            //TODO: create objects
        }
    }
    
    func createStudentLocation(httpBody: [String: Any], completionHandlerForPOST: @escaping (_ result: AnyObject?, _ success: Bool) -> Void) {
        // POST: StudentLocation
        let url = urlFromParameters([:], withPathExtension: ParseMethod.StudentLocation)
        let request = NSMutableURLRequest(url: url)
        request.addValue(ParseHeaderFieldsValues.ParseAppIDValue, forHTTPHeaderField: ParseHeaderFieldsKeys.ParseAppIDKey)
        request.addValue(ParseHeaderFieldsValues.RestApiKeyValue, forHTTPHeaderField: ParseHeaderFieldsKeys.ParseRestKey)
        request.addValue(ParseHeaderFieldsValues.ApplicationJSONKey, forHTTPHeaderField: ParseHeaderFieldsKeys.ContentType)
        request.httpMethod = "POST"
        request.httpBody = network.convertHTTPBodyToData(body: httpBody)
        
        let _ = network.taskForWithRequest(request) { (reponse, success) in
            //TODO: create object
        }
    }
    
    func updateStudentLocation(objectId: String, httpBody: String?, completionHandlerForPUT: @escaping (_ result: AnyObject?, _ success: Bool) -> Void) {
        // PUT: StudentLocation
        var mutablePathExtension: String = ParseMethod.StudentLocation
        mutablePathExtension = UMNetworking().substituteKeyInMethod(mutablePathExtension, key: ParseURLKeys.ObjectId, value: objectId)!
        
        let url = urlFromParameters([:], withPathExtension: mutablePathExtension)
        let request = NSMutableURLRequest(url: url)
        request.addValue(ParseHeaderFieldsValues.ParseAppIDValue, forHTTPHeaderField: ParseHeaderFieldsKeys.ParseAppIDKey)
        request.addValue(ParseHeaderFieldsValues.RestApiKeyValue, forHTTPHeaderField: ParseHeaderFieldsKeys.ParseRestKey)
        request.addValue(ParseHeaderFieldsValues.ApplicationJSONKey, forHTTPHeaderField: ParseHeaderFieldsKeys.ContentType)
        request.httpMethod = "PUT"
        request.httpBody = httpBody?.data(using: String.Encoding.utf8)
        
        let _ = network.taskForWithRequest(request) { (response, success) in
            //TODO: create object
        }
    }
    

    // create a URL from parameters
    private func urlFromParameters(_ parameters: [String: Any], withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = ParseConstants.scheme
        components.host = ParseConstants.host
        components.path = ParseConstants.path + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        if !parameters.isEmpty {
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.url!
    }
    
}
