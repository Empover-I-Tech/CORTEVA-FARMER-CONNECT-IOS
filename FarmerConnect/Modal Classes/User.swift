//
//  User.swift
//  PioneerFarmerConnect
//
//  Created by Empover on 19/12/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import UIKit

@objc class User: NSObject,NSCoding {
    @objc var countryCode: NSString?
    @objc var customerId: NSString?
    @objc var deviceId: NSString?
    @objc var emailId: NSString?
    @objc var aadhaarNumber: NSString?
    @objc var active :NSString?
    @objc var mobileNumber :NSString?
    @objc var showCropDiagnosis :NSString?
    @objc var showGermination :NSString?
    @objc var deviceToken :NSString = ""
    @objc var countryId: NSString?
    @objc var cartCount: NSString?
    @objc var crop: NSString?
    @objc var customerTypeId: NSString?
    @objc var customerTypeName: NSString?
    @objc var districtName: NSString?
    @objc var firstName: NSString?
    @objc var lastName: NSString?
    @objc var pincode: NSString?
    @objc var regionName: NSString?
    @objc var stateName: NSString?
    @objc var userAuthorizationToken: NSString?
    @objc var totalCropAcress: NSString?
    @objc var villageLocation: NSString?
    @objc var corn: NSString?
    @objc var rice: NSString?
    @objc var mustard: NSString?
    @objc var millet: NSString?
    @objc var irrigations: NSString?
    @objc var companies: NSString?
    @objc var seasons: NSString?
    @objc var latitude: NSString?
    @objc var longitude: NSString?
    @objc var countryName: NSString?
    @objc var geolocation: NSString?
    @objc var arrSeasons: NSArray?
    @objc var arrIrrigations: NSArray?
    @objc var arrCompanies: NSArray?
    @objc var deviceType: NSString = "iOS"
    @objc var arrSelectedCropsList : NSMutableArray?
    @objc var soyabean : NSString?
    @objc var cotton : NSString?
    @objc var subIrrigationTypes : NSString?
    @objc var arrSubIrrigations : NSArray?
    @objc var companiesId: NSString?
    //@objc var mobileNumber :NSString?
    @objc var showRewardsScheme : NSString?
    @objc var rglPurchaseOrder : NSString?
    @objc var pravaktaMyBooklets : NSString?
    @objc var  cepJourney :  NSString?
    @objc var  rhrdJourney :  NSString?
    @objc var optInWhatsApp : NSString?
     @objc var sprayVendor : NSString?
     @objc var enableSprayService : NSString?
    @objc var pravakta  : NSString?
    @objc var subscribedSprayServices  : NSString?
    @objc var deepLinkingString: NSString?
    @objc var enableShopScanWin: NSString?
    @objc var enableGenuinityCheckresults: NSString?
    @objc var riceAcres: NSString?
    @objc var imagePath: NSString?
    
    @objc var yieldPaddy: NSString?
    @objc var pexalonKharifSeason: NSString?
    @objc var retailerMno: NSString?
    @objc var mdoMno: NSString?
    
    @objc var knowDelegateAbout: NSString?
    @objc var useDelegate: NSString?
    @objc var chillyAcres: NSString?
   
    //dynamic dashboard icons
    @objc var hybridSeeds: NSString?
    @objc var cropProtection: NSString?
    @objc var genuinityCheck: NSString?
    @objc var nearBy: NSString?
    @objc var pravaktaFeedback: NSString?
    @objc var cropAdvisory: NSString?
    @objc var farmServices: NSString?
    @objc var mandiPrices: NSString?
    @objc var cropCalculator: NSString?
    @objc var farmerDashboard: NSString?
    @objc var rewards: NSString?
    @objc var referFarmer: NSString?
    @objc var weatherReport: NSString?
    @objc var paramarsh: NSString?
    @objc var notification: NSString?
    @objc var offersBtn: NSString?
    
    @objc var delegateDostDhamaka: NSString?
    
    @objc var userLogsGenuinityPrint: NSString?
    @objc var userLogsAllPrint: NSString?
    @objc var planterServicesVendor: NSString?
    @objc var planterServices: NSString?
    
