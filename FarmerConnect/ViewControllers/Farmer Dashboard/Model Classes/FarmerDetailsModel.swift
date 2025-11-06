//
//  FarmerDetailsModel.swift
//  PioneerEmployee
//
//  Created by Admin on 13/08/19.
//  Copyright © 2019 Empover. All rights reserved.
//

import UIKit

class FarmerDetailsCompleteModel: NSObject {
    var arrFarmerConnect : NSMutableArray = NSMutableArray()
    var arrActivityParticipation : NSMutableArray = NSMutableArray()
    var arrOtherActivities : NSMutableArray = NSMutableArray()
    var arrParamarsh  : NSMutableArray = NSMutableArray()
    var otherActivitiesCount : NSString?
    var arrBoughtProducts : NSMutableArray = NSMutableArray()
    
     init(dict : NSDictionary) {
        if let userIds = dict.value(forKey: "count") as? Int {
            self.otherActivitiesCount = String(format: "%d",userIds) as NSString
        }

        self.otherActivitiesCount = (Validations.checkKeyNotAvail(dict, key: "count") as?  NSString ?? "")

        if dict.value(forKey: "farmerConnect") != nil {
            if let arrFarmerConnects = dict.value(forKey: "farmerConnect") as? NSArray {
                
                arrFarmerConnect.removeAllObjects()
                
                for i in 0...arrFarmerConnects.count-1{
                    let fCModel = FarmerConnectModel(dict: arrFarmerConnects[i] as? NSDictionary ?? NSDictionary())
                    self.arrFarmerConnect.add(fCModel)
                }
            }
        }
        
        if dict.value(forKey: "activityParticipation") != nil {
            if let arrActivityParticipations = dict.value(forKey: "activityParticipation") as? NSArray {
                
                self.arrActivityParticipation.removeAllObjects()
                if arrActivityParticipations.count > 0{
                    
                    for i in 0...arrActivityParticipations.count-1{
                        let dic = arrActivityParticipations.object(at: i)
                        let typeStr = (dic as AnyObject).value(forKey: "type") as? NSString ?? ""
                        let activitiesArrayType = (dic as AnyObject).value(forKey: "activities") as? NSArray ?? []
                        for j in 0..<activitiesArrayType.count{
                            // particpationArray.addObjects(from: [activitiesArrayType.object(at: j)])
                            
                            let dic  =  activitiesArrayType.object(at: j) as? NSDictionary ?? [:]
                            
                            let dicnat : NSDictionary = ["name": (dic as AnyObject).value(forKey: "name") as? String ?? "",
                                                         "imagePath" : (dic as AnyObject).value(forKey: "imagePath") as? String ?? "" ,
                                                         "count" : (dic as AnyObject).value(forKey: "count") as? String ?? "",
                                                         "type" : typeStr]
                            
                            let FDboObj : FarmerActivityParticipationModel = FarmerActivityParticipationModel(dict:dicnat )
                            self.arrActivityParticipation.addObjects(from: [FDboObj])
                        }
                    }
                }
            }
        }
        
        if dict.value(forKey: "otherActivities") != nil {
            if let arrOtherActivities1 = dict.value(forKey: "otherActivities") as? NSArray {
                
                self.arrOtherActivities.removeAllObjects()
                if arrOtherActivities1.count  > 0 {
                    
                    for i in 0...arrOtherActivities1.count-1{
                        let fCModel = FarmerOtherActivitiesModel(dict: arrOtherActivities1[i] as? NSDictionary ?? NSDictionary())
                        self.arrOtherActivities.add(fCModel)
                    }
                }
            }
        }
        
        if dict.value(forKey: "boughtProducts") != nil{
            if let arrBoughtProds = dict.value(forKey: "boughtProducts") as? NSArray {
                if arrBoughtProds.count > 0 {
                    self.arrBoughtProducts.removeAllObjects()
                    for i in 0...arrBoughtProds.count-1 {
                        let fCModel = FarmerConnectModel(dict: arrBoughtProds[i] as? NSDictionary ?? NSDictionary())
                        self.arrBoughtProducts.add(fCModel)
                    }
                }
            }
        }
        if dict.value(forKey: "paramarsh") != nil {
            if let arrParamarshs = dict.value(forKey: "paramarsh") as? NSArray {
                if arrParamarshs.count > 0 {
                    self.arrParamarsh.removeAllObjects()
                    
                    for i in 0...arrParamarshs.count-1{
                        let fCModel = FarmerParamarshModel(dict: arrParamarshs[i] as? NSDictionary ?? NSDictionary())
                        self.arrParamarsh.add(fCModel)
                    }
                }
            }
        }

    }
}
class FarmerConnectModel: NSObject {
    var imagePath : NSString?
    var title : NSString?
    var count : NSString?
    var arrSubInfo : NSMutableArray = NSMutableArray()
    var collapsed : Bool = true
    
