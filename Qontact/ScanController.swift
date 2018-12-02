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

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    @IBOutlet weak var previewView: UIView!
    
    enum error: Error{
        case noCameraAvailable
        case videoInputInitFail
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
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
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        self.view.layer.insertSublayer(previewLayer, at: 0)
        
        captureSession.startRunning()
    }
    
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
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            createContact(stringValue)
        }
        
        let alert = UIAlertController(title: "Contact Saved!", message: "Check your contacts to see your new connection", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Exit", style: .default, handler: { action in
            self.performSegue(withIdentifier: "scan_to_home", sender: (Any).self)}))
        self.present(alert, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func createContact(_ input: String) {
        var components = input.components(separatedBy: "::::")
        print(components)
        
        var store = CNContactStore()
        
        var workingContact = CNMutableContact()
        workingContact.givenName = components[0]
        workingContact.familyName = components[1]
        
        var mobilePhone = CNLabeledValue(label: CNLabelPhoneNumberMobile,
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
