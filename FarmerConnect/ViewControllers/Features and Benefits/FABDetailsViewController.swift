//
//  FABDetailsViewController.swift
//  PioneerEmployee
//
//  Created by Empover on 02/10/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import AVFoundation
import AVKit

class FABDetailsViewController: BaseViewController,UIGestureRecognizerDelegate {
    
    var stateIdFromFABVC = NSString()
    var cropIdFromFABVC = NSString()
    var hybridIdFromFABVC = NSString()
    var seasonIdFromFABVC = NSString()
    
    @IBOutlet weak var headerCollectionView: UICollectionView!
    
    @IBOutlet weak var dataTblView: UITableView!
    
    @IBOutlet weak var mainDescriptionTxtView: UITextView!
    
    @IBOutlet weak var collectionViewToDisplayAssets: UICollectionView!
    
    @IBOutlet weak var mainDescriptionOuterView: UIView!
    
    ///main array to store the FAB data and used to display on tableView
    var mutArrayToDisplay = NSMutableArray()
    
    var version = NSString()
    
    var a : NSInteger? = 0
    
    ///Checks the server response for images,pdf's,audio,video,gif files.If exists the respective asset will be added to this array.Based on this array count and asset added to this array we are displaying respective asset image on the collectionView.
    var assetsCountMutArray = NSMutableArray()
    
     /// used to iterate through mutArrToStoreAllAssetsOfFAB while downloading the assets
     var currentIndex:Int = 0
    
    ///This array stores all assets of FAB,and used this array to download the assets.
    var mutArrToStoreAllAssetsOfFAB = NSMutableArray()
    
    var fabDocumentsDirectory = NSString()
    
    //to play video file
     var playerController : AVPlayerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //let parameters = ["stateId":Int((stateIdFromFABVC as String) as String)!,"cropId":Int(cropIdFromFABVC as String)!,"hybridId":Int(hybridIdFromFABVC as String)!,"seasonId":Int(seasonIdFromFABVC as String)!] as NSDictionary
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        fabDocumentsDirectory = appDelegate.getFABFolderPath() as NSString
        headerCollectionView.dataSource = self
        headerCollectionView.delegate = self
        collectionViewToDisplayAssets.dataSource = self
        collectionViewToDisplayAssets.delegate = self
        dataTblView.dataSource = self
        dataTblView.delegate = self
        
        //dataTblView.tableFooterView = UIView()
        dataTblView.separatorStyle = UITableViewCellSeparatorStyle.none
        dataTblView.rowHeight = UITableViewAutomaticDimension
        dataTblView.estimatedRowHeight = 250
        
