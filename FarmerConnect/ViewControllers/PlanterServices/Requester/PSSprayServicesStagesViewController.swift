//
//  PSSprayServicesStagesViewController.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 01/10/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import UIKit
import Alamofire


class PSSprayServicesStagesViewController: BaseViewController, SelectedNumberOfAcresValueDelegate {
   
    var tblCrop = UITableView()
    var cropArray = NSArray()
    var cropNamesArray = NSMutableArray()
    var cropID : Int?
    var selectedTextField = UITextField()
    
    
    @IBOutlet weak var btnSubscription : UIButton!
    @IBOutlet weak var btnBillUpload : UIButton!
    
    @IBOutlet weak var imgBillUpload : UIImageView!
    @IBOutlet weak var imgSubscripotion : UIImageView!
    
    @IBOutlet weak var viewSubscription : UIView!
    @IBOutlet weak var viewBillUpload : UIView!
    
    var sprayRequestDone : Bool = false
    var bookEquipmentDone : Bool = false
    var billUploadDone : Bool = false
    var feedbackSubmissionDone : Bool = false
    
    var noOfAcres : Int = 0
    var noOfScans : Int = 0
    var isFromRequestor : Bool = false
    var isSelected : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let params_Crop =  ["data": ""]
        self.requestToGetCropAdvisoryData(Params: params_Crop)
        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        let userObj = Constatnts.getUserObject()
        if userObj.userLogsAllPrint == "true"{
        self.saveUserLogEventsDetailsToServer()
        }
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
            
            "eventName": Home_PlanterService,
            "className":"PSSprayServicesStagesViewController",
            "moduleName": "PlanterServices",
            
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
    override func viewWillAppear(_ animated: Bool) {
        self.topView?.isHidden = false
        self.lblTitle?.text = NSLocalizedString("planter_services", comment: "")
       
          
        if self.isSelected == true{
             let params : Parameters = ["cropId" : cropID ?? 0 , "cropName" : ""]
          self.requestToGetUserCompletedStages(Params: params )
        }
        self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
    
    }
    
    override func backButtonClick(_ sender: UIButton) {
         //if isFromRequestor == true {
        self.findHamburguerViewController()?.showMenuViewController()
//        }else {
//        self.navigationController?.popViewController(animated: true)
//        }
    }
    
    func requestToGetCropAdvisoryData (Params : [String:String]){
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_CROP_MASTER])
        let userObj1 : User =  Constatnts.getUserObject()
        let  headers : HTTPHeaders  = ["deviceToken": userObj1.deviceToken as String ,
                                       "userAuthorizationToken": userObj1.userAuthorizationToken! as String ,
                                       "mobileNumber": userObj1.mobileNumber! as String,
                                       "customerId": userObj1.customerId! as String,
                                       "deviceId": userObj1.deviceId! as String]
        
        Alamofire.request(urlString, method: .post, parameters: Params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
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
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        // print("Response after decrypting data:\(decryptData)")
                        
                        
                        //                            if let statesArray = decryptData.value(forKey: "stateCodeMaster") as? NSArray{
                        //                                let statesNamesSet =  NSSet(array:statesArray as! [Any])
                        //                                self.stateArray = statesNamesSet.allObjects as NSArray
                        //                                self.stateNamesArray.addObjects(from: statesNamesSet.allObjects)
                        //                            }
                        if let cropsArray = decryptData.value(forKey: "allCrops") as? NSArray{
                            let cropsNamesSet =  NSSet(array:cropsArray as! [Any])
//                            self.cropArray = cropsArray.allObjects as NSArray
                            self.cropNamesArray.addObjects(from: cropsArray as! [Any])
                            if self.cropNamesArray.count > 0 {
                                 let stateDic = self.cropNamesArray.object(at: 0) as? NSDictionary
                                
                                 self.cropID = stateDic?.value(forKey: "id") as? Int ?? 0
                            }
                            let params : Parameters = ["cropId" : self.cropID ?? 0 , "cropName" : ""]
                               self.requestToGetUserCompletedStages(Params: params )
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
extension PSSprayServicesStagesViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cropNamesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellIdentifier)
        cell.textLabel?.font = UIFont.init(name: "Helvetica", size: 13.0)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.sizeToFit()
        cell.textLabel?.text = "hi"
        cell.backgroundColor = UIColor.white
        
        if    tableView == self.tblCrop {
            let stateDic = cropNamesArray.object(at: indexPath.row) as? NSDictionary
            cell.textLabel?.text = stateDic?.value(forKey: "name") as? String
        }
      
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //get crop id
        if self.cropNamesArray.count>0{
            let cropDic = self.cropNamesArray.object(at: indexPath.row) as? NSDictionary
            cropID = cropDic?.value(forKey: "id") as? Int ?? 0
            
            tableView.isHidden = true
        }
        if tblCrop != nil{
            tableView.isHidden = true
        }
        tableView.isHidden = true
        tblCrop.removeFromSuperview()
        let params : Parameters = ["cropId" : cropID ?? 0 , "cropName" : ""]
        self.requestToGetUserCompletedStages(Params: params )
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
             return 35
         
    }
}
extension PSSprayServicesStagesViewController : UITextFieldDelegate{

    
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
        
