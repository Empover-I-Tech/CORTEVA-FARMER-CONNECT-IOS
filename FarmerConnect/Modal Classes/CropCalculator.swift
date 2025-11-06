//
//  CropCalculator.swift
//  FarmerConnect
//
//  Created by Admin on 13/02/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit

class CropCalculator: NSObject {
    @objc var commercialFodderPrice: NSString
    @objc var commercialGrainPrice: NSString
    @objc var costPerIrrigation: NSString
    @objc var cropId: NSString
    @objc var cropName: NSString
    @objc var fertilizerCost: NSString
    @objc var grainYield: NSString
    @objc var calId: NSString
    @objc var isSync: NSString
    @objc var labourCost: NSString
    @objc var landPreparation: NSString
    @objc var noOfIrrigations: NSString
    @objc var pesticideCost: NSString
    @objc var seedCost: NSString
    @objc var seedRate: NSString
    @objc var status: NSString
    @objc var strawYield: NSString
    @objc var totalNoOfLabourersReq: NSString
    @objc var year: NSString
    @objc var plannedAcers: NSString = ""
    @objc var mechanicalHarvestCost: NSString = ""
    @objc var mobileId: NSString = ""
    @objc var geoLocation: NSString = ""

    /*@objc var totalSeedCost: NSString
    @objc var totalLabourCost: NSString
    @objc var totalIrrigationCost: NSString
    @objc var totalInputCost: NSString
    @objc var totalIncone: NSString
    @objc var totalIncone: NSString*/


    init(dict : NSDictionary){
        self.commercialFodderPrice = (Validations.checkKeyNotAvail(dict, key: "commercialFodderPrice") as?NSString)!
        self.cropId = (Validations.checkKeyNotAvail(dict, key: "cropId") as?NSString)!
        self.commercialGrainPrice = (Validations.checkKeyNotAvail(dict, key: "commercialGrainPrice") as?NSString)!
        self.costPerIrrigation = (Validations.checkKeyNotAvail(dict, key: "costPerIrrigation") as?NSString)!
        self.cropId = (Validations.checkKeyNotAvail(dict, key: "cropId") as?NSString)!
        self.cropName = (Validations.checkKeyNotAvail(dict, key: "cropName") as?NSString)!
        self.fertilizerCost = (Validations.checkKeyNotAvail(dict, key: "fertilizerCost") as?NSString)!
        self.grainYield = (Validations.checkKeyNotAvail(dict, key: "grainYield") as?NSString)!
        self.calId = (Validations.checkKeyNotAvail(dict, key: "id") as?NSString)!
        self.isSync = "0"
        if let syncStatus = (Validations.checkKeyNotAvail(dict, key: "isSync") as? Int64){
            self.isSync = NSString(format: "%d", syncStatus)
        }
        self.labourCost = (Validations.checkKeyNotAvail(dict, key: "labourCost") as?NSString)!
        self.landPreparation = (Validations.checkKeyNotAvail(dict, key: "landPreparation") as? NSString)!
        self.noOfIrrigations = (Validations.checkKeyNotAvail(dict, key: "noOfIrrigations") as? NSString)!
        self.pesticideCost = (Validations.checkKeyNotAvail(dict, key: "pesticideCost") as? NSString)!
        self.seedCost = (Validations.checkKeyNotAvail(dict, key: "seedCost") as? NSString)!
        self.seedRate = (Validations.checkKeyNotAvail(dict, key: "seedRate") as? NSString)!
        self.status = (Validations.checkKeyNotAvail(dict, key: "status") as? NSString)!
        self.strawYield = (Validations.checkKeyNotAvail(dict, key: "strawYield") as? NSString)!
        self.totalNoOfLabourersReq = (Validations.checkKeyNotAvail(dict, key: "totalNoOfLabourersReq") as? NSString)!
        if let noOfLabours = Validations.checkKeyNotAvail(dict, key: "totalNoOfLabourersReq") as? Int64{
            self.totalNoOfLabourersReq = NSString(format: "%d", noOfLabours)
        }
        self.year = (Validations.checkKeyNotAvail(dict, key: "year") as? NSString)!
        self.plannedAcers = (Validations.checkKeyNotAvail(dict, key: "planningAcres") as? NSString)!
    }
}
