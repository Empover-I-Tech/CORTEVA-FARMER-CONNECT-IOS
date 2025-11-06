//
//  SideMenuViewController.swift
//  PioneerEmployee
//
//  Created by Empover on 10/08/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
//import UQScannerFramework

class SideMenuViewController: UIViewController, CollapsibleTableViewHeaderDelegate, UIGestureRecognizerDelegate{  // UQScannerDelegate
    
    @IBOutlet weak var sideMenuTblView: UITableView!
    
    var menuItemsArr = NSMutableArray()
    
    var navController : UINavigationController!
    
    var destViewController : UIViewController!
    
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
    
    @IBOutlet weak var ownerNameLbl: UILabel!
    
    @IBOutlet weak var privacyPolicyLbl: ActiveLabel!
    
    @IBOutlet weak var versionNumberLbl: UILabel!
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    @IBOutlet weak var topHeaderView: UIView!
    var dictEncashResponse : NSDictionary?
    
    var alertView : UIView?
    
    var section2collapsed : Bool = true
    
    var section4collapsed : Bool = true
    
    var sideMenuItems = NSMutableArray()
    
    var showCropDiagnosisStr = "false"
    var showRewardsStr = "false"
    var pravaktaMyBooklets = "false"
    var enableShopScanEarn = "false"
    var enableGenuinityScanResult = "false"
    
    var showGerminationStr = "false"
    //    var scannerVc : UQScannerViewController?
    var statusMsgAlert : UIView?
    var languageRow : String = ""
    
    var moduleType = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        sideMenuTblView.dataSource = self
        sideMenuTblView.delegate = self
        
