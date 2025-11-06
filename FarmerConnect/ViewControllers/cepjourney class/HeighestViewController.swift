//
//  HeighestViewController.swift
//  FarmerConnect
//
//  Created by EMPOVER-049 on 30/08/21.
//  Copyright © 2021 ABC. All rights reserved.
//

import UIKit
import Alamofire

class HeighestViewController: BaseViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var selectedLbl: UILabel!
    @IBOutlet weak var scanImg: UIImageView!
    @IBOutlet weak var uploadscan_lbl: UILabel!
    @IBOutlet weak var documentProof_btn: UIButton!
    @IBOutlet weak var txt_totalYield: UITextField!
    @IBOutlet weak var totalArea_txtfield: UITextField!
    @IBOutlet weak var lbl_totalYield: UILabel!
    @IBOutlet weak var totalAreaGrown_lbl: UILabel!
    @IBOutlet weak var scrollview: UIScrollView!
    var alertController = UIAlertController()
    var isImageSelected = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func Validation()-> Bool{
       
        
        if totalArea_txtfield.text == ""{
            self.view.makeToast(NSLocalizedString("Cep_heighest_riceGrown_Enter", comment: ""))
            return false
        }
        else if  txt_totalYield.text == ""{
            self.view.makeToast(NSLocalizedString("cep_totalYield_inquintal", comment: ""))
            return false
        }
        else if !isImageSelected{
            self.view.makeToast(NSLocalizedString("choose_image", comment: ""))
            return false
        }
        return true
    }
    //CEP_fIELDSHARING
    @IBAction func submitAction(_ sender: Any) {
        let isvalid = Validation()
        if isvalid{
        let deviceID = UIDevice.current.identifierForVendor!.uuidString.replacingOccurrences(of: "-", with: "") as String
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            
            let userObj = Constatnts.getUserObject()
            let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,]
            self.registerFirebaseEvents(PV_CEP_Update_Profile_Submit, "", "", "", parameters: firebaseParams as NSDictionary)
            self.recordScreenView("HeighestViewController", "HeighestViewController")
            
            let currentTime = Constatnts.getCurrentMillis()
            let imgFileName = String(currentTime).replacingOccurrences(of: "-", with: "")
            let strSubmitted = String(format:"%@.jpg",imgFileName)
            let dic : NSDictionary = [
                "imagePath": strSubmitted,
                "totalAreaRice": totalArea_txtfield.text ?? "",
                "totalYield": txt_totalYield.text ?? ""
            ]
            
            let paramsDic = NSMutableDictionary(dictionary: dic)
            paramsDic.setValue(userObj.deviceToken, forKey: "deviceToken")
            let paramsStr = Constatnts.nsobjectToJSON(paramsDic as NSDictionary)
            let params =  ["data" : paramsStr]
            print(params)
            let net = NetworkReachabilityManager(host: "www.google.com")
            if net?.isReachable == true{
                DispatchQueue.main.async {
                    self.uploadingWithMultiPartFormData(paramsStr, ImageName: strSubmitted)
                }
            }
            
        }
        }
    }
    
    //MARK:- uploadingWithMultiPartFormData UPLOAD CAPTURE IMAGE FOR
    func uploadingWithMultiPartFormData( _ str : String, ImageName: String){
        let userObj = Constatnts.getUserObject()
        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,]
        //   self.registerFirebaseEvents(CDI_Peat_Integration_Request, "", "", "", parameters: firebaseParams as NSDictionary)
        
        //UPDATE
        //self.recordScreenView("UploadEVENT", Capture_Photo)
        
        SwiftLoader.show(animated: true)
        //let image = UIImage(named: "profile_icon.png")!
        
        let params = ["data" : str]
        //let paramsStr = Constatnts.nsobjectToJSON(params as NSDictionary)
        let data = NSKeyedArchiver.archivedData(withRootObject: params)
        
        var stringAPI = ""
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(params) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
                stringAPI = jsonString
            }
        }
        
        print(data)
        let headers: HTTPHeaders = [
            "userAuthorizationToken": userObj.userAuthorizationToken! as String,
            "mobileNumber": userObj.mobileNumber! as String,
            "customerId": userObj.customerId! as String,
            "deviceId": userObj.deviceId! as String]
        
   
        Alamofire.upload(multipartFormData: {(multipartFormData) in
            multipartFormData.append(stringAPI.data(using: String.Encoding.utf8)!, withName: "encodedData")
        
            // import image to request
           // DispatchQueue.main.async {
            
                if let imageData = UIImageJPEGRepresentation(self.scanImg.image ?? UIImage(), 1) {
                    multipartFormData.append(imageData, withName: "multipartFile", fileName: ImageName, mimeType: "image/png")
                }
            //}
        }, usingThreshold: 60, to: String(format :"%@%@",BASE_URL,CEP_HEIGHEST_YIELD_COMPETITION), method: .post, headers: headers, encodingCompletion: {(encodeResult) in
            switch encodeResult {
            case .success(let upload, _, _):
                upload.validate().responseJSON { response in
                    
                    
                    SwiftLoader.hide()
                    //
                    //debugPrint(response)
                    print(response)
                    if response.result.error == nil{
                        if let json = response.result.value{
                            print(json)
                            let responseStatusCode = (json as? NSDictionary)?.value(forKey: "statusCode") as? String ?? ""
                            if responseStatusCode == STATUS_CODE_200{
                                // self.registerFirebaseEvents(PV_CEP_profile_update_success, "", "", "", parameters: firebaseParams as NSDictionary)
                                
                                let okStr = NSLocalizedString("ok", comment: "")//
                                let msgStr = NSLocalizedString("Submitted_Successfully", comment: "")
                                //                            UIApplication.shared.keyWindow?.makeToast(msg as String)
                                let alert = UIAlertController(title: "", message: msgStr, preferredStyle: .alert)
                                let alertAction = UIAlertAction(title: okStr, style: .default, handler: { (al) in
                                    self.navigationController?.popViewController(animated: true)
                                })
                                alert.addAction(alertAction)
                                self.present(alert, animated: true, completion: nil)
                                
                                
                            }else if responseStatusCode == STATUS_CODE_601{
                                Constatnts.logOut()
                                if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                    print(msg)
                                    self.view.makeToast(msg as String)
                                }
                            }
                            else {  }
                        }
                    }
                    else{
                        //                        self.registerFirebaseEvents(PV_CEP_profile_update_failure, "", "", "", parameters: firebaseParams as NSDictionary)
                        //                        self.view.makeToast(response.result.error?.localizedDescription ?? "")
                        
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                self.registerFirebaseEvents(PV_CEP_profile_update_failure, "", "", "", parameters: firebaseParams as NSDictionary)
                self.view.makeToast(encodingError.localizedDescription)
            }
        })
    }
    
    
    
    
    @IBAction func scanButtonAction(_ sender: Any) {
        let userObj = Constatnts.getUserObject()
        // let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,CROP:cropNameFromCropDiagnosisVC ?? ""]
        //        self.registerFirebaseEvents(CDI_Capture_Photo_Hint_OK, "", "", "", parameters: firebaseParams as NSDictionary)
        let attributedString = NSAttributedString(string: NSLocalizedString("choose_option", comment: ""), attributes: [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20),
            NSAttributedStringKey.foregroundColor : UIColor.orange
        ])
        alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alertController.setValue(attributedString, forKey: "attributedMessage")
        let sendButton = UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            print("Camera button tapped")
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.camera()
                //let userObj = Constatnts.getUserObject()
                //let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,CROP:self.cropNameFromCropDiagnosisVC ?? ""]
                //self.registerFirebaseEvents(CD_Crop_Camera, "", "", "", parameters: firebaseParams as NSDictionary)
            }
            else{
                print("not compatible")
            }
        })
        
        let  deleteButton = UIAlertAction(title: NSLocalizedString("gallery", comment: ""), style: .default, handler: { (action) -> Void in
            print("Gallery button tapped")
            self.photoLibrary()
            //let userObj = Constatnts.getUserObject()
            //let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,CROP:self.cropNameFromCropDiagnosisVC ?? ""]
            //self.registerFirebaseEvents(CD_Crop_Gallery, "", "", "", parameters: firebaseParams as NSDictionary)
        })
        let  cancelButton = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        alertController.addAction(sendButton)
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    //MARK: camera
    func camera()
    {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.allowsEditing = true
        myPickerController.sourceType = UIImagePickerControllerSourceType.camera
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    //MARK: photo library
    func photoLibrary()
    {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.allowsEditing = true
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.topView?.isHidden = false
        self.homeButton?.isHidden = true
        
        self.lblTitle?.text = NSLocalizedString("cep_Heighest_yield_Compltetion", comment: "")
        
        self.totalAreaGrown_lbl?.text = NSLocalizedString("Cep_heighest_riceGrown", comment: "")
        self.lbl_totalYield?.text = NSLocalizedString("cep_totalYield_inquintal", comment: "")
        self.documentProof_btn.setTitle(NSLocalizedString("Document_proof_cep", comment: ""), for: .normal)
        self.uploadscan_lbl?.text = NSLocalizedString("Upload_screen_copy_MandyRecipt", comment: "")
        self.btnSubmit.setTitle(NSLocalizedString("submit", comment: "").uppercased(), for: .normal)
        self.selectedLbl?.text = NSLocalizedString("Cep_Hieghest_Selectedentries", comment: "")
        
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        // self.bgScroll.delaysContentTouches = false
        // self.bgScroll.canCancelContentTouches = false
        
        
    }
    
    //MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
 
        if let image_data = info[UIImagePickerControllerEditedImage] as? UIImage {
            scanImg.image = image_data
        }
        if Reachability.isConnectedToNetwork(){
            isImageSelected = true
            if let image_data = info[UIImagePickerControllerEditedImage] as? UIImage {
                scanImg.image = image_data
                
                if let data = UIImagePNGRepresentation(image_data) as Data? {
                    //print("There were \(data.count) bytes")
                    let bcf = ByteCountFormatter()
                    bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
                    bcf.countStyle = .file
                    let string = bcf.string(fromByteCount: Int64(data.count))
                    //print("original image size: \(string)")
                }
                
                let resizedImg = resized(image: image_data)
                
                if let data1 = UIImagePNGRepresentation(resizedImg!) as Data? {
                    //print("There were \(data1.count) bytes")
                    let bcf = ByteCountFormatter()
                    bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
                    bcf.countStyle = .file
                    let string = bcf.string(fromByteCount: Int64(data1.count))
                    //print("resized image size: \(string)")
                }
                let imageData:Data = UIImagePNGRepresentation(resizedImg!)!
                let imageStr = imageData.base64EncodedString()
                // self.registerFirebaseEvents(CDI_Capture_Photo_Success, "", "", Capture_Photo, parameters: nil)
                
                // self.uploadingWithMultiPartFormData(image_data)
            }
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                dismiss(animated: false) { [self] in
                    self.scanImg.image = image
                    
                }
            }
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: resized image
    func resized (image: UIImage) -> UIImage?{
        var actualHeight: Float = Float(image.size.height)
        var actualWidth: Float = Float(image.size.width)
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = 320.0 / 480.0
        if imgRatio != maxRatio {
            if imgRatio < maxRatio {
                imgRatio = 480.0 / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = 480.0
            }
            else {
                imgRatio = 320.0 / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = 320.0
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData:Data = UIImageJPEGRepresentation(img!, 1)!
        UIGraphicsEndImageContext()
        return UIImage(data: imageData)!
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        let userObj = Constatnts.getUserObject()
        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "HeighestViewController"]
      //  self.registerFirebaseEvents(CEP_Capture_Photo_Cancel, "", "", "", parameters: firebaseParams as NSDictionary)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
