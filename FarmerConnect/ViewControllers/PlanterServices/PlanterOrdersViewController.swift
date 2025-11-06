//
//  PlanterOrdersViewController.swift
//  FarmerConnect
//
//  Created by Empover i-Tech on 29/03/23.
//  Copyright © 2023 ABC. All rights reserved.
//

import UIKit
import Alamofire

class PlanterOrdersViewController: BaseViewController {
    
    @IBOutlet weak var tblPlanterOrders : UITableView!
    @IBOutlet weak var lblNoOrders : UILabel!
    var arrayPlanterOrders = [PlanterOrdersModel]()
    var isFromHome : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblNoOrders.text = NSLocalizedString("no_data_available", comment: "")
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
        self.lblTitle?.text = NSLocalizedString("manage_orders", comment: "")
        
        self.tblPlanterOrders.isHidden = false
        
        
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
         self.getPlanterOrderAPICall()
    }
    func getPlanterOrderAPICall() {
        
        SwiftLoader.show(animated: true)
        let userObj = Constatnts.getUserObject()
        let urlString:String!
        if userObj.planterServicesVendor == "true"{
             urlString = BASE_URL + GET_PLANTER_SERVICES_VENDOR_ORDER_LIST
        }
        else{
             urlString = BASE_URL + GET_PLANTER_SERVICES_REQUESTER_ORDER_LIST
        }
        
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
                       // print("Response after decrypting data:\(decryptData)")
                        self.arrayPlanterOrders.removeAll()
                        
                        let userObj = Constatnts.getUserObject()
                        //                         let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"serverID" : self.arrayTransactions[0].serverID ] as [String : Any]
                        //
                        //                          self.registerFirebaseEvents(Reclaim, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", CashFreeRewards , parameters: fireBaseParams as NSDictionary)
                        
                        if let planterDetailsList = decryptData.value(forKey: "planterServiceDetailsList") as? NSArray {
                            self.arrayPlanterOrders.removeAll()
                            if planterDetailsList.count > 0 {
                                for i in planterDetailsList {
                                    var arrPlanterDetails = PlanterOrdersModel()
                                    arrPlanterDetails.FarmerName = (i as AnyObject).value(forKey:"farmerName") as? String ?? ""
                                    arrPlanterDetails.mobileNumber = (i as AnyObject).value(forKey:"mobileNumber") as? String ?? ""
                                    arrPlanterDetails.NoOfAcres = (i as AnyObject).value(forKey:"noOfAcres") as? Int ?? 0
                                    arrPlanterDetails.crop = (i as AnyObject).value(forKey:"crop") as? String ?? ""
                                    arrPlanterDetails.Address = (i as AnyObject).value(forKey:"address") as? String ?? ""
                                    arrPlanterDetails.recordStatus = (i as AnyObject).value(forKey:"recordStatus") as? String ?? ""
                                    arrPlanterDetails.id = (i as AnyObject).value(forKey:"id") as? Int ?? 0
                                    arrPlanterDetails.dateTime = (i as AnyObject).value(forKey:"dateTime") as? String ?? ""
                                    self.arrayPlanterOrders.append(arrPlanterDetails)
                                }
                                
                                if self.arrayPlanterOrders.count > 0 {
                                    self.lblNoOrders.isHidden = true
                                    self.tblPlanterOrders.isHidden = false
                                    self.tblPlanterOrders.reloadData()
                                    
                                }else {
                                    
                                    self.tblPlanterOrders.isHidden = true
                                    self.lblNoOrders.isHidden = false
                                }
                            }else {
                                self.lblNoOrders.isHidden = false
                                self.tblPlanterOrders.isHidden = true
                            }
                        }
                    }else if responseStatusCode == STATUS_CODE_500{
                        self.view.makeToast((json as! NSDictionary).value(forKey: "message") as? String ?? "")
                    }
                    else if responseStatusCode == STATUS_CODE_601{
                        Constatnts.logOut()
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    }
                }
            }
        }
    }
}
extension PlanterOrdersViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.arrayPlanterOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblPlanterOrders.dequeueReusableCell(withIdentifier: "PlanterOrdersTableViewCell", for: indexPath) as? PlanterOrdersTableViewCell
        cell?.btnViewDetails.tag = indexPath.row
        cell?.btnViewDetails.addTarget(self, action: #selector(self.viewDetailAction(_:)), for: .touchUpInside)
        
        cell?.lblFarmerName.text = ":  " + self.arrayPlanterOrders[indexPath.row].FarmerName
        cell?.lblMobileNumber.text = ":  " + self.arrayPlanterOrders[indexPath.row].mobileNumber
        //cell?.lblCrop.text = ":  " + self.arrayPlanterOrders[indexPath.row].crop
        cell?.lblNoOfAcres.text = ":  " + "\(self.arrayPlanterOrders[indexPath.row].NoOfAcres)"
        if self.arrayPlanterOrders[indexPath.row].Address == ""{
            cell?.lblAddress.isHidden = true
        }else {
            cell?.lblAddress.isHidden = false
            cell?.lblAddress.text = ":  " + self.arrayPlanterOrders[indexPath.row].Address
            
        }
        cell?.lblDateAndTime.text = ":  " + self.arrayPlanterOrders[indexPath.row].dateTime
        cell?.lblDateAndTime.numberOfLines = 0
        
        cell?.lblStatus.text  = ":  " + self.arrayPlanterOrders[indexPath.row].recordStatus
        
        if self.arrayPlanterOrders[indexPath.row].recordStatus.lowercased() == "completed"{
            cell?.lblStatus.textColor = UIColor(red: 40.0/255.0, green: 167.0/255.0, blue: 69.0/255.0, alpha: 1.0)
        }
        else if  self.arrayPlanterOrders[indexPath.row].recordStatus.lowercased() == "accepted"{
            cell?.lblStatus.textColor = UIColor(red: 47.0/255.0, green: 143.0/255.0, blue: 194.0/255.0, alpha: 1.0)
        }
        else if self.arrayPlanterOrders[indexPath.row].recordStatus.lowercased() == "pending"{
            cell?.lblStatus.textColor = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        }
        else if self.arrayPlanterOrders[indexPath.row].recordStatus.lowercased() == "rejected"{
            cell?.lblStatus.textColor = UIColor(red: 255.0/255.0, green: 14.0/255.0, blue: 14.0/255.0, alpha: 1.0)
        }
        else if self.arrayPlanterOrders[indexPath.row].recordStatus.lowercased() == "closed"{
            cell?.lblStatus.textColor = UIColor(red: 255.0/255.0, green: 126.0/255.0, blue: 31.0/255.0, alpha: 1.0)
        }
        
        return cell!
        
    }
    @objc func viewDetailAction(_ sender : UIButton) {
        let rowTag = sender.tag
        //print("select row is",rowTag)
        let planterApprovalController = self.storyboard?.instantiateViewController(withIdentifier: "PlanterApprovalViewController") as? PlanterApprovalViewController
                planterApprovalController?.id = self.arrayPlanterOrders[rowTag].id
                self.navigationController?.pushViewController(planterApprovalController!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let planterApprovalController = self.storyboard?.instantiateViewController(withIdentifier: "PlanterApprovalViewController") as? PlanterApprovalViewController
//        planterApprovalController?.id = self.arrayPlanterOrders[indexPath.row].id
//        self.navigationController?.pushViewController(planterApprovalController!, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 340
    }
    
    @IBAction func btnViewDetails(_ sender : UIButton) {
        let planterApprovalController = self.storyboard?.instantiateViewController(withIdentifier: "PlanterApprovalViewController") as? PlanterApprovalViewController
        planterApprovalController?.id = 0
        self.navigationController?.pushViewController(planterApprovalController!, animated: true)
    }
}
struct PlanterOrdersModel {
    var FarmerName : String = ""
    var mobileNumber : String = ""
    var crop : String = ""
    var NoOfAcres : Int = 0
    var Address : String = ""
    var recordStatus : String = ""
    var id : Int = 0
    var dateTime: String = ""
}

