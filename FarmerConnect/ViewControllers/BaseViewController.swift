//
//  BaseViewController.swift
//  PioneerEmployee
//
//  Created by Empover on 11/09/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import UIKit
//import FirebaseInstanceID
import Firebase

@IBDesignable extension UIImageView{
    @IBInspectable override var borderColor:UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    @IBInspectable override var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable override var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}

@IBDesignable extension UIButton{
    @IBInspectable override var borderColor:UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    @IBInspectable override var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable override var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}

@IBDesignable extension UILabel{
    @IBInspectable override var borderColor:UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    @IBInspectable override var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable override var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}

@IBDesignable extension UIView {
    @IBInspectable var borderColor:UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    @IBInspectable var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

open class BaseViewController: UIViewController {
    
    enum PaymentModes : String {
        case UPI = "upi"
        case PAYTM = "paytm"
        case AMAZON = "amazonpay"
        case BANK = "banktransfer"
    }
    
    
    var topView : UIView?
    var backButton : UIButton?
    var homeButton : UIButton?
    var topImageView : UIImageView?
    var btnCoupons : UIButton?
    var lblCouponCount : UILabel?
    var deeplinkParams : NSDictionary?
    var isFromDeeplink : Bool = false
    
    /// custom Title (label) of Navigation bar
    var lblTitle : UILabel?
    var lblRewardAmount : UILabel?
    override open func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText = NSLocalizedString("done", comment: "")
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true
        
        self.setStatusBarBackgroundColor(color: App_Theme_Blue_Color)
        
        self.topView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        //self.topView?.backgroundColor = UIColor.white//UIColor(red:4.0/255.0, green:7.0/255.0, blue:7.0/255.0, alpha:1.0)
        self.topView?.backgroundColor = App_Theme_Blue_Color
        
        topView?.layer.borderWidth = 0.2
        topView?.layer.cornerRadius = 1.0
        topView?.layer.borderColor = UIColor.lightGray.cgColor
        topView?.layer.masksToBounds = false
        topView?.layer.shadowOffset = CGSize.init(width: 0.2, height: 0.2)
        topView?.layer.shadowRadius = 0.3
        topView?.layer.shadowOpacity = 0.5
        
