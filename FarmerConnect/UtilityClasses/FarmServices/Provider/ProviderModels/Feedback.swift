//
//  Feedback.swift
//  FarmerConnect
//
//  Created by Admin on 09/01/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit

class Feedback: NSObject {

    @objc var bookedDate: NSString?
    var equipmentTransactionId: NSString?
    var fromLocation : NSString?
    var toLocation : NSString?
    var equipImage : NSString?
    var message : NSString?
    var rating : NSString?
    var questionIds : NSString?
    var equipmentId : NSString?

    init(dict : NSDictionary){

        if let rate = Validations.checkKeyNotAvail(dict, key: "rating") as? Float{
            self.rating = NSString(format: "%.1f", rate)
        }
        if let transactionId = Validations.checkKeyNotAvail(dict, key: "equipmentTransactionId") as? Int64{
            self.equipmentTransactionId = NSString(format: "%d", transactionId)
        }
        if let equipId = Validations.checkKeyNotAvail(dict, key: "equipmentId") as? Int64{
            self.equipmentId = NSString(format: "%d", equipId)
        }
        self.bookedDate = (Validations.checkKeyNotAvail(dict, key: "date") as?NSString)!
        self.equipImage = (Validations.checkKeyNotAvail(dict, key: "image") as?NSString)!
        self.fromLocation = (Validations.checkKeyNotAvail(dict, key: "from") as?NSString)!
        self.toLocation = (Validations.checkKeyNotAvail(dict, key: "to") as?NSString)!
    }
}
