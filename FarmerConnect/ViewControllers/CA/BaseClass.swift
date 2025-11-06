//
//  BaseClass.swift
//  CropAdvisoryFramework
//
//  Created by Apple on 04/12/19.
//  Copyright © 2019 Empover iTech Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire

open class BaseClass: NSObject {
    
    
    
    open class func logToConsole(_ msg: String) {
        print(msg);
        
  
        
    }
    
    open class func loadViewFilter(userObj :NSMutableDictionary)  -> UIViewController {
        print("loadViewFilter : \(userObj.count)")

//        Analytics.logEvent(AnalyticsEventSignUp, parameters: [
//            AnalyticsParameterMethod: method
//            ])
        
        let storyboard = UIStoryboard.init(name: "mains", bundle: Bundle(for: self))
        let homeVC = storyboard.instantiateViewController(withIdentifier: "CASubscriptionFilterViewController") as! CASubscriptionFilterViewController
        if userObj.count > 0{
            homeVC.userObj1 = userObj
          //  let userObj2 = User(dict: userObj)
            //CropSubStageCollectionViewCell
           // Constatnts.setUserToUserDefaults(user: userObj2)
        }
        
        return homeVC
    }
    
    open class func loadViewgrowth()  -> UIViewController {

        let storyboard = UIStoryboard.init(name: "cropadvisorySub", bundle: Bundle(for: self))
        let homeVC = storyboard.instantiateViewController(withIdentifier: "SubscriptionGrowthDurationViewController") as! SubscriptionGrowthDurationViewController
        
        return homeVC
    }
    
    
    //CropDetailsPhaseViewController

    open class func loadViewPhase()  -> UIViewController {
        
        let storyboard = UIStoryboard.init(name: "cropadvisorySub", bundle: Bundle(for: self))
        let homeVC = storyboard.instantiateViewController(withIdentifier: "CropDetailsPhaseViewController") as! CropDetailsPhaseViewController
        return homeVC
    }
    
   
    
    
    
