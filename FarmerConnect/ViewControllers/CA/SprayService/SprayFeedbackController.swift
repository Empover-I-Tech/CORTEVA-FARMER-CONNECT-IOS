//
//  SprayFeedbackController.swift
//  PioneerEmployee
//
//  Created by Empover on 31/08/20.
//  Copyright © 2020 Empover. All rights reserved.
//

import UIKit
import Alamofire


class SprayFeedbackController: BaseViewController,UITextFieldDelegate ,FloatRatingViewDelegate{
    @IBOutlet weak var contentview : UIView!
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var buttonsView : UIView!
    @IBOutlet weak var tvTypeOfProblems : UITableView!
    
    @IBOutlet weak var farmerTopImage : UIImageView!
    @IBOutlet weak var farmerNameLabel : UILabel!
    @IBOutlet weak var farmerCropeLabel : UILabel!
    @IBOutlet weak var farmerNoOfAcresLabel : UILabel!
    @IBOutlet weak var farmerMobileLabel : UILabel!
    @IBOutlet weak var farmerAddressLabel : UILabel!

    @IBOutlet weak var  sprayingProblemsView: UIView!
    
    @IBOutlet weak var FeedbackTopImage : UIImageView!
    @IBOutlet weak var FeedbackAcresrequestedText : UITextField!
    @IBOutlet weak var farmerNoofAcresTxt : UITextField!
    @IBOutlet weak var FeedbackdateOfSpray : UITextField!

    @IBOutlet weak var FeedbackReviewTextView : UITextView!
    @IBOutlet weak var farmerView : UIView!
    @IBOutlet weak var FeedbackView : UIView!
    @IBOutlet weak var submitButton : UIButton!
    
     var isMachineBrokage : Bool = false
     var isOverageCrop : Bool = false
    
    var datePickerBGView : UIView!
    var dateView : UIView!
    var validdata = false
    var statusKey = ""
    var isFromHome = false
    var ConfirmAlertView : UIView?
    var infoAlertView : UIView?
    var orderStatus : String  = ""
    var recordID : Int?
    var rating : Double?
    var farmerMobilNumber : String = ""
    var farmerName : String = ""
    var crop : String = ""
    var noOfAcres : Int = 0
    var address : String = ""
    var arrayOfProblemsFaced = [typeOfProblemModel]()
    var taskID : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        var obj = typeOfProblemModel()
        obj.problemType =  NSLocalizedString("Machine_broke_down", comment: "")
        obj.isSelected = false
        var obj1 = typeOfProblemModel()
        obj1.problemType = NSLocalizedString("Overage_Crop", comment: "")
        obj1.isSelected = false
        self.arrayOfProblemsFaced.append(obj)
         self.arrayOfProblemsFaced.append(obj1)
        self.viewInitailLoads()
        
