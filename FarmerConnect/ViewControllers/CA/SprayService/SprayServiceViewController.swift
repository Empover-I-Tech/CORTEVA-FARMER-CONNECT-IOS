//
//  SprayServiceViewController.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 28/08/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import UIKit
import SwiftyGif
import Alamofire
//import UQScannerFramework

class SprayServiceViewController: BaseViewController , SelectedNumberOfAcresValueDelegate{//UQScannerDelegate
    func numberOfAcresValue(_ value: String) {
        UserDefaults.standard.setValue(value, forKey: "numberOfAcres")
        UserDefaults.standard.synchronize()
    }
    
    
    @IBOutlet weak var imgFarmer: UIImageView!
    @IBOutlet weak var tfCrop: UITextField!
    @IBOutlet weak var tfDateOfSowing: UITextField!
    @IBOutlet weak var tfNoOfAcres: UITextField!
     @IBOutlet weak var btnSubscription: UIButton!
    
    @IBOutlet weak var cropLbl: UILabel!
    @IBOutlet weak var dateofSowingLbl: UILabel!
    @IBOutlet weak var noofAcresLbl: UILabel!
    
    @IBOutlet weak var termsAndConditionsLbl: ActiveLabel!
    
    var stateNamesArray = NSMutableArray()
    var cropNamesArray = NSMutableArray()
    var seasonNamesArray = NSMutableArray()
    
    var stateArray = NSArray()
    var cropArray = NSArray()
    var seasonArray = NSArray()
    var FinalArray = NSMutableArray()
    var currentIndex = 0
    var subscriptionArray = NSMutableArray()
    
    var userObj1 : NSMutableDictionary!
    
    var seasonStartDateStr: String?
    var seasonEndDateStr: String?
    
    
    //SUBSCRIPTION RELATED OUTLETS
    var crop_dropDownTable : UITableView!
    var hybrid_dropDownTable : UITableView!
    var categoryDropDownTblView : UITableView!
    //    var stateDropDownTblView = UITableView()
    var seasonTblView = UITableView()
    
    var selectedTextField = UITextField()
    var dobView = UIView()
    
    
    var categoryID = NSString()
    var stateID = NSString()
    var cropID = Int()
    var seasonID = NSString()
    
    var alertController = UIAlertController()
    var cistomView = SubscriptionCreatePop()
    
    var cropsArray = NSMutableArray()
    var cropsImagesArray = NSArray()
    var alertView_Bg: UIView = UIView()
    
    var sprayServiceCheckIn : Bool = false
    
    var fromDateView : UIView?
    var maximumDate : NSDate?
    
 //   var scannerVc : UQScannerViewController?
     var statusMsgAlert : UIView?
     var dictEncashResponse : NSDictionary?
    
    var cropName : String = ""
    var isFromHome : Bool = false
    
    var cropId : Int = 0
        var noOfScans : Int = 0
        var noOfAcres : Int = 0
        var isFromSprayServiceScanner : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        do {
//            let gif = try UIImage(gifName: "spraying.gif")
//            self.imgFarmer.setGifImage(gif, loopCount: -1)
//
//        } catch {
//            print(error)
//        }
        
        let userObj1 : User =  Constatnts.getUserObject()
        
    
        let parameters  = ["capturedtime" : self.getCurrentDateAndTime() , "currentLocation" :  userObj1.geolocation! ,"eventName" :  "Crop_Advisory_Subscription_Load" , "moduleType" : "CropAdvisory","deviceType" : userObj1.deviceType , "Mobile_Number" : userObj1.mobileNumber! ,"screen_name" :  "CASubScriptionViewController" , "User_Id" :  userObj1.customerId!] as [String : Any]
        
        
                    let customType1 = ActiveType.custom(pattern: "Terms and Conditions")
        
        termsAndConditionsLbl.enabledTypes.append(customType1)
       //Removed under line here
        termsAndConditionsLbl?.customize({(label) in
            label.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                switch type {
                case customType1:
//                    atts[NSAttributedStringKey.underlineStyle] = isSelected ? NSUnderlineStyle.styleSingle.rawValue : NSUnderlineStyle.styleSingle.rawValue
                    atts[NSAttributedStringKey.foregroundColor] = UIColor.red
                default: ()
                }
                return atts
            }
            
            label.handleCustomTap(for: customType1, handler: { (message) in
                // print("clicked")
                let net = NetworkReachabilityManager(host: "www.google.com")
                if net?.isReachable == true{
                    self.findHamburguerViewController()?.hideMenuViewControllerWithCompletion(nil)
                    let toPrivacyPolicyWebViewVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginPrivacyPolicyViewController") as! LoginPrivacyPolicyViewController
                    toPrivacyPolicyWebViewVC.privacyPolicyURLStr = TERMS_CONDITIONS_URL as NSString
                    self.present(toPrivacyPolicyWebViewVC, animated: true, completion: nil)
                }
                else{
                    //self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE, duration: 1.0, position: .center)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                    return
                }
            })
//            label.customColor[customType1] = UIColor.white
        })
        if isFromHome == true {
            let params =  ["data": ""]
            self.requestToGetCropAdvisoryData(Params: params)
        }else {
             self.tfCrop.text = self.cropName
            self.cropNamesArray.adding(self.cropName)
            self.cropNamesArray.adding(self.cropID)
        }
       
