//
//  Equipment.swift
//  FarmerConnect
//
//  Created by Admin on 20/12/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit

class Equipment: NSObject {
   @objc var customerId : NSString?
    @objc var ownerId : NSString?
    var latitude: NSString?
    var longitude: NSString?
    @objc var classification: NSString?
    @objc var equipmentClassification: NSString?
    //var equipmentClassificationId: NSString?

    var model: NSString?
    var performance: NSString?
    var vehicleYear: NSString?
    var pricePerHour: NSString?
    var serviceAreaDistance: NSString?
    var maxSerAreaDistProvided : NSString?
    var pickAndDrop: NSString?
    var withDriver: NSString?
    @objc var image_url: NSString?
    var image: NSString?
    var equipImage: NSString?
    @objc var iconImage: NSString?
    var equipmentId: NSString?
    
    var minimumServiceHours: NSString?
    var equipmentDescription: NSString?
    var equipmentDescription2: NSString?
    var equipmentVehicleNumber: NSString?
    var locationName: NSString?
    var deletedImages: NSString?
    var fromDate: NSString?
    var startDate: NSString?
    var endDate: NSString?
    var toDate: NSString?
    var toTime: NSString?
    var fromTime: NSString?
    var maker: NSString?
    var status: NSString?
    var rating: NSString?
    var reason : NSString?
    var isEnabled : Bool?
    var isBlocked : Bool?

    var equipmentLatitude: NSString?
    var equipmentLongitude: NSString?
    var equipmentLocationName: NSString?
    var cancelationPolicyUrl: NSString?
    var availableDates : NSString?
    var fullyAvailableDates : NSString?
    var availableTimings : NSString?
    var requestedDates: NSString?
    var arrImageUrls = NSMutableArray()
    // added for spray services
    var  equipmentClassificationId : NSString?
    var  billUploadDone : Bool?
    var  sprayRequestDone : Bool?
    

