//
//  UMNetworking.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/23/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import UIKit

class UMNetworking: NSObject {

    let session = URLSession.shared
    
    func taskForWithRequest(_ request: NSMutableURLRequest, completionHandler: @escaping(_ results: AnyObject?, _ success: Bool) -> Void) -> URLSessionDataTask {
        
        // DataTask
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in

            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                completionHandler("There was an error with your request: \(String(describing: error))" as AnyObject, false)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                completionHandler("No status code" as AnyObject, false)
                return
            }
            
            //Udacity Exception
            guard statusCode != 403 else {
                completionHandler(403 as AnyObject, false)
                return
            }
            
            guard statusCode >= 200 && statusCode <= 299 else {
                completionHandler("Your request returned a status code other than 2xx!" as AnyObject, false)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completionHandler("No data was returned by the request!" as AnyObject, false)
                return
            }
            
            // Udacity vs Parse Data
            if request.url?.host == UdacityConstants.host {
                let range = Range(5..<data.count)
                let newData = data.subdata(in: range) /* subset response data! */
                self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandler)
            } else {
                self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandler)
            }
        }
        
        task.resume()
        
        return task
    }
    
    
    // Substitute the key for the value that is contained within the method name
    public func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }

    // Given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ success: Bool) -> Void) {
        var parsedResult: AnyObject?
        
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            completionHandlerForConvertData("Could not parse the data as JSON: '\(data)'" as AnyObject, false)
        }
        
        print(parsedResult)
        completionHandlerForConvertData(parsedResult, true)
    }
    
    // Convert dictionary to Data Object
    func convertHTTPBodyToData(body: [String: Any]) -> Data {
        var data: Data = Data()
        do {
            data = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch {
            print(error.localizedDescription)
        }
        return data
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> UMNetworking {
        struct Singleton {
            static var sharedInstance = UMNetworking()
        }
        return Singleton.sharedInstance
    }

}
