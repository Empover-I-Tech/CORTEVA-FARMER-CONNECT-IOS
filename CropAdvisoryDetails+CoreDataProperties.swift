//
//  CropAdvisoryDetails+CoreDataProperties.swift
//  
//
//  Created by Empover on 08/01/18.
//
//

import Foundation
import CoreData


extension CropAdvisoryDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CropAdvisoryDetails> {
        return NSFetchRequest<CropAdvisoryDetails>(entityName: "CropAdvisoryDetails")
    }

    @NSManaged public var categoryId: String?
    @NSManaged public var categoryName: String?
    @NSManaged public var cropAdvisoryStages: NSData?
    @NSManaged public var cropId: String?
    @NSManaged public var cropName: String?
    @NSManaged public var hybridId: String?
    @NSManaged public var hybridName: String?
    @NSManaged public var caRequestMasterId: String?
    @NSManaged public var seasonId: String?
    @NSManaged public var seasonName: String?
    @NSManaged public var sowingDate: String?
    @NSManaged public var stateId: String?
    @NSManaged public var stateName: String?

}