    //MARK: GET CROP TYPE  LIST DETAILS FOR CA
    public  class func submitCropFilterUserData(dic : NSDictionary, headers : HTTPHeaders, completionHandler:@escaping (_ status:Bool?, _ response: NSMutableDictionary?, _ message:String?)-> Void){
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_CA_SUSBSCRIPTION_CROPTYPE ])
        let paramsStr1 = Constatnts.nsobjectToJSON(dic as NSDictionary)
        let params =  ["data": paramsStr1]
        print("params %@",params)
        SwiftLoader.show(animated: true)
        //let headers = Constatnts.getLoggedInFarmerHeaders()
        print("headers : \(headers)")
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response)  in
            //  DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            if let json = response.result.value {
                let responseDic = json as? NSDictionary
                
                print("Response :\(json)")
                let responseStatusCode = NSInteger(responseDic?.value(forKey: "statusCode") as? String ?? "0")
                if responseStatusCode == 200{
                    SwiftLoader.hide()
                    if Validations.isNullString(((json as? NSDictionary)?.value(forKey: JAVA_RESPONSE_DATA_KEY) as? NSString)?.replacingOccurrences(of: "\\", with: "") as NSString? ?? "") == false{
                        let respData = ((json as? NSDictionary)?.value(forKey: JAVA_RESPONSE_DATA_KEY) as? NSString)?.replacingOccurrences(of: "\\", with: "")
                        // print("Response :\(respData)")
                        
                        let decryptData : NSDictionary  = Constatnts.decryptResult(StrJson: respData ?? "")
                        print("Response after decrypting data:\(decryptData)")
                        
                        let dictResult : NSMutableDictionary = NSMutableDictionary(dictionary:decryptData )
                        completionHandler(true,dictResult , "Success")
                    }else {
                        SwiftLoader.hide()
                        let msg =  responseDic?.value(forKey: "message") as? String ?? ""
                        completionHandler(true,nil, msg)
                    }
                }
                else  if responseStatusCode == 10{
                    SwiftLoader.hide()
                    completionHandler(false,NSMutableDictionary(), "No records found")
                }
                else{
                    SwiftLoader.hide()
                    completionHandler(false,NSMutableDictionary(), "Error occured")
                }
            }
            else{
                
                SwiftLoader.hide()
                print("error")
                completionHandler(false,NSMutableDictionary(), "Error occured")
            }
        }
    }
    
    
    
    //MARK: GET CROP TYPE  LIST DETAILS FOR CA
    public  class func getListOfCropsCA(dic : NSDictionary, headers : HTTPHeaders, completionHandler:@escaping (_ status:Bool?, _ response: NSMutableDictionary?, _ message:String?)-> Void){
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,CA_GET_CROPLIST ])
        let paramsStr1 = Constatnts.nsobjectToJSON(dic as NSDictionary)
        let params =  ["data": paramsStr1]
        print("params %@",params)
        SwiftLoader.show(animated: true)
      //  let headers = Constatnts.getLoggedInFarmerHeaders()
        print("headers : \(headers)")
        Alamofire.request(urlString, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response)  in
            //  DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            if let json = response.result.value {
                let responseDic = json as? NSDictionary
                
                // print("Response :\(json)")
                let responseStatusCode = NSInteger(responseDic?.value(forKey: "statusCode") as? String ?? "0")
                if responseStatusCode == 200{
                    SwiftLoader.hide()
                    if Validations.isNullString(((json as? NSDictionary)?.value(forKey: JAVA_RESPONSE_DATA_KEY) as? NSString)?.replacingOccurrences(of: "\\", with: "") as NSString? ?? "") == false{
                        let respData = ((json as? NSDictionary)?.value(forKey: JAVA_RESPONSE_DATA_KEY) as? NSString)?.replacingOccurrences(of: "\\", with: "")
                        //   print("Response :\(respData)")
                        
                        let decryptData : NSDictionary  = Constatnts.decryptResult(StrJson: respData ?? "")
                        print("Response after decrypting data:\(decryptData)")
                        
                        let dictResult : NSMutableDictionary = NSMutableDictionary(dictionary:decryptData )
                        completionHandler(true,dictResult , "Success")
                    }
                }
                else  if responseStatusCode == 10{
                    SwiftLoader.hide()
                    completionHandler(false,NSMutableDictionary(), "No records found")
                }
                else{
                    SwiftLoader.hide()
                    completionHandler(false,NSMutableDictionary(), "Error occured")
                }
            }
            else{
                SwiftLoader.hide()
                print("error")
                completionHandler(false,NSMutableDictionary(), "Error occured")
            }
        }
    }
    
    //CA_GET_ORIGINALIMAGE_AND_SUBIMAGES
    
    //MARK: GET CROP TYPE  LIST DETAILS FOR CA
    public  class func getCAOriginalImageandSubImages(dic : NSDictionary ,header : HTTPHeaders, completionHandler:@escaping (_ status:Bool?, _ response: NSMutableDictionary?, _ message:String?)-> Void){
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,CA_GET_ORIGINALIMAGE_AND_SUBIMAGES ])
        let paramsStr1 = Constatnts.nsobjectToJSON(dic as NSDictionary)
        let params =  ["data": paramsStr1]
        print("params %@",params)
        SwiftLoader.show(animated: true)
       // let headers = Constatnts.getLoggedInFarmerHeaders()
        print("headers : \(header)")
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (response)  in
            //  DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            if let json = response.result.value {
                let responseDic = json as? NSDictionary
                
                print("Response cropAdvisory/getCropAdvisoryOriginalAndSubImageDetails  images:\(json)")
                let responseStatusCode = NSInteger(responseDic?.value(forKey: "statusCode") as? String ?? "0")
                if responseStatusCode == 200{
                    SwiftLoader.hide()
                    if Validations.isNullString(((json as? NSDictionary)?.value(forKey: JAVA_RESPONSE_DATA_KEY) as? NSString)?.replacingOccurrences(of: "\\", with: "") as NSString? ?? "") == false{
                        let respData = ((json as? NSDictionary)?.value(forKey: JAVA_RESPONSE_DATA_KEY) as? NSString)?.replacingOccurrences(of: "\\", with: "")
                        // print("Response :\(respData)")
                        
                        let decryptData : NSDictionary  = Constatnts.decryptResult(StrJson: respData ?? "")
                        print("Response after decrypting data:\(decryptData)")
                        
                        let dictResult : NSMutableDictionary = NSMutableDictionary(dictionary:decryptData )
                        completionHandler(true,dictResult , "Success")
                    }
                }
                else  if responseStatusCode == 10{
                    SwiftLoader.hide()
                    completionHandler(false,NSMutableDictionary(), "No records found")
                }
                else{
                    SwiftLoader.hide()
                    completionHandler(false,NSMutableDictionary(), "Error occured")
                }
            }
            else{
                SwiftLoader.hide()
                print("error")
                completionHandler(false,NSMutableDictionary(), "Error occured")
            }
        }
    }
    
    //Get sub phase pop up images
    
    //MARK: GET CROP TYPE  LIST DETAILS FOR CA
    public  class func getCASubOriginalImageandSubImages(dic : NSDictionary,header : HTTPHeaders, completionHandler:@escaping (_ status:Bool?, _ response: NSMutableDictionary?, _ message:String?)-> Void){
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,CA_GET_SUB_ORIGINALIMAGE_AND_SUBIMAGES ])
        let paramsStr1 = Constatnts.nsobjectToJSON(dic as NSDictionary)
        let params =  ["data": paramsStr1]
        print("params %@",params)
        SwiftLoader.show(animated: true)
      //  let headers = Constatnts.getLoggedInFarmerHeaders()
        print("headers : \(header)")
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (response)  in
            //  DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            if let json = response.result.value {
                let responseDic = json as? NSDictionary
                
                print("Response cropAdvisory/getCropAdvisorySubImagesAndDataDetails images:\(json)")
                let responseStatusCode = NSInteger(responseDic?.value(forKey: "statusCode") as? String ?? "0")
                if responseStatusCode == 200{
                    SwiftLoader.hide()
                    if Validations.isNullString(((json as? NSDictionary)?.value(forKey: JAVA_RESPONSE_DATA_KEY) as? NSString)?.replacingOccurrences(of: "\\", with: "") as NSString? ?? "") == false{
                        let respData = ((json as? NSDictionary)?.value(forKey: JAVA_RESPONSE_DATA_KEY) as? NSString)?.replacingOccurrences(of: "\\", with: "")
                        // print("Response :\(respData)")
                        
                        let decryptData : NSDictionary  = Constatnts.decryptResult(StrJson: respData ?? "")
                        print("Response after decrypting data:\(decryptData)")
                        
                        let dictResult : NSMutableDictionary = NSMutableDictionary(dictionary:decryptData )
                        completionHandler(true,dictResult , "Success")
                    }
                }
                else  if responseStatusCode == 10{
                    SwiftLoader.hide()
                    completionHandler(false,NSMutableDictionary(), "No records found")
                }
                else{
                    SwiftLoader.hide()
                    completionHandler(false,NSMutableDictionary(), "Error occured")
                }
            }
            else{
                SwiftLoader.hide()
                print("error")
                completionHandler(false,NSMutableDictionary(), "Error occured")
            }
        }
    }
    
    //CA_GET_DATA_DETAILS
    
    //GET SUBSCRIPTION FINAL DETAILED SCREEN WITH VOICE FILES
    
    //MARK: GET CROP TYPE  LIST DETAILS FOR CA
    public  class func getCADataDetails(dic : NSDictionary, header : HTTPHeaders, completionHandler:@escaping (_ status:Bool?, _ response: NSMutableDictionary?, _ message:String?)-> Void){
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,CA_GET_DATA_DETAILS ])
        let paramsStr1 = Constatnts.nsobjectToJSON(dic as NSDictionary)
        let params =  ["data": paramsStr1]
        print("params %@",params)
        SwiftLoader.show(animated: true)
       // let headers = Constatnts.getLoggedInFarmerHeaders()
        print("headers : \(header)")
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (response)  in
            //  DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            if let json = response.result.value {
                let responseDic = json as? NSDictionary
                
                print("Response cropAdvisory/getCropAdvisoryDataDetails images:\(json)")
                let responseStatusCode = NSInteger(responseDic?.value(forKey: "statusCode") as? String ?? "0")
                if responseStatusCode == 200{
                    SwiftLoader.hide()
                    if Validations.isNullString(((json as? NSDictionary)?.value(forKey: JAVA_RESPONSE_DATA_KEY) as? NSString)?.replacingOccurrences(of: "\\", with: "") as NSString? ?? "") == false{
                        let respData = ((json as? NSDictionary)?.value(forKey: JAVA_RESPONSE_DATA_KEY) as? NSString)?.replacingOccurrences(of: "\\", with: "")
                        // print("Response :\(String(describing: respData))")
                        
                        let decryptData : NSDictionary  = Constatnts.decryptResult(StrJson: respData ?? "")
                        print("Response after decrypting data:\(decryptData)")
                        
                        let dictResult : NSMutableDictionary = NSMutableDictionary(dictionary:decryptData )
                        completionHandler(true,dictResult , "Success")
                    }
                }
                else  if responseStatusCode == 10{
                    SwiftLoader.hide()
                    completionHandler(false,NSMutableDictionary(), "No records found")
                }
                else{
                    SwiftLoader.hide()
                    completionHandler(false,NSMutableDictionary(), "Error occured")
                }
            }
            else{
                SwiftLoader.hide()
                print("error")
                completionHandler(false,NSMutableDictionary(), "Error occured")
            }
        }
    }
    
    //
    
    //MARK: GET Subscribed user details list
    public   class func getCASubscribeduserDetails(dic : NSDictionary, headers : HTTPHeaders, completionHandler:@escaping (_ status:Bool?, _ response: NSMutableDictionary?, _ message:String?)-> Void){
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,CA_GET_SUBSCRIBED_USER_DETAILS ])
        let paramsStr1 = Constatnts.nsobjectToJSON(dic as NSDictionary)
        let params =  ["data": paramsStr1]
        print("params %@",params)
        SwiftLoader.show(animated: true)
       // let headers = Constatnts.getLoggedInFarmerHeaders()
        print("headers : \(headers)")
        Alamofire.request(urlString, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response)  in
            //  DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            if let json = response.result.value {
                let responseDic = json as? NSDictionary
                
                print("Response cropAdvisory/getCASubscribedUserDetails images:\(json)")
                let responseStatusCode = NSInteger(responseDic?.value(forKey: "statusCode") as? String ?? "0")
                if responseStatusCode == 200{
                    SwiftLoader.hide()
                    if Validations.isNullString(((json as? NSDictionary)?.value(forKey: JAVA_RESPONSE_DATA_KEY) as? NSString)?.replacingOccurrences(of: "\\", with: "") as NSString? ?? "") == false{
                        let respData = ((json as? NSDictionary)?.value(forKey: JAVA_RESPONSE_DATA_KEY) as? NSString)?.replacingOccurrences(of: "\\", with: "")
                        //print("Response :\(respData)")
                        
                        let decryptData : NSDictionary  = Constatnts.decryptResult(StrJson: respData ?? "")
                        print("Response after decrypting data:\(decryptData)")
                        
                        let dictResult : NSMutableDictionary = NSMutableDictionary(dictionary:decryptData )
                        completionHandler(true,dictResult , "Success")
                    }
                }
                else  if responseStatusCode == 10{
                    SwiftLoader.hide()
                    completionHandler(false,NSMutableDictionary(), "No records found")
                }
                else{
                    SwiftLoader.hide()
                    completionHandler(false,NSMutableDictionary(), "Error occured")
                }
            }
            else{
                SwiftLoader.hide()
                print("error")
                completionHandler(false,NSMutableDictionary(), "Error occured")
            }
        }
    }
    
    //CA_SUBSCRIBE_ADVISORY
    
    //MARK: GET Subscribed user details list
    public   class func newCASubscription(dic : NSDictionary, headers : HTTPHeaders, completionHandler:@escaping (_ status:Bool?, _ response: NSMutableDictionary?, _ message:String?)-> Void){
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,CA_SUBSCRIBE_ADVISORY ])
        let paramsStr1 = Constatnts.nsobjectToJSON(dic as NSDictionary)
        let params =  ["data": paramsStr1]
        print("params %@",params)
        SwiftLoader.show(animated: true)
      //  let headers = Constatnts.getLoggedInFarmerHeaders()
        print("headers : \(headers)")
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response)  in
            //  DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            if let json = response.result.value {
                let responseDic = json as? NSDictionary
                
                print("Response cropAdvisory/subscribeCropAdvisory_V2 images:\(json)")
                let responseStatusCode = NSInteger(responseDic?.value(forKey: "statusCode") as? String ?? "0")
                if responseStatusCode == 200{
                    SwiftLoader.hide()
                    if Validations.isNullString(((json as? NSDictionary)?.value(forKey: JAVA_RESPONSE_DATA_KEY) as? NSString)?.replacingOccurrences(of: "\\", with: "") as NSString? ?? "") == false{
                        let respData = ((json as? NSDictionary)?.value(forKey: JAVA_RESPONSE_DATA_KEY) as? NSString)?.replacingOccurrences(of: "\\", with: "")
                        //  print("Response :\(respData)")
                        
                        let decryptData : NSDictionary  = Constatnts.decryptResult(StrJson: respData ?? "")
                        print("Response after decrypting data:\(decryptData)")
                        
                        let dictResult : NSMutableDictionary = NSMutableDictionary(dictionary:decryptData )
                        completionHandler(true,dictResult , "Success")
                    }
                }
                else  if responseStatusCode == 10{
                    SwiftLoader.hide()
                    completionHandler(false,NSMutableDictionary(), "No records found")
                }
                else{
                    SwiftLoader.hide()
                    completionHandler(false,NSMutableDictionary(), "Error occured")
                }
            }
            else{
                SwiftLoader.hide()
                print("error")
                completionHandler(false,NSMutableDictionary(), "Error occured")
            }
        }
    }
    
    //CA_GET_SUBIMAGES_DATADETAILS
    
    
    //MARK: GET Subscribed user details list
    public   class func getCASubimagesDetailsScreen(dic : NSDictionary, completionHandler:@escaping (_ status:Bool?, _ response: NSMutableDictionary?, _ message:String?)-> Void){
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,CA_GET_SUBIMAGES_DATADETAILS ])
        let paramsStr1 = Constatnts.nsobjectToJSON(dic as NSDictionary)
        let params =  ["data": paramsStr1]
        print("params %@",params)
        SwiftLoader.show(animated: true)
        let headers = Constatnts.getLoggedInFarmerHeaders()
        print("headers : \(headers)")
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response)  in
            //  DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            if let json = response.result.value {
                let responseDic = json as? NSDictionary
                
                print("Response CA_GET_SUBIMAGES_DATADETAILS userdetails images:\(json)")
                let responseStatusCode = NSInteger(responseDic?.value(forKey: "statusCode") as? String ?? "0")
                if responseStatusCode == 200{
                    SwiftLoader.hide()
                    if Validations.isNullString(((json as? NSDictionary)?.value(forKey: JAVA_RESPONSE_DATA_KEY) as? NSString)?.replacingOccurrences(of: "\\", with: "") as NSString? ?? "") == false{
                        let respData = ((json as? NSDictionary)?.value(forKey: JAVA_RESPONSE_DATA_KEY) as? NSString)?.replacingOccurrences(of: "\\", with: "")
                        // print("Response :\(respData)")
                        
                        let decryptData : NSDictionary  = Constatnts.decryptResult(StrJson: respData ?? "")
                        print("Response after decrypting data:\(decryptData)")
                        
                        let dictResult : NSMutableDictionary = NSMutableDictionary(dictionary:decryptData )
                        completionHandler(true,dictResult , "Success")
                    }
                }
                else  if responseStatusCode == 10{
                    SwiftLoader.hide()
                    completionHandler(false,NSMutableDictionary(), "No records found")
                }
                else{
                    SwiftLoader.hide()
                    completionHandler(false,NSMutableDictionary(), "Error occured")
                }
            }
            else{
                SwiftLoader.hide()
                print("error")
                completionHandler(false,NSMutableDictionary(), "Error occured")
            }
        }
    }
    
    
}

