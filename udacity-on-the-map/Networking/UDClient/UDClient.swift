//
//  UDClient.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/9/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import UIKit

class UDClient: NSObject {
    
    let network = UMNetworking.sharedInstance()
    let data = OMData.sharedInstance()

    //MARK: Network calls
    func logoutFromUdacity(completionHandler: @escaping (_ result: AnyObject?, _ success: Bool) -> Void) {
        //DELETE: User login session
        let url = urlFromParameters([:], withPathExtension: nil)
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }

        let _ = network.taskForWithRequest(request) { (response, success) in
            completionHandler(response, success)
        }
    }
    
    func getUserPublicData(completionHandler: @escaping (_ result: AnyObject?, _ success: Bool) -> Void) {
        // GET: Udacity User Data
        var mutablePathExtension = UdacityMethod.Users
        mutablePathExtension = network.substituteKeyInMethod(mutablePathExtension, key: UdacityURLKeys.UserId, value: (self.data.session?.uniqueKey)!)!
        let url = urlFromParameters([:], withPathExtension: mutablePathExtension)
        let request = NSMutableURLRequest(url: url)
        
        let _ = network.taskForWithRequest(request) { (response, success) in
            completionHandler(response, success)
        }
    }
    
    func getSessionId(httpBody: [String: Any], completionHandler: @escaping (_ result: AnyObject?, _ success: Bool) -> Void) {
        // POST: Get Udacity Session and uniqueKey
        let url = urlFromParameters([:], withPathExtension: UdacityMethod.Session)
        let request = NSMutableURLRequest(url: url)
        request.addValue(UdacityHeaderFieldValue.ApplicationJSON , forHTTPHeaderField: UdacityHeaderFieldsKeys.Accept)
        request.addValue(UdacityHeaderFieldValue.ApplicationJSON, forHTTPHeaderField: UdacityHeaderFieldsKeys.ContentType)
        request.httpMethod = "POST"
        request.httpBody = network.convertHTTPBodyToData(body: httpBody)
        
        let _ = network.taskForWithRequest(request) { (response, success) in
            completionHandler(response, success)
        }
    }
    
    //MARK: Self Functions
    private func urlFromParameters(_ parameters: [String: Any], withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = UdacityConstants.scheme
        components.host = UdacityConstants.host
        components.path = UdacityConstants.path + (withPathExtension ?? "")
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
