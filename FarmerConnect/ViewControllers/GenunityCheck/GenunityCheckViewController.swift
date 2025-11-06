//////
//////  GenunityCheckViewController.swift
//////  FarmerConnect
//////
//////  Created by Empover-i-Tech on 28/09/19.
//////  Copyright © 2019 ABC. All rights reserved.
//////
////
////import UIKit
////import Alamofire
//////import UQScannerFramework
////
//class GenunityCheckViewController: BaseViewController , UIGestureRecognizerDelegate{
////
////    var scannerVc : UQScannerVC?
////    var statusMsgAlert : UIView?
////     var dictEncashResponse : NSDictionary?
////
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        self.openGenunityCheckScanner()
////        // Do any additional setup after loading the view.
////    }
////      func openGenunityCheckScanner(){
////
////        //        ClientConstants.initializeClientConstants(authId: Genunity_Auth_Id, authToken: Genunity_Auth_Token, baseUrl: Genunity_URL, themeColor: App_Theme_Green_Color, qrFrameColor: App_Theme_Green_Color, qrDotsColor: App_Theme_Green_Color, deploymentEnvironment: "prod", externalUserId: nil, mobileNo: nil, countryCode: nil, packageIdRequired: true, infoEnabled: false, settingsEnabled: true, backEnabled: true, notificationEnable: true, isLocation: false, isUploadImages: true, isUUID: false, fullName: nil, email: nil, hUQL: false, showQRFeedback: false, scanDetails: [], qrImgFileName: "File1")
////
////        ClientConstants.initialize(
////            deploymentEnvironment: .Test,
////            isLocationRequired: true,
////            enableButton: (info: false, back: true),
////            color: (theme: App_Theme_Blue_Color,
////                    frame: App_Theme_Blue_Color,
////                    dots: App_Theme_Blue_Color),
////            userDetails: nil
////        )
////
////        let storyBoard = UIStoryboard(name: "Authenticity", bundle: Bundle(for: UQScannerVC.classForCoder()))
////        let vc = storyBoard.instantiateViewController(withIdentifier: "ScannerVCID") as? UQScannerVC
////        vc?.scanDelegate  = self
////        scannerVc = vc
////        //let appdelegate = UIApplication.shared.delegate as? AppDelegate
////        //appdelegate?.window?.rootViewController = vc
////        self.present(scannerVc!, animated: true, completion: nil)
////        if let hamburguerViewController = self.findHamburguerViewController() {
////            hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
////            })
////        }
////    }
////    func onScanCompletion(result: UQScanResult) {
////        //result.dictionary will provide [String:Any] JSON response
////        //result.model will provide the object of Scanned Result (Optional)
////        //result.error will provide the error while parsing the JSON to Model (Optional)
////
////        scannerVc?.dismissUQScanner(animated: true, cb: {
////            self.scannerVc =  nil
////        })
////        if statusMsgAlert != nil{
////            self.statusMsgAlert?.removeFromSuperview()
////        }
////        var scanResult = result.dictionary as Dictionary
////
////        var message = String(format: "%@", scanResult["message"] as! CVarArg)
////        var ststusLogo = UIImage(named: "GenuinityFailure")
////
////        let userObj = Constatnts.getUserObject()
////        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Genunity_Status_Code:scanResult["responseCode"] ?? "",Product_Deatils:scanResult["productDetails"] ?? "",Serial_Number:scanResult["serialNumber"] ?? ""] as [String : Any]
////        if scanResult["responseCode"] as? Int == Genunity_Status_Code_100{
////            message = String(format: "%@ \n Serial number: %@",GenunitySuccessMessage, scanResult["serialNumber"] as! CVarArg )
////            ststusLogo = UIImage(named: "GenuinitySuccess")
////            self.registerFirebaseEvents(Genuinity_Check_Success, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
////        }
////        else if scanResult["responseCode"] as? Int == Genunity_Status_Code_101 || scanResult["responseCode"] as? Int == Genunity_Status_Code_102{
////            message = String(format: GenunityFailureMessage, scanResult["message"] as! CVarArg)
////            ststusLogo = UIImage(named: "GenuinityFailure")
////            if scanResult["responseCode"] as? Int == Genunity_Status_Code_101 {
////                self.registerFirebaseEvents(Genuine_Label_Inactive, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
////            }
////            else{
////                self.registerFirebaseEvents(Scanned_Label_Invalid, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
////            }
////        }
////        else if scanResult["responseCode"] as? Int == Genunity_Status_Code_103{
////            message = String(format: GenunityAttemptsExceedMessage, scanResult["message"] as! CVarArg )
////            ststusLogo = UIImage(named: "GenunityAttempts")
////            self.registerFirebaseEvents(GC_Scan_Limt_Exceeded, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
////        }
////        else if scanResult["responseCode"] as? Int == Genunity_Status_Code_104{
////            self.registerFirebaseEvents(GC_Not_Geniune, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
////        }
////        else if scanResult["responseCode"] as? Int == Genunity_Status_Code_105{
////            message = String(format: "%@", scanResult["message"] as! CVarArg)
////            ststusLogo = UIImage(named: "GenuinityFailure")
////            self.registerFirebaseEvents(message, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
////        }
////        else{
////            message = scanResult["message"] as! String
////        }
////
////        let paramsStr = try! JSONSerialization.data(withJSONObject: scanResult, options: .prettyPrinted)
////
////        let jsonString = NSString(data: paramsStr, encoding: String.Encoding.utf8.rawValue)! as String
////
////        print("String result    \(jsonString)")
////
////        let appDelegate = UIApplication.shared.delegate as! AppDelegate
////        //        self.statusMsgAlert = CustomAlert.genunityCheckResultPopup(self, frame: appDelegate.window!.frame, title: ("Genuinity Check" as NSString?)!, message: (message  as NSString?)!, buttonTitle: "OK", imgDupontLogo: UIImage(named:"DupontLogo")!, imgDowLogo:  UIImage(named:"DowLogo")!, statusLogo: ststusLogo!, hideClose: true) as? UIView
////
////        //currentViewController?.view.addSubview(self.statusMsgAlert!)
////        //self.view.addSubview(self.statusMsgAlert!)
////
////        //        Singleton.submitScannedUniquoBarcodeResultDataToServer(scanResult: result.dictionary,userMessage:message,completeResponse: jsonString)
////
////        Singleton.submitScannedUniquoBarcodeResultDataToServerNew(scanResult: result.dictionary, userMessage: message, completeResponse: jsonString) { (status, responseDictionary, statusMessage) in
////
////            self.dictEncashResponse = NSDictionary()
////            self.dictEncashResponse = responseDictionary ?? NSDictionary()
////
////            var strCashReward = ""
////            if self.dictEncashResponse?.value(forKey: "showClickableLink") as! Bool == true  {
////                strCashReward  = String(format: "Cash Back : Rs.%@/-",self.dictEncashResponse?.value(forKey: "cashRewards") as! CVarArg)
////            }else {
////                strCashReward = ""
////            }
////
////            self.statusMsgAlert = CustomAlert.genunityCheckResultPopup(self, frame: self.view.frame, title: ("Genuinity Check" as NSString?)!, message: responseDictionary?.value(forKey: "uq_message") as? NSString ?? "N/A", buttonTitle: "OK", imgCorteva: UIImage(named:"corteva")!, statusLogo: ststusLogo!, hideClose: true, rewardMessage: responseDictionary?.value(forKey: "primaryRewardMsg") as? NSString ?? "", rewardMessage1: responseDictionary?.value(forKey: "secondaryRewardMsg") as? NSString ?? "", showEncashBtn: responseDictionary?.value(forKey: "showClickableLink") as? Bool ?? false,prodSerialNo: responseDictionary?.value(forKey: "prodSerialNumber") as? NSString ?? "",cashBackMsg: strCashReward as NSString) as? UIView
////            self.view.addSubview(self.statusMsgAlert!)
////
////
////        }
////    }
////
////    func onBackPressed() {
////        scannerVc?.dismissUQScanner(animated: true, cb: {
////            self.scannerVc =  nil
////        })
////    }
////    @objc func infoAlertSubmit(){
////
////        if self.statusMsgAlert != nil {
////            self.statusMsgAlert?.removeFromSuperview()
////            self.findHamburguerViewController()?.showMenuViewController()
////        }
////
////        if dictEncashResponse?.value(forKey: "showClickableLink") as? Bool ?? false{
////            let userObj = Constatnts.getUserObject()
////
////            let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"rewardPoints" : dictEncashResponse?.value(forKey: "rewardPoints"),"screen_name" : "HomeViewController", "serverRecordId" : dictEncashResponse?.value(forKey: "serverRecordId")] as [String : Any]
////
////            self.registerFirebaseEvents(Selected_Payment_Option_Confirm, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "HomeViewController", parameters: fireBaseParams as NSDictionary)
////
////            let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectModeOfTransferViewController") as? SelectModeOfTransferViewController
////            toSelectPayVC?.dictEncashResponse = dictEncashResponse
////            self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
////        }
////    }
////
////    @objc func gotoEncashPointsPage(){
////        if self.statusMsgAlert != nil {
////            self.statusMsgAlert?.removeFromSuperview()
////        }
////        let userObj = Constatnts.getUserObject()
////
////        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"rewardPoints" : dictEncashResponse?.value(forKey: "rewardPoints"),"screen_name" : "HomeViewController", "serverRecordId" : dictEncashResponse?.value(forKey: "serverRecordId")] as [String : Any]
////
////        self.registerFirebaseEvents(Selected_Payment_Option_Confirm, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "HomeViewController", parameters: fireBaseParams as NSDictionary)
////
////        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectModeOfTransferViewController") as? SelectModeOfTransferViewController
////        toSelectPayVC?.dictEncashResponse = dictEncashResponse
////        self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
////
////    }
////
//<<<<<<< Updated upstream
////  GenunityCheckViewController.swift
////  FarmerConnect
////
////  Created by Empover-i-Tech on 28/09/19.
////  Copyright © 2019 ABC. All rights reserved.
////
//
//import UIKit
//import Alamofire
//import UQScannerFramework
//
//class GenunityCheckViewController: BaseViewController , UIGestureRecognizerDelegate,UQScannerDelegate{
//
//    var scannerVc : UQScannerVC?
//    var statusMsgAlert : UIView?
//     var dictEncashResponse : NSDictionary?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.openGenunityCheckScanner()
//        // Do any additional setup after loading the view.
//    }
//      func openGenunityCheckScanner(){
//        
//        //        ClientConstants.initializeClientConstants(authId: Genunity_Auth_Id, authToken: Genunity_Auth_Token, baseUrl: Genunity_URL, themeColor: App_Theme_Green_Color, qrFrameColor: App_Theme_Green_Color, qrDotsColor: App_Theme_Green_Color, deploymentEnvironment: "prod", externalUserId: nil, mobileNo: nil, countryCode: nil, packageIdRequired: true, infoEnabled: false, settingsEnabled: true, backEnabled: true, notificationEnable: true, isLocation: false, isUploadImages: true, isUUID: false, fullName: nil, email: nil, hUQL: false, showQRFeedback: false, scanDetails: [], qrImgFileName: "File1")
//        
//        ClientConstants.initialize(
//            deploymentEnvironment: .Test,
//            isLocationRequired: true,
//            enableButton: (info: false, back: true),
//            color: (theme: App_Theme_Blue_Color,
//                    frame: App_Theme_Blue_Color,
//                    dots: App_Theme_Blue_Color),
//            userDetails: nil
//        )
//        
//        let storyBoard = UIStoryboard(name: "Authenticity", bundle: Bundle(for: UQScannerVC.classForCoder()))
//        let vc = storyBoard.instantiateViewController(withIdentifier: "ScannerVCID") as? UQScannerVC
//        vc?.scanDelegate  = self
//        scannerVc = vc
//        //let appdelegate = UIApplication.shared.delegate as? AppDelegate
//        //appdelegate?.window?.rootViewController = vc
//        self.present(scannerVc!, animated: true, completion: nil)
//        if let hamburguerViewController = self.findHamburguerViewController() {
//            hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
//            })
//        }
//    }
//    func onScanCompletion(result: UQScanResult) {
//        //result.dictionary will provide [String:Any] JSON response
//        //result.model will provide the object of Scanned Result (Optional)
//        //result.error will provide the error while parsing the JSON to Model (Optional)
//        
//        scannerVc?.dismissUQScanner(animated: true, cb: {
//            self.scannerVc =  nil
//        })
//        if statusMsgAlert != nil{
//            self.statusMsgAlert?.removeFromSuperview()
//        }
//        var scanResult = result.dictionary as Dictionary
//        
//        var message = String(format: "%@", scanResult["message"] as! CVarArg)
//        var ststusLogo = UIImage(named: "GenuinityFailure")
//        
//        let userObj = Constatnts.getUserObject()
//        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Genunity_Status_Code:scanResult["responseCode"] ?? "",Product_Deatils:scanResult["productDetails"] ?? "",Serial_Number:scanResult["serialNumber"] ?? ""] as [String : Any]
//        if scanResult["responseCode"] as? Int == Genunity_Status_Code_100{
//            message = String(format: "%@ \n Serial number: %@",GenunitySuccessMessage, scanResult["serialNumber"] as! CVarArg )
//            ststusLogo = UIImage(named: "GenuinitySuccess")
//            self.registerFirebaseEvents(Genuinity_Check_Success, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
//        }
//        else if scanResult["responseCode"] as? Int == Genunity_Status_Code_101 || scanResult["responseCode"] as? Int == Genunity_Status_Code_102{
//            message = String(format: GenunityFailureMessage, scanResult["message"] as! CVarArg)
//            ststusLogo = UIImage(named: "GenuinityFailure")
//            if scanResult["responseCode"] as? Int == Genunity_Status_Code_101 {
//                self.registerFirebaseEvents(Genuine_Label_Inactive, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
//            }
//            else{
//                self.registerFirebaseEvents(Scanned_Label_Invalid, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
//            }
//        }
//        else if scanResult["responseCode"] as? Int == Genunity_Status_Code_103{
//            message = String(format: GenunityAttemptsExceedMessage, scanResult["message"] as! CVarArg )
//            ststusLogo = UIImage(named: "GenunityAttempts")
//            self.registerFirebaseEvents(GC_Scan_Limt_Exceeded, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
//        }
//        else if scanResult["responseCode"] as? Int == Genunity_Status_Code_104{
//            self.registerFirebaseEvents(GC_Not_Geniune, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
//        }
//        else if scanResult["responseCode"] as? Int == Genunity_Status_Code_105{
//            message = String(format: "%@", scanResult["message"] as! CVarArg)
//            ststusLogo = UIImage(named: "GenuinityFailure")
//            self.registerFirebaseEvents(message, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
//        }
//        else{
//            message = scanResult["message"] as! String
//        }
//        
//        let paramsStr = try! JSONSerialization.data(withJSONObject: scanResult, options: .prettyPrinted)
//        
//        let jsonString = NSString(data: paramsStr, encoding: String.Encoding.utf8.rawValue)! as String
//        
//        print("String result    \(jsonString)")
//        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        //        self.statusMsgAlert = CustomAlert.genunityCheckResultPopup(self, frame: appDelegate.window!.frame, title: ("Genuinity Check" as NSString?)!, message: (message  as NSString?)!, buttonTitle: "OK", imgDupontLogo: UIImage(named:"DupontLogo")!, imgDowLogo:  UIImage(named:"DowLogo")!, statusLogo: ststusLogo!, hideClose: true) as? UIView
//        
//        //currentViewController?.view.addSubview(self.statusMsgAlert!)
//        //self.view.addSubview(self.statusMsgAlert!)
//        
//        //        Singleton.submitScannedUniquoBarcodeResultDataToServer(scanResult: result.dictionary,userMessage:message,completeResponse: jsonString)
//        
//        Singleton.submitScannedUniquoBarcodeResultDataToServerNew(scanResult: result.dictionary, userMessage: message, completeResponse: jsonString) { (status, responseDictionary, statusMessage) in
//            
//            self.dictEncashResponse = NSDictionary()
//            self.dictEncashResponse = responseDictionary ?? NSDictionary()
//            
//            var strCashReward = ""
//            if self.dictEncashResponse?.value(forKey: "showClickableLink") as! Bool == true  {
//                strCashReward  = String(format: "Cash Back : Rs.%@/-",self.dictEncashResponse?.value(forKey: "cashRewards") as! CVarArg)
//            }else {
//                strCashReward = ""
//            }
//            
////            self.statusMsgAlert = CustomAlert.genunityCheckResultPopup(self, frame: self.view.frame, title: ("Genuinity Check" as NSString?)!, message: responseDictionary?.value(forKey: "uq_message") as? NSString ?? "N/A", buttonTitle: "OK", imgCorteva: UIImage(named:"corteva")!, statusLogo: ststusLogo!, hideClose: true, rewardMessage: responseDictionary?.value(forKey: "primaryRewardMsg") as? NSString ?? "", rewardMessage1: responseDictionary?.value(forKey: "secondaryRewardMsg") as? NSString ?? "", showEncashBtn: responseDictionary?.value(forKey: "showClickableLink") as? Bool ?? false,prodSerialNo: responseDictionary?.value(forKey: "prodSerialNumber") as? NSString ?? "",cashBackMsg: strCashReward as NSString) as? UIView
////            self.view.addSubview(self.statusMsgAlert!)
//            
//            
//        }
//    }
//    
//    func onBackPressed() {
//        scannerVc?.dismissUQScanner(animated: true, cb: {
//            self.scannerVc =  nil
//        })
//    }
//    @objc func infoAlertSubmit(){
//        
//        if self.statusMsgAlert != nil {
//            self.statusMsgAlert?.removeFromSuperview()
//            self.findHamburguerViewController()?.showMenuViewController()
//        }
//        
//        if dictEncashResponse?.value(forKey: "showClickableLink") as? Bool ?? false{
//            let userObj = Constatnts.getUserObject()
//            
//            let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"rewardPoints" : dictEncashResponse?.value(forKey: "rewardPoints"),"screen_name" : "HomeViewController", "serverRecordId" : dictEncashResponse?.value(forKey: "serverRecordId")] as [String : Any]
//            
//            self.registerFirebaseEvents(Selected_Payment_Option_Confirm, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "HomeViewController", parameters: fireBaseParams as NSDictionary)
//            
//            let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectModeOfTransferViewController") as? SelectModeOfTransferViewController
//            toSelectPayVC?.dictEncashResponse = dictEncashResponse
//            self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
//        }
//    }
//    
//    @objc func gotoEncashPointsPage(){
//        if self.statusMsgAlert != nil {
//            self.statusMsgAlert?.removeFromSuperview()
//        }
//        let userObj = Constatnts.getUserObject()
//        
//        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"rewardPoints" : dictEncashResponse?.value(forKey: "rewardPoints"),"screen_name" : "HomeViewController", "serverRecordId" : dictEncashResponse?.value(forKey: "serverRecordId")] as [String : Any]
//        
//        self.registerFirebaseEvents(Selected_Payment_Option_Confirm, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "HomeViewController", parameters: fireBaseParams as NSDictionary)
//        
//        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectModeOfTransferViewController") as? SelectModeOfTransferViewController
//        toSelectPayVC?.dictEncashResponse = dictEncashResponse
//        self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
//        
//    }
//
//}
