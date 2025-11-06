//
//  ViewController.swift
//  PioneerFarmerConnect
//
//  Created by Empover on 13/12/17.
//  Copyright © 2017 Empover. All rights rese`rved.
//

import UIKit
import Alamofire


class ViewController: UIViewController {
    
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var termsNConditionsLbl: ActiveLabel!
    @IBOutlet weak var privacyPolicyLbl: ActiveLabel!
    @IBOutlet weak var enterMobileNumberTxtFld: UITextField!{
        didSet{
            enterMobileNumberTxtFld.placeholder = NSLocalizedString("mobile_no_hint", comment: "")
            
        }
    }
    
    @IBOutlet weak var collectionViewLanguages: UICollectionView!
    @IBOutlet weak var hgtConstraint : NSLayoutConstraint!
   
    var selectedLanguageId = ""  //"1" etc
    var selectedLanguageCode = ""  //"en" etc
    var selectedLanguageName = "" //"English" etc
   
    var languagesListMutArray = NSMutableArray()
    
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var otpPopupView: UIView!{
        didSet{
            self.otpPopupView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var otpDescription: UILabel!
    @IBOutlet weak var submitOTPBtn: UIButton!{
        didSet{
            self.submitOTPBtn.layer.cornerRadius = 10
        }
    }
    @IBOutlet var svPinView: SVPinView!
    @IBOutlet weak var progressView: BRCircularProgressView!
    
    @IBOutlet weak var otpOptionsLabel: UILabel!
    @IBOutlet weak var otpOptionsView: UIView!
    
    @IBOutlet weak var otpSms: UILabel!
    @IBOutlet weak var otpWhatsapp: UILabel!
    @IBOutlet weak var otpMissedCall: UILabel!
    
    @IBOutlet weak var permissionsRequiredLbl: UILabel!{
        didSet{
            
            permissionsRequiredLbl.attributedText = NSAttributedString(string: NSLocalizedString("permissions_required_app", comment: ""), attributes:
                                                                        [.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])

        }
    }
    
    
    var timer: Timer?
    var currentMinute: Int?
    var currentSecond: Int?
    
    var totalTimeInSec: CGFloat?
    
    var count : CGFloat = 0
    var loggingUser : User?
    var isFromLogin = false
    var strOTP = ""
    
    
    var countryIDStr = "5"
    var missedCallVerificationId = 0
    var customerId = 0
    
    var filteredArray = NSArray()
    
    /// used to show alert popup when user already logged in with same credentials in another device
    var loginAlertView = UIView()
    
    /// stores devideID and sends to server
    var deviceID = ""
    var activeTxtField : UITextField?
    
    var isWhatsappSelected = false
    
        override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//         countryDropDownTxtFld.tintColor = UIColor.clear
           
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//            self.setStatusBarBackgroundColor(color: App_Theme_Blue_Color)
            
            self.collectionViewLanguages.allowsMultipleSelection = false
            
       // self.loadCountriesDropDownTableView()
            deviceID = UIDevice.current.identifierForVendor!.uuidString.replacingOccurrences(of: "-", with: "") as String

            
//        countryDropDownTxtFld.delegate = self
            enterMobileNumberTxtFld.keyboardType = .asciiCapableNumberPad
        let customType = ActiveType.custom(pattern: "PRIVACY POLICY")
        
        privacyPolicyLbl.enabledTypes.append(customType)
        
        privacyPolicyLbl?.customize({(label) in
            label.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                switch type {
                case customType:
                    atts[NSAttributedStringKey.underlineStyle] = isSelected ? NSUnderlineStyle.styleSingle.rawValue : NSUnderlineStyle.styleSingle.rawValue
                    atts[NSAttributedStringKey.foregroundColor] = App_Theme_Blue_Color
                default: ()
                }
                return atts
            }
            
            label.handleCustomTap(for: customType, handler: { (message) in
                // print("clicked")
                let net = NetworkReachabilityManager(host: "www.google.com")
                if net?.isReachable == true{
                    self.findHamburguerViewController()?.hideMenuViewControllerWithCompletion(nil)
                    let toPrivacyPolicyWebViewVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginPrivacyPolicyViewController") as! LoginPrivacyPolicyViewController
                    toPrivacyPolicyWebViewVC.privacyPolicyURLStr = PRIVACY_POLICY_URL as NSString
                    self.present(toPrivacyPolicyWebViewVC, animated: true, completion: nil)
                }
                else{
                    //self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE, duration: 1.0, position: .center)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                    return
                }
            })
            label.customColor[customType] = UIColor.white
        })
            
            let customType1 = ActiveType.custom(pattern: "Terms and Conditions")
            
            termsNConditionsLbl.enabledTypes.append(customType1)
            
            termsNConditionsLbl?.customize({(label) in
                label.configureLinkAttribute = { (type, attributes, isSelected) in
                    var atts = attributes
                    switch type {
                    case customType1:
                        atts[NSAttributedStringKey.underlineStyle] = isSelected ? NSUnderlineStyle.styleSingle.rawValue : NSUnderlineStyle.styleSingle.rawValue
                        atts[NSAttributedStringKey.foregroundColor] = App_Theme_Blue_Color
                    default: ()
                    }
                    return atts
                }
                
                label.handleCustomTap(for: customType1, handler: { (message) in
                    // print("clicked")
                    let net = NetworkReachabilityManager(host: "www.google.com")
                    if net?.isReachable == true{
                        self.findHamburguerViewController()?.hideMenuViewControllerWithCompletion(nil)
                        let toPrivacyPolicyWebViewVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginPrivacyPolicyViewController") as! LoginPrivacyPolicyViewController
                        toPrivacyPolicyWebViewVC.privacyPolicyURLStr = TERMS_CONDITIONS_URL as NSString
                        self.present(toPrivacyPolicyWebViewVC, animated: true, completion: nil)
                    }
                    else{
                        //self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE, duration: 1.0, position: .center)
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                        return
                    }
                })
                label.customColor[customType] = UIColor.white
            })
            self.requestToGetLanguagesData()
            self.otpView.isHidden = true
            
            self.otpOptionsView.isHidden = true
            
            self.recordScreenView("ViewController", Login_Screen)
            self.registerFirebaseEvents(PV_Login_Screen, "", "", "", parameters: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func requestToGetLanguagesData(){
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,LOGIN_GET_LANGUAGES_LIST])
        let parameters = ["countryId": 5] as NSDictionary
        let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
        let params =  ["data" : paramsStr]
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                      
                       let languagesListArray = decryptData.value(forKey: "languageList") as! NSArray
                        self.languagesListMutArray.removeAllObjects()
                        for i in 0 ..< languagesListArray.count{
                            let languageDict = languagesListArray.object(at: i) as? NSDictionary
                            let langData = Language(dict: languageDict!)
                            self.languagesListMutArray.add(langData)
                        }
                        
                        let predicate = NSPredicate(format: "languageCode == %@",self.selectedLanguageCode)
                        self.filteredArray = (languagesListArray).filtered(using: predicate) as NSArray
                        
                        DispatchQueue.main.async {
                            if self.selectedLanguageCode == "" || self.selectedLanguageCode == nil{
                                let predicate = NSPredicate(format: "languageId == %d",1)
                                let defaultLangArray = (languagesListArray).filtered(using: predicate) as NSArray
                                if let idObj = (self.filteredArray.object(at: 0) as! NSDictionary).value(forKey: "languageId") as? Int {
                                    self.selectedLanguageId = String(format: "%d",idObj) as String
                                }
                                if let codeObj = (self.filteredArray.object(at: 0) as! NSDictionary).value(forKey: "languageCode") as? String {
                                    self.selectedLanguageCode = String(format: "%d",codeObj) as String
                                }
                                if let nameObj = (self.filteredArray.object(at: 0) as! NSDictionary).value(forKey: "languageName") as? Int {
                                    self.selectedLanguageName = String(format: "%d",nameObj) as String
                                }
                                
                                //set default language to Appdelegate and userdefaults
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.selectedLanguage =  self.selectedLanguageCode
                                appDelegate.selectedLanguageName = self.selectedLanguageName
                                appDelegate.selectedlanguageID = self.selectedLanguageId
                                
                                UserDefaults.standard.set([appDelegate.selectedLanguage], forKey: "AppleLanguages")
                                UserDefaults.standard.synchronize()
                                UserDefaults.standard.set(appDelegate.selectedLanguage , forKey: "selectedLanguage")
                                UserDefaults.standard.synchronize()
                                Bundle.setLanguage(appDelegate.selectedLanguage)
                                
                            }
                            self.collectionViewLanguages.reloadData()
                        }
                    }
                }
            }
            else{
                self.view.makeToast((response.error?.localizedDescription)!)
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let mainViewVisibleArea = self.view.bounds.size.height
        let otpViewVisibleArea = self.optionsView.frame.origin.y + self.optionsView.frame.height
        let txtFldOrigin = self.enterMobileNumberTxtFld.frame.origin.y
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            if otpViewVisibleArea > mainViewVisibleArea - keyboardHeight{
                UIView.animate(withDuration: 1, animations: {
                    self.view.frame.origin.y = 0 - txtFldOrigin + UIApplication.shared.statusBarFrame.height
                }, completion: nil)
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 1, animations: {
                   self.view.frame.origin.y = 0
               }, completion: nil)
        }
    func setStatusBarBackgroundColor(color: UIColor) {
        if #available(iOS 13.0, *) {
            let statusBar1 =  UIView()
            statusBar1.frame = UIApplication.shared.statusBarFrame
            statusBar1.backgroundColor = color
            UIApplication.shared.keyWindow?.addSubview(statusBar1)
            
            //            let statusBar = UIView(frame:(UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
            //            statusBar.backgroundColor = UIColor.white
            //            UIApplication.shared.keyWindow?.addSubview(statusBar)
        }else{
            guard let statusBar = (UIApplication.shared.value(forKey: "statusBarWindow") as AnyObject?)?.value(forKey: "statusBar") as! UIView? else {
                return
            }
            statusBar.backgroundColor = color
            
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        enterMobileNumberTxtFld.delegate = self
        UserDefaults.standard.set(false, forKey: "PeetDontShow")
        //Set default language
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
         selectedLanguageCode = appDelegate.selectedLanguage
    }
    
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     
    }
    

    @IBAction func loginBtnClickAction(_ sender: Any) {
//        let toHomeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
//        self.navigationController?.pushViewController(toHomeVC!, animated: true)
//        self.view.endEditing(true)
        enterMobileNumberTxtFld.resignFirstResponder()
        if Validations.isNullString(enterMobileNumberTxtFld.text! as NSString) {
            self.view.makeToast(Please_Enter_Mobile_Number)
            return
        }
        if enterMobileNumberTxtFld.text!.count < 10 {
            self.view.makeToast("Please enter a valid phone number")
            return
        }
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            deviceID = UIDevice.current.identifierForVendor!.uuidString.replacingOccurrences(of: "-", with: "") as String
            let parameters = ["mobileNumber":enterMobileNumberTxtFld.text!, "deviceId":deviceID,"userAcceptanceKey":LOGIN_USER_ACCEPTANCE_KEY_0,"countryId":Int(countryIDStr)!,"deviceType":"iOS"] as NSDictionary
            let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
            let params =  ["data" : paramsStr]
            print(params)
//            self.requestForLogin(loginParams: params as [String:String])
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
        self.registerFirebaseEvents(PV_Login_Screen, enterMobileNumberTxtFld.text ?? "", "", Login_Screen, parameters: nil)
        self.setFireBaseUserProperty(parameters: [MOBILE_NUMBER:enterMobileNumberTxtFld.text ?? ""])
    }
    
    //MARK: requestForLogin
    /**
     login request service with Dictionay input
     - Parameter loginParams:[String:String]
     */
    func requestForLogin (loginParams : [String:String], isWhatsApp : Bool, isSms: Bool){
        SwiftLoader.show(animated: true)
        
        var urlString:String = "" //String(format: "%@%@", arguments: [BASE_URL,LOGIN_SEND_OTP])
       
        if isWhatsApp == true {
            urlString = String(format: "%@%@", arguments: [BASE_URL,SEND_OTP_TO_WHATSAPP])
        }else{
            urlString = String(format: "%@%@", arguments: [BASE_URL,LOGIN_SEND_OTP])
        }
        Alamofire.request(urlString, method: .post, parameters: loginParams, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                       // print("Response after decrypting data:\(decryptData)")
                        
                        var emailIDStr = ""
                         let email = (Validations.checkKeyNotAvail(decryptData, key: "emailId") as?NSString)!

                        if Validations.isNullString(email) == false{
                            emailIDStr = decryptData.value(forKey: "emailId") as! String
                        }
//                        if Validations.checkKeyNotAvail(decryptData, key: "emailId") is String{
//                            emailIDStr = decryptData.value(forKey: "emailId") as! String
//                        }
                        
                        let parameters = ["mobileNumber":self.enterMobileNumberTxtFld.text!, "otp":decryptData.value(forKey: "otp") as! String,"customerId":decryptData.value(forKey: "customerId") as! String,"customerType":decryptData.value(forKey: "customerType") as! String,"deviceToken":"","deviceType":"iOS","deviceId":self.deviceID,"countryId":self.countryIDStr,"emailId": emailIDStr,"countryCode":self.countryIDStr] as NSDictionary
                        
                        
                        print("OTP sms/whatsapp ===> \(decryptData.value(forKey: "otp") as! String)")
                        let userObj = User(dict: parameters)
                        Constatnts.setUserToUserDefaults(user: userObj)
                        
                        self.initiateOTPScreen(isFromSms: isSms, isFromWhatsapp: isWhatsApp, isFromMissedCall: false)
                       
                       /* let toVC = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController
                        toVC?.loggingUser = userObj
                        toVC?.isFromLogin = true
                        self.navigationController?.pushViewController(toVC!, animated: true)*/
                    }
                    else if responseStatusCode == ALREADY_LOGIN_STATUS_CODE_103 {//user_already_logged_in
                        self.loginAlertView = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: NSLocalizedString("login_confirmation", comment: "") as NSString, message: NSLocalizedString("user_already_logged_in", comment: "") as NSString, okButtonTitle: NSLocalizedString("yes", comment: ""), cancelButtonTitle: NSLocalizedString("no", comment: "")) as! UIView
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
    }
    
    @IBAction func missedCallBtnClicked(_ sender: Any) {
        self.isWhatsappSelected = false
        self.enterMobileNumberTxtFld.resignFirstResponder()
        if Validations.isNullString(self.enterMobileNumberTxtFld.text! as NSString) || self.enterMobileNumberTxtFld.text!.count < 10{
            self.view.makeToast(NSLocalizedString("enter_mobile_number_error", comment: ""))
            return
        }
        self.loginAlertView = CustomAlert.loginAlertViewNewDesign(self, image: UIImage(named: "caution")! , frame: self.view.frame, title: NSLocalizedString("caution_", comment: "") as NSString, message: NSLocalizedString("misscall_alert_msg", comment: "").replacingOccurrences(of: "$1", with: self.enterMobileNumberTxtFld.text ?? "") as NSString, okButtonTitle: NSLocalizedString("continu", comment: "").uppercased(), cancelButtonTitle: NSLocalizedString("Cancel", comment: "").uppercased()) as! UIView
        self.view.addSubview(self.loginAlertView)
    }
    
    @IBAction func whatsAppBtnClicked(_ sender: Any) {
        self.enterMobileNumberTxtFld.resignFirstResponder()
        if Validations.isNullString(enterMobileNumberTxtFld.text! as NSString) || self.enterMobileNumberTxtFld.text!.count < 10 {
            self.view.makeToast(NSLocalizedString("enter_mobile_number_error", comment: ""))
            return
        }
        self.loginAlertView = CustomAlert.whatsappAlertPopUpView(self, frame: self.view.frame, message: NSLocalizedString("whatsapp_otp_msg", comment: "").replacingOccurrences(of: "$1", with: self.enterMobileNumberTxtFld.text ?? "") as NSString , cancelButtonTitle: NSLocalizedString("Cancel", comment: "").uppercased(), okButtonTitle: NSLocalizedString("continu", comment: "").uppercased()) as! UIView
        self.view.addSubview(self.loginAlertView)
    }
    
    func whatsappOtpRequested(){
        self.isWhatsappSelected = true
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            deviceID = UIDevice.current.identifierForVendor!.uuidString.replacingOccurrences(of: "-", with: "") as String
            let parameters = ["mobileNumber":enterMobileNumberTxtFld.text!, "deviceId":deviceID,"userAcceptanceKey":LOGIN_USER_ACCEPTANCE_KEY_0,"countryId":Int(countryIDStr)!,"deviceType":"iOS","langCode": "en",
                              "languageId": "1"] as NSDictionary
            let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
            let params =  ["data" : paramsStr]
            print(params)
            self.loginAlertView.removeFromSuperview()
            self.requestForLogin(loginParams: params as [String:String], isWhatsApp: true, isSms: false)
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
        self.registerFirebaseEvents(PV_Login_Screen, enterMobileNumberTxtFld.text ?? "", "", Login_Screen, parameters: nil)
        self.setFireBaseUserProperty(parameters: [MOBILE_NUMBER:enterMobileNumberTxtFld.text ?? ""])

    }
    
    @IBAction func otpBtnClicked(_ sender: Any) {
        self.isWhatsappSelected = false
        self.enterMobileNumberTxtFld.resignFirstResponder()
        if Validations.isNullString(enterMobileNumberTxtFld.text! as NSString) || self.enterMobileNumberTxtFld.text!.count < 10 {
            self.view.makeToast(NSLocalizedString("enter_mobile_number_error", comment: ""))
            return
        }
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            deviceID = UIDevice.current.identifierForVendor!.uuidString.replacingOccurrences(of: "-", with: "") as String
            let parameters = ["mobileNumber":enterMobileNumberTxtFld.text!, "deviceId":deviceID,"userAcceptanceKey":LOGIN_USER_ACCEPTANCE_KEY_0,"countryId":Int(countryIDStr)!,"deviceType":"iOS","langCode": "en",
                              "languageId": "1"] as NSDictionary
            let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
            let params =  ["data" : paramsStr]
            print(params)
            self.requestForLogin(loginParams: params as [String:String], isWhatsApp: false, isSms: true)
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
        self.registerFirebaseEvents(PV_Login_Screen, enterMobileNumberTxtFld.text ?? "", "", Login_Screen, parameters: nil)
        self.setFireBaseUserProperty(parameters: [MOBILE_NUMBER:enterMobileNumberTxtFld.text ?? ""])

    }

    //MARK: popUpNoBtnAction
    @objc func popUpNoBtnAction(){
        loginAlertView.removeFromSuperview()
    }
    //MARK: popUpYesBtnAction

    @objc func popUpYesBtnAction(){
        loginAlertView.removeFromSuperview()
        
        let toregisterVC = self.storyboard?.instantiateViewController(withIdentifier: "NewRegisterationViewController") as! NewRegisterationViewController
        toregisterVC.mobileNumberFromLoginVCStr = self.enterMobileNumberTxtFld.text! as NSString
        toregisterVC.countryIdFromLoginVCStr = self.countryIDStr as NSString
        toregisterVC.isFromUpdate = false
        self.navigationController?.pushViewController(toregisterVC, animated: true)

    }
    
    func showPromptToUserToMakeCall(userAcceptanceKey : String){
        SwiftLoader.show(animated: true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,INFORM_MOBILE_VIA_MISSED_CALL])
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! NSString

        let parameters = ["appName":APP_NAME, "appVersionName" : version, "countryId": self.countryIDStr,"deviceToken":"","langCode":appDelegate.selectedLanguage,"mobileNumber":enterMobileNumberTxtFld.text!,"versionCode":"","deviceId":deviceID,"userAcceptanceKey":userAcceptanceKey,"deviceType":"iOS"] as NSDictionary
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
    
    func checkWhetherNumberVerified(){
        SwiftLoader.show(animated: true)
        var urlString:String = String(format: "%@%@", arguments: [BASE_URL,VERIFY_MOBILE_NUMBER_VIA_MISSED_CALL])
       /* if self.isWhatsappSelected == true{
                   urlString = String(format: "%@%@", arguments: [BASE_URL,SEND_OTP_TO_WHATSAPP])
               }*/
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        var deviceTkn = ""
        if let deviceToken = appDelegate?.gcmRegId{
            deviceTkn = deviceToken as! String
        }
        let parameters = ["appName":APP_NAME, "missCallVerificationId" : missedCallVerificationId, "countryId": self.countryIDStr,"deviceToken":deviceTkn,"customerId":"\(customerId)","mobileNumber":enterMobileNumberTxtFld.text!,"versionCode":"","deviceId":deviceID,"deviceType":"iOS"] as NSDictionary
       
        let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
        let params =  ["data" : paramsStr]
        //let appDelegate = UIApplication.shared.delegate as? AppDelegate

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
                         userObj.countryCode = self.countryIDStr as NSString? ?? ""
                        userObj.deviceId = self.deviceID as NSString
                        userObj.deviceToken = (appDelegate?.gcmRegId)!
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
                        self.registerFirebaseEvents(OTP_Success, self.enterMobileNumberTxtFld.text ?? "", "", "", parameters: nil)
                         //NotificationCenter.default.post(name: Notification.Name("UpdateOwnerTitle"), object: nil)
                         let toVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                         toVC!.isFromOTP = true
                         self.navigationController?.pushViewController(toVC!, animated: true)

                    }
                    else{
                        self.loginAlertView.removeFromSuperview()
                        self.view.makeToast("Unable to process your request! Please try again")
                    }
                }
            }
            else{
                self.loginAlertView.removeFromSuperview()
                if let message = response.result.error?.localizedDescription as String?{
                    self.view.makeToast(message)
                }
            }
        }

    }
    
    func showVerifyBtnPopUp(){
        self.loginAlertView.removeFromSuperview()
        
        self.loginAlertView = CustomAlert.alertPopUpViewMissedCallVerify(self, frame: self.view.frame, message: "After making a call from \(enterMobileNumberTxtFld.text!) please click on verify button" as NSString, okButtonTitle: NSLocalizedString("verify", comment: "")) as! UIView
        self.view.addSubview(self.loginAlertView)
    }
    
    //MARK: alertYesBtnActionMissedCallVerify
    /*
     YES button action of alertview which is displayed to the user when user tapped on missed call verification button
     */
    @objc func alertYesBtnActionMissedCallVerify(){
//        self.showPromptToUserToMakeCall(userAcceptanceKey: LOGIN_USER_ACCEPTANCE_KEY_0)
//        self.loginAlertView.removeFromSuperview()
        self.checkWhetherNumberVerified()
    }

    //MARK: callYesBtn
    /*
     YES button action of alertview which is displayed to the user when user tapped on missed call verification button
     */
    @objc func callYesBtn(){
        self.showPromptToUserToMakeCall(userAcceptanceKey: LOGIN_USER_ACCEPTANCE_KEY_0)
    }
    
    //MARK: callYNoBtnAction
    /*
     No button action of alertview which is displayed to the user when user tapped on missed call verification button
     */
    @objc func callNoBtn(){
        self.loginAlertView.removeFromSuperview()
    }
    
    //MARK: alertYesBtnActionMissedCall
    /*
     YES button action of alertview which is displayed to the user when user tapped on missed call verification button
     */
    @objc func alertYesBtnActionMissedCall(){
        self.showPromptToUserToMakeCall(userAcceptanceKey: LOGIN_USER_ACCEPTANCE_KEY_1)
    }
    
    //MARK: alertNoBtnActionMissedCall
    /*
     No button action of alertview which is displayed to the user when user tapped on missed call verification button
     */
    @objc func alertNoBtnActionMissedCall(){
        self.loginAlertView.removeFromSuperview()
    }

    //MARK: alertYesBtnAction
    /**
     YES button action of the alertView which is displayed to the user
     when already logged in other device
     */
    @objc func alertYesBtnAction(){
        self.reqWhenAlreadyLogin()
    }
    
    //MARK: alertNoBtnAction
    /**
     NO button action of the alertView which is displayed to the user
     when already logged in other device
     */
    @objc func alertNoBtnAction(){
        loginAlertView.removeFromSuperview()
    }

    //whatsapp Alert popup Actions
    @objc func alertCancelAction(){
        self.loginAlertView.removeFromSuperview()
    }
    @objc func alertSubmitAction(){
        self.whatsappOtpRequested()
    }
    
    //MARK: reqWhenAlreadyLogin
    /**
     This method is called when clicked on YES button of the AlertView(i,e already logged in)
     */
    func reqWhenAlreadyLogin(){
        
        let parameters = ["mobileNumber":enterMobileNumberTxtFld.text!, "deviceId":deviceID,"userAcceptanceKey":LOGIN_USER_ACCEPTANCE_KEY_1,"countryId":Int(countryIDStr)!,"deviceType":"iOS"] as NSDictionary
        
        let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
        let params =  ["data" : paramsStr]
        // print(params)
        SwiftLoader.show(animated: true)
        
        var urlString:String = String(format: "%@%@", arguments: [BASE_URL,LOGIN_SEND_OTP])
        if self.isWhatsappSelected == true{
                         urlString = String(format: "%@%@", arguments: [BASE_URL,SEND_OTP_TO_WHATSAPP])
                     }

        Alamofire.request(urlString, method: .post, parameters: params as [String:String], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        print("Response after decrypting data:\(decryptData)")
                        
                        var emailIDStr = ""
                        let email = (Validations.checkKeyNotAvail(decryptData, key: "emailId") as?NSString)!
                        
                        if Validations.isNullString(email) == false{
                            emailIDStr = decryptData.value(forKey: "emailId") as! String
                        }
                        
                        let parameters = ["mobileNumber":self.enterMobileNumberTxtFld.text!, "customerType":decryptData.value(forKey: "customerType") as! String, "otp":decryptData.value(forKey: "otp") as! String,"customerId":decryptData.value(forKey: "customerId") as! String,"deviceToken": "", "deviceType":"iOS","deviceId":self.deviceID,"countryId":self.countryIDStr,"emailId":emailIDStr] as NSDictionary
                        
                        
                        print("OTP (already Login API) ====> \(decryptData.value(forKey: "otp") as! String)")
                        
                        //let parameters = ["deviceToken":AppDelegate.deviceToken,"deviceId":self.deviceID,"ownerName":Json.value(forKey: "OwnerName") as! String] as NSDictionary
                        let userObj = User(dict: parameters)
                        Constatnts.setUserToUserDefaults(user: userObj)
                        
                        self.loginAlertView.removeFromSuperview()
                        self.initiateOTPScreen(isFromSms: !(self.isWhatsappSelected), isFromWhatsapp: self.isWhatsappSelected, isFromMissedCall: false)
                        
                        /*let toVC = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController
                        toVC?.loggingUser = userObj
                        self.navigationController?.pushViewController(toVC!, animated: true)*/
                    }
                }
            }
            else{
                self.view.makeToast((response.result.error?.localizedDescription)!, duration: 1.0, position: .center)
                return
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ViewController : UITextFieldDelegate{
    //MARK: textfield delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTxtField = textField
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        if textField == enterMobileNumberTxtFld {
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            if currentString == "" && Int(string)! < 6{
                return false
            }
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength

        }
        return true
    }
}


extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.languagesListMutArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionViewLanguages.dequeueReusableCell(withReuseIdentifier: "languageCell", for: indexPath) as! LanguageCell
        let languageCell = languagesListMutArray.object(at: indexPath.row) as? Language
        cell.lblLanguage?.text = languageCell?.value(forKey: "languageName") as? String
        cell.selectionButton.isUserInteractionEnabled = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if countryIDStr != "5" && appDelegate.selectedLanguage == languageCell?.value(forKey: "languageCode") as? String {
            cell.selectionButton.setImage(UIImage(named: "circle-selected"), for: .normal)
        }
        else {
            if  appDelegate.selectedLanguage == languageCell?.value(forKey: "languageCode") as? String && countryIDStr == "5" {
                cell.selectionButton.setImage(UIImage(named: "circle-selected"), for: .normal)
                
            }else {
                cell.selectionButton.setImage(UIImage(named: "circle-unselected"), for: .normal)
            }
        }
        //cell.contentView.backgroundColor = UIColor.white
        
        return cell
    }
    @objc @IBAction func selectLanagugage(_ sender : UIButton){
        if sender.imageView?.image == UIImage(named: "circle-selected") {
             sender.setImage(UIImage(named: "circle-unselected"), for: .normal)
        }else {
             sender.setImage(UIImage(named: "circle-selected"), for: .normal)
        }
       
        self.changeDefaultLanguage(sender.tag)
        self.collectionViewLanguages.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.changeDefaultLanguage(indexPath.row)
       self.collectionViewLanguages.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width/3-5, height: 45);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //        return UIEdgeInsetsMake(15, 10, 10, 10)//top,left,bottom,right
        return UIEdgeInsetsMake(5, 5, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0//10
    }
    
    func changeDefaultLanguage(_ row : Int){
        let languageData = languagesListMutArray.object(at: row) as? Language
        if let languageName = languageData?.value(forKey: "languageName") as? String{
            self.selectedLanguageName = languageName
        }
        if let languageCode = languageData?.value(forKey: "languageCode") as? String{
            self.selectedLanguageCode = languageCode
        }
        if let languageId = languageData?.value(forKey: "languageId") as? String{
            self.selectedLanguageId = languageId
        }
        self.selectedlanguageDidChange()
    }
    
    func selectedlanguageDidChange(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.selectedLanguage =  selectedLanguageCode
        appDelegate.selectedLanguageName = selectedLanguageName
        appDelegate.selectedlanguageID = selectedLanguageId
       
        UserDefaults.standard.set([appDelegate.selectedLanguage], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        UserDefaults.standard.set(appDelegate.selectedLanguage , forKey: "selectedLanguage")
        UserDefaults.standard.synchronize()
    
        
        // Update the language by swaping bundle
        Bundle.setLanguage(appDelegate.selectedLanguage)
        
        
        // Done to reintantiate the storyboards instantly
        
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? ViewController else{ return }
        self.navigationController?.pushViewController(viewController, animated: false)
    }
}

