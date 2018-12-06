//
//  ProfileCreateController.swift
//  Qontact
//
//  Created by Rob chandra on 11/30/18.
//  Copyright © 2018 Rohin chandra. All rights reserved.
//

import UIKit

class ProfileCreateController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var phoneNumber: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Check to see if a Saved Profile already exists and if so populate hte fields with the stored values
        if (UserDefaults.standard.object(forKey: "SavedProfiles") != nil)
        {
            // Retrieve stored Profile
            let storage: profileStorage = profileStorage()
            let savedProfile: Profile? = storage.getProfilesFromStore()
            
            // Populate fields with stored values
            firstName.text = savedProfile?.givenName
            lastName.text = savedProfile?.familyName
            phoneNumber.text = savedProfile?.mobilePhoneNumber
        }
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == firstName {
            firstName.resignFirstResponder()
            lastName.becomeFirstResponder()
        } else if textField == lastName {
            lastName.resignFirstResponder()
            phoneNumber.becomeFirstResponder()
        } else if textField == phoneNumber {
            phoneNumber.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func saveProfile(_ sender: Any) {
        // NEED TO ADDRESS LATER THE FORCE UNWRAPPING BY CHECKING FULL NIL VALUES --Zac to do
        
        var profile = Profile(givenName: firstName.text!, familyName: lastName.text!, mobilePhoneNumber: phoneNumber.text!)

        var data = try! NSKeyedArchiver.archivedData(withRootObject: profile, requiringSecureCoding: false)
        UserDefaults.standard.set(data, forKey: "SavedProfiles")
        
        performSegue(withIdentifier: "profile_to_home", sender: (Any).self);
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
