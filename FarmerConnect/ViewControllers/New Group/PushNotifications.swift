//
//  PushNotifications.swift
//  FarmerConnect
//
//  Created by Empover on 04/01/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit

//class PushNotifications: NSObject {
//
//    @objc var notificationId: NSString?
//    @objc var createdOn: NSString?
//    @objc var notificationMsg: NSString?
//     @objc var imagePath: String?
//    @objc var notificationActive: String?
//      @objc var viewStatus: String?
//
//     init(dict : NSDictionary){
//        self.notificationId = (Validations.checkKeyNotAvail(dict, key: "notificationId") as?NSString)!
//       // self.createdOn = (Validations.checkKeyNotAvail(dict, key: "createdOn") as?NSString)!
//         let createdOnStr = Validations.checkKeyNotAvail(dict, key: "createdOn") as? NSString
////            let dateArr = createdOnStr.components(separatedBy: " ") as NSArray
////            let dateObj2 = dateArr.object(at: 0)
////            print(dateObj2)
//            let dateFormatterGet = DateFormatter()
//                      dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
//
//                      let dateFormatterPrint = DateFormatter()
//                      dateFormatterPrint.dateFormat = "dd-MMM-yyyy HH:mm:ss"
//
////            let dateFormatterGet = DateFormatter()
////            dateFormatterGet.dateFormat = "yyyy-MM-dd"
//
////            let dateFormatterPrint = DateFormatter()
////            dateFormatterPrint.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
//        let date = dateFormatterGet.date(from: createdOnStr as String? ?? "")
////            if Validations.isNullString(dateObj2 as! NSString) == false{
//        self.createdOn = dateFormatterPrint.string(from: date ?? Date()) as NSString
////            }
//
//        self.imagePath = (Validations.checkKeyNotAvail(dict, key: "imagePath") as? String)
//        self.notificationActive = (Validations.checkKeyNotAvail(dict, key: "notificationActive") as? String)
//        self.viewStatus = (Validations.checkKeyNotAvail(dict, key: "viewStatus") as? String)
//        self.notificationMsg = (Validations.checkKeyNotAvail(dict, key: "notificationMsg") as?NSString)!
//    }
//}
