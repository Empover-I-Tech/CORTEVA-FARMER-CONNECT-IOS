//
//  CropAdvisoryDetailCell.swift
//  CropAdvisoryFramework
//
//  Created by Apple on 06/12/19.
//  Copyright © 2019 Empover iTech Pvt Ltd. All rights reserved.
//

import UIKit

class CropAdvisoryDetailCell: NSObject {
    
    var noOfDays: NSString?
    var message: NSString
    var messageInLocalLang: NSString
    var messageId: Int
    
    var voiceFileURL: NSString
    var sentOn : NSString?
    var stageName : NSString?
    var supposeToBeOn : NSString?
    var isPlaying :Bool = false
    
   public init(dict : NSDictionary){
        
        if let noOfDaysObj = dict.value(forKey: "noOfDays") as? Int {
            self.noOfDays = String(format: "%d",noOfDaysObj) as NSString
        }
        self.message = (Validations.checkKeyNotAvail(dict, key: "message") as?NSString)!
        self.messageInLocalLang = (Validations.checkKeyNotAvail(dict, key: "messageInLocalLang") as?NSString)!
        
        self.messageId = (dict.value(forKey: "messageId") as?Int)!
        
        self.voiceFileURL = (Validations.checkKeyNotAvail(dict, key: "voiceFileURL") as?NSString)!
        self.stageName = (Validations.checkKeyNotAvail(dict, key: "stageName") as?NSString)!
        if let sentOnStr = Validations.checkKeyNotAvail(dict, key: "sentOn") as? NSString{
            let dateArr = sentOnStr.components(separatedBy: " ") as NSArray
            let dateObj2 = dateArr.object(at: 0)
            print(dateObj2)
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd-MMM-yyyy"
            if Validations.isNullString(dateObj2 as! NSString) == false{
                let date: NSDate? = dateFormatterGet.date(from: dateObj2 as! String)! as NSDate
                print(dateFormatterPrint.string(from: date! as Date))
                self.sentOn = dateFormatterPrint.string(from: date! as Date) as NSString
            }
        }
        if let supposeToBeOnStr = Validations.checkKeyNotAvail(dict, key: "supposeToBeOn") as? NSString{
            let dateArr = supposeToBeOnStr.components(separatedBy: " ") as NSArray
            let dateObj2 = dateArr.object(at: 0)
            print(dateObj2)
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd-MMM-yyyy"
            if Validations.isNullString(dateObj2 as! NSString) == false{
                let date: NSDate? = dateFormatterGet.date(from: dateObj2 as! String)! as NSDate
                print(dateFormatterPrint.string(from: date! as Date))
                self.supposeToBeOn = dateFormatterPrint.string(from: date! as Date) as NSString
            }
        }
    }
}
