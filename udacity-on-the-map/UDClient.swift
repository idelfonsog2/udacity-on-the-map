//
//  UDClient.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/9/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import UIKit

class UDClient: NSObject {
    
    let session = URLSession.shared
    var appDelegate: AppDelegate?
    
    func logoutFromUdacity() {
        let request = NSMutableURLRequest(url: URL(string: UdacityConstants.baseURL)!)
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

        let task = session.dataTask(with: request as URLRequest) {
            data, response, error in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                print(NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }
    
    func getUserPublicData(userId: String, completionHandlerForGET: @escaping (_ result: Any?, _ success: Bool) -> Void) {
        
        // GET
        let url = URL(string: UdacityConstants.baseURL+"/\(userId)")!
        let request = NSMutableURLRequest(url: url)
        
        // DataTask
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo), false)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */

            //TODO: obtain values from JSON
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        task.resume()
        
    }

    
    func getSessionId(httpBody: [String: Any], completionHandlerForPOST: @escaping (_ result: Any?, _ success: Bool) -> Void) {
        
        // POST:
        let url = urlFromParameters([:])
        let request = NSMutableURLRequest(url: url)
        request.addValue(UdacityHeaderFieldValue.ApplicationJSON , forHTTPHeaderField: UdacityHeaderFieldsKeys.Accept)
        request.addValue(UdacityHeaderFieldValue.ApplicationJSON, forHTTPHeaderField: UdacityHeaderFieldsKeys.ContentType)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: httpBody, options: .prettyPrinted)
        } catch {
            print(error.localizedDescription)
        }
        
        // DataTask
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            // Error Function
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo), false)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            //TODO: obtain values from JSON
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
        }
        task.resume()
    }
    
    public func urlFromParameters(_ params: [String : Any]) -> URL {
        var components = URLComponents()
        components.scheme   = UdacityConstants.scheme
        components.host     = UdacityConstants.host
        components.path     = UdacityConstants.path
        
        if !params.isEmpty {
            components.queryItems = [URLQueryItem]()
            for (key, value) in params {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems?.append(queryItem)
            }
        }
        
        return components.url!
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: Any?, _ success: Bool) -> Void) {
        
        // Error Function
//        func sendError(_ error: String) {
//            print(error)
//            completionHandlerForConvertData(nil, false)
//        }

        var parsedResult: AnyObject! = nil
        
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "completionHandlerForConvertData"]
            completionHandlerForConvertData("Could not parse the data as JSON: '\(data)'" as AnyObject, false)
        }
        
        //TODO: delete this statement
        //print(parsedResult)
        
        guard parsedResult != nil else {
            print("parsedResult == nil")
            completionHandlerForConvertData(nil, false)
            return
        }
        
        guard let accountDicionary = parsedResult?["account"] as? [String: Any] else {
            print("no 'account' key found")
            completionHandlerForConvertData(nil, false)
            return
        }
        
        guard let registered = accountDicionary["registered"] as? Bool else {
            print("no 'registered' key found")
            completionHandlerForConvertData(nil, false)
            return
        }
        
        guard let session = parsedResult?["session"] as? [String: Any] else {
            print("no 'session' key found")
            completionHandlerForConvertData(nil, false)
            return
        }
        
        guard let id = session["id"] as? String else {
            print("no 'id' key found")
            completionHandlerForConvertData(nil, false)
            return
        }
        
        self.appDelegate?.sessionId = id
        
        completionHandlerForConvertData(registered as Any, true)
    }

}
