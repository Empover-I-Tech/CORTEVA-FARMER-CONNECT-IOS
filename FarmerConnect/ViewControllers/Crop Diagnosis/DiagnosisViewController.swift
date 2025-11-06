//
//  DiagnosisViewController.swift
//  PioneerEmployee
//
//  Created by Empover on 15/11/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import UIKit
import Alamofire

extension UIImageView {
    func downloadedFrom(url: URL,placeHolder:UIImage?, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    guard let placeHolderImage = placeHolder else{
                        return
                    }
                    DispatchQueue.main.async {
                        self.image = placeHolderImage
                    }
                    return
            }
            DispatchQueue.main.async() {() -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String,placeHolder:UIImage?, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url,placeHolder:placeHolder, contentMode: mode)
    }
}

extension Double {
    // Rounds the double to decimal places value
    mutating func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
}

extension Float
{
    var cleanValue: String
    {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

//extension Float {
//    func cleanValue() -> String {
//        let intValue = Int(self)
//        if self == 0 {return "0"}
//        if self / Float (intValue) == 1 { return "\(intValue)" }
//        return "\(self)"
//    }
//}

class DiagnosisViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,LocationServiceDelegate {

    @IBOutlet weak var diagnosisTblView: UITableView!
    
    @IBOutlet weak var errorLbl: UILabel!
    
    @IBOutlet weak var feedbackView: UIView!
    
    @IBOutlet weak var txtFldFeedbackDiseaseName: UITextField!
    
    @IBOutlet weak var feedbackLikeBtn: UIButton!
    
    @IBOutlet weak var feedbackUnlikeBtn: UIButton!
    
    @IBOutlet weak var feedbackSubmitBtn: UIButton!
    
    @IBOutlet weak var diagnosisTblViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var feedbackViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var footerView: UIView?
    
    @IBOutlet weak var lblFeedbackTitle: UILabel!
    
    @IBOutlet weak var lblCustomercareNumber: ActiveLabel!
    
    var libMutArrToDisplay = NSMutableArray()
    var feedbackLikeBtnStr = ""
    
    var isCmgFromCapturePhotoVC : Bool = false
    var imgBase64StrFromCapturePhotoVC : NSString?
    var cropNameFromCapturePhotoVC : NSString?
    var diseaseReqIdStr = "0"
    
    let locationService : LocationService = LocationService()
    var coordinatePoints = ""
    
    var diseaseCropImage:UIImage?
    var weatherJson = ""
    var errorMessage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        diagnosisTblView.dataSource = self
        diagnosisTblView.delegate = self
        diagnosisTblView.separatorStyle = .none
        diagnosisTblView.tableFooterView = UIView()
        
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
        
        let nib = UINib(nibName: "DiseaseCell", bundle: nil)
            diagnosisTblView.register(nib, forCellReuseIdentifier: "diseaseCell")
        
        let customType = ActiveType.custom(pattern: "1800 103 9799")
        
        lblCustomercareNumber.enabledTypes.append(customType)
        
        lblCustomercareNumber?.customize({(label) in
            label.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                switch type {
                case customType:
                    atts[NSAttributedStringKey.underlineStyle] = isSelected ? NSUnderlineStyle.styleSingle.rawValue : NSUnderlineStyle.styleSingle.rawValue
                    atts[NSAttributedStringKey.foregroundColor] = isSelected ? UIColor(red: 95.0/255.0, green: 169.0/255.0, blue: 254.0/255.0, alpha: 1.0) : UIColor(red: 95.0/255.0, green: 169.0/255.0, blue: 254.0/255.0, alpha: 1.0)
                default: ()
                }
                return atts
            }
            label.handleCustomTap(for: customType, handler: { (message) in
                print("clicked")
                let callUrl = String(format:"tel://%@", "18001039799")
                if let url = URL(string: callUrl), UIApplication.shared.canOpenURL(url) {
                    let userObj = Constatnts.getUserObject()
                    let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "FeedBack", "FeedBack_Customer_Care" : "FeedBack_Customer_Care"]
                    self.registerFirebaseEvents(CD_FeedBack_Customer_Care, "", "", "", parameters: firebaseParams as NSDictionary)
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            })
            label.customColor[customType] = UIColor.white
        })
        
        
        /*errorLbl.isHidden = true
        
        txtFldFeedbackDiseaseName?.isHidden = true
        txtFldFeedbackDiseaseName?.setLeftPaddingPoints(5)
        txtFldFeedbackDiseaseName?.delegate = self
        diagnosisTblViewHeightConstraint.constant = 391//306
        feedbackViewHeightConstraint.constant = 145
        self.feedbackView.isHidden = true
        self.feedbackSubmitBtn.isHidden = true
        //self.feedbackBtn.backgroundColor = UIColor.lightGray
        //self.feedbackBtn.isEnabled = false
        //feedbackDiseaseIdentifiedYesBtn.isSelected = true
        feedbackLikeBtn.isSelected = false
        //feedbackLikeUnlikeTopConstraint.constant = -25
        feedbackLikeBtn.setBackgroundImage(UIImage(named:"LikeGray"), for: .normal)
        feedbackUnlikeBtn.setBackgroundImage(UIImage(named:"UnLikeGray"), for: .normal)
        footerView?.addBorder(toSide: .Top, withColor: UIColor.lightText.cgColor, andThickness: 1.0, xValue: 0, yValue: 1, height: 1.0)
        lblFeedbackTitle.addBorder(toSide: .Bottom, withColor: UIColor.black.cgColor, andThickness: 1.0, xValue: 0, yValue: lblFeedbackTitle.frame.size.height-1, height: 1.0)*/
        
//        if Reachability.isConnectedToNetwork(){
//            let userObj = Constatnts.getUserObject()
//        let parameters : NSDictionary?
//            parameters = ["customerId":userObj.customerId!,"uploadImageByteString":imgBase64StrFromCapturePhotoVC!,"crop":cropNameFromCapturePhotoVC!,"deviceType":"IOS"] as NSDictionary
//
//        let paramsStr1 = Constatnts.nsobjectToJSON(parameters!)
//        let params =  ["data": paramsStr1]
//        self.requestToGetCropDiagnosisLibraryData(Params: params as [String:String])
//        }
//        else{
//            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
//        }
         //self.uploadingWithMultiPartFormData()
        self.recordScreenView("DiagnosisViewController", Disease_List)
        let userObj = Constatnts.getUserObject()
               let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "Disease List"]
               self.registerFirebaseEvents(PV_CDI_Disease_List, "", "", "", parameters: firebaseParams as NSDictionary)
    }
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 10.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        super.viewWillAppear(true)
        self.topView?.isHidden = false
        lblTitle?.text = "Diagnosis"
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        
        errorLbl.isHidden = true
        
        txtFldFeedbackDiseaseName?.isHidden = true
        txtFldFeedbackDiseaseName?.setLeftPaddingPoints(5)
        txtFldFeedbackDiseaseName?.delegate = self
        diagnosisTblViewHeightConstraint.constant = 336//391//306
        feedbackViewHeightConstraint.constant = 145
        self.feedbackView.isHidden = true
        self.feedbackSubmitBtn.isHidden = true
        //self.feedbackBtn.backgroundColor = UIColor.lightGray
        //self.feedbackBtn.isEnabled = false
        //feedbackDiseaseIdentifiedYesBtn.isSelected = true
        feedbackLikeBtn.isSelected = false
        //feedbackLikeUnlikeTopConstraint.constant = -25
        feedbackLikeBtn.setBackgroundImage(UIImage(named:"LikeGray"), for: .normal)
        feedbackUnlikeBtn.setBackgroundImage(UIImage(named:"UnLikeGray"), for: .normal)
        footerView?.addBorder(toSide: .Top, withColor: UIColor.lightText.cgColor, andThickness: 1.0, xValue: 0, yValue: 1, height: 1.0)
        lblFeedbackTitle.addBorder(toSide: .Bottom, withColor: UIColor.black.cgColor, andThickness: 1.0, xValue: 0, yValue: lblFeedbackTitle.frame.size.height-1, height: 1.0)
        
        self.uploadingWithMultiPartFormData()
        
