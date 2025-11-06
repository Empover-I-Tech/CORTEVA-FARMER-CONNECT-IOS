//
//  DelegateDostDhamakaVC.swift
//  FarmerConnect
//
//  Created by EMPOVER-049 on 12/05/22.
//  Copyright © 2022 ABC. All rights reserved.
//

import UIKit
import Alamofire

class DelegateDostDhamakaVC: BaseViewController {
    
    @IBOutlet weak var redeemNowBtn: UIButton!{
        didSet{
            redeemNowBtn.isUserInteractionEnabled = false
            redeemNowBtn.backgroundColor = .gray
            redeemNowBtn.layer.cornerRadius = 4
        }
    }
    @IBOutlet weak var couponDescriptionLBL: UILabel!
    @IBOutlet weak var couponCodeLBL: UILabel!
    @IBOutlet weak var couponCodeVW: UIView!{
        didSet{
            couponCodeVW.layer.cornerRadius = 4
        }
    }
    @IBOutlet weak var cashDisplayVW: UIView!{
        didSet{
            cashDisplayVW.layer.cornerRadius = 4
        }
    }
    @IBOutlet weak var rewardpointsLBL: UILabel!
    @IBOutlet weak var secondarMessageLBL: UILabel!
    @IBOutlet weak var secondaryMsgLBL1: UILabel!
    @IBOutlet weak var productLBL: UILabel!
    @IBOutlet weak var couponCodeTitleLBL: UILabel!
    @IBOutlet weak var backgroundImgVw: UIImageView!
    @IBOutlet weak var starImg: UIImageView!
    
    var resultsDict: NSDictionary?
    