        let params =  ["data": ""]
        let userObj = Constatnts.getUserObject()
        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId]
         self.registerFirebaseEvents(PV_SprayService, "", "", "", parameters: fireBaseParams as NSDictionary)
        self.requestToGetCropAdvisoryData(Params: params as [String:String] )
       
        if userObj.userLogsAllPrint == "true"{
        self.saveUserLogEventsDetailsToServer()
        }
        // Do any additional setup after loading the view.
    }
    func saveUserLogEventsDetailsToServer(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMddHHmmss" //"dd/MM/yyyy HH:mm:ss"
        var todaysDate = dateFormatter.string(from: Date())
        let userObj = Constatnts.getUserObject()
        
        let dict: NSDictionary = ["userModuleUsageLogs":[[
            "mobileNumber": userObj.mobileNumber,
            "deviceId": userObj.deviceId,
            "deviceType": "iOS",
            "customerId": userObj.customerId,
            "logTimeStamp": todaysDate as? NSString,
            "pincode": userObj.pincode,
            "districtLoggedin":userObj.districtName,
            "stateLoggedin":userObj.stateName,
            "stateName": userObj.stateName,
            "marketName":"",
            "commodity":"",
            
            "eventName": Home_SprayServices,
            "className":"SprayServiceViewController",
            "moduleName":"SprayServices",
            
            "healthCardId":"",
            "productId":"",
            "cropId":"",
            "seasonId":"",
            "otherParams":"",
            "isOnlineRecord": "true"]] as? [NSDictionary]
        ]
        
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            userLogEventsSingletonClass.sendUserLogEventsDetailsToServer(dictionary: dict ?? NSDictionary()){ (status, statusMessage) in
                if status == true{
                }else{
                    self.view.makeToast(statusMessage as String? ?? "")
                }
            }
        }else{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let userLogEvents = dict["userModuleUsageLogs"] as! [NSDictionary]
                for eachLogEvent in userLogEvents {
                var userLogEvent: UserLogEvents = UserLogEvents(dict: eachLogEvent)
                userLogEvent.isOnlineRecord = "false"
                appDelegate.saveUserLogEventsModulewise(userLogEvent)
                }
        }
        
    }
    
    @IBAction func cropDropDownBtnAction(_ sender: Any) {
        crop_dropDownTable = UITableView()
        
        loadTable(textField:  self.tfCrop , table : crop_dropDownTable)

    }
    @IBAction func calendarDropDownBtnAction(_ sender: Any) {
        if(self.tfCrop.text?.count ?? 0 > 0){
            fromDatePickerView()
        
        }else{
            self.view.makeToast("Please Select Crop.")
       
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        cropLbl.text = "registration_crop".localized
        dateofSowingLbl.text = "registration_dateofsowing".localized
        noofAcresLbl.text = "registration_numberofacres".localized
        
        let fromDateFormatter: DateFormatter = DateFormatter()
        fromDateFormatter.dateFormat = "dd-MMM-yyyy"
        let currentDateStr = fromDateFormatter.string(from: Date()) as String
        tfDateOfSowing.text = currentDateStr
        
        
        self.topView?.isHidden = false
       let messageStr = NSLocalizedString("Spray_Service", comment: "")
         lblTitle?.text = messageStr
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        
    }
    override func backButtonClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func requestToGetCropAdvisoryData (Params : [String:String]){
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_CROP_MASTER])
        let userObj1 : User =  Constatnts.getUserObject()
        let  headers : HTTPHeaders  = ["deviceToken": userObj1.deviceToken as String ,
                                       "userAuthorizationToken": userObj1.userAuthorizationToken! as String ,
                                       "mobileNumber": userObj1.mobileNumber! as! String,
                                       "customerId": userObj1.customerId! as! String,
                                       "deviceId": userObj1.deviceId! as! String]
        
        Alamofire.request(urlString, method: .post, parameters: Params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                print(response)
                if let json = response.result.value {
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                    if responseStatusCode == STATUS_CODE_200{
                        let userObj = Constatnts.getUserObject()
                        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!  , "screen_name" : "SpraySerCropApiRequestSuccess" ] as [String : Any]
                        
                        self.registerFirebaseEvents("SpraySerCropApiRequestSuccess", "", "", "SprayServiceViewController", parameters: fireBaseParams as NSDictionary)
                        
                        let respData = (json as? NSDictionary)?.value(forKey: "response") as? NSString ?? ""
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)

                        if let cropsArray = decryptData.value(forKey: "allCrops") as? NSArray{
                            self.cropNamesArray.addObjects(from: cropsArray as! [Any])
                            let stateDic = self.cropNamesArray.object(at: 0) as? NSDictionary
//                            self.tfCrop.text = stateDic?.value(forKey: "name") as? String
//                            self.cropID = stateDic?.value(forKey: "id") as? Int ?? 0
                        }
                        
                        
                    }
                    else if responseStatusCode == CROP_ADVISORY_NOT_AVAILABLE_151{
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    } else if responseStatusCode == STATUS_CODE_105{
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    else if responseStatusCode == STATUS_CODE_601{
                        Constatnts.logOut()
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    }
                }
            }
            else{
                self.view.makeToast((response.error?.localizedDescription)!)
            }
        }
    }
    
    
}
//MARK:- UITABLEVIEW DELEGATE AND DATA SOURCE METHODS
extension SprayServiceViewController:  UITableViewDelegate,UITableViewDataSource{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == crop_dropDownTable {
            return cropNamesArray.count
        }
            