/*sample*/

open class GrowthCASubscriptionsBO: NSObject {
    @objc var cropPhase: NSString?
    @objc var cropPhaseImgUrl: NSString?
    @objc var cropShortDurationOrTotal: NSString?
    @objc var cropMediumDurationOrTotal :NSString?
    @objc var cropLongDurationOrTotal :NSString?
    @objc var cropPhaseId :NSString?
    @objc var noOfStagesInEachPhase :NSString?
    @objc var cropPhasePercentage :NSString?
    
    
    
    public  init(dict : NSDictionary){
        self.cropPhaseId = (Validations.checkKeyNotAvail(dict, key: "cropPhaseID") as? NSString ?? "")
        if let idObj = dict.value(forKey: "cropPhaseID") as? Int {
            self.cropPhaseId = String(format: "%d",idObj) as NSString
        }
        
        self.cropPhasePercentage = (Validations.checkKeyNotAvail(dict, key: "cropPhasePercentage") as? NSString ?? "")
        if let idObj = dict.value(forKey: "cropPhasePercentage") as? Int {
            self.cropPhasePercentage = String(format: "%d",idObj) as NSString
        }
        
        if let idObj = dict.value(forKey: "cropPhaseID") as? Int {
            self.cropPhaseId = String(format: "%d",idObj) as NSString
        }
        self.cropPhase = (Validations.checkKeyNotAvail(dict, key: "cropPhase") as? NSString ?? "")
        self.cropPhaseImgUrl = (Validations.checkKeyNotAvail(dict, key: "cropPhaseImgUrl") as? NSString ?? "")
        self.cropShortDurationOrTotal = (Validations.checkKeyNotAvail(dict, key: "cropShortDurationOrTotal") as? NSString ?? "")
        self.cropMediumDurationOrTotal = (Validations.checkKeyNotAvail(dict, key: "cropMediumDurationOrTotal") as? NSString ?? "")
        self.cropLongDurationOrTotal = (Validations.checkKeyNotAvail(dict, key: "cropLongDurationOrTotal") as? NSString ?? "")
        self.noOfStagesInEachPhase = (Validations.checkKeyNotAvail(dict, key: "noOfStagesInEachPhase") as? NSString ?? "")
        
        if let idObj = dict.value(forKey: "noOfStagesInEachPhase") as? Int {
            self.noOfStagesInEachPhase = String(format: "%d",idObj) as NSString
        }
    }
}

