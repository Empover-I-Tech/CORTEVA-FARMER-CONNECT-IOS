//
//  UserLogEvents.swift
//  FarmerConnect
//
//  Created by Empover i-Tech on 02/03/23.
//  Copyright © 2023 ABC. All rights reserved.
//

import Foundation
import Alamofire

class userLogEventsSingletonClass: NSObject {
    
    class func sendUserLogEventsDetailsToServer(dictionary: NSDictionary, completionHandler:@escaping (_ status:Bool?,_ message:NSString?)-> Void){
        
    let headers = Constatnts.getLoggedInFarmerHeaders()
    let paramsStr = Constatnts.nsobjectToJSON(dictionary as NSDictionary)
    let params =  ["data" : paramsStr]
    let urlString:String = String(format: "%@%@", arguments: [BASE_URL,SAVE_USER_LOG_EVENTS_MODULEWISE])
    
    Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
        SwiftLoader.hide()
        print(response)
        if response.result.error == nil {
            if let json = response.result.value {
               
                let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                if responseStatusCode == STATUS_CODE_200{
                    let respData = (json as! NSDictionary).value(forKey: "response") as? NSString ?? ""
                
                  
                    let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString)
                    completionHandler(true,msg)
                }
                else if responseStatusCode == STATUS_CODE_601{
                    Constatnts.logOut()
                    if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                        print(msg)
                    }
                }
                else {
                    if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                        completionHandler(false,msg )
                    }
                }
            }
            else{
                completionHandler(false,"Unknown error occurred")
            }
        }
        else{
            print((response.error?.localizedDescription) ?? "")
            completionHandler(false,"Unknown error occurred")
        }
    }
}

}
