//
//  FABViewController.swift
//  FarmerConnect
//
//  Created by Empover on 21/12/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit
import Alamofire

class FABViewController: BaseViewController {

    @IBOutlet weak var cropNameTxtFld: UITextField!
    
    @IBOutlet weak var hybridNameTxtFld: UITextField!
    
    @IBOutlet weak var seasonNameTxtFld: UITextField!
  
    var isFromHome : Bool = false
    
    var cropDropDownTblView = UITableView()
    var hybridNameTblView = UITableView()
    var seasonTblView = UITableView()
    
    var stateNamesArray = NSMutableArray()
    var cropNamesArray = NSMutableArray()
    var hybridNameArray = NSMutableArray()
    var seasonNamesArray = NSMutableArray()
    
    var stateArray = NSArray()
    var cropArray = NSArray()
    var hybridArray = NSArray()
    var seasonArray = NSArray()
    
    var stateID = NSString()
    var cropID = NSString()
    var hybridID = NSString()
    var seasonID = NSString()
    
    var fabAlertView = UIView()
    
    var mutDictToStoreDBData = NSMutableDictionary()
    
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    @IBOutlet weak var mainOuterView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cropNameTxtFld.leftViewMode = .always
        cropNameTxtFld.contentVerticalAlignment = .center
        cropNameTxtFld.setLeftPaddingPoints(10)
        cropNameTxtFld.tintColor = UIColor.clear
        
        hybridNameTxtFld.leftViewMode = .always
        hybridNameTxtFld.contentVerticalAlignment = .center
        hybridNameTxtFld.setLeftPaddingPoints(10)
        hybridNameTxtFld.tintColor = UIColor.clear
        
        seasonNameTxtFld.leftViewMode = .always
        seasonNameTxtFld.contentVerticalAlignment = .center
        seasonNameTxtFld.setLeftPaddingPoints(10)
        seasonNameTxtFld.tintColor = UIColor.clear
        
        lblNoDataFound.isHidden = true
        mainOuterView.isHidden = false
        
        //crop dropdown tableView
        self.loadDropDownTableView(tableViewDataSource: self, tableViewDelegate: self, tableview: cropDropDownTblView, textField: cropNameTxtFld)
        cropDropDownTblView.dataSource = self
        cropDropDownTblView.delegate = self
        
        //hybrid dropdown tableView
        self.loadDropDownTableView(tableViewDataSource: self, tableViewDelegate: self, tableview: hybridNameTblView, textField: hybridNameTxtFld)
        hybridNameTblView.dataSource = self
        hybridNameTblView.delegate = self
        
