//
//  OTPViewController.swift
//  PioneerEmployee
//
//  Created by Empover on 11/09/17.
//  Copyright © 2017 Empover. All rights reserved.-
//

import UIKit
import Alamofire




class OTPViewController: UIViewController ,UITextFieldDelegate {

    @IBOutlet weak var enterOTPTxtFld: UITextField!
    
    @IBOutlet weak var timerLbl: UILabel!
    
    @IBOutlet weak var resendOTPBtn: UIButton!
    
    @IBOutlet weak var progressView: BRCircularProgressView!
    
    @IBOutlet weak var enterOTPOuterView: UIView!
    
    @IBOutlet weak var receiveOTPLbl: UILabel!
    
    @IBOutlet weak var privacyPolicyLbl: ActiveLabel!
    
    @IBOutlet weak var lblOtpOptions: UILabel!
    @IBOutlet weak var optionsView: UIView!
    
    /// variable used to differentiate between normal submitting the request to get OTP and resend OTP
    var toResendOTPStr = "NO"
    var strOTP = ""
    /// used as a countdown timer (with 3 minutes duration)
    var timer: Timer?
    var currentMinute: Int?
    var currentSecond: Int?
    
    var totalTimeInSec: CGFloat?
    
    var count : CGFloat = 0
    var loggingUser : User?
    var isFromLogin = false
    var countryCodeStr : String?
    var deviceID = ""
    var loginAlertView = UIView()
    var missedCallVerificationId = 0
    var customerId = 0
    
    @IBOutlet var svPinView: SVPinView!
    
    var isProgressViewDisplayed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let titleStr = NSLocalizedString("resendOtp", comment: "")
        self.resendOTPBtn.setTitle(titleStr, for: .normal)
        resendOTPBtn.isHidden = true
        self.optionsView.isHidden = true
        self.lblOtpOptions.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        //timerLbl.isHidden = false
        progressView.isHidden = false
        
//        self.setStatusBarBackgroundColor(color: App_Theme_Blue_Color)

        svPinView.style = .underline
       
        svPinView.didFinishCallback = { pin in
            print("The pin entered is \(pin)")
            self.strOTP = pin
        }

        let localizedString1 = NSLocalizedString("otp_sending_msg", comment: "")
        let localizedString2 = NSLocalizedString("and_or", comment: "")
        let localizedString3 = NSLocalizedString("as sms", comment: "")
        
        let otpMsg = localizedString1.replacingOccurrences(of: "$1", with: "\((loggingUser?.mobileNumber)!)")
        print(otpMsg)
        print(localizedString1)
        print(localizedString2)
        print(localizedString3)
        if Validations.isNullString((loggingUser?.emailId)!) == false{
            
            receiveOTPLbl.text = String(format: "%@  %@ %@", otpMsg ,localizedString2 ,(loggingUser?.emailId)!)
            
            self.view.makeToast(String(format: "%@ %@ %@ %@ ", otpMsg ,localizedString3,localizedString2,(loggingUser?.emailId)!))
        }
        else{
            
            receiveOTPLbl.text = otpMsg
            print(otpMsg)
            print(localizedString3)
            self.view.makeToast(String(format: "%@ %@ ", otpMsg ,localizedString3))
        }
       
        //timerLbl.text = "02:59"
       
        self.setProgressView()
        self.isProgressViewDisplayed = true
        let privacyPolicyType = ActiveType.custom(pattern:"PRIVACY POLICY" )
        privacyPolicyLbl.enabledTypes.append(privacyPolicyType)
        
