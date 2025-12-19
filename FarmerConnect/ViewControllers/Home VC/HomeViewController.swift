//
//  HomeViewController.swift
//  PioneerFarmerConnect
//
//  Created by Empover on 13/12/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import UIKit
import Alamofire
//import FirebaseInstanceID
import Firebase
//import UQScannerFramework
import Kingfisher
//import Acvission
//import AcvissCore
//import ZXingObjC
import EmpoverCameraScannerSDK

enum Dashboard : String {
    case HOME = "Home"
    case FEATURES_AND_BENFITS = "Hybrid Seeds"
    case CROP_PROTECTION = "Crop Protection"
    case CROP_ADVISORY = "Crop Advisory"
    case CROP_DIAGNOSIS = "Crop Diagnostic"
    case FARM_SERVICES = "Farm Services"
    case CROP_CALCULATOR = "Calculators"
    case WEATHER_REPORT = "Weather Report"
    case MANDI_PRICES = "Mandi Prices"
    case PARAMARSH = "Paramarsh"
    case NOTIFICATIONS = "Notifications"
    case GENUNITY_CHECK = "Genuinity Check"
    case GERMINATION = "Germination"
    case REWARDS = "My Rewards"
    case FARMER_DASHBOARD = "My Timeline"
    case MYBOOKLETS = "My Booklets"
    case LOGOUT = "Logout"
    case NEARBY  = "Near By"
    case REWARD_SCHEMES = "Scan"
    case SPRAY_SERVICES = "Spray Services"
    case SPRAY_VENDOR = "Spray Vendor"
    case GENUINITY_CHECKREPORT =  "Genuinity Check Results"
    case PRAVAKTA_FEEDBACK = "Pravakta Feedback"
    case CHANGE_LANGUAGE = "Language Change"
    case SHOP_SCAN_AND_EARN = "Shop, Scan & Earn"
    case REFER_A_FARMER = "Refer a Farmer"
    case CEPJOURNEY  = "Pexalon Scan 2023" //"UDAYAN"
    case RHRD  = "RHRD"
    case DDD = "DDD"
    case PLANTER_SERVICES = "Planter Services"
    case RGL_PURCHASE_ORDERS = "RGL Purchase Orders"
}

extension UIImage {
    func createSelectionIndicator(color: UIColor, size: CGSize, lineHeight: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: size.width, height: lineHeight)))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

class DashboardCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var lblTitle: UILabel!
}

class DashboardFooterCollectionView: UICollectionReusableView {
    
}



class HomeViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,LocationServiceDelegate,UITabBarDelegate , RewardsPopUpProtocol, UITextFieldDelegate ,UITableViewDelegate,UITableViewDataSource,CameraScannerDelegate {
    // AcvissionDelegate
    //, UQScannerDelegate

    var scannerView: CameraScannerView?
    
    var Weather_Base_Url =  "http://api.openweathermap.org/data/2.5/"
    var APP_ID = "7574fa662db029239e9cac49a769aa83"
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    
    var locationService : LocationService!
    var todayWeatherRequest = "weather?lat=%@&lon=%@&APPID=%@"
    
    var retailerTable  =  UITableView()
    var retailersList  =  NSArray()
    var originalRetailersList  =  NSArray()
    var searchString =  NSString()
    
    @IBOutlet weak var cloudImage: UIImageView!
    @IBOutlet var tabBar: UITabBar!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblRainType: UILabel!
    @IBOutlet var lblWeatherType: UILabel!
    @IBOutlet var lblCurrentTemperature: UILabel!
    @IBOutlet weak var newsView: UIView!
    @IBOutlet var noInternetView: UIView!
    @IBOutlet weak var dashBoardCollectionView: UICollectionView!
    @IBOutlet var newsCollectionView: UICollectionView!
    @IBOutlet weak var offersBtn: UIButton!
    @IBOutlet weak var customerSupportBtn: UIButton!

    //var scannerVc : UQScannerViewController?

    var dictEncashResponse : NSDictionary?
    var scanResponseAcviss : NSDictionary?
    var stausLogo = UIImage(named: "GenuinityFailure")
    var strCashReward = ""
    var showRetailerTable : Bool = true
    var retailerName = ""
    var retailerID = ""
    var retailerCode = ""
//    var saveScanResult : NSDictionary?
    var saveScanResult = [String: String]()
    var saveJsonString = ""
    
    @IBOutlet weak var weatherView: UIView!
    private var lastContentOffset: CGFloat = 0
    //    @IBOutlet var newsPageControl: UIPageControl!
    var dashboardDictionary = NSMutableDictionary()
    var dashboardItemsArray = NSMutableArray()
    
    var newsItemsArray = NSMutableArray()
    var loginAlertView = UIView()
    
    var showPravaktaModules = "false"
    var subscribedSprayServices = "false"
    var showCropDiagnosisStr = "false"
    var showGerminationStr = "false"
    var showBookletsStr = "false"
    var enableShopScanEarn = "false"
    var enableGenuinityCheckScanner = "false"
    var statusMsgAlert : UIView?
    var isFromOptInNotifications : Bool = false
    var optInWhatsAppMsgAlert : UIView?
    
    var cortevaNewsDocumentDirectory = NSString()
    
    var isTabItemClickeed : Bool = false
    var  i : Int = 0
    var isFromNotification  : Bool = false
    var isFromOTP : Bool = false
    let btnNotification =  Custombutton()
    
    var sprayRequestDone : Bool = false
    var bookEquipmentDone : Bool = false
    var billUploadDone : Bool = false
    var feedbackSubmissionDone : Bool = false
    
    var cropId : Int = 0
    var noOfScans : Int = 0
    var noOfAcres : Int = 0
    var isFromSprayServiceScanner : Bool = false
    
    var isFromFarmerReferral: Bool = false
    
    var isFromSideMenuShopScan: Bool = false
    
    var moduleType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = false
        
        self.checkFeedBackAvailabilityForCustomer()
        
        self.retailerTable.delegate = self
        self.retailerTable.dataSource = self
        
        let nib1 = UINib(nibName: "RetailerCell", bundle: nil)
    
        self.retailerTable.register(nib1, forCellReuseIdentifier: "retailerCell")
        
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        cortevaNewsDocumentDirectory = appdelegate.getNewsFolderPath() as NSString
        if  isFromNotification == false {    // Notification page back navigation checking while coming from NotificationCenter
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                if appdelegate.isNotificationnavigated == true && appdelegate.notificationDic != nil  {
                    self.notificationNavigationToRespectivePage()
                }
                else{
                    if let deeplinkparams = Singleton.sharedInstance.deepLinkParams as NSDictionary?{
                        self.deepLinkNavigationToRespectivePage(deeplinkparams)
                    }
                }
                
            })
        }
        
        if isFromOTP == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                let fcm = Messaging.messaging().fcmToken
                if fcm != nil  && fcm != "" {
                    print(fcm)
                    HomeViewController.fireBasePusnoticicatinsIdRegistrationWithUser(gcmId: fcm ?? "")
                }
            })
        }
        
        
        let date = Date()
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        
        let userObj = Constatnts.getUserObject()
        
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_PENDING_PROFILE_UPDATE_STATUS])
        Alamofire.request(urlString, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    if (json as! NSDictionary).value(forKey: "statusCode") as? String ?? "" != ""{
                        let responseStatusCode = (json as? NSDictionary)?.value(forKey: "statusCode") as? String ?? ""
                        if responseStatusCode == STATUS_CODE_200{
                            let respData = (json as? NSDictionary)?.value(forKey: "response") as? NSString
                            let decryptData  = Constatnts.decryptResult(StrJson: respData as String? ?? "")
                            
                            appdelegate.isCropsUpdated = decryptData.value(forKey: "cropArea") as? Bool ?? false
                            appdelegate.isCompaniesUpdated = decryptData.value(forKey: "customerCompany") as? Bool ?? false
                            appdelegate.isIrrigationsUpdated = decryptData.value(forKey: "customerIrrigation") as? Bool ?? false
                            appdelegate.isSeasonsUpdated = decryptData.value(forKey: "customerSeason") as? Bool ?? false
                            appdelegate.isTotalCropUpdated = decryptData.value(forKey: "totalCropArea") as? Bool ?? false
                            
                            if !appdelegate.isCropsUpdated || !appdelegate.isCompaniesUpdated || !appdelegate.isIrrigationsUpdated || !appdelegate.isSeasonsUpdated || !appdelegate.isTotalCropUpdated {
                                //                            if UserDefaults.standard.value(forKey: "userRegisteredDate") == nil{
                                var userRegisteredDate = UserDefaults.standard.value(forKey: "userRegisteredDate") as? String? ?? dateFormatterGet.string(from: date)
                                
                                let userDisplayedDate = UserDefaults.standard.value(forKey: "shownDate") as? String? ?? dateFormatterGet.string(from: date)
                                
                                if userRegisteredDate == nil {
                                    UserDefaults.standard.set(dateFormatterGet.string(from: date), forKey: "userRegisteredDate")
                                    
                                    userRegisteredDate = UserDefaults.standard.value(forKey: "userRegisteredDate") as? String? ?? dateFormatterGet.string(from: date)
                                    
                                }
                                if  userDisplayedDate == nil  && dateFormatterGet.string(from: date) != userRegisteredDate {
                                    self.loginAlertView = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: "Alert" as NSString, message: "Do You Want To Update Your Profile?" as NSString, okButtonTitle: "Yes", cancelButtonTitle: "No") as! UIView
                                    self.view.addSubview(self.loginAlertView)
                                    
                                }else{
                                    if Constatnts.timeGapBetweenDates(previousDate: userRegisteredDate!, currentDate: dateFormatterGet.string(from: date)) > 0{
                                        if dateFormatterGet.string(from: date) != userDisplayedDate {
                                            self.loginAlertView = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: "Alert" as NSString, message: "Do You Want To Update Profile?" as NSString, okButtonTitle: "Yes", cancelButtonTitle: "No") as! UIView
                                            self.view.addSubview(self.loginAlertView)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
                
            }
            
        }
        
        Singleton.syncingPendigCropCalculationsToServer()
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.viewWillAppear(_:)), name: NSNotification.Name(rawValue: "UpdateDashboard"), object: nil)
        self.recordScreenView("HomeViewController", Home_Screen)
        self.registerFirebaseEvents(PV_Home_Screen, "", "", "", parameters: nil)
        let optInStr = NSLocalizedString("Opt-in_for_WhatsApp?", comment: "")
        let whats_app_optInStr = NSLocalizedString("click_for_WhatsApp_optIn", comment: "")
        let whats_app_optIn = NSLocalizedString("Opt-in_for_WhatsApp", comment: "")
        let maybelaterStr = NSLocalizedString("Might_be_later", comment: "")
        let Opt_In = NSLocalizedString("Opt-In", comment: "")
        tabBar.selectedItem = tabBar.items![0]
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor(red: 74.0/255.0, green: 193.0/255.0, blue: 86.0/255.0, alpha: 1.0), size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height: tabBar.frame.height), lineHeight: 2.0)
        
        newsCollectionView.decelerationRate = UIScrollViewDecelerationRate.init()
        centeredCollectionViewFlowLayout = (newsCollectionView.collectionViewLayout as! CenteredCollectionViewFlowLayout)
        
        //        centeredCollectionViewFlowLayout.itemSize = CGSize(
        //            width: newsCollectionView.bounds.size.width-40, height: newsCollectionView.bounds.size.height
        //        )
        
        centeredCollectionViewFlowLayout.minimumLineSpacing = 10
        