    init(dict : NSDictionary) {

        self.imagePath = (Validations.checkKeyNotAvail(dict, key: "imagePath") as?  NSString ?? "")
       
        self.title = (Validations.checkKeyNotAvail(dict, key: "title") as?  NSString ?? "")
       
        if let userIds = dict.value(forKey: "count") as? Int {
            self.count = String(format: "%d",userIds) as NSString
        }
       
        self.count = (Validations.checkKeyNotAvail(dict, key: "count") as?  NSString ?? "")
        
        if dict.value(forKey: "subInfo") != nil {
            if let arrSubInfos = dict.value(forKey: "subInfo") as? NSArray {
              
                arrSubInfo.removeAllObjects()
                if arrSubInfos.count > 0 {
                    for i in 0...arrSubInfos.count-1{
                        let fCModel = FarmerConnectSubInfoModel(dict: arrSubInfos[i] as? NSDictionary ?? NSDictionary())
                        self.arrSubInfo.add(fCModel)
                    }
                }
            }
        }

    }

}
class FarmerConnectSubInfoModel : NSObject {
    var crop : NSString?
    var product : NSString?
    var quantity : NSString?
    var hybrid : NSString?
    var acres : NSString?
    var season : NSString?
    var date : NSString?
    var underCrop : NSString?
    var disease : NSString?
    var id : NSString?
    var lblId : NSString?

    init(dict : NSDictionary) {
        self.crop = (Validations.checkKeyNotAvail(dict, key: "lblCrop") as?  NSString ?? "")
        
        self.product = (Validations.checkKeyNotAvail(dict, key: "product") as?  NSString ?? "")
        
        if let userIds = dict.value(forKey: "lblQuantity") as? Int {
            self.quantity = String(format: "%d",userIds) as NSString
        }

        self.quantity = (Validations.checkKeyNotAvail(dict, key: "lblQuantity") as?  NSString ?? "")
        
        self.hybrid = (Validations.checkKeyNotAvail(dict, key: "lblHybrid") as?  NSString ?? "")
        
        if let userIds = dict.value(forKey: "lblAcres") as? Int {
            self.acres = String(format: "%d",userIds) as NSString
        }

        self.acres = (Validations.checkKeyNotAvail(dict, key: "lblAcres") as?  NSString ?? "")
        
        self.season = (Validations.checkKeyNotAvail(dict, key: "lblSeason") as?  NSString ?? "")
       
        self.date = (Validations.checkKeyNotAvail(dict, key: "lblDate") as?  NSString ?? "")
        
        self.underCrop = (Validations.checkKeyNotAvail(dict, key: "lblUnderCrop") as?  NSString ?? "")
       
        self.disease = (Validations.checkKeyNotAvail(dict, key: "lblDisease") as?  NSString ?? "")
      
        if let userIds = dict.value(forKey: "id") as? Int {
            self.id = String(format: "%d",userIds) as NSString
        }
        self.id = (Validations.checkKeyNotAvail(dict, key: "id") as?  NSString ?? "")
//lblId
        self.lblId = (Validations.checkKeyNotAvail(dict, key: "lblId") as?  NSString ?? "")

    }

}
class FarmerActivityParticipationModel: NSObject {
    var type : NSString?
    var arrActivites : NSMutableArray = NSMutableArray()
    var imagePath : NSString?
    var name : NSString?
    var count : NSString?
    
