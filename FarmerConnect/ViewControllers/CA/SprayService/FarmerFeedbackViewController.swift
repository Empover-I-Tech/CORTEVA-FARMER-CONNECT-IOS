//
//  FarmerFeedbackViewController.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 09/09/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import UIKit
import Alamofire


class FarmerFeedbackViewController: BaseViewController {
    @IBOutlet weak var btnGood : UIButton!
     @IBOutlet weak var btnBad : UIButton!
     @IBOutlet weak var btnAverage : UIButton!
    
    @IBOutlet weak var farmerTopImage : UIImageView!
     @IBOutlet weak var farmerNameLabel : UILabel!
     @IBOutlet weak var farmerCropeLabel : UILabel!
     @IBOutlet weak var farmerNoOfAcresLabel : UILabel!
     @IBOutlet weak var farmerMobileLabel : UILabel!
     @IBOutlet weak var farmerAddressLabel : UILabel!
    
    @IBOutlet weak var FeedbackReviewTextView : UITextView!
    @IBOutlet weak var farmerView : UIView!
    @IBOutlet weak var FeedbackView : UIView!
    @IBOutlet weak var submitButton : UIButton!
    @IBOutlet weak var scrollView : UIScrollView!
    var taskID : String = ""
    var recordID : Int?
       var rating : String = ""
       var vendorMobilNumber : String = ""
       var vendorName : String = ""
       var noOfAcres : Int = 0
       var sprayedAcres : Int = 0
    var status = ""
   var  isGood: Bool = false
     var  isBad: Bool = false
     var  isAverage: Bool = false
    var cropID : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFromDeeplink == true {
            self.getRequesterFarmerDetails()
        }else {
        self.farmerNameLabel.text = self.vendorName
              self.farmerNoOfAcresLabel.text = "\(self.noOfAcres)"
              self.farmerMobileLabel.text = self.vendorMobilNumber
              self.farmerAddressLabel.text = "\(self.sprayedAcres)"
        }
        //self.getVendorFarmerDetails()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.topView?.isHidden = false
        self.lblTitle?.text = "Feedback"
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
    }
    func getRequesterFarmerDetails(){
        let urlString = BASE_URL + GET_DATA_REQUESTOR_BASEDON_TASKID
        let params = ["id": taskID]
        let userObj = Constatnts.getUserObject()
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        
        let paramsStr = Constatnts.nsobjectToJSON(params as NSDictionary)
                   let params1 =  ["data" : paramsStr]
        
                Alamofire.request(urlString, method: .post, parameters: params1, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                    
                    SwiftLoader.hide()
                    if response.result.error == nil {
                        if let json = response.result.value {
                            let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String
        //                      let responseMessage  = (json as! NSDictionary).value(forKey: "message") as! String
                            if responseStatusCode == "200"{
                                let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                                let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                                print("Response after decrypting data:\(decryptData)")
//                                @IBOutlet weak var farmerTopImage : UIImageView!
//                                  @IBOutlet weak var farmerNameLabel : UILabel!
//                                  @IBOutlet weak var farmerCropeLabel : UILabel!
//                                  @IBOutlet weak var farmerNoOfAcresLabel : UILabel!
//                                  @IBOutlet weak var farmerMobileLabel : UILabel!
//                                  @IBOutlet weak var farmerAddressLabel : UILabel!
                                self.farmerNameLabel.text = decryptData.value(forKey: "vendorName") as? String
                                self.farmerNoOfAcresLabel.text = decryptData.value(forKey: "noOfAcres") as? String
                                self.farmerMobileLabel.text = decryptData.value(forKey: "vendorMobileNumber") as? String
                                self.farmerAddressLabel.text = decryptData.value(forKey: "sprayedAcres") as? String
                        }
                    }
                }
    }
    }
    @IBAction func btnGoodAction(_ sender  : UIButton) {
  self.isGood = true
                self.isBad =  false
                self.isAverage = false
        
        
                    let goodImage = UIImageView()
                    goodImage.image = UIImage(named: "radio")?.withRenderingMode(.alwaysTemplate)
        goodImage.tintColor = UIColor(hexString: "#3191F3")
                    sender.setImage(goodImage.image, for: .normal)
        
        
                 let badImage = UIImageView()
                badImage.image = UIImage(named: "radioEmpty")?.withRenderingMode(.alwaysTemplate)
        badImage.tintColor = UIColor(hexString: "#3191F3")
                self.btnBad.setImage(badImage.image, for: .normal)
        
                 let averageImage = UIImageView()
                      averageImage.image = UIImage(named: "radioEmpty")?.withRenderingMode(.alwaysTemplate)
        averageImage.tintColor = UIColor(hexString: "#3191F3")
                      self.btnAverage.setImage(averageImage.image, for: .normal)
    }
    
    
    @IBAction func btnAverageAction(_ sender  : UIButton) {

        
           self.isGood = false
                self.isBad =  false
                self.isAverage = true
                         let goodImage = UIImageView()
                            goodImage.image = UIImage(named: "radio")?.withRenderingMode(.alwaysTemplate)
                goodImage.tintColor = UIColor(hexString: "#3191F3")
                            sender.setImage(goodImage.image, for: .normal)
                let badImage = UIImageView()
                        badImage.image = UIImage(named: "radioEmpty")?.withRenderingMode(.alwaysTemplate)
                        badImage.tintColor = UIColor(hexString: "#3191F3")
                        self.btnGood.setImage(badImage.image, for: .normal)
        
                         let averageImage = UIImageView()
                              averageImage.image = UIImage(named: "radioEmpty")?.withRenderingMode(.alwaysTemplate)
                              averageImage.tintColor = UIColor(hexString: "#3191F3")
                              self.btnBad.setImage(averageImage.image, for: .normal)
    }
    
    
    @IBAction func btnBadAction(_ sender  : UIButton) {
      
        
                self.isGood = false
                self.isBad =  true
                self.isAverage = false
                 let goodImage = UIImageView()
                                           goodImage.image = UIImage(named: "radio")?.withRenderingMode(.alwaysTemplate)
                               goodImage.tintColor = UIColor(hexString: "#3191F3")
                                           sender.setImage(goodImage.image, for: .normal)
        
                let badImage = UIImageView()
                 badImage.image = UIImage(named: "radioEmpty")?.withRenderingMode(.alwaysTemplate)
                 badImage.tintColor = UIColor(hexString: "#3191F3")
                 self.btnGood.setImage(badImage.image, for: .normal)
        
                  let averageImage = UIImageView()
                       averageImage.image = UIImage(named: "radioEmpty")?.withRenderingMode(.alwaysTemplate)
                       averageImage.tintColor = UIColor(hexString: "#3191F3")
                       self.btnAverage.setImage(averageImage.image, for: .normal)
        
        
    }

 @IBAction func btnFeedbackSubmission(_ sender  : UIButton) {
    
            let urlString:String = String(format: "%@%@", arguments: [BASE_URL,Spray_REQUESTER_FEEDBACK_SUBMISSION])
            //lastUpdatedTime
            let userObj = Constatnts.getUserObject()
            let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                        "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                        "mobileNumber": userObj.mobileNumber! as String,
                                        "customerId": userObj.customerId! as String,
                                        "deviceId": userObj.deviceId! as String]
       let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? NSString
    
    if isGood == true {
                 self.rating = "good"
             }else if isBad == true {
                 self.rating = "bad"
             }else {
                 self.rating = "average"
             }
             

    let parameters : Parameters = ["customerId" : userObj.customerId ?? ""  , "deviceId" : userObj.deviceId ?? ""  , "deviceType" :  userObj.deviceType , "mobileNumber" : userObj.mobileNumber ?? "" , "userType" : "Farmer" , "versionName" : version ?? "" , "rating" : self.rating , "remarks" : self.FeedbackReviewTextView.text ?? "" , "id" : taskID ?? "" ]
    
            let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
            let params =  ["data" : paramsStr]
            Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
               SwiftLoader.hide()
                if response.result.error == nil {
                    if let json = response.result.value {
                        //print("Response :\(json)")
                        let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                        if responseStatusCode == STATUS_CODE_200{
                             let feedbackMSg = NSLocalizedString( "Requester_Feedback_Message",comment:"")
                            let alert = UIAlertController(title: "Alert", message: feedbackMSg, preferredStyle: .alert)
                            let alertAction  = UIAlertAction(title: "Alert", style: .default) { (alert) in
                                self.navigationController?.popViewController(animated: true)
                            }
                            alert.addAction(alertAction)
                         self.showErrorAlert(alertMessage: feedbackMSg)
                        }else {
                             self.view.makeToast("something went wrong")
                        }
                    }
                }
            }
}

}
extension FarmerFeedbackViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.FeedbackReviewTextView.text = ""
    }
}
