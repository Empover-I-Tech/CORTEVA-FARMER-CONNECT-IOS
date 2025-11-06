//
//  NewsEntityDetails.swift
//  FarmerConnect
//
//  Created by Empover on 08/05/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import UIKit

class NewsEntityDetails: NSObject {
  
    @objc var newsType : NSString?
    @objc var heading1 : NSString?
    @objc var heading2 : NSString?
    @objc var heading3 : NSString?
    @objc var newsDescription : NSString?
    @objc var imagePath : NSString?
    @objc var createdOn : NSString?
    
    init(dict : NSDictionary){
        
        self.newsType = (Validations.checkKeyNotAvail(dict, key: "newsType") as? NSString)!
        self.heading1 = (Validations.checkKeyNotAvail(dict, key: "heading1") as? NSString)!
        self.heading2 = (Validations.checkKeyNotAvail(dict, key: "heading2") as? NSString)!
        self.heading3 = (Validations.checkKeyNotAvail(dict, key: "heading3") as? NSString)!
        self.newsDescription = (Validations.checkKeyNotAvail(dict, key: "description") as? NSString)!
        self.imagePath = (Validations.checkKeyNotAvail(dict, key: "imagePath") as? NSString)!
        self.createdOn = (Validations.checkKeyNotAvail(dict, key: "createdOn") as? NSString)!
        
    }

}