open class CA_CropFilterBO: NSObject {
    @objc var cropName: NSString?
    @objc var cropType: NSString?
    @objc var cropTypeID: NSString?
    @objc var cropID :NSString?
    @objc var categoryID :NSString?
    @objc var stateID :NSString?
    @objc var cropImageUrl :NSString?
    
    
    public   init(dict : NSDictionary){
        self.cropTypeID = (Validations.checkKeyNotAvail(dict, key: "cropTypeID") as? NSString ?? "")
        if let idObj = dict.value(forKey: "cropTypeID") as? Int {
            self.cropTypeID = String(format: "%d",idObj) as NSString
        }
        
        self.categoryID = (Validations.checkKeyNotAvail(dict, key: "categoryID") as? NSString ?? "")
        if let idObj = dict.value(forKey: "categoryID") as? Int {
            self.categoryID = String(format: "%d",idObj) as NSString
        }
        
        self.stateID = (Validations.checkKeyNotAvail(dict, key: "stateID") as? NSString ?? "")
        if let idObj = dict.value(forKey: "stateID") as? Int {
            self.stateID = String(format: "%d",idObj) as NSString
        }
        
        self.cropID = (Validations.checkKeyNotAvail(dict, key: "cropID") as? NSString ?? "")
        if let idObj = dict.value(forKey: "cropID") as? Int {
            self.cropID = String(format: "%d",idObj) as NSString
        }
        self.cropImageUrl = (Validations.checkKeyNotAvail(dict, key: "cropImageUrl") as? NSString ?? "")
        
        
    }
}


