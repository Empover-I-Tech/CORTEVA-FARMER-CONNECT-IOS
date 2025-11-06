//
//  AgroProductMasterEntity+CoreDataProperties.swift
//  
//
//  Created by Empover on 04/01/18.
//
//

import Foundation
import CoreData


extension AgroProductMasterEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AgroProductMasterEntity> {
        return NSFetchRequest<AgroProductMasterEntity>(entityName: "AgroProductMasterEntity")
    }

    @NSManaged public var active: String?
    @NSManaged public var caution: String?
    @NSManaged public var character: String?
    @NSManaged public var createdOn: String?
    @NSManaged public var cropAndDiseaseNamesArray: NSData?
    @NSManaged public var cropAndDiseaseNamesForMobile: String?
    @NSManaged public var id: String?
    @NSManaged public var productDeleted: String?
    @NSManaged public var productImage: String?
    @NSManaged public var productName: String?
    @NSManaged public var productUse: String?
    @NSManaged public var resultAndEffect: String?
    @NSManaged public var status: String?
    @NSManaged public var type: String?
    @NSManaged public var updatedOn: String?
    @NSManaged public var work: String?

}