        privacyPolicyLbl?.customize({(label) in
            label.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                switch type {
                case privacyPolicyType:
                    atts[NSAttributedStringKey.underlineStyle] = isSelected ? NSUnderlineStyle.styleSingle.rawValue : NSUnderlineStyle.styleSingle.rawValue
                    atts[NSAttributedStringKey.foregroundColor] = isSelected ? UIColor(red: 255.0/255.0, green: 153.0/255.0, blue: 0.0/255.0, alpha: 1.0) : UIColor(red: 255.0/255.0, green: 153.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                default: ()
                }
                return atts
            }
            label.handleCustomTap(for: privacyPolicyType, handler: {(message) in
                let net = NetworkReachabilityManager(host: "www.google.com")
                if net?.isReachable == true{
                    let toPrivacyPolicyWebViewVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginPrivacyPolicyViewController") as! LoginPrivacyPolicyViewController
                    toPrivacyPolicyWebViewVC.privacyPolicyURLStr = PRIVACY_POLICY_URL as NSString
                    self.present(toPrivacyPolicyWebViewVC, animated: true, completion: nil)
                }
                else{
                    //self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE, duration: 1.0, position: .center)
                     self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                    return
                }
            })
            label.customColor[privacyPolicyType] = UIColor.white
        })
        //self.hideKeyboard()
        if isFromLogin {
            self.recordScreenView("OTPViewController", OTP_Screen)
            self.registerFirebaseEvents(PV_OTP_Screen, loggingUser?.mobileNumber as String? ?? "", "", "", parameters: nil)
        }
        else{
            self.registerFirebaseEvents(PV_OTP_Registration, loggingUser?.mobileNumber as String? ?? "", "", "", parameters: nil)
        }
        if #available(iOS 12.0, *) {
//            self.enterOTPTxtFld.textContentType = UITextContentType.oneTimeCode
        } else {
            // Fallback on earlier versions
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.isProgressViewDisplayed == false{
            let mainViewVisibleArea = self.view.bounds.size.height
            let otpViewVisibleArea = self.optionsView.frame.origin.y + self.optionsView.frame.height
            let otptxtFldOrigin = self.svPinView.frame.origin.y
            if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                if otpViewVisibleArea > mainViewVisibleArea - keyboardHeight{
                    UIView.animate(withDuration: 1, animations: {
                        self.view.frame.origin.y = 0 - otptxtFldOrigin + UIApplication.shared.statusBarFrame.height
                    }, completion: nil)
                }
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 1, animations: {
                   self.view.frame.origin.y = 0
               }, completion: nil)
        }
    
