//
//  CropAdvisoryNotifications.swift
//  FarmerConnect
//
//  Created by Empover on 08/01/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit

class CropAdvisoryNotifications: NSObject {

    @objc var sowingDate: NSString?
    @objc var cropId: NSString?
    @objc var cropName: NSString?
    @objc var categoryId: NSString?
    @objc var categoryName: NSString?
    @objc var stateId: NSString?
    @objc var stateName: NSString?
    @objc var seasonId: NSString?
    @objc var seasonName: NSString?
    @objc var hybridName: NSString?
    @objc var hybridId: NSString?
    @objc var caRequestMasterId: NSString?
    @objc var messageList: NSArray?
    
    init(dict : NSDictionary){
        self.sowingDate = (Validations.checkKeyNotAvail(dict, key: "sowingDate") as?NSString)!
        if let sowingDateStr = Validations.checkKeyNotAvail(dict, key: "sowingDate") as? NSString{
            let dateArr = sowingDateStr.components(separatedBy: " ") as NSArray
            let dateObj2 = dateArr.object(at: 0)
            print(dateObj2)
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd-MMM-yyyy"
            if Validations.isNullString(dateObj2 as! NSString) == false{
                let date: NSDate? = dateFormatterGet.date(from: dateObj2 as! String)! as NSDate
                print(dateFormatterPrint.string(from: date! as Date))
                self.sowingDate = dateFormatterPrint.string(from: date! as Date) as NSString
            }
        }
        if let cropIdObj = dict.value(forKey: "cropId") as? Int {
            self.cropId = String(format: "%d",cropIdObj) as NSString
        }
        self.cropName = (Validations.checkKeyNotAvail(dict, key: "cropName") as?NSString)!
        if let categoryIdObj = dict.value(forKey: "categoryId") as? Int {
            self.categoryId = String(format: "%d",categoryIdObj) as NSString
        }
        self.categoryName = (Validations.checkKeyNotAvail(dict, key: "categoryName") as?NSString)!
        if let stateIdObj = dict.value(forKey: "stateId") as? Int {
            self.stateId = String(format: "%d",stateIdObj) as NSString
        }
        self.stateName = (Validations.checkKeyNotAvail(dict, key: "stateName") as?NSString)!
        if let seasonIdObj = dict.value(forKey: "seasonId") as? Int {
            self.seasonId = String(format: "%d",seasonIdObj) as NSString
        }
        self.seasonName = (Validations.checkKeyNotAvail(dict, key: "seasonName") as?NSString)!
        self.hybridName = (Validations.checkKeyNotAvail(dict, key: "hybridName") as?NSString)!
        if let hybridIdObj = dict.value(forKey: "hybridId") as? Int {
            self.hybridId = String(format: "%d",hybridIdObj) as NSString
        }
        if let caRequestMasterIdObj = dict.value(forKey: "caRequestMasterId") as? Int {
            self.caRequestMasterId = String(format: "%d",caRequestMasterIdObj) as NSString
        }
        self.messageList = (Validations.checkKeyNotAvailForArray(dict, key: "messageList") as?NSArray)!
    }
}
