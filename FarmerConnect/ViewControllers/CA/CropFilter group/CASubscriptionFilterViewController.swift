//
//  CASubscriptionFilterViewController.swift
//  FarmerConnect
//
//  Created by Apple on 14/11/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SwiftyGif
import SDWebImage

open class SubscriptionCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var lblTitle: UILabel!
}



open class CASubscriptionFilterViewController: BaseViewController {
    @IBOutlet weak var cropAnalysisCollView: UICollectionView!
    @IBOutlet weak var subscriptionBgView: UIView!
    @IBOutlet weak var imgFarmer: UIImageView!
    var cropsArray = NSMutableArray()
    var cropsImagesArray = NSArray()
    var alertView_Bg: UIView = UIView()
    var alertController = UIAlertController()
    var cistomView = SubscriptionCreatePop()
    
    //SUBSCRIPTION RELATED OUTLETS
    var crop_dropDownTable : UITableView!
    var hybrid_dropDownTable : UITableView!
    var categoryDropDownTblView : UITableView!
    //    var stateDropDownTblView = UITableView()
    var seasonTblView = UITableView()
    
    var selectedTextField = UITextField()
    var dobView = UIView()
    
    var seasonStartDateStr: String?
    var seasonEndDateStr: String?
    var hybridArray = NSArray()
    
    var categoryID = NSString()
    var stateID = NSString()
    var cropID = NSString()
    var hybridID = NSString()
    var seasonID = NSString()
    var cropTypeId = NSString()
    
    var categoryNamesArray = NSMutableArray()
    var stateNamesArray = NSMutableArray()
    var cropNamesArray = NSMutableArray()
    var hybridNameArray = NSMutableArray()
    var seasonNamesArray = NSMutableArray()
    
    var categoryArray = NSArray()
    var stateArray = NSArray()
    var cropArray = NSArray()
    var seasonArray = NSArray()
    var FinalArray = NSMutableArray()
    var currentIndex = 0
    var subscriptionArray = NSMutableArray()
    @IBOutlet weak var subscriptionCollection: UICollectionView!
    @IBOutlet weak var selectCropYconstarint: NSLayoutConstraint!
    @IBOutlet weak var subscribedViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cropsCollectionViewHgtConstraint: NSLayoutConstraint!
    @IBOutlet weak var subscribeNowButton: UIButton!
    @IBOutlet weak var lblSelectUrCrop: UILabel!
    @IBOutlet weak var lbl_noCropsHint: UILabel!
    
    var selectedSubscription = NSMutableArray()
    var userObj1 : NSMutableDictionary!
    
    var isFromSideMenu = false
    
    var isCropsSubscriptionAvailable : Bool = false
    
    func updateDeepLinkParametersToUI(){
        
    }
    
    var headers : HTTPHeaders! = nil
    //MARK:- VIEW DID LOAD
    
    
    
    override open func loadView() {
        super.loadView()
        //        CoreDataManager.shared.createPerson(id: "1", name:    "Doe")
        //        CoreDataManager.shared.createPerson(id: "2", name:    "John")
        //         CoreDataManager.shared.createPerson(id: "3", name:    "Sam")
        //         CoreDataManager.shared.createPerson(id: "4", name:    "XYZ")
        
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("viewdidload frmaework")
        // Do any additional setup after loading the view.
        cropAnalysisCollView.dataSource = self
        cropAnalysisCollView.delegate = self
        
        do {
            //            let gif = try UIImage(gifName: "Subscribe-animation.gif")
            //              imgFarmer.image = gif
            let gif = try UIImage(gifName: "Subscribe-animation.gif")
            self.imgFarmer.setGifImage(gif, loopCount: -1)
            
        } catch {
            print(error)
        }
        //        CoreDataManager.shared.fetch()
        forceOrientationPortrait()
        
        // Do any additional setup after loading the view.
        
        // subscribedViewHeightConstraint.constant = 0.0
        
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            //            logEventsAPICall()
            geteSubScriptionList()
            //            getCropListMaster()
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
        
        
        headers  = ["deviceToken": userObj1?.value(forKey: "deviceToken") as? String ?? "",
                    "userAuthorizationToken": userObj1?.value(forKey: "userAuthorizationToken")  as? String ?? "",
                    "mobileNumber": userObj1?.value(forKey: "mobileNumber")  as? String ?? "",
                    "customerId": userObj1?.value(forKey: "customerId")  as? String ?? "",
                    "deviceId": userObj1?.value(forKey: "deviceId")  as? String ?? ""]
        
        print("viewdidload headers: \(headers)")
        print(getCurrentDateAndTime())
        //            {
        //                 "_id": 5,
        //                 "capturedtime": "2020-03-17 10:40:43.922",
        //                 "currentLocation": "0.0,0.0",
        //                 "eventName": "Crop_Selection_Load",
        //                 "id": 0,
        //                 "moduleType": "CropAdvisory",
        //                 "propertiesJsonData": "{\"Mobile_Number\":\"9533072123\",\"screen_name\":\"Crop_Selection\",\"User_Id\":\"330431\"}"
        //               }
        
        
        
        self.recordScreenView("CASubscriptionFilterViewController", "CASubscriptionFilterViewController")
        
        
        let params  = ["capturedtime" : getCurrentDateAndTime() , "currentLocation" :  userObj1?.value(forKey: "geoLocation")  as? String ?? "" ,"eventName" :  "Crop_Selection_Load" , "moduleType" : "CropAdvisory","deviceType" : "iOS" , "Mobile_Number" : userObj1?.value(forKey: "mobileNumber")  as? String ?? "" ,"screen_name" :  "CASubscriptionFilterViewController" , "User_Id" :  userObj1?.value(forKey: "customerId")  as? String ?? ""]
        
        self.registerFirebaseEvents("Crop_Selection_Load", "", "", "CASubscriptionFilterViewController", parameters: params as NSDictionary)
        
        //            CoreDataManager.shared.addLogEvent(UserID: userObj1?.value(forKey: "customerId")  as? String ?? "", mobileNumber: userObj1?.value(forKey: "mobileNumber")  as? String ?? "", screenName: "CASubscriptionFilterViewController", eventName: "Crop_Selection_Load", eventType: "PageLoad",captureTime:getCurrentDateAndTime() , currentLocation: "0.0,0.0", moduleType: "CropAdvisory")
        let userObj = Constatnts.getUserObject()
        if userObj.userLogsAllPrint == "true"{
        self.saveUserLogEventsDetailsToServer()
        }
    }
    
