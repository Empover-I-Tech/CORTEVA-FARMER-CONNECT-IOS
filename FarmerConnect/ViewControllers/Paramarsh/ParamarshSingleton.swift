//
//  ParamarshSingleton.swift
//  FarmerConnect
//
//  Created by Empover on 20/03/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class ParamarshSingleton: NSObject {

    //MARK: Shared Instance
    static let sharedInstance : Singleton = {
        let instance = Singleton()
        return instance
    }()
    
     static var successHandler :((Bool) -> Void)?
    
    //MARK: saveTicketDetails
    class func saveTicketDetails(_ details : TicketDetails)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TicketDetailsEntity")
        fetchRequest.predicate = NSPredicate(format: "id = %@",details.id!)
        
        do {
            let results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            
            //update record
            if results.count > 0 {
                // print("already saved")
                let managedObject = results[0]
                managedObject.setValue(details.assignedTo, forKey: "assignedTo")
                managedObject.setValue(details.assignedToID, forKey: "assignedToID")
                managedObject.setValue(details.assignedToMobilenumber, forKey: "assignedToMobilenumber")
                managedObject.setValue(details.callcenterUser, forKey: "callcenterUser")
                managedObject.setValue(details.callcenterUserId, forKey: "callcenterUserId")
                managedObject.setValue(details.category, forKey: "category")
                managedObject.setValue(details.categoryId, forKey: "categoryId")
                managedObject.setValue(details.formattedDate, forKey: "formattedDate")
                managedObject.setValue(details.crop, forKey: "crop")
                managedObject.setValue(details.damagePerc, forKey: "damagePerc")
                managedObject.setValue(details.defaultWorkflow, forKey: "defaultWorkflow")
                managedObject.setValue(details.descriptionStr, forKey: "descriptionStr")
                managedObject.setValue(details.district, forKey: "district")
                managedObject.setValue(details.escalationLevel, forKey: "escalationLevel")
                managedObject.setValue(details.feedback, forKey: "feedback")
                managedObject.setValue(details.feedbackStatus, forKey: "feedbackStatus")
                managedObject.setValue(details.hybrid, forKey: "hybrid")
                managedObject.setValue(details.id, forKey: "id")
                managedObject.setValue(details.isUserSatisfy, forKey: "isUserSatisfy")
                managedObject.setValue(details.issueType, forKey: "issueType")
                managedObject.setValue(details.issueTypeId, forKey: "issueTypeId")
                managedObject.setValue(details.lotNo, forKey: "lotNo")
                managedObject.setValue(details.mobileNo, forKey: "mobileNo")
                managedObject.setValue(details.name, forKey: "name")
                managedObject.setValue(details.pincode, forKey: "pincode")
                managedObject.setValue(details.qty, forKey: "qty")
                managedObject.setValue(details.raisedBy, forKey: "raisedBy")
                managedObject.setValue(details.raisingForUserType, forKey: "raisingForUserType")
                managedObject.setValue(details.raisingForUserTypeId, forKey: "raisingForUserTypeId")
                managedObject.setValue(details.raisingforUser, forKey: "raisingforUser")
                managedObject.setValue(details.regionName, forKey: "regionName")
                managedObject.setValue(details.role, forKey: "role")
                managedObject.setValue(details.stateName, forKey: "stateName")
                managedObject.setValue(details.status, forKey: "status")
                managedObject.setValue(details.subCategory, forKey: "subCategory")
                managedObject.setValue(details.subCategoryId, forKey: "subCategoryId")
                managedObject.setValue(details.formattedTicketClosedDate, forKey: "formattedTicketClosedDate")
                managedObject.setValue(details.ticketNo, forKey: "ticketNo")
                managedObject.setValue(details.formattedUpdatedDate, forKey: "formattedUpdatedDate")
                managedObject.setValue(details.userType, forKey: "userType")
                managedObject.setValue(details.userTypeId, forKey: "userTypeId")
                managedObject.setValue(details.workflowNo, forKey: "workflowNo")
                
                try managedContext!.save()
                
                return
            }
            else{//insert new record
                let entity =  NSEntityDescription.entity(forEntityName: "TicketDetailsEntity",in:managedContext!)
                let managedObject = NSManagedObject(entity: entity!,insertInto: managedContext)
                
                managedObject.setValue(details.assignedTo, forKey: "assignedTo")
                managedObject.setValue(details.assignedToID, forKey: "assignedToID")
                managedObject.setValue(details.assignedToMobilenumber, forKey: "assignedToMobilenumber")
                managedObject.setValue(details.callcenterUser, forKey: "callcenterUser")
                managedObject.setValue(details.callcenterUserId, forKey: "callcenterUserId")
                managedObject.setValue(details.category, forKey: "category")
                managedObject.setValue(details.categoryId, forKey: "categoryId")
                managedObject.setValue(details.formattedDate, forKey: "formattedDate")
                managedObject.setValue(details.crop, forKey: "crop")
                managedObject.setValue(details.damagePerc, forKey: "damagePerc")
                managedObject.setValue(details.defaultWorkflow, forKey: "defaultWorkflow")
                managedObject.setValue(details.descriptionStr, forKey: "descriptionStr")
                managedObject.setValue(details.district, forKey: "district")
                managedObject.setValue(details.escalationLevel, forKey: "escalationLevel")
                managedObject.setValue(details.feedback, forKey: "feedback")
                managedObject.setValue(details.feedbackStatus, forKey: "feedbackStatus")
                managedObject.setValue(details.hybrid, forKey: "hybrid")
                managedObject.setValue(details.id, forKey: "id")
                managedObject.setValue(details.isUserSatisfy, forKey: "isUserSatisfy")
                managedObject.setValue(details.issueType, forKey: "issueType")
                managedObject.setValue(details.issueTypeId, forKey: "issueTypeId")
                managedObject.setValue(details.lotNo, forKey: "lotNo")
                managedObject.setValue(details.mobileNo, forKey: "mobileNo")
                managedObject.setValue(details.name, forKey: "name")
                managedObject.setValue(details.pincode, forKey: "pincode")
                managedObject.setValue(details.qty, forKey: "qty")
                managedObject.setValue(details.raisedBy, forKey: "raisedBy")
                managedObject.setValue(details.raisingForUserType, forKey: "raisingForUserType")
                managedObject.setValue(details.raisingForUserTypeId, forKey: "raisingForUserTypeId")
                managedObject.setValue(details.raisingforUser, forKey: "raisingforUser")
                managedObject.setValue(details.regionName, forKey: "regionName")
                managedObject.setValue(details.role, forKey: "role")
                managedObject.setValue(details.stateName, forKey: "stateName")
                managedObject.setValue(details.status, forKey: "status")
                managedObject.setValue(details.subCategory, forKey: "subCategory")
                managedObject.setValue(details.subCategoryId, forKey: "subCategoryId")
                managedObject.setValue(details.formattedTicketClosedDate, forKey: "formattedTicketClosedDate")
                managedObject.setValue(details.ticketNo, forKey: "ticketNo")
                managedObject.setValue(details.formattedUpdatedDate, forKey: "formattedUpdatedDate")
                managedObject.setValue(details.userType, forKey: "userType")
                managedObject.setValue(details.userTypeId, forKey: "userTypeId")
                managedObject.setValue(details.workflowNo, forKey: "workflowNo")
                
                do {
                    try managedContext!.save()
                    // print("saved successfully")
                    //self.window?.makeToast(CROP_ADVISORY_SUCCESSFULLY_STORED, duration: 1.0, position: .center)
                }
                catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    //MARK: retrieve Ticket details from DB
    class func getTicketDetailsFromDB(_ entity:String) -> NSMutableArray
    {
        let detailsMutArray  = NSMutableArray()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        //fetchRequest.predicate = NSPredicate(format: "userId = %@",GRAPHICS.Get_UserID())
        
        do {
            let results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            
            for detailsObj  in results as [NSManagedObject] {
                
                let detailsEntity : TicketDetails  =   TicketDetails(dict:NSMutableDictionary())
                
                detailsEntity.assignedTo = (detailsObj.value(forKey: "assignedTo")! as? String)! as NSString
                if detailsObj.value(forKey: "assignedToID") != nil{
                    detailsEntity.assignedToID = (detailsObj.value(forKey: "assignedToID")! as? String)! as NSString
                }
                if detailsObj.value(forKey: "assignedToMobilenumber") != nil{
                    detailsEntity.assignedToMobilenumber = (detailsObj.value(forKey: "assignedToMobilenumber")! as? String)! as NSString
                }
                if detailsObj.value(forKey: "callcenterUser") != nil{
                    detailsEntity.callcenterUser = (detailsObj.value(forKey: "callcenterUser")! as? String)! as NSString
                }
                if detailsObj.value(forKey: "callcenterUserId") != nil{
                    detailsEntity.callcenterUserId = (detailsObj.value(forKey: "callcenterUserId")! as? String)! as NSString
                }
                if detailsObj.value(forKey: "category") != nil{
                    detailsEntity.category = (detailsObj.value(forKey: "category")! as? String)! as NSString
                }
                if detailsObj.value(forKey: "categoryId") != nil{
                    detailsEntity.categoryId = (detailsObj.value(forKey: "categoryId")! as? String)! as NSString
                }
                if detailsObj.value(forKey: "formattedDate") != nil{
                    detailsEntity.formattedDate = ((detailsObj.value(forKey: "formattedDate")! as? String)! as NSString) as String
                }
                if detailsObj.value(forKey: "crop") != nil{
                    detailsEntity.crop = (detailsObj.value(forKey: "crop")! as? String)! as NSString
                }
                if detailsObj.value(forKey: "damagePerc") != nil{
                    detailsEntity.damagePerc = (detailsObj.value(forKey: "damagePerc")! as? String)! as NSString
                }
                if detailsObj.value(forKey: "defaultWorkflow") != nil{
                    detailsEntity.defaultWorkflow = (detailsObj.value(forKey: "defaultWorkflow")! as? String)! as NSString
                }
                if detailsObj.value(forKey: "descriptionStr") != nil{
                    detailsEntity.descriptionStr = (detailsObj.value(forKey: "descriptionStr")! as? String)! as NSString
                }
                if detailsObj.value(forKey: "district") != nil{
                    detailsEntity.district = (detailsObj.value(forKey: "district")! as? String)! as NSString
                }
                if detailsObj.value(forKey: "escalationLevel") != nil{
                    detailsEntity.escalationLevel = (detailsObj.value(forKey: "escalationLevel")! as? String) as NSString?
                }
                if detailsObj.value(forKey: "feedback") != nil{
                    detailsEntity.feedback = (detailsObj.value(forKey: "feedback")! as? String) as NSString?
                }
                if detailsObj.value(forKey: "feedbackStatus") != nil{
                    detailsEntity.feedbackStatus = (detailsObj.value(forKey: "feedbackStatus")! as? String) as NSString?
                }
                if detailsObj.value(forKey: "hybrid") != nil{
                    detailsEntity.hybrid = (detailsObj.value(forKey: "hybrid")! as? String)! as NSString?
                }
                if detailsObj.value(forKey: "id") != nil{
                    detailsEntity.id = (detailsObj.value(forKey: "id")! as? String)! as NSString?
                }
                if detailsObj.value(forKey: "isUserSatisfy") != nil{
                    detailsEntity.isUserSatisfy = (detailsObj.value(forKey: "isUserSatisfy")! as? String) as NSString?
                }
                if detailsObj.value(forKey: "issueType") != nil{
                    detailsEntity.issueType = (detailsObj.value(forKey: "issueType")! as? String) as NSString?
                }
                if detailsObj.value(forKey: "issueTypeId") != nil{
                    detailsEntity.issueTypeId = (detailsObj.value(forKey: "issueTypeId")! as? String) as NSString?
                }
                if detailsObj.value(forKey: "lotNo") != nil{
                    detailsEntity.lotNo = (detailsObj.value(forKey: "lotNo")! as? String) as NSString?
                }
                if detailsObj.value(forKey: "mobileNo") != nil{
                    detailsEntity.mobileNo = (detailsObj.value(forKey: "mobileNo")! as? String) as NSString?
                }
                if detailsObj.value(forKey: "name") != nil{
                    detailsEntity.name = (((detailsObj.value(forKey: "name")! as? String)! as NSString) as String) as String as NSString
                }
                if detailsObj.value(forKey: "pincode") != nil{
                    detailsEntity.pincode = (detailsObj.value(forKey: "pincode")! as? String) as NSString?
                }
                if detailsObj.value(forKey: "qty") != nil{
                    detailsEntity.qty = (detailsObj.value(forKey: "qty")! as? String) as NSString?
                }
                if detailsObj.value(forKey: "raisedBy") != nil{
                    detailsEntity.raisedBy = (detailsObj.value(forKey: "raisedBy")! as? String) as NSString?
                }
                if detailsObj.value(forKey: "raisingForUserType") != nil{
                    detailsEntity.raisingForUserType = (detailsObj.value(forKey: "raisingForUserType")! as? String) as NSString?
                }
                if detailsObj.value(forKey: "raisingForUserTypeId") != nil{
                    detailsEntity.raisingForUserTypeId = (detailsObj.value(forKey: "raisingForUserTypeId")! as? String) as NSString?
                }
                if detailsObj.value(forKey: "raisingforUser") != nil{
                    detailsEntity.raisingforUser = (detailsObj.value(forKey: "raisingforUser")! as? String) as NSString?
                }
                if detailsObj.value(forKey: "regionName") != nil{
                    detailsEntity.regionName = (detailsObj.value(forKey: "regionName")! as? String) as NSString?
                }
                if detailsObj.value(forKey: "role") != nil{
                    detailsEntity.role = (detailsObj.value(forKey: "role")! as? String) as NSString?
                }
                if detailsObj.value(forKey: "stateName") != nil{
                    detailsEntity.stateName = (detailsObj.value(forKey: "stateName")! as? String) as NSString?
                }
                if detailsObj.value(forKey: "status") != nil{
                    detailsEntity.status = (detailsObj.value(forKey: "status")! as? String) as NSString?
                }
                if detailsObj.value(forKey: "subCategory") != nil{
                    detailsEntity.subCategory = (detailsObj.value(forKey: "subCategory")! as? String) as NSString?
                }
                if detailsObj.value(forKey: "subCategoryId") != nil{
                    detailsEntity.subCategoryId = (detailsObj.value(forKey: "subCategoryId")! as? String) as NSString?
                }
                if detailsObj.value(forKey: "formattedTicketClosedDate") != nil{
                    detailsEntity.formattedTicketClosedDate = ((detailsObj.value(forKey: "formattedTicketClosedDate")! as? String) as NSString?) as String? ?? ""
                }
                if detailsObj.value(forKey: "ticketNo") != nil{
                    detailsEntity.ticketNo = (detailsObj.value(forKey: "ticketNo")! as? String)! as NSString
                }
                if detailsObj.value(forKey: "formattedUpdatedDate") != nil{
                    detailsEntity.formattedUpdatedDate = ((detailsObj.value(forKey: "formattedUpdatedDate")! as? String)! as NSString) as String
                }
                if detailsObj.value(forKey: "userType") != nil{
                    detailsEntity.userType = (detailsObj.value(forKey: "userType")! as? String) as NSString?
                }
                if detailsObj.value(forKey: "userTypeId") != nil{
                    detailsEntity.userTypeId = (detailsObj.value(forKey: "userTypeId")! as? String) as NSString?
                }
                if detailsObj.value(forKey: "workflowNo") != nil{
                    detailsEntity.workflowNo = (detailsObj.value(forKey: "workflowNo")! as? String) as NSString?
                }
                //print("\(detailsEntity.id) , \(detailsEntity.formattedDate)")
                //print(" stages : \(detailsEntity.cropAdvisoryDetailsStages)")
                detailsMutArray.add(detailsEntity)
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return detailsMutArray
    }
    
    //MARK: deleteTicketDetails [for testing]
    @objc class func deleteTicketDetails() {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.managedObjectContext
        let coord = appDel.persistentStoreCoordinator
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TicketDetailsEntity")
        fetchRequest.includesPropertyValues = false
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try coord.execute(deleteRequest, with: context)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
    //MARK: saveRaiseTicketDetails
    class func saveRaiseTicketDetails(_ details : RaiseTicket)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RaiseTicketEntity")
        fetchRequest.predicate = NSPredicate(format: "id = %ld",details.id!)
        do {
            let results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            
            //update record
            if results.count > 0 {
                let managedObject = results[0]
                managedObject.setValue(details.id, forKey: "id")
                managedObject.setValue(details.crop, forKey: "crop")
                managedObject.setValue(details.damagePerc, forKey: "damagePerc")
                managedObject.setValue(details.descriptionStr, forKey: "descriptionStr")
                managedObject.setValue(details.district, forKey: "district")
                managedObject.setValue(details.hybrid, forKey: "hybrid")
                managedObject.setValue(details.issueType, forKey: "issueType")
                managedObject.setValue(details.isSentToServer, forKey: "isSentToServer")
                managedObject.setValue(details.isUserExist, forKey: "isUserExist")
                managedObject.setValue(details.lotNo, forKey: "lotNo")
                managedObject.setValue(details.mobileNo, forKey: "mobileNo")
                managedObject.setValue(details.name, forKey: "name")
                managedObject.setValue(details.pincode, forKey: "pincode")
                managedObject.setValue(details.raisingForUserType, forKey: "raisingForUserType")
                managedObject.setValue(details.retailerMobileNo, forKey: "retailerMobileNo")
                managedObject.setValue(details.retailerName, forKey: "retailerName")
                managedObject.setValue(details.userType, forKey: "userType")
                try managedContext!.save()
                return
            }
            else{//insert new record
                let entity =  NSEntityDescription.entity(forEntityName: "RaiseTicketEntity",in:managedContext!)
                let managedObject = NSManagedObject(entity: entity!,insertInto: managedContext)
                managedObject.setValue(details.id, forKey: "id")
                managedObject.setValue(details.crop, forKey: "crop")
                managedObject.setValue(details.damagePerc, forKey: "damagePerc")
                managedObject.setValue(details.descriptionStr, forKey: "descriptionStr")
                managedObject.setValue(details.district, forKey: "district")
                managedObject.setValue(details.hybrid, forKey: "hybrid")
                managedObject.setValue(details.issueType, forKey: "issueType")
                managedObject.setValue(details.isSentToServer, forKey: "isSentToServer")
                managedObject.setValue(details.isUserExist, forKey: "isUserExist")
                managedObject.setValue(details.lotNo, forKey: "lotNo")
                managedObject.setValue(details.mobileNo, forKey: "mobileNo")
                managedObject.setValue(details.name, forKey: "name")
                managedObject.setValue(details.pincode, forKey: "pincode")
                managedObject.setValue(details.raisingForUserType, forKey: "raisingForUserType")
                managedObject.setValue(details.retailerMobileNo, forKey: "retailerMobileNo")
                managedObject.setValue(details.retailerName, forKey: "retailerName")
                managedObject.setValue(details.userType, forKey: "userType")
                
                do {
                    try managedContext!.save()
                    // print("saved successfully")
                }
                catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    //MARK: retrieve Ticket details from DB
    class func getRaiseTicketDetailsFromDB(_ entity:String) -> NSMutableArray
    {
        let detailsMutArray  = NSMutableArray()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        do {
            let results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            for detailsObj  in results as [NSManagedObject] {
                let detailsEntity : RaiseTicket  =   RaiseTicket(dict:NSMutableDictionary())
                detailsEntity.id = detailsObj.value(forKey: "id")! as? Int
                detailsEntity.crop = (detailsObj.value(forKey: "crop")! as? String)! as NSString
                detailsEntity.hybrid = (detailsObj.value(forKey: "hybrid")! as? String)! as NSString
                detailsEntity.damagePerc = (detailsObj.value(forKey: "damagePerc")! as? String)! as NSString
                detailsEntity.descriptionStr = (detailsObj.value(forKey: "descriptionStr")! as? String)! as NSString
                detailsEntity.district = (detailsObj.value(forKey: "district")! as? String)! as NSString
                detailsEntity.isSentToServer = detailsObj.value(forKey: "isSentToServer")! as? Bool ?? false
                detailsEntity.isUserExist = detailsObj.value(forKey: "isUserExist")! as? Bool
                detailsEntity.issueType = (detailsObj.value(forKey: "issueType")! as? String)! as NSString
                detailsEntity.lotNo = (detailsObj.value(forKey: "lotNo")! as? String)! as NSString
                detailsEntity.mobileNo = (detailsObj.value(forKey: "mobileNo")! as? String)! as NSString
                detailsEntity.name = (detailsObj.value(forKey: "name")! as? String)! as NSString
                detailsEntity.pincode = (detailsObj.value(forKey: "pincode")! as? String)! as NSString
                detailsEntity.raisingForUserType = (detailsObj.value(forKey: "raisingForUserType")! as? String)! as NSString
                detailsEntity.retailerMobileNo = (detailsObj.value(forKey: "retailerMobileNo")! as? String)! as NSString
                detailsEntity.retailerName = (detailsObj.value(forKey: "retailerName")! as? String)! as NSString
                detailsEntity.userType = (detailsObj.value(forKey: "userType")! as? String)! as NSString
                
                detailsMutArray.add(detailsEntity)
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return detailsMutArray
    }
    
    //MARK: deleteRaiseTicketDetails [for testing]
    @objc class func deleteRaiseTicketDetails() {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.managedObjectContext
        let coord = appDel.persistentStoreCoordinator
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RaiseTicketEntity")
        fetchRequest.includesPropertyValues = false
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try coord.execute(deleteRequest, with: context)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
    //MARK: sendPendingTicketsToServer
    class func sendPendingTicketsToServer(){
        let retrievedArrFromDB = self.getRaiseTicketDetailsFromDB("RaiseTicketEntity")
        let dbPredicate = NSPredicate(format: "isSentToServer = %@",NSNumber(value: false))
        let outputFilteredArr = (retrievedArrFromDB).filtered(using: dbPredicate) as NSArray
        if outputFilteredArr.count > 0{
            let mutArrayToServer = NSMutableArray()
            for ticket in (0..<outputFilteredArr.count){
                let raiseTicketDict = NSMutableDictionary()
                let ticketObj = outputFilteredArr.object(at: ticket) as? RaiseTicket
                raiseTicketDict.setValue("", forKey: "id")
                raiseTicketDict.setValue(ticketObj?.name, forKey: "name")
                raiseTicketDict.setValue(ticketObj?.pincode, forKey: "pincode")
                raiseTicketDict.setValue(ticketObj?.descriptionStr, forKey: "description")
                raiseTicketDict.setValue(ticketObj?.issueType?.integerValue, forKey: "issueType")
                raiseTicketDict.setValue(ticketObj?.crop?.integerValue, forKey: "crop")
                raiseTicketDict.setValue(ticketObj?.hybrid?.integerValue, forKey: "hybrid")
                //raiseTicketDict.setValue("0", forKey: "district")
                raiseTicketDict.setValue("", forKey: "retailerName")
                raiseTicketDict.setValue(1, forKey: "userType")
                raiseTicketDict.setValue(1, forKey: "raisingForUserType")
                raiseTicketDict.setValue("", forKey: "retailerMobileNo")
                raiseTicketDict.setValue(ticketObj?.mobileNo, forKey: "mobileNo")
                raiseTicketDict.setValue(ticketObj?.lotNo, forKey: "lotNo")
                raiseTicketDict.setValue(ticketObj?.damagePerc, forKey: "damagePerc")
                raiseTicketDict.setValue(ticketObj?.isUserExist, forKey: "isUserExist")
                raiseTicketDict.setValue(ticketObj?.pincode, forKey: "pincodeNew")
                mutArrayToServer.add(raiseTicketDict)
            }
            //print(mutArrayToServer)
            
            //let jsonData: Data =  try! JSONSerialization.data(withJSONObject: mutArrayToServer, options: JSONSerialization.WritingOptions.prettyPrinted)
            //let strJSON : NSString =  NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)!
            //print(strJSON)
            self.requestToSendPendingTicketsToServer(params: mutArrayToServer as! [[String : Any]])//[[String:Any]]
        }
        else{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.makeToast("Data is not available to upload")
        }
    }
    
    //MARK: requestToSendPendingTicketsToServer
    class func requestToSendPendingTicketsToServer (params : [[String:Any]]){
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [PARAMARSH_BASE_URL,PARAMARSH_RAISE_TICKET])
//                Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
//                    SwiftLoader.hide()
//                    if response.result.error == nil {
//                        if let json = response.result.value {
//                            print("Response :\(json)")
//                        }
//                    }
//                    else{
//                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                        appDelegate.window?.makeToast((response.result.error?.localizedDescription)!, duration: 1.0, position: .center)
//                        return
//                    }
//                }
        
//        //var parameters = [[String:AnyObject]]()
        if let url = NSURL(string:urlString){
            var request = URLRequest(url: url as URL)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            Alamofire.request(request).responseJSON { response in
                SwiftLoader.hide()
                if response.result.error == nil {
                    if let json = response.result.value {
                        print("Response :\(json)")
                        let responseStatusCode = (json as! NSDictionary).value(forKey: "code") as! NSInteger //ticketNo
                        if responseStatusCode == SUCCESS_STATUS_CODE_100{
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window?.makeToast("Your complaint raised successfully")
                            self.deleteTicket()
                            self.successHandler?(true)
                        }
                    }
                }
                else{
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.makeToast((response.result.error?.localizedDescription)!, duration: 1.0, position: .center)
                    return
                }
            }
        }
    }
    
    //    func deleteTicketWithID(id:Int)
    //    {
    //        let appDelegate = UIApplication.shared.delegate as? AppDelegate
    //        let managedContext = appDelegate?.managedObjectContext
    //        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"RaiseTicketEntity")
    //        fetchRequest.predicate = NSPredicate(format: "id = %ld", 123)
    //        do
    //        {
    //            let fetchedResults =  try managedContext!.fetch(fetchRequest) as? [NSManagedObject]
    //            for entity in fetchedResults! {
    //                managedContext?.delete(entity)
    //                do {
    //                    try managedContext!.save()
    //                }
    //                catch let error as NSError  {
    //                    print("Could not save \(error), \(error.userInfo)")
    //                }
    //            }
    //        }
    //        catch _ {
    //            print("Could not delete")
    //        }
    //    }
    
    class func deleteTicket(){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"RaiseTicketEntity")
        fetchRequest.predicate = NSPredicate(format: "isSentToServer = %@",NSNumber(value: false))
        do
        {
            let fetchedResults =  try managedContext!.fetch(fetchRequest) as? [NSManagedObject]
            for entity in fetchedResults! {
                managedContext?.delete(entity)
                do {
                    try managedContext!.save()
                }
                catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
        }
        catch _ {
            print("Could not delete")
        }
    }
    
    class func requestToGetMasterData(){
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            SwiftLoader.show(animated: true)
            let urlString:String = String(format: "%@%@", arguments: [PARAMARSH_BASE_URL,PARAMARSH_MASTER_DATA])
            Alamofire.request(urlString, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                SwiftLoader.hide()
                if response.result.error == nil {
                    if let json = response.result.value {
                        //print("Response :\(json)")
                        let responseStatusCode = (json as! NSDictionary).value(forKey: "code") as! NSInteger
                        if responseStatusCode == SUCCESS_STATUS_CODE_100{
                            let hybridMasterArray = ((json as! NSDictionary).value(forKey: "data") as! NSDictionary).value(forKey: "hybridMaster") as! NSArray
                            let cropMasterArray = ((json as! NSDictionary).value(forKey: "data") as! NSDictionary).value(forKey: "cropMaster") as! NSArray
                            
                            let defaults = UserDefaults.standard
                            defaults.set(NSKeyedArchiver.archivedData(withRootObject: hybridMasterArray), forKey: "hybridMaster")
                            defaults.set(NSKeyedArchiver.archivedData(withRootObject: cropMasterArray), forKey: "cropMaster")
                            defaults.synchronize()
                        }
                    }
                }
                else{
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.makeToast((response.result.error?.localizedDescription)!, duration: 1.0, position: .center)
                    return
                }
            }
        }
        else{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
    }
}