open class GrowthCASubPhasesBO: NSObject {
    @objc var cropSubPhase: NSString?
    @objc var cropSubPhaseImgUrl: NSString?
    @objc var cropSubPhaseID :NSString?
    @objc var noOfStagesInEachPhase :NSString?
    var cropSubPhasePercentage :NSString?
    
    
    public   init(dict : NSDictionary){
        self.cropSubPhaseID = (Validations.checkKeyNotAvail(dict, key: "cropPhaseId") as? NSString ?? "")
        if let idObj = dict.value(forKey: "cropPhaseId") as? Int {
            self.cropSubPhaseID = String(format: "%d",idObj) as NSString
        }
        self.cropSubPhasePercentage = (Validations.checkKeyNotAvail(dict, key: "cropPhasePercentage") as? NSString ?? "")
        //self.cropSubPhasePercentage = (Validations.checkKeyNotAvail(dict, key: "cropSubPhasePercentage") as? NSString ?? "")
        if let idObj = dict.value(forKey: "cropPhasePercentage") as? CGFloat {
            self.cropSubPhasePercentage = String(format: "%f",idObj) as NSString
        }
        self.cropSubPhase = (Validations.checkKeyNotAvail(dict, key: "cropSubPhase") as? NSString ?? "")
        self.cropSubPhaseImgUrl = (Validations.checkKeyNotAvail(dict, key: "cropSubPhaseImgUrl") as? NSString ?? "")
        self.noOfStagesInEachPhase = (Validations.checkKeyNotAvail(dict, key: "noOfStagesInEachPhase") as? NSString ?? "")
        
        self.noOfStagesInEachPhase = (Validations.checkKeyNotAvail(dict, key: "noOfStagesInEachPhase") as? NSString ?? "")
        
        if let idObj = dict.value(forKey: "noOfStagesInEachPhase") as? Int {
            self.noOfStagesInEachPhase = String(format: "%d",idObj) as NSString
        }
    }
}

