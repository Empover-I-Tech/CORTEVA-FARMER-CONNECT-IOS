//
//  NotificationsEntity+CoreDataProperties.swift
//  
//
//  Created by Empover on 04/01/18.
//
//

import Foundation
import CoreData


extension NotificationsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NotificationsEntity> {
        return NSFetchRequest<NotificationsEntity>(entityName: "NotificationsEntity")
    }

    @NSManaged public var notificationId: String?
    @NSManaged public var createdOn: String?
    @NSManaged public var notificationMsg: String?

}
