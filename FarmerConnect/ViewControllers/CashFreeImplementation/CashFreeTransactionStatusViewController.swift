//
//  CashFreeTransactionStatusViewController.swift
//  FarmerConnect
//
//  Created by Apple on 10/09/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import UIKit

class CashFreeTransactionStatusViewController: BaseViewController {
    
    @IBOutlet weak var imgTransactionStatus: UIImageView!
    @IBOutlet weak var lblTransactionStatus: UILabel!
    @IBOutlet weak var lblTransactionDescription: UILabel!
    
    @IBOutlet weak var lbl_retailerTitle: UILabel!
    @IBOutlet weak var lbl_retailer_mobileNo: UILabel!
    @IBOutlet weak var lbl_retailer_mdo_mno: UILabel!
    
    @IBOutlet weak var text_retailer_mobileNo: UITextField!
    @IBOutlet weak var text_retailer_mdo_mno: UITextField!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var enterRetailerMno: UIButton!
    @IBOutlet weak var btnGoHome: UIButton!
    @IBOutlet weak var lblTransactionAmount: UILabel!
    @IBOutlet weak var lblSprayServiceAvailability: UIButton!
    @IBOutlet weak var lblSprayServiceAvailabilityConstraint: NSLayoutConstraint!
    @IBOutlet weak var img_reward_status: UIImageView!
    @IBOutlet weak var retailer_view_pop: UIView!
    var cashfreeTransactionId = ""
    var responseDictionary : NSDictionary?
    var dictEncashResponse : NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retailer_view_pop.isHidden = true
        
        self.lbl_retailer_mdo_mno.text = NSLocalizedString("cashfree_rMNo", comment: "")
        self.lbl_retailer_mobileNo.text = NSLocalizedString("cashfree_MDO_mNo", comment: "")
        
        // Do any additional setup after loading the view.
        self.lblTitle?.text = NSLocalizedString("Transfer", comment: "")//"Transfer"
        btnGoHome.dropShadow()
        