        if tblCrop != nil{
            tblCrop.isHidden = true
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
    
   
    func requestToGetUserCompletedStages(Params : Parameters){
        
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_SprayCycleStatus])
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
//                        let userObj = Constatnts.getUserObject()
//                                          let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"screen_name" : "RetailerInformationViewController" ] as [String : Any]
//                                                            //
//                                          self.registerFirebaseEvents("PV_Retailer_CropMaster_success", userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "RetailerInformationViewController" , parameters: fireBaseParams as NSDictionary)
                        let respData = (json as? NSDictionary)?.value(forKey: "response") as? NSString ?? ""
                        let decryptData  = Constatnts.convertToDictionary(text: respData as String)
                        // print("Response after decrypting data:\(decryptData)")
                        
                        
                        //                            if let statesArray = decryptData.value(forKey: "stateCodeMaster") as? NSArray{
                        //                                let statesNamesSet =  NSSet(array:statesArray as! [Any])
                        //                                self.stateArray = statesNamesSet.allObjects as NSArray
                        //                                self.stateNamesArray.addObjects(from: statesNamesSet.allObjects)
                        //                            }
                        self.sprayRequestDone = decryptData?["sprayRequestDone"] as? Bool ?? false
                         self.bookEquipmentDone = decryptData?["bookEquipmentDone"] as? Bool ?? false
                         self.billUploadDone = decryptData?["billUploadDone"] as? Bool ?? false
                        self.feedbackSubmissionDone = decryptData?["feedbackSubmissionDone"] as? Bool ?? false
                         if self.sprayRequestDone == false && self.billUploadDone == false &&   self.bookEquipmentDone == false && self.feedbackSubmissionDone == false {
                            DispatchQueue.main.async {
                            }
                 
                        }
                         if self.sprayRequestDone == false {

                        }
                        
                         if self.billUploadDone == false && self.sprayRequestDone == true {
                            let img = UIImage(named: "Register_Select")
                         }  else if self.sprayRequestDone == false {
                        }
                        if self.billUploadDone == true  {
                            let img = UIImage(named: "Register_UnSelect")

                        }else {

                        }
                        if self.bookEquipmentDone == true {

                        }else if self.billUploadDone == true && self.bookEquipmentDone == false {
                        }else if self.sprayRequestDone == false {
    
                        }
                        if self.feedbackSubmissionDone == true {
                        }else if self.feedbackSubmissionDone == false &&  self.bookEquipmentDone == true {
                        }else if self.sprayRequestDone == false {
                        }
                        
