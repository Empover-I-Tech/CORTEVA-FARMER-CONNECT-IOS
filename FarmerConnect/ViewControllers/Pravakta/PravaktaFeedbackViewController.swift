//
//  PravaktaFeedbackViewController.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 21/09/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import UIKit
import Alamofire


class PravaktaFeedbackViewController: BaseViewController , FloatRatingViewDelegate , UITextViewDelegate {

    
    var isFromHome : Bool = false
    @IBOutlet var deliveryProgramRatingView : FloatRatingView?
    @IBOutlet var evaluationOfMDRRatingView : FloatRatingView?
    @IBOutlet var evaluationOfAgronomy : FloatRatingView?
    @IBOutlet var txtViewSuggetions : UITextView?
    @IBOutlet weak var btnSubmit : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deliveryProgramRatingView?.delegate = self
              deliveryProgramRatingView?.type = .wholeRatings
              deliveryProgramRatingView?.minRating = 0
        
        evaluationOfMDRRatingView?.delegate = self
              evaluationOfMDRRatingView?.type = .wholeRatings
              evaluationOfMDRRatingView?.minRating = 0
        
        evaluationOfAgronomy?.delegate = self
              evaluationOfAgronomy?.type = .wholeRatings
              evaluationOfAgronomy?.minRating = 0
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.topView?.isHidden = false
        self.lblTitle?.text = "Pravakta Feedback"
    }
    @IBAction func btnSubmitAction(_ sender : UIButton) {
        if self.validations() == true {
            //print(headers)
            SwiftLoader.show(animated: true)
            let urlString = String(format: "%@%@", arguments: [BASE_URL,SUBMIT_PRAVAKTA_FEEDBACK])
            let userObj = Constatnts.getUserObject()
            let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                        "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                        "mobileNumber": userObj.mobileNumber! as String,
                                        "customerId": userObj.customerId! as String,
                                        "deviceId": userObj.deviceId! as String]
            
            
            let parameters : Parameters = ["delivaryProgramRate" : self.deliveryProgramRatingView?.rating ?? 0.0 , "mdrSupportRate" : self.evaluationOfMDRRatingView?.rating ?? 0.0 , "agronomyRate" : self.evaluationOfAgronomy?.rating ?? 0.0 , "suggestions" : self.txtViewSuggetions?.text  ?? "" ]
            let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
            let params =  ["data" : paramsStr]
            Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                SwiftLoader.hide()
                if response.result.error == nil {
                    if let json = response.result.value {
                        //print("Response :\(json)")
                        let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                        if responseStatusCode == STATUS_CODE_200{
                            //let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                            //let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                            //print("Response after decrypting data:\(decryptData)")
                            self.view.makeToast(Feedback_Submitted_Successfully)
                            self.navigationController?.popViewController(animated: true)
                        }
                        else{
                            if let message = (json as! NSDictionary).value(forKey: "message") as? String {
                                self.view.makeToast(message)
                            }
                        }
                    }
                }
                else{
                    self.view.makeToast((response.error?.localizedDescription)!)
                }
            }
        }
    }
  
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        //liveLabel.text = String(format: "%.2f", self.floatRatingView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        //updatedLabel.text = String(format: "%.2f", self.floatRatingView.rating)
        if  ratingView == self.deliveryProgramRatingView {
        if self.deliveryProgramRatingView!.rating == Double(1.0) || self.deliveryProgramRatingView!.rating <= Double(6.0) {
            self.deliveryProgramRatingView?.fullImage = UIImage(named: "StarRed")
        }else if self.deliveryProgramRatingView!.rating == Double(7.0) || self.deliveryProgramRatingView!.rating == Double(8.0) {
            self.deliveryProgramRatingView?.fullImage = UIImage(named: "StarOrange")
        }else if self.deliveryProgramRatingView!.rating == Double(9.0) || self.deliveryProgramRatingView!.rating == Double(10.0) {
            self.deliveryProgramRatingView?.fullImage = UIImage(named: "StarGreen")
        }
        }else if ratingView == self.evaluationOfMDRRatingView {
        if self.evaluationOfMDRRatingView!.rating == Double(1.0)  {
            self.evaluationOfMDRRatingView?.fullImage = UIImage(named: "StarRed")
        }else if self.evaluationOfMDRRatingView!.rating == Double(2.0) || self.evaluationOfMDRRatingView!.rating == Double(3.0) {
            self.evaluationOfMDRRatingView?.fullImage = UIImage(named: "StarOrange")
        }else if self.evaluationOfMDRRatingView!.rating == Double(5.0) || self.evaluationOfMDRRatingView!.rating == Double(4.0) {
            self.evaluationOfMDRRatingView?.fullImage = UIImage(named: "StarGreen")
        }
        }else if ratingView == self.evaluationOfAgronomy {
        if self.evaluationOfAgronomy!.rating == Double(1.0)  {
            self.evaluationOfAgronomy?.fullImage = UIImage(named: "StarRed")
        }else if self.evaluationOfAgronomy!.rating == Double(3.0) || self.evaluationOfAgronomy!.rating == Double(2.0) {
            self.evaluationOfAgronomy?.fullImage = UIImage(named: "StarOrange")
        }else if self.evaluationOfAgronomy!.rating == Double(4.0) || self.evaluationOfAgronomy!.rating == Double(5.0) {
            self.evaluationOfAgronomy?.fullImage = UIImage(named: "StarGreen")
        }
        }
        
    }
    func submitPravkaFeedback(_ parameters: NSDictionary){
        if self.validations() == true {
        //print(headers)
        SwiftLoader.show(animated: true)
        let urlString = String(format: "%@%@", arguments: [BASE_URL,SUBMIT_PRAVAKTA_FEEDBACK])
        let userObj = Constatnts.getUserObject()
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        
        
        let parameters : Parameters = ["delivaryProgramRate" : self.deliveryProgramRatingView?.rating ?? 0.0 , "mdrSupportRate" : self.evaluationOfMDRRatingView?.rating ?? 0.0 , "agronomyRate" : self.evaluationOfAgronomy?.rating ?? 0.0 , "suggestions" : self.txtViewSuggetions?.text  ?? "" ]
        let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
        let params =  ["data" : paramsStr]
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        //let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        //let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        //print("Response after decrypting data:\(decryptData)")
                        let appDelegate = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.window?.makeToast(Feedback_Submitted_Successfully)
                        self.navigationController?.popViewController(animated: true)
                    }
                    else{
                        if let message = (json as! NSDictionary).value(forKey: "message") as? String {
                            self.view.makeToast(message)
                        }
                    }
                }
            }
            else{
                self.view.makeToast((response.error?.localizedDescription)!)
            }
        }
        }
    }
    
    func validations()-> Bool {
        
        if self.deliveryProgramRatingView!.rating == Double(0.0) {
            self.view.makeToast("Please select the rating of delivery of the program")
            return false
        }else if self.evaluationOfMDRRatingView!.rating == Double(0.0) {
            self.view.makeToast("Please select the rating of Evaluation Of MDR")
            return false
        }else if self.evaluationOfAgronomy!.rating == Double(0.0) {
            self.view.makeToast("Please select the  rating of the Evaluation Of Agronomy")
            return false
        }
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.text = ""
        return true
    }
    
}
