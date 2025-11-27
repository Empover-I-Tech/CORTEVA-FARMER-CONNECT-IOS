//
//  RewardsViewController.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 26/09/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat , frame : CGRect) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
class RewardsViewController: BaseViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var tblViewTransactions : UITableView!
    @IBOutlet weak var tblViewEcouponTransactions : UITableView!
    @IBOutlet weak var tblViewSeedTransactions: UITableView!
    @IBOutlet weak var tblViewseed2Transactions: UITableView!
    @IBOutlet weak var tblViewDSRTransactions: UITableView!
    
    
    @IBOutlet weak var lblNoRewards : UILabel!
    @IBOutlet weak var lblNoRewardscoupon : UILabel!
    @IBOutlet weak var lblNoRewardsSeed: UILabel!
    @IBOutlet weak var lblNoRewardsSeed2: UILabel!
    @IBOutlet weak var lnlNoRewardsDSR: UILabel!
    
    @IBOutlet weak var rewardPointsView: UIView!
    @IBOutlet weak var rewardPointsTitle: UILabel!
    
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
    var isFromDelegateDostDhamaka: Bool = false
    
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
    
    var giftCouponTransactions = [TransactionModel]()
   
    var couponCodesList = [ecouponCodeList]()
    
    var totalClaimAmount : Double =  0.0
    var totalClaimAmountEcoupon : Double =  0.0
    var totalClaimAmountSeed: Double = 0.0
    var totalClaimAmountSeed2: Double = 0.0
    var totalClaimAmountDSR: Double = 0.0
    
    var theImageView = UIImageView()
    
    @IBOutlet var bgScroll: UIScrollView!
    
    @IBOutlet var EcouponView: UIView!
    @IBOutlet weak var RewardView: UIView!
    @IBOutlet weak var seedView: UIView!
    @IBOutlet weak var seedView2: UIView!
    @IBOutlet weak var dsrView: UIView!
    
    @IBOutlet weak var RewardTopVIew: UIView!
    @IBOutlet weak var EcouponTopVIew: UIView!
    @IBOutlet weak var SeedTopView: UIView!
    @IBOutlet weak var SeedTopView2: UIView!
    @IBOutlet weak var dsrTopView: UIView!
    
    @IBOutlet var contentVIew: UIView!
    
    @IBOutlet var RewardViewImageView : UIImageView!
    @IBOutlet var EcouponImageView: UIImageView!
    @IBOutlet var SeedImageView: UIImageView!
    @IBOutlet var Seed2ImageView: UIImageView!
    @IBOutlet var dsrImageView: UIImageView!
    
    @IBOutlet var EcopounStack: UIStackView!
    @IBOutlet var RewardStack: UIStackView!
    @IBOutlet var seedStack: UIStackView!
    @IBOutlet var seed2Stack: UIStackView!
    @IBOutlet var dsrStack: UIStackView!

    @IBOutlet weak var rewardHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ecouponHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var seedHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var seed2HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dsrHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollHeightConstraint: NSLayoutConstraint!
 
    var arrrayPaymentCashfree = NSMutableArray()
    var arrrayPaymenteCoupon = NSMutableArray()
    var arrrayPaymentSeed = NSMutableArray()
    var arrrayPaymentDsr = NSMutableArray()
    var arrrayPaymentseedTwo = NSMutableArray()
    @IBOutlet weak var ecouponTopViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var rewardTopViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var seedTopViewheightConstrain: NSLayoutConstraint!
    @IBOutlet weak var seed2TopViewheightConstrain: NSLayoutConstraint!
    @IBOutlet weak var dsrTopViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var rewardTitle: UILabel!
    @IBOutlet weak var ecouponTitle: UILabel!
    @IBOutlet weak var seedTitle: UILabel!
    @IBOutlet weak var seed2Title: UILabel!
    @IBOutlet weak var dsrTitle: UILabel!
    
    @IBOutlet weak var rewardPointsheightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var giftCouponStack: UIStackView!
    @IBOutlet weak var giftCouponHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var giftCouponTopView: UIView!
    @IBOutlet weak var giftCouponImageView: UIImageView!
    @IBOutlet weak var giftCouponTitle: UILabel!
    @IBOutlet weak var giftCouponCountLbl: UILabel!
    @IBOutlet weak var giftCouponView: UIView!
    @IBOutlet weak var lblNoRewardsGiftCoupon: UILabel!
    @IBOutlet weak var tblViewGiftCouponTransactions: UITableView!
    
    @IBOutlet weak var QRCodeView: UIView!
    @IBOutlet weak var qrCodeTitleLbl: UILabel!
    @IBOutlet weak var qrCodeSubTitleLbl: UILabel!
    @IBOutlet weak var showQRCode: UIImageView!
    
    @IBOutlet var mainBackgroundView: UIView!
    @IBOutlet weak var qrCodeViewCloseBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainBackgroundView.isHidden = true
        self.QRCodeView.isHidden = true
        self.qrCodeViewCloseBtn.setTitle("", for: .normal)
        //self.rewardPointsView.isHidden = true
        
        let nib = UINib(nibName: "CouponTableViewCell", bundle:nil)
        self.tblViewEcouponTransactions.register(nib, forCellReuseIdentifier: "CouponTableViewCell")
        
        self.addRefreshButton()
       
        let userObj = Constatnts.getUserObject()
        
        self.registerFirebaseEvents(PV_RewardsList, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", CashFreeRewards , parameters: nil)
        let params : NSMutableDictionary = ["reClaim" : "No", "moduleType": "Farmer"]
        
        RewardViewImageView.image = UIImage(named: "downroundIcon")
        SeedImageView.image = UIImage(named: "downroundIcon")
        Seed2ImageView.image = UIImage(named: "downroundIcon")
        dsrImageView.image = UIImage(named: "downroundIcon")
        
        self.requestToGetgetFarmerRewards(params: params )
        
        self.hideShowErrorDisplayingLabels(hide: true)
        self.hideShowTopViews(Hide: true, height: 0)
        self.hideShowViews(hide: false)
        self.hideShowTableViews(hide: true)
        self.setStackViewHeights(height: 50.0)
       
        //        contentHeightConstraint.constant = self.view.frame.size.height
        bgScroll?.updateConstraintsIfNeeded()
        bgScroll?.layoutIfNeeded()
        bgScroll?.contentSize = CGSize(width: self.contentVIew.frame.size.width, height: 3000)
        //  bgScroll?.contentInset = UIEdgeInsetsMake(64.0, 0.0, 44.0, 0.0)
        bgScroll?.updateConstraintsIfNeeded()
        bgScroll?.layoutIfNeeded()
        self.view.layoutIfNeeded()
        self.view.updateConstraintsIfNeeded()
        if userObj.userLogsGenuinityPrint == "true"{
        self.saveUserLogEventsDetailsToServer()
        }
        
        
        //         bgScroll?.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        //
        //           bgScroll?.contentOffset = CGPoint(x: 50, y: 50 )
        // Do any additional setup after loading the view.
       // self.bgScroll.delaysContentTouches = false
        //self.bgScroll.canCancelContentTouches = false
       // self.rewardPointsheightConstraint.constant = 0
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
               print("print qr image data here",output)
                self.showQRCode.image = UIImage(ciImage: output)
                return UIImage(ciImage: output)
            }
        }

        return nil
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
            
            "eventName": Home_rewards,
            "className":"RewardsViewController",
            "moduleName":"rewards",
            
            "healthCardId":"",
            "productId":"",
            "cropId":"",
            "seasonId":"",
            "otherParams":"",
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
    func addRefreshButton(){
        let refreshButton = UIButton(type: .custom)
        refreshButton.frame = CGRect(x: (self.topView?.frame.size.width)! - 50, y: 10, width: 35, height: 35)
        refreshButton.addTarget(self, action: #selector(RewardsViewController.refreshMyTransactionsClick(_:)), for: .touchUpInside)
        refreshButton.setImage(UIImage(named: "RefreshWhite"), for: .normal)
        self.topView?.addSubview(refreshButton)
    }
    func hideShowTopViews(Hide: Bool, height: CGFloat){
        self.RewardTopVIew.isHidden = Hide
        self.EcouponTopVIew.isHidden = Hide
        self.giftCouponTopView.isHidden = Hide
        self.SeedTopView.isHidden = Hide
        self.SeedTopView2.isHidden = Hide
        self.dsrTopView.isHidden = Hide
        self.rewardTopViewHeightConstraint.constant = height
        self.ecouponTopViewHeightConstraint.constant = height
        self.seedTopViewheightConstrain.constant = height
        self.seed2TopViewheightConstrain.constant = height
        self.dsrTopViewHeightConstraint.constant = height
    }
    func hideShowErrorDisplayingLabels(hide: Bool){
        self.lblNoRewards.isHidden = hide
        self.lblNoRewardscoupon.isHidden = hide
        self.lblNoRewardsSeed.isHidden = hide
        self.lblNoRewardsSeed2.isHidden = hide
        self.lblNoRewardsSeed.isHidden = hide
    }
    func hideShowViews(hide: Bool){
        self.EcouponView.isHidden = hide
        self.RewardView.isHidden = hide
        self.seedView.isHidden = hide
        self.seedView2.isHidden = hide
        self.dsrView.isHidden = hide
        self.giftCouponView.isHidden = hide
    }
    func hideShowTableViews(hide:Bool){
        self.tblViewTransactions.isHidden = hide
        self.tblViewEcouponTransactions.isHidden = hide
        self.tblViewSeedTransactions.isHidden = hide
        self.tblViewseed2Transactions.isHidden = hide
        self.tblViewDSRTransactions.isHidden = hide
    }
    func setStackViewHeights(height:CGFloat){
        self.rewardHeightConstraint.constant = height
        self.ecouponHeightConstraint.constant = height
        self.seedHeightConstraint.constant = height
        self.seed2HeightConstraint.constant = height
        self.dsrHeightConstraint.constant = height
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
       // self.bgScroll.delaysContentTouches = false
       // self.bgScroll.canCancelContentTouches = false
    }
    
    override func backButtonClick(_ sender: UIButton) {
      //  self.navigationController?.popViewController(animated: true)
      //  return
        if isFromDelegateDostDhamaka{
            let controllers = self.navigationController?.viewControllers
            for vc in controllers! {
                if vc is HomeViewController {
                    _ = self.navigationController?.popToViewController(vc as! HomeViewController, animated: true)
                }
            }
        }
        else if isFromHome{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.findHamburguerViewController()?.showMenuViewController()
        }
    }
    
    
    func requestToGetgetFarmerRewards(params : NSMutableDictionary){
        self.arrrayPaymentCashfree = NSMutableArray()
        self.arrrayPaymenteCoupon = NSMutableArray()
        self.arrrayPaymentSeed = NSMutableArray()
        self.arrrayPaymentseedTwo = NSMutableArray()
        self.arrrayPaymentDsr = NSMutableArray()
        SwiftLoader.show(animated: true)
        let headers = Constatnts.getLoggedInFarmerHeaders()
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,Get_User_Rewards]  ) // // ["http://192.168.3.141:8080/ATP/rest/" ,"cashFreeReward/getCashFreeTransactionPendingRequest_V2"]
        let paramsStr = Constatnts.nsobjectToJSON(params )
        
        
        let params =  ["data" : paramsStr]
        print(urlString)
        print(headers)
        print("params",params)
        Alamofire.request(urlString, method: .post, parameters :  params , encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            print(response)
            if response.result.error == nil {
                print("what is response here",response)
                if let json = response.result.value {
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        
                        print("Response after decrypting data:\(decryptData)")
                        self.arrayTransactions.removeAll()
                        self.arrayTransactionsEcoupon.removeAll()
                        
                        let userObj = Constatnts.getUserObject()
                        //                         let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"serverID" : self.arrayTransactions[0].serverID ] as [String : Any]
                        //
                        //                          self.registerFirebaseEvents(Reclaim, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", CashFreeRewards , parameters: fireBaseParams as NSDictionary)
                        
                        if let rewardPoints = decryptData.value(forKey: "rewardPoints") as? String{
                           // self.rewardPointsTitle.text = rewardPoints
                          //  self.rewardPointsView.isHidden = false
                          //  self.rewardPointsheightConstraint.constant = 40
                        }else{
                          //  self.rewardPointsTitle.text = ""
                          //  self.rewardPointsView.isHidden = true
                         //   self.rewardPointsheightConstraint.constant = 0
                        }
                        
                        if let cashFree = decryptData.value(forKey: "cashFreeTransactionList") as? NSDictionary {
                            let arrayStatus = cashFree.allKeys as NSArray
                            if arrayStatus.contains("paymentOptions"){
                                self.arrrayPaymentCashfree.add(cashFree["paymentOptions"]  as? NSArray ?? [])
                            }
                            if arrayStatus.contains("programTitle"){
                                let title = cashFree["programTitle"] as! String
                                self.rewardTitle.text = title.uppercased()
                            }else{
                                let title = NSLocalizedString("Reward_Program", comment: "")
                                self.rewardTitle.text = title.uppercased()
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
                                       // print((i as AnyObject)["cashFreeTransactionId"] as? Int ?? 0)
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
                                       // print((i as AnyObject)["cashFreeTransactionId"] as? Int ?? 0)
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
                                       // print((i as AnyObject)["cashFreeTransactionId"] as? Int ?? 0)
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
                            if arrayStatus.contains("paymentOptions"){
                                self.arrrayPaymenteCoupon.add(cashFree["paymentOptions"]  as? NSArray ?? [])
                            }
                            if arrayStatus.contains("programTitle"){
                                let title = cashFree["programTitle"] as! String
                                self.ecouponTitle.text = title.uppercased()
                            }else{
                                let title = NSLocalizedString("E_Coupon", comment: "")
                                self.ecouponTitle.text = title.uppercased()
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
                                       // print((i as AnyObject)["cashFreeTransactionId"] as? Int ?? 0)
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
                                       // print((i as AnyObject)["cashFreeTransactionId"] as? Int ?? 0)
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
                                        //print((i as AnyObject)["cashFreeTransactionId"] as? Int ?? 0)
                                        arrTrans.cashFreeTransactionId = (i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0
                                        arrTrans.prodSerialNumber = (i as AnyObject).value(forKey: "prodSerialNumber") as? String ?? ""
                                        arrTrans.transferId = (i as AnyObject).value(forKey: "prodSerialNumber") as? String ?? ""
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
                                        arrTrans.valueOne = (i as AnyObject).value(forKey:"valueOne") as? String ?? ""
                                        arrTrans.valueTwo = (i as AnyObject).value(forKey:"valueTwo") as? String ?? ""
                                        arrTrans.labelOne = (i as AnyObject).value(forKey:"labelOne") as? String ?? ""
                                        arrTrans.labelTwo = (i as AnyObject).value(forKey:"labelTwo") as? String ?? ""
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
                        // MARK:- Gift Coupon List
                        if let cashFree = decryptData.value(forKey: "giftCouponsList") as? NSDictionary
                        {
                            let arrayStatus = cashFree.allKeys as NSArray
                            if arrayStatus.contains("programTitle"){
                                let title = cashFree["programTitle"] as! String
                                let count = cashFree["totalRewardPoints"] as! Int
                                self.giftCouponTitle.text = title.uppercased()
                                self.giftCouponCountLbl.text = String(count)
                            }
                            if arrayStatus.contains("couponsToClaimList"){
                                let claimTrans = cashFree["couponsToClaimList"] as! NSArray
                                self.giftCouponTransactions.removeAll()
                                if claimTrans.count > 0 {
                                    for i in claimTrans {
                                        let arrTrans = TransactionModel()
                                        arrTrans.sampleQRCodeImgUrl = (i as AnyObject).value(forKey: "sampleQRCodeImgUrl") as? String ?? ""
                                        arrTrans.sampleRedeemedQRCodeImgUrl = (i as AnyObject).value(forKey: "sampleRedeemedQRCodeImgUrl") as? String ?? ""
                                        arrTrans.qrCodeData = (i as AnyObject).value(forKey: "qrCodeData") as? String ?? ""
                                        arrTrans.product = (i as AnyObject).value(forKey: "product") as? String ?? ""
                                        arrTrans.Size = (i as AnyObject).value(forKey: "Size") as? String ?? ""
                                        arrTrans.redeemStatus = (i as AnyObject).value(forKey: "redeemStatus") as? Bool ?? false
                                        arrTrans.redeemMessage = (i as AnyObject).value(forKey: "redeemMessage") as? String ?? ""
                                        arrTrans.couponGeneratedDate = (i as AnyObject).value(forKey: "couponGeneratedDate") as? String ?? ""
                                        arrTrans.redeemedDate = (i as AnyObject).value(forKey: "redeemedDate") as? String ?? ""
                                        
                                        arrTrans.showView = (i as AnyObject).value(forKey: "showView") as? Bool ?? false
                                        arrTrans.ecouponFarmerMapId = (i as AnyObject).value(forKey: "ecouponFarmerMapId") as? Int ?? 0
                                       
                                        self.giftCouponTransactions.append(arrTrans)
                                    }
                                }
                            }
                            
                            print("coming last here in gift coupon",self.giftCouponTransactions.count)
                        }
                        
                        
                        //MARK:- Seed Transaction List
                        if let seedTrans = decryptData.value(forKey: "seedTransactionList") as? NSDictionary {
                            let arrayStatus = seedTrans.allKeys as NSArray
                            if arrayStatus.contains("paymentOptions"){
                                self.arrrayPaymentSeed.add(seedTrans["paymentOptions"]  as? NSArray ?? [])
                            }
                            if arrayStatus.contains("programTitle"){
                                let title = seedTrans["programTitle"] as! String
                                self.seedTitle.text = title.uppercased()
                            }else{
                                let title = "\(NSLocalizedString("Seed_Reward_Program", comment: "")) -1"
                                self.seedTitle.text = title.uppercased()
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
                                        //print((i as AnyObject)["cashFreeTransactionId"] as? Int ?? 0)
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
                                        //print((i as AnyObject)["cashFreeTransactionId"] as? Int ?? 0)
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
                                        //print((i as AnyObject)["cashFreeTransactionId"] as? Int ?? 0)
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
                            if arrayStatus.contains("paymentOptions"){
                                self.arrrayPaymentseedTwo.add(seedTrans["paymentOptions"]  as? NSArray ?? [])
                            }
                            if arrayStatus.contains("programTitle"){
                                let title = seedTrans["programTitle"] as! String
                                self.seed2Title.text = title.uppercased()
                            }else{
                                let title = "\(NSLocalizedString("Seed_Reward_Program", comment: "")) -2"
                                self.seedTitle.text = title.uppercased()
                            }
                            if arrayStatus.contains("seedClaimList"){
                                let claimSeedTrans = seedTrans["seedClaimList"] as! NSArray
                                self.claimSeed2Transactions.removeAll()
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
                                        //print((i as AnyObject)["cashFreeTransactionId"] as? Int ?? 0)
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
                                        //print((i as AnyObject)["cashFreeTransactionId"] as? Int ?? 0)
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
                                        arrTrans.amount = (i as AnyObject).value(forKey: "amount") as? String ?? ""
                                        arrTrans.beneId = (i as AnyObject).value(forKey: "beneId") as? String ?? ""
                                        arrTrans.cashRewards = (i as AnyObject).value(forKey: "cashRewards") as? String ?? ""
                                        arrTrans.cgUrl = (i as AnyObject).value(forKey: "cgUrl") as? String ?? ""
                                        arrTrans.mobileNumber = (i as AnyObject).value(forKey: "mobileNumber") as? String ?? ""
                                        arrTrans.transferMode = (i as AnyObject).value(forKey: "transferMode") as? String ?? ""
                                        arrTrans.createdOn = (i as AnyObject).value(forKey: "createdOn") as? String ?? ""
                                        arrTrans.status = (i as AnyObject).value(forKey: "status") as? String ?? ""
                                        arrTrans.referenceId = (i as AnyObject).value(forKey: "referenceId") as? String ?? ""
                                        //print((i as AnyObject)["cashFreeTransactionId"] as? Int ?? 0)
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
                                        arrTrans.farmerRewardCashPaymentModeId = (i as AnyObject).value(forKey: "farmerRewardCashPaymentModeId")as? Int ?? 0
                                        arrTrans.programId = (i as AnyObject).value(forKey: "programId") as? Int ?? 0
                                        arrTrans.dsrProgramId = (i as AnyObject).value(forKey: "dsrId") as? Int ?? 0
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
                            if arrayStatus.contains("paymentOptions"){
                                self.arrrayPaymentDsr.add(seedTrans["paymentOptions"]  as? NSArray ?? [])
                            }
                            if arrayStatus.contains("programTitle"){
                                let title = seedTrans["programTitle"] as! String
                                self.dsrTitle.text = title.uppercased()
                            }else{
                                let title = NSLocalizedString("DSR_reward_Program", comment: "")
                                self.dsrTitle.text = title.uppercased()
                            }
                            if arrayStatus.contains("dsrClaimList"){
                                let claimDSRTrans = seedTrans["dsrClaimList"] as! NSArray
                                self.claimDSRTransactions.removeAll()
                                if claimDSRTrans.count > 0 {
                                    for i in claimDSRTrans {
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
                                      //  print((i as AnyObject)["cashFreeTransactionId"] as? Int ?? 0)
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
                                       // print((i as AnyObject)["cashFreeTransactionId"] as? Int ?? 0)
                                        arrTrans.cashFreeTransactionId = (i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0
                                        arrTrans.prodSerialNumber = (i as AnyObject).value(forKey: "prodSerialNumber") as? String ?? ""
                                        arrTrans.transferId = (i as AnyObject).value(forKey: "transferId") as? String ?? ""
                                        arrTrans.id = (i as AnyObject).value(forKey: "id") as? String ?? ""
                                        arrTrans.message = (i as AnyObject).value(forKey: "message") as? String ?? ""
                                        arrTrans.modifiedOn = (i as AnyObject).value(forKey: "modifiedOn") as? String ?? ""
                                        
                                        arrTrans.serverRecordId = (i as AnyObject).value(forKey: "serverRecordId") as? String ?? ""
                                        arrTrans.benfTransactionId = (i as AnyObject).value(forKey: "amount") as? String ?? ""
                                        arrTrans.productName = (i as AnyObject).value(forKey: "benfTransactionId") as? String ?? ""
                                        arrTrans.showView = (i as AnyObject).value(forKey: "showView") as? Bool ?? false
                                        arrTrans.ecouponFarmerMapId = (i as AnyObject).value(forKey: "ecouponFarmerMapId") as? Int ?? 0
                                        arrTrans.seasonId = (i as AnyObject).value(forKey: "seasonId") as? Int ?? 0
                                        arrTrans.farmerRewardCashPaymentModeId = (i as AnyObject).value(forKey: "farmerRewardCashPaymentModeId") as? Int ?? 0
                                        arrTrans.programId = (i as AnyObject).value(forKey: "programId") as? Int ?? 0
                                        arrTrans.dsrProgramId = (i as AnyObject).value(forKey: "dsrId") as? Int ?? 0
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
                                        arrTrans.amount = (i as AnyObject).value(forKey: "amount") as? String ?? ""
                                        arrTrans.beneId = (i as AnyObject).value(forKey: "beneId") as? String ?? ""
                                        arrTrans.cashRewards = (i as AnyObject).value(forKey: "cashRewards") as? String ?? ""
                                        arrTrans.cgUrl = (i as AnyObject).value(forKey: "cgUrl") as? String ?? ""
                                        arrTrans.mobileNumber = (i as AnyObject).value(forKey: "mobileNumber") as? String ?? ""
                                        arrTrans.transferMode = (i as AnyObject).value(forKey: "transferMode") as? String ?? ""
                                        arrTrans.createdOn = (i as AnyObject).value(forKey: "createdOn") as? String ?? ""
                                        arrTrans.status = (i as AnyObject).value(forKey: "status") as? String ?? ""
                                        arrTrans.referenceId = (i as AnyObject).value(forKey: "referenceId") as? String ?? ""
                                        //print((i as AnyObject)["cashFreeTransactionId"] as? Int ?? 0)
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
                        
                        if self.giftCouponTransactions.count == 0{
                            self.giftCouponTopView.isHidden = true
                            self.lblNoRewardsGiftCoupon.isHidden = true
                            self.tblViewGiftCouponTransactions.isHidden = true
                            self.giftCouponHeightConstraint.constant = 0
                            self.giftCouponView.isHidden = true
                        }
                        else{
                            self.giftCouponTopView.isHidden = false
                            self.giftCouponView.isHidden = false
                            self.lblNoRewardsGiftCoupon.isHidden = true
                            self.tblViewGiftCouponTransactions.isHidden = false
                            DispatchQueue.main.async {
                                self.tblViewGiftCouponTransactions.reloadData()
                            }
                        }
                        

                        
                            if self.successTransactions.count == 0 && self.claimTransactions.count == 0  && self.reclaimTransactions.count == 0{
                                self.lblNoRewards.isHidden = true
//                                self.tblViewTransactions.isHidden = true
//                                self.rewardHeightConstraint.constant =  0
                                self.rewardTopViewHeightConstraint.constant = 0
                                self.rewardHeightConstraint.constant = 0
                                self.RewardView.isHidden = true
                            }
                            else{
                                self.RewardTopVIew.isHidden = false
                                self.rewardTopViewHeightConstraint.constant = 40
                                self.lblNoRewards.isHidden = true
                                self.RewardView.isHidden = false
                                self.tblViewTransactions.isHidden = false
                                DispatchQueue.main.async {
                                        self.tblViewTransactions.reloadData()
                                var heightConstant = CGFloat((self.successTransactions.count + self.claimTransactions.count + self.reclaimTransactions.count ) * 175)  + 125
                                        self.tblViewTransactions.isScrollEnabled = false
                                                    self.rewardHeightConstraint.constant = heightConstant+100
                                }
                                    }
                              
                        if self.successTransactionsEcoupon.count == 0 && self.claimTransactionsEcoupon.count == 0  && self.reclaimTransactionsEcoupon.count == 0 && self.couponCodesList.count == 0{
                            self.ecouponTopViewHeightConstraint.constant = 0
                                    self.lblNoRewardscoupon.isHidden = true
                                    self.tblViewEcouponTransactions.isHidden = true
                            self.ecouponHeightConstraint.constant = 0
                            self.EcouponView.isHidden = true
                            }
                            else{
                                self.EcouponTopVIew.isHidden = false
                                 self.ecouponTopViewHeightConstraint.constant = 40
                                self.lblNoRewardscoupon.isHidden = true
                                self.tblViewEcouponTransactions.isHidden = false
                                self.EcouponView.isHidden = false
                                DispatchQueue.main.async {
                                    self.tblViewEcouponTransactions.reloadData()
                                                                   
        var heightConstant = CGFloat((self.successTransactionsEcoupon.count + self.claimTransactionsEcoupon.count + self.reclaimTransactionsEcoupon.count ) * 175)  + 120 +  CGFloat(self.couponCodesList.count*45)
                     self.tblViewEcouponTransactions.isScrollEnabled = false
                      self.ecouponHeightConstraint.constant = heightConstant+100
                                }
                                
//                                self.bgScroll.contentSize = CGSize(width: self.view.frame.size.width, height: self.ecouponHeightConstraint.constant + 200)
//
                                }
                        
                        if self.successSeedTransactions.count == 0 && self.claimSeedTransactions.count == 0  && self.reclaimSeedTransactions.count == 0{
                            self.lblNoRewardsSeed.isHidden = true
                            self.seedTopViewheightConstrain.constant = 0
                            self.seedHeightConstraint.constant = 0
                            self.seedView.isHidden = true
                        }else{
                            self.SeedTopView.isHidden = false
                            self.lblNoRewardsSeed.isHidden = true
                            self.seedTopViewheightConstrain.constant = 40
                            self.seedView.isHidden = false
                            self.tblViewSeedTransactions.isHidden = false
                            DispatchQueue.main.async {
                                self.tblViewSeedTransactions.reloadData()
                                var heightConstant = CGFloat((self.successSeedTransactions.count + self.claimSeedTransactions.count + self.reclaimSeedTransactions.count ) * 175)  + 125
                                self.tblViewSeedTransactions.isScrollEnabled = false
                                self.seedHeightConstraint.constant = heightConstant+100
                            }
                        }
                        
                        ///***** Seed 2*****///
                        if self.successSeed2Transactions.count == 0 && self.claimSeed2Transactions.count == 0 && self.reclaimSeed2Transactions.count == 0{
                            self.lblNoRewardsSeed2.isHidden = true
                            self.seed2TopViewheightConstrain.constant = 0
                            self.seed2HeightConstraint.constant = 0
                            self.seedView2.isHidden = true
                        }else{
                            self.SeedTopView2.isHidden = false
                            self.lblNoRewardsSeed2.isHidden = true
                            self.seed2TopViewheightConstrain.constant = 40
                            self.tblViewseed2Transactions.isHidden = false
                            self.seedView2.isHidden = false
                            DispatchQueue.main.async {
                                self.tblViewseed2Transactions.reloadData()
                                var heightConstant = CGFloat((self.successSeed2Transactions.count + self.claimSeed2Transactions.count + self.reclaimSeed2Transactions.count ) * 175)  + 125
                                self.tblViewseed2Transactions.isScrollEnabled = false
                                self.seed2HeightConstraint.constant = heightConstant+100
                            }
                        }
                        
                        
                        ////********** DSR**********//////
                        if self.successDSRTransactions.count == 0 && self.claimDSRTransactions.count == 0 && self.reclaimDSRTransactions.count == 0{
                            self.lnlNoRewardsDSR.isHidden = true
                            self.dsrTopViewHeightConstraint.constant = 0
                            self.dsrHeightConstraint.constant = 0
                            self.dsrView.isHidden = true
                        }else{
                            self.dsrTopView.isHidden = false
                            self.lnlNoRewardsDSR.isHidden = true
                            self.dsrTopViewHeightConstraint.constant = 40
                            self.tblViewDSRTransactions.isHidden = false
                            self.dsrView.isHidden = false
                            DispatchQueue.main.async {
                                self.tblViewDSRTransactions.reloadData()
                                var heightConstant = CGFloat((self.successDSRTransactions.count + self.claimDSRTransactions.count + self.reclaimDSRTransactions.count ) * 175)  + 125
                                self.tblViewDSRTransactions.isScrollEnabled = false
                                self.dsrHeightConstraint.constant = heightConstant+100
                            }
                        }
                       // self.bgScroll.contentSize = CGSize(width: self.view.frame.size.width, height: self.rewardHeightConstraint.constant+self.ecouponHeightConstraint.constant+self.seedHeightConstraint.constant+self.seed2HeightConstraint.constant+self.dsrHeightConstraint.constant+1000)
                        if self.sectionNames.count == 0 && self.sectionNamesEcoupon.count == 0 && self.sectionNamesSeed.count == 0 && self.sectionNamesSeed2.count == 0 && self.sectionNamesDSR.count == 0 &&
                            self.giftCouponTransactions.count == 0{
                            /*self.rewardHeightConstraint.constant = 0
                            self.rewardTopViewHeightConstraint.constant = 0
                            self.RewardView.isHidden = false
                            self.tblViewTransactions.isHidden = true
                            self.lblNoRewards.isHidden = true*/
                            
                            let noDataAvailableLBL : UILabel = UILabel (frame: CGRect(x: self.view.frame.origin.x,y: 20,width:self.view.frame.width,height: 40))
                            noDataAvailableLBL.text = NSLocalizedString("no_data_available", comment: "")
                            noDataAvailableLBL.textColor = UIColor.gray
                            noDataAvailableLBL.textAlignment = NSTextAlignment.center
                            noDataAvailableLBL.font = UIFont.systemFont(ofSize: 14.0)
                            self.bgScroll.addSubview(noDataAvailableLBL)
                            
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
                self.lblNoRewardscoupon.isHidden = false
                self.tblViewTransactions.isHidden = true
                self.rewardHeightConstraint.constant = 70.0
                
                self.lblNoRewards.isHidden = true
                self.tblViewEcouponTransactions.isHidden = true
                self.ecouponHeightConstraint.constant = 70.0
                
                self.lblNoRewardsSeed.isHidden = true
                self.tblViewSeedTransactions.isHidden = true
                self.seedHeightConstraint.constant = 70.0
                
                self.lblNoRewardsSeed2.isHidden = true
                self.tblViewseed2Transactions.isHidden = true
                self.seed2HeightConstraint.constant = 70.0
                
                self.lnlNoRewardsDSR.isHidden = true
                self.tblViewDSRTransactions.isHidden = true
                self.dsrHeightConstraint.constant = 70.0
                
                self.lblNoRewardsGiftCoupon.isHidden = true
                self.tblViewGiftCouponTransactions.isHidden = true
                self.giftCouponHeightConstraint.constant = 70.0
                
                self.view.makeToast((response.error?.localizedDescription)!)
            }
        }
    }
    
    @objc func reClaimAmountForTransaction(_ sender : UIButton) {
        var params = NSDictionary()
        let userObj = Constatnts.getUserObject()
        params = [ "cashFreeTransactionId" : self.reclaimTransactions[sender.tag].cashFreeTransactionId ,"benfTransactionId" : self.reclaimTransactions[sender.tag].benfTransactionId,"cashRewards" : self.reclaimTransactions[sender.tag].amount]
        print("\(params)")
        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectModeOfTransferViewController") as? SelectModeOfTransferViewController
        toSelectPayVC?.dictEncashResponse = params
        toSelectPayVC?.isRewardClaims = true
        toSelectPayVC?.isFromSeedClaims = false
        if arrrayPaymentCashfree.count>0{
            toSelectPayVC?.viewPaymentOptions = arrrayPaymentCashfree as? NSMutableArray ?? []
        }
        toSelectPayVC?.programId = self.reclaimTransactions[sender.tag].programId
        toSelectPayVC?.dsrId = self.reclaimTransactions[sender.tag].dsrProgramId
        self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
        
    }
    @objc func QRCodeCLickAction(_ sender : UIButton) {
        print("coming here sender.tag",sender.tag)
//        var scanORNot = self.giftCouponTransactions[sender.tag].redeemStatus
//        print("coming here sender.tag",scanORNot)
//        if(scanORNot == false){
//            self.view.makeToast("This Coupon is Already Scanned")
//        }
//        else{
            self.mainBackgroundView.isHidden = false
            self.QRCodeView.isHidden = false
            generateQRCode(from: self.giftCouponTransactions[sender.tag].qrCodeData)
//        }
       
    }
    
    @objc func reClaimAmountForTransactionEcoupon(_ sender : UIButton) {
        var params = NSDictionary()
        let userObj = Constatnts.getUserObject()
        params = [ "cashFreeTransactionId" : self.reclaimTransactionsEcoupon[sender.tag].cashFreeTransactionId ,"benfTransactionId" : self.reclaimTransactionsEcoupon[sender.tag].benfTransactionId,"cashRewards" : self.reclaimTransactionsEcoupon[sender.tag].amount,"ecouponFarmerMapId" : self.reclaimTransactionsEcoupon[sender.tag].ecouponFarmerMapId]
        print("\(params)")
        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectModeOfTransferViewController") as? SelectModeOfTransferViewController
        toSelectPayVC?.dictEncashResponse = params
        toSelectPayVC?.isRewardClaims = false
        toSelectPayVC?.isFromSeedClaims = false
        if arrrayPaymenteCoupon.count>0{
            toSelectPayVC?.viewPaymentOptions = arrrayPaymenteCoupon as? NSMutableArray ?? []
        }
        toSelectPayVC?.programId = self.reclaimTransactionsEcoupon[sender.tag].programId
        toSelectPayVC?.dsrId = self.reclaimTransactionsEcoupon[sender.tag].dsrProgramId
        self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
    }
    
    @objc func reClaimAmountForSeedTransaction(_ sender: UIButton){
        var params = NSDictionary()
        let userObj = Constatnts.getUserObject()
        params = [ "cashFreeTransactionId" : self.reclaimSeedTransactions[sender.tag].cashFreeTransactionId ,"benfTransactionId" : self.reclaimSeedTransactions[sender.tag].benfTransactionId,"cashRewards" : self.reclaimSeedTransactions[sender.tag].amount]
        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectModeOfTransferViewController") as? SelectModeOfTransferViewController
        toSelectPayVC?.dictEncashResponse = params
        toSelectPayVC?.isRewardClaims = false
        toSelectPayVC?.isFromSeedClaims = true
        if arrrayPaymentSeed.count>0{
            toSelectPayVC?.viewPaymentOptions = arrrayPaymentSeed as? NSMutableArray ?? []
        }
        toSelectPayVC?.programId = self.reclaimSeedTransactions[sender.tag].programId
        toSelectPayVC?.dsrId = self.reclaimSeedTransactions[sender.tag].dsrProgramId
        self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
        
    }
    @objc func reClaimAmountForSeed2Transaction(_ sender: UIButton){
        var params = NSDictionary()
        let userObj = Constatnts.getUserObject()
        params = [ "cashFreeTransactionId" : self.reclaimSeed2Transactions[sender.tag].cashFreeTransactionId ,"benfTransactionId" : self.reclaimSeed2Transactions[sender.tag].benfTransactionId,"cashRewards" : self.reclaimSeed2Transactions[sender.tag].amount]
        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectModeOfTransferViewController") as? SelectModeOfTransferViewController
        toSelectPayVC?.dictEncashResponse = params
        toSelectPayVC?.isRewardClaims = false
        toSelectPayVC?.isFromSeedClaims = true
        if arrrayPaymentseedTwo.count>0{
            toSelectPayVC?.viewPaymentOptions = arrrayPaymentseedTwo as? NSMutableArray ?? []
        }
        toSelectPayVC?.programId = self.reclaimSeed2Transactions[sender.tag].programId
        toSelectPayVC?.dsrId = self.reclaimSeed2Transactions[sender.tag].dsrProgramId
        self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
        
    }
    
    @objc func reClaimAmountForDSRTransaction(_ sender: UIButton){
        var params = NSDictionary()
        let userObj = Constatnts.getUserObject()
        params = [ "cashFreeTransactionId" : self.reclaimDSRTransactions[sender.tag].cashFreeTransactionId ,"benfTransactionId" : self.reclaimDSRTransactions[sender.tag].benfTransactionId,"cashRewards" : self.reclaimDSRTransactions[sender.tag].amount]
        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectModeOfTransferViewController") as? SelectModeOfTransferViewController
        toSelectPayVC?.dictEncashResponse = params
        toSelectPayVC?.isRewardClaims = false
        toSelectPayVC?.isFromSeedClaims = false
        if arrrayPaymentDsr.count>0{
            toSelectPayVC?.viewPaymentOptions = arrrayPaymentDsr as? NSMutableArray ?? []
        }
        toSelectPayVC?.programId = self.reclaimDSRTransactions[sender.tag].programId
        toSelectPayVC?.dsrId = self.reclaimDSRTransactions[sender.tag].dsrProgramId
        self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
        
    }
    
    @objc func reInitiatePaymentTransactionForRecord(tag : Int) {
        var claimIDsArray = NSMutableArray()
        var params = NSDictionary()
        for  (i,j) in self.claimTransactions.enumerated() {
            params = [ "serverRecordId" : self.claimTransactions[i].serverRecordId ,"benfTransactionId" : self.claimTransactions[i].benfTransactionId]
            claimIDsArray.add(params)
        }
        
        let parameters = ["cashRewards":"\(self.totalClaimAmount)","claimIDs":claimIDsArray] as NSDictionary
        let userObj = Constatnts.getUserObject()
        self.registerFirebaseEvents(GC_Claim, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "RewardsViewController", parameters: nil )
        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectModeOfTransferViewController") as? SelectModeOfTransferViewController
        toSelectPayVC?.dictEncashResponse = parameters
        toSelectPayVC?.isFromSeedClaims = false
        if arrrayPaymentCashfree.count>0{
            toSelectPayVC?.viewPaymentOptions = arrrayPaymentCashfree as? NSMutableArray ?? []
        }
        toSelectPayVC?.programId = self.claimTransactions[tag].programId
        toSelectPayVC?.dsrId = self.claimTransactions[tag].dsrProgramId
        self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
        
    }
    
    @objc func reInitiatePaymentTransactionForRecordEcoupon(tag : Int) {
        var claimIDsArray = NSMutableArray()
        var params = NSDictionary()
        for  (i,j) in self.claimTransactionsEcoupon.enumerated() {
            params = [ "serverRecordId" : self.claimTransactionsEcoupon[i].serverRecordId ,"benfTransactionId" : self.claimTransactionsEcoupon [i].benfTransactionId,"ecouponFarmerMapId" : self.claimTransactionsEcoupon[i].ecouponFarmerMapId]
            claimIDsArray.add(params)
        }
        let parameters = ["cashRewards":"\(self.totalClaimAmountEcoupon)", "ecouponFarmerMapId" : self.claimTransactionsEcoupon[0].ecouponFarmerMapId,"claimIDs":claimIDsArray] as NSDictionary
        let userObj = Constatnts.getUserObject()
        self.registerFirebaseEvents(GC_Claim, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "RewardsViewController", parameters: nil )
        
        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectModeOfTransferViewController") as? SelectModeOfTransferViewController
        toSelectPayVC?.dictEncashResponse = parameters
        toSelectPayVC?.isRewardClaims = false
        toSelectPayVC?.isFromSeedClaims = false
        if arrrayPaymenteCoupon.count>0{
            toSelectPayVC?.viewPaymentOptions = arrrayPaymenteCoupon as? NSMutableArray ?? []
        }
        toSelectPayVC?.programId = self.claimTransactionsEcoupon[tag].programId
        toSelectPayVC?.dsrId = self.claimTransactionsEcoupon[tag].dsrProgramId
        self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
        
    }
    
    @objc func reInitiatePaymentTransactionForRecordSeed(tag: Int){
        var claimIDsArray = NSMutableArray()
        var params = NSDictionary()
        for  (i,j) in self.claimSeedTransactions.enumerated() {
            params = [ "serverRecordId" : self.claimSeedTransactions[i].serverRecordId ,"benfTransactionId" : self.claimSeedTransactions[i].benfTransactionId]
            claimIDsArray.add(params)
        }
        
        let parameters = ["cashRewards":"\(self.totalClaimAmountSeed)","claimIDs":claimIDsArray] as NSDictionary
        let userObj = Constatnts.getUserObject()
        self.registerFirebaseEvents(GC_Claim, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "RewardsViewController", parameters: nil )
        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectModeOfTransferViewController") as? SelectModeOfTransferViewController
        toSelectPayVC?.dictEncashResponse = parameters
        toSelectPayVC?.isRewardClaims = false
        toSelectPayVC?.isFromSeedClaims = true
        if arrrayPaymentSeed.count>0{
            toSelectPayVC?.viewPaymentOptions = arrrayPaymentSeed as? NSMutableArray ?? []
        }
        toSelectPayVC?.programId = self.claimSeedTransactions[tag].programId
        toSelectPayVC?.dsrId = self.claimSeedTransactions[tag].dsrProgramId
        self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
    }
    
    @objc func reInitiatePaymentTransactionForRecordSeed2(tag: Int){
        var claimIDsArray = NSMutableArray()
        var params = NSDictionary()
        for  (i,j) in self.claimSeed2Transactions.enumerated() {
            params = [ "serverRecordId" : self.claimSeed2Transactions[i].serverRecordId ,"benfTransactionId" : self.claimSeed2Transactions[i].benfTransactionId]
            claimIDsArray.add(params)
        }
        let parameters = ["cashRewards":"\(self.totalClaimAmountSeed2)","claimIDs":claimIDsArray] as NSDictionary
        let userObj = Constatnts.getUserObject()
        self.registerFirebaseEvents(GC_Claim, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "RewardsViewController", parameters: nil )
        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectModeOfTransferViewController") as? SelectModeOfTransferViewController
        toSelectPayVC?.dictEncashResponse = parameters
        toSelectPayVC?.isRewardClaims = false
        toSelectPayVC?.isFromSeedClaims = true
        if arrrayPaymentseedTwo.count>0{
            toSelectPayVC?.viewPaymentOptions = arrrayPaymentseedTwo as? NSMutableArray ?? []
        }
        toSelectPayVC?.programId = self.claimSeed2Transactions[tag].programId
        toSelectPayVC?.dsrId = self.claimSeed2Transactions[tag].dsrProgramId
        self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
    }
    
    @objc func reInitiatePaymentTransactionForRecordDSR(tag: Int){
        var claimIDsArray = NSMutableArray()
        var params = NSDictionary()
        for  (i,j) in self.claimSeedTransactions.enumerated() {
            params = [ "serverRecordId" : self.claimDSRTransactions[i].serverRecordId ,"benfTransactionId" : self.claimDSRTransactions[i].benfTransactionId]
            claimIDsArray.add(params)
        }
        
        let parameters = ["cashRewards":"\(self.totalClaimAmountDSR)","claimIDs":claimIDsArray] as NSDictionary
        let userObj = Constatnts.getUserObject()
        self.registerFirebaseEvents(GC_Claim, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "RewardsViewController", parameters: nil )
        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectModeOfTransferViewController") as? SelectModeOfTransferViewController
        toSelectPayVC?.dictEncashResponse = parameters
        toSelectPayVC?.isRewardClaims = false
        toSelectPayVC?.isFromSeedClaims = false
        if arrrayPaymentDsr.count>0{
            toSelectPayVC?.viewPaymentOptions = arrrayPaymentDsr as? NSMutableArray ?? []
        }
        toSelectPayVC?.programId = self.claimDSRTransactions[tag].programId
        toSelectPayVC?.dsrId = self.claimDSRTransactions[tag].dsrProgramId
        self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
    }
    
    @objc @IBAction func updateFarmerTransactions(_ sender : UIButton) {
        let parameters = ["amount":self.reclaimTransactions[sender.tag].amount , "beneId":self.reclaimTransactions[sender.tag].beneId  , "mobileNumber":self.reclaimTransactions[sender.tag].mobileNumber , "transferMode":self.reclaimTransactions[sender.tag].transferMode , "createdOn":self.reclaimTransactions[sender.tag].createdOn , "status":self.reclaimTransactions[sender.tag].status, "referenceId":self.reclaimTransactions[sender.tag].referenceId , "transferId":self.reclaimTransactions[sender.tag].transferId , "cashFreeTransactionId" : self.reclaimTransactions[sender.tag].cashFreeTransactionId , "reClaim" :  "Yes", "moduleType": "Farmer"] as NSDictionary
        
        let finalParamsDic = NSMutableDictionary()
        finalParamsDic.addEntries(from: parameters as! [AnyHashable : Any])
        print(finalParamsDic)
        self.requestToGetgetFarmerRewards(params: finalParamsDic)
    }
    
    @IBAction func refreshMyTransactionsClick(_ sender: UIButton){
        let userObj = Constatnts.getUserObject()
        self.registerFirebaseEvents(Rewards_Refresh_Page, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "RewardsViewController", parameters: nil)
        let params : NSMutableDictionary = ["reClaim" : "No", "moduleType": "Farmer"]
        self.requestToGetgetFarmerRewards(params: params)
    }
    
    @IBAction func qrCodeViewCloseBtn(_ sender: UIButton){
        self.mainBackgroundView.isHidden = true
        self.QRCodeView.isHidden = true
    }
    
    
    @objc func getMoreDetailsOfTransaction(_ sender: UIButton){
        guard let detailedVC = self.storyboard?.instantiateViewController(withIdentifier: "TransactionDetailsPopOverViewController") as? TransactionDetailsPopOverViewController else { return  }
        detailedVC.referenceId = self.successTransactions[sender.tag].referenceId
        detailedVC.amount = self.successTransactions[sender.tag].amount
        let navController = UINavigationController(rootViewController: detailedVC) // Creating a navigation controller with VC1 at the root of the navigation stack.
        self.present(navController, animated:true, completion: nil)
        
    }
    
    @objc func getMoreDetailsOfTransactionSeed(_ sender: UIButton){
        guard let detailedVC = self.storyboard?.instantiateViewController(withIdentifier: "TransactionDetailsPopOverViewController") as? TransactionDetailsPopOverViewController else { return  }
        detailedVC.referenceId = self.successSeedTransactions[sender.tag].referenceId
        detailedVC.amount = self.successSeedTransactions[sender.tag].amount
        detailedVC.seadId = self.successSeedTransactions[sender.tag].programId
        let navController = UINavigationController(rootViewController: detailedVC) // Creating a navigation controller with VC1 at the root of the navigation stack.
        self.present(navController, animated:true, completion: nil)
        
    }
    
    @objc func getMoreDetailsOfTransactionEcoupon(_ sender: UIButton){
        guard let detailedVC = self.storyboard?.instantiateViewController(withIdentifier: "TransactionDetailsPopOverViewController") as? TransactionDetailsPopOverViewController else { return  }
        detailedVC.referenceId = self.successTransactionsEcoupon[sender.tag].referenceId
        detailedVC.amount = self.successTransactionsEcoupon[sender.tag].amount
        let navController = UINavigationController(rootViewController: detailedVC) // Creating a navigation controller with VC1 at the root of the navigation stack.
        self.present(navController, animated:true, completion: nil)
        
    }
    @objc func getMoreDetailsOfTransactionSeed2(_ sender: UIButton){
           guard let detailedVC = self.storyboard?.instantiateViewController(withIdentifier: "TransactionDetailsPopOverViewController") as? TransactionDetailsPopOverViewController else { return  }
           detailedVC.referenceId = self.successSeed2Transactions[sender.tag].referenceId
           detailedVC.amount = self.successSeed2Transactions[sender.tag].amount
           detailedVC.seadId = self.successSeed2Transactions[sender.tag].programId
           let navController = UINavigationController(rootViewController: detailedVC) // Creating a navigation controller with VC1 at the root of the navigation stack.
           self.present(navController, animated:true, completion: nil)
           
       }
    @objc func getMoreDetailsOfTransactionDSR(_ sender: UIButton){
           guard let detailedVC = self.storyboard?.instantiateViewController(withIdentifier: "TransactionDetailsPopOverViewController") as? TransactionDetailsPopOverViewController else { return  }
           detailedVC.referenceId = self.successDSRTransactions[sender.tag].referenceId
           detailedVC.amount = self.successDSRTransactions[sender.tag].amount
           detailedVC.dsrId = self.successDSRTransactions[sender.tag].dsrProgramId
           let navController = UINavigationController(rootViewController: detailedVC) // Creating a navigation controller with VC1 at the root of the navigation stack.
           self.present(navController, animated:true, completion: nil)
           
       }
    
    //    @IBAction func statutoryActionArrow(_ sender: Any) {
    //        switch (sender as AnyObject).tag {
    //        case 100:
    //
    //            self.RewardView.isHidden = !self.RewardView.isHidden
    //
    ////            self.EcouponView.isHidden = true
    ////            self.ecouponHeightConstraint.constant = 0
    ////            self.EcouponImageView.image = UIImage(named: "downroundIcon")
    //
    //            if RewardView.isHidden == true{
    //                RewardViewImageView.image = UIImage(named: "downroundIcon")
    //                self.rewardHeightConstraint.constant = 0
    ////                self.ecouponTopViewHeightConstraint.constant = 35
    //                                  self.bgScroll?.contentSize = CGSize(width: self.contentVIew.frame.size.width, height: self.ecouponHeightConstraint.constant + self.rewardHeightConstraint.constant + 800.0)
    //                                  self.bgScroll?.updateConstraintsIfNeeded()
    //                                           self.bgScroll?.layoutIfNeeded()
    //                                  //        bgScroll?.contentSize = CGSize(width: self.contentVIew.frame.size.width, height: ((contentVIew?.frame.maxY ?? 0) + 1800))
    //                                          self.view.layoutIfNeeded()
    //                                          self.view.updateConstraintsIfNeeded()
    //            }
    //            else{
    //
    //                RewardViewImageView.image = UIImage(named: "upArrow-1")
    //                 DispatchQueue.main.async {
    //                    var heightConstant = CGFloat((self.successTransactions.count + self.claimTransactions.count + self.reclaimTransactions.count ) * 140)
    //                                      self.rewardHeightConstraint.constant = heightConstant
    //                    self.bgScroll?.contentSize = CGSize(width: self.contentVIew.frame.size.width, height: self.ecouponHeightConstraint.constant + self.rewardHeightConstraint.constant + 800.0)
    //                    self.bgScroll?.updateConstraintsIfNeeded()
    //                             self.bgScroll?.layoutIfNeeded()
    //                    //        bgScroll?.contentSize = CGSize(width: self.contentVIew.frame.size.width, height: ((contentVIew?.frame.maxY ?? 0) + 1800))
    //                            self.view.layoutIfNeeded()
    //                            self.view.updateConstraintsIfNeeded()
    //                }
    //            }
    //
    //        case 101:
    //            self.EcouponView.isHidden = !self.EcouponView.isHidden
    ////            RewardViewImageView.image = UIImage(named: "downroundIcon")
    ////            self.rewardHeightConstraint.constant = 0
    //
    //            if self.EcouponView.isHidden == true{
    //                EcouponImageView.image = UIImage(named: "downroundIcon")
    ////                                self.rewardHeightConstraint.constant = 0
    //                self.ecouponTopViewHeightConstraint.constant = 35
    //                var heightConstant = CGFloat((self.successTransactionsEcoupon.count + self.claimTransactionsEcoupon.count + self.reclaimTransactionsEcoupon.count ) * 140)
    //                   self.ecouponHeightConstraint.constant = heightConstant
    //                self.bgScroll?.contentSize = CGSize(width: self.contentVIew.frame.size.width, height: self.ecouponHeightConstraint.constant + self.rewardHeightConstraint.constant + 800.0)
    //                                                  self.bgScroll?.updateConstraintsIfNeeded()
    //                                                           self.bgScroll?.layoutIfNeeded()
    //                                                          self.view.layoutIfNeeded()
    //                                                          self.view.updateConstraintsIfNeeded()
    //
    //
    //
    //
    //
    //
    ////                 self.ecouponTopViewHeightConstraint.constant = 35
    ////                self.ecouponHeightConstraint.constant = 0
    ////                self.bgScroll?.contentSize = CGSize(width: self.contentVIew.frame.size.width, height: self.ecouponHeightConstraint.constant + self.rewardHeightConstraint.constant + 800.0)
    ////                self.bgScroll?.updateConstraintsIfNeeded()
    ////                self.bgScroll?.layoutIfNeeded()
    ////                //        bgScroll?.contentSize = CGSize(width: self.contentVIew.frame.size.width, height: ((contentVIew?.frame.maxY ?? 0) + 1800))
    ////
    ////                self.bgScroll?.updateConstraintsIfNeeded()
    ////                self.bgScroll?.layoutIfNeeded()
    ////                        self.view.layoutIfNeeded()
    ////                        self.view.updateConstraintsIfNeeded()
    //            }
    //            else{
    //                EcouponImageView.image = UIImage(named: "upArrow-1")
    //               self.ecouponTopViewHeightConstraint.constant = 35
    //                       var heightConstant = CGFloat((self.successTransactionsEcoupon.count + self.claimTransactionsEcoupon.count + self.reclaimTransactionsEcoupon.count ) * 140)
    //                          self.ecouponHeightConstraint.constant = heightConstant
    //                       self.bgScroll?.contentSize = CGSize(width: self.contentVIew.frame.size.width, height: self.ecouponHeightConstraint.constant + self.rewardHeightConstraint.constant + 800.0)
    //                                                         self.bgScroll?.updateConstraintsIfNeeded()
    //                                                                  self.bgScroll?.layoutIfNeeded()
    //                                                                 self.view.layoutIfNeeded()
    //                                                                 self.view.updateConstraintsIfNeeded()
    ////                     var heightConstant = CGFloat((self.successTransactionsEcoupon.count + self.claimTransactionsEcoupon.count + self.reclaimTransactionsEcoupon.count ) * 140) + CGFloat(self.couponCodesList.count * 30)
    ////                 DispatchQueue.main.async {
    ////                    self.ecouponHeightConstraint.constant = heightConstant
    ////                    self.bgScroll?.contentSize = CGSize(width: self.contentVIew.frame.size.width, height: self.ecouponHeightConstraint.constant + self.rewardHeightConstraint.constant + 800.0)
    ////                    self.bgScroll?.updateConstraintsIfNeeded()
    ////                    self.bgScroll?.layoutIfNeeded()
    ////                    //        bgScroll?.contentSize = CGSize(width: self.contentVIew.frame.size.width, height: ((contentVIew?.frame.maxY ?? 0) + 1800))
    ////
    ////                    self.bgScroll?.updateConstraintsIfNeeded()
    ////                    self.bgScroll?.layoutIfNeeded()
    ////                            self.view.layoutIfNeeded()
    ////                            self.view.updateConstraintsIfNeeded()
    ////                }
    ////
    //            }
    //
    //        default: break
    //        }
    //
    //    }
       @IBAction func statutoryActionArrow(_ sender: Any) {
          switch (sender as AnyObject).tag {
          case 100:
            
              self.RewardView.isHidden = !self.RewardView.isHidden
              
              if self.RewardView.isHidden == true {
                RewardViewImageView.image = UIImage(named: "downroundIcon")
                                 self.rewardHeightConstraint.constant = 50
                self.rewardTopViewHeightConstraint.constant = 50
                 self.lblNoRewards.isHidden = true
                //                self.ecouponTopViewHeightConstraint.constant = 35
                //                                                   self.bgScroll?.contentSize = CGSize(width: self.contentVIew.frame.size.width, height: self.ecouponHeightConstraint.constant + self.rewardHeightConstraint.constant + 800.0)
//                                                   self.bgScroll?.updateConstraintsIfNeeded()
//                                                            self.bgScroll?.layoutIfNeeded()
//                                                   //        bgScroll?.contentSize = CGSize(width: self.contentVIew.frame.size.width, height: ((contentVIew?.frame.maxY ?? 0) + 1800))
//                                                           self.view.layoutIfNeeded()
//                                                           self.view.updateConstraintsIfNeeded()
              }else {
                RewardViewImageView.image = UIImage(named: "upArrow-1")
                self.lblNoRewards.isHidden = true
                self.rewardTopViewHeightConstraint.constant = 50
                DispatchQueue.main.async {
//                     self.tblViewTransactions.reloadSections([0, 1, 2], with: .none)
                    var heightConstant = CGFloat((self.successTransactions.count + self.claimTransactions.count + self.reclaimTransactions.count ) * 175)  + 120
                      self.tblViewTransactions.isScrollEnabled = false
                    self.rewardHeightConstraint.constant = heightConstant+100
                    let height1 = self.rewardHeightConstraint.constant+self.ecouponHeightConstraint.constant
                    let height2 = self.seedHeightConstraint.constant+self.seed2HeightConstraint.constant+self.dsrHeightConstraint.constant
                    self.bgScroll.contentSize = CGSize(width: self.view.frame.size.width, height: height1+height2+1000)
                    
//                    self.tblViewTransactions.reloadSectionIndexTitles()
              }
              }
            
            
            break
        
            
          case 101:
            
              self.EcouponView.isHidden = !self.EcouponView.isHidden
                          
                          if self.EcouponView.isHidden == true {
                            EcouponImageView.image = UIImage(named: "downroundIcon")
                                             self.ecouponHeightConstraint.constant = 50
                            self.ecouponTopViewHeightConstraint.constant = 50
                            self.lblNoRewardscoupon.isHidden = true
                            //                self.ecouponTopViewHeightConstraint.constant = 35
                            //                                                   self.bgScroll?.contentSize = CGSize(width: self.contentVIew.frame.size.width, height: self.ecouponHeightConstraint.constant + self.rewardHeightConstraint.constant + 800.0)
            //                                                   self.bgScroll?.updateConstraintsIfNeeded()
            //                                                            self.bgScroll?.layoutIfNeeded()
            //                                                   //        bgScroll?.contentSize = CGSize(width: self.contentVIew.frame.size.width, height: ((contentVIew?.frame.maxY ?? 0) + 1800))
            //                                                           self.view.layoutIfNeeded()
            //                                                           self.view.updateConstraintsIfNeeded()
                          }else {
                                   EcouponImageView.image = UIImage(named: "upArrow-1")
                            self.ecouponTopViewHeightConstraint.constant = 50
                            var heightConstant = CGFloat((self.successTransactionsEcoupon.count + self.claimTransactionsEcoupon.count + self.reclaimTransactionsEcoupon.count ) * 175) + CGFloat(self.couponCodesList.count * 45) + 120
                                                self.lblNoRewardscoupon.isHidden = true
                                                 self.tblViewEcouponTransactions.isScrollEnabled = false
                             DispatchQueue.main.async {
                                                self.ecouponHeightConstraint.constant = heightConstant+100
                                let height1 = self.rewardHeightConstraint.constant+self.ecouponHeightConstraint.constant
                                let height2 = self.seedHeightConstraint.constant+self.seed2HeightConstraint.constant+self.dsrHeightConstraint.constant
                                self.bgScroll.contentSize = CGSize(width: self.view.frame.size.width, height: height1+height2+1000)

//                                                                   self.ecouponTopViewHeightConstraint.constant = heightConstant
                          }
                          }
            
            break
            
          case 102:
            self.seedView.isHidden = !self.seedView.isHidden
            
            if self.seedView.isHidden == true {
                SeedImageView.image = UIImage(named: "downroundIcon")
                self.seedHeightConstraint.constant = 50
                self.seedTopViewheightConstrain.constant = 50
                self.lblNoRewardsSeed.isHidden = true
              
            }else {
                SeedImageView.image = UIImage(named: "upArrow-1")
                self.lblNoRewardsSeed.isHidden = true
                self.seedTopViewheightConstrain.constant = 50
                DispatchQueue.main.async {
            
                    var heightConstant = CGFloat((self.successSeedTransactions.count + self.claimSeedTransactions.count + self.reclaimSeedTransactions.count ) * 175)  + 120
                    self.tblViewSeedTransactions.isScrollEnabled = false
                    self.seedHeightConstraint.constant = heightConstant+100
                    let height1 = self.rewardHeightConstraint.constant+self.ecouponHeightConstraint.constant
                    let height2 = self.seedHeightConstraint.constant+self.seed2HeightConstraint.constant+self.dsrHeightConstraint.constant
                    self.bgScroll.contentSize = CGSize(width: self.view.frame.size.width, height: height1+height2+1000)
                    
                    //                    self.tblViewTransactions.reloadSectionIndexTitles()
                }
            }
            
            break
            
            case 103:
            self.seedView2.isHidden = !self.seedView2.isHidden
            self.lblNoRewardsSeed2.isHidden = true
            self.seed2TopViewheightConstrain.constant = 50
                
            if self.seedView2.isHidden == true {
                Seed2ImageView.image = UIImage(named: "downroundIcon")
                self.seed2HeightConstraint.constant = 50
            }else {
                Seed2ImageView.image = UIImage(named: "upArrow-1")
                DispatchQueue.main.async {
                    var heightConstant = CGFloat((self.successSeed2Transactions.count + self.claimSeed2Transactions.count + self.reclaimSeed2Transactions.count ) * 175)  + 120
                    self.tblViewseed2Transactions.isScrollEnabled = false
                    self.seed2HeightConstraint.constant = heightConstant+100
                    let height1 = self.rewardHeightConstraint.constant+self.ecouponHeightConstraint.constant
                    let height2 = self.seedHeightConstraint.constant+self.seed2HeightConstraint.constant+self.dsrHeightConstraint.constant
                    self.bgScroll.contentSize = CGSize(width: self.view.frame.size.width, height: height1+height2+1000)
                }
            }
            break
            
            case 104:
            self.dsrView.isHidden = !self.dsrView.isHidden
            self.dsrTopViewHeightConstraint.constant = 50
            self.lnlNoRewardsDSR.isHidden = true
                
            if self.dsrView.isHidden == true {
                dsrImageView.image = UIImage(named: "downroundIcon")
                self.dsrHeightConstraint.constant = 50
            }else {
                dsrImageView.image = UIImage(named: "upArrow-1")
                DispatchQueue.main.async {
                    var heightConstant = CGFloat((self.successDSRTransactions.count + self.claimDSRTransactions.count + self.reclaimDSRTransactions.count ) * 175)  + 120
                    self.tblViewDSRTransactions.isScrollEnabled = false
                    self.dsrHeightConstraint.constant = heightConstant+100
                    let height1 = self.rewardHeightConstraint.constant+self.ecouponHeightConstraint.constant
                    let height2 = self.seedHeightConstraint.constant+self.seed2HeightConstraint.constant+self.dsrHeightConstraint.constant
                    self.bgScroll.contentSize = CGSize(width: self.view.frame.size.width, height: height1+height2+1000)
                }
            }
         break
              
          case 105:
          self.giftCouponView.isHidden = !self.giftCouponView.isHidden
          self.giftCouponHeightConstraint.constant = 50
          self.lblNoRewardsGiftCoupon.isHidden = true
              
          if self.giftCouponView.isHidden == true {
              giftCouponImageView.image = UIImage(named: "downroundIcon")
              //self.lblNoRewardsGiftCoupon.constant = 50
          }else {
              giftCouponImageView.image = UIImage(named: "upArrow-1")
              DispatchQueue.main.async {
                  var heightConstant = CGFloat(self.giftCouponTransactions.count)
                self.tblViewGiftCouponTransactions.isScrollEnabled = false
                  self.giftCouponHeightConstraint.constant = heightConstant+400
                  let height1 = self.rewardHeightConstraint.constant+self.ecouponHeightConstraint.constant
                  let height2 = self.seedHeightConstraint.constant+self.seed2HeightConstraint.constant+self.dsrHeightConstraint.constant
                  self.bgScroll.contentSize = CGSize(width: self.view.frame.size.width, height: height1+height2)
              }
          }
            break
            
            case .some(_):
            print("jkj")
//                    self.RewardView.isHidden = !self.RewardView.isHidden
          case .none:
            print("gjkkj")
        }
    }
        
        
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
//        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).sync {
//            if self.successTransactions.count == 0 && self.claimTransactions.count == 0  && self.reclaimTransactions.count == 0{
//                self.lblNoRewards.isHidden = false
//                self.tblViewTransactions.isHidden = true
//                self.rewardHeightConstraint.constant =  0
//                self.rewardTopViewHeightConstraint.constant = 40
//                self.ecouponTopViewHeightConstraint.constant = 40
//                var heightConstant = CGFloat((self.successTransactions.count + self.claimTransactions.count + self.reclaimTransactions.count ) * 140)
//                self.bgScroll.contentSize = CGSize(width: self.view.frame.size.width, height: heightConstant)
//            }
//            else{
//                self.lblNoRewards.isHidden = true
//                self.tblViewTransactions.isHidden = false
//                self.rewardTopViewHeightConstraint.constant = 40
//                self.ecouponTopViewHeightConstraint.constant = 40
//                var heightConstant = CGFloat((self.successTransactionsEcoupon.count + self.claimTransactionsEcoupon.count + self.reclaimTransactionsEcoupon.count ) * 140) + CGFloat(self.couponCodesList.count * 30)
//                print(self.tblViewEcouponTransactions.contentSize.height)
//                self.rewardHeightConstraint.constant =  heightConstant
//
//                self.bgScroll.contentSize = CGSize(width: self.view.frame.size.width, height: heightConstant)
//                self.bgScroll.updateConstraints()
//                self.view.layoutIfNeeded()
//                self.view.updateConstraintsIfNeeded()
//
//
//
//            }
//            if self.successTransactionsEcoupon.count == 0 && self.claimTransactionsEcoupon.count == 0  && self.reclaimTransactionsEcoupon.count == 0{
//                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).sync {
//                    self.lblNoRewards.isHidden = false
//                    self.tblViewEcouponTransactions.isHidden = true
//
//                }
//            }
//            else{
//                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).sync {
//                    self.lblNoRewards.isHidden = true
//                    self.tblViewEcouponTransactions.isHidden = false
//                    self.tblViewEcouponTransactions.reloadData()
//                    var heightConstant = CGFloat((self.successTransactionsEcoupon.count + self.claimTransactionsEcoupon.count + self.reclaimTransactionsEcoupon.count ) * 140) + CGFloat(self.couponCodesList.count * 30)
//                    print(self.tblViewEcouponTransactions.contentSize.height)
//                    self.ecouponHeightConstraint.constant =  heightConstant
//
//                    self.bgScroll.contentSize = CGSize(width: self.view.frame.size.width, height: heightConstant)
//                    self.bgScroll.updateConstraints()
//                }
//            }
//        }
        bgScroll?.updateConstraintsIfNeeded()
        bgScroll?.layoutIfNeeded()
        let height1 = self.rewardHeightConstraint.constant+self.ecouponHeightConstraint.constant
        let height2 = self.seedHeightConstraint.constant+self.seed2HeightConstraint.constant+self.dsrHeightConstraint.constant
        self.bgScroll.contentSize = CGSize(width: self.view.frame.size.width, height: height1+height2+2000)
        self.view.layoutIfNeeded()
        self.view.updateConstraintsIfNeeded()
        
    }
    
}



extension RewardsViewController  : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblViewSeedTransactions{
            return sectionNamesSeed.count
        }
        else if tableView == tblViewEcouponTransactions {
            return  sectionNamesEcoupon.count
        }
        else if tableView == tblViewTransactions{
            return sectionNames.count
        }
        else if tableView == tblViewseed2Transactions{
            return sectionNamesSeed2.count
        }
        else if tableView == tblViewDSRTransactions{
            return sectionNamesDSR.count
        }
        else if tableView == tblViewGiftCouponTransactions{
            return 1
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblViewEcouponTransactions {
            if  self.successTransactionsEcoupon.count > 0 && sectionNamesEcoupon[section].itemName.lowercased() == "success list"{
                return sectionNamesEcoupon[section].collapsed ? 0 : self.successTransactionsEcoupon.count
            }else if sectionNamesEcoupon[section].itemName.lowercased() == "claim list" && self.claimTransactionsEcoupon.count > 0  {
                return sectionNamesEcoupon[section].collapsed ? 0 : self.claimTransactionsEcoupon.count
            }else if sectionNamesEcoupon[section].itemName.lowercased() == "reclaim list" && self.reclaimTransactionsEcoupon.count > 0  {
                return sectionNamesEcoupon[section].collapsed ? 0 : self.reclaimTransactionsEcoupon.count
            }else if sectionNamesEcoupon[section].itemName.lowercased() == "lucky draw coupon list" && self.couponCodesList.count > 0  {
                return sectionNamesEcoupon[section].collapsed ? 0 : self.couponCodesList.count
            }else {
                return 0
            }
        }
        else if tableView == tblViewTransactions {
            if  self.successTransactions.count > 0 && sectionNames[section].itemName.lowercased() == "success list"{
                return sectionNames[section].collapsed ? 0 : self.successTransactions.count
            }else if sectionNames[section].itemName.lowercased() == "claim list" && self.claimTransactions.count > 0  {
                return sectionNames[section].collapsed ? 0 : self.claimTransactions.count
            }else if sectionNames[section].itemName.lowercased() == "reclaim list" && self.reclaimTransactions.count > 0  {
                return sectionNames[section].collapsed ? 0 : self.reclaimTransactions.count
            }else {
                return 0
            }
        }else if tableView == tblViewSeedTransactions{
            if  self.successSeedTransactions.count > 0 && sectionNamesSeed[section].itemName.lowercased() == "success list"{
                return sectionNamesSeed[section].collapsed ? 0 : self.successSeedTransactions.count
            }
            else if sectionNamesSeed[section].itemName.lowercased() == "claim list" && self.claimSeedTransactions.count > 0  {
                return sectionNamesSeed[section].collapsed ? 0 : self.claimSeedTransactions.count
            }
            else if sectionNamesSeed[section].itemName.lowercased() == "reclaim list" && self.reclaimSeedTransactions.count > 0  {
                return sectionNamesSeed[section].collapsed ? 0 : self.reclaimSeedTransactions.count
            }
            else {
                return 0
            }
            
        }else if tableView == tblViewseed2Transactions{
            if  self.successSeed2Transactions.count > 0 && sectionNamesSeed2[section].itemName.lowercased() == "success list"{
                return sectionNamesSeed2[section].collapsed ? 0 : self.successSeed2Transactions.count
            }
            else if sectionNamesSeed2[section].itemName.lowercased() == "claim list" && self.claimSeed2Transactions.count > 0  {
                return sectionNamesSeed2[section].collapsed ? 0 : self.claimSeed2Transactions.count
            }
            else if sectionNamesSeed2[section].itemName.lowercased() == "reclaim list" && self.reclaimSeed2Transactions.count > 0  {
                return sectionNamesSeed2[section].collapsed ? 0 : self.reclaimSeed2Transactions.count
            }
            else {
                return 0
            }
        }else if tableView == tblViewDSRTransactions{
            if  self.successDSRTransactions.count > 0 && sectionNamesDSR[section].itemName.lowercased() == "success list"{
                return sectionNamesDSR[section].collapsed ? 0 : self.successDSRTransactions.count
            }
            else if sectionNamesDSR[section].itemName.lowercased() == "claim list" && self.claimDSRTransactions.count > 0  {
                return sectionNamesDSR[section].collapsed ? 0 : self.claimDSRTransactions.count
            }
            else if sectionNamesDSR[section].itemName.lowercased() == "reclaim list" && self.reclaimDSRTransactions.count > 0  {
                return sectionNamesDSR[section].collapsed ? 0 : self.reclaimDSRTransactions.count
            }
            else {
                return 0
            }
        }
        else if tableView == tblViewGiftCouponTransactions{
            if  self.giftCouponTransactions.count > 0 {
                return self.giftCouponTransactions.count
            }
            else {
                return 0
            }
        }
        else{
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == tblViewEcouponTransactions {
            
            if self.sectionNamesEcoupon[section].itemName.lowercased() == "success list" && self.successTransactionsEcoupon.count > 0 || self.sectionNamesEcoupon[section].itemName.lowercased() == "claim list" && self.claimTransactionsEcoupon.count > 0 || self.sectionNamesEcoupon[section].itemName.lowercased() == "reclaim list" && self.reclaimTransactionsEcoupon.count > 0 || self.sectionNamesEcoupon[section].itemName.lowercased() == "lucky draw coupon list" && self.couponCodesList.count > 0 {
                var title = ""
                if sectionNamesEcoupon[section].itemName.lowercased() == "success list"{
                    title = NSLocalizedString("success_list", comment: "").capitalized
                    return title
                }else if sectionNamesEcoupon[section].itemName.lowercased() == "claim list"{
                    title = NSLocalizedString("claim_list", comment: "").capitalized
                    return title
                }else if sectionNamesEcoupon[section].itemName.lowercased() == "reclaim list"{
                    title = NSLocalizedString("reclaim_list", comment: "").capitalized
                    return title
                }else if sectionNamesEcoupon[section].itemName.lowercased() == "lucky draw coupon list"{
                    return (self.sectionNamesEcoupon[section].itemName.capitalized)
                }
               //return (self.sectionNamesEcoupon[section].itemName.capitalized)
            }else {
                return ""
            }
        }
        else if tableView == tblViewTransactions{
            if self.sectionNames[section].itemName.lowercased() == "success list" && self.successTransactions.count > 0 || self.sectionNames[section].itemName.lowercased() == "claim list" && self.claimTransactions.count > 0 || self.sectionNames[section].itemName.lowercased() == "reclaim list" && self.reclaimTransactions.count > 0 {
                //return (self.sectionNames[section].itemName.capitalized)
                var title = ""
                if sectionNames[section].itemName.lowercased() == "success list"{
                    title = NSLocalizedString("success_list", comment: "").capitalized
                    return title
                }else if sectionNames[section].itemName.lowercased() == "claim list"{
                    title = NSLocalizedString("claim_list", comment: "").capitalized
                    return title
                }else if sectionNames[section].itemName.lowercased() == "reclaim list"{
                    title = NSLocalizedString("reclaim_list", comment: "").capitalized
                    return title
                }
            }else {
                return ""
            }
        }
        else if tableView == tblViewSeedTransactions{
            if self.sectionNamesSeed[section].itemName.lowercased() == "success list" && self.successSeedTransactions.count > 0 || self.sectionNamesSeed[section].itemName.lowercased() == "claim list" && self.claimSeedTransactions.count > 0 || self.sectionNamesSeed[section].itemName.lowercased() == "reclaim list" && self.reclaimSeedTransactions.count > 0 {
              // return (self.sectionNamesSeed[section].itemName.capitalized)
                var title = ""
                if sectionNamesSeed[section].itemName.lowercased() == "success list"{
                    title = NSLocalizedString("success_list", comment: "").capitalized
                    return title
                }else if sectionNamesSeed[section].itemName.lowercased() == "claim list"{
                    title = NSLocalizedString("claim_list", comment: "").capitalized
                    return title
                }else if sectionNamesSeed[section].itemName.lowercased() == "reclaim list"{
                    title = NSLocalizedString("reclaim_list", comment: "").capitalized
                    return title
                }
            }else {
                return ""
            }
        }
        else if tableView == tblViewseed2Transactions{
            if self.sectionNamesSeed2[section].itemName.lowercased() == "success list" && self.successSeed2Transactions.count > 0 || self.sectionNamesSeed2[section].itemName.lowercased() == "claim list" && self.claimSeed2Transactions.count > 0 || self.sectionNamesSeed2[section].itemName.lowercased() == "reclaim list" && self.reclaimSeed2Transactions.count > 0 {
               // return (self.sectionNamesSeed2[section].itemName.capitalized)
                var title = ""
                if sectionNamesSeed2[section].itemName.lowercased() == "success list"{
                    title = NSLocalizedString("success_list", comment: "").capitalized
                    return title
                }else if sectionNamesSeed2[section].itemName.lowercased() == "claim list"{
                    title = NSLocalizedString("claim_list", comment: "").capitalized
                    return title
                }else if sectionNamesSeed2[section].itemName.lowercased() == "reclaim list"{
                    title = NSLocalizedString("reclaim_list", comment: "").capitalized
                    return title
                }
            }else {
                return ""
            }
            
        }else if tableView == tblViewDSRTransactions{
           if self.sectionNamesDSR[section].itemName.lowercased() == "success list" && self.successDSRTransactions.count > 0 || self.sectionNamesDSR[section].itemName.lowercased() == "claim list" && self.claimDSRTransactions.count > 0 || self.sectionNamesDSR[section].itemName.lowercased() == "reclaim list" && self.reclaimDSRTransactions.count > 0 {
                //return (self.sectionNamesDSR[section].itemName.capitalized)
            var title = ""
            if sectionNamesDSR[section].itemName.lowercased() == "success list"{
                title = NSLocalizedString("success_list", comment: "").capitalized
                return title
            }else if sectionNamesDSR[section].itemName.lowercased() == "claim list"{
                title = NSLocalizedString("claim_list", comment: "").capitalized
                return title
            }else if sectionNamesDSR[section].itemName.lowercased() == "reclaim list"{
                title = NSLocalizedString("reclaim_list", comment: "").capitalized
                return title
            }
            }else {
                return ""
            }
        }
        else if tableView == tblViewGiftCouponTransactions{
            var title = ""
                title = "Gift Coupon"
                return title
        }
        else{
            return ""
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblViewEcouponTransactions {
            
            if self.sectionNamesEcoupon[section].itemName.lowercased() == "success list" && self.successTransactionsEcoupon.count > 0 || self.sectionNamesEcoupon[section].itemName.lowercased() == "claim list" && self.claimTransactionsEcoupon.count > 0 || self.sectionNamesEcoupon[section].itemName.lowercased() == "reclaim list" && self.reclaimTransactionsEcoupon.count > 0 || self.sectionNamesEcoupon[section].itemName.lowercased() == "lucky draw coupon list" && self.couponCodesList.count > 0{
                return 44.0;
            }else {
                return 0
            }
        }
        else if tableView == tblViewTransactions{
            if self.sectionNames[section].itemName.lowercased() == "success list" && self.successTransactions.count > 0 || self.sectionNames[section].itemName.lowercased() == "claim list" && self.claimTransactions.count > 0 || self.sectionNames[section].itemName.lowercased() == "reclaim list" && self.reclaimTransactions.count > 0 {
                return 44.0;
            }else {
                return 0
            }
        }
        else if tableView == tblViewSeedTransactions{
            if self.sectionNamesSeed[section].itemName.lowercased() == "success list" && self.successSeedTransactions.count > 0 || self.sectionNamesSeed[section].itemName.lowercased() == "claim list" && self.claimSeedTransactions.count > 0 || self.sectionNamesSeed[section].itemName.lowercased() == "reclaim list" && self.reclaimSeedTransactions.count > 0 {
                return 44.0;
            }else {
                return 0
            }
            
        }
        else if tableView == tblViewseed2Transactions{
            if self.sectionNamesSeed2[section].itemName.lowercased() == "success list" && self.successSeed2Transactions.count > 0 || self.sectionNamesSeed2[section].itemName.lowercased() == "claim list" && self.claimSeed2Transactions.count > 0 || self.sectionNamesSeed2[section].itemName.lowercased() == "reclaim list" && self.reclaimSeed2Transactions.count > 0 {
                return 44.0;
            }else {
                return 0
            }
        }else if tableView == tblViewDSRTransactions{
            if self.sectionNamesDSR[section].itemName.lowercased() == "success list" && self.successDSRTransactions.count > 0 || self.sectionNamesDSR[section].itemName.lowercased() == "claim list" && self.claimDSRTransactions.count > 0 || self.sectionNamesDSR[section].itemName.lowercased() == "reclaim list" && self.reclaimDSRTransactions.count > 0 {
                return 44.0;
            }else {
                return 0
            }
        }
        else if tableView == tblViewGiftCouponTransactions{
            return 0;
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0;
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //recast your view as a UITableViewHeaderFooterView
        if tableView == tblViewEcouponTransactions {
            if self.sectionNamesEcoupon[section].itemName.lowercased() == "success list" && self.successTransactionsEcoupon.count > 0 || self.sectionNamesEcoupon[section].itemName.lowercased() == "claim list" && self.claimTransactionsEcoupon.count > 0 || self.sectionNamesEcoupon[section].itemName.lowercased() == "reclaim list" && self.reclaimTransactionsEcoupon.count > 0 || self.sectionNamesEcoupon[section].itemName.lowercased() == "lucky draw coupon list" && self.couponCodesList.count > 0{
                let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
                header.frame = CGRect(x: 0, y: header.frame.origin.y + 5, width: header.frame.size.width, height: 40)
                header.contentView.backgroundColor = App_Theme_Blue_Color
                header.textLabel?.textColor = UIColor.white
                
                header.textLabel?.font = UIFont.systemFont(ofSize: 20.0)
                header.textLabel?.text = header.textLabel!.text!.capitalized
                header.textLabel?.isUserInteractionEnabled = false
                if let viewWithTag = self.view.viewWithTag(kHeaderSectionTagEcoupon + section) {
                    viewWithTag.removeFromSuperview()
                }
                let headerFrame = self.view.frame.size
                
                // header.contentView.addBorder(toSide: .Top, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: header.contentView.frame.size.height-1, height: 1.0)
                header.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: 50)
                // header.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: header.frame.size.width-1, yValue: 0, height: 50)
                self.totalClaimAmountEcoupon = 0
                for (i,j) in self.claimTransactionsEcoupon.enumerated() {
                    let amount = Double(self.claimTransactionsEcoupon[i].amount)
                    self.totalClaimAmountEcoupon = self.totalClaimAmountEcoupon  + amount!
                }
                let rupee = "\u{20B9} "
                
                
               /* self.theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 60, y: 5, width: 40, height: 40));
                if self.sectionNamesEcoupon[section].collapsed == true {
                    theImageView.image = UIImage(named: "downArrow")
                    
                }else {
                    theImageView.image = UIImage(named: "upArrow")
                }
                theImageView.tintColor = UIColor.orange
                theImageView.tag = kHeaderSectionTagEcoupon + section
                header.addSubview(theImageView)*/
                
                var headerSubTitle = UILabel()
                headerSubTitle = UILabel(frame: CGRect(x:
                    headerFrame.width - 120, y: 0, width: 100, height: 50));
                headerSubTitle.isUserInteractionEnabled = false
                headerSubTitle.text = String(format:"%@ %.2f", rupee, self.totalClaimAmountEcoupon)
                
                headerSubTitle.textColor = UIColor.white
                headerSubTitle.tag = kHeaderSectionTagEcoupon + section
                //headerSubTitle.tag = kHeaderSectionTag + section
                header.addSubview(headerSubTitle)
                
                if header.textLabel?.text?.lowercased() == "claim list" {
                    headerSubTitle.isHidden = false
                }else  {
                    headerSubTitle.isHidden = true
                }
                // make headers touchable
                
                header.tag = section
                let headerTapGesture = UITapGestureRecognizer()
                headerTapGesture.addTarget(self, action: #selector(RewardsViewController.sectionHeaderWasTouchedEcoupon))
                header.addGestureRecognizer(headerTapGesture)
            }
        }
        else if tableView == tblViewTransactions{
            if self.sectionNames[section].itemName.lowercased() == "success list" && self.successTransactions.count > 0 || self.sectionNames[section].itemName.lowercased() == "claim list" && self.claimTransactions.count > 0 || self.sectionNames[section].itemName.lowercased() == "reclaim list" && self.reclaimTransactions.count > 0 {
                let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
                header.frame = CGRect(x: 0, y: header.frame.origin.y  + 5, width: header.frame.size.width, height: 40)
                header.contentView.backgroundColor = App_Theme_Blue_Color
                header.textLabel?.textColor = UIColor.white
                
                header.textLabel?.font = UIFont.systemFont(ofSize: 20.0)
                header.textLabel?.text = header.textLabel!.text!.capitalized
                header.textLabel?.isUserInteractionEnabled = false
                if let viewWithTag = self.view.viewWithTag(kHeaderSectionTag + section) {
                    viewWithTag.removeFromSuperview()
                }
                let headerFrame = self.view.frame.size
                
                // header.contentView.addBorder(toSide: .Top, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: header.contentView.frame.size.height-1, height: 1.0)
                header.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: 50)
                // header.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: header.frame.size.width-1, yValue: 0, height: 50)
                self.totalClaimAmount = 0
                for (i,j) in self.claimTransactions.enumerated() {
                    let amount = Double(self.claimTransactions[i].amount)
                    self.totalClaimAmount = self.totalClaimAmount  + amount!
                }
                let rupee = "\u{20B9} "
                
               /*
                self.theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 60, y: 5, width: 40, height: 40));
                if self.sectionNames[section].collapsed == true {
                    theImageView.image = UIImage(named: "downArrow")
                    
                }else {
                    theImageView.image = UIImage(named: "upArrow")
                }
                theImageView.tintColor = UIColor.orange
                theImageView.tag = kHeaderSectionTag + section
                header.addSubview(theImageView)*/
                
                var headerSubTitle = UILabel()
                headerSubTitle = UILabel(frame: CGRect(x:
                    headerFrame.width - 120, y: 0, width: 100, height: 50));
                headerSubTitle.isUserInteractionEnabled = false
                headerSubTitle.text = String(format:"%@ %.2f", rupee, self.totalClaimAmount)
                
                headerSubTitle.textColor = UIColor.white
                headerSubTitle.tag = kHeaderSectionTag + section
                //headerSubTitle.tag = kHeaderSectionTag + section
                header.addSubview(headerSubTitle)
                
                if header.textLabel?.text?.lowercased() == "claim list" {
                    headerSubTitle.isHidden = false
                }else  {
                    headerSubTitle.isHidden = true
                }
                // make headers touchable
                
                header.tag = section
                let headerTapGesture = UITapGestureRecognizer()
                headerTapGesture.addTarget(self, action: #selector(RewardsViewController.sectionHeaderWasTouched(_:)))
                header.addGestureRecognizer(headerTapGesture)
            }
        }
        else if tableView == tblViewSeedTransactions{
            if self.sectionNamesSeed[section].itemName.lowercased() == "success list" && self.successSeedTransactions.count > 0 || self.sectionNamesSeed[section].itemName.lowercased() == "claim list" && self.claimSeedTransactions.count > 0 || self.sectionNamesSeed[section].itemName.lowercased() == "reclaim list" && self.reclaimSeedTransactions.count > 0 {
                let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
                header.frame = CGRect(x: 0, y: header.frame.origin.y  + 5, width: header.frame.size.width, height: 40)
                header.contentView.backgroundColor = App_Theme_Blue_Color
                header.textLabel?.textColor = UIColor.white
                
                header.textLabel?.font = UIFont.systemFont(ofSize: 20.0)
                header.textLabel?.text = header.textLabel!.text!.capitalized
                header.textLabel?.isUserInteractionEnabled = false
                if let viewWithTag = self.view.viewWithTag(kHeaderSectionTagSeed + section) {
                    viewWithTag.removeFromSuperview()
                }
                let headerFrame = self.view.frame.size
                
                // header.contentView.addBorder(toSide: .Top, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: header.contentView.frame.size.height-1, height: 1.0)
                header.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: 50)
                // header.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: header.frame.size.width-1, yValue: 0, height: 50)
                self.totalClaimAmountSeed = 0
                for (i,j) in self.claimSeedTransactions.enumerated() {
                    let amount = Double(self.claimSeedTransactions[i].amount)
                    self.totalClaimAmountSeed = self.totalClaimAmountSeed  + (amount ?? 0)
                }
                let rupee = "\u{20B9} "
                let truncatedAmount = Int(round(totalClaimAmountSeed))
                
                
               /* self.theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 60, y: 5, width: 40, height: 40));
                if self.sectionNamesSeed[section].collapsed == true {
                    theImageView.image = UIImage(named: "downArrow")
                    
                }else {
                    theImageView.image = UIImage(named: "upArrow")
                }
                theImageView.tintColor = UIColor.orange
                theImageView.tag = kHeaderSectionTagSeed + section
                header.addSubview(theImageView)*/
                
                var headerSubTitle = UILabel()
                headerSubTitle = UILabel(frame: CGRect(x:
                    headerFrame.width - 120, y: 0, width: 100, height: 50));
                headerSubTitle.isUserInteractionEnabled = false
                //headerSubTitle.text = String(format:"%@ %.2f", rupee, self.totalClaimAmountSeed)
                headerSubTitle.text = "\(rupee)\(truncatedAmount)"
                
                headerSubTitle.textColor = UIColor.white
                headerSubTitle.tag = kHeaderSectionTagSeed + section
                //headerSubTitle.tag = kHeaderSectionTag + section
                header.addSubview(headerSubTitle)
                
                if header.textLabel?.text?.lowercased() == "claim list" {
                    headerSubTitle.isHidden = false
                }else  {
                    headerSubTitle.isHidden = true
                }
                // make headers touchable
                
                header.tag = section
                let headerTapGesture = UITapGestureRecognizer()
                headerTapGesture.addTarget(self, action: #selector(RewardsViewController.sectionHeaderWasTouchedSeed(_:)))
                header.addGestureRecognizer(headerTapGesture)
            }
            
        }
        else if tableView == tblViewseed2Transactions{
            if self.sectionNamesSeed2[section].itemName.lowercased() == "success list" && self.successSeed2Transactions.count > 0 || self.sectionNamesSeed2[section].itemName.lowercased() == "claim list" && self.claimSeed2Transactions.count > 0 || self.sectionNamesSeed2[section].itemName.lowercased() == "reclaim list" && self.reclaimSeed2Transactions.count > 0 {
                let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
                header.frame = CGRect(x: 0, y: header.frame.origin.y  + 5, width: header.frame.size.width, height: 40)
                header.contentView.backgroundColor = App_Theme_Blue_Color
                header.textLabel?.textColor = UIColor.white
                
                header.textLabel?.font = UIFont.systemFont(ofSize: 20.0)
                header.textLabel?.text = header.textLabel!.text!.capitalized
                header.textLabel?.isUserInteractionEnabled = false
                if let viewWithTag = self.view.viewWithTag(kHeaderSectionTagSeed2 + section) {
                    viewWithTag.removeFromSuperview()
                }
                let headerFrame = self.view.frame.size
                
                // header.contentView.addBorder(toSide: .Top, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: header.contentView.frame.size.height-1, height: 1.0)
                header.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: 50)
                // header.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: header.frame.size.width-1, yValue: 0, height: 50)
                self.totalClaimAmountSeed2 = 0
                for (i,j) in self.claimSeed2Transactions.enumerated() {
                    let amount = Double(self.claimSeed2Transactions[i].amount)
                    self.totalClaimAmountSeed2 = self.totalClaimAmountSeed2  + amount!
                }
                let rupee = "\u{20B9} "
                let truncatedAmount = Int(round(totalClaimAmountSeed2))
                
                
                /*self.theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 60, y: 5, width: 40, height: 40));
                if self.sectionNamesSeed2[section].collapsed == true {
                    theImageView.image = UIImage(named: "downArrow")
                    
                }else {
                    theImageView.image = UIImage(named: "upArrow")
                }
                theImageView.tintColor = UIColor.orange
                theImageView.tag = kHeaderSectionTagSeed2 + section
                header.addSubview(theImageView)*/
                
                var headerSubTitle = UILabel()
                headerSubTitle = UILabel(frame: CGRect(x:
                    headerFrame.width - 120, y: 0, width: 100, height: 50));
                headerSubTitle.isUserInteractionEnabled = false
                //headerSubTitle.text = String(format:"%@ %.2f", rupee, self.totalClaimAmountSeed)
                headerSubTitle.text = "\(rupee)\(truncatedAmount)"
                
                headerSubTitle.textColor = UIColor.white
                headerSubTitle.tag = kHeaderSectionTagSeed2 + section
                //headerSubTitle.tag = kHeaderSectionTag + section
                header.addSubview(headerSubTitle)
                
                if header.textLabel?.text?.lowercased() == "claim list" {
                    headerSubTitle.isHidden = false
                }else  {
                    headerSubTitle.isHidden = true
                }
                // make headers touchable
                
                header.tag = section
                let headerTapGesture = UITapGestureRecognizer()
                headerTapGesture.addTarget(self, action: #selector(RewardsViewController.sectionHeaderWasTouchedSeed2))
                header.addGestureRecognizer(headerTapGesture)
            }
        }
        else if tableView == tblViewDSRTransactions{
            if self.sectionNamesDSR[section].itemName.lowercased() == "success list" && self.successDSRTransactions.count > 0 || self.sectionNamesDSR[section].itemName.lowercased() == "claim list" && self.claimDSRTransactions.count > 0 || self.sectionNamesDSR[section].itemName.lowercased() == "reclaim list" && self.reclaimDSRTransactions.count > 0 {
                let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
                header.frame = CGRect(x: 0, y: header.frame.origin.y  + 5, width: header.frame.size.width, height: 40)
                header.contentView.backgroundColor = App_Theme_Blue_Color
                header.textLabel?.textColor = UIColor.white
                
                header.textLabel?.font = UIFont.systemFont(ofSize: 20.0)
                header.textLabel?.text = header.textLabel!.text!.capitalized
                header.textLabel?.isUserInteractionEnabled = false
                if let viewWithTag = self.view.viewWithTag(KHeaderSectionTagDSR + section) {
                    viewWithTag.removeFromSuperview()
                }
                let headerFrame = self.view.frame.size
                
                // header.contentView.addBorder(toSide: .Top, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: header.contentView.frame.size.height-1, height: 1.0)
                header.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: 50)
                // header.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: header.frame.size.width-1, yValue: 0, height: 50)
                self.totalClaimAmountDSR = 0
                for (i,j) in self.claimDSRTransactions.enumerated() {
                    let amount = Double(self.claimDSRTransactions[i].amount)
                    self.totalClaimAmountDSR = self.totalClaimAmountDSR  + amount!
                }
                let rupee = "\u{20B9} "
                let truncatedAmount = Int(round(totalClaimAmountDSR))
                
                
                /*self.theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 60, y: 5, width: 40, height: 40));
                if self.sectionNamesDSR[section].collapsed == true {
                    theImageView.image = UIImage(named: "downArrow")
                    
                }else {
                    theImageView.image = UIImage(named: "upArrow")
                }
                theImageView.tintColor = UIColor.orange
                theImageView.tag = KHeaderSectionTagDSR + section
                header.addSubview(theImageView)*/
                
                var headerSubTitle = UILabel()
                headerSubTitle = UILabel(frame: CGRect(x:
                    headerFrame.width - 120, y: 0, width: 100, height: 50));
                headerSubTitle.isUserInteractionEnabled = false
                //headerSubTitle.text = String(format:"%@ %.2f", rupee, self.totalClaimAmountSeed)
                headerSubTitle.text = "\(rupee)\(truncatedAmount)"
                
                headerSubTitle.textColor = UIColor.white
                headerSubTitle.tag = KHeaderSectionTagDSR + section
                //headerSubTitle.tag = kHeaderSectionTag + section
                header.addSubview(headerSubTitle)
                
                if header.textLabel?.text?.lowercased() == "claim list" {
                    headerSubTitle.isHidden = false
                }else  {
                    headerSubTitle.isHidden = true
                }
                // make headers touchable
                
                header.tag = section
                let headerTapGesture = UITapGestureRecognizer()
                headerTapGesture.addTarget(self, action: #selector(RewardsViewController.sectionHeaderWasTouchedDSR))
                header.addGestureRecognizer(headerTapGesture)
            }
        }
        
        else if tableView == tblViewGiftCouponTransactions{
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblViewEcouponTransactions {
             if sectionNamesEcoupon[indexPath.section].itemName.lowercased() == "lucky draw coupon list" && self.couponCodesList.count > 0   {
                return 75
            }else {
                return 175
            }
        }
        else{
            return 175.0
        }
//            if sectionNames[indexPath.section].itemName.lowercased() == "claim list" && self.claimTransactions.count > 0  {
//                let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
                
//            return 175.0
//
//
////            }
//        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblViewEcouponTransactions {
            if sectionNamesEcoupon [indexPath.section].itemName.lowercased() == "claim list" && self.claimTransactionsEcoupon.count > 0 {
                let lastRowIndex = tableView.numberOfRows(inSection: indexPath.section)
                if indexPath.row == lastRowIndex-1  {
                    // let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                    
                    let cell1 =  tblViewEcouponTransactions.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! TransactionDetailsTableViewCell
                    cell1.frame = CGRect(x: tableView.frame.origin.x - 5  , y: tableView.frame.origin.y, width: tableView.frame.size.width, height: 135 )
                    let rupee = "\u{20B9} "
                    var totalAmount = 0.0
                    
                    for (i,j) in self.claimTransactionsEcoupon.enumerated() {
                        let amount = Double(self.claimTransactionsEcoupon[i].amount)
                        totalAmount = totalAmount  + (amount ?? 0.0)
                    }
                    
                    if self.claimTransactionsEcoupon[indexPath.row].productName != nil{
                    cell1.lblAmountKey.text = NSLocalizedString("product_name_label", comment: "")
                    cell1.lblAmount.text = ": " +  self.claimTransactionsEcoupon[indexPath.row].productName
                    }else{
                        cell1.lblAmountKey.isHidden = true
                        cell1.lblAmount.isHidden = true
                    }
                    
                    cell1.lblRefIDKey.text = NSLocalizedString("Amount", comment:"")
                    cell1.lblDateKey.text = NSLocalizedString("lbl_date", comment: "")
                    cell1.lblStatusKey.text = NSLocalizedString("serial_no", comment: "")
                    
    
                    
                    
        
                    cell1.lblRefIDKey.text = NSLocalizedString("Amount", comment:"")
                    cell1.lblDateKey.text = NSLocalizedString("lbl_date", comment: "")
                    cell1.lblStatusKey.text = NSLocalizedString("serial_no", comment: "")
                    
                    cell1.btnMoreDetails.isHidden = true
                    //                cell.lblDateKey.isHidden = true
                    // cell.lblCreatedOn.isHidden = true
                    cell1.stackViewTopConstraint.constant = 0
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                    
                    let dateFormatterPrint = DateFormatter()
                    dateFormatterPrint.dateFormat = "dd-MMM-yyyy HH:mm:ss"
                    
                    if self.claimTransactionsEcoupon[indexPath.row].createdOn != nil && self.claimTransactionsEcoupon[indexPath.row].createdOn != ""{
                        let date = dateFormatter.date(from: self.claimTransactionsEcoupon[indexPath.row].createdOn)!
                        cell1.lblCreatedOn.text =  ": " + dateFormatterPrint.string(from: date) as String  //": " + self.claimTransactions[indexPath.row].referenceId
                    }else{
                        cell1.lblCreatedOn.text = ""
                    }
                    
                    cell1.lblStatus.text = ": " + self.claimTransactionsEcoupon[indexPath.row].prodSerialNumber
                    
                    let amount = Double(self.claimTransactionsEcoupon[indexPath.row].amount)
                    cell1.lblReferenceID.text =  ": " + String(format:"%@%.2f", rupee, amount ?? 0.0) //self.claimTransactions[indexPath.row].amount
                    //let strclaim = String(format:"Claim - %@%.2f ", rupee, totalAmount)
                    let claim = NSLocalizedString("Claim", comment: "")
                    let strclaim = String(format:"\(claim) - %@%.2f ", rupee, totalAmount)
                        cell1.btnReclaim.setTitle(strclaim, for: UIControlState.normal)
                        cell1.btnReclaim.isUserInteractionEnabled = false
                         cell1.btnReclaim.isHidden = false
                         cell1.reclaimHgtConstraint.constant = 30
                    
                    cell1.backgroundColor = App_Theme_Green_Color
                    cell1.tag =  indexPath.row
                    cell1.contentView.addBorder(toSide: .Bottom, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: cell1.contentView.frame.size.height-1, height: 1.0)
                    cell1.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: cell1.contentView.frame.size.height)
                    cell1.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: cell1.contentView.frame.size.height-1, yValue: 0, height: cell1.contentView.frame.size.height)
                    
                    let headerTapGesture = UITapGestureRecognizer()
                    headerTapGesture.view?.tag = indexPath.row
                    headerTapGesture.addTarget(self, action: #selector(RewardsViewController.NavigationToPaymentSelectionEcoupon))
                    cell1.addGestureRecognizer(headerTapGesture)
                    return cell1
                }else {
                    let cell =  tblViewEcouponTransactions.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! TransactionDetailsTableViewCell
                    let rupee = "\u{20B9} "
                    
                    if self.claimTransactionsEcoupon[indexPath.row].productName != nil{
                        cell.lblAmountKey.text = NSLocalizedString("product_name_label", comment: "")
                        cell.lblAmount.text = ": " +  self.claimTransactionsEcoupon[indexPath.row].productName
                    }else{
                        cell.lblAmountKey.isHidden = true
                        cell.lblAmount.isHidden = true
                    }
                    
                    
                    cell.lblRefIDKey.text = NSLocalizedString("Amount", comment:"")
                    cell.lblDateKey.text = NSLocalizedString("lbl_date", comment: "")
                    cell.lblStatusKey.text = NSLocalizedString("serial_no", comment: "")
                    
                    cell.btnMoreDetails.isHidden = true
                    //                cell.lblDateKey.isHidden = true
                    // cell.lblCreatedOn.isHidden = true
                    cell.stackViewTopConstraint.constant = 0
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                    
                    let dateFormatterPrint = DateFormatter()
                    dateFormatterPrint.dateFormat = "dd-MMM-yyyy HH:mm:ss"
                    
                    if self.claimTransactionsEcoupon[indexPath.row].createdOn != "" && self.claimTransactionsEcoupon[indexPath.row].createdOn != nil{
                        let date = dateFormatter.date(from: self.claimTransactionsEcoupon[indexPath.row].createdOn)!
                        cell.lblCreatedOn.text =  ": " + dateFormatterPrint.string(from: date) as String  //": " + self.claimTransactions[indexPath.row].referenceId
                    }else{
                        cell.lblCreatedOn.text = ""
                    }
                    
                    cell.lblStatus.text = ": " + self.claimTransactionsEcoupon[indexPath.row].prodSerialNumber
                    
                    let amount = Double(self.claimTransactionsEcoupon[indexPath.row].amount)
                    cell.lblReferenceID.text =  ": " + String(format:"%@%.2f", rupee, amount ?? 0.0) //self.claimTransactions[indexPath.row].amount
                
          
                                           cell.btnReclaim.isHidden = true
                                           cell.reclaimHgtConstraint.constant = 0
              
                    
                    
                    if sectionNamesEcoupon[indexPath.section].collapsed == false {
                        cell.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                        cell.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                    }else {
                        cell.contentView.addBorder(toSide: .Left, withColor: UIColor.clear.cgColor, andThickness: 0.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                        cell.contentView.addBorder(toSide: .Right, withColor: UIColor.clear.cgColor, andThickness: 0.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                    }
                    return cell
                }
            }else if sectionNamesEcoupon[indexPath.section].itemName.lowercased() == "success list" {
                let cell =  tblViewEcouponTransactions.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! TransactionDetailsTableViewCell
                cell.lblDateKey.text = NSLocalizedString("lbl_date", comment: "")
                cell.lblRefIDKey.text = NSLocalizedString("referenceId", comment: "")
                cell.lblStatusKey.text = NSLocalizedString("status", comment: "")
                cell.lblAmountKey.text = NSLocalizedString("Amount", comment:"")
                let rupee = "\u{20B9} "
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "dd-MMM-yyyy HH:mm:ss"
                
                if self.successTransactionsEcoupon[indexPath.row].createdOn != ""{
                    let date = dateFormatter.date(from: self.successTransactionsEcoupon[indexPath.row].createdOn)!
                    cell.lblCreatedOn.text = ": " + dateFormatterPrint.string(from: date) as String
                }else{
                    cell.lblCreatedOn.text = ""
                }
                
                let amount  = Double(self.successTransactionsEcoupon[indexPath.row].amount)
                cell.lblAmount.text = ": " +  String(format:"%@%.2f", rupee, amount ?? 0.0)
                
                cell.lblStatus.text = ": " + self.successTransactionsEcoupon[indexPath.row].status
                cell.lblReferenceID.text = ": " + self.successTransactionsEcoupon[indexPath.row].referenceId
                cell.stackViewTopConstraint.constant = 0
                cell.btnReclaim.isHidden = true
                cell.reclaimHgtConstraint.constant = 0
                cell.btnMoreDetails.isHidden = true
                
                if self.successTransactionsEcoupon[indexPath.row].showView == true{
                    cell.stackViewTopConstraint.constant = 30
                    cell.btnMoreDetails.isHidden = false
                    cell.btnMoreDetails.tag = indexPath.row
                    cell.btnMoreDetails.setImage(UIImage(named: "moreInfo"), for: .normal)
                    cell.btnMoreDetails.addTarget(self, action: #selector(getMoreDetailsOfTransactionEcoupon(_:)), for: .touchUpInside)
                }
                
                if sectionNamesEcoupon[indexPath.section].collapsed == false {
                    cell.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                    cell.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                }
                else {
                    cell.contentView.addBorder(toSide: .Left, withColor: UIColor.clear.cgColor, andThickness: 0.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                    cell.contentView.addBorder(toSide: .Right, withColor: UIColor.clear.cgColor, andThickness: 0.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                }
                return cell
            }else if sectionNamesEcoupon[indexPath.section].itemName.lowercased() == "lucky draw coupon list" {
                let cell =  tblViewEcouponTransactions.dequeueReusableCell(withIdentifier: "CouponTableViewCell", for: indexPath) as! CouponTableViewCell
                
                cell.lblCouponCode.text = " Coupon Code : " + self.couponCodesList[indexPath.row].ecouponCode
                
                if self.couponCodesList[indexPath.row].labelOne != ""  && self.couponCodesList[indexPath.row].valueOne != ""
                {
                cell.lblProgram.text = self.couponCodesList[indexPath.row].labelOne +  " : " + self.couponCodesList[indexPath.row].valueOne
                    cell.lblProgram.isHidden = false
                }else{
                    cell.lblProgram.isHidden = true
                }
                
                if self.couponCodesList[indexPath.row].labelOne != ""  && self.couponCodesList[indexPath.row].valueOne != ""
                {
                    cell.lblProgram2.text = self.couponCodesList[indexPath.row].labelTwo +  " : " + self.couponCodesList[indexPath.row].valueTwo
                    cell.lblProgram2.isHidden = false
                }else{
                    cell.lblProgram2.isHidden = true
                }
                
                if self.couponCodesList[indexPath.row].labelTwo != ""  && self.couponCodesList[indexPath.row].labelOne != ""
                {
                    cell.lblProgram2.text = self.couponCodesList[indexPath.row].labelTwo +  " : " + self.couponCodesList[indexPath.row].valueTwo
                    cell.lblProgram2.isHidden = false
                }else{
                    cell.lblProgram2.isHidden = true
                }
                
                
                if sectionNamesEcoupon[indexPath.section].collapsed == false {
                    cell.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                    cell.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                }else {
                    cell.contentView.addBorder(toSide: .Left, withColor: UIColor.clear.cgColor, andThickness: 0.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                    cell.contentView.addBorder(toSide: .Right, withColor: UIColor.clear.cgColor, andThickness: 0.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                }
                return cell
            }else {
                let cell =  tblViewEcouponTransactions.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! TransactionDetailsTableViewCell
                cell.lblDateKey.text = NSLocalizedString("lbl_date", comment: "")
                cell.lblRefIDKey.text = NSLocalizedString("referenceId", comment: "")
                cell.lblStatusKey.text = NSLocalizedString("status", comment: "")
                cell.lblAmountKey.text = NSLocalizedString("Amount", comment:"")
                let rupee = "\u{20B9} "
                print(rupee)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "dd-MMM-yyyy HH:mm:ss"
                
                if self.reclaimTransactionsEcoupon[indexPath.row].createdOn != ""{
                    let date = dateFormatter.date(from: self.reclaimTransactionsEcoupon[indexPath.row].createdOn)!
                    cell.lblCreatedOn.text = ": " + dateFormatterPrint.string(from: date) as String
                }else{
                    cell.lblCreatedOn.text = ""
                }
                
                let amount  = Double(self.reclaimTransactionsEcoupon[indexPath.row].amount)
                cell.lblAmount.text = ": " +  String(format:"%@%.2f", rupee, amount ?? 0.0)
                
                cell.lblStatus.text = ": " + self.reclaimTransactionsEcoupon[indexPath.row].status
                cell.lblReferenceID.text = ": " + self.reclaimTransactionsEcoupon[indexPath.row].referenceId
                
                cell.btnReclaim.isHidden = false
                cell.btnReclaim.setTitle(self.reclaimTransactionsEcoupon[indexPath.row].buttonText, for: .normal)
                cell.reclaimHgtConstraint.constant = 35
                cell.btnReclaim.tag = indexPath.row
                cell.btnMoreDetails.isHidden = true
                cell.stackViewTopConstraint.constant = 0
                
                if cell.btnReclaim.titleLabel?.text?.lowercased() == "re claim"{
                    cell.btnReclaim.addTarget(self, action: #selector(reClaimAmountForTransactionEcoupon(_:)), for: .touchUpInside)
                }
                cell.btnReclaim.setTitle(NSLocalizedString("Reclaim", comment: ""), for: .normal)
                cell.btnReclaim.addTarget(self, action: #selector(reClaimAmountForTransactionEcoupon(_:)), for: .touchUpInside)
                
                if sectionNamesEcoupon [indexPath.section].collapsed == false {
                    cell.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                    cell.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                }else {
                    cell.contentView.addBorder(toSide: .Left, withColor: UIColor.clear.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                    cell.contentView.addBorder(toSide: .Right, withColor: UIColor.clear.cgColor, andThickness: 1.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                }
                return cell
            }
        }
            
            //tblViewTransactions table
        else if tableView == tblViewTransactions{
            if sectionNames[indexPath.section].itemName.lowercased() == "claim list" && self.claimTransactions.count > 0 {
                let lastRowIndex = tableView.numberOfRows(inSection: indexPath.section)
                
                if indexPath.row == lastRowIndex - 1 {
                    
                    let cell1 =  tblViewTransactions.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! TransactionDetailsTableViewCell
                    var totalAmount = 0.0
                    
                    for (i,j) in self.claimTransactions.enumerated() {
                        let amount = Double(self.claimTransactions[i].amount)
                        totalAmount = totalAmount  + (amount ?? 0.0)
                    }
                    
                    
                    let rupee = "\u{20B9} "
                    
                    if self.claimTransactions[indexPath.row].productName != nil{
                        cell1.lblAmountKey.text = NSLocalizedString("product_name_label", comment: "") //"Product Name "
                        cell1.lblAmount.text = ": " +  self.claimTransactions[indexPath.row].productName
                    }else{
                        cell1.lblAmountKey.isHidden = true
                        cell1.lblAmount.isHidden = true
                    }
                    
                    cell1.lblRefIDKey.text = NSLocalizedString("Amount", comment:"")//"Amount "
                    cell1.lblDateKey.text = NSLocalizedString("lbl_date", comment: "")//"Date "
                    cell1.lblStatusKey.text = NSLocalizedString("serial_no", comment: "")//"Serial No "
                    
                    cell1.btnMoreDetails.isHidden = true
                    //                cell.lblDateKey.isHidden = true
                    // cell.lblCreatedOn.isHidden = true
                    cell1.stackViewTopConstraint.constant = 0
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                    
                    let dateFormatterPrint = DateFormatter()
                    dateFormatterPrint.dateFormat = "dd-MMM-yyyy HH:mm:ss"
                    
                    if self.claimTransactions[indexPath.row].createdOn != ""{
                        let date = dateFormatter.date(from: self.claimTransactions[indexPath.row].createdOn)!
                        cell1.lblCreatedOn.text =  ": " + dateFormatterPrint.string(from: date) as String  //": " + self.claimTransactions[indexPath.row].referenceId
                    }else{
                        cell1.lblCreatedOn.text = ""
                    }
                    //let strclaim = String(format:"Claim - %@%.2f", rupee, totalAmount)
                    let claim = NSLocalizedString("Claim", comment: "")
                    let strclaim = String(format:"\(claim) - %@%.2f", rupee, totalAmount)
                    cell1.btnReclaim.setTitle(strclaim, for: UIControlState.normal)
                    cell1.btnReclaim.isUserInteractionEnabled = false
                   
                    
                    cell1.lblStatus.text = ": " + self.claimTransactions[indexPath.row].prodSerialNumber
                    
                    let amount = Double(self.claimTransactions[indexPath.row].amount)
                    cell1.lblReferenceID.text =  ": " + String(format:"%@%.2f", rupee, amount ?? 0.0) //self.claimTransactions[indexPath.row].amount
                 
                        cell1.btnReclaim.isHidden = false
                        cell1.reclaimHgtConstraint.constant = 35
                    
                    
                    //                    cell1.textLabel?.text = String(format:"Claim - %@%.2f", rupee, totalAmount)
                    //                    cell1.textLabel?.textAlignment = .center
                    //                    cell1.textLabel?.textColor = UIColor.white
                    cell1.backgroundColor = App_Theme_Green_Color
                    cell1.tag =  indexPath.row
                    cell1.contentView.addBorder(toSide: .Bottom, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: cell1.contentView.frame.size.height-1, height: 1.0)
                    cell1.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: cell1.contentView.frame.size.height)
                    cell1.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: cell1.contentView.frame.size.height-1, yValue: 0, height: cell1.contentView.frame.size.height)
                    
                    let headerTapGesture = UITapGestureRecognizer()
                    headerTapGesture.view?.tag = indexPath.row
                    headerTapGesture.addTarget(self, action: #selector(RewardsViewController.NavigationToPaymentSelection))
                    cell1.addGestureRecognizer(headerTapGesture)
                    return cell1
                }else {
                    let cell =  tblViewTransactions.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! TransactionDetailsTableViewCell
                    let rupee = "\u{20B9} "
                    
                    if self.claimTransactions[indexPath.row].productName != nil{
                        cell.lblAmountKey.text = NSLocalizedString("product_name_label", comment: "")
                        cell.lblAmount.text = ": " +  self.claimTransactions[indexPath.row].productName
                    }else{
                        cell.lblAmountKey.isHidden = true
                        cell.lblAmount.isHidden = true
                    }
                    
                    
                    cell.lblRefIDKey.text = NSLocalizedString("Amount", comment:"")
                    cell.lblDateKey.text = NSLocalizedString("lbl_date", comment: "")
                    cell.lblStatusKey.text = NSLocalizedString("serial_no", comment: "")
                    
                    cell.btnMoreDetails.isHidden = true
                    //                cell.lblDateKey.isHidden = true
                    // cell.lblCreatedOn.isHidden = true
                    cell.stackViewTopConstraint.constant = 0
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                    
                    let dateFormatterPrint = DateFormatter()
                    dateFormatterPrint.dateFormat = "dd-MMM-yyyy HH:mm:ss"
                    
                    if self.claimTransactions[indexPath.row].createdOn != ""{
                    let date = dateFormatter.date(from: self.claimTransactions[indexPath.row].createdOn)!
                    cell.lblCreatedOn.text =  ": " + dateFormatterPrint.string(from: date) as String  //": " + self.claimTransactions[indexPath.row].referenceId
                    }else{
                        cell.lblCreatedOn.text = ""
                    }
                    cell.lblStatus.text = ": " + self.claimTransactions[indexPath.row].prodSerialNumber
                    
                    let amount = Double(self.claimTransactions[indexPath.row].amount)
                    cell.lblReferenceID.text =  ": " + String(format:"%@%.2f", rupee, amount ?? 0.0) //self.claimTransactions[indexPath.row].amount
                    
                    cell.btnReclaim.isHidden = true
                    cell.reclaimHgtConstraint.constant = 0
                    
                    if sectionNames[indexPath.section].collapsed == false {
                        cell.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                        cell.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                    }else {
                        cell.contentView.addBorder(toSide: .Left, withColor: UIColor.clear.cgColor, andThickness: 0.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                        cell.contentView.addBorder(toSide: .Right, withColor: UIColor.clear.cgColor, andThickness: 0.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                    }
                    return cell
                }
            }else if sectionNames[indexPath.section].itemName.lowercased() == "success list" {
                let cell =  tblViewTransactions.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! TransactionDetailsTableViewCell
                cell.lblDateKey.text = NSLocalizedString("lbl_date", comment: "")//"Date "
                cell.lblRefIDKey.text = NSLocalizedString("referenceId", comment: "")//"Reference Id "
                cell.lblStatusKey.text = NSLocalizedString("status", comment: "")//"Status"
                cell.lblAmountKey.text = NSLocalizedString("Amount", comment:"")//"Amount "
                let rupee = "\u{20B9} "
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "dd-MMM-yyyy HH:mm:ss"
                
                if self.successTransactions[indexPath.row].createdOn != ""{
                    let date = dateFormatter.date(from: self.successTransactions[indexPath.row].createdOn)!
                    cell.lblCreatedOn.text = ": " + dateFormatterPrint.string(from: date) as String
                }else{
                    cell.lblCreatedOn.text = ""
                }
               
                let amount  = Double(self.successTransactions[indexPath.row].amount)
                cell.lblAmount.text = ": " +  String(format:"%@%.2f", rupee, amount ?? 0.0)
                
                cell.lblStatus.text = ": " + self.successTransactions[indexPath.row].status
                cell.lblReferenceID.text = ": " + self.successTransactions[indexPath.row].referenceId
                cell.stackViewTopConstraint.constant = 0
                cell.btnReclaim.isHidden = true
                cell.reclaimHgtConstraint.constant = 0
                cell.btnMoreDetails.isHidden = true
                
                if self.successTransactions[indexPath.row].showView == true{
                    cell.stackViewTopConstraint.constant = 30
                    cell.btnMoreDetails.isHidden = false
                    cell.btnMoreDetails.tag = indexPath.row
                    cell.btnMoreDetails.setImage(UIImage(named: "moreInfo"), for: .normal)
                    cell.btnMoreDetails.addTarget(self, action: #selector(getMoreDetailsOfTransaction(_:)), for: .touchUpInside)
                }
                
                if sectionNames[indexPath.section].collapsed == false {
                    cell.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                    cell.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                }
                else {
                    cell.contentView.addBorder(toSide: .Left, withColor: UIColor.clear.cgColor, andThickness: 0.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                    cell.contentView.addBorder(toSide: .Right, withColor: UIColor.clear.cgColor, andThickness: 0.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                }
                return cell
            }
            else {
                let cell =  tblViewTransactions.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! TransactionDetailsTableViewCell
                cell.lblDateKey.text = NSLocalizedString("lbl_date", comment: "")//"Date "
                cell.lblRefIDKey.text = NSLocalizedString("referenceId", comment: "")//"Reference Id "
                cell.lblStatusKey.text = NSLocalizedString("status", comment: "")//"Status"
                cell.lblAmountKey.text = NSLocalizedString("Amount", comment:"")//"Amount "
                let rupee = "\u{20B9} "
                print(rupee)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "dd-MMM-yyyy HH:mm:ss"
                
                if self.reclaimTransactions[indexPath.row].createdOn != ""{
                    let date = dateFormatter.date(from: self.reclaimTransactions[indexPath.row].createdOn)!
                    cell.lblCreatedOn.text = ": " + dateFormatterPrint.string(from: date) as String
                }else{
                    cell.lblCreatedOn.text = ""
                }
                
                let amount  = Double(self.reclaimTransactions[indexPath.row].amount)
                cell.lblAmount.text = ": " +  String(format:"%@%.2f", rupee, amount ?? 0.0)
                
                cell.lblStatus.text = ": " + self.reclaimTransactions[indexPath.row].status
                cell.lblReferenceID.text = ": " + self.reclaimTransactions[indexPath.row].referenceId
                
                cell.btnReclaim.isHidden = false
                cell.btnReclaim.setTitle(self.reclaimTransactions[indexPath.row].buttonText, for: .normal)
                cell.reclaimHgtConstraint.constant = 35
                cell.btnReclaim.tag = indexPath.row
                cell.btnMoreDetails.isHidden = true
                cell.stackViewTopConstraint.constant = 0
                cell.btnReclaim.tag = indexPath.row
                if cell.btnReclaim.titleLabel?.text?.lowercased() == "re claim"{
                    cell.btnReclaim.addTarget(self, action: #selector(reClaimAmountForTransaction(_:)), for: .touchUpInside)
                }
                cell.btnReclaim.setTitle(NSLocalizedString("Reclaim", comment: ""), for: .normal)
                cell.btnReclaim.addTarget(self, action: #selector(reClaimAmountForTransaction(_:)), for: .touchUpInside)
                
                if sectionNames[indexPath.section].collapsed == false {
                    cell.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                    cell.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                }else {
                    cell.contentView.addBorder(toSide: .Left, withColor: UIColor.clear.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                    cell.contentView.addBorder(toSide: .Right, withColor: UIColor.clear.cgColor, andThickness: 1.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                }
                return cell
            }
        }
        else if tableView == tblViewSeedTransactions{
            if sectionNamesSeed[indexPath.section].itemName.lowercased() == "claim list" && self.claimSeedTransactions.count > 0 {
                let lastRowIndex = tableView.numberOfRows(inSection: indexPath.section)
                
                if indexPath.row == lastRowIndex - 1 {
                    
                    let cell1 =  tblViewSeedTransactions.dequeueReusableCell(withIdentifier: "transactionCell2", for: indexPath) as! TransactionDetailsTableViewCell
                    var totalAmount = 0.0
                    
                    for (i,j) in self.claimSeedTransactions.enumerated() {
                        let amount = Double(self.claimSeedTransactions[i].amount)
                        totalAmount = totalAmount  + (amount ?? 0.0)
                    }
                    
                    let truncatedAmount = Int(round(totalAmount))
                    let rupee = "\u{20B9} "
                    
                    if self.claimSeedTransactions[indexPath.row].productName != nil{
                        cell1.lblAmountKey.text = NSLocalizedString("product_name_label", comment: "") //"Product Name "
                        cell1.lblAmount.text = ": " +  self.claimSeedTransactions[indexPath.row].productName
                    }else{
                        cell1.lblAmountKey.isHidden = true
                        cell1.lblAmount.isHidden = true
                    }
                    
                   
                    cell1.lblRefIDKey.text =  NSLocalizedString("Amount", comment:"")//"Amount "
                    cell1.lblDateKey.text = NSLocalizedString("lbl_date", comment: "")//"Date "//"Date "
                    cell1.lblStatusKey.text = NSLocalizedString("serial_no", comment: "")//"Serial No "//"Serial No "
                    
                    cell1.btnMoreDetails.isHidden = true
                    //                cell.lblDateKey.isHidden = true
                    // cell.lblCreatedOn.isHidden = true
                    cell1.stackViewTopConstraint.constant = 0
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                    
                    let dateFormatterPrint = DateFormatter()
                    dateFormatterPrint.dateFormat = "dd-MMM-yyyy HH:mm:ss"
                    
                    if self.claimSeedTransactions[indexPath.row].createdOn != ""{
                        let date = dateFormatter.date(from: self.claimSeedTransactions[indexPath.row].createdOn)!
                        cell1.lblCreatedOn.text =  ": " + dateFormatterPrint.string(from: date) as String  //": " + self.claimTransactions[indexPath.row].referenceId
                    }else{
                        cell1.lblCreatedOn.text = ""
                    }
                    
                    let claim = NSLocalizedString("Claim", comment: "")
                   // let strclaim = String(format:"Claim - %@%.2f", rupee, truncatedAmount)
                    let strclaim = "\(claim) - \(rupee)\(truncatedAmount)"
                    cell1.btnReclaim.setTitle(strclaim, for: UIControlState.normal)
                    cell1.btnReclaim.isUserInteractionEnabled = false
                    
                    
                    
                    
                    
                    cell1.lblStatus.text = ": " + self.claimSeedTransactions[indexPath.row].prodSerialNumber
                    
                    let amount = Double(self.claimSeedTransactions[indexPath.row].amount) ?? 0.0
                    let truncatedAmt = Int(round(amount))
                    cell1.lblReferenceID.text =  ": " + String(format:"%@%.2f", rupee, truncatedAmt ?? 0.0 ) //self.claimTransactions[indexPath.row].amount
                    cell1.lblReferenceID.text = ":\(rupee)\(truncatedAmt)"
                    
                    cell1.btnReclaim.isHidden = false
                    cell1.reclaimHgtConstraint.constant = 35
                    
                   
                     //                    cell1.textLabel?.text = String(format:"Claim - %@%.2f", rupee, totalAmount)
                    //                    cell1.textLabel?.textAlignment = .center
                    //                    cell1.textLabel?.textColor = UIColor.white
                    cell1.backgroundColor = App_Theme_Green_Color
                    cell1.tag =  indexPath.row
                    cell1.contentView.addBorder(toSide: .Bottom, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: cell1.contentView.frame.size.height-1, height: 1.0)
                    cell1.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: cell1.contentView.frame.size.height)
                    cell1.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: cell1.contentView.frame.size.height-1, yValue: 0, height: cell1.contentView.frame.size.height)
                    
                    let headerTapGesture = UITapGestureRecognizer()
                    headerTapGesture.view?.tag = indexPath.row
                    headerTapGesture.addTarget(self, action: #selector(RewardsViewController.NavigationToPaymentSelectionSeed))
                    cell1.addGestureRecognizer(headerTapGesture)
                    return cell1
                }else {
                    let cell =  tblViewSeedTransactions.dequeueReusableCell(withIdentifier: "transactionCell2", for: indexPath) as! TransactionDetailsTableViewCell
                    let rupee = "\u{20B9} "
                    
                    if self.claimSeedTransactions[indexPath.row].productName != nil{
                        cell.lblAmountKey.text = NSLocalizedString("product_name_label", comment: "")//"Product Name "
                        cell.lblAmount.text = ": " +  self.claimSeedTransactions[indexPath.row].productName
                    }else{
                        cell.lblAmountKey.isHidden = true
                        cell.lblAmount.isHidden = true
                    }
                    
                    
                    cell.lblRefIDKey.text = NSLocalizedString("Amount", comment:"")//"Amount "
                    cell.lblDateKey.text = NSLocalizedString("lbl_date", comment: "")
                    cell.lblStatusKey.text = NSLocalizedString("serial_no", comment: "")

                    
                    cell.btnMoreDetails.isHidden = true
                    //                cell.lblDateKey.isHidden = true
                    // cell.lblCreatedOn.isHidden = true
                    cell.stackViewTopConstraint.constant = 0
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                    
                    let dateFormatterPrint = DateFormatter()
                    dateFormatterPrint.dateFormat = "dd-MMM-yyyy HH:mm:ss"
                    
                    if self.claimSeedTransactions[indexPath.row].createdOn != ""{
                        let date = dateFormatter.date(from: self.claimSeedTransactions[indexPath.row].createdOn)!
                        cell.lblCreatedOn.text =  ": " + dateFormatterPrint.string(from: date) as String  //": " + self.claimTransactions[indexPath.row].referenceId
                    }else{
                        cell.lblCreatedOn.text = ""
                    }
                    
                    
                    
                    
                    
                    cell.lblStatus.text = ": " + self.claimSeedTransactions[indexPath.row].prodSerialNumber
                    
                    let amount = Double(self.claimSeedTransactions[indexPath.row].amount)
                    let truncatedAmount = Int(round(amount ?? 0.0))
                    cell.lblReferenceID.text =  ": " + String(format:"%@%.2f", rupee, truncatedAmount ?? 0.0) //self.claimTransactions[indexPath.row].amount
                    cell.lblReferenceID.text = ": \(rupee)\(truncatedAmount)"
                    
                    cell.btnReclaim.isHidden = true
                    cell.reclaimHgtConstraint.constant = 0
                    
                    if sectionNamesSeed[indexPath.section].collapsed == false {
                        cell.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                        cell.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                    }else {
                        cell.contentView.addBorder(toSide: .Left, withColor: UIColor.clear.cgColor, andThickness: 0.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                        cell.contentView.addBorder(toSide: .Right, withColor: UIColor.clear.cgColor, andThickness: 0.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                    }
                    return cell
                }
            }else if sectionNamesSeed[indexPath.section].itemName.lowercased() == "success list" {
                let cell =  tblViewSeedTransactions.dequeueReusableCell(withIdentifier: "transactionCell2", for: indexPath) as! TransactionDetailsTableViewCell
                cell.lblDateKey.text = NSLocalizedString("lbl_date", comment: "")
                cell.lblRefIDKey.text = NSLocalizedString("referenceId", comment: "")
                cell.lblStatusKey.text = NSLocalizedString("status", comment: "")
                cell.lblAmountKey.text = NSLocalizedString("Amount", comment:"")
                let rupee = "\u{20B9} "
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "dd-MMM-yyyy HH:mm:ss"
                
                if self.successSeedTransactions[indexPath.row].createdOn != ""{
                    let date = dateFormatter.date(from: self.successSeedTransactions[indexPath.row].createdOn)!
                    cell.lblCreatedOn.text = ": " + dateFormatterPrint.string(from: date) as String
                }else{
                    cell.lblCreatedOn.text = ""
                }
                
                
                let amount  = Double(self.successSeedTransactions[indexPath.row].amount) ?? 0.0
                let truncatedAmount = Int(round(amount))
                cell.lblAmount.text = ": " +  String(format:"%@%.2f", rupee, truncatedAmount ?? 0.0)
                cell.lblAmount.text = ":\(rupee)\(truncatedAmount)"
                
                
                cell.lblStatus.text = ": " + self.successSeedTransactions[indexPath.row].status
                cell.lblReferenceID.text = ": " + self.successSeedTransactions[indexPath.row].referenceId
                cell.stackViewTopConstraint.constant = 0
                cell.btnReclaim.isHidden = true
                cell.reclaimHgtConstraint.constant = 0
                cell.btnMoreDetails.isHidden = true
                
                if self.successSeedTransactions[indexPath.row].showView == true{
                    cell.stackViewTopConstraint.constant = 30
                    cell.btnMoreDetails.isHidden = false
                    cell.btnMoreDetails.tag = indexPath.row
                    cell.btnMoreDetails.setImage(UIImage(named: "moreInfo"), for: .normal)
                    cell.btnMoreDetails.addTarget(self, action: #selector(getMoreDetailsOfTransactionSeed(_:)), for: .touchUpInside)
                }
                
                if sectionNamesSeed[indexPath.section].collapsed == false {
                    cell.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                    cell.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                }
                else {
                    cell.contentView.addBorder(toSide: .Left, withColor: UIColor.clear.cgColor, andThickness: 0.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                    cell.contentView.addBorder(toSide: .Right, withColor: UIColor.clear.cgColor, andThickness: 0.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                }
                return cell
            }
            else {
                let cell =  tblViewSeedTransactions.dequeueReusableCell(withIdentifier: "transactionCell2", for: indexPath) as! TransactionDetailsTableViewCell
                cell.lblDateKey.text = NSLocalizedString("lbl_date", comment: "")
                cell.lblRefIDKey.text = NSLocalizedString("referenceId", comment: "")
                cell.lblStatusKey.text = NSLocalizedString("status", comment: "")
                cell.lblAmountKey.text = NSLocalizedString("Amount", comment:"")
                let rupee = "\u{20B9} "
                print(rupee)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "dd-MMM-yyyy HH:mm:ss"
                
                if self.reclaimSeedTransactions[indexPath.row].createdOn != ""{
                    let date = dateFormatter.date(from: self.reclaimSeedTransactions[indexPath.row].createdOn)!
                    cell.lblCreatedOn.text = ": " + dateFormatterPrint.string(from: date) as String
                }else{
                    cell.lblCreatedOn.text = ""
                }
                
                
                let amount  = Double(self.reclaimSeedTransactions[indexPath.row].amount) ?? 0.0
                let truncatedAmount = Int(round(amount))
                cell.lblAmount.text = ": " +  String(format:"%@%.2f", rupee, truncatedAmount ?? 0.0)
                cell.lblAmount.text = ":\(rupee)\(truncatedAmount)"
                
                
                cell.lblStatus.text = ": " + self.reclaimSeedTransactions[indexPath.row].status
                cell.lblReferenceID.text = ": " + self.reclaimSeedTransactions[indexPath.row].referenceId
                
                cell.btnReclaim.isHidden = false
                cell.btnReclaim.setTitle(self.reclaimSeedTransactions[indexPath.row].buttonText, for: .normal)
                cell.reclaimHgtConstraint.constant = 35
                cell.btnReclaim.tag = indexPath.row
                cell.btnMoreDetails.isHidden = true
                cell.stackViewTopConstraint.constant = 0
                cell.btnReclaim.tag = indexPath.row
                if cell.btnReclaim.titleLabel?.text?.lowercased() == "re claim"{
                    cell.btnReclaim.addTarget(self, action: #selector(reClaimAmountForSeedTransaction(_:)), for: .touchUpInside)
                }
                cell.btnReclaim.setTitle(NSLocalizedString("Reclaim", comment: ""), for: .normal)
                cell.btnReclaim.addTarget(self, action: #selector(reClaimAmountForSeedTransaction(_:)), for: .touchUpInside)
                
                if sectionNamesSeed[indexPath.section].collapsed == false {
                    cell.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                    cell.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                }else {
                    cell.contentView.addBorder(toSide: .Left, withColor: UIColor.clear.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                    cell.contentView.addBorder(toSide: .Right, withColor: UIColor.clear.cgColor, andThickness: 1.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                }
                return cell
            }
        }
        else if tableView == tblViewseed2Transactions{
                if sectionNamesSeed2[indexPath.section].itemName.lowercased() == "claim list" && self.claimSeed2Transactions.count > 0 {
                    let lastRowIndex = tableView.numberOfRows(inSection: indexPath.section)
                    
                    if indexPath.row == lastRowIndex - 1 {
                        
                        let cell1 =  tblViewseed2Transactions.dequeueReusableCell(withIdentifier: "transactionSeed2Cell", for: indexPath) as! TransactionDetailsTableViewCell
                        var totalAmount = 0.0
                        
                        for (i,j) in self.claimSeed2Transactions.enumerated() {
                            let amount = Double(self.claimSeed2Transactions[i].amount)
                            totalAmount = totalAmount  + (amount ?? 0.0)
                        }
                        
                        let truncatedAmount = Int(round(totalAmount))
                        let rupee = "\u{20B9} "
                        
                        if self.claimSeed2Transactions[indexPath.row].productName != nil{
                        cell1.lblAmountKey.text = NSLocalizedString("product_name_label", comment: "")
                        cell1.lblAmount.text = ": " +  self.claimSeed2Transactions[indexPath.row].productName
                        }else{
                            cell1.lblAmountKey.isHidden = true
                            cell1.lblAmount.isHidden = true
                        }
                        
                        
                        cell1.lblRefIDKey.text = NSLocalizedString("Amount", comment:"")
                        cell1.lblDateKey.text = NSLocalizedString("lbl_date", comment: "")
                        cell1.lblStatusKey.text = NSLocalizedString("serial_no", comment: "")
                        
                        cell1.btnMoreDetails.isHidden = true
                        //                cell.lblDateKey.isHidden = true
                        // cell.lblCreatedOn.isHidden = true
                        cell1.stackViewTopConstraint.constant = 0
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                        
                        let dateFormatterPrint = DateFormatter()
                        dateFormatterPrint.dateFormat = "dd-MMM-yyyy HH:mm:ss"
                        
                        if self.claimSeed2Transactions[indexPath.row].createdOn != ""{
                            let date = dateFormatter.date(from: self.claimSeed2Transactions[indexPath.row].createdOn)!
                            cell1.lblCreatedOn.text =  ": " + dateFormatterPrint.string(from: date) as String  //": " + self.claimTransactions[indexPath.row].referenceId
                        }else{
                            cell1.lblCreatedOn.text = ""
                        }
                        let claim =  NSLocalizedString("Claim", comment: "")
                       // let strclaim = String(format:"Claim - %@%.2f", rupee, truncatedAmount)
                        let strclaim = "\(claim) - \(rupee)\(truncatedAmount)"
                        cell1.btnReclaim.setTitle(strclaim, for: UIControlState.normal)
                        cell1.btnReclaim.isUserInteractionEnabled = false
                        
                        
                        
                        
                        
                        
                        cell1.lblStatus.text = ": " + self.claimSeed2Transactions[indexPath.row].prodSerialNumber
                        
                        let amount = Double(self.claimSeed2Transactions[indexPath.row].amount) ?? 0.0
                        let truncatedAmt = Int(round(amount))
                        cell1.lblReferenceID.text =  ": " + String(format:"%@%.2f", rupee, truncatedAmt ?? 0.0 ) //self.claimTransactions[indexPath.row].amount
                        cell1.lblReferenceID.text = ":\(rupee)\(truncatedAmt)"
                        
                        cell1.btnReclaim.isHidden = false
                        cell1.reclaimHgtConstraint.constant = 35
                        
                       
                         //                    cell1.textLabel?.text = String(format:"Claim - %@%.2f", rupee, totalAmount)
                        //                    cell1.textLabel?.textAlignment = .center
                        //                    cell1.textLabel?.textColor = UIColor.white
                        cell1.backgroundColor = App_Theme_Green_Color
                        cell1.tag =  indexPath.row
                        cell1.contentView.addBorder(toSide: .Bottom, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: cell1.contentView.frame.size.height-1, height: 1.0)
                        cell1.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: cell1.contentView.frame.size.height)
                        cell1.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: cell1.contentView.frame.size.height-1, yValue: 0, height: cell1.contentView.frame.size.height)
                        
                        let headerTapGesture = UITapGestureRecognizer()
                        headerTapGesture.view?.tag = indexPath.row
                        headerTapGesture.addTarget(self, action: #selector(RewardsViewController.NavigationToPaymentSelectionSeed2))
                        cell1.addGestureRecognizer(headerTapGesture)
                        return cell1
                    }else {
                        let cell =  tblViewseed2Transactions.dequeueReusableCell(withIdentifier: "transactionSeed2Cell", for: indexPath) as! TransactionDetailsTableViewCell
                        let rupee = "\u{20B9} "
                        
                        if self.claimSeed2Transactions[indexPath.row].productName != nil{
                        cell.lblAmountKey.text = NSLocalizedString("product_name_label", comment: "")
                        cell.lblAmount.text = ": " +  self.claimSeed2Transactions[indexPath.row].productName
                        }else{
                            cell.lblAmountKey.isHidden = true
                            cell.lblAmount.isHidden = true
                        }
                        
                        
                        cell.lblRefIDKey.text = NSLocalizedString("Amount", comment:"")
                        cell.lblDateKey.text = NSLocalizedString("lbl_date", comment: "")
                        cell.lblStatusKey.text = NSLocalizedString("serial_no", comment: "")
                        
                        cell.btnMoreDetails.isHidden = true
                        //                cell.lblDateKey.isHidden = true
                        // cell.lblCreatedOn.isHidden = true
                        cell.stackViewTopConstraint.constant = 0
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                        
                        let dateFormatterPrint = DateFormatter()
                        dateFormatterPrint.dateFormat = "dd-MMM-yyyy HH:mm:ss"
                        
                        if self.claimSeed2Transactions[indexPath.row].createdOn != ""{
                            let date = dateFormatter.date(from: self.claimSeed2Transactions[indexPath.row].createdOn)!
                            cell.lblCreatedOn.text =  ": " + dateFormatterPrint.string(from: date) as String  //": " + self.claimTransactions[indexPath.row].referenceId
                        }else{
                            cell.lblCreatedOn.text = ""
                        }
                        
                        
                        
                        
                        
                        
                        cell.lblStatus.text = ": " + self.claimSeed2Transactions[indexPath.row].prodSerialNumber
                        
                        let amount = Double(self.claimSeed2Transactions[indexPath.row].amount)
                        let truncatedAmount = Int(round(amount ?? 0.0))
                        cell.lblReferenceID.text =  ": " + String(format:"%@%.2f", rupee, truncatedAmount ?? 0.0) //self.claimTransactions[indexPath.row].amount
                        cell.lblReferenceID.text = ": \(rupee)\(truncatedAmount)"
                        
                        cell.btnReclaim.isHidden = true
                        cell.reclaimHgtConstraint.constant = 0
                        
                        if sectionNamesSeed2[indexPath.section].collapsed == false {
                            cell.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                            cell.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                        }else {
                            cell.contentView.addBorder(toSide: .Left, withColor: UIColor.clear.cgColor, andThickness: 0.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                            cell.contentView.addBorder(toSide: .Right, withColor: UIColor.clear.cgColor, andThickness: 0.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                        }
                        return cell
                    }
                }else if sectionNamesSeed2[indexPath.section].itemName.lowercased() == "success list" {
                    let cell =  tblViewseed2Transactions.dequeueReusableCell(withIdentifier: "transactionSeed2Cell", for: indexPath) as! TransactionDetailsTableViewCell
                    cell.lblDateKey.text = NSLocalizedString("lbl_date", comment: "")
                    cell.lblRefIDKey.text = NSLocalizedString("referenceId", comment: "")
                    cell.lblStatusKey.text = NSLocalizedString("status", comment: "")
                    cell.lblAmountKey.text = NSLocalizedString("Amount", comment:"")
                    let rupee = "\u{20B9} "
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                    
                    let dateFormatterPrint = DateFormatter()
                    dateFormatterPrint.dateFormat = "dd-MMM-yyyy HH:mm:ss"
                    
                    if self.successSeed2Transactions[indexPath.row].createdOn != ""{
                        let date = dateFormatter.date(from: self.successSeed2Transactions[indexPath.row].createdOn)!
                        cell.lblCreatedOn.text = ": " + dateFormatterPrint.string(from: date) as String
                    }else{
                        cell.lblCreatedOn.text = ""
                    }
                    
                    
                    let amount  = Double(self.successSeed2Transactions[indexPath.row].amount) ?? 0.0
                    let truncatedAmount = Int(round(amount))
                    cell.lblAmount.text = ": " +  String(format:"%@%.2f", rupee, truncatedAmount ?? 0.0)
                    cell.lblAmount.text = ":\(rupee)\(truncatedAmount)"
                    
                    
                    cell.lblStatus.text = ": " + self.successSeed2Transactions[indexPath.row].status
                    cell.lblReferenceID.text = ": " + self.successSeed2Transactions[indexPath.row].referenceId
                    cell.stackViewTopConstraint.constant = 0
                    cell.btnReclaim.isHidden = true
                    cell.reclaimHgtConstraint.constant = 0
                    cell.btnMoreDetails.isHidden = true
                    
                    if self.successSeed2Transactions[indexPath.row].showView == true{
                        cell.stackViewTopConstraint.constant = 30
                        cell.btnMoreDetails.isHidden = false
                        cell.btnMoreDetails.tag = indexPath.row
                        cell.btnMoreDetails.setImage(UIImage(named: "moreInfo"), for: .normal)
                        cell.btnMoreDetails.addTarget(self, action: #selector(getMoreDetailsOfTransactionSeed2), for: .touchUpInside)
                    }
                    
                    if sectionNamesSeed2[indexPath.section].collapsed == false {
                        cell.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                        cell.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                    }
                    else {
                        cell.contentView.addBorder(toSide: .Left, withColor: UIColor.clear.cgColor, andThickness: 0.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                        cell.contentView.addBorder(toSide: .Right, withColor: UIColor.clear.cgColor, andThickness: 0.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                    }
                    return cell
                }
                else {
                    let cell =  tblViewseed2Transactions.dequeueReusableCell(withIdentifier: "transactionSeed2Cell", for: indexPath) as! TransactionDetailsTableViewCell
                    cell.lblDateKey.text = NSLocalizedString("lbl_date", comment: "")
                    cell.lblRefIDKey.text = NSLocalizedString("referenceId", comment: "")
                    cell.lblStatusKey.text = NSLocalizedString("status", comment: "")
                    cell.lblAmountKey.text = NSLocalizedString("Amount", comment:"")
                    let rupee = "\u{20B9} "
                    print(rupee)
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                    
                    let dateFormatterPrint = DateFormatter()
                    dateFormatterPrint.dateFormat = "dd-MMM-yyyy HH:mm:ss"
                    
                    if self.reclaimSeed2Transactions[indexPath.row].createdOn != ""{
                        let date = dateFormatter.date(from: self.reclaimSeed2Transactions[indexPath.row].createdOn)!
                        cell.lblCreatedOn.text = ": " + dateFormatterPrint.string(from: date) as String
                    }else{
                        
                    }
                    if let date = dateFormatter.date(from: self.reclaimSeed2Transactions[indexPath.row].createdOn){
                        cell.lblCreatedOn.text = ": " + dateFormatterPrint.string(from: date) as String
                    }
                    
                    let amount  = Double(self.reclaimSeed2Transactions[indexPath.row].amount) ?? 0.0
                    let truncatedAmount = Int(round(amount))
                    cell.lblAmount.text = ": " +  String(format:"%@%.2f", rupee, truncatedAmount ?? 0.0)
                    cell.lblAmount.text = ":\(rupee)\(truncatedAmount)"
                    
                    
                    cell.lblStatus.text = ": " + self.reclaimSeed2Transactions[indexPath.row].status
                    cell.lblReferenceID.text = ": " + self.reclaimSeed2Transactions[indexPath.row].referenceId
                    
                    cell.btnReclaim.isHidden = false
                    cell.btnReclaim.setTitle(self.reclaimSeed2Transactions[indexPath.row].buttonText, for: .normal)
                    cell.reclaimHgtConstraint.constant = 35
                    cell.btnReclaim.tag = indexPath.row
                    cell.btnMoreDetails.isHidden = true
                    cell.stackViewTopConstraint.constant = 0
                    cell.btnReclaim.tag = indexPath.row
                    if cell.btnReclaim.titleLabel?.text?.lowercased() == "re claim"{
                        cell.btnReclaim.addTarget(self, action: #selector(reClaimAmountForSeed2Transaction), for: .touchUpInside)
                    }
                    cell.btnReclaim.setTitle(NSLocalizedString("Reclaim", comment: ""), for: .normal)
                    cell.btnReclaim.addTarget(self, action: #selector(reClaimAmountForSeed2Transaction), for: .touchUpInside)
                    
                    if sectionNamesSeed2[indexPath.section].collapsed == false {
                        cell.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                        cell.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                    }else {
                        cell.contentView.addBorder(toSide: .Left, withColor: UIColor.clear.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                        cell.contentView.addBorder(toSide: .Right, withColor: UIColor.clear.cgColor, andThickness: 1.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                    }
                    return cell
                }
        }
        else if tableView == tblViewDSRTransactions{
            if sectionNamesDSR[indexPath.section].itemName.lowercased() == "claim list" && self.claimDSRTransactions.count > 0 {
                let lastRowIndex = tableView.numberOfRows(inSection: indexPath.section)
                
                if indexPath.row == lastRowIndex - 1 {
                    
                    let cell1 =  tblViewDSRTransactions.dequeueReusableCell(withIdentifier: "transactionDSRCell", for: indexPath) as! TransactionDetailsTableViewCell
                    var totalAmount = 0.0
                    
                    for (i,j) in self.claimDSRTransactions.enumerated() {
                        let amount = Double(self.claimDSRTransactions[i].amount)
                        totalAmount = totalAmount  + (amount ?? 0.0)
                    }
                    
                    let truncatedAmount = Int(round(totalAmount))
                    let rupee = "\u{20B9} "
                    
                    cell1.lblAmountKey.text = "Product Name "
                    cell1.lblAmountKey.isHidden = true
                    cell1.lblRefIDKey.text = NSLocalizedString("Amount", comment:"")
                    cell1.lblDateKey.text = NSLocalizedString("lbl_date", comment: "")
                    cell1.lblStatusKey.text = NSLocalizedString("serial_no", comment: "")
                    
                    cell1.btnMoreDetails.isHidden = true
                    //                cell.lblDateKey.isHidden = true
                    // cell.lblCreatedOn.isHidden = true
                    cell1.stackViewTopConstraint.constant = 0
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                    
                    let dateFormatterPrint = DateFormatter()
                    dateFormatterPrint.dateFormat = "dd-MMM-yyyy HH:mm:ss"
                    
                    let claim = NSLocalizedString("Claim", comment: "")
                    // let strclaim = String(format:"Claim - %@%.2f", rupee, truncatedAmount)
                    let strclaim = "\(claim) - \(rupee)\(truncatedAmount)"
                    cell1.btnReclaim.setTitle(strclaim, for: UIControlState.normal)
                    cell1.btnReclaim.isUserInteractionEnabled = false
                    if let date = dateFormatter.date(from: self.claimDSRTransactions[indexPath.row].createdOn){
                        cell1.lblCreatedOn.text =  ": " + dateFormatterPrint.string(from: date) as String  //": " + self.claimTransactions[indexPath.row].referenceId
                    }
                    
                    cell1.lblAmount.text = ": " +  self.claimDSRTransactions[indexPath.row].productName
                    cell1.lblAmount.isHidden = true
                    
                    
                    
                    cell1.lblStatus.text = ": " + self.claimDSRTransactions[indexPath.row].prodSerialNumber
                    
                    let amount = Double(self.claimDSRTransactions[indexPath.row].amount) ?? 0.0
                    let truncatedAmt = Int(round(amount))
                    cell1.lblReferenceID.text =  ": " + String(format:"%@%.2f", rupee, truncatedAmt ?? 0.0 ) //self.claimTransactions[indexPath.row].amount
                    cell1.lblReferenceID.text = ":\(rupee)\(truncatedAmt)"
                    
                    cell1.btnReclaim.isHidden = false
                    cell1.reclaimHgtConstraint.constant = 35
                    
                    
                    //                    cell1.textLabel?.text = String(format:"Claim - %@%.2f", rupee, totalAmount)
                    //                    cell1.textLabel?.textAlignment = .center
                    //                    cell1.textLabel?.textColor = UIColor.white
                    cell1.backgroundColor = App_Theme_Green_Color
                    cell1.tag =  indexPath.row
                    cell1.contentView.addBorder(toSide: .Bottom, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: cell1.contentView.frame.size.height-1, height: 1.0)
                    cell1.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: cell1.contentView.frame.size.height)
                    cell1.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: cell1.contentView.frame.size.height-1, yValue: 0, height: cell1.contentView.frame.size.height)
                    
                    let headerTapGesture = UITapGestureRecognizer()
                    headerTapGesture.view?.tag = indexPath.row
                    headerTapGesture.addTarget(self, action: #selector(RewardsViewController.NavigationToPaymentSelectionDSR))
                    cell1.addGestureRecognizer(headerTapGesture)
                    return cell1
                }else {
                    let cell =  tblViewDSRTransactions.dequeueReusableCell(withIdentifier: "transactionDSRCell", for: indexPath) as! TransactionDetailsTableViewCell
                    let rupee = "\u{20B9} "
                    
                    cell.lblAmountKey.text = "Product Name "
                    cell.lblAmountKey.isHidden = true
                    cell.lblRefIDKey.text = NSLocalizedString("Amount", comment:"")
                    cell.lblDateKey.text = NSLocalizedString("lbl_date", comment: "")
                    cell.lblStatusKey.text = NSLocalizedString("serial_no", comment: "")
                    
                    cell.btnMoreDetails.isHidden = true
                    //                cell.lblDateKey.isHidden = true
                    // cell.lblCreatedOn.isHidden = true
                    cell.stackViewTopConstraint.constant = 0
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                    
                    let dateFormatterPrint = DateFormatter()
                    dateFormatterPrint.dateFormat = "dd-MMM-yyyy HH:mm:ss"
                    
                    if let date = dateFormatter.date(from: self.claimDSRTransactions[indexPath.row].createdOn){
                        cell.lblCreatedOn.text =  ": " + dateFormatterPrint.string(from: date) as String  //": " + self.claimTransactions[indexPath.row].referenceId
                    }
                    
                    cell.lblAmount.text = ": " +  self.claimDSRTransactions[indexPath.row].productName
                    cell.lblAmount.isHidden = true
                    
                    
                    
                    cell.lblStatus.text = ": " + self.claimDSRTransactions[indexPath.row].prodSerialNumber
                    
                    let amount = Double(self.claimDSRTransactions[indexPath.row].amount)
                    let truncatedAmount = Int(round(amount ?? 0.0))
                    cell.lblReferenceID.text =  ": " + String(format:"%@%.2f", rupee, truncatedAmount ?? 0.0) //self.claimTransactions[indexPath.row].amount
                    cell.lblReferenceID.text = ": \(rupee)\(truncatedAmount)"
                    
                    cell.btnReclaim.isHidden = true
                    cell.reclaimHgtConstraint.constant = 0
                    
                    if sectionNamesDSR[indexPath.section].collapsed == false {
                        cell.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                        cell.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                    }else {
                        cell.contentView.addBorder(toSide: .Left, withColor: UIColor.clear.cgColor, andThickness: 0.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                        cell.contentView.addBorder(toSide: .Right, withColor: UIColor.clear.cgColor, andThickness: 0.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                    }
                    return cell
                }
            }else if sectionNamesDSR[indexPath.section].itemName.lowercased() == "success list" {
                let cell =  tblViewDSRTransactions.dequeueReusableCell(withIdentifier: "transactionDSRCell", for: indexPath) as! TransactionDetailsTableViewCell
                cell.lblDateKey.text = NSLocalizedString("lbl_date", comment: "")
                cell.lblRefIDKey.text = NSLocalizedString("referenceId", comment: "")
                cell.lblStatusKey.text = NSLocalizedString("status", comment: "")
                cell.lblAmountKey.text = NSLocalizedString("Amount", comment:"")
                let rupee = "\u{20B9} "
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "dd-MMM-yyyy HH:mm:ss"
                
                if let date = dateFormatter.date(from: self.successDSRTransactions[indexPath.row].createdOn){
                    cell.lblCreatedOn.text = ": " + dateFormatterPrint.string(from: date) as String
                }
                
                let amount  = Double(self.successDSRTransactions[indexPath.row].amount) ?? 0.0
                let truncatedAmount = Int(round(amount))
                cell.lblAmount.text = ": " +  String(format:"%@%.2f", rupee, truncatedAmount ?? 0.0)
                cell.lblAmount.text = ":\(rupee)\(truncatedAmount)"
                
                
                cell.lblStatus.text = ": " + self.successDSRTransactions[indexPath.row].status
                cell.lblReferenceID.text = ": " + self.successDSRTransactions[indexPath.row].referenceId
                cell.stackViewTopConstraint.constant = 0
                cell.btnReclaim.isHidden = true
                cell.reclaimHgtConstraint.constant = 0
                cell.btnMoreDetails.isHidden = true
                
                if self.successDSRTransactions[indexPath.row].showView == true{
                    cell.stackViewTopConstraint.constant = 30
                    cell.btnMoreDetails.isHidden = false
                    cell.btnMoreDetails.tag = indexPath.row
                    cell.btnMoreDetails.setImage(UIImage(named: "moreInfo"), for: .normal)
                    cell.btnMoreDetails.addTarget(self, action: #selector(getMoreDetailsOfTransactionDSR), for: .touchUpInside)
                }
                
                if sectionNamesDSR[indexPath.section].collapsed == false {
                    cell.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                    cell.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                }
                else {
                    cell.contentView.addBorder(toSide: .Left, withColor: UIColor.clear.cgColor, andThickness: 0.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                    cell.contentView.addBorder(toSide: .Right, withColor: UIColor.clear.cgColor, andThickness: 0.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                }
                return cell
            }
            else {
                let cell =  tblViewDSRTransactions.dequeueReusableCell(withIdentifier: "transactionDSRCell", for: indexPath) as! TransactionDetailsTableViewCell
                cell.lblDateKey.text = NSLocalizedString("lbl_date", comment: "")
                cell.lblRefIDKey.text = NSLocalizedString("referenceId", comment: "")
                cell.lblStatusKey.text = NSLocalizedString("status", comment: "")
                cell.lblAmountKey.text = NSLocalizedString("Amount", comment:"")
                let rupee = "\u{20B9} "
                print(rupee)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "dd-MMM-yyyy HH:mm:ss"
                
                if let date = dateFormatter.date(from: self.reclaimDSRTransactions[indexPath.row].createdOn){
                    cell.lblCreatedOn.text = ": " + dateFormatterPrint.string(from: date) as String
                }
                
                let amount  = Double(self.reclaimDSRTransactions[indexPath.row].amount) ?? 0.0
                let truncatedAmount = Int(round(amount))
                cell.lblAmount.text = ": " +  String(format:"%@%.2f", rupee, truncatedAmount ?? 0.0)
                cell.lblAmount.text = ":\(rupee)\(truncatedAmount)"
                
                
                cell.lblStatus.text = ": " + self.reclaimDSRTransactions[indexPath.row].status
                cell.lblReferenceID.text = ": " + self.reclaimDSRTransactions[indexPath.row].referenceId
                
                cell.btnReclaim.isHidden = false
                cell.btnReclaim.setTitle(self.reclaimDSRTransactions[indexPath.row].buttonText, for: .normal)
                cell.reclaimHgtConstraint.constant = 35
                cell.btnReclaim.tag = indexPath.row
                cell.btnMoreDetails.isHidden = true
                cell.stackViewTopConstraint.constant = 0
                cell.btnReclaim.tag = indexPath.row
                if cell.btnReclaim.titleLabel?.text?.lowercased() == "re claim"{
                    cell.btnReclaim.addTarget(self, action: #selector(reClaimAmountForDSRTransaction), for: .touchUpInside)
                }
                
                cell.btnReclaim.setTitle(NSLocalizedString("Reclaim", comment: ""), for: .normal)
                cell.btnReclaim.addTarget(self, action: #selector(reClaimAmountForDSRTransaction), for: .touchUpInside)
                
                if sectionNamesDSR[indexPath.section].collapsed == false {
                    cell.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                    cell.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                }else {
                    cell.contentView.addBorder(toSide: .Left, withColor: UIColor.clear.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
                    cell.contentView.addBorder(toSide: .Right, withColor: UIColor.clear.cgColor, andThickness: 1.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
                }
                return cell
            }
        }
        else if tableView == tblViewGiftCouponTransactions{
            let cell =  tblViewGiftCouponTransactions.dequeueReusableCell(withIdentifier: "GiftCouponTableViewCell", for: indexPath) as! GiftCouponTableViewCell

            cell.productNameValueLbl.text = self.giftCouponTransactions[indexPath.row].product
            cell.dateValueLbl.text = self.giftCouponTransactions[indexPath.row].couponGeneratedDate
            //let redeemStatusHere = self.giftCouponTransactions[indexPath.row].redeemStatus
            //String(redeemStatusHere)
            cell.statusValueLbl.text = self.giftCouponTransactions[indexPath.row].redeemMessage
                
            
            let imageURL = self.giftCouponTransactions[indexPath.row].sampleQRCodeImgUrl
            cell.QRCodeImgBtn.setImage(fromURL: imageURL, for: .normal)
            cell.QRCodeImgBtn.tag = indexPath.row
            cell.QRCodeImgBtn.addTarget(self, action: #selector(QRCodeCLickAction(_:)), for: .touchUpInside)
            return cell
        }
        else{
            let cell = UITableViewCell()
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        //          if tableView == tblViewEcouponTransactions {
        //            let footerView = UIView()
        //                   let separatorView = UIView(frame: CGRect(x: tableView.separatorInset.left, y: footerView.frame.height, width: tableView.frame.width - tableView.separatorInset.right - tableView.separatorInset.left, height: 0))
        //                   separatorView.backgroundColor = UIColor.separatorColor
        //                   footerView.addSubview(separatorView)
        //                   return footerView
        //        }
        //          else{
        let footerView = UIView()
        let separatorView = UIView(frame: CGRect(x: tableView.separatorInset.left, y: footerView.frame.height, width: tableView.frame.width - tableView.separatorInset.right - tableView.separatorInset.left, height: 0))
        separatorView.backgroundColor = UIColor.separatorColor
        footerView.addSubview(separatorView)
        return footerView
        // }
        
    }
    
    // MARK: - Expand / Collapse Methods
    
    //2.00
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        return
                let headerView = sender.view as! UITableViewHeaderFooterView
                let section    = headerView.tag
        
                self.sectionNames[section].collapsed = !self.sectionNames[section].collapsed
                print( self.sectionNames[section].itemName )
                let collapsed = !self.sectionNames[section].collapsed
            self.ecouponTopViewHeightConstraint.constant = 50
        self.rewardTopViewHeightConstraint.constant = 50
        self.seedTopViewheightConstrain.constant = 50
        self.seed2TopViewheightConstrain.constant = 50
        self.dsrTopViewHeightConstraint.constant = 50
        self.giftCouponHeightConstraint.constant = 50
        var heightConstant  : Int = 0
        DispatchQueue.main.async {
            self.tblViewTransactions.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
            var heightConstant = CGFloat((self.successTransactions.count + self.claimTransactions.count + self.reclaimTransactions.count ) * 175 + 125)
            self.lblNoRewards.isHidden = true
            self.tblViewTransactions.isScrollEnabled = false
          self.tblViewTransactions.contentSize.height+200
//            for i in self.sectionNames{
//                if self.sectionNames[section].itemName.lowercased() == i.itemName.lowercased()  && self.sectionNames[section].collapsed == true{
//                    heightConstant = heightConstant + 50
//                }
//            }
              self.rewardHeightConstraint.constant = heightConstant //
       
             
        }
//                if collapsed {
//                        self.rewardHeightConstraint.constant +=  140// self.view.frame.height - 80
//                }
//                else{
//                        self.rewardHeightConstraint.constant -=  120//50
//                }
//                tblViewTransactions?.reloadSections(NSIndexSet(index: section) as IndexSet, with: .none)
//                   bgScroll?.contentSize = CGSize(width: self.contentVIew.frame.size.width, height: self.ecouponHeightConstraint.constant + self.rewardHeightConstraint.constant + 800.0)
       let height1 = self.rewardHeightConstraint.constant+self.ecouponHeightConstraint.constant
        let height2 = self.seedHeightConstraint.constant+self.seed2HeightConstraint.constant+self.dsrHeightConstraint.constant
        self.bgScroll.contentSize = CGSize(width: self.view.frame.size.width, height: height1+height2+1000)
       
    }
    @objc func sectionHeaderWasTouchedSeed(_ sender: UITapGestureRecognizer) {
        return
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section    = headerView.tag
        
        self.sectionNamesSeed[section].collapsed = !self.sectionNamesSeed[section].collapsed
        print( self.sectionNamesSeed[section].itemName )
        let collapsed = !self.sectionNamesSeed[section].collapsed
        self.seedTopViewheightConstrain.constant = 50
        self.ecouponTopViewHeightConstraint.constant = 50
        self.rewardTopViewHeightConstraint.constant = 50
        self.seed2TopViewheightConstrain.constant = 50
        self.dsrTopViewHeightConstraint.constant = 50
        var heightConstant  : Int = 0
        DispatchQueue.main.async {
            self.tblViewSeedTransactions.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
            var dataCount = (self.successSeedTransactions.count + self.claimSeedTransactions.count + self.reclaimSeedTransactions.count )
            var heightConstant = CGFloat((dataCount * 175) + 125)
            self.lblNoRewardsSeed.isHidden = true
            self.tblViewSeedTransactions.isScrollEnabled = false
            self.tblViewSeedTransactions.contentSize.height+200
            self.seedHeightConstraint.constant = heightConstant //
            
            let height1 = self.rewardHeightConstraint.constant+self.ecouponHeightConstraint.constant
            let heoight2 = self.seedHeightConstraint.constant+self.seed2HeightConstraint.constant+self.dsrHeightConstraint.constant
            self.bgScroll.contentSize = CGSize(width: self.view.frame.size.width, height:height1+heoight2+1000)
        }
    }
    
    @objc func sectionHeaderWasTouchedSeed2(_ sender: UITapGestureRecognizer) {
        return
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section    = headerView.tag
        
        self.sectionNamesSeed2[section].collapsed = !self.sectionNamesSeed2[section].collapsed
        print( self.sectionNamesSeed2[section].itemName )
        let collapsed = !self.sectionNamesSeed2[section].collapsed
        self.seed2TopViewheightConstrain.constant = 50
        var heightConstant  : Int = 0
        DispatchQueue.main.async {
            self.tblViewseed2Transactions.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
            var dataCount = (self.successSeed2Transactions.count + self.claimSeed2Transactions.count + self.reclaimSeed2Transactions.count )
            var heightConstant = CGFloat((dataCount * 175) + 125)
            self.lblNoRewardsSeed2.isHidden = true
            self.tblViewseed2Transactions.isScrollEnabled = false
            self.tblViewseed2Transactions.contentSize.height+200
            self.seed2HeightConstraint.constant = heightConstant //
            
            let height1 = self.rewardHeightConstraint.constant+self.ecouponHeightConstraint.constant
            let height2 = self.seedHeightConstraint.constant+self.seed2HeightConstraint.constant+self.dsrHeightConstraint.constant
            self.bgScroll.contentSize = CGSize(width: self.view.frame.size.width, height: height1+height2+1000)
        }
    }
    @objc func sectionHeaderWasTouchedDSR(_ sender: UITapGestureRecognizer) {
        return
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section    = headerView.tag
        
        self.sectionNamesDSR[section].collapsed = !self.sectionNamesDSR[section].collapsed
        print( self.sectionNamesDSR[section].itemName )
        let collapsed = !self.sectionNamesDSR[section].collapsed
        self.seedTopViewheightConstrain.constant = 50
        self.ecouponTopViewHeightConstraint.constant = 50
        self.rewardTopViewHeightConstraint.constant = 50
        self.seed2TopViewheightConstrain.constant = 50
        self.dsrTopViewHeightConstraint.constant = 50
        var heightConstant  : Int = 0
        DispatchQueue.main.async {
            self.tblViewDSRTransactions.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
            let dataCount = (self.successDSRTransactions.count + self.claimDSRTransactions.count + self.reclaimDSRTransactions.count )
            let heightConstant = CGFloat((dataCount * 175) + 125)
            self.lnlNoRewardsDSR.isHidden = true
            self.tblViewDSRTransactions.isScrollEnabled = false
            self.tblViewDSRTransactions.contentSize.height+200
            self.dsrHeightConstraint.constant = heightConstant //
            
            let height1 = self.rewardHeightConstraint.constant+self.ecouponHeightConstraint.constant
            let height2 = self.seedHeightConstraint.constant+self.seed2HeightConstraint.constant+self.dsrHeightConstraint.constant
            self.bgScroll.contentSize = CGSize(width: self.view.frame.size.width, height: height1+height2+1000)
        }
    }
    
    //2.00
    @objc func sectionHeaderWasTouchedEcoupon(_ sender: UITapGestureRecognizer) {
        return
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section    = headerView.tag
        DispatchQueue.main.async {
            self.sectionNamesEcoupon[section].collapsed = !self.sectionNamesEcoupon[section].collapsed
            let collapsed = !self.sectionNamesEcoupon [section].collapsed
//            var heightConstant = CGFloat((self.successTransactionsEcoupon.count + self.claimTransactionsEcoupon.count + self.reclaimTransactionsEcoupon.count ) * 140) + CGFloat(self.couponCodesList.count * 30)
//            print(self.tblViewEcouponTransactions.contentSize.height)
//            self.tblViewEcouponTransactions.isScrollEnabled = false
//            self.ecouponHeightConstraint.constant =  self.tblViewEcouponTransactions.contentSize.height + 300 //self.view.frame.height - 80
//
//
//            self.tblViewEcouponTransactions?.reloadSections(NSIndexSet(index: section) as IndexSet, with: .none)
//            self.bgScroll?.contentSize = CGSize(width: self.contentVIew.frame.size.width, height: self.ecouponHeightConstraint.constant + self.rewardHeightConstraint.constant + 800.0)
//
//
//            self.bgScroll?.updateConstraintsIfNeeded()
                  // Toggle collapse
                    
                 
            self.ecouponTopViewHeightConstraint.constant = 50
            self.rewardTopViewHeightConstraint.constant = 50
            self.seedTopViewheightConstrain.constant = 50
            self.seed2TopViewheightConstrain.constant = 50
            self.dsrTopViewHeightConstraint.constant = 50
            self.giftCouponHeightConstraint.constant = 50
            
     DispatchQueue.main.async {
                                                      
        self.tblViewEcouponTransactions.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
         
//        let heightConstant = CGFloat((self.successTransactionsEcoupon.count + self.claimTransactionsEcoupon.count + self.reclaimTransactionsEcoupon.count ) * 175) + CGFloat(self.couponCodesList.count*45)+125
         
         let transactionHeight = ((self.successTransactionsEcoupon.count + self.claimTransactionsEcoupon.count + self.reclaimTransactionsEcoupon.count ) * 175)
         let couponHeight = CGFloat(self.couponCodesList.count*45)

         let heightConstant = CGFloat(transactionHeight) + CGFloat(couponHeight) + CGFloat(125)
         
            self.lblNoRewardscoupon.isHidden = true
            self.tblViewEcouponTransactions.isScrollEnabled = false
            self.ecouponHeightConstraint.constant = heightConstant
                                                        
            let height1 = self.rewardHeightConstraint.constant+self.ecouponHeightConstraint.constant
            let height2 = self.seedHeightConstraint.constant+self.seed2HeightConstraint.constant+self.dsrHeightConstraint.constant
            self.bgScroll.contentSize = CGSize(width: self.view.frame.size.width, height: height1+height2+1000)
            
        }
    }
    }
    
    @IBAction func NavigationToPaymentSelection(_ sender: UITapGestureRecognizer) {
        self.reInitiatePaymentTransactionForRecord(tag: sender.view!.tag)
        
    }
    
    @IBAction func NavigationToPaymentSelectionEcoupon(_ sender: UITapGestureRecognizer) {
        self.reInitiatePaymentTransactionForRecordEcoupon(tag: sender.view!.tag)
        
    }
    @IBAction func NavigationToPaymentSelectionSeed(_ sender: UITapGestureRecognizer){
        self.reInitiatePaymentTransactionForRecordSeed(tag: sender.view!.tag)
    }
    @IBAction func NavigationToPaymentSelectionSeed2(_ sender: UITapGestureRecognizer){
        self.reInitiatePaymentTransactionForRecordSeed2(tag: sender.view!.tag)
    }
    
    @IBAction func NavigationToPaymentSelectionDSR(_ sender: UITapGestureRecognizer){
        self.reInitiatePaymentTransactionForRecordDSR(tag: sender.view!.tag)
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tblViewEcouponTransactions {
            tableView.deselectRow(at: indexPath, animated: true)
            if self.sectionNamesEcoupon[indexPath.section].itemName.lowercased() == "claim list" {
                let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
                if indexPath.row == lastRowIndex - 1 {
                    self.reInitiatePaymentTransactionForRecordEcoupon(tag: indexPath.row)
                }
                
            }
        }
        else if tableView == tblViewTransactions{
            tableView.deselectRow(at: indexPath, animated: true)
            if self.sectionNames[indexPath.section].itemName.lowercased() == "claim list" {
                let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
                if indexPath.row == lastRowIndex - 1 {
                    self.reInitiatePaymentTransactionForRecord(tag: indexPath.row)
                }
                
            }
        }
        else if tableView == tblViewSeedTransactions{
            tableView.deselectRow(at: indexPath, animated: true)
            if self.sectionNamesSeed[indexPath.section].itemName.lowercased() == "claim list" {
                let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
                if indexPath.row == lastRowIndex - 1 {
                    self.reInitiatePaymentTransactionForRecordSeed(tag: indexPath.row)
                }
            }
        }
        else if tableView == tblViewseed2Transactions{
            tableView.deselectRow(at: indexPath, animated: true)
            if self.sectionNamesSeed2[indexPath.section].itemName.lowercased() == "claim list" {
                let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
                if indexPath.row == lastRowIndex - 1 {
                    self.reInitiatePaymentTransactionForRecordSeed2(tag: indexPath.row)
                }
            }
        }
        else if tableView == tblViewDSRTransactions{
            tableView.deselectRow(at: indexPath, animated: true)
            if self.sectionNamesDSR[indexPath.section].itemName.lowercased() == "claim list" {
                let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
                if indexPath.row == lastRowIndex - 1 {
                    self.reInitiatePaymentTransactionForRecordDSR(tag: indexPath.row)
                }
            }
        }
    }
}
struct SectionDetails {
    var itemName : String  = ""
    var collapsed : Bool = true
    var sectionImage = UIImage()
}

extension UIColor {
    class var separatorColor: UIColor {
        return UIColor.lightGray
    }
}


struct ecouponCodeList {
    var ecouponCode :  String = ""
    var ecouponFarmerMapId : Int = 0
    var flag : Int = 0
    var seasonId : Int = 0
    var labelOne :  String = ""
    var valueOne :  String = ""
    var labelTwo :  String = ""
    var valueTwo :  String = ""
}

extension UIButton {
    func setImage(fromURL urlString: String, for state: UIControl.State = .normal) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.setImage(image, for: state)
            }
        }
        task.resume()
    }
}
