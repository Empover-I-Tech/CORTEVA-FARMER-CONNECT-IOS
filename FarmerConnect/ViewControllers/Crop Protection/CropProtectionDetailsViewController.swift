//
//  CropProtectionDetailsViewController.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 29/03/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class CropProtectionDetailsViewController: BaseViewController,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var btnEnglish : UIButton!
     @IBOutlet weak var btnLocal : UIButton!
    @IBOutlet weak var viewImages : UIView!
    @IBOutlet weak var viewFAB : UIView!
    
    @IBOutlet weak var cvImages : UICollectionView!
    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var dataTblView: UITableView!
    
    @IBOutlet weak var FABViewHgtCons: NSLayoutConstraint!
    @IBOutlet weak var dosageGridViewHgtCons: NSLayoutConstraint!
    @IBOutlet weak var tableHgtCon: NSLayoutConstraint!
    
    @IBOutlet weak var buyFormRetailerBtn: UIButton!
    
   
    var cropName : String  = ""
    var diseaseName : String  = ""
    var productName : String  = ""
    
    
      @IBOutlet weak var lbl_Description : UILabel!
    
    var imgesArray = [String]()
    
    var stateNamesArray = NSMutableArray()
    var cropNamesArray = NSMutableArray()
    var diseaseNameArray = NSMutableArray()
    var productNamesArray = NSMutableArray()
    
    var stateArray = NSArray()
    var cropArray = NSArray()
    var diseaseArray = NSArray()
    var productArray = NSArray()
    
    ///main array to store the FAB data and used to display on tableView
    var mutArrayToDisplay = NSMutableArray()
      var mutDictToStoreDBData = NSMutableDictionary()
    
    var version = NSString()
    
    var a : NSInteger? = 0
    var fabAlertView = UIView()
    

    var assetsCountMutArray = NSMutableArray()
    
    /// used to iterate through mutArrToStoreAllAssetsOfFAB while downloading the assets
    var currentIndex:Int = 0
    
    ///This array stores all assets of FAB,and used this array to download the assets.
    var mutArrToStoreAllAssetsOfFAB = NSMutableArray()
    
    var fabDocumentsDirectory = NSString()
    
    var t_count:Int = 0
    var lastCell: StackViewCell = StackViewCell()
    var button_tag:Int = -1
    var jobs = [String]()
    
    @IBOutlet weak var dosageTableTitle : UILabel!
    @IBOutlet weak var dosageTableView : UITableView!
    @IBOutlet weak var dosageItemWidthCons :  NSLayoutConstraint!
    
    var dosageArray = [TableData]()
    var dosageLocArray = [TableData]()
    var numberOfRows  = Int()
    var numberofColumns = Int()
    var dosageTitle : String = ""
     var descriptionStr : String = ""
    
    var advantageEngMessagesArray =  [String]()
    var advantageLocMessagesArray =  [String]()
    var featureEngMessagesArray =  [String]()
    var featureLocMessagesArray =  [String]()
    var benefitsEngMessagesArray =  [String]()
    var benefitsLocMessagesArray =  [String]()
    
    
    var  isEnglishSelected : Bool = true
   var isLocalSelected : Bool = false
    var selectedTab : String = "Features"
    
    var engkeys : String = ""
    var lockeys : String = ""
    
    var stateId : String = ""
    var cropId : String = ""
    var diseaseId : String = ""
    var productId : String = ""
    
    
   var dosageEngTitle : String = ""
  var dosageLocTitle : String = ""
  var descriptionEngStr : String = ""
  var descriptionLocStr : String = ""
    
       var arrItems = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.headerCollectionView.roundCorners(corners: [.topLeft,.topRight], radius: 20)
        self.headerCollectionView.cornerRadius = 10
        self.dataTblView.register(UINib(nibName: "StackViewCell", bundle: nil), forCellReuseIdentifier: "StackViewCell")
        let userObj = Constatnts.getUserObject()
              let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: FAB_CP_Details_Screen] as [String : Any]
              self.recordScreenView("CropProtectionDetailsViewController", FAB_CP_Details_Screen)
              self.registerFirebaseEvents(PV_CP_FAB_Details, "", "", "", parameters: firebaseParams as NSDictionary)
        
      
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
            
            "eventName": PV_CP_FAB_Details,
            "className":"CropProtectionDetailsViewController",
            "moduleName":"CPFAB",
            
            "healthCardId":"",
            "productId":self.productId,
            "cropId":self.cropId,
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
    @IBAction func buyFormRetailerBtnAction(_ sender: Any) {
        let rewardsVC = self.storyboard?.instantiateViewController(withIdentifier: "NearByViewController") as? NearByViewController
        rewardsVC?.isFromHome = true
        self.navigationController?.pushViewController(rewardsVC!, animated: true)
    }
    func snapshot() -> UIImage?
    {
        UIGraphicsBeginImageContext(scrollView.contentSize)

        let savedContentOffset = scrollView.contentOffset
        let savedFrame = scrollView.frame

        scrollView.contentOffset = CGPoint.zero
        scrollView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)

        scrollView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()

        scrollView.contentOffset = savedContentOffset
        scrollView.frame = savedFrame

        UIGraphicsEndImageContext()

        return image
    }
    
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        self.topView?.isHidden = false
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        buyFormRetailerBtn.setTitle("buyFromRetailer".localized, for: .normal)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.cvImages.dataSource = self
        self.cvImages.delegate = self
        
         self.headerCollectionView.dataSource = self
         self.headerCollectionView.delegate = self
        
         self.dataTblView.dataSource = self
         self.dataTblView.delegate = self
        
         self.dosageTableView.dataSource = self
         self.dosageTableView.delegate = self
        
        self.lblTitle!.text  = self.cropName + " " + self.diseaseName + " " + self.productName
 
