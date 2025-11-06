//
//  PeetUploadedRecordsBO.swift
//  FarmerConnect
//
//  Created by Apple on 11/12/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import Foundation

class  PeetUploadedRecordsBO: NSObject {
    
    var diseaseName : NSString?
    var exactMatch : NSString?
    var probability : NSString?
    var imagePath : NSString?
    var id : NSString?
    var diseaseId : NSString?
    var diseaseRequestId : NSString?
   var scientificNAme : NSString?
    var diseaseDate : NSString?
    var diseaseTypeImgUrl : NSString?
    var diseaseTypeImageCount : NSString?
    
    
    init(dict : NSDictionary) {
        self.id = (Validations.checkKeyNotAvail(dict, key: "id") as?  NSString ?? "")
        if let userIds = dict.value(forKey: "id") as? Int {
            self.id = String(format: "%d",userIds) as NSString
        }
        
        self.diseaseId = (Validations.checkKeyNotAvail(dict, key: "diseaseId") as?  NSString ?? "")
        if let userIds = dict.value(forKey: "diseaseId") as? Int {
            self.diseaseId = String(format: "%d",userIds) as NSString
        }
        
        self.diseaseTypeImgUrl = (Validations.checkKeyNotAvail(dict, key: "diseaseTypeImgUrl") as?  NSString ?? "")
               if let diseaseImg = dict.value(forKey: "diseaseTypeImgUrl") as? Int {
                   self.diseaseTypeImgUrl = String(format: "%d",diseaseImg) as NSString
               }
               
        self.diseaseTypeImageCount = (Validations.checkKeyNotAvail(dict, key: "diseaseTypeImageCount") as?  NSString ?? "")
               if let diseaseTypeCount = dict.value(forKey: "diseaseTypeImageCount") as? Int {
                   self.diseaseTypeImageCount = String(format: "%d",diseaseTypeCount) as NSString
               }
        
        self.diseaseRequestId = (Validations.checkKeyNotAvail(dict, key: "diseaseRequestId") as?  NSString ?? "")
        if let userIds = dict.value(forKey: "diseaseRequestId") as? Int {
            self.diseaseRequestId = String(format: "%d",userIds) as NSString
        }
        
        self.diseaseName = (Validations.checkKeyNotAvail(dict, key: "diseaseName") as?  NSString ?? "")
        self.probability = (Validations.checkKeyNotAvail(dict, key: "probability") as?  NSString ?? "")
        if let userIds = dict.value(forKey: "probability")   as? Double {
            self.probability = String(format: "%.f",userIds) as NSString
        }
        self.imagePath = (Validations.checkKeyNotAvail(dict, key: "imagePath") as?  NSString ?? "")
        self.exactMatch = (Validations.checkKeyNotAvail(dict, key: "exactMatch") as?  NSString ?? "")
        
        self.scientificNAme = (Validations.checkKeyNotAvail(dict, key: "diseaseScientificName") as?  NSString ?? "")
         self.diseaseDate = (Validations.checkKeyNotAvail(dict, key: "diseaseDate") as?  NSString ?? "")

       /* if let sentOnStr = Validations.checkKeyNotAvail(dict, key: "diseaseDate") as? NSString{
                       let dateArr = sentOnStr.components(separatedBy: " ") as NSArray
                       let dateObj2 = dateArr.object(at: 0)
                       print(dateObj2)
                       
                       let dateFormatterGet = DateFormatter()
                       dateFormatterGet.dateFormat = "yyyy-MM-dd"
                       
                       let dateFormatterPrint = DateFormatter()
                       dateFormatterPrint.dateFormat = "d, MMM yyyy"
                       if Validations.isNullString(dateObj2 as! NSString) == false{
                           let date: NSDate? = dateFormatterGet.date(from: dateObj2 as! String)! as NSDate
                           print(dateFormatterPrint.string(from: date! as Date))
                           self.diseaseDate = dateFormatterPrint.string(from: date! as Date) as NSString
                       }
                   }*/
        
        
        
        
        
        if let counterRequest = Validations.checkKeyNotAvail(dict, key: "exactMatch") as? Int64{
            self.exactMatch = NSString(format: "%d", counterRequest)
        }
        
      
    }
}
