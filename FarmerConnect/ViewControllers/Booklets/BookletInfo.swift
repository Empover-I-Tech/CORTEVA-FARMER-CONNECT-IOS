//
//  BookletInfo.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 30/04/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import UIKit

class BookletInfo: NSObject {
    
    var cropId: String?
    var mediaUrl: String?
    var year: String?
    var seasonId: String?
    var mediaServerRecordId : String?
    var season : String?
    var mediaType : String?
    var updatedOn: String?
    var createdOn: String?
    var mediaName: String?
    var crop: String?
    var status: String?

       init(dict : NSDictionary){
           self.cropId = (Validations.checkKeyNotAvail(dict, key: "cropId") as? String)
           if let cId = Validations.checkKeyNotAvail(dict, key: "cropId") as? Int64{
               self.cropId = String(format: "%d", cId)
           }
           if let serverRecordId = Validations.checkKeyNotAvail(dict, key: "mediaServerRecordId") as? Int64{
               self.mediaServerRecordId = String(format: "%d", serverRecordId)
           }
           
        
           self.mediaUrl = (Validations.checkKeyNotAvail(dict, key: "mediaUrl") as? String)
           self.year = (Validations.checkKeyNotAvail(dict, key: "year") as? String)
           self.seasonId = (Validations.checkKeyNotAvail(dict, key: "seasonId") as? String)
           self.season = (Validations.checkKeyNotAvail(dict, key: "season") as? String)
           self.mediaType = (Validations.checkKeyNotAvail(dict, key: "mediaType") as? String)
           self.updatedOn = (Validations.checkKeyNotAvail(dict, key: "updatedOn") as? String)
           self.status = (Validations.checkKeyNotAvail(dict, key: "status") as? String)
           self.mediaName = (Validations.checkKeyNotAvail(dict, key: "mediaName") as? String)
           self.crop = (Validations.checkKeyNotAvail(dict, key: "crop") as? String)
           self.createdOn = (Validations.checkKeyNotAvail(dict, key: "createdOn") as? String)

       }
}
