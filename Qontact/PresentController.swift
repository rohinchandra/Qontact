//
//  PresentController.swift
//  Qontact
//
//  Created by Rob chandra on 11/29/18.
//  Copyright © 2018 Rohin chandra. All rights reserved.
//

import UIKit

class PresentController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var imgQRCode: UIImageView!
    var qrcodeImage: CIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func performButtonAction(sender: AnyObject) {
        var qrcodeImage: CIImage!
        if qrcodeImage == nil {
            if textField.text == "" {
                return
            }
            
            let data = textField.text!.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
            
            let filter = CIFilter(name: "CIQRCodeGenerator")
            
            filter!.setValue(data, forKey: "inputMessage")
            filter!.setValue("Q", forKey: "inputCorrectionLevel")
            
            qrcodeImage = filter!.outputImage
            imgQRCode.image = UIImage(ciImage: qrcodeImage)
            textField.resignFirstResponder()
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
