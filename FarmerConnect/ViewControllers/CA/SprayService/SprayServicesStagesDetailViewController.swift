//
//  SprayServicesStagesDetailViewController.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 12/10/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import UIKit
import Alamofire


class SprayServicesStagesDetailViewController: BaseViewController {

    var isSubscriptionDone : Bool = false
    var isUploadDone : Bool = false
    var isBookEquipmentDone : Bool = false
    var isFeedbackSubmitDone : Bool = false
    
    @IBOutlet weak var viewSubscription : UIStackView!
    @IBOutlet weak var viewBillUpoload : UIStackView!
    @IBOutlet weak var viewBookEquipment : UIStackView!
    @IBOutlet weak var viewFeedback : UIStackView!
    @IBOutlet weak var scView : UIScrollView!
    
    //Subscription
    @IBOutlet weak var lblCrop : UILabel!
    @IBOutlet weak var lblDateOfSowing : UILabel!
    @IBOutlet weak var lblNoOFAcres : UILabel!
  
    //BillUpload
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblMobileNumber : UILabel!
    @IBOutlet weak var lblCropName : UILabel!
    @IBOutlet weak var lblNoOfAcres : UILabel!
     @IBOutlet weak var lblAddress : UILabel!
     @IBOutlet weak var imgBill : UIImageView!
    // bookAnequipmwent
    
   @IBOutlet weak var lblEquipFarmerName : UILabel!
       @IBOutlet weak var lblEquipMobileNumber : UILabel!
       @IBOutlet weak var lblEquipCropName : UILabel!
       @IBOutlet weak var lblEquipNoOfAcres : UILabel!
        @IBOutlet weak var lblEquipAddress : UILabel!
      @IBOutlet weak var lblDate : UILabel!
      
    // Feedback
    @IBOutlet weak var lblCropNamefeedback : UILabel!
    @IBOutlet weak var lblDateOfSowingfeedback : UILabel!
    @IBOutlet weak var lblFeedNoOfAcres : UILabel!
    @IBOutlet weak var lblFarmerfeedback : UILabel!
    @IBOutlet weak var lblMobilefeedback : UILabel!
    @IBOutlet weak var lblFarmerRemarks : UILabel!
    @IBOutlet weak var lblRequestedAcres : UILabel!
      
    
    var cropId : Int = 0
    var cropName : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let params : Parameters = ["cropId" : cropId , "cropName" : cropName]
        self.getSubscriptionStageDetails(params: params)
        
