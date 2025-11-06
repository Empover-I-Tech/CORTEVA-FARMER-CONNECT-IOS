//
//  RequesterOrdersListViewController.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 11/09/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import UIKit
import Alamofire

class RequesterOrdersListViewController: BaseViewController {
  
        @IBOutlet weak var tblSprayOrders : UITableView!
        @IBOutlet weak var lblNoOrders : UILabel!
        var arraySprayOrders = [SprayReqesterOrdersModel]()
        var isFromHome : Bool = false
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.getSprayRequesterOrdersAPICall()
            // Do any additional setup after loading the view.
        }
        
        override func viewWillAppear(_ animated: Bool) {
            self.topView?.isHidden = false
            self.homeButton?.isHidden = true
            self.lblTitle?.text = "Spray Orders"
            
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
        func getSprayRequesterOrdersAPICall() {
            
            SwiftLoader.show(animated: true)
            
            let urlString = BASE_URL + SPRAY_REQUESTER_ORDERS_LIST
            
            let userObj = Constatnts.getUserObject()
            let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                        "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                        "mobileNumber": userObj.mobileNumber! as String,
                                        "customerId": userObj.customerId! as String,
                                        "deviceId": userObj.deviceId! as String]
            
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? NSString
            
            let parameters : Parameters = ["customerId" : userObj.customerId!  , "deviceId" : userObj.deviceId!  , "deviceType" :  userObj.deviceType , "mobileNumber" : userObj.mobileNumber  , "userType" : "Farmer" , "versionName" : version]
            
                    let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
                    let params =  ["data" : paramsStr]
            
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
                            
                            if let sprayDetailsList = decryptData.value(forKey: "requestersprayDetailsList") as? NSArray {
                                self.arraySprayOrders.removeAll()
                                if sprayDetailsList.count > 0 {
                                    for i in sprayDetailsList {
                                        var arrSprayDetails = SprayReqesterOrdersModel()
                                        arrSprayDetails.vendorName = (i as AnyObject).value(forKey:"vendorName") as? String ?? ""
                                        arrSprayDetails.vendorMobileNumber = (i as AnyObject).value(forKey:"vendorMobileNumber") as? String ?? ""
                                        arrSprayDetails.NoOfAcres = (i as AnyObject).value(forKey:"noOfAcres") as? Int ?? 0
                                        arrSprayDetails.sprayRequestId = (i as AnyObject).value(forKey:"sprayRequestId") as? Int ?? 0
                                        arrSprayDetails.sprayedAcres = (i as AnyObject).value(forKey:"sprayedAcres") as? Int ?? 0
                                        arrSprayDetails.recordId = (i as AnyObject).value(forKey:"recordId") as? Int ?? 0
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
    //                                var arrSprayDetails = SprayOrdersModel()
    //                                arrSprayDetails.FarmerName =
    //                                "kavya"
    //                                arrSprayDetails.mobileNumber =  "123456789"
    //                                arrSprayDetails.NoOfAcres =  "2"
    //                                arrSprayDetails.crop =  "Rice"
    //                                arrSprayDetails.Address = "ghhjgjklhi;k dyyiutmn rytujug "
    //                                arrSprayDetails.recordStatus = "completed"
    //                                self.arraySprayOrders.append(arrSprayDetails)
                                    self.lblNoOrders.isHidden = false
                                    self.tblSprayOrders.isHidden = true
    //                                self.tblSprayOrders.reloadData()
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
extension RequesterOrdersListViewController : UITableViewDelegate , UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return  self.arraySprayOrders.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tblSprayOrders.dequeueReusableCell(withIdentifier: "SprayOrdersTableViewCell", for: indexPath) as? SprayOrdersTableViewCell
            cell?.lblFarmerName.text = ":  " + self.arraySprayOrders[indexPath.row].vendorName
            cell?.lblMobileNumber.text = ":  " + self.arraySprayOrders[indexPath.row].vendorMobileNumber
            cell?.lblNoOfAcres.text = ":  " + "\(self.arraySprayOrders[indexPath.row].NoOfAcres)"
            cell?.lblAddress.text = ":  " + "\(self.arraySprayOrders[indexPath.row].sprayedAcres)"
        
            
           
            return cell!
            
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let feedbackController = self.storyboard?.instantiateViewController(withIdentifier: "FarmerFeedbackViewController") as? FarmerFeedbackViewController
            feedbackController?.recordID =  self.arraySprayOrders[indexPath.row].id
            feedbackController?.vendorMobilNumber = self.arraySprayOrders[indexPath.row].vendorMobileNumber
            feedbackController?.vendorName  = self.arraySprayOrders[indexPath.row].vendorName
            feedbackController?.noOfAcres = self.arraySprayOrders[indexPath.row].NoOfAcres
            feedbackController?.sprayedAcres  = self.arraySprayOrders[indexPath.row].sprayedAcres
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
struct SprayReqesterOrdersModel {
    var vendorName : String = ""
    var vendorMobileNumber : String = ""
    var NoOfAcres : Int = 0
    var recordId : Int = 0
    var sprayRequestId : Int = 0
    var sprayedAcres : Int = 0
     var id : Int = 0
}


