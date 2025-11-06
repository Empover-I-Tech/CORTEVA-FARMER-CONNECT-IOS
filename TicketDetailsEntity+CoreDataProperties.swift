//
//  TicketDetailsEntity+CoreDataProperties.swift
//  
//
//  Created by Empover on 20/03/18.
//
//

import Foundation
import CoreData


extension TicketDetailsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TicketDetailsEntity> {
        return NSFetchRequest<TicketDetailsEntity>(entityName: "TicketDetailsEntity")
    }

    @NSManaged public var assignedTo: String?
    @NSManaged public var assignedToID: String?
    @NSManaged public var assignedToMobilenumber: String?
    @NSManaged public var callcenterUser: String?
    @NSManaged public var callcenterUserId: String?
    @NSManaged public var category: String?
    @NSManaged public var categoryId: String?
    @NSManaged public var crop: String?
    @NSManaged public var damagePerc: String?
    @NSManaged public var defaultWorkflow: String?
    @NSManaged public var descriptionStr: String?
    @NSManaged public var district: String?
    @NSManaged public var escalationLevel: String?
    @NSManaged public var feedback: String?
    @NSManaged public var feedbackStatus: String?
    @NSManaged public var formattedDate: String?
    @NSManaged public var formattedTicketClosedDate: String?
    @NSManaged public var formattedUpdatedDate: String?
    @NSManaged public var hybrid: String?
    @NSManaged public var id: String?
    @NSManaged public var issueType: String?
    @NSManaged public var issueTypeId: String?
    @NSManaged public var isUserSatisfy: String?
    @NSManaged public var lotNo: String?
    @NSManaged public var mobileNo: String?
    @NSManaged public var name: String?
    @NSManaged public var pincode: String?
    @NSManaged public var qty: String?
    @NSManaged public var raisedBy: String?
    @NSManaged public var raisingforUser: String?
    @NSManaged public var raisingForUserType: String?
    @NSManaged public var raisingForUserTypeId: String?
    @NSManaged public var regionName: String?
    @NSManaged public var role: String?
    @NSManaged public var stateName: String?
    @NSManaged public var status: String?
    @NSManaged public var subCategory: String?
    @NSManaged public var subCategoryId: String?
    @NSManaged public var ticketNo: String?
    @NSManaged public var userType: String?
    @NSManaged public var userTypeId: String?
    @NSManaged public var workflowNo: String?

}
