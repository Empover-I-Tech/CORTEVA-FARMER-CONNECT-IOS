//
//  RaiseTicket.swift
//  Paramarsh
//
//  Created by Empover on 08/02/18.
//  Copyright © 2018 Empover. All rights reserved.
//

import UIKit

@objc class RaiseTicket: NSObject {
     var id: Int?
    @objc var name: NSString?
    @objc var pincode: NSString?
    @objc var descriptionStr: NSString?
    @objc var issueType: NSString?
    @objc var crop: NSString?
    @objc var hybrid: NSString?
    @objc var district: NSString?
    @objc var retailerName: NSString?
    @objc var userType: NSString?
    @objc var raisingForUserType: NSString?
    @objc var retailerMobileNo: NSString?
    @objc var mobileNo: NSString?
    @objc var lotNo: NSString?
    @objc var damagePerc: NSString?
    var isUserExist: Bool?
    @objc var isSentToServer: Bool = false
    
    init(dict : NSDictionary){
        if let idObj = dict.value(forKey: "id") as? Int {
            self.id = idObj
        }
        //self.id = (Validations.checkKeyNotAvail(dict, key: "id") as?NSString)!
        self.name = (Validations.checkKeyNotAvail(dict, key: "name") as?NSString)!
        self.pincode = (Validations.checkKeyNotAvail(dict, key: "pincode") as?NSString)!
        self.descriptionStr = (Validations.checkKeyNotAvail(dict, key: "description") as?NSString)!
        self.issueType = (Validations.checkKeyNotAvail(dict, key: "issueType") as?NSString)!
        self.crop = (Validations.checkKeyNotAvail(dict, key: "crop") as?NSString)!
        self.hybrid = (Validations.checkKeyNotAvail(dict, key: "hybrid") as?NSString)!
        self.district = (Validations.checkKeyNotAvail(dict, key: "district") as?NSString)!
        self.retailerName = (Validations.checkKeyNotAvail(dict, key: "retailerName") as?NSString)!
        self.userType = (Validations.checkKeyNotAvail(dict, key: "userType") as?NSString)!
        self.raisingForUserType = (Validations.checkKeyNotAvail(dict, key: "raisingForUserType") as?NSString)!
        self.retailerMobileNo = (Validations.checkKeyNotAvail(dict, key: "retailerMobileNo") as?NSString)!
        self.mobileNo = (Validations.checkKeyNotAvail(dict, key: "mobileNo") as?NSString)!
        self.lotNo = (Validations.checkKeyNotAvail(dict, key: "lotNo") as?NSString)!
        self.damagePerc = (Validations.checkKeyNotAvail(dict, key: "damagePerc") as?NSString)!
        if let userExist = Validations.checkKeyNotAvail(dict, key: "isUserExist") as?Bool{
            self.isUserExist = userExist
        }
        if let sentToServer = Validations.checkKeyNotAvail(dict, key: "isSentToServer") as?Bool{
            self.isSentToServer = sentToServer
        }
    }
}
