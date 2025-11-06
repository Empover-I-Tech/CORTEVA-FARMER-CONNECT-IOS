//
//  CropCalculatorEntity+CoreDataProperties.swift
//  
//
//  Created by Admin on 14/02/18.
//
//

import Foundation
import CoreData


extension CropCalculatorEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CropCalculatorEntity> {
        return NSFetchRequest<CropCalculatorEntity>(entityName: "CropCalculatorEntity")
    }

    @NSManaged public var landPreparation: String?
    @NSManaged public var seedCost: String?
    @NSManaged public var seedRate: String?
    @NSManaged public var totalSeedCost: String?
    @NSManaged public var labourCost: String?
    @NSManaged public var totalNoOfLabours: String?
    @NSManaged public var mechanicalHarvestingCost: String?
    @NSManaged public var totalLabourCost: String?
    @NSManaged public var costPerIrrigation: String?
    @NSManaged public var noOfIrrigations: String?
    @NSManaged public var totalIrrigationCost: String?
    @NSManaged public var fertiliserCost: String?
    @NSManaged public var pesticidesCost: String?
    @NSManaged public var totalInputCost: String?
    @NSManaged public var grainYield: String?
    @NSManaged public var commercialGrainPrice: String?
    @NSManaged public var strawYield: String?
    @NSManaged public var commercialFooderPrice: String?
    @NSManaged public var totalIncome: String?
    @NSManaged public var netProfit: String?
    @NSManaged public var isSynced: Bool
    @NSManaged public var cropName: String?
    @NSManaged public var mobileId: String?
    @NSManaged public var geoLocation: String?
    @NSManaged public var status: String?
    @NSManaged public var year: String?
    @NSManaged public var planningAcers: String?

}
