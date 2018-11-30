//
//  Profile.swift
//  Qontact
//
//  Created by Zachary Dearing on 11/30/18.
//  Copyright © 2018 Rohin chandra. All rights reserved.
//

import Foundation

class Profile {
    //MARK Properties
    var givenName: String
    var familyName: String
    var mobilePhoneNumber: String
    var email: String
    
    //MARK: Initialization
    init(givenName: String, familyName: String, mobilePhoneNumber: String, _ emailAddress: String?=nil) {
        self.givenName = givenName
        self.familyName = familyName
        self.mobilePhoneNumber = mobilePhoneNumber
        
        if emailAddress == nil {
            self.email = ""
        } else {
            self.email = emailAddress!
        }
    }
    
    func encodedString() -> String {
        var encoded: String = self.givenName + "::::" + self.familyName + "::::" + self.mobilePhoneNumber
        return encoded;
    }
    
}
