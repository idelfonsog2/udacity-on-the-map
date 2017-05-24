//
//  UdacitySession.swift
//  udacity-on-the-map
//
//  Created by Idelfonso Gutierrez Jr. on 5/23/17.
//  Copyright © 2017 Idelfonso Gutierrez Jr. All rights reserved.
//

import Foundation

struct UdacitySession {
    var uniqueKey: String?
    var sessionId: String?
    
    init(uniqueKey: String?, sessionId: String?) {
        self.uniqueKey = uniqueKey
        self.sessionId = sessionId
    }
    
    init(dictionary: [String: Any]) {
        //Init straigh from JSON
        guard let account = dictionary["account"] as? [String: Any] else {
            return
        }
        
        guard let session = dictionary["session"] as? [String: Any] else {
            return
        }
        
        self.uniqueKey = account["key"] as? String
        self.sessionId = session["id"] as? String
    }
}



