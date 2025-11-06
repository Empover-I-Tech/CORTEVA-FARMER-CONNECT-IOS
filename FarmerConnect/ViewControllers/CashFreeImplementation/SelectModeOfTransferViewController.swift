//
//  SelectModeOfTransferViewController.swift
//  FarmerConnect
//
//  Created by Apple on 10/09/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import UIKit

extension UIButton {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension UIImageView {
    func dropimagehadow(scale: Bool = true) {
        layer.masksToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}


extension UIView {
    func dropViewShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

class SelectModeOfTransferViewController: BaseViewController {
    var dictEncashResponse : NSDictionary?
    var isRewardClaims = true
    var isFromSeedClaims = true
    var programId = 0
    var viewPaymentOptions = NSMutableArray()
    var  dsrId = 0
    
    @IBOutlet weak var amazonGiftCardButton: UIButton!
    @IBOutlet weak var upiButton: UIButton!
    @IBOutlet weak var paytmButton: UIButton!
    @IBOutlet weak var bankButton: UIButton!
    
    @IBOutlet weak var amazonGiftCardView: UIView!
    @IBOutlet weak var upiView: UIView!
    @IBOutlet weak var paytmView: UIView!
    @IBOutlet weak var bankView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.lblTitle?.text = NSLocalizedString("Transfer", comment: "")//"Transfer"
        
        if let cashReward =  self.dictEncashResponse?.value(forKey: "cashRewards") as? String {
            let rupee = "\u{20B9} "
            let cashRewardDoubleValue = Double(cashReward) ?? 0.0
            let truncatedAmount = Int(round(cashRewardDoubleValue))

            //self.lblRewardAmount?.text = String(format:"%@ %.2f",rupee,Double(cashReward) as? CVarArg ?? 0.00)  // + " Cash Reward"
            self.lblRewardAmount?.text = "\(rupee)\(cashRewardDoubleValue)"
            self.lblRewardAmount?.borderColor = UIColor.white
            self.lblRewardAmount?.borderWidth = 1.0
            self.lblRewardAmount?.clipsToBounds = true
        }
        
        if viewPaymentOptions.count>0{
            let dic =  viewPaymentOptions.object(at: 0)  as? NSArray ?? []
            if dic.contains("Bank Details") ||  dic.contains("BankDetails"){
                bankView.isHidden = false
            }
            else{
                bankView.isHidden = true
            }
            if dic.contains("upi") ||  dic.contains("UPI"){
                upiView.isHidden = false
            }
            else{
                upiView.isHidden = true
            }
            if dic.contains("paytm") ||  dic.contains("paytm"){
                paytmView.isHidden = false
            }
            else{
                paytmView.isHidden = true
            }
            if dic.contains("AmazonPaygiftCard") ||  dic.contains("Amazon Pay gift Card"){
                amazonGiftCardView.isHidden = false
            }
            else{
                amazonGiftCardView.isHidden = true
            }
        }
      
        let userObj = Constatnts.getUserObject()
        
        self.registerFirebaseEvents(PV_Payment_Option_Screen, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "SelectModeOfTransferViewController", parameters: nil)
    }
    
    @IBAction func gotoAmazonPaymentPage(_ sender: Any) {
        let userObj = Constatnts.getUserObject()
        
        self.registerFirebaseEvents(Payment_AmazonPay, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "SelectModeOfTransferViewController", parameters: nil)

        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "AddDetailsOfSelectedPaymentModeViewController") as? AddDetailsOfSelectedPaymentModeViewController
        toSelectPayVC?.paymentMode = PaymentModes.AMAZON.rawValue
        toSelectPayVC?.isRewardClaim = isRewardClaims
        toSelectPayVC?.dictEncashResponse = dictEncashResponse
        toSelectPayVC?.isSeedClaims = isFromSeedClaims
        toSelectPayVC?.prorgamId = programId
        toSelectPayVC?.dsrIdd = dsrId
        if dsrId == 1{
            toSelectPayVC?.isDSRClaims = true
        }
        self.navigationController?.pushViewController(toSelectPayVC!, animated: true)

    }
    @IBAction func gotoUpiPaymentPage(_ sender: Any) {
        let userObj = Constatnts.getUserObject()
        
        self.registerFirebaseEvents(Payment_UPI, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "SelectModeOfTransferViewController", parameters: nil)

        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "AddDetailsOfSelectedPaymentModeViewController") as? AddDetailsOfSelectedPaymentModeViewController
        toSelectPayVC?.paymentMode = PaymentModes.UPI.rawValue
        toSelectPayVC?.isRewardClaim = isRewardClaims
        toSelectPayVC?.isSeedClaims = isFromSeedClaims
        toSelectPayVC?.prorgamId = programId
        toSelectPayVC?.dictEncashResponse = dictEncashResponse
       
        toSelectPayVC?.dsrIdd = dsrId
        if dsrId == 1{
                   toSelectPayVC?.isDSRClaims = true
               }
        self.navigationController?.pushViewController(toSelectPayVC!, animated: true)

    }
    @IBAction func gotoPaytmPaymentPage(_ sender: Any) {
        let userObj = Constatnts.getUserObject()
        
        self.registerFirebaseEvents(Payment_PayTm, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "SelectModeOfTransferViewController", parameters: nil)

        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "AddDetailsOfSelectedPaymentModeViewController") as? AddDetailsOfSelectedPaymentModeViewController
        toSelectPayVC?.paymentMode = PaymentModes.PAYTM.rawValue
        toSelectPayVC?.dictEncashResponse = dictEncashResponse
     
        
        toSelectPayVC?.isRewardClaim = isRewardClaims
        toSelectPayVC?.isSeedClaims = isFromSeedClaims
        toSelectPayVC?.prorgamId = programId
        toSelectPayVC?.dsrIdd = dsrId
        if dsrId == 1{
                   toSelectPayVC?.isDSRClaims = true
               }
        self.navigationController?.pushViewController(toSelectPayVC!, animated: true)

    }
    @IBAction func gotoBankPayentPage(_ sender: Any) {
        let userObj = Constatnts.getUserObject()
        
        self.registerFirebaseEvents(Payment_Bank_Transfer, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "SelectModeOfTransferViewController", parameters: nil)

        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "AddDetailsOfSelectedPaymentModeViewController") as? AddDetailsOfSelectedPaymentModeViewController
        toSelectPayVC?.paymentMode = PaymentModes.BANK.rawValue
        toSelectPayVC?.dictEncashResponse = dictEncashResponse
        toSelectPayVC?.isRewardClaim = isRewardClaims
        toSelectPayVC?.isSeedClaims = isFromSeedClaims
        toSelectPayVC?.prorgamId = programId
        toSelectPayVC?.dsrIdd = dsrId
        if dsrId == 1{
                   toSelectPayVC?.isDSRClaims = true
               }
       
        self.navigationController?.pushViewController(toSelectPayVC!, animated: true)

    }
}
