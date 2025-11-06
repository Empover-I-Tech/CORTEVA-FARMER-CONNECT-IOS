//
//  AddDetailsOfSelectedPaymentModeViewController.swift
//  FarmerConnect
//
//  Created by Apple on 10/09/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import UIKit

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
let ACCEPTABLE_CHARACTERS_ACC_NAME = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
let ACCEPTABLE_CHARACTERS_PH_NO = "1234567890"
let ACCEPTABLE_CHARACTERS_ACC_NUMBER = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
let ACCEPTABLE_CHARACTERS_UPI_VPA = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789._-@"
let ACCEPTABLE_CHARACTERS_IFSC_ALPHA = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

class AddDetailsOfSelectedPaymentModeViewController: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var viewAmazonPayDetails: UIView!
    @IBOutlet weak var viewPaytmDetails: UIView!
    @IBOutlet weak var viewUpiDetails: UIView!
    @IBOutlet weak var viewBankDetails: UIView!
    
    //Bank details
    @IBOutlet weak var txtIfscCode: UITextField!
    @IBOutlet weak var txtAccountNumber: UITextField!
    @IBOutlet weak var txtAccountName: UITextField!
    
    //UPI details
    @IBOutlet weak var txtUpiVpa: UITextField!
    
    // amazon pay
    @IBOutlet weak var txtAmazonPayPhoneNumber: UITextField!
    
    //paytm details
    
    @IBOutlet weak var txtPaytmPhoneNumber: UITextField!
    
    var paymentMode : String?
    
    var dictEncashResponse : NSDictionary?
    var backAlertView = UIView()
    var infoAlertView = UIView()
    var isRewardClaim = true
    var isSeedClaims = true
    var prorgamId = 0
    var isDSRClaims = false
    var dsrIdd = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let userObj = Constatnts.getUserObject()
        
        
        
        self.registerFirebaseEvents(PV_Selected_Payment_Option_Screen, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "AddDetailsOfSelectedPaymentModeViewController", parameters: nil)
        
        if paymentMode == PaymentModes.BANK.rawValue{
            viewBankDetails.isHidden = false
            viewAmazonPayDetails.isHidden = true
            viewUpiDetails.isHidden = true
            viewPaytmDetails.isHidden = true
        }
        else if paymentMode == PaymentModes.AMAZON.rawValue{
            viewBankDetails.isHidden = true
            viewAmazonPayDetails.isHidden = false
            viewUpiDetails.isHidden = true
            viewPaytmDetails.isHidden = true
            
        }
        else if paymentMode == PaymentModes.PAYTM.rawValue{
            viewBankDetails.isHidden = true
            viewAmazonPayDetails.isHidden = true
            viewUpiDetails.isHidden = true
            viewPaytmDetails.isHidden = false
            
        }
        else if paymentMode == PaymentModes.UPI.rawValue{
            viewBankDetails.isHidden = true
            viewAmazonPayDetails.isHidden = true
            viewUpiDetails.isHidden = false
            viewPaytmDetails.isHidden = true
        }
        
        txtUpiVpa.setBottomBorder()
        txtIfscCode.setBottomBorder()
        txtAccountNumber.setBottomBorder()
        txtAccountName.setBottomBorder()
        txtAmazonPayPhoneNumber.setBottomBorder()
        txtPaytmPhoneNumber.setBottomBorder()
        
        txtUpiVpa.delegate = self
        txtIfscCode.delegate = self
        txtAccountNumber.delegate = self
        txtAccountName.delegate = self
        txtAmazonPayPhoneNumber.delegate = self
        txtPaytmPhoneNumber.delegate = self
        
        btnConfirm.dropShadow()
        
    }
    
    override func backButtonClick(_ sender: UIButton) {
        
        if txtUpiVpa.text != "" || txtIfscCode.text != "" || txtAccountNumber.text != "" || txtAccountName.text != "" || txtAmazonPayPhoneNumber.text != "" || txtPaytmPhoneNumber.text != "" {
            
            self.backAlertView = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: "Confirmation" as NSString, message: ALERT_GO_BACK_MESSAGE as NSString, okButtonTitle: "YES", cancelButtonTitle: "NO") as! UIView
            self.view.addSubview(self.backAlertView)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func alertYesBtnAction(){
        backAlertView.removeFromSuperview()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func alertNoBtnAction(){
        backAlertView.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool){
        self.lblTitle?.text = NSLocalizedString("Transfer", comment: "")//"Transfer"
        if let cashReward =  self.dictEncashResponse?.value(forKey: "cashRewards") as? String {
            let rupee = "\u{20B9} "
            let cashRewardDouble = Double(cashReward) ?? 0.0
            //let truncatedAmount = Int(round(cashRewardDouble))
            
            self.lblRewardAmount?.text = String(format:"%@ %.2f",rupee,Double(cashReward) as? CVarArg ?? 0.00)  // + " Cash Reward"
            self.lblRewardAmount?.borderColor = UIColor.white
            self.lblRewardAmount?.borderWidth = 1.0
            self.lblRewardAmount?.clipsToBounds = true
        }
    }
    
    func checkBankValidations() -> Bool{
        if txtAccountName.text == ""{
            self.view.makeToast("Please enter account name")
            SwiftLoader.hide()
            return false
        }
        if txtAccountNumber.text == "" {
            self.view.makeToast("Please enter account number")
            SwiftLoader.hide()
            return false
        }
        if txtIfscCode.text == "" {
            self.view.makeToast("Please enter IFSC code")
            SwiftLoader.hide()
            return false
        }
        if txtAccountNumber.text?.count ?? 0 < 6 {
            self.view.makeToast("Please enter valid account number")
            SwiftLoader.hide()
            return false
        }
        if txtIfscCode.text?.count ?? 0 < 11  {
            self.view.makeToast("Please enter valid IFSC code")
            SwiftLoader.hide()
            return false
        }
        
        return true
    }
    
    func checkAmazonValidations() -> Bool{
        
        if txtAmazonPayPhoneNumber.text == "" || txtAmazonPayPhoneNumber.text?.count ?? 0 < 10{
            self.view.makeToast("Please enter valid mobile number")
            SwiftLoader.hide()
            return false
        }
        
        return true
    }
    
    func checkPaytmValidations() -> Bool{
        
        if txtPaytmPhoneNumber.text == "" || txtPaytmPhoneNumber.text?.count ?? 0 < 10{
            self.view.makeToast("Please enter valid mobile number")
            SwiftLoader.hide()
            return false
        }
        
        return true
    }
    
    func checkUpiValidations() -> Bool{
        
        if txtUpiVpa.text == ""{
            let errorMessage = NSLocalizedString("upi_error", comment: "")
            self.view.makeToast("\(errorMessage)")
            SwiftLoader.hide()
            return false
        }
        
        return true
    }
    
    @IBAction func confirmDetailsAndProceedToPayment(_ sender: Any) {
        SwiftLoader.show(animated: true)
        let userObj = Constatnts.getUserObject()
        
        if paymentMode == PaymentModes.BANK.rawValue {
            if checkBankValidations(){
                // let dict = ["accountName" : txtAccountName.text, "accountNumber" : txtAccountNumber.text, "ifscCode" : txtIfscCode.text,"paymentMode" : paymentMode, "phoneNumber" : userObj.mobileNumber ?? "0","cashRewards": dictEncashResponse?.value(forKey: "cashRewards") ?? "0", "servrRecordId" : dictEncashResponse?.value(forKey: "serverRecordId") ?? "0", "upiVpa" : "","benfTransactionId" : dictEncashResponse?.value(forKey: "benfTransactionId")] as NSDictionary
                let dict = ["accountName" : txtAccountName.text, "accountNumber" : txtAccountNumber.text, "ifscCode" : txtIfscCode.text,"paymentMode" : paymentMode, "phoneNumber" : userObj.mobileNumber ?? "0", "upiVpa" : "", "seadProgramId": prorgamId, "dsrId": dsrIdd] as NSMutableDictionary
                dict.addEntries(from: dictEncashResponse as! [AnyHashable : Any])
                print(dict)
                sendDetailsToServerAndGetTransactionStatus(dict: dict)
            }
        }
        else if paymentMode == PaymentModes.AMAZON.rawValue {
            if checkAmazonValidations(){
                //                let dict = ["accountName" : "", "accountNumber" : "", "ifscCode" : "","paymentMode" : paymentMode, "phoneNumber" : txtAmazonPayPhoneNumber.text,"cashRewards": dictEncashResponse?.value(forKey: "cashRewards") ?? "0", "servrRecordId" : dictEncashResponse?.value(forKey: "serverRecordId") ?? "0", "upiVpa" : "","benfTransactionId" : dictEncashResponse?.value(forKey: "benfTransactionId")] as NSDictionary
                var dict = ["accountName" : "", "accountNumber" : "", "ifscCode" : "","paymentMode" : paymentMode, "phoneNumber" : txtAmazonPayPhoneNumber.text, "upiVpa" : "", "seadProgramId": prorgamId, "dsrId": dsrIdd] as NSMutableDictionary
                dict.addEntries(from: dictEncashResponse as! [AnyHashable : Any])
                print(dict)
                sendDetailsToServerAndGetTransactionStatus(dict: dict)
            }
        }
        else if paymentMode == PaymentModes.PAYTM.rawValue {
            if checkPaytmValidations() {
                //                let dict = ["accountName" : "", "accountNumber" : "", "ifscCode" : "","paymentMode" : paymentMode, "phoneNumber" : txtPaytmPhoneNumber.text,"cashRewards": dictEncashResponse?.value(forKey: "cashRewards") ?? "0", "servrRecordId" : dictEncashResponse?.value(forKey: "serverRecordId") ?? "0", "upiVpa" : "","benfTransactionId" : dictEncashResponse?.value(forKey: "benfTransactionId")] as NSDictionary
                let dict = ["accountName" : "", "accountNumber" : "", "ifscCode" : "","paymentMode" : paymentMode, "phoneNumber" : txtPaytmPhoneNumber.text, "upiVpa" : "", "seadProgramId": prorgamId, "dsrId": dsrIdd] as NSMutableDictionary
                
                dict.addEntries(from: dictEncashResponse as! [AnyHashable : Any])
                print(dict)
                sendDetailsToServerAndGetTransactionStatus(dict: dict)
            }
        }
        else {
            if checkUpiValidations(){
                //                let dict = ["accountName" : "", "accountNumber" : "", "ifscCode" : "","paymentMode" : paymentMode, "phoneNumber" : userObj.mobileNumber,"cashRewards": dictEncashResponse?.value(forKey: "cashRewards") ?? "0", "servrRecordId" : dictEncashResponse?.value(forKey: "serverRecordId") ?? "0", "upiVpa" : txtUpiVpa.text,"benfTransactionId" : dictEncashResponse?.value(forKey: "benfTransactionId")] as NSDictionary
                
                let dict = ["accountName" : "", "accountNumber" : "", "ifscCode" : "","paymentMode" : paymentMode, "phoneNumber" : userObj.mobileNumber, "upiVpa" : txtUpiVpa.text,"seadProgramId": prorgamId, "dsrId": dsrIdd] as NSMutableDictionary
                dict.addEntries(from: dictEncashResponse as! [AnyHashable : Any])
                print(dict)
                sendDetailsToServerAndGetTransactionStatus(dict: dict)
            }
        }
    }
    
    func sendDetailsToServerAndGetTransactionStatus(dict: NSDictionary?){
        let userObj = Constatnts.getUserObject()
        
        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"Payment_Mode" : paymentMode,"screen_name" : "AddDetailsOfSelectedPaymentModeViewController", "serverRecordId" : dictEncashResponse?.value(forKey: "serverRecordId")] as [String : Any]
        
        self.registerFirebaseEvents(Selected_Payment_Option_Confirm, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "AddDetailsOfSelectedPaymentModeViewController", parameters: fireBaseParams as NSDictionary)
        
        if (isRewardClaim == true && isSeedClaims == false) || (isDSRClaims == true && isRewardClaim == false && isSeedClaims == false){ //For rewards transactions
            CashFreeSingletonClass.submitDetailsToServerAndGetTransactionStatus(dictionary: dict ?? NSDictionary()) { (status, responseDictionary, statusMessage) in
                SwiftLoader.hide()
                if status == true{
                    
                    if responseDictionary?.value(forKey: "status") as? String ?? "0" == "422" {
                        self.infoAlertView =  CustomAlert.alertInfoPopUpView(self, frame: self.view.frame, title: ("Error" as NSString?)!, message:responseDictionary?.value(forKey: "secondaryMsg") as? NSString ?? "", buttonTitle: NSLocalizedString("modify", comment: "").uppercased(), hideClose: true) as? UIView ?? UIView()
                        self.view.addSubview(self.infoAlertView)
                        
                    }else if  responseDictionary?.value(forKey: "status") as? String ?? "0" == "500" {
                        self.view.makeToast(statusMessage as String? ?? "")
                        
                    }else{
                        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "CashFreeTransactionStatusViewController") as? CashFreeTransactionStatusViewController
                        toSelectPayVC?.responseDictionary = responseDictionary
                        toSelectPayVC?.dictEncashResponse = self.dictEncashResponse
                        self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
                        
                    }
                }else{
                    self.view.makeToast(statusMessage as String? ?? "")
                }
            }
        }else if isRewardClaim == false && isSeedClaims == true{ //For seed transactions and seed 2 Transactions
            CashFreeSingletonClass.submitDetailsToServerAndGetTransactionStatusSeed(dictionary: dict ?? NSDictionary()) { (status, responseDictionary, statusMessage) in
                SwiftLoader.hide()
                if status == true{
                    
                    if responseDictionary?.value(forKey: "status") as? String ?? "0" == "422" {
                        self.infoAlertView =  CustomAlert.alertInfoPopUpView(self, frame: self.view.frame, title: ("Error" as NSString?)!, message:responseDictionary?.value(forKey: "secondaryMsg") as? NSString ?? "", buttonTitle: "MODIFY", hideClose: true) as? UIView ?? UIView()
                        self.view.addSubview(self.infoAlertView)
                        
                    }else if  responseDictionary?.value(forKey: "status") as? String ?? "0" == "500" {
                        self.view.makeToast(statusMessage as String? ?? "")
                        
                    }else{
                        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "CashFreeTransactionStatusViewController") as? CashFreeTransactionStatusViewController
                        toSelectPayVC?.responseDictionary = responseDictionary
                        toSelectPayVC?.dictEncashResponse = self.dictEncashResponse
                        self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
                        
                    }
                }else{
                    self.view.makeToast(statusMessage as String? ?? "")
                }
            }
            
        }else{ // For ecoupon transactions
            
            CashFreeSingletonClass.submitDetailsToServerAndGetTransactionStatusEcoupon(dictionary: dict ?? NSDictionary()) { (status, responseDictionary, statusMessage) in
                SwiftLoader.hide()
                if status == true{
                    
                    if responseDictionary?.value(forKey: "status") as? String ?? "0" == "422" {
                        self.infoAlertView =  CustomAlert.alertInfoPopUpView(self, frame: self.view.frame, title: ("Error" as NSString?)!, message:responseDictionary?.value(forKey: "secondaryMsg") as? NSString ?? "", buttonTitle: "MODIFY", hideClose: true) as? UIView ?? UIView()
                        self.view.addSubview(self.infoAlertView)
                        
                    }else if  responseDictionary?.value(forKey: "status") as? String ?? "0" == "500" {
                        self.view.makeToast(statusMessage as String? ?? "")
                        
                    }else{
                        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "CashFreeTransactionStatusViewController") as? CashFreeTransactionStatusViewController
                        toSelectPayVC?.responseDictionary = responseDictionary
                        toSelectPayVC?.dictEncashResponse = self.dictEncashResponse
                        self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
                        
                    }
                }else{
                    self.view.makeToast(statusMessage as String? ?? "")
                }
            }
        }
        
        //submitDetailsToServerAndGetTransactionStatusEcoupon
    }
    
    @objc func infoAlertSubmit(){
        self.infoAlertView.removeFromSuperview()
    }
    
    //MARK: Textfield delegate methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
        }
        
        if textField == txtAccountName{
            if textField.text?.count ?? 0 >= 100{
                return false
            }
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS_ACC_NAME).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            return (string == filtered)
        }
        
        if textField == txtAmazonPayPhoneNumber || textField == txtPaytmPhoneNumber{
            if textField.text?.count ?? 0 >= 10{
                return false
            }
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS_PH_NO).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            return (string == filtered)
        }
        if textField == txtAccountNumber {
            if textField.text?.count ?? 0 >= 40{
                return false
            }
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS_ACC_NUMBER).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            return (string == filtered)
            
        }
        //ACCEPTABLE_CHARACTERS_UPI_VPA
        if textField == txtUpiVpa {
            if textField.text?.count ?? 0 >= 100{
                return false
            }
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS_UPI_VPA).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            return (string == filtered)
            
        }
        if textField == txtIfscCode{
            if textField.text?.count ?? 0 >= 11 {
                return false
            }
            if textField.text?.count ?? 0 < 4 {
                let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS_IFSC_ALPHA).inverted
                let filtered = string.components(separatedBy: cs).joined(separator: "")
                return (string == filtered)
            }
            if textField.text?.count ?? 0 >= 4 && textField.text?.count ?? 0 < 11{
                let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS_PH_NO).inverted
                let filtered = string.components(separatedBy: cs).joined(separator: "")
                return (string == filtered)
            }
        }
        return false
    }
}