    func saveUserLogEventsDetailsToServer(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMddHHmmss"
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
            "eventName": Home_CropAdvisory,
            "className":"CASubscriptionFilterViewController",
            
            "moduleName":"CropAdvisory",
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
    //    func logEventsAPICall() {
    //
    //      //missingUserType
    //                let urlString:String = String(format: "%@%@", arguments: ["http://www.pioneeractivity.in/",CA_SAVE_LOGEVENTS])
    //
    //                let userObj = Constatnts.getUserObject()
    //
    //        headers  = ["deviceToken": userObj1?.value(forKey: "deviceToken") as? String ?? "",
    //                           "userAuthorizationToken": userObj1?.value(forKey: "userAuthorizationToken")  as? String ?? "",
    //                           "mobileNumber": userObj1?.value(forKey: "mobileNumber")  as? String ?? "",
    //                           "customerId": userObj1?.value(forKey: "customerId")  as? String ?? "",
    //                           "deviceId": userObj1?.value(forKey: "deviceId")  as? String ?? ""]
    //                print(headers)
    //
    //        let events =  CoreDataManager.shared.fetchLogEvnets()
    //
    //        let eventsArray = NSMutableArray()
    //        var parameters = NSDictionary()
    //
    //        if events.count > 0 {
    //
    //            for (index,event) in events.enumerated(){
    //                var   paramsJson = NSDictionary()
    //                if event.crop != ""   && event.crop != nil && event.hybrid != "" && event.hybrid != nil && event.acres_Sowed != "" && event.acres_Sowed != nil {
    //                    paramsJson  = ["Mobile_Number" : event.mobile ?? ""  ,"screen_name" :  event.screenName ?? "" , "User_Id" :  event.userID ?? "" , "crop": event.crop ?? "" ,"Hybrid": event.hybrid ?? "" ,"Acres_Sowed": event.acres_Sowed ?? "" ]
    //                }else if event.caStageId != "" && event.caStageId != nil && event.cropTypeId != "" && event.cropTypeId != nil && event.cropPhaseId != "" &&  event.cropPhaseId != nil {
    //                    paramsJson  = ["Mobile_Number" : event.mobile ?? ""  ,"screen_name" :  event.screenName ?? ""  , "User_Id" :  event.userID ?? "" ,"cropName": event.crop ?? ""  ,"cropPhaseId": event.cropPhaseId  ?? "","cropTypeId": event.cropTypeId ?? "" ,"caStageId": event.caStageId ?? ""]
    //                }else {
    //                      paramsJson  = ["Mobile_Number" : event.mobile  ?? "" ,"screen_name" :  event.screenName ?? "" , "User_Id" :  event.userID ?? ""]
    //                }
    //
    //                var str = ""
    //                if let theJSONData = try?  JSONSerialization.data(
    //                    withJSONObject: paramsJson,
    //                    options: .prettyPrinted
    //                    ),
    //                    let theJSONText = String(data: theJSONData,
    //                                             encoding: String.Encoding.utf8) {
    //                        print("JSON string = \n\(theJSONText)")
    //                    str = theJSONText
    //                  }
    //
    //
    //
    //                let params  = ["_id": String(index) , "capturedtime" : event.captureTime ?? "" , "currentLocation" :  event.currentLocation ?? "0.0,0.0" ,"eventName" :  event.eventName ?? "" , "moduleType" :  event.moduleType ?? "CropAdvisory","deviceType" : "iOS" , "propertiesJsonData" : str ] as [String : Any]
    //
    //                eventsArray.add(params)
    //                parameters = ["logEventsDTOList" : eventsArray]
    //            }
    //
    //
    //        let jwtString = Constatnts.encryptInputParams(parameters: parameters)
    //        let params = ["data" : jwtString]
    //
    //                Alamofire.request(urlString, method: .post, parameters: params , encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
    //                    SwiftLoader.hide()
    //                    if response.result.error == nil {
    //                        CoreDataManager.shared.deleteAllRecords()
    //                    }
    //                    else{
    //                        self.view.makeToast((response.error?.localizedDescription)!)
    //                    }
    //                }
    //        }
    //
    //    }
    @objc func contentViewTapGestureRecognizer(_ tapGesture:UITapGestureRecognizer) {
        view.endEditing(true)
        //        categoryDropDownTblView.isHidden = true
        //        crop_dropDownTable.isHidden = true
        //        hybrid_dropDownTable.isHidden = true
        //        seasonTblView.isHidden = true
    }
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //var touch: UITouch? = touches.first as? UITouch
        //location is relative to the current view
        // do something with the touched point
        // if touch?.view != yourView {
        //        categoryDropDownTblView.isHidden = true
        //        crop_dropDownTable.isHidden = true
        //        hybrid_dropDownTable.isHidden = true
        //        seasonTblView.isHidden = true
        //}
    }
    
    @IBAction func addSubscriptionAction(_ sender: Any) {
        if isCropsSubscriptionAvailable == true {
            let storyboard = UIStoryboard.init(name: "mains", bundle: Bundle(for: CASubscriptionFilterViewController.self))
            
            let subscribeVC = storyboard.instantiateViewController(withIdentifier: "CASubScriptionViewController") as? CASubScriptionViewController
            subscribeVC?.userObj1 = self.userObj1
            self.navigationController?.pushViewController(subscribeVC!, animated: true)
        }else {
            self.view.makeToast("No CropAdvisory Available for your number")
        }
    }
    
    open  func geteSubScriptionList(){
        if subscriptionArray.count>0{
            self.subscriptionCollection.isHidden = false
            subscribedViewHeightConstraint.constant = 223.0
            self.subscriptionCollection.reloadData()
        }
        else{
            subscribedViewHeightConstraint.constant = 0.0
            self.subscriptionCollection.isHidden = true
        }
        self.getCropListMaster()
        
    }
    
    
    @objc func closeTapped1 ( _ sender : UIButton){
        clearTextFields()
        alertView_Bg.removeFromSuperview()
    }
    
    open  func clearTextFields(){
        cistomView.cropTF.text = ""
        cistomView.categoryTxtFld.text = ""
        cistomView.dateOfSowingTF.text = ""
        cistomView.hybridTf.text = ""
        self.cistomView.noOfAcresTxtField.text  = ""
        selectedTextField = UITextField()
    }
    
    //MARK:- SUBSCRIPTION BUTTON ACTION TAPPED
    @objc func SubscribeTapped1 ( _ sender : UIButton){
        
        print(cistomView.cropTF.text ?? "0")
        print(cistomView.hybridTf.text ?? "0")
        print(cistomView.dateOfSowingTF.text ?? "0")
        
        
        //   let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            if Validations.isNullString(cistomView.cropTF.text as NSString? ?? "" as NSString) {
                // appDelegate.window?.makeToast("Please select crop.")
                self.view.makeToast("Please select crop.")
                return
            }
            if Validations.isNullString(cistomView.categoryTxtFld.text as NSString? ?? "" as NSString) {
                self.view.makeToast("Please select crop type.")
                return
            }
            else   if Validations.isNullString(cistomView.hybridTf.text as NSString? ?? "" as NSString) {
                self.view.makeToast("Please select hybrid.")
                return
            }
            else  if Validations.isNullString(cistomView.dateOfSowingTF.text as NSString? ?? "" as NSString) {
                self.view.makeToast("Please select date of sowing")
                return
            }
            else  if Validations.isNullString(cistomView.noOfAcresTxtField.text as NSString? ?? "" as NSString) {
                self.view.makeToast("Please Enter no. of acress")
                return
            }
            submitSubscribeduserDetails()
            
            alertView_Bg.removeFromSuperview()
            /*     let dateFormatter: DateFormatter = DateFormatter()
             dateFormatter.dateFormat = "dd-MMM-yyyy"
             let date = dateFormatter.date(from: cistomView.dateOfSowingTF.text ?? "")
             dateFormatter.dateFormat = "yyyy-MM-dd"
             let strDateToServer = dateFormatter.string(from: date!)
             print(strDateToServer)
             let userObj = Constatnts.getUserObject()
             let parameters = ["customerId":userObj.customerId! as String,
             "category":categoryID as String,
             "state":stateID as String,
             "crop":cropID as String,
             "hybrid":hybridID as String,
             "season":seasonID as String,
             "sowingDate":strDateToServer,
             "acressowed":noOfAcress] as NSDictionary
             print(parameters)
             let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
             let params =  ["data" : paramsStr]
             print(params)
             self.requestToRegisterCropAdvisoryData(params: params as [String:String])
             let fireBaseParams = [MOBILE_NUMBER : userObj.mobileNumber!,USER_ID : userObj.customerId!,CROP:cistomView.cropTF.text ?? "",SEASON:seasonID,HYBRID:cistomView.hybridTf.text ?? "0",STATE: stateID,ACERS_SOWED:noOfAcress] as [String : Any]
             self.registerFirebaseEvents(CA_Submit, "", "", "", parameters: fireBaseParams as NSDictionary)
             }
             else{
             self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
             */ }
    }
    
    //MARK:- SHOW POP UP WINDOW TO ADD SUBSCRIPTION
    public   func showAddSubscriptionWindow(){
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            //  let appDelegate = UIApplication.shared.delegate as! AppDelegate
            alertView_Bg = UIView (frame: CGRect(x: 0,y: 0 ,width: self.view.frame.size.width,height: self.view.frame.size.height ))
            alertView_Bg.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
            self.view.addSubview(alertView_Bg)
            
            let alertView: UIView = UIView (frame: CGRect(x: 20, y:  -60, width:self.view.frame.size.width - 50,height: 295))
            alertView.backgroundColor = .white//UIColor(red: 232.0/255, green: 247.0/255, blue: 248.0/255, alpha: 1.0)
            alertView.layer.cornerRadius = 10.0
            alertView_Bg.addSubview(alertView)
            
            cistomView.frame = CGRect(x: 0, y:  0 ,width: alertView.frame.size.width ,height: alertView.frame.size.height  )
            cistomView.backgroundColor = .clear
            alertView.addSubview(cistomView)
            
            alertView.roundCorners([.layerMinXMaxYCorner,.layerMaxXMaxYCorner,.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 10.0, borderColor: UIColor.clear, borderWidth: 1)
            cistomView.exitBtn.addTarget(self, action: #selector(CASubscriptionFilterViewController.closeTapped1(_:)), for: .touchUpInside)
            cistomView.SubscribeBtn.addTarget(self, action: #selector(CASubscriptionFilterViewController.SubscribeTapped1(_:)), for: .touchUpInside)
            
            cistomView.cropTF.delegate = self
            cistomView.hybridTf.delegate = self
            cistomView.dateOfSowingTF.delegate = self
            
            cistomView.categoryTxtFld.delegate = self
            cistomView.noOfAcresTxtField.delegate = self
            
            //let userObj = Constatnts.getUserObject()
            let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CASubscriptionFilterViewController.contentViewTapGestureRecognizer(_:)))
            singleTapGestureRecognizer.numberOfTapsRequired = 1
            singleTapGestureRecognizer.isEnabled = true
            singleTapGestureRecognizer.cancelsTouchesInView = false
            cistomView.addGestureRecognizer(singleTapGestureRecognizer)
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
        
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override open var shouldAutorotate: Bool {
        return true
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.topView?.isHidden = true
        self.topView?.isHidden = false
        lblTitle?.text = "Crop Advisory"
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        forceOrientationPortrait()
        
        headers  = ["deviceToken": userObj1?.value(forKey: "deviceToken") as? String ?? "",
                    "userAuthorizationToken": userObj1?.value(forKey: "userAuthorizationToken")  as? String ?? "",
                    "mobileNumber": userObj1?.value(forKey: "mobileNumber")  as? String ?? "",
                    "customerId": userObj1?.value(forKey: "customerId")  as? String ?? "",
                    "deviceId": userObj1?.value(forKey: "deviceId")  as? String ?? ""]
    }
    open override func viewDidLayoutSubviews() {
        DispatchQueue.main.async {
            self.cropAnalysisCollView.isScrollEnabled = false
            self.cropsCollectionViewHgtConstraint.constant = self.cropAnalysisCollView.contentSize.height + 50
        }
    }
    override func backButtonClick(_ sender: UIButton) {
        //framework
        // self.findHamburguerViewController()?.showMenuViewController()
        
        //        if isFromSideMenu{
        //           self.navigationController?.popViewController(animated: true)
        //        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func forceOrientationPortrait() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .portrait
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        let defaults = UserDefaults.standard
        //defaults.set(decryptData , forKey: "OTPResponseData")
        defaults.set(false, forKey: "Landscape")
        defaults.synchronize()
    }
    
    //MARK: collectionView datasource and delegate methods
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == subscriptionCollection{
            return subscriptionArray.count
        }else{
            return cropsArray.count
        }
    }
    
}

