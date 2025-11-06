//
//  PlanterApprovalViewController.swift
//  FarmerConnect
//
//  Created by Empover i-Tech on 30/03/23.
//  Copyright © 2023 ABC. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class PlanterApprovalViewController: BaseViewController , UIScrollViewDelegate, FloatRatingViewDelegate,UITextViewDelegate{
    var successOrderAlert : UIView?
    @IBOutlet weak var contentview : UIView!
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var noDataLbl : UILabel!
    @IBOutlet weak var acceptBtn : UIButton!
    @IBOutlet weak var rejectBtn : UIButton!
    @IBOutlet weak var submitButton : UIButton!

    
    @IBOutlet weak var RequesterStackView : UIStackView!
    @IBOutlet weak var EquipmentStackView : UIStackView!
    @IBOutlet weak var ProviderStackView : UIStackView!
    @IBOutlet weak var RetailerStackView : UIStackView!
    @IBOutlet weak var feedbackStackView1 : UIStackView!
    
    @IBOutlet weak var EquipmentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var RequesterTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var RequesterFarmerView : UIView!
    @IBOutlet weak var RequesterMobileView : UIView!
    @IBOutlet weak var RequesterCropView : UIView!
    @IBOutlet weak var RequesterNoOfacressView : UIView!
    @IBOutlet weak var RequesterDateTimeView : UIView!
    @IBOutlet weak var RequesterAddressView : UIView!
    
    @IBOutlet weak var RequesterFarmername : UILabel!
    @IBOutlet weak var RequesterMobile : UILabel!
    @IBOutlet weak var RequesterCrop : UILabel!
    @IBOutlet weak var RequesterNoofAcres : UILabel!
    @IBOutlet weak var RequesterAddress : UILabel!
    @IBOutlet weak var RequesterDateTime : UILabel!
    
    @IBOutlet weak var ProviderView : UIView!
    @IBOutlet weak var ProviderMobileView : UIView!
    @IBOutlet weak var ProviderAddressView : UIView!
    @IBOutlet weak var ProviderName : UILabel!
    @IBOutlet weak var ProviderMobile : UILabel!
    @IBOutlet weak var ProviderAddress : UILabel!
    
    @IBOutlet weak var RetailerView : UIView!
    @IBOutlet weak var RetailerTopView : UIView!
    @IBOutlet weak var RetailerMobileView : UIView!
    @IBOutlet weak var RetailerAddressView : UIView!
    @IBOutlet weak var RetailerBillUploadView : UIView!
    @IBOutlet weak var RetailerName : UILabel!
    @IBOutlet weak var RetailerMobile : UILabel!
    @IBOutlet weak var RetailerAddress : UILabel!
    @IBOutlet weak var RetailerBillPhoto : UILabel!
    
    @IBOutlet weak var EquipmentView : UIView!
    @IBOutlet weak var EquipmentMobileView : UIView!
    @IBOutlet weak var EquipmentCapacityView : UIView!
    @IBOutlet weak var EquipmentWeightView : UIView!
    @IBOutlet weak var EquipmentAddressView : UIView!
    @IBOutlet weak var Equipmentname : UILabel!
    @IBOutlet weak var EquipmentMobile : UILabel!
    @IBOutlet weak var EquipmentCapacity : UILabel!
    @IBOutlet weak var EquipmentWeight : UILabel!
    @IBOutlet weak var EquipmentAddress : UILabel!
    @IBOutlet weak var EquipmenminimumServiceHours : UILabel!
    @IBOutlet weak var EquipmentequipmentDescription : UILabel!
    @IBOutlet weak var Equipmentperformance : UILabel!
    
    @IBOutlet weak var EquipmenminimumServiceHoursView : UIView!
    @IBOutlet weak var EquipmentequipmentDescriptionView : UIView!
    @IBOutlet weak var EquipmentperformanceView : UIView!
    
    @IBOutlet weak var  ProviderTopConstraint: NSLayoutConstraint!
    
    
     var  isGood: Bool = false
     var  isBad: Bool = false
     var  isAverage: Bool = false
    
    @IBOutlet weak var  feedbackStackView : UIStackView!
    @IBOutlet weak var  FeedbackReviewTextViewRequester : UITextView!
    @IBOutlet weak var btnGood : UIButton!
    @IBOutlet weak var btnBad : UIButton!
    @IBOutlet weak var btnAverage : UIButton!
    var selectedGoodBadAvg:String!
    
    var  planterObj = [PlanterModel]()
    var approvedStatus = ""
    @IBOutlet weak var buttonsStack : UIStackView!
    @IBOutlet weak var buttonsView : UIView!
    var statusKey = ""
    
    @IBOutlet weak var SpreyImage : UIImageView!
    var previewImage : UIImageView!
    var ConfirmAlertView : UIView?
    var infoAlertView : UIView?
    
    var deeplinkTaskID : String  = ""
   // var isFromDeeplink : Bool = false
    var rating : Double?
    var status = ""
   
    
    
    
    var id = 0
    var recordID = ""
    var recordStatus = ""

    var action = ""
    var datePickerBGView : UIView!
    var dateView : UIView!
    var RequesterSelected:String!
    var arrayOfProblemsFaced = [typeOfProblemModel]()
    
    
    @IBOutlet weak var FeedbackTopImage : UIImageView!
    
    @IBOutlet weak var FeedbackView : UIView!
    
    @IBOutlet weak var FeedbackAcresrequestedText : UITextField!
    @IBOutlet weak var farmerNoofAcresTxt : UITextField!
    @IBOutlet weak var FeedbackdateOfSpray : UITextField!
    @IBOutlet weak var FeedbackReviewTextView : UITextView!
    
    @IBOutlet weak var sprayingProblemsView: UIView!
    @IBOutlet weak var tvTypeOfProblems : UITableView!
    
    
    
    
    var isMachineBrokage : Bool = false
    var isOverageCrop : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noData()
        self.noDataLbl.text = NSLocalizedString("no_data_available", comment: "")
        self.requestToGetPlanterDataForVendorBasedOnTaskId()
        selectedGoodBadAvg = ""
        RequesterSelected = ""
        FeedbackReviewTextViewRequester.text = NSLocalizedString("Optional", comment: "")
        FeedbackReviewTextView.text = NSLocalizedString("Optional", comment: "")
        if approvedStatus == "Pending"  {
            buttonsView.isHidden  = false
            submitButton.isHidden = true
        }
        else{
            buttonsView.isHidden  = true
            submitButton.isHidden = true
        }
        var obj = typeOfProblemModel()
        obj.problemType =  NSLocalizedString("Machine_broke_down", comment: "")
        obj.isSelected = false
        var obj1 = typeOfProblemModel()
        obj1.problemType = NSLocalizedString("Overage_Crop", comment: "")
        obj1.isSelected = false
        self.arrayOfProblemsFaced.append(obj)
         self.arrayOfProblemsFaced.append(obj1)
    }
    func noData(){
        self.noDataLbl.isHidden = false
        self.contentview.isHidden = true
        self.scrollView.isHidden = true
        self.buttonsView.isHidden = true
    }
    func availableData(){
        self.noDataLbl.isHidden = true
        self.contentview.isHidden = false
        self.scrollView.isHidden = false
        self.buttonsView.isHidden = false
    }
    func requestToGetPlanterDataForVendorBasedOnTaskId(){
        SwiftLoader.show(animated: true)
        let urlString = BASE_URL + GET_PLANTER_DATA_FOR_VENDOR_BASED_ON_TASK_ID
        let userObj = Constatnts.getUserObject()
        let headrs: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        let params = ["id" : self.id] as NSDictionary
        let paramsStr = Constatnts.nsobjectToJSON(params )
        let params1 =  ["data" : paramsStr]
        
        Alamofire.request(urlString, method: .post, parameters :  params1 , encoding: JSONEncoding.default, headers: headrs).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    print(response)
                    self.planterObj.removeAll()
                    let responseStatusCode = (json as? NSDictionary)?.value(forKey: "statusCode") as? String ?? ""
                    if responseStatusCode == "200"{
                        self.availableData()
                        let respData = (json as? NSDictionary)?.value(forKey: "response") as? NSString ?? ""
                        
                        if respData != ""{
                            let json : NSDictionary  = Constatnts.decryptResult(StrJson: respData as String)
                           // print("Response after decrypting data:\(json)")
                            
                            let planterData = PlanterModel(array: json)
                            self.planterObj.append(planterData)
                        
                            DispatchQueue.main.async {
                                if  self.planterObj.count > 0{
                                    self.updateUI()
                                }
                                else{
//                                    print("coming here")
                                }
                            }
                        }
                    }
                    else if responseStatusCode == STATUS_CODE_500{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        self.view.makeToast((json as! NSDictionary).value(forKey: "message") as! String)
                    }
                    else if responseStatusCode == "601"{
                        Constatnts.logOut()
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    }
                    else{
                        
                    }
                }
            }
            else{
                print((response.error?.localizedDescription)!)
            }
        }
    }
    func updateUI(){
        //These all fields not required
        self.RequesterCropView.isHidden = true
        self.RequesterDateTimeView.isHidden = true
        self.EquipmentCapacityView.isHidden = true
        self.EquipmentWeightView.isHidden = true
        self.EquipmentAddressView.isHidden = true
        
        self.RetailerStackView.isHidden = true
        self.feedbackStackView1.isHidden = true
        self.feedbackStackView.isHidden = true
        
        self.RequesterFarmername.text = (self.planterObj[0] ).farmerName
        self.RequesterMobile.text = (self.planterObj[0] ).mobileNumber
        self.RequesterCrop.text = (self.planterObj[0] ).requestorCrop
        self.RequesterNoofAcres.text = (self.planterObj[0] ).noOfAcres
        self.RequesterAddress.text = (self.planterObj[0] ).requestorAddress
        self.RequesterDateTime.text = (self.planterObj[0] ).requestorDateTime
        
        self.RetailerName.text = (self.planterObj[0] ).retailerName
        self.RetailerMobile.text = (self.planterObj[0] ).retailerMNO
        self.RetailerAddress.text = self.planterObj[0] .retailerAddress
        
        self.Equipmentname.text = (self.planterObj[0] ).companyName
        self.EquipmentCapacity.text = (self.planterObj[0] ).equipmentCapacity
        self.EquipmentMobile.text = (self.planterObj[0] ).modelNo
        self.EquipmentWeight.text = (self.planterObj[0] ).equipmentWeight
        self.EquipmentAddress.text = (self.planterObj[0]).companyAddress
        self.EquipmenminimumServiceHours.text = self.planterObj[0] .minimumServiceHours
        self.EquipmentequipmentDescription.text = self.planterObj[0] .equipmentDescription
        self.Equipmentperformance.text = (self.planterObj[0]).performance
        
        self.ProviderName.text = (self.planterObj[0] ).vendorName
        self.ProviderMobile.text = (self.planterObj[0] ).vendorMobileNumber
        self.ProviderAddress.text = (self.planterObj[0] ).vendorAddress
        
        
self.FeedbackAcresrequestedText.text = (self.planterObj[0]).noOfAcres
        //
        
        let theURL = URL(string: self.planterObj[0] .billPhoto)  //use your URL
        
        if RetailerName.text == "" && RetailerMobile.text == "" && RetailerAddress.text == ""{
            self.RetailerStackView.isHidden = true
            self.RetailerView.isHidden = true
            self.RetailerTopView.isHidden = true
            scrollView?.contentSize = CGSize(width: self.view.frame.size.width, height: 1100)
        }
        
        //Requestor
       
        if  self.RequesterCrop.text == ""{
            self.RequesterCropView.isHidden = true
        }
        if RequesterAddress.text == ""{
            self.RequesterAddressView.isHidden = true
        }
        if self.RequesterDateTime.text  == ""{
            self.RequesterDateTimeView.isHidden = true
        }
        
        //Equipment
        if  self.EquipmentCapacity.text == ""{
            self.EquipmentCapacityView.isHidden = true
        }
        if  self.EquipmentAddress.text == ""{
            self.EquipmentAddressView.isHidden = true
        }
        
        if  self.EquipmentMobile.text == ""{
            self.EquipmentMobileView.isHidden = true
        }
       
        if self.EquipmentAddress.text == "" && self.EquipmentMobile.text == "" {
            self.EquipmentHeightConstraint.constant = 40.0
        }
        if self.EquipmentAddress.text == "" {
            self.EquipmentHeightConstraint.constant = 190.0
        }
        if EquipmentWeight.text == ""{
            EquipmentWeightView.isHidden = true
        }
        if  self.EquipmentAddress.text == "" && self.EquipmentCapacity.text == "" && self.EquipmentMobile.text == "" &&
            self.Equipmentname.text == "" && self.EquipmentequipmentDescription.text == "" &&  self.EquipmenminimumServiceHours.text == "0" && self.Equipmentperformance.text == ""{
            self.EquipmentStackView.isHidden = true
            ProviderTopConstraint.constant = -180.0
        }else{
            self.EquipmentStackView.isHidden = false
            ProviderTopConstraint.constant = 7.0
        }
        //Provider
        if  self.ProviderName.text == "" &&  self.ProviderMobile.text  == "" && self.ProviderAddress.text == ""{
            ProviderStackView.isHidden = true
            scrollView?.contentSize = CGSize(width: self.view.frame.size.width, height: 1100)
            
        }
        
        self.recordID = (self.planterObj[0] ).recordIDEquipment
        self.recordStatus = (self.planterObj[0] ).recordStatus
        
        let userObj = Constatnts.getUserObject()
        if userObj.planterServicesVendor == "true"{
            if recordStatus.lowercased() == "pending"{
                self.buttonsView.isHidden = false
                self.buttonsStack.isHidden = false
                self.acceptBtn.isHidden = false
                self.rejectBtn.isHidden = false
                self.submitButton.isHidden = true
                self.feedbackStackView1.isHidden = true
            }else if recordStatus.lowercased() == "accepted"{
                self.buttonsView.isHidden = false
                self.buttonsStack.isHidden = false
                self.acceptBtn.isHidden = true
                self.rejectBtn.isHidden = true
                self.submitButton.isHidden = false
                self.feedbackStackView1.isHidden = false
                self.viewInitailLoads()
            }
            else if recordStatus.lowercased() == "rejected"{
                self.acceptBtn.isHidden = true
                self.rejectBtn.isHidden = true
                self.submitButton.isHidden = true
                self.buttonsView.isHidden = true
                self.buttonsStack.isHidden = true
                self.feedbackStackView1.isHidden = true
            }
            else if recordStatus.lowercased() == "completed"{
                self.acceptBtn.isHidden = true
                self.rejectBtn.isHidden = true
                self.submitButton.isHidden = true
                self.buttonsView.isHidden = true
                self.buttonsStack.isHidden = true
                self.feedbackStackView1.isHidden = true
            }
            else if recordStatus.lowercased() == "closed"{
                self.acceptBtn.isHidden = true
                self.rejectBtn.isHidden = true
                self.submitButton.isHidden = true
                self.buttonsView.isHidden = true
                self.buttonsStack.isHidden = true
                self.feedbackStackView1.isHidden = true
            }
            else if recordStatus.lowercased() == "cancelled"{
                self.acceptBtn.isHidden = true
                self.rejectBtn.isHidden = true
                self.submitButton.isHidden = true
                self.buttonsView.isHidden = true
                self.buttonsStack.isHidden = true
                self.feedbackStackView1.isHidden = true
            }
        }
        else{
//            if recordStatus.lowercased() == "pending"{
//                self.buttonsView.isHidden = true
//                self.buttonsStack.isHidden = true
//                self.acceptBtn.isHidden = true
//                self.rejectBtn.isHidden = true
//                self.submitButton.isHidden = true
//                self.feedbackStackView1.isHidden = true
//                self.feedbackStackView.isHidden = true
//            }else if recordStatus.lowercased() == "accepted" || recordStatus.lowercased() == "rejected"{
//                self.buttonsView.isHidden = true
//                self.buttonsStack.isHidden = true
//                self.acceptBtn.isHidden = true
//                self.rejectBtn.isHidden = true
//                self.submitButton.isHidden = true
//                self.feedbackStackView1.isHidden = true
//                self.feedbackStackView.isHidden = true
//                self.viewInitailLoads()
//            }
            if recordStatus.lowercased() == "completed"{
                self.buttonsView.isHidden = false
                self.buttonsStack.isHidden = false
                self.acceptBtn.isHidden = true
                self.rejectBtn.isHidden = true
                self.submitButton.isHidden = false
                self.feedbackStackView.isHidden = false
            }
            else{
                self.buttonsView.isHidden = true
                self.buttonsStack.isHidden = true
                self.acceptBtn.isHidden = true
                self.rejectBtn.isHidden = true
                self.submitButton.isHidden = true
                self.feedbackStackView1.isHidden = true
                self.feedbackStackView.isHidden = true

            }
        }
        
       
        
        scrollView?.updateConstraintsIfNeeded()
        scrollView?.layoutIfNeeded()
        self.view.layoutIfNeeded()
        self.view.updateConstraintsIfNeeded()
        
        previewImage = UIImageView()
        previewImage.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        self.view.addSubview(previewImage)
        let fileNameWithExt = theURL?.lastPathComponent
        self.RetailerBillPhoto.text = fileNameWithExt
        let imgStr = ( self.planterObj[0] ).equipmentimgUrl
        let url = URL(string:imgStr )
        SpreyImage?.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceHolderImage")!, options: SDWebImageOptions.delayPlaceholder, completed: { (img, error, _, ur) in
            if error != nil {
                DispatchQueue.main.async {
                    self.SpreyImage.image =  UIImage(named: "PlaceHolderImage")!
                }
            }else {
                DispatchQueue.main.async {
                    self.SpreyImage.image = img
                }
            }
        })
        //  RetailerAddress.contentInset = UIEdgeInsetsMake(-7.0,0.0,0,0.0);
        
        SpreyImage.layer.cornerRadius = 2.0
        SpreyImage.layer.borderWidth = 1.0
        SpreyImage.layer.borderColor = UIColor.gray.cgColor
        //print("what is coming in imgStr",imgStr)
        if imgStr == ""{
            self.SpreyImage.isHidden = true
            self.RequesterTopConstraint.constant = -117
        }
        else if self.SpreyImage.image == UIImage(named: "PlaceHolderImage"){
//            self.SpreyImage.isHidden = true
//            self.RequesterTopConstraint.constant = -117
            self.SpreyImage.isHidden = false
            self.RequesterTopConstraint.constant = 5
        }
        else{
            self.SpreyImage.isHidden = false
            self.RequesterTopConstraint.constant = 5
        }
        
       
        
        scrollView?.updateConstraintsIfNeeded()
        if userObj.planterServicesVendor == "true"{
            if recordStatus.lowercased() == "accepted"{
                scrollView?.contentSize = CGSize(width: self.view.frame.size.width, height:1300)
            }
            else{
                scrollView?.contentSize = CGSize(width: self.view.frame.size.width, height:1000)
            }
        }
        else{
            scrollView?.contentSize = CGSize(width: self.view.frame.size.width, height:1100)
        }
        scrollView?.layoutIfNeeded()
        
        scrollView?.updateConstraintsIfNeeded()
        scrollView?.layoutIfNeeded()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.topView?.isHidden = false
        lblTitle?.text = NSLocalizedString("Order_Details", comment: "")
        self.noData()
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        //self.setStatusBarBackgroundColor(color :App_Theme_Blue_Color_new)
        //self.topView?.backgroundColor = App_Theme_Blue_Color_new
        self.RetailerStackView.isHidden = true
       
        let fromDateFormatter: DateFormatter = DateFormatter()
        fromDateFormatter.dateFormat = "dd-MM-yyyy" //"yyyy-MM-dd"
        let getTodayDate = fromDateFormatter.string(from: Date()) as String
        print("today daaaaate",getTodayDate)
        FeedbackdateOfSpray.text = getTodayDate
        
    }
    
    func viewInitailLoads(){
        //submitButton.alpha = 0.4
        //  submitButton.isUserInteractionEnabled = false
        
        FeedbackReviewTextView.layer.cornerRadius = 5.0
        FeedbackReviewTextView.layer.borderColor = UIColor.gray.cgColor
        FeedbackReviewTextView.layer.borderWidth = 1.0
        
        FeedbackdateOfSpray.layer.cornerRadius = 5.0
        FeedbackdateOfSpray.layer.borderColor = UIColor.gray.cgColor
        FeedbackdateOfSpray.layer.borderWidth = 1.0
        farmerNoofAcresTxt.layer.cornerRadius = 5.0
        farmerNoofAcresTxt.layer.borderColor = UIColor.gray.cgColor
        farmerNoofAcresTxt.layer.borderWidth = 1.0
        
        FeedbackAcresrequestedText.layer.cornerRadius = 5.0
        FeedbackAcresrequestedText.layer.borderColor = UIColor.gray.cgColor
        FeedbackAcresrequestedText.layer.borderWidth = 1.0
        FeedbackAcresrequestedText.setLeftPaddingPoints(5.0)
        farmerNoofAcresTxt.setLeftPaddingPoints(5.0)
        FeedbackdateOfSpray.setLeftPaddingPoints(5.0)
        
        self.sprayingProblemsView.isHidden = true
    }
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        self.rating = rating
        // String(format: "%.2f", self.floatRatingView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        self.rating = rating
        //String(format: "%.2f", self.floatRatingView.rating)
        
    }
    @IBAction func submitAction(_ sender: Any) {
        
        let userObj = Constatnts.getUserObject()
        if userObj.planterServicesVendor == "true"{
            self.action = "submitfeedback"
             if self.validations() {
                 self.submitFeedBackResponse()
//                self.ConfirmAlertView = CustomAlert.alertPopUpView(self,frame: self.view.frame, title:NSLocalizedString("alert", comment: "") as NSString, message: NSLocalizedString("You_want_to_submit?", comment: "") as NSString ,okButtonTitle: NSLocalizedString("ok", comment: ""), cancelButtonTitle: NSLocalizedString("cancel", comment: "")) as? UIView
//        self.view.addSubview(self.ConfirmAlertView!)
//        self.view.bringSubview(toFront: self.ConfirmAlertView!)
             }
        }
        else{
            self.RequesterSelected = "submitfeedbackRequest"
            if self.validationsRequester() {
                self.submitFeedBackRequester()
//               self.ConfirmAlertView = CustomAlert.alertPopUpView(self,frame: self.view.frame, title:NSLocalizedString("alert", comment: "") as NSString, message: NSLocalizedString("You_want_to_submit?", comment: "") as NSString ,okButtonTitle: NSLocalizedString("ok", comment: ""), cancelButtonTitle: NSLocalizedString("cancel", comment: "")) as? UIView
//       self.view.addSubview(self.ConfirmAlertView!)
//       self.view.bringSubview(toFront: self.ConfirmAlertView!)
            }
        }
    
    }
    
   
    @objc func alertYesBtnAction(){
        if self.action.lowercased() == "submitfeedback"{
            if ConfirmAlertView != nil {
                ConfirmAlertView?.removeFromSuperview()
                ConfirmAlertView = nil
            }
            self.submitFeedBackResponse()
            self.action = ""
        }
        else if self.RequesterSelected == "submitfeedbackRequest" {
            if ConfirmAlertView != nil {
                ConfirmAlertView?.removeFromSuperview()
                ConfirmAlertView = nil
            }
            self.submitFeedBackRequester()
            self.action = ""
        }
        else{
            submitApproveOrRejectStatusToServer(statusKey)
        }
        
    }
    
    //Confirm alert NO Button
    @objc func alertNoBtnAction(){
        if ConfirmAlertView != nil {
            ConfirmAlertView?.removeFromSuperview()
            ConfirmAlertView = nil
        }
    }

    
    func datePicker(tagVal:Int){
        
        datePickerBGView = UIView (frame: CGRect(x: 0,y: 0 ,width: self.view.frame.size.width,height: self.view.frame.size.height))
        datePickerBGView.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        self.view.addSubview(datePickerBGView)
        self.datePickerBGView.isHidden = false
        let Height:CGFloat = (44.11 * self.view.frame.height/320)
        let width :CGFloat = self.view.frame.size.width-40 //-40
        let posX :CGFloat = (self.view.frame.size.width - width) / 2
        
        dateView = UIView (frame: CGRect(x: posX,y: (self.view.frame.height-Height)/2 ,width: width,height: Height))
        dateView?.backgroundColor = UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        dateView?.layer.cornerRadius = 10.0
        self.datePickerBGView.addSubview(dateView!)
        
        //datePicker
        let datePicker : UIDatePicker = UIDatePicker (frame: CGRect(x: 5,y: 5,width: width-10,height: Height-50))
        datePicker.backgroundColor = UIColor.white
        datePicker.tag = tagVal
        datePicker.layer.cornerRadius = 5.0
        datePicker.datePickerMode = UIDatePickerMode.date
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        var maximumDate:NSDate = NSDate()
        
        let str = dateFormatter.string(from: maximumDate as Date)
        datePicker.maximumDate = dateFormatter.date(from: str)
        FeedbackdateOfSpray.text = str
        
        //datePicker.maximumDate = NSDate() as Date
        
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: .valueChanged)
        dateView?.addSubview(datePicker)
        
        //submit button
        let btnOK : UIButton = UIButton (frame: CGRect(x: 0, y: datePicker.frame.maxY+5,width: width,height: 40))
        btnOK.backgroundColor = UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 0.8)
        btnOK.layer.cornerRadius = 5.0
        btnOK.tag = tagVal
        btnOK.setTitle(NSLocalizedString("ok", comment: ""), for: UIControlState())
        btnOK.addTarget(self, action: #selector(self.alertOK(_:)), for: UIControlEvents.touchUpInside)
        dateView?.addSubview(btnOK)
        
        let dateViewFrame = dateView?.frame
        dateView?.frame.size.height = btnOK.frame.maxY
        dateView?.frame = dateViewFrame!
        
        dateView?.frame.origin.y = (self.view.frame.size.height - 64 - (dateView?.frame.size.height)!) / 2
        dateView?.frame = dateViewFrame!
        //        self.createSeasonPOPUPView.bringSubview(toFront:  self.datePickerBGView)
        
    }
    
    @IBAction func statutoryActionArrow(_ sender: Any) {
        
        switch (sender as AnyObject).tag {
        case 101:
            
            FeedbackView.isHidden = !FeedbackView.isHidden
            if FeedbackView.isHidden == true{
                FeedbackTopImage.image = UIImage(named: "upArrow-1")
            }
            else{
                FeedbackTopImage.image = UIImage(named: "downroundIcon")
            }
            
        default: break
        }
        self.view.layoutIfNeeded()
        self.view.updateConstraintsIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.topView?.isHidden = true
    }
    
    @IBAction func RejectApproveAction(_ sender: UIButton) {
        switch sender.tag{
        case 100:
            //  requestToGetSprayList("2")
            statusKey = "Rejected"
            self.ConfirmAlertView = CustomAlert.alertPopUpView(self,frame: self.view.frame, title:"Alert" as NSString, message: "Are you sure you want to Reject?" as NSString ,okButtonTitle: "OK", cancelButtonTitle: "Cancel") as? UIView
            self.view.addSubview(self.ConfirmAlertView!)
            self.view.bringSubview(toFront: self.ConfirmAlertView!)
            
        case 101:
            statusKey = "Accepted"
            self.ConfirmAlertView = CustomAlert.alertPopUpView(self,frame: self.view.frame, title:"Alert" as NSString, message: "Are you sure you want to Accept?" as NSString ,okButtonTitle: "OK", cancelButtonTitle: "Cancel") as? UIView
            self.view.addSubview(self.ConfirmAlertView!)
            self.view.bringSubview(toFront: self.ConfirmAlertView!)
        default: break
            
        }
    }
    @IBAction func btnGoodAction(_ sender: UIButton) {
        self.isGood = true
        self.isBad =  false
        self.isAverage = false
        selectedGoodBadAvg = "Good"
     
            let goodImage = UIImageView()
            goodImage.image = UIImage(named: "radio")?.withRenderingMode(.alwaysTemplate)
           // goodImage.tintColor = UIColor(hexStrings: "#3191F3")
            sender.setImage(goodImage.image, for: .normal)
        

         let badImage = UIImageView()
        badImage.image = UIImage(named: "Radio")?.withRenderingMode(.alwaysTemplate)
        //badImage.tintColor = UIColor(hexStrings: "#3191F3")
        self.btnBad.setImage(badImage.image, for: .normal)

         let averageImage = UIImageView()
              averageImage.image = UIImage(named: "Radio")?.withRenderingMode(.alwaysTemplate)
              //averageImage.tintColor = UIColor(hexStrings: "#3191F3")
              self.btnAverage.setImage(averageImage.image, for: .normal)
    }
    
    @IBAction func btnBadAction(_ sender: UIButton) {
        self.isGood = false
        self.isBad =  true
        self.isAverage = false
        selectedGoodBadAvg = "Bad"
        sender.setImage(UIImage(named: "radio"), for: .normal)
        
        let badImage = UIImageView()
         badImage.image = UIImage(named: "Radio")?.withRenderingMode(.alwaysTemplate)
         //badImage.tintColor = UIColor(hexStrings: "#3191F3")
         self.btnGood.setImage(badImage.image, for: .normal)

          let averageImage = UIImageView()
               averageImage.image = UIImage(named: "Radio")?.withRenderingMode(.alwaysTemplate)
              // averageImage.tintColor = UIColor(hexStrings: "#3191F3")
               self.btnAverage.setImage(averageImage.image, for: .normal)
    }
    @IBAction func btnAverageAction(_ sender: UIButton) {
        self.isGood = false
        self.isBad =  false
        self.isAverage = true
        selectedGoodBadAvg = "Average"
        sender.setImage(UIImage(named: "radio"), for: .normal)
        let badImage = UIImageView()
                badImage.image = UIImage(named: "Radio")?.withRenderingMode(.alwaysTemplate)
                //badImage.tintColor = UIColor(hexStrings: "#3191F3")
                self.btnBad.setImage(badImage.image, for: .normal)

                 let averageImage = UIImageView()
                      averageImage.image = UIImage(named: "Radio")?.withRenderingMode(.alwaysTemplate)
                      //averageImage.tintColor = UIColor(hexStrings: "#3191F3")
                      self.btnGood.setImage(averageImage.image, for: .normal)
    }
        
    @IBAction func RetailerBillPriviewAction(_ sender: Any) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        let imagePreviewController = mainStoryboard.instantiateViewController(withIdentifier: "CropDiagnosisImageViewController") as? CropDiagnosisImageViewController
        
        let imgStr = ( self.planterObj[0] ).billPhoto
        var imagebiill = UIImage()
        let url = URL(string:imgStr )
        previewImage.sd_setImage(with: url, placeholderImage: UIImage(named: "image_placeholder")!, options: SDWebImageOptions.delayPlaceholder, completed: { (img, error, _, ur) in
            if error != nil {
                DispatchQueue.main.async {
                    imagebiill =  UIImage(named: "image_placeholder")!
                    
                    imagePreviewController?.CDImage = imagebiill
                    self.present(imagePreviewController!, animated: true, completion: nil)
                    
                }
            }else {
                DispatchQueue.main.async {
                    imagebiill  = img ?? UIImage()
                    
                    
                    imagePreviewController?.CDImage = imagebiill
                    self.present(imagePreviewController!, animated: true, completion: nil)
                    
                }
            }
        })
        
    }

   func submitApproveOrRejectStatusToServer(_ str: String){
       SwiftLoader.show(animated: true)
       let urlString = BASE_URL + PLANTER_SERVICES_ORDER_ACCEPT_OR_REJECT
       let userObj = Constatnts.getUserObject()
       let headrs: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                   "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                   "mobileNumber": userObj.mobileNumber! as String,
                                   "customerId": userObj.customerId! as String,
                                   "deviceId": userObj.deviceId! as String]
       let params = ["id" : self.id,"status":str as? String] as NSDictionary
       let paramsStr = Constatnts.nsobjectToJSON(params )
       let params1 =  ["data" : paramsStr]
       Alamofire.request(urlString, method: .post, parameters :  params1 , encoding: JSONEncoding.default, headers: headrs).responseJSON { (response) in
           SwiftLoader.hide()
           if response.result.error == nil {
               if let json = response.result.value {
                   print(response)
                   self.planterObj.removeAll()
                   let responseStatusCode = (json as? NSDictionary)?.value(forKey: "statusCode") as? String ?? ""
                   if responseStatusCode == "200"{
                       let respData = (json as? NSDictionary)?.value(forKey: "response") as? NSString ?? ""
                       
                       let message = (json as? NSDictionary)?.value(forKey: "message") as? NSString ?? ""
                       let feedbackMSg = NSLocalizedString( message as String,comment:"")
                           
                       if self.successOrderAlert != nil{
                           self.successOrderAlert?.removeFromSuperview()
                       }
                       
                       self.successOrderAlert = CustomAlert.alertInfoPopUpView(self, frame: UIScreen.main.bounds, title: NSLocalizedString("ThankYou", comment: "") as NSString, message: feedbackMSg as NSString, buttonTitle: NSLocalizedString("ok", comment: ""), hideClose: true) as? UIView
                       
                      let appdelegate = UIApplication.shared.delegate as? AppDelegate
                       appdelegate?.window?.addSubview(self.successOrderAlert!)
                       
                   }
                   else if responseStatusCode == STATUS_CODE_500{
                       let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                       let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                       self.view.makeToast((json as! NSDictionary).value(forKey: "message") as! String)
                   }
                   else if responseStatusCode == "601"{
                       Constatnts.logOut()
                       if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                           self.view.makeToast(msg as String)
                       }
                   }
               }
           }
           else{
               print((response.error?.localizedDescription)!)
           }
       }
    }
    

    
    //Confirm alert NO Button
   
    
    
    func showAlertWhenCropNotAvailable(alertMessage: String){
        if infoAlertView != nil {
            infoAlertView?.removeFromSuperview()
        }
        self.infoAlertView = CustomAlert.alertInfoPopUpView(self, frame: self.view.frame, title: "Alert!", message: alertMessage as NSString, buttonTitle: "OK", hideClose: true) as? UIView
        self.view.addSubview(self.infoAlertView!)
    }
    
    //MARK: Info Popup Alert Button Action methods
    @objc func infoAlertSubmit(){
        if self.infoAlertView != nil {
            self.infoAlertView?.removeFromSuperview()
            self.navigationController?.popViewController(animated: true)
        }
        if self.successOrderAlert != nil {
            self.successOrderAlert?.removeFromSuperview()
            let feedbackController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
            //feedbackController?.isFromRequestor = true
            self.navigationController?.pushViewController(feedbackController!, animated: true)
        }
    }
    
    func submitFeedBackRequester(){
                SwiftLoader.show(animated: true)
                SwiftLoader.show(animated: true)
                let urlString = BASE_URL + GET_PLANTER_SERVICES_REQUESTER_FEEDBACKSUBMIT
                let userObj = Constatnts.getUserObject()
                let headrs: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                            "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                            "mobileNumber": userObj.mobileNumber! as String,
                                            "customerId": userObj.customerId! as String,
                                            "deviceId": userObj.deviceId! as String]
              
                
                let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? NSString
                
        let params : Parameters = ["recordId" : recordID ?? ""  , "rating" : self.selectedGoodBadAvg ?? "" , "remarks" : self.FeedbackReviewTextViewRequester.text! ]
                
                let paramsStr = Constatnts.nsobjectToJSON(params as NSDictionary)
                let params1 =  ["data" : paramsStr]
                Alamofire.request(urlString, method: .post, parameters: params1, encoding: JSONEncoding.default, headers: headrs).responseJSON { (response) in
                    
                    SwiftLoader.hide()
                    if response.result.error == nil {
                        if let json = response.result.value {
        let message = (json as! NSDictionary).value(forKey: "message") as? String
        let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String
        //                      let responseMessage  = (json as! NSDictionary).value(forKey: "message") as! String
        if responseStatusCode == "200"{
            
            if self.successOrderAlert != nil{
                self.successOrderAlert?.removeFromSuperview()
            }
            
            self.successOrderAlert = CustomAlert.alertInfoPopUpView(self, frame: UIScreen.main.bounds, title: NSLocalizedString("ThankYou", comment: "") as NSString, message: NSLocalizedString( "Provider_Feedback_Message",comment:"") as NSString, buttonTitle: NSLocalizedString("ok", comment: ""), hideClose: true) as? UIView
            
           let appdelegate = UIApplication.shared.delegate as? AppDelegate
            appdelegate?.window?.addSubview(self.successOrderAlert!)
            
        }
        else{
        self.view.makeToast(message ?? "")
                }
                        }
                    }
                }
            
            
            }
    //from-SprayFeedabackController
    func submitFeedBackResponse() {
//        if self.FeedbackAcresrequestedText.text != ""  && self.farmerNoofAcresTxt.text != "" && self.self.FeedbackdateOfSpray.text !=  "" && self.rating != 0.0 &&  self.FeedbackReviewTextView.text  != "" {
       
        SwiftLoader.show(animated: true)
        SwiftLoader.show(animated: true)
        let urlString = BASE_URL + PLANTER_SERVICE_ORDER_COMPLETION_CONFIRMATION
        let userObj = Constatnts.getUserObject()
        let headrs: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
      
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? NSString
        
        let params : Parameters = ["recordId" : recordID ?? ""  , "requestedAcres" : self.FeedbackAcresrequestedText.text ?? "" , "sprayedAcres" : self.farmerNoofAcresTxt.text! , "dateOfSpraying" : self.FeedbackdateOfSpray.text ?? "", "remarks" : self.FeedbackReviewTextView.text! ]
        
        let paramsStr = Constatnts.nsobjectToJSON(params as NSDictionary)
        let params1 =  ["data" : paramsStr]
        Alamofire.request(urlString, method: .post, parameters: params1, encoding: JSONEncoding.default, headers: headrs).responseJSON { (response) in
            
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    let message = (json as! NSDictionary).value(forKey: "message") as? String
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String
//                      let responseMessage  = (json as! NSDictionary).value(forKey: "message") as! String
                    if responseStatusCode == "200"{
                        
                        if self.successOrderAlert != nil{
                            self.successOrderAlert?.removeFromSuperview()
                        }
                        
                        self.successOrderAlert = CustomAlert.alertInfoPopUpView(self, frame: UIScreen.main.bounds, title: NSLocalizedString("ThankYou", comment: "") as NSString, message: NSLocalizedString( "Provider_Feedback_Message",comment:"") as NSString, buttonTitle: NSLocalizedString("ok", comment: ""), hideClose: true) as? UIView
                        
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
                        appdelegate?.window?.addSubview(self.successOrderAlert!)
                    }else{
                        self.view.makeToast(message ?? "")
                    }
                }
            }
        }
    }
    func validationsRequester() -> Bool{
        if self.selectedGoodBadAvg == "" {
            let errorMsg = NSLocalizedString("Select_good_bad_average", comment: "")
            self.view.makeToast(errorMsg)
            return false
        }
        return true
    }
    func validations() -> Bool  {
        if self.FeedbackAcresrequestedText.text == "" {
            let errorMsg = NSLocalizedString("How_many_Acres_planting_was_requested", comment: "")
            self.view.makeToast(errorMsg)
            return false
        }
        if self.farmerNoofAcresTxt.text  == "" {
            let errorMsg = NSLocalizedString("Please_enter_how_many_Acres_planting_is_done", comment: "")
            self.view.makeToast(errorMsg)
            return false
        }
        let  requesteAcres = Int(self.FeedbackAcresrequestedText.text ?? "0")
        let  sprayedAcres = Int(self.farmerNoofAcresTxt.text ?? "0")
       
        if self.sprayingProblemsView.isHidden == true {
        if  requesteAcres! > sprayedAcres! {
            let errorMsg = NSLocalizedString("What_the_problem_why_planting_is_not_done_fully?", comment: "")
            //self.view.makeToast(errorMsg)
            self.sprayingProblemsView.isHidden = false
            self.tvTypeOfProblems.reloadData()
            return false
        }else {
            self.sprayingProblemsView.isHidden = true
            return true
        }
        }
        let errorMsg = NSLocalizedString("Please_select_Date_of_planting_done", comment: "")
        if self.FeedbackdateOfSpray.text  == "" {
            self.view.makeToast(errorMsg)
            return false
        }
        if self.rating  == 0.0 {
                let errorMsg = NSLocalizedString("Please_provide_rating", comment: "")
            self.view.makeToast(errorMsg)
            return false
        }
         return true
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        if dateView != nil{
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let selectedDate = dateFormatter.string(from: sender.date) as String
            print("Selected value \(selectedDate)")
            FeedbackdateOfSpray.text = selectedDate
            
        }
    }
    
    @objc func alertOK(_ sender: UIButton){
        self.datePickerBGView.isHidden = true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == FeedbackReviewTextViewRequester{
            FeedbackReviewTextViewRequester.text = ""
        }
        else if textView == FeedbackReviewTextView{
            FeedbackReviewTextView.text = ""
        }
    
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == FeedbackReviewTextViewRequester{
        FeedbackReviewTextViewRequester.text = ""
        }
        else if textView == FeedbackReviewTextView{
            FeedbackReviewTextView.text = ""
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == FeedbackReviewTextViewRequester{
        if FeedbackReviewTextViewRequester.text == ""{
            FeedbackReviewTextViewRequester.text = NSLocalizedString("Optional", comment: "")
        }
        }
        else if textView == FeedbackReviewTextView{
            if FeedbackReviewTextView.text == ""{
                FeedbackReviewTextView.text = NSLocalizedString("Optional", comment: "")
           }
      }
    }
}
extension PlanterApprovalViewController: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == FeedbackdateOfSpray {
            textField.resignFirstResponder()
            
