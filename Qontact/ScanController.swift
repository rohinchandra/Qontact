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

// this is a separate helper class for contact integration
// Gets users permission to access contacts book
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
    // AVCapture is a library used to access the iphone camera. If you run this on a simulator,
    // it will not work
    
    // Most of the code in this class was based on code found here https://www.hackingwithswift.com/example-code/media/how-to-scan-a-qr-code
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    @IBOutlet weak var previewView: UIView!
    
    // Will handle errors if no camera is available
    enum error: Error{
        case noCameraAvailable
        case videoInputInitFail
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background to black and start a capture session
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        // Make sure that video session is starting --> return if can't access camera/vido
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        // Set the camera layer to the back to allow buttons to appear over it
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        self.view.layer.insertSublayer(previewLayer, at: 0)
        
        // Start running capture session
        captureSession.startRunning()
    }
    
    // If something fails along the way, call this method
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    // This method actually scans the qr code
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        // If you have a metadataobject, its the qr code. Scan it and get the string value
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            // Create a contact with the string value
            createContact(stringValue)
        }
        
        // Present an alert to the user when a contact is saved successfully
        let alert = UIAlertController(title: "Contact Saved!", message: "Check your contacts to see your new connection", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Exit", style: .default, handler: { action in
            self.performSegue(withIdentifier: "scan_to_home", sender: (Any).self)}))
        self.present(alert, animated: true)
    }
    
    // These functions make it so you hide the status bar and only allow portrait mode. Purely visual
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // This function parses the string contained in the QR code and adds this info to a new contact
    func createContact(_ input: String) {
        // Seperated each value by ::::, so parsing the string here
        let components = input.components(separatedBy: "::::")
        
        let store = CNContactStore()
        // Extracting the data from our input array and adding it to the appropriate place in workingContact
        // First name is first, last name second, phone number third
        let workingContact = CNMutableContact()
        workingContact.givenName = components[0]
        workingContact.familyName = components[1]
        
        let mobilePhone = CNLabeledValue(label: CNLabelPhoneNumberMobile,
                                         value: CNPhoneNumber(stringValue: components[2]))
        workingContact.phoneNumbers = [mobilePhone]
        
        // saving the contact to the contact store
        let request = CNSaveRequest()
        request.add(workingContact, toContainerWithIdentifier: nil)
        do{
            try store.execute(request)
        } catch let err{
            print("Failed to save the contact. \(err)")
        }
    }

}
