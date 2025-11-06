//
//  SelectCropAndProductViewController.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 27/03/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SDWebImage


class SelectCropAndProductViewController: BaseViewController {
    
    
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var lbl_Courtesy: UILabel!
    
    @IBOutlet weak var viewDisease : UIView!
    @IBOutlet weak var viewProducts : UIView!
    @IBOutlet weak var viewCrops : UIView!
    @IBOutlet weak var viewDiseaseHgtCon : NSLayoutConstraint!
    
    @IBOutlet weak var cvCrops : UICollectionView!
    @IBOutlet weak var cvDiseases : UICollectionView!
    @IBOutlet weak var cvProducts : UICollectionView!
    @IBOutlet weak var scrollView : UIScrollView!
    
    @IBOutlet weak var cropCVHgtCons : NSLayoutConstraint!
    @IBOutlet weak var contentHgtCons : NSLayoutConstraint!
    
    var cropsArray = [CropObj]()
    var disesesArray = [CropObj]()
    var productsArray = [CropObj]()
    
    var selectedCrop = [CropObj]()
    var selectedDiseaseArray = [DiseaseObj]()
    
    @IBOutlet weak var btnChangeCrop : UIButton!
    @IBOutlet weak var btnChangeDisease : UIButton!
    
    var stateID : String  = ""
    var cropID : String  = ""
    var diseaseID : String  = ""
    var productID : String  = ""
    
    
    var cropName : String  = ""
    var diseaseName : String  = ""
    var productName : String  = ""
    
    var isFromHome : Bool = false
    
    var isSelectedCrop : Bool = false
    var isSelectedDisease : Bool = false
    
    var selectedDiseaseIndex : Int?
    var selectedProductIndex : Int?
    
    var stateNamesArray = NSMutableArray()
    var cropNamesArray = NSMutableArray()
    var diseaseNameArray = NSMutableArray()
    var productNamesArray = NSMutableArray()
    
    var stateArray = NSArray()
    var cropArray = NSArray()
    var diseaseArray = NSArray()
    var productArray = NSArray()
    
    var cropDic : NSDictionary?
    
    
    ///main array to store the FAB data and used to display on tableView
    var mutArrayToDisplay = NSMutableArray()
    var mutDictToStoreDBData = NSMutableDictionary()
    
    var version = NSString()
    
