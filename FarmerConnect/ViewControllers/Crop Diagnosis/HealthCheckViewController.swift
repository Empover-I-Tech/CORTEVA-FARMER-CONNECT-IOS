//
//  HealthCheckViewController.swift
//  FarmerConnect
//
//  Created by Apple on 26/12/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class HealthCheckViewController: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
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
    var hint1String = "Don't capture the whole plant. Get closer too the problem and focus on that. Move closer to your crop as much as possible so that the camera can read the problem properly"
    var hint2String = "Make sure your phone camera is focusing on the part where the plant is affected the most. Also make sure thre is enough light and the picture is clear. Photography in dark is not recomended and use flash if necessary"
    
    var actionCount:Int!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var captureBgView: UIView!
    @IBOutlet weak var PageCollectionView: UICollectionView!
    var isCameraOrGaleery = false
    var loaderView : UIView?
    var camImages: [UIImage] = [
        UIImage(named: "Loader_0000")!,
        UIImage(named: "Loader_0001")!,
        UIImage(named: "Loader_0002")!,
        UIImage(named: "Loader_0003")!,
        UIImage(named: "Loader_0004")!,
        UIImage(named: "Loader_0005")!,
        UIImage(named: "Loader_0006")!,
        UIImage(named: "Loader_0007")!,
        UIImage(named: "Loader_0000")!,
        UIImage(named: "Loader_0001")!,
        UIImage(named: "Loader_0002")!,
        UIImage(named: "Loader_0003")!,
        UIImage(named: "Loader_0004")!,
        UIImage(named: "Loader_0005")!,
        UIImage(named: "Loader_0006")!,
        UIImage(named: "Loader_0007")!,
    ]
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.recordScreenView("HealthCheckViewController", Capture_Photo)
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
            
            coordinatePoints = String(format : "%@,%@", String(format : "%f",currentLocation.latitude), String(format : "%f",currentLocation.longitude))
        }
    }
    
    
    //MARK:- VIEW WILL DISAPPEAR
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)        
    }
    
    
    //MARK:- VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.topView?.isHidden = false
        lblTitle?.text = "health_check".localized
        
        //UserDefaults.standard.set(false, forKey: "PeetDontShow")
        
        //CHECK FOR HINT DONT SHOW CONDITION
        if !isCameraOrGaleery {
        if let isPeetDontShow = UserDefaults.standard.value(forKey: "PeetDontShow") as? Bool{
            if isPeetDontShow {
                PageCollectionView.isHidden = true
                captureBgView.isHidden = false
            }
            else{
                actionCount = 0
                PageCollectionView.isHidden = false
                captureBgView.isHidden = true
            }
        }
        }
        else{
            PageCollectionView.isHidden = true
            captureBgView.isHidden = false
        }
    }
    
    
    //MARK:- DONT SHOW HINT VIEW ACTION
    @objc func dontShowAgainAction(_ sender : UIButton){
        UserDefaults.standard.set(true, forKey: "PeetDontShow")
        PageCollectionView.isHidden = true
        captureBgView.isHidden = false
        
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
//        let userObj = Constatnts.getUserObject()
//        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,CROP:cropNameFromCropDiagnosisVC ?? ""]
//        self.registerFirebaseEvents(CDI_Capture_Photo_Hint_OK, "", "", "", parameters: firebaseParams as NSDictionary)
        
        let userObj = Constatnts.getUserObject()
        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "Capture Photo", "Crop" : cropNameFromCropDiagnosisVC ?? ""] as [String : Any]
        self.registerFirebaseEvents(CDI_Capture_Photo_Hint_OK, "", "", "", parameters: firebaseParams as NSDictionary)
        
        
        let attributedString = NSAttributedString(string: "Choose Option", attributes: [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20),
            NSAttributedStringKey.foregroundColor : UIColor.orange
        ])
        alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alertController.setValue(attributedString, forKey: "attributedMessage")
        let sendButton = UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            print("Camera button tapped")
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.camera()
                // firebase Events
                  let userObj = Constatnts.getUserObject()
                let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "Crop Diagnosis Home Page" ,"crop" :self.cropNameFromCropDiagnosisVC ?? "" ] as [String : Any]
                      self.registerFirebaseEvents(CD_Crop_Camera, "", "", "", parameters: firebaseParams as NSDictionary)
            }
            else{
                print("not compatible")
            }
        })
        
        let  deleteButton = UIAlertAction(title: "Gallery", style: .default, handler: { (action) -> Void in
            print("Gallery button tapped")
            self.photoLibrary()
            //let userObj = Constatnts.getUserObject()
            //let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,CROP:self.cropNameFromCropDiagnosisVC ?? ""]
            //self.registerFirebaseEvents(CD_Crop_Gallery, "", "", "", parameters: firebaseParams as NSDictionary)
        })
        let  cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        alertController.addAction(sendButton)
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        isCameraOrGaleery = true
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- Camera Action
    @IBAction func cameraAction(_ sender : UIButton) {
        self.camera()
    }
    
    
    //MARK:- Gallery Button Action
    @IBAction func galleryAction(_ sender : UIButton) {
        self.photoLibrary()
    }
    
    //MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //print(info)
        
        if Reachability.isConnectedToNetwork(){
            
            if let image_data = info[UIImagePickerControllerEditedImage] as? UIImage {
                //yourImageView.contentMode = .scaleAspectFit
                //yourImageView.image = pickedImage
                //let image_data = info[UIImagePickerControllerOriginalImage] as? UIImage
                
                //let imageData:Data = UIImagePNGRepresentation(image_data)!
                //let imageStr = imageData.base64EncodedString()
                
                if let data = UIImagePNGRepresentation(image_data) as Data? {
                    //print("There were \(data.count) bytes")
                    let bcf = ByteCountFormatter()
                    bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
                    bcf.countStyle = .file
                    
                }
                
                let resizedImg = resized(image: image_data)
                if let data1 = UIImagePNGRepresentation(resizedImg!) as Data? {
                    //print("There were \(data1.count) bytes")
                    let bcf = ByteCountFormatter()
                    bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
                    bcf.countStyle = .file
                    
                }
                let imageData:Data = UIImagePNGRepresentation(resizedImg!)!
                //  let imageStr = imageData.base64EncodedString()
            let userObj = Constatnts.getUserObject()
                   let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "CropDiagnosisHintScreen"]
                   self.registerFirebaseEvents(CDI_Capture_Photo_Success, "", "", "", parameters: firebaseParams as NSDictionary)
                
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
        self.isCameraOrGaleery = true
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- uploadingWithMultiPartFormData UPLOAD CAPTURE IMAGE FOR DIAGNOSIS
    func uploadingWithMultiPartFormData(_ imgData : UIImage ){
        let userObj = Constatnts.getUserObject()
        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,]
        self.registerFirebaseEvents(CDI_Peat_Integration_Request, "", "", "", parameters: firebaseParams as NSDictionary)
        
        //UPDATE
        //self.recordScreenView("UploadEVENT", Capture_Photo)
        self.loaderView = CustomAlert.loadingGifPopup(self, frame: self.view.frame , imgLoader: (UIImage(named: "harvest"))!, loaderImgs: camImages) as? UIView
                   let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window?.rootViewController?.view?.addSubview( self.loaderView!)
     //   SwiftLoader.show(animated: true)
        //let image = UIImage(named: "profile_icon.png")!
        
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String,"userType": "Farmer"]
        
        
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
                    self.loaderView?.removeFromSuperview()
                  //  SwiftLoader.hide()
                    //
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
                                         self.isCameraOrGaleery = true
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
                                self.isCameraOrGaleery = true
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
                        self.isCameraOrGaleery = true
                        self.navigationController?.pushViewController(toDiagnosisVC, animated: true)
                        
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                self.view.makeToast(encodingError.localizedDescription)
            }
        })
    }
    
    
    //MARK:- resized image
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

