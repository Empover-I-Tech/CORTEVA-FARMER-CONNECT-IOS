//
//  FABDetails+CoreDataProperties.swift
//  
//
//  Created by Empover-i-Tech on 30/03/20.
//
//

import Foundation
import CoreData


extension FABDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FABDetails> {
        return NSFetchRequest<FABDetails>(entityName: "FABDetails")
    }

    @NSManaged public var cropId: String?
    @NSManaged public var cropName: String?
    @NSManaged public var fabData: Data?
    @NSManaged public var hybridId: String?
    @NSManaged public var hybridName: String?
    @NSManaged public var id: String?
    @NSManaged public var mainDescription: String?
    @NSManaged public var seasonId: String?
    @NSManaged public var seasonName: String?
    @NSManaged public var stateId: String?
    @NSManaged public var stateName: String?
    @NSManaged public var version: String?

}