    var a : NSInteger? = 0
    var fabAlertView = UIView()
    var isSave  : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let cropArr = ["Grapes","Grapes","Grapes","Grapes","Grapes","Grapes","Grapes","Grapes","Grapes","Grapes",]
        //        for (i,x) in cropArr.enumerated(){
        //            var croObj = CropObj()
        //            croObj.cropName = cropArr[i]
        //            croObj.cropID = String(i)
        //            self.cropsArray.append(croObj)
        //            self.disesesArray.append(croObj)
        //            self.productsArray.append(croObj)
        //        }
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            let userObj = Constatnts.getUserObject()
            let parameters = ["pincode":userObj.pincode! as String] as NSDictionary
            print(parameters)
            let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
            let params =  ["data" : paramsStr]
            self.requestToGetFABMasterData(params: params as [String:String])
            
            
            
        }
        else{
            let connectionStr  = NSLocalizedString("", comment: "")
            self.fabAlertView = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: "Oops! No Internet" as NSString, message: FAB_ALERT_MESSAGE as NSString, okButtonTitle: "YES", cancelButtonTitle: "") as! UIView
            self.view.addSubview(self.fabAlertView)
        }
        let userObj = Constatnts.getUserObject()
        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: FAB_CP_Screen] as [String : Any]
        self.recordScreenView("SelectCropAndProductViewController", FAB_CP_Screen)
        self.registerFirebaseEvents(PV_CP_FAB_Screen, "", "", "", parameters: firebaseParams as NSDictionary)
        
        if userObj.userLogsAllPrint == "true"{
        self.saveUserLogEventsDetailsToServer()
        }
        // Do any additional setup after loading the view.
    }
    func saveUserLogEventsDetailsToServer(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMddHHmmss" //"dd/MM/yyyy HH:mm:ss"
        let todaysDate = dateFormatter.string(from: Date())
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
            
            "eventName": Home_CPFAB,
            "className": "SelectCropAndProductViewController",
            "moduleName": "CPFAB",
            
            "healthCardId":"",
            "productId":"",
            "cropId":"",
            "seasonId":"",
            "otherParams":"",
            "isOnlineRecord": "true"]] as? [NSDictionary]
        ]
        
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            userLogEventsSingletonClass.sendUserLogEventsDetailsToServer(dictionary: dict ){ (status, statusMessage) in
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
    func requestToGetFABMasterData(params : [String:String]){
        
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_FAB_CP_MASTER_DETAILS])
        
        let userObj = Constatnts.getUserObject()
        
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        print(headers)
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        self.lblNoDataFound.isHidden = true
                        self.viewCrops.isHidden = false
                        
                        //Firebase Events
                        
                        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: FAB_CP_Screen] as [String : Any]
                        self.registerFirebaseEvents(PV_CPFAB_Request_Success, "", "", "", parameters: firebaseParams as NSDictionary)
                        
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        print("Response after decrypting data:\(decryptData)")
                        let courtey =  decryptData.value(forKey: "courtesyToGoogle") as? String
                        self.lbl_Courtesy.text  = courtey
                        if let statesArray = decryptData.value(forKey: "stateCodeMaster") as? NSArray{
                            let statesNamesSet =  NSSet(array:statesArray as! [Any])
                            self.stateArray = statesNamesSet.allObjects as NSArray
                            self.stateNamesArray.addObjects(from: statesNamesSet.allObjects)
                            let stateDic = self.stateNamesArray.object(at: 0) as? NSDictionary
                            self.stateID  = stateDic?.value(forKey: "id") as? String ?? ""
                            
                        }
                        if let cropsArray = decryptData.value(forKey: "cropMaster") as? NSArray{
                            let cropsNamesSet =  NSSet(array:cropsArray as! [Any])
                            self.cropArray = cropsNamesSet.allObjects as NSArray
                            self.cropNamesArray.addObjects(from: cropsNamesSet.allObjects)
                        }
                        if let diseasesArray = decryptData.value(forKey: "diseaseMaster") as? NSArray{
                            let diseaseNamesSet =  NSSet(array:diseasesArray as! [Any])
                            self.diseaseArray = diseaseNamesSet.allObjects as NSArray
                            self.diseaseNameArray.addObjects(from: diseaseNamesSet.allObjects)
                        }
                        if let productsArray = decryptData.value(forKey: "productMaster") as? NSArray{
                            let productNamesSet =  NSSet(array: productsArray as! [Any])
                            self.productArray = productNamesSet.allObjects as NSArray
                            self.productNamesArray.addObjects(from: productNamesSet.allObjects)
                        }
                        DispatchQueue.main.async {
                            if self.isFromDeeplink == true{
                                // self.updateDeepLinkFABParametersToUI()
                            }
                            else{
                                self.updateUI()
                            }
                        }
                    }
                    else if responseStatusCode == FAB_MASTER_DETAILS_BASED_ON_STATENAME_STATUS_CODE_301{
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            //Firebase Events
                            let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: FAB_CP_Screen] as [String : Any]
                            self.registerFirebaseEvents( PV_CPFAB_Request_NotAvailable, "", "", "", parameters: firebaseParams as NSDictionary)
                            
                            self.lblNoDataFound.isHidden = false
                            self.viewCrops.isHidden = true
                            self.lblNoDataFound.text = msg as String
                            self.view.makeToast(msg as String)
                        }
                    } else if responseStatusCode == STATUS_CODE_105 {
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.lblNoDataFound.isHidden = false
                            self.viewCrops.isHidden = true
                            self.lblNoDataFound.text = msg as String
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
                //Firebase Events
                let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: FAB_CP_Screen] as [String : Any]
                self.registerFirebaseEvents(PV_CPFAB_Request_Something_went_wrong, "", "", "", parameters: firebaseParams as NSDictionary)
                
                self.viewCrops.isHidden = true
                self.view.makeToast((response.error?.localizedDescription)!)
            }
        }
    }
    func updateDeepLinkFABParametersToUI(){
        if let deeplinkTempParams = self.deeplinkParams as NSDictionary? {
            if let tempCropId = deeplinkTempParams.value(forKey: Crop_Id) as? String{
                if let cropName = self.getFieldNameFromDeepLinkParameterId(tempCropId, objectsArray: self.cropArray) as String?{
                    self.cropID = (tempCropId as NSString) as String
                    
                }
            }
            
            if let tempDiseaseId = deeplinkTempParams.value(forKey: DISEASE) as? String{
                if let hybridName = self.getFieldNameFromDeepLinkParameterId(tempDiseaseId, objectsArray: self.diseaseArray) as? String?{
                    self.diseaseID = tempDiseaseId as  String ?? ""
                    //                    self.hybridNameTxtFld.text = hybridName
                }
            }
            if let tempProductId = deeplinkTempParams.value(forKey: PRODUCT) as? String{
                if let productName = self.getFieldNameFromDeepLinkParameterId(tempProductId, objectsArray: self.productArray) as String?{
                    self.productID = tempProductId as  String ?? ""
                    //                    self.seasonNameTxtFld.text = productName
                }
            }
        }
        self.cvCrops.reloadData()
        self.cvDiseases.reloadData()
        self.cvProducts.reloadData()
        if let stateDic = stateArray.firstObject as? NSDictionary{
            stateID = (stateDic.value(forKey: "id") as? String ?? "" )
        }
    }
    
    func getFieldNameFromDeepLinkParameterId(_ paramId:String, objectsArray:NSArray) -> String?{
        let filterPredicate = NSPredicate(format: "id = %@", paramId)
        let filterArray = objectsArray.filtered(using: filterPredicate) as NSArray?
        if filterArray?.count ?? 0 > 0{
            if let seasonDic = filterArray?.lastObject as? NSDictionary{
                if let categoryName = seasonDic.value(forKey: "name") as? String{
                    return categoryName
                }
            }
        }
        return nil
    }
    
    func updateUI(){
        if isSave == true{
            self.cvCrops.reloadData()
            self.cvDiseases.reloadData()
            self.cvProducts.reloadData()
        }else {
            self.cvCrops.reloadData()
        }
        //         self.filterDiseaseWithCrop(cropDic: self.cropDic!)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.topView?.isHidden = false
        self.homeButton?.isHidden = true
        self.lblTitle?.text = NSLocalizedString("Crop_Protection", comment: "")
        
        if isFromHome {
            self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        }else{
            self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
        }
        if isSelectedCrop == false {
            self.viewDisease.isHidden = true
            self.viewProducts.isHidden = true
        }
        
        
        
    }
    
    override func backButtonClick(_ sender: UIButton) {
        if isFromHome {
            self.navigationController?.popViewController(animated: true)
        }else{
            self.findHamburguerViewController()?.showMenuViewController()
        }
        
    }
    
    @objc func  alertNoBtnAction(){
        self.isSave = true
    }
    @objc func alertYesBtnAction(){
        
        fabAlertView.removeFromSuperview()
        self.isSave = true
        //retrieve fab details from DB
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let retrievedArrFromDB = appDelegate.getFAB_CP_DetailsFromDB("FAB_CPDetails")
        if retrievedArrFromDB.count > 0 {
            let productMasterArray = NSMutableArray()
            let cropMasterArray = NSMutableArray()
            let diseaseMasterArray = NSMutableArray()
            let stateCodeMasterArray = NSMutableArray()
            
            for i in (0..<retrievedArrFromDB.count){
                let cropMasterDict = NSMutableDictionary()
                let diseaseMasterDict = NSMutableDictionary()
                let productMasterDict = NSMutableDictionary()
                let stateCodeMasterDict = NSMutableDictionary()
                
                let fabObj = retrievedArrFromDB.object(at: i) as? FAB_CPDetailsEntity
                
                //state master
                stateCodeMasterDict.setValue(fabObj?.state, forKey: "name")
                stateCodeMasterDict.setValue(fabObj?.stateId, forKey: "id")
                stateCodeMasterArray.add(stateCodeMasterDict)
                self.stateID = fabObj?.stateId as? NSString! as! String
                mutDictToStoreDBData.setValue(stateCodeMasterArray, forKey: "stateCodeMaster")
                self.lblNoDataFound.isHidden = true
                //crop master
                cropMasterDict.setValue(fabObj?.crop, forKey: "name")
                cropMasterDict.setValue(fabObj?.cropId, forKey: "id")
                self.cropID = fabObj?.cropId as? NSString! as! String
                cropMasterDict.setValue(fabObj?.cropImageUrl, forKey: "cropImageUrl")
                cropMasterArray.add(cropMasterDict)
                mutDictToStoreDBData.setValue(cropMasterArray, forKey: "cropMaster")
                
                //hybrid master
                diseaseMasterDict.setValue(fabObj?.cropId, forKey: "cropId")
                diseaseMasterDict.setValue(fabObj?.diseaseId, forKey: "id")
                self.diseaseID = fabObj?.diseaseId as? NSString as! String
                diseaseMasterDict.setValue(fabObj?.diseaseName, forKey: "name")
                diseaseMasterDict.setValue(fabObj?.diseaseType, forKey: "diseaseType")
                diseaseMasterDict.setValue(fabObj?.diseaseImageUrl, forKey: "diseaseImageUrl")
                
                diseaseMasterArray.add(diseaseMasterDict)
                mutDictToStoreDBData.setValue(diseaseMasterArray, forKey: "diseaseMaster")
                
                //season master
                //                 seasonMasterDict.setValue(fabObj?.stateId, forKey: "stateId")
                productMasterDict.setValue(fabObj?.cropId, forKey: "cropId")
                productMasterDict.setValue(fabObj?.productFormulation, forKey: "productFormulation")
                productMasterDict.setValue(fabObj?.productId, forKey: "id")
                self.productID = fabObj?.productId as? NSString as! String
                productMasterDict.setValue(fabObj?.productName, forKey: "name")
                productMasterDict.setValue(fabObj?.productImageUrl, forKey: "productImageUrl")
                productMasterArray.add(productMasterDict)
                mutDictToStoreDBData.setValue(productMasterArray, forKey: "productMaster")
            }
            
            // print(mutDictToStoreDBData)
            
            self.stateArray = mutDictToStoreDBData.value(forKey: "stateCodeMaster") as! NSArray
            self.cropArray = mutDictToStoreDBData.value(forKey: "cropMaster") as! NSArray
            self.diseaseArray = mutDictToStoreDBData.value(forKey: "diseaseMaster") as! NSArray
            self.productArray = mutDictToStoreDBData.value(forKey: "productMaster") as! NSArray
            
            if let statesArray =  self.stateArray as? NSArray{
                let statesNamesSet =  NSSet(array:statesArray as! [Any])
                self.stateNamesArray.addObjects(from: statesNamesSet.allObjects)
                let sortedArr = self.stateNamesArray.sorted(by: { ($0 as! String) < ($1 as! String) })
                self.stateNamesArray.removeAllObjects()
                self.stateNamesArray.addObjects(from: sortedArr)
                //print(self.stateNamesArray)
            }
            if let cropsArray =  self.cropArray as? NSArray{
                let cropsNamesSet =  NSSet(array:cropsArray as! [Any])
                self.cropNamesArray.addObjects(from: cropsNamesSet.allObjects)
                let sortedArr = self.cropNamesArray.sorted(by: { ($0 as! String) < ($1 as! String) })
                self.cropNamesArray.removeAllObjects()
                self.cropNamesArray.addObjects(from: sortedArr)
                // print(self.cropNamesArray)
            }
            if let diseasArray =  self.diseaseArray as? NSArray {
                let diseaseNamesSet =  NSSet(array:diseasArray as! [Any])
                self.diseaseNameArray.addObjects(from: diseaseNamesSet.allObjects)
                let sortedArr = self.diseaseNameArray.sorted(by: { ($0 as! String) < ($1 as! String) })
                self.diseaseNameArray.removeAllObjects()
                self.diseaseNameArray.addObjects(from: sortedArr)
                // print(self.hybridNameArray)
            }
            if let productArray =  self.productArray as? NSArray{
                let productNamesSet =  NSSet(array:productArray as! [Any])
                self.productNamesArray.addObjects(from: productNamesSet.allObjects)
                let sortedArr = self.productNamesArray.sorted(by: { ($0 as! String) < ($1 as! String) })
                self.productNamesArray.removeAllObjects()
                self.productNamesArray.addObjects(from: sortedArr)
                //  print(self.seasonNamesArray)
            }
            DispatchQueue.main.async {
                if self.isFromDeeplink == true{
                    self.updateDeepLinkFABParametersToUI()
                }
                else{
                    self.updateUI()
                }
            }
        }
        else{
            self.viewCrops.isHidden = true
            self.lblNoDataFound.isHidden = false
            self.lblNoDataFound.text = "No Data Available"
        }
    }
    
    //MARK: filterDiseaseWithCropAndState
    /**
     This method is used to filter the Disease Array with cropID and stateID
     
     */ //filterCropsWithCategoryAndState
    func filterDiseaseWithCrop(cropDic: NSDictionary){
        if cropDic != nil {
            cropID = cropDic.value(forKey: "id") as! String
            let diseasePredicate = NSPredicate(format: "(cropId == %@)",cropID)
            let diseaseFilteredArr = (self.diseaseArray).filtered(using: diseasePredicate) as NSArray
            self.diseaseNameArray.removeAllObjects()
            if diseaseFilteredArr.count > 0{
                self.viewDiseaseHgtCon.constant = 175
                self.viewDisease.isHidden = false
                if let diseaseDic = diseaseFilteredArr.firstObject as? NSDictionary{
                    // print("crop data array : \(cropFilteredArr)")
                    
                    self.diseaseNameArray.addObjects(from: diseaseFilteredArr as! [Any])
                    // print(self.cropNamesArray)
                    self.cvDiseases.reloadData()
                    //get crop id
                    //                    hybridNameTxtFld.text = hybridDic.value(forKey: "name") as? String
                    //  diseaseID = (diseaseDic.value(forKey: "id") as! String as NSString) as String
                    //                    self.filterProductWithCropAndDisease(cropDic: cropDic,diseaseDic: diseaseDic)
                    self.filterproductWithCrop(cropDic: cropDic)
                }
            }else {
                self.filterproductWithCrop(cropDic: cropDic)
                self.viewDiseaseHgtCon.constant = 0
                self.viewDisease.isHidden = true
            }
        }
    }
    //filterCropsWithCategoryAndState
    func filterproductWithCrop(cropDic: NSDictionary){
        if cropDic != nil {
            cropID = cropDic.value(forKey: "id") as! String
            let productPredicate = NSPredicate(format: "(cropId == %@)",cropID)
            let productFilteredArr = (self.productArray).filtered(using: productPredicate) as NSArray
            self.productNamesArray.removeAllObjects()
            if productFilteredArr.count > 0{
                if let productDic = productFilteredArr.firstObject as? NSDictionary{
                    
                    self.productNamesArray.removeAllObjects()
                    var isMatch : Bool = true
                    var idsArray = [String]()
                    self.productNamesArray.add(productDic)
                    let id =  productDic.value(forKey: "id") as! String
                    idsArray.append(id)
                    if   productFilteredArr.count > 0 {
                        for i in (0..<productFilteredArr.count){
                            if let productDi = productFilteredArr[i] as? NSDictionary{
                                let pid = productDi.value(forKey: "id") as! String
                                print(productNamesArray)
                                print(productDi.value(forKey: "id") as! String)
                                print(productDi.value(forKey: "name") as! String)
                                
                                for j in (0..<productNamesArray.count){
                                    let productD = productNamesArray[j] as? NSDictionary
                                    let pid1 = productD?.value(forKey: "id") as? String
                                    if pid != pid1 && idsArray.contains(pid) == false {
                                        idsArray.append(pid)
                                        self.productNamesArray.add(productDi)
                                        break
                                    }
                                }
                                //                                                            if isMatch == false{
                                //                                                                 idsArray.append(pid)
                                //                                                                  self.productNamesArray.add(productDi)
                                //                                                               isMatch = true
                                //                                                            }
                                
                                
                                
                            }
                            
                        }
                    }
                    
                    self.cvProducts.reloadData()
                    
                    // print(self.cropNamesArray)
                    
                    //get crop id
                    //                    hybridNameTxtFld.text = hybridDic.value(forKey: "name") as? String
                    productID = (productDic.value(forKey: "id") as! String as NSString) as String
                    
                }
            }
        }
    }
    
    //MARK: filterSeasonWithStateAndCropAndHybrid
    /**
     This method is used to filter the Hybrids Array with categoryID,stateID and cropID
     - Parameter stateDic: NSDictionary?
     - Parameter cropDic: NSDictionary?
     - Parameter hybridDic: NSDictionary?
     */  //filterHybridWithCategoryAndStaeAndCrop
    func filterProductWithCropAndDisease(cropDic: NSDictionary?,diseaseDic :  NSDictionary?){
        if  cropDic != nil &&  diseaseDic != nil {
            cropID = cropDic!.value(forKey: "id") as! String
            diseaseID = diseaseDic!.value(forKey: "id") as! String
            let productPredicate = NSPredicate(format: "(cropId == %@) AND (diseaseId == %@)",cropID,diseaseID)
            let productFilterArray = self.productArray.filtered(using: productPredicate)
            self.productNamesArray.removeAllObjects()
            if productFilterArray.count > 0{
                
                self.productNamesArray.addObjects(from: productFilterArray)
                if let seasonDic = productNamesArray.firstObject as? NSDictionary{
                    //                    self.seasonNameTxtFld.text = seasonDic.value(forKey: "name") as? String
                    productID = (seasonDic.value(forKey: "id") as! String as NSString) as String
                    
                }
            }
            if self.diseaseNameArray.count > 0 {
                self.viewDisease.isHidden = false
                self.cvDiseases.reloadData()
            }else {
                self.viewDisease.isHidden = true
            }
            if self.productNamesArray.count > 0 {
                self.viewProducts.isHidden = false
                self.cvProducts.reloadData()
            }else {
                self.viewProducts.isHidden = true
            }
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async {
            if self.isSelectedCrop == true{
                self.cvCrops.isScrollEnabled = false
                self.cropCVHgtCons.constant = 1000
                self.contentHgtCons.constant = 160
            }else{
                self.cvCrops.isScrollEnabled = false
                self.cropCVHgtCons.constant = self.cvCrops.contentSize.height + 70
                self.contentHgtCons.constant = self.cvCrops.contentSize.height + 70
                
            }
        }
    }
    
    @IBAction func btnChangeCrop(_sender : UIButton){
        self.viewDisease.isHidden = true
        self.viewProducts.isHidden = true
        self.isSelectedCrop = false
        self.changeScrollDirection()
    }
    
    @IBAction func btnChangDisease(_sender : UIButton){
        self.diseaseID = ""
        self.diseaseName = ""
        self.btnChangeDisease.isHidden = true
        self.isSelectedDisease = false
        self.cvDiseases.reloadData()
    }
    
}

