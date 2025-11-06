//
//  Classifications.swift
//  FarmerConnect
//
//  Created by Empover on 26/12/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit

@objc class Classifications: NSObject {

     @objc var id: NSString?
     @objc var name: NSString?
     @objc var minimumBookingHours: NSString?
     @objc var minimumServiceHours: NSString?
    
    init(dict : NSDictionary){
        if let idObj = dict.value(forKey: "id") as? Int {
            self.id = String(format: "%d",idObj) as NSString
        }
        if let minimumBookingHoursObj = dict.value(forKey: "minimumBookingHours") as? Int {
            self.minimumBookingHours = String(format: "%d",minimumBookingHoursObj) as NSString
        }
        self.name = (Validations.checkKeyNotAvail(dict, key: "name") as?NSString)!
        if let minimumServiceHoursObj = dict.value(forKey: "minimumServiceHours") as? Int {
            self.minimumServiceHours = String(format: "%d",minimumServiceHoursObj) as NSString
        }
    }
}