extension CASubscriptionFilterViewController:  UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    
    @IBAction func nextAction(_ sender: Any) {
        let visibleItems: NSArray = self.subscriptionCollection.indexPathsForVisibleItems as NSArray
        if(visibleItems.count>0){
            let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
            let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
            if nextItem.row < subscriptionArray.count {
                //                subscriptionCollection.delegate = self
                //                subscriptionCollection.reloadData()
                //                subscriptionCollection.layoutIfNeeded()
                self.subscriptionCollection.scrollToItem(at: nextItem, at: .left, animated: true)
            }
        }
        
    }
    @IBAction func previousAction(_ sender: Any) {
        let visibleItems: NSArray = self.subscriptionCollection.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item - 1, section: 0)
        if nextItem.row < subscriptionArray.count && nextItem.row >= 0{
            self.subscriptionCollection.scrollToItem(at: nextItem, at: .right, animated: true)
            
        }
        
    }
    
    
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //        guard self.isViewDidLayoutCallFirstTime else {return}
    //        self.isViewDidLayoutCallFirstTime = false
    //        self.collectionView.collectionViewLayout.collectionViewContentSize // It will required to re calculate collectionViewContentSize in internal method
    //        let indexpath = IndexPath(item: self.currentIndex, section: 0)
    //
    //        self.collectionView.scrollToItem(at: indexpath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
    //
    //    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cell = self.cropAnalysisCollView.dequeueReusableCell(withReuseIdentifier: "CropDiagnosisCell", for: indexPath)
        if collectionView == subscriptionCollection{
            let cellIdentifier = "CASubcriptionFilterCel"
            
            
            let cell : CASubcriptionFilterCell = subscriptionCollection.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CASubcriptionFilterCell
            
            let dicObj : CASubscribedUserListBO = subscriptionArray.object(at: indexPath.row) as! CASubscribedUserListBO
            
            cell.lbl_cropTitle.text = dicObj.cropName as String? ?? ""
            cell.lbl_Hybrid.text = dicObj.hybridName as String? ?? ""
            let Str = (dicObj.dateOfShowing as String? ?? "")
            let fullName : String = Str
            let fullNameArr : [String] = fullName.components(separatedBy: " ")
            
            cell.lbl_Hybrid.text = String(format : "Hybrid :%@",dicObj.hybridName as String? ?? "")
            if fullNameArr.count >= 1{
                //  let dateStr
                let dateStr = fullNameArr[0] as String? ?? ""
                if let startDate = FarmServicesConstants.getDateStringFromDateStringWithNormalFormat(serverDate: dateStr) as String?{
                    //getDateStringFromDateStringWithNormalFormat
                    
                    cell.lbl_dateOfSowing.text = String(format : "Date of Sowing :%@",startDate)
                }
                // cell.lbl_dateOfSowing.text = String(format : "Date of Sowing :%@",fullNameArr[0] as String? ?? "")
            }
            
            
            let url = URL(string:dicObj.cropImageUrl as String? ?? "")
            cell.cropImg.contentMode = .scaleToFill
            //            cell.cropImg!.sd_setImage(with: url, placeholderImage:UIImage(named:"Rice") , options: nil) { (img, error, cache, url) in
            //                print("fvijx")
            //            }
            cell.cropImg.sd_setImage(with: url, placeholderImage:UIImage.init(named: "Rice"))
            let strPercentrag = String(format : "%@%%",dicObj.percentage as String? ?? "") // dicObj.percentage as String? ?? ""
            cell.setProgressView(strPercentrag)
            return cell
        }
        else{
            let cellIdentifier = "CropAdvisoryCell"
            
            // cropAnalysisCollView.register(UINib.init(nibName: "CropDiagnosisCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
            let cell : UICollectionViewCell = cropAnalysisCollView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            let dicObj = cropsArray.object(at: indexPath.row) as? NSDictionary ?? [:]
            let cameraImgView = cell.contentView.viewWithTag(200) as! UIImageView
            cameraImgView.isHidden = true
            let cropImgView = cell.contentView.viewWithTag(100) as! UIImageView
            let cropNameLbl = cell.contentView.viewWithTag(101) as! UILabel
            cropNameLbl.text = dicObj.object(forKey: "cropName") as? String ?? "" //cropID
            let url = URL(string:dicObj.object(forKey: "imageUrl") as? String ?? "")
            cropImgView.kf.setImage(with: url , placeholder: UIImage(named:"image_placeholder.png"))//, options: nil, progressBlock: nil, completionHandler: nil)
            
            
            
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == subscriptionCollection {
            return CGSize(width: (collectionView.frame.size.width*80)/100, height: collectionView.frame.size.height)
        }
        else{
            if cropsArray.count > 1{
                return CGSize(width: collectionView.bounds.size.width/2-15, height: collectionView.bounds.size.width/2-10)//150
            }
            return CGSize(width: collectionView.bounds.size.width-15, height: collectionView.bounds.size.height-60)//150
        }
        
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == subscriptionCollection {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else{
            return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)//top,left,bottom,right
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //  let storyboard = UIStoryboard.init(name: "cropadvisorySub", bundle: Bundle(for: CASubscriptionFilterViewController.self))
    
    // let toGrowthSelectedObj = storyboard.instantiateViewController(withIdentifier: "SubscriptionGrowthDurationViewController") as? SubscriptionGrowthDurationViewController
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var  dicObj  = NSDictionary()
        var isFromSubs = false
        if collectionView ==  cropAnalysisCollView{
            //            CoreDataManager.shared.addLogEvent(UserID: userObj1?.value(forKey: "customerId")  as? String ?? "", mobileNumber: userObj1?.value(forKey: "mobileNumber")  as? String ?? "", screenName: "CASubscriptionFilterViewController", eventName: "Crop_Selection_Click", eventType: "Click",captureTime:getCurrentDateAndTime(), currentLocation: "0.0,0.0", moduleType: "CropAdvisory")
            
            let params  = ["capturedtime" : getCurrentDateAndTime() , "currentLocation" :  userObj1?.value(forKey: "geoLocation")  as? String ?? "" ,"eventName" :  "Crop_Selection_Click" , "moduleType" : "CropAdvisory","deviceType" : "iOS" , "Mobile_Number" : userObj1?.value(forKey: "mobileNumber")  as? String ?? "" ,"screen_name" :  "CASubscriptionFilterViewController" , "User_Id" :  userObj1?.value(forKey: "customerId")  as? String ?? ""]
            
            self.registerFirebaseEvents("Crop_Selection_Click", "", "", "CASubscriptionFilterViewController", parameters: params as NSDictionary)
            
            dicObj = cropsArray.object(at: indexPath.row) as? NSDictionary ?? [:]
            cropID = dicObj.object(forKey: "cropId") as? String as NSString? ?? "" as NSString
            if let idObj = dicObj.object(forKey: "cropId") as? Int {
                cropID = String(format: "%d",idObj) as NSString
            }
        }else{
            let params  = ["capturedtime" : getCurrentDateAndTime() , "currentLocation" :  userObj1?.value(forKey: "geoLocation")  as? String ?? "" ,"eventName" :  "Crop_Subscribed_Click" , "moduleType" : "CropAdvisory","deviceType" : "iOS" , "Mobile_Number" : userObj1?.value(forKey: "mobileNumber")  as? String ?? "" ,"screen_name" :  "CASubscriptionFilterViewController" , "User_Id" :  userObj1?.value(forKey: "customerId")  as? String ?? ""]
            
            self.registerFirebaseEvents("Crop_Subscribed_Click", "", "", "CASubscriptionFilterViewController", parameters: params as NSDictionary)
            
            //               CoreDataManager.shared.addLogEvent(UserID: self.userObj1?.value(forKey: "customerId")  as? String ?? "", mobileNumber: self.userObj1?.value(forKey: "mobileNumber")  as? String ?? "", screenName: "CASubScriptionFilterViewController", eventName: "Crop_Subscribed_Click", eventType: "Click",captureTime:getCurrentDateAndTime(), currentLocation: userObj1?.value(forKey: "geoLocation")  as? String ?? "", moduleType: "CropAdvisory")
            
            isFromSubs = true
            if(selectedSubscription.count>0){
                selectedSubscription.removeAllObjects()
            }
            let cropListDict: CASubscribedUserListBO = subscriptionArray.object(at: indexPath.row) as! CASubscribedUserListBO
            cropID = cropListDict.cropID ?? "" as NSString
            selectedSubscription.add(cropListDict)
        }
        
        let userObj = Constatnts.getUserObject()
        let parameters = [
            "crop":cropID ,"mobileNumber" : userObj1?.value(forKey: "mobileNumber")  as? String ?? ""
            
            ] as NSDictionary
        print(parameters)
        let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
        let params =  ["data" : paramsStr]
        print(params)
        navigateFunc(parameter : parameters , isfromSubscription  : isFromSubs)
    }
    override open var prefersStatusBarHidden: Bool {
        return false
    }
    
    func navigateFunc(parameter : NSDictionary , isfromSubscription : Bool ) {
        
        
        headers  = ["deviceToken": userObj1?.value(forKey: "deviceToken") as? String ?? "",
                    "userAuthorizationToken": userObj1?.value(forKey: "userAuthorizationToken")  as? String ?? "",
                    "mobileNumber": userObj1?.value(forKey: "mobileNumber")  as? String ?? "",
                    "customerId": userObj1?.value(forKey: "customerId")  as? String ?? "",
                    "deviceId": userObj1?.value(forKey: "deviceId")  as? String ?? ""]
        
        BaseClass.submitCropFilterUserData(dic : parameter as NSDictionary , headers : headers) { (status, responseArray,message) in
            
            if status == true{
                if responseArray != nil{
                    if isfromSubscription == true{
                        //                    CoreDataManager.shared.addLogEvent(UserID: self.userObj1?.value(forKey: "customerId")  as? String ?? "", mobileNumber: self.userObj1?.value(forKey: "mobileNumber")  as? String ?? "", screenName: "CASubScriptionFilterViewController", eventName: "CropSubscribed_Success_Request", eventType: "onRequest",captureTime:self.getCurrentDateAndTime(), currentLocation: "0.0,0.0", moduleType: "CropAdvisory")
                        
                        let params  = ["capturedtime" : self.getCurrentDateAndTime() , "currentLocation" :  self.userObj1?.value(forKey: "geoLocation")  as? String ?? "" ,"eventName" :  "CropSubscribed_Success_Request" , "moduleType" : "CropAdvisory","deviceType" : "iOS" , "Mobile_Number" : self.userObj1?.value(forKey: "mobileNumber")  as? String ?? "" ,"screen_name" :  "CASubscriptionFilterViewController" , "User_Id" :  self.userObj1?.value(forKey: "customerId")  as? String ?? ""]
                        
                        self.registerFirebaseEvents("CropSubscribed_Success_Request", "", "", "CASubscriptionFilterViewController", parameters: params as NSDictionary)
                        
                    }else {
                        //                    CoreDataManager.shared.addLogEvent(UserID: self.userObj1?.value(forKey: "customerId")  as? String ?? "", mobileNumber: self.userObj1?.value(forKey: "mobileNumber")  as? String ?? "", screenName: "CASubScriptionFilterViewController", eventName: "CropSelection_Success_Request", eventType: "onRequest",captureTime:self.getCurrentDateAndTime(), currentLocation: "0.0,0.0", moduleType: "CropAdvisory")
                        
                        let params  = ["capturedtime" : self.getCurrentDateAndTime() , "currentLocation" :  self.userObj1?.value(forKey: "geoLocation")  as? String ?? "" ,"eventName" :  "CropSelection_Success_Request" , "moduleType" : "CropAdvisory","deviceType" : "iOS" , "Mobile_Number" : self.userObj1?.value(forKey: "mobileNumber")  as? String ?? "" ,"screen_name" :  "CASubscriptionFilterViewController" , "User_Id" :  self.userObj1?.value(forKey: "customerId")  as? String ?? ""]
                        
                        self.registerFirebaseEvents("CropSelection_Success_Request", "", "", "CASubscriptionFilterViewController", parameters: params as NSDictionary)
                        
                        
                    }
                    
                    
                    
                    self.FinalArray.removeAllObjects()
                    let dicP = responseArray?.object(forKey: "cropTypes") as? NSArray ?? []
                    for i in 0..<dicP.count{
                        let cropListDict = CropControllerBO(dict: dicP.object(at: i) as! NSDictionary)
                        print(cropListDict)
                        
                        self.FinalArray.add(cropListDict)
                    }
                    
                    if( self.FinalArray.count>0){
                        
                        if( self.FinalArray.count>1){
                            
                            let storyboard = UIStoryboard.init(name: "mains", bundle: Bundle(for: CASubscriptionFilterViewController.self))
                            
                            let toCropSelected = storyboard.instantiateViewController(withIdentifier: "CropAdvisoryCropController") as? CropAdvisoryCropController
                            
                            toCropSelected?.userObjDic = self.userObj1
                            
                            //                        let toCropSelected = self.storyboard?.instantiateViewController(withIdentifier: "CropAdvisoryCropController") as? CropAdvisoryCropController
                            toCropSelected?.categoryCropArray = self.FinalArray
                            self.navigationController?.pushViewController(toCropSelected!, animated: true)
                        }
                        else{
                            
                            let cropTypeIDObj = self.FinalArray.object(at: 0) as! CropControllerBO
                            let cropTypeID = cropTypeIDObj.cropTypeID as String? as NSString? ?? "" as NSString
                            self.cropID = cropTypeIDObj.cropID as String? as NSString? ?? "" as NSString
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.myOrientation = .landscape
                            
                            //framework
                            
                            let storyboard = UIStoryboard.init(name: "cropadvisorySub", bundle: Bundle(for: CASubscriptionFilterViewController.self))
                            
                            let toGrowthSelectedObj = storyboard.instantiateViewController(withIdentifier: "SubscriptionGrowthDurationViewController") as? SubscriptionGrowthDurationViewController
                            // let mainStoryboard: UIStoryboard = UIStoryboard(name: "cropadvisorySub",bundle: nil)
                            //  let toGrowthSelectedObj = mainStoryboard.instantiateViewController(withIdentifier: "SubscriptionGrowthDurationViewController") as? SubscriptionGrowthDurationViewController
                            toGrowthSelectedObj?.cropID = self.cropID
                            toGrowthSelectedObj?.cropTypeId = cropTypeID
                            if isfromSubscription {
                                toGrowthSelectedObj?.selectedSubscription = self.selectedSubscription
                                toGrowthSelectedObj?.isfromSubscriptionTap = isfromSubscription
                            }
                            var defaults = UserDefaults.standard
                            defaults.set(true, forKey: "Landscape")
                            defaults.synchronize()
                            toGrowthSelectedObj?.SelectedCropString = String(format:"%@ %@",cropTypeIDObj.cropType ?? "",cropTypeIDObj.cropName ?? "")
                            toGrowthSelectedObj?.userObj1 = self.userObj1
                            self.navigationController?.pushViewController(toGrowthSelectedObj!, animated: true)
                        }
                    }else{
                        self.view.makeToast(message ?? "")
                    }
                }
                else{
                    self.view.makeToast(message ?? "")
                }
            }
            else{
                if isfromSubscription == true{
                    //             CoreDataManager.shared.addLogEvent(UserID: self.userObj1?.value(forKey: "customerId")  as? String ?? "", mobileNumber: self.userObj1?.value(forKey: "mobileNumber")  as? String ?? "", screenName: "CASubScriptionFilterViewController", eventName: "CropSubscribed_Something_Wrong", eventType: "onRequest",captureTime:self.getCurrentDateAndTime(), currentLocation: "0.0,0.0", moduleType: "CropAdvisory")
                    
                    let params  = ["capturedtime" : self.getCurrentDateAndTime() , "currentLocation" :  self.userObj1?.value(forKey: "geoLocation")  as? String ?? "" ,"eventName" :  "CropSubscribed_Something_Wrong" , "moduleType" : "CropAdvisory","deviceType" : "iOS" , "Mobile_Number" : self.userObj1?.value(forKey: "mobileNumber")  as? String ?? "" ,"screen_name" :  "CASubscriptionFilterViewController" , "User_Id" :  self.userObj1?.value(forKey: "customerId")  as? String ?? ""]
                    
                    self.registerFirebaseEvents("CropSubscribed_Something_Wrong", "", "", "CASubscriptionFilterViewController", parameters: params as NSDictionary)
                    
                }else {
                    //                     CoreDataManager.shared.addLogEvent(UserID: self.userObj1?.value(forKey: "customerId")  as? String ?? "", mobileNumber: self.userObj1?.value(forKey: "mobileNumber")  as? String ?? "", screenName: "CASubScriptionFilterViewController", eventName: "CropSelection_Something_Wrong", eventType: "onRequest",captureTime:self.getCurrentDateAndTime(), currentLocation: "0.0,0.0", moduleType: "CropAdvisory")
                    
                    let params  = ["capturedtime" : self.getCurrentDateAndTime() , "currentLocation" :  self.userObj1?.value(forKey: "geoLocation")  as? String ?? "" ,"eventName" :  "CropSelection_Something_Wrong" , "moduleType" : "CropAdvisory","deviceType" : "iOS" , "Mobile_Number" : self.userObj1?.value(forKey: "mobileNumber")  as? String ?? "" ,"screen_name" :  "CASubscriptionFilterViewController" , "User_Id" :  self.userObj1?.value(forKey: "customerId")  as? String ?? ""]
                    
                    self.registerFirebaseEvents("CropSelection_Something_Wrong", "", "", "CASubscriptionFilterViewController", parameters: params as NSDictionary)
                }
                self.view.makeToast(message ?? "")
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == cropAnalysisCollView{
            switch kind {
                
            case UICollectionElementKindSectionHeader:
                
                let headerView = cropAnalysisCollView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CAHeader", for: indexPath as IndexPath) as? SubscriptionCollectionReusableView
                headerView?.roundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 10.0, borderColor: UIColor.clear, borderWidth: 0.0)
                //
                //                let dict : NSDictionary = dashboardItemsArray.object(at: indexPath.section) as! NSDictionary
                //                headerView!.lblTitle.text = dict["Title"] as? String
                //
                //                //                if dict["Title"] as? String == "Advisory Related" {
                //                //                    headerView?.btnParamarsh.isHidden = false
                //                //                    headerView?.btnParamarsh.addTarget(self, action: #selector(self.gotoParamarshScreen(_:)), for: .touchUpInside)
                //                //                }
                
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
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == cropAnalysisCollView{
            return CGSize(width: collectionView.frame.width, height: 75)
        }
        else{
            return CGSize(width: 0, height: 0)
        }
    }
    
}

//MARK:- UITABLEVIEW DELEGATE AND DATA SOURCE METHODS
extension CASubscriptionFilterViewController:  UITableViewDelegate,UITableViewDataSource{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == categoryDropDownTblView {
            return categoryNamesArray.count
        }
        else if tableView == crop_dropDownTable {
            return cropNamesArray.count
        }
        else if tableView == hybrid_dropDownTable {
            return hybridNameArray.count
        }
        else{
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellIdentifier)
        cell.textLabel?.font = UIFont.init(name: "Helvetica", size: 13.0)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.sizeToFit()
        cell.textLabel?.text = "hi"
        cell.backgroundColor = UIColor.white
        
        
        if tableView == categoryDropDownTblView {
            let categoryDic = categoryNamesArray.object(at: indexPath.row) as? NSDictionary
            cell.textLabel?.text = categoryDic?.value(forKey: "cropSubTypeName") as? String
        }
        else if tableView == crop_dropDownTable {
            let stateDic = cropNamesArray.object(at: indexPath.row) as? NSDictionary
            cell.textLabel?.text = stateDic?.value(forKey: "name") as? String
        }
        else if tableView == hybrid_dropDownTable {
            let hybridDic = hybridNameArray.object(at: indexPath.row) as? NSDictionary
            cell.textLabel?.text = hybridDic?.value(forKey: "name") as? String
        }
        else{
            //            let seasonDic = seasonNamesArray.object(at: indexPath.row) as? NSDictionary
            //            cell.textLabel?.text = seasonDic?.value(forKey: "name") as? String
        }
        
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        if tableView == categoryDropDownTblView {
            if self.categoryNamesArray.count>0{
                let categoryDic = self.categoryNamesArray.object(at: indexPath.row) as? NSDictionary
                categoryID = categoryDic?.value(forKey: "cropId") as? String as NSString? ?? ""
                cistomView.categoryTxtFld.text = categoryDic?.value(forKey: "cropSubTypeName") as? String
                cropTypeId = categoryDic?.value(forKey: "cropTypeId") as? String as NSString? ?? ""
            }
            
            // self.filterStatesWithCategory(categoryDic: categoryDic)
            if categoryDropDownTblView != nil{
                categoryDropDownTblView.isHidden = true
            }
            cistomView.categoryTxtFld.resignFirstResponder()
        }
            
        else if tableView == crop_dropDownTable {
            //get crop id
            if self.cropNamesArray.count>0{
                let cropDic = self.cropNamesArray.object(at: indexPath.row) as? NSDictionary
                cropID = cropDic?.value(forKey: "id") as? String as NSString? ?? ""
                cistomView.cropTF.text = cropDic?.value(forKey: "name") as? String
                
                let categoryPredicate = NSPredicate(format: "cropName = %@",cropDic?.value(forKey: "name") as? String ?? "")
                let categoryFilterArray = (self.categoryArray).filtered(using: categoryPredicate) as NSArray
                let categoryDic = categoryFilterArray.firstObject as? NSDictionary
                self.filterStatesWithCategory(categoryDic: categoryDic)
                self.filterHybridWithCategoryAndStaeAndCrop(categoryDic: categoryDic,  cropDic: cropDic)
            }
            if crop_dropDownTable != nil{
                crop_dropDownTable.isHidden = true
            }
            cistomView.cropTF.resignFirstResponder()
        }
        else if tableView == hybrid_dropDownTable {
            if self.hybridNameArray.count>0{
                let hybridDic = self.hybridNameArray.object(at: indexPath.row) as? NSDictionary
                hybridID = hybridDic?.value(forKey: "id") as? String as NSString? ?? ""
                cistomView.hybridTf.text = hybridDic?.value(forKey: "name") as? String
            }
            if hybrid_dropDownTable != nil{
                hybrid_dropDownTable.isHidden = true
            }
            cistomView.hybridTf.resignFirstResponder()
        }
        else{
            tableView.isHidden = true
        }
        self.view.endEditing(true)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
}

//MARK:- UITEXTFIELDDELEGATE METHODS
extension CASubscriptionFilterViewController : UITextFieldDelegate{
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == cistomView.categoryTxtFld{
            textField.resignFirstResponder()
            
            categoryDropDownTblView = UITableView()
            categoryDropDownTblView.reloadData()
            self.hideUnhideDropDownTblView(tblView: categoryDropDownTblView, hideUnhide: false)
        }
        if textField == cistomView.cropTF{
            textField.resignFirstResponder()
            
            crop_dropDownTable = UITableView()
            crop_dropDownTable.reloadData()
            self.hideUnhideDropDownTblView(tblView: crop_dropDownTable, hideUnhide: false)
        }
        
        if textField == cistomView.hybridTf{
            hybrid_dropDownTable = UITableView()
            textField.resignFirstResponder()
            hybrid_dropDownTable.reloadData()
            self.hideUnhideDropDownTblView(tblView: hybrid_dropDownTable, hideUnhide: false)
        }
        
        
        if textField == cistomView.hybridTf{
            textField.resignFirstResponder()
        }
    }
    
    
    func loadTable( textField: UITextField, table : UITableView){
        self.loadDropDownTableView( tableview: table, textField: textField)
        table.dataSource = self
        table.delegate   = self
        table.reloadData()
        self.hideUnhideDropDownTblView(tblView: table, hideUnhide: table.isHidden)
    }
    
    //MARK:- DROPDOWN TABLE VIEW DESIGN LOADS
    func loadDropDownTableView(tableview:UITableView,textField:UITextField){
        tableview.isScrollEnabled = true
        tableview.isHidden = true
        tableview.layer.borderWidth = 0.5
        tableview.layer.borderColor = UIColor.blue.cgColor
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.estimatedRowHeight = 30
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.tableFooterView = UIView()
        self.alertView_Bg.addSubview(tableview)
        let xConstraint = NSLayoutConstraint.init(item: tableview, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem:textField , attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0.0) as NSLayoutConstraint
        let yConstraint = NSLayoutConstraint.init(item: tableview, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem:textField , attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0) as NSLayoutConstraint
        let widthConstraint = NSLayoutConstraint.init(item: tableview, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem:textField , attribute: NSLayoutConstraint.Attribute.width, multiplier: 1.0, constant: 0.0) as NSLayoutConstraint
        let heightConstraint = NSLayoutConstraint.init(item: tableview, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem:textField , attribute: NSLayoutConstraint.Attribute.height, multiplier: 1.0, constant: 120) as NSLayoutConstraint //height constant : 120
        self.alertView_Bg.addConstraints([xConstraint,yConstraint,widthConstraint,heightConstraint])
    }
    
    
    // ------------------------------- //
    // MARK: hideUnhideDropDownTblView
    // ------------------------------- //
    @objc func hideUnhideDropDownTblView(tblView : UITableView, hideUnhide : Bool){
        
        if hybrid_dropDownTable != nil{
            hybrid_dropDownTable.isHidden = true
        }
        if categoryDropDownTblView != nil{
            categoryDropDownTblView.isHidden = true
        }
        
        if crop_dropDownTable != nil{
            crop_dropDownTable.isHidden = true
        }
        //tblView.isHidden = true
        tblView.isHidden = !hideUnhide
        self.view.bringSubview(toFront: tblView)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        //print("TextField did end editing method called")
        //        print("end")
        //        print(self.view.superview?.frame)
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        selectedTextField = textField
        // print("start")
        // print(self.view.frame)
        
        //  let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if(textField == cistomView.categoryTxtFld){
            textField.resignFirstResponder()
            if(cistomView.cropTF.text?.count ?? 0 > 0){
                categoryDropDownTblView = UITableView()
                
                loadTable(textField:  cistomView.categoryTxtFld , table : categoryDropDownTblView)
            }else{
                self.view.makeToast("Please Select Crop.")
            }
            return false
        }
        if(textField == cistomView.cropTF){
            textField.resignFirstResponder()
            crop_dropDownTable = UITableView()
            
            loadTable(textField:  cistomView.cropTF , table : crop_dropDownTable)
            return false
            
        }
        if textField == cistomView.hybridTf{
            textField.resignFirstResponder()
            if(cistomView.cropTF.text?.count ?? 0 > 0){
                hybrid_dropDownTable = UITableView()
                
                loadTable(textField:  cistomView.hybridTf , table : hybrid_dropDownTable)
                
            }else{
                self.view.makeToast("Please Select Crop.")
            }
            return false
        }
            
        else if textField == cistomView.dateOfSowingTF{
            textField.resignFirstResponder()
            if(cistomView.cropTF.text?.count ?? 0 > 0){
                dobPickerView()
            }else{
                self.view.makeToast("Please Select Crop.")
            }
            return false
        }
        else{
            return true;
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
}

//MARK:-  PICKER DELEGATE METHODS
extension CASubscriptionFilterViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    //MARK:- dobPickerView DESIGN
    func dobPickerView(){
        let Height:CGFloat = (44.11 * self.view.frame.height/120) //120
        let width :CGFloat = self.view.frame.size.width-40 //-40
        let posX :CGFloat = (self.view.frame.size.width - width) / 2
        
        dobView = UIView (frame: CGRect(x: posX,y: (self.view.frame.height-Height)/2 + 10 ,width: width,height: Height + 100))
        dobView.backgroundColor = UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        dobView.layer.cornerRadius = 10.0
        self.alertView_Bg.addSubview(dobView)
        
        //dobPicker
        let dobPicker : UIDatePicker = UIDatePicker (frame: CGRect(x: 5,y: 5,width: width-10,height: Height + 50))
        dobPicker.backgroundColor = UIColor.white
        dobPicker.layer.cornerRadius = 5.0
        dobPicker.datePickerMode = UIDatePicker.Mode.date
        
        
        if Validations.isNullString(self.seasonStartDateStr as NSString? ?? "") == false{
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateToSetOnPicker = dateFormatter.date(from: self.seasonStartDateStr!)
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            let str = dateFormatter.string(from: dateToSetOnPicker!)
            dobPicker.minimumDate = dateFormatter.date(from: str)//NSDate() as Date
            
            let dateToSetStr = dateFormatter.string(from: dateToSetOnPicker!)
            dobPicker.date = dateFormatter.date(from: dateToSetStr)!
            if Validations.isNullString( cistomView.dateOfSowingTF.text as NSString? ?? "" as NSString) == false{
                if let selectedDate = dateFormatter.date(from: cistomView.dateOfSowingTF.text ?? "") as Date?{
                    dobPicker.date = selectedDate
                }
            }
        }
        else{
            //dobPicker.minimumDate = NSDate() as Date
            //            let dateFormatter: DateFormatter = DateFormatter()
            //            dateFormatter.dateFormat = "dd-MMM-yyyy"
            //            let currentDateStr = dateFormatter.string(from: Date()) as String
            //            dateOfSowingTxtFLd.text = currentDateStr
        }
        
        if Validations.isNullString(self.seasonEndDateStr as NSString? ?? "") == false{
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateToSetOnPicker = dateFormatter.date(from: self.seasonEndDateStr!)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let str = dateFormatter.string(from: dateToSetOnPicker!)
            dobPicker.maximumDate = dateFormatter.date(from: str)//NSDate() as Date
            
            //let dateToSetStr = dateFormatter.string(from: dateToSetOnPicker!)
            //dobPicker.date = dateFormatter.date(from: dateToSetStr)!
        }
        else{
            dobPicker.maximumDate = NSDate() as Date
        }
        
        dobPicker.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: .valueChanged)
        dobView.addSubview(dobPicker)
        
        //submit button
        let btnOK : UIButton = UIButton (frame: CGRect(x: 0, y: dobPicker.frame.maxY+5,width: width,height: 40))
        btnOK.backgroundColor = UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 0.8)
        btnOK.layer.cornerRadius = 5.0
        btnOK.setTitle("OK", for: UIControl.State())
        btnOK.addTarget(self, action: #selector(SubscriptionGrowthDurationViewController.alertOK), for: UIControl.Event.touchUpInside)
        dobView.addSubview(btnOK)
        
        let dobFrame = dobView.frame
        dobView.frame.size.height = btnOK.frame.maxY
        dobView.frame = dobFrame
        dobView.frame.origin.y = (self.view.frame.size.height - 64 - dobView.frame.size.height) / 2
        dobView.frame = dobFrame
    }
    
    //MARK:- datePickerValueChanged
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let selectedDate = dateFormatter.string(from: sender.date) as NSString
        //print("Selected value \(selectedDate)")
        self.cistomView.dateOfSowingTF.text = selectedDate as String
        
        
    }
    
    //REMOVE SOWING PICKER VIEW
    @objc func alertOK(){
        self.dobView.removeFromSuperview()
    }
}