    init(dict : NSDictionary){
        self.ownerId = (Validations.checkKeyNotAvail(dict, key: "ownerId") as?NSString)!
        if let ownerId = Validations.checkKeyNotAvail(dict, key: "ownerId") as? Int64{
            self.ownerId = NSString(format: "%d", ownerId)
        }
        if let customerId = Validations.checkKeyNotAvail(dict, key: "customerId") as? Int64{
            self.customerId = NSString(format: "%d", customerId)
        }
        if let equipId = Validations.checkKeyNotAvail(dict, key: "equipmentId") as? Int64{
            self.equipmentId = NSString(format: "%d", equipId)
        }
        if let equipClassificationId = Validations.checkKeyNotAvail(dict, key: "equipmentClassificationId") as? Int64{
                   self.equipmentClassificationId = NSString(format: "%d", equipClassificationId)
               }
        self.billUploadDone = (Validations.checkKeyNotAvail(dict, key: "billUploadDone") as? Bool) ?? false
        self.sprayRequestDone = (Validations.checkKeyNotAvail(dict, key: "sprayRequestDone") as? Bool) ?? false
        
        if let serviceDistance = Validations.checkKeyNotAvail(dict, key: "distance") as? Int64{
            self.serviceAreaDistance = NSString(format: "%d", serviceDistance)
        }
        if Validations.isNullString(self.serviceAreaDistance ?? "") == true {
            if let serviceDistance = Validations.checkKeyNotAvail(dict, key: "serviceAreaDistance") as? Int64{
                self.serviceAreaDistance = NSString(format: "%d", serviceDistance)
            }
        }
        if let maxServiceDistance = Validations.checkKeyNotAvail(dict, key: "maxSerAreaDistProvided") as? Int64{
            self.maxSerAreaDistProvided = NSString(format: "%d", maxServiceDistance)
        }
        self.image = (Validations.checkKeyNotAvail(dict, key: "image") as?NSString)!
        self.equipImage = (Validations.checkKeyNotAvail(dict, key: "equipImage") as?NSString)!
        self.iconImage = (Validations.checkKeyNotAvail(dict, key: "iconImage") as?NSString)!
        self.classification = (Validations.checkKeyNotAvail(dict, key: "classification") as?NSString)!
        self.equipmentClassification = (Validations.checkKeyNotAvail(dict, key: "equipmentClassification") as?NSString)!
        self.image_url = (Validations.checkKeyNotAvail(dict, key: "imageUrl") as?NSString)!
        self.status = (Validations.checkKeyNotAvail(dict, key: "status") as?NSString)!
        self.isEnabled = (Validations.checkKeyNotAvail(dict, key: "isEnabled") as? Bool) ?? false
        self.isBlocked = (Validations.checkKeyNotAvail(dict, key: "isBlocked") as? Bool) ?? true
        self.availableDates = (Validations.checkKeyNotAvail(dict, key: "availableDates") as?NSString)!
        if Validations.isNullString(self.availableDates ?? "") == true{
            self.availableDates = (Validations.checkKeyNotAvail(dict, key: "availabelDates") as?NSString)!
        }
        self.fullyAvailableDates = (Validations.checkKeyNotAvail(dict, key: "fullyAvailableDates") as?NSString)!
        self.requestedDates = (Validations.checkKeyNotAvail(dict, key: "requestedDates") as?NSString)!
        self.availableTimings = (Validations.checkKeyNotAvail(dict, key: "availableTimings") as?NSString)!
        self.fromDate = (Validations.checkKeyNotAvail(dict, key: "fromDate") as?NSString)!
        self.startDate = (Validations.checkKeyNotAvail(dict, key: "startDate") as?NSString)!
        self.endDate = (Validations.checkKeyNotAvail(dict, key: "endDate") as?NSString)!
        self.toDate = (Validations.checkKeyNotAvail(dict, key: "toDate") as?NSString)!

        self.equipmentDescription2 = (Validations.checkKeyNotAvail(dict, key: "description") as?NSString)!
        self.cancelationPolicyUrl = (Validations.checkKeyNotAvail(dict, key: "cancellationPolicyURL") as?NSString)!
        self.equipmentDescription = (Validations.checkKeyNotAvail(dict, key: "equipmentDescription") as?NSString)!
        self.reason = (Validations.checkKeyNotAvail(dict, key: "reason") as? NSString ?? "")

        if let equipLat = Validations.checkKeyNotAvail(dict, key: "equipmentLatitude") as? Float{
            self.equipmentLatitude = NSString(format: "%f", equipLat)
        }
        if let equipLat = Validations.checkKeyNotAvail(dict, key: "equipmentLatitude") as? Double{
            self.equipmentLatitude = NSString(format: "%f", equipLat)
        }
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
        if let equipLat = Validations.checkKeyNotAvail(dict, key: "equipmentLatitude") as? NSString{
            self.equipmentLatitude = equipLat
        }
        if let equipLong = Validations.checkKeyNotAvail(dict, key: "equipmentLongitude") as? NSString{
            self.equipmentLongitude = equipLong
        }
        if let equipLong = Validations.checkKeyNotAvail(dict, key: "equipmentLongitude") as? Float{
            self.equipmentLongitude = NSString(format: "%f", equipLong)
        }
        if let equipLong = Validations.checkKeyNotAvail(dict, key: "equipmentLongitude") as? Double{
            self.equipmentLongitude = NSString(format: "%f", equipLong)
        }
        self.equipmentLocationName = (Validations.checkKeyNotAvail(dict, key: "equipmentLocationName") as?NSString)!
        self.locationName = (Validations.checkKeyNotAvail(dict, key: "locationName") as?NSString)!
        let imageUrls = Validations.checkKeyNotAvailForArray(dict, key: "imageUrls") as? NSArray
        if imageUrls != nil {
            if imageUrls!.count > 0{
                self.arrImageUrls.addObjects(from: imageUrls! as! [Any])
            }
        }
        self.maker = (Validations.checkKeyNotAvail(dict, key: "maker") as?NSString)!
        self.model = (Validations.checkKeyNotAvail(dict, key: "model") as?NSString)!
        self.performance = (Validations.checkKeyNotAvail(dict, key: "performance") as?NSString)!
        self.rating = (Validations.checkKeyNotAvail(dict, key: "rating") as? NSString ?? "0")!
        if let serAreaDistProvided = Validations.checkKeyNotAvail(dict, key: "maxSerAreaDistProvided") as? Int64{
            self.maxSerAreaDistProvided = NSString(format: "%d", serAreaDistProvided)
        }
        if let minServiceHours = Validations.checkKeyNotAvail(dict, key: "minimumServiceHours") as? Int64{
            self.minimumServiceHours = NSString(format: "%d", minServiceHours)
        }
        if let perform = Validations.checkKeyNotAvail(dict, key: "performance") as? Float{
            self.performance = NSString(format: "%d", perform)
        }
        if let pickUpAndDrop = dict.value(forKey: "pickUpAndDrop") as? Int64{
            print(pickUpAndDrop)
        }
        if let driver = dict.value(forKey: "withDriver") as? Int64{
            print(driver)
        }
        if let rate = Validations.checkKeyNotAvail(dict, key: "rating") as? Int64{
            self.rating = NSString(format: "%d", rate)
        }
        if let priceHourly = Validations.checkKeyNotAvail(dict, key: "pricePerHour") as? Int64{
            self.pricePerHour = NSString(format: "%d", priceHourly)
        }
        self.equipmentVehicleNumber = (Validations.checkKeyNotAvail(dict, key: "vehicleNumber") as?NSString)!
        if let year = Validations.checkKeyNotAvail(dict, key: "vehicleYear") as? Int64{
            self.vehicleYear = NSString(format: "%d", year)
        }
        self.pickAndDrop = (Validations.checkKeyNotAvail(dict, key: "pickUpAndDrop") as?NSString)!
        self.withDriver = (Validations.checkKeyNotAvail(dict, key: "withDriver") as?NSString)!

    }
}
