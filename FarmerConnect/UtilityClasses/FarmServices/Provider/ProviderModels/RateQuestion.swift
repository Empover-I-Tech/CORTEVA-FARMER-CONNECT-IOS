//
//  RateQuestion.swift
//  FarmerConnect
//
//  Created by Admin on 09/01/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit

class RateQuestion: NSObject {
    @objc var question: NSString?
    @objc var questionId: NSString?
    @objc var isSelected : Bool = false
     var active : Bool?
    var rating : NSString?
    //var toLocation : NSString?
    //var equipImage : NSString?
    
    
    init(dict : NSDictionary){
        if let questionId = Validations.checkKeyNotAvail(dict, key: "id") as? Int64{
            self.questionId = NSString(format: "%d", questionId)
        }
        if let rate = Validations.checkKeyNotAvail(dict, key: "rating") as? Int64{
            self.rating = NSString(format: "%d", rate)
        }
        if let active = Validations.checkKeyNotAvail(dict, key: "active") as? Bool{
            self.active = active
        }
        self.question = (Validations.checkKeyNotAvail(dict, key: "question") as?NSString)!
        self.isSelected = false
    }
}
