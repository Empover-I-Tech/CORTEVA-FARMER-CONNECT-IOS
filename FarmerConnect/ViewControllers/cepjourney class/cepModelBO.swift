//
//  cepModelBO.swift
//  FarmerConnect
//
//  Created by EMPOVER-049 on 06/08/21.
//  Copyright © 2021 ABC. All rights reserved.
//

import Foundation

@objc class CEPDashboardBO: NSObject {
    
    @objc var id: NSString?
    @objc var name: NSString?
    @objc var minimumBookingHours: NSString?
    @objc var minimumServiceHours: NSString?
    
    @objc var  cepBPHAlerts: NSString?
    @objc var  cepBuyPexalonGetCashback : NSString?
    @objc var  cepFieldPictureSharing : NSString?
    @objc var  cepPercentCompleted : NSString?
    @objc var  cepPexalonMadePossible : NSString?
    @objc var  cepProfileUpdate : NSString?
    @objc var  cepReferral : NSString?
    @objc var  farmerID : NSString?
    @objc var  farmerName : NSString?
    @objc var  profilePicUrl : NSString?
    @objc var  mdoMno : NSString?
    @objc var  retailerMno : NSString?
    
    @objc var  profileUpdate : NSString?
    @objc var  referral : NSString?
    @objc var  scanAndWin : NSString?
    @objc var  bphAlerts : NSString?
    @objc var  fieldPictureSharing : NSString?
    @objc var  rewards : NSString?
    @objc var  pexalonMadePossible : NSString?
    @objc var fieldPictureStatments : NSArray?
    
    @objc var profileUpdateVisible: NSString?
    @objc var referralVisible: NSString?
    @objc var scanAndWinVisible: NSString?
    @objc var bphAlertsVisible: NSString?
    @objc var fieldPictureSharingVisible: NSString?
    @objc var rewardsVisible: NSString?
    @objc var pexalonMadePossibleVisible: NSString?
    