        else{
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellIdentifier)
        cell.textLabel?.font = UIFont.init(name: "Helvetica", size: 13.0)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.sizeToFit()
        cell.textLabel?.text = "hi"
        cell.backgroundColor = UIColor.white
        
        
        if tableView == crop_dropDownTable {
            let stateDic = cropNamesArray.object(at: indexPath.row) as? NSDictionary
            cell.textLabel?.text = stateDic?.value(forKey: "name") as? String
        }
            
       
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == crop_dropDownTable {
            //get crop id
            if self.cropNamesArray.count>0{
                let cropDic = self.cropNamesArray.object(at: indexPath.row) as? NSDictionary
                cropID = cropDic?.value(forKey: "id") as? Int ?? 0
                self.tfCrop.text = cropDic?.value(forKey: "name") as? String
                
                
            }
            if crop_dropDownTable != nil{
                crop_dropDownTable.isHidden = true
            }
            self.tfCrop.resignFirstResponder()
        }
            
        else{
            tableView.isHidden = true
        }
        self.view.endEditing(true)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    //MARK:- ADD SUBSCRIPTION
    @IBAction  func submitSubscribeduserDetails(){
        
        if self.tfNoOfAcres.text  != "" && self.tfCrop.text != "" && self.tfDateOfSowing.text != "" {
            
            
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            let date = dateFormatter.date(from: self.tfDateOfSowing.text ?? "")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let strDateToServer = dateFormatter.string(from: date!)
            
            
            let dic : Parameters  = ["cropId" : cropID ,
                                     "cropName":self.tfCrop.text ?? "",
                                     "dateOfSowing" : strDateToServer ,
                                     "noOfAcres" : self.tfNoOfAcres.text ?? "" ,
            ]
            let userObj1 : User =  Constatnts.getUserObject()
            
            let parameters  = ["capturedtime" : self.getCurrentDateAndTime() , "currentLocation" :  userObj1.geolocation ,"eventName" :  "Crop_Advisory_Subscription_Click" , "moduleType" : "SprayService","deviceType" : "iOS" , "Mobile_Number" : userObj1.mobileNumber ,"screen_name" :  "SprayServiceViewController" , "User_Id" :  userObj1.customerId , "crop" : self.tfCrop.text ?? "" , "acres_Sowed" :  self.tfNoOfAcres.text ?? "" ] as [String : Any]
            
            
            let userObj = Constatnts.getUserObject()
            let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId! , "CropName" : self.tfCrop.text ?? "" , "dateOfSowing" :  self.tfNoOfAcres.text ?? "" ,"Acres_Sowed" : self.tfNoOfAcres.text ?? "" ] as [String : Any]
            
            self.registerFirebaseEvents("SprayServiceSubmitRequest", "", "", "SprayServiceViewController", parameters: fireBaseParams as NSDictionary)
            
            
            let  headers : HTTPHeaders  = ["deviceToken": userObj1.deviceToken as String ,
                                           "userAuthorizationToken": userObj1.userAuthorizationToken! as String ,
                                           "mobileNumber": userObj1.mobileNumber! as! String,
                                           "customerId": userObj1.customerId! as! String,
                                           "deviceId": userObj1.deviceId! as! String]
            
            
            let urlString:String = String(format: "%@%@", arguments: [BASE_URL,SUBMIT_SPRAY_SERVICE_REQUEST])
            let paramsStr1 = Constatnts.nsobjectToJSON(dic as NSDictionary)
            let params =  ["data": paramsStr1]
            print("params %@",params)
            SwiftLoader.show(animated: true)
            //  let headers = Constatnts.getLoggedInFarmerHeaders()
            print("headers : \(headers)")
            Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response)  in
                
