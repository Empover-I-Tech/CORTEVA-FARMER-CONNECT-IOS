//
//  FAB_CPDetails+CoreDataProperties.swift
//  
//
//  Created by Empover-i-Tech on 30/03/20.
//
//

import Foundation
import CoreData


extension FAB_CPDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FAB_CPDetails> {
        return NSFetchRequest<FAB_CPDetails>(entityName: "FAB_CPDetails")
    }

    @NSManaged public var cropId: String?
    @NSManaged public var cropName: String?
    @NSManaged public var diseaseId: String?
    @NSManaged public var fabcpData: Data?
    @NSManaged public var diseaseName: String?
    @NSManaged public var productName: String?
    @NSManaged public var productId: String?
    @NSManaged public var version: String?
    @NSManaged public var id: String?

}