//MARK:- LOCATION SERVICES DELEGATE METHODS
extension HealthCheckViewController : LocationServiceDelegate {
    //MARK: Location service delegate methods
    func tracingLocation(_ currentLocation: CLLocation) {
        //print(String(format : "%f",currentLocation.coordinate.latitude), String(format : "%f",currentLocation.coordinate.longitude))
        locationService.stopUpdatingLocation()
    }
    
    func tracingLocationDidFailWithError(_ error: NSError) {
        
    }
}


//MARK:- UICOLLECTIONVIEW DELEGATE AND DATA SOURCE METHODS
extension HealthCheckViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "healthCheckCell"
        
        let cell : HealthCheckCollectionViewCell = PageCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HealthCheckCollectionViewCell
        
        cell.bgView.dropViewShadow()
        cell.nextBtn.addTarget(self, action: #selector(self.nextAction(_:)), for: .touchUpInside)
        cell.dontShowBtn.addTarget(self, action: #selector(self.dontShowAgainAction(_:)), for: .touchUpInside)
        
        cell.nextBtn.tag = indexPath.row
        
        if indexPath.row == 0{
           
            cell.hintLabel.text = hint1String
            cell.nextBtn.setTitle("Next", for: .normal)
            cell.pagingImage.image = UIImage(named: "PagingCD1")
        }else{
   
            cell.hintLabel.text = hint2String
            cell.nextBtn.setTitle("Got it", for: .normal)
            cell.pagingImage.image = UIImage(named: "PagingCD2")
        
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.PageCollectionView.frame.width - 20, height : 170)//150
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(2, 2, 2, 2)//top,left,bottom,right
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    //
    @objc func nextAction(_ sender: UIButton){
        if sender.tag == 0{
            bgImage.image = UIImage(named: "2Peet.png")
//            let visibleItems: NSArray = self.PageCollectionView.indexPathsForVisibleItems as NSArray
//            if(visibleItems.count>0){
//                let nextItem: IndexPath = IndexPath(item: 1, section: 0)
//                if nextItem.row < 2 {
//                    self.PageCollectionView.scrollToItem(at: nextItem, at: .left, animated: true)
//                }
//            }
            let visibleItems: NSArray = self.PageCollectionView.indexPathsForVisibleItems as NSArray? ?? []
            if(visibleItems.count>0){
                let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
                let nextItem: IndexPath = IndexPath(item: currentItem.item, section: 0)
               // if nextItem.row < 2 {
                    self.PageCollectionView.scrollToItem(at: nextItem, at: .centeredHorizontally, animated: true)
                print("Selected: \(nextItem.row)")
                PageCollectionView.reloadData()
                //}
            }
  
        }
        else{
            let userObj = Constatnts.getUserObject()
            let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,CROP:cropNameFromCropDiagnosisVC ?? ""]
            self.registerFirebaseEvents(CDI_Capture_Photo_Hint_OK, "", "", "", parameters: firebaseParams as NSDictionary)
            UserDefaults.standard.set(true, forKey: "PeetDontShow")
            PageCollectionView.isHidden = true
            captureBgView.isHidden = false
        }
    }
    
}
