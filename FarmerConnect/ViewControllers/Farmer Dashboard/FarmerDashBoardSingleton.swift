//
//  FarmerDashBoardSingleton.swift
//  PioneerEmployee
//
//  Created by Admin on 13/08/19.
//  Copyright © 2019 Empover. All rights reserved.
//

import UIKit
import Alamofire

class FarmerDashBoardSingleton: NSObject {
    static var filterSuccessHandler :((Bool,NSDictionary,String) -> Void)?
    
    class func getFilteredDataForAddProduct(accessLevel:String,id:String){
        let commonParams = FarmerDashBoardSingleton.farmerDashBoardCommonParameters()
        
        let finalParamsDic = NSMutableDictionary()
        finalParamsDic.addEntries(from: commonParams as! [AnyHashable : Any])
        finalParamsDic.setValue(["accessLevel":accessLevel,"id":id], forKey: "filterRequest")
        let paramsStr1 = Constatnts.nsobjectToJSON(finalParamsDic as NSDictionary)
        let finalParameters =  ["data": paramsStr1] as [String : Any]
        
        SwiftLoader.show(animated: true)
        print(finalParameters)
        let headers = Constatnts.getLoggedInFarmerHeaders()
        
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,FARMER_ADD_PRODUCT])
        
        Alamofire.request(urlString, method: .post, parameters: finalParameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            //SwiftLoader.hide()
            SwiftLoader.hide()
            if response.result.error == nil{
                if let json = response.result.value {
                    //print(json)
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: JAVA_RESPONSE_DATA_KEY) as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        
                        let dictResult = NSMutableDictionary(dictionary: decryptData )
                        //print(outputDict)
                        self.filterSuccessHandler!(true,dictResult,"")
                    }
                    else{
                        self.filterSuccessHandler!(false,NSDictionary(),"Error catch occurred")
                    }
                }
                else{
                    self.filterSuccessHandler!(false,NSDictionary(),"Error catch occurred")
                }
            }
            else{
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                appDelegate?.window?.makeToast((response.result.error?.localizedDescription)!)
                self.filterSuccessHandler!(false,NSDictionary(),(response.result.error?.localizedDescription)!)
            }
        }

    }
    
    class func farmerDashBoardCommonParameters() -> NSDictionary
    {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? NSString
        let headers = Constatnts.getLoggedInFarmerHeaders()
        
//        let loginDecodedData = UserDefaults.standard.value(forKey: "LoginDecodedData") as! NSDictionary
        var userId = ""
        if let customerId = headers["customerId"] as String? {
            userId = customerId
        }
        
        var mobileNumber = ""
        
        if let customerId = headers["mobileNumber"] as String? {
            mobileNumber = customerId
        }
        
        var geoLocation = ""
        if let currentLocation = LocationService.sharedInstance.currentLocation as CLLocation?{
            if let coordinates = currentLocation.coordinate as CLLocationCoordinate2D?{
                geoLocation = String(format: "%f,%f", coordinates.latitude,coordinates.longitude)
            }
        }//BaseViewController.getMobileNumber()//"7702277392"
        let parameters = ["mobileNumber": mobileNumber,"versionName":version,"empId":userId,"deviceType":DEVICE_TYPE,"geoLocation":geoLocation] as NSDictionary
        return parameters
    }
    
    
    
    
    class func getCompleteFarmerDetailsBasedOnFarmerMobileNumber(mobileNumber : String, completionHandler:@escaping (_ status:Bool?, _ response: NSMutableDictionary?, _ message:String?)-> Void){
        
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,FARMER_DETAILS_BASED_ON_MOBILE])
        
        let dict = ["mobileNumber" : mobileNumber]
        
        let paramsStr1 = Constatnts.nsobjectToJSON(dict as NSDictionary)
        
        let params =  ["data": paramsStr1]
        print("params ",params)
        SwiftLoader.show(animated: true)
        let headers = Constatnts.getLoggedInFarmerHeaders()
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            //  DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            if let json = response.result.value {
                
                print("Response :\(json)")
                
                let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                if responseStatusCode == STATUS_CODE_200{
                    let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                    let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                    let dictResult = NSMutableDictionary(dictionary: decryptData )
                    completionHandler(true,dictResult , "Success")

                }
                else{
                    completionHandler(false,NSMutableDictionary(),"Error catch occurred")
                }
            }
            else{
                completionHandler(false,NSMutableDictionary(),"Error catch occurred")
            }
        }
    }
    
    
    class func getFarmerDashboardActivitiesTimeLine(dictParameter : NSDictionary?, completionHandler:@escaping (_ status:Bool?, _ response: NSDictionary?, _ message:String?)-> Void){
        
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,FARMER_ACTIVITY_TIMELINE])
        
        let paramsStr1 = Constatnts.nsobjectToJSON(dictParameter ?? NSDictionary())
        
        let params =  ["data": paramsStr1]
        print("params %@",params)
        SwiftLoader.show(animated: true)
        
        let headers = Constatnts.getLoggedInFarmerHeaders()
        
        print("headers : \(headers)")
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            
            if let json = response.result.value {
                
                print("Response :\(json)")
                let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                if responseStatusCode == STATUS_CODE_200{
                    let respData = ((json as! NSDictionary).value(forKey: "response") as! NSString)
                    let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                    let dictResult = NSMutableDictionary(dictionary: decryptData )
                    if dictResult.object(forKey: "graphview") != nil{
                        let dictNewResult = dictResult.object(forKey: "graphview") as? NSDictionary ?? NSDictionary()
                        completionHandler(true,dictNewResult , "Success")
                    }
                }
            }
            else{
                completionHandler(false,NSDictionary(),"Error catch occurred")
            }
        }
        
    }

    class func saveFarmerBoughtProductData( dic : NSDictionary,completionHandler:@escaping (_ status:Bool?, _ response: NSDictionary?, _ message:String?)-> Void){
        //print(parameters)
        
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,FARMER_SAVE_PRODUCT])
        
        let headers = Constatnts.getLoggedInFarmerHeaders()
        let paramsStr1 = Constatnts.nsobjectToJSON(dic ?? NSDictionary())
        
        print("headers : \(headers)")
        
        let params =  ["data": paramsStr1]
        print("params %@",params)
        SwiftLoader.show(animated: true)
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            
            //  DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            if response.result.error == nil{
                if let json = response.result.value {
                    //print(json)
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        completionHandler(true,NSDictionary(),"Product added successfully")
                    }
                    else{
                        completionHandler(false,NSDictionary(),"Error catch occurred")
                    }
                }
                else{
                    completionHandler(false,NSDictionary(),"Error catch occurred")
                }
            }
            else{
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                appDelegate?.window?.makeToast((response.result.error?.localizedDescription)!)
                completionHandler(false,NSDictionary(),(response.result.error?.localizedDescription)!)
            }
        }
    }
}