        let userObj = Constatnts.getUserObject()
        enterRetailerMno.isHidden = true
        if responseDictionary != nil{
            lblTransactionStatus.text = responseDictionary?.value(forKey: "succAndFailMsg") as? String ?? ""
            lblTransactionDescription.text = responseDictionary?.value(forKey: "secondaryMsg") as? String ?? ""
            
            if responseDictionary?.value(forKey: "subCode") != nil{
                if responseDictionary?.value(forKey: "subCode") as? String == "200"{
                    self.lblTransactionAmount?.isHidden = false
                    self.img_reward_status.isHidden = false
                    if let cashReward =  self.dictEncashResponse?.value(forKey: "cashRewards") as? String {
                        let rupee = "\u{20B9} "
                        var truncatedamount = Double(cashReward) ?? 0.0
                        var truncatedMaount = Int(round(truncatedamount))
                        self.lblTransactionAmount?.text = String(format:"%@ %.2f",rupee,Double(cashReward) as? CVarArg ?? 0.00)
                        self.lblTransactionAmount.text = "\(rupee)\(truncatedMaount)"
                        
                        
                    }
                    DispatchQueue.main.async(execute: {
                        
                        UIView.animate(withDuration: 20.0, delay: 1, options: ([.curveLinear, .repeat]), animations: {() -> Void in
                            self.lblSprayServiceAvailability.center = CGPoint(x: 0 - self.lblSprayServiceAvailability.bounds.size.width / 2, y: self.lblSprayServiceAvailability.center.y)
                            
                        }, completion:  nil)
                        
                    })
                    if let enableSprayService =  self.dictEncashResponse?.value(forKey: "enableSprayService") as? String {
                        lblSprayServiceAvailabilityConstraint.constant = 35
                        self.lblSprayServiceAvailability.isHidden = false
                    }else {
                        lblSprayServiceAvailabilityConstraint.constant = 0
                        self.lblSprayServiceAvailability.isHidden = true
                    }
                    
                    if let enableenableMdoRetailer =  self.dictEncashResponse?.value(forKey: "enableMdoRetailer") as? String {
                        enterRetailerMno.isHidden = false
                        self.cashfreeTransactionId = self.dictEncashResponse?.value(forKey: "cashfreeTransactionId") as? String ?? ""
                        self.text_retailer_mdo_mno.text = self.dictEncashResponse?.value(forKey: "mdoMno") as? String ?? ""
                        self.text_retailer_mobileNo.text = self.dictEncashResponse?.value(forKey: "retailerMno") as? String ?? ""
                    }
                    
                    
                    
                    imgTransactionStatus.image = UIImage(named: "success_transaction")
                    img_reward_status.image = UIImage(named:"reward-success")
                    
                    lblTransactionStatus.text = responseDictionary?.value(forKey: "succAndFailMsg") as? String ?? ""
                    lblTransactionDescription.text = responseDictionary?.value(forKey: "secondaryMsg") as? String ?? ""
                    
                    lblTransactionStatus.textColor = UIColor(red: 72.0/255.0, green: 193.0/255.0, blue: 71.0/255.0, alpha: 1.0)
                    
                    self.registerFirebaseEvents(PV_Completed_Payment_Succes, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "CashFreeTransactionStatusViewController", parameters: nil)
                }else  if responseDictionary?.value(forKey: "subCode") as? String == "201"{
                    if let cashReward =  self.dictEncashResponse?.value(forKey: "cashRewards") as? String {
                        let rupee = "\u{20B9} "
                        self.lblTransactionAmount?.text = String(format:"%@ %.2f",rupee,Double(cashReward) as? CVarArg ?? 0.00)
                    }
                    lblSprayServiceAvailabilityConstraint.constant = 0
                    self.lblSprayServiceAvailability.isHidden = true
                  //  enterRetailerMno.isHidden = false
                    
                    imgTransactionStatus.image = UIImage(named: "Failed-money-transfer")
                    img_reward_status.image = UIImage(named:"reward-success")
                    self.lblTransactionAmount?.isHidden = false
                    self.img_reward_status.isHidden = false
                    lblTransactionStatus.textColor = .black
                    self.registerFirebaseEvents(PV_Completed_Payment_Fail, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "CashFreeTransactionStatusViewController", parameters: nil)
                    
                }else{
                    imgTransactionStatus.image = UIImage(named: "Failed-money-transfer")
                    img_reward_status.image = UIImage(named:"reward-failure")
                    self.lblTransactionAmount?.isHidden = true
                    self.img_reward_status.isHidden = true
                  //  enterRetailerMno.isHidden = false
                    lblTransactionStatus.textColor = .red
                    self.registerFirebaseEvents(PV_Completed_Payment_Fail, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "CashFreeTransactionStatusViewController", parameters: nil)
                }
            }else{
                imgTransactionStatus.image = UIImage(named: "Failed-money-transfer")
                img_reward_status.image = UIImage(named:"reward-failure")
                self.lblTransactionAmount?.isHidden = true
                self.img_reward_status.isHidden = true
             //  enterRetailerMno.isHidden = false
                lblTransactionStatus.textColor = .red
                
                lblTransactionStatus.text = responseDictionary?.value(forKey: "message") as? String ?? ""
                
                self.registerFirebaseEvents(PV_Completed_Payment_Fail, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "CashFreeTransactionStatusViewController", parameters: nil)
            }
        }
    }
    
    //CASH_FREE_RETAILER_MOBILE
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.backButton?.isHidden = true
        
        let button1 = UIButton(type: .custom)
        button1.frame = CGRect(x: (topView?.frame.size.width)! - 45, y: 10, width: 30, height: 30)
        button1.setImage(UIImage(named: "Home_New"), for: .normal)
        button1.addTarget(self, action: #selector(gotoHomePage(_:)), for: .touchUpInside)
        topView?.addSubview(button1)
        
    }
    
    @IBAction func gotoHomePage(_ sender: Any) {
        
        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
        
    }
    @IBAction func retailerNumberPop(_ sender: Any) {
        
        retailer_view_pop.isHidden = false
        
    }
    
    @IBAction func retailerNumberPopClose(_ sender: Any) {
        
        retailer_view_pop.isHidden = true
        
    }
    
    @IBAction func submitRetailerNumberPop(_ sender: Any) {
        
        
        
        let dict: NSDictionary = [
            "retailerMno": self.text_retailer_mobileNo.text ?? "",
            "mdoMno":  self.text_retailer_mdo_mno.text ?? "",
            "cashfreeTransactionId": cashfreeTransactionId
        ]
        
        cepJourneySingletonClass.submitretailerMobileCashfree(dictionary: dict ) { (status, responseDictionary, statusMessage) in
            SwiftLoader.hide()
            print("responseDictionary ======= .")
            print(responseDictionary)
            if status == true{
                //                           let userObj = Constatnts.getUserObject()
                //                           let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,]
                //                           self.registerFirebaseEvents(PV_CEP_Referral_Success, "", "", "", parameters: firebaseParams as NSDictionary)
                //
                //UPDATE
                self.recordScreenView("CashFreeTransactionStatusViewController", "CashFreeTransactionStatusViewController")
                print(responseDictionary ?? [:])
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                appDelegate?.window?.makeToast(statusMessage as String? ?? "")
                let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
                
            }else{
                self.view.makeToast(statusMessage as String? ?? "")
            }
        }
        
        
    }
}