//MARK:- API INTEGRATIONS AND CALLS
extension CASubscriptionFilterViewController{
    
    //MARK:- GET MASTER FOR  SUBSCRIPTION WINDOW TEXTFIELDS
    /*
     - Parameter Params: [:]
     */
    func getCropListMaster(){
        
        //  let headers1 : HTTPHeaders = headers
        
        headers  = ["deviceToken": userObj1?.value(forKey: "deviceToken") as? String ?? "",
                    "userAuthorizationToken": userObj1?.value(forKey: "userAuthorizationToken")  as? String ?? "",
                    "mobileNumber": userObj1?.value(forKey: "mobileNumber")  as? String ?? "",
                    "customerId": userObj1?.value(forKey: "customerId")  as? String ?? "",
                    "deviceId": userObj1?.value(forKey: "deviceId")  as? String ?? ""]
        BaseClass.getListOfCropsCA(dic : [:], headers : headers) { (status, responseArray,message) in
            if status == true{
                //            CoreDataManager.shared.addLogEvent(UserID: self.userObj1?.value(forKey: "customerId")  as? String ?? "", mobileNumber: self.userObj1?.value(forKey: "mobileNumber")  as? String ?? "", screenName: "CASubscriptionFilterViewController", eventName: "CropMaster_Success_Request", eventType: "onRequest",captureTime:self.getCurrentDateAndTime(), currentLocation: "0.0,0.0", moduleType: "CropAdvisory")
                
                
                let params  = ["capturedtime" : self.getCurrentDateAndTime() , "currentLocation" :  self.userObj1?.value(forKey: "geoLocation")  as? String ?? "" ,"eventName" :  "CropMaster_Success_Request" , "moduleType" : "CropAdvisory","deviceType" : "iOS" , "Mobile_Number" : self.userObj1?.value(forKey: "mobileNumber")  as? String ?? "" ,"screen_name" :  "CASubscriptionFilterViewController" , "User_Id" :  self.userObj1?.value(forKey: "customerId")  as? String ?? ""]
                
                self.registerFirebaseEvents("CropMaster_Success_Request", "", "", "CASubscriptionFilterViewController", parameters: params as NSDictionary)
                
                self.cropsArray.removeAllObjects()
                //  let dicP = subscriptionArray.object(forKey: "crops") as? NSArray ?? []
                let dicP = responseArray?.value(forKey: "crops") as? NSArray ?? []
                for i in 0..<dicP.count{
                    let cropListDict = CropControllerBO(dict: dicP.object(at: i) as! NSDictionary)
                    self.cropsArray.add(cropListDict)
                }
                self.cropsArray = NSMutableArray(array:dicP )
                print(dicP)
                if( self.cropsArray.count>0){
                    self.cropAnalysisCollView.reloadData()
                    // self.lbl_noCropsHint.isHidden = true
                    self.cropAnalysisCollView.isHidden = false
                }
                else{
                    // self.lbl_noCropsHint.isHidden = false
                    self.cropAnalysisCollView.isHidden = true
                    self.view.makeToast("No records")
                }
            }
            else{
                //        CoreDataManager.shared.addLogEvent(UserID: self.userObj1?.value(forKey: "customerId")  as? String ?? "", mobileNumber: self.userObj1?.value(forKey: "mobileNumber")  as? String ?? "", screenName: "CASubscriptionFilterViewController", eventName: "CropMaster_Something_Wrong", eventType: "onRequest",captureTime:self.getCurrentDateAndTime(), currentLocation: "0.0,0.0", moduleType: "CropAdvisory")
                //
                let params  = ["capturedtime" : self.getCurrentDateAndTime() , "currentLocation" :  self.userObj1?.value(forKey: "geoLocation")  as? String ?? "" ,"eventName" :  "CropMaster_Something_Wrong" , "moduleType" : "CropAdvisory","deviceType" : "iOS" , "Mobile_Number" : self.userObj1?.value(forKey: "mobileNumber")  as? String ?? "" ,"screen_name" :  "CASubscriptionFilterViewController" , "User_Id" :  self.userObj1?.value(forKey: "customerId")  as? String ?? ""]
                
                self.registerFirebaseEvents("CropMaster_Something_Wrong", "", "", "CASubscriptionFilterViewController", parameters: params as NSDictionary)
                
                
                // self.lbl_noCropsHint.isHidden = false
                self.cropAnalysisCollView.isHidden = true
                print("No records")
            }
        }
        self.getSubscribeduserDetailsMaster()
    }
    