//        self.diagnosisTblView.reloadData()
    }
    
    //MARK: requestToGetCropDiagnosisLibraryData
    func requestToGetCropDiagnosisLibraryData(Params:[String:String]){
        //SKActivityIndicator.show("Loading...")
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [CDI_BASE_URL,CROP_DIAGNOSIS_REQUEST])
        let userObj = Constatnts.getUserObject()
        
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        //print(headers)
        
        Alamofire.request(urlString, method: .post, parameters: Params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            //SKActivityIndicator.dismiss()
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print(json)
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        //print("Response after decrypting data:\(decryptData)")
                        
                        let resultArray = decryptData.value(forKey: "cropDiagnosisResponseDTO") as! NSArray
                        self.libMutArrToDisplay.removeAllObjects()
                        for i in 0 ..< resultArray.count{
                            let libraryDic = resultArray.object(at: i) as? NSDictionary
                            let cropDiagnosisLib = CropDiagnosisLibrary(dict: libraryDic!)
                            self.libMutArrToDisplay.add(cropDiagnosisLib)
                        }
                        //print(self.libMutArrToDisplay)
                        DispatchQueue.main.async {
                            self.diagnosisTblView.reloadData()
                        }
                        let userObj = Constatnts.getUserObject()
                        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "Disease List"]
                        self.registerFirebaseEvents(CDI_Success_Request, "", "", "", parameters: firebaseParams as NSDictionary)
                    }
                    else if responseStatusCode == STATUS_CODE_601{
                         Constatnts.logOut()
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                      let userObj = Constatnts.getUserObject()
                        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "Disease List"]
                        self.registerFirebaseEvents( CDI_Something_Wrong, "", "", "", parameters: firebaseParams as NSDictionary)
                    }
                    else{
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                        let userObj = Constatnts.getUserObject()
                        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "Disease List"]
                        self.registerFirebaseEvents( CDI_Something_Wrong, "", "", "", parameters: firebaseParams as NSDictionary)
                    }
                }
                else{
                     let userObj = Constatnts.getUserObject()
                           let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "Disease List"]
                           self.registerFirebaseEvents(CDI_Failure_Request, "", "", "", parameters: firebaseParams as NSDictionary)
                }
            }
            else{
                self.view.makeToast((response.result.error?.localizedDescription)!, duration: 1.0, position: .center)
                let userObj = Constatnts.getUserObject()
                       let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "Disease List"]
                       self.registerFirebaseEvents(CDI_Failure_Request, "", "", "", parameters: firebaseParams as NSDictionary)
                return
            }
        }
    }
    
    //MARK : uploadingWithMultiPartFormData
    func uploadingWithMultiPartFormData(){
        if  self.libMutArrToDisplay.count > 0 {
            self.errorLbl.isHidden = true
            //self.feedbackBtn.isHidden = false
            self.feedbackView.isHidden = false
            //print(self.libMutArrToDisplay)
            DispatchQueue.main.async {
                self.diagnosisTblView.reloadData()
            }
        }else  {
        self.errorLbl.isHidden = false
        self.errorLbl.text = errorMessage
        }
            
//        
//        //SKActivityIndicator.show("Loading...")
//        SwiftLoader.show(animated: true)
//        //let image = UIImage(named: "profile_icon.png")!
//        let userObj = Constatnts.getUserObject()
//        
//        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
//                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
//                                    "mobileNumber": userObj.mobileNumber! as String,
//                                    "customerId": userObj.customerId! as String,
//                                    "deviceId": userObj.deviceId! as String,"userType": "Farmer"]
//        
//        //Soujanya //
//        // define parameters
//        let parameters = [
//            "crop": cropNameFromCapturePhotoVC!,
//            "customerId": userObj.customerId! as String,
//            "coordinatePoints": coordinatePoints,
//            "weather" : weatherJson
//            ] as NSDictionary
//      print("parameters : %@",parameters)
//        let paramsStr1 = Constatnts.nsobjectToJSON(parameters)
//       print(paramsStr1)
//        
//        Alamofire.upload(multipartFormData: {(multipartFormData) in
//            // import image to request
//            if let imageData = UIImageJPEGRepresentation(self.diseaseCropImage!, 1) {
//                multipartFormData.append(imageData, withName: "multipartFile", fileName: "image.jpg", mimeType: "image/png")
//            }
//            multipartFormData.append(paramsStr1.data(using: String.Encoding.utf8)!, withName: "encodedData")
//        }, usingThreshold: 60, to: String(format :"%@%@",CDI_BASE_URL,CROP_DIAGNOSIS_MULTIPART), method: .post, headers: headers, encodingCompletion: {(encodeResult) in
//            switch encodeResult {
//            case .success(let upload, _, _):
//                upload.validate().responseJSON { response in
//                    //SKActivityIndicator.dismiss()
//                    SwiftLoader.hide()
//                    //debugPrint(response)
//                    print(response)
//                    if response.result.error == nil{
//                        if let json = response.result.value{
//                            print(json)
//                            let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
//                            if responseStatusCode == STATUS_CODE_200{
//                                self.errorLbl.isHidden = true
//                                //self.feedbackBtn.isHidden = false
//                                self.feedbackView.isHidden = false
//                                if Validations.isNullString(((json as! NSDictionary).value(forKey: "response") as! NSString).replacingOccurrences(of: "\\", with: "") as NSString) == false{
//                                    let respData = ((json as! NSDictionary).value(forKey: "response") as! NSString).replacingOccurrences(of: "\\", with: "")
//                                    let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
//                                    print("decryptData :\(decryptData)")
//                                    /*if let diseaseReqIdObj = decryptData.value(forKey: "id") as? Int {
//                                        self.diseaseReqIdStr = String(format: "%d",diseaseReqIdObj)
//                                    }*/
//                                    if let resultArray = decryptData.value(forKey: "cropDiagnosisResponseDTO")! as? NSArray{
//                                        self.libMutArrToDisplay.removeAllObjects()
//                                        for i in 0 ..< resultArray.count{
//                                            let libraryDic = resultArray.object(at: i) as? NSDictionary
//                                            
//                                            if let diseaseReqIdObj = libraryDic?.value(forKey: "diseaseId") as? Int {
//                                                if self.diseaseReqIdStr == "0"{
//                                                    self.diseaseReqIdStr = String(format: "%d",diseaseReqIdObj)
//                                                }
//                                            }
//                                            let cropDiagnosisLib = CropDiagnosisLibrary(dict: libraryDic!)
//                                            self.libMutArrToDisplay.add(cropDiagnosisLib)
//                                        }
//                                        //print(self.libMutArrToDisplay)
//                                        DispatchQueue.main.async {
//                                            self.diagnosisTblView.reloadData()
//                                        }
//                                    }
//                                }
//                            }else if responseStatusCode == STATUS_CODE_601{
//                                Constatnts.logOut()
//                                if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
//                                    print(msg)
//                                }
//                            }
//                            else{
//                                self.errorLbl.isHidden = false
//                                //self.view.makeToast((json as! NSDictionary).value(forKey: "message") as! String)
//                                self.errorLbl.text = (json as! NSDictionary).value(forKey: "message") as? String
//                                return
//                            }
//                        }
//                    }
//                    else{
//                        self.view.makeToast((response.result.error?.localizedDescription)!, duration: 1.0, position: .center)
//                        return
//                    }
//                }
//            case .failure(let encodingError):
//                print(encodingError)
//                self.view.makeToast(encodingError.localizedDescription)
//            }
//        })
    }
    
    override func backButtonClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Location service delegate methods
    func tracingLocation(_ currentLocation: CLLocation) {
        //print(String(format : "%f",currentLocation.coordinate.latitude), String(format : "%f",currentLocation.coordinate.longitude))
        locationService.stopUpdatingLocation()
    }
    
    func tracingLocationDidFailWithError(_ error: NSError) {
        
    }
    
