//
//  RewardsServiceCall.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 26/09/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import UIKit
import Alamofire

class RewardsServiceCall: NSObject {

    class func getTransactionUserRewardsDetails(completionHandler:@escaping (_ status:Bool?,_ dictionary: NSDictionary?,_ message:NSString?)-> Void){
        
        SwiftLoader.show(animated: true)
        let headers = Constatnts.getLoggedInFarmerHeaders()
        
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,Get_User_Rewards])
        
        Alamofire.request(urlString, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
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
            }
            else{
                print((response.error?.localizedDescription) ?? "")
                completionHandler(false,NSDictionary(),"Unknown error occurred")
            }
        }
    }
}