    //MARK:- GET SUBSCRIBED USER DATA DETAILS
    public  func getSubscribeduserDetailsMaster(){
        headers  = ["deviceToken": userObj1?.value(forKey: "deviceToken") as? String ?? "",
                    "userAuthorizationToken": userObj1?.value(forKey: "userAuthorizationToken")  as? String ?? "",
                    "mobileNumber": userObj1?.value(forKey: "mobileNumber")  as? String ?? "",
                    "customerId": userObj1?.value(forKey: "customerId")  as? String ?? "",
                    "deviceId": userObj1?.value(forKey: "deviceId")  as? String ?? ""]
        
        BaseClass.getCASubscribeduserDetails(dic : [:], headers : headers) { (status, responseArray,message) in
            if status == true{
                self.subscriptionArray.removeAllObjects()
                //  let dicP = subscriptionArray.object(forKey: "crops") as? NSArray ?? []
                let dicP = responseArray?.value(forKey: "subscribedDetails") as? NSArray ?? []
                for i in 0..<dicP.count{
                    let cropListDict: CASubscribedUserListBO = CASubscribedUserListBO(dict: dicP.object(at: i) as? NSDictionary ?? [:])
                    self.subscriptionArray.add(cropListDict)
                    
                }
                // self.subscriptionArray = NSMutableArray(array:dicP )
                print(dicP)
                if( self.subscriptionArray.count>0){
                    self.subscribedViewHeightConstraint.constant = 223
                    
                    self.subscriptionCollection.isHidden = false
                    self.subscriptionCollection.reloadData()
                }
                else{
                    self.subscriptionCollection.isHidden = true
                    self.subscribedViewHeightConstraint.constant = 0.0
                    self.view.makeToast("No records")
                }
                
                //                self.view.layoutIfNeeded()
                //                self.view.updateConstraintsIfNeeded()
            }
            else{
                print("No records")
            }
            let params =  ["data": ""]
            self.requestToGetCropAdvisoryData(Params: params as [String:String])
        }
        
    }
    