        sideMenuTblView.tableFooterView = UIView()
        sideMenuTblView.separatorColor = UIColor.darkGray
        
        

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SideMenuViewController.topHeaderViewTapped(_:)))
        tap.delegate = self
        topHeaderView.addGestureRecognizer(tap)
        
       
        //NotificationCenter.default.addObserver(self, selector: #selector(SideMenuViewController.updateOwnerTitle), name: Notification.Name("UpdateOwnerTitle"), object: nil)
        
        
    }
    
    @objc func topHeaderViewTapped(_ sender: UITapGestureRecognizer) {
        //print("tapped")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.tempDictToSaveReqDetails = nil
        appDelegate.previousLocationStr = ""
        if let hamburguerViewController = self.findHamburguerViewController()?.contentViewController {
            self.navController = hamburguerViewController as? UINavigationController
        }
        else{
            navController = self.storyboard?.instantiateViewController(withIdentifier: "NavigationViewController") as! DLHamburguerNavigationController
        }
        if self.navController.topViewController != nil{
            destViewController = self.navController.topViewController
        }
        if let hamburguerViewController = self.findHamburguerViewController() {
            hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
            })
        }
        if self.navController.topViewController != nil{
            self.destViewController = self.navController.topViewController
            let myProfileVC = self.mainStoryboard.instantiateViewController(withIdentifier: "MyProfileViewController")
            self.destViewController.navigationController?.pushViewController(myProfileVC, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let userObj = Constatnts.getUserObject()
        
        menuItemsArr.removeAllObjects()
        
        ownerNameLbl.text = String(format: "%@ %@", userObj.firstName!, userObj.lastName!)
        showCropDiagnosisStr = userObj.showCropDiagnosis! as String
        showRewardsStr = userObj.showRewardsScheme! as String
        pravaktaMyBooklets = userObj.pravaktaMyBooklets! as String
        enableGenuinityScanResult = userObj.enableGenuinityCheckresults as! String
        enableShopScanEarn = userObj.enableShopScanWin! as String
        self.getFarmerAvailableOptionsFromSidemenuData(userObj)
        sideMenuTblView.reloadData()
        
        self.logoutBtn.setTitle(NSLocalizedString("log_out", comment: ""), for: .normal)
        let privacyStr = NSLocalizedString("privacy_policy", comment: "")
        let customType = ActiveType.custom(pattern: privacyStr)
        
        privacyPolicyLbl.enabledTypes.append(customType)
        privacyPolicyLbl.text = NSLocalizedString("privacy_policy", comment: "")
        privacyPolicyLbl?.customize({(label) in
            label.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                switch type {
                case customType:
                    atts[NSAttributedStringKey.underlineStyle] = isSelected ? NSUnderlineStyle.styleSingle.rawValue : NSUnderlineStyle.styleSingle.rawValue
                    atts[NSAttributedStringKey.foregroundColor] = isSelected ? UIColor(red: 255.0/255.0, green: 153.0/255.0, blue: 0.0/255.0, alpha: 1.0) : UIColor(red: 255.0/255.0, green: 153.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                default: ()
                }
                return atts
            }
            label.handleCustomTap(for: customType, handler: { (message) in
                // print("clicked")
                let net = NetworkReachabilityManager(host: "www.google.com")
                if net?.isReachable == true{
                    self.findHamburguerViewController()?.hideMenuViewControllerWithCompletion(nil)
                    let toPrivacyPolicyWebViewVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginPrivacyPolicyViewController") as! LoginPrivacyPolicyViewController
                    toPrivacyPolicyWebViewVC.privacyPolicyURLStr = PRIVACY_POLICY_URL as NSString
                    self.present(toPrivacyPolicyWebViewVC, animated: true, completion: nil)
                }
                else{
                    //                    self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE, duration: 1.0, position: .center)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                    return
                }
                
            })
            label.customColor[customType] = UIColor.white
        })
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let versionStr  = NSLocalizedString("version", comment: "")
        versionNumberLbl?.text = String(format: "%@ %@",versionStr, version)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFarmerAvailableOptionsFromSidemenuData(_ sideMenuData: User){
        let userObj = Constatnts.getUserObject()
        let arrDashBoardItems = NSMutableArray()
        
        arrDashBoardItems.add(NSLocalizedString("home", comment: ""))
        
        if userObj.weatherReport == "true"{
        arrDashBoardItems.add(NSLocalizedString("weather_report", comment: ""))
        }
        if userObj.hybridSeeds == "true"{
        arrDashBoardItems.add(NSLocalizedString("hybrid_Seeds", comment: ""))
        }
        if userObj.cropProtection == "true"{
        arrDashBoardItems.add(NSLocalizedString("Crop_Protection", comment: ""))
        }
        // arrDashBoardItems.add(NSLocalizedString("features", comment: ""))
        if userObj.genuinityCheck == "true"{
        arrDashBoardItems.add(NSLocalizedString("genuinity_check", comment: ""))
        }
        if userObj.nearBy == "true"{
        arrDashBoardItems.add(NSLocalizedString("nearby", comment: ""))
        }
        //
        if userObj.cropAdvisory == "true"{
        var cropAdvisorySection = Section(name: NSLocalizedString("crop_advisory", comment: ""), items: [NSLocalizedString("crop_advisory", comment: ""),NSLocalizedString("crop_advisory_notifications", comment: "")])
        cropAdvisorySection.collapsed = false
        arrDashBoardItems.add(cropAdvisorySection)
        }
       
        if  userObj.cepJourney == "true" ||  userObj.cepJourney == ""{
            arrDashBoardItems.add(NSLocalizedString("cep_Udayan", comment: ""))
        }
        if  userObj.rhrdJourney == "true" ||  userObj.rhrdJourney == ""{
            arrDashBoardItems.add(NSLocalizedString("rhrd_title", comment: ""))
        }
        
        if sideMenuData.showCropDiagnosis == "true"{
            arrDashBoardItems.add(NSLocalizedString("crop_diagnostic", comment: ""))
        }
//        var farmServicesSection = Section(name: NSLocalizedString("farm_services", comment: ""), items: [NSLocalizedString("provider", comment: ""),NSLocalizedString("requester", comment: "")])
//        farmServicesSection.collapsed = false
//        arrDashBoardItems.add(farmServicesSection)
        
        if userObj.mandiPrices == "true"{
        arrDashBoardItems.add(NSLocalizedString("mandi_prices", comment: ""))
        }
        if userObj.cropCalculator == "true"{
        arrDashBoardItems.add(NSLocalizedString("crop_calculator", comment: ""))
        }
        if userObj.farmerDashboard == "true"{
        arrDashBoardItems.add(NSLocalizedString("farmer_Dashboard", comment: ""))
        }
        if userObj.rewards == "true"{
        arrDashBoardItems.add(NSLocalizedString("rewards", comment: ""))
        }
        if sideMenuData.enableShopScanWin == "true"{
            arrDashBoardItems.add(NSLocalizedString("shop_scan_earn", comment: ""))
        }
        if sideMenuData.showRewardsScheme == "true"{
            arrDashBoardItems.add(NSLocalizedString("reward_schemes", comment: ""))
        }
        
        //<<<<<<< HEAD
        //
        //        arrDashBoardItems.add(Dashboard.REWARDS.rawValue)
        //
        //=======
        if userObj.paramarsh == "true"{
        arrDashBoardItems.add(NSLocalizedString("paramarsh", comment: ""))
        }
        if userObj.notification == "true"{
        arrDashBoardItems.add(NSLocalizedString("notifications", comment: ""))
        }
        if sideMenuData.showGermination == "true"{
            arrDashBoardItems.add(NSLocalizedString("germination", comment: ""))
        }
        //<<<<<<< HEAD
        //        arrDashBoardItems.add(Dashboard.PARAMARSH.rawValue)
        //        arrDashBoardItems.add(Dashboard.NOTIFICATIONS.rawValue)
        //
        //
        //=======
        if sideMenuData.pravaktaMyBooklets == "true"{
            arrDashBoardItems.add(NSLocalizedString("my_booklets", comment: ""))
        }
       if sideMenuData.enableGenuinityCheckresults == "true"{
            arrDashBoardItems.add(NSLocalizedString("Genuinity Check Results", comment: ""))
        }
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        if appdelegate.selectedLanguage == "en" {
            languageRow = Dashboard.CHANGE_LANGUAGE.rawValue
        }else {
            languageRow = Dashboard.CHANGE_LANGUAGE.rawValue +  " / " + NSLocalizedString("language_change", comment: "")
        }
        arrDashBoardItems.add(languageRow)   // Dashboard.CHANGE_LANGUAGE.rawValue
        
        //let logoutSection = Section(name: Dashboard.LOGOUT.rawValue, items: [])
        //arrDashBoardItems.add(Dashboard.LOGOUT.rawValue)
        menuItemsArr = arrDashBoardItems
    }
    
    @IBAction func logOutBtn_Touch_Up_Inside(_ sender: Any) {
        let net = NetworkReachabilityManager(host: "www.google.com")
        self.registerFirebaseEvents(Logout_Yes, "", "", "", parameters: nil)
        if net?.isReachable == true{
            self.requestToLogout()
        }
        else{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
    }
    
    //MARK: requestToLogout
    func requestToLogout (){
        
        SwiftLoader.show(animated: true)
        
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,LOGOUT])
        
        let userObj = Constatnts.getUserObject()
        
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        //print(headers)
        Alamofire.request(urlString, method: .post, parameters: ["data": ""], encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil{
                if let json = response.result.value {
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        DispatchQueue.main.async {
                            Constatnts.logOut()
                        }
                    }
                }
            }
        }
    }
    
    func mainNavigationController() -> DLHamburguerNavigationController {
        return self.storyboard?.instantiateViewController(withIdentifier: "NavigationViewController") as! DLHamburguerNavigationController
    }
}

