//
//  UserLogEvents.swift
//  FarmerConnect
//
//  Created by Empover i-Tech on 09/03/23.
//  Copyright © 2023 ABC. All rights reserved.
//

import Foundation
import UIKit

class UserLogEvents: NSObject {
    
    @objc var mobileNumber: NSString?
    @objc var deviceId: NSString?
    @objc var deviceType: NSString?
    @objc var customerId: NSString?
    @objc var logTimeStamp: NSString?
    @objc var pincode: NSString?
    @objc var eventName: NSString?
    @objc var className: NSString?
    
    @objc var moduleName: NSString?
    @objc var healthCardId: NSString?
    @objc var productId: NSString?
    @objc var cropId: NSString?
    @objc var seasonId: NSString?
    @objc var otherParams: NSString?
    
    @objc var districtLoggedin: NSString?
    @objc var stateLoggedin: NSString?
    @objc var isOnlineRecord: NSString?
    
    @objc var stateName: NSString?
    @objc var marketName: NSString?
    @objc var commodity: NSString?

    
    
    init(dict : NSDictionary){
        self.mobileNumber = (Validations.checkKeyNotAvail(dict, key: "mobileNumber") as?NSString)!
        self.deviceId = (Validations.checkKeyNotAvail(dict, key: "deviceId") as?NSString)!
        self.deviceType = (Validations.checkKeyNotAvail(dict, key: "deviceType") as?NSString)!
        self.customerId = (Validations.checkKeyNotAvail(dict, key: "customerId") as?NSString)!
        self.logTimeStamp = (Validations.checkKeyNotAvail(dict, key: "logTimeStamp") as?NSString)!
        self.pincode = (Validations.checkKeyNotAvail(dict, key: "pincode") as?NSString)!
        self.eventName = (Validations.checkKeyNotAvail(dict, key: "eventName") as?NSString)!
        self.className = (Validations.checkKeyNotAvail(dict, key: "className") as?NSString)!
        
        self.moduleName = (Validations.checkKeyNotAvail(dict, key: "moduleName") as?NSString)!
        self.healthCardId = (Validations.checkKeyNotAvail(dict, key: "healthCardId") as?NSString)!
        self.productId = (Validations.checkKeyNotAvail(dict, key: "productId") as?NSString)!
        self.cropId = (Validations.checkKeyNotAvail(dict, key: "cropId") as?NSString)!
        self.seasonId = (Validations.checkKeyNotAvail(dict, key: "seasonId") as?NSString)!
        self.otherParams = (Validations.checkKeyNotAvail(dict, key: "otherParams") as?NSString)!
        
        self.districtLoggedin = (Validations.checkKeyNotAvail(dict, key: "districtLoggedin") as?NSString)!
        self.stateLoggedin = (Validations.checkKeyNotAvail(dict, key: "stateLoggedin") as?NSString)!
        
        self.stateName = (Validations.checkKeyNotAvail(dict, key: "stateName") as?NSString)!
        self.marketName = (Validations.checkKeyNotAvail(dict, key: "marketName") as?NSString)!
        self.commodity = (Validations.checkKeyNotAvail(dict, key: "commodity") as?NSString)!
        
        if let isOnlineRecord = dict.value(forKey: "isOnlineRecord") as? Bool {
            self.isOnlineRecord = String(isOnlineRecord) as NSString
        }
        
    }
}
