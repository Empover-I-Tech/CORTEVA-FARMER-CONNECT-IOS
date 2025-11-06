//
//  Order.swift
//  FarmerConnect
//
//  Created by Admin on 04/01/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit

class Order: NSObject {
    var equipmentId: NSString?
    var requestedUserId: NSString?
    var locationName: NSString?
    @objc var fromDate: NSString?
    @objc var bookedDate: NSString?
    var startTime: NSString?
    var endTime: NSString?
    var equipmentTransactionId: NSString?
    var cancellationPolicyURL : NSString?
    var isBooked: Bool?
    var latitude: NSString?
    var longitude: NSString?
    var noOfHours: NSString?
    var toDate: NSString?
    var multipleProviderCheck: Bool?
    var multipleProviderPrice: NSString?
    var multipleProviderDistance: NSString?
    var contact: NSString?
    var pricePerHour: NSString?
    var priceBeforeCounterRequest: NSString?
    var eligibleForCounterRequest: NSString?
    var contactNo : NSString?
    var distance : NSString?
    var equipImage : NSString?
    var fromLocation : NSString?
    var toLocation : NSString?
    var model : NSString?
    var rating : NSString?
    var imageView : NSString?
    var requestBy : NSString?
    var providedBy : NSString?
    var secondaryStatus : NSString?
    var status : NSString?
    var totalPrice : NSString?
    var requestedEndTimeBeforeCounterRequest : NSString?
    var requestedForDateBeforeCounterRequest : NSString?
    var requestedStartTimeBeforeCounterRequest : NSString?
    var requestedToDateBeforeCounterRequest : NSString?
    //var totalPrice : NSString?

    var singleDaySelected: Bool?
    