        self.backButton = UIButton(type: .custom)
        self.backButton?.frame = CGRect(x: 2, y: 5, width: 45, height: 45)
        self.backButton?.setImage(UIImage(named: "Back"), for: UIControlState())
        self.backButton?.addTarget(self, action: #selector(BaseViewController.backButtonClick(_:)), for: .touchUpInside)
        topView?.addSubview(backButton!)
        
        //        self.topImageView = UIImageView(frame: CGRect(x: 0, y: 5, width: topView!.frame.size.width, height: 45))
        //        self.topImageView?.image = UIImage(named: "TopBarImage")
        //        self.topImageView?.contentMode = .scaleAspectFit
        //        topView?.addSubview(topImageView!)
        
        self.lblTitle = UILabel(frame: CGRect(x: 65, y: 10, width: topView!.frame.size.width - 100, height: 35))
        self.lblTitle?.textColor = UIColor.white    //UIColor(red:34.0/255.0, green:119.0/255.0, blue:45.0/255.0, alpha:1.0)
        self.lblTitle?.font = UIFont.systemFont(ofSize: 18)//UIFont(name: "HelveticaNeueBold", size: 18.0)
        topView?.addSubview(lblTitle!)
        
        self.lblRewardAmount = UILabel(frame: CGRect(x: topView!.frame.size.width - 110, y: 5, width:  100 , height: 40))
        self.lblRewardAmount?.textColor = UIColor.white    //UIColor(red:34.0/255.0, green:119.0/255.0, blue:45.0/255.0, alpha:1.0)
        self.lblRewardAmount?.font = UIFont.boldSystemFont(ofSize: 15)//UIFont(name: "HelveticaNeueBold", size: 18.0)
        self.lblRewardAmount?.numberOfLines = 0
        self.lblRewardAmount?.textAlignment = .center
        topView?.addSubview(lblRewardAmount!)
        
        
        
        
        self.homeButton = UIButton(type: .custom)
        self.homeButton?.frame = CGRect(x: (lblTitle?.frame.size.width)!+5, y: 10, width: 30, height: 30)
        self.homeButton?.setImage(UIImage(named:"home.png"), for: UIControlState())
        self.homeButton?.addTarget(self, action: #selector(BaseViewController.homeButtonClick(_:)), for: .touchUpInside)
        topView?.addSubview(homeButton!)
        
        //        let bottomline = UIImageView(frame: CGRect(x: 0, y: (self.topView?.frame.maxY)! - 1, width: (self.topView?.frame.maxX)!, height: 1.0))
        //        bottomline.backgroundColor = UIColor(red: 236.0/255.0, green: 125.0/255.0, blue: 59.0/255.0, alpha: 1.0)
        //        self.topView?.addSubview(bottomline)
        
        self.navigationController?.navigationBar.addSubview(topView!)
        //        self.setStatusBarBackgroundColor(color: App_Theme_Blue_Color)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.topView?.isHidden = false
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.topView?.isHidden = true
    }
    
    func showBackButton(_ show: Bool){
        if (!show) {
            topImageView!.frame = CGRect(x: 0, y: 5, width: topView!.frame.size.width, height: 45);
        }
        else{
            topImageView!.frame = CGRect(x: 0, y: 5, width: topView!.frame.size.width, height: 45);
        }
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        if #available(iOS 13.0, *) {
            let statusBar1 =  UIView()
            statusBar1.frame = UIApplication.shared.statusBarFrame
            statusBar1.backgroundColor = color
            UIApplication.shared.keyWindow?.addSubview(statusBar1)
            
            //            let statusBar = UIView(frame:(UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
            //            statusBar.backgroundColor = UIColor.white
            //            UIApplication.shared.keyWindow?.addSubview(statusBar)
        }else{
            guard let statusBar = (UIApplication.shared.value(forKey: "statusBarWindow") as AnyObject?)?.value(forKey: "statusBar") as! UIView? else {
                return
            }
            statusBar.backgroundColor = color
            
        }
    }
    func getCurrentDateAndTime()-> String{
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = df.string(from: date)
        return dateString
    }
    /**
     This method is used to enable dropdown for the textfields
     */
    func loadDropDownTableView(tableViewDataSource: UITableViewDataSource,tableViewDelegate:UITableViewDelegate,tableview:UITableView,textField:UITextField){
        
        //tableview.dataSource = self as? UITableViewDataSource
        //tableview.delegate = self as? UITableViewDelegate
        tableview.isScrollEnabled = true
        tableview.isHidden = true
        //dropDownTableView.layer.cornerRadius = 5.0
        tableview.layer.borderWidth = 0.5
        //cityDropDownTableView.cellLayoutMarginsFollowReadableWidth = false
        tableview.layer.borderColor = UIColor.gray.cgColor
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.tableFooterView = UIView()
        
        self.view.addSubview(tableview)
        //
        let xConstraint = NSLayoutConstraint.init(item: tableview, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem:textField , attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0) as NSLayoutConstraint
        let yConstraint = NSLayoutConstraint.init(item: tableview, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem:textField , attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0) as NSLayoutConstraint
        let widthConstraint = NSLayoutConstraint.init(item: tableview, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem:textField , attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0.0) as NSLayoutConstraint
        let heightConstraint = NSLayoutConstraint.init(item: tableview, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem:textField , attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 120) as NSLayoutConstraint //height constant : 120
        // print("height :\(heightConstraint.constant)")
        
        self.view.addConstraints([xConstraint,yConstraint,widthConstraint,heightConstraint])
    }
    
    func addPaddingToTextField(txtFld : UITextField){
        txtFld.leftViewMode = .always
        txtFld.contentVerticalAlignment = .center
        txtFld.setLeftPaddingPoints(10)
        txtFld.tintColor = UIColor.clear
    }
    
    @objc func backButtonClick(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func homeButtonClick(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func addNodetailsFoundLabelFooterToTableView(tableView: UITableView,message: String){
        let tableFooterView = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.maxX, height: 60))
        tableFooterView.text = message
        tableFooterView.sizeToFit()
        tableFooterView.font = UIFont.systemFont(ofSize: 15.0)
        tableFooterView.textAlignment = NSTextAlignment.center
        tableView.tableFooterView = tableFooterView
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIView {
    
    // Example use: myView.addBorder(toSide: .Left, withColor: UIColor.redColor().CGColor, andThickness: 1.0)
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat,xValue:CGFloat?,yValue:CGFloat?,height:CGFloat?) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: yValue ?? frame.minY, width: thickness, height: height ?? frame.size.height); break
        case .Right: border.frame = CGRect(x: (frame.origin.x + frame.size.width) - thickness, y: yValue ?? frame.minY, width: thickness, height: height ?? frame.size.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: yValue ?? frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: yValue ?? frame.maxY, width: frame.width, height: thickness); break
        }
        