open class CropControllerBO: NSObject {
    @objc var categoryID: NSString?
    @objc var cropID: NSString?
    @objc var cropImageUrl :NSString?
    @objc var cropName :NSString?
    @objc var cropType :NSString?
    @objc var cropTypeID :NSString?
    @objc var stateID :NSString?
    
    
    public  init(dict : NSDictionary){
        self.categoryID = (Validations.checkKeyNotAvail(dict, key: "categoryId") as? NSString ?? "")
        if let idObj = dict.value(forKey: "categoryId") as? Int {
            self.categoryID = String(format: "%d",idObj) as NSString
        }
        
        self.cropID = (Validations.checkKeyNotAvail(dict, key: "cropId") as? NSString ?? "")
        if let idObj = dict.value(forKey: "cropId") as? Int {
            self.cropID = String(format: "%d",idObj) as NSString
        }
        
        self.cropTypeID = (Validations.checkKeyNotAvail(dict, key: "cropTypeId") as? NSString ?? "")
        if let idObj = dict.value(forKey: "cropTypeId") as? Int {
            self.cropTypeID = String(format: "%d",idObj) as NSString
        }
        
        self.stateID = (Validations.checkKeyNotAvail(dict, key: "stateId") as? NSString ?? "")
        if let idObj = dict.value(forKey: "stateId") as? Int {
            self.stateID = String(format: "%d",idObj) as NSString
        }
        
        self.cropImageUrl = (Validations.checkKeyNotAvail(dict, key: "cropImageUrl") as? NSString ?? "")
        self.cropName = (Validations.checkKeyNotAvail(dict, key: "cropName") as? NSString ?? "")
        self.cropType = (Validations.checkKeyNotAvail(dict, key: "cropType") as? NSString ?? "")
    }
}