//MARK:- OTP changes
extension ViewController{
    
    func initiateOTPScreen(isFromSms: Bool, isFromWhatsapp: Bool, isFromMissedCall: Bool){
        self.strOTP = ""
        var message = ""
        self.count = 0
        let userObject = Constatnts.getUserObject()
        
        self.otpView.isHidden = false
        self.otpOptionsView.isHidden = true
        self.progressView.isHidden = false
        self.submitOTPBtn.isHidden = false
        
        self.svPinView.style = .underline
        svPinView.didFinishCallback = { pin in
            print("The pin entered is \(pin)")
            self.strOTP = pin
        }
        
        self.otpSms.text = NSLocalizedString("sms_st", comment: "")
        self.otpWhatsapp.text = NSLocalizedString("whatsapp_st", comment: "")
        self.otpMissedCall.text = NSLocalizedString("missed_call", comment: "")
        self.otpOptionsLabel.text = NSLocalizedString("choose_verification_message", comment: "")
        self.submitOTPBtn.setTitle(NSLocalizedString("submit", comment: "").uppercased(), for: .normal)
        
        if isFromSms == true{
            var message1 = NSLocalizedString("otp_sending_msg", comment: "").replacingOccurrences(of: "$1", with: "\(String(describing: userObject.mobileNumber ?? ""))")
            message = message1
            if userObject.emailId != ""{
                var message2 = NSLocalizedString("otp_sending_msg_email", comment: "").replacingOccurrences(of: "$2", with: "\(String(describing: userObject.emailId ?? ""))")
                message = message+message2
            }
            self.otpDescription.text = message
            self.otpSms.text = "Resend"+" "+NSLocalizedString("sms_st", comment: "")
            self.view.makeToast(message)
        }else{
            var message1 = NSLocalizedString("otp_sending_whatsapp_msg", comment: "").replacingOccurrences(of: "$1", with: "\(String(describing: userObject.mobileNumber ?? ""))")
            message = message1
            if userObject.emailId != ""{
                var message2 = NSLocalizedString("otp_sending_msg_email", comment: "").replacingOccurrences(of: "$2", with: "\(String(describing: userObject.emailId))")
                message = message+message2
            }
            self.otpDescription.text = message
            self.otpWhatsapp.text = "Resend"+" "+NSLocalizedString("whatsapp_st", comment: "")
            self.view.makeToast(message)
        }
        
        self.setProgressView()
    }
    
