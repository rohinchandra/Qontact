//
//  ScanController.swift
//  Qontact
//
//  Created by Rob chandra on 11/30/18.
//  Copyright © 2018 Rohin chandra. All rights reserved.
//

import UIKit

import Contacts

// this is a separate helper class
public final class ContactAuthorizer{
    public class func authorizeContacts(completionHandler
        : @escaping (_ succeeded: Bool) -> Void){
        switch CNContactStore.authorizationStatus(for: .contacts){
        case .authorized:
            completionHandler(true)
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts){succeeded, err in
                completionHandler(err == nil && succeeded)
            }
        default:
            completionHandler(false)
        }
    }
}

class ScanController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func SaveButton(_ sender: UIButton) {
        print("test")
        ContactAuthorizer.authorizeContacts {succeeded in
            if succeeded{
                self.createContact()
            } else{
                print("Not handled")
            }
        }
    }
    
    func createContact() {
        var store = CNContactStore()
        
        let fooBar = CNMutableContact()
        fooBar.givenName = "Foo"
        fooBar.middleName = "A."
        fooBar.familyName = "Bar"
        fooBar.nickname = "Fooboo"
        
        // saving the contact to the contact store
        let request = CNSaveRequest()
        request.add(fooBar, toContainerWithIdentifier: nil)
        do{
            try store.execute(request)
            print("Successfully stored the contact")
        } catch let err{
            print("Failed to save the contact. \(err)")
        }
    }

}