open class CASubscribedUserListBO: NSObject {
    @objc var hybridName: NSString?
    @objc var cropID: NSString?
    @objc var cropImageUrl :NSString?
    @objc var cropName :NSString?
    @objc var cropType :NSString?
    @objc var category :NSString?
    @objc var season :NSString?
    @objc var dateOfShowing :NSString?
    @objc var percentage :NSString?
    
    public  init(dict : NSDictionary){
        self.category = (Validations.checkKeyNotAvail(dict, key: "categoryId") as? NSString ?? "")
        if let idObj = dict.object(forKey: "categoryId") as? Int {
            self.category = String(format: "%d",idObj) as NSString
        }
        
        if let idObj = dict.object(forKey: "categoryId") as? UInt64 {
            self.category = String(format: "%d",idObj) as NSString
        }
        
        self.cropID = (Validations.checkKeyNotAvail(dict, key: "cropId") as? NSString ?? "")
        if let idObj = dict.object(forKey: "cropId") as? Int {
            self.cropID = String(format: "%d",idObj) as NSString
        }
        
        
        self.hybridName = (Validations.checkKeyNotAvail(dict, key: "hybridName") as? NSString ?? "")
        if let idObj = dict.object(forKey: "hybridName") as? Int {
            self.hybridName = String(format: "%d",idObj) as NSString
        }
        
        self.season = (Validations.checkKeyNotAvail(dict, key: "seasonId") as? NSString ?? "")
        if let idObj = dict.object(forKey: "seasonId") as? Int {
            self.season = String(format: "%d",idObj) as NSString
        }
        
        self.percentage = (Validations.checkKeyNotAvail(dict, key: "percentage") as? NSString ?? "")
               if let idObj = dict.object(forKey: "percentage") as? Int {
                   self.percentage = String(format: "%d",idObj) as NSString
               }
        self.cropImageUrl = (Validations.checkKeyNotAvail(dict, key: "subscribeCropImage") as? NSString ?? "")
        self.cropName = (Validations.checkKeyNotAvail(dict, key: "cropName") as? NSString ?? "")
        // self.category = (Validations.checkKeyNotAvail(dict, key: "category") as? NSString ?? "")
        self.dateOfShowing = (Validations.checkKeyNotAvail(dict, key: "dateOfShowing") as? NSString ?? "")
    }
}

open class GrowthCASubPhasesNew: NSObject {
    @objc var caSatgeId: NSString?
    @objc var cropId: NSString?
    @objc var cropName :NSString?
    @objc var cropPhaseID :NSString?
    @objc var cropPhasePercentage :NSString?
    @objc var cropTypeId :NSString?
    
    
    
    
    public  init(dict : NSDictionary){
        self.caSatgeId = (Validations.checkKeyNotAvail(dict, key: "caSatgeId") as? NSString ?? "")
        if let idObj = dict.value(forKey: "caSatgeId") as? Int {
            self.caSatgeId = String(format: "%d",idObj) as NSString
        }
        self.cropName = (Validations.checkKeyNotAvail(dict, key: "cropName") as? NSString ?? "")
        self.cropId = (Validations.checkKeyNotAvail(dict, key: "cropId") as? NSString ?? "")
        if let idObj = dict.value(forKey: "cropId") as? CGFloat {
            self.cropId = String(format: "%f",idObj) as NSString
        }
        
        self.cropPhasePercentage = (Validations.checkKeyNotAvail(dict, key: "cropPhasePercentage") as? NSString ?? "")
        if let idObj = dict.value(forKey: "cropPhasePercentage") as? CGFloat {
            self.cropPhasePercentage = String(format: "%f",idObj) as NSString
        }
        
        self.cropTypeId = (Validations.checkKeyNotAvail(dict, key: "cropTypeId") as? NSString ?? "")
        if let idObj = dict.value(forKey: "cropTypeId") as? CGFloat {
            self.cropTypeId = String(format: "%f",idObj) as NSString
        }
        
        self.cropPhaseID = (Validations.checkKeyNotAvail(dict, key: "cropPhaseID") as? NSString ?? "")
        
        if let idObj = dict.value(forKey: "cropPhaseID") as? Int {
            self.cropPhaseID = String(format: "%d",idObj) as NSString
        }
    }
    
    
}



open class GrowthCASubPhasesDetailBO: NSObject {
    @objc var localLanguageMessage: NSString?
    @objc var stage: NSString?
    @objc var voiceFileName :NSString?
    @objc var hybridName :NSString?
    
