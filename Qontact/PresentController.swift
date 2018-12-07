//
//  PresentController.swift
//  Qontact
//
//  Created by Rob chandra on 11/29/18.
//  Copyright © 2018 Rohin chandra. All rights reserved.
//

import UIKit

class PresentController: UIViewController {

    // This is where the QR code will be displayed
    @IBOutlet weak var imgQRCode: UIImageView!
    
    // Storing the qr code image here before displaying it
    var qrcodeImage: CIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Getting profile from storage
        var storage: profileStorage = profileStorage()
        let savedProfile: Profile? = storage.getProfilesFromStore()
        if (savedProfile == nil)
        {
            // Profile doesn't exist, go to ProfileCreateController
            performSegue(withIdentifier: "present_to_profileCreate", sender: (Any).self);
        } else {
            // Saved Profile exists, generate QR code
            // Got much of this code from here: https://www.appcoda.com/qr-code-generator-tutorial/
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
