//
//  NearByViewController.swift
//  PioneerEmployee
//
//  Created by Empover-i-Tech on 16/03/20.
//  Copyright © 2020 Empover. All rights reserved.
//

import UIKit
import WebKit
import Alamofire


class NearByViewController: BaseViewController,WKNavigationDelegate {
    
    var isFromHome :Bool = false
    @IBOutlet weak var webView : WKWebView!
    @IBOutlet weak var viewPopUp : UIView!
    @IBOutlet weak var viewSubPopUP : UIView!
    @IBOutlet weak var cvModules : UICollectionView!
    @IBOutlet weak var btnFarmer : UIButton!
    @IBOutlet weak var btnAll : UIButton!
    @IBOutlet weak var btnRetailer : UIButton!
    @IBOutlet weak var filterSubHeight : NSLayoutConstraint!
    @IBOutlet weak var bottomButtonsHeight : NSLayoutConstraint!
    @IBOutlet weak var ActivitiesStackview : UIStackView!

    @IBOutlet weak var btnPDA : UIButton!
    @IBOutlet weak var btnPSA : UIButton!
    @IBOutlet weak var btnOSA : UIButton!
    @IBOutlet weak var btnAgrinomy : UIButton!
    @IBOutlet weak var distanceLbl : UILabel!
    @IBOutlet weak var radiusSlider: UISlider!
    
    var filterButton :  UIButton?
    var menuButton :  UIButton?
    var currentLatitude  : String = ""
    var currentLongitude  : String = ""
    var allString : String = "ALL"
    var pdaString = "null"
    var psaString = "null"
    var osaString = "null"
    var agroString = "null"
    var farmerString = "null"
    var retailerString = "null"
    var bigFarmerStr = "null"
    var Pravaktastr = "null"
    var Activitiesstr = "null"
    var distanceStr = "null"
    var modulesArray = [moduleModel]()
    var activitiesSelected = false
    let moduleNamesArray = ["Big Farmers","Pravakta","Activities"]
    var userMobile = ""
    var userCustomerId = ""
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.navigationDelegate = self
      
        btnAll.setImage(UIImage(named: "radio")?.withRenderingMode(.alwaysTemplate), for: .normal)
 
        if var currentLocation = LocationService.sharedInstance.currentLocation as CLLocation?{
            if let coordinates = currentLocation.coordinate as CLLocationCoordinate2D?{
                
          
                let getLat:String = String(coordinates.latitude)
                let getLong:String = String(coordinates.longitude)
                currentLatitude = getLat //"\(coordinates.latitude)"
                currentLongitude = getLong // \(coordinates.longitude)"
            }
        }
        let userObj = Constatnts.getUserObject()
        userMobile = userObj.mobileNumber as? String ?? ""
        userCustomerId = userObj.customerId as? String ?? ""
        ActivitiesStackview.isHidden = true
        distanceLbl.text  = "5"
        distanceStr = distanceLbl.text ?? "null"
        self.resetAllStrings()
        

        let urlString = String(format: "%@%@mobileNumber=%@&latitude=%@&longitude=%@&distance=5&actByFar=null&actByRet=null&actBigFarmer=null&actPravakta=null&actActivities=null&actALL=ALL&actPDA=null&actPSA=null&actOSA=null&actAGRO=null&userType=FARMER", arguments: [BASE_URL_NEARBY,NEAR_BY,userMobile,currentLatitude,currentLongitude])
        
        
        
        print(urlString)
                
        self.loadRequest(urlString: urlString)
        for (i,_) in self.moduleNamesArray.enumerated() {
            let model = moduleModel()
            if i == 0 {
                model.isSelected = false
            }else {
                model.isSelected = false
            }
            model.titleName = self.moduleNamesArray[i]
            self.modulesArray.append(model)
        }
       
        if userObj.userLogsAllPrint == "true"{
        saveUserLogEventsDetailsToServer()
        }
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
            "logTimeStamp": todaysDate,
            "pincode": userObj.pincode,
            "districtLoggedin":userObj.districtName,
            "stateLoggedin":userObj.stateName,
            "stateName": userObj.stateName,
           