        layer.addSublayer(border)
    }
}

extension DispatchQueue {
    
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
}

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    func recordScreenView(_ screenClass: String,_ screenName:String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            // [START set_current_screen]
           // Analytics.setScreenName(screenName, screenClass: screenClass)
            Analytics.logEvent(screenClass, parameters: [AnalyticsParameterScreenName: screenName])
            //FIRAnalytics.setUserPropertyString(screenId, forName: Screen_Id_Param)
            //Analytics.setUserProperty(screenName, forName: Screen_Name_Param)
            // [END set_current_screen]
            //self.recordGoogleScreenView(screenName)
        })
    }
    func  registerFirebaseEvents(_ eventName:String,_ mobilNumber: String, _ userId: String,_ screenName: String,parameters:NSDictionary?){
        if parameters != nil{
            self.setFireBaseUserProperty(parameters: parameters)
            Analytics.logEvent(eventName, parameters: parameters as? [String : Any])
        }
        else{
            let userObj = Constatnts.getUserObject()
            if userObj.customerId?.length ?? 0 > 0{
                let defaultParams = [MOBILE_NUMBER:userObj.mobileNumber,USER_ID:userObj.customerId]
                Analytics.setUserProperty(userObj.mobileNumber! as String, forName: MOBILE_NUMBER)
                Analytics.setUserProperty(userObj.customerId! as String, forName: USER_ID)
                Analytics.logEvent(eventName, parameters: defaultParams as [String : Any])
            }
            else if mobilNumber.count > 0{
                let defaultParams = [MOBILE_NUMBER:mobilNumber]
                Analytics.setUserProperty(mobilNumber, forName: MOBILE_NUMBER)
                Analytics.logEvent(eventName, parameters: defaultParams as [String : Any])
            }
            else{
                Analytics.logEvent(eventName, parameters: [:])
            }
        }
        //Analytics.setUserProperty(screenName, forName: Screen_Name_Param)
        //FIRAnalytics.logEvent(withName: eventName, parameters:nil)*/
    }
    func setFireBaseUserProperty(parameters:NSDictionary?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            // [START set_current_screen]
            if parameters != nil{
                for key in parameters!.allKeys{
                    //Analytics.setUserProperty(key as? String, forName: parameters?.value(forKey: key as? String ?? "") as? String ?? "")
                    if let keyStr = key as? String{
                        switch keyStr
                        {
                        case MOBILE_NUMBER:
                            Analytics.setUserProperty(parameters?.value(forKey: key as? String ?? "") as? String ?? "", forName: MOBILE_NUMBER)
                            break
                        case USER_ID:
                            Analytics.setUserProperty(parameters?.value(forKey: key as? String ?? "") as? String ?? "", forName: USER_ID)
                            break
                        case PINCODE:
                            Analytics.setUserProperty(parameters?.value(forKey: key as? String ?? "") as? String ?? "", forName: PINCODE)
                            break
                        case EQUIPMENT_ID:
                            Analytics.setUserProperty(parameters?.value(forKey: key as? String ?? "") as? String ?? "", forName: EQUIPMENT_ID)
                            break
                        case CROP:
                            Analytics.setUserProperty(parameters?.value(forKey: key as? String ?? "") as? String ?? "", forName: CROP)
                            break
                        case SEASON:
                            Analytics.setUserProperty(parameters?.value(forKey: key as? String ?? "") as? String ?? "", forName: SEASON)
                            break
                        case HYBRID:
                            Analytics.setUserProperty(parameters?.value(forKey: key as? String ?? "") as? String ?? "", forName: HYBRID)
                            break
                        case STATE:
                            Analytics.setUserProperty(parameters?.value(forKey: key as? String ?? "") as? String ?? "", forName: STATE)
                            break
                        case PRODUCT_NAME:
                            Analytics.setUserProperty(parameters?.value(forKey: key as? String ?? "") as? String ?? "", forName: PRODUCT_NAME)
                            break
                        case DISEASE_NAME:
                            Analytics.setUserProperty(parameters?.value(forKey: key as? String ?? "") as? String ?? "", forName: DISEASE_NAME)
                            break
                        case DATE:
                            Analytics.setUserProperty(parameters?.value(forKey: key as? String ?? "") as? String ?? "", forName: DATE)
                            break
                        case EQUIPMENT_CLASSIFICATION:
                            Analytics.setUserProperty(parameters?.value(forKey: key as? String ?? "") as? String ?? "", forName: EQUIPMENT_CLASSIFICATION)
                            break
                        case ORDER_ID:
                            Analytics.setUserProperty(parameters?.value(forKey: key as? String ?? "") as? String ?? "", forName: ORDER_ID)
                            break
                        default:
                            break
                        }
                        
                    }
                }
            }
            // [END set_current_screen]
            //self.recordGoogleScreenView(screenName)
        })
    }
}
extension UIViewController{
    func notificationsHandlerNavigation(notificationDic: NSDictionary){
        if let isLogin = UserDefaults.standard.value(forKey: "login") as? Bool{
            if isLogin == true{
                //let appdelegate = UIApplication.shared.delegate as! AppDelegate
                //appdelegate.isNotificationnavigated = false
                if let notification_type = notificationDic[Notification_User_Type] as? NSString{
                    if notification_type as String == Notification_Type_Provider as String  {
                        print(notificationDic)
                        let myOrdersController = self.storyboard?.instantiateViewController(withIdentifier: "MyOrdersSegmentViewController") as? MyOrdersSegmentViewController
                        self.navigationController?.pushViewController(myOrdersController!, animated: true)
                    }
                    else if notification_type as String == Notification_Type_Requester_Home as String{
                        print(notificationDic)
                        let requesterHomeController = self.storyboard?.instantiateViewController(withIdentifier: "RequesterViewController") as? RequesterViewController
                        self.navigationController?.pushViewController(requesterHomeController!, animated: true)
                    }
                    else if notification_type as String == Notification_Type_Provider_Home as String{
                        print(notificationDic)
                        let providerHomeController = self.storyboard?.instantiateViewController(withIdentifier: "EquipmentsViewController") as? EquipmentsViewController
                        self.navigationController?.pushViewController(providerHomeController!, animated: true)
                        
                    }
                    else if notification_type as String == Notification_Type_Requester as String{
                if let notification_Class = notificationDic[Notification_Classification] as? NSString{
                    if notification_Class as String == Notification_Type_Classification as String{
                            print(notificationDic)
                            let requesterOrdersController = self.storyboard?.instantiateViewController(withIdentifier: "PlanterOrdersViewController") as? PlanterOrdersViewController
                            requesterOrdersController?.isFromHome = true
                            self.navigationController?.pushViewController(requesterOrdersController!, animated: true)
                        }
                        else{
                        print(notificationDic)
                        let requesterOrdersController = self.storyboard?.instantiateViewController(withIdentifier: "RequesterOrdersViewController") as? RequesterOrdersViewController
                        self.navigationController?.pushViewController(requesterOrdersController!, animated: true)
                        }
                      }
                    }
                    else if notification_type as String == Notification_Type_Deeplink as String{
                        print(notificationDic)
                        let requesterOrdersController = self.storyboard?.instantiateViewController(withIdentifier: "RequesterOrdersViewController") as? RequesterOrdersViewController
                        self.navigationController?.pushViewController(requesterOrdersController!, animated: true)
                        
                    }
                }
                else if let deepLink_Url_Str = notificationDic[Notification_Deeplink_Key] as? NSString{
                    if let isLogin = UserDefaults.standard.value(forKey: "login") as? Bool{
                        if isLogin == true{
                            let deeplinkUrl = URL(string: deepLink_Url_Str as String)
                            if let deepLinkParams = Singleton.getParametersFromDeeplinkingNotificationUrl(deeplinkUrl!) as NSDictionary?{
                                Singleton.sharedInstance.deepLinkParams = deepLinkParams
                                Singleton.sharedInstance.isFromDeepLink = true
                                self.deeplinkHandlerNavigation(deepLinkParams: deepLinkParams as! [String : AnyObject])
                            }
                            
                        }
                    }
                }else if let deepLink_Url_Str = notificationDic[Deeplink_Key_Notification] as? NSString{
                    if let isLogin = UserDefaults.standard.value(forKey: "login") as? Bool{
                        if isLogin == true{
                            let deeplinkUrl = URL(string: deepLink_Url_Str as String)
                            if let deepLinkParams = Singleton.getParametersFromDeeplinkingNotificationUrl(deeplinkUrl!) as NSDictionary?{
                                Singleton.sharedInstance.deepLinkParams = deepLinkParams
                                Singleton.sharedInstance.isFromDeepLink = true
                                self.deeplinkHandlerNavigation(deepLinkParams: deepLinkParams as! [String : AnyObject])
                            }
                            
                        }
                    }
                }
                
            }
        }
    }
    
