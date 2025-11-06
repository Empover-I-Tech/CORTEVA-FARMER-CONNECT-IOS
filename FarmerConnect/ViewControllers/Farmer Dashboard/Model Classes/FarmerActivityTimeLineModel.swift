//
//  FarmerActivityTimeLineModel.swift
//  PioneerEmployee
//
//  Created by Admin on 26/08/19.
//  Copyright © 2019 Empover. All rights reserved.
//

import UIKit

class FarmerActivityTimeLineModel: NSObject {
    var activityMonth : String?
    var arrActivities : NSMutableArray = NSMutableArray()
    
    init(dict : NSDictionary) {
        self.activityMonth = (Validations.checkKeyNotAvail(dict, key: "month") as? String)
       
        if dict.value(forKey: "activities") != nil {
            if let arrOtherActivities1 = dict.value(forKey: "activities") as? NSArray {
                
                self.arrActivities.removeAllObjects()
                if arrOtherActivities1.count > 0 {
                    
                    for i in 0...arrOtherActivities1.count-1{
                        let fCModel = FarmerActivitiesModel(dict: arrOtherActivities1[i] as? NSDictionary ?? NSDictionary())
                        self.arrActivities.add(fCModel)
                    }
                }
            }
        }
    }
}

class FarmerActivitiesModel : NSObject {
    var activityImage : String?
    var arrActivityInfo : NSMutableArray = NSMutableArray()
    var activityType : String?
    var activityName : String?
    var activityDate : String?
    
    init(dict : NSDictionary) {
        self.activityImage = (Validations.checkKeyNotAvail(dict, key: "activityImage") as? String)
        self.activityType = (Validations.checkKeyNotAvail(dict, key: "activityType") as? String)
        self.activityName = (Validations.checkKeyNotAvail(dict, key: "activityName") as? String)
        self.activityDate = (Validations.checkKeyNotAvail(dict, key: "activityDate") as? String)
        
        if dict.value(forKey: "activityInfo") != nil {
            if let arrOtherActivities1 = dict.value(forKey: "activityInfo") as? NSArray {
                
                self.arrActivityInfo.removeAllObjects()
                if arrOtherActivities1.count > 0 {
                    for i in 0...arrOtherActivities1.count-1{
                        let fCModel = FarmerInternalActivitesInMonth(dict: arrOtherActivities1[i] as? NSDictionary ?? NSDictionary())
                        self.arrActivityInfo.add(fCModel)
                    }
                }
            }
        }
    }
}

class FarmerInternalActivitesInMonth : NSObject{
    var activitylblAcres : String?
    var activitylblCrop : String?
    var activitylblHybrid : String?
    var activitylblProduct : String?
    var activitylblSeason : String?
    var activitylblUnderCrop : String?
    var activitylblDate : String?
    var activityId : String?
    var activitylblQuantity : String?
    var activityHybrid : String?
    var activityCrop : String?
    var activityLastIssuedDate : String?
    var activityResolvedBy : String?
    
    init(dict : NSDictionary) {
        self.activitylblAcres = (Validations.checkKeyNotAvail(dict, key: "lblAcres") as? String)
        self.activitylblCrop = (Validations.checkKeyNotAvail(dict, key: "lblCrop") as? String)
        self.activitylblHybrid = (Validations.checkKeyNotAvail(dict, key: "lblHybrid") as? String)
        self.activitylblProduct = (Validations.checkKeyNotAvail(dict, key: "lblProduct") as? String)
        self.activitylblSeason = (Validations.checkKeyNotAvail(dict, key: "lblSeason") as? String)
        self.activitylblUnderCrop = (Validations.checkKeyNotAvail(dict, key: "lblUnderCrop") as? String)
        self.activitylblDate =  (Validations.checkKeyNotAvail(dict, key: "lblDate") as? String)
        self.activityId =  (Validations.checkKeyNotAvail(dict, key: "lblId") as? String)
        self.activitylblQuantity =  (Validations.checkKeyNotAvail(dict, key: "lblId") as? String)

        self.activityHybrid = (Validations.checkKeyNotAvail(dict, key: "hybrid") as? String)
        self.activityCrop =  (Validations.checkKeyNotAvail(dict, key: "crop") as? String)
        self.activityLastIssuedDate =  (Validations.checkKeyNotAvail(dict, key: "lastIssueDate") as? String)
        self.activityResolvedBy =  (Validations.checkKeyNotAvail(dict, key: "resolvedby") as? String)

    }
}
