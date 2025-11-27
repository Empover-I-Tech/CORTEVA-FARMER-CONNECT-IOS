//
//  RHRDLandingViewController.swift
//  FarmerConnect
//
//  Created by Empover on 09/09/21.
//  Copyright © 2021 ABC. All rights reserved.
//


import UIKit
//import UQScannerFramework
import Alamofire
//import Acvission
//import AcvissCore
//import ZXingObjC
import EmpoverCameraScannerSDK

class RHRDLandingViewController: BaseViewController,UIScrollViewDelegate ,RewardsPopUpProtocol, UIPopoverPresentationControllerDelegate,UIPopoverControllerDelegate,CameraScannerDelegate{
    //AcvissionDelegate
    //UQScannerDelegate
    
    var scannerView: CameraScannerView?
    
    @IBOutlet weak var lbl_myProfile: UILabel!
    @IBOutlet weak var lbl_dasboard: UILabel!
    @IBOutlet weak var lbl_exit: UILabel!
    @IBOutlet weak var lbl_scanAndWin: UILabel!
    @IBOutlet weak var lbl_Rewards: UILabel!
    @IBOutlet weak var lbl_fieldSharing: UILabel!
    @IBOutlet weak var lbl_Referral: UILabel!
    @IBOutlet weak var lbl_profileUpdate: UILabel!
    @IBOutlet weak var lbl_pexalon_Highest: UILabel!
    @IBOutlet weak var lbl_bphAlerts: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var username_lbl: UILabel!
    @IBOutlet weak var profile_btn: UIButton!
    @IBOutlet weak var profile_img: UIImageView!
    @IBOutlet weak var enrollmentBtn: UIButton!
    @IBOutlet weak var referralBtn: UIButton!
    @IBOutlet weak var fieldPictureSharing: UIButton!
    @IBOutlet weak var buyPexalonBtn: UIButton!
    @IBOutlet weak var bphAlerts: UIButton!
    @IBOutlet weak var pexalonHighestBtn: UIButton!

    //var scannerVc : UQScannerViewController?
    @IBOutlet weak var Profileupdate_view: UIView!
    @IBOutlet weak var referral_view: UIView!
    @IBOutlet weak var scanAndWin_view: UIView!
    @IBOutlet weak var bphAlerts_view: UIView!
    @IBOutlet weak var fieldSharing_view: UIView!
    @IBOutlet weak var rewards_view: UIView!
    @IBOutlet weak var pexalonHighest_view: UIView!
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var Profileupdate_viewSection: UIView!
    @IBOutlet weak var referral_viewSection: UIView!
    @IBOutlet weak var scanAndWin_viewSection: UIView!
    @IBOutlet weak var bphAlerts_viewSection: UIView!
    @IBOutlet weak var fieldSharing_viewSection: UIView!
    @IBOutlet weak var rewards_viewSection: UIView!
    @IBOutlet weak var pexalonHighest_viewSection: UIView!
    var unsavedChangesAlert : UIView?
    var arrayFieldSharing = NSMutableArray()
    var statusMsgAlert : UIView?
    var moreButton : UIButton?
    var isFromHome = false
    var dashboardDicArray = NSMutableArray()
    @IBOutlet weak var profileCompltion_lbl: UILabel!
    var dictEncashResponse : NSDictionary?
    var backAlert = false
    