extension SideMenuViewController : UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //Return the number of sections.
        return menuItemsArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sectionData = menuItemsArr.object(at: section) as? Section{
            if sectionData.collapsed == true{
                if (sectionData.items.count) > 0{
                    return (sectionData.items.count)
                }
                return 1
            }
            return 0
        }
        else{
            return 1
        }
    }
    
    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let sectionData = menuItemsArr.object(at: section) as? Section{
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
            header.backgroundColor = UIColor.white
            header.titleLabel.text = sectionData.name
            //header.titleLabel.backgroundColor = UIColor.blue
            //header.arrowLabel.text = ">"
            header.setCollapsed((sectionData.collapsed))
            header.section = section
            header.delegate = self
            header.arrowBtn.rotate(section2collapsed ? 0.0 : -.pi/2)
            
            return header
        }
        else{
            return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SideCell")
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "SideCell")
            cell!.backgroundColor = UIColor.clear
        }
        let titleLbl : UILabel = cell!.viewWithTag(100) as! UILabel
        if let sectionData = menuItemsArr.object(at: indexPath.section) as? Section{
            titleLbl.text = sectionData.items.object(at: indexPath.row) as? String
        }
        else{
            titleLbl.text = menuItemsArr.object(at: indexPath.section) as? String
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if menuItemsArr.object(at: section) is Section{
            return 35
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.tempDictToSaveReqDetails = nil
        appDelegate.previousLocationStr = ""
        
        if let hamburguerViewController = self.findHamburguerViewController()?.contentViewController {
            self.navController = hamburguerViewController as? UINavigationController
        }
        else{
            navController = self.storyboard?.instantiateViewController(withIdentifier: "NavigationViewController") as! DLHamburguerNavigationController
        }
        let currentViewController = self.navController.visibleViewController
        
        if let sectionData = menuItemsArr.object(at: indexPath.section) as? Section{
            let menuTitle = sectionData.name
            switch (menuTitle){
            case NSLocalizedString("crop_advisory", comment: ""):
                switch (indexPath.row){
                case 0:
                    let net = NetworkReachabilityManager(host: "www.google.com")
                    if net?.isReachable == true{
                        
                        appDelegate.isOpennedCropAdvisoryFromSidemMenu = true
                        
                        if currentViewController is HomeViewController
                        {
                            destViewController = currentViewController
                            
                            break
                        }
                        else{
                            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                        }
                        
                        break
                    }
                    else{
                        if self.navController.topViewController != nil{
                            destViewController = self.navController.topViewController
                        }
                        if let hamburguerViewController = self.findHamburguerViewController() {
                            hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                            })
                        }
                        self.destViewController.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                    }
                    break
                case 1:
                    if currentViewController is CropNotificationViewController
                    {
                        destViewController = currentViewController
                        break
                    }
                    else{
                        destViewController = mainStoryboard.instantiateViewController(withIdentifier: "CropNotificationViewController") as? CropNotificationViewController
                    }
                    break
                    
                default:
                    break
                }
                break
            case NSLocalizedString("farm_services", comment: ""):
                switch (indexPath.row){
                case 0:
                    if currentViewController is AddEquipmentViewController
                    {
                        destViewController = currentViewController
                        break
                    }
                    else{
                        destViewController = mainStoryboard.instantiateViewController(withIdentifier: "EquipmentsViewController") as? EquipmentsViewController
                    }
                    break
                case 1:
                    if currentViewController is RequesterViewController
                    {
                        destViewController = currentViewController
                        break
                    }
                    else{
                        destViewController = mainStoryboard.instantiateViewController(withIdentifier: "RequesterViewController") as? RequesterViewController
                    }
                    break
                    
                default:
                    break
                }
                
                break
            default: break
            }
        }
        else{
            
            let menuTitle = menuItemsArr.object(at: indexPath.section) as? String
            switch (menuTitle) {
            case NSLocalizedString("home", comment: "")?:
                if currentViewController is HomeViewController
                {
                    destViewController = currentViewController
                }
                else{
                    destViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                }
                break
                
            case "Hybrid Seeds" :    // NSLocalizedString("features", comment: "")?
                if currentViewController is FABViewController
                {
                    destViewController = currentViewController
                }
                else{
                    destViewController = mainStoryboard.instantiateViewController(withIdentifier: "FABViewController") as? FABViewController
                }
                break
            case "Crop Protection" :    // NSLocalizedString("features", comment: "")?
                if currentViewController is SelectCropAndProductViewController
                {
                    destViewController = currentViewController
                }
                else{
                    destViewController = mainStoryboard.instantiateViewController(withIdentifier: "SelectCropAndProductViewController") as? SelectCropAndProductViewController
                }
                break
                
            case NSLocalizedString("crop_diagnostic", comment: "")?:
                if currentViewController is CropDiagnosis_ViewController
                
                //            case NSLocalizedString("crop_diagnostic", comment: "")?:
                //                if currentViewController is CropDiagnosisViewController
                //>>>>>>> remotes/origin/Multiple_Language_Support
                {
                    destViewController = currentViewController
                    break
                }
                else{
                    //                    destViewController = mainStoryboard.instantiateViewController(withIdentifier: "CropDiagnosisPeetViwControllerOne") as? CropDiagnosisPeetViwControllerOne
                    destViewController = self.storyboard?.instantiateViewController(withIdentifier: "CropDiagnosis_ViewController") as? CropDiagnosis_ViewController
                    
                }
                break
            //<<<<<<< HEAD
            //
            //            case Dashboard.CROP_CALCULATOR.rawValue?:
            //=======
            
            case NSLocalizedString("cep_Udayan", comment: "")?:
                if currentViewController is CEPLandingViewController
                {
                    destViewController = currentViewController
                    break
                }
                else{
                    destViewController = self.storyboard?.instantiateViewController(withIdentifier: "CEPLandingViewController") as? CEPLandingViewController
                    
                }
                break
            case NSLocalizedString("rhrd_title", comment: "")?:
                if currentViewController is RHRDLandingViewController
                {
                    destViewController = currentViewController
                    break
                }
                else{
                    destViewController = self.storyboard?.instantiateViewController(withIdentifier: "RHRDLandingViewController") as? RHRDLandingViewController
                    
                }
                break
                
            case NSLocalizedString("crop_calculator", comment: "")?:
                let net = NetworkReachabilityManager(host: "www.google.com")
                if net?.isReachable == true{
                    if currentViewController is CalculatorHomeViewController
                    {
                        destViewController = currentViewController
                    }
                    else{
                        destViewController = mainStoryboard.instantiateViewController(withIdentifier: "CalculatorHomeViewController") as? CalculatorHomeViewController
                    }
                }
                break
            case NSLocalizedString("weather_report", comment: "")?:
                let net = NetworkReachabilityManager(host: "www.google.com")
                if net?.isReachable == true{
                    if currentViewController is WeatherReportViewController
                    {
                        destViewController = currentViewController
                        UserDefaults.standard.set(false, forKey: "isFromHome")
                        UserDefaults.standard.synchronize()
                        break
                    }
                    else{
                        destViewController = mainStoryboard.instantiateViewController(withIdentifier: "WeatherReportViewController") as? WeatherReportViewController
                        UserDefaults.standard.set(false, forKey: "isFromHome")
                        UserDefaults.standard.synchronize()
                        
                    }
                }
                else{
                    if self.navController.topViewController != nil{
                        destViewController = self.navController.topViewController
                    }
                    if let hamburguerViewController = self.findHamburguerViewController() {
                        hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                        })
                    }
                    self.destViewController.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                }
                break
            case NSLocalizedString("mandi_prices", comment: "")?:
                if currentViewController is MandisAndCropsDashboard
                {
                    destViewController = currentViewController
                    break
                }
                else{
                    destViewController = mainStoryboard.instantiateViewController(withIdentifier: "MandisAndCropsDashboard") as? MandisAndCropsDashboard
                }
                break
            case NSLocalizedString("paramarsh", comment: "")?:
                if currentViewController is ParamarshProfileViewController
                {
                    destViewController = currentViewController
                    break
                }
                else{
                    let storyBoard = UIStoryboard(name: "Paramarsh" , bundle: nil)
                    destViewController = storyBoard.instantiateViewController(withIdentifier: "ParamarshProfileViewController") as? ParamarshProfileViewController
                }
                break
            case NSLocalizedString("notifications", comment: "")?:
                if currentViewController is NotificationsViewController
                {
                    destViewController = currentViewController
                    break
                }
                else{
                    destViewController = mainStoryboard.instantiateViewController(withIdentifier: "NotificationsViewController") as? NotificationsViewController
                }
                break
            case NSLocalizedString("farmer_Dashboard", comment: "")?:
                if currentViewController is FarmerTimeLineVerticalViewController
                {
                    destViewController = currentViewController
                    break
                }
                else{
                    destViewController = mainStoryboard.instantiateViewController(withIdentifier: "FarmerTimeLineVerticalViewController") as? FarmerTimeLineVerticalViewController
                }
                break
            case NSLocalizedString("genuinity_check", comment: "")?:
                //                let genunityVC  = GenunityCheckViewController()
                //                 destViewController = genunityVC
                appDelegate.isOpennedGenuinityCheckFromSidemMenu = true
                
                if currentViewController is HomeViewController
                {
                    destViewController = currentViewController
                    
                    break
                }
                else{
                    destViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                }
                break
                
            case NSLocalizedString("nearby", comment: "")?:
                if currentViewController is NearByViewController
                {
                    destViewController = currentViewController
                    break
                }
                else{
                    destViewController = mainStoryboard.instantiateViewController(withIdentifier: "NearByViewController") as? NearByViewController
                }
                
                break
                
            case NSLocalizedString("reward_schemes", comment: "")?:
                //                let genunityVC  = GenunityCheckViewController()
                //                 destViewController = genunityVC
                //                self.openGenunityCheckScanner(currentController: self)
                appDelegate.isOpennedGenuinityCheckFromSidemMenu = true
                
                if currentViewController is HomeViewController
                {
                    destViewController = currentViewController
                    
                    break
                }
                else{
                    destViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                }
                
                break
            case NSLocalizedString("my_booklets", comment: "")?:
                
                
                if currentViewController is BookletsViewController
                {
                    destViewController = currentViewController
                    
                    break
                }
                else{
                    destViewController = mainStoryboard.instantiateViewController(withIdentifier: "BookletsViewController") as? BookletsViewController
                }
                
                break
            case NSLocalizedString("shop_scan_earn", comment: "")?:
                
                appDelegate.isOpenedShopScanEarnFromSideMenu = true
                if currentViewController is HomeViewController
                {
                    
                    destViewController = currentViewController
                    
                    
                    break
                }
                else{
                    
                    destViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                    
                }
                
                break
            case NSLocalizedString("Genuinity Check Results", comment: "")?:
                
                appDelegate.isOpenedGenuinityCheckResultsFromSideMenu = true
                if currentViewController is HomeViewController
                {
                    
                    destViewController = currentViewController
                    
                    
                    break
                }
                else{
                    
                    destViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                    
                }
                
                break
                
            case NSLocalizedString("rewards", comment: "")?:
                let rewardsVC = self.storyboard?.instantiateViewController(withIdentifier: "RewardsViewController") as? RewardsViewController
                
                destViewController = rewardsVC
                break
            case NSLocalizedString("germination", comment: "")?:
                let net = NetworkReachabilityManager(host: "www.google.com")
                if net?.isReachable == true{
                    if currentViewController is GerminationViewController
                    {
                        destViewController = currentViewController
                        break
                    }
                    else{
                        destViewController = mainStoryboard.instantiateViewController(withIdentifier: "GerminationViewController") as? GerminationViewController
                    }
                }
                else{
                    if self.navController.topViewController != nil{
                        destViewController = self.navController.topViewController
                    }
                    if let hamburguerViewController = self.findHamburguerViewController() {
                        hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                        })
                    }
                    self.destViewController.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                }
                break
                
            case languageRow? :
                if currentViewController is ChangeLanguageViewController
                {
                    destViewController = currentViewController
                    break
                }
                else{
                    destViewController = mainStoryboard.instantiateViewController(withIdentifier: "ChangeLanguageViewController") as? ChangeLanguageViewController
                }
                break
            default:
                break
            }
        }
        
        if let viewController = destViewController{
            navController.viewControllers = [viewController]
            if let hamburguerViewController = self.findHamburguerViewController() {
                hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                    hamburguerViewController.contentViewController = self.navController
                })
            }
        }
    }
    
    //MARK: checkGermination
    func checkGermination(){
        GerminationServiceManager.getGerminationList(completionHandler: { (success,responseDict,errorMessage) in
            if success == true{
                if let germinationFarmersDataObj = responseDict?.value(forKey: "germinationFarmersData") as? NSArray{
                    if germinationFarmersDataObj.count > 0{
                        if germinationFarmersDataObj.count == 1{
                            let germinationListDict = GerminationList(dict: germinationFarmersDataObj.object(at: 0) as! NSDictionary)
                            //print(germinationListDict)
                            let statusObj = (germinationFarmersDataObj.object(at: 0) as! NSDictionary).value(forKey: "status") as! String
                            if statusObj == STATUS_AGREEMENT_PENDING{
                                if self.navController.topViewController != nil{
                                    self.destViewController = self.navController.topViewController
                                    let germinationAgreementVC = self.mainStoryboard.instantiateViewController(withIdentifier: "GerminationAgreementViewController") as? GerminationAgreementViewController
                                    germinationAgreementVC?.germinationModelObj = germinationListDict
                                    germinationAgreementVC?.isFromHome = false
                                    self.destViewController.navigationController?.pushViewController(germinationAgreementVC!, animated: true)
                                }
                            }
                            else{
                                let listArray = NSMutableArray()
                                let germinationListDict = GerminationList(dict: germinationFarmersDataObj.object(at: 0) as! NSDictionary)
                                listArray.add(germinationListDict)
                                //print(listArray)
                                if self.navController.topViewController != nil{
                                    self.destViewController = self.navController.topViewController
                                    let germinationListVC = self.mainStoryboard.instantiateViewController(withIdentifier: "GerminationListViewController") as? GerminationListViewController
                                    germinationListVC?.germinationListArray = listArray
                                    germinationListVC?.isFromHome = false
                                    self.destViewController.navigationController?.pushViewController(germinationListVC!, animated: true)
                                }
                            }
                        }
                        else{
                            let listArray = NSMutableArray()
                            var germinationListDict: GerminationList?
                            for i in 0..<germinationFarmersDataObj.count{
                                germinationListDict = GerminationList(dict: germinationFarmersDataObj.object(at: i) as! NSDictionary)
                                listArray.add(germinationListDict!)
                            }
                            //print(listArray)
                            if self.navController.topViewController != nil{
                                self.destViewController = self.navController.topViewController
                                let germinationListVC = self.mainStoryboard.instantiateViewController(withIdentifier: "GerminationListViewController") as? GerminationListViewController
                                germinationListVC?.germinationListArray = listArray
                                germinationListVC?.isFromHome = false
                                self.destViewController.navigationController?.pushViewController(germinationListVC!, animated: true)
                            }
                        }
                    }
                }
            }
            else{
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.makeToast(errorMessage ?? "")
            }
        })
        if let hamburguerViewController = self.findHamburguerViewController() {
            hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
            })
        }
    }
    
    //MARK: checkGerminationPendingOrClaimed
    func checkGerminationPendingOrClaimed(){
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            if let hamburguerViewController = self.findHamburguerViewController() {
                hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                })
            }
            if self.navController.topViewController != nil{
                self.destViewController = self.navController.topViewController
                let toGerminationVC = self.mainStoryboard.instantiateViewController(withIdentifier: "GerminationViewController") as? GerminationViewController
                toGerminationVC?.isFromHome = false
                self.destViewController.navigationController?.pushViewController(toGerminationVC!, animated: true)
            }
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
                            if self.navController.topViewController != nil{
                                self.destViewController = self.navController.topViewController
                            }
                            let germinationObj = listArray.firstObject as? GerminationList
                            let germinationAlert = GerminationAlertView(frame: UIScreen.main.bounds, germination: germinationObj!)
                            germinationAlert.successHandler = {(status, acres) in
                                germinationAlert.removeFromSuperview()
                                if status == true{
                                    if let hamburguerViewController = self.findHamburguerViewController() {
                                        hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                                        })
                                    }
                                    if self.navController.topViewController != nil{
                                        self.destViewController = self.navController.topViewController
                                        let toGerminationAgreementVC = self.mainStoryboard.instantiateViewController(withIdentifier: "GerminationAgreementViewController") as? GerminationAgreementViewController
                                        toGerminationAgreementVC?.germinationModelObj = germinationListDict
                                        toGerminationAgreementVC?.isFromHome = false
                                        self.destViewController.navigationController?.pushViewController(toGerminationAgreementVC!, animated: true)
                                    }
                                }
                            }
                            if let hamburguerViewController = self.findHamburguerViewController() {
                                hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                                })
                            }
                            UIApplication.shared.keyWindow?.addSubview(germinationAlert)
                            //self.view.addSubview(germinationAlert)
                        }
                        else if listArray.count > 1{ //alert action sheet
                            self.showGerminationCropsListActionSheet(responseArray: listArray)
                        }
                    }
                    else{
                        if self.navController.topViewController != nil{
                            self.destViewController = self.navController.topViewController
                        }
                        if let hamburguerViewController = self.findHamburguerViewController() {
                            hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                            })
                        }
                        if let msg = errorMessage as String?{
                            self.destViewController.view.makeToast(msg)
                        }
                    }
                }
            }
        })
    }
    
    func showGerminationCropsListActionSheet(responseArray:NSArray?){
        if responseArray != nil{
            if responseArray?.count ?? 0 > 0{
                let germinationActionSheet = UIAlertController(title: "Select Crop", message: "", preferredStyle: .alert)
                for i in 0..<(responseArray?.count)!{
                    let germination = responseArray?.object(at:i) as? GerminationList
                    let germinationAction = UIAlertAction(title: germination?.cropName, style: .default, handler: { (alertAction) in
                        //print(alertAction.title!)
                        let predicate = NSPredicate(format: "cropName == %@", alertAction.title!)
                        let filteredArray = responseArray?.filtered(using: predicate)
                        if filteredArray?.count ?? 0 > 0{
                            let germinationObj = filteredArray?.first as? GerminationList
                            if self.navController.topViewController != nil{
                                self.destViewController = self.navController.topViewController
                            }
                            let germinationAlert = GerminationAlertView(frame: UIScreen.main.bounds, germination: germinationObj!)
                            germinationAlert.successHandler = {(status, acres) in
                                germinationAlert.removeFromSuperview()
                                if status == true{
                                    if let hamburguerViewController = self.findHamburguerViewController() {
                                        hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                                        })
                                    }
                                    if self.navController.topViewController != nil{
                                        //self.destViewController = self.navController.topViewController
                                        let toGerminationAgreementVC = self.mainStoryboard.instantiateViewController(withIdentifier: "GerminationAgreementViewController") as? GerminationAgreementViewController
                                        toGerminationAgreementVC?.germinationModelObj = germination
                                        toGerminationAgreementVC?.isFromHome = false
                                        self.destViewController.navigationController?.pushViewController(toGerminationAgreementVC!, animated: true)
                                    }
                                }
                            }
                            UIApplication.shared.keyWindow?.addSubview(germinationAlert)
                            //self.view.addSubview(germinationAlert)
                        }
                    })
                    germinationActionSheet.addAction(germinationAction)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (alertAction) in
                    
                }
                germinationActionSheet.addAction(cancelAction)
                if let hamburguerViewController = self.findHamburguerViewController() {
                    hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                    })
                }
                if self.navController.topViewController != nil{
                    self.destViewController = self.navController.topViewController
                    self.destViewController.present(germinationActionSheet, animated: true, completion: nil)
                }
            }
        }
    }
    
    func openGenunityCheckScanner(currentController:UIViewController){
        
        //        //  ClientConstants.initializeClientConstants(authId: Genunity_Auth_Id, authToken: Genunity_Auth_Token, baseUrl: Genunity_URL, themeColor: App_Theme_Green_Color, qrFrameColor: App_Theme_Green_Color, qrDotsColor: App_Theme_Green_Color, deploymentEnvironment: "prod", externalUserId: nil, mobileNo: nil, countryCode: nil, packageIdRequired: true, infoEnabled: false, settingsEnabled: true, backEnabled: true, notificationEnable: true, isLocation: false, isUploadImages: true, isUUID: false, fullName: nil, email: nil, hUQL: false, showQRFeedback: false, scanDetails: [], qrImgFileName: "File1")
        ////
        //        let userObj = Constatnts.getUserObject()
        //        ClientConstants.initialize(
        //            deploymentEnvironment: .Test,
        //            isLocationRequired: true,
        //            guidingImage: UIImage(named: "uniquo_guidingImage"),
        //            enableButton: (info: false, back: true),
        //            color: (theme: App_Theme_Blue_Color,
        //                    frame: App_Theme_Blue_Color,
        //                    dots: App_Theme_Blue_Color),
        //            userDetails: UQUserDetails(userId:userObj.customerId! as String, mobile: "" , email: "", fullName: "")
        //        ) //UQUserDetails(userId:userObj.customerId! as String, mobile: "" , email: "", fullName: "")
        //        let storyBoard = UIStoryboard(name: "Authenticity", bundle: Bundle(for: UQScannerViewController.classForCoder()))
        //        let vc = storyBoard.instantiateViewController(withIdentifier: "ScannerVCID") as? UQScannerViewController
        //        vc?.scanDelegate  = self
        //        scannerVc = vc
        //        let hamburguerViewController = self.findHamburguerViewController()?.contentViewController
        //        self.navController = hamburguerViewController as? UINavigationController
        //        self.navController.pushViewController(scannerVc!, animated: true)
    }
    
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
    //            if self.dictEncashResponse?.value(forKey: "showClickableLink") as? Bool == true  {
    //                strCashReward  = String(format: "Cash Back : Rs.%@/-",self.dictEncashResponse?.value(forKey: "cashRewards") as! CVarArg)
    //            }else {
    //                strCashReward = ""
    //            }
    //
    //            self.statusMsgAlert = CustomAlert.genunityCheckResultPopup(self, frame: appDelegate.window?.frame ?? self.view.frame, title: ("Genuinity Check" as NSString?)!, message: responseDictionary?.value(forKey: "uq_message") as? NSString ?? "N/A", buttonTitle1: responseDictionary?.value(forKey: "buttonTitle1") as? NSString ?? "", buttonTitle2: responseDictionary?.value(forKey: "buttonTitle2") as? NSString ?? "", imgCorteva: UIImage(named:"corteva")!, statusLogo: ststusLogo!, hideClose: true, rewardMessage: responseDictionary?.value(forKey: "primaryRewardMsg") as? NSString ?? "", rewardMessage1: responseDictionary?.value(forKey: "secondaryRewardMsg") as? NSString ?? "", showEncashBtn: responseDictionary?.value(forKey: "showClickableLink") as? Bool ?? false,prodSerialNo: responseDictionary?.value(forKey: "prodSerialNumber") as? NSString ?? "",cashBackMsg: strCashReward as NSString, productName: responseDictionary?.value(forKey: "productName") as? NSString ?? "", enableSprayService: responseDictionary?.value(forKey: "enableSprayService") as? Bool ?? false) as? UIView
    //            appDelegate.window?.rootViewController?.view.addSubview(self.statusMsgAlert!)
    //
    //        }
    //    }
    
    //    func onBackPressed() {
    //        scannerVc?.dismissUQScanner(animated: true, cb: {
    //            self.scannerVc =  nil
    //        })
    //    }
    
    @objc func infoAlertScanMore(){
        
        if self.statusMsgAlert != nil {
            self.statusMsgAlert?.removeFromSuperview()
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = (appDelegate.window?.rootViewController)!
        //self.openGenunityCheckScanner(currentController: vc )
        
    }
    @objc func infoCloseButton(){
        
        if self.statusMsgAlert != nil {
            self.statusMsgAlert?.removeFromSuperview()
        }
        
    }
    @objc func infoAlertSubmit(){
        if self.statusMsgAlert != nil {
            let userObj = Constatnts.getUserObject()
            
            self.registerFirebaseEvents(GC_Exit, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "SideMenuViewController", parameters: nil)
            self.statusMsgAlert?.removeFromSuperview()
        }
        
        if dictEncashResponse?.value(forKey: "multipleRewards") as? Bool ?? false  && dictEncashResponse?.value(forKey: "showClickableLink") as? Bool ?? false{
            let rewardsVC = self.storyboard?.instantiateViewController(withIdentifier: "RewardsViewController") as? RewardsViewController
            self.navigationController?.pushViewController(rewardsVC!, animated: true)
            return
        }
        let showClickable =  dictEncashResponse?.value(forKey: "multipleRewards") as? Bool
        if dictEncashResponse?.value(forKey: "showClickableLink") as? Bool ?? false &&  showClickable == false  {
            
            let userObj = Constatnts.getUserObject()
            
            let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"rewardPoints" : dictEncashResponse?.value(forKey: "rewardPoints"),"screen_name" : "HomeViewController", "serverRecordId" : dictEncashResponse?.value(forKey: "serverRecordId")] as [String : Any]
            
            var claimIDsArray = NSMutableArray()
            var params = NSDictionary()
            params = [ "serverRecordId" : dictEncashResponse?.value(forKey: "serverRecordId") as? NSString ?? "","benfTransactionId" : dictEncashResponse?.value(forKey: "benfTransactionId") as? NSString ?? ""]
            claimIDsArray.add(params)
            let strCashReward  = self.dictEncashResponse?.value(forKey: "cashRewards") as? String // String(format: "Cash Back : Rs.%@/-",self.dictEncashResponse?.value(forKey: "cashRewards") as! CVarArg)
            
            let parameters = ["cashRewards":strCashReward ?? "","claimIDs":claimIDsArray] as NSDictionary
            
            
            self.registerFirebaseEvents(Selected_Payment_Option_Confirm, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "HomeViewController", parameters: fireBaseParams as NSDictionary)
            
            let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectModeOfTransferViewController") as? SelectModeOfTransferViewController
            print(params)
            toSelectPayVC?.dictEncashResponse = parameters//  dictEncashResponse
            //            self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
            if self.navController.topViewController != nil{
                self.destViewController = self.navController.topViewController
                let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectModeOfTransferViewController") as? SelectModeOfTransferViewController
                let arrrayPayment = NSMutableArray()
                arrrayPayment.add(dictEncashResponse?.value(forKey: "viewPaymentOptions")  as? NSArray ?? [])
                
                if arrrayPayment.count>0{
                    toSelectPayVC?.viewPaymentOptions = arrrayPayment as? NSMutableArray ?? []
                }
                toSelectPayVC?.dictEncashResponse = parameters
                print(parameters)
                self.destViewController.navigationController?.pushViewController(toSelectPayVC!, animated: false)
            }
        }
        
    }
    
    
    @objc func gotoEncashPointsPage(){
        if self.statusMsgAlert != nil {
            self.statusMsgAlert?.removeFromSuperview()
        }
        let userObj = Constatnts.getUserObject()
        
        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"rewardPoints" : dictEncashResponse?.value(forKey: "rewardPoints"),"screen_name" : "HomeViewController", "serverRecordId" : dictEncashResponse?.value(forKey: "serverRecordId")] as [String : Any]
        
        var claimIDsArray = NSMutableArray()
        var params = NSDictionary()
        params = [ "serverRecordId" : dictEncashResponse?.value(forKey: "serverRecordId") as? NSString ?? "" ,"benfTransactionId" : dictEncashResponse?.value(forKey: "benfTransactionId") as? NSString ?? ""]
        claimIDsArray.add(params)
        
        let strCashReward  =  self.dictEncashResponse?.value(forKey: "cashRewards") as? String //String(format: "Cash Back : Rs.%@/-",self.dictEncashResponse?.value(forKey: "cashRewards") as! CVarArg)
        
        let parameters = ["cashRewards":strCashReward ?? "","claimIDs":claimIDsArray] as NSDictionary
        
        self.registerFirebaseEvents(Selected_Payment_Option_Confirm, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "SideMenuViewController", parameters: fireBaseParams as NSDictionary)
        
        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectModeOfTransferViewController") as? SelectModeOfTransferViewController
        print(params)
        toSelectPayVC?.dictEncashResponse =  parameters //  dictEncashResponse
        let arrrayPayment = NSMutableArray()
        arrrayPayment.add(dictEncashResponse?.value(forKey: "viewPaymentOptions")  as? NSArray ?? [])
        
        if arrrayPayment.count>0{
            toSelectPayVC?.viewPaymentOptions = arrrayPayment as? NSMutableArray ?? []
        }
        self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
        
    }
    
    // MARK: - Section Header Delegate
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        var sectionData = menuItemsArr.object(at: section) as? Section
        let collapsed = sectionData?.collapsed
        sectionData?.collapsed = !(collapsed!)
        menuItemsArr.replaceObject(at: section, with: sectionData!)
        header.setCollapsedCrop(!(collapsed!))
        sideMenuTblView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)){
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            cell.preservesSuperviewLayoutMargins = false
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)){
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
}