    init(dict : NSDictionary){
        self.arrSelectedCropsList = NSMutableArray ()
        
        self.countryCode = (Validations.checkKeyNotAvail(dict, key: "countryCode") as?NSString)!
        self.customerId = (Validations.checkKeyNotAvail(dict, key: "customerId") as?NSString)!
        self.countryId = (Validations.checkKeyNotAvail(dict, key: "countryId") as?NSString)!
        self.deviceId = (Validations.checkKeyNotAvail(dict, key: "deviceId") as?NSString)!
        self.emailId = (Validations.checkKeyNotAvail(dict, key: "emailId") as?NSString)!
        self.aadhaarNumber = (Validations.checkKeyNotAvail(dict, key: "aadhaarNumber") as?NSString)!
        self.mobileNumber = (Validations.checkKeyNotAvail(dict, key: "mobileNumber") as?NSString)!
        self.crop = (Validations.checkKeyNotAvail(dict, key: "crop") as?NSString)!
        self.cartCount = (Validations.checkKeyNotAvail(dict, key: "cartCount") as?NSString)!
        self.customerTypeId = (Validations.checkKeyNotAvail(dict, key: "customerTypeId") as?NSString)!
        self.customerTypeName = (Validations.checkKeyNotAvail(dict, key: "customerTypeName") as?NSString)!
        self.districtName = (Validations.checkKeyNotAvail(dict, key: "districtName") as?NSString)!
        self.firstName = (Validations.checkKeyNotAvail(dict, key: "firstName") as?NSString)!
        self.lastName = (Validations.checkKeyNotAvail(dict, key: "lastName") as?NSString)!
        self.pincode = (Validations.checkKeyNotAvail(dict, key: "pincode") as?NSString)!
        self.regionName = (Validations.checkKeyNotAvail(dict, key: "regionName") as?NSString)!
        self.stateName = (Validations.checkKeyNotAvail(dict, key: "stateName") as?NSString)!
        self.userAuthorizationToken = (Validations.checkKeyNotAvail(dict, key: "userAuthorizationToken") as?NSString)!
        self.deviceType = (Validations.checkKeyNotAvail(dict, key: "deviceType") as?NSString)!
        self.cartCount = (Validations.checkKeyNotAvail(dict, key: "cartCount") as?NSString)!
        self.companies = (Validations.checkKeyNotAvail(dict, key: "company") as?NSString)!
        self.corn = (Validations.checkKeyNotAvail(dict, key: "cornCropAcres") as?NSString)!
        self.countryName = (Validations.checkKeyNotAvail(dict, key: "countryName") as?NSString)!
        self.geolocation = (Validations.checkKeyNotAvail(dict, key: "geolocation") as?NSString)!
        self.irrigations = (Validations.checkKeyNotAvail(dict, key: "irrigation") as?NSString)!
        self.millet = (Validations.checkKeyNotAvail(dict, key: "milletCropAcres") as?NSString)!
        self.mustard = (Validations.checkKeyNotAvail(dict, key: "mustardCropAcres") as?NSString)!
        self.rice = (Validations.checkKeyNotAvail(dict, key: "riceCropAcres") as?NSString)!
        self.seasons = (Validations.checkKeyNotAvail(dict, key: "season") as?NSString)!
        self.totalCropAcress = (Validations.checkKeyNotAvail(dict, key: "totalCropAcres") as?NSString)!
        self.riceAcres = (Validations.checkKeyNotAvail(dict, key: "riceAcres") as?NSString)!
        self.imagePath = (Validations.checkKeyNotAvail(dict, key: "imagePath") as?NSString)!
        self.yieldPaddy = (Validations.checkKeyNotAvail(dict, key: "yieldPaddy") as?NSString)!
        self.pexalonKharifSeason = (Validations.checkKeyNotAvail(dict, key: "pexalonKharifSeason") as?NSString)!
        self.retailerMno = (Validations.checkKeyNotAvail(dict, key: "retailerMno") as?NSString)!
        self.mdoMno = (Validations.checkKeyNotAvail(dict, key: "mdoMno") as?NSString)!
     
        self.knowDelegateAbout = (Validations.checkKeyNotAvail(dict, key: "knowDelegateAbout") as? NSString) ?? ""
        self.useDelegate = (Validations.checkKeyNotAvail(dict, key: "useDelegate") as? NSString) ?? ""
        self.chillyAcres = (Validations.checkKeyNotAvail(dict, key: "chillyAcres") as? NSString) ?? ""
      
        
        self.villageLocation = (Validations.checkKeyNotAvail(dict, key: "villageLocation") as?NSString)!
        self.soyabean = (Validations.checkKeyNotAvail(dict, key: "soyabeanCropAcres") as?NSString)!
        self.cotton = (Validations.checkKeyNotAvail(dict, key: "cottonCropAcres") as?NSString)!
        self.subIrrigationTypes = (Validations.checkKeyNotAvail(dict, key: "subIrrigationTypes") as? NSString)!
        self.companiesId = (Validations.checkKeyNotAvail(dict, key: "companyIds") as? NSString)!
        self.deepLinkingString = (Validations.checkKeyNotAvail(dict, key: "myReferShortenUrl") as? NSString)!
//      self.optInWhatsApp = (Validations.checkKeyNotAvail(dict, key: "optInWhatsApp") as? optInWhatsApp)?

//      if  Validations.checkKeyNotAvail(dict, key: "cropsList") as?Bool ?? false {
        if  dict.value(forKey: "cropsList") != nil{
            for dicts  in ((dict.value(forKey: "cropsList") as? NSArray)!){
                let cropDict = dicts as? NSDictionary
                let name = (Validations.checkKeyNotAvail(cropDict!, key: "name") as?NSString)!
                if name.length > 0 {
                    arrSelectedCropsList?.add(name)
                }
            }
        }
        if let optInWhatsAppObj = dict.value(forKey: "optInWhatsApp") as? Bool {
            self.optInWhatsApp = String(optInWhatsAppObj) as NSString
        }
        if let userLogsAllPrintObj = dict.value(forKey: "userLogsAllPrint") as? Bool {
            self.userLogsAllPrint = String(userLogsAllPrintObj) as NSString
        }
        if let userLogsGenuinityPrintObj = dict.value(forKey: "userLogsGenuinityPrint") as? Bool {
            self.userLogsGenuinityPrint = String(userLogsGenuinityPrintObj) as NSString
        }
           
        
        if dict.value(forKey: "userMenuControl") != nil{
            if let diction = dict.value(forKey: "userMenuControl") as? NSDictionary {
                if let showObj = diction.value(forKey: "rewardsSchemeAvailable") as? Bool {
                    self.showRewardsScheme = String(showObj) as NSString
                }
            }
        }
        
        
        if dict.value(forKey: "userMenuControl") != nil{
                   if let diction = dict.value(forKey: "userMenuControl") as? NSDictionary {
                       if let showObj = diction.value(forKey: "pravaktaMyBooklets") as? Bool {
                           self.pravaktaMyBooklets = String(showObj) as NSString
                       }
                   }
               }
        
        
        if dict.value(forKey: "userMenuControl") != nil{
            if let diction = dict.value(forKey: "userMenuControl") as? NSDictionary {
                if let showObj = diction.value(forKey: "shopScanWinProg") as? Bool {
                    self.enableShopScanWin = String(showObj) as NSString
                }
            }
        }
        if dict.value(forKey: "userMenuControl") != nil{
            if let diction = dict.value(forKey: "userMenuControl") as? NSDictionary {
                if let showObj = diction.value(forKey: "genunityReport") as? Bool {
                    self.enableGenuinityCheckresults = String(showObj) as NSString
                }
            }
        }
        
        if dict.value(forKey: "userMenuControl") != nil{
            if let diction = dict.value(forKey: "userMenuControl") as? NSDictionary {
                if let showObj = diction.value(forKey: "buy") as? Bool {
                    self.rglPurchaseOrder = String(showObj) as NSString
                }
            }
        }
        
        if dict.value(forKey: "userMenuControl") != nil{
                     if let diction = dict.value(forKey: "userMenuControl") as? NSDictionary {
                         if let showObj = diction.value(forKey: "enableSprayService") as? Bool {
                             self.enableSprayService = String(showObj) as NSString
                         }
                     }
                 }
        
        if dict.value(forKey: "userMenuControl") != nil{
                            if let diction = dict.value(forKey: "userMenuControl") as? NSDictionary {
                                if let showObj = diction.value(forKey: "pravakta") as? Bool {
                                    self.pravakta = String(showObj) as NSString
                                }
                            }
                        }
        if dict.value(forKey: "userMenuControl") != nil{
                             if let diction = dict.value(forKey: "userMenuControl") as? NSDictionary {
                                 if let showObj = diction.value(forKey: "subscribedSprayServices") as? Bool {
                                     self.subscribedSprayServices = String(showObj) as NSString
                                 }
                             }
                         }
        if dict.value(forKey: "userMenuControl") != nil{
                         if let diction = dict.value(forKey: "userMenuControl") as? NSDictionary {
                             if let showObj = diction.value(forKey: "sprayVendor") as? Bool {
                                 self.sprayVendor = String(showObj) as NSString
                             }
                         }
                     }
        if dict.value(forKey: "userMenuControl") != nil{
                         if let diction = dict.value(forKey: "userMenuControl") as? NSDictionary {
                             if let showObj = diction.value(forKey: "cepJourney") as? Bool {
                                 self.cepJourney = String(showObj) as NSString
                             }
                         }
                     }
        if dict.value(forKey: "userMenuControl") != nil{
                         if let diction = dict.value(forKey: "userMenuControl") as? NSDictionary {
                             if let showObj = diction.value(forKey: "rhrdJourney") as? Bool {
                                 self.rhrdJourney = String(showObj) as NSString
                             }
                         }
                     }
        
        if dict.value(forKey: "userMenuControl") != nil{
            if let diction = dict.value(forKey: "userMenuControl") as? NSDictionary {
                
                
                if let showObj = diction.value(forKey: "hybridSeeds") as? Bool {
                    self.hybridSeeds = String(showObj) as NSString
                }
                if let showObj = diction.value(forKey: "cropProtection") as? Bool {
                    self.cropProtection = String(showObj) as NSString
                }
                if let showObj = diction.value(forKey: "genuinityCheck") as? Bool {
                    self.genuinityCheck = String(showObj) as NSString
                }
                if let showObj = diction.value(forKey: "nearBuy") as? Bool {
                    self.nearBy = String(showObj) as NSString
                }
                if let showObj = diction.value(forKey: "pravakta") as? Bool {
                    self.pravaktaFeedback = String(showObj) as NSString
                }
                if let showObj = diction.value(forKey: "cropAdvisory") as? Bool {
                    self.cropAdvisory = String(showObj) as NSString
                }
                if let showObj = diction.value(forKey: "farmServices") as? Bool {
                    self.farmServices = String(showObj) as NSString
                }
                if let showObj = diction.value(forKey: "mandiPrices") as? Bool {
                    self.mandiPrices = String(showObj) as NSString
                }
                if let showObj = diction.value(forKey: "calculator") as? Bool {
                    self.cropCalculator = String(showObj) as NSString
                }
                if let showObj = diction.value(forKey: "myTimeline") as? Bool {
                    self.farmerDashboard = String(showObj) as NSString
                }
                if let showObj = diction.value(forKey: "myRewards") as? Bool {
                    self.rewards = String(showObj) as NSString
                }

                if let showObj = diction.value(forKey: "referFarmer") as? Bool {
                    self.referFarmer = String(showObj) as NSString
                }
                if let showObj = diction.value(forKey: "weatherReportFC") as? Bool {
                    self.weatherReport = String(showObj) as NSString
                }
                if let showObj = diction.value(forKey: "paramarshFC") as? Bool {
                    self.paramarsh = String(showObj) as NSString
                }
                if let showObj = diction.value(forKey: "notificationsFC") as? Bool {
                    self.notification = String(showObj) as NSString
                }
                
                if let showObj = diction.value(forKey: "rewardsSchemeAvailable") as? Bool {
                    self.offersBtn = String(showObj) as NSString
                }
                if let delegateObj = diction.value(forKey: "delegateDostDhamaka") as? Bool {
                    self.delegateDostDhamaka = String(delegateObj) as NSString
                }
                if let cropDiagnosisObj = diction.value(forKey: "showCropDiagnosis") as? Bool {
                    self.showCropDiagnosis = String(cropDiagnosisObj) as NSString
                }
                if let userLogsGenuinityPrint = diction.value(forKey: "userLogsGenuinityPrint") as? Bool {
                    self.userLogsGenuinityPrint = String(userLogsGenuinityPrint) as NSString
                }
                if let userLogsAllPrint = diction.value(forKey: "userLogsAllPrint") as? Bool {
                    self.userLogsAllPrint = String(userLogsAllPrint) as NSString
                }
                if let planterServicesVendor = diction.value(forKey: "planterServicesVendor") as? Bool {
                    self.planterServicesVendor = String(planterServicesVendor) as NSString
                }
                if let planterServices = diction.value(forKey: "planterServices") as? Bool {
                    self.planterServices = String(planterServices) as NSString
                }
            }
        }
        
        //rhrdJourney
        //arrSubIrrigations
     
        if Validations.isNullString(self.subIrrigationTypes ?? "") == false{
            let tempArrIrrigation = self.subIrrigationTypes?.components(separatedBy: ",")
            if tempArrIrrigation?.count ?? 0 > 0{
                self.arrSubIrrigations = tempArrIrrigation as NSArray?
            }
        }

        if Validations.isNullString(self.irrigations ?? "") == false{
            let tempArrIrrigation = self.irrigations?.components(separatedBy: ",")
            if tempArrIrrigation?.count ?? 0 > 0{
                self.arrIrrigations = tempArrIrrigation as NSArray?
            }
        }
        
        if Validations.isNullString(self.seasons ?? "") == false{
            let tempArrSeasons = self.seasons?.components(separatedBy: ",")
            if tempArrSeasons?.count ?? 0 > 0{
                self.arrSeasons = tempArrSeasons as NSArray?
            }
        }
        if Validations.isNullString(self.companies ?? "") == false{
            let tempArrCompanies = self.companies?.components(separatedBy: ",")
            if tempArrCompanies?.count ?? 0 > 0{
                self.arrCompanies = tempArrCompanies as NSArray?
            }
        }
        if let activeObj = dict.value(forKey: "active") as? Bool {
            self.active = String(activeObj) as NSString
        }
       
        if let germinationObj = dict.value(forKey: "showGermination") as? Bool {
            self.showGermination = String(germinationObj) as NSString
        }
        
    }
    func updateUserProfileData(dict : NSDictionary){
        if let cntCode = Validations.checkKeyNotAvail(dict, key: "countryCode") as? NSString{
            if Validations.isNullString(cntCode) == false{
                self.countryCode = (Validations.checkKeyNotAvail(dict, key: "countryCode") as?NSString)!
            }
        }
        self.customerId = (Validations.checkKeyNotAvail(dict, key: "customerId") as?NSString)!
        self.countryId = (Validations.checkKeyNotAvail(dict, key: "countryId") as?NSString)!
        self.emailId = (Validations.checkKeyNotAvail(dict, key: "emailId") as?NSString)!
        self.aadhaarNumber = (Validations.checkKeyNotAvail(dict, key: "aadhaarNumber") as?NSString)!
        self.mobileNumber = (Validations.checkKeyNotAvail(dict, key: "mobileNumber") as?NSString)!
        self.crop = (Validations.checkKeyNotAvail(dict, key: "crop") as?NSString)!
        self.cartCount = (Validations.checkKeyNotAvail(dict, key: "cartCount") as?NSString)!
        self.customerTypeId = (Validations.checkKeyNotAvail(dict, key: "customerTypeId") as?NSString)!
        self.customerTypeName = (Validations.checkKeyNotAvail(dict, key: "customerTypeName") as?NSString)!
        self.districtName = (Validations.checkKeyNotAvail(dict, key: "districtName") as?NSString)!
        self.firstName = (Validations.checkKeyNotAvail(dict, key: "firstName") as?NSString)!
        self.lastName = (Validations.checkKeyNotAvail(dict, key: "lastName") as?NSString)!
        self.pincode = (Validations.checkKeyNotAvail(dict, key: "pincode") as?NSString)!
        self.regionName = (Validations.checkKeyNotAvail(dict, key: "regionName") as?NSString)!
        self.stateName = (Validations.checkKeyNotAvail(dict, key: "stateName") as?NSString)!
        self.userAuthorizationToken = (Validations.checkKeyNotAvail(dict, key: "userAuthorizationToken") as?NSString)!
        self.cartCount = (Validations.checkKeyNotAvail(dict, key: "cartCount") as?NSString)!
        self.companies = (Validations.checkKeyNotAvail(dict, key: "company") as? NSString ?? "")!
        self.corn = (Validations.checkKeyNotAvail(dict, key: "cornCropAcres") as? NSString ?? "")!
        self.countryName = (Validations.checkKeyNotAvail(dict, key: "countryName") as? NSString ?? "")!
        self.geolocation = (Validations.checkKeyNotAvail(dict, key: "geolocation") as? NSString ?? "")!
        self.irrigations = (Validations.checkKeyNotAvail(dict, key: "irrigation") as? NSString ?? "")!
        self.millet = (Validations.checkKeyNotAvail(dict, key: "milletCropAcres") as? NSString ?? "")!
        self.mustard = (Validations.checkKeyNotAvail(dict, key: "mustardCropAcres") as? NSString ?? "")!
        self.rice = (Validations.checkKeyNotAvail(dict, key: "riceCropAcres") as? NSString ?? "")!
        self.seasons = (Validations.checkKeyNotAvail(dict, key: "season") as? NSString ?? "")!
        self.totalCropAcress = (Validations.checkKeyNotAvail(dict, key: "totalCropAcres") as? NSString ?? "")!
        self.riceAcres = (Validations.checkKeyNotAvail(dict, key: "riceAcres") as? NSString ?? "")!
        self.imagePath = (Validations.checkKeyNotAvail(dict, key: "imagePath") as? NSString ?? "")!
        self.yieldPaddy = (Validations.checkKeyNotAvail(dict, key: "yieldPaddy") as?NSString)!
        self.pexalonKharifSeason = (Validations.checkKeyNotAvail(dict, key: "pexalonKharifSeason") as?NSString)!
        self.retailerMno = (Validations.checkKeyNotAvail(dict, key: "retailerMno") as?NSString)!
        self.mdoMno = (Validations.checkKeyNotAvail(dict, key: "mdoMno") as?NSString)!
        
        self.knowDelegateAbout = (Validations.checkKeyNotAvail(dict, key: "knowDelegateAbout") as? NSString) ?? ""
        self.useDelegate = (Validations.checkKeyNotAvail(dict, key: "useDelegate") as? NSString) ?? ""
        self.chillyAcres = (Validations.checkKeyNotAvail(dict, key: "chillyAcres") as? NSString) ?? ""
        
        
        self.villageLocation = (Validations.checkKeyNotAvail(dict, key: "villageLocation") as? NSString ?? "")!
        self.soyabean = (Validations.checkKeyNotAvail(dict, key: "soyabeanCropAcres") as?NSString)!
        self.cotton = (Validations.checkKeyNotAvail(dict, key: "cottonCropAcres") as?NSString)!
        self.subIrrigationTypes = (Validations.checkKeyNotAvail(dict, key: "subIrrigationTypes") as? NSString)!
        self.companiesId = (Validations.checkKeyNotAvail(dict, key: "companyIds") as? NSString)!
        
        
//        self.optInWhatsApp = (Validations.checkKeyNotAvail(dict, key: "optInWhatsApp") as? NSString)!

        if  dict.value(forKey: "cropsList") != nil{
            arrSelectedCropsList?.removeAllObjects()
            for dicts  in ((dict.value(forKey: "cropsList") as? NSArray)!){
                let cropDict = dicts as? NSDictionary
                let name = (Validations.checkKeyNotAvail(cropDict!, key: "name") as?NSString)!
                if name.length > 0 {
                    arrSelectedCropsList?.add(name)
                }
            }
        }

        if Validations.isNullString(self.irrigations ?? "") == false{
            let tempArrIrrigation = self.irrigations?.components(separatedBy: ",")
            if tempArrIrrigation?.count ?? 0 > 0{
                self.arrIrrigations = tempArrIrrigation as NSArray?
            }
        }
        if Validations.isNullString(self.subIrrigationTypes ?? "") == false{
            let tempArrIrrigation = self.subIrrigationTypes?.components(separatedBy: ",")
            if tempArrIrrigation?.count ?? 0 > 0{
                self.arrSubIrrigations = tempArrIrrigation as NSArray?
            }
        }

        if Validations.isNullString(self.seasons ?? "") == false{
            let tempArrSeasons = self.seasons?.components(separatedBy: ",")
            if tempArrSeasons?.count ?? 0 > 0{
                self.arrSeasons = tempArrSeasons as NSArray?
            }
        }
        if Validations.isNullString(self.companies ?? "") == false{
            let tempArrCompanies = self.companies?.components(separatedBy: ",")
            if tempArrCompanies?.count ?? 0 > 0{
                self.arrCompanies = tempArrCompanies as NSArray?
            }
        }
        if let activeObj = dict.value(forKey: "active") as? Bool {
            self.active = String(activeObj) as NSString
        }
        /*if let cropDiagnosisObj = dict.value(forKey: "showCropDiagnosis") as? Bool {
            self.showCropDiagnosis = String(cropDiagnosisObj) as NSString
        }*/
    }
    required init(coder decoder: NSCoder) {
        self.countryCode = decoder.decodeObject(forKey: "countryCode") as? NSString ?? ""
        self.countryId = decoder.decodeObject(forKey: "countryId") as? NSString ?? ""
        self.customerId = decoder.decodeObject(forKey: "customerId") as? NSString ?? ""
        self.deviceId = decoder.decodeObject(forKey: "deviceId") as? NSString ?? ""
        self.emailId = decoder.decodeObject(forKey: "emailId") as? NSString ?? ""
        self.aadhaarNumber = decoder.decodeObject(forKey: "aadhaarNumber") as? NSString ?? ""
        self.mobileNumber = decoder.decodeObject(forKey: "mobileNumber") as? NSString ?? ""
        self.active = decoder.decodeObject(forKey: "active") as? NSString ?? ""
        self.showCropDiagnosis = decoder.decodeObject(forKey: "showCropDiagnosis") as? NSString ?? ""
        self.showGermination = decoder.decodeObject(forKey: "showGermination") as? NSString ?? ""
        self.deviceToken = decoder.decodeObject(forKey: "deviceToken") as? NSString ?? ""
        self.cartCount = decoder.decodeObject(forKey: "cartCount") as? NSString ?? ""
        self.crop = decoder.decodeObject(forKey: "crop") as? NSString ?? ""
        self.customerTypeId = decoder.decodeObject(forKey: "customerTypeId") as? NSString ?? ""
        self.customerTypeName = decoder.decodeObject(forKey: "customerTypeName") as? NSString ?? ""
        self.districtName = decoder.decodeObject(forKey: "districtName") as? NSString ?? ""
        self.firstName = decoder.decodeObject(forKey: "firstName") as? NSString ?? ""
        self.lastName = decoder.decodeObject(forKey: "lastName") as? NSString ?? ""
        self.pincode = decoder.decodeObject(forKey: "pincode") as? NSString ?? ""
        self.regionName = decoder.decodeObject(forKey: "regionName") as? NSString ?? ""
        self.stateName = decoder.decodeObject(forKey: "stateName") as? NSString ?? ""
        self.userAuthorizationToken = decoder.decodeObject(forKey: "userAuthorizationToken") as? NSString ?? ""
        self.deviceType = decoder.decodeObject(forKey: "deviceType") as? NSString ?? ""
        self.totalCropAcress = decoder.decodeObject(forKey: "totalCropAcress") as? NSString ?? ""
        self.riceAcres = decoder.decodeObject(forKey: "riceAcres") as? NSString
        self.imagePath = decoder.decodeObject(forKey: "imagePath") as? NSString
        self.yieldPaddy = decoder.decodeObject(forKey: "yieldPaddy") as? NSString
        self.pexalonKharifSeason = decoder.decodeObject(forKey: "pexalonKharifSeason") as? NSString
        self.retailerMno = decoder.decodeObject(forKey: "retailerMno") as? NSString
        self.mdoMno = decoder.decodeObject(forKey: "mdoMno") as? NSString
        
        self.knowDelegateAbout = decoder.decodeObject(forKey: "knowDelegateAbout") as? NSString
        self.useDelegate = decoder.decodeObject(forKey: "useDelegate") as? NSString
        self.chillyAcres = decoder.decodeObject(forKey: "chillyAcres") as? NSString
       
        
        
        self.villageLocation = decoder.decodeObject(forKey: "villageLocation") as? NSString ?? ""
        self.corn = decoder.decodeObject(forKey: "corn") as? NSString ?? ""
        self.rice = decoder.decodeObject(forKey: "rice") as? NSString ?? ""
        self.mustard = decoder.decodeObject(forKey: "mustard") as? NSString ?? ""
        self.millet = decoder.decodeObject(forKey: "millet") as? NSString ?? ""
        self.irrigations = decoder.decodeObject(forKey: "irrigations") as? NSString ?? ""
        self.companies = decoder.decodeObject(forKey: "companies") as? NSString ?? ""
        self.seasons = decoder.decodeObject(forKey: "seasons") as? NSString ?? ""
        self.latitude = decoder.decodeObject(forKey: "latitude") as? NSString ?? ""
        self.longitude = decoder.decodeObject(forKey: "longitude") as? NSString ?? ""
        self.countryName = decoder.decodeObject(forKey: "countryName") as? NSString ?? ""
        self.geolocation = decoder.decodeObject(forKey: "geolocation") as? NSString ?? ""
        self.soyabean = decoder.decodeObject(forKey: "soyabean") as? NSString ?? ""
        self.cotton = decoder.decodeObject(forKey: "cotton") as? NSString ?? ""
        self.subIrrigationTypes = decoder.decodeObject(forKey: "subIrrigationTypes") as? NSString ?? ""
        self.optInWhatsApp = decoder.decodeObject(forKey: "optInWhatsApp") as? NSString ?? ""

        self.arrSeasons = decoder.decodeObject(forKey: "arrSeasons") as? NSArray ?? NSArray()
        self.arrIrrigations = decoder.decodeObject(forKey: "arrIrrigations") as? NSArray ?? NSArray()
        self.arrCompanies = decoder.decodeObject(forKey: "arrCompanies") as? NSArray ?? NSArray()
        self.arrSelectedCropsList = decoder.decodeObject(forKey: "arrSelectedCropsList") as? NSMutableArray ?? NSMutableArray()
        self.arrSubIrrigations = decoder.decodeObject(forKey: "arrSubIrrigations") as? NSArray ?? NSArray()
     
        self.companiesId = decoder.decodeObject(forKey: "companyIds") as? NSString ?? ""
        self.showRewardsScheme = decoder.decodeObject(forKey: "showRewardsScheme") as? NSString ?? ""
        self.pravaktaMyBooklets = decoder.decodeObject(forKey: "pravaktaMyBooklets") as? NSString ?? ""
        self.enableShopScanWin = decoder.decodeObject(forKey: "shopScanWinProg") as? NSString ?? ""
        self.enableGenuinityCheckresults = decoder.decodeObject(forKey: "genunityReport") as? NSString ?? ""
        self.rglPurchaseOrder = decoder.decodeObject(forKey: "buy") as? NSString ?? ""
           self.enableSprayService = decoder.decodeObject(forKey: "enableSprayService") as? NSString ?? ""
           self.sprayVendor = decoder.decodeObject(forKey: "sprayVendor") as? NSString ?? ""
        self.cepJourney = decoder.decodeObject(forKey: "cepJourney") as? NSString ?? ""
        self.rhrdJourney =  decoder.decodeObject(forKey: "rhrdJourney") as? NSString ?? ""
        self.pravakta = decoder.decodeObject(forKey: "pravakta") as? NSString ?? ""
        self.subscribedSprayServices = decoder.decodeObject(forKey: "subscribedSprayServices") as? NSString ?? ""
        self.deepLinkingString =  decoder.decodeObject(forKey: "myReferShortenUrl") as? NSString ?? ""
        
        self.hybridSeeds =  decoder.decodeObject(forKey: "hybridSeeds") as? NSString ?? ""
        self.cropProtection =  decoder.decodeObject(forKey: "cropProtection") as? NSString ?? ""
        self.genuinityCheck =  decoder.decodeObject(forKey: "genuinityCheck") as? NSString ?? ""
        self.nearBy =  decoder.decodeObject(forKey: "nearBuy") as? NSString ?? ""
        self.pravaktaFeedback =  decoder.decodeObject(forKey: "pravakta") as? NSString ?? ""
        self.cropAdvisory =  decoder.decodeObject(forKey: "cropAdvisory") as? NSString ?? ""
        self.farmServices =  decoder.decodeObject(forKey: "farmServices") as? NSString ?? ""
        self.mandiPrices =  decoder.decodeObject(forKey: "mandiPrices") as? NSString ?? ""
        self.cropCalculator =  decoder.decodeObject(forKey: "calculator") as? NSString ?? ""
        self.farmerDashboard =  decoder.decodeObject(forKey: "myTimeline") as? NSString ?? ""
        self.rewards =  decoder.decodeObject(forKey: "myRewards") as? NSString ?? ""
        self.referFarmer =  decoder.decodeObject(forKey: "referFarmer") as? NSString ?? ""
        self.weatherReport =  decoder.decodeObject(forKey: "weatherReportFC") as? NSString ?? ""
        self.paramarsh =  decoder.decodeObject(forKey: "paramarshFC") as? NSString ?? ""
        self.notification =  decoder.decodeObject(forKey: "notificationsFC") as? NSString ?? ""
        self.offersBtn =  decoder.decodeObject(forKey: "rewardsSchemeAvailable") as? NSString ?? ""
        self.delegateDostDhamaka = decoder.decodeObject(forKey: "delegateDostDhamaka") as? NSString ?? ""
        
        self.userLogsGenuinityPrint = decoder.decodeObject(forKey: "userLogsGenuinityPrint") as? NSString ?? ""
        self.userLogsAllPrint = decoder.decodeObject(forKey: "userLogsAllPrint") as? NSString ?? ""
        self.planterServices = decoder.decodeObject(forKey: "planterServices") as? NSString ?? ""
        self.planterServicesVendor = decoder.decodeObject(forKey: "planterServicesVendor") as? NSString ?? ""
        
    }
    