    func deeplinkHandlerNavigation(deepLinkParams: [String : AnyObject]){
        if let isLogin = UserDefaults.standard.value(forKey: "login") as? Bool{
            if isLogin == true{
                //let appdelegate = UIApplication.shared.delegate as! AppDelegate
                //appdelegate.isNotificationnavigated = false
                
                if let module_type = deepLinkParams["module"] as? NSString{
                    let params = deepLinkParams as? Dictionary<String, Any>
                    if module_type as String == Crop_Advisori_Registration as String  {
                        print(deepLinkParams)
                        let currentViewController = UIApplication.topViewController()
                        if currentViewController?.isKind(of: CropAdvisoryRegistrationViewController.self) == false{
                            let cropAdvisoryController = self.storyboard?.instantiateViewController(withIdentifier: "CropAdvisoryRegistrationViewController") as? CropAdvisoryRegistrationViewController
                            cropAdvisoryController?.isFromDeeplink = true
                            cropAdvisoryController?.deeplinkParams = deepLinkParams as NSDictionary
                            self.navigationController?.pushViewController(cropAdvisoryController!, animated: true)
                        }
                        else{
                            if let advisoryRegister = currentViewController as? CropAdvisoryRegistrationViewController{
                                advisoryRegister.isFromDeeplink = true
                                advisoryRegister.deeplinkParams = deepLinkParams as NSDictionary
                                advisoryRegister.updateDeepLinkParametersToUI()
                            }
                        }
                    }
                    else if module_type as String == CD_Product_Details as String{
                        print(deepLinkParams)
                        let cdProductDetailsController = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as? ProductDetailsViewController
                        cdProductDetailsController?.isFromDeeplink = true
                        cdProductDetailsController?.deeplinkParams = deepLinkParams as NSDictionary
                        if let diseaseId = deepLinkParams[Product_Id] as? String{
                            cdProductDetailsController?.idFromLibDetailsVC = diseaseId as NSString
                        }
                        self.navigationController?.pushViewController(cdProductDetailsController!, animated: true)
                    }
                    else if module_type as String == Crop_Diagnostic as String{
                        print(deepLinkParams)
                        let cdHomeController = self.storyboard?.instantiateViewController(withIdentifier: "CropDiagnosisViewController") as? CropDiagnosisViewController
                        cdHomeController?.isFromDeeplink = true
                        self.navigationController?.pushViewController(cdHomeController!, animated: true)
                    }
                    else if module_type as String == CD_All_Products as String{
                        print(deepLinkParams)
                        let cdAllProductController = self.storyboard?.instantiateViewController(withIdentifier: "AllProductsViewController") as? AllProductsViewController
                        cdAllProductController?.isFromDeeplink = true
                        cdAllProductController?.deeplinkParams = deepLinkParams as NSDictionary
                        self.navigationController?.pushViewController(cdAllProductController!, animated: true)
                    }
                    else if module_type as String == FAB as String{
                        print(deepLinkParams)
                        let fabController = self.storyboard?.instantiateViewController(withIdentifier: "FABViewController") as? FABViewController
                        fabController?.isFromDeeplink = true
                        fabController?.deeplinkParams = deepLinkParams as NSDictionary
                        self.navigationController?.pushViewController(fabController!, animated: true)
                    }
                    else if module_type as String == Hybrid_Product_Details as String{
                        print(deepLinkParams)
                        Singleton.sharedInstance.isFromDeepLink = false
                        Singleton.sharedInstance.deepLinkParams = nil
                        //let requesterOrdersController = self.storyboard?.instantiateViewController(withIdentifier: "RequesterOrdersViewController") as? RequesterOrdersViewController
                        //self.navigationController?.pushViewController(requesterOrdersController!, animated: true)
                    }
                    else if module_type as String == Disease_Details as String{
                        print(deepLinkParams)
                        //                        let diseaseDetectController = self.storyboard?.instantiateViewController(withIdentifier: "DiseaseDetectedViewController") as? DiseaseDetectedViewController
                        //                        diseaseDetectController?.isFromDeeplink = true
                        //                        diseaseDetectController?.deeplinkParams = deepLinkParams
                        //                        if let diseaseId = deepLinkParams.value(forKey: Disease_Id) as? String{
                        //                            diseaseDetectController?.urlIDStr = diseaseId as NSString
                        //                        }
                        //                        self.navigationController?.pushViewController(diseaseDetectController!, animated: true)
                        let diseaseDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "LibraryDetailsViewController") as! LibraryDetailsViewController
                        if let diseaseId = deepLinkParams[Disease_Id] as? String{
                            diseaseDetailsVC.diseaseId =  diseaseId
                        }
                        diseaseDetailsVC.isFromDeeplink = true
                        diseaseDetailsVC.deeplinkParams = deepLinkParams as NSDictionary
                        diseaseDetailsVC.isFromDiagnosisScreen = true
                        self.navigationController?.pushViewController(diseaseDetailsVC, animated: true)
                    }
                    else if module_type as String == Equipment_View_Details as String{
                        print(deepLinkParams)
                        let equipmentController = self.storyboard?.instantiateViewController(withIdentifier: "ViewEquipmentViewController") as? ViewEquipmentViewController
                        equipmentController?.isFromDeeplink = true
                        equipmentController?.deeplinkParams = deepLinkParams as NSDictionary
                        self.navigationController?.pushViewController(equipmentController!, animated: true)
                    }  else if module_type as String == Notification_s as String{
                        let requesterOrdersController = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsViewController") as? NotificationsViewController
                        requesterOrdersController?.isFromNotification = true
                        self.navigationController?.pushViewController(requesterOrdersController!, animated: true)
                    }  else if module_type as String == WhatsAppOptIn as String{
                        let requesterOrdersController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                        requesterOrdersController?.isFromOptInNotifications = true
                        requesterOrdersController?.isFromNotification = true
                        self.navigationController?.pushViewController(requesterOrdersController!, animated: true)
                    } else if module_type as String == SPRAY_MODULE as String{
                        if let subModule_type = deepLinkParams["subModule"] as? NSString{
                            let taskId = deepLinkParams["taskId"] as? NSString
                            let keys =  deepLinkParams.keys
                        
                            if subModule_type as String == Spray_subModule_uploadBill as String  {
                                let RetailerInformationVC = self.storyboard?.instantiateViewController(withIdentifier: "RetailerInformationViewController") as? RetailerInformationViewController
                                 RetailerInformationVC?.isFromDeeplink = true
                                if let cropId = deepLinkParams["crop"] as? String{
                                    RetailerInformationVC?.cropID =  Int(cropId)
                                                     }
                                
                                self.navigationController?.pushViewController(RetailerInformationVC!, animated: true)
                                //                            let Spray_subModule_uploadBill = "uploadBill"
                                //                            let Spray_subModule_requesterMode = "requesterMode"
                                //                            let Spray_subModule_farmerFeedbackList = "farmerFeedbackList"
                                //                            let Spray_subModule_vendorOrderList = "vendorOrderList"
                            } else if subModule_type as String == Spray_subModule_requesterMode as String{
                                let requesterHomeController = self.storyboard?.instantiateViewController(withIdentifier: "RequesterViewController") as? RequesterViewController
                                 requesterHomeController?.isFromDeeplink = true
                                self.navigationController?.pushViewController(requesterHomeController!, animated: true)
                            }else if subModule_type as String == Spray_subModule_farmerFeedbackList as String &&
                                keys.contains("taskId")  {
                                let requesterHomeController = self.storyboard?.instantiateViewController(withIdentifier: "FarmerFeedbackViewController") as? FarmerFeedbackViewController
                                requesterHomeController?.isFromDeeplink = true
                                requesterHomeController?.taskID = taskId as? String ?? ""
                                self.navigationController?.pushViewController(requesterHomeController!, animated: true)
                            }else if subModule_type as String == Spray_subModule_farmerFeedbackList as String  &&
                            !keys.contains("taskId"){
                                let requesterHomeController = self.storyboard?.instantiateViewController(withIdentifier: "RequesterOrdersListViewController") as? RequesterOrdersListViewController
                                 requesterHomeController?.isFromDeeplink = true
                                self.navigationController?.pushViewController(requesterHomeController!, animated: true)
                            }
                            else if subModule_type as String == Spray_subModule_vendorOrderList as String &&
                             keys.contains(taskId! as String) {
                                let requesterHomeController = self.storyboard?.instantiateViewController(withIdentifier: "SprayFeedbackController") as? SprayFeedbackController
                                requesterHomeController?.isFromDeeplink = true
                                requesterHomeController?.taskID = taskId! as String
                                self.navigationController?.pushViewController(requesterHomeController!, animated: true)
                            }else if subModule_type as String == Spray_subModule_vendorOrderList as String {
                                let requesterHomeController = self.storyboard?.instantiateViewController(withIdentifier: "SprayOrdersViewController") as? SprayOrdersViewController
                                 requesterHomeController?.isFromDeeplink = true
                                self.navigationController?.pushViewController(requesterHomeController!, animated: true)
                                
                            }
                        }
                    }else if module_type as String == Refer_a_Farmer as String{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                        vc?.isFromFarmerReferral = true
                        self.navigationController?.pushViewController(vc!, animated: true)
                    }
                }
            }
        }
    }
}
class Custombutton : UIButton {
    // The badge displayed over the BarButtonItem
    var badge: UILabel?
    var badgeValue: String?
    // Badge background color
    var badgeBGColor: UIColor?
    // Badge text color
    var badgeTextColor: UIColor?
    // Badge font
    var badgeFont: UIFont?
    // Padding value for the badge
    var badgePadding: CGFloat = 0.0
    // Minimum size badge to small
    var badgeMinSize: CGFloat = 0.0
    // Values for offseting the badge over the BarButtonItem you picked
    var badgeOriginX: CGFloat = 0.0
    private  var badgeOriginY: CGFloat = 0.0
    // In case of numbers, remove the badge when reaching zero
    private  var shouldHideBadgeAtZero = false
    // Badge has a bounce animation when value changes
    var shouldAnimateBadge = false
    // MARK: - Init methods
    convenience init?(customUIButton customButton: UIButton?) {
        self.init(customUIButton: customButton)
        initializer()
    }
    
