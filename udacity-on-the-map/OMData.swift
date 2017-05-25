//
//  OMData.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/24/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import UIKit

class OMData: NSObject {

    //MARK: Properties
    var studentLocations: [StudentLocation] = [StudentLocation]()
    var myStudentLocation: StudentLocation? = nil
    var user: UdacityUser? = nil
    var session: UdacitySession? = nil
    
    class func sharedInstance() -> OMData {
        struct Singleton {
            static var sharedInstance = OMData()
        }
        return Singleton.sharedInstance
    }
}