                        if self.bookEquipmentDone == true && self.feedbackSubmissionDone == false {
                        }else if self.sprayRequestDone == false {
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
    
    @IBAction func btnSubscriptionClickAfterSubscription(_ sender : UIButton){
          let toRequesterController = self.storyboard?.instantiateViewController(withIdentifier: "PSRequesterViewController") as? PSRequesterViewController
           toRequesterController?.cropID = cropID ?? 0
            toRequesterController?.isFromBookingStages = true
                     self.navigationController?.pushViewController(toRequesterController!, animated: true)
      }
    
    @IBAction func btnRegisterBillDetailsUpload(_ sender : UIButton){

        let planterServiceProvider = self.storyboard?.instantiateViewController(withIdentifier: "PlanterOrdersViewController") as? PlanterOrdersViewController
        planterServiceProvider?.isFromHome = true
        self.navigationController?.pushViewController(planterServiceProvider!, animated: true)
        
//            let toSelectVC = self.storyboard?.instantiateViewController(withIdentifier: "PSSprayServicesStagesDetailViewController") as?   PSSprayServicesStagesDetailViewController
//                       toSelectVC?.cropId = self.cropID!
//                       toSelectVC?.cropName = ""
//                       toSelectVC?.isSubscriptionDone = self.sprayRequestDone
//                       toSelectVC?.isUploadDone = billUploadDone
//                       toSelectVC?.isBookEquipmentDone  = self.bookEquipmentDone
//                       toSelectVC?.isFeedbackSubmitDone = self.feedbackSubmissionDone
//                       self.navigationController?.pushViewController(toSelectVC!, animated: true)
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
                        //print("Response after decrypting data:\(decryptData)")
                        self.noOfAcres = decryptData?["noOfAcres"] as? Int ?? 0
                        self.noOfScans = decryptData?["noOfScans"] as? Int ?? 0
                        if self.noOfScans == 0 {
                            let popOverVC = self.storyboard?.instantiateViewController(withIdentifier: "NumberOfAcresViewController") as? NumberOfAcresViewController
                            popOverVC?.cropID = self.cropID!
                            popOverVC?.noOfAcres = self.noOfAcres
                            popOverVC!.delegate = self
                            self.addChildViewController(popOverVC!)
                            popOverVC!.view.frame = self.view.frame
                            self.view.addSubview(popOverVC!.view)
                            popOverVC!.didMove(toParentViewController: self)
                        }else if self.noOfAcres == self.noOfScans {
                            let RetailerInformationVC = self.storyboard?.instantiateViewController(withIdentifier: "RetailerInformationViewController") as? RetailerInformationViewController
                            RetailerInformationVC?.cropID = self.cropID
                            RetailerInformationVC?.cropName = ""
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
                            toSelectPayVC?.cropId =  self.cropID!
                            toSelectPayVC?.moduleType = "Spray Service"
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

    func numberOfAcresValue(_ value: String) {
           
        UserDefaults.standard.setValue(value, forKey: "numberOfAcres")
        UserDefaults.standard.synchronize()
        
    }
    
    func getVendorFarmerDetails(){
            let urlString = BASE_URL + GET_VENDOR_DATA_TO_SUBMIT_FEEDBACK
            let params = ["cropId": cropID]
            let userObj = Constatnts.getUserObject()
            let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                        "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                        "mobileNumber": userObj.mobileNumber! as String,
                                        "customerId": userObj.customerId! as String,
                                        "deviceId": userObj.deviceId! as String]
            
            let paramsStr = Constatnts.nsobjectToJSON(params as NSDictionary)
                       let params1 =  ["data" : paramsStr]
            
                    Alamofire.request(urlString, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                        
                        SwiftLoader.hide()
                        if response.result.error == nil {
                            if let json = response.result.value {
                                let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String
            //                      let responseMessage  = (json as! NSDictionary).value(forKey: "message") as! String
                                if responseStatusCode == "200"{
                                    let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                                    let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                                    //print("Response after decrypting data:\(decryptData)")
  
                                     let toSelectVC = self.storyboard?.instantiateViewController(withIdentifier: "FarmerFeedbackViewController") as?   FarmerFeedbackViewController
                                    toSelectVC?.vendorName = decryptData.value(forKey: "vendorName") as? String ?? ""
                                    toSelectVC?.vendorMobilNumber = decryptData.value(forKey: "vendorMobileNumber") as? String ?? ""
                                    let acres = decryptData.value(forKey: "sprayedAcres") as? String
                                    toSelectVC?.sprayedAcres = Int(acres ??  "") ?? 0
                                    let noOfAcres = decryptData.value(forKey: "noOfAcres") as? String
                                    toSelectVC?.noOfAcres =  Int(noOfAcres ?? "") ?? 0
                                    self.navigationController?.pushViewController(toSelectVC!, animated: true)
                                    
                                }else if responseStatusCode == "109" {
                                    self.view.makeToast("Vendor not yet submitted feedback")
                                }
                        }
                    }
        }
        }
}
