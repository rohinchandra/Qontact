//
//  Profile.swift
//  Qontact
//
//  Created by Zachary Dearing on 11/30/18.
//  Copyright © 2018 Rohin chandra. All rights reserved.
//

import Foundation
import os.log

// Profile stores the users given name, family name, and mobile phone number
// This class extends NSObject and NSCoding so that it can be encoded/decoded to allow it to be stored to persistent memory on iPhone
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
        // Initiate the class and save the parameters to the local variables
        self.givenName = givenName
        self.familyName = familyName
        self.mobilePhoneNumber = mobilePhoneNumber
    }
    
    // This function generates the string used to pass the information via QR code
    func encodedString() -> String {
        var encoded: String = self.givenName + "::::" + self.familyName + "::::" + self.mobilePhoneNumber
        return encoded;
    }
    
    // This is an extesnion of NSCoding that provides the necessary implementation to allow the class to be encoded for saving to iOS storage
    func encode(with aCoder: NSCoder) {
        aCoder.encode(givenName, forKey: PropertyKey.givenName)
        aCoder.encode(familyName, forKey: PropertyKey.familyName)
        aCoder.encode(mobilePhoneNumber, forKey: PropertyKey.mobilePhoneNumber)
    }
    
    // This is an extension of NSCoding that allows for decoding of the information and then
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The given name is required. If we cannot decode a given name then, the initializer should fail.
        guard let givenName = aDecoder.decodeObject(forKey: PropertyKey.givenName) as? String else {
            os_log("Unable to decode the given name.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // The family name is required. If we cannot decode a family name then, the initializer should fail.
        guard let familyName = aDecoder.decodeObject(forKey: PropertyKey.familyName) as? String else {
            os_log("Unable to decode the given name.", log: OSLog.default, type: .debug)
            return nil
        }
       
        // The phone number is required. If we cannot decode a phone number then, the initializer should fail.
        guard let mobilePhoneNumber = aDecoder.decodeObject(forKey: PropertyKey.mobilePhoneNumber) as? String else {
            os_log("Unable to decode the given name.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(givenName: givenName, familyName: familyName, mobilePhoneNumber: mobilePhoneNumber)
        
    }
}

// This short class allows profiles to be retrived from UserDefaults storage and unencoded
class profileStorage {
    func getProfilesFromStore() -> Profile?{
        let data = UserDefaults.standard.data(forKey: "SavedProfiles")
        let person =  NSKeyedUnarchiver.unarchiveObject(with: data as Data!) as! Profile
        
        return person
    }
}
