//
//  NotificationsViewController.swift
//  FarmerConnect
//
//  Created by Empover on 10/01/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SwiftyGif
//import SwiftGifOrigin
import Kingfisher

class NotificationsViewController: BaseViewController {
    
    @IBOutlet weak var tblViewNotifications: UITableView!
    
    var mutArrayToDisplay = NSMutableArray()
    var inActiveNotifications = NSMutableArray()
    
    @IBOutlet weak var lblNoNotifFound: UILabel!
    
    var isFromNotification  : Bool = false
    
    var NotificationMsgAlert : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tblViewNotifications.dataSource = self
        tblViewNotifications.delegate = self
        tblViewNotifications?.estimatedRowHeight = 30
        tblViewNotifications?.rowHeight = UITableViewAutomaticDimension
        tblViewNotifications.separatorStyle = .none
        tblViewNotifications.tableFooterView = UIView()
        let nib = UINib(nibName: "NotificationCell", bundle: nil)
        self.tblViewNotifications.register(nib, forCellReuseIdentifier: "notificationCell")
        self.recordScreenView("NotificationsViewController", Notifications_Screen)
        self.registerFirebaseEvents(PV_Notifications, "", "", Notifications_Screen, parameters: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 10.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        super.viewWillAppear(true)
        self.topView?.isHidden = false
        lblTitle?.text =   NSLocalizedString("notifications", comment: "") //"Notifications"
        if isFromNotification == true {
            self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
            if UserDefaults.standard.value(forKey: "badgeCount") != nil {
                          let badgeCount = UserDefaults.standard.value(forKey: "badgeCount") as? Int
                          //                let NCount = Int(badgeCount ?? "0") ?? 0
                                          UIApplication.shared.applicationIconBadgeNumber = badgeCount!-1
                                          UserDefaults.standard.setValue(UIApplication.shared.applicationIconBadgeNumber, forKey: "badgeCount")
                      }
        }else {
            self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
        }
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
//    let PV_Notifications_Delete = "PV_Notifications_Delete"
//    let PV_Notifications_Move_to_Alert = "PV_Notifications_Move_to_Alert"
//    let PV_Notifications_Success = "PV_Notifications_Success"
//    let PV_Notifications_Fail = "PV_Notifications_Fail"
//    let PV_Notifications_Alert_Page = "PV_Notifications_Alert_Page"
    //MARK: requestToGetNotificationsData
    @objc func requestToGetNotificationsData(Params:[String:String]){
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,NOTIFICATIONS])
        let userObj = Constatnts.getUserObject()
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        
        Alamofire.request(urlString, method: .post, parameters: Params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    // print(json)
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                
                        let userObj = Constatnts.getUserObject()
                        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId]
                        self.registerFirebaseEvents(PV_Notifications_Success, "", "", "", parameters: fireBaseParams as NSDictionary)
                        
