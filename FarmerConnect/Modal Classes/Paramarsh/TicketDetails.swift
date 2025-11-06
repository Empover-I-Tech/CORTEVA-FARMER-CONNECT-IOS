//
//  TicketDetails.swift
//  Paramarsh
//
//  Created by Empover on 07/02/18.
//  Copyright © 2018 Empover. All rights reserved.
//

import UIKit

class TicketDetails: NSObject {
    @objc var assignedTo: NSString?
    @objc var assignedToID: NSString?
    @objc var assignedToMobilenumber: NSString?
    @objc var callcenterUser: NSString?
    @objc var callcenterUserId: NSString?
    @objc var category: NSString?
    @objc var categoryId: NSString?
    var createdDate : Int64?
    @objc var formattedDate : String = ""
    @objc var crop: NSString?
    @objc var damagePerc: NSString?
    @objc var defaultWorkflow: NSString?
    @objc var descriptionStr: NSString?
    @objc var district: NSString?
    @objc var escalationLevel: NSString?
    @objc var feedback: NSString?
    @objc var feedbackStatus: NSString?
    @objc var hybrid: NSString?
    @objc var id: NSString?
    @objc var isUserSatisfy: NSString?
    @objc var issueType: NSString?
    @objc var issueTypeId: NSString?
    @objc var lotNo: NSString?
    @objc var mobileNo: NSString?
    @objc var name: NSString?
    @objc var pincode: NSString?
    @objc var qty: NSString?
    @objc var raisedBy: NSString?
    @objc var raisingForUserType: NSString?
    @objc var raisingForUserTypeId: NSString?
    @objc var raisingforUser: NSString?
    @objc var regionName: NSString?
    @objc var role: NSString?
    @objc var stateName: NSString?
    @objc var status: NSString?
    @objc var subCategory: NSString?
    @objc var subCategoryId: NSString?
    var ticketClosedDate : Int64?
    @objc var formattedTicketClosedDate : String = ""
    @objc var ticketNo: NSString?
    var updatedDate : Int64?
    @objc var formattedUpdatedDate : String = ""
    @objc var userType: NSString?
    @objc var userTypeId: NSString?
    @objc var workflowNo: NSString?
    
