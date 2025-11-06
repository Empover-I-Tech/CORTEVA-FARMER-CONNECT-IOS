//
//  GerminationSingleton.swift
//  FarmerConnect
//
//  Created by Empover on 24/07/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit
import Alamofire

class GerminationServiceManager: NSObject {

    //MARK: Shared Instance
    static let sharedInstance : GerminationServiceManager = {
        let instance = GerminationServiceManager()
        return instance
    }()
    
    //MARK: getGerminationList
    class func getGerminationList(completionHandler:@escaping (_ status:Bool?,_ responseDict:NSDictionary?,_ errorMsg:String?)->Void){
        SwiftLoader.show(animated: true)
        let userObj = Constatnts.getUserObject()
        let headers = Constatnts.getLoggedInFarmerHeaders()
        let parameters = ["mobileNumber": userObj.mobileNumber! as String] as NSDictionary
        //print(parameters)
        let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
        let params =  ["data" : paramsStr]
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_GERMINATION_LIST])

        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print(json)
                    if let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String{
                        if responseStatusCode == STATUS_CODE_200{
                            if let respData = (json as! NSDictionary).value(forKey: "response") as? NSString{
                                let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                                //print(decryptData)
                                let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString)
                                completionHandler(true,decryptData,msg as String? ?? "")
                            }
                        }
                        else if responseStatusCode == STATUS_CODE_601{
                            Constatnts.logOut()
                        }
                        else{
                            if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                completionHandler(false,NSDictionary(),msg as String)
                            }
                        }
                    }
                }
            }
            else{
                completionHandler(false,NSDictionary(),(response.result.error?.localizedDescription)!)
            }
        }
    }
    
    //MARK: submitGerminationAgreement
    class func submitGerminationAgreement(params:NSDictionary?, completionHandler:@escaping (_ status:Bool?,_ errorMsg:String?)->Void){
        SwiftLoader.show(animated: true)
        let headers = Constatnts.getLoggedInFarmerHeaders()
        
        let paramsStr = Constatnts.nsobjectToJSON(params!)
        let params =  ["data" : paramsStr]
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,SUBMIT_GERMINATION_AGREEMENT])
    
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print(json)
                    if let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String{
                        if responseStatusCode == STATUS_CODE_200{
                            if let respData = (json as! NSDictionary).value(forKey: "response") as? NSString{
                                let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                                //print(decryptData)
                                completionHandler(true,Germination_Enrolled_Success_Msg)
                            }
                            completionHandler(true,Germination_Enrolled_Success_Msg)
                        }
                        else{
                            if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                completionHandler(false,msg as String)
                            }
                        }
                    }
                }
            }
            else{
                completionHandler(false,(response.result.error?.localizedDescription)!)
            }
        }
    }
    
    //MARK: submitGerminationClaim
    class func submitGerminationClaim(params:NSDictionary?, completionHandler:@escaping (_ status:Bool?,_ errorMsg:String?)->Void){
        SwiftLoader.show(animated: true)
        let headers = Constatnts.getLoggedInFarmerHeaders()
        
        let paramsStr = Constatnts.nsobjectToJSON(params!)
        let params =  ["data" : paramsStr]
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,SUBMIT_GERMINATION_CLAIM])
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print(json)
                    if let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String{
                        if responseStatusCode == STATUS_CODE_200{
                            if let respData = (json as! NSDictionary).value(forKey: "response") as? NSString{
                                let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                                //print(decryptData)
                                completionHandler(true,Germination_Claimed_Success_Msg)
                            }
                            if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                completionHandler(true,msg as String)
                            }
                            else{
                                completionHandler(true,Germination_Claimed_Success_Msg)
                            }
                        }
                        else{
                            if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                completionHandler(false,msg as String)
                            }
                        }
                    }
                }
            }
            else{
                completionHandler(false,(response.result.error?.localizedDescription)!)
            }
        }
    }
}
