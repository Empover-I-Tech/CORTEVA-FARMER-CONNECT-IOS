//
//  CapturePhotoViewController.swift
//  PioneerEmployee
//
//  Created by Empover on 15/11/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class CapturePhotoViewController: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var alertController = UIAlertController()
    var cropNameFromCropDiagnosisVC:NSString?
    @IBOutlet var imgCaptureInst1 : UIImageView?
    @IBOutlet var imgCaptureInst2 : UIImageView?
    var  weatherJson = ""
    let locationService : LocationService = LocationService()
    var coordinatePoints = ""
    var libMutArrToDisplay = NSMutableArray()
    var diseaseReqIdStr = "0"
    var errorMessage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.recordScreenView("CapturePhotoViewController", Capture_Photo)
        self.registerFirebaseEvents(PV_CDI_Capture_Photo_Hint, "", "", "", parameters:nil)
        
        let userObj = Constatnts.getUserObject()
        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "Capture Photo"]
        self.registerFirebaseEvents(PV_CDI_Capture_Photo_Hint, "", "", "", parameters: firebaseParams as NSDictionary)
        
        if (!CLLocationManager.locationServicesEnabled() || CLLocationManager.authorizationStatus() == .denied)//location details are optional
        {
            //print("location not enabled")
            coordinatePoints = ""
        }
        else{
            locationService.delegate = self
            locationService.locationManager?.requestLocation()
            guard let currentLocation = LocationService.sharedInstance.currentLocation?.coordinate else {
                return
            }
            //print(currentLocation)
            //print(String(format : "%f",currentLocation.latitude), String(format : "%f",currentLocation.longitude))
            //let latitude = String(format : "%f",currentLocation.latitude)
            //let longitude = String(format : "%f",currentLocation.longitude)
            coordinatePoints = String(format : "%@,%@", String(format : "%f",currentLocation.latitude), String(format : "%f",currentLocation.longitude))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.topView?.isHidden = false
        lblTitle?.text = "How to capture photo?"
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
    }
    
    override func backButtonClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func okBtn_Touch_Up_Inside(_ sender: Any) {
        //let attributedString = NSAttributedString(string: "Choose Option", attributes: [
        //NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15),
        //NSAttributedStringKey.foregroundColor : UIColor.orange
        //])
        let userObj = Constatnts.getUserObject()
        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,CROP:cropNameFromCropDiagnosisVC ?? ""]
        self.registerFirebaseEvents(CDI_Capture_Photo_Hint_OK, "", "", "", parameters: firebaseParams as NSDictionary)
        let attributedString = NSAttributedString(string: NSLocalizedString("choose_option", comment: ""), attributes: [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20),
            NSAttributedStringKey.foregroundColor : UIColor.orange
        ])
        alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alertController.setValue(attributedString, forKey: "attributedMessage")
        let sendButton = UIAlertAction(title: NSLocalizedString("camera", comment: ""), style: .default, handler: { (action) -> Void in
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
        let  cancelButton = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        alertController.addAction(sendButton)
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    // Camera Action
    
    @IBAction func cameraAction(_ sender : UIButton) {
        self.camera()
    }
    // Gallery Button Action
    @IBAction func galleryAction(_ sender : UIButton) {
        self.photoLibrary()
    }
    //MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //print(info)
        
        if Reachability.isConnectedToNetwork(){
            
            if let image_data = info[UIImagePickerControllerEditedImage] as? UIImage {
                
                
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
                self.registerFirebaseEvents(CDI_Capture_Photo_Success, "", "", Capture_Photo, parameters: nil)
                
                self.uploadingWithMultiPartFormData(image_data)
            }
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      let userObj = Constatnts.getUserObject()
        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "CropDiagnosisHintScreen"]
        self.registerFirebaseEvents(CDI_Capture_Photo_Cancel, "", "", "", parameters: firebaseParams as NSDictionary)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK : uploadingWithMultiPartFormData
    func uploadingWithMultiPartFormData(_ imgData : UIImage ){
        //SKActivityIndicator.show("Loading...")
        SwiftLoader.show(animated: true)
        //let image = UIImage(named: "profile_icon.png")!
        let userObj = Constatnts.getUserObject()
        
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String,"userType": "Farmer"]
        
        //Soujanya //
        // define parameters
        let parameters = [
            "crop": cropNameFromCropDiagnosisVC!,
            "customerId": userObj.customerId! as String,
            "coordinatePoints": coordinatePoints,
            "weather" : weatherJson
            ] as NSDictionary
        print("parameters : %@",parameters)
        let paramsStr1 = Constatnts.nsobjectToJSON(parameters)
        print(paramsStr1)
        
        Alamofire.upload(multipartFormData: {(multipartFormData) in
            // import image to request
            if let imageData = UIImageJPEGRepresentation(imgData, 1) {
                multipartFormData.append(imageData, withName: "multipartFile", fileName: "image.jpg", mimeType: "image/png")
            }
            multipartFormData.append(paramsStr1.data(using: String.Encoding.utf8)!, withName: "encodedData")
        }, usingThreshold: 60, to: String(format :"%@%@",CDI_BASE_URL,CROP_DIAGNOSIS_MULTIPART), method: .post, headers: headers, encodingCompletion: {(encodeResult) in
            switch encodeResult {
            case .success(let upload, _, _):
                upload.validate().responseJSON { response in
                    //SKActivityIndicator.dismiss()
                    SwiftLoader.hide()
                    //debugPrint(response)
                    print(response)
                    if response.result.error == nil{
                        if let json = response.result.value{
                            print(json)
                            let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                            if responseStatusCode == STATUS_CODE_200{
                                
                                if Validations.isNullString(((json as! NSDictionary).value(forKey: "response") as! NSString).replacingOccurrences(of: "\\", with: "") as NSString) == false{
                                    let respData = ((json as! NSDictionary).value(forKey: "response") as! NSString).replacingOccurrences(of: "\\", with: "")
                                    let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                                    print("decryptData :\(decryptData)")
                                    /*if let diseaseReqIdObj = decryptData.value(forKey: "id") as? Int {
                                     self.diseaseReqIdStr = String(format: "%d",diseaseReqIdObj)
                                     }*/
                                    if let resultArray = decryptData.value(forKey: "cropDiagnosisResponseDTO")! as? NSArray{
                                        self.libMutArrToDisplay.removeAllObjects()
                                        for i in 0 ..< resultArray.count{
                                            let libraryDic = resultArray.object(at: i) as? NSDictionary
                                            
                                            if let diseaseReqIdObj = libraryDic?.value(forKey: "diseaseId") as? Int {
                                                if self.diseaseReqIdStr == "0"{
                                                    self.diseaseReqIdStr = String(format: "%d",diseaseReqIdObj)
                                                }
                                            }
                                            let cropDiagnosisLib = CropDiagnosisLibrary(dict: libraryDic!)
                                            self.libMutArrToDisplay.add(cropDiagnosisLib)
                                        }
                                        let toDiagnosisVC = self.storyboard?.instantiateViewController(withIdentifier: "DiagnosisViewController") as! DiagnosisViewController
                                        toDiagnosisVC.weatherJson = self.weatherJson
                                        toDiagnosisVC.diseaseReqIdStr = self.diseaseReqIdStr
                                        toDiagnosisVC.libMutArrToDisplay = self.libMutArrToDisplay
                                        toDiagnosisVC.errorMessage = self.errorMessage
                                        self.navigationController?.pushViewController(toDiagnosisVC, animated: true)
                                        
                                    }
                                }
                            }else if responseStatusCode == STATUS_CODE_601{
                                Constatnts.logOut()
                                if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                    print(msg)
                                    self.errorMessage = msg as String
                                }
                            }else {
                                if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                                                   print(msg)
                                                                   self.errorMessage = msg as String
                                                               }
                                let toDiagnosisVC = self.storyboard?.instantiateViewController(withIdentifier: "DiagnosisViewController") as! DiagnosisViewController
                                toDiagnosisVC.weatherJson = self.weatherJson
                                toDiagnosisVC.diseaseReqIdStr = self.diseaseReqIdStr
                                toDiagnosisVC.libMutArrToDisplay = self.libMutArrToDisplay
                                toDiagnosisVC.errorMessage = self.errorMessage
                                self.navigationController?.pushViewController(toDiagnosisVC, animated: true)
                            }
                        }
                    }
                    else{
                      //  self.view.makeToast((response.result.error?.localizedDescription)!, duration: 1.0, position: .center)
                        let toDiagnosisVC = self.storyboard?.instantiateViewController(withIdentifier: "DiagnosisViewController") as! DiagnosisViewController
                            toDiagnosisVC.weatherJson = self.weatherJson
                            toDiagnosisVC.diseaseReqIdStr = self.diseaseReqIdStr
                            toDiagnosisVC.libMutArrToDisplay = self.libMutArrToDisplay
                        toDiagnosisVC.errorMessage = "Disease could not be Identified"
                        self.navigationController?.pushViewController(toDiagnosisVC, animated: true)
                        
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                self.view.makeToast(encodingError.localizedDescription)
            }
        })
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension CapturePhotoViewController : LocationServiceDelegate {
    //MARK: Location service delegate methods
    func tracingLocation(_ currentLocation: CLLocation) {
        //print(String(format : "%f",currentLocation.coordinate.latitude), String(format : "%f",currentLocation.coordinate.longitude))
        locationService.stopUpdatingLocation()
    }
    
    func tracingLocationDidFailWithError(_ error: NSError) {
        
    }
}