//    @IBAction func feedbackCloseBtnClick(_ sender: Any) {
//        self.txtFldFeedbackDiseaseName?.resignFirstResponder()
//        self.feedbackView.isHidden = true
//    }
    
//    @IBAction func feedbackBtnClick(_ sender: Any) {
//        //self.view.addSubview(self.feedbackView)
//        //self.view.bringSubview(toFront: self.feedbackView)
//        self.feedbackView.isHidden = false
//    }
    
//    @IBAction func feedbackDiseaseIdentifiedYesBtnClick(_ sender: ISRadioButton) {
//        self.feedbackDiseaseIdentifiedYesBtn.isSelected = true
//        self.feedbackDiseaseIdentifiedNoBtn.isSelected = false
//        self.txtFldFeedbackDiseaseName?.isHidden = true
//        self.feedbackLikeUnlikeTopConstraint.constant = -25
//    }
//
//    @IBAction func feedbackDiseaseIdentifiedNoBtnClick(_ sender: ISRadioButton) {
//        self.feedbackDiseaseIdentifiedNoBtn.isSelected = true
//        self.feedbackDiseaseIdentifiedYesBtn.isSelected = false
//
//        self.txtFldFeedbackDiseaseName?.isHidden = false
//        self.feedbackLikeUnlikeTopConstraint.constant = 6
//    }
    
    @IBAction func feedbackLikeBtnClick(_ sender: UIButton) {
        self.diagnosisTblViewHeightConstraint.constant = 336//391//306
        self.feedbackViewHeightConstraint.constant = 145
        self.feedbackLikeBtnStr = "true"
        feedbackLikeBtn.isSelected = true
        self.feedbackSubmitBtn.isHidden = true
        self.txtFldFeedbackDiseaseName?.isHidden = true
        feedbackLikeBtn.setBackgroundImage(UIImage(named:"LikeGreen"), for: .normal)
        feedbackUnlikeBtn.setBackgroundImage(UIImage(named:"UnLikeGray"), for: .normal)
        
        //let isDiseaseIdentified = ""
        //let parameters = ["id":self.diseaseReqIdStr ,"isDiseaseIdentified":isDiseaseIdentified,"isLike":self.feedbackLikeBtnStr,"diseasenameByCustomer":self.txtFldFeedbackDiseaseName?.text! ?? ""] as NSDictionary
        
        let userObj = Constatnts.getUserObject()
        
        let parameters = ["userType": "Farmer","customerId": userObj.customerId! as String,"mobileNo":userObj.mobileNumber! as String,"accrracyFlag":self.feedbackLikeBtnStr,"comments":self.txtFldFeedbackDiseaseName?.text! ?? "","diseaseId":self.diseaseReqIdStr] as NSDictionary
        
        let paramsStr1 = Constatnts.nsobjectToJSON(parameters)
        let params =  ["data": paramsStr1]
        self.requestToSubmitCustomerFeedback(Params: params as [String:String])
    }
    
    @IBAction func feedbackUnlikeBtnClick(_ sender: UIButton) {
        self.diagnosisTblViewHeightConstraint.constant = 251//306
        self.feedbackViewHeightConstraint.constant = 230
        feedbackLikeBtn.isSelected = false
        self.feedbackLikeBtnStr = "false"
        self.feedbackSubmitBtn.isHidden = false
        self.txtFldFeedbackDiseaseName?.isHidden = false
        feedbackLikeBtn.setBackgroundImage(UIImage(named:"LikeGray"), for: .normal)
        feedbackUnlikeBtn.setBackgroundImage(UIImage(named:"UnLikeGreen"), for: .normal)
    }
    
    @IBAction func feedbackSubmitBtnClick(_ sender: Any) {
        self.view.endEditing(true)
//        if self.feedbackDiseaseIdentifiedYesBtn.isSelected == false{
//            if Validations.isNullString((self.txtFldFeedbackDiseaseName?.text as NSString?)!) == true{
//                self.view.makeToast("Please enter disease name")
//                return
//            }
//        }
        //self.feedbackView.isHidden = true
        //let isDiseaseIdentified = ""
//        if self.feedbackDiseaseIdentifiedYesBtn.isSelected == false{
//            isDiseaseIdentified = "false"
//        }
        //print("id: \(Int(diseaseReqIdStr) ?? 0), isDiseaseIdentified: \(isDiseaseIdentified), isLike: \(self.feedbackLikeBtnStr), diseasenameByCustomer: \(self.txtFldFeedbackDiseaseName?.text ?? "")")
        //let parameters = ["id":self.diseaseReqIdStr ,"isDiseaseIdentified":isDiseaseIdentified,"isLike":self.feedbackLikeBtnStr,"diseasenameByCustomer":self.txtFldFeedbackDiseaseName?.text! ?? ""] as NSDictionary
        let userObj = Constatnts.getUserObject()
        
        let parameters = ["userType": "Farmer","customerId": userObj.customerId! as String,"mobileNo":userObj.mobileNumber! as String,"accrracyFlag":self.feedbackLikeBtnStr,"comments":self.txtFldFeedbackDiseaseName?.text! ?? "","diseaseId":self.diseaseReqIdStr] as NSDictionary
        
        let paramsStr1 = Constatnts.nsobjectToJSON(parameters)
        let params =  ["data": paramsStr1]
     let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "FeedBack"]
     self.registerFirebaseEvents(CD_CL_FeedBack, "", "", "", parameters: firebaseParams as NSDictionary)
        //let encryptDestURLStr = Constatnts.encrptInputString(paramStr: String(format: "%@%@", CDI_BASE_URL,CDI_CUSTOMER_FEEDBACK) as NSString)
        //let params =  ["requestData": paramsStr1 ,"destinationURL": encryptDestURLStr]
        self.requestToSubmitCustomerFeedback(Params: params as [String:String])
    }
    
    //MARK: requestToSubmitCustomerFeedback
    func requestToSubmitCustomerFeedback(Params:[String:String]){
        //SKActivityIndicator.show("Loading...")
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [CDI_BASE_URL,CDI_CUSTOMER_FEEDBACK])
        let userObj = Constatnts.getUserObject()
        
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        Alamofire.request(urlString, method: .post, parameters: Params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            //SKActivityIndicator.dismiss()
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print(json)
                    if let responseStatusCode = (json as! NSDictionary).value(forKey: JAVA_STATUS_CODE_KEY) as? String{
                        if responseStatusCode == STATUS_CODE_200{
                            let userObj = Constatnts.getUserObject()
                            let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "FeedBack"]
                               self.registerFirebaseEvents(CDI_DiseaseList_Success_Request, "", "", "", parameters: firebaseParams as NSDictionary)
                            self.diagnosisTblViewHeightConstraint.constant = 626//681
                            self.feedbackView.isHidden = true
                            self.feedbackViewHeightConstraint.constant = 5
                            self.feedbackView.removeFromSuperview()
                            self.view.makeToast("Feedback submitted successfully.")
                        }else if responseStatusCode == STATUS_CODE_601{
                            Constatnts.logOut()
                            if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                print(msg)
                            }
                        }
                        else{
                            let userObj = Constatnts.getUserObject()
                         let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "FeedBack"]
                          self.registerFirebaseEvents(CDI_feedback_Api_Something_Wrong, "", "", "", parameters: firebaseParams as NSDictionary)
                            if let errorMsg = (json as! NSDictionary).value(forKey: JAVA_RESPONSE_MESSAGE_KEY) as? String{
                                self.view.makeToast(errorMsg, duration: 1.0, position: .center)
                            }
                        }
                    }
                }
            }
            else{
                let userObj = Constatnts.getUserObject()
                 let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "FeedBack"]
                   self.registerFirebaseEvents(CDI_feedback_Api_Failure_Request, "", "", "", parameters: firebaseParams as NSDictionary)
                self.view.makeToast((response.result.error.debugDescription), duration: 1.0, position: .center)
                return
            }
        }
    }
    
    //MARK: tableView datasource and delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libMutArrToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = diagnosisTblView.dequeueReusableCell(withIdentifier: "diseaseCell", for: indexPath) as? DiseaseCell
        
        let cropDiagnosisCell = libMutArrToDisplay.object(at: indexPath.row) as? CropDiagnosisLibrary
        
