//
//  AgroProductMaster.swift
//  FarmerConnect
//
//  Created by Empover on 28/12/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit

class AgroProductMaster: NSObject {

    @objc var id: NSString?
    @objc var createdOn: NSString?
    @objc var active: NSString?
    @objc var updatedOn: NSString?
    @objc var productName: NSString?
    @objc var productUse: NSString?
    @objc var caution: NSString?
    @objc var work: NSString?
    @objc var cropAndDiseaseNamesForMobile: NSString?
    @objc var type: NSString?
    @objc var productImage: NSString?
    @objc var deleted: NSString?
    @objc var resultAndEffect: NSString?
    @objc var character: NSString?
    @objc var status: NSString?
    @objc var cropAndDiseaseNamesArray: NSArray
    
    init(dict : NSDictionary){
        if let idObj = dict.value(forKey: "id") as? Int {
            self.id = String(format: "%d",idObj) as NSString
        }
        self.createdOn = (Validations.checkKeyNotAvail(dict, key: "createdOn") as?NSString)!
        if let active = dict.value(forKey: "active") as? Bool {
            self.active = String(active) as NSString
        }
        self.updatedOn = (Validations.checkKeyNotAvail(dict, key: "updatedOn") as?NSString)!
        self.productName = (Validations.checkKeyNotAvail(dict, key: "productName") as?NSString)!
        self.productUse = (Validations.checkKeyNotAvail(dict, key: "productUse") as?NSString)!
        self.caution = (Validations.checkKeyNotAvail(dict, key: "caution") as?NSString)!
        self.work = (Validations.checkKeyNotAvail(dict, key: "work") as?NSString)!
        self.cropAndDiseaseNamesForMobile = (Validations.checkKeyNotAvail(dict, key: "cropAndDiseaseNamesForMobile") as?NSString)!
        self.type = (Validations.checkKeyNotAvail(dict, key: "type") as?NSString)!
        self.productImage = (Validations.checkKeyNotAvail(dict, key: "productImage") as?NSString)!
        if let deletedObj = dict.value(forKey: "deleted") as? Bool {
            self.deleted = String(deletedObj) as NSString
        }
        self.resultAndEffect = (Validations.checkKeyNotAvail(dict, key: "resultAndEffect") as?NSString)!
        self.character = (Validations.checkKeyNotAvail(dict, key: "character") as?NSString)!
        self.status = (Validations.checkKeyNotAvail(dict, key: "status") as?NSString)!
       self.cropAndDiseaseNamesArray = (Validations.checkKeyNotAvailForArray(dict, key: "cropAndDiseaseNames") as?NSArray)!
      
    }
}
