//
//  PresentController.swift
//  Qontact
//
//  Created by Rob chandra on 11/29/18.
//  Copyright © 2018 Rohin chandra. All rights reserved.
//

import UIKit

class PresentController: UIViewController {

//    @IBOutlet weak var textField: UITextField!
//    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var imgQRCode: UIImageView!
    
    var qrcodeImage: CIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var storage: profileStorage = profileStorage()
        let savedProfile: Profile? = storage.getProfilesFromStore()
        if (savedProfile == nil)
        {
            // Profile doesn't exist, go to ProfileCreateController
            performSegue(withIdentifier: "present_to_profileCreate", sender: (Any).self);
        } else {
            // Saved Profile exists, generate QR code
            // savedProfile!.encodedString()
            var qrcodeImage: CIImage!
            if qrcodeImage == nil {
                let data = savedProfile!.encodedString().data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
                let filter = CIFilter(name: "CIQRCodeGenerator")
                
                filter!.setValue(data, forKey: "inputMessage")
                filter!.setValue("Q", forKey: "inputCorrectionLevel")
                
                qrcodeImage = filter!.outputImage
                imgQRCode.image = UIImage(ciImage: qrcodeImage)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
//    func displayQRCodeImage() {
//        let scaleX = imgQRCode.frame.size.width / qrcodeImage.extent().size.height
//        let scaleY = imgQRCode.frame.size.height / qrcodeImage.extent().size.width
//
//        let transformedImage = qrcodeImage.imageByApplyingTransform(CGAffineTransformMakeScale(scaleX, scaleY))
//
//        imgQRCode.image = UIImage(CIImage: transformedImage)
//
//    }
    
    
//    @IBAction func performButtonActionWithSender(_ sender: UIButton) {
//        var qrcodeImage: CIImage!
//        if qrcodeImage == nil {
//            if textField.text == "" {
//                return
//            }
//
//            let data = textField.text!.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
//
//            let filter = CIFilter(name: "CIQRCodeGenerator")
//
//            filter!.setValue(data, forKey: "inputMessage")
//            filter!.setValue("Q", forKey: "inputCorrectionLevel")
//
//            qrcodeImage = filter!.outputImage
//            imgQRCode.image = UIImage(ciImage: qrcodeImage)
//            textField.resignFirstResponder()
//        }
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
