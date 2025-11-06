//
//  GerminationList.swift
//  FarmerConnect
//
//  Created by Empover on 24/07/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit

class GerminationList: NSObject {

    @objc var year: String?
    @objc var seasonName: String?
    @objc var seasonId: String?
    @objc var cropName: String?
    @objc var cropId: String?
    @objc var status: String?
    @objc var germinationId: String?
    @objc var startDate: String?
    @objc var endDate: String?
    @objc var actual: String?
    @objc var total: String?
    @objc var target: String?
    @objc var prevYear: String?
    @objc var minimumAcres: String?
    @objc var maximumAcres: String?
    @objc var germinationText: String?
    
    init(dict : NSDictionary){
        if let yearObj = dict.value(forKey: "year") as? Int {
            self.year = String(format: "%d",yearObj)
            self.prevYear = String(format: "%d",yearObj-1)
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
        self.status = Validations.checkKeyNotAvail(dict, key: "status") as? String ?? ""
        if let germinationIdObj = dict.value(forKey: "germinationId") as? Int {
            self.germinationId = String(format: "%d",germinationIdObj)
        }
        self.startDate = Validations.checkKeyNotAvail(dict, key: "startDate") as? String ?? ""
        self.endDate = Validations.checkKeyNotAvail(dict, key: "endDate") as? String ?? ""
        if let actualObj = dict.value(forKey: "actual") as? Int {
            self.actual = String(format: "%d",actualObj)
        }
        if let totalObj = dict.value(forKey: "total") as? Int {
            self.total = String(format: "%d",totalObj)
        }
        if let targetObj = dict.value(forKey: "target") as? Int {
            self.target = String(format: "%d",targetObj)
        }
        if let minAcresObj = dict.value(forKey: "minimumAcres") as? Int {
            self.minimumAcres = String(format: "%d",minAcresObj)
        }
        if let maximumAcresObj = dict.value(forKey: "maximumAcres") as? Int {
            self.maximumAcres = String(format: "%d",maximumAcresObj)
        }
        self.germinationText = Validations.checkKeyNotAvail(dict, key: "germinationText") as? String ?? ""
    }
}