extension SelectCropAndProductViewController:  UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cvCrops {
            if isSelectedCrop == false {
                return self.cropNamesArray.count
            }else {
                return self.selectedCrop.count
            }
            
        }else if collectionView == cvDiseases{
            if isSelectedDisease == false && diseaseNameArray.count > 0  {
                return diseaseNameArray.count
            }else {
                if self.selectedDiseaseArray.count > 0 {
                    return self.selectedDiseaseArray.count
                }else {
                    return 0
                }
            }
        }else{
            if productNamesArray.count > 0 {
                return productNamesArray.count
            }else {
                return  0
            }
        }
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cell = self.cropAnalysisCollView.dequeueReusableCell(withReuseIdentifier: "CropDiagnosisCell", for: indexPath)
        if collectionView == cvCrops{
            let cellIdentifier = "cropCell"
            let cell  = cvCrops.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CropNameCell
            let cropDic = cropNamesArray.object(at: indexPath.row) as? NSDictionary
            
            if isSelectedCrop == true {
                cell.lbl_Crop.text = self.selectedCrop[indexPath.row].cropName
                if self.selectedCrop[indexPath.row].cropImage != ""{
                    let imgStr = self.selectedCrop[indexPath.row].cropImage
                    let url = URL(string:imgStr ?? "PlaceHolderImage")
                    cell.img_Crop?.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceHolderImage")!, options: SDWebImageOptions.refreshCached, completed: { (img, error, _, ur) in
                        if error != nil {
                            cell.img_Crop?.image =  UIImage(named: "PlaceHolderImage")!
                        }else {
                            cell.img_Crop?.image = img
                        }
                    })
                    //            (with: url, completed: nil)
                }else {
                    cell.img_Crop?.image =  UIImage(named: "PlaceHolderImage")!
                }
            }else {
                cell.lbl_Crop.text = cropDic?.value(forKey: "name") as? String
                cell.lbl_Crop.adjustsFontSizeToFitWidth = true
                if cropDic?.value(forKey: "cropImageUrl") as? String != ""{
                    let imgStr = cropDic?.value(forKey: "cropImageUrl") as? String
                    let url = URL(string:imgStr ?? "PlaceHolderImage")
                    cell.img_Crop?.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceHolderImage")!, options: SDWebImageOptions.refreshCached, completed: { (img, error, _, ur) in
                        if error != nil {
                            cell.img_Crop?.image =  UIImage(named: "PlaceHolderImage")!
                        }else {
                            cell.img_Crop?.image = img
                        }
                    })
                }else {
                    cell.img_Crop?.image =  UIImage(named: "PlaceHolderImage")!
                }
                
            }
            
            
            cell.img_Crop.contentMode = .scaleAspectFit
            cell.layer.shadowOpacity = 0.20
            cell.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.layer.shadowRadius = 5
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.masksToBounds = false
            return cell
        }
        else if collectionView == cvDiseases{
            let cellIdentifier = "diseaseCell"
            let cell = cvDiseases.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! DiseaseCollectionViewCell
            let diseaseDic = diseaseNameArray.object(at: indexPath.row) as? NSDictionary
            if isSelectedDisease == true {
                cell.lbl_Disease.text = self.selectedDiseaseArray[indexPath.row].diseaseName
                cell.lbl_SceintficName.text =   self.selectedDiseaseArray[indexPath.row].diseaseType
            }else {
                cell.lbl_Disease.text = diseaseDic?.value(forKey: "name") as? String
                cell.lbl_SceintficName.text = diseaseDic?.value(forKey: "diseaseType") as? String
                if diseaseDic?.value(forKey: "diseaseImageUrl") as? String != ""{
                    let imgStr = diseaseDic?.value(forKey: "diseaseImageUrl") as? String
                    let url = URL(string:imgStr!)
                    cell.img_Disease.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceHolderImage")!, options: SDWebImageOptions.refreshCached, completed: { (img, error, _, ur) in
                        if error != nil {
                            cell.img_Disease.image =  UIImage(named: "PlaceHolderImage")!
                        }else {
                            cell.img_Disease.image =  img
                        }
                    })
                }else {
                    cell.img_Disease.image =  UIImage(named: "PlaceHolderImage")!
                    
                }
            }
            //        cell.img_Disease.contentMode = .scaleAspectFit
            cell.layer.shadowOpacity = 0.20
            cell.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.layer.shadowRadius = 5
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.masksToBounds = false
            if indexPath.row == self.selectedDiseaseIndex && self.isSelectedCrop == true {
                cell.view_Disease.layer.borderWidth = 1
                cell.view_Disease.layer.borderColor = UIColor.blue.cgColor
            }else {
                cell.view_Disease.layer.borderWidth = 0
                cell.view_Disease.layer.borderColor = UIColor.clear.cgColor
            }
            return cell
        }else {
            let cellIdentifier = "productCell"
            let cell = cvProducts.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProductCollectionViewCell
            let productDic = productNamesArray.object(at: indexPath.row) as? NSDictionary
            cell.lbl_Disease.text = productDic?.value(forKey: "name") as? String //cropID
            cell.lbl_SceintficName.text = "( " + (productDic?.value(forKey: "productFormulation") as? String ?? "") +  " )"
            if productDic?.value(forKey: "productImageUrl") as? String != ""{
                let imgStr = productDic?.value(forKey: "productImageUrl") as? String
                let url = URL(string:imgStr ?? "PlaceHolderImage")
                cell.img_Disease.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceHolderImage")!, options: SDWebImageOptions.refreshCached, completed: { (img, error, _, ur) in
                    if error != nil {
                        cell.img_Disease.image =  UIImage(named: "PlaceHolderImage")!
                    }else {
                        cell.img_Disease.image =  img
                    }
                })
            }else {
                cell.img_Disease.image =  UIImage(named: "PlaceHolderImage")!
            }
            //        cell.img_Disease.contentMode = .scaleAspectFit
            cell.layer.shadowOpacity = 0.20
            cell.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.layer.shadowRadius = 5
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.masksToBounds = false
            if indexPath.row == self.selectedProductIndex && self.isSelectedCrop == true {
                cell.view_Disease.layer.borderWidth = 1
                //cell.view_Disease.layer.borderColor = UIColor.red.cgColor
                cell.view_Disease.layer.borderColor = UIColor.clear.cgColor
            }else {
                cell.view_Disease.layer.borderWidth = 0
                cell.view_Disease.layer.borderColor = UIColor.clear.cgColor
            }
            return cell
        }
        
        //            let url = URL(string:dicObj.object(forKey: "imageUrl") as? String ?? "")
        //            cropImgView.kf.setImage(with: url , placeholder: UIImage(named:"image_placeholder.png"))//, options: nil, progressBlock: nil, completionHandler: nil)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == cvCrops {
            if cropNamesArray.count > 1{
                return CGSize(width: collectionView.bounds.size.width/2-10, height: 84)//150
            }
            return CGSize(width: collectionView.bounds.size.width-10, height: collectionView.bounds.size.height-30)//150
        }else {
            if isSelectedDisease == true {
                return CGSize(width: collectionView.bounds.size.width-30, height: collectionView.bounds.size.height-60)//150
            }else {
                return CGSize(width: collectionView.bounds.size.width-30, height: collectionView.bounds.size.height)//150
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == cvCrops {
            return UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        }else{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)//top,left,bottom,right
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView ==  cvCrops{
            self.isSelectedCrop = true
            var cropObj = CropObj()
            var diseaseObj = DiseaseObj()
            self.selectedCrop.removeAll()
            let cropDic = cropNamesArray.object(at: indexPath.row) as? NSDictionary
            cropObj.cropName = cropDic?.value(forKey: "name") as? String ?? ""
            cropObj.cropID = cropDic?.value(forKey: "id") as? String ?? ""
            cropObj.cropImage = cropDic?.value(forKey: "cropImageUrl") as? String ?? ""
            
            //            let diseaseDic = diseaseNameArray.object(at: indexPath.row) as? NSDictionary
            //            diseaseObj.diseaseName = diseaseDic?.value(forKey: "name") as? String ?? ""
            //            diseaseObj.diseaseID = diseaseDic?.value(forKey: "id") as? String ?? ""
            //            diseaseObj.diseaseImage = diseaseDic?.value(forKey: "diseaseImageUrl") as? String ?? ""
            
            self.cropID = cropObj.cropID
            self.cropName = cropObj.cropName
            self.selectedCrop.append(cropObj)
            self.btnChangeCrop.isHidden = false
            self.cropDic = cropDic
            //            self.filterProductWithCropAndDisease(cropDic: self.cropDic, diseaseDic: diseaseDic)
            //            if self.productNamesArray.count > 0 {
            //                self.changeScrollDirection()
            //            }else {
            //                self.view.makeToast("No products are availble for selected crop")
            //            }
            if isSave == true {
                self.cvCrops.isUserInteractionEnabled = false
                self.cvDiseases.isUserInteractionEnabled = false
                self.btnChangeCrop.isHidden = true
                self.btnChangeDisease.isHidden = true
                
            }else {
                self.cvCrops.isUserInteractionEnabled = true
                self.cvDiseases.isUserInteractionEnabled = true
                
            }
            self.changeScrollDirection()
            
        }else if  collectionView ==  cvDiseases {
            self.btnChangeDisease.isHidden = false
            self.isSelectedDisease = true
            
            var diseaseObj = DiseaseObj()
            self.selectedDiseaseArray.removeAll()
            
            let diseaseDic = diseaseNameArray.object(at: indexPath.row) as? NSDictionary
            diseaseObj.diseaseName = diseaseDic?.value(forKey: "name") as? String ?? ""
            diseaseObj.diseaseID = diseaseDic?.value(forKey: "id") as? String ?? ""
            diseaseObj.diseaseImage = diseaseDic?.value(forKey: "diseaseImageUrl") as? String ?? ""
            diseaseObj.diseaseType = diseaseDic?.value(forKey: "diseaseType") as? String ?? ""
            self.diseaseID = diseaseDic?.value(forKey: "id") as? String ?? ""
            self.diseaseName = diseaseDic?.value(forKey: "name") as? String ?? ""
            self.selectedDiseaseArray.append(diseaseObj)
            self.cvDiseases.reloadData()
            self.filterProductWithCropAndDisease(cropDic: self.cropDic, diseaseDic: diseaseDic)
            
        }else if  collectionView ==  cvProducts {
            let cell = cvProducts.cellForItem(at: indexPath) as! ProductCollectionViewCell
            cell.layer.shadowOpacity = 0.20
            cell.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.layer.shadowRadius = 5
            cell.layer.shadowColor = UIColor.blue.cgColor
            cell.layer.masksToBounds = false
            let pDic = productNamesArray.object(at: indexPath.row) as? NSDictionary
            self.productName = pDic?.value(forKey: "name") as? String ?? ""
            self.productID = pDic?.value(forKey: "id") as? String ?? ""
            self.selectedProductIndex = indexPath.row
            self.cvProducts.reloadData()
            
            let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "CropProtectionDetailsViewController") as? CropProtectionDetailsViewController
            detailsVC?.stateId  = stateID
            detailsVC?.cropId  =  cropID
            detailsVC?.diseaseId  = diseaseID
            detailsVC?.productId  = self.productID
            detailsVC?.cropName  =  self.cropName
            detailsVC?.diseaseName  = self.diseaseName
            detailsVC?.productName  = self.productName
            let userObj = Constatnts.getUserObject()
            let fireBaseParams = [MOBILE_NUMBER : userObj.mobileNumber ?? "",USER_ID : userObj.customerId! ,CROP:self.cropName,PRODUCT:self.productName,DISEASEID:self.diseaseName] as [String : Any]
            self.registerFirebaseEvents(PV_CPFAB_CDP, "", "", FAB_CP_Screen, parameters: fireBaseParams as NSDictionary)
            self.navigationController?.pushViewController(detailsVC!, animated: true)
            
            
        }
    }
    override open var prefersStatusBarHidden: Bool {
        return false
    }
    
    func changeScrollDirection() {
        
        self.filterDiseaseWithCrop(cropDic: self.cropDic!)
        
        if self.productNamesArray.count > 0 {
            self.cvCrops.reloadData()
            let layout = self.cvCrops.collectionViewLayout as? UICollectionViewFlowLayout
            
            if( layout?.scrollDirection == .vertical)
            {
                
                layout?.scrollDirection = .horizontal
                DispatchQueue.main.async {
                    self.viewDisease.isHidden = false
                    self.viewProducts.isHidden = false
                    self.cvCrops.isUserInteractionEnabled = false
                    self.viewDisease.isHidden = false
                    self.btnChangeCrop.isHidden = false
                    self.cvCrops.isScrollEnabled = false
                    self.cropCVHgtCons.constant = 1000
                    self.contentHgtCons.constant = 160
                }
            }
            else{
                layout?.scrollDirection = .vertical
                DispatchQueue.main.async {
                    self.cvCrops.isUserInteractionEnabled = true
                    self.viewDisease.isHidden = true
                    self.btnChangeCrop.isHidden = true
                    self.cvCrops.isScrollEnabled = false
                    self.cropCVHgtCons.constant = self.cvCrops.contentSize.height + 70
                    self.contentHgtCons.constant = self.cvCrops.contentSize.height + 70
                }
            }
            
            scrollView.setContentOffset(.zero, animated: true)
            
            
        }else{
            self.showNormalAlert(title: "Alert!", message: "No Data Available for selected Crop")
            DispatchQueue.main.async {
                self.cvCrops.isUserInteractionEnabled = true
                self.viewDisease.isHidden = true
                self.btnChangeCrop.isHidden = true
                self.cvCrops.isScrollEnabled = false
                self.isSelectedCrop = false
                self.cropCVHgtCons.constant = self.cvCrops.contentSize.height + 70
                self.contentHgtCons.constant = self.cvCrops.contentSize.height + 70
                return
            }
            
        }
        
    }
}
struct CropObj {
    var cropName : String = ""
    var cropID : String = ""
    var cropImage : String = ""
}
struct DiseaseObj {
    var diseaseName : String = ""
    var diseaseID : String = ""
    var diseaseImage : String = ""
    var diseaseType : String = ""
}
