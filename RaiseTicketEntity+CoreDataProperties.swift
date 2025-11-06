//
//  RaiseTicketEntity+CoreDataProperties.swift
//  
//
//  Created by Empover on 20/03/18.
//
//

import Foundation
import CoreData


extension RaiseTicketEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RaiseTicketEntity> {
        return NSFetchRequest<RaiseTicketEntity>(entityName: "RaiseTicketEntity")
    }

    @NSManaged public var crop: String?
    @NSManaged public var damagePerc: String?
    @NSManaged public var descriptionStr: String?
    @NSManaged public var district: String?
    @NSManaged public var hybrid: String?
    @NSManaged public var id: Int64
    @NSManaged public var isSentToServer: Bool
    @NSManaged public var issueType: String?
    @NSManaged public var isUserExist: Bool
    @NSManaged public var lotNo: String?
    @NSManaged public var mobileNo: String?
    @NSManaged public var name: String?
    @NSManaged public var pincode: String?
    @NSManaged public var raisingForUserType: String?
    @NSManaged public var retailerMobileNo: String?
    @NSManaged public var retailerName: String?
    @NSManaged public var userType: String?

}
