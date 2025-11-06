//
//  NotificationsViewController.swift
//  FarmerConnect
//
//  Created by Empover on 04/01/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit
import Alamofire

class NotificationsViewController: BaseViewController {

    @IBOutlet weak var tblViewNotifications: UITableView!
    
    var mutArrayToDisplay = NSMutableArray()
    
    @IBOutlet weak var lblNoNotifFound: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tblViewNotifications.dataSource = self
        tblViewNotifications.delegate = self
        tblViewNotifications?.estimatedRowHeight = 30
        tblViewNotifications?.rowHeight = UITableViewAutomaticDimension
        tblViewNotifications.separatorStyle = .none
        tblViewNotifications.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.topView?.isHidden = false
        lblTitle?.text = "Notifications"
        self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
        lblNoNotifFound.isHidden = true
        
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            let userObj = Constatnts.getUserObject()
            let defaults = UserDefaults.standard
            let parameters : NSDictionary?
            var lastSyncTimeStr = ""
            if defaults.value(forKey: "lastSyncTime") != nil{
                lastSyncTimeStr = defaults.value(forKey: "lastSyncTime") as! String
            }
            parameters = ["lastUpdated":lastSyncTimeStr,"customerId":userObj.customerId!] as NSDictionary
            
            let paramsStr1 = Constatnts.nsobjectToJSON(parameters!)
            let params =  ["data": paramsStr1]
            self.requestToGetNotificationsData(Params: params as [String:String])
        }
        else{
            //self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            if let notifArrayObj = appDelegate?.getNotificationDetailsFromDB("NotificationsEntity"){
                if notifArrayObj.count > 0{
                    self.lblNoNotifFound.isHidden = true
                     self.mutArrayToDisplay.removeAllObjects()
                    self.mutArrayToDisplay = notifArrayObj
                    DispatchQueue.main.async {
                        self.tblViewNotifications.reloadData()
                    }
                }
                else{
                    self.lblNoNotifFound.isHidden = false
                    self.lblNoNotifFound.text = "No notifications found"
                }
            }
            else{
                
            }
        }
    }
    
    //MARK: requestToGetNotificationsData
    @objc func requestToGetNotificationsData(Params:[String:String]){
        //SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,NOTIFICATIONS])
        let userObj = Constatnts.getUserObject()
        
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        print(headers)
        
        Alamofire.request(urlString, method: .post, parameters: Params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    print(json)
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        
                        if let respData = (json as! NSDictionary).value(forKey: "response") as? NSString{
                            
                            let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                             //print("Response after decrypting data:\(decryptData)")
                            
                            let defaults = UserDefaults.standard
                            defaults.set(decryptData.value(forKey: "syncTime") as! String, forKey: "lastSyncTime")
                            defaults.synchronize()
                            
                            if let notificationsArray = decryptData.value(forKey: "notifications") as? NSArray{
                                 self.lblNoNotifFound.isHidden = true
                                 self.mutArrayToDisplay.removeAllObjects()
                                
                                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                                //appDelegate?.deleteNotificationDetails()
                                for i in (0..<notificationsArray.count){
                                    let notificationsDict = notificationsArray.object(at: i) as! NSDictionary
                                    let notificationObj = Notifications(dict: notificationsDict)
                                    appDelegate?.saveNotificationDetails(notificationObj)
                                }
                                self.mutArrayToDisplay = (appDelegate?.getNotificationDetailsFromDB("NotificationsEntity"))!
                                print(self.mutArrayToDisplay)
                                
                                DispatchQueue.main.async {
                                    self.tblViewNotifications.reloadData()
                                }
                            }
                        }
                        else{
                            self.lblNoNotifFound.isHidden = false
                            self.lblNoNotifFound.text = "No notifications found"
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
        }
    }
    
    override func backButtonClick(_ sender: UIButton) {
        self.findHamburguerViewController()?.showMenuViewController()
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

extension NotificationsViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mutArrayToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblViewNotifications.dequeueReusableCell(withIdentifier: "NotificationsCell", for: indexPath)
        let notificationsCell = self.mutArrayToDisplay.object(at: indexPath.row) as? Notifications
        
        let lblNotificationMsg = cell.viewWithTag(100) as! UILabel
        let lblCreatedOn = cell.viewWithTag(101) as! UILabel
        
        lblNotificationMsg.text = notificationsCell?.notificationMsg! as String?
        lblCreatedOn.text = notificationsCell?.createdOn! as String?
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