//      let outerView = cell.contentView.viewWithTag(203)
//        outerView?.layer.cornerRadius = 5.0
//        outerView?.clipsToBounds = true
//        outerView?.layer.borderWidth = 0.5
//        outerView?.layer.borderColor = UIColor.lightGray.cgColor
//        outerView?.dropViewShadow()
        
        // let percentagebtn = cell.viewWithTag(303) as! UIButton
       
       
//        let prescriptionView = cell.contentView.viewWithTag(1000)
//
//        let percentageView = cell.contentView.viewWithTag(204)
//        let percentageLbl = cell.viewWithTag(205) as! UILabel
//            percentageView?.isHidden = false
//            percentageLbl.isHidden = false
//            percentageView?.clipsToBounds = true
//        percentageView?.isHidden = false
//        prescriptionView?.isHidden = false
        
//        if  cropDiagnosisCell?.value(forKey: "diseaseId") as? NSString == "0" ||  cropDiagnosisCell?.value(forKey: "diseaseId") as? NSString == ""{
//            prescriptionView?.isHidden = true
//
//        }
//        else{
//
//        }
        
        
       // percentageView?.layer.cornerRadius = percentageView?.frame.height ?? 0/2//0.5 * (percentageView?.bounds.size.width)!
            
            var percentVal = cropDiagnosisCell?.value(forKey: "probability") as? Double
            //var percentDoubleVal = (percentVal! as NSString).doubleValue
            let num : Float = Float((percentVal!).roundToPlaces(places: 2))//*100
            let roundedValue = roundf(num)
            //print(roundedValue)
