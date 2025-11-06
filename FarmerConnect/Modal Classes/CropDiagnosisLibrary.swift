//
//  CropDiagnosisLibrary.swift
//  FarmerConnect
//
//  Created by Empover on 28/12/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit

class CropDiagnosisLibrary: NSObject {

    @objc var diseaseId: NSString?
    @objc var diseaseRequestId: NSString?
    @objc var id: NSString?
    @objc var probability: NSNumber?
    @objc var imagePath :NSString?
    @objc var diseaseScientificName: NSString?
    @objc var exactMatch: NSString?
    @objc var diseaseName :NSString?
    @objc var diseaseDate : NSString?
    @objc var diseaseTypeImgUrl : NSString?
    @objc var diseaseTypeImageCount : NSString?

    init(dict : NSDictionary){
        if let diseaseIdObj = dict.value(forKey: "diseaseId") as? Int {
            self.diseaseId = String(format: "%d",diseaseIdObj) as NSString
        }
        if let diseaseRequestIdObj = dict.value(forKey: "diseaseRequestId") as? Int {
            self.diseaseRequestId = String(format: "%d",diseaseRequestIdObj) as NSString
        }
        if let idObj = dict.value(forKey: "id") as? Int {
            self.id = String(format: "%d",idObj) as NSString
        }
        
        self.probability = dict.value(forKey: "probability") as? NSNumber
        //        if let probabilityObj = dict.value(forKey: "probability") as? NSNumber {
        //            self.probability = String(format: "%f",probabilityObj) as NSString
        //        }
        self.imagePath = (Validations.checkKeyNotAvail(dict, key: "imagePath") as?NSString)!
        self.diseaseScientificName = (Validations.checkKeyNotAvail(dict, key: "diseaseScientificName") as?NSString)!
        self.diseaseName = (Validations.checkKeyNotAvail(dict, key: "diseaseName") as?NSString)!
        if let exactMatchObj = dict.value(forKey: "exactMatch") as? Bool {
            self.exactMatch = String(exactMatchObj) as NSString
        }
        self.diseaseDate = (Validations.checkKeyNotAvail(dict, key: "diseaseDate") as?  NSString ?? "")
        self.diseaseTypeImgUrl = (Validations.checkKeyNotAvail(dict, key: "diseaseTypeImgUrl") as?  NSString ?? "")
               if let diseaseImg = dict.value(forKey: "diseaseTypeImgUrl") as? Int {
                   self.diseaseTypeImgUrl = String(format: "%d",diseaseImg) as NSString
               }
               
        self.diseaseTypeImageCount = (Validations.checkKeyNotAvail(dict, key: "diseaseTypeImageCount") as?  NSString ?? "")
               if let diseaseTypeCount = dict.value(forKey: "diseaseTypeImageCount") as? Int {
                   self.diseaseTypeImageCount = String(format: "%d",diseaseTypeCount) as NSString
               }

    }
}