        // Do any additional setup after loading the view.
    }
    
    func viewInitailLoads(){
        submitButton.alpha = 0.4
        //  submitButton.isUserInteractionEnabled = false
        
        
        scrollView?.updateConstraintsIfNeeded()
        scrollView?.layoutIfNeeded()
        scrollView?.contentSize = CGSize(width: self.view.frame.size.width, height: 1200)
        scrollView?.updateConstraintsIfNeeded()
        scrollView?.layoutIfNeeded()
        self.view.layoutIfNeeded()
        self.view.updateConstraintsIfNeeded()
        
        FeedbackReviewTextView.layer.cornerRadius = 5.0
        FeedbackReviewTextView.layer.borderColor = UIColor.gray.cgColor
        FeedbackReviewTextView.layer.borderWidth = 1.0
        FeedbackReviewTextView.text = ""
        
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
        
        self.farmerNameLabel.text = self.farmerName
        self.farmerCropeLabel.text = self.crop
        self.farmerNoOfAcresLabel.text = "\(self.noOfAcres)"
        self.farmerMobileLabel.text = self.farmerMobilNumber
        self.farmerAddressLabel.text = self.address
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
             if self.validations() {
                self.ConfirmAlertView = CustomAlert.alertPopUpView(self,frame: self.view.frame, title:NSLocalizedString("alert", comment: "") as NSString, message: NSLocalizedString("You_want_to_submit?", comment: "") as NSString ,okButtonTitle: NSLocalizedString("ok", comment: ""), cancelButtonTitle: NSLocalizedString("cancel", comment: "")) as? UIView
        self.view.addSubview(self.ConfirmAlertView!)
        self.view.bringSubview(toFront: self.ConfirmAlertView!)
        }
    }
    
    @IBAction func statutoryActionArrow(_ sender: Any) {
        
        switch (sender as AnyObject).tag {
        case 100:
            
            farmerView.isHidden = !farmerView.isHidden
            if farmerView.isHidden == true{
                farmerTopImage.image = UIImage(named: "upArrow-1")
            }
            else{
                farmerTopImage.image = UIImage(named: "downroundIcon")
            }
            
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.topView?.isHidden = false
        lblTitle?.text = NSLocalizedString("feedback", comment: "")
        if isFromHome == true {
            self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        }
        else{
            self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
        }
        self.setStatusBarBackgroundColor(color :App_Theme_Blue_Color)
        self.topView?.backgroundColor = App_Theme_Blue_Color
        
        
    }
    
    //Confirm alert YES Button
    @objc func alertYesBtnAction(){
        //  requestToGetSprayList(statusKey)
        if ConfirmAlertView != nil {
            ConfirmAlertView?.removeFromSuperview()
            ConfirmAlertView = nil
        }
        self.submitFeedBackResponse()
    }
    
    //Confirm alert NO Button
    @objc func alertNoBtnAction(){
        
        if ConfirmAlertView != nil {
            ConfirmAlertView?.removeFromSuperview()
            ConfirmAlertView = nil
        }
    }
    
    //------------------------------------- //
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == FeedbackdateOfSpray {
            textField.resignFirstResponder()
            
            datePicker(tagVal: textField.tag)
           return false
        }
        return true
    }
    
    func datePicker(tagVal:Int){
        
        datePickerBGView = UIView (frame: CGRect(x: 0,y: 0 ,width: self.view.frame.size.width,height: self.view.frame.size.height))
        datePickerBGView.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        self.view.addSubview(datePickerBGView)
        self.view.backgroundColor = UIColor.lightGray
        self.datePickerBGView.isHidden = false
        let Height:CGFloat = (44.11 * self.view.frame.height/120)
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
    
    func submitFeedBackResponse() {
//        if self.FeedbackAcresrequestedText.text != ""  && self.farmerNoofAcresTxt.text != "" && self.self.FeedbackdateOfSpray.text !=  "" && self.rating != 0.0 &&  self.FeedbackReviewTextView.text  != "" {
       
        SwiftLoader.show(animated: true)
        
        let urlString = BASE_URL + SUBMIT_FEEDBACK
        
        let userObj = Constatnts.getUserObject()
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        
        var reason = ""
                  if  isOverageCrop == true {
                    reason = "overageCrop"
                  }else if isMachineBrokage == true {
                      reason = "machineBrokage"
              }
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? NSString
        
        let params : Parameters = ["recordId" : recordID ?? ""  , "requestedAcres" : self.FeedbackAcresrequestedText.text ?? "" , "sprayedAcres" : self.farmerNoofAcresTxt.text! , "dateOfSpraying" : self.FeedbackdateOfSpray.text ?? ""   , "status" : orderStatus  , "remarks" :
            self.FeedbackReviewTextView.text! , "sprayedLessReason" : reason]
        
        let paramsStr = Constatnts.nsobjectToJSON(params as NSDictionary)
              let params1 =  ["data" : paramsStr]
        Alamofire.request(urlString, method: .post, parameters: params1, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    let message = (json as! NSDictionary).value(forKey: "message") as? String
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String
//                      let responseMessage  = (json as! NSDictionary).value(forKey: "message") as! String
                    if responseStatusCode == "200"{
                        let feedbackMSg = NSLocalizedString( "Provider_Feedback_Message",comment:"")
                        self.showErrorAlert(alertMessage:feedbackMSg )
                    }else{
                        self.view.makeToast(message ?? "")
                    }
                }
            }
        }
    
    
    }
    
    func validations() -> Bool  {
        if self.FeedbackAcresrequestedText.text == "" {
            let errorMsg = NSLocalizedString("How_many_Acres_spraying_was_requested", comment: "")
            self.view.makeToast(errorMsg)
            return false
        }
        if self.farmerNoofAcresTxt.text  == "" {
            let errorMsg = NSLocalizedString("Please_enter_how_many_Acres_spraying_is_done", comment: "")
            self.view.makeToast(errorMsg)
            return false
        }
        let  requesteAcres = Int(self.FeedbackAcresrequestedText.text ?? "0")
        let  sprayedAcres = Int(self.farmerNoofAcresTxt.text ?? "0")
       
        if self.sprayingProblemsView.isHidden == true {
        if  requesteAcres! > sprayedAcres! {
            let errorMsg = NSLocalizedString("What_the problem_why_spraying_is_not_done_fully?", comment: "")
             self.view.makeToast(errorMsg)
                self.sprayingProblemsView.isHidden = false
            self.tvTypeOfProblems.reloadData()
            return false
        }else {
            self.sprayingProblemsView.isHidden = true
            return true
        }
        }
         let errorMsg = NSLocalizedString("Please_select_Date_of_spraying_done", comment: "")
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
}
extension SprayFeedbackController : UITableViewDelegate , UITableViewDataSource {
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
    
  
}
struct typeOfProblemModel {
    var problemType : String = ""
    var isSelected : Bool = false
}