//            percentageLbl.text = String(format: "%@%%", roundedValue.cleanValue)
        cell?.setProgressView(String(format: "%@%%", roundedValue.cleanValue))
       // percentageLbl.text = String(format: "%f%%", percentVal ?? 0.0)
        
//        let cropImg = cell.viewWithTag(200) as! UIImageView
        cell?.img_diesease.image = UIImage(named:"image_placeholder.png")  //http://103.24.202.7:9090/CDI/
        let imgPath = cropDiagnosisCell?.value(forKey: "imagePath") as! String
        let url = NSURL(string:(imgPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
       // NSLog("%@", url!)
        //cropImg.kf.setImage(with: url! as? Resource , placeholder: UIImage(named:"image_placeholder.png"), options:nil , progressBlock: nil, completionHandler: nil)
        cell?.img_diesease.downloadedFrom(url: url! as URL, placeHolder: UIImage(named:"image_placeholder.png"))
        cell?.lbl_DiseaseSubmittedDate.text = cropDiagnosisCell?.diseaseDate as String? ?? ""
        cell?.imgCropType.downloadImageFrom(link: cropDiagnosisCell?.diseaseTypeImgUrl as String? ?? "", contentMode: .scaleAspectFit)
        cell?.btn_ImagesCount.setTitle(cropDiagnosisCell?.diseaseTypeImageCount as String? ?? "", for: .normal)

//        let title = cell.viewWithTag(201) as! UILabel
        cell?.lbl_diseaseNAme.text = cropDiagnosisCell?.value(forKey: "diseaseName") as? String
//        let subTitle = cell.viewWithTag(202) as! UILabel
        cell?.lbl_scientificName.text = cropDiagnosisCell?.value(forKey: "diseaseScientificName") as? String
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        diagnosisTblView.deselectRow(at: indexPath, animated: false)
        if Reachability.isConnectedToNetwork(){
            let cropDiagnosisCell = libMutArrToDisplay.object(at: indexPath.row) as? CropDiagnosisLibrary
      //      let toDiseaseDetectedVC = self.storyboard?.instantiateViewController(withIdentifier: "DiseaseDetectedViewController") as! DiseaseDetectedViewController
//            diseaseDetailsVC.urlIDStr = cropDiagnosisCell?.value(forKey: "diseaseId") as? NSString
//            diseaseDetailsVC.diseaseName = cropDiagnosisCell?.diseaseName as String? ?? ""
//            diseaseDetailsVC.diseaseRequestId = cropDiagnosisCell?.value(forKey: "diseaseRequestId") as? String
//            self.navigationController?.pushViewController(diseaseDetailsVC, animated: true)

            //LibraryDetailsViewController
            let userObj = Constatnts.getUserObject()
            let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,DISEASE_NAME:cropDiagnosisCell?.diseaseName,CROP:cropNameFromCapturePhotoVC]
            self.registerFirebaseEvents(CDI_Disease_Details, "", "", "", parameters: firebaseParams as NSDictionary)
            let diseaseDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "LibraryDetailsViewController") as! LibraryDetailsViewController
            diseaseDetailsVC.diseaseId = cropDiagnosisCell?.value(forKey: "diseaseId") as! String
            diseaseDetailsVC.diseaseName = cropDiagnosisCell?.diseaseName as String? ?? ""
            diseaseDetailsVC.diseaseRequestId = (cropDiagnosisCell?.value(forKey: "diseaseRequestId") as? String)!
            diseaseDetailsVC.cropName = cropNameFromCapturePhotoVC as String? ?? ""
            diseaseDetailsVC.isFromDiagnosisScreen = true
            self.navigationController?.pushViewController(diseaseDetailsVC, animated: true)
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension DiagnosisViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtFldFeedbackDiseaseName?.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let validCharSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 ").inverted
        let filtered: String = (string.components(separatedBy: validCharSet) as NSArray).componentsJoined(by: "")
        let _char = string.cString(using: String.Encoding.utf8)
        let isBackSpace: Int = Int(strcmp(_char, "\\b"))
        if isBackSpace == -92 {
            // is backspace
            if textField.text?.count == 1 {
            }
            return true
        }
        if (filtered == "") {
        }
        if (textField.text?.count)! >= 90 && range.length == 0 {
            return false
        }
        return (string == filtered)
    }
}
