//
//  CashFreeSingletonClass.swift
//  FarmerConnect
//
//  Created by Apple on 11/09/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import UIKit
import Alamofire

class CashFreeSingletonClass: NSObject {
    
    class func submitDetailsToServerAndGetTransactionStatus(dictionary: NSDictionary, completionHandler:@escaping (_ status:Bool?,_ dictionary: NSDictionary?,_ message:NSString?)-> Void){
      
        SwiftLoader.show(animated: true)
        let headers = Constatnts.getLoggedInFarmerHeaders()

        let paramsStr = Constatnts.nsobjectToJSON(dictionary as NSDictionary)
        let params =  ["data" : paramsStr]
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,CASH_FREE_PAYMENTMODE_REQUEST]) // "http://192.168.3.141:8080/ATP/rest/"
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    print(json)
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
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
    
    class func submitDetailsToServerAndGetTransactionStatusEcoupon(dictionary: NSDictionary, completionHandler:@escaping (_ status:Bool?,_ dictionary: NSDictionary?,_ message:NSString?)-> Void){
         
           SwiftLoader.show(animated: true)
           let headers = Constatnts.getLoggedInFarmerHeaders()

           let paramsStr = Constatnts.nsobjectToJSON(dictionary as NSDictionary)
           let params =  ["data" : paramsStr]
           let urlString:String = String(format: "%@%@", arguments: [BASE_URL,CASH_FREE_ECOUPON_PAYMENTMODE_REQUEST]) // "http://192.168.3.141:8080/ATP/rest/"
           
           Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
               SwiftLoader.hide()
               if response.result.error == nil {
                   if let json = response.result.value {
                       print(json)
                       let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                       if responseStatusCode == STATUS_CODE_200{
                           let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
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
    class func submitDetailsToServerAndGetTransactionStatusSeed(dictionary: NSDictionary, completionHandler:@escaping (_ status:Bool?,_ dictionary: NSDictionary?,_ message:NSString?)-> Void){
      
        SwiftLoader.show(animated: true)
        let headers = Constatnts.getLoggedInFarmerHeaders()

        let paramsStr = Constatnts.nsobjectToJSON(dictionary as NSDictionary)
        let params =  ["data" : paramsStr]
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,CASH_FREE_PAYMENTMODE_REQUEST_SEED]) // "http://192.168.3.141:8080/ATP/rest/"
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    print(json)
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
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
}