        //season dropdown tableView
        self.loadDropDownTableView(tableViewDataSource: self, tableViewDelegate: self, tableview: seasonTblView, textField: seasonNameTxtFld)
        seasonTblView.dataSource = self
        seasonTblView.delegate = self
        
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
        self.recordScreenView("FABViewController", FAB_Screen)
        self.registerFirebaseEvents(PV_FAB_Screen, "", "", "", parameters: nil)
    }
    
    func updateDeepLinkFABParametersToUI(){
        if let deeplinkTempParams = self.deeplinkParams as NSDictionary? {
            if let tempCropId = deeplinkTempParams.value(forKey: Crop_Id) as? String{
                if let cropName = self.getFieldNameFromDeepLinkParameterId(tempCropId, objectsArray: self.cropArray) as String?{
                    self.cropID = tempCropId as NSString
                    self.cropNameTxtFld.text = cropName
                }
            }

            if let tempHybridId = deeplinkTempParams.value(forKey: Hybrid_Id) as? String{
                if let hybridName = self.getFieldNameFromDeepLinkParameterId(tempHybridId, objectsArray: self.hybridNameArray) as String?{
                    self.hybridID = tempHybridId as NSString
                    self.hybridNameTxtFld.text = hybridName
                }
            }
            if let tempSeasonId = deeplinkTempParams.value(forKey: Season_Id) as? String{
                if let seasonName = self.getFieldNameFromDeepLinkParameterId(tempSeasonId, objectsArray: self.seasonArray) as String?{
                    self.seasonID = tempSeasonId as NSString
                    self.seasonNameTxtFld.text = seasonName
                }
            }
        }
        self.cropDropDownTblView.reloadData()
        self.hybridNameTblView.reloadData()
        self.seasonTblView.reloadData()
        if let stateDic = stateArray.firstObject as? NSDictionary{
            stateID = stateDic.value(forKey: "id") as! String as NSString
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
    //MARK: alertYesBtnAction
    /*
     AlertView is enabled when there is no internet connection.
     AlertView YES button action.
     */
   @objc func alertYesBtnAction(){
        fabAlertView.removeFromSuperview()
        
        //retrieve fab details from DB
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let retrievedArrFromDB = appDelegate.getFABDetailsFromDB("FABDetails")
        if retrievedArrFromDB.count > 0 {
            
            let stateCodeMasterArray = NSMutableArray()
            let cropMasterArray = NSMutableArray()
            let hybridMasterArray = NSMutableArray()
            let seasonMasterArray = NSMutableArray()
            
            for i in (0..<retrievedArrFromDB.count){
                let stateCodeMasterDict = NSMutableDictionary()
                let cropMasterDict = NSMutableDictionary()
                let hybridMasterDict = NSMutableDictionary()
                let seasonMasterDict = NSMutableDictionary()
                
                let fabObj = retrievedArrFromDB.object(at: i) as? FABDetailsEntity
                
                //state master
                stateCodeMasterDict.setValue(fabObj?.state, forKey: "name")
                stateCodeMasterDict.setValue(fabObj?.stateId, forKey: "id")
                stateCodeMasterArray.add(stateCodeMasterDict)
                mutDictToStoreDBData.setValue(stateCodeMasterArray, forKey: "stateCodeMaster")
                
                //crop master
                cropMasterDict.setValue(fabObj?.stateId, forKey: "stateId")
                cropMasterDict.setValue(fabObj?.crop, forKey: "name")
                cropMasterDict.setValue(fabObj?.cropId, forKey: "id")
                cropMasterArray.add(cropMasterDict)
                mutDictToStoreDBData.setValue(cropMasterArray, forKey: "cropMaster")
                
                //hybrid master
                hybridMasterDict.setValue(fabObj?.stateId, forKey: "stateId")
                hybridMasterDict.setValue(fabObj?.cropId, forKey: "cropId")
                hybridMasterDict.setValue(fabObj?.hybridId, forKey: "id")
                hybridMasterDict.setValue(fabObj?.hybrid, forKey: "name")
                
                hybridMasterArray.add(hybridMasterDict)
                mutDictToStoreDBData.setValue(hybridMasterArray, forKey: "hybridMaster")
                
                //season master
                seasonMasterDict.setValue(fabObj?.stateId, forKey: "stateId")
                seasonMasterDict.setValue(fabObj?.cropId, forKey: "cropId")
                seasonMasterDict.setValue(fabObj?.hybridId, forKey: "hybridId")
                seasonMasterDict.setValue(fabObj?.seasonId, forKey: "id")
                seasonMasterDict.setValue(fabObj?.season, forKey: "name")
                
                seasonMasterArray.add(seasonMasterDict)
                mutDictToStoreDBData.setValue(seasonMasterArray, forKey: "seasonMaster")
            }
            
            // print(mutDictToStoreDBData)
            
            self.stateArray = mutDictToStoreDBData.value(forKey: "stateCodeMaster") as! NSArray
            self.cropArray = mutDictToStoreDBData.value(forKey: "cropMaster") as! NSArray
            self.hybridArray = mutDictToStoreDBData.value(forKey: "hybridMaster") as! NSArray
            self.seasonArray = mutDictToStoreDBData.value(forKey: "seasonMaster") as! NSArray
            
            if let statesArray =  self.stateArray.value(forKey: "name") as? NSArray{
                let statesNamesSet =  NSSet(array:statesArray as! [Any])
                self.stateNamesArray.addObjects(from: statesNamesSet.allObjects)
                let sortedArr = self.stateNamesArray.sorted(by: { ($0 as! String) < ($1 as! String) })
                self.stateNamesArray.removeAllObjects()
                self.stateNamesArray.addObjects(from: sortedArr)
                //print(self.stateNamesArray)
            }
            if let cropsArray =  self.cropArray.value(forKey: "name") as? NSArray{
                let cropsNamesSet =  NSSet(array:cropsArray as! [Any])
                self.cropNamesArray.addObjects(from: cropsNamesSet.allObjects)
                let sortedArr = self.cropNamesArray.sorted(by: { ($0 as! String) < ($1 as! String) })
                self.cropNamesArray.removeAllObjects()
                self.cropNamesArray.addObjects(from: sortedArr)
                // print(self.cropNamesArray)
            }
            if let hybridArray =  self.hybridArray.value(forKey: "name") as? NSArray{
                let hybridNamesSet =  NSSet(array:hybridArray as! [Any])
                self.hybridNameArray.addObjects(from: hybridNamesSet.allObjects)
                let sortedArr = self.hybridNameArray.sorted(by: { ($0 as! String) < ($1 as! String) })
                self.hybridNameArray.removeAllObjects()
                self.hybridNameArray.addObjects(from: sortedArr)
                // print(self.hybridNameArray)
            }
            if let seasonArray =  self.seasonArray.value(forKey: "name") as? NSArray{
                let seasonNamesSet =  NSSet(array:seasonArray as! [Any])
                self.seasonNamesArray.addObjects(from: seasonNamesSet.allObjects)
                let sortedArr = self.seasonNamesArray.sorted(by: { ($0 as! String) < ($1 as! String) })
                self.seasonNamesArray.removeAllObjects()
                self.seasonNamesArray.addObjects(from: sortedArr)
                //  print(self.seasonNamesArray)
            }
            DispatchQueue.main.async {
                //self.stateNameTxtFld.text = self.stateNamesArray.object(at: 0) as? String
                //self.stateDropDownTblView.reloadData()
                //self.updateUI()
                if self.isFromDeeplink == true{
                    self.updateDeepLinkFABParametersToUI()
                }
                else{
                    self.updateUI()
                }
            }
        }
        else{
            self.mainOuterView.isHidden = true
            self.lblNoDataFound.isHidden = false
            self.lblNoDataFound.text = "No Data Available"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.topView?.isHidden = false
        self.homeButton?.isHidden = true
        self.lblTitle?.text = NSLocalizedString("feature_benefits", comment: "")
        
        if isFromHome {
            self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        }else{
            self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
        }
    }
    
    override func backButtonClick(_ sender: UIButton) {
        if isFromHome {
            self.navigationController?.popViewController(animated: true)
        }else{
            self.findHamburguerViewController()?.showMenuViewController()
        }
    }
    
    @IBAction func getFABDetailsBtn_Touch_Up_Inside(_ sender: Any) {
      print("stateID :\(stateID), cropID :\(cropID), hybridID :\(hybridID), seasonID :\(seasonID)")
        let toFABDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "FABDetailsViewController") as! FABDetailsViewController
        toFABDetailsVC.stateIdFromFABVC = stateID
        toFABDetailsVC.cropIdFromFABVC = cropID
        toFABDetailsVC.hybridIdFromFABVC = hybridID
        toFABDetailsVC.seasonIdFromFABVC = seasonID
        let userObj = Constatnts.getUserObject()
        let fireBaseParams = [MOBILE_NUMBER : userObj.mobileNumber ?? "",USER_ID : userObj.customerId ?? "",CROP:cropNameTxtFld.text!,SEASON:seasonNameTxtFld.text!,HYBRID:hybridNameTxtFld.text!] as [String : Any]
        self.registerFirebaseEvents(FAB_Get_FAB, "", "", FAB_Screen, parameters: fireBaseParams as NSDictionary)
        self.navigationController?.pushViewController(toFABDetailsVC, animated: true)
    }
    
    //MARK: requestToGetFABMasterData
    /**
     Get FAB data such as Crop,Hybrid and Season based on State name.
     - Parameter Params:[String:String]
     */
    func requestToGetFABMasterData(params : [String:String]){
        
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_FAB_MASTER_DETAILS])
        
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
                        self.mainOuterView.isHidden = false
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        print("Response after decrypting data:\(decryptData)")
                        
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
                        DispatchQueue.main.async {
                            if self.isFromDeeplink == true{
                                self.updateDeepLinkFABParametersToUI()
                            }
                            else{
                                self.updateUI()
                            }
                        }
                    }
                    else if responseStatusCode == FAB_MASTER_DETAILS_BASED_ON_STATENAME_STATUS_CODE_301{
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.mainOuterView.isHidden = true
                            self.lblNoDataFound.isHidden = false
                            self.lblNoDataFound.text = msg as String
                            self.view.makeToast(msg as String)
                        }
                    } else if responseStatusCode == STATUS_CODE_105 {
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.mainOuterView.isHidden = true
                            self.lblNoDataFound.isHidden = false
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
                self.view.makeToast((response.error?.localizedDescription)!)
            }
        }
    }
    
    //MARK: UpdateUI
    /**
     This method is used to reload all the tableViews and textFields data
     */
    func updateUI(){
        self.cropDropDownTblView.reloadData()
        self.hybridNameTblView.reloadData()
        self.seasonTblView.reloadData()
        self.refreshTextFields()
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
    
    //MARK: filterCropWithState
    /**
     This method is used to filter the Crops Array with stateID
     - Parameter categoryDic: NSDictionary?
     */
    func filterCropWithState(stateDic: NSDictionary?){
        if stateDic != nil {
            stateID = stateDic!.value(forKey: "id") as! String as NSString
            //crop
            let cropPredicate = NSPredicate(format: "stateId = %@",stateID)
            let cropFilteredArr = (self.cropArray).filtered(using: cropPredicate) as NSArray
            //print("state data array : \(stateFilteredArr)")
            self.cropNamesArray.removeAllObjects()
            self.cropNamesArray.addObjects(from: cropFilteredArr as! [Any])
            //get crop id
            if cropFilteredArr.count > 0{
                if let cropDic = cropFilteredArr.firstObject as? NSDictionary{
                    cropNameTxtFld.text = cropDic.value(forKey: "name") as? String
                    cropID = cropDic.value(forKey: "id") as! String as NSString
                    self.filterHybridsWithCropAndState(cropDic: cropDic, stateDic: stateDic)
                }
            }
        }
    }
    
    //MARK: filterHybridsWithCropAndState
    /**
     This method is used to filter the Hybrids Array with cropID and stateID
     - Parameter cropDic: NSDictionary?
     - Parameter stateDic: NSDictionary?
     */ //filterCropsWithCategoryAndState
    func filterHybridsWithCropAndState(cropDic: NSDictionary?, stateDic: NSDictionary?){
        if cropDic != nil && stateDic != nil {
            cropID = cropDic!.value(forKey: "id") as! String as NSString
            stateID = stateDic!.value(forKey: "id") as! String as NSString
            let hybridPredicate = NSPredicate(format: "(cropId == %@) AND (stateId == %@)",cropID,stateID)
            let hybridFilteredArr = (self.hybridArray).filtered(using: hybridPredicate) as NSArray
            if hybridFilteredArr.count > 0{
                if let hybridDic = hybridFilteredArr.firstObject as? NSDictionary{
                    // print("crop data array : \(cropFilteredArr)")
                    self.hybridNameArray.removeAllObjects()
                    self.hybridNameArray.addObjects(from: hybridFilteredArr as! [Any])
                    // print(self.cropNamesArray)
                    self.hybridNameTblView.reloadData()
                    //get crop id
                    hybridNameTxtFld.text = hybridDic.value(forKey: "name") as? String
                    hybridID = hybridDic.value(forKey: "id") as! String as NSString
                    self.filterSeasonWithStateAndCropAndHybrid(stateDic: stateDic, cropDic: cropDic, hybridDic: hybridDic)
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
    func filterSeasonWithStateAndCropAndHybrid(stateDic: NSDictionary?,cropDic: NSDictionary?,hybridDic: NSDictionary?){
        if stateDic != nil && cropDic != nil && hybridDic != nil {
            stateID = stateDic!.value(forKey: "id") as! String as NSString
            cropID = cropDic!.value(forKey: "id") as! String as NSString
            hybridID = hybridDic!.value(forKey: "id") as! String as NSString
            let seasonPredicate = NSPredicate(format: "(stateId == %@) AND (cropId == %@) AND (hybridId == %@)",stateID,cropID,hybridID)
            let seasonFilterArray = self.seasonArray.filtered(using: seasonPredicate)
            if seasonFilterArray.count > 0{
                self.seasonNamesArray.removeAllObjects()
                self.seasonNamesArray.addObjects(from: seasonFilterArray)
                if let seasonDic = seasonNamesArray.firstObject as? NSDictionary{
                    self.seasonNameTxtFld.text = seasonDic.value(forKey: "name") as? String
                    seasonID = seasonDic.value(forKey: "id") as! String as NSString
                    self.seasonTblView.reloadData()
                }
            }
        }
    }
}

extension FABViewController :  UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == cropDropDownTblView {
            return cropNamesArray.count
        }
        else if tableView == hybridNameTblView {
            return hybridNameArray.count
        }
        else{
            return seasonNamesArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 14.0)
       
        if tableView == cropDropDownTblView {
            let stateDic = cropNamesArray.object(at: indexPath.row) as? NSDictionary
            cell.textLabel?.text = stateDic?.value(forKey: "name") as? String
        }
        else if tableView == hybridNameTblView {
            let hybridDic = hybridNameArray.object(at: indexPath.row) as? NSDictionary
            cell.textLabel?.text = hybridDic?.value(forKey: "name") as? String
        }
        else{
            let seasonDic = seasonNamesArray.object(at: indexPath.row) as? NSDictionary
            cell.textLabel?.text = seasonDic?.value(forKey: "name") as? String
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
//        if tableView == categoryDropDownTblView {
//            let categoryDic = self.categoryNamesArray.object(at: indexPath.row) as? NSDictionary
//            categoryID = categoryDic!.value(forKey: "id") as! String as NSString
//
         if tableView == cropDropDownTblView {
            //get crop id
            let cropDic = self.cropNamesArray.object(at: indexPath.row) as? NSDictionary
            cropID = cropDic!.value(forKey: "id") as! String as NSString
            cropNameTxtFld.text = cropDic?.value(forKey: "name") as? String
            
//            let statePredicate = NSPredicate(format: "name = %@","")
//            let statesFilterArray = (self.stateNamesArray).filtered(using: statePredicate) as NSArray
//            let stateDic = statesFilterArray.firstObject as? NSDictionary
            
          let stateDic = stateNamesArray.firstObject as? NSDictionary
            
            self.filterHybridsWithCropAndState(cropDic: cropDic, stateDic: stateDic)
            cropDropDownTblView.isHidden = true
            cropNameTxtFld.resignFirstResponder()
        }
        else if tableView == hybridNameTblView {
            
            let hybridDic = self.hybridNameArray.object(at: indexPath.row) as? NSDictionary
            hybridID = hybridDic!.value(forKey: "id") as! String as NSString
            hybridNameTxtFld.text = hybridDic?.value(forKey: "name") as? String
            
//            let statePredicate = NSPredicate(format: "name = %@","")
//            let statesFilterArray = (self.stateNamesArray).filtered(using: statePredicate) as NSArray
//            let stateDic = statesFilterArray.firstObject as? NSDictionary
            
             let stateDic = stateNamesArray.firstObject as? NSDictionary
            
            let cropPredicate = NSPredicate(format: "name = %@",cropNameTxtFld.text!)
            let cropsFilterArray = (self.cropNamesArray).filtered(using: cropPredicate) as NSArray
            let cropDic = cropsFilterArray.firstObject as? NSDictionary
            
            self.filterSeasonWithStateAndCropAndHybrid(stateDic: stateDic, cropDic: cropDic, hybridDic: hybridDic)
            hybridNameTblView.isHidden = true
            hybridNameTxtFld.resignFirstResponder()
        }
        else{
            let seasonDic = self.seasonNamesArray.object(at: indexPath.row) as? NSDictionary
            seasonID = seasonDic!.value(forKey: "id") as! String as NSString
            seasonNameTxtFld.text = seasonDic?.value(forKey: "name") as? String
            seasonTblView.isHidden = true
            seasonNameTxtFld.resignFirstResponder()
        }
        self.view.endEditing(true)
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
            
            "eventName": Home_FAB,
            "className":"HomeViewController",
            "moduleName": "FAB",
            
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
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
    
    //MARK: refreshTextFields
    func refreshTextFields(){
        if let stateDic = stateArray.firstObject as? NSDictionary{
            stateID = stateDic.value(forKey: "id") as! String as NSString
            self.filterCropWithState(stateDic:stateDic)
        }
    }
}

extension FABViewController : UITextFieldDelegate{
    //MARK: textfield delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
         if textField == cropNameTxtFld {
            cropDropDownTblView.isHidden = true
        }
        else if textField == hybridNameTxtFld {
            hybridNameTblView.isHidden = true
        }
        else {
            seasonTblView.isHidden = true
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
         if textField == cropNameTxtFld {
            cropNameTxtFld.resignFirstResponder()
            cropDropDownTblView.isHidden = false
            hybridNameTblView.isHidden = true
            seasonTblView.isHidden = true
        }
        else if textField == hybridNameTxtFld {
            hybridNameTxtFld.resignFirstResponder()
            hybridNameTblView.isHidden = false
            cropDropDownTblView.isHidden = true
            seasonTblView.isHidden = true
        }
        else {
            seasonNameTxtFld.resignFirstResponder()
            seasonTblView.isHidden = false
            cropDropDownTblView.isHidden = true
            hybridNameTblView.isHidden = true
        }
    }
}