    func updatemdoRetaile(dict : NSDictionary){
        
        self.retailerMno = (Validations.checkKeyNotAvail(dict, key: "retailerMno") as?NSString)!
        self.mdoMno = (Validations.checkKeyNotAvail(dict, key: "mdoMno") as?NSString)!
        
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.countryCode, forKey: "countryCode")
        coder.encode(self.countryId, forKey: "countryId")
        coder.encode(self.customerId, forKey: "customerId")
        coder.encode(self.deviceId, forKey: "deviceId")
        coder.encode(self.emailId, forKey: "emailId")
        coder.encode(self.aadhaarNumber, forKey: "aadhaarNumber")
        coder.encode(self.mobileNumber, forKey: "mobileNumber")
        coder.encode(self.active, forKey: "active")
        coder.encode(self.showCropDiagnosis, forKey: "showCropDiagnosis")
        coder.encode(self.showGermination, forKey: "showGermination")
        coder.encode(self.deviceToken, forKey: "deviceToken")
        coder.encode(self.cartCount, forKey: "cartCount")
        coder.encode(self.crop, forKey: "crop")
        coder.encode(self.customerTypeId, forKey: "customerTypeId")
        coder.encode(self.customerTypeName, forKey: "customerTypeName")
        coder.encode(self.districtName, forKey: "districtName")
        coder.encode(self.firstName, forKey: "firstName")
        coder.encode(self.lastName, forKey: "lastName")
        coder.encode(self.pincode, forKey: "pincode")
        coder.encode(self.regionName, forKey: "regionName")
        coder.encode(self.stateName, forKey: "stateName")
        coder.encode(self.userAuthorizationToken, forKey: "userAuthorizationToken")
        coder.encode(self.deviceType, forKey: "deviceType")
        coder.encode(self.totalCropAcress, forKey: "totalCropAcress")
        coder.encode(self.riceAcres, forKey: "riceAcres")
        coder.encode(self.imagePath, forKey: "imagePath")
        
