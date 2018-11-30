//
//  ScanController.swift
//  Qontact
//
//  Created by Rob chandra on 11/30/18.
//  Copyright © 2018 Rohin chandra. All rights reserved.
//

import UIKit
import AVFoundation
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


class ScanController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet var videoPreview: UIView!
    
    var stringURL = String()
    
    enum error: Error{
        case noCameraAvailable
        case videoInputInitFail
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            
        } catch {
            print("Failed to scan QR Code")
        }

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

    func captureOutput (_ captureOutput: AVCaptureOutput!,
                        didOutputMetadataObjects metadataObjects:[Any]!,
                        from connection: AVCaptureConnection!){
        if metadataObjects.count > 0 {
            let machineReadableCode = metadataObjects [0] as!AVMetadataMachineReadableCodeObject
            if machineReadableCode.type == AVMetadataObject.ObjectType.qr {
                stringURL = machineReadableCode.stringValue!
            }
        }
        
    }
    


}
