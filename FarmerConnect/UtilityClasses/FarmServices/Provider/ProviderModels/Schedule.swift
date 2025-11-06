//
//  Schedule.swift
//  FarmerConnect
//
//  Created by Admin on 22/12/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit

class Schedule: NSObject {

    var locationName: NSString?
    var fromTime: NSString?
    var pricePerHour: NSString?
    @objc var date: NSString?
    var toTime: NSString?
    var equipmentAvailabilityId : NSString?
    var isBooked: Bool?
    var latitude: NSString?
    var longitude: NSString?
    var minimumServiceHours: NSString?
    var availableDate: Date?

    init(dict : NSDictionary){
        if let equipId = Validations.checkKeyNotAvail(dict, key: "equipmentAvailabilityId") as? Int64{
            self.equipmentAvailabilityId = NSString(format: "%d", equipId)
        }
        if let price = Validations.checkKeyNotAvail(dict, key: "pricePerHour") as? Int64{
            self.pricePerHour = NSString(format: "%d", price)
        }
        self.fromTime = (Validations.checkKeyNotAvail(dict, key: "fromTime") as?NSString)!
        self.date = (Validations.checkKeyNotAvail(dict, key: "date") as?NSString)!
        self.toTime = (Validations.checkKeyNotAvail(dict, key: "toTime") as?NSString)!
        self.isBooked = (Validations.checkKeyNotAvail(dict, key: "isBooked") as?Bool ?? false)!
        if let equipLat = Validations.checkKeyNotAvail(dict, key: "latitude") as? Float{
            self.latitude = NSString(format: "%f", equipLat)
        }
        if let equipLat = Validations.checkKeyNotAvail(dict, key: "latitude") as? Double{
            self.latitude = NSString(format: "%f", equipLat)
        }
        if let equipLong = Validations.checkKeyNotAvail(dict, key: "longitude") as? Float{
            self.longitude = NSString(format: "%f", equipLong)
        }
        if let equipLong = Validations.checkKeyNotAvail(dict, key: "longitude") as? Double{
            self.longitude = NSString(format: "%f", equipLong)
        }
        self.locationName = (Validations.checkKeyNotAvail(dict, key: "locationName") as?NSString)!
        if let availDate = FarmServicesConstants.getDateFromDateString(dateStr: self.date as String!) {
            self.availableDate = availDate as Date
        }
    }
}