                        if let respData = (json as! NSDictionary).value(forKey: "response") as? NSString{
                            let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                            //print("Response after decrypting data:\(decryptData)")
                            let defaults = UserDefaults.standard
                            defaults.set(decryptData.value(forKey: "syncTime") as! String, forKey: "lastSyncTime")
                            defaults.synchronize()
                            if let notificationsArray = decryptData.value(forKey: "notifications") as? NSArray{
                                self.lblNoNotifFound.text = "No notifications found"
                                self.lblNoNotifFound.isHidden = true
                                self.mutArrayToDisplay.removeAllObjects()
                                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                                //appDelegate?.deleteNotificationDetails()
                                for i in (0..<notificationsArray.count){
                                    let notificationsDict = notificationsArray.object(at: i) as! NSDictionary
                                    let notificationObj = Notifications(dict: notificationsDict)
                                 appDelegate?.saveNotificationDetails(notificationObj)
                                }
                                var arr = NSMutableArray()
                                arr = (appDelegate?.getNotificationDetailsFromDB("NotificationsEntity"))!
                                var dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"// yyyy-MM-dd"
                                let ready = arr.sorted(by: { dateFormatter.date(from:($0 as? Notifications)?.createdOn as! String)?.compare(dateFormatter.date(from:($1 as? Notifications)?.createdOn as! String)!) == .orderedDescending })
                                
                                for (i,x) in ready.enumerated() {
                                    self.mutArrayToDisplay.add(x)
                                }
                                DispatchQueue.main.async {
                                    if self.mutArrayToDisplay.count > 0{
                                        SwiftLoader.show(animated: true)
                                        self.lblNoNotifFound.isHidden = true
                                        self.lblNoNotifFound.text = "No notifications found"
                                        self.tblViewNotifications.reloadData()
                                        SwiftLoader.hide()
                                    }else {
                                        self.lblNoNotifFound.isHidden = false
                                    }
                                    
                                }
                            }
                            else{
                                self.loadOldNotificationsFromLocalDB()
                            }
                        }
                        else{
                            self.lblNoNotifFound.isHidden = false
                            self.lblNoNotifFound.text = "No notifications found"
                            self.loadOldNotificationsFromLocalDB()
                        }
                    }
                    else if responseStatusCode == STATUS_CODE_601{
                        Constatnts.logOut()
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    }else {
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                                   self.view.makeToast(msg as String)
                                               }
                        let userObj = Constatnts.getUserObject()
                                           let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId]
                                           self.registerFirebaseEvents(PV_Notifications_Fail, "", "", "", parameters: fireBaseParams as NSDictionary)
                    }
                }
            }
        }
    }
    func loadOldNotificationsFromLocalDB(){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        var arr = NSMutableArray()
        arr = (appDelegate?.getNotificationDetailsFromDB("NotificationsEntity"))!
        DispatchQueue.main.async {
            
            
            var dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"// yyyy-MM-dd"
            let ready = arr.sorted(by: { dateFormatter.date(from:($0 as? Notifications)?.createdOn as! String)?.compare(dateFormatter.date(from:($1 as? Notifications)?.createdOn as! String)!) == .orderedDescending })
//            self.mutArrayToDisplay.removeAllObjects()
//            for (i,x) in ready.enumerated() {
//                self.mutArrayToDisplay.add(x)
//            }
            
            
            self.mutArrayToDisplay.removeAllObjects()
                       
                       let arrayNotifictions = NSMutableArray()
                       
                       for (i,x) in ready.enumerated() {
                           arrayNotifictions.add(x)
                       }
                       
                       
                       for (i,x) in arrayNotifictions.enumerated() {
                           let notificationInfo = arrayNotifictions.object(at: i) as? Notifications
                           if notificationInfo?.notificationActive != true {
                               self.mutArrayToDisplay.add(x)
                           }
                       }
            
            
            
            if self.mutArrayToDisplay.count > 0{
                self.lblNoNotifFound.isHidden = true
            }else {
                self.lblNoNotifFound.text = "No notifications found"
                self.lblNoNotifFound.isHidden = false
            }
            
            
            DispatchQueue.main.async {
                self.tblViewNotifications.reloadData()
            }
            
        }
    }
    override func backButtonClick(_ sender: UIButton) {
        if isFromNotification == true {
            let requesterOrdersController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
            requesterOrdersController?.isFromNotification = true
            self.navigationController?.pushViewController(requesterOrdersController!, animated: true)
            
        }else {
            self.findHamburguerViewController()?.showMenuViewController()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension NotificationsViewController : UITableViewDataSource, UITableViewDelegate,SwiftyGifDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mutArrayToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let notificationInfo = self.mutArrayToDisplay.object(at: indexPath.row) as? Notifications
        let CDataArray = NSMutableArray()
        var imgArray = [UIImage]()
        if notificationInfo?.imagePath != "" && notificationInfo?.imagePath != nil {
            let cell =  self.tblViewNotifications.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as? NotificationCell
            let notificationsCell = self.mutArrayToDisplay.object(at: indexPath.row) as? Notifications
            
            let lblNotificationMsg = cell?.viewWithTag(100) as! UILabel
            let lblCreatedOn = cell?.viewWithTag(101) as! UILabel
            let imgNotification = cell?.viewWithTag(102) as! UIImageView
             let viewContent = cell?.viewWithTag(99)
            
            lblNotificationMsg.text = notificationsCell?.notificationMsg! as String?
            lblCreatedOn.text = notificationsCell?.createdOn! as String?
            let imgStr = notificationInfo?.imagePath ?? ""
            
            if (imgStr.contains("gif")) {
                imgNotification.delegate = self
                let url = URL(string: imgStr)
                imgNotification.kf.setImage(with: url)
                
            }
                
                //                let imageURL = UIImage.gifImageWithURL(imgStr ?? "")
                //               imgNotification.image = imageURL
            else {
                if notificationInfo?.imagePath != ""{
                    let url = URL(string:imgStr)
                    
                    imgNotification.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceHolderImage")!, options: SDWebImageOptions.delayPlaceholder, completed: { (img, error, _, ur) in
                        if error != nil {
                            DispatchQueue.main.async {
                                imgNotification.image =  UIImage(named: "PlaceHolderImage")!
                            }
                        }else {
                            DispatchQueue.main.async {
                                imgNotification.image = img
                            }
                        }
                    })
                }else {
                    DispatchQueue.main.async {
                        imgNotification.image =  UIImage(named: "PlaceHolderImage")!
                    }
                }
                
                
            }
            if notificationsCell?.viewStatus == true {
                viewContent?.backgroundColor = UIColor(hexString: "#F4F2F2")
            }else {
                viewContent?.backgroundColor = UIColor.init(hexString: "#c2E7FF")
            }
            return cell!
            
        }else {
            let cell = tblViewNotifications.dequeueReusableCell(withIdentifier: "NotificationsCell", for: indexPath)
            let notificationsCell = self.mutArrayToDisplay.object(at: indexPath.row) as? Notifications
            
            let lblNotificationMsg = cell.viewWithTag(100) as! UILabel
            let lblCreatedOn = cell.viewWithTag(101) as! UILabel
             let viewContent = cell.viewWithTag(99)!
            
            lblNotificationMsg.text = notificationsCell?.notificationMsg! as String?
            lblCreatedOn.text = notificationsCell?.createdOn! as String?
            if notificationsCell?.viewStatus == true {
            viewContent.backgroundColor = UIColor.init(hexString: "#F4F2F2")
                   }else {
            viewContent.backgroundColor = UIColor.init(hexString: "#C2E7FF")
                   }
            return cell
        }
        
        
        
        
        
        
        
        
        //                  for img in imgArray{
        //                      let data  = Data(UIImagePNGRepresentation(img)!
        //                      )
        //                      CDataArray.add(data)
        //                  }
        //
        //                  //convert the Array to NSData
        //                  //you can save this in core data
        //                  var coreDataObject = NSKeyedArchiver.archivedData(withRootObject: CDataArray)
        //                  //extract:
        //                  if let mySavedData = NSKeyedUnarchiver.unarchiveObject(with: coreDataObject) as? NSArray{
        //                      print(mySavedData)
        //                  }
    }
    func gifDidStart(sender: UIImageView) {
        SwiftLoader.show(animated: true)
    }
    func gifURLDidFinish(sender: UIImageView) {
        SwiftLoader.hide()
    }
    func gifURLDidFail(sender: UIImageView) {
        SwiftLoader.hide()
    }
    func fileInDocumentsDirectory(filename: String) -> String {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = (documentsURL.appendingPathComponent(filename)).absoluteString
        return fileURL
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let userObj = Constatnts.getUserObject()
            let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId]
            self.registerFirebaseEvents(PV_Notifications_Move_to_Alert, "", "", "", parameters: fireBaseParams as NSDictionary)
            
            //            let notificationInfo = self.mutArrayToDisplay.object(at: indexPath.row) as? Notifications
            //             let pop =  NotificationDetailsPopUpViewController()
            //             pop.alertMessage = notificationInfo?.notificationMsg as String? ?? "" as String
            //            pop.imagURL = notificationInfo?.imagePath! ?? ""
            //            pop.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            //
            //            self.addChildViewController(pop)
            //            self.view.addSubview(pop.view)
            let notificationInfo = self.mutArrayToDisplay.object(at: indexPath.row) as? Notifications
            //            let pop =  NotificationDetailsPopUpViewController()
            //            pop.alertMessage = notificationInfo?.notificationMsg as String? ?? "" as String
            //            pop.imagURL = notificationInfo?.imagePath! ?? ""
            //            pop.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            //
            //            self.addChildViewController(pop)
            //            self.view.addSubview(pop.view)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationFullViewController") as? NotificationFullViewController
            vc?.alertMessage = notificationInfo?.notificationMsg as String? ?? "" as String
            vc?.imagURL = notificationInfo?.imagePath! ?? ""
            let notificationsObj = self.mutArrayToDisplay.object(at: indexPath.row) as? Notifications
            notificationsObj?.notificationActive = false
            notificationsObj?.viewStatus = true
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.saveNotificationDetails(notificationsObj!)
            self.readNotificcations()
            self.navigationController?.pushViewController(vc!, animated: true)
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "", handler: {a,b,c in
            // example of your delete function
            self.mutArrayToDisplay.remove(indexPath.row)
            self.tblViewNotifications.beginUpdates()
            let notificationsObj = self.mutArrayToDisplay.object(at: indexPath.row) as? Notifications
            notificationsObj?.notificationActive = true
            //            if notificationsObj?.viewStatus == "" {
            //                notificationsObj?.viewStatus = "false"
            //            }else {
            //                notificationsObj?.viewStatus = "true"
            //            }
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.saveNotificationDetails(notificationsObj!)
            let net = NetworkReachabilityManager(host: "www.google.com")
            if net?.isReachable == true{
                self.deleteNotifications()
            }else {
                self.loadOldNotificationsFromLocalDB()
            }
            //              let notificationsObj = self.mutArrayToDisplay.object(at: indexPath.row) as? PushNotifications
            //            let param = ["createdOn": notificationsObj?.createdOn ?? "",
            //                                                                   "imagePath": notificationsObj?.imagePath ?? "",
            //                                                                   "notificationId": notificationsObj?.notificationId ?? "","notificationMsg": notificationsObj?.notificationMsg ?? "","notificationActive" : false] as? NSDictionary
            
            
            //                      let paramsStr1 = Constatnts.nsobjectToJSONWithFarmerConnectCert(parameters!)
            //                      let params =  ["data": paramsStr1]
            //            deleteNotifications()
            self.tblViewNotifications.endUpdates()
        })
        
        deleteAction.image = UIImage(named: "notificationDelete")
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            self.mutArrayToDisplay.remove(indexPath.row)
            self.tblViewNotifications.beginUpdates()
            let notificationsObj = self.mutArrayToDisplay.object(at: indexPath.row) as? Notifications
            notificationsObj?.notificationActive = true
            //            if notificationsObj?.viewStatus == "" {
            //                notificationsObj?.viewStatus = "false"
            //            }else {
            //                notificationsObj?.viewStatus = "true"
            //            }
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.saveNotificationDetails(notificationsObj!)
            let net = NetworkReachabilityManager(host: "www.google.com")
            if net?.isReachable == true{
                self.deleteNotifications()
            }else {
                self.loadOldNotificationsFromLocalDB()
            }
            //              let notificationsObj = self.mutArrayToDisplay.object(at: indexPath.row) as? PushNotifications
            //            let param = ["createdOn": notificationsObj?.createdOn ?? "",
            //                                                                   "imagePath": notificationsObj?.imagePath ?? "",
            //                                                                   "notificationId": notificationsObj?.notificationId ?? "","notificationMsg": notificationsObj?.notificationMsg ?? "","notificationActive" : false] as? NSDictionary
            
            
            //                      let paramsStr1 = Constatnts.nsobjectToJSONWithFarmerConnectCert(parameters!)
            //                      let params =  ["data": paramsStr1]
            //            deleteNotifications()
            self.tblViewNotifications.endUpdates()
        }
    }
    func deleteNotifications() {
        
        SwiftLoader.show(animated: true)
        
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        var arr = NSMutableArray()
        arr = (appDelegate?.getNotificationDetailsFromDB("NotificationsEntity"))!
        self.inActiveNotifications.removeAllObjects()
        
        for (i,x) in arr.enumerated() {
            let obj = x as? Notifications
            if obj?.notificationActive == true {
                self.inActiveNotifications.add(x)
            }
        }
        
        let userObj = Constatnts.getUserObject()
        let  headers  = ["deviceToken": userObj.deviceToken as String,
                                      "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                      "mobileNumber": userObj.mobileNumber! as String,
                                      "customerId": userObj.customerId! as String,
                                      "deviceId": userObj.deviceId! as String]
        
        let notificationsArray = NSMutableArray()
        for (i,x) in inActiveNotifications.enumerated() {
            let obj = x as? Notifications
            if obj?.notificationActive == true {
                let mutDictToServer = NSMutableDictionary()
                mutDictToServer.setValue(obj?.notificationId, forKey: "notificationId")
                mutDictToServer.setValue(obj?.createdOn, forKey: "createdOn")
                mutDictToServer.setValue(obj?.notificationMsg, forKey: "notificationMsg")
                mutDictToServer.setValue(obj?.imagePath, forKey: "imagePath")
                if obj?.notificationActive == true {
                    mutDictToServer.setValue(true, forKey: "notificationActive")
                }else {
                    mutDictToServer.setValue(false, forKey: "notificationActive")
                }
                if obj?.viewStatus == true {
                    mutDictToServer.setValue(true, forKey: "viewStatus")
                }else {
                    mutDictToServer.setValue(false, forKey: "viewStatus")
                }
                
                notificationsArray.add(mutDictToServer)
            }
        }
        
        let parameters  = ["deviceToken": userObj.deviceToken as String,
                                      "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                      "mobileNumber": userObj.mobileNumber! as String,
                                      "customerId": userObj.customerId! as String,
                                      "deviceId": userObj.deviceId! as String]
   
        let finalParamsDic = NSMutableDictionary()
        finalParamsDic.addEntries(from: parameters as [AnyHashable : Any])
        finalParamsDic.setValue(notificationsArray, forKey: "notifications")
        print(finalParamsDic)
        
        let paramsStr1 = Constatnts.nsobjectToJSON(finalParamsDic as NSDictionary)
        
        
        //         let paramsStr1 = Constatnts.nsobjectToJSONWithFarmerConnectCert(parameters!)
        let params =  ["data": paramsStr1]
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,DELETE_NOTIFICATIONS])
   
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    // print(json)
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == "200"{
                        let userObj = Constatnts.getUserObject()
                        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId]
                        self.registerFirebaseEvents(PV_Notifications_Delete, "", "", "", parameters: fireBaseParams as NSDictionary)
                        
                        let deleteCodes = (json as! NSDictionary).value(forKey: "response") as! String
                        let arrElents = deleteCodes.components(separatedBy: ",")
                        
                        for (i,x) in self.mutArrayToDisplay.enumerated(){
                            let obj = x as? Notifications
                            for (j,y) in arrElents.enumerated() {
                                if obj!.notificationId! as String == arrElents[j] {
                                    appDelegate?.deletedNotificationDetailsInOffline(arrElents[j])
                                }
                            }
                            self.loadOldNotificationsFromLocalDB()
                        }
                    }else {
                        self.loadOldNotificationsFromLocalDB()
                    }
                    
                }
            }
        }
    }
    func readNotificcations(){
        SwiftLoader.show(animated: true)
        
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        var arr = NSMutableArray()
        arr = (appDelegate?.getNotificationDetailsFromDB("NotificationsEntity"))!
        self.inActiveNotifications.removeAllObjects()
        for (i,x) in arr.enumerated() {
            let obj = x as? Notifications
            if obj?.viewStatus == true {
                self.inActiveNotifications.add(x)
            }
        }
        
    let userObj = Constatnts.getUserObject()
                let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                            "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                            "mobileNumber": userObj.mobileNumber! as String,
                                            "customerId": userObj.customerId! as String,
                                            "deviceId": userObj.deviceId! as String]
        
        let notificationsArray = NSMutableArray()
        for (i,x) in inActiveNotifications.enumerated() {
            let obj = x as? Notifications
            if obj?.viewStatus == true {
                let mutDictToServer = NSMutableDictionary()
                mutDictToServer.setValue(obj?.notificationId, forKey: "notificationId")
                mutDictToServer.setValue(obj?.createdOn, forKey: "createdOn")
                mutDictToServer.setValue(obj?.notificationMsg, forKey: "notificationMsg")
                mutDictToServer.setValue(obj?.imagePath, forKey: "imagePath")
                if obj?.notificationActive == true {
                    mutDictToServer.setValue(true, forKey: "notificationActive")
                }else {
                    mutDictToServer.setValue(false, forKey: "notificationActive")
                }
                if obj?.viewStatus == true {
                    mutDictToServer.setValue(true, forKey: "viewStatus")
                }else {
                    mutDictToServer.setValue(false, forKey: "viewStatus")
                }
                
                notificationsArray.add(mutDictToServer)
            }
        }
        
        
        let parameters = ["mobileNo":  userObj.mobileNumber! as String,
                          "customerId": userObj.customerId! as String,
                          "deviceId": userObj.deviceId! as String ] as? NSDictionary
        let finalParamsDic = NSMutableDictionary()
        finalParamsDic.addEntries(from: parameters as! [AnyHashable : Any])
        finalParamsDic.setValue(notificationsArray, forKey: "notifications")
        print(finalParamsDic)
        
        let paramsStr1 = Constatnts.nsobjectToJSON(finalParamsDic as NSDictionary)
        
        
        //         let paramsStr1 = Constatnts.nsobjectToJSONWithFarmerConnectCert(parameters!)
        let params =  ["data": paramsStr1]
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,DELETE_NOTIFICATIONS])
       
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    print(json)
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == "200"{
                        let deleteCodes = (json as! NSDictionary).value(forKey: "response") as! String
                        let arrElents = deleteCodes.components(separatedBy: ",")
                        
                        for (i,x) in self.mutArrayToDisplay.enumerated(){
                            let obj = x as? Notifications
                            for (j,y) in arrElents.enumerated() {
                                if obj!.notificationId! as String == arrElents[j] {
                                    appDelegate?.saveNotificationDetails(obj!)
                                    self.loadOldNotificationsFromLocalDB()
                                }
                            }
                            
                        }
                    }
                    
                }
            }
        }
        
    }
   
    
    func saveImage(image: UIImage) -> Bool {
        guard let data = UIImageJPEGRepresentation(image, 1) ?? UIImagePNGRepresentation(image) else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("fileName.png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    @objc func infoOkButtonOptIn() {
        self.NotificationMsgAlert?.removeFromSuperview()
    }
    
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
}
extension UIColor {
    
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
}

extension UIColor {
    convenience init?(hexString: String) {
        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        let red, green, blue, alpha: CGFloat
        switch chars.count {
        case 3:
            chars = chars.flatMap { [$0, $0] }
            fallthrough
        case 6:
            chars = ["F","F"] + chars
            fallthrough
        case 8:
            alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
            red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
            green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
            blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
        default:
            return nil
        }
        self.init(red: red, green: green, blue:  blue, alpha: alpha)
    }
}