        mainDescriptionTxtView.isEditable = false
        mainDescriptionTxtView.text = ""
        
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(FABDetailsViewController.swipeLeft))
        leftSwipeGesture.delegate = self
        leftSwipeGesture.direction = .left
        dataTblView.addGestureRecognizer(leftSwipeGesture)
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(FABDetailsViewController.swipeRight))
        rightSwipeGesture.delegate = self
        rightSwipeGesture.direction = .right
        dataTblView.addGestureRecognizer(rightSwipeGesture)

        let shareButton = UIButton(frame: CGRect(x:UIScreen.main.bounds.size.width-42,y: 6,width: 40,height: 40))
        shareButton.backgroundColor =  UIColor.clear
        shareButton.setImage( UIImage(named: "Share"), for: UIControlState())
        shareButton.addTarget(self, action: #selector(FABDetailsViewController.shareButtonClick(_:)), for: UIControlEvents.touchUpInside)
        self.topView?.addSubview(shareButton)
        
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let retrievedArrFromDB = appDelegate.getFABDetailsFromDB("FABDetails")
            //print(retrievedArrFromDB)
            let dbPredicate = NSPredicate(format: "stateId = %@ && cropId = %@ && hybridId = %@ && seasonId = %@",stateIdFromFABVC,cropIdFromFABVC,hybridIdFromFABVC,seasonIdFromFABVC)
            let outputFilteredArr = (retrievedArrFromDB).filtered(using: dbPredicate) as NSArray
            if outputFilteredArr.count > 0{
                let fabObj = outputFilteredArr.object(at: 0) as? FABDetailsEntity
                let fabVersion = (fabObj?.version)!
                if Validations.isNullString(fabVersion) == false{
                    version = fabVersion
                }
                else{
                    version = "0"
                }
            }
            else{
                version = "0"
            }
        
        let parameters = ["stateId":stateIdFromFABVC,"cropId":cropIdFromFABVC,"hybridId":hybridIdFromFABVC,"seasonId":seasonIdFromFABVC,"version" : version] as NSDictionary
        let paramsStr1 = Constatnts.nsobjectToJSON(parameters as NSDictionary)
        let params =  ["data": paramsStr1]
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.requestToGetFABDetailsData(Params: params)
            }
     
        }
        else{
            self.updateUI()
        }
        self.recordScreenView("FABDetailsViewController", FAB_Details_Screen)
        self.registerFirebaseEvents(PV_FAB_Details_Screen, "", "", "", parameters: nil)
        self.registerFirebaseEvents(PV_Features_Tab, "", "", "", parameters: nil)
        let userObj = Constatnts.getUserObject()
        if userObj.userLogsAllPrint == "true"{
        self.saveUserLogEventsDetailsToServer()
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
            "logTimeStamp": todaysDate as? NSString,
            "pincode": userObj.pincode,
            "districtLoggedin":userObj.districtName,
            "stateLoggedin":userObj.stateName,
            "stateName": userObj.stateName,
            "marketName":"",
            "commodity":"",
            
            "eventName": PV_FAB_Details_Screen,
            "className":"FABDetailsViewController",
            "moduleName":"FAB",
            
            "healthCardId":"",
            "productId":self.hybridIdFromFABVC,
            "cropId": self.cropIdFromFABVC,
            "seasonId": self.seasonIdFromFABVC,
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
    
    //MARK: swipeLeft
    @objc func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        if a != mutArrayToDisplay.count - 1 {
            a = a! + 1
            //dataTblView.reloadData()
            headerCollectionView.reloadData()
            let transition = CATransition()
            transition.type = kCATransitionPush
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.fillMode = kCAFillModeForwards
            transition.duration = 0.6
            transition.subtype = kCATransitionFromRight
            dataTblView.layer.add(transition, forKey: "UITableViewReloadDataAnimationKey")
            dataTblView.reloadData()
        }
        else {
        }
        //    [self scrollViewDidEndDecelerating:_collectionviewToDisplay];
        let indexPath1 = IndexPath(item: a!, section: 0)
        headerCollectionView!.scrollToItem(at: indexPath1, at: .centeredHorizontally, animated: true)
        assetsCountMutArray.removeAllObjects()
        if mutArrayToDisplay.count > 0 {
            let checkPDFFileKey = (Validations.checkKeyNotAvail((mutArrayToDisplay.object(at: a!) as! NSDictionary), key: "pdfFile") as?NSString)!
            let pdfFileAvailable = Validations.isNullString(checkPDFFileKey)
            if pdfFileAvailable == false {//not null
                assetsCountMutArray.add("FabDetailsPdfIcon")
            }
            let checkImgKey = (Validations.checkKeyNotAvail((mutArrayToDisplay.object(at: a!) as! NSDictionary), key: "images") as?NSString)!
            let imgsAvailable = Validations.isNullString(checkImgKey)
            if imgsAvailable == false {
                assetsCountMutArray.add("FabDetailsImgIcon")
            }
            
            //let voiceFileAvailable = Validations.isNullString((mutArrayToDisplay.object(at: a!) as! NSDictionary).value(forKey: "voiceFile") as! NSString)
            let checkVoiceFileKey = (Validations.checkKeyNotAvail((mutArrayToDisplay.object(at: a!) as! NSDictionary), key: "voiceFile") as?NSString)!
            let voiceFileAvailable = Validations.isNullString(checkVoiceFileKey)
            if voiceFileAvailable == false {
                assetsCountMutArray.add("FabDetailsAudioIcon")
            }
            
            let checkVideoFileKey = (Validations.checkKeyNotAvail((mutArrayToDisplay.object(at: a!) as! NSDictionary), key: "videoFile") as?NSString)!
            let videoFileAvailable = Validations.isNullString(checkVideoFileKey)
            if videoFileAvailable == false {//not null
                assetsCountMutArray.add("FabDetailsVideoIcon")
            }
            collectionViewToDisplayAssets.reloadData()
        }
        if indexPath1.row == 0 {
            self.registerFirebaseEvents(PV_Features_Tab, "", "", "", parameters: nil)
        }
        else if indexPath1.row == 1{
            self.registerFirebaseEvents(PV_Benefits_Tab, "", "", "", parameters: nil)
        }
        else if indexPath1.row == 2{
            self.registerFirebaseEvents(PV_Advantages_Tab, "", "", "", parameters: nil)
        }
    }
    
    //MARK: swipeRight
    @objc func swipeRight(_ sender: UISwipeGestureRecognizer) {
        if a != 0 {
            a = a! - 1
            //dataTblView.reloadData()
            headerCollectionView.reloadData()
            let transition = CATransition()
            transition.type = kCATransitionPush
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.fillMode = kCAFillModeForwards
            transition.duration = 0.6
            transition.subtype = kCATransitionFromLeft
            dataTblView.layer.add(transition, forKey: "UITableViewReloadDataAnimationKey")
            dataTblView.reloadData()
        }
        else {
        }
        //    [self scrollViewDidEndDecelerating:_collectionviewToDisplay];
        let indexPath1 = IndexPath(item: a!, section: 0)
        headerCollectionView!.scrollToItem(at: indexPath1, at: .centeredHorizontally, animated: true)
        assetsCountMutArray.removeAllObjects()
        if mutArrayToDisplay.count > 0 {
            let checkPDFFileKey = (Validations.checkKeyNotAvail((mutArrayToDisplay.object(at: a!) as! NSDictionary), key: "pdfFile") as?NSString)!
            let pdfFileAvailable = Validations.isNullString(checkPDFFileKey)
            if pdfFileAvailable == false {//not null
                assetsCountMutArray.add("FabDetailsPdfIcon")
            }
            let checkImgKey = (Validations.checkKeyNotAvail((mutArrayToDisplay.object(at: a!) as! NSDictionary), key: "images") as?NSString)!
            let imgsAvailable = Validations.isNullString(checkImgKey)
            if imgsAvailable == false {
                assetsCountMutArray.add("FabDetailsImgIcon")
            }
            //let voiceFileAvailable = Validations.isNullString((mutArrayToDisplay.object(at: a!) as! NSDictionary).value(forKey: "voiceFile") as! NSString)
            let checkVoiceFileKey = (Validations.checkKeyNotAvail((mutArrayToDisplay.object(at: a!) as! NSDictionary), key: "voiceFile") as?NSString)!
            let voiceFileAvailable = Validations.isNullString(checkVoiceFileKey)
            if voiceFileAvailable == false {
                assetsCountMutArray.add("FabDetailsAudioIcon")
            }
            let checkVideoFileKey = (Validations.checkKeyNotAvail((mutArrayToDisplay.object(at: a!) as! NSDictionary), key: "videoFile") as?NSString)!
            let videoFileAvailable = Validations.isNullString(checkVideoFileKey)
            if videoFileAvailable == false {//not null
                assetsCountMutArray.add("FabDetailsVideoIcon")
            }
            collectionViewToDisplayAssets.reloadData()
        }
        if indexPath1.row == 0 {
            self.registerFirebaseEvents(PV_Features_Tab, "", "", "", parameters: nil)
        }
        else if indexPath1.row == 1{
            self.registerFirebaseEvents(PV_Benefits_Tab, "", "", "", parameters: nil)
        }
        else if indexPath1.row == 2{
            self.registerFirebaseEvents(PV_Advantages_Tab, "", "", "", parameters: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
          let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let retrievedArrFromDB = appDelegate.getFABDetailsFromDB("FABDetails")
               // print(retrievedArrFromDB)
               let dbPredicate = NSPredicate(format: "stateId = %@ && cropId = %@ && hybridId = %@ && seasonId = %@",stateIdFromFABVC,cropIdFromFABVC,hybridIdFromFABVC,seasonIdFromFABVC)
               let outputFilteredArr = (retrievedArrFromDB).filtered(using: dbPredicate) as NSArray
               if outputFilteredArr.count > 0 {
                   let fabObj = outputFilteredArr.object(at: 0) as? FABDetailsEntity
                   let userObj = Constatnts.getUserObject()
                let titleStr = (fabObj?.crop as? String ?? "") + "-" + (fabObj?.hybrid as? String ?? "")
                var titleStr1 = titleStr + "-" + (fabObj?.season as? String ?? "")
                  lblTitle?.text =  titleStr1
        }
        self.topView?.isHidden = false
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        //self.refreshTextFields()
    }
    
    //MARK : backButtonClick
    override func backButtonClick(_ sender: UIButton) {
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.isClickedOnFABDetailsCloseBtn = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareButtonClick( _ sender: UIButton)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var message = ""
        let retrievedArrFromDB = appDelegate.getFABDetailsFromDB("FABDetails")
        // print(retrievedArrFromDB)
        let dbPredicate = NSPredicate(format: "stateId = %@ && cropId = %@ && hybridId = %@ && seasonId = %@",stateIdFromFABVC,cropIdFromFABVC,hybridIdFromFABVC,seasonIdFromFABVC)
        let outputFilteredArr = (retrievedArrFromDB).filtered(using: dbPredicate) as NSArray
        if outputFilteredArr.count > 0 {
            let fabObj = outputFilteredArr.object(at: 0) as? FABDetailsEntity
            let userObj = Constatnts.getUserObject()
            let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,CROP:fabObj?.crop ?? "",HYBRID:fabObj?.hybrid ?? "",SEASON:fabObj?.season ?? ""] as [String : Any]
            self.registerFirebaseEvents(FAB_Details_Share, "", "", "", parameters: firebaseParams as NSDictionary)
            message = String(format: "FAB %@ %@ %@", fabObj?.season ?? "",fabObj?.crop ?? "",fabObj?.hybrid ?? "")
        }

        let urlPath = String(format: "%@=%@&%@=%@&%@=%@&%@=%@", Module,FAB,Crop_Id,cropIdFromFABVC,Hybrid_Id,hybridIdFromFABVC,Season_Id,seasonIdFromFABVC)
        let finalUrl = String(format: "%@%@", deepLinkBaseUrl,urlPath)
        let activityControl = Validations.showShareActivityController(viewController: self, fileUrl: URL(string: finalUrl)!, userName: "", message: message)
        //retrieve fab details from DB
        self.present(activityControl, animated: true, completion: nil)
    }
    

    //MARK: requestToGetFABDetailsData
    /**
      Request to server to get detailed FAB data based on StateID,CropID,HybridID and SeasonID
     - Parameter Params:[String:String]
    */
    func requestToGetFABDetailsData (Params : [String:String]){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            SwiftLoader.show(animated: true)
        }
       
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_FAB_DETAILS])
        let userObj = Constatnts.getUserObject()
        
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        print(headers)
        
        Alamofire.request(urlString, method: .post, parameters: Params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        print("Response after decrypting data:\(decryptData)")
                        
                        let dataMutArr = NSMutableArray()
                        
                        let featuresDict = NSMutableDictionary()
                        featuresDict.setValue("Features", forKey: "Title")
                        featuresDict.setValue(decryptData["f_message"], forKey: "message")
                        featuresDict.setValue(decryptData["f_image_tags"], forKey: "imageTags")
                        featuresDict.setValue(decryptData["f_images"], forKey: "images")
                        featuresDict.setValue(decryptData["f_voiceFile"], forKey: "voiceFile")
                        featuresDict.setValue(decryptData["f_pdfFile"], forKey: "pdfFile")
                        featuresDict.setValue(decryptData["f_videoFile"], forKey: "videoFile")
                        dataMutArr.add(featuresDict)
                        
                        let advantagesDict = NSMutableDictionary()
                        advantagesDict.setValue("Advantages", forKey: "Title")
                        advantagesDict.setValue(decryptData["a_message"], forKey: "message")
                        advantagesDict.setValue(decryptData["a_image_tags"], forKey: "imageTags")
                        advantagesDict.setValue(decryptData["a_images"], forKey: "images")
                        advantagesDict.setValue(decryptData["a_voiceFile"], forKey: "voiceFile")
                        advantagesDict.setValue(decryptData["a_pdfFile"], forKey: "pdfFile")
                        advantagesDict.setValue(decryptData["a_videoFile"], forKey: "videoFile")
                        dataMutArr.add(advantagesDict)
                        
                        let benefitsDict = NSMutableDictionary()
                        benefitsDict.setValue("Benefits", forKey: "Title")
                        benefitsDict.setValue(decryptData["b_message"], forKey: "message")
                        benefitsDict.setValue(decryptData["b_image_tags"], forKey: "imageTags")
                        benefitsDict.setValue(decryptData["b_images"], forKey: "images")
                        benefitsDict.setValue(decryptData["b_voiceFile"], forKey: "voiceFile")
                        benefitsDict.setValue(decryptData["b_pdfFile"], forKey: "pdfFile")
                        benefitsDict.setValue(decryptData["b_videoFile"], forKey: "videoFile")
                        dataMutArr.add(benefitsDict)
                        
                        // print(dataMutArr)
                        
                        let fabDetails : FABDetailsEntity = FABDetailsEntity(dict: NSMutableDictionary())
                        
                        fabDetails.id = decryptData["id"] as! NSString
                        fabDetails.version = decryptData["version"] as! NSString
                        fabDetails.mainDescription = decryptData["description"] as! NSString
                        fabDetails.stateId = decryptData["stateId"] as! NSString
                        fabDetails.state = decryptData["state"] as! NSString
                        fabDetails.cropId = decryptData["cropId"] as! NSString
                        fabDetails.crop = decryptData["crop"] as! NSString
                        fabDetails.hybridId = decryptData["hybridId"] as! NSString
                        fabDetails.hybrid = decryptData["hybrid"] as! NSString
                        fabDetails.seasonId = decryptData["seasonId"] as! NSString
                        fabDetails.season = decryptData["season"] as! NSString
                        
                        fabDetails.fabDataArray = dataMutArr
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        //appDelegate.deleteFABDetails()
                        appDelegate.saveFABDetails(fabDetails)
                        self.updateUI()
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
                self.view.makeToast((response.result.error.debugDescription), duration: 1.0, position: .center)
                return
            }
        }
    }
    
    //MARK: updateUI
    func updateUI(){
        //retrieve fab details from DB
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let retrievedArrFromDB = appDelegate.getFABDetailsFromDB("FABDetails")
       // print(retrievedArrFromDB)
        
        let dbPredicate = NSPredicate(format: "stateId = %@ && cropId = %@ && hybridId = %@ && seasonId = %@",stateIdFromFABVC,cropIdFromFABVC,hybridIdFromFABVC,seasonIdFromFABVC)
        let outputFilteredArr = (retrievedArrFromDB).filtered(using: dbPredicate) as NSArray

        if outputFilteredArr.count > 0 {
            mainDescriptionOuterView.isHidden = false
            headerCollectionView.isHidden = false
            dataTblView.isHidden = false
            collectionViewToDisplayAssets.isHidden = false
            
            let fabObj = outputFilteredArr.object(at: 0) as? FABDetailsEntity
            let mainDesc = fabObj?.mainDescription
            mainDescriptionTxtView.text = mainDesc! as String
            let dataArr = fabObj?.fabDataArray
            mutArrayToDisplay = dataArr?.object(at: 0) as! NSMutableArray
            self.headerCollectionView.reloadData()
            self.dataTblView.reloadData()
            assetsCountMutArray.removeAllObjects()
            
            let checkPDFFileKey = (Validations.checkKeyNotAvail((mutArrayToDisplay.object(at: a!) as! NSDictionary), key: "pdfFile") as?NSString)!
            let pdfFileAvailable = Validations.isNullString(checkPDFFileKey)
            if pdfFileAvailable == false {//not null
                assetsCountMutArray.add("FabDetailsPdfIcon")
            }
            
            let checkImgKey = (Validations.checkKeyNotAvail((mutArrayToDisplay.object(at: a!) as! NSDictionary), key: "images") as?NSString)!
            let imgsAvailable = Validations.isNullString(checkImgKey)
            if imgsAvailable == false {//not null
                assetsCountMutArray.add("FabDetailsImgIcon")
            }
            
            //let voiceFileAvailable = Validations.isNullString((mutArrayToDisplay.object(at: a!) as! NSDictionary).value(forKey: "voiceFile") as! NSString)
            let checkVoiceFileKey = (Validations.checkKeyNotAvail((mutArrayToDisplay.object(at: a!) as! NSDictionary), key: "voiceFile") as?NSString)!
            let voiceFileAvailable = Validations.isNullString(checkVoiceFileKey)
            if voiceFileAvailable == false {//not null
                assetsCountMutArray.add("FabDetailsAudioIcon")
            }
            
            let checkVideoFileKey = (Validations.checkKeyNotAvail((mutArrayToDisplay.object(at: a!) as! NSDictionary), key: "videoFile") as?NSString)!
            let videoFileAvailable = Validations.isNullString(checkVideoFileKey)
            if videoFileAvailable == false {//not null
                assetsCountMutArray.add("FabDetailsVideoIcon")
            }
            
            collectionViewToDisplayAssets.reloadData()
            
            // used for downloading assets
            mutArrToStoreAllAssetsOfFAB.removeAllObjects()
            for i in (0..<mutArrayToDisplay.count){
                let assetDictObj = mutArrayToDisplay.object(at: i) as! NSDictionary
                let checkpdfFileKey = (Validations.checkKeyNotAvail(assetDictObj, key: "pdfFile") as?NSString)!
                let pdfFileAvailable = Validations.isNullString(checkpdfFileKey)
                if pdfFileAvailable == false {//not null
                    mutArrToStoreAllAssetsOfFAB.add(assetDictObj.value(forKey: "pdfFile") as! NSString)
                }
                
                let checkImgKey = (Validations.checkKeyNotAvail(assetDictObj, key: "images") as?NSString)!
                let imgsAvailable = Validations.isNullString(checkImgKey)
                if imgsAvailable == false {//not null
                    let imagesArr = (assetDictObj.value(forKey: "images") as! NSString).components(separatedBy: "#") as NSArray
                    for j in (0..<imagesArr.count){
                        mutArrToStoreAllAssetsOfFAB.add(imagesArr.object(at: j))
                    }
                }
                
                let checkVoiceFileKey = (Validations.checkKeyNotAvail(assetDictObj, key: "voiceFile") as?NSString)!
                let voiceFileAvailable = Validations.isNullString(checkVoiceFileKey)
                if voiceFileAvailable == false {//not null
                    mutArrToStoreAllAssetsOfFAB.add(assetDictObj.value(forKey: "voiceFile") as! NSString)
                }
                
                let checkVideoFileKey = (Validations.checkKeyNotAvail(assetDictObj, key: "videoFile") as?NSString)!
                let videoFileAvailable = Validations.isNullString(checkVideoFileKey)
                if videoFileAvailable == false {//not null
                    mutArrToStoreAllAssetsOfFAB.add(assetDictObj.value(forKey: "videoFile") as! NSString)
                }
            }
            
            if Reachability.isConnectedToNetwork(){
                DispatchQueue.global().async {
                    self.checkAssetsToBeDownloaded()
                }
            }
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE, duration: 1.0, position: .center)
            mainDescriptionOuterView.isHidden = true
            headerCollectionView.isHidden = true
            dataTblView.isHidden = true
            collectionViewToDisplayAssets.isHidden = true
        }
    }
    
    //MARK: checkAssetsToBeDownloaded
    func checkAssetsToBeDownloaded(){
            if currentIndex < mutArrToStoreAllAssetsOfFAB.count {
            let assetStr = mutArrToStoreAllAssetsOfFAB.object(at: currentIndex)
            self.downloadAssetAndStore(inDocumentsDirectory: assetStr as! NSString)
            currentIndex+=1
            self.checkAssetsToBeDownloaded()
        }
    }
    
    //MARK: getDocumentPath
    /**
      get the FABAssets Folder path of Documents directory
     - Parameter assetStr: NSString
     - Returns: NSString
    */
    func getDocumentPath(_ assetStr: NSString) -> NSString {
        let assetArr = assetStr.components(separatedBy: "/") as NSArray
        let filePath = String(format: "%@/%@", fabDocumentsDirectory,assetArr.lastObject as! NSString) as NSString
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
                    print(response.destinationURL!)
                }
                else{
                }
            }
        }
        else{
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension FABDetailsViewController :  UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DataCell"
        //let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        let cell : UITableViewCell = dataTblView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let localLangLbl: UILabel? = cell.contentView.viewWithTag(100) as? UILabel
        localLangLbl?.numberOfLines = 0
        if mutArrayToDisplay.count > 0 {
            let msg = (mutArrayToDisplay.object(at: a!) as! NSDictionary).value(forKey: "message") as? String
            localLangLbl?.text = msg!
        }
        else{
            localLangLbl?.text = ""
        }
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 14.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 30
//    }
    
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
    
//     func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        
//        let footerView = UIView(frame: CGRect.init(x: 0, y: tableView.frame.size.height-50, width: tableView.frame.size.width, height: 40))
//        footerView.backgroundColor = UIColor.gray
//        
//        return footerView
//    }
//    
//     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 40.0
//    }
}

