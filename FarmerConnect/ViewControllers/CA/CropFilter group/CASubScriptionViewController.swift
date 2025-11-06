//
//  CASubScriptionViewController.swift
//  CropAdvisoryFramework
//
//  Created by Empover-i-Tech on 06/03/20.
//  Copyright © 2020 Empover iTech Pvt Ltd. All rights reserved.
//

import UIKit
import SwiftyGif
import Alamofire


class CASubScriptionViewController: BaseViewController {
    
    
    @IBOutlet weak var imgFarmer: UIImageView!
    @IBOutlet weak var tfCrop: UITextField!
    @IBOutlet weak var tfCropType: UITextField!
    @IBOutlet weak var tfHybrid: UITextField!
    @IBOutlet weak var tfDateOfSowing: UITextField!
    @IBOutlet weak var tfNoOfAcres: UITextField!
    
    @IBOutlet weak var viewSprayService: UIView!
    @IBOutlet weak var viewCropTypeConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewHybridConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnSpraySubscription: UIButton!

    
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
    
    var userObj1 : NSMutableDictionary!
    
    var seasonStartDateStr: String?
    var seasonEndDateStr: String?
    var hybridArray = NSArray()
    
    
    //SUBSCRIPTION RELATED OUTLETS
    var crop_dropDownTable : UITableView!
    var hybrid_dropDownTable : UITableView!
    var categoryDropDownTblView : UITableView!
    //    var stateDropDownTblView = UITableView()
    var seasonTblView = UITableView()
    
    var selectedTextField = UITextField()
    var dobView = UIView()
    
    
    var categoryID = NSString()
    var stateID = NSString()
    var cropID = NSString()
    var hybridID = NSString()
    var seasonID = NSString()
    var cropTypeId = NSString()
    
    var alertController = UIAlertController()
    var cistomView = SubscriptionCreatePop()
    
    var cropsArray = NSMutableArray()
    var cropsImagesArray = NSArray()
    var alertView_Bg: UIView = UIView()
    
    var sprayServiceCheckIn : Bool = false
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSprayService.isHidden = true
           do {
   let gif = try UIImage(gifName: "Subscribe-animation.gif")
                    self.imgFarmer.setGifImage(gif, loopCount: -1)
                
            } catch {
                print(error)
            }
        
//    CoreDataManager.shared.addLogEvent(UserID: self.userObj1?.value(forKey: "customerId")  as? String ?? "", mobileNumber: self.userObj1?.value(forKey: "mobileNumber")  as? String ?? "", screenName: "CASubScriptionViewController", eventName: "Crop_Advisory_Subscription_Load", eventType: "PageLoad",captureTime:self.getCurrentDateAndTime(), currentLocation: "0.0,0.0", moduleType: "CropAdvisory")
    
        let parameters  = ["capturedtime" : self.getCurrentDateAndTime() , "currentLocation" :  self.userObj1?.value(forKey: "geoLocation")  as? String ?? "" ,"eventName" :  "Crop_Advisory_Subscription_Load" , "moduleType" : "CropAdvisory","deviceType" : "iOS" , "Mobile_Number" : self.userObj1?.value(forKey: "mobileNumber")  as? String ?? "" ,"screen_name" :  "CASubScriptionViewController" , "User_Id" :  self.userObj1?.value(forKey: "customerId")  as? String ?? ""] as [String : Any]
                                                                                                                              
        self.registerFirebaseEvents("Crop_Advisory_Subscription_Load", "", "", "CASubScriptionViewController", parameters: parameters as NSDictionary)
        
        
        
        let params =  ["data": ""]
        