    init(dict : NSDictionary) {
        self.type = (Validations.checkKeyNotAvail(dict, key: "type") as?  NSString ?? "")
        self.imagePath = (Validations.checkKeyNotAvail(dict, key: "imagePath") as?  NSString ?? "")
        self.name = (Validations.checkKeyNotAvail(dict, key: "name") as?  NSString ?? "")
      
        if let userIds = dict.value(forKey: "count") as? Int {
            self.count = String(format: "%d",userIds) as NSString
        }
        self.count = (Validations.checkKeyNotAvail(dict, key: "count") as?  NSString ?? "")
    }
}

class FarmerActivityParticipationSubModel : NSObject {
    var imagePath : NSString?
    var name : NSString?
    var count : NSString?

    init(dict : NSDictionary) {
        
        self.imagePath = (Validations.checkKeyNotAvail(dict, key: "imagePath") as?  NSString ?? "")
        
        self.name = (Validations.checkKeyNotAvail(dict, key: "name") as?  NSString ?? "")
        
        if let userIds = dict.value(forKey: "count") as? Int {
            self.count = String(format: "%d",userIds) as NSString
        }
        
        self.count = (Validations.checkKeyNotAvail(dict, key: "count") as?  NSString ?? "")

    }

}
class FarmerOtherActivitiesModel: NSObject {
    var imagePath : NSString?
    var name : NSString?
    var count : NSString?
    var flag : Bool?
 
    init(dict : NSDictionary) {
        self.imagePath = (Validations.checkKeyNotAvail(dict, key: "imagePath") as?  NSString ?? "")
        
        self.name = (Validations.checkKeyNotAvail(dict, key: "name") as?  NSString ?? "")
        
        if let userIds = dict.value(forKey: "count") as? Int {
            self.count = String(format: "%d",userIds) as NSString
        }
        
        self.count = (Validations.checkKeyNotAvail(dict, key: "count") as?  NSString ?? "")

        if dict.value(forKey: "flag") != nil {
            self.flag = dict.value(forKey: "flag") as? Bool
        }
    }
}

class FarmerParamarshModel: NSObject {
    var pendingIssues : NSString?
    var lastIssueDate : NSString?
    var resolvedBy : NSString?
    var status : NSString?
    var closedIssues : NSString?
    var hybrid : NSString?
    var crop : NSString?
    
    init(dict : NSDictionary) {
        
        if let userIds = dict.value(forKey: "pendingIssues") as? Int {
            self.pendingIssues = String(format: "%d",userIds) as NSString
        }

        self.pendingIssues = (Validations.checkKeyNotAvail(dict, key: "pendingIssues") as?  NSString ?? "")

        self.lastIssueDate = (Validations.checkKeyNotAvail(dict, key: "lastIssueDate") as?  NSString ?? "")

        self.resolvedBy = (Validations.checkKeyNotAvail(dict, key: "resolvedby") as?  NSString ?? "")
        self.status = (Validations.checkKeyNotAvail(dict, key: "status") as?  NSString ?? "")
        self.closedIssues = (Validations.checkKeyNotAvail(dict, key: "closedIssues") as? NSString ?? "")
        self.hybrid = (Validations.checkKeyNotAvail(dict, key: "hybrid") as? NSString ?? "")
        self.crop = (Validations.checkKeyNotAvail(dict, key: "crop") as? NSString ?? "")

    }

}
