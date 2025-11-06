//
//  PushNotificationServiceManager.swift
//  PioneerEmployee
//
//  Created by Empover-i-Tech on 10/06/20.
//  Copyright © 2020 Empover. All rights reserved.
//

import UIKit
import Alamofire

class PushNotificationServiceManager: NSObject {
    
    //MARK: Shared Instance
    static let sharedInstance : PushNotificationServiceManager = {
        let instance = PushNotificationServiceManager()
        return instance
    }()
    
    //MARK: GetPushNotificationsCount
    
    //MARK: requestToGetNotificationsData
   class func requestToGetUnreadNotificationsCount(Params:[String:String] , completionHandler:@escaping (_ status:Bool?)-> Void){
 
        
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,NOTIFICATIONS])
                let userObj = Constatnts.getUserObject()
        
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        
        Alamofire.request(urlString, method: .post, parameters: Params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.error == nil {
                if let json = response.result.value {
                    print(json)
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    let res = (json as! NSDictionary).value(forKey: "response")! as? String
                    if responseStatusCode == "\(STATUS_CODE_200)" &&  res != nil {
                        if let respData = (json as! NSDictionary).value(forKey: "response") as? NSString{
                            let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                            //print("Response after decrypting data:\(decryptData)")
                            let defaults = UserDefaults.standard
                            defaults.set(decryptData.value(forKey: "syncTime") as! String, forKey: "lastSyncTime")
                            defaults.synchronize()
                            if let notificationsArray = decryptData.value(forKey: "notifications") as? NSArray{
                                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                                //appDelegate?.deleteNotificationDetails()
                                for i in (0..<notificationsArray.count){
                                    let notificationsDict = notificationsArray.object(at: i) as! NSDictionary
                                    let notificationObj = Notifications(dict: notificationsDict)
//                                    notificationObj.viewStatus = "false"
//                                    notificationObj.notificationActive = "false"
                                    appDelegate?.saveNotificationDetails(notificationObj)
                                    
                                }
                                var arr = NSMutableArray()
                                arr = (appDelegate?.getNotificationDetailsFromDB("NotificationsEntity"))!
                                var dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"// yyyy-MM-dd"
                                let notificationsArr = arr.sorted(by: { dateFormatter.date(from:($0 as? Notifications)?.createdOn as! String)?.compare(dateFormatter.date(from:($1 as? Notifications)?.createdOn as! String)!) == .orderedDescending })
                              
                                let mutArrayToDisplay = NSMutableArray()
                                for (i,x) in notificationsArr.enumerated() {
                                    mutArrayToDisplay.add(x)
                                }
                                DispatchQueue.main.async {
                                    
                                    let arrayNotifictions = NSMutableArray()
                                    for (i,x) in mutArrayToDisplay.enumerated() {
                                        let notificationInfo = mutArrayToDisplay.object(at: i) as? Notifications
                                        if notificationInfo?.viewStatus != true {
                                                   arrayNotifictions.add(x)
                                                   }
                                               }
                                    unReadnotifications = "\(arrayNotifictions.count)"
                                    
                                }
                            }
                            
                        }
                    }
                    else if responseStatusCode == "\(STATUS_CODE_601)"{
                        Constatnts.logOut()
                        completionHandler(false)
                    }else{
                        self.loadOldNotificationsFromLocalDB()
                        completionHandler(true)
                    }
                }
            }
        }
    }
    
 class   func loadOldNotificationsFromLocalDB(){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        var arr = NSMutableArray()
        arr = (appDelegate?.getNotificationDetailsFromDB("NotificationsEntity"))!
        DispatchQueue.main.async {
            
            
            var dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"// yyyy-MM-dd"
            let ready = arr.sorted(by: { dateFormatter.date(from:($0 as? Notifications)?.createdOn as! String)?.compare(dateFormatter.date(from:($1 as? Notifications)?.createdOn as! String)!) == .orderedDescending })
            
            let mutArrayToDisplay = NSMutableArray()
                                           for (i,x) in ready.enumerated() {
                                               mutArrayToDisplay.add(x)
                                           }
            
                let arrayNotifictions = NSMutableArray()
            for (i,x) in mutArrayToDisplay.enumerated() {
                let notificationInfo = mutArrayToDisplay.object(at: i) as? Notifications
                if notificationInfo?.viewStatus != true {
                   arrayNotifictions.add(x)
                }
            }
                unReadnotifications = "\(arrayNotifictions.count)"
            
            
        }
    }
}
