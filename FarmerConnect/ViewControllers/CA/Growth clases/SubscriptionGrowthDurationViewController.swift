

//
//  SubscriptionGrowthDurationViewController.swift
//  FarmerConnect
//
//  Created by Apple on 05/11/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import UIKit
import Alamofire
open class SubscriptionGrowthDurationViewController: BaseViewController{
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var bgImage:  UIImageView!
    var SelectedPhaseString = "Vegetative Phase"
    @IBOutlet weak var cropCollectionview: UICollectionView!
    
    var crop_dropDownTable : UITableView!
    var hybrid_dropDownTable : UITableView!
    var categoryDropDownTblView : UITableView!
    var stateDropDownTblView = UITableView()
    var seasonTblView = UITableView()
    
    var isFromSideMenu = false
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var subscribeCropdateLbl: UILabel!
    @IBOutlet weak var cropHybridLbl: UILabel!
    @IBOutlet weak var subscribeCropNameLbl: UILabel!
    var SelectedCropString =  "Direct Seeded Rice"
    @IBOutlet weak var growthDurationLable: UILabel!
    
    @IBOutlet weak var subscribeInfoLbl: UILabel!
    @IBOutlet weak var subscribeInfoBgView: UIView!
    var cistomView = SubscriptionCreatePop()
    var cropCustomView = CropSubscriptionDetailView()
    var alertView_Bg: UIView!// : UIView!
    var alertController = UIAlertController()
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
    var cropPhaseID = NSString()//
    
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
    var subscriptionArray = NSMutableArray()
    var currentIndex = 0
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var phaseArrayCollection = NSMutableArray()
    var categoryDic = NSMutableDictionary()
    var globalWidth = CGFloat(0.0)
    
    var cropPahseId = NSString()
    var subPhaseId = NSString()
    
    var subPhaseCollectionView = UICollectionView(frame: .zero , collectionViewLayout: UICollectionViewFlowLayout())
    var subsPhaseArray = NSMutableArray()
    
    // subscribeCall
    var noOfAcress = ""
    var registrationSuccessAlert: UIView?
    var isSubscribeduser = false
    var isfromSubscriptionTap = false
    
    var selectedSubscription = NSMutableArray()
    var subDetailedScreenArray = NSMutableArray()
    var csStageSelected = ""
    let modelName = UIDevice.current.modelName
    var userObj1 = NSMutableDictionary()
    
    var frameworkBundle:Bundle? {
        let bundleId = "empover.CropAdvisoryFramework"
        return Bundle(identifier: bundleId)
    }
    
    //MARK:- VIEW DID LOAD
    /**
     - Hanlded view landscape orientation
     */
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        // layout.itemSize = CGSize(width: 111, height: 111)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true
//         CoreDataManager.shared.addLogEvent(UserID: self.userObj1.value(forKey: "customerId")  as? String ?? "", mobileNumber: self.userObj1.value(forKey: "mobileNumber")  as? String ?? "", screenName: "SubscriptionGrowthDurationViewController", eventName: "CropType_Selection_Load", eventType: "PageLoad",captureTime:self.getCurrentDateAndTime(), currentLocation: "0.0,0.0", moduleType: "CropAdvisory")
        
        let parameters  = ["capturedtime" : self.getCurrentDateAndTime() , "currentLocation" :  self.userObj1.value(forKey: "geoLocation")  as? String ?? "" ,"eventName" :  "CropType_Selection_Load" , "moduleType" : "CropAdvisory","deviceType" : "iOS" , "Mobile_Number" : self.userObj1.value(forKey: "mobileNumber")  as? String ?? "" ,"screen_name" :  "SubscriptionGrowthDurationViewController" , "User_Id" :  self.userObj1.value(forKey: "customerId")  as? String ?? ""] as [String : Any]
                                                  
        self.registerFirebaseEvents("CropType_Selection_Load", "", "", "SubscriptionGrowthDurationViewController", parameters: parameters as NSDictionary)
        
        
        loadVIewdidInitialCornerView()
        
        if modelName ==  "iPhone X" ||  modelName ==  "iPhone XS" || modelName ==  "iPhone XS Max" || modelName ==  "iPhone XR"{
            bgImage.contentMode = .scaleToFill
            print(bgImage.frame )
            DispatchQueue.main.async {
                var labelFrame : CGRect = self.bgImage.frame
                labelFrame.size.height = self.bgImage.frame.height + 40
                self.bgImage.frame = labelFrame
            }
            print(bgImage.frame )
        }
        else{
            bgImage.contentMode = .scaleAspectFit
        }
        
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            self.getMainPhasePriginalImagesMaster()
            let params =  ["data": ""]
            self.requestToGetCropAdvisoryData(Params: params as [String:String])
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
    }
    
    
    
    public func loadVIewdidInitialCornerView(){
        subscribeInfoBgView.layer.cornerRadius = 10.0
        subscribeInfoBgView.layer.borderWidth = 0.5
        subscribeInfoBgView.layer.borderColor = UIColor.blue.cgColor
        cropHybridLbl.roundCorners([.layerMinXMinYCorner, .layerMaxXMaxYCorner], radius: 1.0, borderColor: UIColor.blue, borderWidth: 0.5)
    }
    
    
    //MARK:- ORIENTATION SET
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape //|| .landscapeRight
    }
    
    override open var shouldAutorotate: Bool {
        return true
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        self.topView?.frame = frame
        
        UIApplication.shared.isStatusBarHidden = false
    }
    
    override open var prefersStatusBarHidden: Bool {
        return true
    }