        coder.encode(self.yieldPaddy, forKey: "yieldPaddy")
        coder.encode(self.pexalonKharifSeason, forKey: "pexalonKharifSeason")
        coder.encode(self.retailerMno, forKey: "retailerMno")
        coder.encode(self.mdoMno, forKey: "mdoMno")
        
        coder.encode(self.knowDelegateAbout, forKey: "knowDelegateAbout")
        coder.encode(self.useDelegate, forKey: "useDelegate")
        coder.encode(self.chillyAcres, forKey: "chillyAcres")
        
       
       
       
        
        coder.encode(self.villageLocation, forKey: "villageLocation")
        coder.encode(self.corn, forKey: "corn")
        coder.encode(self.rice, forKey: "rice")
        coder.encode(self.mustard, forKey: "mustard")
        coder.encode(self.millet, forKey: "millet")
        coder.encode(self.irrigations, forKey: "irrigations")
        coder.encode(self.companies, forKey: "companies")
        coder.encode(self.seasons, forKey: "seasons")
        coder.encode(self.latitude, forKey: "latitude")
        coder.encode(self.longitude, forKey: "longitude")
        coder.encode(self.countryName, forKey: "countryName")
        coder.encode(self.geolocation, forKey: "geolocation")
        coder.encode(self.arrSeasons, forKey: "arrSeasons")
        coder.encode(self.arrIrrigations, forKey: "arrIrrigations")
        coder.encode(self.arrCompanies, forKey: "arrCompanies")
        coder.encode(self.arrSelectedCropsList, forKey: "arrSelectedCropsList")
        coder.encode(self.soyabean, forKey: "soyabean")
        coder.encode(self.cotton, forKey: "cotton")
        coder.encode(self.showRewardsScheme, forKey: "showRewardsScheme")
        coder.encode(self.pravaktaMyBooklets, forKey: "pravaktaMyBooklets")
        coder.encode(self.enableShopScanWin, forKey: "shopScanWinProg")
        coder.encode(self.enableGenuinityCheckresults, forKey: "genunityReport")
        coder.encode(self.rglPurchaseOrder, forKey: "buy")
        coder.encode(self.sprayVendor, forKey: "sprayVendor")
        coder.encode(self.cepJourney, forKey: "cepJourney")
        coder.encode(self.rhrdJourney, forKey: "rhrdJourney")
         coder.encode(self.enableSprayService, forKey: "enableSprayService")
        coder.encode(self.arrSubIrrigations, forKey: "arrSubIrrigations")
        coder.encode(self.companiesId, forKey: "companyIds")
        coder.encode(self.subIrrigationTypes, forKey: "subIrrigationTypes")
        coder.encode(self.optInWhatsApp, forKey: "optInWhatsApp")
         coder.encode(self.pravakta, forKey: "pravakta")
         coder.encode(self.subscribedSprayServices, forKey: "subscribedSprayServices")
        coder.encode(self.deepLinkingString, forKey: "myReferShortenUrl")
        