extension FABDetailsViewController :  UICollectionViewDataSource, UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == headerCollectionView {
            return 3
        }
        return assetsCountMutArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if collectionView == headerCollectionView {
            let cellIdentifier: String = "HeaderCell"
            let cell: UICollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            let lbl1: UILabel? = (cell?.contentView.viewWithTag(100) as? UILabel)
            
            ///This temp variable is used to display headers for the collectionView till we get the response from the server.(instead of displaying blank titles)
            let tempTitleArr = [NSLocalizedString("features", comment: ""),NSLocalizedString("advantages", comment: ""),NSLocalizedString("benifits", comment: "")] as NSArray
            if mutArrayToDisplay.count > 0 {
            
                let typeStr =  ((mutArrayToDisplay.object(at: indexPath.row) as! NSDictionary).value(forKey: "Title") as? String)
                
                if  typeStr?.lowercased() == "features" {
                     lbl1?.text = NSLocalizedString("features1", comment: "")
                }else if typeStr?.lowercased() == "advantages"{
                      lbl1?.text = NSLocalizedString("advantages", comment: "")
                }else if typeStr?.lowercased() == "benefits" {
                     lbl1?.text = NSLocalizedString("benifits", comment: "")
                }
            }
            else{
                lbl1?.text = tempTitleArr.object(at: indexPath.row) as? String
            }
            lbl1?.textColor = UIColor.white
            let selectedView: UIView? = (cell?.contentView.viewWithTag(101))
            if indexPath.row == a {
                selectedView?.isHidden = false
                cell?.contentView.backgroundColor = App_Theme_Orange_Color//UIColor (red: 255.0/255, green: 214.0/255, blue: 51.0/255, alpha: 1.0)
            }
            else {
                selectedView?.isHidden = true
                cell?.contentView.backgroundColor = App_Theme_Blue_Color
            }
            return cell!
        }
        else{
            let cellIdentifier: String = "AssetsCell"
            let cell: UICollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            let imgView: UIImageView? = (cell?.contentView.viewWithTag(101) as? UIImageView)
            imgView?.image = UIImage(named: assetsCountMutArray.object(at: indexPath.row) as! String)
            return cell!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == headerCollectionView {
            a! = indexPath.row
            dataTblView.reloadData()
            headerCollectionView.reloadData()
            
            assetsCountMutArray.removeAllObjects()
            
            if mutArrayToDisplay.count > 0 {
                let checkPdfFileKey = (Validations.checkKeyNotAvail((mutArrayToDisplay.object(at: a!) as! NSDictionary), key: "pdfFile") as?NSString)!
                let pdfFileAvailable = Validations.isNullString(checkPdfFileKey)
                if pdfFileAvailable == false {//not null
                    assetsCountMutArray.add("FabDetailsPdfIcon")
                }
                
                let checkImgKey = (Validations.checkKeyNotAvail((mutArrayToDisplay.object(at: a!) as! NSDictionary), key: "images") as?NSString)!
                let imgsAvailable = Validations.isNullString(checkImgKey)
                if imgsAvailable == false {
                    assetsCountMutArray.add("FabDetailsImgIcon")
                }
                
                //let voiceFileAvailable = Validations.isNullString((mutArrayToDisplay.object(at: a!) as! NSDictionary).value(forKey: "voiceFile") as! NSString)
                
                let checkVoiceFileKey = (Validations.checkKeyNotAvail((mutArrayToDisplay.object(at: a!) as! NSDictionary), key: "voiceFile") as?NSString)!
                let voiceFileAvailable = Validations.isNullString(checkVoiceFileKey)
                if voiceFileAvailable == false {//not null
                    assetsCountMutArray.add("FabDetailsAudioIcon")
                }
                
                let checkVideoFileKey = (Validations.checkKeyNotAvail((mutArrayToDisplay.object(at: a!) as! NSDictionary), key: "videoFile") as?NSString)!
                let videoFileAvailable = Validations.isNullString(checkVideoFileKey)
                if videoFileAvailable == false {//not null
                    assetsCountMutArray.add("FabDetailsVideoIcon")
                }
                collectionViewToDisplayAssets.reloadData()
            }
            if self.a == 0 {
                self.registerFirebaseEvents(PV_Features_Tab, "", "", "", parameters: nil)
            }
            else if self.a == 1{
                self.registerFirebaseEvents(PV_Advantages_Tab, "", "", "", parameters: nil)
            }
            else if self.a == 2{
                self.registerFirebaseEvents(PV_Benefits_Tab, "", "", "", parameters: nil)
            }
        }
        else{
            let checkStr = assetsCountMutArray.object(at: indexPath.row) as! NSString
            if checkStr == "FabDetailsImgIcon"{
                let net = NetworkReachabilityManager(host: "www.google.com")
                if net?.isReachable == true{
                    let toFABImagesVC = self.storyboard?.instantiateViewController(withIdentifier: "FABImagesViewController") as! FABImagesViewController
                    toFABImagesVC.assetDictFromFABDetailsVC = mutArrayToDisplay.object(at: a!) as? NSDictionary
                    self.present(toFABImagesVC, animated: true, completion: nil)
                }
                else{
                    let imagesArrToCheckInDocDir = ((mutArrayToDisplay.object(at: a!) as! NSDictionary).value(forKey: "images") as! NSString).components(separatedBy: "#") as NSArray
                    let docPath = self.getDocumentPath(imagesArrToCheckInDocDir.object(at: 0) as! NSString)
                    let isFileExists = self.checkIfFileExists(atPath: docPath as String)
                    if isFileExists == true {
                        let toFABImagesVC = self.storyboard?.instantiateViewController(withIdentifier: "FABImagesViewController") as! FABImagesViewController
                        toFABImagesVC.assetDictFromFABDetailsVC = mutArrayToDisplay.object(at: a!) as? NSDictionary
                        self.present(toFABImagesVC, animated: true, completion: nil)
                    }
                    else{
                       // self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE, duration: 1.0, position: .center)
                         self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                        return
                    }
                }
                if self.a == 0 {
                    self.registerFirebaseEvents(FAB_Features_Image, "", "", "", parameters: nil)
                }
                else if self.a == 1{
                    self.registerFirebaseEvents(FAB_Advantages_Image, "", "", "", parameters: nil)
                }
                else if self.a == 2{
                    self.registerFirebaseEvents(FAB_Benefits_Image, "", "", "", parameters: nil)
                }
            }
            else if checkStr == "FabDetailsAudioIcon"{
                let net = NetworkReachabilityManager(host: "www.google.com")
                if net?.isReachable == true{
                    let toFABAudioVC = self.storyboard?.instantiateViewController(withIdentifier: "FABAudioViewController") as! FABAudioViewController
                    toFABAudioVC.assetDictFromFABDetailsVC = mutArrayToDisplay.object(at: a!) as? NSDictionary
                    self.present(toFABAudioVC, animated: true, completion: nil)
                }
                else{
                    let audioFileObj = mutArrayToDisplay.object(at: a!) as? NSDictionary
                    let docPath = self.getDocumentPath(audioFileObj?.value(forKey: "voiceFile") as! NSString)
                    let isFileExists = self.checkIfFileExists(atPath: docPath as String)
                    if isFileExists == true {
                        let toFABAudioVC = self.storyboard?.instantiateViewController(withIdentifier: "FABAudioViewController") as! FABAudioViewController
                        toFABAudioVC.assetDictFromFABDetailsVC = mutArrayToDisplay.object(at: a!) as? NSDictionary
                        self.present(toFABAudioVC, animated: true, completion: nil)
                    }
                    else{
                        //self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE, duration: 1.0, position: .center)
                         self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                        return
                    }
                }
                if self.a == 0 {
                    self.registerFirebaseEvents(FAB_Features_Audio, "", "", "", parameters: nil)
                }
                else if self.a == 1{
                    self.registerFirebaseEvents(FAB_Advantages_Audio, "", "", "", parameters: nil)
                }
                else if self.a == 2{
                    self.registerFirebaseEvents(FAB_Benefits_Audio, "", "", "", parameters: nil)
                }
            }
            else if checkStr == "FabDetailsPdfIcon"{
                let net = NetworkReachabilityManager(host: "www.google.com")
                if net?.isReachable == true{
                    let toFABPdfVC = self.storyboard?.instantiateViewController(withIdentifier: "FABPdfViewController") as! FABPdfViewController
                    toFABPdfVC.assetDictFromFABDetailsVC = mutArrayToDisplay.object(at: a!) as? NSDictionary
                    self.present(toFABPdfVC, animated: true, completion: nil)
                }
                else{
                let pdfFileObj = mutArrayToDisplay.object(at: a!) as? NSDictionary
                let docPath = self.getDocumentPath(pdfFileObj?.value(forKey: "pdfFile") as! NSString)
                let isFileExists = self.checkIfFileExists(atPath: docPath as String)
                if isFileExists == true {
                    let toFABPdfVC = self.storyboard?.instantiateViewController(withIdentifier: "FABPdfViewController") as! FABPdfViewController
                    toFABPdfVC.assetDictFromFABDetailsVC = mutArrayToDisplay.object(at: a!) as? NSDictionary
                    self.present(toFABPdfVC, animated: true, completion: nil)
                }
                else{
                    //self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE, duration: 1.0, position: .center)
                     self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                    return
                    }
                }
                if self.a == 0 {
                    self.registerFirebaseEvents(FAB_Features_Pdf, "", "", "", parameters: nil)
                }
                else if self.a == 1{
                    self.registerFirebaseEvents(FAB_Advantages_Pdf, "", "", "", parameters: nil)
                }
                else if self.a == 2{
                    self.registerFirebaseEvents(FAB_Benefits_Pdf, "", "", "", parameters: nil)
                }
            }
            else if checkStr == "FabDetailsVideoIcon"{
                let urlStr = (mutArrayToDisplay.object(at: a!) as! NSDictionary).value(forKey: "videoFile") as! NSString
                let assetArr = urlStr.components(separatedBy: "/") as NSArray
                let fileExtensionStr = assetArr.lastObject as! NSString
                let fileExtensionArr = fileExtensionStr.components(separatedBy: ".") as NSArray
                let gifStr = fileExtensionArr[1] as! String
                if gifStr == "gif"{
                    let net = NetworkReachabilityManager(host: "www.google.com")
                    if net?.isReachable == true{
                    let toFABGifVC = self.storyboard?.instantiateViewController(withIdentifier: "FABGIFImageViewController") as! FABGIFImageViewController
                    toFABGifVC.assetDictFromFABDetailsVC = mutArrayToDisplay.object(at: a!) as? NSDictionary
                    self.present(toFABGifVC, animated: true, completion: nil)
                    }
                    else{
                        let gifFileObj = mutArrayToDisplay.object(at: a!) as? NSDictionary
                        let docPath = self.getDocumentPath(gifFileObj?.value(forKey: "videoFile") as! NSString)
                        let isFileExists = self.checkIfFileExists(atPath: docPath as String)
                        if isFileExists == true {
                            let toFABGifVC = self.storyboard?.instantiateViewController(withIdentifier: "FABGIFImageViewController") as! FABGIFImageViewController
                            toFABGifVC.assetDictFromFABDetailsVC = mutArrayToDisplay.object(at: a!) as? NSDictionary
                            self.present(toFABGifVC, animated: true, completion: nil)
                        }
                        else{
                            //self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE, duration: 1.0, position: .center)
                             self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                            return
                        }
                    }
                }
                else{
                    let videoFileObj = mutArrayToDisplay.object(at: a!) as? NSDictionary
                    let docPath = self.getDocumentPath(videoFileObj?.value(forKey: "videoFile") as! NSString)
                    let isFileExists = self.checkIfFileExists(atPath: docPath as String)
                    if isFileExists == true {
                        /***** av player controller *********/
                        let url = NSURL(fileURLWithPath: docPath as String)
                        let player = AVPlayer(url:url as URL)
                        playerController = AVPlayerViewController()
                        playerController?.player = player
                        //playerController?.allowsPictureInPicturePlayback = false
                        //playerController?.delegate = self
                        NotificationCenter.default.addObserver(self, selector: #selector(FABDetailsViewController.didfinishplaying(note:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                        self.present(playerController!, animated: true, completion: nil)
                        /***** av player controller *********/
                    }
                    else{
                        let net = NetworkReachabilityManager(host: "www.google.com")
                        if net?.isReachable == true{
                            let url =  NSURL(string: videoFileObj?.value(forKey: "videoFile") as! String)
                            let player = AVPlayer(url:url! as URL)
                            playerController = AVPlayerViewController()
                            playerController?.player = player
                            //playerController?.allowsPictureInPicturePlayback = false
                            // playerController?.delegate = self
                            self.present(playerController!, animated: true, completion: nil)
                            NotificationCenter.default.addObserver(self, selector: #selector(FABDetailsViewController.didfinishplaying(note:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                            
                            DispatchQueue.global().async {
                                self.downloadAssetAndStore(inDocumentsDirectory: videoFileObj?.value(forKey: "videoFile") as! NSString)
                            }
                        }
                        else{
                           // self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE, duration: 1.0, position: .center)
                             self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                            return
                        }
                    }
                }
                if self.a == 0 {
                    self.registerFirebaseEvents(FAB_Features_Video, "", "", "", parameters: nil)
                }
                else if self.a == 1{
                    self.registerFirebaseEvents(FAB_Advantages_Video, "", "", "", parameters: nil)
                }
                else if self.a == 2{
                    self.registerFirebaseEvents(FAB_Benefits_Video, "", "", "", parameters: nil)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == headerCollectionView {
            return CGSize(width: collectionView.bounds.size.width/3, height: 40)
        }
        return CGSize(width: collectionView.bounds.size.width/CGFloat(assetsCountMutArray.count), height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(1, 1, 1, -10)//top,left,bottom,right
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    //Notification Observer -video didfinishplaying
    @objc func didfinishplaying(note : NSNotification)
    {
        playerController?.dismiss(animated: true,completion: nil)
    }
}

