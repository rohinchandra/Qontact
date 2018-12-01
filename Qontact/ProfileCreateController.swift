//
//  ProfileCreateController.swift
//  Qontact
//
//  Created by Rob chandra on 11/30/18.
//  Copyright © 2018 Rohin chandra. All rights reserved.
//

import UIKit

class ProfileCreateController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var phoneNumber: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveProfile(_ sender: Any) {
        // NEED TO ADDRESS LATER THE FORCE UNWRAPPING BY CHECKING FULL NIL VALUES --Zac to do
        
        var profile = Profile(givenName: firstName.text!, familyName: lastName.text!, mobilePhoneNumber: phoneNumber.text!)
        print(profile.encodedString())

        var data = try! NSKeyedArchiver.archivedData(withRootObject: profile, requiringSecureCoding: false)
        UserDefaults.standard.set(data, forKey: "SavedProfiles")
        print(data)
        
        var storage: profileStorage = profileStorage()
        storage.getProfilesFromStore()
        print("end")
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