            "eventName": Home_NearBy,
            "className":"NearByViewController",
            "moduleName":"NearBy",
            
            "healthCardId":"",
            "productId":"",
            "cropId":"",
            "seasonId":"",
            "marketName":"",
            "commodity":"",
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
    
    @IBAction func radiusSlider_Value_Changed(_ sender: Any) {
        let step : Float = 0.5
        let roundedValue = round(Float(radiusSlider.value) / step) * step
        radiusSlider.value = roundedValue
        self.distanceLbl.text = String(format:"%.0f",radiusSlider.value)
        distanceStr = distanceLbl.text ?? "null"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.setStatusBarBackgroundColor(color :App_Theme_Green_Color)
        self.topView?.backgroundColor = App_Theme_Green_Color
        self.topView?.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    
        let userObj = Constatnts.getUserObject()
          userMobile = userObj.mobileNumber as? String ?? ""
          userCustomerId = userObj.customerId as? String ?? ""
            
        self.topView?.isHidden = false
        lblTitle?.text = "Near By"
        if isFromHome == true {
            self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        }
        else{
            self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
        }
        
        self.filterButton = UIButton(type: .custom)
        self.filterButton?.frame = CGRect(x: (topView?.frame.size.width)! - 75, y: 10, width: 30, height: 30)
        self.setStatusBarBackgroundColor(color :App_Theme_Green_Color)
        self.topView?.backgroundColor = App_Theme_Green_Color
        self.filterButton?.setImage(UIImage(named: "Filter"), for: .normal)
        self.filterButton?.addTarget(self, action: #selector(NearByViewController.filterButtonClick(_:)), for: .touchUpInside)
        self.setStatusBarBackgroundColor(color :App_Theme_Blue_Color)
        self.topView?.backgroundColor = App_Theme_Blue_Color
        topView?.addSubview(filterButton!)
        
        self.menuButton = UIButton(type: .custom)
        self.menuButton?.frame = CGRect(x: (topView?.frame.size.width)! - 35, y: 10, width: 30, height: 30)
        self.menuButton?.setImage(UIImage(named: "Menu"), for: .normal)
        self.menuButton?.addTarget(self, action: #selector(NearByViewController.menuButtonClick(_:)), for: .touchUpInside)

        topView?.addSubview(menuButton!)
        
    }
    override func viewDidLayoutSubviews() {
        
    }
    override func backButtonClick(_ sender: UIButton) {
        let alert = UIAlertController(title: "Alert!", message: "Are you sure you want to exit?", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "NO", style: .cancel, handler: nil)
        let alertAction1 = UIAlertAction(title: "YES", style: .default) { (alertA) in
            if self.isFromHome == true {
                self.navigationController?.popViewController(animated: true)
            }
            else{
                self.findHamburguerViewController()?.showMenuViewController()
            }
        }
        alert.addAction(alertAction)
        alert.addAction(alertAction1)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func loadRequest(urlString : String) {
        SwiftLoader.show(animated: true)
        let url =  NSURL(string: urlString as String)
        let req = URLRequest(url: url! as URL)
        SwiftLoader.hide()
        webView.load(req)
    }
    
    @IBAction func filterButtonClick(_ sender : UIButton) {
        DispatchQueue.main.async {
            if self.viewPopUp != nil{
                self.viewPopUp.frame = UIScreen.main.bounds
                let appdelegate = UIApplication.shared.delegate as? AppDelegate
                appdelegate?.window?.addSubview(self.viewPopUp)
                self.cvModules.reloadData()
            }
        }
    }
    @IBAction func menuButtonClick(_ sender : UIButton) {
        let nearBylistController = self.storyboard?.instantiateViewController(withIdentifier: "NearByListViewController") as? NearByListViewController
        
      
        let dic : NSMutableDictionary = [ "actAGRO": agroString,
                                          "actALL": allString,
                                          "actActivities": Activitiesstr,
                                          "actBigFarmer": bigFarmerStr,
                                          "actByFar": farmerString,
                                          "actByRet": retailerString,
                                          "actOSA": osaString,
                                          "actPDA": pdaString,
                                          "actPSA": psaString,
                                          "actPravakta": Pravaktastr,
                                          "distance": distanceStr,
                                          "latitude":  currentLatitude,
                                          "longitude": currentLongitude,
                                          "minRecord": 0,
                                          "mobileNumber": userMobile ,
                                          "modelType": "nearBy",
                                          "userType": "FARMER"] as NSMutableDictionary
        //paramsDic
        nearBylistController?.paramsDic = dic
        self.navigationController?.pushViewController(nearBylistController!, animated: true)
    }
    
    @IBAction func closeClick(_ sender : UIButton) {
        self.viewPopUp.removeFromSuperview()
    }
    
    @IBAction func btnRetailerAction(_ sender : UIButton) {
        switch sender.currentImage?.withRenderingMode(.alwaysTemplate) {
        case UIImage(named: "CheckboxEmpty")?.withRenderingMode(.alwaysTemplate):
            self.retailerString = "Retailer"
            self.allString = "null"
            self.btnAll.setImage(UIImage(named: "radioEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
            DispatchQueue.main.async {
                self.btnRetailer.setImage(UIImage(named: "radioFilledNear")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }
        case UIImage(named: "radioFilledNear")?.withRenderingMode(.alwaysTemplate):
            self.retailerString = "null"
            DispatchQueue.main.async {
                self.btnRetailer.setImage(UIImage(named: "CheckboxEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }
        default:
            print("kjkk")
        }
    }
    
    
    @IBAction func btnFarmerAction(_ sender : UIButton) {
        self.activitiesSelected = !self.activitiesSelected
        switch sender.currentImage?.withRenderingMode(.alwaysTemplate) {
        case UIImage(named: "CheckboxEmpty")?.withRenderingMode(.alwaysTemplate):
            self.Activitiesstr = "ACTIVITIES"
            self.allString = "null"
            self.btnAll.setImage(UIImage(named: "radioEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
            DispatchQueue.main.async {
                 
                self.btnFarmer.setImage(UIImage(named: "radioFilledNear")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }
        case UIImage(named: "radioFilledNear")?.withRenderingMode(.alwaysTemplate):
            self.Activitiesstr = "null"
            DispatchQueue.main.async {
                
                self.btnFarmer.setImage(UIImage(named: "CheckboxEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }
        default:
            print("kjkk")
        }
        
        if  self.activitiesSelected == true{
                       filterSubHeight.constant = 200.0
                       ActivitiesStackview.isHidden = false
                       Activitiesstr = "ACTIVITIES"
                       
                   }else{
                       filterSubHeight.constant = 180.0
                       //  bottomButtonsHeight.constant = 0.0
                       ActivitiesStackview.isHidden = true
                       self.psaString = "null"
                       self.osaString = "null"
                       self.agroString = "null"
                       self.pdaString = "null"
                       btnPSA.setImage(UIImage(named: "CheckboxEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
                       btnOSA.setImage(UIImage(named: "CheckboxEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
                       btnPDA.setImage(UIImage(named: "CheckboxEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
                       btnAgrinomy.setImage(UIImage(named: "CheckboxEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
                   }
    }
    
    
    
    @IBAction func btnPDAAction(_ sender : UIButton) {
        switch sender.currentImage?.withRenderingMode(.alwaysTemplate) {
        case UIImage(named: "CheckboxEmpty")?.withRenderingMode(.alwaysTemplate):
            self.pdaString = "PDA"
            DispatchQueue.main.async {
                self.btnAll.setImage(UIImage(named: "radioEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
                self.allString = "null"
                self.btnPDA.setImage(UIImage(named: "radioFilledNear")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }
        case UIImage(named: "radioFilledNear")?.withRenderingMode(.alwaysTemplate):
            self.psaString = "null"
            DispatchQueue.main.async {
                self.btnPDA.setImage(UIImage(named: "CheckboxEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }
        default:
            print("kjkk")
        }
    }
    
    
    @IBAction func btnPSAAction(_ sender : UIButton) {
        switch sender.currentImage?.withRenderingMode(.alwaysTemplate) {
        case UIImage(named: "CheckboxEmpty")?.withRenderingMode(.alwaysTemplate):
            self.psaString = "PSA"
            DispatchQueue.main.async {
                self.btnAll.setImage(UIImage(named: "radioEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
                self.allString = "null"
                self.btnPSA.setImage(UIImage(named: "radioFilledNear")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }
        case UIImage(named: "radioFilledNear")?.withRenderingMode(.alwaysTemplate):
            self.psaString = "null"
            DispatchQueue.main.async {
                self.btnPSA.setImage(UIImage(named: "CheckboxEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }
        default:
            print("kjkk")
        }
    }
    
    @IBAction func btnOSAAction(_ sender : UIButton) {
        switch sender.currentImage?.withRenderingMode(.alwaysTemplate) {
        case UIImage(named: "CheckboxEmpty")?.withRenderingMode(.alwaysTemplate):
            self.osaString = "OSA"
            DispatchQueue.main.async {
                self.btnAll.setImage(UIImage(named: "radioEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
                self.allString = "null"
                self.btnOSA.setImage(UIImage(named: "radioFilledNear")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }
        case UIImage(named: "radioFilledNear")?.withRenderingMode(.alwaysTemplate):
            self.osaString = "null"
            DispatchQueue.main.async {
                self.btnOSA.setImage(UIImage(named: "CheckboxEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }
        default:
            print("kjkk")
        }
    }
    
    
    @IBAction func btnagirmnomyction(_ sender : UIButton) {
        switch sender.currentImage?.withRenderingMode(.alwaysTemplate) {
        case UIImage(named: "CheckboxEmpty")?.withRenderingMode(.alwaysTemplate):
            self.agroString = "AGRONOMY"
            DispatchQueue.main.async {
                self.btnAll.setImage(UIImage(named: "radioEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
                self.allString = "null"
                self.btnAgrinomy.setImage(UIImage(named: "radioFilledNear")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }
        case UIImage(named: "radioFilledNear")?.withRenderingMode(.alwaysTemplate):
            self.agroString = "null"
            DispatchQueue.main.async {
                self.btnAgrinomy.setImage(UIImage(named: "CheckboxEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }
        default:
            print("kjkk")
        }
    }
    
    @IBAction func btnAllction(_ sender : UIButton) {
        self.resetAllStrings()
        for (i,x) in  self.modulesArray.enumerated(){
            self.modulesArray[i].isSelected = false
            self.cvModules.reloadData()
        }
        //  bottomButtonsHeight.constant = 0.0
        ActivitiesStackview.isHidden = true
        self.activitiesSelected = false
        switch sender.currentImage?.withRenderingMode(.alwaysTemplate) {
        case UIImage(named: "radioEmpty")?.withRenderingMode(.alwaysTemplate):
            self.allString = "ALL"
            
            DispatchQueue.main.async {
                self.btnAll.setImage(UIImage(named: "radio")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }
        case UIImage(named: "radio")?.withRenderingMode(.alwaysTemplate):
            self.allString = "null"
            DispatchQueue.main.async {
                self.btnAll.setImage(UIImage(named: "radioEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }
        default:
            print("kjkk")
        }
    }
    
    @IBAction func ListNavigation(_ sender : UIButton) {
        let nearBylistController = self.storyboard?.instantiateViewController(withIdentifier: "NearByListViewController") as? NearByListViewController
        
      
        let dic : NSMutableDictionary = [ "actAGRO": agroString,
                                          "actALL": allString,
                                          "actActivities": Activitiesstr,
                                          "actBigFarmer": bigFarmerStr,
                                          "actByFar": farmerString,
                                          "actByRet": retailerString,
                                          "actOSA": osaString,
                                          "actPDA": pdaString,
                                          "actPSA": psaString,
                                          "actPravakta": Pravaktastr,
                                          "distance": distanceStr,
                                          "latitude":  currentLatitude,
                                          "longitude": currentLongitude,
                                          "minRecord": 0,
                                          "mobileNumber": userMobile ,
                                          "modelType": "nearBy",
                                          "userType": "FARMER"] as NSMutableDictionary
        //paramsDic
        nearBylistController?.paramsDic = dic
        self.navigationController?.pushViewController(nearBylistController!, animated: true)
    }
    
    func resetAllStrings(){
        self.pdaString = "null"
        self.bigFarmerStr = "null"
        self.Pravaktastr = "null"
        self.psaString = "null"
        self.osaString = "null"
        self.agroString = "null"
        self.pdaString = "null"
        self.retailerString = "null"
        self.Activitiesstr = "null"
        self.farmerString = "null"
        self.allString = "ALL"
        self.distanceStr = "null"
        filterSubHeight.constant = 195.0
        activitiesSelected = false

        self.btnFarmer.setImage(UIImage(named: "CheckboxEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.btnRetailer.setImage(UIImage(named: "CheckboxEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnPSA.setImage(UIImage(named: "CheckboxEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnOSA.setImage(UIImage(named: "CheckboxEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnPDA.setImage(UIImage(named: "CheckboxEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnAgrinomy.setImage(UIImage(named: "CheckboxEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
      
    }
    
    @IBAction func btnResetAction(_ sender : UIButton) {
        self.resetAllStrings()
        //  bottomButtonsHeight.constant = 0.0
        ActivitiesStackview.isHidden = true
        self.btnAll.setImage(UIImage(named: "radio")?.withRenderingMode(.alwaysTemplate), for: .normal)
        distanceLbl.text  = "5"
        distanceStr = distanceLbl.text ?? "null"
        radiusSlider.value = 5
        for (i,x) in  self.modulesArray.enumerated(){
            self.modulesArray[i].isSelected = false
            self.cvModules.reloadData()
        }
    }
    
    @IBAction func btnLoadAction(_ sender : UIButton) {
        var designationName : String = ""
        var mobile : String = ""
        var userID : String = ""
        
        
        for (i,x) in self.modulesArray.enumerated(){
                       
                       if self.modulesArray[i].isSelected == true && self.modulesArray[i].titleName == "Big Farmers" {
                           self.bigFarmerStr = "BigFarmer"
                           self.allString = "null"
                       }
                       if self.modulesArray[i].isSelected == true && self.modulesArray[i].titleName == "Pravakta" {
                           self.Pravaktastr = self.modulesArray[i].titleName
                           self.allString = "null"
                       }
                       if self.modulesArray[i].isSelected == true && self.modulesArray[i].titleName == "Activities" {
                           self.Activitiesstr = "ACTIVITIES"
                       }
                       if pdaString == "PDA" ||  psaString == "PSA"  || osaString == "OSA" || agroString == "AGRONOMY" {
                           self.allString = "null"
                           self.allString = "null"
                       }
            
        }
        let firebaseParams = ["Mobile_Number": userMobile,"User_Id":userCustomerId,"screen_name":"NearByViewController"] as [String : Any]
        self.registerFirebaseEvents("Near_by", "", "", "", parameters: firebaseParams as NSDictionary)
        
        if self.farmerString == "null" && self.retailerString == "null" &&  self.allString == "null" && self.bigFarmerStr == "null" && self.Pravaktastr == "null" &&
          self.Activitiesstr == "null"  {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.makeToast("Please select any one option")
        }
            
        else  if self.Activitiesstr != "null"  &&  self.osaString == "null" &&
            self.agroString == "null" && self.pdaString == "null" &&  self.psaString == "null"
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.makeToast("Please select any one activity")
        }
        else {
            for (i,x) in self.modulesArray.enumerated(){
                
                if self.modulesArray[i].isSelected == true && self.modulesArray[i].titleName == "Big Farmers" {
                    self.bigFarmerStr = "BigFarmer"
                    self.allString = "null"
                }
                if self.modulesArray[i].isSelected == true && self.modulesArray[i].titleName == "Pravakta" {
                    self.Pravaktastr = self.modulesArray[i].titleName
                    self.allString = "null"
                }
                if self.modulesArray[i].isSelected == true && self.modulesArray[i].titleName == "Activities" {
                    self.Activitiesstr = "ACTIVITIES"
                }
                if pdaString == "PDA" ||  psaString == "PSA"  || osaString == "OSA" || agroString == "AGRONOMY" {
                    self.allString = "null"
                    self.allString = "null"
                }
            }
            self.viewPopUp.removeFromSuperview()
          
            
            let urlString = String(format: "%@%@mobileNumber=%@&latitude=%@&longitude=%@&distance=%@&actByFar=%@&actByRet=%@&actBigFarmer=%@&actPravakta=%@&actActivities=%@&actALL=%@&actPDA=%@&actPSA=%@&actOSA=%@&actAGRO=%@&userType=FARMER", arguments: [BASE_URL_NEARBY,NEAR_BY,userMobile,currentLatitude,currentLongitude,(distanceStr),farmerString,retailerString,bigFarmerStr,Pravaktastr,Activitiesstr,allString,pdaString,psaString,osaString,agroString])
            self.loadRequest(urlString: urlString)
        }
    }
        
  
}

extension NearByViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.modulesArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.cvModules.dequeueReusableCell(withReuseIdentifier: "moduleCell", for: indexPath) as? ModuleNameCell
        cell?.btnModuleName.setTitle(self.modulesArray[indexPath.row].titleName ,for : .normal)
        cell?.btnModuleName.isUserInteractionEnabled = false
        cell?.btnModuleName.titleLabel?.textColor = UIColor.darkGray
        if   self.modulesArray[indexPath.row].isSelected == true {
            cell?.btnModuleName.setImage(UIImage(named: "radioFilledNear")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }else {
            cell?.btnModuleName.setImage(UIImage(named: "CheckboxEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
            
        }
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let numberofItem: CGFloat = 3
        let collectionViewWidth = self.cvModules.bounds.width
        let extraSpace = (numberofItem - 1) * flowLayout.minimumInteritemSpacing
        let inset = flowLayout.sectionInset.right + flowLayout.sectionInset.left
        let width = Int((collectionViewWidth - extraSpace - inset) / numberofItem)
        print(width)
        return CGSize(width: width, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //        return UIEdgeInsetsMake(15, 10, 10, 10)//top,left,bottom,right
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0//10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.btnAll.setImage(UIImage(named: "radioEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.allString = "ALL"
        if indexPath.row == 2{
            
            // self.modulesArray[0].isSelected = false
            self.modulesArray[indexPath.row].isSelected = !self.modulesArray[indexPath.row].isSelected
            self.activitiesSelected = !self.activitiesSelected
            //PHI
            self.cvModules.reloadData()
            
            if  self.activitiesSelected == true{
                filterSubHeight.constant = 220.0
                // bottomButtonsHeight.constant = 15.0
                ActivitiesStackview.isHidden = false
                Activitiesstr = "ACTIVITIES"
                
            }else{
                filterSubHeight.constant = 195.0
                //  bottomButtonsHeight.constant = 0.0
                ActivitiesStackview.isHidden = true
                self.psaString = "null"
                self.osaString = "null"
                self.agroString = "null"
                self.pdaString = "null"
                btnPSA.setImage(UIImage(named: "CheckboxEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
                btnOSA.setImage(UIImage(named: "CheckboxEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
                btnPDA.setImage(UIImage(named: "CheckboxEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
                btnAgrinomy.setImage(UIImage(named: "CheckboxEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }
            self.cvModules.reloadData()
        }else{
            // self.modulesArray[0].isSelected = false
            self.modulesArray[indexPath.row].isSelected = !self.modulesArray[indexPath.row].isSelected
            self.cvModules.reloadData()
        }
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SwiftLoader.show(animated: true)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       /* let contentSize:CGSize = webView.scrollView.contentSize
        let viewSize:CGSize = self.view.bounds.size

        let rw:Float = Float(viewSize.width / contentSize.width)

        webView.scrollView.minimumZoomScale = CGFloat(rw)
        webView.scrollView.maximumZoomScale = CGFloat(rw)
        webView.scrollView.zoomScale = CGFloat(rw)*/
        SwiftLoader.hide()
    }
    
}
