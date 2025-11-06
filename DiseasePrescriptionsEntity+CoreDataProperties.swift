//
//  DiseasePrescriptionsEntity+CoreDataProperties.swift
//  
//
//  Created by Empover on 04/01/18.
//
//

import Foundation
import CoreData


extension DiseasePrescriptionsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiseasePrescriptionsEntity> {
        return NSFetchRequest<DiseasePrescriptionsEntity>(entityName: "DiseasePrescriptionsEntity")
    }

    @NSManaged public var active: String?
    @NSManaged public var biologicalControl: String?
    @NSManaged public var chemicalControl: String?
    @NSManaged public var createdOn: String?
    @NSManaged public var crop: String?
    @NSManaged public var diseaseBiologicalName: String?
    @NSManaged public var diseaseDeleted: String?
    @NSManaged public var diseaseId: String?
    @NSManaged public var diseaseImageFile: String?
    @NSManaged public var diseaseName: String?
    @NSManaged public var diseaseType: String?
    @NSManaged public var hazadDescription: String?
    @NSManaged public var hosts: String?
    @NSManaged public var id: String?
    @NSManaged public var inANutshell: String?
    @NSManaged public var preventiveMeasures: String?
    @NSManaged public var productMapping: String?
    @NSManaged public var productMappingImage: String?
    @NSManaged public var status: String?
    @NSManaged public var symptoms: String?
    @NSManaged public var trigger: String?
    @NSManaged public var updatedOn: String?

}
