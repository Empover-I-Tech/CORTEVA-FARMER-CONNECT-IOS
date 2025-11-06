//
//  cepJourneySingleton.swift
//  FarmerConnect
//
//  Created by EMPOVER-049 on 06/08/21.
//  Copyright © 2021 ABC. All rights reserved.
//

import Foundation
import Alamofire

class cepJourneySingletonClass: NSObject {
    
    //MARK:- DASHBOARD CEP
    
    class func getFarmerCEPDashboardDetails(dictionary: NSDictionary, completionHandler:@escaping (_ status:Bool?,_ dictionary: NSDictionary?,_ message:NSString?)-> Void){
  
    SwiftLoader.show(animated: true)
    let headers = Constatnts.getLoggedInFarmerHeaders()
        print(headers)
        print("=======")

    let paramsStr = Constatnts.nsobjectToJSON(dictionary as NSDictionary)
    let params =  ["data" : paramsStr]
        print(params)
    let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_CEP_DASHBOARD_DETAILS]) // "http://192.168.3.141:8080/ATP/rest/"
    
    Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
        SwiftLoader.hide()
        print(response)
        if response.result.error == nil {
            if let json = response.result.value {
               
                let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                if responseStatusCode == STATUS_CODE_200{
                    let respData = (json as! NSDictionary).value(forKey: "response") as? NSString ?? ""
                    let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                
                  
                    let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString)
                    completionHandler(true,decryptData,msg)
                }
                else if responseStatusCode == STATUS_CODE_601{
                    Constatnts.logOut()
                    if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                        print(msg)
                    }
                }
                else {
                    if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                        completionHandler(false, NSDictionary(),msg )
                    }
                }
            }
            else{
                completionHandler(false,NSDictionary(),"Unknown error occurred")
            }
        }
        else{
            print((response.error?.localizedDescription) ?? "")
            completionHandler(false,NSDictionary(),"Unknown error occurred")
        }
    }
}
    
    class func getCEPDashboardMore(dictionary: NSDictionary, completionHandler:@escaping (_ status:Bool?,_ dictionary: NSDictionary?,_ message:NSString?)-> Void){
    print("Inside CEP")
    SwiftLoader.show(animated: true)
    let headers = Constatnts.getLoggedInFarmerHeaders()
        print(headers)
        print("=======")

    let paramsStr = Constatnts.nsobjectToJSON(dictionary as NSDictionary)
    let params =  ["data" : paramsStr]
        print(params)
    let urlString:String = String(format: "%@%@", arguments: [BASE_URL,CEP_DASHBOARDMORE_API]) // "http://192.168.3.141:8080/ATP/rest/"
    
    Alamofire.request(urlString, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
        SwiftLoader.hide()
        print("RESPONSEEEE CEP")
        print(response)
        if response.result.error == nil {
            if let json = response.result.value {
               
                let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                if responseStatusCode == STATUS_CODE_200{
                    let respData = (json as! NSDictionary).value(forKey: "response") as? NSString ?? ""
                    let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                
                  
                    let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString)
                    completionHandler(true,decryptData,msg)
                }
                else if responseStatusCode == STATUS_CODE_601{
                    Constatnts.logOut()
                    if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                        print(msg)
                    }
                }
                else {
                    if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                        completionHandler(false, NSDictionary(),msg )
                    }
                }
            }
            else{
                completionHandler(false,NSDictionary(),"Unknown error occurred")
            }
        }
        else{
            print((response.error?.localizedDescription) ?? "")
            completionHandler(false,NSDictionary(),"Unknown error occurred")
        }
    }
}
    
    
    
    //MARK:- REFERRAL SCREEN API
    
    class func submitReferralDetails(dictionary: NSDictionary, completionHandler:@escaping (_ status:Bool?,_ dictionary: NSDictionary?,_ message:NSString?)-> Void){
  
    SwiftLoader.show(animated: true)
    let headers = Constatnts.getLoggedInFarmerHeaders()
        print(headers)
        print("=======")

    let paramsStr = Constatnts.nsobjectToJSON(dictionary as NSDictionary)
    let params =  ["data" : paramsStr]
        print(params)
    let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_CEP_FARMERREERAL]) // "http://192.168.3.141:8080/ATP/rest/"
    
    Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
        SwiftLoader.hide()
        print(response)
        if response.result.error == nil {
            if let json = response.result.value {
               
                let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                if responseStatusCode == STATUS_CODE_200{
                    let respData = (json as! NSDictionary).value(forKey: "response") as?  NSString ?? ""
                  //  let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                
                  
                    let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString)
                    completionHandler(true,[:],msg)
                }
                else if responseStatusCode == STATUS_CODE_601{
                    Constatnts.logOut()
                    if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                        print(msg)
                    }
                }
                else {
                    if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                        completionHandler(false, NSDictionary(),msg )
                    }
                }
            }
            else{
                completionHandler(false,NSDictionary(),"Unknown error occurred")
            }
        }
        else{
            print((response.error?.localizedDescription) ?? "")
            completionHandler(false,NSDictionary(),"Unknown error occurred")
        }
    }
}
    
     //MARK:- REFERRAL SCREEN API
        
        class func submitretailerMobileCashfree(dictionary: NSDictionary, completionHandler:@escaping (_ status:Bool?,_ dictionary: NSDictionary?,_ message:NSString?)-> Void){
      
        SwiftLoader.show(animated: true)
        let headers = Constatnts.getLoggedInFarmerHeaders()
            print(headers)
            print("=======")

        let paramsStr = Constatnts.nsobjectToJSON(dictionary as NSDictionary)
        let params =  ["data" : paramsStr]
            print(params)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,CASH_FREE_RETAILER_MOBILE]) // "http://192.168.3.141:8080/ATP/rest/"
        
            Alamofire.request(urlString, method: .post, parameters: dictionary as? Parameters ?? [:], encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            print(response)
            if response.result.error == nil {
                if let json = response.result.value {
                   
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as?  NSString ?? ""
                      //  let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                    
                      
                        let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString)
                        completionHandler(true,[:],msg)
                    }
                    else if responseStatusCode == STATUS_CODE_601{
                        Constatnts.logOut()
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            print(msg)
                        }
                    }
                    else {
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            completionHandler(false, NSDictionary(),msg )
                        }
                    }
                }
                else{
                    completionHandler(false,NSDictionary(),"Unknown error occurred")
                }
            }
            else{
                print((response.error?.localizedDescription) ?? "")
                completionHandler(false,NSDictionary(),"Unknown error occurred")
            }
        }
    }
    
    //PESTDiesease master
    //MARK:- DASHBOARD CEP
    
    class func getPestDieaseMaster(dictionary: NSDictionary, completionHandler:@escaping (_ status:Bool?,_ dictionary: NSDictionary?,_ message:NSString?)-> Void){
  
    SwiftLoader.show(animated: true)
    let headers = Constatnts.getLoggedInFarmerHeaders()
        print(headers)
        print("=======")

    let paramsStr = Constatnts.nsobjectToJSON(dictionary as NSDictionary)
    let params =  ["data" : paramsStr]
        print(params)
    let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_CEP_PEST_DOWNLOADMASTER]) // "http://192.168.3.141:8080/ATP/rest/"
    
    Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
        SwiftLoader.hide()
        print(response)
        if response.result.error == nil {
            if let json = response.result.value {
               
                let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                if responseStatusCode == STATUS_CODE_200{
                    let respData = (json as! NSDictionary).value(forKey: "response") as? NSString ?? ""
                    let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                
                  
                    let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString)
                    completionHandler(true,decryptData,msg)
                }
                else if responseStatusCode == STATUS_CODE_601{
                    Constatnts.logOut()
                    if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                        print(msg)
                    }
                }
                else {
                    if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                        completionHandler(false, NSDictionary(),msg )
                    }
                }
            }
            else{
                completionHandler(false,NSDictionary(),"Unknown error occurred")
            }
        }
        else{
            print((response.error?.localizedDescription) ?? "")
            completionHandler(false,NSDictionary(),"Unknown error occurred")
        }
    }
}
    
    class func getFarmerRHRDDashboardDetails(dictionary: NSDictionary, completionHandler:@escaping (_ status:Bool?,_ dictionary: NSDictionary?,_ message:NSString?)-> Void){
  
    SwiftLoader.show(animated: true)
    let headers = Constatnts.getLoggedInFarmerHeaders()
        print(headers)
        print("=======")

    let paramsStr = Constatnts.nsobjectToJSON(dictionary as NSDictionary)
    let params =  ["data" : ""]//paramsStr
        print(params)
    let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_RHRD_HOMEPAGE_DETAILS]) // "http://192.168.3.141:8080/ATP/rest/"
    
    Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
        SwiftLoader.hide()
        
        print("RHRD ======================== RHRD")
        print(response)
        if response.result.error == nil {
            if let json = response.result.value {
               
                let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                if responseStatusCode == STATUS_CODE_200{
                    let respData = (json as! NSDictionary).value(forKey: "response") as? NSString ?? ""
                    let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                
                  
                    let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString)
                    completionHandler(true,decryptData,msg)
                }
                else if responseStatusCode == STATUS_CODE_601{
                    Constatnts.logOut()
                    if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                        print(msg)
                    }
                }
                else {
                    if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                        completionHandler(false, NSDictionary(),msg )
                    }
                }
            }
            else{
                completionHandler(false,NSDictionary(),"Unknown error occurred")
            }
        }
        else{
            print((response.error?.localizedDescription) ?? "")
            completionHandler(false,NSDictionary(),"Unknown error occurred")
        }
    }
}
    
    class func getRHRDDashboardMore(dictionary: NSDictionary, completionHandler:@escaping (_ status:Bool?,_ dictionary: NSDictionary?,_ message:NSString?)-> Void){
  
    SwiftLoader.show(animated: true)
    let headers = Constatnts.getLoggedInFarmerHeaders()
        print(headers)
        print("=======")

    let paramsStr = Constatnts.nsobjectToJSON(dictionary as NSDictionary)
    let params =  ["data" : paramsStr]
        print(params)
    let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_RHRD_TOTALACTIVITIES_DASHBOARD]) // "http://192.168.3.141:8080/ATP/rest/"
    
    Alamofire.request(urlString, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
        SwiftLoader.hide()
        print("RHRD\(response)")
        if response.result.error == nil {
            if let json = response.result.value {
               
                let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                if responseStatusCode == STATUS_CODE_200{
                    let respData = (json as! NSDictionary).value(forKey: "response") as? NSString ?? ""
                    let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                
                  
                    let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString)
                    completionHandler(true,decryptData,msg)
                }
                else if responseStatusCode == STATUS_CODE_601{
                    Constatnts.logOut()
                    if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                        print(msg)
                    }
                }
                else {
                    if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                        completionHandler(false, NSDictionary(),msg )
                    }
                }
            }
            else{
                completionHandler(false,NSDictionary(),"Unknown error occurred")
            }
        }
        else{
            print((response.error?.localizedDescription) ?? "")
            completionHandler(false,NSDictionary(),"Unknown error occurred")
        }
    }
}
    
    //MARK:- REFERRAL SCREEN API
    
    class func submitReferralDetailsRHRD(dictionary: NSDictionary, completionHandler:@escaping (_ status:Bool?,_ dictionary: NSDictionary?,_ message:NSString?)-> Void){
  
    SwiftLoader.show(animated: true)
    let headers = Constatnts.getLoggedInFarmerHeaders()
        print(headers)
        print("=======")

    let paramsStr = Constatnts.nsobjectToJSON(dictionary as NSDictionary)
    let params =  ["data" : paramsStr]
        print(params)
    let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_RHRD_REFERAL_DETAILS]) // "http://192.168.3.141:8080/ATP/rest/"
    
    Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
        SwiftLoader.hide()
        print(response)
        if response.result.error == nil {
            if let json = response.result.value {
               
                let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                if responseStatusCode == STATUS_CODE_200{
                    let respData = (json as! NSDictionary).value(forKey: "response") as?  NSString ?? ""
                  //  let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                
                  
                    let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString)
                    completionHandler(true,[:],msg)
                }
                else if responseStatusCode == STATUS_CODE_601{
                    Constatnts.logOut()
                    if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                        print(msg)
                    }
                }
                else {
                    if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                        completionHandler(false, NSDictionary(),msg )
                    }
                }
            }
            else{
                completionHandler(false,NSDictionary(),"Unknown error occurred")
            }
        }
        else{
            print((response.error?.localizedDescription) ?? "")
            completionHandler(false,NSDictionary(),"Unknown error occurred")
        }
    }
}
    


}