    //MARK:- ADD SUBSCRIPTION
    public  func submitSubscribeduserDetails(){
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let date = dateFormatter.date(from: cistomView.dateOfSowingTF.text ?? "")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strDateToServer = dateFormatter.string(from: date!)
        
        
        let dic : NSDictionary = ["crop" : cropID ,
                                  "sowingDate" : strDateToServer ,
                                  "acressowed" : cistomView.noOfAcresTxtField.text ?? "" ,
                                  "cropTypeId" : cropTypeId ,
                                  "hybrid" : hybridID ]
        
        headers  = ["deviceToken": userObj1?.value(forKey: "deviceToken") as? String ?? "",
                    "userAuthorizationToken": userObj1?.value(forKey: "userAuthorizationToken")  as? String ?? "",
                    "mobileNumber": userObj1?.value(forKey: "mobileNumber")  as? String ?? "",
                    "customerId": userObj1?.value(forKey: "customerId")  as? String ?? "",
                    "deviceId": userObj1?.value(forKey: "deviceId")  as? String ?? ""]
        
        
        BaseClass.newCASubscription(dic : dic, headers : headers) { (status, responseArray,message) in
            if status == true{
                self.clearTextFields()
                //self.view.makeToast("Subscribed Succesfully")
                self.getSubscribeduserDetailsMaster()
            }
            else{
                print("No records")
            }
        }
    }
    
    
    
