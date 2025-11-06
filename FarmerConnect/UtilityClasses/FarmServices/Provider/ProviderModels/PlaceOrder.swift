//
//  PlaceOrder.swift
//  FarmerConnect
//
//  Created by Admin on 04/01/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit

class PlaceOrder: NSObject {
    var equipmentId: NSString?
    var requestedUserId: NSString?
    var locationName: NSString?
    @objc var fromDate: NSString?
    var startTime: NSString?
    var endTime: NSString?
    var equipmentTransactionId: NSString?
    //var equipmentAvailabilityId : NSString?
    var isBooked: Bool?
    var latitude: NSString?
    var longitude: NSString?
    var noOfHoursRequired: NSString?
    var toDate: NSString?
    var multipleProviderCheck: Bool?
    var multipleProviderPrice: NSString?
    var multipleProviderDistance: NSString?
    var pricePerHour: NSString?
    var distance: NSString?
    var counterRequest: Bool?
    var singleDaySelected: Bool?

    init(dict : NSDictionary){
        if let equipId = Validations.checkKeyNotAvail(dict, key: "equipmentId") as? Int64{
            self.equipmentId = NSString(format: "%d", equipId)
        }
        if let price = Validations.checkKeyNotAvail(dict, key: "pricePerHour") as? Int64{
            self.pricePerHour = NSString(format: "%d", price)
        }
        self.startTime = (Validations.checkKeyNotAvail(dict, key: "startTime") as?NSString)!
        self.fromDate = (Validations.checkKeyNotAvail(dict, key: "date") as?NSString)!
        self.endTime = (Validations.checkKeyNotAvail(dict, key: "endTime") as?NSString)!
        self.isBooked = (Validations.checkKeyNotAvail(dict, key: "isBooked") as?Bool ?? false)!
        self.multipleProviderCheck = (Validations.checkKeyNotAvail(dict, key: "multipleProviderCheck") as?Bool ?? false)!
        self.counterRequest = (Validations.checkKeyNotAvail(dict, key: "counterRequest") as?Bool ?? false)!
        self.singleDaySelected = (Validations.checkKeyNotAvail(dict, key: "singleDaySelected") as?Bool ?? false)!
        self.multipleProviderPrice = (Validations.checkKeyNotAvail(dict, key: "multipleProviderPrice") as?NSString)!
        self.multipleProviderDistance = (Validations.checkKeyNotAvail(dict, key: "multipleProviderDistance") as?NSString)!
        self.noOfHoursRequired = (Validations.checkKeyNotAvail(dict, key: "noOfHoursRequired") as?NSString)!
        self.equipmentTransactionId = (Validations.checkKeyNotAvail(dict, key: "equipmentTransactionId") as?NSString)!
        self.requestedUserId = (Validations.checkKeyNotAvail(dict, key: "requestedUserId") as?NSString)!

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
    }
}