        coder.encode(self.hybridSeeds, forKey: "hybridSeeds")
        coder.encode(self.cropProtection, forKey: "cropProtection")
        coder.encode(self.genuinityCheck, forKey: "genuinityCheck")
        coder.encode(self.nearBy, forKey: "nearBuy")
        coder.encode(self.pravaktaFeedback, forKey: "pravakta")
        coder.encode(self.cropAdvisory, forKey: "cropAdvisory")
        coder.encode(self.farmServices, forKey: "farmServices")
        coder.encode(self.mandiPrices, forKey: "mandiPrices")
        coder.encode(self.cropCalculator, forKey: "calculator")
        coder.encode(self.farmerDashboard, forKey: "myTimeline")
        coder.encode(self.rewards, forKey: "myRewards")
        coder.encode(self.referFarmer, forKey: "referFarmer")
        coder.encode(self.weatherReport, forKey: "weatherReportFC")
        coder.encode(self.paramarsh, forKey: "paramarshFC")
        coder.encode(self.notification, forKey: "notificationsFC")
        coder.encode(self.offersBtn, forKey: "rewardsSchemeAvailable")
        coder.encode(self.delegateDostDhamaka, forKey: "delegateDostDhamaka")

        coder.encode(self.userLogsGenuinityPrint, forKey: "userLogsGenuinityPrint")
        coder.encode(self.userLogsAllPrint, forKey: "userLogsAllPrint")
        coder.encode(self.planterServices, forKey: "planterServices")
        coder.encode(self.planterServicesVendor, forKey: "planterServicesVendor")
    }
}

