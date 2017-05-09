//
//  PSClient.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/9/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import UIKit

class PSClient: NSObject {
    
    let session = URLSession.shared
    
    func taskForGETmethod(parameters: [String : Any], completionHandlerForGET: @escaping (_ success: AnyObject?, _ data: AnyObject?) -> Void) {
        let url = urlFromParameters(parameters)
        let request = NSMutableURLRequest(url: url)
        request.addValue(ParseHeaderFieldsValues.ParseAppIDValue, forHTTPHeaderField: ParseHeaderFieldsKeys.ParseAppIDKey)
        request.addValue(ParseHeaderFieldsValues.RestApiKeyValue, forHTTPHeaderField: ParseHeaderFieldsKeys.ParseRestKey)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
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
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        task.resume()
        
    }
    
    func taskForPOSTmethod(parameters: [String: Any], completionHandler: @escaping (_ success: Bool, _ data: Any)-> Void) {
        //do something
    }
    
    func urlFromParameters(_ params: [String : Any]) -> URL {
        var components = URLComponents(string: ParseConstants.baseURL)
        components?.queryItems = [URLQueryItem]()
        
        for (key, value) in params {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components?.queryItems?.append(queryItem)
        }
        return (components?.url)!
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
}
