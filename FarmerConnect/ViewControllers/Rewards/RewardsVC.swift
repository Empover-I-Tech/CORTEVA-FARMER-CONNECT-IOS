//
//  RewardsVC.swift
//  FarmerConnect
//
//  Created by Empover on 19/05/21.
//  Copyright © 2021 ABC. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class RewardsVC: BaseViewController {
    
    @IBOutlet weak var rewardPointsView: UIView!
    @IBOutlet weak var rewardPointsTitle: UILabel!
    @IBOutlet weak var rewardPointsheightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tblVw: UITableView!
    
    let kHeaderSectionTag: Int = 6900;
    let kHeaderSectionTagEcoupon: Int = 7900;
    let kHeaderSectionTagSeed: Int = 8900;
    let kHeaderSectionTagSeed2: Int = 9900;
    let KHeaderSectionTagDSR: Int = 9100;
    
    var sectionNames = [SectionDetails]()
    var sectionNamesEcoupon = [SectionDetails]()
    var sectionNamesSeed = [SectionDetails]()
    var sectionNamesSeed2 = [SectionDetails]()
    var sectionNamesDSR = [SectionDetails]()
    
    var isFromHome : Bool = false
    
    var arrayTransactions = [TransactionModel]()
    var arrayTransactionsEcoupon = [TransactionModel]()
    
    var successTransactionsEcoupon = [TransactionModel]()
    var claimTransactionsEcoupon = [TransactionModel]()
    var reclaimTransactionsEcoupon = [TransactionModel]()
    
    var successTransactions = [TransactionModel]()
    var claimTransactions = [TransactionModel]()
    var reclaimTransactions = [TransactionModel]()
    
    var successSeedTransactions = [TransactionModel]()
    var claimSeedTransactions = [TransactionModel]()
    var reclaimSeedTransactions = [TransactionModel]()
    
    var successSeed2Transactions = [TransactionModel]()
    var claimSeed2Transactions = [TransactionModel]()
    var reclaimSeed2Transactions = [TransactionModel]()
    
    var successDSRTransactions = [TransactionModel]()
    var claimDSRTransactions = [TransactionModel]()
    var reclaimDSRTransactions = [TransactionModel]()
    
    var couponCodesList = [ecouponCodeList]()
    
    var totalClaimAmount : Double =  0.0
    var totalClaimAmountEcoupon : Double =  0.0
    var totalClaimAmountSeed: Double = 0.0
    var totalClaimAmountSeed2: Double = 0.0
    var totalClaimAmountDSR: Double = 0.0
    
    var theImageView = UIImageView()
    
    var rewardsData : NSDictionary?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        self.rewardPointsView.isHidden = true
        self.rewardPointsheightConstraint.constant = 0
        
        let nib = UINib(nibName: "CouponTableViewCell", bundle:nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "CouponTableViewCell")
        
        let refreshButton = UIButton(type: .custom)
        refreshButton.frame = CGRect(x: (self.topView?.frame.size.width)! - 50, y: 10, width: 35, height: 35)
        refreshButton.addTarget(self, action: #selector(RewardsViewController.refreshMyTransactionsClick(_:)), for: .touchUpInside)
        refreshButton.setImage(UIImage(named: "RefreshWhite"), for: .normal)
        self.topView?.addSubview(refreshButton)
        let userObj = Constatnts.getUserObject()
        
        self.registerFirebaseEvents(PV_RewardsList, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", CashFreeRewards , parameters: nil)
        
        let params : NSMutableDictionary = ["reClaim" : "No", "moduleType": "Farmer"]
        self.requestToGetgetFarmerRewards(params: params )
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.topView?.isHidden = false
        self.homeButton?.isHidden = true
        self.lblTitle?.text = NSLocalizedString("rewards", comment: "")
        if isFromHome {
            self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        }else{
            self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
        }
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
    }
    override func backButtonClick(_ sender: UIButton){
//        self.navigationController?.popViewController(animated: true)
//        return
        if isFromHome{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.findHamburguerViewController()?.showMenuViewController()
        }
    }
    
    func requestToGetgetFarmerRewards(params : NSMutableDictionary){
        SwiftLoader.show(animated: true)
        let headers = Constatnts.getLoggedInFarmerHeaders()
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,Get_User_Rewards]  ) // // ["http://192.168.3.141:8080/ATP/rest/" ,"cashFreeReward/getCashFreeTransactionPendingRequest_V2"]
        let paramsStr = Constatnts.nsobjectToJSON(params )
        
        
        let params =  ["data" : paramsStr]
        
        print(headers)
        Alamofire.request(urlString, method: .post, parameters :  params , encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        self.rewardsData = decryptData
                        print("Response after decrypting data:\(decryptData)")
                        self.arrayTransactions.removeAll()
                        self.arrayTransactionsEcoupon.removeAll()
                        
                        let userObj = Constatnts.getUserObject()

                        if let rewardPoints = decryptData.value(forKey: "rewardPoints") as? String{
                            self.rewardPointsTitle.text = rewardPoints
                            self.rewardPointsView.isHidden = false
                            self.rewardPointsheightConstraint.constant = 40
                        }else{
                            self.rewardPointsTitle.text = ""
                            self.rewardPointsView.isHidden = true
                            self.rewardPointsheightConstraint.constant = 0
                        }
                        
                        if let cashFree = decryptData.value(forKey: "cashFreeTransactionList") as? NSDictionary {
                            let arrayStatus = cashFree.allKeys as NSArray
                            if arrayStatus.contains("programTitle"){
                                let title = cashFree["programTitle"] as! String
                                //self.rewardTitle.text = title.uppercased()
                            }
                            if arrayStatus.contains("claimList"){
                                let claimTrans = cashFree["claimList"] as! NSArray
                                self.claimTransactions.removeAll()
                                if claimTrans.count > 0 {
                                    for i in claimTrans {
                                        let arrTrans = TransactionModel()
                                        arrTrans.amount = (i as AnyObject).value(forKey: "amount") as? String ?? ""
                                        arrTrans.beneId = (i as AnyObject).value(forKey: "beneId") as? String ?? ""
                                        arrTrans.cashRewards = (i as AnyObject).value(forKey: "cashRewards") as? String ?? ""
                                        arrTrans.cgUrl = (i as AnyObject).value(forKey: "cgUrl") as? String ?? ""
                                        arrTrans.mobileNumber = (i as AnyObject).value(forKey: "mobileNumber") as? String ?? ""
                                        arrTrans.transferMode = (i as AnyObject).value(forKey: "transferMode") as? String ?? ""
                                        arrTrans.createdOn = (i as AnyObject).value(forKey: "createdOn") as? String ?? ""
                                        arrTrans.status = (i as AnyObject).value(forKey: "status") as? String ?? ""
                                        arrTrans.referenceId = (i as AnyObject).value(forKey: "referenceId") as? String ?? ""
                                        arrTrans.prodSerialNumber = (i as AnyObject).value(forKey: "prodSerialNumber") as? String ?? ""
                                        print((i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0)
                                        arrTrans.cashFreeTransactionId = (i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0
                                        arrTrans.ecouponFarmerMapId = (i as AnyObject).value(forKey: "ecouponFarmerMapId") as? Int ?? 0
                                        arrTrans.seasonId = (i as AnyObject).value(forKey: "seasonId") as? Int ?? 0
                                        
                                        arrTrans.farmerRewardCashPaymentModeId = (i as AnyObject).value(forKey: "farmerRewardCashPaymentModeId") as? Int ?? 0
                                        arrTrans.transferId = (i as AnyObject).value(forKey: "transferId") as? String ?? ""
                                        arrTrans.id = (i as AnyObject).value(forKey: "id") as? String ?? ""
                                        arrTrans.message = (i as AnyObject).value(forKey: "message") as? String ?? ""
                                        arrTrans.modifiedOn = (i as AnyObject).value(forKey: "modifiedOn") as? String ?? ""
                                        arrTrans.buttonText =  (i as AnyObject).value(forKey: "buttonText") as? String ?? ""
                                        arrTrans.serverRecordId = (i as AnyObject).value(forKey: "serverRecordId") as? String ?? ""
                                        arrTrans.benfTransactionId = (i as AnyObject).value(forKey: "benfTransactionId") as? String ?? ""
                                        arrTrans.productName = (i as AnyObject).value(forKey: "productName") as? String ?? ""
                                        arrTrans.showView = (i as AnyObject).value(forKey: "showView") as? Bool ?? false
                                        arrTrans.programId = ( i as AnyObject).value(forKey: "programId") as? Int ?? 0
                                        arrTrans.dsrProgramId = (i as AnyObject).value(forKey: "dsrId") as? Int ?? 0
                                        self.claimTransactions.append(arrTrans)
                                        
                                    }
                                }
                            }
                            if arrayStatus.contains("successList"){
                                let successTrans = cashFree["successList"] as! NSArray
                                self.successTransactions.removeAll()
                                if successTrans.count > 0 {
                                    for i in successTrans {
                                        let arrTrans = TransactionModel()
                                        arrTrans.amount = (i as AnyObject).value(forKey: "amount") as? String ?? ""
                                        arrTrans.beneId = (i as AnyObject).value(forKey: "beneId") as? String ?? ""
                                        arrTrans.cashRewards = (i as AnyObject).value(forKey: "cashRewards") as? String ?? ""
                                        arrTrans.cgUrl = (i as AnyObject).value(forKey: "cgUrl") as? String ?? ""
                                        arrTrans.mobileNumber = (i as AnyObject).value(forKey: "mobileNumber") as? String ?? ""
                                        arrTrans.transferMode = (i as AnyObject).value(forKey: "transferMode") as? String ?? ""
                                        arrTrans.createdOn = (i as AnyObject).value(forKey: "createdOn") as? String ?? ""
                                        arrTrans.status = (i as AnyObject).value(forKey: "status") as? String ?? ""
                                        arrTrans.referenceId = (i as AnyObject).value(forKey: "referenceId") as? String ?? ""
                                        print((i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0)
                                        arrTrans.cashFreeTransactionId = (i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0
                                        arrTrans.prodSerialNumber = (i as AnyObject).value(forKey: "prodSerialNumber") as? String ?? ""
                                        arrTrans.transferId = (i as AnyObject).value(forKey: "transferId") as? String ?? ""
                                        arrTrans.id = (i as AnyObject).value(forKey: "id") as? String ?? ""
                                        arrTrans.message = (i as AnyObject).value(forKey: "message") as? String ?? ""
                                        arrTrans.modifiedOn = (i as AnyObject).value(forKey: "modifiedOn") as? String ?? ""
                                        arrTrans.buttonText =  (i as AnyObject).value(forKey: "buttonText") as? String ?? ""
                                        arrTrans.serverRecordId = (i as AnyObject).value(forKey: "serverRecordId") as? String ?? ""
                                        arrTrans.benfTransactionId = (i as AnyObject).value(forKey: "benfTransactionId") as? String ?? ""
                                        arrTrans.productName = (i as AnyObject).value(forKey: "productName") as? String ?? ""
                                        arrTrans.showView = (i as AnyObject).value(forKey: "showView") as? Bool ?? false
                                        arrTrans.ecouponFarmerMapId = (i as AnyObject).value(forKey: "ecouponFarmerMapId") as? Int ?? 0
                                        arrTrans.seasonId = (i as AnyObject).value(forKey: "seasonId") as? Int ?? 0
                                        arrTrans.farmerRewardCashPaymentModeId = (i as AnyObject).value(forKey: "farmerRewardCashPaymentModeId") as? Int ?? 0
                                        arrTrans.programId = ( i as AnyObject).value(forKey: "programId") as? Int ?? 0
                                        arrTrans.dsrProgramId = (i as AnyObject).value(forKey: "dsrId") as? Int ?? 0
                                        self.successTransactions.append(arrTrans)
                                    }
                                }
                            }
                            if arrayStatus.contains("reClaimList"){
                                let reclaimTrans = cashFree["reClaimList"] as! NSArray
                                self.reclaimTransactions.removeAll()
                                if reclaimTrans.count > 0 {
                                    for i in reclaimTrans {
                                        let arrTrans = TransactionModel()
                                        arrTrans.amount = (i as AnyObject).value(forKey: "amount") as? String ?? ""
                                        arrTrans.beneId = (i as AnyObject).value(forKey: "beneId") as? String ?? ""
                                        arrTrans.cashRewards = (i as AnyObject).value(forKey: "cashRewards") as? String ?? ""
                                        arrTrans.cgUrl = (i as AnyObject).value(forKey: "cgUrl") as? String ?? ""
                                        arrTrans.mobileNumber = (i as AnyObject).value(forKey: "mobileNumber") as? String ?? ""
                                        arrTrans.transferMode = (i as AnyObject).value(forKey: "transferMode") as? String ?? ""
                                        arrTrans.createdOn = (i as AnyObject).value(forKey: "createdOn") as? String ?? ""
                                        arrTrans.status = (i as AnyObject).value(forKey: "status") as? String ?? ""
                                        arrTrans.referenceId = (i as AnyObject).value(forKey: "referenceId") as? String ?? ""
                                        print((i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0)
                                        arrTrans.cashFreeTransactionId = (i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0
                                        arrTrans.prodSerialNumber = (i as AnyObject).value(forKey: "prodSerialNumber") as? String ?? ""
                                        arrTrans.transferId = (i as AnyObject).value(forKey: "transferId") as? String ?? ""
                                        arrTrans.id = (i as AnyObject).value(forKey: "id") as? String ?? ""
                                        arrTrans.message = (i as AnyObject).value(forKey: "message") as? String ?? ""
                                        arrTrans.modifiedOn = (i as AnyObject).value(forKey: "modifiedOn") as? String ?? ""
                                        arrTrans.buttonText =  (i as AnyObject).value(forKey: "buttonText") as? String ?? ""
                                        arrTrans.serverRecordId = (i as AnyObject).value(forKey: "serverRecordId") as? String ?? ""
                                        arrTrans.benfTransactionId = (i as AnyObject).value(forKey: "benfTransactionId") as? String ?? ""
                                        arrTrans.productName = (i as AnyObject).value(forKey: "productName") as? String ?? ""
                                        arrTrans.showView = (i as AnyObject).value(forKey: "showView") as? Bool ?? false
                                        arrTrans.ecouponFarmerMapId = (i as AnyObject).value(forKey: "ecouponFarmerMapId") as? Int ?? 0
                                        arrTrans.seasonId = (i as AnyObject).value(forKey: "seasonId") as? Int ?? 0
                                        arrTrans.farmerRewardCashPaymentModeId = (i as AnyObject).value(forKey: "farmerRewardCashPaymentModeId") as? Int ?? 0
                                        arrTrans.programId = ( i as AnyObject).value(forKey: "programId") as? Int ?? 0
                                        arrTrans.dsrProgramId = (i as AnyObject).value(forKey: "dsrId") as? Int ?? 0
                                        self.reclaimTransactions.append(arrTrans)
                                    }
                                }
                            }
                            var secDetails = SectionDetails()
                            self.sectionNames.removeAll()
                            for i in arrayStatus {
                                let status = (i as? String)!
                                if status.lowercased() == "successlist" && self.successTransactions.count > 0 || status.lowercased() == "claimlist" && self.claimTransactions.count > 0 || status.lowercased() == "reclaimlist" && self.reclaimTransactions.count > 0 {
                                    var transType = ""
                                    if status.lowercased() == "successlist" {
                                        transType = "Success List"
                                    }else if status.lowercased() == "reclaimlist" {
                                        transType = "Reclaim List"
                                    }else if status.lowercased() == "claimlist" {
                                        transType = "Claim List"
                                    }
                                    secDetails.itemName  = transType
                                    //2.00
                                    secDetails.collapsed = false
                                    self.sectionNames.append(secDetails)
                                }
                            }
                        }
                        
                        if let cashFree = decryptData.value(forKey: "eCouponTransactionList") as? NSDictionary {
                            let arrayStatus = cashFree.allKeys as NSArray
                            if arrayStatus.contains("programTitle"){
                                let title = cashFree["programTitle"] as! String
                                //self.ecouponTitle.text = title.uppercased()
                            }
                            if arrayStatus.contains("ecouponClaimList"){
                                let claimTrans = cashFree["ecouponClaimList"] as! NSArray
                                self.claimTransactionsEcoupon.removeAll()
                                if claimTrans.count > 0 {
                                    for i in claimTrans {
                                        let arrTrans = TransactionModel()
                                        arrTrans.amount = (i as AnyObject).value(forKey: "amount") as? String ?? ""
                                        arrTrans.beneId = (i as AnyObject).value(forKey: "beneId") as? String ?? ""
                                        arrTrans.cashRewards = (i as AnyObject).value(forKey: "cashRewards") as? String ?? ""
                                        arrTrans.cgUrl = (i as AnyObject).value(forKey: "cgUrl") as? String ?? ""
                                        arrTrans.mobileNumber = (i as AnyObject).value(forKey: "mobileNumber") as? String ?? ""
                                        arrTrans.transferMode = (i as AnyObject).value(forKey: "transferMode") as? String ?? ""
                                        arrTrans.createdOn = (i as AnyObject).value(forKey: "createdOn") as? String ?? ""
                                        arrTrans.status = (i as AnyObject).value(forKey: "status") as? String ?? ""
                                        arrTrans.referenceId = (i as AnyObject).value(forKey: "referenceId") as? String ?? ""
                                        arrTrans.prodSerialNumber = (i as AnyObject).value(forKey: "prodSerialNumber") as? String ?? ""
                                        print((i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0)
                                        arrTrans.cashFreeTransactionId = (i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0
                                        arrTrans.transferId = (i as AnyObject).value(forKey: "transferId") as? String ?? ""
                                        arrTrans.id = (i as AnyObject).value(forKey: "id") as? String ?? ""
                                        arrTrans.message = (i as AnyObject).value(forKey: "message") as? String ?? ""
                                        arrTrans.modifiedOn = (i as AnyObject).value(forKey: "modifiedOn") as? String ?? ""
                                        arrTrans.buttonText =  (i as AnyObject).value(forKey: "buttonText") as? String ?? ""
                                        arrTrans.serverRecordId = (i as AnyObject).value(forKey: "serverRecordId") as? String ?? ""
                                        arrTrans.benfTransactionId = (i as AnyObject).value(forKey: "benfTransactionId") as? String ?? ""
                                        arrTrans.productName = (i as AnyObject).value(forKey: "productName") as? String ?? ""
                                        arrTrans.showView = (i as AnyObject).value(forKey: "showView") as? Bool ?? false
                                        arrTrans.ecouponFarmerMapId = (i as AnyObject).value(forKey: "ecouponFarmerMapId") as? Int ?? 0
                                        arrTrans.seasonId = (i as AnyObject).value(forKey: "seasonId") as? Int ?? 0
                                        arrTrans.farmerRewardCashPaymentModeId = (i as AnyObject).value(forKey: "farmerRewardCashPaymentModeId") as? Int ?? 0
                                        arrTrans.programId = (i as AnyObject).value(forKey: "programId") as? Int ?? 0
                                        arrTrans.dsrProgramId = (i as AnyObject).value(forKey: "dsrId") as? Int ?? 0
                                        self.claimTransactionsEcoupon.append(arrTrans)
                                    }
                                }
                            }
                            if arrayStatus.contains("ecouponSuccessList"){
                                let successTrans = cashFree["ecouponSuccessList"] as! NSArray
                                self.successTransactionsEcoupon.removeAll()
                                if successTrans.count > 0 {
                                    for i in successTrans {
                                        let arrTrans = TransactionModel()
                                        arrTrans.amount = (i as AnyObject).value(forKey: "amount") as? String ?? ""
                                        arrTrans.beneId = (i as AnyObject).value(forKey: "beneId") as? String ?? ""
                                        arrTrans.cashRewards = (i as AnyObject).value(forKey: "cashRewards") as? String ?? ""
                                        arrTrans.cgUrl = (i as AnyObject).value(forKey: "cgUrl") as? String ?? ""
                                        arrTrans.mobileNumber = (i as AnyObject).value(forKey: "mobileNumber") as? String ?? ""
                                        arrTrans.transferMode = (i as AnyObject).value(forKey: "transferMode") as? String ?? ""
                                        arrTrans.createdOn = (i as AnyObject).value(forKey: "createdOn") as? String ?? ""
                                        arrTrans.status = (i as AnyObject).value(forKey: "status") as? String ?? ""
                                        arrTrans.referenceId = (i as AnyObject).value(forKey: "referenceId") as? String ?? ""
                                        print((i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0)
                                        arrTrans.cashFreeTransactionId = (i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0
                                        arrTrans.prodSerialNumber = (i as AnyObject).value(forKey: "prodSerialNumber") as? String ?? ""
                                        arrTrans.transferId = (i as AnyObject).value(forKey: "transferId") as? String ?? ""
                                        arrTrans.id = (i as AnyObject).value(forKey: "id") as? String ?? ""
                                        arrTrans.message = (i as AnyObject).value(forKey: "message") as? String ?? ""
                                        arrTrans.modifiedOn = (i as AnyObject).value(forKey: "modifiedOn") as? String ?? ""
                                        arrTrans.buttonText =  (i as AnyObject).value(forKey: "buttonText") as? String ?? ""
                                        arrTrans.serverRecordId = (i as AnyObject).value(forKey: "serverRecordId") as? String ?? ""
                                        arrTrans.benfTransactionId = (i as AnyObject).value(forKey: "benfTransactionId") as? String ?? ""
                                        arrTrans.productName = (i as AnyObject).value(forKey: "productName") as? String ?? ""
                                        arrTrans.showView = (i as AnyObject).value(forKey: "showView") as? Bool ?? false
                                        arrTrans.ecouponFarmerMapId = (i as AnyObject).value(forKey: "ecouponFarmerMapId") as? Int ?? 0
                                        arrTrans.seasonId = (i as AnyObject).value(forKey: "seasonId") as? Int ?? 0
                                        arrTrans.farmerRewardCashPaymentModeId = (i as AnyObject).value(forKey: "farmerRewardCashPaymentModeId") as? Int ?? 0
                                        arrTrans.programId = (i as AnyObject).value(forKey: "programId") as? Int ?? 0
                                        arrTrans.dsrProgramId = (i as AnyObject).value(forKey: "dsrId") as? Int ?? 0
                                        self.successTransactionsEcoupon.append(arrTrans)
                                    }
                                }
                            }
                            if arrayStatus.contains("ecouponReClaimList"){
                                let reclaimTrans = cashFree["ecouponReClaimList"] as! NSArray
                                self.reclaimTransactionsEcoupon.removeAll()
                                if reclaimTrans.count > 0 {
                                    for i in reclaimTrans {
                                        let arrTrans = TransactionModel()
                                        arrTrans.amount = (i as AnyObject).value(forKey: "amount") as? String ?? ""
                                        arrTrans.beneId = (i as AnyObject).value(forKey: "beneId") as? String ?? ""
                                        arrTrans.cashRewards = (i as AnyObject).value(forKey: "cashRewards") as? String ?? ""
                                        arrTrans.cgUrl = (i as AnyObject).value(forKey: "cgUrl") as? String ?? ""
                                        arrTrans.mobileNumber = (i as AnyObject).value(forKey: "mobileNumber") as? String ?? ""
                                        arrTrans.transferMode = (i as AnyObject).value(forKey: "transferMode") as? String ?? ""
                                        arrTrans.createdOn = (i as AnyObject).value(forKey: "createdOn") as? String ?? ""
                                        arrTrans.status = (i as AnyObject).value(forKey: "status") as? String ?? ""
                                        arrTrans.referenceId = (i as AnyObject).value(forKey: "referenceId") as? String ?? ""
                                        print((i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0)
                                        arrTrans.cashFreeTransactionId = (i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0
                                        arrTrans.prodSerialNumber = (i as AnyObject).value(forKey: "prodSerialNumber") as? String ?? ""
                                        arrTrans.transferId = (i as AnyObject).value(forKey: "transferId") as? String ?? ""
                                        arrTrans.id = (i as AnyObject).value(forKey: "id") as? String ?? ""
                                        arrTrans.message = (i as AnyObject).value(forKey: "message") as? String ?? ""
                                        arrTrans.modifiedOn = (i as AnyObject).value(forKey: "modifiedOn") as? String ?? ""
                                        arrTrans.buttonText =  (i as AnyObject).value(forKey: "buttonText") as? String ?? ""
                                        arrTrans.serverRecordId = (i as AnyObject).value(forKey: "serverRecordId") as? String ?? ""
                                        arrTrans.benfTransactionId = (i as AnyObject).value(forKey: "benfTransactionId") as? String ?? ""
                                        arrTrans.productName = (i as AnyObject).value(forKey: "productName") as? String ?? ""
                                        arrTrans.showView = (i as AnyObject).value(forKey: "showView") as? Bool ?? false
                                        arrTrans.ecouponFarmerMapId = (i as AnyObject).value(forKey: "ecouponFarmerMapId") as? Int ?? 0
                                        arrTrans.seasonId = (i as AnyObject).value(forKey: "seasonId") as? Int ?? 0
                                        arrTrans.farmerRewardCashPaymentModeId = (i as AnyObject).value(forKey: "farmerRewardCashPaymentModeId") as? Int ?? 0
                                        arrTrans.programId = (i as AnyObject).value(forKey: "programId") as? Int ?? 0
                                        arrTrans.dsrProgramId = (i as AnyObject).value(forKey: "dsrId") as? Int ?? 0
                                        self.reclaimTransactionsEcoupon.append(arrTrans)
                                    }
                                }
                            }
                            print("djgkl")
                            print(arrayStatus.contains("ecouponCodeList"))
                            print(cashFree["ecouponCodeList"] as! NSArray)
                            print("wert")
                            if arrayStatus.contains("ecouponCodeList"){
                                let reclaimTrans = cashFree["ecouponCodeList"] as! NSArray
                                self.couponCodesList.removeAll()
                                if reclaimTrans.count > 0 {
                                    for i in reclaimTrans {
                                        var arrTrans = ecouponCodeList()
                                        arrTrans.ecouponCode = (i as AnyObject).value(forKey:"ecouponCode") as? String ?? ""
                                        self.couponCodesList.append(arrTrans)
                                    }
                                }
                            }
                            var secDetails = SectionDetails()
                            self.sectionNamesEcoupon.removeAll()
                            for i in arrayStatus {
                                let status = (i as? String)!
                                if status.lowercased() == "ecouponsuccesslist" && self.successTransactionsEcoupon.count > 0 || status.lowercased() == "ecouponclaimlist" && self.claimTransactionsEcoupon.count > 0 || status.lowercased() == "ecouponreclaimlist" && self.reclaimTransactionsEcoupon.count > 0 || status.lowercased() == "ecouponcodelist" && self.couponCodesList.count > 0{
                                    var transType = ""
                                    if status.lowercased() == "ecouponsuccesslist" {
                                        transType = "Success List"
                                    }else if status.lowercased() == "ecouponreclaimlist" {
                                        transType = "Reclaim List"
                                    }else if status.lowercased() == "ecouponclaimlist" {
                                        transType = "Claim List"
                                    }else if status.lowercased() == "ecouponcodelist" {
                                        transType = "Lucky Draw Coupon List"
                                    }
                                    secDetails.itemName  = transType
                                    secDetails.collapsed = false
                                    self.sectionNamesEcoupon.append(secDetails)
                                    
                                    
                                }
                            }
                            
                        }
                        //MARK:- Seed Transaction List
                        if let seedTrans = decryptData.value(forKey: "seedTransactionList") as? NSDictionary {
                            let arrayStatus = seedTrans.allKeys as NSArray
                            if arrayStatus.contains("programTitle"){
                                let title = seedTrans["programTitle"] as! String
                                //self.seedTitle.text = title.uppercased()
                            }
                            if arrayStatus.contains("seedClaimList"){
                                let claimSeedTrans = seedTrans["seedClaimList"] as! NSArray
                                self.claimSeedTransactions.removeAll()
                                if claimSeedTrans.count > 0 {
                                    for i in claimSeedTrans {
                                        let arrTrans = TransactionModel()
                                        arrTrans.amount = (i as AnyObject).value(forKey: "amount") as? String ?? ""
                                        arrTrans.beneId = (i as AnyObject).value(forKey: "beneId") as? String ?? ""
                                        arrTrans.cashRewards = (i as AnyObject).value(forKey: "cashRewards") as? String ?? ""
                                        arrTrans.cgUrl = (i as AnyObject).value(forKey: "cgUrl") as? String ?? ""
                                        arrTrans.mobileNumber = (i as AnyObject).value(forKey: "mobileNumber") as? String ?? ""
                                        arrTrans.transferMode = (i as AnyObject).value(forKey: "transferMode") as? String ?? ""
                                        arrTrans.createdOn = (i as AnyObject).value(forKey: "createdOn") as? String ?? ""
                                        arrTrans.status = (i as AnyObject).value(forKey: "status") as? String ?? ""
                                        arrTrans.referenceId = (i as AnyObject).value(forKey: "referenceId") as? String ?? ""
                                        arrTrans.prodSerialNumber = (i as AnyObject).value(forKey: "prodSerialNumber") as? String ?? ""
                                        print((i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0)
                                        arrTrans.cashFreeTransactionId = (i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0
                                        arrTrans.transferId = (i as AnyObject).value(forKey: "transferId") as? String ?? ""
                                        arrTrans.id = (i as AnyObject).value(forKey: "id") as? String ?? ""
                                        arrTrans.message = (i as AnyObject).value(forKey: "message") as? String ?? ""
                                        arrTrans.modifiedOn = (i as AnyObject).value(forKey: "modifiedOn") as? String ?? ""
                                        arrTrans.buttonText =  (i as AnyObject).value(forKey: "buttonText") as? String ?? ""
                                        arrTrans.serverRecordId = (i as AnyObject).value(forKey: "serverRecordId") as? String ?? ""
                                        arrTrans.benfTransactionId = (i as AnyObject).value(forKey: "benfTransactionId") as? String ?? ""
                                        arrTrans.productName = (i as AnyObject).value(forKey: "productName") as? String ?? ""
                                        arrTrans.showView = (i as AnyObject).value(forKey: "showView") as? Bool ?? false
                                        arrTrans.ecouponFarmerMapId = (i as AnyObject).value(forKey: "ecouponFarmerMapId") as? Int ?? 0
                                        arrTrans.seasonId = (i as AnyObject).value(forKey: "seasonId") as? Int ?? 0
                                        arrTrans.farmerRewardCashPaymentModeId = (i as AnyObject).value(forKey: "farmerRewardCashPaymentModeId") as? Int ?? 0
                                        arrTrans.programId = (i as AnyObject).value(forKey: "programId") as? Int ?? 0
                                        arrTrans.dsrProgramId = (i as AnyObject).value(forKey: "dsrId") as? Int ?? 0
                                        self.claimSeedTransactions.append(arrTrans)
                                    }
                                }
                            }
                            if arrayStatus.contains("seedSuccessList"){
                                let successSeedTrans = seedTrans["seedSuccessList"] as! NSArray
                                self.successSeedTransactions.removeAll()
                                if successSeedTrans.count > 0 {
                                    for i in successSeedTrans {
                                        let arrTrans = TransactionModel()
                                        arrTrans.buttonText =  (i as AnyObject).value(forKey: "buttonText") as? String ?? ""
                                        arrTrans.amount = (i as AnyObject).value(forKey: "amount") as? String ?? ""
                                        arrTrans.beneId = (i as AnyObject).value(forKey: "beneId") as? String ?? ""
                                        arrTrans.cashRewards = (i as AnyObject).value(forKey: "cashRewards") as? String ?? ""
                                        arrTrans.cgUrl = (i as AnyObject).value(forKey: "cgUrl") as? String ?? ""
                                        arrTrans.mobileNumber = (i as AnyObject).value(forKey: "mobileNumber") as? String ?? ""
                                        arrTrans.transferMode = (i as AnyObject).value(forKey: "transferMode") as? String ?? ""
                                        arrTrans.createdOn = (i as AnyObject).value(forKey: "createdOn") as? String ?? ""
                                        arrTrans.status = (i as AnyObject).value(forKey: "status") as? String ?? ""
                                        arrTrans.referenceId = (i as AnyObject).value(forKey: "referenceId") as? String ?? ""
                                        print((i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0)
                                        arrTrans.cashFreeTransactionId = (i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0
                                        arrTrans.prodSerialNumber = (i as AnyObject).value(forKey: "prodSerialNumber") as? String ?? ""
                                        arrTrans.transferId = (i as AnyObject).value(forKey: "transferId") as? String ?? ""
                                        arrTrans.id = (i as AnyObject).value(forKey: "id") as? String ?? ""
                                        arrTrans.message = (i as AnyObject).value(forKey: "message") as? String ?? ""
                                        arrTrans.modifiedOn = (i as AnyObject).value(forKey: "modifiedOn") as? String ?? ""
                                        
                                        arrTrans.serverRecordId = (i as AnyObject).value(forKey: "serverRecordId") as? String ?? ""
                                        arrTrans.benfTransactionId = (i as AnyObject).value(forKey: "benfTransactionId") as? String ?? ""
                                        arrTrans.productName = (i as AnyObject).value(forKey: "productName") as? String ?? ""
                                        arrTrans.showView = (i as AnyObject).value(forKey: "showView") as? Bool ?? false
                                        arrTrans.ecouponFarmerMapId = (i as AnyObject).value(forKey: "ecouponFarmerMapId") as? Int ?? 0
                                        arrTrans.seasonId = (i as AnyObject).value(forKey: "seasonId") as? Int ?? 0
                                        arrTrans.farmerRewardCashPaymentModeId = (i as AnyObject).value(forKey: "farmerRewardCashPaymentModeId") as? Int ?? 0
                                        arrTrans.programId = (i as AnyObject).value(forKey: "programId") as? Int ?? 0
                                        arrTrans.dsrProgramId = (i as AnyObject).value(forKey: "dsrId") as? Int ?? 0
                                        self.successSeedTransactions.append(arrTrans)
                                    }
                                }
                            }
                            if arrayStatus.contains("seedReClaimList"){
                                let reclaimSeedTrans = seedTrans["seedReClaimList"] as! NSArray
                                self.reclaimSeedTransactions.removeAll()
                                if reclaimSeedTrans.count > 0 {
                                    for i in reclaimSeedTrans {
                                        let arrTrans = TransactionModel()
                                        arrTrans.amount = (i as AnyObject).value(forKey: "amount") as? String ?? ""
                                        arrTrans.beneId = (i as AnyObject).value(forKey: "beneId") as? String ?? ""
                                        arrTrans.cashRewards = (i as AnyObject).value(forKey: "cashRewards") as? String ?? ""
                                        arrTrans.cgUrl = (i as AnyObject).value(forKey: "cgUrl") as? String ?? ""
                                        arrTrans.mobileNumber = (i as AnyObject).value(forKey: "mobileNumber") as? String ?? ""
                                        arrTrans.transferMode = (i as AnyObject).value(forKey: "transferMode") as? String ?? ""
                                        arrTrans.createdOn = (i as AnyObject).value(forKey: "createdOn") as? String ?? ""
                                        arrTrans.status = (i as AnyObject).value(forKey: "status") as? String ?? ""
                                        arrTrans.referenceId = (i as AnyObject).value(forKey: "referenceId") as? String ?? ""
                                        print((i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0)
                                        arrTrans.cashFreeTransactionId = (i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0
                                        arrTrans.prodSerialNumber = (i as AnyObject).value(forKey: "prodSerialNumber") as? String ?? ""
                                        arrTrans.transferId = (i as AnyObject).value(forKey: "transferId") as? String ?? ""
                                        arrTrans.id = (i as AnyObject).value(forKey: "id") as? String ?? ""
                                        arrTrans.message = (i as AnyObject).value(forKey: "message") as? String ?? ""
                                        arrTrans.modifiedOn = (i as AnyObject).value(forKey: "modifiedOn") as? String ?? ""
                                        arrTrans.buttonText =  (i as AnyObject).value(forKey: "buttonText") as? String ?? ""
                                        arrTrans.serverRecordId = (i as AnyObject).value(forKey: "serverRecordId") as? String ?? ""
                                        arrTrans.benfTransactionId = (i as AnyObject).value(forKey: "benfTransactionId") as? String ?? ""
                                        arrTrans.productName = (i as AnyObject).value(forKey: "productName") as? String ?? ""
                                        arrTrans.showView = (i as AnyObject).value(forKey: "showView") as? Bool ?? false
                                        arrTrans.ecouponFarmerMapId = (i as AnyObject).value(forKey: "ecouponFarmerMapId") as? Int ?? 0
                                        arrTrans.seasonId = (i as AnyObject).value(forKey: "seasonId") as? Int ?? 0
                                        arrTrans.farmerRewardCashPaymentModeId = (i as AnyObject).value(forKey: "farmerRewardCashPaymentModeId") as? Int ?? 0
                                        arrTrans.programId = (i as AnyObject).value(forKey: "programId") as? Int ?? 0
                                        arrTrans.dsrProgramId = (i as AnyObject).value(forKey: "dsrId") as? Int ?? 0
                                        self.reclaimSeedTransactions.append(arrTrans)
                                    }
                                }
                            }
                           
                            var secDetails = SectionDetails()
                            self.sectionNamesSeed.removeAll()
                            for i in arrayStatus {
                                let status = (i as? String)!
                                if (status.lowercased() == "seedreclaimlist" && self.reclaimSeedTransactions.count > 0) || (status.lowercased() == "seedsuccesslist" && self.successSeedTransactions.count > 0) || (status.lowercased() == "seedclaimlist" && self.claimSeedTransactions.count > 0){
                                    var transType = ""
                                    if status.lowercased() == "seedsuccesslist" {
                                        transType = "Success List"
                                    }else if status.lowercased() == "seedreclaimlist" {
                                        transType = "Reclaim List"
                                    }else if status.lowercased() == "seedclaimlist" {
                                        transType = "Claim List"
                                    }
                                    secDetails.itemName  = transType
                                    secDetails.collapsed = false
                                    self.sectionNamesSeed.append(secDetails)
                                }
                            }
                            
                        }
                        /////*****************Seed2 **************/////
                        //MARK:-Seed2 transaction List
                        if let seedTrans = decryptData.value(forKey: "seedTwoTransactionList") as? NSDictionary {
                            let arrayStatus = seedTrans.allKeys as NSArray
                            if arrayStatus.contains("programTitle"){
                                let title = seedTrans["programTitle"] as! String
                               //self.seed2Title.text = title.uppercased()
                            }
                            if arrayStatus.contains("seedClaimList"){
                                let claimSeedTrans = seedTrans["seedClaimList"] as! NSArray
                                self.claimSeed2Transactions.removeAll()
                                if claimSeedTrans.count > 0 {
                                    for i in claimSeedTrans {
                                        let arrTrans = TransactionModel()
                                        arrTrans.amount = (i as AnyObject).value(forKey:"amount") as? String ?? ""
                                        arrTrans.beneId = (i as AnyObject).value(forKey:"beneId") as? String ?? ""
                                        arrTrans.cashRewards = (i as AnyObject).value(forKey:"cashRewards") as? String ?? ""
                                        arrTrans.cgUrl = (i as AnyObject).value(forKey:"cgUrl") as? String ?? ""
                                        arrTrans.mobileNumber = (i as AnyObject).value(forKey:"mobileNumber") as? String ?? ""
                                        arrTrans.transferMode = (i as AnyObject).value(forKey:"transferMode") as? String ?? ""
                                        arrTrans.createdOn = (i as AnyObject).value(forKey:"createdOn") as? String ?? ""
                                        arrTrans.status = (i as AnyObject).value(forKey:"status") as? String ?? ""
                                        arrTrans.referenceId = (i as AnyObject).value(forKey:"referenceId") as? String ?? ""
                                        arrTrans.prodSerialNumber = (i as AnyObject).value(forKey:"prodSerialNumber") as? String ?? ""
                                        print((i as AnyObject).value(forKey:"cashFreeTransactionId") as? Int ?? 0)
                                        arrTrans.cashFreeTransactionId = (i as AnyObject).value(forKey:"cashFreeTransactionId") as? Int ?? 0
                                        arrTrans.transferId = (i as AnyObject).value(forKey:"transferId") as? String ?? ""
                                        arrTrans.id = (i as AnyObject).value(forKey:"id") as? String ?? ""
                                        arrTrans.message = (i as AnyObject).value(forKey:"message") as? String ?? ""
                                        arrTrans.modifiedOn = (i as AnyObject).value(forKey:"modifiedOn") as? String ?? ""
                                        arrTrans.buttonText =  (i as AnyObject).value(forKey:"buttonText") as? String ?? ""
                                        arrTrans.serverRecordId = (i as AnyObject).value(forKey:"serverRecordId") as? String ?? ""
                                        arrTrans.benfTransactionId = (i as AnyObject).value(forKey:"benfTransactionId") as? String ?? ""
                                        arrTrans.productName = (i as AnyObject).value(forKey:"productName") as? String ?? ""
                                        arrTrans.showView = (i as AnyObject).value(forKey:"showView") as? Bool ?? false
                                        arrTrans.ecouponFarmerMapId = (i as AnyObject).value(forKey:"ecouponFarmerMapId") as? Int ?? 0
                                        arrTrans.seasonId = (i as AnyObject).value(forKey:"seasonId") as? Int ?? 0
                                        arrTrans.farmerRewardCashPaymentModeId = (i as AnyObject).value(forKey:"farmerRewardCashPaymentModeId") as? Int ?? 0
                                        arrTrans.programId = (i as AnyObject).value(forKey:"programId") as? Int ?? 0
                                        arrTrans.dsrProgramId = (i as AnyObject).value(forKey:"dsrId") as? Int ?? 0
                                        self.claimSeed2Transactions.append(arrTrans)
                                    }
                                }
                            }
                            if arrayStatus.contains("seedSuccessList"){
                                let successSeedTrans = seedTrans["seedSuccessList"] as! NSArray
                                self.successSeed2Transactions.removeAll()
                                if successSeedTrans.count > 0 {
                                    for i in successSeedTrans {
                                        let arrTrans = TransactionModel()
                                        arrTrans.buttonText =  (i as AnyObject).value(forKey:"buttonText") as? String ?? ""
                                        arrTrans.amount = (i as AnyObject).value(forKey:"amount") as? String ?? ""
                                        arrTrans.beneId = (i as AnyObject).value(forKey:"beneId") as? String ?? ""
                                        arrTrans.cashRewards = (i as AnyObject).value(forKey:"cashRewards") as? String ?? ""
                                        arrTrans.cgUrl = (i as AnyObject).value(forKey:"cgUrl") as? String ?? ""
                                        arrTrans.mobileNumber = (i as AnyObject).value(forKey:"mobileNumber") as? String ?? ""
                                        arrTrans.transferMode = (i as AnyObject).value(forKey:"transferMode") as? String ?? ""
                                        arrTrans.createdOn = (i as AnyObject).value(forKey:"createdOn") as? String ?? ""
                                        arrTrans.status = (i as AnyObject).value(forKey:"status") as? String ?? ""
                                        arrTrans.referenceId = (i as AnyObject).value(forKey:"referenceId") as? String ?? ""
                                        print((i as AnyObject).value(forKey:"cashFreeTransactionId") as? Int ?? 0)
                                        arrTrans.cashFreeTransactionId = (i as AnyObject).value(forKey:"cashFreeTransactionId") as? Int ?? 0
                                        arrTrans.prodSerialNumber = (i as AnyObject).value(forKey:"prodSerialNumber") as? String ?? ""
                                        arrTrans.transferId = (i as AnyObject).value(forKey:"transferId") as? String ?? ""
                                        arrTrans.id = (i as AnyObject).value(forKey:"id") as? String ?? ""
                                        arrTrans.message = (i as AnyObject).value(forKey:"message") as? String ?? ""
                                        arrTrans.modifiedOn = (i as AnyObject).value(forKey:"modifiedOn") as? String ?? ""
                                        
                                        arrTrans.serverRecordId = (i as AnyObject).value(forKey:"serverRecordId") as? String ?? ""
                                        arrTrans.benfTransactionId = (i as AnyObject).value(forKey:"benfTransactionId") as? String ?? ""
                                        arrTrans.productName = (i as AnyObject).value(forKey:"productName") as? String ?? ""
                                        arrTrans.showView = (i as AnyObject).value(forKey:"showView") as? Bool ?? false
                                        arrTrans.ecouponFarmerMapId = (i as AnyObject).value(forKey:"ecouponFarmerMapId") as? Int ?? 0
                                        arrTrans.seasonId = (i as AnyObject).value(forKey:"seasonId") as? Int ?? 0
                                        arrTrans.farmerRewardCashPaymentModeId = (i as AnyObject).value(forKey:"farmerRewardCashPaymentModeId") as? Int ?? 0
                                        arrTrans.programId = (i as AnyObject).value(forKey:"programId") as? Int ?? 0
                                        arrTrans.dsrProgramId = (i as AnyObject).value(forKey:"dsrId") as? Int ?? 0
                                        self.successSeed2Transactions.append(arrTrans)
                                    }
                                }
                            }
                            if arrayStatus.contains("seedReClaimList"){
                                let reclaimSeedTrans = seedTrans["seedReClaimList"] as! NSArray
                                self.reclaimSeed2Transactions.removeAll()
                                if reclaimSeedTrans.count > 0 {
                                    for i in reclaimSeedTrans {
                                        let arrTrans = TransactionModel()
                                        arrTrans.amount = (i as AnyObject).value(forKey:"amount") as? String ?? ""
                                        arrTrans.beneId = (i as AnyObject).value(forKey:"beneId") as? String ?? ""
                                        arrTrans.cashRewards = (i as AnyObject).value(forKey:"cashRewards") as? String ?? ""
                                        arrTrans.cgUrl = (i as AnyObject).value(forKey:"cgUrl") as? String ?? ""
                                        arrTrans.mobileNumber = (i as AnyObject).value(forKey:"mobileNumber") as? String ?? ""
                                        arrTrans.transferMode = (i as AnyObject).value(forKey:"transferMode") as? String ?? ""
                                        arrTrans.createdOn = (i as AnyObject).value(forKey:"createdOn") as? String ?? ""
                                        arrTrans.status = (i as AnyObject).value(forKey:"status") as? String ?? ""
                                        arrTrans.referenceId = (i as AnyObject).value(forKey:"referenceId") as? String ?? ""
                                        print((i as AnyObject).value(forKey:"cashFreeTransactionId") as? Int ?? 0)
                                        arrTrans.cashFreeTransactionId = (i as AnyObject).value(forKey:"cashFreeTransactionId") as? Int ?? 0
                                        arrTrans.prodSerialNumber = (i as AnyObject).value(forKey:"prodSerialNumber") as? String ?? ""
                                        arrTrans.transferId = (i as AnyObject).value(forKey:"transferId") as? String ?? ""
                                        arrTrans.id = (i as AnyObject).value(forKey:"id") as? String ?? ""
                                        arrTrans.message = (i as AnyObject).value(forKey:"message") as? String ?? ""
                                        arrTrans.modifiedOn = (i as AnyObject).value(forKey:"modifiedOn") as? String ?? ""
                                        arrTrans.buttonText =  (i as AnyObject).value(forKey:"buttonText") as? String ?? ""
                                        arrTrans.serverRecordId = (i as AnyObject).value(forKey:"serverRecordId") as? String ?? ""
                                        arrTrans.benfTransactionId = (i as AnyObject).value(forKey:"benfTransactionId") as? String ?? ""
                                        arrTrans.productName = (i as AnyObject).value(forKey:"productName") as? String ?? ""
                                        arrTrans.showView = (i as AnyObject).value(forKey:"showView") as? Bool ?? false
                                        arrTrans.ecouponFarmerMapId = (i as AnyObject).value(forKey:"ecouponFarmerMapId") as? Int ?? 0
                                        arrTrans.seasonId = (i as AnyObject).value(forKey:"seasonId") as? Int ?? 0
                                        arrTrans.farmerRewardCashPaymentModeId = (i as AnyObject).value(forKey:"farmerRewardCashPaymentModeId") as? Int ?? 0
                                        arrTrans.programId = (i as AnyObject).value(forKey:"programId") as? Int ?? 0
                                        arrTrans.dsrProgramId = (i as AnyObject).value(forKey:"dsrId") as? Int ?? 0
                                        self.reclaimSeed2Transactions.append(arrTrans)
                                    }
                                }
                            }
                           
                            var secDetails = SectionDetails()
                            self.sectionNamesSeed2.removeAll()
                            for i in arrayStatus {
                                let status = (i as? String)!
                                if (status.lowercased() == "seedreclaimlist" && self.reclaimSeed2Transactions.count > 0) || (status.lowercased() == "seedsuccesslist" && self.successSeed2Transactions.count > 0) || (status.lowercased() == "seedclaimlist" && self.claimSeed2Transactions.count > 0){
                                    var transType = ""
                                    if status.lowercased() == "seedsuccesslist" {
                                        transType = "Success List"
                                    }else if status.lowercased() == "seedreclaimlist" {
                                        transType = "Reclaim List"
                                    }else if status.lowercased() == "seedclaimlist" {
                                        transType = "Claim List"
                                    }
                                    secDetails.itemName  = transType
                                    secDetails.collapsed = false
                                    self.sectionNamesSeed2.append(secDetails)
                                }
                            }
                            
                        }
                        
                        
                        //MARK:-  DSR Transaction List
                        ///********** DSR********//////
                        
                        if let seedTrans = decryptData.value(forKey: "dsrTransactionList") as? NSDictionary {
                            let arrayStatus = seedTrans.allKeys as NSArray
                            if arrayStatus.contains("programTitle"){
                                let title = seedTrans["programTitle"] as! String
                               // self.dsrTitle.text = title.uppercased()
                            }
                            if arrayStatus.contains("dsrClaimList"){
                                let claimDSRTrans = seedTrans["dsrClaimList"] as! NSArray
                                self.claimDSRTransactions.removeAll()
                                if claimDSRTrans.count > 0 {
                                    for i in claimDSRTrans {
                                        let arrTrans = TransactionModel()
                                        arrTrans.amount = (i as AnyObject).value(forKey:"amount") as? String ?? ""
                                        arrTrans.beneId = (i as AnyObject).value(forKey:"beneId") as? String ?? ""
                                        arrTrans.cashRewards = (i as AnyObject).value(forKey:"cashRewards") as? String ?? ""
                                        arrTrans.cgUrl = (i as AnyObject).value(forKey:"cgUrl") as? String ?? ""
                                        arrTrans.mobileNumber = (i as AnyObject).value(forKey:"mobileNumber") as? String ?? ""
                                        arrTrans.transferMode = (i as AnyObject).value(forKey:"transferMode") as? String ?? ""
                                        arrTrans.createdOn = (i as AnyObject).value(forKey:"createdOn") as? String ?? ""
                                        arrTrans.status = (i as AnyObject).value(forKey:"status") as? String ?? ""
                                        arrTrans.referenceId = (i as AnyObject).value(forKey:"referenceId") as? String ?? ""
                                        arrTrans.prodSerialNumber = (i as AnyObject).value(forKey:"prodSerialNumber") as? String ?? ""
                                        print((i as AnyObject).value(forKey:"cashFreeTransactionId") as? Int ?? 0)
                                        arrTrans.cashFreeTransactionId = (i as AnyObject).value(forKey:"cashFreeTransactionId") as? Int ?? 0
                                        arrTrans.transferId = (i as AnyObject).value(forKey:"transferId") as? String ?? ""
                                        arrTrans.id = (i as AnyObject).value(forKey:"id") as? String ?? ""
                                        arrTrans.message = (i as AnyObject).value(forKey:"message") as? String ?? ""
                                        arrTrans.modifiedOn = (i as AnyObject).value(forKey:"modifiedOn") as? String ?? ""
                                        arrTrans.buttonText =  (i as AnyObject).value(forKey:"buttonText") as? String ?? ""
                                        arrTrans.serverRecordId = (i as AnyObject).value(forKey:"serverRecordId") as? String ?? ""
                                        arrTrans.benfTransactionId = (i as AnyObject).value(forKey:"benfTransactionId") as? String ?? ""
                                        arrTrans.productName = (i as AnyObject).value(forKey:"productName") as? String ?? ""
                                        arrTrans.showView = (i as AnyObject).value(forKey:"showView") as? Bool ?? false
                                        arrTrans.ecouponFarmerMapId = (i as AnyObject).value(forKey:"ecouponFarmerMapId") as? Int ?? 0
                                        arrTrans.seasonId = (i as AnyObject).value(forKey:"seasonId") as? Int ?? 0
                                        arrTrans.farmerRewardCashPaymentModeId = (i as AnyObject).value(forKey:"farmerRewardCashPaymentModeId") as? Int ?? 0
                                        arrTrans.programId = (i as AnyObject).value(forKey:"programId") as? Int ?? 0
                                        arrTrans.dsrProgramId = (i as AnyObject).value(forKey:"dsrId") as? Int ?? 0
                                        self.claimDSRTransactions.append(arrTrans)
                                    }
                                }
                            }
                            if arrayStatus.contains("dsrSuccessList"){
                                let successDSRTrans = seedTrans["dsrSuccessList"] as! NSArray
                                self.successDSRTransactions.removeAll()
                                if successDSRTrans.count > 0 {
                                    for i in successDSRTrans {
                                        let arrTrans = TransactionModel()
                                        arrTrans.buttonText =  (i as AnyObject).value(forKey:"buttonText") as? String ?? ""
                                        arrTrans.amount = (i as AnyObject).value(forKey:"amount") as? String ?? ""
                                        arrTrans.beneId = (i as AnyObject).value(forKey:"beneId") as? String ?? ""
                                        arrTrans.cashRewards = (i as AnyObject).value(forKey:"cashRewards") as? String ?? ""
                                        arrTrans.cgUrl = (i as AnyObject).value(forKey:"cgUrl") as? String ?? ""
                                        arrTrans.mobileNumber = (i as AnyObject).value(forKey:"mobileNumber") as? String ?? ""
                                        arrTrans.transferMode = (i as AnyObject).value(forKey:"transferMode") as? String ?? ""
                                        arrTrans.createdOn = (i as AnyObject).value(forKey:"createdOn") as? String ?? ""
                                        arrTrans.status = (i as AnyObject).value(forKey:"status") as? String ?? ""
                                        arrTrans.referenceId = (i as AnyObject).value(forKey:"referenceId")as? String ?? ""
                                        print((i as AnyObject).value(forKey:"cashFreeTransactionId") as? Int ?? 0)
                                        arrTrans.cashFreeTransactionId = (i as AnyObject).value(forKey:"cashFreeTransactionId") as? Int ?? 0
                                        arrTrans.prodSerialNumber = (i as AnyObject).value(forKey:"prodSerialNumber") as? String ?? ""
                                        arrTrans.transferId = (i as AnyObject).value(forKey:"transferId") as? String ?? ""
                                        arrTrans.id = (i as AnyObject).value(forKey:"id") as? String ?? ""
                                        arrTrans.message = (i as AnyObject).value(forKey:"message") as? String ?? ""
                                        arrTrans.modifiedOn = (i as AnyObject).value(forKey:"modifiedOn") as? String ?? ""
                                        
                                        arrTrans.serverRecordId = (i as AnyObject).value(forKey:"serverRecordId") as? String ?? ""
                                        arrTrans.benfTransactionId = (i as AnyObject).value(forKey:"benfTransactionId") as? String ?? ""
                                        arrTrans.productName = (i as AnyObject).value(forKey:"productName") as? String ?? ""
                                        arrTrans.showView = (i as AnyObject).value(forKey:"showView") as? Bool ?? false
                                        arrTrans.ecouponFarmerMapId = (i as AnyObject).value(forKey:"ecouponFarmerMapId") as? Int ?? 0
                                        arrTrans.seasonId = (i as AnyObject).value(forKey:"seasonId") as? Int ?? 0
                                        arrTrans.farmerRewardCashPaymentModeId = (i as AnyObject).value(forKey:"farmerRewardCashPaymentModeId") as? Int ?? 0
                                        arrTrans.programId = (i as AnyObject).value(forKey:"programId") as? Int ?? 0
                                        arrTrans.dsrProgramId = (i as AnyObject).value(forKey:"dsrId") as? Int ?? 0
                                        self.successDSRTransactions.append(arrTrans)
                                    }
                                }
                            }
                            if arrayStatus.contains("dsrReClaimList"){
                                let reclaimDSRTrans = seedTrans["dsrReClaimList"] as! NSArray
                                self.reclaimDSRTransactions.removeAll()
                                if reclaimDSRTrans.count > 0 {
                                    for i in reclaimDSRTrans {
                                        let arrTrans = TransactionModel()
                                        arrTrans.amount = (i as AnyObject).value(forKey:"amount") as? String ?? ""
                                        arrTrans.beneId = (i as AnyObject).value(forKey:"beneId") as? String ?? ""
                                        arrTrans.cashRewards = (i as AnyObject).value(forKey:"cashRewards") as? String ?? ""
                                        arrTrans.cgUrl = (i as AnyObject).value(forKey:"cgUrl") as? String ?? ""
                                        arrTrans.mobileNumber = (i as AnyObject).value(forKey:"mobileNumber") as? String ?? ""
                                        arrTrans.transferMode = (i as AnyObject).value(forKey:"transferMode") as? String ?? ""
                                        arrTrans.createdOn = (i as AnyObject).value(forKey:"createdOn") as? String ?? ""
                                        arrTrans.status = (i as AnyObject).value(forKey:"status") as? String ?? ""
                                        arrTrans.referenceId = (i as AnyObject).value(forKey:"referenceId") as? String ?? ""
                                        print((i as AnyObject).value(forKey:"cashFreeTransactionId") as? Int ?? 0)
                                        arrTrans.cashFreeTransactionId = (i as AnyObject).value(forKey:"cashFreeTransactionId") as? Int ?? 0
                                        arrTrans.prodSerialNumber = (i as AnyObject).value(forKey:"prodSerialNumber") as? String ?? ""
                                        arrTrans.transferId = (i as AnyObject).value(forKey:"transferId") as? String ?? ""
                                        arrTrans.id = (i as AnyObject).value(forKey:"id") as? String ?? ""
                                        arrTrans.message = (i as AnyObject).value(forKey:"message") as? String ?? ""
                                        arrTrans.modifiedOn = (i as AnyObject).value(forKey:"modifiedOn") as? String ?? ""
                                        arrTrans.buttonText =  (i as AnyObject).value(forKey:"buttonText") as? String ?? ""
                                        arrTrans.serverRecordId = (i as AnyObject).value(forKey:"serverRecordId") as? String ?? ""
                                        arrTrans.benfTransactionId = (i as AnyObject).value(forKey:"benfTransactionId") as? String ?? ""
                                        arrTrans.productName = (i as AnyObject).value(forKey:"productName") as? String ?? ""
                                        arrTrans.showView = (i as AnyObject).value(forKey:"showView") as? Bool ?? false
                                        arrTrans.ecouponFarmerMapId = (i as AnyObject).value(forKey:"ecouponFarmerMapId") as? Int ?? 0
                                        arrTrans.seasonId = (i as AnyObject).value(forKey:"seasonId") as? Int ?? 0
                                        arrTrans.farmerRewardCashPaymentModeId = (i as AnyObject).value(forKey:"farmerRewardCashPaymentModeId") as? Int ?? 0
                                        arrTrans.programId = (i as AnyObject).value(forKey:"programId") as? Int ?? 0
                                        arrTrans.dsrProgramId = (i as AnyObject).value(forKey:"dsrId") as? Int ?? 0
                                        self.reclaimDSRTransactions.append(arrTrans)
                                    }
                                }
                            }
                           
                            var secDetails = SectionDetails()
                            self.sectionNamesDSR.removeAll()
                            for i in arrayStatus {
                                let status = (i as? String)!
                                if (status.lowercased() == "dsrreclaimlist" && self.reclaimDSRTransactions.count > 0) || (status.lowercased() == "dsrsuccesslist" && self.successDSRTransactions.count > 0) || (status.lowercased() == "dsrclaimlist" && self.claimDSRTransactions.count > 0){
                                    var transType = ""
                                    if status.lowercased() == "dsrsuccesslist" {
                                        transType = "Success List"
                                    }else if status.lowercased() == "dsrreclaimlist" {
                                        transType = "Reclaim List"
                                    }else if status.lowercased() == "dsrclaimlist" {
                                        transType = "Claim List"
                                    }
                                    secDetails.itemName  = transType
                                    secDetails.collapsed = false
                                    self.sectionNamesDSR.append(secDetails)
                                }
                            }
                            
                        }
                        
                    }
                    else if responseStatusCode == STATUS_CODE_601{
                        Constatnts.logOut()
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    }else if responseStatusCode == STATUS_CODE_500{
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast("Please try Again later")
                        }
                    }else if responseStatusCode == STATUS_CODE_105{
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }else   {
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

extension RewardsVC: UITableViewDelegate, UITableViewDataSource{
     func numberOfSections(in tableView: UITableView) -> Int {
        return self.rewardsData?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    
    
}