                //  DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
                if let json = response.result.value {
                    let responseDic = json as? NSDictionary
                    
                    let responseStatusCode = NSInteger(responseDic?.value(forKey: "statusCode") as? String ?? "0")
                    let message = responseDic?.value(forKey: "message") as? String ?? "0"
                    if responseStatusCode == 200{
                        let userObj = Constatnts.getUserObject()
                        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId! , "screen_name" : "SprayServiceViewController" ] as [String : Any]
                        
                        self.registerFirebaseEvents("SprayServiceSubmitRequest", "", "", "SprayServiceViewController", parameters: fireBaseParams as NSDictionary)
                        
                        SwiftLoader.hide()
                       let messageStr = NSLocalizedString("successfully_subscribed_for_spray_services_solutions_message", comment: "")
                        
                        let msg = NSLocalizedString("congratulations", comment: "")
                        let alertController = UIAlertController(title: msg, message: messageStr, preferredStyle: .alert)
                                   
                                   let backButtonAction = UIAlertAction(title: NSLocalizedString("Register", comment: ""), style: .default, handler: {
                                       alert -> Void in
                                    let params : Parameters = ["cropId" : self.cropID ]
                                    self.getNumberScansDoneByRequester(Params: params)
                                   })
                        let backButtonAction1 = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .default, handler: {
                                                             alert -> Void in
                            self.navigationController?.popViewController(animated: true)
                                                         })
                                   alertController.addAction(backButtonAction)
                         alertController.addAction(backButtonAction1)
                                   self.present(alertController, animated: true, completion: nil)
//                        self.showNormalAlert(title: "Congratulations", message: message)
                          self.clearTextFields()
                    }
                    else  if responseStatusCode == 102{
                        SwiftLoader.hide()
                        let alreadySubscribedMsg = NSLocalizedString("Already_subscribed_Message", comment: "")
                        self.view.makeToast(alreadySubscribedMsg)
                    }
                    else{
                        let userObj = Constatnts.getUserObject()
                        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId! , "screen_name" : "SprayServiceViewController" ] as [String : Any]
                        
                        self.registerFirebaseEvents("SpraySerApiRequestSomethingWrong", "", "", "SprayServiceViewController", parameters: fireBaseParams as NSDictionary)
                        
                        SwiftLoader.hide()
                        self.view.makeToast(message)
                    }
                }
                else{
                    SwiftLoader.hide()
                    print("error")
                    self.view.makeToast("Error occured!")
                }
            }
        }
        else {

                 if self.tfCrop.text == "" {
                     self.view.makeToast("Select_Crop".localized)
            }
               else if self.tfDateOfSowing.text == "" {
                   self.view.makeToast("date_select".localized)
            }
            else if self.tfNoOfAcres.text  == "" {
                self.view.makeToast("acres_hint".localized)
            }
        }
    }
    func getNumberScansDoneByRequester(Params : Parameters){
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_NumberOfScansRequester])
        let userObj1 : User =  Constatnts.getUserObject()
        let  headers : HTTPHeaders  = ["deviceToken": userObj1.deviceToken as String ,
                                       "userAuthorizationToken": userObj1.userAuthorizationToken! as String ,
                                       "mobileNumber": userObj1.mobileNumber! as String,
                                       "customerId": userObj1.customerId! as String,
                                       "deviceId": userObj1.deviceId! as String]
        
        Alamofire.request(urlString, method: .post, parameters: Params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                print(response)
                if let json = response.result.value {
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                    if responseStatusCode == STATUS_CODE_200{
                        let userObj = Constatnts.getUserObject()
                        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"screen_name" : "RetailerInformationViewController" ] as [String : Any]
                        //
                        self.registerFirebaseEvents("PV_Retailer_CropMaster_success", userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "RetailerInformationViewController" , parameters: fireBaseParams as NSDictionary)
                        let respData = (json as? NSDictionary)?.value(forKey: "response") as? NSString ?? ""
                        let decryptData  = Constatnts.convertToDictionary(text: respData as String)
                        print("Response after decrypting data:\(decryptData)")
                        self.noOfAcres = decryptData?["noOfAcres"] as? Int ?? 0
                        self.noOfScans = decryptData?["noOfScans"] as? Int ?? 0
                        if self.noOfScans == 0 {
                            let popOverVC = self.storyboard?.instantiateViewController(withIdentifier: "NumberOfAcresViewController") as? NumberOfAcresViewController
                            popOverVC?.cropID = self.cropID
                            popOverVC?.noOfAcres = self.noOfAcres
                            popOverVC!.delegate = self
                            self.addChildViewController(popOverVC!)
                            popOverVC!.view.frame = self.view.frame
                            self.view.addSubview(popOverVC!.view)
                            popOverVC!.didMove(toParentViewController: self)
                        }else if self.noOfAcres == self.noOfScans {
                            let RetailerInformationVC = self.storyboard?.instantiateViewController(withIdentifier: "RetailerInformationViewController") as? RetailerInformationViewController
                              RetailerInformationVC?.cropID = self.cropID
                            RetailerInformationVC?.cropName = self.tfCrop.text!
                            self.navigationController?.pushViewController(RetailerInformationVC!, animated: true)
                        }else {
                            let appdele = UIApplication.shared.delegate as? AppDelegate
                            appdele?.isOpennedGenuinityCheckFromOffers = true
                            let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                            toSelectPayVC?.isFromSprayServiceScanner = true
                            toSelectPayVC?.noOfAcres = self.noOfAcres
                            toSelectPayVC?.noOfScans = self.noOfScans
                            let delegate = UIApplication.shared.delegate as? AppDelegate
                            delegate?.numberOfScans =  self.noOfScans
                            toSelectPayVC?.cropId =  self.cropID
                            self.navigationController?.pushViewController(toSelectPayVC!, animated: false)
                        }
                        
                    }
                    else if responseStatusCode == CROP_ADVISORY_NOT_AVAILABLE_151{
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    } else if responseStatusCode == STATUS_CODE_105{
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    else if responseStatusCode == STATUS_CODE_601{
                        Constatnts.logOut()
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    }
                }
            }
            else{
                self.view.makeToast((response.error?.localizedDescription)!)
            }
        }
    }

   /* func openGenunityCheckScanner(){
         let userObj = Constatnts.getUserObject()

        ClientConstants.initialize(
            deploymentEnvironment: .Test,
            isLocationRequired: true,
            guidingImage: UIImage(named: "uniquo_guidingImage"),
            enableButton: (info: false, back: true),
            color: (theme: App_Theme_Blue_Color,
                    frame: App_Theme_Blue_Color,
                    dots: App_Theme_Blue_Color),
            userDetails: UQUserDetails(userId:userObj.customerId! as String, mobile: "" , email: "", fullName: "")
        )
        let vc: UQScannerViewController = UQScannerViewController.instantiate()
        vc.scanDelegate  = self
        scannerVc = vc
        self.present(scannerVc!, animated: true, completion: nil)
    }*/
    
    /*func onScanCompletion(result: UQScanResult) {
        //result.dictionary will provide [String:Any] JSON response
        //result.model will provide the object of Scanned Result (Optional)
        //result.error will provide the error while parsing the JSON to Model (Optional)

        scannerVc?.dismissUQScanner(animated: true, cb: {
            self.scannerVc =  nil
        })
        if statusMsgAlert != nil{
            self.statusMsgAlert?.removeFromSuperview()
        }

        var scanResult = result.dictionary as Dictionary

        var message = String(format: "%@", scanResult["message"] as! CVarArg)
        var ststusLogo = UIImage(named: "GenuinityFailure")

        let userObj = Constatnts.getUserObject()
        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Genunity_Status_Code:scanResult["responseCode"] ?? "",Product_Deatils:scanResult["productDetails"] ?? "",Serial_Number:scanResult["serialNumber"] ?? ""] as [String : Any]
        if scanResult["responseCode"] as? Int == Genunity_Status_Code_100{
            message = String(format: "%@ \n Serial number: %@",GenunitySuccessMessage, scanResult["serialNumber"] as! CVarArg )
            ststusLogo = UIImage(named: "GenuinitySuccess")
            self.registerFirebaseEvents(Genuinity_Check_Success, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
        }
        else if scanResult["responseCode"] as? Int == Genunity_Status_Code_101 || scanResult["responseCode"] as? Int == Genunity_Status_Code_102{
            message = String(format: GenunityFailureMessage, scanResult["message"] as! CVarArg)
            ststusLogo = UIImage(named: "GenuinityFailure")
            if scanResult["responseCode"] as? Int == Genunity_Status_Code_101 {
                self.registerFirebaseEvents(Genuine_Label_Inactive, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
            }
            else{
                self.registerFirebaseEvents(Scanned_Label_Invalid, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
            }
        }
        else if scanResult["responseCode"] as? Int == Genunity_Status_Code_103{
            message = String(format: GenunityAttemptsExceedMessage, scanResult["message"] as! CVarArg )
            ststusLogo = UIImage(named: "GenunityAttempts")
            self.registerFirebaseEvents(GC_Scan_Limt_Exceeded, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
        }
        else if scanResult["responseCode"] as? Int == Genunity_Status_Code_104{
            self.registerFirebaseEvents(GC_Not_Geniune, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
        }
        else if scanResult["responseCode"] as? Int == Genunity_Status_Code_105{
            message = String(format: "%@", scanResult["message"] as! CVarArg)
            ststusLogo = UIImage(named: "GenuinityFailure")
            self.registerFirebaseEvents(message, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
        }
        else{
            message = scanResult["message"] as! String
        }

        let paramsStr = try! JSONSerialization.data(withJSONObject: scanResult, options: .prettyPrinted)

        let jsonString = NSString(data: paramsStr, encoding: String.Encoding.utf8.rawValue)! as String

        print("String result    \(jsonString)")

        Singleton.submitScannedUniquoBarcodeResultDataToServerNew(scanResult: result.dictionary, userMessage: message, completeResponse: jsonString, selectedLabel: "") { (status, responseDictionary, statusMessage) in

            if status == true{
                self.dictEncashResponse = NSDictionary()
             print(responseDictionary)
                self.dictEncashResponse = responseDictionary ?? NSDictionary()
                 let delegate = UIApplication.shared.delegate as? AppDelegate
                 delegate!.numberOfScans = delegate!.numberOfScans + 1
                 let params : Parameters = ["noOfScans": delegate!.numberOfScans , "cropId" : self.cropId]
                 
                 if self.noOfAcres > delegate!.numberOfScans {
                      self.submitNumberScanningsCount(Params: params)
                 }
                
             


                //            self.statusMsgAlert = CustomAlert.genunityCheckResultPopup(self, frame: self.view.frame, title: ("Genuinity Check" as NSString?)!, message: responseDictionary?.value(forKey: "uq_message") as? NSString ?? "N/A", buttonTitle: "OK", imgCorteva:  UIImage(named:"corteva")!, statusLogo: ststusLogo!, hideClose: true,rewardMessage: responseDictionary?.value(forKey: "primaryRewardMsg" as? NSString ?? "N/A"),rewardMessage1: responseDictionary?.value(forKey: "secondaryRewardMsg" as? NSString ?? "N/A"), showEncashBtn: true) as? UIView
                var strCashReward = ""
                if self.dictEncashResponse?.value(forKey: "rewardPoints") as? String != "" && self.dictEncashResponse?.value(forKey: "rewardPoints")  != nil {
                    let rupee = "\u{20B9} "

                    strCashReward  = String(format: "Cash Back : %@%@/-",rupee,self.dictEncashResponse?.value(forKey: "rewardPoints") as? CVarArg ?? "")
                }else {
                    strCashReward = ""
                }

                let appDelegate = UIApplication.shared.delegate as! AppDelegate
             self.statusMsgAlert = CustomAlert.genunityCheckResultPopup(self, frame: appDelegate.window?.frame ?? self.view.frame, title: ("Genuinity Check" as NSString?)!, message: responseDictionary?.value(forKey: "uq_message") as? NSString ?? "N/A", buttonTitle1: responseDictionary?.value(forKey: "buttonTitle1") as? NSString ?? "", buttonTitle2: responseDictionary?.value(forKey: "buttonTitle2") as? NSString ?? "" , imgCorteva: UIImage(named:"corteva")!, statusLogo: ststusLogo!, hideClose: true, rewardMessage: responseDictionary?.value(forKey: "primaryRewardMsg") as? NSString ?? "", rewardMessage1: responseDictionary?.value(forKey: "secondaryRewardMsg") as? NSString ?? "", showEncashBtn: responseDictionary?.value(forKey: "showClickableLink") as? Bool ?? false,prodSerialNo: responseDictionary?.value(forKey: "prodSerialNumber") as? NSString ?? "",cashBackMsg: strCashReward as NSString, productName: responseDictionary?.value(forKey: "productName") as? NSString ?? "",  enableSprayService: responseDictionary?.value(forKey: "enableSprayService") as? Bool ?? false) as? UIView
                appDelegate.window?.rootViewController?.view.addSubview(self.statusMsgAlert!)
                //            self.view.addSubview(self.statusMsgAlert!)
            }else{
                self.view.makeToast(statusMessage ?? "Oops! Some thing went wrong. Please try again.")
            }
        }
    }*/
    
    

        func submitNumberScanningsCount(Params : Parameters){
                let urlString:String = String(format: "%@%@", arguments: [BASE_URL,SUBMIT_NumberOfScansRequester])
                let userObj1 : User =  Constatnts.getUserObject()
                let  headers : HTTPHeaders  = ["deviceToken": userObj1.deviceToken as String ,
                                               "userAuthorizationToken": userObj1.userAuthorizationToken! as String ,
                                               "mobileNumber": userObj1.mobileNumber! as String,
                                               "customerId": userObj1.customerId! as String,
                                               "deviceId": userObj1.deviceId! as String]
                
                Alamofire.request(urlString, method: .post, parameters: Params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                    SwiftLoader.hide()
                    if response.result.error == nil {
                        print(response)
                        if let json = response.result.value {
                            let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                            if responseStatusCode == STATUS_CODE_200{
                                let userObj = Constatnts.getUserObject()
                             let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"screen_name" : "RetailerInformationViewController" ] as [String : Any]
                                                                    //
                                                  self.registerFirebaseEvents("PV_Retailer_CropMaster_success", userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "RetailerInformationViewController" , parameters: fireBaseParams as NSDictionary)
                                let respData = (json as? NSDictionary)?.value(forKey: "response") as? NSString ?? ""
                                                       let decryptData  = Constatnts.convertToDictionary(text: respData as String)
                                                        print("Response after decrypting data:\(decryptData)")
                              
    //                            if self.noOfAcres == 0 {
    //                                let popOverVC = self.storyboard?.instantiateViewController(withIdentifier: "NumberOfAcresViewController") as? NumberOfAcresViewController
    //                                popOverVC!.delegate = self
    //                                self.addChildViewController(popOverVC!)
    //                                popOverVC!.view.frame = self.view.frame
    //                                self.view.addSubview(popOverVC!.view)
    //                                popOverVC!.didMove(toParentViewController: self)
    //                            }else if self.noOfAcres == self.noOfAcres {
    //                                let appdele = UIApplication.shared.delegate as? AppDelegate
    //                                    appdele?.isOpennedGenuinityCheckFromOffers = true
    //                                let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
    //                                self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
    //                            }
                               
                            }
                            else if responseStatusCode == CROP_ADVISORY_NOT_AVAILABLE_151{
                                if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                    self.view.makeToast(msg as String)
                                }
                            } else if responseStatusCode == STATUS_CODE_105{
                                if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                    self.view.makeToast(msg as String)
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                            else if responseStatusCode == STATUS_CODE_601{
                                Constatnts.logOut()
                                if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                    self.view.makeToast(msg as String)
                                }
                            }
                        }
                    }
                    else{
                        self.view.makeToast((response.error?.localizedDescription)!)
                    }
                }
            }

    func onBackPressed() {
      /*  scannerVc?.dismissUQScanner(animated: true, cb: {
            self.scannerVc =  nil
        })*/
    }
    @objc func infoAlertScanMore(){
       
        if self.statusMsgAlert != nil {
            self.statusMsgAlert?.removeFromSuperview()
        }
        
         let delegate = UIApplication.shared.delegate as? AppDelegate
//        if isFromSprayServiceScanner == true {
//            if noOfAcres == delegate?.numberOfScans {
//                       let retailerInfoVC = self.storyboard?.instantiateViewController(withIdentifier: "RetailerInformationViewController") as? RetailerInformationViewController
//                       self.navigationController?.pushViewController(retailerInfoVC!, animated: true)
//                   }else {
//                    self.openGenunityCheckScanner()
//            }
//        } else {
//             self.openGenunityCheckScanner()
//        }
       
        
    }
    @objc func infoCloseButton(){
        
        if self.statusMsgAlert != nil {
            self.statusMsgAlert?.removeFromSuperview()
        }
        
    }
    @objc func infoAlertSubmit(){
        let userObj = Constatnts.getUserObject()
        if self.statusMsgAlert != nil {
            self.registerFirebaseEvents(GC_Exit, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "SideMenuViewController", parameters: nil)
            self.statusMsgAlert?.removeFromSuperview()
        }
        let multipleRewards =  dictEncashResponse?.value(forKey: "multipleRewards") as? Bool
        if  multipleRewards == true {
            self.registerFirebaseEvents(GC_Claim, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "HomeViewController", parameters: nil)
            let rewardsVC = self.storyboard?.instantiateViewController(withIdentifier: "RewardsViewController") as? RewardsViewController
            self.navigationController?.pushViewController(rewardsVC!, animated: true)
            return
        }
        let multipleRewards1 =  dictEncashResponse?.value(forKey: "multipleRewards") as? Bool
         let showClickableLink =  dictEncashResponse?.value(forKey: "showClickableLink") as? Bool
        if  multipleRewards1 == false &&  showClickableLink == true {
            let userObj = Constatnts.getUserObject()
            
            let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"rewardPoints" : dictEncashResponse?.value(forKey: "rewardPoints"),"screen_name" : "HomeViewController", "serverRecordId" : dictEncashResponse?.value(forKey: "serverRecordId")] as [String : Any]
            
            self.registerFirebaseEvents(Selected_Payment_Option_Confirm, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "HomeViewController", parameters: fireBaseParams as NSDictionary)
            
                    let keys = self.dictEncashResponse?.allKeys as NSArray?
                var claimIDsArray = NSMutableArray()
                var params = NSDictionary()
                if (keys?.contains("ecouponFarmerId"))! {
                         params = [ "serverRecordId" : dictEncashResponse?.value(forKey: "serverRecordId") as? NSString ?? "","benfTransactionId" : dictEncashResponse?.value(forKey: "benfTransactionId") as? NSString ?? "","ecouponFarmerMapId":dictEncashResponse?.value(forKey: "ecouponFarmerId") as? NSString ?? "" ]
                }else {
                        params = [ "serverRecordId" : dictEncashResponse?.value(forKey: "serverRecordId") as? NSString ?? "","benfTransactionId" : dictEncashResponse?.value(forKey: "benfTransactionId") as? NSString ?? ""]
                }
            
             
      
            claimIDsArray.add(params)
            let strCashReward  = self.dictEncashResponse?.value(forKey: "cashRewards") as? String // String(format: "Cash Back : Rs.%@/-",self.dictEncashResponse?.value(forKey: "cashRewards") as! CVarArg)
            
            var isRewardClaims : Bool = true
                
                   var parameters = NSDictionary()
                   if (keys?.contains("ecouponFarmerId"))! {
                       isRewardClaims = false
                        parameters = ["cashRewards":strCashReward ?? "","claimIDs":claimIDsArray,"ecouponFarmerMapId":dictEncashResponse?.value(forKey: "ecouponFarmerId") as? NSString ?? "","enableSprayService": dictEncashResponse?.value(forKey: "enableSprayService") as? Bool ?? false] as NSDictionary
                   }else {
                       isRewardClaims = true
                       parameters = ["cashRewards":strCashReward ?? "","claimIDs":claimIDsArray,"enableSprayService": dictEncashResponse?.value(forKey: "enableSprayService") as? Bool ?? false] as NSDictionary
                   }
            
            let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectModeOfTransferViewController") as? SelectModeOfTransferViewController
            toSelectPayVC?.dictEncashResponse = parameters  //dictEncashResponse
            toSelectPayVC?.isRewardClaims = isRewardClaims
            self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
        }
    }
    
    @objc func gotoEncashPointsPage(){
        if self.statusMsgAlert != nil {
            self.statusMsgAlert?.removeFromSuperview()
        }
        let userObj = Constatnts.getUserObject()
        
        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"rewardPoints" : dictEncashResponse?.value(forKey: "rewardPoints"),"screen_name" : "HomeViewController", "serverRecordId" : dictEncashResponse?.value(forKey: "serverRecordId")] as [String : Any]
        
        self.registerFirebaseEvents(Selected_Payment_Option_Confirm, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "HomeViewController", parameters: fireBaseParams as NSDictionary)
           let keys = self.dictEncashResponse?.allKeys as NSArray?
        var claimIDsArray = NSMutableArray()
        var params = NSDictionary()
        if (keys?.contains("ecouponFarmerId"))! {
                 params = [ "serverRecordId" : dictEncashResponse?.value(forKey: "serverRecordId") as? NSString ?? "","benfTransactionId" : dictEncashResponse?.value(forKey: "benfTransactionId") as? NSString ?? "","ecouponFarmerMapId":dictEncashResponse?.value(forKey: "ecouponFarmerId") as? NSString ?? ""]
        }else {
                params = [ "serverRecordId" : dictEncashResponse?.value(forKey: "serverRecordId") as? NSString ?? "","benfTransactionId" : dictEncashResponse?.value(forKey: "benfTransactionId") as? NSString ?? ""]
        }
    
        claimIDsArray.add(params)
        let strCashReward  = self.dictEncashResponse?.value(forKey: "cashRewards") as? String // String(format: "Cash Back : Rs.%@/-",self.dictEncashResponse?.value(forKey: "cashRewards") as! CVarArg)
        var isRewardClaims : Bool = true
     
        var parameters = NSDictionary()
        if (keys?.contains("ecouponFarmerId"))! {
            isRewardClaims = false
             parameters = ["cashRewards":strCashReward ?? "","claimIDs":claimIDsArray,"ecouponFarmerMapId":dictEncashResponse?.value(forKey: "ecouponFarmerId") as? NSString ?? ""] as NSDictionary
        }else {
            isRewardClaims = true
            
            parameters = ["cashRewards":strCashReward ?? "","claimIDs":claimIDsArray] as NSDictionary
        }
         
        
        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectModeOfTransferViewController") as? SelectModeOfTransferViewController
        toSelectPayVC?.dictEncashResponse = parameters  //dictEncashResponse
        toSelectPayVC?.isRewardClaims = isRewardClaims
        self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
        
    }
    open  func clearTextFields(){
        cistomView.cropTF.text = ""
        cistomView.categoryTxtFld.text = ""
        cistomView.dateOfSowingTF.text = ""
        cistomView.hybridTf.text = ""
        self.cistomView.noOfAcresTxtField.text  = ""
        selectedTextField = UITextField()
    }
    
}