//        self.getNewsFromServer() // stop calling new from server as per teja told new changes
        var firstLoginTimeInDay = ""
        let optInWhastsapp = userObj.optInWhatsApp! as String
        if optInWhastsapp == "false" && isFromOptInNotifications == false{
            if UserDefaults.standard.value(forKey: "firstLoginTime") != nil && optInWhastsapp == "false"{
                firstLoginTimeInDay = UserDefaults.standard.value(forKey: "firstLoginTime") as? String ?? ""
                
                
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"
                
                
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "dd-MMM-yyyy HH:mm:ss"
                
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = "dd-MMM-yyyy"
                
                
                let dateFormatter2 = DateFormatter()
                dateFormatter2.dateFormat = "dd-MMM-yyyy"
                
                var createdOnDate = ""
                var previousDate = Date()
                if let createdOnStr = firstLoginTimeInDay as? String {
                    let dateArr = createdOnStr.components(separatedBy: " ") as NSArray
                    let dateObj2 = dateArr.object(at: 0)
                    print(dateObj2)
                    
                    let dateFormatterGet = DateFormatter()
                    dateFormatterGet.dateFormat = "dd-MMM-yyyy"
                    
                    let dateFormatter3 = DateFormatter()
                    dateFormatter3.dateFormat = "dd-MMM-yyyy"
                    
                    if Validations.isNullString(dateObj2 as! NSString) == false{
                        previousDate = dateFormatterGet.date(from: dateObj2 as! String)!
                        print(dateFormatter3.string(from: date as Date))
                        createdOnDate = dateFormatter3.string(from: date as Date)
                    }
                }
                let dateFormatter4 = DateFormatter()
                dateFormatter4.dateFormat = "dd-MMM-yyyy"
                //   let previousDate =  dateFormatter4.date(from: createdOnDate)
                let currentDateSting1 = dateFormatter2.string(from: Date())
                let currentDate =  dateFormatter4.date(from: currentDateSting1 )!
                
                let currentDateSting = dateFormatter.string(from: Date())
                //            let previousDate =  dateFormatter1.date(from: firstLoginTimeInDay)
                //            let previousLogin = dateFormatter1.string(from:previousDate ?? Date() )
                
                
                
                let startDate = dateFormatter.date(from: currentDateSting)!
                if dateFormatterPrint.date(from: firstLoginTimeInDay )! != nil{
                    let endDate = dateFormatterPrint.date(from: firstLoginTimeInDay )!
                    
                    if endDate != nil && startDate != nil && previousDate  != nil && currentDate != nil {
                        if  endDate < startDate  && previousDate != currentDate {
                            
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            self.optInWhatsAppMsgAlert = CustomAlert.WhatsAppOptInPopup(self, frame: appDelegate.window?.frame ?? self.view.frame, title: (optInStr as NSString?)!, message: whats_app_optInStr as NSString , buttonTitle1: maybelaterStr as NSString , buttonTitle2: Opt_In as NSString, hideClose: true ) as? UIView
                            let dateFormatterPrint = DateFormatter()
                            dateFormatterPrint.dateFormat = "dd-MMM-yyyy HH:mm:ss"
                            let date = dateFormatterPrint.string(from: Date())
                            UserDefaults.standard.setValue(date, forKey: "firstLoginTime")
                            UserDefaults.standard.synchronize()
                            appDelegate.window?.rootViewController?.view.addSubview(self.optInWhatsAppMsgAlert!)
                            
                        }else if  endDate == startDate {
                            print("❌")
                        }
                        
                    }
                }
            }else {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                self.optInWhatsAppMsgAlert = CustomAlert.WhatsAppOptInPopup(self, frame: appDelegate.window?.frame ?? self.view.frame, title: (whats_app_optIn as NSString?)!, message: whats_app_optInStr as NSString, buttonTitle1: maybelaterStr as NSString, buttonTitle2: Opt_In as NSString, hideClose: true ) as? UIView
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "dd-MMM-yyyy HH:mm:ss"
                
                let date = dateFormatterPrint.string(from: Date())
                UserDefaults.standard.setValue(date, forKey: "firstLoginTime")
                UserDefaults.standard.synchronize()
                appDelegate.window?.rootViewController?.view.addSubview(self.optInWhatsAppMsgAlert!)
            }
        } else if isFromOptInNotifications == true && optInWhastsapp == "false" {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            self.optInWhatsAppMsgAlert = CustomAlert.WhatsAppOptInPopup(self, frame: appDelegate.window?.frame ?? self.view.frame, title: (whats_app_optIn as NSString?)!, message: whats_app_optInStr as NSString, buttonTitle1:maybelaterStr as NSString, buttonTitle2: Opt_In as NSString, hideClose: true ) as? UIView
            let dateFormatterPrint = DateFormatter()
            //                                               dateFormatterPrint.dateFormat = "dd-MMM-yyyy HH:mm:ss"
            //
            //                                               let date = dateFormatterPrint.string(from: Date())
            //                                               UserDefaults.standard.setValue(date, forKey: "firstLoginTime")
            //                                               UserDefaults.standard.synchronize()
            appDelegate.window?.rootViewController?.view.addSubview(self.optInWhatsAppMsgAlert!)
        }
        if isFromFarmerReferral == true {
            //self.openGenunityCheckScanner()
            self.moduleType = "Genuinity Check"
            //self.openAcvission()
            self.openEmpoverScanner()
        }
    }
    
    func checkandUpdateIfAnyOfflineUserLogEventsToServer(){
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            var mutArray = appDelegate.getUserLogEventsModulewiseFromDB("UserLogEventsModuleWise")
            
            var pendingOfflineLogs = [NSDictionary]()
            
            if mutArray.count != 0{
                for obj in mutArray{
                    var eachObj = obj as? UserLogEvents
                    let dict = [
                        "mobileNumber": eachObj?.mobileNumber,
                        "deviceId":eachObj?.deviceId,
                        "deviceType": eachObj?.deviceType,
                        "customerId": eachObj?.customerId,
                        "logTimeStamp":eachObj?.logTimeStamp,
                        "pincode": eachObj?.pincode,
                        "districtLoggedin": eachObj?.districtLoggedin,
                        "stateLoggedin": eachObj?.stateLoggedin,
                        "stateName":eachObj?.stateName,
                        "marketName":eachObj?.marketName,
                        "commodity":eachObj?.commodity,
                        "eventName": eachObj?.eventName,
                        "className": eachObj?.className,
                        
                        "moduleName": eachObj?.moduleName,
                        "healthCardId": eachObj?.healthCardId,
                        "productId": eachObj?.productId,
                        "cropId": eachObj?.cropId,
                        "seasonId":eachObj?.seasonId,
                        "otherParams":eachObj?.otherParams,
                        "isOnlineRecord":eachObj?.isOnlineRecord] as? NSDictionary
                    
                    pendingOfflineLogs.append(dict!)
                }
                let parameters = ["userModuleUsageLogs":pendingOfflineLogs] as? NSDictionary
                userLogEventsSingletonClass.sendUserLogEventsDetailsToServer(dictionary: parameters ?? NSDictionary()){ (status, statusMessage) in
                    if status == true{
                        appDelegate.deleteUserLogEventsModulewiseFromDB()
                    }else{
                        self.view.makeToast(statusMessage as String? ?? "")
                    }
                }
            }
            
        }
    }
    
    func saveUserLogEventsDetailsToServer(isFromModule: String){
        var moduleName = ""
        var eventName = ""
        if isFromModule == "ShopScanWin"{
            moduleName = "ShopScanWin"
            eventName = Home_ShopScanWin
        }
        else if isFromModule == "GenuinityCheck"{
            moduleName = "Genuinity_Check"
            eventName = Home_Genuinity_Check
        }
        else if isFromModule == "ReferFarmer"{
            moduleName = "ReferFarmers"
            eventName = ReferFarmer
        }
        
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
            
            "eventName": eventName,
            "className":"HomeViewController",
            "moduleName": moduleName,
            
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
    func gotoProfileScreen(){
        //  MyProfileViewController
        
        let toProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController
        self.navigationController?.pushViewController(toProfileVC!, animated: true)
        
    }
    
    @objc func alertYesBtnAction(){
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let date = Date()
        
        UserDefaults.standard.set(dateFormatterGet.string(from: date), forKey: "shownDate")
        
        self.gotoProfileScreen()
    }
    
    @objc func alertNoBtnAction(){
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let date = Date()
        
        UserDefaults.standard.set(dateFormatterGet.string(from: date), forKey: "shownDate")
        
        loginAlertView.removeFromSuperview()
    }
    
    @objc func  alertMaybeLaterButton(){
        self.optInWhatsAppMsgAlert?.removeFromSuperview()
        
        
    }
    @objc func  infoCloseButtonOptIn(){
        
        self.optInWhatsAppMsgAlert?.removeFromSuperview()
        
    }
    @objc func  alertOptInButton(){
        
        
        
        let userObj = Constatnts.getUserObject()
        
        let headers : HTTPHeaders =  ["authKey" : AUTHKEY_OLDUSER , "methodName" : METHODNAME_OLDUSER ,"sharedWith" : SHAREWITH  ]
        
        let params  : Parameters =  ["mobileNumber" :  userObj.mobileNumber as String? ?? ""]
        
        SwiftLoader.show(animated: true)
        
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,WHATSUP_OPT_IN_REGISTRATION])
        
        
        Alamofire.request(urlString, method: .post, parameters: params , encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "Status") as? String
                    if responseStatusCode == STATUS_CODE_1{
                        
                        
                        
                        let dateFormatterPrint = DateFormatter()
                        dateFormatterPrint.dateFormat = "dd-MMM-yyyy HH:mm:ss"
                        
                        let date = dateFormatterPrint.string(from: Date())
                        UserDefaults.standard.setValue(date, forKey: "firstLoginTime")
                        UserDefaults.standard.synchronize()
                        userObj.optInWhatsApp = "true"
                        self.optInWhatsAppMsgAlert?.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    func getNewsFromServer(){
        SwiftLoader.show(animated: true)
        
        let newsURL = String(format: "%@%@", NEWS_BASEURL,GET_NEWS_FROM_DOTNET_SERVER)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        Alamofire.request(newsURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            SwiftLoader.hide()
            
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let respData = response.result.value as? NSDictionary
                    if respData?.value(forKey: "respCd") as? Int == STATUS_CODE_100{
                        
                        let respData1 = (respData!.value(forKey: "data") as! NSString)//.replacingOccurrences(of: "\\", with: "")
                        //                        print("respData :\(respData1)")
                        if let data = respData1.data(using: String.Encoding.utf8.rawValue) {
                            do {
                                let outputDict = try JSONSerialization.jsonObject(with: data, options: [])
                                if let responseDic = outputDict as? NSDictionary{
                                    //    self.newsItemsArray.addObjects(from: responseDic.value(forKey: "newsList") as! [Any])
                                    if let arrNews = responseDic.value(forKey: "newsList") as? NSArray{
                                        Constatnts.deleteCoreDataEntity(entityName: "NewsEntity")
                                        
                                        for i in (0..<arrNews.count){
                                            let newsDict = arrNews.object(at: i) as! NSDictionary
                                            let newsObj = NewsEntityDetails(dict: newsDict)
                                            
                                            appDelegate.saveNewsRecords(newsObj)
                                        }
                                        
                                        self.newsItemsArray.removeAllObjects()
                                        self.newsItemsArray = appDelegate.getOfflineNews()
                                        self.newsCollectionView.reloadData()
                                        self.newsCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionViewScrollPosition.left, animated: true)
                                        self.newsView.isHidden = true //false as per new changes teja told hiden this
                                    }
                                    else{
                                        self.newsItemsArray.removeAllObjects()
                                        
                                        self.newsItemsArray = appDelegate.getOfflineNews()
                                        
                                        if self.newsItemsArray.count > 0 {
                                            self.newsCollectionView.reloadData()
                                            self.newsView.isHidden = true //false as per new changes teja told hiden this
                                            
                                        }else{
                                            self.newsView.isHidden = true
                                        }
                                    }
                                }
                            }
                            catch{
                                self.newsItemsArray.removeAllObjects()
                                
                                self.newsItemsArray = appDelegate.getOfflineNews()
                                
                                if self.newsItemsArray.count > 0 {
                                    self.newsCollectionView.reloadData()
                                    //                                    self.newsView.isHidden = true
                                    
                                }else{
                                    self.newsView.isHidden = true
                                }
                            }
                        }
                    }
                }
                else{
                    self.newsItemsArray.removeAllObjects()
                    
                    self.newsItemsArray = appDelegate.getOfflineNews()
                    
                    if self.newsItemsArray.count > 0 {
                        self.newsCollectionView.reloadData()
                        //                        self.newsView.isHidden = true
                        
                    }else{
                        self.newsView.isHidden = true
                    }
                }
            }
            else{
                self.newsItemsArray.removeAllObjects()
                
                self.newsItemsArray = appDelegate.getOfflineNews()
                
                if self.newsItemsArray.count > 0 {
                    self.newsCollectionView.reloadData()
                    //                    self.newsView.isHidden = true
                    
                }else{
                    self.newsView.isHidden = true
                    
                }
            }
        }
    }
    
    func refreshTodayWeatherData(){
        locationService = LocationService()
        if let prevLocation = CLLocationManager().location as CLLocation?{
            self.getCurrentDayWeatherReportServiceCall(String(format : "%f",prevLocation.coordinate.latitude), String(format : "%f",prevLocation.coordinate.longitude))
        }
        if (!CLLocationManager.locationServicesEnabled() || CLLocationManager.authorizationStatus() == .denied)
        {
            let alert : UIAlertController = UIAlertController(title: "Location access", message: "In order to be notified, please open this app's settings and enable location access", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url as URL)
                }
            }
            alert.addAction(openAction)
            // self.present(alert, animated: true, completion: nil)
        }
        else{
            locationService.delegate = self
            locationService.locationManager?.requestLocation()
            guard let currentLocation = LocationService.sharedInstance.currentLocation?.coordinate else {
                return
            }
            self.getCurrentDayWeatherReportServiceCall(String(format : "%f",currentLocation.latitude), String(format : "%f",currentLocation.longitude))
        }
    }
    
    func getCurrentDayWeatherReportServiceCall(_ latitude: String?, _ longitude:String?){
        //        SwiftLoader.show(animated: true)
        
        let currentDayTempUrl = String(format: "%@%@", Base_Url,String(format: todayWeatherRequest, latitude ?? 0.0, longitude ?? 0.0, APP_ID))
        Alamofire.request(currentDayTempUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            //            SwiftLoader.hide()
            // print("Result:\(String(describing: response.result.value))")
            let responseDic = response.result.value as? NSDictionary
            if response.result.error == nil{
                let todayWeather = Weather(dict: responseDic!)
                self.lblCurrentTemperature.text =  String(format: "%@\u{00b0}", Constatnts.getTemparatureFromValue(tempDouble: todayWeather.currentTemparature))
                self.weatherView.isHidden = true//false teja told to hide
                
                // print((todayWeather.currentTemparature ?? 0.0 - 273.15))
                self.lblLocation.text =  todayWeather.cityName as String!
                self.lblWeatherType.text = todayWeather.w_main as String!
                self.lblRainType.text = todayWeather.w_description as String!
                
                let imageUrl = String(format: "%@%@.png", Weather_Image_Url,(todayWeather.w_icon)!)
                self.cloudImage.downloadImageFrom(link: imageUrl, contentMode: .scaleToFill)
                
            }else{
                self.weatherView.isHidden = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setStatusBarBackgroundColor(color :App_Theme_Blue_Color)
        if #available(iOS 11.0, *) {
            self.automaticallyAdjustsScrollViewInsets = true
        }
        else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
       // self.refreshTodayWeatherData()
        self.newsCollectionView.isHidden = true //as per teja told we kept it hide
        self.navigationController?.navigationBar.isHidden = false
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.tempDictToSaveReqDetails = nil
        appDelegate.previousLocationStr = ""
        
        if  appDelegate.isOpennedGenuinityCheckFromSidemMenu {
            
            appDelegate.isOpennedGenuinityCheckFromSidemMenu = false
           // openGenunityCheckScanner()
            self.moduleType = "Genuinity Check"
            //self.openAcvission()
            self.openEmpoverScanner()
            
        }
        
        if  appDelegate.isOpennedGenuinityCheckFromOffers {
            
            appDelegate.isOpennedGenuinityCheckFromOffers = false
           // openGenunityCheckScanner()
            self.moduleType = "Spray Service"
            //self.openAcvission()
            self.openEmpoverScanner()
            
        }
        
        if  appDelegate.isOpennedCropAdvisoryFromSidemMenu {
            
            appDelegate.isOpennedCropAdvisoryFromSidemMenu = false
            cropAdvisoryOptionSelectionActionSheetControl()
            
        }
        self.weatherView.isHidden = true
        
        self.topView?.isHidden = false
        self.homeButton?.isHidden = true
        self.lblTitle?.text = NSLocalizedString("home", comment: "")
        self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
       
        let userObj = Constatnts.getUserObject()
        let userObj1 : User =  Constatnts.getUserObject()

        let btnAbout = UIButton(frame: CGRect(x:self.topView!.frame.size.width-82,y: 10,width: 30,height: 30))
        btnAbout.backgroundColor =  UIColor.clear
        btnAbout.setImage( UIImage(named: "question"), for: UIControlState())
        btnAbout.addTarget(self, action: #selector(self.gotoAboutScreen(_:)), for: UIControlEvents.touchUpInside)
        self.topView?.addSubview(btnAbout)
        
        if userObj.notification == "true"{
        btnNotification.frame = CGRect(x:UIScreen.main.bounds.size.width-42,y: self.topView!.frame.size.height -  50,width: 45,height: 45)
        btnNotification.backgroundColor =  UIColor.clear
        btnNotification.setImage( UIImage(named: "Notification"), for: UIControlState())
        btnNotification.addTarget(self, action: #selector(self.gotoNotificationsScreen(_:)), for: UIControlEvents.touchUpInside)
        self.topView?.addSubview(btnNotification)
        }
        
        
        showCropDiagnosisStr = userObj.showCropDiagnosis! as String
        showBookletsStr = userObj.pravaktaMyBooklets! as String
        enableShopScanEarn = userObj.enableShopScanWin! as String
        enableGenuinityCheckScanner = userObj.enableGenuinityCheckresults as! String
        showPravaktaModules = userObj.pravakta! as String
        subscribedSprayServices = userObj.subscribedSprayServices! as String
        
        if userObj.userLogsAllPrint == "true"{
        self.checkandUpdateIfAnyOfflineUserLogEventsToServer()
        }
        self.setUserMenuForDashboard()
        
        var notificationlastSyncTimeStr = ""
        if UserDefaults.standard.value(forKey: "lastSyncTime") != nil{
            notificationlastSyncTimeStr = UserDefaults.standard.value(forKey: "lastSyncTime") as! String
        }
        
        
        let notificationParameters = ["lastUpdated":notificationlastSyncTimeStr,
                                      "deviceToken": userObj.deviceToken as String,
                                      "mobileNo": userObj.mobileNumber! as String,
                                      "customerId": userObj.customerId! as String,
                                      "deviceId": userObj.deviceId! as String] as? NSDictionary
        
        let paramsJWT = Constatnts.nsobjectToJSON(notificationParameters!)
        let notificationParams =  ["data": paramsJWT]
        PushNotificationServiceManager.requestToGetUnreadNotificationsCount(Params: notificationParams) { (status) in
            DispatchQueue.main.async {
                self.btnNotification.badgeTextColor = UIColor.white
                self.btnNotification.badgeBGColor = UIColor.red
                self.btnNotification.badgeFont = UIFont(name: "system", size: 3.0)
                self.btnNotification.badgeOriginX = (self.btnNotification.frame.size.width -  20)
                if unReadnotifications != "0" {
                    self.btnNotification.badge?.text = unReadnotifications
                    self.btnNotification.setBadgeValue(badgeValue: unReadnotifications)
                    self.btnNotification.refreshBadge()
                    //           self.notificationButton?.initializer()
                    print("ghjgg;lk")
                    self.btnNotification.updateBadgeValue(animated: true)
                }else {
                    self.btnNotification.removeBadge()
                }
            }
        }
        if  appDelegate.isOpenedShopScanEarnFromSideMenu {
            appDelegate.isOpenedShopScanEarnFromSideMenu = false
          //  openGenunityCheckScanner()
            self.moduleType = "Shop Scan & Earn"
            //self.openAcvission()
            self.openEmpoverScanner()
        }
        if appDelegate.isOpenedGenuinityCheckResultsFromSideMenu{
            appDelegate.isOpenedGenuinityCheckResultsFromSideMenu = false
            let net = NetworkReachabilityManager(host: "www.google.com")
            if net?.isReachable == true{
                let genuinityCheckReportsVC = self.storyboard?.instantiateViewController(withIdentifier: "GenuinityCheckReportsViewController") as? GenuinityCheckReportsViewController
                genuinityCheckReportsVC?.isFromHome = true
                self.navigationController?.pushViewController(genuinityCheckReportsVC!, animated: true)
            }
            else{
                self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
            }
        }
    }
    
    func setUserMenuForDashboard(){
        
        guard let items = tabBar.items else { return }
       // items[0].title = NSLocalizedString("Grower_Engagement", comment: "")
        items[0].title = NSLocalizedString("home", comment: "")
//        items[1].title = NSLocalizedString("Grower_Engagement", comment: "")
        items[1].title = NSLocalizedString("Services", comment: "")
        items[2].title = NSLocalizedString("rewards", comment: "")
        
        //var GrowerEngagementArray = NSMutableArray()
        var productsArray = NSMutableArray()
        var servicesArray = NSMutableArray()
        var rewardsArray = NSMutableArray()
        let userObj = Constatnts.getUserObject()
        
        //Products Array Data
        if userObj.hybridSeeds == "true"{
            let diction1 = NSMutableDictionary()
            diction1.setValue(NSLocalizedString("hybrid_Seeds", comment: ""), forKey: "name")
            diction1.setValue(Dashboard.FEATURES_AND_BENFITS.rawValue, forKey: "image")
            productsArray.add(diction1)
        }
        
        if userObj.cropProtection == "true"{
            let diction = NSMutableDictionary()
            diction.setValue(NSLocalizedString("Crop_Protection", comment: ""), forKey: "name") // NSLocalizedString("features", comment: "")
            diction.setValue(Dashboard.CROP_PROTECTION.rawValue, forKey: "image")
            productsArray.add(diction)
        }
        if userObj.nearBy == "true"{
            let dictionOthers = NSMutableDictionary()
            dictionOthers.setValue(NSLocalizedString("nearby", comment: ""), forKey: "name")
            dictionOthers.setValue(Dashboard.NEARBY.rawValue, forKey: "image")
            productsArray.add(dictionOthers)
        }
        if userObj.genuinityCheck == "true"{
            let diction2 = NSMutableDictionary()
            diction2.setValue(NSLocalizedString("genuinity_check", comment: ""), forKey: "name")
            diction2.setValue(Dashboard.GENUNITY_CHECK.rawValue, forKey: "image")
            productsArray.add(diction2)
        }
//        if userObj.rglPurchaseOrder == "true"{
//            let diction22 = NSMutableDictionary()
//            diction22.setValue(NSLocalizedString("rglPurchaseOrder", comment: ""), forKey: "name")
//            diction22.setValue(Dashboard.RGL_PURCHASE_ORDERS.rawValue, forKey: "image")
//            productsArray.add(diction22)
//        }
        //As it is not there in android we are hiding this code
//        if userObj.pravaktaFeedback == "true"{
//            let diction14 = NSMutableDictionary()
//            diction14.setValue("Pravakta Feedback", forKey: "name")
//            diction14.setValue(Dashboard.PRAVAKTA_FEEDBACK.rawValue, forKey: "image")
//            productsArray.add(diction14)
//        }
//        
//        if Validations.isNullString(userObj.pravakta!) == false{
//            if showPravaktaModules == "true"{
//               if enableGenuinityCheckScanner == "true"{
//                    let dictionary3 = NSMutableDictionary()
//                    dictionary3.setValue("Genuinity Check Results", forKey: "name")
//                    dictionary3.setValue(Dashboard.GENUINITY_CHECKREPORT.rawValue, forKey: "image")
//                    productsArray.add(dictionary3)
//                }
//            }
//        }
        
        //ServicesArray
         if userObj.cropAdvisory == "true"{
             let diction3 = NSMutableDictionary()
             diction3.setValue(NSLocalizedString("crop_advisory", comment: ""), forKey: "name")
             diction3.setValue(Dashboard.CROP_ADVISORY.rawValue, forKey: "image")
             servicesArray.add(diction3)
         }
         
//        if userObj.farmServices == "true"{
//            let diction4 = NSMutableDictionary()
//            diction4.setValue(NSLocalizedString("farm_services", comment: ""), forKey: "name")
//            diction4.setValue(Dashboard.FARM_SERVICES.rawValue, forKey: "image")
//            servicesArray.add(diction4)
//        }
        if userObj.mandiPrices == "true"{
            let diction5 = NSMutableDictionary()
            diction5.setValue(NSLocalizedString("mandi_prices", comment: ""), forKey: "name")
            diction5.setValue(Dashboard.MANDI_PRICES.rawValue, forKey: "image")
            servicesArray.add(diction5)
        }
         
        if userObj.cropCalculator == "true"{
            let diction6 = NSMutableDictionary()
            diction6.setValue(NSLocalizedString("crop_calculator", comment: ""), forKey: "name")
            diction6.setValue(Dashboard.CROP_CALCULATOR.rawValue, forKey: "image")
            servicesArray.add(diction6)
        }
        if userObj.farmerDashboard == "true"{
            let diction7 = NSMutableDictionary()
            diction7.setValue(NSLocalizedString("farmer_Dashboard", comment: ""), forKey: "name")
            diction7.setValue(Dashboard.FARMER_DASHBOARD.rawValue, forKey: "image")
            servicesArray.add(diction7)
        }
        if userObj.pravaktaMyBooklets == "true"{
         let diction11 = NSMutableDictionary()
         diction11.setValue(NSLocalizedString("my_booklets", comment: ""), forKey: "name")
         diction11.setValue(Dashboard.MYBOOKLETS.rawValue, forKey: "image")
            servicesArray.add(diction11)
        }
        if userObj.sprayVendor == "true"{
            let diction12 = NSMutableDictionary()
            diction12.setValue(NSLocalizedString("Spray_Vendor", comment: ""), forKey: "name")
            diction12.setValue(Dashboard.SPRAY_VENDOR.rawValue, forKey: "image")
            servicesArray.add(diction12)
        }
         
        if userObj.enableSprayService == "true" {
            let diction13 = NSMutableDictionary()
            diction13.setValue(NSLocalizedString("Spray_Service", comment: ""), forKey: "name")
            diction13.setValue(Dashboard.SPRAY_SERVICES.rawValue, forKey: "image")
            servicesArray.add(diction13)
        }
        if userObj.planterServices == "true" || userObj.planterServicesVendor == "true" {
            let diction14 = NSMutableDictionary()
            diction14.setValue(NSLocalizedString("planter_services", comment: ""), forKey: "name")
            diction14.setValue(Dashboard.PLANTER_SERVICES.rawValue, forKey: "image")
            servicesArray.add(diction14)
        }
         //CEPJOURNEY
//        if  userObj.cepJourney == "true" ||  userObj.cepJourney == ""{
//            let diction19 = NSMutableDictionary()
//            diction19.setValue(NSLocalizedString("cep_Udayan", comment: ""), forKey: "name")
//            diction19.setValue(Dashboard.CEPJOURNEY.rawValue, forKey: "image")
//            GrowerEngagementArray.add(diction19)
//        }
         
         //RHRD
//        if  userObj.rhrdJourney == "true" ||  userObj.rhrdJourney == ""{
//            let diction20 = NSMutableDictionary()
//            diction20.setValue(NSLocalizedString("rhrd_title", comment: ""), forKey: "name")
//            diction20.setValue(Dashboard.RHRD.rawValue, forKey: "image")
//            GrowerEngagementArray.add(diction20)
//        }
        //Delegate Dost Dhamaka
//        if userObj.delegateDostDhamaka == "true"{
//        let diction21 = NSMutableDictionary()
//        diction21.setValue(NSLocalizedString("ddd_title", comment: ""), forKey: "name")
//        diction21.setValue(Dashboard.DDD.rawValue, forKey: "image")
//        GrowerEngagementArray.add(diction21)
//        }
         
//        if Validations.isNullString(userObj.pravakta!) == false{
//            if showPravaktaModules == "true"{
//                let diction14 = NSMutableDictionary()
//                diction14.setValue("Pravakta Feedback", forKey: "name")
//                diction14.setValue(Dashboard.PRAVAKTA_FEEDBACK.rawValue, forKey: "image")
//                servicesArray.add(diction14)
//                
//            }
//        }
         
        if userObj.rewards == "true"{
         let diction8 = NSMutableDictionary()
         diction8.setValue(NSLocalizedString("rewards", comment: ""), forKey: "name")
         diction8.setValue(Dashboard.REWARDS.rawValue, forKey: "image")
         rewardsArray.insert(diction8, at: 0)
        }
         
         if userObj.showRewardsScheme == "true"{
             let diction9 = NSMutableDictionary()
             diction9.setValue(NSLocalizedString("reward_schemes", comment: ""), forKey: "name")
             diction9.setValue(Dashboard.REWARD_SCHEMES.rawValue, forKey: "image")
             rewardsArray.add(diction9)
         }
         
        if userObj.enableShopScanWin == "true"{
         let diction15 = NSMutableDictionary()
         diction15.setValue(NSLocalizedString("shop_scan_earn", comment: ""), forKey: "name")
         diction15.setValue(Dashboard.SHOP_SCAN_AND_EARN.rawValue, forKey: "image")
         rewardsArray.add(diction15)
         }
        
        if userObj.referFarmer == "true"{
            let diction16 = NSMutableDictionary()
            diction16.setValue(NSLocalizedString("Refer_a_Farmer", comment: ""), forKey: "name")
            diction16.setValue(Dashboard.REFER_A_FARMER.rawValue, forKey: "image")
            rewardsArray.add(diction16)
        }
         
        
        if Validations.isNullString(userObj.showCropDiagnosis!) == true{
//            if showCropDiagnosisStr == "true"{
                let diction10 = NSMutableDictionary()
                diction10.setValue(NSLocalizedString("crop_diagnostic", comment: ""), forKey: "name")
                diction10.setValue(Dashboard.CROP_DIAGNOSIS.rawValue, forKey: "image")
                servicesArray.insert(diction10, at: 1)
                
//            }
        }
        
        showGerminationStr = userObj.showGermination! as String
        if showGerminationStr == "true"{
            
        }
        
        let dicProducts = NSMutableDictionary()
        dicProducts.setValue(NSLocalizedString("products", comment: ""), forKey: "Title")
        dicProducts.setValue(productsArray, forKey: "Items")
        
//        let dicgrowerEngagement = NSMutableDictionary()
//        dicgrowerEngagement.setValue(NSLocalizedString("Grower_Engagement", comment: ""), forKey: "Title")
//        dicgrowerEngagement.setValue(GrowerEngagementArray, forKey: "Items")
        
        let dicServices = NSMutableDictionary()
        dicServices.setValue("Services", forKey: "Title")
        dicServices.setValue(servicesArray, forKey: "Items")
        
        let dictRewards = NSMutableDictionary()
        dictRewards.setValue(NSLocalizedString("rewards", comment: ""), forKey: "Title")
        dictRewards.setValue(rewardsArray, forKey: "Items")
        
        if userObj.offersBtn == "true"{
            self.offersBtn.isHidden = false
        }else{
            self.offersBtn.isHidden = true
        }
        
        if userObj.paramarsh == "true"{
            self.customerSupportBtn.isHidden = false
        }else{
            self.customerSupportBtn.isHidden = true
        }
        
        if userObj.weatherReport == "true"{
            self.weatherView.isHidden = true//false teja told to hide
        }else{
            self.weatherView.isHidden = true
        }
        
        dashboardItemsArray.removeAllObjects()
        dashboardItemsArray.add(dicProducts)
       // dashboardItemsArray.add(dicgrowerEngagement)
        dashboardItemsArray.add(dicServices)
        dashboardItemsArray.add(dictRewards)
        dashBoardCollectionView.reloadData()
    }
    @objc func gotoAboutScreen (_ sender: UIButton) {
        
        let toOnBoardScreen = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as? PageContentViewController
        toOnBoardScreen?.isFromHome = true
        self.navigationController?.pushViewController(toOnBoardScreen!, animated: true)
    }
    
    @objc func gotoNotificationsScreen (_ sender: UIButton) {
        
        let toNotificationsVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsViewController") as? NotificationsViewController
        self.navigationController?.pushViewController(toNotificationsVC!, animated: true)
    }
    
    override func backButtonClick(_ sender: UIButton) {
        self.findHamburguerViewController()?.showMenuViewController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkFeedBackAvailabilityForCustomer(){
        let userObj = Constatnts.getUserObject()
        let headers : HTTPHeaders = ["userAuthorizationToken": userObj.userAuthorizationToken! as String,"mobileNumber":userObj.mobileNumber! as String,"customerId": userObj.customerId! as String,"deviceToken":userObj.deviceToken as String,"deviceId":userObj.deviceId! as String]
        //print(headers)
        SwiftLoader.show(animated: true)
        let urlString = String(format: "%@%@", arguments: [BASE_URL,Check_FeedBack_Availability])
        let parameters = ["customerId":userObj.customerId ?? ""] as [String : Any]
        let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
        let params =  ["data" : paramsStr]
        print(params)
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String) as NSDictionary?
                        if decryptData != nil{
                            let feedBack = Feedback(dict: decryptData!)
                            let feedbackController = self.storyboard?.instantiateViewController(withIdentifier: "FeedbackViewController") as? FeedbackViewController
                            feedbackController?.selectedFeedback = feedBack
                            if Validations.isNullString(feedBack.equipmentTransactionId ?? "") == false{
                                let navController = UINavigationController(rootViewController: feedbackController!)
                                self.navigationController?.present(navController, animated: true, completion: nil)
                            }
                        }
                        // print("Response after decrypting data:\(String(describing: decryptData))")
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
    class func fireBasePusnoticicatinsIdRegistrationWithUser(gcmId: String){
        if let isLogin = UserDefaults.standard.value(forKey: "login") as? Bool{
            if isLogin == true && Constatnts.getCustomerId() > 0{
                let userObj = Constatnts.getUserObject()
                
                
                
                if Validations.isNullString(gcmId as NSString) == false{
                    //print("InstanceID token: \(refreshedToken)")
                    //let dictionary = Bundle.main.infoDictionary!
                    //let appVersion = dictionary["CFBundleShortVersionString"] as! String
                    //let build = dictionary["CFBundleVersion"] as! String
                    //print("Device Id: \(User_Deviceid)")
                    let parameteers : NSDictionary = ["customerId":userObj.customerId!,"deviceToken":gcmId,"deviceId":userObj.deviceId!,"deviceType" : userObj.deviceType,"mobileNumber": userObj.mobileNumber!] as [String : Any] as NSDictionary
                    let paramsStr = Constatnts.nsobjectToJSON(parameteers as NSDictionary)
                    let params =  ["data" : paramsStr]
                    Alamofire.request(String(format: "%@%@",BASE_URL,User_DeviceToken_registration), method: .post, parameters: params, encoding:JSONEncoding.default, headers: nil).responseJSON { (response) in
                        //                                SwiftLoader.hide()
                        if let JSON = response.result.value
                        {
                            print("Response hghhhh:\(JSON)")
                            let responseStatusCode = (JSON as! NSDictionary).value(forKey: "statusCode") as! String
                            if responseStatusCode == STATUS_CODE_200{
                                userObj.deviceToken = gcmId as NSString
                                Constatnts.setUserToUserDefaults(user: userObj)
                                let respData = (JSON as! NSDictionary).value(forKey: "response") as! NSString
                                let decryptData  = Constatnts.decryptResult(StrJson: respData as String) as NSDictionary?
                                //print("Response after decrypting data:\(String(describing: decryptData))")
                            }
                            else{
                                //self.present(Validations.showModalAlertView((Validations.checkKeyNotAvail(responseDic!, key: "message") as? NSString)!, okTitle: "Ok", okHandler: { _ in }), animated: true, completion: nil)
                            }
                        }
                        //let responseDic = JSON as? NSDictionary
                    }
                }
                
                
                //                if let refreshedToken = InstanceID.instanceID().token() {
                //
                //                }
            }
        }
    }
    class func fireBasePusnoticicatinsIdRegistrationWithUser(){
        if let isLogin = UserDefaults.standard.value(forKey: "login") as? Bool{
            if isLogin == true && Constatnts.getCustomerId() > 0{
                let userObj = Constatnts.getUserObject()
                
                //                    InstanceID.instanceID().instanceID { (result, error) in
                //                        if let error = error {
                //                            print("Error fetching remote instange ID: \(error)")
                //                        } else if let result = result {
                //                            print("Remote instance ID token: \(result.token)")
                //                            let refreshedToken = result.token
                //
                //                            if Validations.isNullString(refreshedToken as NSString) == false{
                //                                //print("InstanceID token: \(refreshedToken)")
                //                                //let dictionary = Bundle.main.infoDictionary!
                //                                //let appVersion = dictionary["CFBundleShortVersionString"] as! String
                //                                //let build = dictionary["CFBundleVersion"] as! String
                //                                //print("Device Id: \(User_Deviceid)")
                //                                let parameteers : NSDictionary = ["customerId":userObj.customerId!,"deviceToken":refreshedToken,"deviceId":userObj.deviceId!,"deviceType" : userObj.deviceType,"mobileNumber": userObj.mobileNumber!] as [String : Any] as NSDictionary
                //                                let paramsStr = Constatnts.nsobjectToJSON(parameteers as NSDictionary)
                //                                let params =  ["data" : paramsStr]
                //                                Alamofire.request(String(format: "%@%@",BASE_URL,User_DeviceToken_registration), method: .post, parameters: params, encoding:JSONEncoding.default, headers: nil).responseJSON { (response) in
                //    //                                SwiftLoader.hide()
                //                                    if let JSON = response.result.value
                //                                    {
                //    print("Response bvhyjkkkkl:\(JSON)")
                //                                        let responseStatusCode = (JSON as! NSDictionary).value(forKey: "statusCode") as! String
                //                                        if responseStatusCode == STATUS_CODE_200{
                //                                            userObj.deviceToken = refreshedToken as NSString
                //                                            Constatnts.setUserToUserDefaults(user: userObj)
                //                                            let respData = (JSON as! NSDictionary).value(forKey: "response") as! NSString
                //                                            let decryptData  = Constatnts.decryptResult(StrJson: respData as String) as NSDictionary?
                //                                            //print("Response after decrypting data:\(String(describing: decryptData))")
                //                                        }
                //                                        else{
                //                                            //self.present(Validations.showModalAlertView((Validations.checkKeyNotAvail(responseDic!, key: "message") as? NSString)!, okTitle: "Ok", okHandler: { _ in }), animated: true, completion: nil)
                //                                        }
                //                                    }
                //                                    //let responseDic = JSON as? NSDictionary
                //                                }
                //                            }
                //                        }
                //                    }
                
                Messaging.messaging().token { token, error in
                    if let error = error {
                        print("Error fetching remote instange ID: \(error)")
                    } else if let result = token {
                        print("Remote instance ID token: \(token)")
                        let refreshedToken = token
                        
                        if Validations.isNullString(refreshedToken as? NSString ?? "") == false{
                            
                            let parameteers : NSDictionary = ["customerId":userObj.customerId!,"deviceToken":refreshedToken,"deviceId":userObj.deviceId!,"deviceType" : userObj.deviceType,"mobileNumber": userObj.mobileNumber!] as [String : Any] as NSDictionary
                            let paramsStr = Constatnts.nsobjectToJSON(parameteers as NSDictionary)
                            let params =  ["data" : paramsStr]
                            Alamofire.request(String(format: "%@%@",BASE_URL,User_DeviceToken_registration), method: .post, parameters: params, encoding:JSONEncoding.default, headers: nil).responseJSON { (response) in
                                
                                if let JSON = response.result.value
                                {
                                    print("Response bvhyjkkkkl:\(JSON)")
                                    let responseStatusCode = (JSON as! NSDictionary).value(forKey: "statusCode") as! String
                                    if responseStatusCode == STATUS_CODE_200{
                                        userObj.deviceToken = refreshedToken as? NSString ?? ""
                                        Constatnts.setUserToUserDefaults(user: userObj)
                                        let respData = (JSON as! NSDictionary).value(forKey: "response") as! NSString
                                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String) as NSDictionary?
                                        
                                    }
                                    else{
                                        
                                    }
                                }
                                //let responseDic = JSON as? NSDictionary
                            }
                        }
                    }
                }
                
            }
        }
    }
    func notificationNavigationToRespectivePage(){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        if appdelegate.isNotificationnavigated == true {
            appdelegate.isNotificationnavigated = false
            if appdelegate.notificationDic != nil {
                self.notificationsHandlerNavigation(notificationDic: appdelegate.notificationDic!)
                appdelegate.notificationDic = nil
            }
        }
    }
    
    func deepLinkNavigationToRespectivePage(_ deepLinkParams:NSDictionary?){
        if Singleton.sharedInstance.isFromDeepLink == true {
            Singleton.sharedInstance.isFromDeepLink = false
            if Singleton.sharedInstance.deepLinkParams != nil {
                self.deeplinkHandlerNavigation(deepLinkParams: deepLinkParams as! [String : AnyObject])
                Singleton.sharedInstance.deepLinkParams = nil
            }
        }
        
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

    
    //MARK: checkDiseaseImageFileAvailable
    func checkDiseaseImageFileAvailable(imageURLStr: String) -> String{
        
        if Validations.validateUrl(urlString: imageURLStr as NSString) == false && Validations.isNullString(imageURLStr as NSString) == false {
            let docPath = self.getDocumentPath(imageURLStr as NSString)
            let isFileExists = self.checkIfFileExists(atPath: docPath as String)
            if isFileExists == true {
                return docPath as String
            }
            else{
                if Reachability.isConnectedToNetwork() {
                    //let imgURL =  NSURL(string: imageURLStr)
                    self.downloadAssetAndStore(inDocumentsDirectory: imageURLStr as NSString)
                    return imageURLStr
                }
            }
        }
        return imageURLStr
    }
    
    //MARK: getDocumentPath
    func getDocumentPath(_ assetStr: NSString) -> NSString {
        let assetArray = assetStr.components(separatedBy: "/") as NSArray
        let filePath = String(format: "%@/%@", cortevaNewsDocumentDirectory,assetArray.lastObject as! NSString) as NSString
        return filePath
    }
    
    //MARK: downloadAssetAndStore
    func downloadAssetAndStore(inDocumentsDirectory assetStr: NSString) {
        //SwiftLoader.show(animated: true)
        let docPath = self.getDocumentPath(assetStr)
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let url = NSURL(fileURLWithPath: docPath as String)
            return (url as URL, [.removePreviousFile])
        }
        Alamofire.download(assetStr as String, to: destination).response { response in
            if response.destinationURL != nil {
                //                SwiftLoader.hide()
                //print(response.destinationURL!)
                //print("disease image file saved when clicked")
            }
        }
    }
    
    //MARK: checkIfFileExists
    func checkIfFileExists(atPath strPath: String) -> Bool {
        let fileExists: Bool = FileManager.default.fileExists(atPath: strPath)
        return fileExists
    }
    
    //MARK: collectionView datasource and delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == newsCollectionView {
            return 1
        }else{
            return dashboardItemsArray.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == newsCollectionView {
            return newsItemsArray.count
        }else{
            
            let dict : NSDictionary = dashboardItemsArray.object(at:section) as! NSDictionary
            let arr : NSArray =  dict["Items"] as? NSArray ?? []
            return arr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == dashBoardCollectionView{
            switch kind {
            
            case UICollectionElementKindSectionHeader:
                
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "dashboardHeader", for: indexPath as IndexPath) as? DashboardCollectionReusableView
                
                let dict : NSDictionary = dashboardItemsArray.object(at: indexPath.section) as! NSDictionary
                headerView!.lblTitle.text = dict["Title"] as? String
                return headerView!
                
            case UICollectionElementKindSectionFooter:
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "dashboardFooter", for: indexPath as IndexPath) as? DashboardFooterCollectionView
                footerView?.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
                
                return footerView!
                
            default:
                break
            //assert(false, "Unexpected element kind")
            }
            
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == newsCollectionView{
            return CGSize(width: 0, height: 0)
        }
        else{
            return CGSize(width: collectionView.frame.width, height: 30)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if collectionView == newsCollectionView{
            return CGSize(width: 0, height: 0)
        }
        else{
            return CGSize(width: collectionView.frame.width, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == newsCollectionView {
            let cell = self.newsCollectionView.dequeueReusableCell(withReuseIdentifier: "newsCell", for: indexPath) as! NewsCell
            //            let dictNews = newsItemsArray.object(at: indexPath.row) as? NSDictionary
            let newsData = newsItemsArray.object(at: indexPath.row) as? NewsEntityDetails
            cell.dashboardImg.contentMode = .scaleAspectFit
            cell.dashboardImg.image = UIImage(named:"image_placeholder.png")
            cell.dashboardImg.backgroundColor = UIColor.red
            let productImgURL = self.checkDiseaseImageFileAvailable(imageURLStr: newsData?.value(forKey: "imagePath") as! String)
            if productImgURL != "" {
                cell.dashboardImg.isHidden = false
                cell.imgConstraint.constant = 82
                DispatchQueue.main.async {
                    if productImgURL.hasPrefix("http") || productImgURL.hasPrefix("https") {
                        //let imageUrl = URL(string: cropImgURL)
                        cell.dashboardImg.kf.setImage(with: productImgURL as? Resource , placeholder: UIImage(named:"image_placeholder.png"), options: nil, progressBlock: nil)
                    }
                    else{
                        cell.dashboardImg.image = UIImage(contentsOfFile: (productImgURL))
                    }
                }
            }else {
                cell.dashboardImg.isHidden = true
                cell.imgConstraint.constant = 0
            }
            cell.lblTitle.text = newsData?.value(forKey: "newsType") as? String
            cell.lblDesc.textAlignment = .left
            cell.lblDesc.text =  newsData?.value(forKey: "newsDescription") as? String
            return cell
            
        }else{
            let cell = self.dashBoardCollectionView.dequeueReusableCell(withReuseIdentifier: "DashboardCell", for: indexPath)
            
            let dict : NSDictionary = dashboardItemsArray.object(at: indexPath.section) as! NSDictionary
            let array : NSArray = dict["Items"] as? NSArray ?? []
            let dictionary : NSDictionary = array[indexPath.row] as? NSDictionary ?? [:]
            
            let dashboardImg = cell.contentView.viewWithTag(100) as! UIImageView
            dashboardImg.image = UIImage(named:dictionary.value(forKey: "image") as? String ?? "")
            
            let titleLbl = cell.contentView.viewWithTag(101) as! UILabel
            titleLbl.text = dictionary.value(forKey: "name") as? String ?? ""
            
            if #available(iOS 13.0, *) {
                switch UIScreen.main.traitCollection.userInterfaceStyle {
                case .dark:
                    cell.contentView.backgroundColor = UIColor.black
                    break // put your dark mode code here
                case .light:
                    cell.contentView.backgroundColor = UIColor.white
                    break
                case .unspecified:
                    break
                }
            }
            
            
            cell.contentView.layer.borderColor = UIColor(red: 230.0/255.0, green: 238.0/255.0, blue: 252.0/255.0, alpha: 1.0).cgColor
            cell.contentView.layer.borderWidth = 0.4
            //            cell.contentView.layer.cornerRadius = 5.0
            
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == newsCollectionView {
            //return CGSize(width: collectionView.bounds.size.width-45, height: collectionView.bounds.size.height)
            return CGSize(width: UIScreen.main.bounds.size.width-45, height: collectionView.bounds.size.height)
        }else{
            
            return CGSize(width: collectionView.bounds.size.width/3, height: collectionView.bounds.size.width/3);
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //        return UIEdgeInsetsMake(15, 10, 10, 10)//top,left,bottom,right
        
        if collectionView == newsCollectionView {
            return UIEdgeInsetsMake(0, 0, 0, -5)
        }else{
            return UIEdgeInsetsMake(0, 0, 0, 0)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == newsCollectionView {
            return 0
        }else{
            return 0//10
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == newsCollectionView {
            return -10
        }else{
            return 0
        }
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        cell.alpha = 0
        UIView.animate(withDuration: 0.8) {
            cell.alpha = 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let net = NetworkReachabilityManager(host: "www.google.com")
        if collectionView == dashBoardCollectionView {
            
            let dict : NSDictionary = dashboardItemsArray.object(at: indexPath.section) as! NSDictionary
            let array : NSArray = dict["Items"] as? NSArray ?? []
            let dictionary : NSDictionary = array[indexPath.row] as? NSDictionary ?? [:]
            
            if dictionary.value(forKey: "image") as? String == "Farm Services" {
                if net?.isReachable == true{
                    self.farmservicesOptionSelectionActionSheetControl()
                }
                else{
                    self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                }
            }
            else if dictionary.value(forKey: "image") as? String == "Crop Advisory" {
                self.cropAdvisoryOptionSelectionActionSheetControl()
            }
            else if dictionary.value(forKey: "image") as? String == "Mandi Prices"{
                if net?.isReachable == true{
                    let toFABVC = self.storyboard?.instantiateViewController(withIdentifier: "MandisAndCropsDashboard") as? MandisAndCropsDashboard
                    toFABVC?.isFromHome = true
                    self.navigationController?.pushViewController(toFABVC!, animated: true)
                }
                else{
                    self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                }
            }
            else if dictionary.value(forKey: "image") as? String == "Pexalon Scan 2023"{//"UDAYAN"{
                if net?.isReachable == true{
                    let toFABVC = self.storyboard?.instantiateViewController(withIdentifier: "CEPLandingViewController") as? CEPLandingViewController
                    toFABVC?.isFromHome = true
                    self.navigationController?.pushViewController(toFABVC!, animated: true)
                }
                else{
                    self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                }
            }
            
            else if dictionary.value(forKey: "image") as? String == "RHRD"{
                if net?.isReachable == true{
                    let toFABVC = self.storyboard?.instantiateViewController(withIdentifier: "RHRDLandingViewController") as? RHRDLandingViewController
                     toFABVC?.isFromHome = true
                    self.navigationController?.pushViewController(toFABVC!, animated: true)
                }
                else{
                    self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                }
            }
            //DelegateDostDhamaka
            else if dictionary.value(forKey: "image") as? String == "DDD"{
                if net?.isReachable == true{
                    let toDDDVC = self.storyboard?.instantiateViewController(withIdentifier: "DelegateDostDhamakaVC") as? DelegateDostDhamakaVC
                    self.navigationController?.pushViewController(toDDDVC!, animated: true)
                }
                else{
                    self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                }
            }
            
            //RHRD_Home
            else if dictionary.value(forKey: "image") as? String == "Pravakta Feedback"{
                if net?.isReachable == true{
                    let toFABVC = self.storyboard?.instantiateViewController(withIdentifier: "PravaktaFeedbackViewController") as? PravaktaFeedbackViewController
                    toFABVC?.isFromHome = true
                    self.navigationController?.pushViewController(toFABVC!, animated: true)
                }
                else{
                    self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                }
            }else if dictionary.value(forKey: "image") as? String == "Genuinity Check Results"{
                if net?.isReachable == true{
                    let genuinityCheckReportsVC = self.storyboard?.instantiateViewController(withIdentifier: "GenuinityCheckReportsViewController") as? GenuinityCheckReportsViewController
                    genuinityCheckReportsVC?.isFromHome = true
                    self.navigationController?.pushViewController(genuinityCheckReportsVC!, animated: true)
                }
                else{
                    self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                }
            }
            else if dictionary.value(forKey: "image") as? String == "Genuinity Check"{
                self.moduleType = "Genuinity Check"
                let userObj = Constatnts.getUserObject()
                if userObj.userLogsGenuinityPrint == "true"{
                self.saveUserLogEventsDetailsToServer(isFromModule: "GenuinityCheck")
                }
                //self.openAcvission()
                self.openEmpoverScanner()
            }else if dictionary.value(forKey: "image") as? String == "Scan"{
                self.moduleType = "Genuinity Check"
                //self.openAcvission()
                self.openEmpoverScanner()
            }else if dictionary.value(forKey: "image") as? String == "Shop, Scan & Earn"{
                self.moduleType = "Shop Scan & Earn"
                let userObj = Constatnts.getUserObject()
                if userObj.userLogsGenuinityPrint == "true"{
                self.saveUserLogEventsDetailsToServer(isFromModule: "ShopScanWin")
                }
                //self.openAcvission()
                self.openEmpoverScanner()
            }
            else if dictionary.value(forKey: "image") as? String == "Hybrid Seeds"{
                self.hybridOptionSelectionActionSheetControl()
//                let toFABVC = self.storyboard?.instantiateViewController(withIdentifier: "FABViewController") as? FABViewController
//                toFABVC?.isFromHome = true
//                self.navigationController?.pushViewController(toFABVC!, animated: true)
            }
            else if dictionary.value(forKey: "image") as? String == "Crop Protection"{
                let toFABVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectCropAndProductViewController") as? SelectCropAndProductViewController
                toFABVC?.isFromHome = true
                self.navigationController?.pushViewController(toFABVC!, animated: true)
            }
            else if dictionary.value(forKey: "image") as? String == "Calculators"{
                if net?.isReachable == true{
                    let toCalculationsVC = self.storyboard?.instantiateViewController(withIdentifier: "CalculatorHomeViewController") as? CalculatorHomeViewController
                    toCalculationsVC!.isFromHome = true
                    self.navigationController?.pushViewController(toCalculationsVC!, animated: true)
                }
                else{
                    self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                }
            }
            
            else if dictionary.value(forKey: "image") as? String == "Crop Diagnostic"{
                let diagnosisVC = self.storyboard?.instantiateViewController(withIdentifier: "CropDiagnosis_ViewController") as? CropDiagnosis_ViewController
                diagnosisVC?.isFromHome = true
                self.navigationController?.pushViewController(diagnosisVC!, animated: true)
            }
            else if dictionary.value(forKey: "image") as? String == "My Rewards"{
                if net?.isReachable == true{
                    let rewardsVC = self.storyboard?.instantiateViewController(withIdentifier: "RewardsViewController") as? RewardsViewController
                    rewardsVC?.isFromHome = true
                    self.navigationController?.pushViewController(rewardsVC!, animated: true)
                }
                else{
                    self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                }
            }
            else if dictionary.value(forKey: "image") as? String == "RGL Purchase Orders"{
                if net?.isReachable == true{
                    let rewardsVC = self.storyboard?.instantiateViewController(withIdentifier: "RGLProductsListVC") as? RGLProductsListVC
                    rewardsVC?.isFromHome = true
                    self.navigationController?.pushViewController(rewardsVC!, animated: true)
                }
                else{
                    self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                }
            }
            else if dictionary.value(forKey: "image") as? String == "Near By"{
                if net?.isReachable == true{
                    let rewardsVC = self.storyboard?.instantiateViewController(withIdentifier: "NearByViewController") as? NearByViewController
                    rewardsVC?.isFromHome = true
                    self.navigationController?.pushViewController(rewardsVC!, animated: true)
                }
                else{
                    self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                }
            }
            else if dictionary.value(forKey: "image") as? String == "Spray Vendor"{
                if net?.isReachable == true{
                    let rewardsVC = self.storyboard?.instantiateViewController(withIdentifier: "SprayOrdersViewController") as? SprayOrdersViewController
                    rewardsVC?.isFromHome = true
                    self.navigationController?.pushViewController(rewardsVC!, animated: true)
                }
                else{
                    self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                }
            }else if dictionary.value(forKey: "image") as? String == "Spray Services"{
                if net?.isReachable == true{
                    let userObj = Constatnts.getUserObject()
                    //                        if userObj.subscribedSprayServices == "true" {
                    //                            let sprayVC = self.storyboard?.instantiateViewController(withIdentifier: "SprayServicesStagesViewController") as? SprayServicesStagesViewController
                    //                            self.navigationController?.pushViewController(sprayVC!, animated: true)
                    //                        }else {
                    //                        let sprayVC = self.storyboard?.instantiateViewController(withIdentifier: "SprayServiceViewController") as? SprayServiceViewController
                    //                        self.navigationController?.pushViewController(sprayVC!, animated: true)
                    //                        }
                    let params : Parameters = ["cropId" : 0 ,"cropName" : "" ]
                    self.getUserSubscriptionStages(Params: params)
                }
                else{
                    self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                }
            }
            else if dictionary.value(forKey: "image") as? String == "Planter Services"{
                if net?.isReachable == true{
                    let userObj = Constatnts.getUserObject()
//                    if userObj.planterServices == "true"{
//                        let plantVC = self.storyboard?.instantiateViewController(withIdentifier: "PSSprayServicesStagesViewController") as? PSSprayServicesStagesViewController
//                        self.navigationController?.pushViewController(plantVC!, animated: true)
//                   }
                     if userObj.planterServicesVendor == "true"{
                        let planterServiceProvider = self.storyboard?.instantiateViewController(withIdentifier: "PlanterOrdersViewController") as? PlanterOrdersViewController
                        self.navigationController?.pushViewController(planterServiceProvider!, animated: true)
                    }
                    else{
                        let plantVC = self.storyboard?.instantiateViewController(withIdentifier: "PSSprayServicesStagesViewController") as? PSSprayServicesStagesViewController
                            self.navigationController?.pushViewController(plantVC!, animated: true)
                    }
                }
                else{
                    self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                }
            }
            else if dictionary.value(forKey: "image") as? String == "My Timeline" {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                //        appDelegate.myOrientation = .landscape
                appDelegate.myOrientation = .portrait
                let userObj = Constatnts.getUserObject()
                
                let headers = Constatnts.getLoggedInFarmerHeaders()
                var userId = "0"
                if let customerId = headers["customerId"] as String? {
                    userId = customerId
                }
                
                let farmerMobileNumber = userObj.mobileNumber as String?
                let farmerName = userObj.firstName as String?
                
                self.registerFirebaseEvents(Farmer_UserDashboard_GraphView_Screen, farmerMobileNumber ?? "Customer", userId ?? "0", "HomeViewController", parameters: nil)
                
                let farmerDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "FarmerTimeLineVerticalViewController") as? FarmerTimeLineVerticalViewController
                farmerDetailsVC!.farmerMobileNumber = farmerMobileNumber
                farmerDetailsVC!.farmerName = farmerName
                farmerDetailsVC!.isFromHome = true
                self.navigationController?.pushViewController(farmerDetailsVC!, animated: true)
            }else if dictionary.value(forKey: "image") as? String == "My Booklets" {
                let bookletsVC = self.storyboard?.instantiateViewController(withIdentifier: "BookletsViewController") as? BookletsViewController
                bookletsVC!.isFromHome = true
                self.navigationController?.pushViewController(bookletsVC!, animated: true)
            }else if dictionary.value(forKey: "image") as? String == "Refer a Farmer"{
                let userObj = Constatnts.getUserObject()
                if userObj.userLogsAllPrint == "true"{
                self.saveUserLogEventsDetailsToServer(isFromModule: "ReferFarmer")
                }
                let message = "Hi! I am sharing you Farmer Connect app. Using this link you can scan and earn rewards."
                
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyMMddHHmmssZ"
                let formattedDate = dateFormatter.string(from: date)
                
                
                var deepLink = userObj.deepLinkingString
                var formattedDeepLink = ""
                if deepLink != nil && ((deepLink?.contains("fcContent")) != nil){
                    formattedDeepLink = deepLink?.replacingOccurrences(of: "fcContent", with: formattedDate) as! String
                }else{
                    return
                }
                let items = [message,formattedDeepLink] as [Any]
                let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                present(ac, animated: true)
            }
        }
        else{
            
            let newsData = self.newsItemsArray.object(at: indexPath.row) as? NewsEntityDetails
            let newsDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "newsDetails") as? NewsDetailsViewController
            newsDetailsVC?.newsData = newsData
            self.navigationController?.pushViewController(newsDetailsVC!, animated: true)
            
        }
    }
    
    @IBAction func gotoWeatherReportsScreen(_ sender: Any) {
        let net = NetworkReachabilityManager(host: "www.google.com")
        
        if net?.isReachable == true{
            let toWeatherVC = self.storyboard?.instantiateViewController(withIdentifier: "WeatherReportViewController") as? WeatherReportViewController
            //toWeatherVC?.isFromHome = true
            UserDefaults.standard.set(true, forKey: "isFromHome")
            UserDefaults.standard.synchronize()
            self.navigationController?.pushViewController(toWeatherVC!, animated: true)
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
        
    }
    
    
    //MARK: LocationDelegate methods
    func tracingLocation(_ currentLocation: CLLocation) {
        self.getCurrentDayWeatherReportServiceCall(String(format : "%f",currentLocation.coordinate.latitude), String(format : "%f",currentLocation.coordinate.longitude))
        locationService.stopUpdatingLocation()
    }
    
    func tracingLocationDidFailWithError(_ error: NSError) {
        
    }
    
    //MARK: checkGermination
    func checkGermination(){
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            GerminationServiceManager.getGerminationList(completionHandler: { (success,responseDict,errorMessage) in
                if success == true{
                    if let germinationFarmersDataObj = responseDict?.value(forKey: "germinationFarmersData") as? NSArray{
                        if germinationFarmersDataObj.count > 0{
                            if germinationFarmersDataObj.count == 1{
                                let germinationListDict = GerminationList(dict: germinationFarmersDataObj.object(at: 0) as! NSDictionary)
                                print(germinationListDict)
                                let statusObj = (germinationFarmersDataObj.object(at: 0) as! NSDictionary).value(forKey: "status") as! String
                                if statusObj == STATUS_AGREEMENT_PENDING{
                                    let toGerminationAgreementVC = self.storyboard?.instantiateViewController(withIdentifier: "GerminationAgreementViewController") as? GerminationAgreementViewController
                                    toGerminationAgreementVC?.germinationModelObj = germinationListDict
                                    toGerminationAgreementVC?.isFromHome = true
                                    self.navigationController?.pushViewController(toGerminationAgreementVC!, animated: true)
                                }
                                else{
                                    let listArray = NSMutableArray()
                                    //var germinationListDict: GerminationList?
                                    let germinationListDict = GerminationList(dict: germinationFarmersDataObj.object(at: 0) as! NSDictionary)
                                    listArray.add(germinationListDict)
                                    print(listArray)
                                    let toGerminationListVC = self.storyboard?.instantiateViewController(withIdentifier: "GerminationListViewController") as? GerminationListViewController
                                    toGerminationListVC?.germinationListArray = listArray
                                    toGerminationListVC?.isFromHome = true
                                    self.navigationController?.pushViewController(toGerminationListVC!, animated: true)
                                }
                            }
                            else{
                                let listArray = NSMutableArray()
                                var germinationListDict: GerminationList?
                                for i in 0..<germinationFarmersDataObj.count{
                                    germinationListDict = GerminationList(dict: germinationFarmersDataObj.object(at: i) as! NSDictionary)
                                    listArray.add(germinationListDict!)
                                }
                                print(listArray)
                                let toGerminationListVC = self.storyboard?.instantiateViewController(withIdentifier: "GerminationListViewController") as? GerminationListViewController
                                toGerminationListVC?.germinationListArray = listArray
                                toGerminationListVC?.isFromHome = true
                                self.navigationController?.pushViewController(toGerminationListVC!, animated: true)
                            }
                        }
                    }
                }
                else{
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.makeToast(errorMessage ?? "")
                }
            })
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
    }
    

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
        
        Singleton.submitScannedUniquoBarcodeResultDataToServerNew(scanResult: result.dictionary, userMessage: message, completeResponse: jsonString, selectedLabel: "") { (status, responseDictionary, statusMessage) in
            
            if status == true{
                self.dictEncashResponse = NSDictionary()
                print(responseDictionary)
                self.dictEncashResponse = responseDictionary ?? NSDictionary()
                if self.isFromSprayServiceScanner == true {
                    let delegate = UIApplication.shared.delegate as? AppDelegate
                    delegate!.numberOfScans = delegate!.numberOfScans + 1
                    let params : Parameters = ["noOfScans": delegate!.numberOfScans , "cropId" : self.cropId]
                    
                    if self.noOfAcres >= delegate!.numberOfScans {
                        self.submitNumberScanningsCount(Params: params)
                    }
                    
                }
                
                
                //            self.statusMsgAlert = CustomAlert.genunityCheckResultPopup(self, frame: self.view.frame, title: ("Genuinity Check" as NSString?)!, message: responseDictionary?.value(forKey: "uq_message") as? NSString ?? "N/A", buttonTitle: "OK", imgCorteva:  UIImage(named:"corteva")!, statusLogo: ststusLogo!, hideClose: true,rewardMessage: responseDictionary?.value(forKey: "primaryRewardMsg" as? NSString ?? "N/A"),rewardMessage1: responseDictionary?.value(forKey: "secondaryRewardMsg" as? NSString ?? "N/A"), showEncashBtn: true) as? UIView
                var strCashReward = ""
                if self.dictEncashResponse?.value(forKey: "rewardPoints") as? String != "" && self.dictEncashResponse?.value(forKey: "rewardPoints")  != nil {
                    let rupee = "\u{20B9} "
                    
                    strCashReward  = String(format: "Cash Back : %@%@/-",rupee,self.dictEncashResponse?.value(forKey: "rewardPoints") as? CVarArg ?? "")
                }else {
                    strCashReward = ""
                }
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                if statusMessage == STATUS_CODE_205{
                    /* let selectLableVC = self.storyboard?.instantiateViewController(withIdentifier: "RewardsPopupVC") as? RewardsPopupVC
                     selectLableVC?.delegate = self
                     selectLableVC?.dictEncashResponse = self.dictEncashResponse
                     selectLableVC?.labelsArray = responseDictionary?.value(forKey: "unUsedPacketLabels") as? [String] ?? []
                     self.navigationController?.pushViewController(selectLableVC!, animated: true)*/
                    
                    let selectLableVC = self.storyboard?.instantiateViewController(withIdentifier: "RewardsPopupVC") as! RewardsPopupVC
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
        // var scanResult = self.dictEncashResponse?.value(forKey: "complete_response")
        //let paramsStr = try! JSONSerialization.data(withJSONObject: scanResult, options: .prettyPrinted)
        
        //let jsonString = NSString(data: paramsStr, encoding: String.Encoding.utf8.rawValue)! as String
        
        // print("String result    \(jsonString)")
        let dict = convertToDictionary(text: scanResult as! String)
        Singleton.submitScannedUniquoBarcodeResultDataToServerNew(scanResult: dict, userMessage: "", completeResponse: scanResult as! String, selectedLabel: selectedLable ) { (status, responseDictionary, statusMessage) in
            if status == true{
                self.dictEncashResponse = NSDictionary()
                print(responseDictionary)
                self.dictEncashResponse = responseDictionary ?? NSDictionary()
                if self.isFromSprayServiceScanner == true {
                    let delegate = UIApplication.shared.delegate as? AppDelegate
                    delegate!.numberOfScans = delegate!.numberOfScans + 1
                    let params : Parameters = ["noOfScans": delegate!.numberOfScans , "cropId" : self.cropId]
                    
                    if self.noOfAcres >= delegate!.numberOfScans {
                        self.submitNumberScanningsCount(Params: params)
                    }
                    
                }
                //            self.statusMsgAlert = CustomAlert.genunityCheckResultPopup(self, frame: self.view.frame, title: ("Genuinity Check" as NSString?)!, message: responseDictionary?.value(forKey: "uq_message") as? NSString ?? "N/A", buttonTitle: "OK", imgCorteva:  UIImage(named:"corteva")!, statusLogo: ststusLogo!, hideClose: true,rewardMessage: responseDictionary?.value(forKey: "primaryRewardMsg" as? NSString ?? "N/A"),rewardMessage1: responseDictionary?.value(forKey: "secondaryRewardMsg" as? NSString ?? "N/A"), showEncashBtn: true) as? UIView
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
    
    @objc func infoSprayServices(){
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if self.noOfAcres == delegate!.numberOfScans {
            if statusMsgAlert != nil{
                self.statusMsgAlert?.removeFromSuperview()
            }
            let retailerInfoVC = self.storyboard?.instantiateViewController(withIdentifier: "RetailerInformationViewController") as? RetailerInformationViewController
            retailerInfoVC?.cropID = cropId
            self.navigationController?.pushViewController(retailerInfoVC!, animated: true)
        }else {
            let noOfScans = self.noOfAcres  - delegate!.numberOfScans
            self.view.makeToast("Please scan remaining" +  " " + "\(noOfScans)" +  " " + "coupons to Bill upload")
        }
    }
    
    
    
    
    //    @IBAction func sprayserviceProductNavigation(_ sender : UIButton){
    //         let retailerInfoVC = self.storyboard?.instantiateViewController(withIdentifier: "OffersViewController") as? OffersViewController
    //                  self.navigationController?.pushViewController(retailerInfoVC!, animated: true)
    //        self.navigationController?.pushViewController(retailerInfoVC!, animated: true)
    //
    //
    //       }
    @IBAction func sprayserviceProductNavigation(_ sender: Any) {
        
        let net = NetworkReachabilityManager(host: "www.google.com")
        
        if net?.isReachable == true {
            let storyBoard = UIStoryboard(name: "Main" , bundle: nil)
            let retailerInfoVC = storyBoard.instantiateViewController(withIdentifier: "OffersViewController") as? OffersViewController
            self.navigationController?.pushViewController(retailerInfoVC!, animated: true)
        }else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
    }
    //MARK: Genunity check alert delegate methods
    

    func onBackPressed() {
        /*scannerVc?.dismissUQScanner(animated: true, cb: {
            self.scannerVc =  nil
        })*/
    }

    @objc func infoAlertScanMore(){
        
        if self.statusMsgAlert != nil {
            self.statusMsgAlert?.removeFromSuperview()
        }
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if isFromSprayServiceScanner == true {
            if noOfAcres == delegate!.numberOfScans {
                let retailerInfoVC = self.storyboard?.instantiateViewController(withIdentifier: "RetailerInformationViewController") as? RetailerInformationViewController
                retailerInfoVC!.cropID = self.cropId
                self.navigationController?.pushViewController(retailerInfoVC!, animated: true)
            }else if noOfAcres > delegate!.numberOfScans {
                
               // self.openGenunityCheckScanner()
                self.moduleType = "Spray Service"
                //self.openAcvission()
                self.openEmpoverScanner()
            }
        } else {
           // self.openGenunityCheckScanner()
           // self.moduleType = "Spray Service"
            //self.openAcvission()
            self.openEmpoverScanner()
        }
        
        
    }
    @objc func infoCloseButton(){
        if self.statusMsgAlert != nil {
            self.statusMsgAlert?.removeFromSuperview()
        }
        
    }
    
//    @IBAction func vehicleYearButtonClick(_ sender: UIButton){
//        
//        print("it is coming here")
//        self.view.endEditing(true)
//        if self.statusMsgAlert != nil {
//            self.statusMsgAlert?.removeFromSuperview()
//        }
//        //self.txtVehicleYear?.becomeFirstResponder()
//    }
    
    
    func doApiCall(){

        var ststusLogo = UIImage(named: "GenuinityFailure")
        let dict = convertToDictionary(text: "")
            
        Singleton.submitScannedUniquoBarcodeResultDataToServerForRetailer(scanResult: saveScanResult,completeResponse: saveJsonString, selectedRetailerId:retailerID,selectedRetailerName:retailerName,selectedRetailerCode:retailerCode,responseCode: 0) { (status, responseDictionary, statusMessage) in
                
            print("resp1",status!)
                print("resp2",responseDictionary!)
                print("resp3",statusMessage!)
             
                
            if status == true{
                self.dictEncashResponse = NSDictionary()
                self.dictEncashResponse = responseDictionary ?? NSDictionary()
                self.scanResponseAcviss = responseDictionary ?? NSDictionary()
                
                if self.dictEncashResponse?.value(forKey: "rewardPoints") as? String != "" && self.dictEncashResponse?.value(forKey: "rewardPoints")  != nil {
                    let rupee = "\u{20B9} "
                    
                    self.strCashReward  = String(format: "Cash Back : %@%@/-",rupee,self.dictEncashResponse?.value(forKey: "rewardPoints") as? CVarArg ?? "")
                }else {
                    self.strCashReward = ""
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
                self.stausLogo = UIImage(named: "GenuinityFailure")
                if Int(self.dictEncashResponse?["uq_responseCode"] as? String ?? "") == 100{
                    self.stausLogo = UIImage(named: "GenuinitySuccess")
                }else{
                    self.stausLogo = UIImage(named: "GenuinityFailure")
                }

                    self.statusMsgAlert = CustomAlert.genunityCheckResultPopup(self, frame: appDelegate.window?.frame ?? self.view.frame, title: NSLocalizedString("genuinity_check", comment: "") as NSString, message: responseDictionary?.value(forKey: "uq_message") as? NSString ?? "N/A", buttonTitle1: responseDictionary?.value(forKey: "buttonTitle1") as? NSString ?? "", buttonTitle2: responseDictionary?.value(forKey: "buttonTitle2") as? NSString ?? "" , imgCorteva: UIImage(named:"corteva")!, statusLogo: self.stausLogo!, hideClose: true, rewardMessage: responseDictionary?.value(forKey: "primaryRewardMsg") as? NSString ?? "", rewardMessage1: responseDictionary?.value(forKey: "secondaryRewardMsg") as? NSString ?? "", showEncashBtn: responseDictionary?.value(forKey: "showClickableLink") as? Bool ?? false,prodSerialNo: responseDictionary?.value(forKey: "prodSerialNumber") as? NSString ?? "",cashBackMsg: self.strCashReward as NSString, productName: responseDictionary?.value(forKey: "productName") as? NSString ?? "",  enableSprayService: responseDictionary?.value(forKey: "enableSprayService") as? Bool ?? false) as? UIView
                    appDelegate.window?.rootViewController?.view.addSubview(self.statusMsgAlert!)
                
            }else{
                self.view.makeToast(statusMessage ?? "Oops! Some thing went wrong. Please try again.")
            }
        }
    }
    
    
    
    @objc func infoAlertSubmit(){
        print("it is coming here")
        let userObj = Constatnts.getUserObject()
        let getRetailerName = statusMsgAlert?.viewWithTag(88888) as? UITextField
        let getRetailerCode = statusMsgAlert?.viewWithTag(99999) as? UITextField

        self.retailerName = getRetailerName?.text ?? ""
        self.retailerCode = getRetailerCode?.text ?? ""
        print("it is coming here1",retailerName)
        print("it is coming here2",retailerCode)
        if getRetailerName != nil{
            getRetailerName?.resignFirstResponder()
            let string = getRetailerName?.text
            print("KK11",string!)
            if(string == ""){
                self.view.makeToast(NSLocalizedString("pleaseSelectRetailer", comment: ""))
                return
            }
        }
        if getRetailerCode != nil{
            getRetailerCode?.resignFirstResponder()
            let string = getRetailerCode?.text
            print("KK12",string!)
            if(string?.count ?? 0 < 4){
                self.view.makeToast(NSLocalizedString("pleaseEnterFourDigitCode", comment: ""))
                return
            }
           
        }
        
        if(self.retailerName != "" && self.retailerCode != ""){
            print("do main api call here")
            self.doApiCall()
                self.statusMsgAlert?.removeFromSuperview()
                self.statusMsgAlert = nil
        }
        
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
        
        let arrrayPayment = NSMutableArray()
        arrrayPayment.add(dictEncashResponse?.value(forKey: "viewPaymentOptions")  as? NSArray ?? [])
        
        
        
        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectModeOfTransferViewController") as? SelectModeOfTransferViewController
        toSelectPayVC?.dictEncashResponse = parameters  //dictEncashResponse
        toSelectPayVC?.isRewardClaims = isRewardClaims
        if arrrayPayment.count>0{
            toSelectPayVC?.viewPaymentOptions = arrrayPayment as? NSMutableArray ?? []
        }
        self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
        
    }
    
    func farmservicesOptionSelectionActionSheetControl(){
        
        let farmServicerActionSheet = UIAlertController(title: NSLocalizedString("farm_services", comment: ""), message: "", preferredStyle: .alert)
        
        let providererAction = UIAlertAction(title: NSLocalizedString("provider", comment: ""), style: .default) { (alertAction) in
            let addEquipmentController = self.storyboard?.instantiateViewController(withIdentifier: "EquipmentsViewController") as? EquipmentsViewController
            addEquipmentController?.isFromHome = true
            self.navigationController?.pushViewController(addEquipmentController!, animated: true)
        }
        let requsterAction = UIAlertAction(title: NSLocalizedString("requester", comment: ""), style: .default) { (alertAction) in
            let toRequesterController = self.storyboard?.instantiateViewController(withIdentifier: "RequesterViewController") as? RequesterViewController
            toRequesterController?.isFromHome = true
            self.navigationController?.pushViewController(toRequesterController!, animated: true)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .destructive) { (alertAction) in
            
        }
        farmServicerActionSheet.addAction(providererAction)
        farmServicerActionSheet.addAction(requsterAction)
        farmServicerActionSheet.addAction(cancelAction)
        self.present(farmServicerActionSheet, animated: true, completion: nil)
    }
    
    //MARK: checkGerminationPendingOrClaimed
    func checkGerminationPendingOrClaimed(){
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            let toGerminationVC = self.storyboard?.instantiateViewController(withIdentifier: "GerminationViewController") as! GerminationViewController
            toGerminationVC.isFromHome = true
            self.navigationController?.pushViewController(toGerminationVC, animated: true)
            //            GerminationServiceManager.getGerminationList(completionHandler: { (success,responseDict,errorMessage) in
            //                if success == true{
            //                    let toGerminationVC = self.storyboard?.instantiateViewController(withIdentifier: "GerminationViewController") as! GerminationViewController
            //                    toGerminationVC.outputDict = responseDict
            //                    toGerminationVC.isFromHome = true
            //                    self.navigationController?.pushViewController(toGerminationVC, animated: true)
            //                }
            //            })
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
    }
    
    //MARK: checkGerminationActionControll
    func checkGerminationActionControl(){
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            GerminationServiceManager.getGerminationList(completionHandler: { (success,responseDict,errorMessage) in
                if success == true{
                    if let germinationFarmersDataObj = responseDict?.value(forKey: "germinationFarmersData") as? NSArray{
                        if germinationFarmersDataObj.count > 0{
                            let listArray = NSMutableArray()
                            var germinationListDict: GerminationList?
                            for i in 0..<germinationFarmersDataObj.count{
                                germinationListDict = GerminationList(dict: germinationFarmersDataObj.object(at: i) as! NSDictionary)
                                listArray.add(germinationListDict!)
                            }
                            if listArray.count == 1 {  //custom alertView with textField
                                let germinationObj = listArray.firstObject as? GerminationList
                                let germinationAlert = GerminationAlertView(frame: self.view.frame, germination: germinationObj!)
                                germinationAlert.successHandler = {(status, acres) in
                                    germinationAlert.removeFromSuperview()
                                    if status == true{
                                        let toGerminationAgreementVC = self.storyboard?.instantiateViewController(withIdentifier: "GerminationAgreementViewController") as? GerminationAgreementViewController
                                        toGerminationAgreementVC?.germinationModelObj = germinationListDict
                                        toGerminationAgreementVC?.isFromHome = true
                                        self.navigationController?.pushViewController(toGerminationAgreementVC!, animated: true)
                                    }
                                }
                                self.view.addSubview(germinationAlert)
                            }
                            else if listArray.count > 1{ //alert action sheet
                                self.showGerminationCropsListActionSheet(responseArray: listArray)
                            }
                        }
                        else{
                            if let msg = errorMessage as String?{
                                //self.view.makeToast(msg)
                                if self.statusMsgAlert != nil{
                                    self.statusMsgAlert?.removeFromSuperview()
                                }
                                self.statusMsgAlert = CustomAlert.alertInfoPopUpView(self, frame: self.view.frame, title: (Dashboard.GERMINATION.rawValue as NSString?)!, message:(msg  as NSString?)!, buttonTitle: "OK", hideClose: true) as? UIView
                                self.view.addSubview(self.statusMsgAlert!)
                            }
                        }
                    }
                }
            })
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
    }
    
    func showGerminationCropsListActionSheet(responseArray:NSArray?){
        if responseArray != nil{
            if responseArray?.count ?? 0 > 0{
                let germinationActionSheet = UIAlertController(title: "Select Crop", message: "", preferredStyle: .alert)
                for i in 0..<(responseArray?.count)!{
                    let germination = responseArray?.object(at:i) as? GerminationList
                    let germinationAction = UIAlertAction(title: germination?.cropName, style: .default, handler: { (alertAction) in
                        print(alertAction.title!)
                        let predicate = NSPredicate(format: "cropName == %@", alertAction.title!)
                        let filteredArray = responseArray?.filtered(using: predicate)
                        if filteredArray?.count ?? 0 > 0{
                            let germinationObj = filteredArray?.first as? GerminationList
                            let germinationAlert = GerminationAlertView(frame: self.view.frame, germination: germinationObj!)
                            germinationAlert.successHandler = {(status, acres) in
                                germinationAlert.removeFromSuperview()
                                if status == true{
                                    let toGerminationAgreementVC = self.storyboard?.instantiateViewController(withIdentifier: "GerminationAgreementViewController") as? GerminationAgreementViewController
                                    toGerminationAgreementVC?.germinationModelObj = germinationObj
                                    toGerminationAgreementVC?.isFromHome = true
                                    self.navigationController?.pushViewController(toGerminationAgreementVC!, animated: true)
                                }
                            }
                            self.view.addSubview(germinationAlert)
                        }
                    })
                    germinationActionSheet.addAction(germinationAction)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (alertAction) in
                    
                }
                germinationActionSheet.addAction(cancelAction)
                self.present(germinationActionSheet, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: cropAdvisoryOptionSelectionActionSheetControl
    //    func cropAdvisoryOptionSelectionActionSheetControl(){
    //        let cropAdvisoryActionSheet = UIAlertController(title: NSLocalizedString("crop_advisory", comment: ""), message: "", preferredStyle: .alert)
    //        let registrationAction = UIAlertAction(title: NSLocalizedString("crop_advisory_registration", comment: ""), style: .default) { (alertAction) in
    //            let net = NetworkReachabilityManager(host: "www.google.com")
    //            if net?.isReachable == true{
    //                let registrationVC = self.storyboard?.instantiateViewController(withIdentifier: "CropAdvisoryRegistrationViewController") as? CropAdvisoryRegistrationViewController
    //                self.navigationController?.pushViewController(registrationVC!, animated: true)
    //            }
    //            else{
    //                self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
    //            }
    //        }
    //        let notificationAction = UIAlertAction(title: NSLocalizedString("crop_advisory_notifications", comment: ""), style: .default) { (alertAction) in
    //            let notificationVC = self.storyboard?.instantiateViewController(withIdentifier: "CropNotificationViewController") as? CropNotificationViewController
    //            self.navigationController?.pushViewController(notificationVC!, animated: true)
    //        }
    //        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .destructive) { (alertAction) in
    //
    //        }
    //        cropAdvisoryActionSheet.addAction(registrationAction)
    //        cropAdvisoryActionSheet.addAction(notificationAction)
    //        cropAdvisoryActionSheet.addAction(cancelAction)
    //        self.present(cropAdvisoryActionSheet, animated: true, completion: nil)
    //    }
    
    func hybridOptionSelectionActionSheetControl(){
        
        let cropAdvisoryActionSheet = UIAlertController(title: NSLocalizedString("select", comment: ""), message: "", preferredStyle: .alert)
        UIAlertController(title: NSLocalizedString("", comment: ""), message: "", preferredStyle: .alert)
        let fabAction = UIAlertAction(title: NSLocalizedString("fab", comment: ""), style: .default) { (alertAction) in
            let toFABVC = self.storyboard?.instantiateViewController(withIdentifier: "FABViewController") as? FABViewController
            toFABVC?.isFromHome = true
            self.navigationController?.pushViewController(toFABVC!, animated: true)
        }
        let samplingAction = UIAlertAction(title: NSLocalizedString("sampling", comment: ""), style: .default) { (alertAction) in
            let sprayServiceVC = self.storyboard?.instantiateViewController(withIdentifier: "SampleTrackingListViewController") as? SampleTrackingListViewController
            self.navigationController?.pushViewController(sprayServiceVC!, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (alertAction) in
            self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
        }
        cropAdvisoryActionSheet.addAction(fabAction)
        cropAdvisoryActionSheet.addAction(samplingAction)
        cropAdvisoryActionSheet.addAction(cancelAction)
        self.present(cropAdvisoryActionSheet, animated: true, completion: nil)
    }
    func cropAdvisoryOptionSelectionActionSheetControl(){
        
        let cropAdvisoryActionSheet = UIAlertController(title: NSLocalizedString("select", comment: ""), message: "", preferredStyle: .alert)
        UIAlertController(title: NSLocalizedString("", comment: ""), message: "", preferredStyle: .alert)
        let registrationAction = UIAlertAction(title: NSLocalizedString("crop_advisory", comment: ""), style: .default) { (alertAction) in
            let net = NetworkReachabilityManager(host: "www.google.com")
            if net?.isReachable == true{
                //                let registrationVC = self.storyboard?.instantiateViewController(withIdentifier: "CASubscriptionFilterViewController") as? CASubscriptionFilterViewController//CropAdvisoryRegistrationViewController
                //                self.navigationController?.pushViewController(registrationVC!, animated: true)
               
                let userObj1 : User =  Constatnts.getUserObject()
                
                var diction = NSMutableDictionary()
                diction.setValue(userObj1.deviceToken, forKey: "deviceToken")
                diction.setValue(userObj1.userAuthorizationToken, forKey: "userAuthorizationToken")
                diction.setValue(userObj1.mobileNumber, forKey: "mobileNumber")
                diction.setValue(userObj1.customerId, forKey: "customerId")
                diction.setValue(userObj1.deviceId, forKey: "deviceId")
                
                diction.setValue(userObj1.emailId, forKey: "emailId")
                diction.setValue(userObj1.countryId, forKey: "countryId")
                
                diction.setValue(userObj1.customerTypeId, forKey: "customerTypeId")
                diction.setValue(userObj1.customerTypeName, forKey: "customerTypeName")
                
                diction.setValue(userObj1.firstName, forKey: "firstName")
                diction.setValue(userObj1.lastName, forKey: "lastName")
                diction.setValue(userObj1.pincode, forKey: "pincode")
                diction.setValue(userObj1.regionName, forKey: "regionName")
                diction.setValue(userObj1.geolocation, forKey: "geolocation")
                
                let view = BaseClass.loadViewFilter(userObj: diction)
                self.navigationController?.pushViewController(view, animated: true)
            }
            else{
                //  self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
            }
        }
        let notificationAction = UIAlertAction(title: NSLocalizedString("crop_advisory_notifications", comment: ""), style: .default) { (alertAction) in
            let notificationVC = self.storyboard?.instantiateViewController(withIdentifier: "CropNotificationViewController") as? CropNotificationViewController
            self.navigationController?.pushViewController(notificationVC!, animated: true)
        }
        let sprayServiceAction = UIAlertAction(title: NSLocalizedString("Spray_Service", comment: ""), style: .default) { (alertAction) in
            let sprayServiceVC = self.storyboard?.instantiateViewController(withIdentifier: "SprayServiceViewController") as? SprayServiceViewController
            
            self.navigationController?.pushViewController(sprayServiceVC!, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (alertAction) in
            self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
        }
        cropAdvisoryActionSheet.addAction(registrationAction)
        cropAdvisoryActionSheet.addAction(notificationAction)
        let  userObj = Constatnts.getUserObject()
        if userObj.enableSprayService == "true" {
            cropAdvisoryActionSheet.addAction(sprayServiceAction)
        }
        cropAdvisoryActionSheet.addAction(cancelAction)
        self.present(cropAdvisoryActionSheet, animated: true, completion: nil)
    }
    //MARK: tabbar delegate methods
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        isTabItemClickeed = true
        
        if item.tag == 101 {
            dashBoardCollectionView.scrollToItem(at: NSIndexPath.init(item: 0, section: 0) as IndexPath, at: .centeredVertically, animated: true)
        }
//        else if item.tag == 104 {
//            dashBoardCollectionView.scrollToItem(at: NSIndexPath.init(item: 0, section: 0) as IndexPath, at: .centeredVertically, animated: true)
//        }
        else if item.tag == 102 {
            dashBoardCollectionView.scrollToItem(at: NSIndexPath.init(item: 0, section: 1) as IndexPath, at: .centeredVertically, animated: true)
        }
        else if item.tag == 103 {
            dashBoardCollectionView.scrollToItem(at: NSIndexPath.init(item: 0, section: 2) as IndexPath, at: .centeredVertically, animated: true)
        }
        
        else {
            let net = NetworkReachabilityManager(host: "www.google.com")
            
            if net?.isReachable == true {
                let storyBoard = UIStoryboard(name: "Paramarsh" , bundle: nil)
                let paramarshVC = storyBoard.instantiateViewController(withIdentifier: "ParamarshProfileViewController") as? ParamarshProfileViewController
                paramarshVC?.isFromSideMenu = false
                self.navigationController?.pushViewController(paramarshVC!, animated: true)
            }else{
                self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
            }
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: ({
            self.isTabItemClickeed = false
        }))
    }
    //MARK: scrolling delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isTabItemClickeed == false {
            let visible = dashBoardCollectionView?.visibleCells as NSArray?
            if (self.lastContentOffset > scrollView.contentOffset.y) {
                // move up
                if let cell = visible?.firstObject as? UICollectionViewCell{
                    let indexPath = dashBoardCollectionView.indexPath(for: cell) as IndexPath?
                    //print("\(indexPath?.section ?? 10)")
                    if indexPath != nil{
                        tabBar.selectedItem = tabBar.items![indexPath?.section ?? 0]
                    }
                }
            }
            else if (self.lastContentOffset < scrollView.contentOffset.y) {
                // move down
                if let cell = visible?.lastObject as? UICollectionViewCell{
                    let indexPath = dashBoardCollectionView.indexPath(for: cell) as IndexPath?
                    //print("\(indexPath?.section ?? 10)")
                    if indexPath != nil{
                        tabBar.selectedItem = tabBar.items![indexPath?.section ?? 0]
                    }
                }
            }
        }
        else{
        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y
        }
        
    }
    @IBAction func btnGotoParamarsh(_ sender: Any) {
        
        let net = NetworkReachabilityManager(host: "www.google.com")
        
        if net?.isReachable == true {
            let storyBoard = UIStoryboard(name: "Paramarsh" , bundle: nil)
            let paramarshVC = storyBoard.instantiateViewController(withIdentifier: "ParamarshProfileViewController") as? ParamarshProfileViewController
            paramarshVC?.isFromSideMenu = false
            self.navigationController?.pushViewController(paramarshVC!, animated: true)
        }else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.notificationNavigationToRespectivePage()
        })
    }
    
    func getUserSubscriptionStages(Params : Parameters){
        
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_SprayCycleStatus])
        let userObj1 : User =  Constatnts.getUserObject()
        let  headers : HTTPHeaders  = ["deviceToken": userObj1.deviceToken as String ,
                                       "userAuthorizationToken": userObj1.userAuthorizationToken! as String ,
                                       "mobileNumber": userObj1.mobileNumber! as String,
                                       "customerId": userObj1.customerId! as String,
                                       "deviceId": userObj1.deviceId! as String]
        
        Alamofire.request(urlString, method: .post, parameters: Params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                print(response)
                if let json = response.result.value {
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                    if responseStatusCode == STATUS_CODE_200{
                        
                        let respData = (json as? NSDictionary)?.value(forKey: "response") as? NSString ?? ""
                        let decryptData  = Constatnts.convertToDictionary(text: respData as String)
                        
                        
                        //                            if let statesArray = decryptData.value(forKey: "stateCodeMaster") as? NSArray{
                        //                                let statesNamesSet =  NSSet(array:statesArray as! [Any])
                        //                                self.stateArray = statesNamesSet.allObjects as NSArray
                        //                                self.stateNamesArray.addObjects(from: statesNamesSet.allObjects)
                        //                            }
                        self.sprayRequestDone = decryptData?["sprayRequestDone"] as? Bool ?? false
                        self.bookEquipmentDone = decryptData?["bookEquipmentDone"] as? Bool ?? false
                        self.billUploadDone = decryptData?["billUploadDone"] as? Bool ?? false
                        self.feedbackSubmissionDone = decryptData?["feedbackSubmissionDone"] as? Bool ?? false
                        
                        if self.sprayRequestDone == true {
                            let sprayVC = self.storyboard?.instantiateViewController(withIdentifier: "SprayServicesStagesViewController") as? SprayServicesStagesViewController
                            self.navigationController?.pushViewController(sprayVC!, animated: true)
                        }else {
                            let sprayVC = self.storyboard?.instantiateViewController(withIdentifier: "SprayServiceViewController") as? SprayServiceViewController
                            
                            sprayVC?.isFromHome = true
                            self.navigationController?.pushViewController(sprayVC!, animated: true)
                        }
                        //                            if self.billUploadDone == false {
                        //                                self.btnBillUploadSelection.isHidden = true
                        //                            }else {
                        //                                self.btnBillUploadSelection.isHidden = false
                        //                            }
                        //                            if self.bookEquipmentDone == false {
                        //                                self.btnBookEquipmentDoneSelection.isHidden = true
                        //                            }else {
                        //                                self.btnBookEquipmentDoneSelection.isHidden = false
                        //                            }
                        //
                        //                            if self.feedbackSubmissionDone == false {
                        //                                self.btnFeedbackSubmissionDoneSelection.isHidden = true
                        //                            }else {
                        //                                self.btnFeedbackSubmissionDoneSelection.isHidden = false
                        //                            }
                    }
                    else if responseStatusCode == CROP_ADVISORY_NOT_AVAILABLE_151{
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    } else if responseStatusCode == STATUS_CODE_105{
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    else if responseStatusCode == STATUS_CODE_601{
                        Constatnts.logOut()
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
    
    func submitNumberScanningsCount(Params : Parameters){
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,SUBMIT_NumberOfScansRequester])
        let userObj1 : User =  Constatnts.getUserObject()
        let  headers : HTTPHeaders  = ["deviceToken": userObj1.deviceToken as String ,
                                       "userAuthorizationToken": userObj1.userAuthorizationToken! as String ,
                                       "mobileNumber": userObj1.mobileNumber! as String,
                                       "customerId": userObj1.customerId! as String,
                                       "deviceId": userObj1.deviceId! as String]
        
        Alamofire.request(urlString, method: .post, parameters: Params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                print(response)
                if let json = response.result.value {
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                    if responseStatusCode == STATUS_CODE_200{
                        let userObj = Constatnts.getUserObject()
                        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"screen_name" : "RetailerInformationViewController" ] as [String : Any]
                        //
                        self.registerFirebaseEvents("PV_Retailer_CropMaster_success", userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "RetailerInformationViewController" , parameters: fireBaseParams as NSDictionary)
                        let respData = (json as? NSDictionary)?.value(forKey: "response") as? NSString ?? ""
                        let decryptData  = Constatnts.convertToDictionary(text: respData as String)
                        
                        
                    }
                    else if responseStatusCode == CROP_ADVISORY_NOT_AVAILABLE_151{
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    } else if responseStatusCode == STATUS_CODE_105{
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    else if responseStatusCode == STATUS_CODE_601{
                        Constatnts.logOut()
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
    

    //MARK: - Acvission

//    func openAcvission(){
        ///Note: Make sure correct values are present in Acviss-Credentials.plist
        ///Acvission Integration: Step 2: Instantiate VisionViewController from Acvission
        ///
    /* The Below code is commented becuase we are using empover scanner here*/
//        let userObj = Constatnts.getUserObject()
//        let userId = userObj.customerId as! String
//        let mobileNum = userObj.mobileNumber! as String
//        let usr =  AcvissCoreCertify.User.init(
//                        linkedId: userId,
//                        token: "",
//                        mobile:(countryCode: "", number: mobileNum),
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
//        print(" onVericationCompletion33: ==>")
//       // print(result as Any)
//        
//        if statusMsgAlert != nil{
//            self.statusMsgAlert?.removeFromSuperview()
//        }
//    
//        if raw != nil{
//            
//            let rawResult = raw as Dictionary
//            var message = ""
//            var ststusLogo = UIImage(named: "GenuinityFailure")
//            let userObj = Constatnts.getUserObject()
//            
//            print("String rawResult is",rawResult)
//            print("String responseCode is",responseCode)
//            let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!, USER_ID:userObj.customerId!, Genunity_Status_Code:responseCode.rawValue, Product_Deatils:rawResult["product_details"] ?? "",Serial_Number:rawResult["serial_number"] ?? ""] as [String : Any]
//            
//            if responseCode.rawValue == Genunity_Status_Code_100{
//                message = String(format: "%@ \n Serial number: %@",GenunitySuccessMessage, rawResult["serial_number"]  as? String ?? "")
//                ststusLogo = UIImage(named: "GenuinitySuccess")
//                self.registerFirebaseEvents(Genuinity_Check_Success, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
//            }
//            else if responseCode.rawValue == Genunity_Status_Code_101 || responseCode.rawValue as? Int == Genunity_Status_Code_102{
//                message = String(format: GenunityFailureMessage, rawResult["message"] as? String ?? "")
//                ststusLogo = UIImage(named: "GenuinityFailure")
//                if responseCode.rawValue == Genunity_Status_Code_101{
//                    self.registerFirebaseEvents(Genuine_Label_Inactive, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
//                }
//                else{
//                    self.registerFirebaseEvents(Scanned_Label_Invalid, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
//                }
//            }
//            else if responseCode.rawValue == Genunity_Status_Code_103{
//                message = String(format: GenunityAttemptsExceedMessage, rawResult["message"] as? String ?? "")
//                ststusLogo = UIImage(named: "GenunityAttempts")
//                self.registerFirebaseEvents(GC_Scan_Limt_Exceeded, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
//            }
//            else if responseCode.rawValue == Genunity_Status_Code_104{ //External
//                message = (rawResult["message"] as? String) ?? ""
//                ststusLogo = UIImage(named: "GenuinityFailure")
//                self.registerFirebaseEvents(GC_Not_Geniune, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
//            }
//            else if responseCode.rawValue == Genunity_Status_Code_105 { //AttemptsError
//                message = (rawResult["message"] as? String) ?? ""
//                //String(format: "%@", rawResult["message"] as! CVarArg)
//                ststusLogo = UIImage(named: "GenuinityFailure")
//                self.registerFirebaseEvents(message, "", "", Genuinity_Check, parameters: fireBaseParams as NSDictionary)
//            }
//            else{
//                message = rawResult["message"] as? String ?? ""
//            }
//            print("String rawResult from data:",rawResult["data"] ?? "")
//            
//            let paramsStr = try! JSONSerialization.data(withJSONObject: rawResult["data"] ?? "", options: .prettyPrinted)
//            
//            let jsonString = NSString(data: paramsStr, encoding: String.Encoding.utf8.rawValue)! as String
//            print("String result12    \(jsonString)")
//
//
//            Singleton.submitScannedAcvissBarcodeResultDataToServerNew(scanResult: raw as Dictionary, completeResponse: jsonString, selectedLabel: "", moduleType: self.moduleType, responseCode: responseCode.rawValue) { (status, responseDictionary, statusMessage) in
//                if status == true{
//                    self.dictEncashResponse = NSDictionary()
//                    print(responseDictionary)
//                    
//                    self.dictEncashResponse = responseDictionary ?? NSDictionary()
//                    self.scanResponseAcviss = responseDictionary ?? NSDictionary()
//                    
//                    if self.isFromSprayServiceScanner == true {
//                        let delegate = UIApplication.shared.delegate as? AppDelegate
//                        delegate!.numberOfScans = delegate!.numberOfScans + 1
//                        let params : Parameters = ["noOfScans": delegate!.numberOfScans , "cropId" : self.cropId]
//                        
//                        if self.noOfAcres >= delegate!.numberOfScans {
//                            self.submitNumberScanningsCount(Params: params)
//                        }
//                        
//                    }
//                    
//                    var strCashReward = ""
//                    if self.dictEncashResponse?.value(forKey: "rewardPoints") as? String != "" && self.dictEncashResponse?.value(forKey: "rewardPoints")  != nil {
//                        let rupee = "\u{20B9} "
//                        
//                        strCashReward  = String(format: "Cash Back : %@%@/-",rupee,self.dictEncashResponse?.value(forKey: "rewardPoints") as? CVarArg ?? "")
//                    }else {
//                        strCashReward = ""
//                    }
//                    
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
//                    
//                    self.stausLogo = UIImage(named: "GenuinityFailure")
//                    if (self.dictEncashResponse?["uq_responseCode"] as! Int == Genunity_Status_Code_100){
//                        self.stausLogo = UIImage(named: "GenuinitySuccess")
//                    }else{
//                        self.stausLogo = UIImage(named: "GenuinityFailure")
//                    }
//                    
//                    
//                    print("The decryptData",responseDictionary?.value(forKey: "showRetailerIdPopup") as? Bool ?? false)
//                    let objIS = responseDictionary?.value(forKey: "showRetailerIdPopup") as? Bool ?? false
//                    let ArrayID =  responseDictionary?.value(forKey: "retailerList") as? NSArray ?? []
//                    self.retailersList = ArrayID
//                    self.originalRetailersList = ArrayID
//                    print("what is full array count",self.retailersList.count)
//                    self.retailerTable.reloadData()
//                    self.retailerName = ""
//                    self.retailerID = ""
//                    self.retailerCode = ""
//                    self.showRetailerTable = true
//                    print("it is objecttt",objIS)
//                    if(objIS == true){
//                        self.statusMsgAlert = CustomAlert.genunityCheckNewResultPopup(self, value: self.showRetailerTable, reatilerTableView : self.retailerTable, selectedRetailerName: self.retailerName as NSString, frame: appDelegate.window?.frame ?? self.view.frame, title: NSLocalizedString("genuinity_check", comment: "") as NSString, message: responseDictionary?.value(forKey: "uq_message") as? NSString ?? "N/A", buttonTitle1: responseDictionary?.value(forKey: "buttonTitle1") as? NSString ?? "", buttonTitle2: responseDictionary?.value(forKey: "buttonTitle2") as? NSString ?? "" , imgCorteva: UIImage(named:"corteva")!, statusLogo: self.stausLogo!, hideClose: true, rewardMessage: responseDictionary?.value(forKey: "primaryRewardMsg") as? NSString ?? "", rewardMessage1: responseDictionary?.value(forKey: "secondaryRewardMsg") as? NSString ?? "", showEncashBtn: responseDictionary?.value(forKey: "showClickableLink") as? Bool ?? false,prodSerialNo: responseDictionary?.value(forKey: "prodSerialNumber") as? NSString ?? "",cashBackMsg: self.strCashReward as NSString, productName: responseDictionary?.value(forKey: "productName") as? NSString ?? "",  enableSprayService: responseDictionary?.value(forKey: "enableSprayService") as? Bool ?? false,retailerList: responseDictionary?.value(forKey: "retailerList") as? NSArray ?? []) as? UIView
//                        appDelegate.window?.rootViewController?.view.addSubview(self.statusMsgAlert!)
////                        self.retailerTable.reloadData()
//                    }
//                    else{
//                        self.statusMsgAlert = CustomAlert.genunityCheckResultPopup(self, frame: appDelegate.window?.frame ?? self.view.frame, title: NSLocalizedString("genuinity_check", comment: "") as NSString, message: responseDictionary?.value(forKey: "uq_message") as? NSString ?? "N/A", buttonTitle1: responseDictionary?.value(forKey: "buttonTitle1") as? NSString ?? "", buttonTitle2: responseDictionary?.value(forKey: "buttonTitle2") as? NSString ?? "" , imgCorteva: UIImage(named:"corteva")!, statusLogo: self.stausLogo!, hideClose: true, rewardMessage: responseDictionary?.value(forKey: "primaryRewardMsg") as? NSString ?? "", rewardMessage1: responseDictionary?.value(forKey: "secondaryRewardMsg") as? NSString ?? "", showEncashBtn: responseDictionary?.value(forKey: "showClickableLink") as? Bool ?? false,prodSerialNo: responseDictionary?.value(forKey: "prodSerialNumber") as? NSString ?? "",cashBackMsg: strCashReward as NSString, productName: responseDictionary?.value(forKey: "productName") as? NSString ?? "",  enableSprayService: responseDictionary?.value(forKey: "enableSprayService") as? Bool ?? false) as? UIView
//                        appDelegate.window?.rootViewController?.view.addSubview(self.statusMsgAlert!)
//                    }
//                }else{
//                    self.view.makeToast(statusMessage ?? "Oops! Some thing went wrong. Please try again.")
//                }
//            }
//        }
//    }
    
    ///Only detected code's value for Generic or Regex Match
//    func onDetectionOfExemptedCode(_ exemptedCodeDetails: ExemptedCode) {
//        print("the acviss exemptedCodeDetails are:", exemptedCodeDetails)
//        if statusMsgAlert != nil{
//            self.statusMsgAlert?.removeFromSuperview()
//        }
//        let regularExpression = ["^([hH]{1}[tT]{2}[pP]{1}[sS]{1}:\\/\\/[cC]{1}[oO]{1}[iI]{1}[dD]{1}.[iI]{1}[nN]{1}\\/)","https:\\/\\/roots-cpm.ecubix.com\\/?.*","http:\\/\\/6\\.ivcs\\.ai\\/?.*"]
//        let checkForRegexMatch = regularExpression.filter{$0 == exemptedCodeDetails.matchedRegEx}
//        if checkForRegexMatch.count > 0{
//            let parameters = ["barCodeScannedValue":exemptedCodeDetails.barCodeScannedValue,"matchedRegEx":exemptedCodeDetails.matchedRegEx,"message":exemptedCodeDetails.message]
//            let scanResult = parameters as Dictionary
//            self.saveScanResult = parameters as Dictionary
//            let paramsStr = try! JSONSerialization.data(withJSONObject: scanResult, options: .prettyPrinted)
//            let jsonString = NSString(data: paramsStr, encoding: String.Encoding.utf8.rawValue)! as String
//            self.saveJsonString = NSString(data: paramsStr, encoding: String.Encoding.utf8.rawValue)! as String
//            NSLog("the acviss jsonString RESPONSE:", jsonString)
//            DispatchQueue.main.async {
//               // self.navigationController?.popViewController(animated: true)
//            }
//            Singleton.submitScannedAcvissBarcodeResultDataToServerNew(scanResult: scanResult as Dictionary, completeResponse: jsonString, selectedLabel: "", moduleType: self.moduleType, responseCode: 0) { (status, responseDictionary, statusMessage) in
//               // NSLog("the acviss Resp:", jsonString)
//                if status == true{
//                    self.dictEncashResponse = NSDictionary()
//                    self.dictEncashResponse = responseDictionary ?? NSDictionary()
//                    self.scanResponseAcviss = responseDictionary ?? NSDictionary()
//                    
//                   
//                    if self.dictEncashResponse?.value(forKey: "rewardPoints") as? String != "" && self.dictEncashResponse?.value(forKey: "rewardPoints")  != nil {
//                        let rupee = "\u{20B9} "
//                        
//                        self.strCashReward  = String(format: "Cash Back : %@%@/-",rupee,self.dictEncashResponse?.value(forKey: "rewardPoints") as? CVarArg ?? "")
//                    }else {
//                        self.strCashReward = ""
//                    }
//                    
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
//                    self.stausLogo = UIImage(named: "GenuinityFailure")
//                    if Int(self.dictEncashResponse?["uq_responseCode"] as? String ?? "") == 100{
//                        self.stausLogo = UIImage(named: "GenuinitySuccess")
//                    }else{
//                        self.stausLogo = UIImage(named: "GenuinityFailure")
//                    }
//                   // print("The decryptData",responseDictionary?.value(forKey: "showRetailerIdPopup") as? Bool ?? false)
//                    let objIS = responseDictionary?.value(forKey: "showRetailerIdPopup") as? Bool ?? false
//                    let ArrayID =  responseDictionary?.value(forKey: "retailerList") as? NSArray ?? []
//                    self.retailersList = ArrayID
//                    self.originalRetailersList = ArrayID
//                    //print("what is full array count",self.retailersList.count)
//                    self.retailerTable.reloadData()
//                    self.retailerName = ""
//                    self.retailerID = ""
//                    self.retailerCode = ""
//                    self.showRetailerTable = true
//                    if(objIS == true){
//                        self.statusMsgAlert = CustomAlert.genunityCheckNewResultPopup(self, value: self.showRetailerTable, reatilerTableView : self.retailerTable, selectedRetailerName: self.retailerName as NSString, frame: appDelegate.window?.frame ?? self.view.frame, title: NSLocalizedString("genuinity_check", comment: "") as NSString, message: responseDictionary?.value(forKey: "uq_message") as? NSString ?? "N/A", buttonTitle1: responseDictionary?.value(forKey: "buttonTitle1") as? NSString ?? "", buttonTitle2: responseDictionary?.value(forKey: "buttonTitle2") as? NSString ?? "" , imgCorteva: UIImage(named:"corteva")!, statusLogo: self.stausLogo!, hideClose: true, rewardMessage: responseDictionary?.value(forKey: "primaryRewardMsg") as? NSString ?? "", rewardMessage1: responseDictionary?.value(forKey: "secondaryRewardMsg") as? NSString ?? "", showEncashBtn: responseDictionary?.value(forKey: "showClickableLink") as? Bool ?? false,prodSerialNo: responseDictionary?.value(forKey: "prodSerialNumber") as? NSString ?? "",cashBackMsg: self.strCashReward as NSString, productName: responseDictionary?.value(forKey: "productName") as? NSString ?? "",  enableSprayService: responseDictionary?.value(forKey: "enableSprayService") as? Bool ?? false,retailerList: responseDictionary?.value(forKey: "retailerList") as? NSArray ?? []) as? UIView
//                        appDelegate.window?.rootViewController?.view.addSubview(self.statusMsgAlert!)
////                        self.retailerTable.reloadData()
//                    }
//                    else{
//                        self.statusMsgAlert = CustomAlert.genunityCheckResultPopup(self, frame: appDelegate.window?.frame ?? self.view.frame, title: NSLocalizedString("genuinity_check", comment: "") as NSString, message: responseDictionary?.value(forKey: "uq_message") as? NSString ?? "N/A", buttonTitle1: responseDictionary?.value(forKey: "buttonTitle1") as? NSString ?? "", buttonTitle2: responseDictionary?.value(forKey: "buttonTitle2") as? NSString ?? "" , imgCorteva: UIImage(named:"corteva")!, statusLogo: self.stausLogo!, hideClose: true, rewardMessage: responseDictionary?.value(forKey: "primaryRewardMsg") as? NSString ?? "", rewardMessage1: responseDictionary?.value(forKey: "secondaryRewardMsg") as? NSString ?? "", showEncashBtn: responseDictionary?.value(forKey: "showClickableLink") as? Bool ?? false,prodSerialNo: responseDictionary?.value(forKey: "prodSerialNumber") as? NSString ?? "",cashBackMsg: self.strCashReward as NSString, productName: responseDictionary?.value(forKey: "productName") as? NSString ?? "",  enableSprayService: responseDictionary?.value(forKey: "enableSprayService") as? Bool ?? false) as? UIView
//                        appDelegate.window?.rootViewController?.view.addSubview(self.statusMsgAlert!)
//                    }
//                    
//                }else{
//                    self.view.makeToast(statusMessage ?? "Oops! Some thing went wrong. Please try again.")
//                }
//            }
//        }
//    }
    
    ///Multiple Scans
//    func onVerificationCompletion(results: [(model: LabelData?, raw: [String : Any])]) {
//        print("onVerificationCompletion:===>")
//        print(results)
//    }
    
    public enum Environment {
        case production
        case test
    }
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
        
//        let displayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
//        ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
//        ?? "FarmerConnect"
//        let bundleId = Bundle.main.bundleIdentifier ?? "com.phi.farmerconnect"
        
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

//        scannerView = CameraScannerView(frame: view.bounds)
//        scannerView?.delegate = self
//        scannerView?.configure(with: config)
//        modalPresentationStyle = .fullScreen
//        view.addSubview(scannerView!)
//        scannerView?.startScanning()
        
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

            let regularExpression = [ "^([hH]{1}[tT]{2}[pP]{1}[sS]{1}:\\/\\/[cC]{1}[oO]{1}[iI]{1}[dD]{1}\\.[iI]{1}[nN]{1}\\/)",
                                      "^([hH]{1}[tT]{2}[pP]{1}[sS]{1}:\\/\\/[uU]{1}[aA]{1}[tT]{1}\\.[fF]{1}[aA]{1}[rR]{1}[mM]{1}[eE]{1}[rR]{1}[cC]{1}[oO]{1}[nN]{2}[eE]{1}[cC]{1}[tT]{1}\\.[iI]{1}[nN]{1}\\/)",
                                      "^([hH]{1}[tT]{2}[pP]{1}[sS]{1}:\\/\\/[fF]{1}[aA]{1}[rR]{1}[mM]{1}[eE]{1}[rR]{1}[cC]{1}[oO]{1}[nN]{2}[eE]{1}[cC]{1}[tT]{1}\\.[iI]{1}[nN]{1}\\/)",
                                      "^[A-Z0-9]{8}$",
                                      "^www\\.checko\\.ai\\/\\?i=[A-Z0-9]{8}$",
                                      "^([a-zA-Z0-9]*)_[0-9]{10}_[a-z0-9A-Z]*_[0-9]*",
                                      "https:\\/\\/roots-cpm\\.ecubix\\.com\\/?.*",
                                      "http:\\/\\/6\\.ivcs\\.ai\\/?.*",
                                      "^sv1[A-Za-z0-9]{21,22}$",
                                      "^[A-Za-z]v1.*$",
                                      "(?i)^[A-Z0-9].*"]
            
//            let checkForRegexMatch = regularExpression.filter{$0 == exemptedCodeDetails!.matchedRegEx}
//            let server = exemptedCodeDetails?.matchedRegEx ?? ""
//            let checkForRegexMatch = regularExpression.filter {
//                $0.replacingOccurrences(of: "\\.", with: ".") == server.replacingOccurrences(of: "\\.", with: ".")
//            }
//        print("matched",checkForRegexMatch)
//            print("matched11",checkForRegexMatch.count)
//            if checkForRegexMatch.count > 0{
                let parameters = ["barCodeScannedValue":exemptedCodeDetails!.barCodeScannedValue,"matchedRegEx":exemptedCodeDetails!.matchedRegEx,"message":exemptedCodeDetails!.message]
                let scanResult = parameters as Dictionary
                print("scanResult sending is :",scanResult)
                self.saveScanResult = parameters as Dictionary
                let paramsStr = try! JSONSerialization.data(withJSONObject: scanResult, options: .prettyPrinted)
                let jsonString = NSString(data: paramsStr, encoding: String.Encoding.utf8.rawValue)! as String
          
                self.saveJsonString = NSString(data: paramsStr, encoding: String.Encoding.utf8.rawValue)! as String
                NSLog("the acviss jsonString request:", jsonString)
                DispatchQueue.main.async {
                   // self.navigationController?.popViewController(animated: true)
                }
                Singleton.submitScannedAcvissBarcodeResultDataToServerNew(scanResult: scanResult as Dictionary, completeResponse: jsonString, selectedLabel: "", moduleType: self.moduleType, responseCode: 0) { (status, responseDictionary, statusMessage) in
                   // NSLog("the acviss Resp:", jsonString)
                    if status == true{
                        self.dictEncashResponse = NSDictionary()
                        self.dictEncashResponse = responseDictionary ?? NSDictionary()
                        self.scanResponseAcviss = responseDictionary ?? NSDictionary()
                        
                       
                        if self.dictEncashResponse?.value(forKey: "rewardPoints") as? String != "" && self.dictEncashResponse?.value(forKey: "rewardPoints")  != nil {
                            let rupee = "\u{20B9} "
                            
                            self.strCashReward  = String(format: "Cash Back : %@%@/-",rupee,self.dictEncashResponse?.value(forKey: "rewardPoints") as? CVarArg ?? "")
                        }else {
                            self.strCashReward = ""
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
                        self.stausLogo = UIImage(named: "GenuinityFailure")
                        if Int(self.dictEncashResponse?["uq_responseCode"] as? String ?? "") == 100{
                            self.stausLogo = UIImage(named: "GenuinitySuccess")
                        }else{
                            self.stausLogo = UIImage(named: "GenuinityFailure")
                        }
                       // print("The decryptData",responseDictionary?.value(forKey: "showRetailerIdPopup") as? Bool ?? false)
                        let objIS = responseDictionary?.value(forKey: "showRetailerIdPopup") as? Bool ?? false
                        let ArrayID =  responseDictionary?.value(forKey: "retailerList") as? NSArray ?? []
                        self.retailersList = ArrayID
                        self.originalRetailersList = ArrayID
                        //print("what is full array count",self.retailersList.count)
                        self.retailerTable.reloadData()
                        self.retailerName = ""
                        self.retailerID = ""
                        self.retailerCode = ""
                        self.showRetailerTable = true
                        if(objIS == true){
                            self.statusMsgAlert = CustomAlert.genunityCheckNewResultPopup(self, value: self.showRetailerTable, reatilerTableView : self.retailerTable, selectedRetailerName: self.retailerName as NSString, frame: appDelegate.window?.frame ?? self.view.frame, title: NSLocalizedString("genuinity_check", comment: "") as NSString, message: responseDictionary?.value(forKey: "uq_message") as? NSString ?? "N/A", buttonTitle1: responseDictionary?.value(forKey: "buttonTitle1") as? NSString ?? "", buttonTitle2: responseDictionary?.value(forKey: "buttonTitle2") as? NSString ?? "" , imgCorteva: UIImage(named:"corteva")!, statusLogo: self.stausLogo!, hideClose: true, rewardMessage: responseDictionary?.value(forKey: "primaryRewardMsg") as? NSString ?? "", rewardMessage1: responseDictionary?.value(forKey: "secondaryRewardMsg") as? NSString ?? "", showEncashBtn: responseDictionary?.value(forKey: "showClickableLink") as? Bool ?? false,prodSerialNo: responseDictionary?.value(forKey: "prodSerialNumber") as? NSString ?? "",cashBackMsg: self.strCashReward as NSString, productName: responseDictionary?.value(forKey: "productName") as? NSString ?? "",  enableSprayService: responseDictionary?.value(forKey: "enableSprayService") as? Bool ?? false,retailerList: responseDictionary?.value(forKey: "retailerList") as? NSArray ?? []) as? UIView
                            appDelegate.window?.rootViewController?.view.addSubview(self.statusMsgAlert!)
    //                        self.retailerTable.reloadData()
                        }
                        else{
                            self.statusMsgAlert = CustomAlert.genunityCheckResultPopup(self, frame: appDelegate.window?.frame ?? self.view.frame, title: NSLocalizedString("genuinity_check", comment: "") as NSString, message: responseDictionary?.value(forKey: "uq_message") as? NSString ?? "N/A", buttonTitle1: responseDictionary?.value(forKey: "buttonTitle1") as? NSString ?? "", buttonTitle2: responseDictionary?.value(forKey: "buttonTitle2") as? NSString ?? "" , imgCorteva: UIImage(named:"corteva")!, statusLogo: self.stausLogo!, hideClose: true, rewardMessage: responseDictionary?.value(forKey: "primaryRewardMsg") as? NSString ?? "", rewardMessage1: responseDictionary?.value(forKey: "secondaryRewardMsg") as? NSString ?? "", showEncashBtn: responseDictionary?.value(forKey: "showClickableLink") as? Bool ?? false,prodSerialNo: responseDictionary?.value(forKey: "prodSerialNumber") as? NSString ?? "",cashBackMsg: self.strCashReward as NSString, productName: responseDictionary?.value(forKey: "productName") as? NSString ?? "",  enableSprayService: responseDictionary?.value(forKey: "enableSprayService") as? Bool ?? false) as? UIView
                            appDelegate.window?.rootViewController?.view.addSubview(self.statusMsgAlert!)
                        }
                        
                    }else{
                        self.view.makeToast(statusMessage ?? "Oops! Some thing went wrong. Please try again.")
                    }
                }
           // }
        }
      
    }
    
    //MARK: UITextfield Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        stausLogo = UIImage(named: "GenuinitySuccess")
        if textField == statusMsgAlert?.viewWithTag(88888){
            textField.resignFirstResponder()
           print("it is hereree dropdown")
//            self.retailerName = ""
//            self.retailerID = ""
            if(showRetailerTable == false){
                self.showRetailerTable = true
            }
            else{
                self.showRetailerTable = false
            }
            self.retailersList = self.originalRetailersList
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            self.statusMsgAlert?.removeFromSuperview()
            self.statusMsgAlert = CustomAlert.genunityCheckNewResultPopup(self, value: self.showRetailerTable, reatilerTableView : self.retailerTable, selectedRetailerName: self.retailerName as NSString, frame: appDelegate.window?.frame ?? self.view.frame, title: NSLocalizedString("genuinity_check", comment: "") as NSString, message: scanResponseAcviss?.value(forKey: "uq_message") as? NSString ?? "N/A", buttonTitle1: scanResponseAcviss?.value(forKey: "buttonTitle1") as? NSString ?? "", buttonTitle2: scanResponseAcviss?.value(forKey: "buttonTitle2") as? NSString ?? "" , imgCorteva: UIImage(named:"corteva")!, statusLogo: self.stausLogo!, hideClose: true, rewardMessage: scanResponseAcviss?.value(forKey: "primaryRewardMsg") as? NSString ?? "", rewardMessage1: scanResponseAcviss?.value(forKey: "secondaryRewardMsg") as? NSString ?? "", showEncashBtn: scanResponseAcviss?.value(forKey: "showClickableLink") as? Bool ?? false,prodSerialNo: scanResponseAcviss?.value(forKey: "prodSerialNumber") as? NSString ?? "",cashBackMsg: self.strCashReward as NSString, productName: scanResponseAcviss?.value(forKey: "productName") as? NSString ?? "",  enableSprayService: scanResponseAcviss?.value(forKey: "enableSprayService") as? Bool ?? false,retailerList: scanResponseAcviss?.value(forKey: "retailerList") as? NSArray ?? []) as? UIView
                    appDelegate.window?.rootViewController?.view.addSubview(self.statusMsgAlert!)
                    self.retailerTable.reloadData()
        }
        if textField == statusMsgAlert?.viewWithTag(99999){
           print("it is hereree id")
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == statusMsgAlert?.viewWithTag(99999){
            textField.resignFirstResponder()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
                if(textField == statusMsgAlert?.viewWithTag(1010)){
                    print("0909")
                    let currentString: NSString = (textField.text ?? "") as NSString
                    print("090911199",currentString)
                    print("090911199",currentString.length)
                    if(currentString == ""){
                        self.retailersList = self.originalRetailersList
                    }
                    else{
                    }
                }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == statusMsgAlert?.viewWithTag(99999){
        let maxLength = 4
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString

        return newString.length <= maxLength
        }
        else if(textField == statusMsgAlert?.viewWithTag(1010)){
            searchString = (textField.text ?? "") as NSString
//            self.retailerName = searchString as String
            if(searchString.length <= 1){
                self.retailersList = self.originalRetailersList
                print("what is retailersList is03",self.retailersList)
            }

        }
        return true
    }
    
    @objc func searchButtonClick(){
        self.view.endEditing(true)
        //self.txtClassification?.becomeFirstResponder()
        if(searchString.length >= 1){
            let searchText = searchString as String
            let filteredData = filterDataByName(self.retailersList as! [[String : Any]], searchText: searchText)
            print("what is filteredData filteredData is",filteredData)
            self.retailersList = filteredData as NSArray
            print("what is retailersList is02",self.retailersList)
            print("what is retailersList is02 count",self.retailersList.count)
            if(retailersList.count == 0){
                self.view.makeToast(NSLocalizedString("no_data_available", comment: ""))
                self.showRetailerTable = true
                self.updatePopup()
            }
            else{
                self.updatePopup()
            }
            
        }
    }
    
    func updatePopup(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                   self.statusMsgAlert?.removeFromSuperview()
                   self.statusMsgAlert = CustomAlert.genunityCheckNewResultPopup(self, value: self.showRetailerTable, reatilerTableView : self.retailerTable, selectedRetailerName: self.retailerName as NSString, frame: appDelegate.window?.frame ?? self.view.frame, title: NSLocalizedString("genuinity_check", comment: "") as NSString, message: scanResponseAcviss?.value(forKey: "uq_message") as? NSString ?? "N/A", buttonTitle1: scanResponseAcviss?.value(forKey: "buttonTitle1") as? NSString ?? "", buttonTitle2: scanResponseAcviss?.value(forKey: "buttonTitle2") as? NSString ?? "" , imgCorteva: UIImage(named:"corteva")!, statusLogo: self.stausLogo!, hideClose: true, rewardMessage: scanResponseAcviss?.value(forKey: "primaryRewardMsg") as? NSString ?? "", rewardMessage1: scanResponseAcviss?.value(forKey: "secondaryRewardMsg") as? NSString ?? "", showEncashBtn: scanResponseAcviss?.value(forKey: "showClickableLink") as? Bool ?? false,prodSerialNo: scanResponseAcviss?.value(forKey: "prodSerialNumber") as? NSString ?? "",cashBackMsg: self.strCashReward as NSString, productName: scanResponseAcviss?.value(forKey: "productName") as? NSString ?? "",  enableSprayService: scanResponseAcviss?.value(forKey: "enableSprayService") as? Bool ?? false,retailerList: scanResponseAcviss?.value(forKey: "retailerList") as? NSArray ?? []) as? UIView
                           appDelegate.window?.rootViewController?.view.addSubview(self.statusMsgAlert!)
                           self.retailerTable.reloadData()
    }
    
    func filterDataByName(_ data: [[String: Any]], searchText: String) -> [[String: Any]] {
        return data.filter { item in
            guard let name = item["name"] as? String else { return false }
            return name.lowercased().contains(searchText.lowercased())
        }
    }
    
    //MARK: UITableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("full count is",self.retailersList.count)
        return self.retailersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let retailerCell = retailerTable.dequeueReusableCell(withIdentifier: "retailerCell") as! RetailerCell
        
        let stateDic = retailersList.object(at: indexPath.row) as? NSDictionary
        print("what is in here:",stateDic!)
        print("static array item",stateDic?.value(forKey: "name") ?? "")
        retailerCell.lblRetailer.text = (stateDic?.value(forKey: "name") as? String ?? "")

        return retailerCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        self.stausLogo = UIImage(named: "GenuinitySuccess")
        let selectedList = retailersList.object(at: indexPath.row) as? NSDictionary
        print("the selected data",selectedList ?? "")
        self.retailerName = selectedList?["name"] as! String
        self.retailerID = String(format:"%i",selectedList!["id"] as? Int ?? 0)
        //String(describing: selectedList!["id"])
        
        print("the selected retailer name is",self.retailerName)
        print("the selected retailer ID is",self.retailerID)
                if(showRetailerTable == false){
                    self.showRetailerTable = true
                }
                else{
                    self.showRetailerTable = false
                }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.statusMsgAlert?.removeFromSuperview()
        self.statusMsgAlert = CustomAlert.genunityCheckNewResultPopup(self, value: self.showRetailerTable, reatilerTableView : self.retailerTable, selectedRetailerName: self.retailerName as NSString, frame: appDelegate.window?.frame ?? self.view.frame, title: NSLocalizedString("genuinity_check", comment: "") as NSString, message: scanResponseAcviss?.value(forKey: "uq_message") as? NSString ?? "N/A", buttonTitle1: scanResponseAcviss?.value(forKey: "buttonTitle1") as? NSString ?? "", buttonTitle2: scanResponseAcviss?.value(forKey: "buttonTitle2") as? NSString ?? "" , imgCorteva: UIImage(named:"corteva")!, statusLogo: self.stausLogo!, hideClose: true, rewardMessage: scanResponseAcviss?.value(forKey: "primaryRewardMsg") as? NSString ?? "", rewardMessage1: scanResponseAcviss?.value(forKey: "secondaryRewardMsg") as? NSString ?? "", showEncashBtn: scanResponseAcviss?.value(forKey: "showClickableLink") as? Bool ?? false,prodSerialNo: scanResponseAcviss?.value(forKey: "prodSerialNumber") as? NSString ?? "",cashBackMsg: self.strCashReward as NSString, productName: scanResponseAcviss?.value(forKey: "productName") as? NSString ?? "",  enableSprayService: scanResponseAcviss?.value(forKey: "enableSprayService") as? Bool ?? false,retailerList: scanResponseAcviss?.value(forKey: "retailerList") as? NSArray ?? []) as? UIView
                appDelegate.window?.rootViewController?.view.addSubview(self.statusMsgAlert!)
                self.retailerTable.reloadData()
//            }
//        }
        tableView.isHidden = true
        self.view.endEditing(true)
    }
    
}
extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else {
            preconditionFailure("Take a look to your format")
        }
        return date
    }
}