    init(dict : NSDictionary){
        self.assignedTo = (Validations.checkKeyNotAvail(dict, key: "assignedTo") as?NSString)!
        if let assignedToIDObj = dict.value(forKey: "assignedToId") as? Int {
            self.assignedToID = String(format: "%d",assignedToIDObj) as NSString
        }
        self.assignedToMobilenumber = (Validations.checkKeyNotAvail(dict, key: "assignedToMobilenumber") as?NSString)!
        self.callcenterUser = (Validations.checkKeyNotAvail(dict, key: "callcenterUser") as?NSString)!
        if let callcenterUserIdObj = dict.value(forKey: "callcenterUserId") as? Int {
            self.callcenterUserId = String(format: "%d",callcenterUserIdObj) as NSString
        }
        self.category = (Validations.checkKeyNotAvail(dict, key: "category") as?NSString)!
        if let categoryIdObj = dict.value(forKey: "categoryId") as? Int {
            self.categoryId = String(format: "%d",categoryIdObj) as NSString
        }
        
        if let date = Validations.checkKeyNotAvail(dict, key: "createdDate") as? Int64 {
            if date > 0{
                self.createdDate = date
                guard let dateFromServer = ((self.createdDate)!).dateFromMilliseconds(format: "dd/MM/yyyy") as String?  else {
                }
                self.formattedDate = dateFromServer
                print(self.formattedDate)
                
//                let dateVar = Date.init(timeIntervalSinceNow: TimeInterval(1517835664317)/1000)
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "dd-MM-yyyy hh:mm"
//                print(dateFormatter.string(from: dateVar))
                
//                if  let  timeResult = Validations.checkKeyNotAvail(dict, key: "createdDate") as? Int64 {
//                    let date = Date(timeIntervalSince1970: TimeInterval(timeResult)/1000)
//                    let dateFormatter = DateFormatter()
//                    //dateFormatter.dateStyle = DateFormatter.Style.medium
//                    dateFormatter.dateFormat = "dd-MMM-yyyy"
//                    dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
//                    let localDate = dateFormatter.string(from: date)
//                    print(localDate)
//
//                }
            }
        }
        self.crop = (Validations.checkKeyNotAvail(dict, key: "crop") as?NSString)
        self.damagePerc = (Validations.checkKeyNotAvail(dict, key: "damagePerc") as?NSString)
//        if let damagePercObj = dict.value(forKey: "damagePerc") as? Int {
//            self.damagePerc = String(format: "%d",damagePercObj) as NSString
//        }
        if let defaultWorkflowObj = dict.value(forKey: "defaultWorkflow") as? Bool {
            self.defaultWorkflow = String(defaultWorkflowObj) as NSString
        }
        //self.defaultWorkflow = (Validations.checkKeyNotAvail(dict, key: "defaultWorkflow") as?NSString)!
        self.descriptionStr = (Validations.checkKeyNotAvail(dict, key: "description") as?NSString)
        self.district = (Validations.checkKeyNotAvail(dict, key: "district") as?NSString)
        if let escalationLevelObj = dict.value(forKey: "escalationLevel") as? Int {
            self.escalationLevel = String(format: "%d",escalationLevelObj) as NSString
        }
        self.feedback = (Validations.checkKeyNotAvail(dict, key: "feedback") as?NSString)!
        self.feedbackStatus = (Validations.checkKeyNotAvail(dict, key: "feedbackStatus") as?NSString)
        self.hybrid = (Validations.checkKeyNotAvail(dict, key: "hybrid") as?NSString)!
        if let idObj = dict.value(forKey: "id") as? Int {
            self.id = String(format: "%d",idObj) as NSString
        }
        self.isUserSatisfy = (Validations.checkKeyNotAvail(dict, key: "isUserSatisfy") as?NSString)
        self.issueType = (Validations.checkKeyNotAvail(dict, key: "issueType") as?NSString)
        if let issueTypeIdObj = dict.value(forKey: "issueTypeId") as? Int {
            self.issueTypeId = String(format: "%d",issueTypeIdObj) as NSString
        }
        self.lotNo = (Validations.checkKeyNotAvail(dict, key: "lotNo") as?NSString)
        if let lotNoObj = dict.value(forKey: "lotNo") as? Int {
            self.lotNo = String(format: "%d",lotNoObj) as NSString
        }
        self.mobileNo = (Validations.checkKeyNotAvail(dict, key: "mobileNo") as?NSString)
        self.name = (Validations.checkKeyNotAvail(dict, key: "name") as?NSString)
        self.pincode = (Validations.checkKeyNotAvail(dict, key: "pincode") as?NSString)
        self.qty = (Validations.checkKeyNotAvail(dict, key: "qty") as?NSString)
        self.raisedBy = (Validations.checkKeyNotAvail(dict, key: "raisedBy") as?NSString)
        self.raisingForUserType = (Validations.checkKeyNotAvail(dict, key: "raisingForUserType") as?NSString)
        if let raisingForUserTypeIdObj = dict.value(forKey: "raisingForUserTypeId") as? Int {
            self.raisingForUserTypeId = String(format: "%d",raisingForUserTypeIdObj) as NSString
        }
        self.raisingforUser = (Validations.checkKeyNotAvail(dict, key: "raisingforUser") as?NSString)
        self.regionName = (Validations.checkKeyNotAvail(dict, key: "regionName") as?NSString)
        self.role = (Validations.checkKeyNotAvail(dict, key: "role") as?NSString)
        self.stateName = (Validations.checkKeyNotAvail(dict, key: "stateName") as?NSString)
        self.status = (Validations.checkKeyNotAvail(dict, key: "status") as?NSString)
        self.subCategory = (Validations.checkKeyNotAvail(dict, key: "subCategory") as?NSString)
        if let subCategoryIdObj = dict.value(forKey: "subCategoryId") as? Int {
            self.subCategoryId = String(format: "%d",subCategoryIdObj) as NSString
        }
        if let date = Validations.checkKeyNotAvail(dict, key: "ticketClosedDate") as? Int64 {
            if date > 0{
                self.ticketClosedDate = date
                guard let dateFromServer = ((self.ticketClosedDate)!).dateFromMilliseconds(format: "dd/MM/yyyy") as String?  else {
                }
                self.formattedTicketClosedDate = dateFromServer
                print(self.formattedTicketClosedDate)
            }
        }
        self.ticketNo = (Validations.checkKeyNotAvail(dict, key: "ticketNo") as?NSString)
//        if let ticketNoObj = dict.value(forKey: "ticketNo") as? Int {
//            self.ticketNo = String(format: "%d",ticketNoObj) as NSString
//        }
        if let date = Validations.checkKeyNotAvail(dict, key: "updatedDate") as? Int64 {
            if date > 0{
                self.updatedDate = date
                guard let dateFromServer = ((self.updatedDate)!).dateFromMilliseconds(format: "dd/MM/yyyy") as String?  else {
                }
                self.formattedUpdatedDate = dateFromServer
                print(self.formattedUpdatedDate)
            }
        }
        self.userType = (Validations.checkKeyNotAvail(dict, key: "userType") as?NSString)
        if let userTypeIdObj = dict.value(forKey: "userTypeId") as? Int {
            self.userTypeId = String(format: "%d",userTypeIdObj) as NSString
        }
        self.workflowNo = (Validations.checkKeyNotAvail(dict, key: "workflowNo") as?NSString)
    }
}