    @IBOutlet weak var popStackView: UIStackView!
    //MAR:- View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        let userObj = Constatnts.getUserObject()
        if userObj.userLogsAllPrint == "true"{
        self.saveUserLogEventsDetailsToServer()
        }
    }
    
    func saveUserLogEventsDetailsToServer(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMddHHmmss" //"dd/MM/yyyy HH:mm:ss"
        var todaysDate = dateFormatter.string(from: Date())
        let userObj = Constatnts.getUserObject()
        
        let dict: NSDictionary = ["userModuleUsageLogs":[[
            "mobileNumber": userObj.mobileNumber,
            "deviceId": userObj.deviceId,
            "deviceType": "iOS",
            "customerId": userObj.customerId,
            "logTimeStamp": todaysDate as? NSString,
            "pincode": userObj.pincode,
            "districtLoggedin":userObj.districtName,
            "stateLoggedin":userObj.stateName,
            "stateName": userObj.stateName,
            "marketName":"",
            "commodity":"",
            
            "eventName": Home_RHRD,
            "className":"RHRDLandingViewController",
            "moduleName":"RHRD",
            
            "healthCardId":"",
            "productId":"",
            "cropId":"",
            "seasonId":"",
            
            "isOnlineRecord": "true"]] as? [NSDictionary]
        ]
        
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            userLogEventsSingletonClass.sendUserLogEventsDetailsToServer(dictionary: dict ?? NSDictionary()){ (status, statusMessage) in
                if status == true{
                }else{
                    self.view.makeToast(statusMessage as String? ?? "")
                }
            }
        }else{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let userLogEvents = dict["userModuleUsageLogs"] as! [NSDictionary]
                for eachLogEvent in userLogEvents {
                var userLogEvent: UserLogEvents = UserLogEvents(dict: eachLogEvent)
                userLogEvent.isOnlineRecord = "false"
                appDelegate.saveUserLogEventsModulewise(userLogEvent)
                }
        }
        
    }
    
    
    //MARK:- EXIT ACTION
    @IBAction func exitAction(_ sender : Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MAR:- SHOW MORE BUTTON POP WINDOW
    @objc @IBAction func showPopover(_ sender: AnyObject) {
        self.view.bringSubview(toFront: popStackView)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func setPreferredContentSizeFromAutolayout() {
        let meBetterSize = moreButton?.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        self.preferredContentSize = meBetterSize!
        self.popoverPresentationController?
            .presentedViewController
            .preferredContentSize = meBetterSize!
    }
    
    
    func loadInitialdata(){
        self.lbl_scanAndWin.text = NSLocalizedString("rhrd_scan_and_get_luckydraw", comment: "") as NSString as String
        self.lbl_fieldSharing.text = NSLocalizedString("rhrd_uploadField_and_get_luckydraw", comment: "") as NSString as String
        self.lbl_Referral.text = NSLocalizedString("rhrd_Refer_and_get_luckydraw", comment: "") as NSString as String
        self.lbl_profileUpdate.text = NSLocalizedString("rhrd_Enroll_and_get_luckydraw", comment: "") as NSString as String
        self.lbl_pexalon_Highest.text = NSLocalizedString("rhrd_share_succesStory_and_get_luckydraw", comment: "") as NSString as String
        NSLocalizedString("alert", comment: "") as NSString
        let userObj = Constatnts.getUserObject()
        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,]
        self.registerFirebaseEvents(PV_CEP_Home_Screen, "", "", "", parameters: firebaseParams as NSDictionary)
        self.recordScreenView("CEPHomePageActivity", "RHRDLandingViewController")
        self.lbl_myProfile.text = NSLocalizedString("cep_myProfile", comment: "") as NSString as String
        self.lbl_dasboard.text = NSLocalizedString("cep_Dashboard", comment: "") as NSString as String
        self.lbl_exit.text = NSLocalizedString("cep_Exit", comment: "") as NSString as String
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? NSString
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let  submittedDateImage = dateFormatter.string(from: Date())
        
        let dict: NSDictionary = [
            "mobileNumber": userObj.mobileNumber! as String,
            "deviceType": "iOS",
            "loginId": userObj.customerId! as String,
            "versionNo": version ?? "",
            "lastUpdatedTime": submittedDateImage
        ]
        cepJourneySingletonClass.getFarmerRHRDDashboardDetails(dictionary: dict ?? NSDictionary()) { (status, responseDictionary, statusMessage) in
            SwiftLoader.hide()
            if status == true{
                // print(responseDictionary)
                self.registerFirebaseEvents(PV_CEP_Spray_Request_Success, "", "", "", parameters: firebaseParams as NSDictionary)
                let dic = RHRDPDashboardBO(dict: responseDictionary ?? [:])
                self.username_lbl.text = String(format:"Hello %@",dic.farmerName as? String ?? "")
                
                var percentgeCompleted = dic.rhrdPercentCompleted as? String ?? ""
                var completedText = NSLocalizedString("completed_ofthe_journey", comment: "")
                self.profileCompltion_lbl.text = "\(percentgeCompleted) \(completedText) "
                
                let dic123 : NSDictionary = ["mdoMno" :  dic.mdoMno,
                                             "retailerMno" : dic.retailerMno]
                
                let userObj = Constatnts.getUserObject()
                userObj.updatemdoRetaile(dict: dic123)
                Constatnts.setUserToUserDefaults(user: userObj)
                
                if dic.rhrdProfileUpdate == "1"{
                    self.Profileupdate_view.backgroundColor = .green
                }
                if dic.rhrdReferral == "1"{
                    self.referral_view.backgroundColor = .green
                }
                
                if dic.rhrdFieldPictureUpload == "1"{
                    self.fieldSharing_view.backgroundColor = .green
                }
                if dic.rhrdGenuinityCheck == "1"{
                    self.scanAndWin_view.backgroundColor = .green
                }
                if dic.rhrdShareSuccessStory == "1"{
                    self.pexalonHighest_view.backgroundColor = .green
                }
                
                let imageUrl = URL(string: (dic.profilePicUrl) as? String ?? "")
                self.arrayFieldSharing = NSMutableArray()
                self.arrayFieldSharing.addObjects(from: (dic.fieldPictureStatments  ) as! [Any] )
                self.profile_img.downloadedFrom(url:imageUrl ?? NSURL() as URL , placeHolder: UIImage(named:"cepProfile"))
                self.profile_img.contentMode = .scaleToFill
                if dic.shareSuccessStory == "1"{
                    self.pexalonHighest_viewSection.isHidden = false
                }
                else{
                    self.pexalonHighest_viewSection.isHidden = true
                }
                
                if dic.referral == "1"{
                    self.referral_viewSection.isHidden = false
                }
                else{
                    self.referral_viewSection.isHidden = true
                }
                
                if dic.genuinityCheck == "1"{
                    self.scanAndWin_viewSection.isHidden = false
                }
                else{
                    self.scanAndWin_viewSection.isHidden = true
                }
                
                if dic.fieldPictureUpload == "1"{
                    self.fieldSharing_view.isHidden = false
                }
                else{
                    self.fieldSharing_view.isHidden = true
                }
                if dic.enrolProfileUpdate == "1"{
                    self.Profileupdate_viewSection.isHidden = false
                }
                else{
                    self.Profileupdate_viewSection.isHidden = true
                }
                
            }else{
                self.view.makeToast(statusMessage as String? ?? "")
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.view.sendSubview(toBack: popStackView)
        self.topView?.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.topView?.isHidden = false
        self.homeButton?.isHidden = true
        self.loadInitialdata()
        self.lblTitle?.text = NSLocalizedString("rhrd_title", comment: "")
        if isFromHome {
            self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        }else{
            self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
        }
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        moreButton = UIButton()
        moreButton?.frame = CGRect(x:self.topView!.frame.size.width-40,y: 15,width: 24,height: 24)
        moreButton?.backgroundColor =  UIColor.clear
        moreButton?.setImage( UIImage(named: "cepMore"), for: UIControlState())
        moreButton?.addTarget(self, action: #selector(RHRDLandingViewController.showPopover(_:)), for: UIControlEvents.touchUpInside)
        self.topView?.addSubview(moreButton!)
    }
    
    
    //MARK:- GOTO DASHBOARD ACTION
    @IBAction func gotoDashboard(_ sender: Any){
        let rewardsVC = self.storyboard?.instantiateViewController(withIdentifier: "CEPDashboardViewController") as? CEPDashboardViewController
        rewardsVC?.isRHRD = true
        self.navigationController?.pushViewController(rewardsVC!, animated: true)
    }
    
    
    //MARK:- BACKBUTTON
    override func backButtonClick(_ sender: UIButton) {
        backAlert = true
        self.unsavedChangesAlert = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: NSLocalizedString("alert", comment: "") as NSString, message: String(format: NSLocalizedString("RHRDExitMsg", comment: "")) as NSString, okButtonTitle:NSLocalizedString("yes", comment: "") , cancelButtonTitle: NSLocalizedString("no", comment: "")) as? UIView
        self.view.addSubview(self.unsavedChangesAlert!)
        
       
    }
    
    //MARK: alertYesBtnAction
    /**
     YES button action of the alertView which is displayed to the user
     when already logged in other device
     */
    @objc func alertYesBtnAction(){
        
        if self.unsavedChangesAlert != nil {
            self.unsavedChangesAlert?.removeFromSuperview()
        }
        if isFromHome{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.findHamburguerViewController()?.showMenuViewController()
        }
    }
    
//    @objc func infoAlertSubmit(){
//
//        if self.unsavedChangesAlert != nil {
//            self.unsavedChangesAlert?.removeFromSuperview()
//        }
//    }
    //MARK: alertNoBtnAction
    /**
     NO button action of the alertView which is displayed to the user
     when already logged in other device
     */
    @objc func alertNoBtnAction(){
        
        unsavedChangesAlert?.removeFromSuperview()
    }
    
    @IBAction func enrollment_action(_ sender: Any) {
        let profileVc = self.storyboard?.instantiateViewController(withIdentifier: "RHRDProfileupdateViewController") as? RHRDProfileupdateViewController
        self.navigationController?.pushViewController(profileVc!, animated: true)
        
    }
    
    
    //MARK:- REFERRAL ACTION
    @IBAction func refferalAction(_ sender: Any) {
        let profileVc = self.storyboard?.instantiateViewController(withIdentifier: "CEPReferralViewController") as? CEPReferralViewController
        profileVc?.isRHRD = true
        self.navigationController?.pushViewController(profileVc!, animated: true)
    }
    
    
    //MARK:- FIELD PICTURE SHARING
    @IBAction func fieldPictureSharing(_ sender: Any) {
        let profileVc = self.storyboard?.instantiateViewController(withIdentifier: "RHRDFieldSharingViewController") as? RHRDFieldSharingViewController
        self.navigationController?.pushViewController(profileVc!, animated: true)
    }
    
    //MARK:- SCAN AND WIN
    @IBAction func buyPexalonACtion(_ sender: Any) {
        //openGenunityCheckScanner()
        //self.openAcvission()
        self.openEmpoverScanner()
    }
    
    //MARK:- SHARE SUCCESS STORY
    @IBAction func shareSuccessStoryAction(_ sender: Any) {
        let profileVc = self.storyboard?.instantiateViewController(withIdentifier: "RHRDSuccessStoryViewController") as? RHRDSuccessStoryViewController
        self.navigationController?.pushViewController(profileVc!, animated: true)
    }
    
    

   /* func openGenunityCheckScanner(){
        let userObj = Constatnts.getUserObject()
        
        ClientConstants.initialize(
            deploymentEnvironment: .Test,
            isLocationRequired: true,
            guidingImage: UIImage(named: "uniquo_guidingImage"),
            enableButton: (info: false, back: true),
            color: (theme: App_Theme_Blue_Color,
                    frame: App_Theme_Blue_Color,
                    dots: App_Theme_Blue_Color),
            userDetails: UQUserDetails(userId:userObj.customerId! as String, mobile: "" , email: "", fullName: "")
        )
        let vc: UQScannerViewController = UQScannerViewController.instantiate()
        vc.scanDelegate  = self
        scannerVc = vc
        self.present(scannerVc!, animated: true, completion: nil)
    }*/
    
  /*  func onScanCompletion(result: UQScanResult) {
        //result.dictionary will provide [String:Any] JSON response
        //result.model will provide the object of Scanned Result (Optional)
        //result.error will provide the error while parsing the JSON to Model (Optional)
        
        scannerVc?.dismissUQScanner(animated: true, cb: {
            self.scannerVc =  nil
        })
        if statusMsgAlert != nil{
            self.statusMsgAlert?.removeFromSuperview()
        }
        
        var scanResult = result.dictionary as Dictionary
        
        var message = String(format: "%@", scanResult["message"] as! CVarArg)
        var ststusLogo = UIImage(named: "GenuinityFailure")
        
        let userObj = Constatnts.getUserObject()
        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Genunity_Status_Code:scanResult["responseCode"] ?? "",Product_Deatils:scanResult["productDetails"] ?? "",Serial_Number:scanResult["serialNumber"] ?? ""] as [String : Any]
        if scanResult["responseCode"] as? Int == Genunity_Status_Code_100{
            message = String(format: "%@ \n Serial number: %@",GenunitySuccessMessage, scanResult["serialNumber"] as! CVarArg )
            ststusLogo = UIImage(named: "GenuinitySuccess")
            self.registerFirebaseEvents(Genuinity_Check_Success, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
        }
        else if scanResult["responseCode"] as? Int == Genunity_Status_Code_101 || scanResult["responseCode"] as? Int == Genunity_Status_Code_102{
            message = String(format: GenunityFailureMessage, scanResult["message"] as! CVarArg)
            ststusLogo = UIImage(named: "GenuinityFailure")
            if scanResult["responseCode"] as? Int == Genunity_Status_Code_101 {
                self.registerFirebaseEvents(Genuine_Label_Inactive, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
            }
            else{
                self.registerFirebaseEvents(Scanned_Label_Invalid, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
            }
        }
        else if scanResult["responseCode"] as? Int == Genunity_Status_Code_103{
            message = String(format: GenunityAttemptsExceedMessage, scanResult["message"] as! CVarArg )
            ststusLogo = UIImage(named: "GenunityAttempts")
            self.registerFirebaseEvents(GC_Scan_Limt_Exceeded, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
        }
        else if scanResult["responseCode"] as? Int == Genunity_Status_Code_104{
            message = scanResult["message"] as! String
            ststusLogo = UIImage(named: "GenuinityFailure")
            self.registerFirebaseEvents(GC_Not_Geniune, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
        }
        else if scanResult["responseCode"] as? Int == Genunity_Status_Code_105{
            message = String(format: "%@", scanResult["message"] as! CVarArg)
            ststusLogo = UIImage(named: "GenuinityFailure")
            self.registerFirebaseEvents(message, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
        }
        else{
            message = scanResult["message"] as! String
        }
        
        let paramsStr = try! JSONSerialization.data(withJSONObject: scanResult, options: .prettyPrinted)
        
        let jsonString = NSString(data: paramsStr, encoding: String.Encoding.utf8.rawValue)! as String
        
        print("String result    \(jsonString)")
        
        Singleton.submitScannedUniquoBarcodeResultDataToServerRHRDCEP(scanResult: result.dictionary, userMessage: message, moduleType: "RHRD", completeResponse: jsonString, selectedLabel: "") { (status, responseDictionary, statusMessage) in
            
            if status == true{
                self.dictEncashResponse = NSDictionary()
   delegate as! AppDelegate
                   if statusMessage == STATUS_CODE_205{
                print(responseDictionary)
                self.dictEncashResponse = responseDictionary ?? NSDictionary()
                var strCashReward = ""
                if self.dictEncashResponse?.value(forKey: "rewardPoints") as? String != "" && self.dictEncashResponse?.value(forKey: "rewardPoints")  != nil {
                    let rupee = "\u{20B9} "
                    
                    strCashReward  = String(format: "Cash Back : %@%@/-",rupee,self.dictEncashResponse?.value(forKey: "rewardPoints") as? CVarArg ?? "")
                }else {
                    strCashReward = ""
                }
                
                let appDelegate = UIApplication.shared.                    let selectLableVC = self.storyboard?.instantiateViewController(withIdentifier: "RewardsPopupVC") as! RewardsPopupVC
                    selectLableVC.delegate = self
                    selectLableVC.dictEncashResponse = self.dictEncashResponse
                    selectLableVC.labelsArray = responseDictionary?.value(forKey: "unUsedPacketLabels") as? [String] ?? []
                    selectLableVC.windowTitle = responseDictionary?.value(forKey: "windowTitle") as? String ?? ""
                    selectLableVC.modalPresentationStyle = .overCurrentContext
                    self.present(selectLableVC, animated: true, completion: nil)
                    return
                }
                self.statusMsgAlert = CustomAlert.genunityCheckResultPopup(self, frame: appDelegate.window?.frame ?? self.view.frame, title: NSLocalizedString("genuinity_check", comment: "") as NSString, message: responseDictionary?.value(forKey: "uq_message") as? NSString ?? "N/A", buttonTitle1: responseDictionary?.value(forKey: "buttonTitle1") as? NSString ?? "", buttonTitle2: responseDictionary?.value(forKey: "buttonTitle2") as? NSString ?? "" , imgCorteva: UIImage(named:"corteva")!, statusLogo: ststusLogo!, hideClose: true, rewardMessage: responseDictionary?.value(forKey: "primaryRewardMsg") as? NSString ?? "", rewardMessage1: responseDictionary?.value(forKey: "secondaryRewardMsg") as? NSString ?? "", showEncashBtn: responseDictionary?.value(forKey: "showClickableLink") as? Bool ?? false,prodSerialNo: responseDictionary?.value(forKey: "prodSerialNumber") as? NSString ?? "",cashBackMsg: strCashReward as NSString, productName: responseDictionary?.value(forKey: "productName") as? NSString ?? "",  enableSprayService: responseDictionary?.value(forKey: "enableSprayService") as? Bool ?? false) as? UIView
                appDelegate.window?.rootViewController?.view.addSubview(self.statusMsgAlert!)
                //            self.view.addSubview(self.statusMsgAlert!)
            }else{
                self.view.makeToast(statusMessage ?? "Oops! Some thing went wrong. Please try again.")
            }
        }
    }*/
    
    //MARK: Acviss delegate methods
//   func openAcvission(){
//        let userObj = Constatnts.getUserObject()
//        let userId = userObj.customerId as? String ?? ""
//        let mobileNum = userObj.mobileNumber! as String
//        let usr =  AcvissCoreCertify.User.init(
//            linkedId: userId,
//                        token: "",
//                        mobile: (countryCode: "", number: mobileNum),
//                        fullName: "",
//                        email: ""
//                    )
//        let regularExpression = ["^([hH]{1}[tT]{2}[pP]{1}[sS]{1}:\\/\\/[cC]{1}[oO]{1}[iI]{1}[dD]{1}.[iI]{1}[nN]{1}\\/)","https:\\/\\/roots-cpm.ecubix.com\\/?.*","http:\\/\\/6\\.ivcs\\.ai\\/?.*"]
//        let acvission_configuration = Acvission.Configuration.init(
//            environment: .Production,
//            language: .English,
//            user: usr,
//            mode: Acvission.ScannerMode.Default,
//            regex: regularExpression,
//            scanMultiple: false,
//            enableCustomerSupportButton: true,
//            //type: Acvission.ScannerMode.OnlyVerify,
//            enableReportInvalid: false,
//            enableAudioInstructions: false,
//            enableBlurredFocus: true,
//            enableBackButton: false
//        )
//        Acvission.shared.instantiate(
//            with: acvission_configuration,
//            over: self,
//            style: .Show,
//            delegate: self
//        )
//    }
//    func onVerificationCompletion(raw: [String : Any], responseCode: ResponseCodeShared) {
//        
//        if statusMsgAlert != nil{
//            self.statusMsgAlert?.removeFromSuperview()
//        }
//        
//        if raw != nil{
//        var rawResult = raw as Dictionary
//        
//        var message = String(format: "%@", rawResult["message"] as! CVarArg)
//        var ststusLogo = UIImage(named: "GenuinityFailure")
//        
//        let userObj = Constatnts.getUserObject()
//        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Genunity_Status_Code: responseCode.rawValue ?? "",Product_Deatils:rawResult["product_details"] ?? "",Serial_Number:rawResult["serial_number"] ?? ""] as [String : Any]
//        
//        if responseCode.rawValue as? Int == Genunity_Status_Code_100{
//            message = String(format: "%@ \n Serial number: %@",GenunitySuccessMessage, rawResult["serial_number"] as? String ?? "")
//            ststusLogo = UIImage(named: "GenuinitySuccess")
//            self.registerFirebaseEvents(Genuinity_Check_Success, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
//        }
//        else if responseCode.rawValue as? Int == Genunity_Status_Code_101 || responseCode.rawValue as? Int == Genunity_Status_Code_102{
//            message = String(format: GenunityFailureMessage, rawResult["message"] as? String ?? "")
//            ststusLogo = UIImage(named: "GenuinityFailure")
//            if responseCode.rawValue as? Int == Genunity_Status_Code_101 {
//                self.registerFirebaseEvents(Genuine_Label_Inactive, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
//            }
//            else{
//                self.registerFirebaseEvents(Scanned_Label_Invalid, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
//            }
//        }
//        else if responseCode.rawValue as? Int == Genunity_Status_Code_103{
//            message = String(format: GenunityAttemptsExceedMessage, rawResult["message"] as? String ?? "")
//            ststusLogo = UIImage(named: "GenunityAttempts")
//            self.registerFirebaseEvents(GC_Scan_Limt_Exceeded, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
//        }
//        else if responseCode.rawValue as? Int == Genunity_Status_Code_104{
//            message = rawResult["message"] as? String ?? ""
//            ststusLogo = UIImage(named: "GenuinityFailure")
//            self.registerFirebaseEvents(GC_Not_Geniune, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
//        }
//        else if responseCode.rawValue as? Int == Genunity_Status_Code_105{
//            message = (rawResult["message"] as? String) ?? ""
////            message = String(format: "%@", rawResult["message"] as! CVarArg)
//            ststusLogo = UIImage(named: "GenuinityFailure")
//            self.registerFirebaseEvents(message, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
//        }
//        else{
//            message = rawResult["message"] as? String ?? ""
//        }
//        
//        let paramsStr = try! JSONSerialization.data(withJSONObject: rawResult["data"] ?? "", options: .prettyPrinted)
//        
//        let jsonString = NSString(data: paramsStr, encoding: String.Encoding.utf8.rawValue)! as String
//        
//        print("String result    \(jsonString)")
//        
//        Singleton.submitScannedUniquoBarcodeResultDataToServerRHRDCEP(scanResult: raw as Dictionary, userMessage: message, moduleType: "RHRD", completeResponse: jsonString, selectedLabel: "", responseCode: responseCode.rawValue) { (status, responseDictionary, statusMessage) in
//            
//            if status == true{
//                self.dictEncashResponse = NSDictionary()
//                print(responseDictionary)
//                
//                self.dictEncashResponse = responseDictionary ?? NSDictionary()
//                var strCashReward = ""
//                if self.dictEncashResponse?.value(forKey: "rewardPoints") as? String != "" && self.dictEncashResponse?.value(forKey: "rewardPoints")  != nil {
//                    let rupee = "\u{20B9} "
//                    
//                    strCashReward  = String(format: "Cash Back : %@%@/-",rupee,self.dictEncashResponse?.value(forKey: "rewardPoints") as? CVarArg ?? "")
//                }else {
//                    strCashReward = ""
//                }
//                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                if statusMessage == STATUS_CODE_205{
//                    let selectLableVC = self.storyboard?.instantiateViewController(withIdentifier: "RewardsPopupVC") as! RewardsPopupVC
//                    selectLableVC.delegate = self
//                    selectLableVC.dictEncashResponse = self.dictEncashResponse
//                    selectLableVC.labelsArray = responseDictionary?.value(forKey: "unUsedPacketLabels") as? [String] ?? []
//                    selectLableVC.windowTitle = responseDictionary?.value(forKey: "windowTitle") as? String ?? ""
//                    selectLableVC.modalPresentationStyle = .overCurrentContext
//                    self.present(selectLableVC, animated: true, completion: nil)
//                    return
//                }
//                var stausLogo = UIImage(named: "GenuinityFailure")
//                if self.dictEncashResponse?["uq_responseCode"] as? Int == 100{
//                    stausLogo = UIImage(named: "GenuinitySuccess")
//                }else{
//                    stausLogo = UIImage(named: "GenuinityFailure")
//                }
//                self.statusMsgAlert = CustomAlert.genunityCheckResultPopup(self, frame: appDelegate.window?.frame ?? self.view.frame, title: NSLocalizedString("genuinity_check", comment: "") as NSString, message: responseDictionary?.value(forKey: "uq_message") as? NSString ?? "N/A", buttonTitle1: responseDictionary?.value(forKey: "buttonTitle1") as? NSString ?? "", buttonTitle2: responseDictionary?.value(forKey: "buttonTitle2") as? NSString ?? "" , imgCorteva: UIImage(named:"corteva")!, statusLogo: stausLogo!, hideClose: true, rewardMessage: responseDictionary?.value(forKey: "primaryRewardMsg") as? NSString ?? "", rewardMessage1: responseDictionary?.value(forKey: "secondaryRewardMsg") as? NSString ?? "", showEncashBtn: responseDictionary?.value(forKey: "showClickableLink") as? Bool ?? false,prodSerialNo: responseDictionary?.value(forKey: "prodSerialNumber") as? NSString ?? "",cashBackMsg: strCashReward as NSString, productName: responseDictionary?.value(forKey: "productName") as? NSString ?? "",  enableSprayService: responseDictionary?.value(forKey: "enableSprayService") as? Bool ?? false) as? UIView
//                appDelegate.window?.rootViewController?.view.addSubview(self.statusMsgAlert!)
//                //            self.view.addSubview(self.statusMsgAlert!)
//            }else{
//                self.view.makeToast(statusMessage ?? "Oops! Some thing went wrong. Please try again.")
//            }
//        }
//        }
//    }
    ///Only detected code's value for Generic or Regex Match
//    func onDetectionOfExemptedCode(_ exemptedCodeDetails: ExemptedCode) {
//        let regularExpression = ["^([hH]{1}[tT]{2}[pP]{1}[sS]{1}:\\/\\/[cC]{1}[oO]{1}[iI]{1}[dD]{1}.[iI]{1}[nN]{1}\\/)","https:\\/\\/roots-cpm.ecubix.com\\/?.*","http:\\/\\/6\\.ivcs\\.ai\\/?.*"]
//        var checkForRegexMatch = regularExpression.filter{$0 == exemptedCodeDetails.matchedRegEx}
//        if checkForRegexMatch.count > 0{
//            var parameters = ["barCodeScannedValue":exemptedCodeDetails.barCodeScannedValue,"matchedRegEx":exemptedCodeDetails.matchedRegEx,"message":exemptedCodeDetails.message]
//            var scanResult = parameters as Dictionary
//            let paramsStr = try! JSONSerialization.data(withJSONObject: scanResult, options: .prettyPrinted)
//            let jsonString = NSString(data: paramsStr, encoding: String.Encoding.utf8.rawValue)! as String
//            DispatchQueue.main.async {
//                self.navigationController?.popViewController(animated: true)
//            }
//            Singleton.submitScannedUniquoBarcodeResultDataToServerRHRDCEP(scanResult: scanResult as Dictionary, userMessage: exemptedCodeDetails.message, moduleType: "RHRD", completeResponse: jsonString, selectedLabel: "", responseCode: 0) { (status, responseDictionary, statusMessage) in
//                
//                if status == true{
//                    self.dictEncashResponse = NSDictionary()
//                    self.dictEncashResponse = responseDictionary ?? NSDictionary()
//                    var strCashReward = ""
//                    if self.dictEncashResponse?.value(forKey: "rewardPoints") as? String != "" && self.dictEncashResponse?.value(forKey: "rewardPoints")  != nil {
//                        let rupee = "\u{20B9} "
//                        
//                        strCashReward  = String(format: "Cash Back : %@%@/-",rupee,self.dictEncashResponse?.value(forKey: "rewardPoints") as? CVarArg ?? "")
//                    }else {
//                        strCashReward = ""
//                    }
//                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                    if statusMessage == STATUS_CODE_205{
//                        let selectLableVC = self.storyboard?.instantiateViewController(withIdentifier: "RewardsPopupVC") as! RewardsPopupVC
//                        selectLableVC.delegate = self
//                        selectLableVC.dictEncashResponse = self.dictEncashResponse
//                        selectLableVC.labelsArray = responseDictionary?.value(forKey: "unUsedPacketLabels") as? [String] ?? []
//                        selectLableVC.windowTitle = responseDictionary?.value(forKey: "windowTitle") as? String ?? ""
//                        selectLableVC.modalPresentationStyle = .overCurrentContext
//                        self.present(selectLableVC, animated: true, completion: nil)
//                        return
//                    }
//                    var stausLogo = UIImage(named: "GenuinityFailure")
//                    if Int(self.dictEncashResponse?["uq_responseCode"] as? String ?? "") == 100{
//                        stausLogo = UIImage(named: "GenuinitySuccess")
//                    }else{
//                        stausLogo = UIImage(named: "GenuinityFailure")
//                    }
//                    self.statusMsgAlert = CustomAlert.genunityCheckResultPopup(self, frame: appDelegate.window?.frame ?? self.view.frame, title: NSLocalizedString("genuinity_check", comment: "") as NSString, message: responseDictionary?.value(forKey: "uq_message") as? NSString ?? "N/A", buttonTitle1: responseDictionary?.value(forKey: "buttonTitle1") as? NSString ?? "", buttonTitle2: responseDictionary?.value(forKey: "buttonTitle2") as? NSString ?? "" , imgCorteva: UIImage(named:"corteva")!, statusLogo: stausLogo!, hideClose: true, rewardMessage: responseDictionary?.value(forKey: "primaryRewardMsg") as? NSString ?? "", rewardMessage1: responseDictionary?.value(forKey: "secondaryRewardMsg") as? NSString ?? "", showEncashBtn: responseDictionary?.value(forKey: "showClickableLink") as? Bool ?? false,prodSerialNo: responseDictionary?.value(forKey: "prodSerialNumber") as? NSString ?? "",cashBackMsg: strCashReward as NSString, productName: responseDictionary?.value(forKey: "productName") as? NSString ?? "",  enableSprayService: responseDictionary?.value(forKey: "enableSprayService") as? Bool ?? false) as? UIView
//                    appDelegate.window?.rootViewController?.view.addSubview(self.statusMsgAlert!)
//                    //            self.view.addSubview(self.statusMsgAlert!)
//                }else{
//                    self.view.makeToast(statusMessage ?? "Oops! Some thing went wrong. Please try again.")
//                }
//            }
//        }
//        
//    }
    
    ///Multiple Scans
//    func onVerificationCompletion(results: [(model: LabelData?, raw: [String : Any])]) {
//        print("onVerificationCompletion:===>")
//        print(results)
//    }
    
    //MARK: - Empover Scanner
    func openEmpoverScanner(){
        let regexPatterns = [
            "^([hH]{1}[tT]{2}[pP]{1}[sS]{1}:\\/\\/[cC]{1}[oO]{1}[iI]{1}[dD]{1}\\.[iI]{1}[nN]{1}\\/)",
            "^([hH]{1}[tT]{2}[pP]{1}[sS]{1}:\\/\\/[uU]{1}[aA]{1}[tT]{1}\\.[fF]{1}[aA]{1}[rR]{1}[mM]{1}[eE]{1}[rR]{1}[cC]{1}[oO]{1}[nN]{2}[eE]{1}[cC]{1}[tT]{1}\\.[iI]{1}[nN]{1}\\/)",
            "^([hH]{1}[tT]{2}[pP]{1}[sS]{1}:\\/\\/[fF]{1}[aA]{1}[rR]{1}[mM]{1}[eE]{1}[rR]{1}[cC]{1}[oO]{1}[nN]{2}[eE]{1}[cC]{1}[tT]{1}\\.[iI]{1}[nN]{1}\\/)",
            "^[A-Z0-9]{8}$",
            "^www\\.checko\\.ai\\/\\?i=[A-Z0-9]{8}$",
            "^([a-zA-Z0-9]*)_[0-9]{10}_[a-z0-9A-Z]*_[0-9]*",
            "https:\\/\\/roots-cpm\\.ecubix\\.com\\/?.*",
            "http:\\/\\/6\\.ivcs\\.ai\\/?.*",
            "^sv1[A-Za-z0-9]{21,22}$",
            "^[A-Za-z]v1.*$",
            "(?i)^[A-Z0-9].*"
        ]
        let userObj = Constatnts.getUserObject()
        let userId = userObj.customerId! as String
        let mobileNum = userObj.mobileNumber! as String
        
        let getUserID = userId
        var getAuthId = ""
        var getToken = ""
        var getProjectId = ""
        var getEnvironment: ScannerConfiguration.Environment = .test
        var getProjectName = ""
        var getLanguage = ""
        
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        if BASE_URL == "https://pioneeractivity.com/rest/" {
            print("Its is PROD")
         getAuthId = "TYC67PL25OKMINBVCXS"
         getToken = "QAZCWSX25EDCIRFV12TGB45YHNUJMKLOPIUYTREWQASDFGH"
         getProjectId = "com.pioneer.india.directsales"
         getEnvironment = .production
         getProjectName = "Corteva Farmer Connect"
         getLanguage = "en"
        }
        else{
            print("Its is UAT")
         getAuthId = "ABCDE125FGHIJKLMN"
         getToken = "XQZCRTY25PLMINW8947ASD12KQWERTYUXMNBVCXZPOIUYTRE"
         getProjectId = "PROJ1004"
         getEnvironment = .test
         getProjectName = "Farmer Connect"
         getLanguage = "en"

        }
        print("getUserID iss: \(getUserID)")
         

        let user = ScannerUser(linkedId: getUserID, authId: getAuthId, token: getToken, fullName: "", email: "", deviceType: "IOS", projectId: getProjectId, projectName: getProjectName, userId: getUserID, mobileNumber: mobileNum)
        
        let config = ScannerConfiguration(regexPatterns: regexPatterns, environment: getEnvironment, user: user, scanMultiple: false, scannerType: "DEFAULT", referralCode: "", language: getLanguage)
        
        let scannerVC = ScannerViewController(config: config, delegate: self) // 'self' must conform to CameraScannerDelegate
        scannerVC.modalPresentationStyle = .fullScreen
        present(scannerVC, animated: true, completion: nil)
    }
    func didDetectQRCode(_ code: String) {
        print("Empover Scanner Detected QR Code: \(code)")
    }
    
    func didFailWithError(_ error: any Error) {
        print("Empover Scanner Error: \(error.localizedDescription)")
    }
    
    func didTapBackButton() {
        scannerView?.stopScanning()
        scannerView?.removeFromSuperview()
        scannerView = nil
        dismiss(animated: true)
    }
    
    func didReceiveAPIResponse(_ response: [String : Any]) {
        print("API Response: \(response)")
        scannerView?.stopScanning()
        DispatchQueue.main.async {
            let exemptedCodeDetails = response["exemptedCode"] as? EmpoverCameraScannerSDK.ExemptedCode
            print("Scanned value:", exemptedCodeDetails!.message)
            print("Scanned matchedRegEx value:", exemptedCodeDetails!.matchedRegEx)
            self.scannerView?.stopScanning()
            self.scannerView?.removeFromSuperview()
            self.scannerView = nil
            self.dismiss(animated: true)
            
            if self.statusMsgAlert != nil{
                self.statusMsgAlert?.removeFromSuperview()
            }

                    let regularExpression = [
                        "^([hH]{1}[tT]{2}[pP]{1}[sS]{1}:\\/\\/[cC]{1}[oO]{1}[iI]{1}[dD]{1}\\.[iI]{1}[nN]{1}\\/)",
                                                  "^([hH]{1}[tT]{2}[pP]{1}[sS]{1}:\\/\\/[uU]{1}[aA]{1}[tT]{1}\\.[fF]{1}[aA]{1}[rR]{1}[mM]{1}[eE]{1}[rR]{1}[cC]{1}[oO]{1}[nN]{2}[eE]{1}[cC]{1}[tT]{1}\\.[iI]{1}[nN]{1}\\/)",
                                                  "^([hH]{1}[tT]{2}[pP]{1}[sS]{1}:\\/\\/[fF]{1}[aA]{1}[rR]{1}[mM]{1}[eE]{1}[rR]{1}[cC]{1}[oO]{1}[nN]{2}[eE]{1}[cC]{1}[tT]{1}\\.[iI]{1}[nN]{1}\\/)",
                                                  "^[A-Z0-9]{8}$",
                                                  "^www\\.checko\\.ai\\/\\?i=[A-Z0-9]{8}$",
                                                  "^([a-zA-Z0-9]*)_[0-9]{10}_[a-z0-9A-Z]*_[0-9]*",
                                                  "https:\\/\\/roots-cpm\\.ecubix\\.com\\/?.*",
                                                  "http:\\/\\/6\\.ivcs\\.ai\\/?.*",
                                                  "^sv1[A-Za-z0-9]{21,22}$",
                                                  "^[A-Za-z]v1.*$",
                                                  "(?i)^[A-Z0-9].*"
                    ]
//            let server = exemptedCodeDetails?.matchedRegEx ?? ""
//            let checkForRegexMatch = regularExpression.filter {
//                $0.replacingOccurrences(of: "\\.", with: ".") == server.replacingOccurrences(of: "\\.", with: ".")
//            }
                  //  if checkForRegexMatch.count > 0{
                        var parameters = ["barCodeScannedValue":exemptedCodeDetails!.barCodeScannedValue,"matchedRegEx":exemptedCodeDetails!.matchedRegEx,"message":exemptedCodeDetails!.message]
                        var scanResult = parameters as Dictionary
                        let paramsStr = try! JSONSerialization.data(withJSONObject: scanResult, options: .prettyPrinted)
                        let jsonString = NSString(data: paramsStr, encoding: String.Encoding.utf8.rawValue)! as String
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                        Singleton.submitScannedUniquoBarcodeResultDataToServerRHRDCEP(scanResult: scanResult as Dictionary, userMessage: exemptedCodeDetails!.message, moduleType: "RHRD", completeResponse: jsonString, selectedLabel: "", responseCode: 0) { (status, responseDictionary, statusMessage) in
            
                            if status == true{
                                self.dictEncashResponse = NSDictionary()
                                self.dictEncashResponse = responseDictionary ?? NSDictionary()
                                var strCashReward = ""
                                if self.dictEncashResponse?.value(forKey: "rewardPoints") as? String != "" && self.dictEncashResponse?.value(forKey: "rewardPoints")  != nil {
                                    let rupee = "\u{20B9} "
            
                                    strCashReward  = String(format: "Cash Back : %@%@/-",rupee,self.dictEncashResponse?.value(forKey: "rewardPoints") as? CVarArg ?? "")
                                }else {
                                    strCashReward = ""
                                }
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                if statusMessage == STATUS_CODE_205{
                                    let selectLableVC = self.storyboard?.instantiateViewController(withIdentifier: "RewardsPopupVC") as! RewardsPopupVC
                                    selectLableVC.delegate = self
                                    selectLableVC.dictEncashResponse = self.dictEncashResponse
                                    selectLableVC.labelsArray = responseDictionary?.value(forKey: "unUsedPacketLabels") as? [String] ?? []
                                    selectLableVC.windowTitle = responseDictionary?.value(forKey: "windowTitle") as? String ?? ""
                                    selectLableVC.modalPresentationStyle = .overCurrentContext
                                    self.present(selectLableVC, animated: true, completion: nil)
                                    return
                                }
                                var stausLogo = UIImage(named: "GenuinityFailure")
                                if Int(self.dictEncashResponse?["uq_responseCode"] as? String ?? "") == 100{
                                    stausLogo = UIImage(named: "GenuinitySuccess")
                                }else{
                                    stausLogo = UIImage(named: "GenuinityFailure")
                                }
                                self.statusMsgAlert = CustomAlert.genunityCheckResultPopup(self, frame: appDelegate.window?.frame ?? self.view.frame, title: NSLocalizedString("genuinity_check", comment: "") as NSString, message: responseDictionary?.value(forKey: "uq_message") as? NSString ?? "N/A", buttonTitle1: responseDictionary?.value(forKey: "buttonTitle1") as? NSString ?? "", buttonTitle2: responseDictionary?.value(forKey: "buttonTitle2") as? NSString ?? "" , imgCorteva: UIImage(named:"corteva")!, statusLogo: stausLogo!, hideClose: true, rewardMessage: responseDictionary?.value(forKey: "primaryRewardMsg") as? NSString ?? "", rewardMessage1: responseDictionary?.value(forKey: "secondaryRewardMsg") as? NSString ?? "", showEncashBtn: responseDictionary?.value(forKey: "showClickableLink") as? Bool ?? false,prodSerialNo: responseDictionary?.value(forKey: "prodSerialNumber") as? NSString ?? "",cashBackMsg: strCashReward as NSString, productName: responseDictionary?.value(forKey: "productName") as? NSString ?? "",  enableSprayService: responseDictionary?.value(forKey: "enableSprayService") as? Bool ?? false) as? UIView
                                appDelegate.window?.rootViewController?.view.addSubview(self.statusMsgAlert!)
                                //            self.view.addSubview(self.statusMsgAlert!)
                            }else{
                                self.view.makeToast(statusMessage ?? "Oops! Some thing went wrong. Please try again.")
                            }
                        }
//                    }
           }
      
    }
    
    func onBackPressed() {
      /*  scannerVc?.dismissUQScanner(animated: true, cb: {
            self.scannerVc =  nil
        })*/
    }

    @objc func infoAlertScanMore(){
        
        if self.statusMsgAlert != nil {
            self.statusMsgAlert?.removeFromSuperview()
        }
        
        //self.openGenunityCheckScanner()
       // self.openAcvission()
        self.openEmpoverScanner()
        
    }
    @objc func infoCloseButton(){
        
        if self.statusMsgAlert != nil {
            self.statusMsgAlert?.removeFromSuperview()
        }
        
    }
    @objc func infoAlertSubmit(){
        if self.unsavedChangesAlert != nil {
            self.unsavedChangesAlert?.removeFromSuperview()
        }
        let userObj = Constatnts.getUserObject()
        let arrrayPayment = NSMutableArray()
        arrrayPayment.add(dictEncashResponse?.value(forKey: "viewPaymentOptions")  as? NSArray ?? [])
        
        if self.statusMsgAlert != nil {
            self.registerFirebaseEvents(GC_Exit, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "SideMenuViewController", parameters: nil)
            self.statusMsgAlert?.removeFromSuperview()
        }
        let multipleRewards =  dictEncashResponse?.value(forKey: "multipleRewards") as? Bool
        if  multipleRewards == true {
            self.registerFirebaseEvents(GC_Claim, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "HomeViewController", parameters: nil)
            let rewardsVC = self.storyboard?.instantiateViewController(withIdentifier: "RewardsViewController") as? RewardsViewController
            self.navigationController?.pushViewController(rewardsVC!, animated: true)
            return
        }
        let multipleRewards1 =  dictEncashResponse?.value(forKey: "multipleRewards") as? Bool
        let showClickableLink =  dictEncashResponse?.value(forKey: "showClickableLink") as? Bool
        if  multipleRewards1 == false &&  showClickableLink == true {
            let userObj = Constatnts.getUserObject()
            
            let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"rewardPoints" : dictEncashResponse?.value(forKey: "rewardPoints"),"screen_name" : "HomeViewController", "serverRecordId" : dictEncashResponse?.value(forKey: "serverRecordId")] as [String : Any]
            
            self.registerFirebaseEvents(Selected_Payment_Option_Confirm, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "HomeViewController", parameters: fireBaseParams as NSDictionary)
            
            let keys = self.dictEncashResponse?.allKeys as NSArray?
            var claimIDsArray = NSMutableArray()
            var params = NSDictionary()
            if (keys?.contains("ecouponFarmerId"))! {
                params = [ "serverRecordId" : dictEncashResponse?.value(forKey: "serverRecordId") as? NSString ?? "","benfTransactionId" : dictEncashResponse?.value(forKey: "benfTransactionId") as? NSString ?? "","ecouponFarmerMapId":dictEncashResponse?.value(forKey: "ecouponFarmerId") as? NSString ?? "" ]
            }
            else if (keys?.contains("seadProgramId"))!{
                params = [ "serverRecordId" : dictEncashResponse?.value(forKey: "serverRecordId") as? NSString ?? "","benfTransactionId" : dictEncashResponse?.value(forKey: "benfTransactionId") as? NSString ?? "", "programId": dictEncashResponse?.value(forKey: "seadProgramId") ]
            }
            else if (keys?.contains("dsrProgramId"))!{
                params = [ "serverRecordId" : dictEncashResponse?.value(forKey: "serverRecordId") as? NSString ?? "","benfTransactionId" : dictEncashResponse?.value(forKey: "benfTransactionId") as? NSString ?? "", "dsrId": dictEncashResponse?.value(forKey: "dsrProgramId")]
            }
            else {
                params = [ "serverRecordId" : dictEncashResponse?.value(forKey: "serverRecordId") as? NSString ?? "","benfTransactionId" : dictEncashResponse?.value(forKey: "benfTransactionId") as? NSString ?? ""]
            }
            
            
            
            claimIDsArray.add(params)
            let strCashReward  = self.dictEncashResponse?.value(forKey: "cashRewards") as? String // String(format: "Cash Back : Rs.%@/-",self.dictEncashResponse?.value(forKey: "cashRewards") as! CVarArg)
            
            var isRewardClaims : Bool = true
            var isSeedClaims: Bool = true
            var isDSRClaims: Bool = true
            
            var parameters = NSDictionary()
            if (keys?.contains("ecouponFarmerId"))! {
                isRewardClaims = false
                isSeedClaims = false
                isDSRClaims = false
                parameters = ["cashRewards":strCashReward ?? "","claimIDs":claimIDsArray,"ecouponFarmerMapId":dictEncashResponse?.value(forKey: "ecouponFarmerId") as? NSString ?? "","enableSprayService": dictEncashResponse?.value(forKey: "enableSprayService") as? Bool ?? false] as NSDictionary
            }else if (keys?.contains("seadProgramId"))!{
                isRewardClaims = false
                isSeedClaims = true
                isDSRClaims = false
                parameters = ["cashRewards":strCashReward ?? "","claimIDs":claimIDsArray,"programId": dictEncashResponse?.value(forKey: "seadProgramId"),"enableSprayService": dictEncashResponse?.value(forKey: "enableSprayService") as? Bool ?? false] as NSDictionary
            }else if (keys?.contains("dsrProgramId"))!{
                isRewardClaims = false
                isSeedClaims = false
                isDSRClaims = true
                parameters = ["cashRewards":strCashReward ?? "","claimIDs":claimIDsArray,"dsrId": dictEncashResponse?.value(forKey: "dsrProgramId"),"enableSprayService": dictEncashResponse?.value(forKey: "enableSprayService") as? Bool ?? false] as NSDictionary
            }
            else {
                isRewardClaims = true
                isSeedClaims = false
                isDSRClaims = false
                parameters = ["cashRewards":strCashReward ?? "","claimIDs":claimIDsArray,"enableSprayService": dictEncashResponse?.value(forKey: "enableSprayService") as? Bool ?? false] as NSDictionary
            }
            
            let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectModeOfTransferViewController") as? SelectModeOfTransferViewController
            toSelectPayVC?.dictEncashResponse = parameters  //dictEncashResponse
            toSelectPayVC?.isRewardClaims = isRewardClaims
            //viewPaymentOptions
            if arrrayPayment.count>0{
                toSelectPayVC?.viewPaymentOptions = arrrayPayment as? NSMutableArray ?? []
            }
            if (keys?.contains("seadProgramId"))!{
                toSelectPayVC?.programId = dictEncashResponse?.value(forKey: "seadProgramId") as! Int
            }
            if (keys?.contains("dsrProgramId"))!{
                toSelectPayVC?.dsrId = dictEncashResponse?.value(forKey: "dsrProgramId") as! Int
            }
            
            let arrrayPayment = NSMutableArray()
            arrrayPayment.add(dictEncashResponse?.value(forKey: "viewPaymentOptions")  as? NSArray ?? [])
            
            if arrrayPayment.count>0{
                toSelectPayVC?.viewPaymentOptions = arrrayPayment as? NSMutableArray ?? []
            }
            
            toSelectPayVC?.isFromSeedClaims = isSeedClaims
            // toSelectPayVC?.isfromDSRClaims = isDSRClaims
            self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
        }
    }
    
    @objc func gotoEncashPointsPage(){
        if self.statusMsgAlert != nil {
            self.statusMsgAlert?.removeFromSuperview()
        }
        let userObj = Constatnts.getUserObject()
        
        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"rewardPoints" : dictEncashResponse?.value(forKey: "rewardPoints"),"screen_name" : "HomeViewController", "serverRecordId" : dictEncashResponse?.value(forKey: "serverRecordId")] as [String : Any]
        
        self.registerFirebaseEvents(Selected_Payment_Option_Confirm, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "HomeViewController", parameters: fireBaseParams as NSDictionary)
        let keys = self.dictEncashResponse?.allKeys as NSArray?
        var claimIDsArray = NSMutableArray()
        var params = NSDictionary()
        if (keys?.contains("ecouponFarmerId"))! {
            params = [ "serverRecordId" : dictEncashResponse?.value(forKey: "serverRecordId") as? NSString ?? "","benfTransactionId" : dictEncashResponse?.value(forKey: "benfTransactionId") as? NSString ?? "","ecouponFarmerMapId":dictEncashResponse?.value(forKey: "ecouponFarmerId") as? NSString ?? ""]
        }else {
            params = [ "serverRecordId" : dictEncashResponse?.value(forKey: "serverRecordId") as? NSString ?? "","benfTransactionId" : dictEncashResponse?.value(forKey: "benfTransactionId") as? NSString ?? ""]
        }
        
        claimIDsArray.add(params)
        let strCashReward  = self.dictEncashResponse?.value(forKey: "cashRewards") as? String // String(format: "Cash Back : Rs.%@/-",self.dictEncashResponse?.value(forKey: "cashRewards") as! CVarArg)
        var isRewardClaims : Bool = true
        
        var parameters = NSDictionary()
        if (keys?.contains("ecouponFarmerId"))! {
            isRewardClaims = false
            parameters = ["cashRewards":strCashReward ?? "","claimIDs":claimIDsArray,"ecouponFarmerMapId":dictEncashResponse?.value(forKey: "ecouponFarmerId") as? NSString ?? ""] as NSDictionary
        }else {
            isRewardClaims = true
            
            parameters = ["cashRewards":strCashReward ?? "","claimIDs":claimIDsArray] as NSDictionary
        }
        
        
        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectModeOfTransferViewController") as? SelectModeOfTransferViewController
        toSelectPayVC?.dictEncashResponse = parameters  //dictEncashResponse
        toSelectPayVC?.isRewardClaims = isRewardClaims
        self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
        
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    //status code- 205
    func requestServerForRewardData(selectedLable:String, data: NSDictionary ){
        var ststusLogo = UIImage(named: "GenuinityFailure")
        var scanResult = data.value(forKey: "complete_response")
        
        let dict = convertToDictionary(text: scanResult as! String)
        Singleton.submitScannedUniquoBarcodeResultDataToServerNew(scanResult: dict, userMessage: "", completeResponse: scanResult as! String, selectedLabel: selectedLable ) { (status, responseDictionary, statusMessage) in
            if status == true{
                self.dictEncashResponse = NSDictionary()
                print(responseDictionary)
                self.dictEncashResponse = responseDictionary ?? NSDictionary()
                var strCashReward = ""
                if self.dictEncashResponse?.value(forKey: "rewardPoints") as? String != "" && self.dictEncashResponse?.value(forKey: "rewardPoints")  != nil {
                    let rupee = "\u{20B9} "
                    
                    strCashReward  = String(format: "Cash Back : %@%@/-",rupee,self.dictEncashResponse?.value(forKey: "rewardPoints") as? CVarArg ?? "")
                }else {
                    strCashReward = ""
                }
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                if statusMessage == STATUS_CODE_205{
                    let selectLableVC = self.storyboard?.instantiateViewController(withIdentifier: "RewardsPopupVC") as? RewardsPopupVC
                    selectLableVC?.dictEncashResponse = self.dictEncashResponse
                    selectLableVC?.labelsArray = responseDictionary?.value(forKey: "unUsedPacketLabels") as? [String] ?? []
                    self.navigationController?.pushViewController(selectLableVC!, animated: true)
                }
                self.statusMsgAlert = CustomAlert.genunityCheckResultPopup(self, frame: appDelegate.window?.frame ?? self.view.frame, title: ("Genuinity Check" as NSString?)!, message: responseDictionary?.value(forKey: "uq_message") as? NSString ?? "N/A", buttonTitle1: responseDictionary?.value(forKey: "buttonTitle1") as? NSString ?? "", buttonTitle2: responseDictionary?.value(forKey: "buttonTitle2") as? NSString ?? "" , imgCorteva: UIImage(named:"corteva")!, statusLogo: ststusLogo!, hideClose: true, rewardMessage: responseDictionary?.value(forKey: "primaryRewardMsg") as? NSString ?? "", rewardMessage1: responseDictionary?.value(forKey: "secondaryRewardMsg") as? NSString ?? "", showEncashBtn: responseDictionary?.value(forKey: "showClickableLink") as? Bool ?? false,prodSerialNo: responseDictionary?.value(forKey: "prodSerialNumber") as? NSString ?? "",cashBackMsg: strCashReward as NSString, productName: responseDictionary?.value(forKey: "productName") as? NSString ?? "",  enableSprayService: responseDictionary?.value(forKey: "enableSprayService") as? Bool ?? false) as? UIView
                appDelegate.window?.rootViewController?.view.addSubview(self.statusMsgAlert!)
                //            self.view.addSubview(self.statusMsgAlert!)
            }else{
                self.view.makeToast(statusMessage ?? "Oops! Some thing went wrong. Please try again.")
            }
        }
    }
    
    func showPopView(){
        
    }
    
    
    
    
}

