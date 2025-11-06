//
//  AppDelegate.swift
//  PioneerFarmerConnect
//
//  Created by Empover on 13/12/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
//import FirebaseInstanceID
import FirebaseMessaging
import Alamofire
import CoreData
import UserNotifications
import FBSDKCoreKit
extension Bundle {
    static func swizzleLocalization() {
        let orginalSelector = #selector(localizedString(forKey:value:table:))
        guard let orginalMethod = class_getInstanceMethod(self, orginalSelector) else { return }
        
        let mySelector = #selector(myLocaLizedString(forKey:value:table:))
        guard let myMethod = class_getInstanceMethod(self, mySelector) else { return }
        
        if class_addMethod(self, orginalSelector, method_getImplementation(myMethod), method_getTypeEncoding(myMethod)) {
            class_replaceMethod(self, mySelector, method_getImplementation(orginalMethod), method_getTypeEncoding(orginalMethod))
        } else {
            method_exchangeImplementations(orginalMethod, myMethod)
        }
    }
    
    @objc private func myLocaLizedString(forKey key: String,value: String?, table: String?) -> String {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let bundlePath = Bundle.main.path(forResource: appDelegate.selectedLanguage, ofType: "lproj"),
            let bundle = Bundle(path: bundlePath) else {
                return Bundle.main.myLocaLizedString(forKey: key, value: value, table: table)
        }
        return bundle.myLocaLizedString(forKey: key, value: value, table: table)
    }
}
struct AppUtility {
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.myOrientation = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
    var window: UIWindow?
    var managedContext : NSManagedObjectContext?
    var previousLocationStr : String = ""
    var prevLocCoordinates : CLLocationCoordinate2D?
    var tempDictToSaveReqDetails : NSDictionary?
    var tempClassificationMutArray = NSMutableArray()

    var i = 0

    var selectedLanguage = ""
    var selectedLanguageName = ""
    var selectedlanguageID = ""

    var mutArrayToDownloadCropAdvisoryData = NSMutableArray()
    var cropDiagnosisDocumentsDirectory = NSString()
    /// used to iterate through mutArrayToDownloadCropAdvisoryData while downloading the assets
    var currentIndex:Int = 0
    var deviceId : String = ""
    var gcmRegId : NSString?
    var notificationDic : NSDictionary?
    var isNotificationnavigated : Bool = false
    static var isRequesterHelpShow : Bool = false
    var isTimeLine : Bool = false
    var isCropsUpdated : Bool = false
    var isIrrigationsUpdated : Bool = false
    var isSeasonsUpdated : Bool = false
    var isCompaniesUpdated : Bool = false
    var isTotalCropUpdated : Bool = false
    var isOpennedGenuinityCheckFromSidemMenu : Bool = false
    var isOpenedShopScanEarnFromSideMenu: Bool = false
    var isOpenedGenuinityCheckResultsFromSideMenu: Bool = false
    var isOpennedCropAdvisoryFromSidemMenu : Bool = false
    var isOpennedGenuinityCheckFromOffers : Bool = false
    var orientationLock = UIInterfaceOrientationMask.portrait
    var myOrientation: UIInterfaceOrientationMask = .portrait
    var numberOfScans : Int = 0
    
    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }


        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            
        ApplicationDelegate.shared.application(
                   application,
                   didFinishLaunchingWithOptions: launchOptions
               )
     
        GMSServices.provideAPIKey(Google_API_Key)
            GMSPlacesClient.provideAPIKey(Google_API_Key)
            //GMSServices.provideAPIKey("AIzaSyA8Orrd62f0b1wmKAkqFVJecwO55vmFWws") //Production
            //GMSPlacesClient.provideAPIKey("AIzaSyA8Orrd62f0b1wmKAkqFVJecwO55vmFWws") //Production
            LocationService.sharedInstance.locationManager?.requestLocation()
            LocationService.sharedInstance.locationManager?.startUpdatingLocation()
                         FirebaseApp.configure()
           Messaging.messaging().delegate = self
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "Landscape")
        defaults.synchronize()
        // Override point for customization after application launch.
        if launchOptions?.keys.contains(.userActivityDictionary) ?? false {
            if let activity = launchOptions![.userActivityDictionary] as? NSDictionary{
                if let userActivity = activity.value(forKey:UIApplicationLaunchOptionsKey.userActivityType.rawValue) as? NSUserActivity{
                    if userActivity.activityType == NSUserActivityTypeBrowsingWeb,let url = userActivity.webpageURL,let components = URLComponents(url: url, resolvingAgainstBaseURL: true){
                        //print(components)
                        Singleton.getRefferalCodeFromAppStoreUrl(url)
                    }
                }
            }
        }
       

        managedContext = managedObjectContext
        
    
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().previousNextDisplayMode = .alwaysHide
        
//        self.setStatusBarBackgroundColor(color: UIColor(red : 0/255 , green : 102/255 , blue : 0/255 ,alpha : 1.0))
//        self.setStatusBarBackgroundColor(color: App_Theme_Blue_Color)
       // UIApplication.shared.statusBarStyle = .lightContent
        
        cropDiagnosisDocumentsDirectory = self.getCropDiagnosisFolderPath() as NSString
        //print(cropDiagnosisDocumentsDirectory)
        if let isLogin = UserDefaults.standard.value(forKey: "login") as? Bool{
            if isLogin == true{
                let net = NetworkReachabilityManager(host: "www.google.com")
                if net?.isReachable == true{
                    let defaults = UserDefaults.standard
                    let parameters : NSDictionary?
                    var lastSyncTimeStr = ""
                    if defaults.value(forKey: "lastSyncedOn") != nil{
                        lastSyncTimeStr = defaults.value(forKey: "lastSyncedOn") as! String
                    }
                    parameters = ["lastUpdatedTime":lastSyncTimeStr] as NSDictionary
                    
                    let paramsStr1 = Constatnts.nsobjectToJSON(parameters!)
                    let params =  ["data": paramsStr1]
                    self.requestToGetCropDiagnosisMasterData(Params: params as [String:String])
                    var notificationlastSyncTimeStr = ""
                                     if defaults.value(forKey: "lastSyncTime") != nil{
                                         notificationlastSyncTimeStr = defaults.value(forKey: "lastSyncTime") as! String
                                     }
                                 let userObj = Constatnts.getUserObject()
                                            

                    let notificationParameters = ["lastUpdated":notificationlastSyncTimeStr,
                                                   "deviceToken": userObj.deviceToken as String,
                                                   "mobileNo": userObj.mobileNumber! as String,
                                                   "customerId": userObj.customerId! as String,
                                                   "deviceId": userObj.deviceId! as String] as? NSDictionary
                                     
                                     let paramsJWT = Constatnts.nsobjectToJSON(notificationParameters!)
                                     let notificationParams =  ["data": paramsJWT]
                          PushNotificationServiceManager.requestToGetUnreadNotificationsCount(Params: notificationParams) { (status) in
                              print("xh")
                          }
                }
                else{
                    //self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                }
            }
        }
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
              application.registerForRemoteNotifications()
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
           
            UNUserNotificationCenter.current().delegate = self
             application.registerUserNotificationSettings(settings)
        }
       
        
                  // For iOS 10 data message (sent via FCM)
               
     
       
        
        // [END register_for_notifications]
        
       /* if UserDefaults.standard.value(forKey: "AppleLanguages") != nil {
            selectedLanguage = UserDefaults.standard.value(forKey: "AppleLanguages") as? String ?? "en"
        }
        else{
            selectedLanguage = "en"
        }*/
        if UserDefaults.standard.value(forKey: "selectedLanguage") as? String != ""{
            selectedLanguage = UserDefaults.standard.value(forKey: "selectedLanguage") as? String ?? "en"
        }else{
            selectedLanguage = "en"
        }
       Bundle.swizzleLocalization()

       
       
       
        IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText = NSLocalizedString("done", comment: "")
//       let instance = InstanceID.instanceID()
//             instance.deleteID { (error) in
//                 print(error.debugDescription)
//             }
//             Messaging.messaging().shouldEstablishDirectChannel = true
                 ConnectToFCM()
        
        let remoteNotif = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable : Any]
               //let openUrl = launchOptions?[UIApplicationLaunchOptionsKey.url] as? NSDictionary
               
               if remoteNotif != nil {
                   //let itemName = remoteNotif?["aps"] as! String
                   //print("Custom: \(itemName)")
                
                notificationDic = remoteNotif as NSDictionary?
                   isNotificationnavigated = true
                   // Print full message.
                   print("Message: \(String(describing: remoteNotif))")
                self.application(application, didReceiveRemoteNotification: remoteNotif!)
                   //FIRAnalytics.logEvent(withName: App_Open_Source_Event, parameters: [App_Open_Source_Param : "notification" as NSObject])
               }else{
                
                UIApplication.shared.applicationIconBadgeNumber = 0
        }
        return true
    }
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//
//        return myOrientation
//
//    }
    
    func getCPFABPdfFolderPath() -> String{
             let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
             let url = NSURL(fileURLWithPath: path)
             let filePath = url.appendingPathComponent("CPFABPdf")?.path
             let fileManager = FileManager.default
             if fileManager.fileExists(atPath: filePath!) {
                 // print("FILE AVAILABLE")
                 return filePath!
             }
             else {
                 //print("FILE NOT AVAILABLE")
                 do {
                     try fileManager.createDirectory(atPath: filePath!, withIntermediateDirectories: false,attributes: nil)
                 }
                 catch {
                     //print("Error creating record files folder in documents dir: \(error)")
                     return ""
                 }
                 return filePath!
             }
         }
    //MARK: requestToGetCropDiagnosisMasterData
    @objc func requestToGetCropDiagnosisMasterData(Params:[String:String]){
        //SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [CDI_BASE_URL,CROP_DIAGNOSIS_MASTER_DATA])
        let userObj = Constatnts.getUserObject()
        
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        print(headers)
        
        Alamofire.request(urlString, method: .post, parameters: Params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
//            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    print(json)
                    if let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String{
                        if responseStatusCode == STATUS_CODE_200{
                            let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                            let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                            print("Response after decrypting data:\(decryptData)")
                            do {
                                let outputDict = try JSONSerialization.data(withJSONObject: decryptData, options: JSONSerialization.WritingOptions.prettyPrinted)
                                let jsonSTr = NSString(data: outputDict, encoding: String.Encoding.utf8.rawValue)! as String
                                print(jsonSTr)
                            }
                            catch{
                                
                            }
                            
                            let defaults = UserDefaults.standard
                            defaults.set(decryptData.value(forKey: "lastSyncedOn") as! String, forKey: "lastSyncedOn")
                            defaults.synchronize()
                            
                            // self.deleteDiseasePrescriptionDetails()
                            //self.deleteAgroProductsDetails()
                            // self.mutArrayToDownloadCropAdvisoryData.removeAllObjects()
                            let diseasesArray = decryptData.value(forKey: "diseasePrescriptions") as! NSArray
                            for i in 0 ..< diseasesArray.count{
                                let diseasesDict = diseasesArray.object(at: i) as? NSDictionary
                                let diseasesData = DiseasePrescriptions(dict:diseasesDict!)
                                self.saveDiseasePrescriptionDetails(diseasesData)
                                
                                let diseaseImgStr = diseasesDict?.value(forKey: "diseaseImageFile") as? String
                                
                                let productImageAvailable = Validations.checkKeyNotAvail(diseasesDict!, key: "productMappingImage") as! String
                                
                                if Validations.isNullString(productImageAvailable as NSString) == false {
                                    if Validations.isNullString(diseasesDict?.value(forKey: "productMappingImage") as! NSString) == false{
                                        let textStr = diseasesDict?.value(forKey: "productMappingImage") as? String
                                        let productMapping = textStr?.components(separatedBy: ",")
                                        for i in (0..<(productMapping?.count)!){
                                            self.mutArrayToDownloadCropAdvisoryData.add(productMapping![i])
                                        }
                                    }
                                }
                                self.mutArrayToDownloadCropAdvisoryData.add(diseaseImgStr!)
                            }
                            
                            let productMasterArray = decryptData.value(forKey: "agroProductMasters") as! NSArray
                            for i in 0 ..< productMasterArray.count{
                                let productMasterDict = productMasterArray.object(at: i) as? NSDictionary
                                let productData = AgroProductMaster(dict:productMasterDict!)
                                self.saveAgroProductsDetails(productData)
                                
                                let productImageAvailable = Validations.checkKeyNotAvail(productMasterDict!, key: "productImage") as! String
                                if Validations.isNullString(productImageAvailable as NSString) == false {
                                    let productImgStr = productMasterDict?.value(forKey: "productImage") as? String
                                    self.mutArrayToDownloadCropAdvisoryData.add(productImgStr!)
                                }
                            }
                            
                            //print(self.mutArrayToDownloadCropAdvisoryData)
                            
                            if Reachability.isConnectedToNetwork(){
                                self.checkCropDiagnosisAssetsToBeDownloaded()
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: checkCropDiagnosisAssetsToBeDownloaded
    func checkCropDiagnosisAssetsToBeDownloaded(){
        if currentIndex < self.mutArrayToDownloadCropAdvisoryData.count {
            let assetStr = self.mutArrayToDownloadCropAdvisoryData.object(at: currentIndex)
            self.downloadAssetAndStore(inDocumentsDirectory: assetStr as! NSString)
            currentIndex+=1
            self.checkCropDiagnosisAssetsToBeDownloaded()
        }
    }
    
    //MARK: getDocumentPath
    /**
     get the CroAdvisoryAssets Folder path of Documents directory
     - Parameter assetStr: NSString
     - Returns: NSString
     */
    func getDocumentPath(_ assetStr: NSString) -> NSString {
        let assetArr = assetStr.components(separatedBy: "/") as NSArray
        let filePath = String(format: "%@/%@", cropDiagnosisDocumentsDirectory,assetArr.lastObject as! NSString) as NSString
        return filePath
    }
    
    //MARK: checkIfFileExists
    func checkIfFileExists(atPath strPath: String) -> Bool {
        let fileExists: Bool = FileManager.default.fileExists(atPath: strPath)
        return fileExists
    }
    
    //MARK: downloadAssetAndStore
    func downloadAssetAndStore(inDocumentsDirectory assetStr: NSString) {
        let docPath = self.getDocumentPath(assetStr)
        let isFileExists = self.checkIfFileExists(atPath: docPath as String)
        if isFileExists == false {
            print(assetStr)
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                let url = NSURL(fileURLWithPath: docPath as String)
                return (url as URL, [.removePreviousFile])
            }
            //let urlToDownload = String(format:"%@", dictDocument.value(forKey: "voiceFileName") as! String)
            //print("download started :\(urlToDownload)")
            Alamofire.download(assetStr as String, to: destination).response { response in
                if response.destinationURL != nil {
                    //print(response.destinationURL!)
                }
                else{
                }
            }
        }
        else{
            print("asset available")
        }
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        if #available(iOS 13.0, *) {
            let statusBar1 =  UIView()
            statusBar1.frame = UIApplication.shared.statusBarFrame
            statusBar1.backgroundColor = color
            UIApplication.shared.keyWindow?.addSubview(statusBar1)
            
        }else{
            guard let statusBar = (UIApplication.shared.value(forKey: "statusBarWindow") as AnyObject?)?.value(forKey: "statusBar") as! UIView? else {
                return
            }
            statusBar.backgroundColor = color
        }
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
      
     
        NotificationCenter.default.post(name: Notification.Name("UpdateLatLong"), object: nil)
        
        if let isLogin = UserDefaults.standard.value(forKey: "login") as? Bool{
            if isLogin == true{
                let net = NetworkReachabilityManager(host: "www.google.com")
                if net?.isReachable == true{
                    AppDelegate.requestToCheckForceUpdateMobileVersion()
                }
            }
        }
        self.ConnectToFCM()
    }
     // [START connect_to_fcm]
     func ConnectToFCM() {
       //  Messaging.messaging().shouldEstablishDirectChannel = true

  
        
        Messaging.messaging().token { token, error in
            if let error = error {
              print("Error fetching remote instance ID: \(error)")
            } else if let result = token {
              print("Remote instance ID token: \(token)")
             self.gcmRegId  = "\(token)" as NSString
                    if let isLogin = UserDefaults.standard.value(forKey: "login") as? Bool{
                        if isLogin == true{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                        let fcm = Messaging.messaging().fcmToken
                        if fcm != nil  && fcm != "" {
                        print(fcm!)
                        HomeViewController.fireBasePusnoticicatinsIdRegistrationWithUser(gcmId: fcm! ?? "")
                        }
                })
//                         DispatchQueue.main.async {
//                               HomeViewController.fireBasePusnoticicatinsIdRegistrationWithUser(gcmId: self.gcmRegId! as String)
//                         }
                          
                        }
                    }
              
            }
        }
     }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        self.gcmRegId  = "\(fcmToken)" as NSString
        if let isLogin = UserDefaults.standard.value(forKey: "login") as? Bool{
            if isLogin == true{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                let fcm = Messaging.messaging().fcmToken
                if fcm != nil  && fcm != "" {
                print(fcm!)
                HomeViewController.fireBasePusnoticicatinsIdRegistrationWithUser(gcmId: fcm! ?? "")
                }
            })
//                HomeViewController.fireBasePusnoticicatinsIdRegistrationWithUser(gcmId: self.gcmRegId! as String)
            }
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
   
