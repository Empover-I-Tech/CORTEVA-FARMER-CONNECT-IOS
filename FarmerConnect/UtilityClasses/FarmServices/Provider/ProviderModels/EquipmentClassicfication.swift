//
//  EquipmentClassicfication.swift
//  FarmerConnect
//
//  Created by Admin on 20/12/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit

class EquipmentClassicfication: NSObject {

    @objc var classificationId : NSString?
    @objc var minimumServiceHours : NSString?
    @objc var name : NSString?

    init(dict : NSDictionary){
        if let equipId = Validations.checkKeyNotAvail(dict, key: "id") as? Int64{
            self.classificationId = NSString(format: "%d", equipId)
        }
        if let serviceHours = Validations.checkKeyNotAvail(dict, key: "minimumServiceHours") as? Int64{
            self.minimumServiceHours = NSString(format: "%d", serviceHours)
        }
        //self.minimumServiceHours = (Validations.checkKeyNotAvail(dict, key: "minimumServiceHours") as?NSString)!
        self.name = (Validations.checkKeyNotAvail(dict, key: "name") as?NSString)!
    }
}