//         self.dataTblView.separatorStyle = UITableViewCellSeparatorStyle.none
//         self.dataTblView.rowHeight = UITableViewAutomaticDimension
//         self.dataTblView.estimatedRowHeight = 250
        
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(FABDetailsViewController.swipeLeft))
        leftSwipeGesture.delegate = self
        leftSwipeGesture.direction = .left
         self.dataTblView.addGestureRecognizer(leftSwipeGesture)
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(FABDetailsViewController.swipeRight))
        rightSwipeGesture.delegate = self
        rightSwipeGesture.direction = .right
         self.dataTblView.addGestureRecognizer(rightSwipeGesture)
        
        let shareButton = UIButton(frame: CGRect(x:UIScreen.main.bounds.size.width-42,y: 6,width: 40,height: 40))
        shareButton.backgroundColor =  UIColor.clear
        shareButton.setImage( UIImage(named: "Share"), for: UIControlState())
        shareButton.addTarget(self, action: #selector(CropProtectionDetailsViewController.shareButtonClick(_:)), for: UIControlEvents.touchUpInside)
        self.topView?.addSubview(shareButton)
         
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let retrievedArrFromDB = appDelegate.getFAB_CP_DetailsFromDB("FAB_CPDetails")
            //print(retrievedArrFromDB)
            let dbPredicate = NSPredicate(format: "productId = %@",productId)
            let outputFilteredArr = (retrievedArrFromDB).filtered(using: dbPredicate) as NSArray
            if outputFilteredArr.count > 0{
                let fabObj = outputFilteredArr.object(at: 0) as? FAB_CPDetailsEntity
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
            var desID = "0"
            if diseaseId == ""{
                desID  = "0"
            }else {
                desID  = diseaseId
            }
            let parameters = ["stateId":stateId,"cropId":cropId,"diseaseId":desID,"productId":productId,"version" : version] as NSDictionary
            let paramsStr1 = Constatnts.nsobjectToJSON(parameters as NSDictionary)
            let params =  ["data": paramsStr1]
//            DispatchQueue.main.async{
//            self.requestToGetFABDetailsData(Params: params)
//            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                print("do action after 0.2 seconds")
                self.requestToGetFABDetailsData(Params: params)
            }
        }
        else{
            self.updateUI()
        }
    }
    @IBAction func shareButtonClick( _ sender: UIButton)
    {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        var message = ""
//        let retrievedArrFromDB = appDelegate.getFAB_CP_DetailsFromDB("FAB_CPDetails")
//        // print(retrievedArrFromDB)
//        let dbPredicate = NSPredicate(format: "stateId = %@ && cropId = %@ && diseaseId = %@ && productId = %@",stateId,cropId,diseaseId,productId)
//        let outputFilteredArr = (retrievedArrFromDB).filtered(using: dbPredicate) as NSArray
//        if outputFilteredArr.count > 0 {
//            let fabObj = outputFilteredArr.object(at: 0) as? FAB_CPDetailsEntity
//
//            //FirebaseEvents
//            let userObj = Constatnts.getUserObject()
//            let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,STATE:fabObj?.stateId ?? "",CROP:fabObj?.crop ?? "",DISEASEID:fabObj?.diseaseId ?? "",PRODUCT:fabObj?.productId ?? "",Screen_Name_Param: FAB_CP_Details_Screen] as [String : Any]
//            self.registerFirebaseEvents(PV_CP_FAB_Details_Share, "", "", "", parameters: firebaseParams as NSDictionary)
//
//            message = String(format: "FABCropProtection %@ %@ %@ %@", fabObj?.stateId ?? "", fabObj?.productId ?? "",fabObj?.crop ?? "",fabObj?.diseaseId ?? "")
//        }
//
//        let urlPath = String(format: "%@=%@&%@=%@&%@=%@&%@=%@&%@=%@", Module,FAB_CP,State_Id,stateId,Crop_Id,cropId,DISEASE,diseaseId,PRODUCT,productId)
 //       let finalUrl = String(format: "%@%@", deepLinkBaseUrl,urlPath)
//        let activityControl = Validations.showShareActivityController(viewController: self, fileUrl: URL(string: finalUrl)!, userName: "", message: message)
//        //retrieve fab details from DB
//        self.present(activityControl, animated: true, completion: nil)
        
//        let imgRect:CGRect = CGRect(x: 202, y: 0, width: 380, height: 650)
//        let custImg = UIImage.init(view: self.drawView())
//
//        let imageShare = [ custImg ]
//        let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
//
//       activityViewController.popoverPresentationController?.sourceView = self.view
//        self.present(activityViewController, animated: true, completion: nil)
        
        let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "CropProtectionDetailsShareController") as? CropProtectionDetailsShareController
        detailsVC?.imgesArray = self.imgesArray
        detailsVC?.dosageArray = self.dosageArray
        detailsVC?.dosageLocArray = self.dosageLocArray
        detailsVC?.mutArrayToDisplay = self.mutArrayToDisplay
         detailsVC?.arrItems =  self.arrItems
        detailsVC?.cropName =  self.cropName
        detailsVC?.diseaseName =  self.diseaseName
         detailsVC?.productName =  self.productName
        detailsVC?.dosageEngTitle = self.dosageEngTitle
        detailsVC?.dosageLocTitle = self.dosageLocTitle
         detailsVC?.descriptionEngStr = self.descriptionEngStr
         detailsVC?.descriptionLocStr = self.descriptionLocStr
        let userObj = Constatnts.getUserObject()
        let fireBaseParams = [MOBILE_NUMBER : userObj.mobileNumber ?? "",USER_ID : userObj.customerId! ,CROP:self.cropName,PRODUCT:self.productName,DISEASEID:self.diseaseName] as [String : Any]
        self.registerFirebaseEvents(PV_CPFAB_CDP, "", "", FAB_CP_Screen, parameters: fireBaseParams as NSDictionary)
        self.navigationController?.pushViewController(detailsVC!, animated: true)
 }
    
    
       func captureScreen() -> UIImage?{
           let screenRect: CGRect = UIScreen.main.bounds
           UIGraphicsBeginImageContext(screenRect.size)
           
           let ctx = UIGraphicsGetCurrentContext()
           UIColor.white.set()
           ctx?.fill(screenRect)
           let window: UIWindow? = UIApplication.shared.keyWindow
           if let aCtx = ctx {
               window?.layer.render(in: aCtx)
           }
           let screenImg: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           return screenImg
       }
    func requestToGetFABDetailsData (Params : [String:String]){
        SwiftLoader.show(animated: true)
        let noDataStr = NSLocalizedString("no_data_available",comment: "")
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_FAB_CP_DETAILS])
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
                    print("Response :\(json)")
                    let responseStatusCode = (json as? NSDictionary)?.value(forKey: "statusCode") as? String
                    if responseStatusCode == STATUS_CODE_200{
                        self.lblNoDataFound.isHidden = true
                      
                        let respData = (json as? NSDictionary)?.value(forKey: "response") as? NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String? ?? "")
                        print("Response after decrypting data:\(decryptData)")
                        
                        //Firebase Events
                        
                        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: FAB_CP_Details_Screen] as [String : Any]
                        self.registerFirebaseEvents(PV_CP_FAB_Details_Success, "", "", "", parameters: firebaseParams as NSDictionary)
                        
                        let dataMutArr = NSMutableArray()
                        let featuresDict = NSMutableDictionary()
                        featuresDict.setValue("Features", forKey: "Title")
                        
                        // FAB DropDown Data
                        
                        let featureMessageDict = decryptData["f_message"] as? NSDictionary
                        let featureEngMsg = featureMessageDict?["englishMsg"] as? NSArray
                        let featureLocalMsg = featureMessageDict?.value(forKey: "localMsg") as? NSArray
                        
                        // Advantage TAB
                        
                        //Messages English
                        self.featureEngMessagesArray.removeAll()
                        for (i,x) in featureEngMsg!.enumerated() {
                            self.featureEngMessagesArray.append(featureEngMsg![i] as? String ?? "")
                        }
                        
                        // localMEssages
                        self.featureLocMessagesArray.removeAll()
                        for (i,x) in featureLocalMsg!.enumerated() {
                            self.featureLocMessagesArray.append(featureLocalMsg?[i] as? String ?? "")
                        }
                        featuresDict.setValue(self.featureEngMessagesArray, forKey: "englishMsg")
                        featuresDict.setValue(self.featureLocMessagesArray, forKey: "localMsg")
                        dataMutArr.add(featuresDict)
                        
                        
                        
                        let advantagesDict = NSMutableDictionary()
                        advantagesDict.setValue("Advantages", forKey: "Title")
                        
                        let advantageMessageDict = decryptData["a_message"] as? NSDictionary
                        let advantageEngMsg = advantageMessageDict?.value(forKey: "englishMsg") as? NSArray
                        let advantageLocalMsg = advantageMessageDict?.value(forKey: "localMsg") as? NSArray
                        
                        // Advantage TAB
                        
                        //Messages English
                        self.advantageEngMessagesArray.removeAll()
                        for (i,x) in advantageEngMsg!.enumerated() {
                            self.advantageEngMessagesArray.append(advantageEngMsg?[i] as? String ?? "")
                        }
                        
                        // localMEssages
                        self.advantageLocMessagesArray.removeAll()
                        for (i,x) in advantageLocalMsg!.enumerated() {
                            self.advantageLocMessagesArray.append(advantageLocalMsg?[i] as? String ?? "")
                        }
                        advantagesDict.setValue(self.advantageEngMessagesArray, forKey: "englishMsg")
                        advantagesDict.setValue(self.advantageLocMessagesArray, forKey: "localMsg")
                        dataMutArr.add(advantagesDict)
                        
                        
                        let benefitsDict = NSMutableDictionary()
                        benefitsDict.setValue("Benefits", forKey: "Title")
                        
                        let benefitMessageDict = decryptData["b_message"] as? NSDictionary
                        let benefitEngMsg = (benefitMessageDict as AnyObject).value(forKey: "englishMsg") as? NSArray
                        let benefitLocalMsg = (benefitMessageDict as AnyObject).value(forKey: "localMsg") as? NSArray
                        
                        // Advantage TAB
                        
                        //Messages English
                        self.benefitsEngMessagesArray.removeAll()
                        for (i,x) in benefitEngMsg!.enumerated() {
                            self.benefitsEngMessagesArray.append(benefitEngMsg?[i] as? String ?? "")
                        }
                        
                        // localMEssages
                        self.benefitsLocMessagesArray.removeAll()
                        for (i,x) in benefitLocalMsg!.enumerated() {
                            self.benefitsLocMessagesArray.append(benefitLocalMsg?[i] as? String ?? "")
                        }
                        benefitsDict.setValue(self.benefitsEngMessagesArray, forKey: "englishMsg")
                        benefitsDict.setValue(self.benefitsLocMessagesArray, forKey: "localMsg")
                        dataMutArr.add(benefitsDict)
                        
                        // print(dataMutArr)
                        
                        let fabDetails  = FAB_CPDetailsEntity(dict: NSMutableDictionary())
                        
                        
                        fabDetails.id = decryptData["id"] as? NSString ?? ""
                        fabDetails.version = decryptData["version"] as? NSString ?? ""
                        fabDetails.productId = decryptData["productId"] as? NSString ?? ""
                        fabDetails.productName = decryptData["product"] as? NSString ?? ""
                        fabDetails.productImageUrl = decryptData["productImageUrl"] as? NSString ?? ""
                        fabDetails.diseaseImageUrl = decryptData["diseaseImageUrl"] as? NSString ?? ""
                        fabDetails.productFormulation = decryptData["productFormulation"] as? NSString ?? ""
                        fabDetails.product_images_urls = decryptData["product_images_urls"] as? NSString ?? ""
                        fabDetails.diseaseType = decryptData["diseaseType"] as? NSString ?? ""
                        fabDetails.cropImageUrl = decryptData["cropImageUrl"] as? NSString ?? ""
                        fabDetails.cropId = decryptData["cropId"] as? NSString ?? ""
                        fabDetails.crop = decryptData["crop"] as? NSString ?? ""
                        fabDetails.diseaseId = decryptData["diseaseId"] as? NSString ?? ""
                        fabDetails.diseaseName = decryptData["disease"] as? NSString ?? ""
                        fabDetails.stateId = decryptData["stateId"] as? NSString ?? ""
                        fabDetails.state = decryptData["state"] as? NSString ?? ""
                        fabDetails.des_englishMsg = decryptData["des_englishMsg"] as? NSString ?? ""
                        fabDetails.des_localMsg = decryptData["des_localMsg"] as? NSString ?? ""
                        
                        fabDetails.fabCPDataArray = dataMutArr
                        // DosageTable Data Loading
                        let mutArr = decryptData["dose"] as? NSDictionary
                        let doseTableArray =  (mutArr?.value(forKey: "tableData_eng") as? NSArray)!
                        let doseTableLocArray =  (mutArr?.value(forKey: "tableData_loc") as? NSArray)!
                        self.numberOfRows = mutArr?.value(forKey: "noofRows") as? Int ?? 0
                        self.numberofColumns = mutArr?.value(forKey: "noOfColumns") as? Int ?? 0
                         let dosageStr  = NSLocalizedString("Dose(Formulation/Acre)", comment: "")
                        fabDetails.tableHeader = mutArr?.value(forKey: "tableHeader_eng") as? String as NSString? ?? dosageStr as NSString
                        fabDetails.tableLocHeader = mutArr?.value(forKey: "tableHeader_loc") as? String as NSString? ?? dosageStr as NSString
                        
                        //                for (i,x) in doseTableArray.enumerated() {
                        //                                self.dosageArray.removeAll()
                        //                                var tableInfo =  TableData()
                        //                                tableInfo.columnOne = (x as AnyObject)["columnOne"] as? String ?? ""
                        //                                tableInfo.columnTwo = (x as AnyObject)["columnTwo"] as? String ?? ""
                        //                                tableInfo.columnThree = (x as AnyObject)["columnThree"] as? String ?? ""
                        //                                tableInfo.columnFour = (x as AnyObject)["columnFour"] as? String ?? ""
                        //                                self.dosageArray.append(tableInfo)
                        //                            }
                        let dosageDataMutArr = NSMutableArray()
                        
                        
                        for i in doseTableArray {
                            let tableDataDict = NSMutableDictionary()
                            var tableInfo =  TableData()
                            let q =   (i as? NSDictionary)?.allKeys as NSArray?
                           // let getDic:Dictionary = q
                            if (q?.contains("columnOne"))!{
                                //NSArray *result = [dictionaryObject valueForKeyPath:@"preference"];
                                tableInfo.columnOne = (i as AnyObject).value(forKey: "columnOne") as! String
                                //(i as AnyObject)["columnOne"] as? String ?? ""
                                tableDataDict.setValue(tableInfo.columnOne, forKey: "columnOne")
                            }
                            if (q?.contains("columnTwo"))!{
                                tableInfo.columnTwo = (i as AnyObject).value(forKey: "columnTwo") as! String
                                 tableDataDict.setValue(tableInfo.columnTwo, forKey: "columnTwo")
                            }
                            if (q?.contains("columnThree"))!{
                                tableInfo.columnThree = (i as AnyObject).value(forKey: "columnThree") as! String
                                  tableDataDict.setValue(tableInfo.columnThree, forKey: "columnThree")
                            }
                            if (q?.contains("columnFour"))!{
                                tableInfo.columnFour = (i as AnyObject).value(forKey: "columnFour") as! String
                                tableDataDict.setValue(tableInfo.columnFour, forKey: "columnFour")
                            }
                            
                            
                            dosageDataMutArr.add(tableDataDict)
                        }
                        fabDetails.tableData = dosageDataMutArr
                        
                        
                        let dosageDataLocMutArr = NSMutableArray()
                        
                        
                        for i in doseTableLocArray {
                            let tableDataDict = NSMutableDictionary()
                            var tableInfo =  TableData()
                            let q =   (i as? NSDictionary)?.allKeys as NSArray?
                            if (q?.contains("columnOne"))!{
                                tableInfo.columnOne = (i as AnyObject).value(forKey: "columnOne") as! String
                                //(i as AnyObject)["columnOne"] as? String ?? ""
                                tableDataDict.setValue(tableInfo.columnOne, forKey: "columnOne")
                            }
                            if (q?.contains("columnTwo"))!{
                                tableInfo.columnTwo = (i as AnyObject).value(forKey: "columnTwo") as! String
                                //(i as AnyObject)["columnTwo"] as? String ?? ""
                                 tableDataDict.setValue(tableInfo.columnTwo, forKey: "columnTwo")
                            }
                            if (q?.contains("columnThree"))!{
                                tableInfo.columnThree = (i as AnyObject).value(forKey: "columnThree") as! String
                                //(i as AnyObject)["columnThree"] as? String ?? ""
                                tableDataDict.setValue(tableInfo.columnThree, forKey: "columnThree")
                            }
                            if (q?.contains("columnFour"))!{
                                tableInfo.columnFour = (i as AnyObject).value(forKey: "columnFour") as! String
                                //(i as AnyObject)["columnFour"] as? String ?? ""
                                tableDataDict.setValue(tableInfo.columnFour, forKey: "columnFour")
                            }
//                            if tableInfo.columnOne != "" {
//                                tableDataDict.setValue(tableInfo.columnOne, forKey: "columnOne")
//                            }
//                            if tableInfo.columnTwo != "" {
//                                tableDataDict.setValue(tableInfo.columnTwo, forKey: "columnTwo")
//                            }
//                            if tableInfo.columnThree != "" {
//                                tableDataDict.setValue(tableInfo.columnThree, forKey: "columnThree")
//                            }
//                            if tableInfo.columnFour != "" {
//                                tableDataDict.setValue(tableInfo.columnFour, forKey: "columnFour")
//                            }
                            
                            dosageDataLocMutArr.add(tableDataDict)
                        }
                        
                        
                        
                        fabDetails.tableLocData = dosageDataLocMutArr
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        //appDelegate.deleteFABDetails()
                        appDelegate.saveFABCPDetails(fabDetails)
                        DispatchQueue.main.async{
                            self.updateUI()
                        }
                        
                    } else if responseStatusCode == STATUS_CODE_601{
                        Constatnts.logOut()
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    }else if responseStatusCode == STATUS_CODE_300{
                       
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                        self.lblNoDataFound.isHidden = false
                        self.lblNoDataFound.text  = noDataStr

                    }else if responseStatusCode == STATUS_CODE_500{
                       
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                        self.lblNoDataFound.isHidden = false
                       

                        self.lblNoDataFound.text  = noDataStr

                    }else {
                       
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                        self.lblNoDataFound.isHidden = false
                        self.lblNoDataFound.text  = "No Data Available"

                    }
                }
            }
            else{
                
                //Firebase Events
                
                let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: FAB_CP_Details_Screen] as [String : Any]
                
                self.registerFirebaseEvents(PV_CP_FAB_Details_Something_went_wrong, "", "", "", parameters: firebaseParams as NSDictionary)

                self.view.makeToast((response.result.error.debugDescription), duration: 1.0, position: .center)
                
                self.lblNoDataFound.isHidden = false
                self.lblNoDataFound.text = "No Data Available"
                return
            }
        }
    }
    //MARK : backButtonClick
    override func backButtonClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLayoutSubviews() {
        
        DispatchQueue.main.async{
            self.dataTblView.isScrollEnabled = false
             self.dosageTableView.isScrollEnabled = false
            self.FABViewHgtCons.constant = self.dataTblView.contentSize.height
            self.dosageGridViewHgtCons.constant = self.dosageTableView.contentSize.height + 60
        }
    }
}
extension CropProtectionDetailsViewController : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView ==  self.cvImages{
            return self.imgesArray.count
        }else {
            return 3
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.cvImages {
            let cell  = self.cvImages.dequeueReusableCell(withReuseIdentifier: "cvImage", for: indexPath) as! ImageCollectionViewCell
            if self.imgesArray[indexPath.row]   != "" {
                let imgStr = self.imgesArray[indexPath.row]
                let url = URL(string:imgStr )
                 cell.imageHybrid?.image = UIImage(named: "image_placeholder.png")!
                cell.imageHybrid?.sd_setImage(with: url, placeholderImage: UIImage(named: "image_placeholder.png")!, options: SDWebImageOptions.refreshCached, completed: { (img, error, _, ur) in
                    if error != nil {
                        DispatchQueue.main.async{
                            cell.imageHybrid?.image = UIImage(named: "image_placeholder.png")!
                        }
                    }else {
                        DispatchQueue.main.async{
                            cell.imageHybrid?.image = img
                        }
                    }
                })

            }else {
                DispatchQueue.main.async{
                      cell.imageHybrid?.image = UIImage(named: "image_placeholder.png")!
                }
            }
            
            if self.imgesArray.count == 1 {
                cell.btnPrevious.isHidden = true
                cell.btnNext.isHidden = true
            }else {
                cell.btnPrevious.isHidden = false
                cell.btnNext.isHidden = false
            }
            cell.btnNext.tag = indexPath.row
            cell.btnPrevious.tag = indexPath.row
            cell.btnNext.addTarget(self, action: #selector(CropProtectionDetailsViewController.btnNextAction(_:)), for: .touchUpInside)
            cell.btnPrevious.addTarget(self, action: #selector(CropProtectionDetailsViewController.btnPreviousAction(_:)), for: .touchUpInside)
            return cell
        }else {
            let cellIdentifier: String = "HeaderCell"
            let cell: UICollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            let lbl1: UILabel? = (cell?.contentView.viewWithTag(100) as? UILabel)
            
            ///This temp variable is used to display headers for the collectionView till we get the response from the server.(instead of displaying blank titles)
            let tempTitleArr = [NSLocalizedString("features", comment: ""),NSLocalizedString("advantages", comment: ""),NSLocalizedString("benifits", comment: "")] as NSArray
            if mutArrayToDisplay.count > 0 {
                
                let typeStr =  ((mutArrayToDisplay.object(at: indexPath.row) as! NSDictionary).value(forKey: "Title") as? String)
                
                if  typeStr?.lowercased() == "features" {
                    lbl1?.text = "Features"
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
                cell?.contentView.backgroundColor = App_Theme_Orange_new_Color//UIColor (red: 255.0/255, green: 214.0/255, blue: 51.0/255, alpha: 1.0)
            }
            else {
                selectedView?.isHidden = true
                cell?.contentView.backgroundColor = App_Theme_Blue_Color
            }
            return cell!
        }
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.cvImages{
            return CGSize(width: collectionView.bounds.size.width , height: collectionView.bounds.size.height-30)
        }
            else if collectionView == headerCollectionView {
            return CGSize(width: collectionView.frame.size.width/3, height: 40)
        }
            else{
            return CGSize(width: collectionView.bounds.size.width/CGFloat(assetsCountMutArray.count), height: 35)
              
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == headerCollectionView {
            self.selectedTab  = (((mutArrayToDisplay.object(at: indexPath.row) as! NSDictionary).value(forKey: "Title") as? String)!)
            a! = indexPath.row
            self.headerCollectionView.reloadData{
                 self.dataTblView.reloadData()
            }
        }
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsetsMake(1, 1, 1, -10)//top,left,bottom,right
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 2
//    }
    
    
    @IBAction func btnNextAction(_ sender : UIButton) {
        let visibleItems: NSArray = self.cvImages.indexPathsForVisibleItems as NSArray? ?? []
        if(visibleItems.count>0){
            let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
            let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
            if nextItem.row < imgesArray.count {
                self.cvImages.scrollToItem(at: nextItem, at: .right, animated: false)
            }
        }
    }
    
    @IBAction func btnPreviousAction(_ sender: Any) {
        let visibleItems: NSArray = self.cvImages.indexPathsForVisibleItems as NSArray? ?? []
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item - 1, section: 0)
        if nextItem.row < imgesArray.count && nextItem.row >= 0{
            self.cvImages.scrollToItem(at: nextItem, at: .left, animated: false)
        }
    }
    
    }


extension CropProtectionDetailsViewController :  UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == dosageTableView {
               return 40
        }else {
        if indexPath.row == button_tag {
            return 200
        } else {
            return 60
        }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dosageTableView {
            if self.isEnglishSelected == true {
            if self.dosageArray.count > 0 {
                return self.dosageArray.count
            }else {
            return 0
            }
            }else {
                if self.dosageLocArray.count > 0 {
                    return self.dosageLocArray.count
                }else {
                return 0
                }
            }
        }else {
            if mutArrayToDisplay.count > 0 {
                engkeys  = "englishMsg"
                lockeys = "localMsg"
          
            if isEnglishSelected  == true {
                let engMessagesArr =  ((mutArrayToDisplay.object(at: a!) as! NSDictionary).value(forKey: engkeys)) as! NSArray
                return engMessagesArr.count
            }else {
                let engMessagesArr =  ((mutArrayToDisplay.object(at: a!) as! NSDictionary).value(forKey: lockeys)) as! NSArray
                return engMessagesArr.count
            }
            }else {
                return 0
            }
            }
            
        }
        
    
    @IBAction func englishLanguageSelectionButton(_ sender : UIButton) {
        let img = UIImage(named: "radioEmpty")?.withRenderingMode(.alwaysTemplate)
        let img1 = UIImage(named: "radio")?.withRenderingMode(.alwaysTemplate)
        if #available(iOS 13.0, *) {
            img?.withTintColor(.blue)
            img1?.withTintColor(.blue)
        } else {
            btnEnglish.tintColor = UIColor.blue
            btnLocal.tintColor = UIColor.darkGray
        }
        btnEnglish.titleLabel?.textColor = UIColor.darkGray
         btnLocal.titleLabel?.textColor = UIColor.darkGray
        
        btnEnglish.setImage(img1, for: .normal)
        btnLocal.setImage(img, for: .normal)
        
         self.lbl_Description?.text =  "Description :  " +  descriptionEngStr
        
        self.dosageTableTitle.text = " " + dosageEngTitle
        
        self.isEnglishSelected = true
         self.isLocalSelected = false
        self.dataTblView.reloadData()
        self.dosageTableView.reloadData()
    }
    @IBAction func localLanguageSelectionButton(_ sender : UIButton) {
         let img = UIImage(named: "radioEmpty")?.withRenderingMode(.alwaysTemplate)
          let img1 = UIImage(named: "radio")?.withRenderingMode(.alwaysTemplate)
        if #available(iOS 13.0, *) {
            img?.withTintColor(.blue)
            img1?.withTintColor(.blue)
        } else {
            btnEnglish.tintColor = UIColor.darkGray
            btnLocal.tintColor = UIColor.blue
        }
        btnEnglish.titleLabel?.textColor = UIColor.darkGray
         btnLocal.titleLabel?.textColor = UIColor.darkGray
        
        self.lbl_Description?.text = "Description :  " + descriptionLocStr
  
  
        self.dosageTableTitle.text = " " +  dosageLocTitle
        
        btnEnglish.setImage(img, for: .normal)
        btnLocal.setImage(img1, for: .normal)
        self.isEnglishSelected = false
        self.isLocalSelected = true
         self.dataTblView.reloadData()
        self.dosageTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView ==  dosageTableView {
             let cell = tableView.dequeueReusableCell(withIdentifier: "dosageCell", for: indexPath) as! DosageCell
             cell.dosageItemCollectionView.isScrollEnabled = false
            DispatchQueue.main.async {
                var dataInfo = TableData()
                if self.isEnglishSelected == true {
                    dataInfo.columnOne = self.dosageArray[indexPath.row].columnOne
                                   dataInfo.columnTwo = self.dosageArray[indexPath.row].columnTwo
                                    dataInfo.columnThree = self.dosageArray[indexPath.row].columnThree
                                    dataInfo.columnFour = self.dosageArray[indexPath.row].columnFour
                }else {
                    dataInfo.columnOne = self.dosageLocArray[indexPath.row].columnOne
                                   dataInfo.columnTwo = self.dosageLocArray[indexPath.row].columnTwo
                                    dataInfo.columnThree = self.dosageLocArray[indexPath.row].columnThree
                                    dataInfo.columnFour = self.dosageLocArray[indexPath.row].columnFour
                }
            
                 var arrI = [String]()
                if self.arrItems.contains("columnOne") {
                    arrI.append(dataInfo.columnOne)
                }
               if self.arrItems.contains("columnTwo")  {
                arrI.append( dataInfo.columnTwo)
               }
                if self.arrItems.contains("columnThree")  {
                   arrI.append(dataInfo.columnThree)
                             }
                if self.arrItems.contains("columnFour") {
                    arrI.append(dataInfo.columnFour)
                        }
               
                cell.arrDosageItems  = arrI
                cell.dosageItemCollectionView.reloadData()
            }
            return cell
        }
        else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StackViewCell", for: indexPath) as! StackViewCell
        
            if isEnglishSelected  == true {
                let engmessages =  ((mutArrayToDisplay.object(at: a!) as! NSDictionary).value(forKey: engkeys)) as! NSArray
                let engMsg = engmessages[indexPath.row] as? String
                cell.open.setTitle(engMsg , for: .normal)
                let txt =  "\(cell.open.titleLabel?.getTruncatingText(originalString: engMsg ?? "", newEllipsis: " MORE", maxLines: 2) ?? "")"
                
                let txt1 = txt.replacingOccurrences(of: "MORE", with: "")
                cell.textView.text = engMsg?.replacingOccurrences(of: txt1, with: "")
            }else {
                let engmessages =  ((mutArrayToDisplay.object(at: a!) as! NSDictionary).value(forKey: lockeys)) as! NSArray
                let engMsg = engmessages[indexPath.row] as? String
               

                cell.open.setTitle(engMsg , for: .normal)
                let txt =  "\(cell.open.titleLabel?.getTruncatingText(originalString: engMsg ?? "", newEllipsis: " MORE", maxLines: 2) ?? "")"
                let txt1 = txt.replacingOccurrences(of: "MORE", with: "")
                             cell.textView.text = engMsg?.replacingOccurrences(of: txt1, with: "")
            }
            cell.open.titleLabel?.numberOfLines = 2
             
           let lines =  self.numberOfLines(textView: cell.textView)
            
            if lines >= 2 {
                let img = UIImage(named: "downArrow")
                cell.open.setImage(img, for: .normal)
                cell.open.semanticContentAttribute = .forceRightToLeft
               
            }
           
        //cell.open.titleLabel?.numberOfLines = 2
//            button_tag = -1
        cell.openView.backgroundColor = UIColor.white
            if !cell.cellExists &&  lines >= 2{
            cell.stuffView.backgroundColor =  UIColor.white
                   cell.tag = indexPath.row
            t_count += 1
            cell.cellExists = true
            }
        UIView.animate(withDuration: 0) {
            cell.contentView.layoutIfNeeded()
        }
            if ((indexPath.row) % 2) == 0 {
                cell.open.backgroundColor = UIColor(red:193.0/255.0, green: 198.0/255.0, blue: 242.0/255.0, alpha: 1.0)
            }else {
                cell.open.backgroundColor = UIColor(red: 225.0/255.0, green: 229.0/255.0, blue: 249.0/255.0, alpha: 1.0)
            }
        return cell
        }
    }
    func numberOfLines(textView: UITextView) -> Int {
        let layoutManager = textView.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var lineRange: NSRange = NSMakeRange(0, 1)
        var index = 0
        var numberOfLines = 0

        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        return numberOfLines
    }
    
    
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let  cell = dataTblView.cellForRow(at:indexPath) as! StackViewCell
        
          let lines =  self.numberOfLines(textView: cell.textView)
        if lines >= 2 {
          
            self.dataTblView.beginUpdates()
        
            let previousCellTag = button_tag
            
            if lastCell.cellExists {
                self.lastCell.animate(duration: 0.2, c: {
                    cell.contentView.layoutIfNeeded()
                })
                
                if indexPath.row == button_tag {
                    button_tag = -1
                    lastCell = StackViewCell()
                }
            }
            
            if indexPath.row != previousCellTag {
                button_tag = indexPath.row
                print(IndexPath(row: button_tag, section: 0))
                lastCell = dataTblView.cellForRow(at: IndexPath(row: button_tag, section: 0)) as! StackViewCell
//                self.dataTblView.reloadRows(at: [indexPath], with: .fade)
                
                self.lastCell.animate(duration: 0.2, c: {
                   cell.contentView.layoutIfNeeded()
                })
            
            }
            
            self.dataTblView.endUpdates()
            DispatchQueue.main.async{
            self.dataTblView.isScrollEnabled = false
                self.tableHgtCon.constant = self.dataTblView.contentSize.height  + 20
                self.FABViewHgtCons.constant =  self.tableHgtCon.constant
                 self.dataTblView.updateConstraints()
            }
        }
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
            let checkImgKey = (Validations.checkKeyNotAvail((mutArrayToDisplay.object(at: a!) as! NSDictionary), key: "images") as?NSString)!
            let imgsAvailable = Validations.isNullString(checkImgKey)
            if imgsAvailable == false {
                assetsCountMutArray.add("FabDetailsImgIcon")
            }
            //              collectionViewToDisplayAssets.reloadData()
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
            
            //              collectionViewToDisplayAssets.reloadData()
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

    //MARK: updateUI
    func updateUI(){
        //retrieve fab details from DB
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let retrievedArrFromDB = appDelegate.getFAB_CP_DetailsFromDB("FAB_CPDetails")
        // print(retrievedArrFromDB)
        
        //          let dbPredicate = NSPredicate(format: "stateId = %@ && cropId = %@ && hybridId = %@ && seasonId = %@",stateIdFromFABVC,cropIdFromFABVC,hybridIdFromFABVC,seasonIdFromFABVC)
        let dbPredicate = NSPredicate(format: "productId = %@",productId)
        let outputFilteredArr = (retrievedArrFromDB).filtered(using: dbPredicate) as NSArray
        
        if outputFilteredArr.count > 0 {
            
             self.lblNoDataFound.isHidden = true
            
            headerCollectionView.isHidden = false
            dataTblView.isHidden = false
            self.cvImages.isHidden  = false
            
            let fabObj = outputFilteredArr.object(at: 0) as? FAB_CPDetailsEntity
            self.dosageEngTitle = fabObj?.tableHeader as String? ?? ""
            self.dosageLocTitle = fabObj?.tableLocHeader as String? ?? ""
            self.dosageTableTitle.text = " " + dosageEngTitle
            let imArr = fabObj?.product_images_urls as String? ?? ""
            
            let arr =  imArr.components(separatedBy: "#")
            
            self.imgesArray = arr
            
            
            self.descriptionEngStr = fabObj?.des_englishMsg as String? ?? ""
            self.descriptionLocStr = fabObj?.des_localMsg as String? ?? ""
            self.lbl_Description?.text =  "Description :  " + descriptionEngStr

            var tableData = (fabObj?.tableData)
            let data = tableData?.object(at: 0) as! NSMutableArray
            self.dosageArray.removeAll()
            for i in (0..<data.count){
                var tableInfo =  TableData()
                let infoDict = data[i] as? NSDictionary
                let q =   infoDict?.allKeys as NSArray?
                self.arrItems.removeAll()
                if (q?.contains("columnOne"))!{
                    tableInfo.columnOne = infoDict?.value(forKey: "columnOne") as! String
                    self.arrItems.append("columnOne")
                }
                if (q?.contains("columnTwo"))!{
                    tableInfo.columnTwo = infoDict?.value(forKey: "columnTwo") as! String
                    self.arrItems.append("columnTwo")
                }
                if (q?.contains("columnThree"))!{
                    tableInfo.columnThree = infoDict?.value(forKey: "columnThree") as! String
                    self.arrItems.append("columnThree")
                }
                if (q?.contains("columnFour"))!{
                    tableInfo.columnFour = infoDict?.value(forKey: "columnFour") as! String
                     self.arrItems.append("columnFour")
                }
                self.dosageArray.append(tableInfo)
            }
       
          
            var tableLocData = (fabObj?.tableLocData)
            let data1 = tableLocData?.object(at: 0) as! NSMutableArray
            self.dosageLocArray.removeAll()
            for i in (0..<data1.count){
                var tableInfo =  TableData()
                let infoDict = data1[i] as? NSDictionary
                let q =   infoDict?.allKeys as NSArray?
                if (q?.contains("columnOne"))!{
                    tableInfo.columnOne = infoDict?.value(forKey: "columnOne") as! String
                }
                if (q?.contains("columnTwo"))!{
                    tableInfo.columnTwo = infoDict?.value(forKey: "columnTwo") as! String
                }
                if (q?.contains("columnThree"))!{
                    tableInfo.columnThree = infoDict?.value(forKey: "columnThree") as! String
                }
                if (q?.contains("columnFour"))!{
                    tableInfo.columnFour = infoDict?.value(forKey: "columnFour") as! String
                }
                self.dosageLocArray.append(tableInfo)
            }
              self.dosageTableView.reloadData()
            
            let dataArr = fabObj?.fabCPDataArray
            mutArrayToDisplay = dataArr?.object(at: 0) as! NSMutableArray
            self.cvImages.reloadData()
            self.cvImages.layoutIfNeeded()
            self.headerCollectionView.reloadData()
            self.dataTblView.reloadData()
            self.dataTblView.isScrollEnabled = false
            self.dosageTableView.isScrollEnabled = false
            self.FABViewHgtCons.constant = self.dataTblView.contentSize.height
            self.dosageGridViewHgtCons.constant = self.dosageTableView.contentSize.height + 60
            
        } else{
            
//            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE, duration: 1.0, position: .center)
            self.lblNoDataFound.isHidden = false
            self.lblNoDataFound.text  = "No Data Available"
            headerCollectionView.isHidden = true
            dataTblView.isHidden = true
            dosageTableView.isHidden  = true
            self.cvImages.isHidden = true
        }
          
            
           
             
               
            
//            DispatchQueue.global(qos: .utility).async {
//                   DispatchQueue.main.async {
//                                        self.cvImages.reloadData()
//                                        self.headerCollectionView.reloadData()
//                                        self.dataTblView.reloadData()
//                                        self.dosageTableView.reloadData()
//                                        self.dataTblView.isScrollEnabled = false
//                                        self.dosageTableView.isScrollEnabled = false
//                                        self.dataTblView.isScrollEnabled = false
//                                        self.FABViewHgtCons.constant = self.dataTblView.contentSize.height + 260
//                                        self.dosageGridViewHgtCons.constant = self.dosageTableView.contentSize.height + 60
//                        }
//                 }
        
       
    }
    
    //MARK: checkAssetsToBeDownloaded
    
}
struct Datamodel {
    var messages : String = ""
    var isCollapsable : Bool = false
}
struct TableData {
    var  columnFour : String = ""
   var columnOne : String = ""
    var columnThree: String = ""
   var  columnTwo: String = ""
}
extension UICollectionView {
    func reloadData(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData()})
        {_ in completion() }
    }
}
extension UILabel {

func getTruncatingText(originalString: String, newEllipsis: String, maxLines: Int?) -> String {

    let maxLines = maxLines ?? self.numberOfLines

    guard maxLines > 0 else {
        return originalString
    }

    guard self.numberOfLinesNeeded(forString: originalString) > maxLines else {
        return originalString
    }

    var truncatedString = originalString

    var low = originalString.startIndex
    var high = originalString.endIndex
    // binary search substring
    while low != high {
        let mid = originalString.index(low, offsetBy: originalString.distance(from: low, to: high)/2)
        truncatedString = String(originalString[..<mid])
        if self.numberOfLinesNeeded(forString: truncatedString + newEllipsis) <= maxLines {
            low = originalString.index(after: mid)
        } else {
            high = mid
        }
    }

    // substring further to try and truncate at the end of a word
    var tempString = truncatedString
    var prevLastChar = "a"
    for _ in 0..<15 {
        if let lastChar = tempString.last {
            if (prevLastChar == " " && String(lastChar) != "") || prevLastChar == "." {
                truncatedString = tempString
                break
            }
            else {
                prevLastChar = String(lastChar)
                tempString = String(tempString.dropLast())
            }
        }
        else {
            break
        }
    }

    return truncatedString + newEllipsis
}

private func numberOfLinesNeeded(forString string: String) -> Int {
    let oneLineHeight = "A".size(withAttributes: [NSAttributedStringKey.font: font]).height
    let totalHeight = self.getHeight(forString: string)
    let needed = Int(totalHeight / oneLineHeight)
    return needed
}

private func getHeight(forString string: String) -> CGFloat {
    return string.boundingRect(
        with: CGSize(width: self.bounds.size.width, height: CGFloat.greatestFiniteMagnitude),
        options: [.usesLineFragmentOrigin, .usesFontLeading],
        attributes: [NSAttributedStringKey.font: font],
        context: nil).height
}
}
fileprivate extension UIScrollView {
    func screenshot() -> UIImage? {
        // begin image context
        UIGraphicsBeginImageContextWithOptions(contentSize, false, 0.0)
        // save the orginal offset & frame
        let savedContentOffset = contentOffset
        let savedFrame = frame
        // end ctx, restore offset & frame before returning
        defer {
            UIGraphicsEndImageContext()
            contentOffset = savedContentOffset
            frame = savedFrame
        }
        // change the offset & frame so as to include all content
        contentOffset = .zero
        frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: ctx)
        let image = UIGraphicsGetImageFromCurrentImageContext()

        return image
    }
}

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
}

extension UIView {
    /** Loads instance from nib with the same name. */
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        //let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: "CPShareScreenView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func loadCropsGraphViewNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        //let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: "CropsGraphView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}

extension UIView {
    
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> Self? {
        return loadWithNib(nibNamed, bundle: bundle)
    }
    
    fileprivate class func loadWithNib<T>(_ nibNamed: String, bundle : Bundle? = nil) -> T? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil).first as? T
    }
    
}
