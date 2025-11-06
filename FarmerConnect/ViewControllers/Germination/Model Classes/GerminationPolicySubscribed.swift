//
//  GerminationPolicySubscribed.swift
//  PioneerEmployee
//
//  Created by Empover on 09/08/18.
//  Copyright © 2018 Empover. All rights reserved.
//

import UIKit

class GerminationPolicySubscribed: NSObject {
    @objc var year: String? //also used for claim
    @objc var seasonName: String? //also used for claim
    @objc var seasonId: String? //also used for claim
    @objc var cropName: String? //also used for claim
    @objc var cropId: String? //also used for claim
    @objc var germinationFarmerDataId: String?
    @objc var startDate: String?
    @objc var farmerMobileNumber: String? //also used for claim
    @objc var totalAcres: String?
    @objc var targetAcres: String?
    @objc var name: String? //also used for claim
    @objc var pincode: String? //also used for claim
    @objc var area: String?
    @objc var district: String?
    @objc var mandal: String?
    @objc var state: String?
    @objc var territory: String?
    @objc var region: String?
    @objc var cu: String?
    
    //params for claim
    @objc var dateOfSowing: String?
    @objc var germinationClaimTransactionId: String?
    @objc var germinationFailedAcres: String?
    @objc var status: String?
    
    init(dict : NSDictionary){
        if let yearObj = dict.value(forKey: "year") as? Int {
            self.year = String(format: "%d",yearObj)
        }
        else{
            self.year = Validations.checkKeyNotAvail(dict, key: "year") as? String ?? ""
        }
        self.seasonName = Validations.checkKeyNotAvail(dict, key: "seasonName") as? String ?? ""
        if let seasonIdObj = dict.value(forKey: "seasonId") as? Int {
            self.seasonId = String(format: "%d",seasonIdObj)
        }
        self.cropName = Validations.checkKeyNotAvail(dict, key: "cropName") as? String ?? ""
        if let cropIdObj = dict.value(forKey: "cropId") as? Int {
            self.cropId = String(format: "%d",cropIdObj)
        }
        if let germinationIdObj = dict.value(forKey: "germinationFarmerDataId") as? Int {
            self.germinationFarmerDataId = String(format: "%d",germinationIdObj)
        }
        self.startDate = Validations.checkKeyNotAvail(dict, key: "startDate") as? String ?? ""
        self.farmerMobileNumber = Validations.checkKeyNotAvail(dict, key: "farmerMobileNumber") as? String ?? ""
        if let totalObj = dict.value(forKey: "totalAcres") as? Float {
            self.totalAcres = String(format: "%.1f",totalObj)
        }
        if let targetObj = dict.value(forKey: "targetAcres") as? Float {
            self.targetAcres = String(format: "%.1f",targetObj)
        }
        self.name = Validations.checkKeyNotAvail(dict, key: "name") as? String ?? ""
        self.pincode = Validations.checkKeyNotAvail(dict, key: "pincode") as? String ?? ""
        self.area = Validations.checkKeyNotAvail(dict, key: "area") as? String ?? ""
        self.district = Validations.checkKeyNotAvail(dict, key: "district") as? String ?? ""
        self.mandal = Validations.checkKeyNotAvail(dict, key: "mandal") as? String ?? ""
        self.state = Validations.checkKeyNotAvail(dict, key: "state") as? String ?? ""
        self.territory = Validations.checkKeyNotAvail(dict, key: "territory") as? String ?? ""
        self.region = Validations.checkKeyNotAvail(dict, key: "region") as? String ?? ""
        self.cu = Validations.checkKeyNotAvail(dict, key: "cu") as? String ?? ""
        
        //claim
        self.dateOfSowing = Validations.checkKeyNotAvail(dict, key: "dateOfSowing") as? String ?? ""
        self.germinationClaimTransactionId = Validations.checkKeyNotAvail(dict, key: "germinationClaimTransactionId") as? String ?? ""
        if let germinationFailedAcresObj = dict.value(forKey: "germinationFailedAcres") as? Float {
            self.germinationFailedAcres = String(format: "%.1f",germinationFailedAcresObj)
        }
        else{
            self.germinationFailedAcres = Validations.checkKeyNotAvail(dict, key: "germinationFailedAcres") as? String ?? ""
        }
        self.status = Validations.checkKeyNotAvail(dict, key: "status") as? String ?? ""
    }
}