    func initializer() {
        // Default design initialization
        badgeBGColor = UIColor.red
        badgeTextColor = UIColor.white
        badgeFont = UIFont.systemFont(ofSize:3.0)
        badgePadding = 10
        badgeMinSize = 10
        badgeOriginX = 15
        badgeOriginY = 5
        shouldHideBadgeAtZero = true
        shouldAnimateBadge = true
        // Avoids badge to be clipped when animating its scale
        self.clipsToBounds = false
    }
    
    // MARK: - Utility methods
    
    // Handle badge display when its properties have been changed (color, font, ...)
    func refreshBadge() {
        // Change new attributes
        badge?.textColor = badgeTextColor
        badge?.backgroundColor = badgeBGColor
        badge?.font = badgeFont
    }
    
    func updateBadgeFrame() {
        // When the value changes the badge could need to get bigger
        // Calculate expected size to fit new value
        // Use an intermediate label to get expected size thanks to sizeToFit
        // We don't call sizeToFit on the true label to avoid bad display
        let frameLabel = duplicate(badge)
        frameLabel?.sizeToFit()
        
        let expectedLabelSize = frameLabel?.frame.size
        
        // Make sure that for small value, the badge will be big enough
        var minHeight = expectedLabelSize?.height ?? 0.0
        
        // Using a const we make sure the badge respect the minimum size
        minHeight = (minHeight < badgeMinSize) ? badgeMinSize : expectedLabelSize?.height ?? 0.0
        var minWidth = expectedLabelSize?.width ?? 0.0
        let padding = badgePadding
        
        // Using const we make sure the badge doesn't get too smal
        minWidth = (minWidth < minHeight) ? minHeight : expectedLabelSize?.width ?? 0.0
        badge?.frame = CGRect(x: badgeOriginX, y: badgeOriginY, width: minWidth + padding, height: minHeight + padding)
        badge?.layer.cornerRadius = (minHeight + padding) / 2
        badge?.layer.masksToBounds = true
    }
    
