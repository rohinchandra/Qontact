//
//  ScanController.swift
//  Qontact
//
//  Created by Rob chandra on 11/30/18.
//  Copyright © 2018 Rohin chandra. All rights reserved.
//

import UIKit
import AVFoundation

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
