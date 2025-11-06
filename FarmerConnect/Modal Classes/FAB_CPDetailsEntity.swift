//
//  FAB_CPDetailsEntity.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 30/03/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import UIKit

@objc class FAB_CPDetailsEntity: NSObject {
    @objc var cropId: NSString
    @objc var crop: NSString
    @objc var productId: NSString
    @objc var productName: NSString
    @objc var diseaseId: NSString
    @objc var diseaseName: NSString
    @objc var id: NSString
    @objc var version: NSString
    @objc var fabCPDataArray: NSArray
     @objc var tableHeader: NSString
         @objc var tableLocHeader: NSString
     @objc var tableData: NSArray
     @objc var tableLocData: NSArray
    @objc var stateId: NSString
       @objc var state: NSString
   @objc var cropImageUrl: NSString
    @objc var productImageUrl: NSString
    @objc var diseaseImageUrl: NSString
    @objc var diseaseType : NSString
 @objc var des_englishMsg : NSString
     @objc var des_localMsg : NSString
    @objc var productFormulation : NSString
     @objc var product_images_urls : NSString
    
    
    init(dict : NSDictionary){
        self.cropId = (Validations.checkKeyNotAvail(dict, key: "cropId") as?NSString)!
         self.productId = (Validations.checkKeyNotAvail(dict, key: "productId") as?NSString)!
         self.productName = (Validations.checkKeyNotAvail(dict, key: "productName") as?NSString)!
         self.diseaseId = (Validations.checkKeyNotAvail(dict, key: "diseaseId") as?NSString)!
        self.diseaseName = (Validations.checkKeyNotAvail(dict, key: "diseaseName") as?NSString)!
        self.cropImageUrl = (Validations.checkKeyNotAvail(dict, key: "cropImageUrl") as?NSString)!
        self.productImageUrl = (Validations.checkKeyNotAvail(dict, key: "productImageUrl") as?NSString)!
        self.diseaseImageUrl = (Validations.checkKeyNotAvail(dict, key: "diseaseImageUrl") as?NSString)!
         self.productFormulation = (Validations.checkKeyNotAvail(dict, key: "productFormulation") as?NSString)!
        self.crop = (Validations.checkKeyNotAvail(dict, key: "crop") as?NSString)!
        self.id = (Validations.checkKeyNotAvail(dict, key: "id") as?NSString)!
        self.version = (Validations.checkKeyNotAvail(dict, key: "version") as?NSString)!
        self.stateId = (Validations.checkKeyNotAvail(dict, key: "stateId") as?NSString)!
        self.state = (Validations.checkKeyNotAvail(dict, key: "state") as?NSString)!
        self.diseaseType = (Validations.checkKeyNotAvail(dict, key: "diseaseType") as?NSString)!
        self.fabCPDataArray = (Validations.checkKeyNotAvailForArray(dict, key: "fabcpDataArray") as?NSArray)!
          self.tableData = (Validations.checkKeyNotAvailForArray(dict, key: "tableData") as?NSArray)!
        self.tableLocData = (Validations.checkKeyNotAvailForArray(dict, key: "tableLocData") as?NSArray)!
        self.tableHeader = (Validations.checkKeyNotAvail(dict, key: "tableHeader") as?NSString)!
        self.tableLocHeader = (Validations.checkKeyNotAvail(dict, key: "tableLocHeader") as?NSString)!
        self.des_localMsg = (Validations.checkKeyNotAvail(dict, key: "des_localMsg") as?NSString)!
         self.des_englishMsg = (Validations.checkKeyNotAvail(dict, key: "des_englishMsg") as?NSString)!
         self.product_images_urls = (Validations.checkKeyNotAvail(dict, key: "product_images_urls") as?NSString)!
    }
}
