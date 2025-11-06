//
//  ImagePreviewController.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 02/05/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class ImagePreviewController: UIViewController {
    
    @IBOutlet weak var imgPreview : UIImageView!
    var imgStr : String  = ""
    var selectedImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if imgStr != "" {
            let url = URL(string:imgStr )
             self.imgPreview?.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceHolderImage"), options: SDWebImageOptions.refreshCached, completed: { (img, error, _,url) in
                 if error != nil {
                    self.imgPreview.image = UIImage(named: "PlaceHolderImage")
                 }else {
                    self.imgPreview.image = img
                 }
             })

        }else {
            self.imgPreview.image = selectedImage
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeBtnAction(_ sender : UIButton){
        self.dismiss(animated: true, completion: nil)
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
