//
//  Profile.swift
//  Qontact
//
//  Created by Zachary Dearing on 11/30/18.
//  Copyright © 2018 Rohin chandra. All rights reserved.
//

import Foundation
import os.log

class Profile: NSObject, NSCoding {
    //MARK Properties
    var givenName: String
    var familyName: String
    var mobilePhoneNumber: String
    
    //MARK: Types
    struct PropertyKey {
        static let givenName = "givenName"
        static let familyName = "familyName"
        static let mobilePhoneNumber = "mobilePhoneNumber"
    }
    
    
    //MARK: Initialization
    init(givenName: String, familyName: String, mobilePhoneNumber: String) {
        self.givenName = givenName
        self.familyName = familyName
        self.mobilePhoneNumber = mobilePhoneNumber
    }
    
    func encodedString() -> String {
        var encoded: String = self.givenName + "::::" + self.familyName + "::::" + self.mobilePhoneNumber
        return encoded;
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(givenName, forKey: PropertyKey.givenName)
        aCoder.encode(familyName, forKey: PropertyKey.familyName)
        aCoder.encode(mobilePhoneNumber, forKey: PropertyKey.mobilePhoneNumber)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let givenName = aDecoder.decodeObject(forKey: PropertyKey.givenName) as? String else {
            os_log("Unable to decode the given name.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // required in order for this to run
        guard let familyName = aDecoder.decodeObject(forKey: PropertyKey.familyName) as? String else {
            os_log("Unable to decode the given name.", log: OSLog.default, type: .debug)
            return nil
        }
       
        // required in order for this to run
        guard let mobilePhoneNumber = aDecoder.decodeObject(forKey: PropertyKey.mobilePhoneNumber) as? String else {
            os_log("Unable to decode the given name.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(givenName: givenName, familyName: familyName, mobilePhoneNumber: mobilePhoneNumber)
        
    }
}

class profileStorage {
    func getProfilesFromStore(){
        let data = UserDefaults.standard.value(forKey: "data")
        let person =  NSKeyedUnarchiver.unarchiveObject(with: data as! Data)
        print(person)
    }
}