//    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
        
        self.topView?.isHidden = false
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .landscapeRight
        
        
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft{
            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            
        }
        else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight{
            let value = UIInterfaceOrientation.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
            
        else{
            self.forcelandscapeLeft()
        }
        
        // Post a notification
        //  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setLandscape"), object: ["orientation" : "Land"], userInfo: nil)
        
        
        var defaults = UserDefaults.standard
        defaults.set(true, forKey: "Landscape")
        defaults.synchronize()
        
        if self.topView?.frame.width ?? 0 < self.view.frame.height{
            let frame = CGRect(x: 0, y: 0, width: self.view.frame.height, height: 50)
            self.topView?.frame = frame
            
//
//            let shareButton = UIButton(frame: CGRect(x:UIScreen.main.bounds.size.width-60,y: 0,width: 50,height: 50))
//            shareButton.backgroundColor =  UIColor.clear
//            shareButton.setImage( UIImage(named: "subscribeHand"), for: UIControl.State())
//            shareButton.addTarget(self, action: #selector(SubscriptionGrowthDurationViewController.addSubscriptionAction(_:)), for: UIControl.Event.touchUpInside)
//            self.topView?.addSubview(shareButton)
        }
        globalWidth = self.topView?.frame.width ?? 0
        print(self.view.frame)
        self.lblTitle?.text = SelectedCropString
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
    }

    @objc  func deviceDidRotate(){
        
    }
    
    // @objc func backButtonClick(_ sender: UIButton){
    
    
    // MARK:- HANDLED VIEW ORIENTATION --------- //
    /*
     - Hanlded view to Portrait orientation
     -
     */
    override func backButtonClick(_ sender: UIButton) {
       
            
            var defaults = UserDefaults.standard
            defaults.set(false, forKey: "Landscape")
            defaults.synchronize()
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.myOrientation = .portrait
            
            forceOrientationPortrait()
          
            self.navigationController?.popViewController(animated: false)
            if isFromSideMenu == true{
                self.navigationController?.popViewController(animated: true)
            }
            else{
                self.navigationController?.popViewController(animated: true)
            }
        
    }
    
    @objc func forcelandscapeLeft() {
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    @objc func forceOrientationPortrait() {
        //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //        appDelegate.myOrientation = .portrait
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        var defaults = UserDefaults.standard
        defaults.set(false, forKey: "Landscape")
        defaults.synchronize()
    }
    
    //MARK:- TOP SUBSCRIPTION BUTTON PREV AND NEXT ACTIONS
    @IBAction func subscribeDetailActionTap(_ sender: Any) {
        
        //CHANGE SELECTED CROP OT BELOW COLLETION VIEW
        
    }
    
    //MARK:- SUBSCRIPTION PREVIOS AND NEXT OBJECT
    @IBAction func nextAction(_ sender: Any) {
        if currentIndex >= 0 && currentIndex < subscriptionArray.count - 1  {
            currentIndex = currentIndex + 1
            let dic = subscriptionArray.object(at: currentIndex) as? NSDictionary ?? [:]
            subscribeCropNameLbl.text = dic.value(forKey: "cropName") as? String
            cropHybridLbl.text = dic.value(forKey: "CropHybdid") as? String
            subscribeCropdateLbl.text = dic.value(forKey: "cropDate") as? String
            subscribeInfoLbl.text = String(format: "Subscribe \(currentIndex + 1)/\(subscriptionArray.count)")
        }
    }
    @IBAction func previousAction(_ sender: Any) {
        if currentIndex != 0 && currentIndex <= subscriptionArray.count - 1{
            currentIndex = currentIndex - 1
            let dic = subscriptionArray.object(at: currentIndex) as? NSDictionary ?? [:]
            subscribeCropNameLbl.text = dic.value(forKey: "cropName") as? String
            cropHybridLbl.text = dic.value(forKey: "CropHybdid") as? String
            subscribeCropdateLbl.text = dic.value(forKey: "cropDate") as? String
            subscribeInfoLbl.text = String(format: "Subscribe \(currentIndex + 1)/\(subscriptionArray.count)")
            
        }
    }
    
    //MARK:- SHOW POP UP WINDOW TO ADD SUBSCRIPTION
    public  func showAddSubscriptionWindow(){
       // let appDelegate = UIApplication.shared.delegate as! CropAdvisoryAppDelegate
        
//        self.topView?.isHidden = true
        if alertView_Bg != nil{
          alertView_Bg.removeFromSuperview()
        }
        
        //   let appde = CropAdvisoryAppDelegate()
        alertView_Bg = UIView (frame: CGRect(x: 0,y: 0 ,width: self.view.frame.size.width,height: self.view.frame.size.height ))
        alertView_Bg.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        self.view.addSubview(alertView_Bg)
      // appDelegate.window!.addSubview(alertView_Bg)
        
        
        let alertView: UIView = UIView (frame: CGRect(x: self.view.frame.size.width/2 - self.view.frame.size.width/4 - 35, y:  20 ,width:self.view.frame.size.width/2 + 80 ,height: 295))
        alertView.backgroundColor = .white//UIColor(red: 232.0/255, green: 247.0/255, blue: 248.0/255, alpha: 1.0)
        alertView.layer.cornerRadius = 10.0
        alertView_Bg.addSubview(alertView)
        // self.view.addSubview(alertView_Bg)
        
        cistomView.frame = CGRect(x: 0, y:  0 ,width: alertView.frame.size.width ,height: alertView.frame.size.height  )
        cistomView.backgroundColor = .clear
        alertView.addSubview(cistomView)
        
        alertView.roundCorners([.layerMinXMaxYCorner,.layerMaxXMaxYCorner,.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 10.0, borderColor: UIColor.clear, borderWidth: 1)
        cistomView.exitBtn.addTarget(self, action: #selector(SubscriptionGrowthDurationViewController.closeTapped1(_:)), for: .touchUpInside)
        cistomView.SubscribeBtn.addTarget(self, action: #selector(SubscriptionGrowthDurationViewController.SubscribeTapped1(_:)), for: .touchUpInside)
        
        cistomView.cropTF.delegate         = self
        cistomView.hybridTf.delegate       = self
        cistomView.dateOfSowingTF.delegate = self
        cistomView.noOfAcresTxtField.delegate = self
        cistomView.categoryTxtFld.delegate = self
    }
    
    // -------------------------------------- //
    // MARK: - Show PREVIEW when phase selected
    // ------------------------------------- //
    
    public  func showPreviewDetailsOfSelected(img : String)//obj : ComplaintStatus
    {
        
        
        
        // let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let width :CGFloat = self.view.frame.width - 80
        alertView_Bg = UIView (frame: CGRect(x: 0,y: 0 ,width: self.view.frame.size.width,height: self.view.frame.size.height ))
        alertView_Bg.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        self.view.addSubview(alertView_Bg)
        
        let alertView: UIView = UIView (frame: CGRect(x: 40, y:  50 ,width: width + 6 ,height: self.view.frame.size.height - 60))
        alertView.backgroundColor = UIColor(red: 232.0/255, green: 247.0/255, blue: 248.0/255, alpha: 1.0)
        alertView.layer.cornerRadius = 2.0
        alertView_Bg.addSubview(alertView)
        
        // let cistomView = CropSubscriptionDetailView()
        cropCustomView.frame = CGRect(x: 0, y:  10 ,width: width + 6,height: self.view.frame.size.height - 60)
        alertView.addSubview(cropCustomView)
        cropCustomView.CropImage.isHidden = false
        
        //        DispatchQueue.main.async {
        //            var labelFrame : CGRect = cistomView.CropImage.frame
        //            labelFrame.size.height = cistomView.CropImage.height + 40
        //            self.bgImage.frame = labelFrame
        //        }
        // cistomView.CropImage.layer.borderWidth = 10.0
        //  let modelName = UIDevice.current.modelName
        if modelName ==  "iPhone X" ||  modelName ==  "iPhone XS" || modelName ==  "iPhone XS Max" || modelName ==  "iPhone XR"{
            cropCustomView.CropImage.contentMode = .scaleAspectFit
        }
        else{
            cropCustomView.CropImage.contentMode = .scaleAspectFit
        }
        
        
        let url = URL(string:img as? String ?? "")
        
        cropCustomView.CropImage.kf.setImage(with : url, placeholder: UIImage(named:"image_placeholder.png"))
        
        
        //  cropCustomView.CropImage.kf.setImage(with: url , placeholder: UIImage(named:"image_placeholder.png"), options: nil, progressBlock: nil, completionHandler: nil)
        
        cropCustomView.phaseTitleLbl.text = SelectedPhaseString
        cropCustomView.backgroundColor = .clear
        cropCustomView.cornerRadius = 2.0
        cropCustomView.bringSubview(toFront: cropCustomView.closeBtn)
        cropCustomView.closeBtn.addTarget(self, action: #selector(SubscriptionGrowthDurationViewController.closeTapped(_:)), for: .touchUpInside)
        // cistomView.PlayBtn.addTarget(self, action: #selector(SubscriptionGrowthDurationViewController.PreviewBottomTapped(_:)), for: .touchUpInside)
        
        var frame = CGRect(x: 40, y: 0, width: cropCustomView.frame.width -  85, height: cropCustomView.frame.height - 25 )
        
        
        if modelName ==  "iPhone X" ||  modelName ==  "iPhone XS" || modelName ==  "iPhone XS Max" || modelName ==  "iPhone XR"{
            
            frame = CGRect(x: 90, y: 0, width: cropCustomView.frame.width -  180, height: cropCustomView.frame.height - 25 )
        }
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.collectionViewLayout = layout
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(collectionView)
        self.subPhaseCollectionView = collectionView
        subPhaseCollectionView.backgroundColor = UIColor.clear
        subPhaseCollectionView.delegate   = self
        // subPhaseCollectionView.backgroundColor = .red
        subPhaseCollectionView.dataSource = self
        
        //   let nib = UINib(nibName: "CropSubStageCollectionViewCell", bundle: nil).instantiate(withOwner: "CropSubStageCollectionViewCell", options: nil)
        //  self.subPhaseCollectionView.register(UINib(nibName: "CropSubStageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CropSubStageCollectionViewCell")
        
        //        self.subPhaseCollectionView.register(UINib(nibName: "CropSubStageCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CropSubStageCollectionViewCell")
//        CoreDataManager.shared.addLogEvent(UserID: self.userObj1.value(forKey: "customerId")  as? String ?? "", mobileNumber: self.userObj1.value(forKey: "mobileNumber")  as? String ?? "", screenName: "SubscriptionGrowthDurationViewController", eventName: "CropStage_Dialog", eventType: "PageLoad",captureTime:self.getCurrentDateAndTime(), currentLocation: "0.0,0.0", moduleType: "CropAdvisory")
        
        let parameters  = ["capturedtime" : self.getCurrentDateAndTime() , "currentLocation" :  self.userObj1.value(forKey: "geoLocation")  as? String ?? "" ,"eventName" :  "CropStage_Dialog" , "moduleType" : "CropAdvisory","deviceType" : "iOS" , "Mobile_Number" : self.userObj1.value(forKey: "mobileNumber")  as? String ?? "" ,"screen_name" :  "SubscriptionGrowthDurationViewController" , "User_Id" :  self.userObj1.value(forKey: "customerId")  as? String ?? ""] as [String : Any]
                                                         
               self.registerFirebaseEvents("CropStage_Dialog", "", "", "SubscriptionGrowthDurationViewController", parameters: parameters as NSDictionary)
        
        
        subPhaseCollectionView.reloadData()
        
    }
    
    
    //MARK:- NAVIGATE TO DETAILS PHASE NAVIGATION ON PLAYBTN ACTION CALL
    @objc func  PreviewBottomTapped ( _ sender : UIButton){
        alertView_Bg.removeFromSuperview()
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "cropadvisorySub",bundle: nil)
        let viewContro = mainStoryboard.instantiateViewController(withIdentifier: "CropDetailsPhaseViewController") as? CropDetailsPhaseViewController
        viewContro?.userObj = self.userObj1
        viewContro?.isFromSideMenu = false
        viewContro?.cropType = self.cropTypeId as String
        viewContro?.cropID = self.cropID as String
        viewContro?.cropPhaseID = self.cropPhaseID as String
        self.navigationController?.pushViewController(viewContro!, animated: true)
    }
    
    
    @objc func closeTapped ( _ sender : UIButton){
        subPhaseCollectionView.removeFromSuperview()
        alertView_Bg.removeFromSuperview()
//        self.topView?.isHidden = false
        
    }
    
    //MARK:- SUBSCRIPTION BUTTON ACTION TAPPED
    @objc func SubscribeTapped1 ( _ sender : UIButton){
        
        print(cistomView.cropTF.text ?? "0")
        print(cistomView.hybridTf.text ?? "0")
        print(cistomView.dateOfSowingTF.text ?? "0")
        
        
        //  let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            if Validations.isNullString(cistomView.cropTF.text as NSString? ?? "" as NSString) {
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
            //self.topView?.isHidden = false
            /*     let dateFormatter: DateFormatter = DateFormatter()
             dateFormatter.dateFormat = "dd-MMM-yyyy"
             let date = dateFormatter.date(from: cistomView.dateOfSowingTF.text ?? "")
             dateFormatter.dateFormat = "yyyy-MM-dd"
             let strDateToServer = dateFormatter.string(from: date!)
             print(strDateToServer)
             let userObj = Constants.getUserObject()
             let parameters = ["customerId":userObj.customerId! as String,
             "category":categoryID as String,
             "state":stateID as String,
             "crop":cropID as String,
             "hybrid":hybridID as String,
             "season":seasonID as String,
             "sowingDate":strDateToServer,
             "acressowed":noOfAcress] as NSDictionary
             print(parameters)
             let paramsStr = Constants.nsobjectToJSON(parameters as NSDictionary)
             let params =  ["data" : paramsStr]
             print(params)
             let userObj = Constants.getUserObject()
             self.requestToRegisterCropAdvisoryData(params: params as [String:String])
             let fireBaseParams = [MOBILE_NUMBER : userObj.mobileNumber!,USER_ID : userObj.customerId!,CROP:cistomView.cropTF.text ?? "",SEASON:seasonID,HYBRID:cistomView.hybridTf.text ?? "0",STATE: stateID,ACERS_SOWED:noOfAcress] as [String : Any]
             self.registerFirebaseEvents(CA_Submit, "", "", "", parameters: fireBaseParams as NSDictionary)
             }
             else{
             self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
             */ }
        
        self.registerFirebaseEvents("SubscriptionGrowthDuration", "", "", "", parameters: nil )
    }
    
    
    
    @objc func infoAlertSubmit(){
        if self.registrationSuccessAlert != nil {
            self.registrationSuccessAlert?.removeFromSuperview()
            self.registrationSuccessAlert = nil
        }
    }
    
    @objc func closeTapped1 ( _ sender : UIButton){
        clearSubscriptionPopFeilds()
        alertView_Bg.removeFromSuperview()
        // self.topView?.isHidden = false
        
    }
    
    func clearSubscriptionPopFeilds(){
        cistomView.cropTF.text = ""
        cistomView.categoryTxtFld.text = ""
        cistomView.hybridTf.text = ""
        cistomView.dateOfSowingTF.text = ""
        cistomView.noOfAcresTxtField.text = ""
        
    }
    @IBAction func addSubscriptionAction(_ sender: Any) {
        // cropCollectionview.reloadData()
        showAddSubscriptionWindow()
    }
    
}


//MARK:- COLLECTIONVIEW DELEGATE METHODS
extension SubscriptionGrowthDurationViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cropCollectionview
        {
            return phaseArrayCollection.count
        }
        else{
            return  subsPhaseArray.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if modelName ==  "iPhone X" ||  modelName ==  "iPhone XS" || modelName ==  "iPhone XS Max" || modelName ==  "iPhone XR"{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
    }
    
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //        if collectionView == phaseArrayCollection {
    //            return -10
    //        }else{
    //            return 0
    //        }
    //
    //    }
    public func collectionView(_ collectionView: UICollectionView,
                               willDisplay cell: UICollectionViewCell,
                               forItemAt indexPath: IndexPath) {
        
        cell.alpha = 0
        UIView.animate(withDuration: 0.8) {
            cell.alpha = 1
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == cropCollectionview{
            let cell: CA_CropCollectionViewCell = cropCollectionview.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CA_CropCollectionViewCell
            
            
            
            return cell
        }
        else
        {
            
            print("CropSubStageCollectionViewCell 1")
            
            let bundle1 = Bundle(for: type(of: self))
            subPhaseCollectionView.register(UINib.init(nibName: "CropSubStageCollectionViewCell", bundle: Bundle(for: CropSubStageCollectionViewCell.self)), forCellWithReuseIdentifier: "CropSubStageCollectionViewCell")
            
            print("CropSubStageCollectionViewCell 2")
            
            
            CropSubStageCollectionViewCell.register(for: subPhaseCollectionView)
            subPhaseCollectionView.register(UINib(nibName: "CropSubStageCollectionViewCell", bundle: frameworkBundle), forCellWithReuseIdentifier: "CropSubStageCollectionViewCell")
            
            
            print("CropSubStageCollectionViewCell 3")
            
            //            let cell : CropSubStageCollectionViewCell = subPhaseCollectionView.dequeueReusableCell(withReuseIdentifier: "CropSubStageCollectionViewCell", for: indexPath) as! CropSubStageCollectionViewCell
            
            let cell : CropSubStageCollectionViewCell = subPhaseCollectionView.dequeueReusableCell(withReuseIdentifier: "CropSubStageCollectionViewCell", for: indexPath) as! CropSubStageCollectionViewCell
            
            
            
            
            print("CropSubStageCollectionViewCell 4")
            // let objBo : GrowthCASubPhasesNew = phaseArrayCollection.object(at: indexPath.row) as! GrowthCASubPhasesNew
            //  SelectedPhaseString = objBo.cropSubPhase as String?  ?? ""
            // showPreviewDetailsOfSelected(img: objBo.cropSubPhaseImgUrl as String? ?? "" )
            // cropPhaseID =  objBo.cropPhaseId   ?? "" as NSString
            // getsubPhasePriginalImagesMaster()
            
            //            if subsPhaseArray.count == 1{
            //                if modelName ==  "iPhone X" ||  modelName ==  "iPhone XS" || modelName ==  "iPhone XS Max" || modelName ==  "iPhone XR"{
            //                    cropCustomView.CropImage.contentMode = .scaleAspectFit
            //                }
            //                else{
            //                    //cropCustomView.CropImage.contentMode = .scaleToFill
            //                }
            //            }
            
            return cell
        }
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //307-width
        
        if collectionView == subPhaseCollectionView {
            
            let widthVar = CGFloat(subPhaseCollectionView.frame.size.width)
            let heightVar = CGFloat(subPhaseCollectionView.frame.size.height)
            
            let obj : GrowthCASubPhasesNew =  subsPhaseArray.object(at: indexPath.row) as! GrowthCASubPhasesNew
            let percentObj:CGFloat   = CGFloat((obj.cropPhasePercentage ?? "0.0").floatValue)
            for i in 0..<subsPhaseArray.count{
                if indexPath.row == i{
                    return CGSize(width:(percentObj*widthVar)/100, height: heightVar)
                }
            }
            
            return CGSize(width: 100, height: 100)
            
        }
        else{
            let heightVar = CGFloat(cropCollectionview.frame.size.height)
            
            let obj : GrowthCASubscriptionsBO =  phaseArrayCollection.object(at: indexPath.row) as! GrowthCASubscriptionsBO
            let percentObj:CGFloat   = CGFloat((obj.cropPhasePercentage ?? "0.0").floatValue)
            
            for i in 0..<phaseArrayCollection.count{
                if indexPath.row == i{
                    // let xObj = Float(percentObj)*Float(globalWidth)
                    if modelName ==  "iPhone X" ||  modelName ==  "iPhone XS" || modelName ==  "iPhone XS Max" || modelName ==  "iPhone XR"{
                        return CGSize(width:(percentObj*(globalWidth - 70))/100, height: heightVar)
                    }else{
                        return CGSize(width:(percentObj*(globalWidth ))/100, height: heightVar)
                    }
                    
                }
            }
            return CGSize(width: 100, height: 100)
        }
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//         CoreDataManager.shared.addLogEvent(UserID: self.userObj1.value(forKey: "customerId")  as? String ?? "", mobileNumber: self.userObj1.value(forKey: "mobileNumber")  as? String ?? "", screenName: "SubscriptionGrowthDurationViewController", eventName: "CropType_Item_Click", eventType: "Click",captureTime:self.getCurrentDateAndTime(), currentLocation: "0.0,0.0", moduleType: "CropAdvisory")
        
        let parameters  = ["capturedtime" : self.getCurrentDateAndTime() , "currentLocation" :  self.userObj1.value(forKey: "geoLocation")  as? String ?? "" ,"eventName" :  "CropType_Item_Click" , "moduleType" : "CropAdvisory","deviceType" : "iOS" , "Mobile_Number" : self.userObj1.value(forKey: "mobileNumber")  as? String ?? "" ,"screen_name" :  "SubscriptionGrowthDurationViewController" , "User_Id" :  self.userObj1.value(forKey: "customerId")  as? String ?? ""] as [String : Any]
                                                            
        self.registerFirebaseEvents("CropType_Item_Click", "", "", "SubscriptionGrowthDurationViewController", parameters: parameters as NSDictionary)
        
        
        
        if collectionView == subPhaseCollectionView{
            
            //            let mainStoryboard: UIStoryboard = UIStoryboard(name: "cropadvisorySub",bundle: nil)
            //            let viewContro = mainStoryboard.instantiateViewController(withIdentifier: "CropDetailsPhaseViewController") as? CropDetailsPhaseViewController
            
            //            let viewControl = BaseClass.loadViewPhase()
            //            viewControl.isFromSideMenu = false
            getsubPhaseDetailedScreen(indexPath.row)
            
        }else{
            let objBo : GrowthCASubscriptionsBO = phaseArrayCollection.object(at: indexPath.row) as! GrowthCASubscriptionsBO
            SelectedPhaseString = objBo.cropPhase as String?  ?? ""
            cropPhaseID =  objBo.cropPhaseId   ?? "" as NSString
            getsubPhaseoriginalImagesMaster()
            
        }
    }
}


//MARK:-  UIVIEW FOR CORNER RADIUS
public extension UIView {
    
    public  func roundCorners(_ corners: CACornerMask, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        self.layer.maskedCorners = corners
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
}

//MARK:- UITABLEVIEW DELEGATE AND DATA SOURCE METHODS
extension SubscriptionGrowthDurationViewController:  UITableViewDelegate,UITableViewDataSource{
    
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
        cell.textLabel?.text = " "
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
            
        }
        
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        if tableView == categoryDropDownTblView {
            let categoryDic = self.categoryNamesArray.object(at: indexPath.row) as? NSDictionary
            categoryID = categoryDic!.value(forKey: "cropId") as? String as NSString? ?? ""
            cistomView.categoryTxtFld.text = categoryDic?.value(forKey: "cropSubTypeName") as? String
            cropTypeId = categoryDic!.value(forKey: "cropTypeId") as? String as NSString? ?? ""
            if categoryDropDownTblView != nil{
                categoryDropDownTblView.isHidden = true
            }
            cistomView.categoryTxtFld.resignFirstResponder()
        }
            
        else if tableView == crop_dropDownTable {
            //get crop id
            let cropDic = self.cropNamesArray.object(at: indexPath.row) as? NSDictionary
            cropID = cropDic?.value(forKey: "id") as? String as NSString? ?? ""
            cistomView.cropTF.text = cropDic?.value(forKey: "name") as? String
            
            let categoryPredicate = NSPredicate(format: "cropName = %@",cropDic?.value(forKey: "name") as? String ?? "")
            let categoryFilterArray = (self.categoryArray).filtered(using: categoryPredicate) as NSArray
            let categoryDic = categoryFilterArray.firstObject as? NSDictionary
            self.filterStatesWithCategory(categoryDic: categoryDic)
            self.filterHybridWithCategoryAndStaeAndCrop(categoryDic: categoryDic,  cropDic: cropDic)
            if crop_dropDownTable != nil{
                crop_dropDownTable.isHidden = true
            }
            cistomView.cropTF.resignFirstResponder()
        }
        else if tableView == hybrid_dropDownTable {
            
            let hybridDic = self.hybridNameArray.object(at: indexPath.row) as? NSDictionary
            hybridID = hybridDic?.value(forKey: "id") as? String as NSString? ?? ""
            cistomView.hybridTf.text = hybridDic?.value(forKey: "name") as? String
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
extension SubscriptionGrowthDurationViewController : UITextFieldDelegate{
    
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        if textField == cistomView.categoryTxtFld{
            textField.resignFirstResponder()
            categoryDropDownTblView.reloadData()
            categoryDropDownTblView = UITableView()
            self.hideUnhideDropDownTblView(tblView: categoryDropDownTblView, hideUnhide: false)
        }
        if textField == cistomView.cropTF{
            textField.resignFirstResponder()
            crop_dropDownTable.reloadData()
            crop_dropDownTable = UITableView()
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
            // dobPickerView()
            // return false
        }
    }
    
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        //print("TextField did end editing method called")
        print("end")
        print(self.view.frame)
    }
    
    func loadTable( textField: UITextField, table : UITableView){
        // table = UITableView()
        
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
        tblView.isHidden = !hideUnhide
        self.view.bringSubview(toFront: tblView)
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        selectedTextField = textField
        
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
extension SubscriptionGrowthDurationViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    //MARK:- dobPickerView DESIGN
    func dobPickerView(){
        let Height:CGFloat = (44.11 * self.view.frame.height/60) //120
        let width :CGFloat = self.view.frame.size.width-100 //-40
        let posX :CGFloat = (self.view.frame.size.width - width) / 2
        
        dobView = UIView (frame: CGRect(x: posX,y: (self.view.frame.height-Height)/2 ,width: width,height: Height))
        dobView.backgroundColor = UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        dobView.layer.cornerRadius = 10.0
        self.alertView_Bg.addSubview(dobView)
        
        //dobPicker
        let dobPicker : UIDatePicker = UIDatePicker (frame: CGRect(x: 5,y: 5,width: width-10,height: Height-50))
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


extension SubscriptionGrowthDurationViewController{
    
    //MARK: requestToGetCropAdvisoryData
    /**
     This method is used to get the crop advisory data from server
     - Parameter Params: [String:String]
     */
    func requestToGetCropAdvisoryData (Params : [String:String]){
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,CA_GET_MASTER_ADD_SUBSCRIPTION_DROPDOWN_V2])
        
        var   Headers : HTTPHeaders  = ["deviceToken": userObj1.value(forKey: "deviceToken") as? String ?? "",
                                        "userAuthorizationToken": userObj1.value(forKey: "userAuthorizationToken")  as? String ?? "",
                                        "mobileNumber": userObj1.value(forKey: "mobileNumber")  as? String ?? "",
                                        "customerId": userObj1.value(forKey: "customerId")  as? String ?? "",
                                        "deviceId": userObj1.value(forKey: "deviceId")  as? String ?? ""]
        print("requestToGetCropAdvisoryData \(Headers)")
        Alamofire.request(urlString, method: .post, parameters: Params, encoding: JSONEncoding.default, headers: Headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                print(response)
                if let json = response.result.value {
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as? NSString ?? ""
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
                        //                        self.contentView.isHidden = true
                        //                        self.btnSubmit.isHidden = true
                        //                        self.lblNoDataAvailable.isHidden = false
                        //                        self.lblNoDataAvailable.text = (json as! NSDictionary).value(forKey: "message") as? String
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
    
    
    //MARK: filterCropsWithCategoryAndState
    /**
     This method is used to filter the Crops Array with categoryID and stateID
     - Parameter categoryDic: NSDictionary?
     - Parameter stateDic: NSDictionary?step
     */
    func filterCropsWithCategoryAndState(categoryDic: NSDictionary?, stateDic: NSDictionary?){
        if categoryDic != nil && stateDic != nil {
            categoryID = categoryDic!.value(forKey: "id") as? String as? NSString ?? ""
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
    
    //MARK: filterHybridWithCategoryAndStaeAndCrop
    /**
     This method is used to filter the Hybrids Array with categoryID,stateID and cropID
     - Parameter categoryDic: NSDictionary?
     - Parameter stateDic: NSDictionary?
     - Parameter cropDic: NSDictionary?
     */
    func filterHybridWithCategoryAndStaeAndCrop(categoryDic: NSDictionary?, cropDic: NSDictionary?){
        if categoryDic != nil  && cropDic != nil {
            categoryID = categoryDic!.value(forKey: "id") as? String as NSString? ?? ""
            //stateID = stateDic!.value(forKey: "id") as! String as NSString
            cropID = cropDic?.value(forKey: "id") as? String as? NSString ?? ""
            let hybridPredicate = NSPredicate(format: " (cropId == %@)",cropID)
            let hybridFilterArray = self.hybridArray.filtered(using: hybridPredicate)
            if hybridFilterArray.count > 0{
                self.hybridNameArray.removeAllObjects()
                self.hybridNameArray.addObjects(from: hybridFilterArray)
                if let hybridDic = hybridNameArray.firstObject as? NSDictionary{
                    cistomView.hybridTf.text = hybridDic.value(forKey: "name") as? String
                    hybridID = hybridDic.value(forKey: "id") as? String as? NSString ?? ""
                    //self.hybrid_dropDownTable.reloadData()
                    self.filterSeasonWithCategoryAndStaeAndCropAndHybrid(categoryDic: categoryDic,  cropDic: cropDic, hybridDic: hybridDic)
                    
                }
            }
        }
    }
    
    
    /*
     //MARK: GET SELECTED CROP DETAILS AND IMAGES TO DESIGN THE SCREEN
     This method is used to get the crop advisory original image percentages from server
     - Parameter Params: [String:String], cropid and cropTypeId
     */
    func getMainPhasePriginalImagesMaster(){
        //getsubPhasePriginalImagesMaster()
        
        var parameters = ["crop" : cropID , "cropTypeId" : cropTypeId ] as NSDictionary
        print(parameters)
        
        if isfromSubscriptionTap{
            let obj : CASubscribedUserListBO = selectedSubscription.object(at:0) as! CASubscribedUserListBO
            parameters = ["crop" : cropID ,
                          "cropTypeId" : cropTypeId,
                          "hybridName" : obj.hybridName as String? ?? "" ,
                          "dateOfShowing" : obj.dateOfShowing as String? ?? "",
                          "categoryId" : obj.category as String? ?? "" ,
                          "seasonId" : obj.season as String? ?? "",
                           "mobileNumber": userObj1.value(forKey: "mobileNumber")  as? String ?? ""
                ] as NSDictionary
        }
        
        
        var   Headers : HTTPHeaders  = ["deviceToken": userObj1.value(forKey: "deviceToken") as? String ?? "",
                                        "userAuthorizationToken": userObj1.value(forKey: "userAuthorizationToken")  as? String ?? "",
                                        "mobileNumber": userObj1.value(forKey: "mobileNumber")  as? String ?? "",
                                        "customerId": userObj1.value(forKey: "customerId")  as? String ?? "",
                                        "deviceId": userObj1.value(forKey: "deviceId")  as? String ?? ""]
        BaseClass.getCAOriginalImageandSubImages(dic : parameters , header : Headers) { (status, responseArray,message) in
            if status == true{
                
//                 CoreDataManager.shared.addLogEvent(UserID: self.userObj1.value(forKey: "customerId")  as? String ?? "", mobileNumber: self.userObj1.value(forKey: "mobileNumber")  as? String ?? "", screenName: "SubscriptionGrowthDurationViewController", eventName: "CropPhaseLifeCycle_Success_Request", eventType: "onRequest",captureTime:self.getCurrentDateAndTime(), currentLocation: self.userObj1.value(forKey: "geoLocation")  as? String ?? "0.0,0.0", moduleType: "CropAdvisory")
                
                
                let parameters  = ["capturedtime" : self.getCurrentDateAndTime() , "currentLocation" :  self.userObj1.value(forKey: "geoLocation")  as? String ?? "" ,"eventName" :  "CropPhaseLifeCycle_Success_Request" , "moduleType" : "CropAdvisory","deviceType" : "iOS" , "Mobile_Number" : self.userObj1.value(forKey: "mobileNumber")  as? String ?? "" ,"screen_name" :  "SubscriptionGrowthDurationViewController" , "User_Id" :  self.userObj1.value(forKey: "customerId")  as? String ?? ""] as [String : Any]
                                                                          
                self.registerFirebaseEvents("CropPhaseLifeCycle_Success_Request", "", "", "SubscriptionGrowthDurationViewController", parameters: parameters as NSDictionary)
                
                if self.phaseArrayCollection.count>0{
                    self.phaseArrayCollection.removeAllObjects()
                }
                
                if self.FinalArray.count>0{
                    self.FinalArray.removeAllObjects()
                }
                let arrrayay  = responseArray?.object(forKey: "cropDetails") as? NSArray ?? []
                //GrowthCASubscriptionsBO
                for i in 0..<arrrayay.count{
                    let cropListDict = GrowthCASubscriptionsBO(dict: arrrayay.object(at: i) as! NSDictionary)
                    self.FinalArray.add(cropListDict)
                }
                let dicP = responseArray?.value(forKey: "cropGlobalDetails") as? NSDictionary
                
                self.phaseArrayCollection = NSMutableArray(array:self.FinalArray )
                let imageObj = UIImage(named: dicP?.object(forKey: "globalBgPhaseImgUrl") as? String ?? "")
                //dic.cropSubPhaseImgUrl ?? ""
                
                let url = URL(string:dicP?.object(forKey: "globalBgPhaseImgUrl") as? String ?? "")
                self.bgImage.kf.setImage(with : url, placeholder: UIImage(named:"image_placeholder.png"))
                //  self.bgImage.kf.setImage(with: url , placeholder: UIImage(named:"image_placeholder.png"), options: nil, progressBlock: nil, completionHandler: nil)
                
                let rect =  self.bgImage.contentClippingRect
                
                print("image size :\(rect)")
                
                var stringSubscribed = dicP?.object(forKey: "userSubscribed") as? String ?? ""
                if let idObj = dicP?.value(forKey: "userSubscribed") as? Int {
                    stringSubscribed = (String(format: "%d",idObj) as NSString) as String
                }
                
                
                let result = (stringSubscribed == "1") ? true : false
                
                //  if  let stringSubscribed == "1"  ?? true : false
                self.isSubscribeduser = result
                
                if( self.phaseArrayCollection.count>0){
                    self.cropCollectionview.reloadData()
                    self.cropCollectionview.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
                }
                print("final array :%@",self.phaseArrayCollection)
            }
            else{
                
//                CoreDataManager.shared.addLogEvent(UserID: self.userObj1.value(forKey: "customerId")  as? String ?? "", mobileNumber: self.userObj1.value(forKey: "mobileNumber")  as? String ?? "", screenName: "SubscriptionGrowthDurationViewController", eventName: "CropPhaseLifeCycle_Something_Wrong", eventType: "onRequest",captureTime:self.getCurrentDateAndTime(), currentLocation: "0.0,0.0", moduleType: "CropAdvisory")
                
                let parameters  = ["capturedtime" : self.getCurrentDateAndTime() , "currentLocation" :  self.userObj1.value(forKey: "geoLocation")  as? String ?? "" ,"eventName" :  "CropPhaseLifeCycle_Something_Wrong" , "moduleType" : "CropAdvisory","deviceType" : "iOS" , "Mobile_Number" : self.userObj1.value(forKey: "mobileNumber")  as? String ?? "" ,"screen_name" :  "SubscriptionGrowthDurationViewController" , "User_Id" :  self.userObj1.value(forKey: "customerId")  as? String ?? ""] as [String : Any]
                                                                                        
                self.registerFirebaseEvents("CropPhaseLifeCycle_Something_Wrong", "", "", "SubscriptionGrowthDurationViewController", parameters: parameters as NSDictionary)
            }
        }
    }
    
    
    
    func getsubPhaseoriginalImagesMaster(){
        let userObj = Constatnts.getUserObject()
        //
        var parameters = ["crop" : cropID ,
                          "cropPhaseId" : cropPhaseID,
                          "mobileNumber" : userObj1.value(forKey: "mobileNumber")  as? String ?? "",
                          "cropTypeId" : cropTypeId ,
                          "hybridName" :  "" ,
                          "dateOfShowing" :  "",
                          "categoryId" :  "" ,
                          "seasonId" :  "" ] as NSDictionary
        
        if isfromSubscriptionTap{
            let obj : CASubscribedUserListBO = selectedSubscription.object(at:0) as! CASubscribedUserListBO
            parameters = ["crop" : cropID ,
                          "cropPhaseId" : cropPhaseID,
                          "mobileNumber" : userObj1.value(forKey: "mobileNumber")  as? String ?? "",
                          "cropTypeId" : cropTypeId ,
                          "hybridName" : obj.hybridName as String? ?? "" ,
                          "dateOfShowing" : obj.dateOfShowing as String? ?? "",
                          "categoryId" : obj.category as String? ?? "" ,
                          "seasonId" : obj.season as String? ?? "" ] as NSDictionary
        }
        
        var   Headers : HTTPHeaders  = ["deviceToken": userObj1.value(forKey: "deviceToken") as? String ?? "",
                                        "userAuthorizationToken": userObj1.value(forKey: "userAuthorizationToken")  as? String ?? "",
                                        "mobileNumber": userObj1.value(forKey: "mobileNumber")  as? String ?? "",
                                        "customerId": userObj1.value(forKey: "customerId")  as? String ?? "",
                                        "deviceId": userObj1.value(forKey: "deviceId")  as? String ?? ""]
        
        BaseClass.getCASubOriginalImageandSubImages(dic : parameters , header : Headers) { (status, responseArray,message) in
            if status == true{
                if self.subsPhaseArray.count>0{
                    self.subsPhaseArray.removeAllObjects()
                }
                
                if self.FinalArray.count>0{
                    self.FinalArray.removeAllObjects()
                }
                let arrrayay  = responseArray?.object(forKey: "cropSubImageDetails") as? NSArray ?? []
                //GrowthCASubscriptionsBO
                for i in 0..<arrrayay.count{
                    let cropListDict = GrowthCASubPhasesNew(dict: arrrayay.object(at: i) as! NSDictionary)
                    self.FinalArray.add(cropListDict)
                }
                let dicP = responseArray?.value(forKey: "cropGlobalDetails") as? NSDictionary
                
                self.subsPhaseArray = NSMutableArray(array:self.FinalArray )
                
                if( self.subsPhaseArray.count>0){
                    let objBo : GrowthCASubPhasesNew = self.subsPhaseArray.object(at: 0) as! GrowthCASubPhasesNew
                    //    self.SelectedPhaseString = objBo.crop as String?  ?? ""
                    self.showPreviewDetailsOfSelected(img: dicP?.object(forKey: "globalBgPhaseImgUrl") as? String ?? "" )
                    self.subPhaseCollectionView.reloadData()
                }
                print("final array :%@",self.subsPhaseArray)
            }
            else{
            }
        }
    }
    
    //getCASubimagesDetailsScreen
    func getsubPhaseDetailedScreen(_ index : Int){
        let userObj = Constatnts.getUserObject()
        
        let obj : GrowthCASubPhasesNew = subsPhaseArray.object(at:index) as! GrowthCASubPhasesNew
        let   parameters = ["crop" : cropID ,
                            "cropPhaseId" : cropPhaseID,
                            "mobileNumber" : userObj.mobileNumber ?? "",
                            "cropTypeId" : cropTypeId ,
                            "caSatgeId" : obj.caSatgeId as String? ?? "" ?? "" ,
            ] as NSDictionary
        
        csStageSelected = obj.caSatgeId as String? ?? ""
        var selectedindexx = 0
        print(parameters)
        
        var   Headers : HTTPHeaders  = ["deviceToken": userObj1.value(forKey: "deviceToken") as? String ?? "",
                                        "userAuthorizationToken": userObj1.value(forKey: "userAuthorizationToken")  as? String ?? "",
                                        "mobileNumber": userObj1.value(forKey: "mobileNumber")  as? String ?? "",
                                        "customerId": userObj1.value(forKey: "customerId")  as? String ?? "",
                                        "deviceId": userObj1.value(forKey: "deviceId")  as? String ?? ""]
        
        
        BaseClass.getCADataDetails(dic : parameters, header : Headers) { (status, responseArray,message) in
            if status == true{
                self.alertView_Bg.removeFromSuperview()
                //  print(responseArray)
                
                //                let mainStoryboard: UIStoryboard = UIStoryboard(name: "cropadvisorySub",bundle: nil)
                //                let viewContro = mainStoryboard.instantiateViewController(withIdentifier: "CropDetailsPhaseViewController") as? CropDetailsPhaseViewController
                //                viewContro?.isFromSideMenu = false
                
                let viewControl : CropDetailsPhaseViewController  = BaseClass.loadViewPhase() as! CropDetailsPhaseViewController
                viewControl.isFromSideMenu = false
                
                if self.subDetailedScreenArray.count>0{
                    self.subDetailedScreenArray.removeAllObjects()
                }
                let arrrayay  = responseArray?.object(forKey: "cropSubImageDetails") as? NSArray ?? []
                //GrowthCASubscriptionsBO
                for i in 0..<arrrayay.count{
                    let cropListDict = GrowthCASubPhasesDetailBO(dict: arrrayay.object(at: i) as? NSDictionary ?? [:])
                    var str = cropListDict.value(forKey: "caStageId") as? String ?? ""
                    
                    if let idObj = cropListDict.value(forKey: "caStageId") as? Int {
                        str = (String(format: "%d",idObj) as NSString) as String
                    }
                    
                    if str   ==   self.csStageSelected   {
                        selectedindexx = i
                    }
                    self.subDetailedScreenArray.add(cropListDict)
                }
                // let dicP = responseArray?.value(forKey: "cropGlobalDetails") as? NSDictionary
                
                print("final array :%@",self.subDetailedScreenArray)
                viewControl.DetailsFromPrevousScrenArray = self.subDetailedScreenArray
                viewControl.selectedSubscriptionArray = self.selectedSubscription
                viewControl.mutArrayToDisplay = self.subDetailedScreenArray
                viewControl.isFromSubscriptionList = self.isfromSubscriptionTap
                viewControl.csStageSelectedStr = self.csStageSelected
                viewControl.selectedindex = selectedindexx
                viewControl.userObj = self.userObj1
                viewControl.cropType = self.cropTypeId as String
                viewControl.cropID = self.cropID as String
                viewControl.cropPhaseID = self.cropPhaseID as String
                self.navigationController?.pushViewController(viewControl, animated: true)
            }
            else{
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
            categoryID = categoryDic?.value(forKey: "cropId") as! String as NSString
            
            cropID = cropDic!.value(forKey: "id") as? String as NSString? ?? ""
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
                        cistomView.dateOfSowingTF.text = startDate
                    }
                    self.seasonEndDateStr = seasonDic.value(forKey: "endDate") as? String ?? ""
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
            categoryID = categoryDic!.value(forKey: "cropId") as? String as NSString? ?? ""
            //state
            cropTypeId = categoryDic!.value(forKey: "cropTypeId") as? String as NSString? ?? ""
            let statePredicate = NSPredicate(format: "cropId = %@",categoryID)
            let stateFilteredArr = (self.categoryArray).filtered(using: statePredicate) as NSArray
            
            //print("state data array : \(stateFilteredArr)")
            if stateFilteredArr.count > 0{
                self.categoryNamesArray.removeAllObjects()
                let statesNamesSet =  NSSet(array:stateFilteredArr as! [Any])
                // self.categoryArray = statesNamesSet.allObjects as NSArray
                self.categoryNamesArray.addObjects(from: statesNamesSet.allObjects)
                //self.categoryDropDownTblView.reloadData()
                if categoryNamesArray.count > 0{
                    let categoryDic = categoryNamesArray.object(at: 0) as? NSDictionary
                    cistomView.categoryTxtFld.text =  categoryDic?.value(forKey: "cropSubTypeName") as? String
                    categoryID = categoryDic?.value(forKey: "cropId") as? String as NSString? ?? ""
                    cropTypeId = categoryDic!.value(forKey: "cropTypeId") as? String as NSString? ?? ""
                }
            }
        }
    }
    
    //MARK:- ADD SUBSCRIPTION
    func submitSubscribeduserDetails(){
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
        
        var   Headers : HTTPHeaders  = ["deviceToken": userObj1.value(forKey: "deviceToken") as? String ?? "",
                                        "userAuthorizationToken": userObj1.value(forKey: "userAuthorizationToken")  as? String ?? "",
                                        "mobileNumber": userObj1.value(forKey: "mobileNumber")  as? String ?? "",
                                        "customerId": userObj1.value(forKey: "customerId")  as? String ?? "",
                                        "deviceId": userObj1.value(forKey: "deviceId")  as? String ?? ""]
        
        
        BaseClass.newCASubscription(dic : dic, headers: Headers ) { (status, responseArray,message) in
            if status == true{
                self.clearSubscriptionPopFeilds()
                self.view.makeToast("Subscribed Succesfully")
            }
            else{
                print("No records")
            }
        }
    }
    
    
}



extension UIImageView {
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }
        
        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }
        
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0
        
        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}


extension CropSubStageCollectionViewCell {
    
    static func register(for collectionView: UICollectionView)  {
        let cellName = String(describing: self)
        let cellIdentifier = "CropSubStageCollectionViewCell"
        let cellNib = UINib(nibName: String(describing: self), bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellIdentifier)
    }
}