    func setProgressView(){
        progressView.backgroundColor = UIColor.clear
        progressView.setProgressText("\("00:30")")
        currentMinute = 00
        currentSecond = 30
        totalTimeInSec = 30
        progressView.setCircleStrokeWidth(10)
        progressView.setProgressTextFont()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
    }
    @IBAction func submitOTPClickAction(_ sender: Any) {
        self.view.endEditing(true)
        if Validations.isNullString(strOTP as NSString) {
            self.view.makeToast(Please_Enter_Otp)
            return
        }
        else if strOTP.count<6{
            self.view.makeToast(NSLocalizedString("enter_valid_otp_error", comment: ""))
            return
        }
        else{
            self.registerFirebaseEvents(OTP_Submit, loggingUser?.mobileNumber as String? ?? "" as String, "", "", parameters: nil)
            let net = NetworkReachabilityManager(host: "www.google.com")
            if net?.isReachable == true{
                let userObject = Constatnts.getUserObject()
                let parameters = ["mobileNumber":userObject.mobileNumber, "otp":strOTP,"customerId":userObject.customerId,"deviceToken":userObject.deviceToken,"deviceId":userObject.deviceId!,"countryId":userObject.countryId!.integerValue,"deviceType":"iOS"] as NSDictionary
                let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
                let params =  ["data" : paramsStr]
                self.requestToSubmitOTP(Params: params as [String:String], isFromWhatsApp: false, requestToResendOTP: false)
            }
            else{
                self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
            }
        }
    }
    //SUbmit and resend OTP same method is used
    func requestToSubmitOTP (Params : [String:String],isFromWhatsApp: Bool, requestToResendOTP: Bool){
        SwiftLoader.show(animated: true)
        var urlString:String?
        urlString = String(format: "%@%@", arguments: [BASE_URL,LOGIN_RESEND_OTP]) //request otp though sms
        if requestToResendOTP == false {
            urlString = String(format: "%@%@", arguments: [BASE_URL,LOGIN_VERIFY_OTP])  //submit otp
        }else if isFromWhatsApp == true{
            urlString = String(format: "%@%@", arguments: [BASE_URL,SEND_OTP_TO_WHATSAPP]) //request otp through whatsapp
            self.isWhatsappSelected = true
        }
        print(urlString)
        print(Params)
        Alamofire.request(urlString!, method: .post, parameters: Params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    print("Response :\(json)")
                    
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        
                        if requestToResendOTP == true{
                            self.view.makeToast(Otp_Sent_Successfully, duration: 2.0, position: .center)
                            self.otpOptionsView.isHidden = true
                            self.progressView.isHidden = false
                            self.submitOTPBtn.isHidden = false
                            self.count = 0
                            self.strOTP = ""
                            self.svPinView.clearPin()
                            self.setProgressView()
                            return
                        }else{
                            let existingUserObj = Constatnts.getUserObject()
                            let userObj = User(dict: decryptData)
                            print(decryptData)
                            userObj.countryCode = self.countryIDStr as NSString? ?? ""
                            userObj.deviceId = existingUserObj.deviceId //self.loggingUser?.deviceId
                            userObj.deviceToken = existingUserObj.deviceToken //(self.loggingUser?.deviceToken)!
                            Constatnts.setUserToUserDefaults(user: userObj)
                            
                            NotificationCenter.default.post(name: Notification.Name("UpdateDashboard"), object: nil)
                        
                            let defaults = UserDefaults.standard
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
                        
                            let toVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                            toVC!.isFromOTP = true
                            self.navigationController?.pushViewController(toVC!, animated: true)
                        }
                    }
                    else if responseStatusCode == STATUS_CODE_122{
                        let userObject = Constatnts.getUserObject()
                        self.registerFirebaseEvents(OTP_Expired, userObject.mobileNumber as String? ?? "" as String, "", "", parameters: nil)
                        self.view.makeToast((json as! NSDictionary).value(forKey: "message") as! String)
                    }
                    else if responseStatusCode == STATUS_CODE_123{
                        let userObject = Constatnts.getUserObject()
                        self.registerFirebaseEvents(OTP_Invalid, userObject.mobileNumber as String? ?? "" as String, "", "", parameters: nil)
                        self.view.makeToast((json as! NSDictionary).value(forKey: "message") as! String)
                    }
                }
            }
            else{
                self.view.makeToast((response.result.error?.localizedDescription)!, duration: 1.0, position: .center)
            }
        }
    }
    @IBAction func resendOtpBySmsClicked(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            self.otpOptionsView.isHidden = true
            self.submitOTPBtn.isHidden = false
            self.progressView.isHidden = false
            deviceID = UIDevice.current.identifierForVendor!.uuidString.replacingOccurrences(of: "-", with: "") as String
            let userObject = Constatnts.getUserObject()
            let parameters = ["mobileNumber":userObject.mobileNumber!,"customerId": userObject.customerId!,"deviceId": userObject.deviceId!,"countryId": userObject.countryId!.integerValue,"deviceType":"iOS", "otp":"", "deviceToken":appDelegate?.gcmRegId] as NSDictionary
            let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
            let params =  ["data" : paramsStr]
            self.requestToSubmitOTP(Params: params as [String:String], isFromWhatsApp: false,requestToResendOTP: true)
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
    }
    
    @IBAction func resendOtpByWhatsappClicked(_ sender: Any) {
        if self.isWhatsappSelected == false{
            self.loginAlertView = CustomAlert.whatsappAlertPopUpView(self, frame: self.view.frame, message: NSLocalizedString("whatsapp_otp_msg", comment: "").replacingOccurrences(of: "$1", with: self.enterMobileNumberTxtFld.text ?? "") as NSString , cancelButtonTitle: NSLocalizedString("Cancel", comment: "").uppercased(), okButtonTitle: NSLocalizedString("continu", comment: "").uppercased()) as! UIView
            self.view.addSubview(self.loginAlertView)
        }else{
            self.requestToResendOTPFromWhatsapp()
        }
        
    }
    
    func requestToResendOTPFromWhatsapp(){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let net = NetworkReachabilityManager(host: "www.google.com")
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! NSString
        if net?.isReachable == true{
            self.otpOptionsView.isHidden = true
            self.submitOTPBtn.isHidden = false
            self.progressView.isHidden = false
            deviceID = UIDevice.current.identifierForVendor!.uuidString.replacingOccurrences(of: "-", with: "") as String
            let userObject = Constatnts.getUserObject()
            let parameters = ["mobileNumber":userObject.mobileNumber!,"customerId": userObject.customerId!,"deviceId":userObject.deviceId!,"countryId":userObject.countryId?.integerValue,"deviceType":"iOS","languageId": appDelegate?.selectedLanguage,"versionCode": version,"userAcceptanceKey": LOGIN_USER_ACCEPTANCE_KEY_0] as NSDictionary
            
            let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
            let params =  ["data" : paramsStr]
            self.requestToSubmitOTP(Params: params as [String:String], isFromWhatsApp: true, requestToResendOTP: true)
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
    }
    
    @IBAction func resendOtpByMisscallClicked(_ sender: Any) {
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            self.count = 0
            self.strOTP = ""
            self.svPinView.clearPin()
            let userObject = Constatnts.getUserObject()
            self.loginAlertView = CustomAlert.loginAlertViewNewDesign(self, image: UIImage(named: "caution")! , frame: self.view.frame, title: "Caution", message: "Please make sure that you are calling from mobile number: \(userObject.mobileNumber ?? "")" as NSString, okButtonTitle: "Continue", cancelButtonTitle: "Cancel") as! UIView
            self.view.addSubview(self.loginAlertView)
        }else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
        
    }
   
    
    @objc func timerAction(){
        count+=1
        if count >= totalTimeInSec! {
            timer?.invalidate()
            self.progressView.isHidden = true
            self.otpOptionsView.isHidden = false
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
                self.progressView.isHidden = true
                self.otpOptionsView.isHidden = false
            }
        }
    }
    
    @IBAction func closeOTPPopup(_ sender: Any) {
        self.strOTP = ""
        self.count = 0
        self.isWhatsappSelected = false
        self.otpView.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }
    
}
