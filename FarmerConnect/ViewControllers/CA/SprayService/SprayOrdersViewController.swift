//
//  SprayOrdersViewController.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 01/09/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import UIKit
import Alamofire

class SprayOrdersViewController: BaseViewController {
    
    @IBOutlet weak var tblSprayOrders : UITableView!
    @IBOutlet weak var lblNoOrders : UILabel!
    var arraySprayOrders = [SprayOrdersModel]()
    var isFromHome : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userObj = Constatnts.getUserObject()
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
            
            "eventName": Home_vendorOrderList,
            "className":"HomeViewController",
            "moduleName": "SprayServices",
            
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
        self.homeButton?.isHidden = true
        self.lblTitle?.text = NSLocalizedString("Spray_Orders", comment: "")
        
        self.tblSprayOrders.isHidden = false
        
        
        if isFromHome {
            self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        }else{
            self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
        }
        
    }
    override func backButtonClick(_ sender: UIButton) {
        
        if isFromHome{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.findHamburguerViewController()?.showMenuViewController()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
         self.getSprayOrderAPICall()
    }
    func getSprayOrderAPICall() {
        
        SwiftLoader.show(animated: true)
        
        let urlString = BASE_URL + GET_SPRAY_VENDORS
        
        let userObj = Constatnts.getUserObject()
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? NSString
        
        let params : Parameters = ["customerId" : userObj.customerId  , "deviceId" : userObj.deviceId  , "deviceType" :  userObj.deviceType , "mobileNumber" : userObj.mobileNumber , "requestId" : 0 , "status" : 0  , "userType" : "Farmer" , "versionName" : version]
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        print("Response after decrypting data:\(decryptData)")
                        self.arraySprayOrders.removeAll()
                        
                        let userObj = Constatnts.getUserObject()
                        //                         let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"serverID" : self.arrayTransactions[0].serverID ] as [String : Any]
                        //
                        //                          self.registerFirebaseEvents(Reclaim, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", CashFreeRewards , parameters: fireBaseParams as NSDictionary)
                        
                        if let sprayDetailsList = decryptData.value(forKey: "sprayDetailsList") as? NSArray {
                            self.arraySprayOrders.removeAll()
                            if sprayDetailsList.count > 0 {
                                for i in sprayDetailsList {
                                    var arrSprayDetails = SprayOrdersModel()
                                    arrSprayDetails.FarmerName = (i as AnyObject).value(forKey:"farmerName") as? String ?? ""
                                    arrSprayDetails.mobileNumber = (i as AnyObject).value(forKey:"mobileNumber") as? String ?? ""
                                    arrSprayDetails.NoOfAcres = (i as AnyObject).value(forKey:"noOfAcres") as? Int ?? 0
                                    arrSprayDetails.crop = (i as AnyObject).value(forKey:"crop") as? String ?? ""
                                    arrSprayDetails.Address = (i as AnyObject).value(forKey:"address") as? String ?? ""
                                    arrSprayDetails.recordStatus = (i as AnyObject).value(forKey:"recordStatus") as? String ?? ""
                                    arrSprayDetails.id = (i as AnyObject).value(forKey:"id") as? Int ?? 0
                                    self.arraySprayOrders.append(arrSprayDetails)
                                }
                                
                                if self.arraySprayOrders.count > 0 {
                                    self.lblNoOrders.isHidden = true
                                    self.tblSprayOrders.isHidden = false
                                    self.tblSprayOrders.reloadData()
                                    
                                }else {
                                    
                                    self.tblSprayOrders.isHidden = true
                                    self.lblNoOrders.isHidden = false
                                }
                            }else {
                                self.lblNoOrders.isHidden = false
                                self.tblSprayOrders.isHidden = true
                            }
                        }
                    }
                }
            }
        }
    }
}
extension SprayOrdersViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.arraySprayOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblSprayOrders.dequeueReusableCell(withIdentifier: "SprayOrdersTableViewCell", for: indexPath) as? SprayOrdersTableViewCell
        cell?.lblFarmerName.text = ":  " + self.arraySprayOrders[indexPath.row].FarmerName
        cell?.lblMobileNumber.text = ":  " + self.arraySprayOrders[indexPath.row].mobileNumber
        cell?.lblCrop.text = ":  " + self.arraySprayOrders[indexPath.row].crop
        cell?.lblNoOfAcres.text = ":  " + "\(self.arraySprayOrders[indexPath.row].NoOfAcres)"
        if self.arraySprayOrders[indexPath.row].Address == ""{
            cell?.lblAddress.isHidden = true
        }else {
            cell?.lblAddress.isHidden = false
              cell?.lblAddress.text = ":  " + self.arraySprayOrders[indexPath.row].Address
        }
       
        cell?.lblStatus.text  =  self.arraySprayOrders[indexPath.row].recordStatus
        
        if self.arraySprayOrders[indexPath.row].recordStatus.lowercased() == "approve"{
            cell?.lblStatus.textColor = App_Theme_Blue_Color
        }else if  self.arraySprayOrders[indexPath.row].recordStatus.lowercased() == "pending"{
            cell?.lblStatus.textColor = UIColor.red
        }
        return cell!
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedbackController = self.storyboard?.instantiateViewController(withIdentifier: "SprayFeedbackController") as? SprayFeedbackController
        feedbackController?.orderStatus =  self.arraySprayOrders[indexPath.row].recordStatus
        feedbackController?.recordID =  self.arraySprayOrders[indexPath.row].id
        feedbackController?.farmerMobilNumber = self.arraySprayOrders[indexPath.row].mobileNumber
        feedbackController?.farmerName  = self.arraySprayOrders[indexPath.row].FarmerName
        feedbackController?.crop =  self.arraySprayOrders[indexPath.row].crop
        feedbackController?.noOfAcres = self.arraySprayOrders[indexPath.row].NoOfAcres
        feedbackController?.address  = self.arraySprayOrders[indexPath.row].Address
        self.navigationController?.pushViewController(feedbackController!, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    
    @IBAction func btnViewDetails(_ sender : UIButton) {
        let feedbackController = self.storyboard?.instantiateViewController(withIdentifier: "SprayFeedbackController") as? SprayFeedbackController
        self.navigationController?.pushViewController(feedbackController!, animated: true)
    }
}
struct SprayOrdersModel {
    var FarmerName : String = ""
    var mobileNumber : String = ""
    var crop : String = ""
    var NoOfAcres : Int = 0
    var Address : String = ""
    var recordStatus : String = ""
    var id : Int = 0
}