        self.requestToGetCropAdvisoryData(Params: params as [String:String] )
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
         self.topView?.isHidden = false
        lblTitle?.text = "Subscribe"
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
            
    }
     override func backButtonClick(_ sender: UIButton) {
            self.navigationController?.popViewController(animated: true)
        }

    @IBAction func btnSprayService(_ sender : UIButton){
        self.viewCropTypeConstraint.constant = 0
        self.viewHybridConstraint.constant = 0
        if btnSpraySubscription.imageView?.image == UIImage(named: "CheckMarkGreen"){
                   btnSpraySubscription.setImage(UIImage(named: "CheckboxEmpty"), for: .normal)
                   self.sprayServiceCheckIn = false
               }else {
                   btnSpraySubscription.setImage(UIImage(named: "CheckMarkGreen"), for: .normal)
                   self.sprayServiceCheckIn = true
               }
    }
    
    func requestToGetCropAdvisoryData (Params : [String:String]){
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,CA_GET_MASTER_ADD_SUBSCRIPTION_DROPDOWN_V2])
        let userObj =  userObj1 //ConstantSdk.getUserObject()
      let  headers  = ["deviceToken": userObj1?.value(forKey: "deviceToken") as? String ?? "",
                    "userAuthorizationToken": userObj1?.value(forKey: "userAuthorizationToken")  as? String ?? "",
                    "mobileNumber": userObj1?.value(forKey: "mobileNumber")  as? String ?? "",
                    "customerId": userObj1?.value(forKey: "customerId")  as? String ?? "",
                    "deviceId": userObj1?.value(forKey: "deviceId")  as? String ?? ""]
        Alamofire.request(urlString, method: .post, parameters: Params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                print(response)
                if let json = response.result.value {
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                    if responseStatusCode == STATUS_CODE_200{
                        
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
                        
                    }
                    else if responseStatusCode == CROP_ADVISORY_NOT_AVAILABLE_151{
                    if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
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
                    self.tfCropType.text =  categoryDic?.value(forKey: "cropSubTypeName") as? String
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
                    self.tfHybrid.text = hybridDic.value(forKey: "name") as? String
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
                        self.tfDateOfSowing.text = startDate
                    }
                    self.seasonEndDateStr = seasonDic.value(forKey: "endDate") as? String ?? ""
                }
            }
        }
    }
    
}
//MARK:- UITABLEVIEW DELEGATE AND DATA SOURCE METHODS
extension CASubScriptionViewController:  UITableViewDelegate,UITableViewDataSource{
    
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
                self.tfCropType.text = categoryDic?.value(forKey: "cropSubTypeName") as? String
                cropTypeId = categoryDic?.value(forKey: "cropTypeId") as? String as NSString? ?? ""
            }
            
            // self.filterStatesWithCategory(categoryDic: categoryDic)
            if categoryDropDownTblView != nil{
                categoryDropDownTblView.isHidden = true
            }
             self.tfCropType.resignFirstResponder()
        }
            
        else if tableView == crop_dropDownTable {
            //get crop id
            if self.cropNamesArray.count>0{
                let cropDic = self.cropNamesArray.object(at: indexPath.row) as? NSDictionary
                cropID = cropDic?.value(forKey: "id") as? String as NSString? ?? ""
                 self.tfCrop.text = cropDic?.value(forKey: "name") as? String
                
                let categoryPredicate = NSPredicate(format: "cropName = %@",cropDic?.value(forKey: "name") as? String ?? "")
                let categoryFilterArray = (self.categoryArray).filtered(using: categoryPredicate) as NSArray
                let categoryDic = categoryFilterArray.firstObject as? NSDictionary
                self.filterStatesWithCategory(categoryDic: categoryDic)
                self.filterHybridWithCategoryAndStaeAndCrop(categoryDic: categoryDic,  cropDic: cropDic)
            }
            if crop_dropDownTable != nil{
                crop_dropDownTable.isHidden = true
            }
            self.tfCrop.resignFirstResponder()
        }
        else if tableView == hybrid_dropDownTable {
            if self.hybridNameArray.count>0{
                let hybridDic = self.hybridNameArray.object(at: indexPath.row) as? NSDictionary
                hybridID = hybridDic?.value(forKey: "id") as? String as NSString? ?? ""
                self.tfHybrid.text = hybridDic?.value(forKey: "name") as? String
            }
            if hybrid_dropDownTable != nil{
                hybrid_dropDownTable.isHidden = true
            }
            self.tfHybrid.resignFirstResponder()
        }
        else{
            tableView.isHidden = true
        }
        self.view.endEditing(true)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }

    //MARK:- ADD SUBSCRIPTION
    @IBAction  func submitSubscribeduserDetails(){
        
        if self.tfNoOfAcres.text  != "" && self.tfCrop.text != "" && self.tfCropType.text != "" && self.tfHybrid.text != "" && self.tfDateOfSowing.text != "" &&  self.tfNoOfAcres.text != "" {
        
          let dateFormatter: DateFormatter = DateFormatter()
          dateFormatter.dateFormat = "dd-MMM-yyyy"
        let date = dateFormatter.date(from: self.tfDateOfSowing.text ?? "")
          dateFormatter.dateFormat = "yyyy-MM-dd"
          let strDateToServer = dateFormatter.string(from: date!)
       
          
          let dic : NSDictionary = ["crop" : cropID ,
                                    "sowingDate" : strDateToServer ,
                                    "acressowed" : self.tfNoOfAcres.text ?? "" ,
                                    "cropTypeId" : cropTypeId ,
                                   "hybrid" : hybridID ]
//        CoreDataManager.shared.addSubscriptionLogEvent(UserID: self.userObj1?.value(forKey: "customerId")  as? String ?? "", mobileNumber: self.userObj1?.value(forKey: "mobileNumber")  as? String ?? "", screenName: "CASubScriptionViewController", eventName: "Crop_Advisory_Subscription_Click", eventType: "Click",captureTime:self.getCurrentDateAndTime(), currentLocation: self.userObj1?.value(forKey: "geoLocation")  as? String ?? "", moduleType: "CropAdvisory",crop: self.tfCrop.text ?? "", hybrid: self.tfHybrid.text ?? "", acres_Sowed: self.tfNoOfAcres.text ?? "" )
        
        
//            var parameters   = ["capturedtime" : self.getCurrentDateAndTime() , "currentLocation" :  self.userObj1?.value(forKey: "geoLocation")  as? String ?? "" ,"eventName" :  "Crop_Advisory_Subscription_Click" , "moduleType" : "CropAdvisory","deviceType" : "iOS" , "Mobile_Number" : self.userObj1?.value(forKey: "mobileNumber")  as? String ?? "" ,"screen_name" :  "CASubScriptionViewController" , "User_Id" :  self.userObj1?.value(forKey: "customerId")  as? String ?? "" , "crop" :  self.tfCrop.text ?? "" , "hybrid" : self.tfHybrid.text ?? ""  , "acres_Sowed" : self.tfNoOfAcres.text ?? ""] as [String : Any]
            
        let parameters  = ["capturedtime" : self.getCurrentDateAndTime() , "currentLocation" :  self.userObj1.value(forKey: "geoLocation")  as? String ?? "" ,"eventName" :  "Crop_Advisory_Subscription_Click" , "moduleType" : "CropAdvisory","deviceType" : "iOS" , "Mobile_Number" : self.userObj1.value(forKey: "mobileNumber")  as? String ?? "" ,"screen_name" :  "CASubScriptionViewController" , "User_Id" :  self.userObj1.value(forKey: "customerId")  as? String ?? "" , "crop" : self.tfCrop.text ?? "" , "hybrid" : self.tfHybrid.text ?? "" , "acres_Sowed" :  self.tfNoOfAcres.text ?? "" ] as [String : Any]
                                                                                                                                    
            self.registerFirebaseEvents("Crop_Advisory_Subscription_Click", "", "", "CASubScriptionViewController", parameters: parameters as NSDictionary)
        
      
      let headers  = ["deviceToken": userObj1?.value(forKey: "deviceToken") as? String ?? "",
                  "userAuthorizationToken": userObj1?.value(forKey: "userAuthorizationToken")  as? String ?? "",
                  "mobileNumber": userObj1?.value(forKey: "mobileNumber")  as? String ?? "",
                  "customerId": userObj1?.value(forKey: "customerId")  as? String ?? "",
                  "deviceId": userObj1?.value(forKey: "deviceId")  as? String ?? ""]
      
      
          BaseClass.newCASubscription(dic : dic, headers : headers) { (status, responseArray,message) in
              if status == true{
//                   CoreDataManager.shared.addLogEvent(UserID: self.userObj1?.value(forKey: "customerId")  as? String ?? "", mobileNumber: self.userObj1?.value(forKey: "mobileNumber")  as? String ?? "", screenName: "CASubScriptionViewController", eventName: "CropSubscription_Success_Request", eventType: "onRequest",captureTime:self.getCurrentDateAndTime(), currentLocation: "0.0,0.0", moduleType: "CropAdvisory")
                
                let parameters  = ["capturedtime" : self.getCurrentDateAndTime() , "currentLocation" :  self.userObj1?.value(forKey: "geoLocation")  as? String ?? "" ,"eventName" :  "CropSubscription_Success_Request" , "moduleType" : "CropAdvisory","deviceType" : "iOS" , "Mobile_Number" : self.userObj1?.value(forKey: "mobileNumber")  as? String ?? "" ,"screen_name" :  "CASubScriptionViewController" , "User_Id" :  self.userObj1?.value(forKey: "customerId")  as? String ?? "" ]
                                                                                                                                            
                self.registerFirebaseEvents("CropSubscription_Success_Request", "", "", "CASubScriptionViewController", parameters: parameters as NSDictionary)
                
                
                  self.clearTextFields()
                 self.view.makeToast("Subscribed Succesfully")
                self.navigationController?.popViewController(animated: true)
              }
              else{
                if message == "Crop Advisory Not Available." {
                    
//                     CoreDataManager.shared.addLogEvent(UserID: self.userObj1?.value(forKey: "customerId")  as? String ?? "", mobileNumber: self.userObj1?.value(forKey: "mobileNumber")  as? String ?? "", screenName: "CASubScriptionViewController", eventName: "CropSubscription_Not_Available", eventType: "onRequest",captureTime:self.getCurrentDateAndTime(), currentLocation: "0.0,0.0", moduleType: "CropAdvisory")
                    
                    let parameters  = ["capturedtime" : self.getCurrentDateAndTime() , "currentLocation" :  self.userObj1?.value(forKey: "geoLocation")  as? String ?? "" ,"eventName" :  "CropSubscription_Not_Available" , "moduleType" : "CropAdvisory","deviceType" : "iOS" , "Mobile_Number" : self.userObj1?.value(forKey: "mobileNumber")  as? String ?? "" ,"screen_name" :  "CASubScriptionViewController" , "User_Id" :  self.userObj1?.value(forKey: "customerId")  as? String ?? "" ]
                                                                                                                                                               
                    self.registerFirebaseEvents("CropSubscription_Not_Available", "", "", "CASubScriptionViewController", parameters: parameters as NSDictionary)
                    
                     self.view.makeToast("Crop Advisory Not Available")
                }else {
//                 CoreDataManager.shared.addLogEvent(UserID: self.userObj1?.value(forKey: "customerId")  as? String ?? "", mobileNumber: self.userObj1?.value(forKey: "mobileNumber")  as? String ?? "", screenName: "CASubScriptionViewController", eventName: "CropSubscription_Something_Wrong", eventType: "onRequest",captureTime:self.getCurrentDateAndTime(), currentLocation: "0.0,0.0", moduleType: "CropAdvisory")
                    
                    
                    let parameters  = ["capturedtime" : self.getCurrentDateAndTime() , "currentLocation" :  self.userObj1?.value(forKey: "geoLocation")  as? String ?? "" ,"eventName" :  "CropSubscription_Something_Wrong" , "moduleType" : "CropAdvisory","deviceType" : "iOS" , "Mobile_Number" : self.userObj1?.value(forKey: "mobileNumber")  as? String ?? "" ,"screen_name" :  "CASubScriptionViewController" , "User_Id" :  self.userObj1?.value(forKey: "customerId")  as? String ?? "" ]
                                                                                                                        
                    self.registerFirebaseEvents("CropSubscription_Something_Wrong", "", "", "CASubScriptionViewController", parameters: parameters as NSDictionary)
                    
                     self.view.makeToast("Something went wrong")
                }
                  print("No records")
              }
          }
        }else {
            self.view.makeToast("Please enter all the Fields to subscribe")
        }
      }
    open  func clearTextFields(){
        cistomView.cropTF.text = ""
        cistomView.categoryTxtFld.text = ""
        cistomView.dateOfSowingTF.text = ""
        cistomView.hybridTf.text = ""
        self.cistomView.noOfAcresTxtField.text  = ""
        selectedTextField = UITextField()
    }
    
}