//   func setStatusBarBackgroundColor(color: UIColor) {
//       if #available(iOS 13.0, *) {
//           let statusBar1 =  UIView()
//           statusBar1.frame = UIApplication.shared.statusBarFrame
//           statusBar1.backgroundColor = color
//           UIApplication.shared.keyWindow?.addSubview(statusBar1)
//           
//       }else{
//           guard let statusBar = (UIApplication.shared.value(forKey: "statusBarWindow") as AnyObject?)?.value(forKey: "statusBar") as! UIView? else {
//               return
//           }
//           statusBar.backgroundColor = color
//           
//       }
//   }



    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        enterOTPTxtFld.resignFirstResponder()
    }
    
    //MARK: setProgressView
    /**
     Used BRCircularProgressView inorder to show the countDown timer of 3 minutes
     */
    func setProgressView(){
        progressView.backgroundColor = UIColor.clear
        progressView.setProgressText("\("02:00")")
        
        currentMinute = 02
        currentSecond = 00
        
        totalTimeInSec = 120
        
        progressView.setCircleStrokeWidth(10)
        progressView.setProgressTextFont()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
    }
    
    //MARK: timerAction
    /**
     Used to calculate the timer value
     */
    @objc func timerAction(){
        count+=1
        //let time : CGFloat = CGFloat(timeRemaining! - count)
        if count > totalTimeInSec! {
            timer?.invalidate()
            //resendOTPBtn.isHidden = false
            self.lblOtpOptions.isHidden = false
            self.optionsView.isHidden = false
            progressView.isHidden = true
            self.isProgressViewDisplayed = false
            return
        }
        else{
            self.progressView.progress = count/totalTimeInSec!
               if (currentMinute! > 0 || currentSecond! >= 0) && currentMinute! >= 0 {
                if currentSecond == 0 {
                    currentMinute = currentMinute!-1
                    currentSecond = 59
                    let text = String(format: "%02d%@%02d", currentMinute!,":",currentSecond!)
                    progressView.setProgressText(text)
                }
                else if currentSecond! > 0 {
                    currentSecond = currentSecond!-1
                    let text = String(format: "%02d%@%02d", currentMinute!,":",currentSecond!)
                    progressView.setProgressText(text)
                }
                if currentMinute! >= 0 {
                    let text = String(format: "%02d%@%02d", currentMinute!,":",currentSecond!)
                    progressView.setProgressText(text)
                }
            }
            else {
                timer?.invalidate()
                //resendOTPBtn.isHidden = false
                self.lblOtpOptions.isHidden = false
                self.optionsView.isHidden = false
                progressView.isHidden = true
                self.isProgressViewDisplayed = false
            }
        }
    }

    
    @IBAction func submitOTPBtn_Touch_Up_Inside(_ sender: Any) {
      self.view.endEditing(true)
//      enterOTPTxtFld.resignFirstResponder()
        
        
        if Validations.isNullString(strOTP as NSString) {
            self.view.makeToast(Please_Enter_Otp)
           // timer?.invalidate()
           // progressView.isHidden = true
            //self.isProgressViewDisplayed = false
            //resendOTPBtn.isHidden = false
            return
        }
        else if strOTP.count<6{
            self.view.makeToast(Please_Enter_Valid_Otp)
            //timer?.invalidate()
            //progressView.isHidden = true
            //self.isProgressViewDisplayed = false
            //resendOTPBtn.isHidden = false
            return
        }
        else{
            self.registerFirebaseEvents(OTP_Submit, loggingUser?.mobileNumber as String? ?? "" as String, "", "", parameters: nil)
            let net = NetworkReachabilityManager(host: "www.google.com")
            if net?.isReachable == true{
            toResendOTPStr = "NO"
            //let loginDecodedData = UserDefaults.standard.value(forKey: "LoginDecodedData") as! NSDictionary
                
                 let parameters = ["mobileNumber":loggingUser!.mobileNumber!, "otp":strOTP,"customerId": loggingUser!.customerId!,"deviceToken":loggingUser!.deviceToken,"deviceId":loggingUser!.deviceId!,"countryId":loggingUser!.countryId!.integerValue,"deviceType":"iOS"] as NSDictionary

                print(parameters)
            let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
            let params =  ["data" : paramsStr]
                self.requestToVerifyOTP(Params: params as [String:String], isFromWhatsApp: false)
            }
            else{
                self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
            }
        }
    }
    
    @IBAction func resendOTPBtn_Touch_Up_Inside(_ sender: Any) {
        self.registerFirebaseEvents(OTP_Resend, loggingUser?.mobileNumber as String? ?? "" as String, "", "", parameters: nil)
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
        //resendOTPBtn.isHidden = true
        progressView.isHidden = false
        toResendOTPStr = "YES"
        //let loginDecodedData = UserDefaults.standard.value(forKey: "LoginDecodedData") as! NSDictionary
            let parameters = ["mobileNumber":loggingUser!.mobileNumber!,"customerId": loggingUser!.customerId!,"deviceId":loggingUser!.deviceId!,"countryId":loggingUser!.countryId!.integerValue,"deviceType":"iOS"] as NSDictionary
        let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
        let params =  ["data" : paramsStr]
            self.requestToVerifyOTP(Params: params as [String:String], isFromWhatsApp: false)
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
    }
        
    @IBAction func otpBtnClicked(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            self.lblOtpOptions.isHidden = true
            self.optionsView.isHidden = true
            self.progressView.isHidden = false
            self.toResendOTPStr = "YES"
            deviceID = UIDevice.current.identifierForVendor!.uuidString.replacingOccurrences(of: "-", with: "") as String
            let parameters = ["mobileNumber":loggingUser!.mobileNumber!,"customerId": loggingUser!.customerId!,"deviceId":loggingUser!.deviceId!,"countryId":loggingUser!.countryId!.integerValue,"deviceType":"iOS", "otp":"", "deviceToken":appDelegate?.gcmRegId] as NSDictionary
            let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
            let params =  ["data" : paramsStr]
            self.requestToVerifyOTP(Params: params as [String:String], isFromWhatsApp: false)
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
    }
   
    @IBAction func whatsAppBtnClicked(_ sender: Any) {
        let net = NetworkReachabilityManager(host: "www.google.com")
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! NSString
        if net?.isReachable == true{
            self.lblOtpOptions.isHidden = true
            self.optionsView.isHidden = true
            self.progressView.isHidden = false
            self.toResendOTPStr = "YES"
            deviceID = UIDevice.current.identifierForVendor!.uuidString.replacingOccurrences(of: "-", with: "") as String
            let parameters = ["mobileNumber":loggingUser!.mobileNumber!,"customerId": loggingUser!.customerId!,"deviceId":loggingUser!.deviceId!,"countryId":loggingUser!.countryId!.integerValue,"deviceType":"iOS","languageId": "","versionCode": version,"userAcceptanceKey": LOGIN_USER_ACCEPTANCE_KEY_0] as NSDictionary
            let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
            let params =  ["data" : paramsStr]
            self.requestToVerifyOTP(Params: params as [String:String], isFromWhatsApp: true)
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
    }
   
    @IBAction func missedCallBtnClicked(_ sender: Any) {
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            self.toResendOTPStr = "YES"
        }else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
        self.loginAlertView = CustomAlert.loginAlertViewNewDesign(self, image: UIImage(named: "caution")! , frame: self.view.frame, title: "Caution", message: "Please make sure that you are calling from mobile number: \(String(describing: loggingUser!.mobileNumber!))" as NSString, okButtonTitle: "Continue", cancelButtonTitle: "Cancel") as! UIView
        self.view.addSubview(self.loginAlertView)
        
    }

    //MARK: callYesBtn
       /*
        YES button action of alertview which is displayed to the user when user tapped on missed call verification button
        */
       @objc func callYesBtn(){
           self.showPromptToUserToMakeCall(userAcceptanceKey: LOGIN_USER_ACCEPTANCE_KEY_0)
       }
       
       //MARK: callYNoBtn
       /*
        No button action of alertview which is displayed to the user when user tapped on missed call verification button
        */
       @objc func callNoBtn(){
        
           self.loginAlertView.removeFromSuperview()
       }
       
    func showPromptToUserToMakeCall(userAcceptanceKey : String){
        SwiftLoader.show(animated: true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,INFORM_MOBILE_VIA_MISSED_CALL])
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! NSString

        let parameters = ["appName":APP_NAME, "appVersionName" : version, "countryId": loggingUser!.countryId!,"deviceToken":loggingUser?.deviceToken,"langCode":appDelegate.selectedLanguage,"mobileNumber":loggingUser!.mobileNumber!,"versionCode":"","deviceId":deviceID, "userAcceptanceKey":userAcceptanceKey,"deviceType":"iOS"] as NSDictionary
        let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
        let params =  ["data" : paramsStr]

        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                         print("Response after decrypting data:\(decryptData)")
                        self.missedCallVerificationId = decryptData.value(forKey: "missCallVerificationId") as? Int ?? 0
                        self.customerId = (decryptData.value(forKey: "customerId") as? NSString)?.integerValue as? Int ?? 0
                        
                        if let url = URL(string: "tel://\(MISSED_CALL_VERIFICATION_NUMBER)") {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }

                        self.showVerifyBtnPopUp()
                    }
                    else if responseStatusCode == ALREADY_LOGIN_STATUS_CODE_103 {//user_already_logged_in

                        self.loginAlertView = CustomAlert.alertPopUpViewForMissedCallVerification(self, frame: self.view.frame, title: NSLocalizedString("login_confirmation", comment: "") as NSString, message: NSLocalizedString("user_already_logged_in", comment: "") as NSString, okButtonTitle: NSLocalizedString("yes", comment: ""), cancelButtonTitle: NSLocalizedString("no", comment: "")) as! UIView
                        self.view.addSubview(self.loginAlertView)
                    }
                    else  if responseStatusCode == STATUS_CODE_101 || responseStatusCode == INVALID_USER_STATUS_CODE_102{//user_doesnot_exist
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        //print("Response after decrypting data:\(decryptData)")
                        //                        let str = String(format: "Farmer does not exist with the entered mobile number %@. Do you want to register now?",self.enterMobileNumberTxtFld.text!)
                        self.loginAlertView = CustomAlert.alertNewPopView(self, frame: self.view.frame, title: NSLocalizedString("login_confirmation", comment: "") as NSString, message: NSLocalizedString("user_doesnot_exist", comment: "") as NSString, okButtonTitle: NSLocalizedString("yes", comment: ""), cancelButtonTitle: NSLocalizedString("no", comment: "")) as! UIView
                        
                        //                        self.loginAlertView = CustomAlert.alertNewPopView(self, frame: self.view.frame, title: "Alert!" as NSString, message: str as NSString, okButtonTitle: "YES", cancelButtonTitle: "NO") as! UIView
                        self.view.addSubview(self.loginAlertView)
                    }
                }
            }
            else{
                if let message = response.result.error?.localizedDescription as String?{
                    self.view.makeToast(message)
                }
            }
        }

        self.loginAlertView.removeFromSuperview()
    }
    
    func showVerifyBtnPopUp(){
        self.loginAlertView.removeFromSuperview()
        self.loginAlertView = CustomAlert.alertPopUpViewMissedCallVerify(self, frame: self.view.frame, message: "After making a call from \(loggingUser!.mobileNumber!) please click on verify button" as NSString, okButtonTitle: "Verify") as! UIView
        self.view.addSubview(self.loginAlertView)
    }
     
    //MARK: alertYesBtnActionMissedCallVerify
    /*
     YES button action of alertview which is displayed to the user when user tapped on missed call verification button
     After clicking on verify button, this method executes
     */
    @objc func alertYesBtnActionMissedCallVerify(){
        //        self.showPromptToUserToMakeCall(userAcceptanceKey: LOGIN_USER_ACCEPTANCE_KEY_0)
        //        self.loginAlertView.removeFromSuperview()
        self.checkWhetherNumberVerified()
    }
    //MARK: alertNoBtnActionMissedCall
      /*
       No button action of alertview which is displayed to the user when user tapped on missed call verification button
       */
      @objc func alertNoBtnActionMissedCall(){
          self.loginAlertView.removeFromSuperview()
      }
    //MARK: popUpNoBtnAction
      @objc func popUpNoBtnAction(){
          loginAlertView.removeFromSuperview()
      }
    //MARK: popUpYesBtnAction

    @objc func popUpYesBtnAction(){
        loginAlertView.removeFromSuperview()
        
        let toregisterVC = self.storyboard?.instantiateViewController(withIdentifier: "NewRegisterationViewController") as! NewRegisterationViewController
        toregisterVC.mobileNumberFromLoginVCStr = loggingUser!.mobileNumber! as NSString
        toregisterVC.countryIdFromLoginVCStr = loggingUser!.countryId! as NSString
        toregisterVC.isFromUpdate = false
        self.navigationController?.pushViewController(toregisterVC, animated: true)

    }
    //MARK: alertYesBtnAction
    /**
     YES button action of the alertView which is displayed to the user
     when already logged in other device
     */
    @objc func alertYesBtnAction(){
        self.reqWhenAlreadyLogin()
    }
    func reqWhenAlreadyLogin(){
        
    }
    
    func checkWhetherNumberVerified(){
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,VERIFY_MOBILE_NUMBER_VIA_MISSED_CALL])
        let parameters = ["appName":APP_NAME, "missCallVerificationId" : missedCallVerificationId, "countryId": loggingUser!.countryId!,"deviceToken":"","customerId":"\(customerId)","mobileNumber": loggingUser!.mobileNumber!,"versionCode":"","deviceId":deviceID,"deviceType":"iOS"] as NSDictionary
        let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
        let params =  ["data" : paramsStr]
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        print("Response after decrypting data:\(decryptData)")
                        let userObj = User(dict: decryptData)
                        print(decryptData)
                        userObj.countryCode = self.loggingUser!.countryId! as NSString? ?? ""
                        userObj.deviceId = self.deviceID as NSString
                        userObj.deviceToken = (appDelegate?.gcmRegId)!
                        Constatnts.setUserToUserDefaults(user: userObj)
                        
                        NotificationCenter.default.post(name: Notification.Name("UpdateDashboard"), object: nil)
                        //NotificationCenter.default.post(name: Notification.Name("UpdateSideMenuData"), object: nil)
                        
                        
                        let appDelegate = UIApplication.shared.delegate as? AppDelegate
                        let defaults = UserDefaults.standard
                        let parameters : NSDictionary?
                        var lastSyncTimeStr = ""
                        if defaults.value(forKey: "lastSyncedOn") != nil{
                            lastSyncTimeStr = defaults.value(forKey: "lastSyncedOn") as! String
                        }
                        parameters = ["lastUpdatedTime":lastSyncTimeStr] as NSDictionary
                        
                        let paramsStr1 = Constatnts.nsobjectToJSON(parameters!)
                        let params =  ["data": paramsStr1]
                        appDelegate?.requestToGetCropDiagnosisMasterData(Params: params as [String:String])
                        //self.registerFirebaseEvents(OTP_Success, self.enterMobileNumberTxtFld.text ?? "", "", "", parameters: nil)
                        //NotificationCenter.default.post(name: Notification.Name("UpdateOwnerTitle"), object: nil)
                        let toVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                        toVC!.isFromOTP = true
                        self.navigationController?.pushViewController(toVC!, animated: true)
                        
                    }
                    else{
                        self.view.makeToast("Unable to process your request! Please try again")
                    }
                }
            }
            else{
                if let message = response.result.error?.localizedDescription as String?{
                    self.view.makeToast(message)
                }
            }
        }
        
    }
    
    func requestToVerifyOTP (Params : [String:String], isFromWhatsApp: Bool){
        SwiftLoader.show(animated: true)
        let urlString:String?
        if toResendOTPStr == "NO" {
            urlString = String(format: "%@%@", arguments: [BASE_URL,LOGIN_VERIFY_OTP])  //submit otp
        }else if isFromWhatsApp == true{
            urlString = String(format: "%@%@", arguments: [BASE_URL,SEND_OTP_TO_WHATSAPP]) //request otp through whatsapp
        }else{
            urlString = String(format: "%@%@", arguments: [BASE_URL,LOGIN_RESEND_OTP]) //request otp though message
        }
        
        
        Alamofire.request(urlString!, method: .post, parameters: Params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                   print("Response :\(json)")
                    
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        print("Response after decrypting data:\(decryptData)")
                        
                        if self.toResendOTPStr == "YES"{
                            self.view.makeToast(Otp_Sent_Successfully, duration: 2.0, position: .center)
                            //self.resendOTPBtn.isHidden = true
                            self.lblOtpOptions.isHidden = true
                            self.optionsView.isHidden = true
                            self.progressView.isHidden = false
                            self.count = 0
                            self.setProgressView()
                            self.isProgressViewDisplayed = true
                            
                            return
                        }
                        else{
                            let userObj = User(dict: decryptData)
                            print(decryptData)
                            userObj.countryCode = self.countryCodeStr as NSString? ?? ""
                            userObj.deviceId = self.loggingUser?.deviceId
                            userObj.deviceToken = (self.loggingUser?.deviceToken)!
                            Constatnts.setUserToUserDefaults(user: userObj)
                            
                            NotificationCenter.default.post(name: Notification.Name("UpdateDashboard"), object: nil)
                            //NotificationCenter.default.post(name: Notification.Name("UpdateSideMenuData"), object: nil)
                            
                            let defaults = UserDefaults.standard
                            //defaults.set(decryptData , forKey: "OTPResponseData")
                            defaults.set(true, forKey: "login")
                            defaults.synchronize()
                           
                            let appDelegate = UIApplication.shared.delegate as? AppDelegate
                            let parameters : NSDictionary?
                            var lastSyncTimeStr = ""
                            if defaults.value(forKey: "lastSyncedOn") != nil{
                                lastSyncTimeStr = defaults.value(forKey: "lastSyncedOn") as! String
                            }
                            parameters = ["lastUpdatedTime":lastSyncTimeStr] as NSDictionary

                            let paramsStr1 = Constatnts.nsobjectToJSON(parameters!)
                            let params =  ["data": paramsStr1]
                            appDelegate?.requestToGetCropDiagnosisMasterData(Params: params as [String:String])
                            self.registerFirebaseEvents(OTP_Success, self.loggingUser?.mobileNumber as String? ?? "" as String, "", "", parameters: nil)
                            //NotificationCenter.default.post(name: Notification.Name("UpdateOwnerTitle"), object: nil)
                            let toVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                            toVC!.isFromOTP = true
                            self.navigationController?.pushViewController(toVC!, animated: true)
                        }
                    }
                    else if responseStatusCode == STATUS_CODE_122{
                        self.registerFirebaseEvents(OTP_Expired, self.loggingUser?.mobileNumber as String? ?? "" as String, "", "", parameters: nil)
                        self.view.makeToast((json as! NSDictionary).value(forKey: "message") as! String)
                    }
                    else if responseStatusCode == STATUS_CODE_123{
                        self.registerFirebaseEvents(OTP_Invalid, self.loggingUser?.mobileNumber as String? ?? "" as String, "", "", parameters: nil)
                        self.view.makeToast((json as! NSDictionary).value(forKey: "message") as! String)
                    }
                }
            }
            else{
                self.view.makeToast((response.result.error?.localizedDescription)!, duration: 1.0, position: .center)
            }
        }
    }

    //MARK: textField delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enterOTPTxtFld.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let validCharSet = CharacterSet(charactersIn: "0123456789").inverted
        let filtered: String = (string.components(separatedBy: validCharSet) as NSArray).componentsJoined(by: "")
        let _char = string.cString(using: String.Encoding.utf8)
        let isBackSpace: Int = Int(strcmp(_char, "\\b"))
        if isBackSpace == -92 {
            // is backspace
            if textField.text?.count == 1 {
            }
            return true
        }
        if (filtered == "") {
        }
        if (textField.text?.count)! >= 6 && range.length == 0 {
            return false
        }
        return (string == filtered)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
