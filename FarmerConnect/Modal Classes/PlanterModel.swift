//
//  PlanterModel.swift
//  FarmerConnect
//
//  Created by Empover i-Tech on 28/03/23.
//  Copyright © 2023 ABC. All rights reserved.
//

import Foundation
import UIKit

class PlanterModel: NSObject {
    
    var   id: String = ""
    var   farmerName: String = ""
    var   mobileNumber: String = ""
    var   noOfAcres: String = ""
    var   requestorCrop: String = ""
    var   requestorAddress : String = ""
    var   latitude : String = ""
    var   longitude: String = ""
    var   vendorName: String = ""
    var   vendorMobileNumber: String = ""
    var   vendorAddress: String = ""
    var   companyName: String = ""
    var   equipmentCapacity : String = ""
    var   modelNo : String = ""
    var   equipmentWeight : String = ""
    var   companyNumber : String = ""
    var   companyAddress : String = ""
    var   equipmentimgUrl : String = ""
    var recordStatus : String = ""
    
    var   requestorDateTime : String = ""
    var   billPhoto : String = ""
    var   retailerName : String = ""
    var   retailerMNO : String = ""
    var   retailerAddress : String = ""
    var   retailerPincode : String = ""
    var   billingUploadDateTime : String = ""
    
    var   minimumServiceHours : String = ""
    var   equipmentDescription : String = ""
    var   performance : String = ""
    var sprayRequestId : String = ""
    var recordIDEquipment: String = ""
 
    init(array : NSDictionary) {
        
       
         self.id = String(describing: array["id"] ?? "")
         self.sprayRequestId = String(describing: array["sprayRequestId"] ?? "")
         self.requestorDateTime = String(describing: array["dateTime"] ?? "")
         self.recordStatus = String(describing: array["recordStatus"] ?? "")
        self.minimumServiceHours = String(describing: array["minimumHours"] ?? "")
        self.equipmentDescription = String(describing: array["description"] ?? "")
        self.performance = String(describing: array["performance"] ?? "")
        
        
        self.farmerName = String(describing: array["farmerName"] ?? "")
        self.mobileNumber = String(describing: array["mobileNumber"] ?? "")
        self.noOfAcres = String(describing: array["noOfAcres"] ?? "")
        self.requestorCrop = String(describing: array["crop"] ?? "")
        self.requestorAddress = String(describing: array["address"] ?? "")
        
        self.latitude = String(describing: array["latitude"] ?? "")
        self.longitude = String(describing: array["longitude"] ?? "")
        self.vendorName = String(describing: array["vendorName"] ?? "")
        self.vendorMobileNumber = String(describing: array["vendorMobileNumber"] ?? "")
        self.vendorAddress = String(describing: array["vendorAddress"] ?? "")
        self.companyName = String(describing: array["companyName"] ?? "")
        self.equipmentCapacity = String(describing: array["datecapacityTime"] ?? "")
        self.modelNo = String(describing: array["modelNo"] ?? "")
        self.equipmentWeight = String(describing: array["weight"] ?? "") 
        self.companyNumber = String(describing: array["companyNumber"] ?? "")
        self.companyAddress = String(describing: array["companyAddress"] ?? "")
        self.equipmentimgUrl = String(describing: array["equipmentimgUrl"] ?? "")
        if self.noOfAcres == ""{
            self.noOfAcres =  String(format:"%i",array["noOfAcres"] as? Int ?? 0)
        }
        if self.id == ""{
           self.id =  String(format:"%i",array["id"] as? Int ?? 0)
        }
        if self.sprayRequestId == ""{
           self.sprayRequestId =  String(format:"%i",array["sprayRequestId"] as? Int ?? 0)
        }
        
        if  self.minimumServiceHours == ""{
            self.minimumServiceHours =  String(format:"%i",array["minimumHours"] as? Int ?? 0)
        }
        self.billPhoto = String(describing: array["billPhoto"] ?? "")
        self.retailerName = String(describing: array["retailerName"] ?? "")
        self.retailerAddress = String(describing: array["retailerAddress"] ?? "")
        self.retailerPincode = String(describing: array["retailerPincode"] ?? "")
        self.retailerMNO = String(describing: array["retailerMNO"] ?? "")
        self.billingUploadDateTime = String(describing: array["billingUploadDateTime"] ?? "")
        
        if  self.retailerPincode != ""{
             self.retailerAddress =  self.retailerAddress + "," +  self.retailerPincode
        }
        self.recordIDEquipment = String(describing: array["id"] ?? "")
        if self.recordIDEquipment == ""{
           self.recordIDEquipment =  String(format:"%i",array["id"] as? Int ?? 0)
        }
       
        
    }
    
}