    init(dict : NSDictionary){
        
        
        self.cepBPHAlerts = (Validations.checkKeyNotAvail(dict, key: "cepBPHAlerts") as? NSString) ?? ""
      
        self.mdoMno = (Validations.checkKeyNotAvail(dict, key: "mdoMno") as? NSString) ?? ""
        self.retailerMno = (Validations.checkKeyNotAvail(dict, key: "retailerMno") as? NSString) ?? ""
        
        if let idObj = dict.value(forKey: "cepBPHAlerts") as? Int {
            self.cepBPHAlerts = String(format: "%d",idObj) as NSString
        }
        self.cepFieldPictureSharing = (Validations.checkKeyNotAvail(dict, key: "cepFieldPictureSharing") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "cepFieldPictureSharing") as? Int {
            self.cepFieldPictureSharing = String(format: "%d",idObj) as NSString
        }
        
        self.cepBuyPexalonGetCashback = (Validations.checkKeyNotAvail(dict, key: "cepBuyPexalonGetCashback") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "cepBuyPexalonGetCashback") as? Int {
            self.cepBuyPexalonGetCashback = String(format: "%d",idObj) as NSString
        }
        self.fieldPictureStatments = dict.value(forKey: "fieldPictureStatments") as? NSArray ?? []
        
        self.cepPercentCompleted = (Validations.checkKeyNotAvail(dict, key: "cepPercentCompleted") as? NSString) ?? ""
        self.cepPexalonMadePossible = (Validations.checkKeyNotAvail(dict, key: "cepPexalonMadePossible") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "cepPexalonMadePossible") as? Int {
            self.cepPexalonMadePossible = String(format: "%d",idObj) as NSString
        }
        
        self.cepProfileUpdate = (Validations.checkKeyNotAvail(dict, key: "cepProfileUpdate") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "cepProfileUpdate") as? Int {
            self.cepProfileUpdate = String(format: "%d",idObj) as NSString
        }
        self.cepReferral = (Validations.checkKeyNotAvail(dict, key: "cepReferral") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "cepReferral") as? Int {
            self.cepReferral = String(format: "%d",idObj) as NSString
        }
        self.farmerID = (Validations.checkKeyNotAvail(dict, key: "farmerID") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "farmerID") as? Int {
            self.farmerID = String(format: "%d",idObj) as NSString
        }
        self.farmerName = (Validations.checkKeyNotAvail(dict, key: "farmerName") as? NSString) ?? ""
        self.profilePicUrl = (Validations.checkKeyNotAvail(dict, key: "profilePicUrl") as? NSString) ?? ""
        
        self.profileUpdate = (Validations.checkKeyNotAvail(dict, key: "profileUpdate") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "profileUpdate") as? Int {
            self.profileUpdate = String(format: "%d",idObj) as NSString
        }
        
        self.referral = (Validations.checkKeyNotAvail(dict, key: "referral") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "referral") as? Int {
            self.referral = String(format: "%d",idObj) as NSString
        }
        
        self.scanAndWin = (Validations.checkKeyNotAvail(dict, key: "scanAndWin") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "scanAndWin") as? Int {
            self.scanAndWin = String(format: "%d",idObj) as NSString
        }
        
        self.bphAlerts = (Validations.checkKeyNotAvail(dict, key: "bphAlerts") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "bphAlerts") as? Int {
            self.bphAlerts = String(format: "%d",idObj) as NSString
        }
        self.fieldPictureSharing = (Validations.checkKeyNotAvail(dict, key: "fieldPictureSharing") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "fieldPictureSharing") as? Int {
            self.fieldPictureSharing = String(format: "%d",idObj) as NSString
        }
        
        self.rewards = (Validations.checkKeyNotAvail(dict, key: "rewards") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "rewards") as? Int {
            self.rewards = String(format: "%d",idObj) as NSString
        }
        
        self.pexalonMadePossible = (Validations.checkKeyNotAvail(dict, key: "pexalonMadePossible") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "pexalonMadePossible") as? Int {
            self.pexalonMadePossible = String(format: "%d",idObj) as NSString
        }
        self.profileUpdateVisible = (Validations.checkKeyNotAvail(dict, key: "profileUpdateVisible") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "profileUpdateVisible") as? Int {
            self.profileUpdateVisible = String(format: "%d",idObj) as NSString
        }
        self.referralVisible = (Validations.checkKeyNotAvail(dict, key: "referralVisible") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "referralVisible") as? Int {
            self.referralVisible = String(format: "%d",idObj) as NSString
        }
        self.scanAndWinVisible = (Validations.checkKeyNotAvail(dict, key: "scanAndWinVisible") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "scanAndWinVisible") as? Int {
            self.scanAndWinVisible = String(format: "%d",idObj) as NSString
        }
        self.bphAlertsVisible = (Validations.checkKeyNotAvail(dict, key: "bphAlertsVisible") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "bphAlertsVisible") as? Int {
            self.bphAlertsVisible = String(format: "%d",idObj) as NSString
        }
        self.fieldPictureSharingVisible = (Validations.checkKeyNotAvail(dict, key: "fieldPictureSharingVisible") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "fieldPictureSharingVisible") as? Int {
            self.fieldPictureSharingVisible = String(format: "%d",idObj) as NSString
        }
        self.rewardsVisible = (Validations.checkKeyNotAvail(dict, key: "rewardsVisible") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "rewardsVisible") as? Int {
            self.rewardsVisible = String(format: "%d",idObj) as NSString
        }
        self.pexalonMadePossibleVisible = (Validations.checkKeyNotAvail(dict, key: "pexalonMadePossibleVisible") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "pexalonMadePossibleVisible") as? Int {
            self.pexalonMadePossibleVisible = String(format: "%d",idObj) as NSString
        }
    }
}

@objc class RHRDPDashboardBO: NSObject {
    
    @objc var id: NSString?
    @objc var name: NSString?
    @objc var minimumBookingHours: NSString?
    @objc var minimumServiceHours: NSString?
    @objc var  cepBPHAlerts: NSString?
    @objc var  rhrdGenuinityCheck : NSString?
    @objc var  genuinityCheck : NSString?
    @objc var  rhrdFieldPictureUpload : NSString?
    @objc var  rhrdPercentCompleted : NSString?
    @objc var  cepPexalonMadePossible : NSString?
    @objc var  enrolProfileUpdate : NSString?
    @objc var  referral : NSString?
    @objc var  farmerID : NSString?
    @objc var  farmerName : NSString?
    @objc var  profilePicUrl : NSString?
    @objc var  mdoMno : NSString?
    @objc var  retailerMno : NSString?
    @objc var  rhrdProfileUpdate : NSString?
    @objc var  rhrdReferral : NSString?
    @objc var  scanAndWin : NSString?
    @objc var  bphAlerts : NSString?
    @objc var  fieldPictureSharing : NSString?
    @objc var  rewards : NSString?
    @objc var  rhrdShareSuccessStory : NSString?
    @objc var fieldPictureStatments : NSArray?
    @objc var  shareSuccessStory : NSString?
    @objc var fieldPictureUpload : NSString?
    