        if isSubscriptionDone == true &&  isUploadDone == false {
            self.viewBillUpoload.isHidden = true
             self.viewBookEquipment.isHidden = true
             self.viewFeedback.isHidden = true
        }else if isUploadDone == true && isBookEquipmentDone == false {
            self.viewBillUpoload.isHidden = false
            self.viewBookEquipment.isHidden = true
            self.viewFeedback.isHidden = true
        }else if isBookEquipmentDone == true && isFeedbackSubmitDone == false {
            self.viewBillUpoload.isHidden = false
            self.viewBookEquipment.isHidden = false
            self.viewFeedback.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.topView?.isHidden = false
         self.lblTitle?.text = "Spray Services"
    }
    override func viewWillLayoutSubviews() {
        self.scView.contentSize = CGSize(width: self.view.frame.size.width , height: 1400)
    }
    override func backButtonClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func getSubscriptionStageDetails(params : Parameters){
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [ BASE_URL , GET_SprayCycleStatusDetails])
        let userObj1 : User =  Constatnts.getUserObject()
        let  headers : HTTPHeaders  = ["deviceToken": userObj1.deviceToken as String ,
                                       "userAuthorizationToken": userObj1.userAuthorizationToken! as String ,
                                       "mobileNumber": userObj1.mobileNumber! as String,
                                       "customerId": userObj1.customerId! as String,
                                       "deviceId": userObj1.deviceId! as String]
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                print(response)
                if let json = response.result.value {
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                    if responseStatusCode == STATUS_CODE_200{
                        //                        let userObj = Constatnts.getUserObject()
                        //                                          let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"screen_name" : "RetailerInformationViewController" ] as [String : Any]
                        //                                                            //
                        //                                          self.registerFirebaseEvents("PV_Retailer_CropMaster_success", userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "RetailerInformationViewController" , parameters: fireBaseParams as NSDictionary)
                        let respData = (json as? NSDictionary)?.value(forKey: "response") as? NSString ?? ""
                        let decryptData  = Constatnts.convertToDictionary(text: respData as String)
                        print("Response after decrypting data:\(decryptData)")
                        
                        
                        //                            if let statesArray = decryptData.value(forKey: "stateCodeMaster") as? NSArray{
                        //                                let statesNamesSet =  NSSet(array:statesArray as! [Any])
                        //                                self.stateArray = statesNamesSet.allObjects as NSArray
                        //                                self.stateNamesArray.addObjects(from: statesNamesSet.allObjects)
                        //                            }
                        let sprayBillUploadDetails = decryptData?["sprayBillUploadDetails"] as? NSDictionary
                        let bookEquipmentDetails = decryptData?["sprayEquipmentDetails"] as? NSDictionary
                        let spraySubscriptionDetails = decryptData?["spraySubscriptionDetails"] as? NSDictionary
                        let feedbackSubmissionDetails = decryptData?["sprayFeedbackDetails"] as? NSDictionary
                        
                        
                        
                        //Subscription
                        let cropName = spraySubscriptionDetails?["cropName"] as?  String
                        self.lblCrop.text = cropName
                        self.lblDateOfSowing.text = spraySubscriptionDetails?["dateOfSowing"] as?  String
                        self.lblNoOFAcres.text = "\(spraySubscriptionDetails?["noOfAcres"] as?  Int ?? 0)"
                        
                        //
                        
                        self.lblName.text = sprayBillUploadDetails?["farmerName"] as?  String
                        self.lblMobileNumber.text = sprayBillUploadDetails?["mobileNumber"] as?  String
                        self.lblNoOfAcres.text = "\(sprayBillUploadDetails?["noOfAcres"] as?  Int ?? 0)"
                        self.lblAddress.text = sprayBillUploadDetails?["address"] as?  String
                        self.lblCropName.text = sprayBillUploadDetails?["cropName"] as?  String
                        //
                        
                        self.lblEquipFarmerName.text = bookEquipmentDetails?["farmerName"] as?  String
                        self.lblEquipMobileNumber.text = bookEquipmentDetails?["mobileNumber"] as?  String
                        self.lblEquipNoOfAcres.text = "\(bookEquipmentDetails?["noOfAcres"] as?  Int ?? 0)"
                        self.lblEquipAddress.text = bookEquipmentDetails?["address"] as?  String
                        self.lblDate.text = bookEquipmentDetails?["requestedDate"] as?  String
                        self.lblEquipCropName.text = bookEquipmentDetails?["cropName"] as?  String
                        
                        self.lblFarmerfeedback.text = feedbackSubmissionDetails?["farmerName"] as?  String
                        self.lblFeedNoOfAcres.text = "\(feedbackSubmissionDetails?["noOfAcres"] as?  Int ?? 0)"
                        self.lblDateOfSowingfeedback.text = feedbackSubmissionDetails?["dateOfSowing"] as?  String
                        self.lblMobilefeedback.text = feedbackSubmissionDetails?["mobileNumber"] as?  String
                        self.lblFarmerRemarks.text = feedbackSubmissionDetails?["remarks"] as?  String
                        self.lblRequestedAcres.text = "\(feedbackSubmissionDetails?["requestedAcres"] as?  Int ?? 0)"
                        
                        
                        //                                    //BillUpload
                        //                                    @IBOutlet weak var lblMandal : UILabel!
                        //                                    @IBOutlet weak var lblVillage : UILabel!
                        //                                    @IBOutlet weak var lblRetailerName : UILabel!
                        //                                    @IBOutlet weak var lblRetailerMobileNumber : UILabel!
                        //                                    @IBOutlet weak var lblPincode : UILabel!
                        //                                     @IBOutlet weak var lblAddress : UILabel!
                        //                                     @IBOutlet weak var imgBill : UIImageView!
                        //                                    // bookAnequipmwent
                        //
                        //                                //    @IBOutlet weak var lblMandal : UILabel!
                        //                                //      @IBOutlet weak var lblVillage : UILabel!
                        //                                //      @IBOutlet weak var lblRetailerName : UILabel!
                        //                                //      @IBOutlet weak var lblRetailerMobileName : UILabel!
                        //                                //      @IBOutlet weak var lblPincode : UILabel!
                        //
                        //                                    // Feedback
                        //                                    @IBOutlet weak var lblVendorName : UILabel!
                        //                                      @IBOutlet weak var lblVendorMobileNumber : UILabel!
                        //                                      @IBOutlet weak var lblNoOfSprayedAcres : UILabel!
                        //                                      @IBOutlet weak var lblNoOfAcres : UILabel!
                        //                                    @IBOutlet weak var lblFarmerfeedback : UILabel!
                        //                                     @IBOutlet weak var lblFarmerRemarks : UILabel!
                        //
                        //
                        //
                        ////
                        //
                        //
                        //
                        //                                 if self.billUploadDone == false && self.sprayRequestDone == true {
                        //                                    let img = UIImage(named: "Register_Select")
                        //                                    self.imgBillUpload.image = img
                        //                                 }
                        //                                if self.billUploadDone == true {
                        //                                    self.btnBillUploadSelection.isHidden = false
                        //                                    let img = UIImage(named: "Register_Select")
                        //                                    self.imgBillUpload.image = img
                        //                                    self.viewBillUpload.borderColor = App_Theme_Blue_Color
                        //                                    self.viewBillUpload.borderWidth = 2
                        //                                    self.viewBillUpload.clipsToBounds = true
                        //                                }
                        //                                if self.bookEquipmentDone == true {
                        //                                    self.btnBookEquipmentDoneSelection.isHidden = false
                        //                                     self.imgBookEquipment.image = UIImage(named: "BookEquipment_Select")
                        //                                    self.viewBookEquipment.borderColor = App_Theme_Blue_Color
                        //                                                                           self.viewBookEquipment.borderWidth = 2
                        //                                                                           self.viewBookEquipment.clipsToBounds = true
                        //                                }
                        //                                if self.billUploadDone == true && self.bookEquipmentDone == false {
                        //                                    self.imgBookEquipment.image = UIImage(named: "BookEquipment_Select")
                        //                                }
                        //
                        //                                if self.feedbackSubmissionDone == true {
                        //                                    self.btnFeedbackSubmissionDoneSelection.isHidden = false
                        //                                    self.imgFeedback.image = UIImage(named:"Feedback_Select")
                        //                                    self.viewFeedback.borderColor = App_Theme_Blue_Color
                        //                                                      self.viewFeedback.borderWidth = 2
                        //                                                      self.viewFeedback.clipsToBounds = true
                        //                                }
                        //
                        //                                if self.bookEquipmentDone == true && self.feedbackSubmissionDone == false {
                        //                                    self.imgFeedback.image = UIImage(named: "Feedback_Select")
                        //                                }
                    }
                    else if responseStatusCode == CROP_ADVISORY_NOT_AVAILABLE_151{
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    } else if responseStatusCode == STATUS_CODE_105{
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    else if responseStatusCode == STATUS_CODE_601{
                        Constatnts.logOut()
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
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