//        let myOrientation1 =  dele.application(application, supportedInterfaceOrientationsFor: window)
 
            if let isLogin = UserDefaults.standard.value(forKey: "Landscape") as? Bool{
                print("isLogin : \(isLogin)")
                if isLogin == true{
                    print("isLogin::::::: : \(isLogin)")
                    return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.RawValue(Int(UIInterfaceOrientationMask.landscapeRight.rawValue)))
                    
                }
                else{
                    return myOrientation
                }
            }
          return myOrientation//UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.RawValue(Int(UIInterfaceOrientationMask.portrait.rawValue)))
           // return myOrientation
        }

    //    }
    //MARK: Handle Url Link Clicks And Open Url Schemas
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let url = userActivity.webpageURL,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                return false
        }
        print(components)
        Singleton.getRefferalCodeFromAppStoreUrl(url)
        return true
        //http://dev.goyawo.com/story/p6?uid=563
        
    }

    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        ApplicationDelegate.shared.application(
            application,
                   open: url,
                   sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                   annotation: options[UIApplication.OpenURLOptionsKey.annotation]
               )
     /*      let urlString = url.absoluteString
            weak var tracker = GAI.sharedInstance().tracker(
                withName: "tracker",
                trackingId: "UA-XXXX-Y")
            // setCampaignParametersFromUrl: parses Google Analytics campaign ("UTM")
            // parameters from a string url into a Map that can be set on a Tracker.
            let hitParams = GAIDictionaryBuilder()
            // Set campaign data on the map, not the tracker directly because it only
            // needs to be sent once.
            hitParams.campaignParametersFromUrl = urlString
            // Campaign source is the only required campaign field. If previous call
            // did not set a campaign source, use the hostname as a referrer instead.
            if !hitParams.get(kGAICampaignSource) && (url.host?.count ?? 0) != 0 {
                // Set campaign data on the map, not the tracker.
                hitParams.set("referrer", forKey: kGAICampaignMedium)
                hitParams.set(url.host, forKey: kGAICampaignSource)
            }
            let hitParamsDict = hitParams.build()
            // A screen name is required for a screen view.
            tracker?.set(kGAIScreenName, value: "screen name")
            // Previous V3 SDK versions.
            // [tracker send:[[[GAIDictionaryBuilder createAppView] setAll:hitParamsDict] build]];
            // SDK Version 3.08 and up.
            tracker?.send(GAIDictionaryBuilder.createScreenView().setAll(hitParamsDict).build()) */
        
        //Singleton.getRefferalCodeFromAppStoreUrl(url)
        if let isLogin = UserDefaults.standard.value(forKey: "login") as? Bool{
            let deepLinkParams = Singleton.getParametersFromDeeplinkingUrl(url)
            Singleton.sharedInstance.deepLinkParams = deepLinkParams!
            Singleton.sharedInstance.isFromDeepLink = true
            self.isNotificationnavigated = false
            if isLogin == true{
                let currentViewController = UIApplication.topViewController()
                if UIApplication.shared.applicationState == .active{
                }
                if (currentViewController?.isKind(of: DLDemoRootViewController.self))!{
                    let tempController = currentViewController as? DLDemoRootViewController
                    if let hamburguerViewController =  tempController?.contentViewController{
                        let navController  = hamburguerViewController as? UINavigationController
                        let visibleViewController = navController?.visibleViewController
                        if visibleViewController?.isKind(of: HomeViewController.self) == true{
                            if let homeController = visibleViewController as? HomeViewController{
                                homeController.deepLinkNavigationToRespectivePage(deepLinkParams)
                            }
                            else{
                                Singleton.sharedInstance.isFromDeepLink = false
                                Singleton.sharedInstance.deepLinkParams = nil
                                visibleViewController?.deeplinkHandlerNavigation(deepLinkParams: deepLinkParams! as! [String : AnyObject])
                            }
                        }
                        else{
                            Singleton.sharedInstance.isFromDeepLink = false
                            Singleton.sharedInstance.deepLinkParams = nil
                            visibleViewController?.deeplinkHandlerNavigation(deepLinkParams: deepLinkParams as! [String : AnyObject])
                        }
                    }
                }
                //let currentViewController = UIApplication.topViewController()
                //currentViewController?.deeplinkHandlerNavigation(deepLinkParams: deepLinkParams!)
                return true
            }
            else{
                return false
            }
        }
        return true
    }
    
    func handleReceivedNotificationScreenNavigation(userInfo: NSDictionary){
        if let notification_type = userInfo[Notification_User_Type] as? NSString{
            if notification_type == Notification_Type_Provider{
                let currentViewController = UIApplication.topViewController()
                if currentViewController?.isKind(of: MyOrdersSegmentViewController.self) == false{
                    currentViewController?.notificationsHandlerNavigation(notificationDic: userInfo as NSDictionary)
                }
            }
            else if notification_type == Notification_Type_Requester{
                let currentViewController = UIApplication.topViewController()
                if currentViewController?.isKind(of: RequesterOrdersViewController.self) == false{
                    currentViewController?.notificationsHandlerNavigation(notificationDic: userInfo as NSDictionary)
                }
            }
            else if notification_type == Notification_Type_Requester_Home{
                let currentViewController = UIApplication.topViewController()
                if currentViewController?.isKind(of: RequesterViewController.self) == false{
                    currentViewController?.notificationsHandlerNavigation(notificationDic: userInfo as NSDictionary)
                }
            }
            else if notification_type == Notification_Type_Provider_Home{
                let currentViewController = UIApplication.topViewController()
                if currentViewController?.isKind(of: EquipmentsViewController.self) == false{
                    currentViewController?.notificationsHandlerNavigation(notificationDic: userInfo as NSDictionary)
                }
            }
        }
        /*if let notification_type = userInfo[notificationType] as? NSString{
         if notification_type == Notification_Type_Follow  || notification_type == Notification_Type_Story_Add || notification_type == Notification_Type_Milestone_Follow{
         let currentViewController = UIApplication.topViewController()
         if currentViewController?.isKind(of: MyStoriesViewController.self) == false{
         currentViewController?.notificationsHandlerNavigation(notificationDic: userInfo as NSDictionary)
         }
         }
         else if notification_type == Notification_Type_Listen || notification_type == Notification_Type_Share || notification_type == Notification_Type_Milestone_Like || notification_type == Notification_Type_Milestone_Listen{
         let currentViewController = UIApplication.topViewController()
         if currentViewController?.isKind(of: StoryDetailsViewController.self) == false{
         currentViewController?.notificationsHandlerNavigation(notificationDic: userInfo as NSDictionary)
         }
         }
         else if notification_type == Notification_Type_Comment{
         let currentViewController = UIApplication.topViewController()
         if currentViewController?.isKind(of: CommentsViewController.self) == false{
         currentViewController?.notificationsHandlerNavigation(notificationDic: userInfo as NSDictionary)
         }
         }
         
         }*/
    }
    // [START refresh_token]
    @objc func tokenRefreshNotification(_ notification: Notification) {
        print(notification)
       
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = token {
                let refreshedToken = token

                print("InstanceID token: \(refreshedToken)")
                UserDefaults.standard.setValue(refreshedToken, forKey: "gcmId")
                self.gcmRegId = refreshedToken as NSString?
                if Validations.isNullString(refreshedToken as? NSString ?? "") == false{
                    HomeViewController.fireBasePusnoticicatinsIdRegistrationWithUser(gcmId: refreshedToken ?? "")
                }
            }
        }
        // Connect to FCM since connection may have failed when attempted before having a token.
        ConnectToFCM()
    }
    // [END refresh_token]
    

    // [END connect_to_fcm]
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the InstanceID token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        //let characterSet: NSCharacterSet = NSCharacterSet(charactersIn: "<>")
        //let deviceTokenString: String = (deviceToken.description as NSString).trimmingCharacters(in: characterSet as CharacterSet).replacingOccurrences(of: " ", with: "")
        let device_Id = deviceToken.map { String(format: "%02.2hhx", $0) }.joined() as NSString//deviceTokenString
        User_Deviceid = device_Id
        self.deviceId = device_Id as String
        UserDefaults.standard.set(device_Id, forKey: "DeviceId")
        print("APNs token retrieved: \(User_Deviceid)")
      //  Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
      Messaging.messaging().apnsToken = deviceToken
        
        //InstanceID.instanceID().setAPNSToken(deviceToken, type: InstanceIDAPNSTokenType.sandbox)
        //InstanceID.instanceID().setAPNSToken(deviceToken, type: InstanceIDAPNSTokenType.prod)
        