//MARK:- UITEXTFIELDDELEGATE METHODS
extension CASubScriptionViewController : UITextFieldDelegate{
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.tfCropType{
            textField.resignFirstResponder()
            
            categoryDropDownTblView = UITableView()
            categoryDropDownTblView.reloadData()
            self.hideUnhideDropDownTblView(tblView: categoryDropDownTblView, hideUnhide: false)
        }
        if textField == self.tfCrop{
            textField.resignFirstResponder()
            
            crop_dropDownTable = UITableView()
            crop_dropDownTable.reloadData()
            self.hideUnhideDropDownTblView(tblView: crop_dropDownTable, hideUnhide: false)
        }
        
        if textField == self.tfHybrid{
            hybrid_dropDownTable = UITableView()
            textField.resignFirstResponder()
            hybrid_dropDownTable.reloadData()
            self.hideUnhideDropDownTblView(tblView: hybrid_dropDownTable, hideUnhide: false)
        }
        
        
        if textField == self.tfHybrid{
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
        self.view.addSubview(tableview)
        let xConstraint = NSLayoutConstraint.init(item: tableview, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem:textField , attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0.0) as NSLayoutConstraint
        let yConstraint = NSLayoutConstraint.init(item: tableview, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem:textField , attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0) as NSLayoutConstraint
        let widthConstraint = NSLayoutConstraint.init(item: tableview, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem:textField , attribute: NSLayoutConstraint.Attribute.width, multiplier: 1.0, constant: 0.0) as NSLayoutConstraint
        let heightConstraint = NSLayoutConstraint.init(item: tableview, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem:textField , attribute: NSLayoutConstraint.Attribute.height, multiplier: 1.0, constant: 120) as NSLayoutConstraint //height constant : 120
        self.view.addConstraints([xConstraint,yConstraint,widthConstraint,heightConstraint])
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
        if(textField == self.tfCropType){
            textField.resignFirstResponder()
            if(self.tfCrop.text?.count ?? 0 > 0){
                categoryDropDownTblView = UITableView()
                
                loadTable(textField:  self.tfCropType , table : categoryDropDownTblView)
            }else{
                self.view.makeToast("Please Select Crop.")
            }
            return false
        }
        if(textField == self.tfCrop){
            textField.resignFirstResponder()
            crop_dropDownTable = UITableView()
            
            loadTable(textField:  self.tfCrop , table : crop_dropDownTable)
            return false
        }
        if textField == self.tfHybrid{
            textField.resignFirstResponder()
            if(self.tfCrop.text?.count ?? 0 > 0){
                hybrid_dropDownTable = UITableView()
                
                loadTable(textField:  self.tfHybrid , table : hybrid_dropDownTable)
                
            }else{
                self.view.makeToast("Please Select Crop.")
            }
            return false
        }
            
        else if textField == self.tfDateOfSowing{
            textField.resignFirstResponder()
            if(self.tfCrop.text?.count ?? 0 > 0){
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
extension CASubScriptionViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
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
            if Validations.isNullString( self.tfDateOfSowing.text as NSString? ?? "" as NSString) == false{
                if let selectedDate = dateFormatter.date(from: self.tfDateOfSowing.text ?? "") as Date?{
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
        self.tfDateOfSowing.text = selectedDate as String
    }
    
    //REMOVE SOWING PICKER VIEW
    @objc func alertOK(){
        self.dobView.removeFromSuperview()
    }
}
