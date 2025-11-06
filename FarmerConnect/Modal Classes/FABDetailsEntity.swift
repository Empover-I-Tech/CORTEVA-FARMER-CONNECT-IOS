//
//  FABDetailsEntity.swift
//  PioneerEmployee
//
//  Created by Empover on 02/10/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import UIKit

@objc class FABDetailsEntity: NSObject {

    @objc var mainDescription: NSString
    @objc var cropId: NSString
    @objc var crop: NSString
    @objc var stateId: NSString
    @objc var state: NSString
    @objc var seasonId: NSString
    @objc var season: NSString
    @objc var hybrid: NSString
    @objc var hybridId: NSString
    @objc var id: NSString
    @objc var version: NSString
    @objc var fabDataArray: NSArray
    
    init(dict : NSDictionary){
        self.mainDescription = (Validations.checkKeyNotAvail(dict, key: "mainDescription") as?NSString)!
        self.cropId = (Validations.checkKeyNotAvail(dict, key: "cropId") as?NSString)!
        self.crop = (Validations.checkKeyNotAvail(dict, key: "crop") as?NSString)!
        self.stateId = (Validations.checkKeyNotAvail(dict, key: "stateId") as?NSString)!
        self.state = (Validations.checkKeyNotAvail(dict, key: "state") as?NSString)!
        self.seasonId = (Validations.checkKeyNotAvail(dict, key: "seasonId") as?NSString)!
        self.season = (Validations.checkKeyNotAvail(dict, key: "season") as?NSString)!
        self.hybrid = (Validations.checkKeyNotAvail(dict, key: "hybrid") as?NSString)!
        self.hybridId = (Validations.checkKeyNotAvail(dict, key: "hybridId") as?NSString)!
        self.id = (Validations.checkKeyNotAvail(dict, key: "id") as?NSString)!
        self.version = (Validations.checkKeyNotAvail(dict, key: "version") as?NSString)!
        self.fabDataArray = (Validations.checkKeyNotAvailForArray(dict, key: "fabDataArray") as?NSArray)!
    }
}