    init(dict : NSDictionary){
        if let equipId = Validations.checkKeyNotAvail(dict, key: "equipmentId") as? Int64{
            self.equipmentId = NSString(format: "%d", equipId)
        }
        if let price = Validations.checkKeyNotAvail(dict, key: "pricePerHour") as? Int64{
            self.pricePerHour = NSString(format: "%d", price)
        }
        if let counterRequest = Validations.checkKeyNotAvail(dict, key: "eligibleForCounterRequest") as? Int64{
            self.eligibleForCounterRequest = NSString(format: "%d", counterRequest)
        }
        if let dist = Validations.checkKeyNotAvail(dict, key: "distance") as? Int64{
            self.distance = NSString(format: "%d", dist)
        }
        if let noOfHrs = Validations.checkKeyNotAvail(dict, key: "noOfHours") as? Int64{
            self.noOfHours = NSString(format: "%d", noOfHrs)
        }
        if let pricePer = Validations.checkKeyNotAvail(dict, key: "pricePerHour") as? Int64{
            self.pricePerHour = NSString(format: "%d", pricePer)
        }
        if let prevPricePer = Validations.checkKeyNotAvail(dict, key: "priceBeforeCounterRequest") as? Int64{
            self.priceBeforeCounterRequest = NSString(format: "%d", prevPricePer)
        }

        if let totalPric = Validations.checkKeyNotAvail(dict, key: "totalPrice") as? Int64{
            self.totalPrice = NSString(format: "%d", totalPric)
        }
        if let transactionId = Validations.checkKeyNotAvail(dict, key: "equipmentTransactionId") as? Int64{
            self.equipmentTransactionId = NSString(format: "%d", transactionId)
        }
        self.status = (Validations.checkKeyNotAvail(dict, key: "status") as?NSString)!
        self.secondaryStatus = (Validations.checkKeyNotAvail(dict, key: "secondaryStatus") as?NSString)!
        self.bookedDate = (Validations.checkKeyNotAvail(dict, key: "bookedDate") as?NSString)!
        if Validations.isNullString(self.distance ?? "") == true{
            self.distance = (Validations.checkKeyNotAvail(dict, key: "distance") as?NSString)!
        }
        self.equipImage = (Validations.checkKeyNotAvail(dict, key: "equipImage") as?NSString)!
        self.fromLocation = (Validations.checkKeyNotAvail(dict, key: "from") as?NSString)!
        self.imageView = (Validations.checkKeyNotAvail(dict, key: "imageView") as?NSString)!
        self.model = (Validations.checkKeyNotAvail(dict, key: "model") as?NSString)!
        self.toLocation = (Validations.checkKeyNotAvail(dict, key: "to") as?NSString)!
        self.contactNo = (Validations.checkKeyNotAvail(dict, key: "contact") as?NSString)!
        self.cancellationPolicyURL = (Validations.checkKeyNotAvail(dict, key: "cancellationPolicyURL") as?NSString)!
        self.startTime = (Validations.checkKeyNotAvail(dict, key: "startTime") as?NSString)!
        self.fromDate = (Validations.checkKeyNotAvail(dict, key: "bookedFromDate") as?NSString)!
        self.toDate = (Validations.checkKeyNotAvail(dict, key: "bookedToDate") as?NSString)!
        self.endTime = (Validations.checkKeyNotAvail(dict, key: "endTime") as?NSString)!
        self.isBooked = (Validations.checkKeyNotAvail(dict, key: "isBooked") as?Bool ?? false)!
        self.multipleProviderCheck = (Validations.checkKeyNotAvail(dict, key: "multipleProviderCheck") as?Bool ?? false)!
        self.singleDaySelected = (Validations.checkKeyNotAvail(dict, key: "singleDaySelected") as?Bool ?? false)!
        self.multipleProviderPrice = (Validations.checkKeyNotAvail(dict, key: "multipleProviderPrice") as?NSString)!
        self.multipleProviderDistance = (Validations.checkKeyNotAvail(dict, key: "multipleProviderDistance") as?NSString)!
        self.requestedUserId = (Validations.checkKeyNotAvail(dict, key: "requestedUserId") as?NSString)!
        self.requestBy = (Validations.checkKeyNotAvail(dict, key: "requestBy") as?NSString)!
        self.providedBy = (Validations.checkKeyNotAvail(dict, key: "providedBy") as?NSString)!
        self.rating = (Validations.checkKeyNotAvail(dict, key: "rating") as? NSString ?? "")
        self.requestedToDateBeforeCounterRequest = (Validations.checkKeyNotAvail(dict, key: "requestedToDateBeforeCounterRequest") as? NSString ?? "")
        self.requestedForDateBeforeCounterRequest = (Validations.checkKeyNotAvail(dict, key: "requestedForDateBeforeCounterRequest") as? NSString ?? "")
        self.requestedStartTimeBeforeCounterRequest = (Validations.checkKeyNotAvail(dict, key: "requestedStartTimeBeforeCounterRequest") as? NSString ?? "")
        self.requestedEndTimeBeforeCounterRequest = (Validations.checkKeyNotAvail(dict, key: "requestedEndTimeBeforeCounterRequest") as? NSString ?? "")
        if let rate = Validations.checkKeyNotAvail(dict, key: "rating") as? Float{
            self.rating = NSString(format: "%.1f", rate)
        }
        if let equipLat = Validations.checkKeyNotAvail(dict, key: "requesterLatitude") as? NSString{
            self.latitude = equipLat
        }
        if let equipLat = Validations.checkKeyNotAvail(dict, key: "requesterLatitude") as? Double{
            self.latitude = NSString(format: "%f", equipLat)
        }
        if let equipLong = Validations.checkKeyNotAvail(dict, key: "requesterLongitude") as? NSString{
            self.longitude = equipLong
        }
        if let equipLong = Validations.checkKeyNotAvail(dict, key: "requesterLongitude") as? Double{
            self.longitude = NSString(format: "%f", equipLong)
        }
        if let equipLat = Validations.checkKeyNotAvail(dict, key: "providerLatitude") as? Float{
            self.latitude = NSString(format: "%f", equipLat)
        }
        if let equipLat = Validations.checkKeyNotAvail(dict, key: "providerLatitude") as? Double{
            self.latitude = NSString(format: "%f", equipLat)
        }
        if let equipLong = Validations.checkKeyNotAvail(dict, key: "providerLongitude") as? Float{
            self.longitude = NSString(format: "%f", equipLong)
        }
        if let equipLong = Validations.checkKeyNotAvail(dict, key: "providerLongitude") as? Double{
            self.longitude = NSString(format: "%f", equipLong)
        }
        if let singleDayReq = Validations.checkKeyNotAvail(dict, key: "singleDayRequest") as? Bool{
            self.singleDaySelected = singleDayReq
        }
        self.locationName = (Validations.checkKeyNotAvail(dict, key: "locationName") as?NSString)!
    }
}