//        InstanceID.instanceID().instanceID { (result, error) in
//            if let error = error {
//                print("Error fetching remote instange ID: \(error)")
//            } else if let result = result {
//                let refreshedToken = result.token
//                if let isLogin = UserDefaults.standard.value(forKey: "login") as? Bool{
//                    if isLogin == true{
//                        HomeViewController.fireBasePusnoticicatinsIdRegistrationWithUser(gcmId: refreshedToken)
//                    }
//                }
//            }
//        }
//        if let refreshedToken = InstanceID.instanceID().token() {
//            if let isLogin = UserDefaults.standard.value(forKey: "login") as? Bool{
//                if isLogin == true{
//                    HomeViewController.fireBasePusnoticicatinsIdRegistrationWithUser(gcmId: refreshedToken)
//                }
//            }
//        }
        // With swizzling disabled you must set the APNs token here.
        // FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
    }
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        if application.applicationState == .active{
            if isNotificationnavigated == false {
                isNotificationnavigated = true
                handleReceivedNotificationScreenNavigation(userInfo: userInfo as NSDictionary)
            }
        }
        
    }
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//          let instance = InstanceID.instanceID()
//          instance.deleteID { (error) in
//              print(error.debugDescription)
//          }
//
//                 InstanceID.instanceID().instanceID { (result, error) in
//                          if let error = error {
//                            print("Error fetching remote instance ID: \(error)")
//                          } else if let result = result {
//                            print("Remote instance ID token: \(result.token)")
//                            self.gcmRegId  = "Remote InstanceID token: \(result.token)" as NSString
//                              if let isLogin = UserDefaults.standard.value(forKey: "login") as? Bool{
//                                  if isLogin == true{
//                                    HomeViewController.fireBasePusnoticicatinsIdRegistrationWithUser(gcmId: self.gcmRegId! as String)
//                                  }
//                              }
//                          }
//                        }
//
//          Messaging.messaging().shouldEstablishDirectChannel = true
//    }
    
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//      print("Firebase registration token: \(fcmToken)")
//        let dataDict:[String: String] = ["token": fcmToken]
////      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
//        UserDefaults.standard.setValue(fcmToken, forKey: "fcmToken")
//               UserDefaults.standard.synchronize()
//        if let isLogin = UserDefaults.standard.value(forKey: "login") as? Bool{
//                         if isLogin == true{
//                            DispatchQueue.main.async {
//                                HomeViewController.fireBasePusnoticicatinsIdRegistrationWithUser(gcmId: fcmToken)
//
//                            }
//                         }
//                     }
//
////connectToFcm()
//      // TODO: If necessary send token to application server.
//      // Note: This callback is fired at each app startup and whenever a new token is generated.
//    }


    /**refresh
     It redirects to the folder **OnlineData** in **CropAdvisory Directory** else new folder is created
     - Remark: used to store all downloaded assets of **Crop Advisory** data when there is a active internet connection
     - Returns: String
     */
    func getCropAdvisoryFolderPath() -> String{
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.appendingPathComponent("CropAdvisory")?.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath!) {
            //  print("FILE AVAILABLE")
            return filePath!
        } else {
            // print("FILE NOT AVAILABLE")
            do {
                try fileManager.createDirectory(atPath: filePath!, withIntermediateDirectories: false,attributes: nil)
            }
            catch {
                // print("Error creating record files folder in documents dir: \(error)")
                return ""
            }
            return filePath!
        }
    }
    
    // [END ios_10_data_message_handling]
    //MARK: requestToCheckForceUpdateMobileVersion
    /**
     Request sent to server with appVersionCode and deviceType as Parameters
     */
    public class func requestToCheckForceUpdateMobileVersion()
    {

        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! NSString
        //let versionFloat = NSNumber(value: version.doubleValue)
        let parameters = ["appVersionName":version, "deviceType":"iOS"] as [String : Any]
        
        print(parameters)
        //        let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
        //        let params =  ["data" : paramsStr]
        //        print(params)
        
        SwiftLoader.show(animated: true)
        
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,FORCE_UPDATE_MOBILE_VERSION_DATA])
        
        let userObj = Constatnts.getUserObject()
        
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        print(headers)
        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response)
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        //                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        //                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        
                        let respData = ((json as! NSDictionary).value(forKey: "response") as! NSString).replacingOccurrences(of: "\\", with: "")
                        
                        if let data = respData.data(using: String.Encoding.utf8) {
                            do {
                                let outputDict:NSDictionary = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                                
                                var appVersionCode = Validations.checkKeyNotAvail(outputDict, key: "appVersionName") as? NSString
                                let releaseFeature = Validations.checkKeyNotAvail(outputDict, key: "releaseFeature") as? NSString
                                //let appVersionName = Validations.checkDateKeyNotAvail(decryptData, key: "appVersionName") as? NSString
                                let forceMandatoryUpdate = Validations.checkKeyNotAvail(outputDict, key: "mandatoryUpdate") as? Int64
                                let forceUpdate = Validations.checkKeyNotAvail(outputDict, key: "forceUpdate") as? Int64
                                let userLogsAllPrint = Validations.checkKeyNotAvail(outputDict, key: "userLogsAllPrint") as? Int64
                                
                                
                                
                                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                                let presentController = appDelegate?.window?.rootViewController
                                //let numberFormatter = NumberFormatter()
                                if appVersionCode == nil{
                                    appVersionCode = version
                                }
                                //let versionValue = version.floatValue
                                //let appVersionValue = appVersionCode!.floatValue
                                if version != appVersionCode{
                                    if (forceMandatoryUpdate == 1 && forceUpdate == 1) || forceMandatoryUpdate == 1{
                                        let alertController = UIAlertController(title: "", message: releaseFeature as String?, preferredStyle: .alert)
                                        
                                        alertController.addAction(UIAlertAction(title: "Update", style: .default, handler: {
                                            alert -> Void in
                                            let url  = NSURL(string: "https://itunes.apple.com/in/app/pioneer-farmer-connect/id1334134143?mt=8")
                                            if UIApplication.shared.canOpenURL(url! as URL) {
                                                if #available(iOS 10.0, *) {
                                                    UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
                                                } else {
                                                    // Fallback on earlier versions
                                                    UIApplication.shared.openURL(url! as URL)
                                                }
                                            }
                                        }))
                                        presentController?.present(alertController, animated: true, completion: nil)
                                    }
                                    else if forceMandatoryUpdate == 1 || forceUpdate == 1{
                                        let alertView = Validations.showModalAlertView("", releaseFeature!, cancelTitle: "Ignore", okTitle: "Update", cancelHandler: { (alertControl) in
                                            
                                        }, okHandler: { (AlertControl) in
                                            let url  = NSURL(string: "https://itunes.apple.com/in/app/pioneer-farmer-connect/id1334134143?mt=8")
                                            if UIApplication.shared.canOpenURL(url! as URL) {
                                                if #available(iOS 10.0, *) {
                                                    UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
                                                } else {
                                                    // Fallback on earlier versions
                                                    UIApplication.shared.openURL(url! as URL)
                                                }
                                            }
                                        })
                                        presentController?.present(alertView, animated: true, completion: nil)
                                    }
                                }
                                
                                if outputDict.value(forKey: "userMenuControl") != nil{
                                    if let diction = outputDict.value(forKey: "userMenuControl") as? NSDictionary {
                                        if let showObj = diction.value(forKey: "rewardsSchemeAvailable") as? Bool {
                                            let userObj = Constatnts.getUserObject()
                                            userObj.showRewardsScheme = String(showObj) as NSString
                                        }
                                    }
                                }
                                
                                if let cropDiagnosisObj = outputDict.value(forKey: "showCropDiagnosis") as? Bool {
                                    let showCropDiagnosis = String(cropDiagnosisObj) as NSString
                                    if showCropDiagnosis == "true"{
                                        if let cropObj = outputDict.value(forKey: "crop") as? String {
                                            let userObj = Constatnts.getUserObject()
                                            userObj.crop = cropObj as NSString
                                            userObj.showCropDiagnosis = showCropDiagnosis
                                            Constatnts.setUserToUserDefaults(user: userObj)
                                            //NotificationCenter.default.post(name: Notification.Name("UpdateDashboard"), object: nil)
                                            //NotificationCenter.default.post(name: Notification.Name("UpdateSideMenuData"), object: nil)
                                        }
                                    }
                                    else{
                                        let userObj = Constatnts.getUserObject()
                                        userObj.showCropDiagnosis = showCropDiagnosis
                                        Constatnts.setUserToUserDefaults(user: userObj)
                                        //NotificationCenter.default.post(name: Notification.Name("UpdateDashboard"), object: nil)
                                        //NotificationCenter.default.post(name: Notification.Name("UpdateSideMenuData"), object: nil)
                                    }
                                }
                                if let germinationObj = outputDict.value(forKey: "showGermination") as? Bool {
                                    let userObj = Constatnts.getUserObject()
                                    userObj.showGermination = "false"
                                    if germinationObj == true{
                                        userObj.showGermination = "true"
                                    }
                                    Constatnts.setUserToUserDefaults(user: userObj)
                                    //NotificationCenter.default.post(name: Notification.Name("UpdateDashboard"), object: nil)
                                    //NotificationCenter.default.post(name: Notification.Name("UpdateSideMenuData"), object: nil)
                                }
                                if let pravaktaObj = outputDict.value(forKey: "pravaktaMyBooklets") as? Bool {
                                    let userObj = Constatnts.getUserObject()
                                    userObj.pravaktaMyBooklets = "false"
                                    if pravaktaObj == true{
                                        userObj.pravaktaMyBooklets = "true"
                                    }
                                    Constatnts.setUserToUserDefaults(user: userObj)
                                    //NotificationCenter.default.post(name: Notification.Name("UpdateDashboard"), object: nil)
                                    //NotificationCenter.default.post(name: Notification.Name("UpdateSideMenuData"), object: nil)
                                }
                                
                                if outputDict.value(forKey: "userMenuControl") != nil{
                                    if let diction = outputDict.value(forKey: "userMenuControl") as? NSDictionary {
                                        if let shopScanEarnObj = diction.value(forKey: "shopScanWinProg") as? Bool {
                                            let userObj = Constatnts.getUserObject()
                                            userObj.enableShopScanWin = "false"
                                            if shopScanEarnObj == true{
                                                userObj.enableShopScanWin = "true"
                                            }
                                            Constatnts.setUserToUserDefaults(user: userObj)
                                        }
                                    }
                                }
                                
                                if outputDict.value(forKey: "userMenuControl") != nil{
                                    if let diction = outputDict.value(forKey: "userMenuControl") as? NSDictionary {
                                        if let GenuinityCheckScannerObj = diction.value(forKey: "genunityReport") as? Bool {
                                            let userObj = Constatnts.getUserObject()
                                            userObj.enableGenuinityCheckresults = "false"
                                            if GenuinityCheckScannerObj == true{
                                                userObj.enableGenuinityCheckresults = "true"
                                            }
                                            Constatnts.setUserToUserDefaults(user: userObj)
                                        }
                                    }
                                }
                            
                                
                                if let optInWhatsAppObj = outputDict.value(forKey: "optInWhatsApp") as? Bool {
                                    let userObj = Constatnts.getUserObject()
                                    userObj.optInWhatsApp = "false"
                                    if optInWhatsAppObj == true{
                                        userObj.optInWhatsApp = "true"
                                    }
                                    Constatnts.setUserToUserDefaults(user: userObj)
                                }
                                if let userLogsAllPrintObj = outputDict.value(forKey: "userLogsAllPrint") as? Bool {
                                    let userObj = Constatnts.getUserObject()
                                    userObj.userLogsAllPrint = "false"
                                    if userLogsAllPrintObj == true{
                                        userObj.userLogsAllPrint = "true"
                                    }
                                    Constatnts.setUserToUserDefaults(user: userObj)
                                }
                                if let userLogsGenuinityPrintObj = outputDict.value(forKey: "userLogsGenuinityPrint") as? Bool {
                                    let userObj = Constatnts.getUserObject()
                                    userObj.userLogsGenuinityPrint = "false"
                                    if userLogsGenuinityPrintObj == true{
                                        userObj.userLogsGenuinityPrint = "true"
                                    }
                                    Constatnts.setUserToUserDefaults(user: userObj)
                                }
                                
                                
                                
                                if let pravaktaObj = outputDict.value(forKey: "pravakta") as? Bool {
                                    let userObj = Constatnts.getUserObject()
                                    userObj.pravakta = "false"
                                    if pravaktaObj == true{
                                        userObj.pravakta = "true"
                                    }
                                    Constatnts.setUserToUserDefaults(user: userObj)
                                }
                                if let enableSprayServiceObj = outputDict.value(forKey: "enableSprayService") as? Bool {
                                    let userObj = Constatnts.getUserObject()
                                    userObj.enableSprayService = "false"
                                    if enableSprayServiceObj == true{
                                        userObj.enableSprayService = "true"
                                    }
                                    Constatnts.setUserToUserDefaults(user: userObj)
                                }
                                if let sprayVendorObj = outputDict.value(forKey: "sprayVendor") as? Bool {
                                    let userObj = Constatnts.getUserObject()
                                    userObj.sprayVendor = "false"
                                    if sprayVendorObj == true{
                                        userObj.sprayVendor = "true"
                                    }
                                    Constatnts.setUserToUserDefaults(user: userObj)
                                }
                                if let sprayVendorObj = outputDict.value(forKey: "subscribedSprayServices") as? Bool {
                                    let userObj = Constatnts.getUserObject()
                                    userObj.subscribedSprayServices = "false"
                                    if sprayVendorObj == true{
                                        userObj.subscribedSprayServices = "true"
                                    }
                                    Constatnts.setUserToUserDefaults(user: userObj)
                                }
                                if let deepLinkingString = outputDict.value(forKey: "myReferShortenUrl") as? String{
                                    let userObj = Constatnts.getUserObject()
                                    userObj.deepLinkingString = deepLinkingString as? NSString
                                    Constatnts.setUserToUserDefaults(user: userObj)
                                }
                                
                                NotificationCenter.default.post(name: Notification.Name("UpdateDashboard"), object: nil)
                                //NotificationCenter.default.post(name: Notification.Name("UpdateSideMenuData"), object: nil)
                            }
                            catch{
                                
                            }
                        }
                    }
                    else if responseStatusCode == STATUS_CODE_601{
                        Constatnts.logOut()
                    }
                    else if responseStatusCode == STATUS_CODE_500{
                        print((json as! NSDictionary).value(forKey: "message") as! String)
                    }
                }
            }
        }
    }
    
    //MARK: saveCropAdvisoryDetails
    func saveCropAdvisoryDetails(_ details : CropAdvisoryNotifications)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CropAdvisoryDetails")
        fetchRequest.predicate = NSPredicate(format: "caRequestMasterId = %@",details.caRequestMasterId!)
        
        do {
            let results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            
            //update record
            if results.count > 0 {
                
                // print("already saved")
                
                //self.window?.makeToast("Crop Advisory Details Already Saved", duration: 1.0, position: .center)
                
                let managedObject = results[0]
                
                managedObject.setValue(details.caRequestMasterId, forKey: "caRequestMasterId")
                managedObject.setValue(details.categoryId, forKey: "categoryId")
                managedObject.setValue(details.categoryName, forKey: "categoryName")
                managedObject.setValue(details.stateId, forKey: "stateId")
                managedObject.setValue(details.stateName, forKey: "stateName")
                managedObject.setValue(details.cropId, forKey: "cropId")
                managedObject.setValue(details.cropName, forKey: "cropName")
                managedObject.setValue(details.hybridId, forKey: "hybridId")
                managedObject.setValue(details.hybridName, forKey: "hybridName")
                managedObject.setValue(details.seasonId, forKey: "seasonId")
                managedObject.setValue(details.seasonName, forKey: "seasonName")
                managedObject.setValue(details.sowingDate, forKey: "sowingDate")
                managedObject.setValue(NSKeyedArchiver.archivedData(withRootObject: details.messageList!), forKey: "cropAdvisoryStages")
                
                try managedContext!.save()
                
                return
            }
            else{//insert new record
                
                let entity =  NSEntityDescription.entity(forEntityName: "CropAdvisoryDetails",in:managedContext!)
                
                let managedObject = NSManagedObject(entity: entity!,insertInto: managedContext)
                
                managedObject.setValue(details.caRequestMasterId, forKey: "caRequestMasterId")
                managedObject.setValue(details.categoryId, forKey: "categoryId")
                managedObject.setValue(details.categoryName, forKey: "categoryName")
                managedObject.setValue(details.stateId, forKey: "stateId")
                managedObject.setValue(details.stateName, forKey: "stateName")
                managedObject.setValue(details.cropId, forKey: "cropId")
                managedObject.setValue(details.cropName, forKey: "cropName")
                managedObject.setValue(details.hybridId, forKey: "hybridId")
                managedObject.setValue(details.hybridName, forKey: "hybridName")
                managedObject.setValue(details.seasonId, forKey: "seasonId")
                managedObject.setValue(details.seasonName, forKey: "seasonName")
                managedObject.setValue(details.sowingDate, forKey: "sowingDate")
                managedObject.setValue(NSKeyedArchiver.archivedData(withRootObject: details.messageList!), forKey: "cropAdvisoryStages")
                
                do {
                    try managedContext!.save()
                    // print("saved successfully")
                    //self.window?.makeToast(CROP_ADVISORY_SUCCESSFULLY_STORED, duration: 1.0, position: .center)
                }
                catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    //MARK: saveBookletDetails
    func saveBookletDetails(_ details : BookletInfo)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookletDetails")
        fetchRequest.predicate = NSPredicate(format: "mediaServerRecordId = %@",details.mediaServerRecordId!)
        
        do {
            let results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            
            //update record
            if results.count > 0 {
                // print("already saved")
                
                //self.window?.makeToast("Crop Advisory Details Already Saved", duration: 1.0, position: .center)
                
                let managedObject = results[0]
                
                managedObject.setValue(details.mediaServerRecordId, forKey: "mediaServerRecordId")
                managedObject.setValue(details.mediaUrl, forKey: "mediaUrl")
                managedObject.setValue(details.mediaName, forKey: "mediaName")
                managedObject.setValue(details.createdOn, forKey: "createdOn")
                managedObject.setValue(details.mediaType, forKey: "mediaType")
                managedObject.setValue(details.year, forKey: "year")
                managedObject.setValue(details.crop, forKey: "crop")
                managedObject.setValue(details.cropId, forKey: "cropId")
                managedObject.setValue(details.season, forKey: "season")
                managedObject.setValue(details.seasonId, forKey: "seasonId")
                managedObject.setValue(details.status, forKey: "status")
                managedObject.setValue(details.updatedOn, forKey: "updatedOn")
                
                try managedContext!.save()
                
                return
            }
            else{//insert new record
                
                let entity =  NSEntityDescription.entity(forEntityName: "BookletDetails",in:managedContext!)
                
                let managedObject = NSManagedObject(entity: entity!,insertInto: managedContext)
                
                managedObject.setValue(details.mediaServerRecordId, forKey: "mediaServerRecordId")
                managedObject.setValue(details.mediaUrl, forKey: "mediaUrl")
                managedObject.setValue(details.mediaName, forKey: "mediaName")
                managedObject.setValue(details.createdOn, forKey: "createdOn")
                managedObject.setValue(details.mediaType, forKey: "mediaType")
                managedObject.setValue(details.year, forKey: "year")
                managedObject.setValue(details.crop, forKey: "crop")
                managedObject.setValue(details.cropId, forKey: "cropId")
                managedObject.setValue(details.season, forKey: "season")
                managedObject.setValue(details.seasonId, forKey: "seasonId")
                managedObject.setValue(details.status, forKey: "status")
                managedObject.setValue(details.updatedOn, forKey: "updatedOn")
                
                do {
                    try managedContext!.save()
               
                }
                catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    //MARK: retrieve crop advisory details from DB
    func getBookletDetailsFromDB(_ entity:String) -> NSMutableArray
    {
        let detailsMutArray  = NSMutableArray()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        //fetchRequest.predicate = NSPredicate(format: "userId = %@",GRAPHICS.Get_UserID())
        
        do {
            let results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            
            for detailsObj  in results as [NSManagedObject] {
                
                let detailsEntity   =   BookletInfo(dict:NSMutableDictionary())
                
                detailsEntity.mediaServerRecordId = (detailsObj.value(forKey: "mediaServerRecordId") as? String)
                
                detailsEntity.cropId = (detailsObj.value(forKey: "cropId") as? String)
                detailsEntity.crop = (detailsObj.value(forKey: "crop") as? String)
                detailsEntity.mediaName = (detailsObj.value(forKey: "mediaName") as? String)
                detailsEntity.mediaUrl = (detailsObj.value(forKey: "mediaUrl") as? String)
                detailsEntity.mediaType = (detailsObj.value(forKey: "mediaType")as? String)
                detailsEntity.seasonId = (detailsObj.value(forKey: "seasonId") as? String)
                detailsEntity.season = (detailsObj.value(forKey: "season") as? String)
                detailsEntity.createdOn = (detailsObj.value(forKey: "createdOn") as? String)
                detailsEntity.updatedOn = (detailsObj.value(forKey: "updatedOn") as? String)
                detailsEntity.status = (detailsObj.value(forKey: "status") as? String)
                detailsEntity.year = (detailsObj.value(forKey: "year") as? String)
              
                
                detailsMutArray.add(detailsEntity)
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return detailsMutArray
    }
    //MARK: saveCropCalculationsDetails
    func saveCropCalculationDetails(_ details : CropCalculator)
    {
        var managedObject : NSManagedObject?
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedContext
        if details.status == "UPDATE" {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CropCalculatorEntity")
            fetchRequest.predicate = NSPredicate(format: "year = %@ && cropName=%@ ",details.year,details.cropName)
            do {
                let results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
                //update record
                if results.count > 0 {
                    // print("already saved")
                    managedObject = results[0]
                }
            }
            catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        else{//insert new record
            let entity =  NSEntityDescription.entity(forEntityName: "CropCalculatorEntity",in:managedContext!)
            managedObject = NSManagedObject(entity: entity!,insertInto: managedContext)
        }
        if managedObject != nil {
            managedObject?.setValue(details.year, forKey: "year")
            managedObject?.setValue(details.plannedAcers, forKey: "planningAcers")
            managedObject?.setValue(details.landPreparation, forKey: "landPreparation")
            managedObject?.setValue(details.seedCost, forKey: "seedCost")
            managedObject?.setValue(details.seedRate, forKey: "seedRate")
            managedObject?.setValue(details.labourCost, forKey: "labourCost")
            managedObject?.setValue(details.totalNoOfLabourersReq, forKey: "totalNoOfLabours")
            managedObject?.setValue(details.mechanicalHarvestCost, forKey: "mechanicalHarvestingCost")
            managedObject?.setValue(details.costPerIrrigation, forKey: "costPerIrrigation")
            managedObject?.setValue(details.noOfIrrigations, forKey: "noOfIrrigations")
            managedObject?.setValue(details.fertilizerCost, forKey: "fertiliserCost")
            managedObject?.setValue(details.pesticideCost, forKey: "pesticidesCost")
            managedObject?.setValue(details.grainYield, forKey: "grainYield")
            managedObject?.setValue(details.commercialGrainPrice, forKey: "commercialGrainPrice")
            managedObject?.setValue(details.strawYield, forKey: "strawYield")
            managedObject?.setValue(details.commercialFodderPrice, forKey: "commercialFooderPrice")
            managedObject?.setValue(details.cropName, forKey: "cropName")
            managedObject?.setValue(details.mobileId, forKey: "mobileId")
            managedObject?.setValue(details.geoLocation, forKey: "geoLocation")
            managedObject?.setValue(details.status, forKey: "status")
            do {
                try managedContext!.save()
                // print("saved successfully")
                //self.window?.makeToast(CROP_ADVISORY_SUCCESSFULLY_STORED, duration: 1.0, position: .center)
            }
            catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
        
    }
    
    //MARK: retrieve crop advisory details from DB
    func getCropAdvisoryDetailsFromDB(_ entity:String) -> NSMutableArray
    {
        let detailsMutArray  = NSMutableArray()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        //fetchRequest.predicate = NSPredicate(format: "userId = %@",GRAPHICS.Get_UserID())
        
        do {
            let results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            
            for detailsObj  in results as [NSManagedObject] {
                
                let detailsEntity : CropAdvisoryNotifications  =   CropAdvisoryNotifications(dict:NSMutableDictionary())
                
                detailsEntity.caRequestMasterId = (detailsObj.value(forKey: "caRequestMasterId")! as? String)! as NSString
                
                let stagesArray = [Any](arrayLiteral: NSKeyedUnarchiver.unarchiveObject(with: detailsObj.value(forKey: "cropAdvisoryStages")! as! Data)!)
                
                detailsEntity.messageList = stagesArray as NSArray
                
                detailsEntity.categoryId = (detailsObj.value(forKey: "categoryId")! as? String)! as NSString
                detailsEntity.categoryName = (detailsObj.value(forKey: "categoryName")! as? String)! as NSString
                detailsEntity.stateId = (detailsObj.value(forKey: "stateId")! as? String)! as NSString
                detailsEntity.stateName = (detailsObj.value(forKey: "stateName")! as? String)! as NSString
                detailsEntity.cropId = (detailsObj.value(forKey: "cropId")! as? String)! as NSString
                detailsEntity.cropName = (detailsObj.value(forKey: "cropName")! as? String)! as NSString
                detailsEntity.hybridId = (detailsObj.value(forKey: "hybridId")! as? String)! as NSString
                detailsEntity.hybridName = (detailsObj.value(forKey: "hybridName")! as? String)! as NSString
                detailsEntity.seasonId = (detailsObj.value(forKey: "seasonId")! as? String)! as NSString
                detailsEntity.seasonName = (detailsObj.value(forKey: "seasonName")! as? String)! as NSString
                detailsEntity.sowingDate = (detailsObj.value(forKey: "sowingDate")! as? String)! as NSString
                
                //print("\(detailsEntity.caRequestMasterId) , \(detailsEntity.categoryId)")
                
                //print(" stages : \(detailsEntity.cropAdvisoryDetailsStages)")
                
                detailsMutArray.add(detailsEntity)
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return detailsMutArray
    }
    
    //MARK: deleteCropAdvisoryDetails [for testing]
    @objc func deleteCropAdvisoryDetails() {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.managedObjectContext
        let coord = appDel.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CropAdvisoryDetails")
        
        fetchRequest.includesPropertyValues = false
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord.execute(deleteRequest, with: context)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
    //MARK: saveNewsRecords
    
    @objc func saveNewsRecords(_ details : NewsEntityDetails){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedContext
        
        let entity =  NSEntityDescription.entity(forEntityName: "NewsEntity",in:managedContext!)
        let managedObject = NSManagedObject(entity: entity!,insertInto: managedContext)
        managedObject.setValue(details.newsType, forKey: "newsType")
        managedObject.setValue(details.heading1, forKey: "heading1")
        managedObject.setValue(details.heading2, forKey: "heading2")
        managedObject.setValue(details.heading3, forKey: "heading3")
        managedObject.setValue(details.newsDescription, forKey: "newsDescription")
        managedObject.setValue(details.createdOn, forKey: "createdOn")
        managedObject.setValue(details.imagePath, forKey: "imagePath")

        do {
            try managedContext!.save()
        }
        catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }

    }
    //MARK: get News Records
    
    @objc func getOfflineNews () -> NSMutableArray {
    
        let newsMutArray  = NSMutableArray()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NewsEntity")
        //fetchRequest.predicate = NSPredicate(format: "userId = %@",GRAPHICS.Get_UserID())
        
        do {
            let results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            
            for detailsObj  in results as [NSManagedObject] {
                
                let detailsEntity : NewsEntityDetails  =   NewsEntityDetails(dict:NSMutableDictionary())
                
                detailsEntity.newsType = (detailsObj.value(forKey: "newsType")! as? String)! as NSString
                detailsEntity.createdOn = (detailsObj.value(forKey: "createdOn")! as? String)! as NSString
                detailsEntity.newsDescription = (detailsObj.value(forKey: "newsDescription")! as? String)! as NSString
                detailsEntity.heading1 = (detailsObj.value(forKey: "heading1")! as? String)! as NSString
                detailsEntity.heading2 = (detailsObj.value(forKey: "heading2")! as? String)! as NSString
                detailsEntity.heading3 = (detailsObj.value(forKey: "heading3")! as? String)! as NSString
                detailsEntity.imagePath = (detailsObj.value(forKey: "imagePath")! as? String)! as NSString

                newsMutArray.add(detailsEntity)
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return newsMutArray

    }
    
    //MARK: saveNotificationDetails
    @objc func saveNotificationDetails(_ details : Notifications)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NotificationsEntity")
        fetchRequest.predicate = NSPredicate(format: "notificationId = %@",details.notificationId!)
        do {
            let results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            //update record
            if results.count > 0 {
                // print("already saved")
                // self.window?.makeToast("FAB Details Already Saved", duration: 1.0, position: .center)
                let managedObject = results[0]
                managedObject.setValue(details.notificationId, forKey: "notificationId")
                managedObject.setValue(details.notificationMsg, forKey: "notificationMsg")
                managedObject.setValue(details.createdOn, forKey: "createdOn")
                managedObject.setValue(details.imagePath, forKey: "imagePath")
                managedObject.setValue(details.notificationActive, forKey: "notificationActive")
                managedObject.setValue(details.viewStatus, forKey: "viewStatus")
                try managedContext!.save()
                return
            }
            else{
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let managedContext = appDelegate.managedContext
                let entity =  NSEntityDescription.entity(forEntityName: "NotificationsEntity",in:managedContext!)
                let managedObject = NSManagedObject(entity: entity!,insertInto: managedContext)
                managedObject.setValue(details.notificationId, forKey: "notificationId")
                managedObject.setValue(details.notificationMsg, forKey: "notificationMsg")
                managedObject.setValue(details.createdOn, forKey: "createdOn")
                 managedObject.setValue(details.imagePath, forKey: "imagePath")
                managedObject.setValue(details.notificationActive, forKey: "notificationActive")
                managedObject.setValue(details.viewStatus, forKey: "viewStatus")
                do {
                    try managedContext!.save()
                    // print("saved successfully")
                    //self.window?.makeToast(CROP_ADVISORY_SUCCESSFULLY_STORED, duration: 1.0, position: .center)
                }
                catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    //MARK: saveNotificationDetails
    @objc func deletedNotificationDetailsInOffline(_ id : String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NotificationsEntity")
        //          fetchRequest.predicate = NSPredicate(format: "notificationId = %@",details.notificationId!)
        do {
            let results = try! managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            //update record
            if results.count > 0 {
                for detailsObj  in results as [NSManagedObject] {
                    
                    let detailsEntity : Notifications  =   Notifications(dict:NSMutableDictionary())
                    detailsEntity.notificationId = (detailsObj.value(forKey: "notificationId")! as? String)! as NSString
                    //                for item in results {
                    if detailsEntity.notificationId! as String == id {
                        managedObjectContext.delete(detailsObj)
                    }
                }
                //                    let managedObject = results[0]
                //                                     managedObject.setValue(details.notificationId, forKey: "notificationId")
                //                                     managedObject.setValue(details.notificationMsg, forKey: "notificationMsg")
                //                                     managedObject.setValue(details.createdOn, forKey: "createdOn")
                //                                     managedObject.setValue(details.imagePath, forKey: "imagePath")
                //                                     managedObject.setValue(details.notificationActive, forKey: "notificationActive")
                
            }
            try! managedContext!.save()
            return
        }catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    //MARK: retrieve Notification details from DB
    @objc func getNotificationDetailsFromDB(_ entity:String) -> NSMutableArray
    {
        let detailsMutArray  = NSMutableArray()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        do {
            let results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            for detailsObj  in results as [NSManagedObject] {
                let detailsEntity : Notifications  =   Notifications(dict:NSMutableDictionary())
                detailsEntity.notificationId = (detailsObj.value(forKey: "notificationId")! as? String)! as NSString
                detailsEntity.notificationMsg = (detailsObj.value(forKey: "notificationMsg")! as? String)! as NSString
                detailsEntity.createdOn = (detailsObj.value(forKey: "createdOn")! as? String)! as NSString
                detailsEntity.imagePath = (detailsObj.value(forKey: "imagePath") as? String)
                    detailsEntity.viewStatus = (detailsObj.value(forKey: "viewStatus") as? Bool)
                    detailsEntity.notificationActive = (detailsObj.value(forKey: "notificationActive") as? Bool)
                //print("\(detailsEntity.notificationId) , \(detailsEntity.createdOn)")
                // print(" fabData : \(detailsEntity.fabDataArray)")
                detailsMutArray.add(detailsEntity)
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return detailsMutArray
    }
    
    //MARK: deleteNotificationDetails [for testing]
    @objc func deleteNotificationDetails() {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.managedObjectContext
        let coord = appDel.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NotificationsEntity")
        
        fetchRequest.includesPropertyValues = false
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord.execute(deleteRequest, with: context)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    //MARK: saveUserLogEventsModuleWise in DB
    @objc  func saveUserLogEventsModulewise(_ details : UserLogEvents)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserLogEventsModuleWise")
        fetchRequest.predicate = NSPredicate(format: "moduleName = %@",details.moduleName!)
        
        do {
            let results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            
            //update record
            if results.count > 0 {
                // print("already saved")
                // self.window?.makeToast("FAB Details Already Saved", duration: 1.0, position: .center)
                let managedObject = results[0]
                
                managedObject.setValue(details.mobileNumber, forKey: "mobileNumber")
                managedObject.setValue(details.deviceId, forKey: "deviceId")
                managedObject.setValue(details.deviceType, forKey: "deviceType")
                managedObject.setValue(details.customerId, forKey: "customerId")
                managedObject.setValue(details.logTimeStamp, forKey: "logTimeStamp")
                managedObject.setValue(details.pincode, forKey: "pincode")
                managedObject.setValue(details.stateName, forKey: "stateName")
                managedObject.setValue(details.marketName, forKey: "marketName")
                managedObject.setValue(details.commodity, forKey: "commodity")
                managedObject.setValue(details.eventName, forKey: "eventName")
                managedObject.setValue(details.className, forKey: "classNamed")
                
                managedObject.setValue(details.moduleName, forKey: "moduleName")
                managedObject.setValue(details.healthCardId, forKey: "healthCardId")
                managedObject.setValue(details.productId, forKey: "productId")
                managedObject.setValue(details.cropId, forKey: "cropId")
                managedObject.setValue(details.seasonId, forKey: "seasonId")
                managedObject.setValue(details.otherParams, forKey: "otherParams")
                
                managedObject.setValue(details.stateLoggedin, forKey: "districtLoggedin")
                managedObject.setValue(details.districtLoggedin, forKey: "districtLoggedin")
                managedObject.setValue(details.isOnlineRecord, forKey: "isOnlineRecord")
                
                try managedContext!.save()
                
                return
            }
            else{
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let managedContext = appDelegate.managedContext
                
                let entity =  NSEntityDescription.entity(forEntityName: "UserLogEventsModuleWise",in:managedContext!)
                
                let managedObject = NSManagedObject(entity: entity!,insertInto: managedContext)
                
                managedObject.setValue(details.mobileNumber, forKey: "mobileNumber")
                managedObject.setValue(details.deviceId, forKey: "deviceId")
                managedObject.setValue(details.deviceType, forKey: "deviceType")
                managedObject.setValue(details.customerId, forKey: "customerId")
                managedObject.setValue(details.logTimeStamp, forKey: "logTimeStamp")
                managedObject.setValue(details.pincode, forKey: "pincode")
                managedObject.setValue(details.stateName, forKey: "stateName")
                managedObject.setValue(details.marketName, forKey: "marketName")
                managedObject.setValue(details.commodity, forKey: "commodity")
                managedObject.setValue(details.eventName, forKey: "eventName")
                managedObject.setValue(details.className, forKey: "classNamed")
                
                managedObject.setValue(details.moduleName, forKey: "moduleName")
                managedObject.setValue(details.healthCardId, forKey: "healthCardId")
                managedObject.setValue(details.productId, forKey: "productId")
                managedObject.setValue(details.cropId, forKey: "cropId")
                managedObject.setValue(details.seasonId, forKey: "seasonId")
                managedObject.setValue(details.otherParams, forKey: "otherParams")
                
                managedObject.setValue(details.stateLoggedin, forKey: "districtLoggedin")
                managedObject.setValue(details.districtLoggedin, forKey: "districtLoggedin")
                managedObject.setValue(details.isOnlineRecord, forKey: "isOnlineRecord")
                
                
                do {
                    try managedContext!.save()
                    print(managedObject)
                    // print("saved successfully")
                }
                catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    //MARK: retrieve UserlogEvents details from DB
    @objc func getUserLogEventsModulewiseFromDB(_ entity:String) -> NSMutableArray
    {
        let detailsMutArray  = NSMutableArray()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        //fetchRequest.predicate = NSPredicate(format: "userId = %@",GRAPHICS.Get_UserID())
        
        do {
            let results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            
            for detailsObj  in results as [NSManagedObject] {
                
                let detailsEntity : UserLogEvents  =   UserLogEvents(dict:NSMutableDictionary())
                
                detailsEntity.mobileNumber = (detailsObj.value(forKey: "mobileNumber") as? String ?? "") as NSString?
                detailsEntity.deviceId = (detailsObj.value(forKey: "deviceId") as? String ?? "") as NSString?
                detailsEntity.deviceType = (detailsObj.value(forKey: "deviceType") as? String ?? "") as NSString
                detailsEntity.customerId = (detailsObj.value(forKey: "customerId") as? String ?? "") as NSString
                detailsEntity.logTimeStamp = (detailsObj.value(forKey: "logTimeStamp") as? String ?? "") as NSString
                detailsEntity.pincode = (detailsObj.value(forKey: "pincode") as? String ?? "") as NSString
                detailsEntity.eventName = (detailsObj.value(forKey: "eventName") as? String ?? "") as NSString
                detailsEntity.className = (detailsObj.value(forKey: "classNamed") as? String ?? "") as NSString
                
                detailsEntity.moduleName = (detailsObj.value(forKey: "moduleName") as? String ?? "") as NSString
                detailsEntity.healthCardId = (detailsObj.value(forKey: "healthCardId") as? String ?? "") as NSString
                detailsEntity.productId = (detailsObj.value(forKey: "productId") as? String ?? "") as NSString
                detailsEntity.cropId = (detailsObj.value(forKey: "cropId") as? String ?? "") as NSString
                detailsEntity.seasonId = (detailsObj.value(forKey: "seasonId") as? String ?? "") as NSString
                detailsEntity.otherParams = (detailsObj.value(forKey: "otherParams")! as? String ?? "") as NSString
                
                detailsEntity.stateLoggedin = (detailsObj.value(forKey: "stateLoggedin") as? String ?? "") as NSString
                detailsEntity.districtLoggedin = (detailsObj.value(forKey: "districtLoggedin") as? String ?? "") as NSString
                detailsEntity.isOnlineRecord = (detailsObj.value(forKey: "isOnlineRecord") as? String ?? "") as NSString
                
                detailsEntity.stateName = (detailsObj.value(forKey: "stateName") as? String ?? "") as NSString
                detailsEntity.marketName = (detailsObj.value(forKey: "marketName") as? String ?? "") as NSString
                detailsEntity.commodity = (detailsObj.value(forKey: "commodity") as? String ?? "") as NSString
                
                detailsMutArray.add(detailsEntity)
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return detailsMutArray
    }
    //MARK: delete UserLogEventsfromDB
    @objc func deleteUserLogEventsModulewiseFromDB() {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.managedObjectContext
        let coord = appDel.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserLogEventsModuleWise")
        
        fetchRequest.includesPropertyValues = false
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord.execute(deleteRequest, with: context)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
    //MARK: saveDiseasePrescriptionDetails
    @objc  func saveDiseasePrescriptionDetails(_ details : DiseasePrescriptions)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DiseasePrescriptionsEntity")
        fetchRequest.predicate = NSPredicate(format: "id = %@",details.id!)
        
        do {
            let results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            
            //update record
            if results.count > 0 {
                // print("already saved")
                // self.window?.makeToast("FAB Details Already Saved", duration: 1.0, position: .center)
                let managedObject = results[0]
                
                managedObject.setValue(details.preventiveMeasures, forKey: "preventiveMeasures")
                managedObject.setValue(details.productMapping, forKey: "productMapping")
                managedObject.setValue(details.symptoms, forKey: "symptoms")
                managedObject.setValue(details.active, forKey: "active")
                managedObject.setValue(details.biologicalControl, forKey: "biologicalControl")
                managedObject.setValue(details.hazadDescription, forKey: "hazadDescription")
                managedObject.setValue(details.createdOn, forKey: "createdOn")
                managedObject.setValue(details.status, forKey: "status")
                managedObject.setValue(details.diseaseName, forKey: "diseaseName")
                managedObject.setValue(details.deleted, forKey: "diseaseDeleted")
                managedObject.setValue(details.updatedOn, forKey: "updatedOn")
                managedObject.setValue(details.inANutshell, forKey: "inANutshell")
                managedObject.setValue(details.crop, forKey: "crop")
                managedObject.setValue(details.diseaseBiologicalName, forKey: "diseaseBiologicalName")
                managedObject.setValue(details.chemicalControl, forKey: "chemicalControl")
                managedObject.setValue(details.productMappingImage, forKey: "productMappingImage")
                managedObject.setValue(details.id, forKey: "id")
                managedObject.setValue(details.diseaseImageFile, forKey: "diseaseImageFile")
                managedObject.setValue(details.diseaseId, forKey: "diseaseId")
                managedObject.setValue(details.diseaseType, forKey: "diseaseType")
                managedObject.setValue(details.hosts, forKey: "hosts")
                managedObject.setValue(details.trigger, forKey: "trigger")
                try managedContext!.save()
                
                return
            }
            else{
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                let managedContext = appDelegate.managedContext
                
                let entity =  NSEntityDescription.entity(forEntityName: "DiseasePrescriptionsEntity",in:managedContext!)
                
                let managedObject = NSManagedObject(entity: entity!,insertInto: managedContext)
                
                managedObject.setValue(details.id, forKey: "id")
                managedObject.setValue(details.preventiveMeasures, forKey: "preventiveMeasures")
                managedObject.setValue(details.productMapping, forKey: "productMapping")
                managedObject.setValue(details.symptoms, forKey: "symptoms")
                managedObject.setValue(details.active, forKey: "active")
                managedObject.setValue(details.biologicalControl, forKey: "biologicalControl")
                managedObject.setValue(details.hazadDescription, forKey: "hazadDescription")
                managedObject.setValue(details.createdOn, forKey: "createdOn")
                managedObject.setValue(details.status, forKey: "status")
                managedObject.setValue(details.diseaseName, forKey: "diseaseName")
                managedObject.setValue(details.deleted, forKey: "diseaseDeleted")
                managedObject.setValue(details.updatedOn, forKey: "updatedOn")
                managedObject.setValue(details.inANutshell, forKey: "inANutshell")
                managedObject.setValue(details.crop, forKey: "crop")
                managedObject.setValue(details.diseaseBiologicalName, forKey: "diseaseBiologicalName")
                managedObject.setValue(details.chemicalControl, forKey: "chemicalControl")
                managedObject.setValue(details.productMappingImage, forKey: "productMappingImage")
                managedObject.setValue(details.id, forKey: "id")
                managedObject.setValue(details.diseaseImageFile, forKey: "diseaseImageFile")
                managedObject.setValue(details.diseaseId, forKey: "diseaseId")
                managedObject.setValue(details.diseaseType, forKey: "diseaseType")
                managedObject.setValue(details.hosts, forKey: "hosts")
                managedObject.setValue(details.trigger, forKey: "trigger")
                
                do {
                    try managedContext!.save()
                    // print("saved successfully")
                }
                catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    //MARK: retrieve DiseasePrescription details from DB
    @objc func getDiseasePrescriptionDetailsFromDB(_ entity:String) -> NSMutableArray
    {
        let detailsMutArray  = NSMutableArray()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        //fetchRequest.predicate = NSPredicate(format: "userId = %@",GRAPHICS.Get_UserID())
        
        do {
            let results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            
            for detailsObj  in results as [NSManagedObject] {
                
                let detailsEntity : DiseasePrescriptions  =   DiseasePrescriptions(dict:NSMutableDictionary())
                
                detailsEntity.preventiveMeasures = (detailsObj.value(forKey: "preventiveMeasures") as? String) as NSString?
                detailsEntity.productMapping = (detailsObj.value(forKey: "productMapping") as? String) as NSString?
                detailsEntity.symptoms = (detailsObj.value(forKey: "symptoms") as? String)! as NSString
                detailsEntity.active = (detailsObj.value(forKey: "active")! as? String)! as NSString
                detailsEntity.biologicalControl = (detailsObj.value(forKey: "biologicalControl")! as? String)! as NSString
                detailsEntity.hazadDescription = (detailsObj.value(forKey: "hazadDescription")! as? String)! as NSString
                detailsEntity.createdOn = (detailsObj.value(forKey: "createdOn")! as? String)! as NSString
                detailsEntity.status = (detailsObj.value(forKey: "status")! as? String)! as NSString
                detailsEntity.diseaseName = (detailsObj.value(forKey: "diseaseName")! as? String)! as NSString
                detailsEntity.deleted = (detailsObj.value(forKey: "diseaseDeleted")! as? String)! as NSString
                detailsEntity.updatedOn = (detailsObj.value(forKey: "updatedOn")! as? String)! as NSString
                detailsEntity.inANutshell = (detailsObj.value(forKey: "inANutshell")! as? String)! as NSString
                detailsEntity.crop = (detailsObj.value(forKey: "crop")! as? String)! as NSString
                detailsEntity.diseaseBiologicalName = (detailsObj.value(forKey: "diseaseBiologicalName")! as? String)! as NSString
                detailsEntity.chemicalControl = (detailsObj.value(forKey: "chemicalControl")! as? String)! as NSString
                detailsEntity.productMappingImage = (detailsObj.value(forKey: "productMappingImage")! as? String)! as NSString
                detailsEntity.id = (detailsObj.value(forKey: "id")! as? String)! as NSString
                detailsEntity.diseaseImageFile = (detailsObj.value(forKey: "diseaseImageFile")! as? String)! as NSString
                detailsEntity.diseaseId = (detailsObj.value(forKey: "diseaseId")! as? String)! as NSString
                detailsEntity.diseaseType = (detailsObj.value(forKey: "diseaseType")! as? String)! as NSString
                detailsEntity.hosts = (detailsObj.value(forKey: "hosts")! as? String)! as NSString
                detailsEntity.trigger = (detailsObj.value(forKey: "trigger")! as? String)! as NSString
                
                detailsMutArray.add(detailsEntity)
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return detailsMutArray
    }
    
    //MARK: saveAgroProductsDetails
    @objc  func saveAgroProductsDetails(_ details : AgroProductMaster)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AgroProductMasterEntity")
        fetchRequest.predicate = NSPredicate(format: "id = %@",details.id!)
        
        do {
            let results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            
            //update record
            if results.count > 0 {
                // print("already saved")
                // self.window?.makeToast("FAB Details Already Saved", duration: 1.0, position: .center)
                let managedObject = results[0]
                
                managedObject.setValue(details.id, forKey: "id")
                managedObject.setValue(details.createdOn, forKey: "createdOn")
                managedObject.setValue(details.active, forKey: "active")
                managedObject.setValue(details.status, forKey: "status")
                managedObject.setValue(details.deleted, forKey: "productDeleted")
                managedObject.setValue(details.updatedOn, forKey: "updatedOn")
                managedObject.setValue(details.productName, forKey: "productName")
                managedObject.setValue(details.productUse, forKey: "productUse")
                managedObject.setValue(details.caution, forKey: "caution")
                managedObject.setValue(details.work, forKey: "work")
                managedObject.setValue(details.cropAndDiseaseNamesForMobile, forKey: "cropAndDiseaseNamesForMobile")
                managedObject.setValue(details.type, forKey: "type")
                managedObject.setValue(details.productImage, forKey: "productImage")
                managedObject.setValue(details.resultAndEffect, forKey: "resultAndEffect")
                managedObject.setValue(details.character, forKey: "character")
                managedObject.setValue(NSKeyedArchiver.archivedData(withRootObject: details.cropAndDiseaseNamesArray), forKey: "cropAndDiseaseNamesArray")
                
                try managedContext!.save()
                
                return
            }
            else{
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                let managedContext = appDelegate.managedContext
                
                let entity =  NSEntityDescription.entity(forEntityName: "AgroProductMasterEntity",in:managedContext!)
                
                let managedObject = NSManagedObject(entity: entity!,insertInto: managedContext)
                
                managedObject.setValue(details.id, forKey: "id")
                managedObject.setValue(details.createdOn, forKey: "createdOn")
                managedObject.setValue(details.active, forKey: "active")
                managedObject.setValue(details.status, forKey: "status")
                managedObject.setValue(details.deleted, forKey: "productDeleted")
                managedObject.setValue(details.updatedOn, forKey: "updatedOn")
                managedObject.setValue(details.productName, forKey: "productName")
                managedObject.setValue(details.productUse, forKey: "productUse")
                managedObject.setValue(details.caution, forKey: "caution")
                managedObject.setValue(details.work, forKey: "work")
                managedObject.setValue(details.cropAndDiseaseNamesForMobile, forKey: "cropAndDiseaseNamesForMobile")
                managedObject.setValue(details.type, forKey: "type")
                managedObject.setValue(details.productImage, forKey: "productImage")
                managedObject.setValue(details.resultAndEffect, forKey: "resultAndEffect")
                managedObject.setValue(details.character, forKey: "character")
                managedObject.setValue(NSKeyedArchiver.archivedData(withRootObject: details.cropAndDiseaseNamesArray), forKey: "cropAndDiseaseNamesArray")
                
                do {
                    try managedContext!.save()
                    // print("saved successfully")
                    //self.window?.makeToast(CROP_ADVISORY_SUCCESSFULLY_STORED, duration: 1.0, position: .center)
                }
                catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    //MARK: retrieve AgroProducts details from DB
    @objc func getAgroProductsDetailsFromDB(_ entity:String) -> NSMutableArray
    {
        let detailsMutArray  = NSMutableArray()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        //fetchRequest.predicate = NSPredicate(format: "userId = %@",GRAPHICS.Get_UserID())
        
        do {
            let results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            
            for detailsObj  in results as [NSManagedObject] {
                
                let detailsEntity : AgroProductMaster  =   AgroProductMaster(dict:NSMutableDictionary())
                
                detailsEntity.id = (detailsObj.value(forKey: "id")! as? String)! as NSString
                detailsEntity.createdOn = (detailsObj.value(forKey: "createdOn")! as? String)! as NSString
                detailsEntity.active = (detailsObj.value(forKey: "active")! as? String)! as NSString
                detailsEntity.updatedOn = (detailsObj.value(forKey: "updatedOn")! as? String)! as NSString
                detailsEntity.productName = (detailsObj.value(forKey: "productName")! as? String)! as NSString
                detailsEntity.productUse = (detailsObj.value(forKey: "productUse")! as? String)! as NSString
                detailsEntity.caution = (detailsObj.value(forKey: "caution")! as? String)! as NSString
                detailsEntity.work = (detailsObj.value(forKey: "work")! as? String)! as NSString
                detailsEntity.cropAndDiseaseNamesForMobile = (detailsObj.value(forKey: "cropAndDiseaseNamesForMobile")! as? String)! as NSString
                detailsEntity.type = (detailsObj.value(forKey: "type")! as? String)! as NSString
                detailsEntity.productImage = (detailsObj.value(forKey: "productImage")! as? String)! as NSString
                detailsEntity.deleted = (detailsObj.value(forKey: "productDeleted")! as? String)! as NSString
                detailsEntity.resultAndEffect = (detailsObj.value(forKey: "resultAndEffect")! as? String)! as NSString
                detailsEntity.character = (detailsObj.value(forKey: "character")! as? String)! as NSString
                detailsEntity.status = (detailsObj.value(forKey: "status")! as? String)! as NSString
                let detailsData = [Any](arrayLiteral: NSKeyedUnarchiver.unarchiveObject(with: detailsObj.value(forKey: "cropAndDiseaseNamesArray")! as! Data)!)
                
                detailsEntity.cropAndDiseaseNamesArray = detailsData as NSArray
                
                //print("\(detailsEntity.id) , \(detailsEntity.type)")
                // print(" fabData : \(detailsEntity.fabDataArray)")
                
                detailsMutArray.add(detailsEntity)
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return detailsMutArray
    }
    
    //MARK: deleteDiseasePrescriptionDetails [for testing]
    @objc func deleteDiseasePrescriptionDetails() {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.managedObjectContext
        let coord = appDel.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DiseasePrescriptionsEntity")
        
        fetchRequest.includesPropertyValues = false
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord.execute(deleteRequest, with: context)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
    //MARK: deleteAgroProductsDetails [for testing]
    @objc func deleteAgroProductsDetails() {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.managedObjectContext
        let coord = appDel.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AgroProductMasterEntity")
        
        fetchRequest.includesPropertyValues = false
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord.execute(deleteRequest, with: context)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    //MARK: deleteCropCalculationDetails [for testing]
    @objc func deleteCropCalculationDetails() {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.managedObjectContext
        let coord = appDel.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CropCalculatorEntity")
        
        fetchRequest.includesPropertyValues = false
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord.execute(deleteRequest, with: context)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    @objc func deleteSyncedCropCaliculationDetails(mobileId:String, _ year:String?,_ cropName:String?) {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.managedObjectContext
        let coord = appDel.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CropCalculatorEntity")
        //let filterPredicate = NSPredicate(format: "mobileId == %@ && year == %@ && cropName == %@", mobileId,year,cropName)
        let filterPredicate = NSPredicate(format: "mobileId == %@", mobileId)
        fetchRequest.predicate = filterPredicate
        fetchRequest.includesPropertyValues = false
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try coord.execute(deleteRequest, with: context)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    /**
     It redirects to the folder **CropDiagnosis** in **Documents Directory** else new folder is created
     - Remark: used to store all downloaded assets of **CropAdvisory** data when there is a active internet connection
     - Returns: String
     */
    @objc func getCropDiagnosisFolderPath() -> String{
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.appendingPathComponent("CropDiagnosis")?.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath!) {
            //  print("FILE AVAILABLE")
            return filePath!
        } else {
            //  print("FILE NOT AVAILABLE")
            do {
                try fileManager.createDirectory(atPath: filePath!, withIntermediateDirectories: false,attributes: nil)
            }
            catch {
                //   print("Error creating record files folder in documents dir: \(error)")
                return ""
            }
            return filePath!
        }
    }
    
    
    /**
     It redirects to the folder **FABAssets** in **Documents Directory** else new folder is created
     - Remark: used to store all downloaded assets of **FAB** data when there is a active internet connection
     - Returns: String
     */
    func getFABFolderPath() -> String{
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.appendingPathComponent("FABAssets")?.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath!) {
            //  print("FILE AVAILABLE")
            return filePath!
        } else {
            //  print("FILE NOT AVAILABLE")
            do {
                try fileManager.createDirectory(atPath: filePath!, withIntermediateDirectories: false,attributes: nil)
            }
            catch {
                //   print("Error creating record files folder in documents dir: \(error)")
                return ""
            }
            return filePath!
        }
    }
    
    /**
     It redirects to the folder **CropDiagnosis** in **Documents Directory** else new folder is created
     - Remark: used to store all downloaded assets of **Corteva News** data when there is a active internet connection
     - Returns: String
     */
    @objc func getNewsFolderPath() -> String{
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.appendingPathComponent("CortevaNews")?.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath!) {
            //  print("FILE AVAILABLE")
            return filePath!
        } else {
            //  print("FILE NOT AVAILABLE")
            do {
                try fileManager.createDirectory(atPath: filePath!, withIntermediateDirectories: false,attributes: nil)
            }
            catch {
                //   print("Error creating record files folder in documents dir: \(error)")
                return ""
            }
            return filePath!
        }
    }

    //MARK: saveFABDetails
    @objc  func saveFABDetails(_ details : FABDetailsEntity)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FABDetails")
        fetchRequest.predicate = NSPredicate(format: "id = %@",details.id)
        
        do {
            let results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            
            //update record
            if results.count > 0 {
                // print("already saved")
                // self.window?.makeToast("FAB Details Already Saved", duration: 1.0, position: .center)
                let managedObject = results[0]
                
                managedObject.setValue(details.id, forKey: "id")
                managedObject.setValue(details.version, forKey: "version")
                managedObject.setValue(details.mainDescription, forKey: "mainDescription")
                managedObject.setValue(details.stateId, forKey: "stateId")
                managedObject.setValue(details.state, forKey: "stateName")
                managedObject.setValue(details.cropId, forKey: "cropId")
                managedObject.setValue(details.crop, forKey: "cropName")
                managedObject.setValue(details.hybridId, forKey: "hybridId")
                managedObject.setValue(details.hybrid, forKey: "hybridName")
                managedObject.setValue(details.seasonId, forKey: "seasonId")
                managedObject.setValue(details.season, forKey: "seasonName")
                managedObject.setValue(NSKeyedArchiver.archivedData(withRootObject: details.fabDataArray), forKey: "fabData")
                
                try managedContext!.save()
                
                return
            }
            else{
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                let managedContext = appDelegate.managedContext
                
                let entity =  NSEntityDescription.entity(forEntityName: "FABDetails",in:managedContext!)
                
                let fabDetails = NSManagedObject(entity: entity!,insertInto: managedContext)
                
                fabDetails.setValue(details.id, forKey: "id")
                fabDetails.setValue(details.version, forKey: "version")
                fabDetails.setValue(details.mainDescription, forKey: "mainDescription")
                fabDetails.setValue(details.stateId, forKey: "stateId")
                fabDetails.setValue(details.state, forKey: "stateName")
                fabDetails.setValue(details.cropId, forKey: "cropId")
                fabDetails.setValue(details.crop, forKey: "cropName")
                fabDetails.setValue(details.hybridId, forKey: "hybridId")
                fabDetails.setValue(details.hybrid, forKey: "hybridName")
                fabDetails.setValue(details.seasonId, forKey: "seasonId")
                fabDetails.setValue(details.season, forKey: "seasonName")
                fabDetails.setValue(NSKeyedArchiver.archivedData(withRootObject: details.fabDataArray), forKey: "fabData")
                
                do {
                    try managedContext!.save()
                    // print("saved successfully")
                    //self.window?.makeToast(CROP_ADVISORY_SUCCESSFULLY_STORED, duration: 1.0, position: .center)
                }
                catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    //MARK: saveFABDetails
    @objc  func saveFABCPDetails(_ details : FAB_CPDetailsEntity)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FAB_CPDetails")
        fetchRequest.predicate = NSPredicate(format: "id = %@",details.id)
        
        do {
            let results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            
            //update record
            if results.count > 0 {
                // print("already saved")
                // self.window?.makeToast("FAB Details Already Saved", duration: 1.0, position: .center)
                let managedObject = results[0]
                
                managedObject.setValue(details.id, forKey: "id")
                managedObject.setValue(details.version, forKey: "version")
                managedObject.setValue(details.productId, forKey: "productId")
                managedObject.setValue(details.productName, forKey: "productName")
                  managedObject.setValue(details.productImageUrl, forKey: "productImageUrl")
                managedObject.setValue(details.cropImageUrl, forKey: "cropImageUrl")
                  managedObject.setValue(details.diseaseImageUrl, forKey: "diseaseImageUrl")
                managedObject.setValue(details.diseaseType, forKey: "diseaseType")
                 managedObject.setValue(details.productFormulation, forKey: "productFormulation")
                managedObject.setValue(details.cropId, forKey: "cropId")
                managedObject.setValue(details.crop, forKey: "cropName")
                managedObject.setValue(details.stateId, forKey: "stateId")
                managedObject.setValue(details.state, forKey: "stateName")
                managedObject.setValue(details.diseaseId, forKey: "diseaseId")
                managedObject.setValue(details.diseaseName, forKey: "diseaseName")
                managedObject.setValue(details.tableHeader, forKey: "tableHeader")
                managedObject.setValue(details.tableLocHeader, forKey: "tableLocHeader")
                managedObject.setValue(details.des_localMsg, forKey: "des_localMsg")
                 managedObject.setValue(details.des_englishMsg, forKey: "des_englishMsg")
                managedObject.setValue(details.product_images_urls, forKey: "product_images_urls")
                
               try! managedObject.setValue(NSKeyedArchiver.archivedData(withRootObject: details.fabCPDataArray, requiringSecureCoding: true), forKey: "fabcpData")
                try! managedObject.setValue(NSKeyedArchiver.archivedData(withRootObject: details.tableData, requiringSecureCoding: true), forKey: "tableData")
                try! managedObject.setValue(NSKeyedArchiver.archivedData(withRootObject: details.tableLocData, requiringSecureCoding: true), forKey: "tableLocData")
                try managedContext!.save()
                
                return
            }
            else{
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                let managedContext = appDelegate.managedContext
                
                let entity =  NSEntityDescription.entity(forEntityName: "FAB_CPDetails",in:managedContext!)
                
                let fabDetails = NSManagedObject(entity: entity!,insertInto: managedContext)
                
                fabDetails.setValue(details.id, forKey: "id")
                fabDetails.setValue(details.version, forKey: "version")
                fabDetails.setValue(details.productId, forKey: "productId")
                fabDetails.setValue(details.productName, forKey: "productName")
                fabDetails.setValue(details.cropId, forKey: "cropId")
                fabDetails.setValue(details.crop, forKey: "cropName")
                fabDetails.setValue(details.stateId, forKey: "stateId")
                fabDetails.setValue(details.state, forKey: "stateName")
                fabDetails.setValue(details.diseaseId, forKey: "diseaseId")
                fabDetails.setValue(details.diseaseName, forKey: "diseaseName")
                fabDetails.setValue(details.diseaseImageUrl, forKey: "diseaseImageUrl")
                fabDetails.setValue(details.cropImageUrl, forKey: "cropImageUrl")
                fabDetails.setValue(details.productImageUrl, forKey: "productImageUrl")
                fabDetails.setValue(details.diseaseType, forKey: "diseaseType")
                fabDetails.setValue(details.productFormulation, forKey: "productFormulation")
                //fabDetails.setValue(NSKeyedArchiver.archivedData(withRootObject: details.fabCPDataArray), forKey: "fabData")
                fabDetails.setValue(details.tableHeader, forKey: "tableHeader")
                fabDetails.setValue(details.tableLocHeader, forKey: "tableLocHeader")
                 fabDetails.setValue(details.des_localMsg, forKey: "des_localMsg")
                fabDetails.setValue(details.des_englishMsg, forKey: "des_englishMsg")
                 fabDetails.setValue(details.product_images_urls, forKey: "product_images_urls")
                
                fabDetails.setValue(try? NSKeyedArchiver.archivedData(withRootObject: details.fabCPDataArray, requiringSecureCoding: true), forKey: "fabcpData")
                fabDetails.setValue(try? NSKeyedArchiver.archivedData(withRootObject: details.tableData, requiringSecureCoding: true), forKey: "tableData")
                  fabDetails.setValue(try? NSKeyedArchiver.archivedData(withRootObject: details.tableLocData, requiringSecureCoding: true), forKey: "tableLocData")
                 try managedContext!.save()
                do {
                    try managedContext!.save()
                    // print("saved successfully")
                    //self.window?.makeToast(CROP_ADVISORY_SUCCESSFULLY_STORED, duration: 1.0, position: .center)
                }
                catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    
    
    //MARK: retrieve fab details from DB
    @objc func getFABDetailsFromDB(_ entity:String) -> NSMutableArray
    {
        let detailsMutArray  = NSMutableArray()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        //fetchRequest.predicate = NSPredicate(format: "userId = %@",GRAPHICS.Get_UserID())
        
        do {
            let results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            
            for detailsObj  in results as [NSManagedObject] {
                
                let detailsEntity : FABDetailsEntity  =   FABDetailsEntity(dict:NSMutableDictionary())
                
                detailsEntity.id = (detailsObj.value(forKey: "id")! as? String)! as NSString
                detailsEntity.version = (detailsObj.value(forKey: "version")! as? String)! as NSString
                
                let fabData = [Any](arrayLiteral: NSKeyedUnarchiver.unarchiveObject(with: detailsObj.value(forKey: "fabData")! as! Data)!)
                
                detailsEntity.fabDataArray = fabData as NSArray
                
                detailsEntity.mainDescription = (detailsObj.value(forKey: "mainDescription")! as? String)! as NSString
                detailsEntity.stateId = (detailsObj.value(forKey: "stateId")! as? String)! as NSString
                detailsEntity.state = (detailsObj.value(forKey: "stateName")! as? String)! as NSString
                detailsEntity.cropId = (detailsObj.value(forKey: "cropId")! as? String)! as NSString
                detailsEntity.crop = (detailsObj.value(forKey: "cropName")! as? String)! as NSString
                detailsEntity.hybridId = (detailsObj.value(forKey: "hybridId")! as? String)! as NSString
                detailsEntity.hybrid = (detailsObj.value(forKey: "hybridName")! as? String)! as NSString
                detailsEntity.seasonId = (detailsObj.value(forKey: "seasonId")! as? String)! as NSString
                detailsEntity.season = (detailsObj.value(forKey: "seasonName")! as? String)! as NSString
                
                // print("\(detailsEntity.id) , \(detailsEntity.state)")
                
                // print(" fabData : \(detailsEntity.fabDataArray)")
                
                detailsMutArray.add(detailsEntity)
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return detailsMutArray
    }
    
    //MARK: retrieve fab details from DB
    @objc func getFAB_CP_DetailsFromDB(_ entity:String) -> NSMutableArray
    {
        let detailsMutArray  = NSMutableArray()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        //fetchRequest.predicate = NSPredicate(format: "userId = %@",GRAPHICS.Get_UserID())
        
        do {
            let results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            
            for detailsObj  in results as [NSManagedObject] {
                
                let detailsEntity   =   FAB_CPDetailsEntity(dict:NSMutableDictionary())
                
                detailsEntity.id = (detailsObj.value(forKey: "id")! as? String)! as NSString
                detailsEntity.version = (detailsObj.value(forKey: "version")! as? String)! as NSString
                
                let fabData = [Any](arrayLiteral: NSKeyedUnarchiver.unarchiveObject(with: detailsObj.value(forKey: "fabcpData")! as! Data)!)
                
                detailsEntity.fabCPDataArray = fabData as NSArray
                
                let faTableData = [Any](arrayLiteral: NSKeyedUnarchiver.unarchiveObject(with: detailsObj.value(forKey: "tableData")! as! Data)!)
               let faTableLocData = [Any](arrayLiteral: NSKeyedUnarchiver.unarchiveObject(with: detailsObj.value(forKey: "tableLocData")! as! Data)!)
                
                      detailsEntity.tableData = faTableData as NSArray
                      detailsEntity.tableLocData = faTableLocData as NSArray
                
                detailsEntity.productId = (detailsObj.value(forKey: "productId")! as? String)! as NSString
                detailsEntity.productName = (detailsObj.value(forKey: "productName")! as? String)! as NSString
                detailsEntity.cropId = (detailsObj.value(forKey: "cropId")! as? String)! as NSString
                detailsEntity.crop = (detailsObj.value(forKey: "cropName")! as? String)! as NSString
                detailsEntity.diseaseId = (detailsObj.value(forKey: "diseaseId")! as? String)! as NSString
                detailsEntity.diseaseName = (detailsObj.value(forKey: "diseaseName")! as? String)! as NSString
                detailsEntity.tableHeader = (detailsObj.value(forKey: "tableHeader")! as? String)! as NSString
                   detailsEntity.tableLocHeader = (detailsObj.value(forKey: "tableLocHeader") as? String) as NSString? ?? ""
                detailsEntity.stateId = (detailsObj.value(forKey: "stateId")! as? String)! as NSString
                detailsEntity.state = (detailsObj.value(forKey: "stateName")! as? String)! as NSString
                detailsEntity.des_englishMsg = (detailsObj.value(forKey: "des_englishMsg") as? String) as NSString? ??  ""
                detailsEntity.des_localMsg = (detailsObj.value(forKey: "des_localMsg") as? String) as NSString? ?? ""
                detailsEntity.cropImageUrl = (detailsObj.value(forKey: "cropImageUrl") as? String) as NSString? ?? ""
                detailsEntity.diseaseImageUrl = (detailsObj.value(forKey: "diseaseImageUrl") as? String) as NSString? ?? ""
                detailsEntity.productImageUrl = (detailsObj.value(forKey: "productImageUrl") as? String) as NSString? ?? ""
                 detailsEntity.diseaseType = (detailsObj.value(forKey: "diseaseType") as? String) as NSString? ?? ""
                 detailsEntity.productFormulation = (detailsObj.value(forKey: "productFormulation") as? String) as NSString? ?? ""
                 detailsEntity.product_images_urls = (detailsObj.value(forKey: "product_images_urls") as? String) as NSString? ?? ""
                // print("\(detailsEntity.id) , \(detailsEntity.state)")
                
                // print(" fabData : \(detailsEntity.fabDataArray)")
                
                detailsMutArray.add(detailsEntity)
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return detailsMutArray
    }
    
    //MARK: deleteFABDetails [for testing]
    @objc func deleteFABDetails() {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.managedObjectContext
        let coord = appDel.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FABDetails")
        
        fetchRequest.includesPropertyValues = false
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord.execute(deleteRequest, with: context)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
    class func uploadEquipmentProfileImages(images: NSMutableArray, equipmentIdId: String, userId:String){
        //let appdelegate = UIApplication.shared.delegate
        if images.count > 0 {
            let userObj = Constatnts.getUserObject()
            let headers : HTTPHeaders = ["userAuthorizationToken": userObj.userAuthorizationToken! as String,"mobileNumber":userObj.mobileNumber! as String,"customerId": userObj.customerId! as String,"deviceToken":userObj.deviceToken as String,"deviceId":userObj.deviceId! as String]
            let urlString = String(format: "%@%@", arguments: [BASE_URL,Add_Equipment_Images])
            if let uploadImage = images.object(at: 0) as? UIImage{
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    var params = [String:String]();
                    params["equipmentId"] = equipmentIdId
                    for (key, value) in params {
                        if let data = value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                            multipartFormData.append(data, withName: key)
                        }
                    }
                    let imageData1 = UIImageJPEGRepresentation(uploadImage, 0.5)!
                    let imageName = FarmServicesConstants.getTimeStampForImage()
                    
                    multipartFormData.append(imageData1, withName: "equipmentImage", fileName: imageName, mimeType: "image/jpeg")
                    print("success");
                }, usingThreshold: 60, to: urlString, method: .post, headers: headers, encodingCompletion: { (encodeResult) in
                    switch encodeResult {
                    case .success(let upload, _, _):
                        upload
                            .validate()
                            .responseJSON { response in
                                switch response.result {
                                case .success(let value):
                                    let json = value
                                    //print("Response :\(json)")
                                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                                    if responseStatusCode == STATUS_CODE_200{
                                        //let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                                        //let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                                        //print(decryptData)
                                        images.remove(uploadImage)
                                        DispatchQueue.main.async {
                                            if images.count > 0 {
                                                AppDelegate.uploadEquipmentProfileImages(images: images, equipmentIdId: equipmentIdId, userId: userId)
                                            }
                                        }
                                    }
                                    
                                case .failure(let responseError):
                                    print("responseError: \(responseError)")
                                }
                        }
                    case .failure(let encodingError):
                        print("encodingError: \(encodingError)")
                    }
                })
            }
        }
    }
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "FarmerConnect", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("FarmerConnect.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: [NSMigratePersistentStoresAutomaticallyOption: true,NSInferMappingModelAutomaticallyOption: true,NSSQLitePragmasOption: ["journal_mode": "DELETE"]])
            //try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        }
        catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            // NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        //        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator//coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                _ = error as NSError
                // NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}
// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
//    func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        let userInfo = notification.request.content.userInfo as NSDictionary
//
//        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("foreground : \(messageID)")
//        }
//
//        // Print full message.
//
//        if UIApplication.shared.applicationState == .active{
//                UIApplication.shared.applicationIconBadgeNumber =  UIApplication.shared.applicationIconBadgeNumber + 1
////            if isNotificationnavigated == false {
////                isNotificationnavigated = true
////                notificationDic = userInfo as NSDictionary?
////                let currentViewController = UIApplication.topViewController()
////                isNotificationnavigated = true
////                if (currentViewController?.isKind(of: DLDemoRootViewController.self))!{
////                    let tempController = currentViewController as? DLDemoRootViewController
////                    if let hamburguerViewController =  tempController?.contentViewController{
////                        let navController  = hamburguerViewController as? UINavigationController
////                        let visibleViewController = navController?.visibleViewController
////                        visibleViewController?.notificationsHandlerNavigation(notificationDic: userInfo as NSDictionary)
////                    }
////                }
////            }
//        }
//        else{
//                UIApplication.shared.applicationIconBadgeNumber =  UIApplication.shared.applicationIconBadgeNumber + 1
//            if isNotificationnavigated == false {
//                isNotificationnavigated = true
//                notificationDic = userInfo as NSDictionary?
//                let currentViewController = UIApplication.topViewController()
//                //print(currentViewController ?? <#default value#>)
//                isNotificationnavigated = true
//                if (currentViewController?.isKind(of: DLDemoRootViewController.self))!{
//                    let tempController = currentViewController as? DLDemoRootViewController
//                    if let hamburguerViewController =  tempController?.contentViewController{
//                        let navController  = hamburguerViewController as? UINavigationController
//                        let visibleViewController = navController?.visibleViewController
//                        if (visibleViewController?.isKind(of: NotificationsViewController.self))!{
//                            let visibleTemp = visibleViewController as? NotificationsViewController
//                            visibleTemp?.viewDidLoad()
//                        }
//                        else{
//                            visibleViewController?.notificationsHandlerNavigation(notificationDic: userInfo as NSDictionary)
//                        }
//                    }
//                }
//            }
//        }
//        // Change this to your preferred presentation option
//        completionHandler([.alert, .badge, .sound])
//
//
//    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      let userInfo = notification.request.content.userInfo
       print(userInfo)
      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if UIApplication.shared.applicationState == .active  || UIApplication.shared.applicationState == .inactive {
                 let apsDictionary = userInfo["aps"] as? NSDictionary
              let badge =   userInfo["google.c.a.e"] as? String

                   print("Message ID: \(badge)")
      let bCount = Int(badge ?? "0") ?? 0
                    if UserDefaults.standard.value(forKey: "badgeCount") != nil {
                                  let badgeCount = UserDefaults.standard.value(forKey: "badgeCount") as? Int
                                   //                let NCount = Int(badgeCount ?? "0") ?? 0
                                                   UIApplication.shared.applicationIconBadgeNumber = badgeCount!+bCount
                        UserDefaults.standard.setValue(UIApplication.shared.applicationIconBadgeNumber, forKey: "badgeCount")
                        UserDefaults.standard.synchronize()
                        
                               }else{
                                   UserDefaults.standard.setValue(bCount, forKey: "badgeCount")
                      UIApplication.shared.applicationIconBadgeNumber = bCount
                               }
      }
      // Change this to your preferred presentation option
      completionHandler([[.alert, .sound,.badge]])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("InActive  \(messageID)")
      }
//                    UIApplication.shared.applicationIconBadgeNumber =  UIApplication.shared.applicationIconBadgeNumber + 1
                         // Print full message.

    }
    
        func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                         fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
          // If you are receiving a notification message while your app is in the background,
          // this callback will not be fired till the user taps on the notification launching the application.
          // TODO: Handle data of notification

          // With swizzling disabled you must let Messaging know about the message, for Analytics
          // Messaging.messaging().appDidReceiveMessage(userInfo)

          // Print message ID.
             if UIApplication.shared.applicationState == .background || UIApplication.shared.applicationState == .inactive {
            print(userInfo )
          if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
          }
            // Print message ID.
               let apsDictionary = userInfo["aps"] as? NSDictionary
            let badge =   userInfo["google.c.a.e"] as? String

                 print("Message ID: \(badge)")
    let bCount = Int(badge ?? "0") ?? 0
                  if UserDefaults.standard.value(forKey: "badgeCount") != nil {
                                 let badgeCount = UserDefaults.standard.value(forKey: "badgeCount") as? Int
    //                let NCount = Int(badgeCount ?? "0") ?? 0
                    UIApplication.shared.applicationIconBadgeNumber = badgeCount!+bCount
                    UserDefaults.standard.setValue(UIApplication.shared.applicationIconBadgeNumber, forKey: "badgeCount")
                    UserDefaults.standard.synchronize()
                             }else{
                                 UserDefaults.standard.setValue(bCount, forKey: "badgeCount")
                    UIApplication.shared.applicationIconBadgeNumber = bCount
                             }
    //            Print full message.
              
          // Print full message.
            }
            
    //    UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
          completionHandler(UIBackgroundFetchResult.newData)
        }
    func userNotificationCenter(_ center: UNUserNotificationCenter,didReceive response: UNNotificationResponse,withCompletionHandler completionHandler: @escaping () -> Void) {
//        if  UIApplication.shared.applicationIconBadgeNumber > 0 {
//                 UIApplication.shared.applicationIconBadgeNumber =  UIApplication.shared.applicationIconBadgeNumber - 1
//        }else{
//             UIApplication.shared.applicationIconBadgeNumber = 0
//        }
        
        if UIApplication.shared.applicationIconBadgeNumber > 0 {
           UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber-1
             if  UIApplication.shared.applicationIconBadgeNumber == 0 {
                 let defaults = UserDefaults.standard
                        defaults.removeObject(forKey: "badgeCount")
                        defaults.synchronize()
             }
         }
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID:", messageID)
        }
        
        // Print full message.
        print("Notification:",userInfo)
        if userInfo["gcm.notification.deepLinkingURL"] != nil {
             isNotificationnavigated = false
        }
        
        
        if UIApplication.shared.applicationState == .active {
            if isNotificationnavigated == false {
                isNotificationnavigated = true
                notificationDic = userInfo as NSDictionary?
                let currentViewController = UIApplication.topViewController()
                isNotificationnavigated = true
                if (currentViewController?.isKind(of: DLDemoRootViewController.self))!{
                    let tempController = currentViewController as? DLDemoRootViewController
                    if let hamburguerViewController =  tempController?.contentViewController{
                        let navController  = hamburguerViewController as? UINavigationController
                        let visibleViewController = navController?.visibleViewController
                        visibleViewController?.notificationsHandlerNavigation(notificationDic: userInfo as NSDictionary)
                    }
                }
            }
        }
        else{
            if isNotificationnavigated == false {
                isNotificationnavigated = true
                notificationDic = userInfo as NSDictionary?
                let currentViewController = UIApplication.topViewController()
                //print(currentViewController ?? default value)
                isNotificationnavigated = true
                if (currentViewController?.isKind(of: DLDemoRootViewController.self))!{
                    let tempController = currentViewController as? DLDemoRootViewController
                    if let hamburguerViewController =  tempController?.contentViewController{
                        let navController  = hamburguerViewController as? UINavigationController
                        let visibleViewController = navController?.visibleViewController
                        if (visibleViewController?.isKind(of: NotificationsViewController.self))!{
//                            let visibleTemp = visibleViewController as? NotificationsViewController
//                            visibleTemp?.viewDidLoad()
                             visibleViewController?.notificationsHandlerNavigation(notificationDic: userInfo as NSDictionary)
                            //self.window?.makeToast("Did receive viewdidload")
                        }
                        else{
                            visibleViewController?.notificationsHandlerNavigation(notificationDic: userInfo as NSDictionary)
                            //self.window?.makeToast("Did receive navigation")
                        }
                    }
                }
            }
        }
        completionHandler()
    }
    // [END ios_10_message_handling]
    
}

// [START ios_10_data_message_handling]
/*extension AppDelegate : MessagingDelegate {
    private func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
//        let instance = InstanceID.instanceID()
//        instance.deleteID { (error) in
//            print(error.debugDescription)
//        }
       // Messaging.messaging().shouldEstablishDirectChannel = true
        
        Messaging.messaging().token { token, error in
           // Check for error. Otherwise do what you will with token here
        }
        ConnectToFCM()
    }
        
//        if let refreshedToken = InstanceID.instanceID().token() {
//            if let isLogin = UserDefaults.standard.value(forKey: "login") as? Bool{
//                if isLogin == true{
//                    HomeViewController.fireBasePusnoticicatinsIdRegistrationWithUser(gcmId: refreshedToken)
//                }
//            }
//        }
   
    
    // Receive data message on iOS 10 devices while app is in the foreground.
   
}*/

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
}

extension UIApplication {
    @available(iOS 13.0, *)
    var userInterfaceStyle: UIUserInterfaceStyle? {
        return self.keyWindow?.traitCollection.userInterfaceStyle
    }
}

@available(iOS 13.0, *)
    func setSystemTheme() {
        switch UIApplication.shared.userInterfaceStyle {
        case .dark?:
            ColorSettings.shared.interfaceStyle = .dark
        case .light?:
            ColorSettings.shared.interfaceStyle = .light
        default:
            break
        }
    
    struct ColorSettings {
        
        static var shared : ColorSettings = ColorSettings()
        var interfaceStyle  : InterfaceStyle{
            get{
                UserDefaults.standard.string(forKey: "interfaceStyle") == "light" ? InterfaceStyle.light : InterfaceStyle.dark
            }set {
                UserDefaults.standard.setValue(newValue == .light ? "light" : "dark", forKey: "interfaceStyle")
            }
        }
    }
    }