//MARK:- UITEXTFIELDDELEGATE METHODS
extension SprayServiceViewController : UITextFieldDelegate{
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        if textField == self.tfCrop{
            textField.resignFirstResponder()
            
            crop_dropDownTable = UITableView()
            crop_dropDownTable.reloadData()
            self.hideUnhideDropDownTblView(tblView: crop_dropDownTable, hideUnhide: false)
        }
        
        
    }
    
    
    func loadTable( textField: UITextField, table : UITableView){
        self.loadDropDownTableView( tableview: table, textField: textField)
        table.dataSource = self
        table.delegate   = self
        table.reloadData()
        self.hideUnhideDropDownTblView(tblView: table, hideUnhide: table.isHidden)
    }
    
    //MARK:- DROPDOWN TABLE VIEW DESIGN LOADS
    func loadDropDownTableView(tableview:UITableView,textField:UITextField){
        tableview.isScrollEnabled = true
        tableview.isHidden = true
        tableview.layer.borderWidth = 0.5
        tableview.layer.borderColor = UIColor.blue.cgColor
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.estimatedRowHeight = 30
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.tableFooterView = UIView()
        self.view.addSubview(tableview)
        let xConstraint = NSLayoutConstraint.init(item: tableview, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem:textField , attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0.0) as NSLayoutConstraint
        let yConstraint = NSLayoutConstraint.init(item: tableview, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem:textField , attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0) as NSLayoutConstraint
        let widthConstraint = NSLayoutConstraint.init(item: tableview, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem:textField , attribute: NSLayoutConstraint.Attribute.width, multiplier: 1.0, constant: 0.0) as NSLayoutConstraint
        let heightConstraint = NSLayoutConstraint.init(item: tableview, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem:textField , attribute: NSLayoutConstraint.Attribute.height, multiplier: 1.0, constant: 120) as NSLayoutConstraint //height constant : 120
        self.view.addConstraints([xConstraint,yConstraint,widthConstraint,heightConstraint])
    }
    
    
    // ------------------------------- //
    // MARK: hideUnhideDropDownTblView
    // ------------------------------- //
    @objc func hideUnhideDropDownTblView(tblView : UITableView, hideUnhide : Bool){
        
        if hybrid_dropDownTable != nil{
            hybrid_dropDownTable.isHidden = true
        }
        if categoryDropDownTblView != nil{
            categoryDropDownTblView.isHidden = true
        }
        
        if crop_dropDownTable != nil{
            crop_dropDownTable.isHidden = true
        }
        //tblView.isHidden = true
        tblView.isHidden = !hideUnhide
        self.view.bringSubview(toFront: tblView)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        //print("TextField did end editing method called")
        //        print("end")
        //        print(self.view.superview?.frame)
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        selectedTextField = textField
        // print("start")
        // print(self.view.frame)
        
        
        if(textField == self.tfCrop){
            textField.resignFirstResponder()
            crop_dropDownTable = UITableView()
            
            loadTable(textField:  self.tfCrop , table : crop_dropDownTable)
            return false
        }
            
            
        else if textField == self.tfDateOfSowing{
            textField.resignFirstResponder()
            if(self.tfCrop.text?.count ?? 0 > 0){
                fromDatePickerView()
                return false
            }else{
                self.view.makeToast("Please Select Crop.")
                return false
            }
            
        }
        else{
            return true;
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
}

//MARK:-  PICKER DELEGATE METHODS
extension SprayServiceViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //MARK: DatePickerView
    func fromDatePickerView(){
        let Height:CGFloat = (44.11 * self.view.frame.height/120)
        let width :CGFloat = self.view.frame.size.width-40 //-40
        let posX :CGFloat = (self.view.frame.size.width - width) / 2
        
        fromDateView = UIView (frame: CGRect(x: posX,y: (self.view.frame.height-Height)/2 ,width: width,height: Height))
        fromDateView?.backgroundColor = UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        fromDateView?.layer.cornerRadius = 10.0
        self.view.backgroundColor = UIColor.lightGray
        self.view.alpha = 0.7
        self.view.addSubview(fromDateView!)
//          self.view.isUserInteractionEnabled = false
        //dobPicker
        let dobPicker : UIDatePicker = UIDatePicker (frame: CGRect(x: 5,y: 5,width: width-10,height: Height-50))
        dobPicker.backgroundColor = UIColor.white
        dobPicker.layer.cornerRadius = 5.0
        dobPicker.datePickerMode = UIDatePickerMode.date
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        calendar.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let components: NSDateComponents = NSDateComponents()
        components.calendar = calendar as Calendar
//        components.month = -3 // this is for month
        let minDate: NSDate = calendar.date(byAdding: components as DateComponents, to: Date(), options: NSCalendar.Options(rawValue: 0))! as NSDate
        print("minDate: \(minDate)")
//        dobPicker.minimumDate = minDate as Date
//        dobPicker.maximumDate = NSDate() as Date
//
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        //print("Selected value \(selectedDate)")
        let  curDate  = Date()
        
        let dateToSetStr = dateFormatter.string(from: curDate)
        self.tfDateOfSowing.text = dateToSetStr as String
        dobPicker.date = dateFormatter.date(from: dateToSetStr)!
        
        
        
        dobPicker.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: .valueChanged)
        fromDateView?.addSubview(dobPicker)
        
        //submit button
        let btnOK : UIButton = UIButton (frame: CGRect(x: 0, y: dobPicker.frame.maxY+5,width: width,height: 40))
        btnOK.backgroundColor = UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 0.8)
        btnOK.layer.cornerRadius = 5.0
        btnOK.setTitle("OK", for: UIControlState())
        btnOK.addTarget(self, action: #selector(SprayServiceViewController.alertOK), for: UIControlEvents.touchUpInside)
        fromDateView?.addSubview(btnOK)
        
        let dobFrame = fromDateView?.frame
        fromDateView?.frame.size.height = btnOK.frame.maxY
        fromDateView?.frame = dobFrame!
        
        fromDateView?.frame.origin.y = (self.view.frame.size.height - 64 - (fromDateView?.frame.size.height)!) / 2
        fromDateView?.frame = dobFrame!
    }

    
    //MARK:- datePickerValueChanged
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let selectedDate = dateFormatter.string(from: sender.date) as NSString
        //print("Selected value \(selectedDate)")
        self.tfDateOfSowing.text = selectedDate as String
    }
    
    //REMOVE SOWING PICKER VIEW
    @objc func alertOK(){
          self.view.isUserInteractionEnabled = true
        self.fromDateView?.removeFromSuperview()
    }

}