    init(dict : NSDictionary){
        
        
        self.cepBPHAlerts = (Validations.checkKeyNotAvail(dict, key: "cepBPHAlerts") as? NSString) ?? ""
      
        self.mdoMno = (Validations.checkKeyNotAvail(dict, key: "mdoMno") as? NSString) ?? ""
        self.retailerMno = (Validations.checkKeyNotAvail(dict, key: "retailerMno") as? NSString) ?? ""
        
        if let idObj = dict.value(forKey: "cepBPHAlerts") as? Int {
            self.cepBPHAlerts = String(format: "%d",idObj) as NSString
        }
        self.fieldPictureUpload = (Validations.checkKeyNotAvail(dict, key: "fieldPictureUpload") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "fieldPictureUpload") as? Int {
            self.fieldPictureUpload = String(format: "%d",idObj) as NSString
        }
        
        self.rhrdFieldPictureUpload = (Validations.checkKeyNotAvail(dict, key: "rhrdFieldPictureUpload") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "rhrdFieldPictureUpload") as? Int {
            self.rhrdFieldPictureUpload = String(format: "%d",idObj) as NSString
        }
        
        self.rhrdGenuinityCheck = (Validations.checkKeyNotAvail(dict, key: "rhrdGenuinityCheck") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "rhrdGenuinityCheck") as? Int {
            self.rhrdGenuinityCheck = String(format: "%d",idObj) as NSString
        }
        self.fieldPictureStatments = dict.value(forKey: "fieldPictureStatments") as? NSArray ?? []
        
        self.genuinityCheck = (Validations.checkKeyNotAvail(dict, key: "genuinityCheck") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "genuinityCheck") as? Int {
            self.genuinityCheck = String(format: "%d",idObj) as NSString
        }
        self.fieldPictureStatments = dict.value(forKey: "fieldPictureStatments") as? NSArray ?? []
        
        self.rhrdPercentCompleted = (Validations.checkKeyNotAvail(dict, key: "rhrdPercentCompleted") as? NSString) ?? ""
        self.rhrdShareSuccessStory = (Validations.checkKeyNotAvail(dict, key: "rhrdShareSuccessStory") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "rhrdShareSuccessStory") as? Int {
            self.rhrdShareSuccessStory = String(format: "%d",idObj) as NSString
        }
        
        self.shareSuccessStory = (Validations.checkKeyNotAvail(dict, key: "shareSuccessStory") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "shareSuccessStory") as? Int {
            self.shareSuccessStory = String(format: "%d",idObj) as NSString
        }
        
        self.enrolProfileUpdate = (Validations.checkKeyNotAvail(dict, key: "enrolProfileUpdate") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "enrolProfileUpdate") as? Int {
            self.enrolProfileUpdate = String(format: "%d",idObj) as NSString
        }
        self.rhrdReferral = (Validations.checkKeyNotAvail(dict, key: "rhrdReferral") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "rhrdReferral") as? Int {
            self.rhrdReferral = String(format: "%d",idObj) as NSString
        }
        self.farmerID = (Validations.checkKeyNotAvail(dict, key: "farmerID") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "farmerID") as? Int {
            self.farmerID = String(format: "%d",idObj) as NSString
        }
        self.farmerName = (Validations.checkKeyNotAvail(dict, key: "farmerName") as? NSString) ?? ""
        self.profilePicUrl = (Validations.checkKeyNotAvail(dict, key: "profilePicUrl") as? NSString) ?? ""
        
        self.rhrdProfileUpdate = (Validations.checkKeyNotAvail(dict, key: "rhrdProfileUpdate") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "rhrdProfileUpdate") as? Int {
            self.rhrdProfileUpdate = String(format: "%d",idObj) as NSString
        }
        
        self.referral = (Validations.checkKeyNotAvail(dict, key: "referral") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "referral") as? Int {
            self.referral = String(format: "%d",idObj) as NSString
        }
        
        self.scanAndWin = (Validations.checkKeyNotAvail(dict, key: "scanAndWin") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "scanAndWin") as? Int {
            self.scanAndWin = String(format: "%d",idObj) as NSString
        }
        
        self.bphAlerts = (Validations.checkKeyNotAvail(dict, key: "bphAlerts") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "bphAlerts") as? Int {
            self.bphAlerts = String(format: "%d",idObj) as NSString
        }
        self.fieldPictureSharing = (Validations.checkKeyNotAvail(dict, key: "fieldPictureSharing") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "fieldPictureSharing") as? Int {
            self.fieldPictureSharing = String(format: "%d",idObj) as NSString
        }
        
        self.rewards = (Validations.checkKeyNotAvail(dict, key: "rewards") as? NSString) ?? ""
        if let idObj = dict.value(forKey: "rewards") as? Int {
            self.rewards = String(format: "%d",idObj) as NSString
        }
        
//        self.pexalonMadePossible = (Validations.checkKeyNotAvail(dict, key: "pexalonMadePossible") as? NSString) ?? ""
//        if let idObj = dict.value(forKey: "pexalonMadePossible") as? Int {
//            self.pexalonMadePossible = String(format: "%d",idObj) as NSString
//        }
    }
}