            datePicker(tagVal: textField.tag)
           return false
        }
        return true
    }
}
extension PlanterApprovalViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfProblemsFaced.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProblemCell", for: indexPath) as? ProblemCell
        cell?.btnTypeOfProblem.setTitle(self.arrayOfProblemsFaced[indexPath.row].problemType, for: .normal)
        if self.arrayOfProblemsFaced[indexPath.row].isSelected == false {
               cell?.btnTypeOfProblem.setImage(UIImage(named: "radioEmpty"), for: .normal)
        }else {
               cell?.btnTypeOfProblem.setImage(UIImage(named: "radio"), for: .normal)
        }
        
              cell?.btnTypeOfProblem.tag = indexPath.row
        if self.arrayOfProblemsFaced[indexPath.row].problemType == NSLocalizedString("Machine_broke_down", comment: "") {
             cell?.btnTypeOfProblem.addTarget(self, action: #selector(SprayFeedbackController.btnMachine_broken_Action(_:)), for: .touchUpInside)
        }else if  self.arrayOfProblemsFaced[indexPath.row].problemType == NSLocalizedString("Overage_Crop", comment: "") {
             cell?.btnTypeOfProblem.addTarget(self, action: #selector(SprayFeedbackController.btnOverageCropAction(_:)), for: .touchUpInside)
        }
       
       
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        self.arrayOfProblemsFaced[indexPath.row].isSelected = !self.arrayOfProblemsFaced[indexPath.row].isSelected
        self.tvTypeOfProblems.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    @objc  @IBAction func btnMachine_broken_Action(_ sender  : UIButton) {
        self.isMachineBrokage = true
        
        let goodImage = UIImageView()
        goodImage.image = UIImage(named: "radio")?.withRenderingMode(.alwaysTemplate)
        goodImage.tintColor = UIColor(hexString: "#3191F3")
        sender.setImage(goodImage.image, for: .normal)
    }
    @objc   @IBAction func btnOverageCropAction(_ sender  : UIButton) {
        self.isOverageCrop = true
         let goodImage = UIImageView()
        goodImage.image = UIImage(named: "radio")?.withRenderingMode(.alwaysTemplate)
        goodImage.tintColor = UIColor(hexString: "#3191F3")
        sender.setImage(goodImage.image, for: .normal)
    }
    
  
}

