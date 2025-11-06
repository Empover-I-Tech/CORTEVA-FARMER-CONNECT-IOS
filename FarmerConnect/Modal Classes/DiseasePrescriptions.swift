//
//  DiseasePrescriptions.swift
//  FarmerConnect
//
//  Created by Empover on 28/12/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit

class DiseasePrescriptions: NSObject {

    @objc var preventiveMeasures: NSString?
    @objc var productMapping: NSString?
    @objc var symptoms: NSString?
    @objc var active: NSString?
    @objc var biologicalControl: NSString?
    @objc var hazadDescription: NSString?
    @objc var createdOn: NSString?
    @objc var status: NSString?
    @objc var diseaseName: NSString?
    @objc var deleted: NSString?
    @objc var updatedOn: NSString?
    @objc var inANutshell: NSString?
    @objc var crop: NSString?
    @objc var diseaseBiologicalName: NSString?
    @objc var chemicalControl: NSString?
    @objc var productMappingImage: NSString?
    @objc var id: NSString?
    @objc var diseaseImageFile: NSString?
    @objc var diseaseId: NSString?
    @objc var diseaseType: NSString?
    @objc var hosts: NSString?
    @objc var trigger: NSString?
    
    init(dict : NSDictionary){
        self.preventiveMeasures = (Validations.checkKeyNotAvail(dict, key: "preventiveMeasures") as?NSString)!
        self.productMapping = (Validations.checkKeyNotAvail(dict, key: "productMapping") as?NSString)!
        self.symptoms = (Validations.checkKeyNotAvail(dict, key: "symptoms") as?NSString)!
        if let active = dict.value(forKey: "active") as? Bool {
            self.active = String(active) as NSString
        }
        self.biologicalControl = (Validations.checkKeyNotAvail(dict, key: "biologicalControl") as?NSString)!
        self.hazadDescription = (Validations.checkKeyNotAvail(dict, key: "hazadDescription") as?NSString)!
        self.createdOn = (Validations.checkKeyNotAvail(dict, key: "createdOn") as?NSString)!
        self.status = (Validations.checkKeyNotAvail(dict, key: "status") as?NSString)!
        self.diseaseName = (Validations.checkKeyNotAvail(dict, key: "diseaseName") as?NSString)!
        if let deletedObj = dict.value(forKey: "deleted") as? Bool {
            self.deleted = String(deletedObj) as NSString
        }
        self.updatedOn = (Validations.checkKeyNotAvail(dict, key: "updatedOn") as?NSString)!
        self.inANutshell = (Validations.checkKeyNotAvail(dict, key: "inANutshell") as?NSString)!
        self.crop = (Validations.checkKeyNotAvail(dict, key: "crop") as?NSString)!
        self.diseaseBiologicalName = (Validations.checkKeyNotAvail(dict, key: "diseaseBiologicalName") as?NSString)!
        self.chemicalControl = (Validations.checkKeyNotAvail(dict, key: "chemicalControl") as?NSString)!
        self.productMappingImage = (Validations.checkKeyNotAvail(dict, key: "productMappingImage") as?NSString)!
        if let idObj = dict.value(forKey: "id") as? Int {
            self.id = String(format: "%d",idObj) as NSString
        }
        self.diseaseImageFile = (Validations.checkKeyNotAvail(dict, key: "diseaseImageFile") as?NSString)!
        if let diseaseIdObj = dict.value(forKey: "diseaseId") as? Int {
            self.diseaseId = String(format: "%d",diseaseIdObj) as NSString
        }
        self.diseaseType = (Validations.checkKeyNotAvail(dict, key: "diseaseType") as?NSString)!
        self.hosts = (Validations.checkKeyNotAvail(dict, key: "hosts") as?NSString)!
        self.trigger = (Validations.checkKeyNotAvail(dict, key: "trigger") as?NSString)!
    }
}