    //MARK: requestToGetCropAdvisoryData
    /**
     This method is used to get the crop advisory data from server
     - Parameter Params: [String:String]
     */
    func requestToGetCropAdvisoryData (Params : [String:String]){
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,CA_GET_MASTER_ADD_SUBSCRIPTION_DROPDOWN_V2])
        let userObj =  userObj1 //Constatnts.getUserObject()
        print(headers)
        Alamofire.request(urlString, method: .post, parameters: Params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                print(response)
                
                if let json = response.result.value {
                    
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                    if responseStatusCode == STATUS_CODE_200{
                          self.isCropsSubscriptionAvailable = true
                        let respData = (json as? NSDictionary)?.value(forKey: "response") as? NSString ?? ""
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        // print("Response after decrypting data:\(decryptData)")
                        
                        if let categoriesArray = decryptData.value(forKey: "cropSubType") as? NSArray{
                            let categoryNamesSet =  NSSet(array:categoriesArray as! [Any])
                            self.categoryArray = categoryNamesSet.allObjects as NSArray
                            //self.categoryNamesArray.addObjects(from: categoriesArray as! [Any])
                            self.categoryNamesArray.addObjects(from: categoryNamesSet.allObjects)
                        }
                        if let statesArray = decryptData.value(forKey: "stateCodeMaster") as? NSArray{
                            let statesNamesSet =  NSSet(array:statesArray as! [Any])
                            self.stateArray = statesNamesSet.allObjects as NSArray
                            self.stateNamesArray.addObjects(from: statesNamesSet.allObjects)
                        }
                        if let cropsArray = decryptData.value(forKey: "cropMaster") as? NSArray{
                            let cropsNamesSet =  NSSet(array:cropsArray as! [Any])
                            self.cropArray = cropsNamesSet.allObjects as NSArray
                            self.cropNamesArray.addObjects(from: cropsNamesSet.allObjects)
                        }
                        if let hybridsArray = decryptData.value(forKey: "hybridMaster") as? NSArray{
                            let hybridNamesSet =  NSSet(array:hybridsArray as! [Any])
                            self.hybridArray = hybridNamesSet.allObjects as NSArray
                            self.hybridNameArray.addObjects(from: hybridNamesSet.allObjects)
                        }
                        if let seasonsArray = decryptData.value(forKey: "seasonMaster") as? NSArray{
                            let seasonNamesSet =  NSSet(array: seasonsArray as! [Any])
                            self.seasonArray = seasonNamesSet.allObjects as NSArray
                            self.seasonNamesArray.addObjects(from: seasonNamesSet.allObjects)
                        }
                        /*  DispatchQueue.main.async {
                         if self.isFromDeeplink == true{
                         self.updateDeepLinkParametersToUI()
                         }
                         else{
                         self.updateUI()
                         }
                         }*/
                    }
                    else if responseStatusCode == CROP_ADVISORY_NOT_AVAILABLE_151{
                          self.isCropsSubscriptionAvailable = false
                        //                        self.contentView.isHidden = true
                        //                        self.btnSubmit.isHidden = true
                        //                        self.lblNoDataAvailable.isHidden = false
                        //                        self.lblNoDataAvailable.text = (json as! NSDictionary).value(forKey: "message") as? String
                    } else if responseStatusCode == STATUS_CODE_105{
                        self.isCropsSubscriptionAvailable = false
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    else if responseStatusCode == STATUS_CODE_601{
                        self.isCropsSubscriptionAvailable = false
                        Constatnts.logOut()
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    }
                }
            }
            else{
                self.isCropsSubscriptionAvailable = false
                //self.view.makeToast((response.error?.localizedDescription)!)
            }
        }
    }
    
    
    //MARK: filterCropsWithCategoryAndState
    /**
     This method is used to filter the Crops Array with categoryID and stateID
     - Parameter categoryDic: NSDictionary?
     - Parameter stateDic: NSDictionary?
     */
    func filterCropsWithCategoryAndState(categoryDic: NSDictionary?, stateDic: NSDictionary?){
        if categoryDic != nil && stateDic != nil {
            categoryID = categoryDic!.value(forKey: "id") as? String as NSString? ?? ""
            stateID = stateDic!.value(forKey: "id") as! String as NSString
            let cropPredicate = NSPredicate(format: "(cropId == %@) AND ",categoryID)
            let cropFilteredArr = (self.cropArray).filtered(using: cropPredicate) as NSArray
            
            if cropFilteredArr.count > 0{
                
                if let cropDic = cropFilteredArr.firstObject as? NSDictionary{
                    self.cropNamesArray.removeAllObjects()
                    self.cropNamesArray.addObjects(from: cropFilteredArr as! [Any])
                    cistomView.cropTF.text = cropDic.value(forKey: "name") as? String
                    cropID = cropDic.value(forKey: "id") as! String as NSString
                    self.filterHybridWithCategoryAndStaeAndCrop(categoryDic: categoryDic,  cropDic: cropDic)
                }
            }
        }
    }
    
    //MARK: filterStatesWithCategory
    /**
     This method is used to filter the States Array with categoryID
     - Parameter categoryDic: NSDictionary?
     */
    func filterStatesWithCategory(categoryDic: NSDictionary?){
        if categoryDic != nil {
            categoryID = categoryDic?.value(forKey: "cropId") as? String as NSString? ?? ""
            //state
            
            cropTypeId = categoryDic?.value(forKey: "cropTypeId") as? String as NSString? ?? ""
            let statePredicate = NSPredicate(format: "cropId = %@",categoryID)
            let stateFilteredArr = (self.categoryArray).filtered(using: statePredicate) as NSArray
            
            //print("state data array : \(stateFilteredArr)")
            if stateFilteredArr.count > 0{
                self.categoryNamesArray.removeAllObjects()
                let statesNamesSet =  NSSet(array:stateFilteredArr as! [Any])
                // self.categoryArray = statesNamesSet.allObjects as NSArray
                self.categoryNamesArray.addObjects(from: statesNamesSet.allObjects)
                
                
               // self.categoryDropDownTblView.reloadData()
                if categoryNamesArray.count > 0{
                    let categoryDic = categoryNamesArray.object(at: 0) as? NSDictionary
                    cistomView.categoryTxtFld.text =  categoryDic?.value(forKey: "cropSubTypeName") as? String
                    categoryID = categoryDic?.value(forKey: "cropId") as? String as NSString? ?? ""
                    cropTypeId = categoryDic?.value(forKey: "cropTypeId") as? String as NSString? ?? ""
                    
                }
            }
        }
    }
    
    //MARK: filterHybridWithCategoryAndStaeAndCrop
    /**
     This method is used to filter the Hybrids Array with categoryID,stateID and cropID
     - Parameter categoryDic: NSDictionary?
     - Parameter stateDic: NSDictionary?
     - Parameter cropDic: NSDictionary?
     */
    func filterHybridWithCategoryAndStaeAndCrop(categoryDic: NSDictionary?, cropDic: NSDictionary?){
        if categoryDic != nil  && cropDic != nil {
            categoryID = categoryDic?.value(forKey: "id") as? String as NSString? ?? ""
            //stateID = stateDic!.value(forKey: "id") as! String as NSString
            cropID = cropDic?.value(forKey: "id") as? String as NSString? ?? ""
            let hybridPredicate = NSPredicate(format: "(cropId == %@)",cropID)
            let hybridFilterArray = self.hybridArray.filtered(using: hybridPredicate)
            if hybridFilterArray.count > 0{
                self.hybridNameArray.removeAllObjects()
                self.hybridNameArray.addObjects(from: hybridFilterArray)
                if let hybridDic = hybridNameArray.firstObject as? NSDictionary{
                    cistomView.hybridTf.text = hybridDic.value(forKey: "name") as? String
                    hybridID = hybridDic.value(forKey: "id") as? String as NSString? ?? ""
                    // self.hybrid_dropDownTable.reloadData()
                    self.filterSeasonWithCategoryAndStaeAndCropAndHybrid(categoryDic: categoryDic,  cropDic: cropDic, hybridDic: hybridDic)
                    
                }
            }
        }
    }
    
    //MARK: filterSeasonWithCategoryAndStaeAndCropAndHybrid
    /**
     This method is used to filter the Hybrids Array with categoryID,stateID,cropID and hybridID
     - Parameter categoryDic: NSDictionary?
     - Parameter stateDic: NSDictionary?
     - Parameter cropDic: NSDictionary?
     - Parameter hybridDic: NSDictionary?
     */
    func filterSeasonWithCategoryAndStaeAndCropAndHybrid(categoryDic: NSDictionary?, cropDic: NSDictionary?,hybridDic: NSDictionary?){
        if categoryDic != nil  && cropDic != nil && hybridDic != nil {
            categoryID = categoryDic?.value(forKey: "cropId") as? String as NSString? ?? ""
            
            cropID = cropDic?.value(forKey: "id") as? String as NSString? ?? ""
            //   hybridID = hybridDic!.value(forKey: "id") as! String as NSString
            let seasonPredicate = NSPredicate(format: "(cropId == %@)  ",cropID)//AND (cropTypeId == %@) //,hybridID
            let seasonFilteredArr = (self.hybridArray).filtered(using: seasonPredicate)
            // print("season data array : \(seasonFilteredArr)")
            if seasonFilteredArr.count>0 {
                self.hybridNameArray.removeAllObjects()
                
                let hybridNamesSet =  NSSet(array:seasonFilteredArr )
                self.hybridNameArray.addObjects(from: hybridNamesSet.allObjects)
                
                if let seasonDic = self.hybridNameArray.firstObject as? NSDictionary{
                    
                    self.seasonStartDateStr = seasonDic.value(forKey: "startDate") as? String ?? ""
                    if let startDate = FarmServicesConstants.getDateStringFromDateStringWithShortFormat(serverDate: self.seasonStartDateStr) as String?{
                        //getDateStringFromDateStringWithNormalFormat
                        cistomView.dateOfSowingTF.text = startDate
                    }
                    self.seasonEndDateStr = seasonDic.value(forKey: "endDate") as? String ?? ""
                }
            }
        }
    }
    
}
