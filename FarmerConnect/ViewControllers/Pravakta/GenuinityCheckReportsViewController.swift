//
//  GenunityCheckReportsViewController.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 21/09/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import UIKit
import Alamofire

class GenuinityCheckReportsViewController: BaseViewController {
    
    @IBOutlet weak var tblGenuinityCheckReport : UITableView!
    @IBOutlet weak var lblNoRecords : UILabel!
    
    var arrReports = [ReportsObj]()
    var isFromHome : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ReportsCell", bundle: nil)
        self.tblGenuinityCheckReport.register(nib, forCellReuseIdentifier: "ReportsCell")
        self.getAll_PravaktaReports()
        // Do any addition al setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.lblTitle?.text = "Genuinity Check Results"
    }
    
    func getAll_PravaktaReports() {
        
        SwiftLoader.show(animated: true)
        
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_GENUINITYCHECK_REPORTS])
        
        let userObj = Constatnts.getUserObject()
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        
        let parameters : Parameters = ["mobileNumber" : userObj.mobileNumber! as String]
        
        let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
        let params =  ["data" : paramsStr]
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        print("Response after decrypting data:\(decryptData)")
                        
                        
                        let userObj = Constatnts.getUserObject()
                        
                        if let reportsList = decryptData.value(forKey: "reportsList") as? NSArray {
                            self.arrReports.removeAll()
                            if reportsList.count > 0 {
                                for i in reportsList {
                                    var arrTrans = ReportsObj()
                                    arrTrans.pincode = (i as AnyObject).value(forKey:"pincode") as? String ?? ""
                                    arrTrans.productName = (i as AnyObject).value(forKey:"productName") as? String ?? ""
                                    arrTrans.serialNumber = (i as AnyObject).value(forKey:"serialNumber") as? String ?? ""
                                    arrTrans.dataOfScan = (i as AnyObject).value(forKey:"dataOfScan") as? String ?? ""
                                    arrTrans.message = (i as AnyObject).value(forKey:"responseMessage") as? String ?? ""
                                    self.arrReports.append(arrTrans)
                                }
                                
                                if self.arrReports.count > 0 {
                                    self.tblGenuinityCheckReport.reloadData()
                                    self.lblNoRecords.isHidden = true
                                }else {
                                    self.lblNoRecords.isHidden = false
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
}
extension GenuinityCheckReportsViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReports.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblGenuinityCheckReport.dequeueReusableCell(withIdentifier: "ReportsCell", for: indexPath) as? ReportsCell
        cell?.lblPincode.text = self.arrReports[indexPath.row].pincode
        cell?.lblProductName.text = self.arrReports[indexPath.row].productName
        cell?.lblSerialNo.text = self.arrReports[indexPath.row].serialNumber
        cell?.lblMessage.text = self.arrReports[indexPath.row].message
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd-MMM-yyyy HH:mm:ss"
        let date = dateFormatter.date(from: self.arrReports[indexPath.row].dataOfScan)
        cell?.lblDateOfScan.text =  ": " + dateFormatterPrint.string(from: date ?? Date()) as String
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
struct ReportsObj {
    var pincode : String = ""
    var productName : String = ""
    var serialNumber : String = ""
    var dataOfScan : String = ""
    var message : String = ""
}