    var timer: Timer!
    var indx = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            self.getDataFromServerForDelegateDostDhamaka()
        }else{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
        let userObj = Constatnts.getUserObject()
        if userObj.userLogsAllPrint == "true"{
            self.saveUserLogEventsDetailsToServer()
        }
        self.secondaryMsgLBL1.isHidden = true
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
                    
                    "eventName": Home_DelegateDostDhamaka,
                    "className":"DelegateDostDhamakaVC",
                    "moduleName":"DelegateDostDhamaka",
                    
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
    func getDataFromServerForDelegateDostDhamaka(){
        SwiftLoader.show(animated: true)
        let userObj = Constatnts.getUserObject()
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        var parameters = ["mobileNumber": userObj.mobileNumber! as String,"customerId": userObj.customerId! as String]
        let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
        let params =  ["data" : paramsStr]
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_DDD_COUPON_DETAILS])
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { [self] (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                    if responseStatusCode == STATUS_CODE_200{
                        
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        
                        self.resultsDict = decryptData
                        
                       // print("Response after decrypting data:\(decryptData)")
                        
                        if let couponCode = decryptData.value(forKey: "couponCode"){
                            self.couponCodeLBL.text = couponCode as? String
                        }
                        if let productName = decryptData.value(forKey: "productName"){
                            self.productLBL.text = "Product Name: \(productName)"
                        }
                        if let couponDescription = decryptData.value(forKey: "primaryRewardMsg"){
                            self.couponDescriptionLBL.text = couponDescription as? String
                        }
                        if let rewardsPoints = decryptData.value(forKey: "rewardPoints"){
                            let rupee = "\u{20B9} \(rewardsPoints) /-"
                            self.rewardpointsLBL.text = rupee
                        }
                        if let secondaryMsg = decryptData.value(forKey: "secondaryRewardMsg"){
                            self.secondarMessageLBL.text = secondaryMsg as? String
                        }
                        
                        
                        if let rewardStatus = decryptData.value(forKey: "status") as? String{
                            if rewardStatus.lowercased() == ""{
                                if let redeemNowValue = decryptData.value(forKey: "redeemNow"){
                                    if redeemNowValue as! Bool == true{
                                        self.redeemNowBtn.isHidden = false
                                        self.redeemNowBtn.isUserInteractionEnabled = true
                                        self.timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.setRandomBackgroundColor), userInfo: nil, repeats: true)
                                    }else{
                                        self.redeemNowBtn.isHidden = false
                                        self.redeemNowBtn.isUserInteractionEnabled = false
                                        self.redeemNowBtn.backgroundColor = .gray
                                    }
                                }
                            }
                            else if rewardStatus.lowercased() == "error"{
                                if let redeemNowValue = decryptData.value(forKey: "redeemNow"){
                                    if redeemNowValue as! Bool == true{
                                        self.redeemNowBtn.isUserInteractionEnabled = true
                                        self.redeemNowBtn.isHidden = false
                                        self.timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.setRandomBackgroundColor), userInfo: nil, repeats: true)
                                    }else{
                                        self.redeemNowBtn.isHidden = true
                                        self.redeemNowBtn.isUserInteractionEnabled = false
                                    }
                                }
                            }
                            else if rewardStatus.lowercased() == "success"{
                                self.redeemNowBtn.isUserInteractionEnabled = false
                                self.redeemNowBtn.isHidden = true
                                self.backgroundImgVw.image = UIImage(named: "DDD_success_bgImg")
                                self.secondarMessageLBL.font = UIFont.systemFont(ofSize: 16, weight: .bold)
                                if let secondaryMsg1 = decryptData.value(forKey: "secondaryMsg1"){
                                    self.secondaryMsgLBL1.isHidden = false
                                    self.secondaryMsgLBL1.text = secondaryMsg1 as? String
                                    self.secondaryMsgLBL1.startBlink()
                                }else{
                                    self.secondaryMsgLBL1.isHidden = true
                                    self.secondaryMsgLBL1.stopBlink()
                                }
                            }
                            else{//PENDING
                                self.redeemNowBtn.isUserInteractionEnabled = false
                                self.redeemNowBtn.isHidden = true
                                let seconds = 5.0
                                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                                    let net = NetworkReachabilityManager(host: "www.google.com")
                                    if net?.isReachable == true{
                                        let rewardsVC = self.storyboard?.instantiateViewController(withIdentifier: "RewardsViewController") as? RewardsViewController
                                        rewardsVC?.isFromHome = false
                                        rewardsVC?.isFromDelegateDostDhamaka = true
                                        self.navigationController?.pushViewController(rewardsVC!, animated: true)
                                    }
                                    else{
                                        self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                                    }
                                }
                            }
                        }
                    }
                    else if responseStatusCode == STATUS_CODE_601{
                        Constatnts.logOut()
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    }
                    else if responseStatusCode == STATUS_CODE_101{
                        self.enableDisableViewBasedOnServerData(isDisable: true)
                        let noCouponLBL : UILabel = UILabel (frame: CGRect(x: self.view.frame.origin.x,y: (self.view.frame.height/2)-60,width:self.view.frame.width,height: 40))
                        noCouponLBL.text = (json as! NSDictionary).value(forKey: "message") as? String
                        noCouponLBL.textColor = UIColor.black
                        noCouponLBL.textAlignment = NSTextAlignment.center
                        noCouponLBL.font = UIFont.systemFont(ofSize: 17.0)
                        self.backgroundImgVw.addSubview(noCouponLBL)
                    }
                    else{
                        if let message = (json as! NSDictionary).value(forKey: "message") as? String {
                            self.view.makeToast(message)
                        }
                    }
                }
            }
            else{
                self.view.makeToast((response.error?.localizedDescription)!)
            }
        }
    }
    
    func enableDisableViewBasedOnServerData(isDisable: Bool){
        self.couponCodeTitleLBL.isHidden = isDisable
        self.couponCodeLBL.isHidden = isDisable
        self.couponCodeVW.isHidden = isDisable
        self.productLBL.isHidden = isDisable
        self.couponDescriptionLBL.isHidden = isDisable
        self.cashDisplayVW.isHidden = isDisable
        self.starImg.isHidden = isDisable
        self.rewardpointsLBL.isHidden = isDisable
        self.secondarMessageLBL.isHidden = isDisable
        self.redeemNowBtn.isHidden = isDisable
    }
    
  
    @objc func setRandomBackgroundColor() {
        let colors = [
            UIColor(red: 57/255, green: 95/255, blue: 211/255, alpha: 1),
            UIColor(red: 40/255, green: 167/255, blue: 69/255, alpha: 1),
            UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        ]
        if self.indx == 3{
            self.indx = 0
            self.redeemNowBtn.backgroundColor = colors[indx]
        }else{
            self.redeemNowBtn.backgroundColor = colors[indx]
            self.indx = self.indx+1
        }
    }
    
    @IBAction func redeemnowBtnClicked(){
        self.timer.invalidate()
        self.timer = nil
        
        let claimIDsArray = NSMutableArray()
        var params = NSDictionary()
        var parameters = NSDictionary()
        
        if resultsDict != nil{
            params = [ "serverRecordId" : String(describing: resultsDict?.value(forKey: "serverRecordId") ?? ""), "benfTransactionId" : String(describing: resultsDict?.value(forKey: "benfTransactionId") ?? "") , "dsrProgramId": 0,"seadProgramId": 0, "ecouponFarmerMapId": 0]
            claimIDsArray.add(params)
            let strCashReward = resultsDict?.value(forKey: "cashRewards")
            parameters = ["cashRewards":strCashReward ?? "","claimIDs":claimIDsArray] as NSDictionary
        }
        
        
        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectModeOfTransferViewController") as? SelectModeOfTransferViewController
        toSelectPayVC?.dictEncashResponse = parameters  //dictEncashResponse
        toSelectPayVC?.isRewardClaims = true
        toSelectPayVC?.isFromSeedClaims = false
        let arrrayPayment = NSMutableArray()
        arrrayPayment.add(resultsDict?.value(forKey: "viewPaymentOptions")  as? NSArray ?? [])
        if arrrayPayment.count>0{
            toSelectPayVC?.viewPaymentOptions = arrrayPayment as? NSMutableArray ?? []
        }
        self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.topView?.isHidden = false
        self.lblTitle?.text = "Delegate Dost Dhamaka"
        self.getDataFromServerForDelegateDostDhamaka()
    }
    
    
}
extension UILabel {

    func startBlink() {
        UIView.animate(withDuration: 3.0,
              delay:0.0,
                       options:[.allowUserInteraction, .curveEaseIn, .autoreverse, .repeat],
              animations: { self.alpha = 0 },
              completion: nil)
    }

    func stopBlink() {
        layer.removeAllAnimations()
        alpha = 1
    }
}