    func updateBadgeValue(animated: Bool) {
        // Bounce animation on badge if value changed and if animation authorized
        if animated && shouldAnimateBadge && !(badge?.text == badgeValue) {
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.fromValue = NSNumber(value: 1.5)
            animation.toValue = NSNumber(value: 1)
            animation.duration = 0.2
            animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, _: 1.3, _: 1, _: 1)
            badge?.layer.add(animation, forKey: "bounceAnimation")
        }
        
        //            // Set the new value
        //            badge?.text = badgeValue
        
        // Animate the size modification if needed
        //NSTimeInterval duration = animated ? 0.2 : 0;
        //[UIView animateWithDuration:duration animations:^{
        updateBadgeFrame()
        //}]; // this animation breaks the rounded corners in iOS 9
    }
    
    func duplicate(_ labelToCopy: UILabel?) -> UILabel? {
        let duplicateLabel = UILabel(frame: labelToCopy?.frame ?? CGRect.zero)
        duplicateLabel.text = labelToCopy?.text
        duplicateLabel.font = labelToCopy?.font
        
        return duplicateLabel
    }
    func setBadgeValue(badgeValue : String)
    {
        // Set new value
        let _badgeValue = badgeValue
        
        // When changing the badge value check if we need to remove the badge
        //        if ((badgeValue == "") || (badgeValue == "0") && (self.shouldHideBadgeAtZero)) {
        //            self.removeBadge()
        //        } else
        
        if (!(self.badge != nil)) {
            // Create a new badge because not existing
            self.badge   = UILabel(frame: CGRect(x: 20, y: 20, width: 20, height: 20))
            self.badge?.textColor            = self.badgeTextColor;
            self.badge?.backgroundColor      = self.badgeBGColor;
            self.badge?.font                 = self.badgeFont;
            self.badge?.textAlignment        = .center
            
            self.addSubview(self.badge!)
            self.updateBadgeValue(animated:false)
        } else {
            self.updateBadgeValue(animated: true)
        }
    }
    
    func removeBadge() {
        // Animate badge removal
        UIView.animate(withDuration: 0.2, animations: {
            self.badge?.transform = CGAffineTransform(scaleX: 0, y: 0)
        }) { finished in
            self.badge?.removeFromSuperview()
            self.badge = nil
        }
    }
    
    func setBadgeBGColor(badgeBGColor : UIColor) {
        
        let _badgeBGColor = badgeBGColor
        
        if ((self.badge) != nil) {
            self.refreshBadge()
        }
    }
    
    func setBadgeTextColor(badgeTextColor : UIColor)
    {
        let _badgeTextColor = badgeTextColor;
        
        if ((self.badge) != nil) {
            self.refreshBadge()
        }
    }
    
    func setBadgeTextColor(badgeFont : UIFont)
    {
        let _badgeFont = badgeFont;
        
        if ((self.badge) != nil) {
            self.refreshBadge()
        }
    }
    
    func setBadgePadding(badgePadding : CGFloat)
    {
        let _badgePadding = badgePadding;
        
        if ((self.badge) != nil) {
            self.updateBadgeFrame()
        }
    }
    
    func setBadgeMinSize(badgeMinSize : CGFloat)
    {
        let _badgeMinSize = badgeMinSize;
        
        if ((self.badge) != nil) {
            self.updateBadgeFrame()
        }
    }
    
    func setBadgeOriginX(badgeOriginX : CGFloat)
    {
        let _badgeOriginX = badgeOriginX;
        
        if ((self.badge) != nil) {
            self.updateBadgeFrame()
        }
    }
    
    func setBadgeOriginY(badgeOriginY : CGFloat)
    {
        let _badgeOriginY = badgeOriginY;
        
        if ((self.badge) != nil) {
            self.updateBadgeFrame()
        }
    }
    
}

public extension UIDevice {
    
    /// pares the deveice name as the standard name
    var modelName: String {
        
        #if targetEnvironment(simulator)
        let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
        #else
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        #endif
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPhone12,1":                              return "iPhone 11"
        case "iPhone12,3":                              return "iPhone 11 Pro"
        case "iPhone12,5":                              return "iPhone 11 Pro Max"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad7,5", "iPad7,6":                      return "iPad 6"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        default:                                        return identifier
        }
    }
    
}


