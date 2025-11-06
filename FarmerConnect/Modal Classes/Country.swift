//
//  CountriesListEntity.swift
//  PioneerFarmerConnect
//
//  Created by Empover on 18/12/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import UIKit

@objc class Country: NSObject {

   @objc var countryCode: NSString?
   @objc var countryName: NSString?
   @objc var countryId: NSString?
   @objc var active :NSString?
    
      init(dict : NSDictionary){
        if let idObj = dict.value(forKey: "id") as? Int {
            self.countryId = String(format: "%d",idObj) as NSString
        }
        self.countryName = (Validations.checkKeyNotAvail(dict, key: "countryName") as?NSString)!
        self.countryCode = (Validations.checkKeyNotAvail(dict, key: "countryCode") as?NSString)!
        if let activeObj = dict.value(forKey: "active") as? Bool {
            self.active = String(activeObj) as NSString
        }
    }
}

@objc class Language: NSObject {

   @objc var languageCode: NSString?
   @objc var languageName: NSString?
   @objc var languageId: NSString?
   @objc var defaultLang :NSString?
    
      init(dict : NSDictionary){
         /* if let idObj = dict.value(forKey: "languageId") as? String{
            self.languageId = String(format: "%d",idObj) as NSString
        }*/
        self.languageId = dict.value(forKey: "languageId") as? NSString
        self.languageName = (Validations.checkKeyNotAvail(dict, key: "languageName") as?NSString)!
        self.languageCode = (Validations.checkKeyNotAvail(dict, key: "languageCode") as?NSString)!
        if let defaultObj = dict.value(forKey: "defaultLanguage") as? Bool {
            self.defaultLang = String(defaultObj) as NSString
        }
    }
}