    @objc var cropName :NSString?
    @objc var englishMessage :NSString?
    @objc var thumImageName : NSString?
    var isPlaying :Bool = false
    @objc var startDate :NSString?
    @objc var endDate : NSString?
    @objc var caStageId : NSString?
    @objc var endThumbImage : NSString?
    @objc var startThumbImage : NSString?
    @objc var imageTitle : NSString?
    @objc var expectedDate : NSString?
    
    /* var noOfDays: NSString?
     var message: NSString
     var messageInLocalLang: NSString
     var messageId: Int
     var voiceFileURL: NSString
     var sentOn : NSString?
     var stageName : NSString?
     var supposeToBeOn : NSString?
     var isPlaying :Bool = false*/
    //@objc var englishMessage :NSString?
    
    
    public  init(dict : NSDictionary){
        print(dict)
        self.caStageId = (Validations.checkKeyNotAvail(dict, key: "caStageId") as? NSString ?? "")
        if let idObj = dict.value(forKey: "caStageId") as? Int {
            self.caStageId = String(format: "%d",idObj) as NSString
        }
        self.imageTitle = (Validations.checkKeyNotAvail(dict, key: "imageTitle") as? NSString ?? "")
        self.localLanguageMessage = (Validations.checkKeyNotAvail(dict, key: "localLanguageMessage") as? NSString ?? "")
        self.stage = (Validations.checkKeyNotAvail(dict, key: "stage") as? NSString ?? "")
        self.voiceFileName = (Validations.checkKeyNotAvail(dict, key: "voiceFileName") as? NSString ?? "")
        self.cropName = (Validations.checkKeyNotAvail(dict, key: "cropName") as? NSString ?? "")
        self.englishMessage = (Validations.checkKeyNotAvail(dict, key: "englishMessage") as? NSString ?? "")
        self.thumImageName = (Validations.checkKeyNotAvail(dict, key: "thumbImage") as? NSString ?? "")
        self.startThumbImage = (Validations.checkKeyNotAvail(dict, key: "startThumbImage") as? NSString ?? "")
        self.endThumbImage = (Validations.checkKeyNotAvail(dict, key: "endThumbImage") as? NSString ?? "")
        self.hybridName = (Validations.checkKeyNotAvail(dict, key: "hybridName") as? NSString ?? "")
        
        
        
        let str = (Validations.checkKeyNotAvail(dict, key: "stageDate") as? NSString)
        if (str ?? "" ).contains("day") || (str ?? "" ).contains("days") || (str ?? "" ).contains("back") || (str ?? "" ).contains("now") {
            self.startDate = (Validations.checkKeyNotAvail(dict, key: "stageDate") as? NSString ?? "")
        }else{
            if let sentOnStr = Validations.checkKeyNotAvail(dict, key: "stageDate") as? NSString{
                let dateArr = sentOnStr.components(separatedBy: " ") as NSArray
                let dateObj2 = dateArr.object(at: 0)
                print(dateObj2)
                
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "dd-MMM-yyyy"
                if Validations.isNullString(dateObj2 as! NSString) == false{
                    
                    let date: NSDate? = dateFormatterGet.date(from: dateObj2 as? String ?? "") as? NSDate ?? NSDate()
                    print(dateFormatterPrint.string(from: date! as Date))
                    self.startDate = dateFormatterPrint.string(from: date as Date? ?? Date()) as NSString
                }
            }
        }
        
        let strExpected = (Validations.checkKeyNotAvail(dict, key: "expectedDate") as? NSString)
        if (strExpected ?? "" ).contains("day") || (strExpected ?? "" ).contains("days") || (strExpected ?? "" ).contains("back") || (strExpected ?? "" ).contains("now") || (strExpected ?? "" ).contains("sowing") || (strExpected ?? "" ).contains("date") {
            self.expectedDate = (Validations.checkKeyNotAvail(dict, key: "expectedDate") as? NSString ?? "")
        }else{
            if let sentOnStr = Validations.checkKeyNotAvail(dict, key: "expectedDate") as? NSString{
                let dateArr = sentOnStr.components(separatedBy: " ") as NSArray
                let dateObj2 = dateArr.object(at: 0)
                print(dateObj2)
                
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "dd-MMM-yyyy"
                if Validations.isNullString(dateObj2 as! NSString) == false{
                    let date: NSDate? = dateFormatterGet.date(from: dateObj2 as? String ?? "") as? NSDate ?? NSDate()
                    print(dateFormatterPrint.string(from: date! as Date))
                    self.expectedDate = dateFormatterPrint.string(from: date as Date? ?? Date()) as NSString
                }
            }
        }
        
    }
    
    
}

