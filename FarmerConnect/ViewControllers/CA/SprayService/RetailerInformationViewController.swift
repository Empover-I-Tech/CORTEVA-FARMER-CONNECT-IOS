//
//  RetailerInformationViewController.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 29/08/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class RetailerInformationViewController: BaseViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate , SelectedNumberOfAcresValueDelegate {
    func numberOfAcresValue(_ value: String) {
        UserDefaults.standard.setValue(value, forKey: "numberOfAcres")
               UserDefaults.standard.synchronize()
    }
    
    
    @IBOutlet weak var tblViewRetailers : UITableView!
    @IBOutlet weak var lblNoRewards : UILabel!
    @IBOutlet weak var capturedImage : UIImageView!
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tfCrop : UITextField!
    @IBOutlet weak var tfBillNumber : UITextField!
    @IBOutlet weak var tfMandal : UITextField!
    @IBOutlet weak var tfVillage : UITextField!
    
    
    @IBOutlet weak var tblHgtConstraint: NSLayoutConstraint!
    var selectedTextField = UITextField()
    
    var cropNamesArray = NSMutableArray()
    var mandalNamesArray = NSMutableArray()
    var villageNamesArray = NSMutableArray()
    
    var filteredVillageNamesArray = [villageModelObj]()
    
    let kHeaderSectionTag: Int = 6900;
    var sectionNames = [SectionDetails]()
    
    var isFromHome : Bool = false
    var isCameraOrGaleery : Bool = false
    
    var arrayRetailers = [RetailerInformation]()
    var totalRetailers  = [RetailerInformation]()
    var arrayMandals = [String]()
    var arrayVillages = [villageModelObj]()
    var filteredCustomer = [RetailerInformation]()
    
    var selectedRetailer = [TransactionModel]()
    var claimTransactions = [TransactionModel]()
    var reclaimTransactions = [TransactionModel]()
    var totalClaimAmount : Double =  0.0
    var theImageView = UIImageView()
    
    var selectedRetailerID : String = ""
    var selectedImage = UIImage()
    var searchActive : Bool = false
    
    var cropArray = NSArray()
    
    @IBOutlet weak var viewSelectedRetailer: UIView!
    @IBOutlet weak var lblSelectedRetailerName: UILabel!
    @IBOutlet weak var lblSelectedRetailerMobileNumber: UILabel!
    @IBOutlet weak var lblSelectedRetailerAddress: UILabel!
    
    var crop_dropDownTable : UITableView!
    var cropID : Int?
     var cropName : String = ""
    
    var mandal_dropDownTable : UITableView!
    var mandalID : Int?
    
    var village_dropDownTable : UITableView!
    var villageID : Int?
   var noOfScans : Int = 0
   var noOfAcres : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        self.registerFirebaseEvents(PV_Bill_upload_farmer_purchase, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "" , parameters: nil)
        let userObj = Constatnts.getUserObject()
                 let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "RetailerInformationViewController"]
                 self.registerFirebaseEvents(PV_Bill_upload_farmer_purchase, "", "", "", parameters: firebaseParams as NSDictionary)
        
        self.searchBar.textField?.returnKeyType = .done
        self.searchBar.textField?.enablesReturnKeyAutomatically = false
        let params_Crop =  ["data": ""]
        self.tfCrop.text = self.cropName
       
//        self.requestToGetCropAdvisoryData(Params: params_Crop)
        let params : Parameters = ["pinCode" : userObj.pincode as String? ?? ""]
        if isFromDeeplink == true {
            let params1 : Parameters = ["cropId" : cropID!]
            self.getNumberScansDoneByRequester(Params: params1)
        }else {
        self.requestToGetMandalsAndVillageInformationBasedOnPincode(params: params )
    }
}
    func getNumberScansDoneByRequester(Params : Parameters){
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_NumberOfScansRequester])
        let userObj1 : User =  Constatnts.getUserObject()
        let  headers : HTTPHeaders  = ["deviceToken": userObj1.deviceToken as String ,
                                       "userAuthorizationToken": userObj1.userAuthorizationToken! as String ,
                                       "mobileNumber": userObj1.mobileNumber! as String,
                                       "customerId": userObj1.customerId! as String,
                                       "deviceId": userObj1.deviceId! as String]
        
        Alamofire.request(urlString, method: .post, parameters: Params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                print(response)
                if let json = response.result.value {
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                    if responseStatusCode == STATUS_CODE_200{
                        let userObj = Constatnts.getUserObject()
                        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"screen_name" : "RetailerInformationViewController" ] as [String : Any]
                        //
                        self.registerFirebaseEvents("PV_Retailer_CropMaster_success", userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "RetailerInformationViewController" , parameters: fireBaseParams as NSDictionary)
                        let respData = (json as? NSDictionary)?.value(forKey: "response") as? NSString ?? ""
                        let decryptData  = Constatnts.convertToDictionary(text: respData as String)
                        print("Response after decrypting data:\(decryptData)")
                        self.noOfAcres = decryptData?["noOfAcres"] as? Int ?? 0
                        self.noOfScans = decryptData?["noOfScans"] as? Int ?? 0
                        if self.noOfScans == 0 {
                            let popOverVC = self.storyboard?.instantiateViewController(withIdentifier: "NumberOfAcresViewController") as? NumberOfAcresViewController
                            popOverVC?.cropID = self.cropID!
                            popOverVC?.noOfAcres = self.noOfAcres
                            popOverVC!.delegate = self
                            self.addChildViewController(popOverVC!)
                            popOverVC!.view.frame = self.view.frame
                            self.view.addSubview(popOverVC!.view)
                            popOverVC!.didMove(toParentViewController: self)
                        }else if self.noOfAcres == self.noOfScans {
                               let params_Crop =  ["data": ""]
                            self.requestToGetCropAdvisoryData(Params: params_Crop)
                        }else {
                            let appdele = UIApplication.shared.delegate as? AppDelegate
                            appdele?.isOpennedGenuinityCheckFromOffers = true
                            let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                            toSelectPayVC?.isFromSprayServiceScanner = true
                            toSelectPayVC?.noOfAcres = self.noOfAcres
                            toSelectPayVC?.noOfScans = self.noOfScans
                            let delegate = UIApplication.shared.delegate as? AppDelegate
                            delegate?.numberOfScans =  self.noOfScans
                            toSelectPayVC?.cropId =  self.cropID!
                            self.navigationController?.pushViewController(toSelectPayVC!, animated: false)
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
    func requestToGetCropAdvisoryData (Params : [String:String]){
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_CROP_MASTER])
        let userObj1 : User =  Constatnts.getUserObject()
        let  headers : HTTPHeaders  = ["deviceToken": userObj1.deviceToken as String ,
                                       "userAuthorizationToken": userObj1.userAuthorizationToken! as String ,
                                       "mobileNumber": userObj1.mobileNumber! as String,
                                       "customerId": userObj1.customerId! as String,
                                       "deviceId": userObj1.deviceId! as String]
        
        Alamofire.request(urlString, method: .post, parameters: Params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                print(response)
                if let json = response.result.value {
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                    if responseStatusCode == STATUS_CODE_200{
                        let userObj = Constatnts.getUserObject()
                                          let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"screen_name" : "RetailerInformationViewController" ] as [String : Any]
                                                            //
                                          self.registerFirebaseEvents("PV_Retailer_CropMaster_success", userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "RetailerInformationViewController" , parameters: fireBaseParams as NSDictionary)
                        let respData = (json as? NSDictionary)?.value(forKey: "response") as? NSString ?? ""
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        // print("Response after decrypting data:\(decryptData)")
                        
                        
                        //                            if let statesArray = decryptData.value(forKey: "stateCodeMaster") as? NSArray{
                        //                                let statesNamesSet =  NSSet(array:statesArray as! [Any])
                        //                                self.stateArray = statesNamesSet.allObjects as NSArray
                        //                                self.stateNamesArray.addObjects(from: statesNamesSet.allObjects)
                        //                            }
                        if let cropsArray = decryptData.value(forKey: "allCrops") as? NSArray{
                            let cropsNamesSet =  NSSet(array:cropsArray as! [Any])
                            self.cropArray = cropsNamesSet.allObjects as NSArray
                            self.cropNamesArray.addObjects(from:cropsArray as! [Any])
                            if self.cropNamesArray.count > 0 {
                                 let stateDic = self.cropNamesArray.object(at: 0) as? NSDictionary
                                self.tfCrop.text = stateDic?.value(forKey: "name") as? String
                                 self.cropID = stateDic?.value(forKey: "id") as? Int ?? 0
                            }
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
                    let userObj1 : User =  Constatnts.getUserObject()
                    let params : Parameters = ["pinCode" : userObj1.pincode as String? ?? ""]
                    self.requestToGetMandalsAndVillageInformationBasedOnPincode(params: params )
                    
                }
            }
            else{
                self.view.makeToast((response.error?.localizedDescription)!)
            }

        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.topView?.isHidden = false
        self.homeButton?.isHidden = true
        self.lblTitle?.text = NSLocalizedString("Upload_Bill_Details", comment: "")
        
        self.tblViewRetailers.isHidden = false
        self.viewSelectedRetailer.isHidden = true
            self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        self.tblViewRetailers.isScrollEnabled = false
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 150  + self.tblViewRetailers.contentSize.height + 50)

    }
    
    
    override func backButtonClick(_ sender: UIButton) {
        if isFromHome{
            self.navigationController?.popViewController(animated: true)
        }else if isFromDeeplink == true {
                let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                    self.navigationController?.pushViewController(toSelectPayVC!, animated: false)
        }  else{
            self.findHamburguerViewController()?.showMenuViewController()
        }
    }
    
    func requestToGetMandalsAndVillageInformationBasedOnPincode(params : Parameters){
        SwiftLoader.show(animated: true)
        let headers = Constatnts.getLoggedInFarmerHeaders()
        let urlString:String =  BASE_URL + GET_MANDAL_AND_VILLAGES_PINCODE //"http://pioneeractivity.in/rest/cropAdvisory/getRetaillers" //String(format: "%@%@", arguments: [BASE_URL,GET_RETAILERS]  ) // // ["http://192.168.3.141:8080/ATP/rest/" ,"cashFreeReward/getCashFreeTransactionPendingRequest_V2"]
        
        Alamofire.request(urlString, method: .post, parameters :  params , encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            
            if response.result.error == nil {
                if let json = response.result.value {
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let responseJSON = self.convertToDictionary(text: respData as String)
                        
                        
                        print("Response after decrypting data:\(String(describing: responseJSON))")
                        self.arrayMandals.removeAll()
                        let userObj = Constatnts.getUserObject()
                        //                         let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"serverID" : self.arrayTransactions[0].serverID ] as [String : Any]
                        //
                        //                          self.registerFirebaseEvents(Reclaim, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", CashFreeRewards , parameters: fireBaseParams as NSDictionary)
                        
                        if let mandalListArray = (responseJSON as? NSDictionary)!["mandalList"] as? NSArray {
                            self.arrayMandals.removeAll()
                            if mandalListArray.count > 0 {
                                for i in mandalListArray {
                                    let name = (i as AnyObject).value(forKey:"name") as? String ?? ""
                                    self.mandalNamesArray.add(name)
                                   
                                }
                                 self.tfMandal.text = self.mandalNamesArray[0] as? String ?? ""
                            }
                        }
                        if let villagesListArray = (responseJSON as? NSDictionary)!["villageList"] as? NSArray {
                            self.arrayVillages.removeAll()
                            if villagesListArray.count > 0 {
                                for i in villagesListArray {
                                    var villageObj = villageModelObj()
                                    villageObj.mandalName = (i as AnyObject).value(forKey:"mandalName") as? String ?? ""
                                    villageObj.name = (i as AnyObject).value(forKey:"name") as? String ?? ""
                                    self.arrayVillages.append(villageObj)
                                   
                                }
                                for i in self.arrayVillages{
                                    if self.tfMandal.text == i.mandalName {
                                      self.tfVillage.text = i.name
                                      }
                                }
                            }
                        }
                        var secDetails = SectionDetails()
                        self.sectionNames.removeAll()
                        let retailerListstr = NSLocalizedString("Retailer_List", comment: "")
                        secDetails.itemName  = retailerListstr
                        secDetails.collapsed = false
                        self.sectionNames.append(secDetails)
                        if self.totalRetailers.count ==  0 {
                            //                                self.lblNoRewards.isHidden = false
                            self.tblViewRetailers.isHidden = true
                        }
                        else{
                            //                                self.lblNoRewards.isHidden = true
                            self.tblViewRetailers.isHidden = false
                            self.tblViewRetailers.reloadData()
                            
                            var heightConstant = CGFloat((self.arrayRetailers.count  * 44)  + 100)
                            self.tblViewRetailers.isScrollEnabled = false
                            self.tblHgtConstraint.constant = heightConstant + 100
                        }
                        
                    }
                        
                    else if responseStatusCode == STATUS_CODE_601{
                        Constatnts.logOut()
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    }else if responseStatusCode == STATUS_CODE_500{
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast("Please try Again later")
                        }
                    }else if responseStatusCode == STATUS_CODE_105{
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }else   {
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    }
                }
            }
            else{
                
                self.view.makeToast((response.error?.localizedDescription)!)
            }
            let userObj  = Constatnts.getUserObject()
            
        }
    }
    
    
    func requestToGetgetRetailersInformation(params : Parameters){
        SwiftLoader.show(animated: true)
        let headers = Constatnts.getLoggedInFarmerHeaders()
        let urlString:String =  BASE_URL + GET_RETAILERS //"http://pioneeractivity.in/rest/cropAdvisory/getRetaillers" //String(format: "%@%@", arguments: [BASE_URL,GET_RETAILERS]  ) // // ["http://192.168.3.141:8080/ATP/rest/" ,"cashFreeReward/getCashFreeTransactionPendingRequest_V2"]
        
        Alamofire.request(urlString, method: .post, parameters :  params , encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            
            if response.result.error == nil {
                if let json = response.result.value {
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        print("Response after decrypting data:\(decryptData)")
                        self.arrayRetailers.removeAll()
                        let userObj = Constatnts.getUserObject()
                        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"screen_name" : "RetailerInformationViewController" ] as [String : Any]
                        //
                self.registerFirebaseEvents("PV_RetailerMaster_success", userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "RetailerInformationViewController" , parameters: fireBaseParams as NSDictionary)
                        
                        if let cashFree = decryptData.value(forKey: "retailerList") as? NSArray {
   self.arrayRetailers.removeAll()
                            self.arrayRetailers.removeAll()
                            if cashFree.count > 0 {
                                for i in cashFree {
                                    var arrTrans = RetailerInformation()
                                    arrTrans.retailerFirmName = (i as AnyObject).value(forKey:"retailerFirmName") as? String ?? ""
                                    arrTrans.retailerId = (i as AnyObject).value(forKey:"retailerId") as? String ?? ""
                                    arrTrans.retailerPINCode = (i as AnyObject).value(forKey:"retailerPINCode") as? String ?? ""
                                    arrTrans.retailerMobileNumber = (i as AnyObject).value(forKey:"retailerMobileNumber") as? String ?? ""
                                    arrTrans.officeAddress = (i as AnyObject).value(forKey:"officeAddress") as? String ?? ""
                                    self.arrayRetailers.append(arrTrans)
                                }
                                var secDetails = SectionDetails()
                                self.sectionNames.removeAll()
                                secDetails.itemName  = NSLocalizedString("Retailer_List", comment: "")
                                secDetails.collapsed = false
                                self.sectionNames.append(secDetails)
                                if self.arrayRetailers.count ==  0 {
                                    //                                self.lblNoRewards.isHidden = false
                                    self.tblViewRetailers.isHidden = true
                                }
                                else{
                                    //                                self.lblNoRewards.isHidden = true
                                    self.tblViewRetailers.isHidden = false
                                    self.tblViewRetailers.reloadData()
                                    
                                    var heightConstant = CGFloat((self.arrayRetailers.count  * 44)  + 100)
                                    self.tblViewRetailers.isScrollEnabled = false
                                    self.tblHgtConstraint.constant = heightConstant + 100
                                    
                                }
                                
                            }else {
                                self.tblViewRetailers.isHidden = true
                            }
                        }
                    }
                    else if responseStatusCode == STATUS_CODE_601{
                        Constatnts.logOut()
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    }else if responseStatusCode == STATUS_CODE_500{
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            
                        let userObj = Constatnts.getUserObject()
                        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"screen_name" : "RetailerInformationViewController" ] as [String : Any]
                                          //
                        self.registerFirebaseEvents("PV_RetailerMaster_something_WentWrong", userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "RetailerInformationViewController" , parameters: fireBaseParams as NSDictionary)
                            
                            self.view.makeToast("Please try Again later")
                        }
                    }else if responseStatusCode == STATUS_CODE_105{
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }else   {
                        
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
    
    @IBAction func selectedCloseButton(_ sender : UIButton){
        self.viewSelectedRetailer.isHidden = true
        self.tblViewRetailers.isHidden = false
        self.scrollView.setContentOffset(.zero, animated: true)
    }
}
extension RetailerInformationViewController  : UITableViewDelegate , UITableViewDataSource {
    //MARK:- UITABLEVIEW DELEGATE AND DATA SOURCE METHODS
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == crop_dropDownTable {
            return cropNamesArray.count
        }else  if tableView == mandal_dropDownTable {
            return mandalNamesArray.count
        }else  if tableView == village_dropDownTable {
            return filteredVillageNamesArray.count
        }else {
            
            if(searchActive) {
                return filteredCustomer.count
            }
            return (self.arrayRetailers.count)
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        print(self.sectionNames[section])
        if tableView == tblViewRetailers {
            if self.sectionNames[section].itemName.lowercased() == NSLocalizedString("Retailer_List", comment: "") && self.arrayRetailers.count > 0  {
                return (self.sectionNames[section].itemName.capitalized)
            }else {
                return ""
            }
        }
        return ""
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblViewRetailers {
            if self.sectionNames[section].itemName.lowercased() == "retailers list" && self.arrayRetailers.count > 0  {
                return 44.0;
            }else {
                return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0;
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if tableView == tblViewRetailers {
            //recast your view as a UITableViewHeaderFooterView
            if self.sectionNames[section].itemName.lowercased() == "retailers list" && self.arrayRetailers.count > 0 {
                let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
                header.frame = CGRect(x: 10, y: header.frame.origin.y, width: header.frame.size.width-10, height: 50)
                header.contentView.backgroundColor = App_Theme_Blue_Color
                header.textLabel?.textColor = UIColor.white
                
                header.textLabel?.font = UIFont.systemFont(ofSize: 20.0)
                header.textLabel?.text = header.textLabel!.text!.capitalized
                header.textLabel?.isUserInteractionEnabled = false
                if let viewWithTag = self.view.viewWithTag(kHeaderSectionTag + section) {
                    viewWithTag.removeFromSuperview()
                }
                let headerFrame = self.view.frame.size
                
                // header.contentView.addBorder(toSide: .Top, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: header.contentView.frame.size.height-1, height: 1.0)
                header.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: 50)
                // header.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: header.frame.size.width-1, yValue: 0, height: 50)
                
                
                
                //            self.theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 60, y: 0, width: 50, height: 50));
                //            if self.sectionNames[section].collapsed == true {
                //                theImageView.image = UIImage(named: "downArrow")
                //
                //            }else {
                //                theImageView.image = UIImage(named: "upArrow")
                //            }
                //            theImageView.tintColor = UIColor.orange
                //            theImageView.tag = kHeaderSectionTag + section
                
                var headerSubTitle = UILabel()
                headerSubTitle = UILabel(frame: CGRect(x:
                    headerFrame.width - 120, y: 0, width: 100, height: 50));
                headerSubTitle.isUserInteractionEnabled = false
                
                headerSubTitle.textColor = UIColor.white
                headerSubTitle.tag = kHeaderSectionTag + section
                //headerSubTitle.tag = kHeaderSectionTag + section
                header.addSubview(headerSubTitle)
                header.addSubview(theImageView)
                if header.textLabel?.text?.lowercased() == "retailers list" {
                    headerSubTitle.isHidden = false
                }else  {
                    headerSubTitle.isHidden = true
                }
                // make headers touchable
                
                header.tag = section
                let headerTapGesture = UITapGestureRecognizer()
                headerTapGesture.addTarget(self, action: #selector(RewardsViewController.sectionHeaderWasTouched(_:)))
                header.addGestureRecognizer(headerTapGesture)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  tableView == self.crop_dropDownTable{
            return 35
        }else if  tableView == self.mandal_dropDownTable{
            return 35
        }else if  tableView == self.village_dropDownTable{
            return 35
        }else {
            return 160
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblViewRetailers {
            let cell1 = tblViewRetailers.dequeueReusableCell(withIdentifier: "RetailerInfoCell", for: indexPath) as? RetailerInfoCell
            cell1?.frame = CGRect(x: tableView.frame.origin.x - 5  , y: tableView.frame.origin.y, width: tableView.frame.size.width, height: 35 )
            self.viewSelectedRetailer.isHidden = true
            var detail   = RetailerInformation()
            if(searchActive) {
                detail = self.filteredCustomer[indexPath.row]
            }else{
                detail = self.arrayRetailers[indexPath.row]
            }
            
            cell1?.retailerName.text = ": " + detail.retailerFirmName
            cell1?.retailerMobileNumber.text = ": " + detail.retailerMobileNumber
            cell1?.retailerAddress.text = ": " + detail.officeAddress
            
            cell1?.tag =  indexPath.row
            cell1?.contentView.addBorder(toSide: .Bottom, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: (cell1?.contentView.frame.size.height)!-1, height: 1.0)
            cell1?.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: cell1?.contentView.frame.size.height)
            cell1?.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: (cell1?.contentView.frame.size.height)!-1, yValue: 0, height: cell1?.contentView.frame.size.height)
            
            //        let headerTapGesture = UITapGestureRecognizer()
            //        headerTapGesture.addTarget(self, action: #selector(RewardsViewController.NavigationToPaymentSelection))
            //        cell1?.addGestureRecognizer(headerTapGesture)
            return cell1!
        }else   {
            let cellIdentifier = "Cell"
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellIdentifier)
            cell.textLabel?.font = UIFont.init(name: "Helvetica", size: 13.0)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.sizeToFit()
            cell.textLabel?.text = "hi"
            cell.backgroundColor = UIColor.white
            
            if    tableView == self.crop_dropDownTable {
                let stateDic = cropNamesArray.object(at: indexPath.row) as? NSDictionary
                cell.textLabel?.text = stateDic?.value(forKey: "name") as? String
            }
            else if  tableView == self.mandal_dropDownTable{
                let stateDic = mandalNamesArray.object(at: indexPath.row) as? String
                cell.textLabel?.text = stateDic
            }else if  tableView == self.village_dropDownTable{
                let stateDic = filteredVillageNamesArray[indexPath.row]
                cell.textLabel?.text = stateDic.name
            }
            
            
            return cell
            
        }
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        let separatorView = UIView(frame: CGRect(x: tableView.separatorInset.left, y: footerView.frame.height, width: tableView.frame.width - tableView.separatorInset.right - tableView.separatorInset.left, height: 0))
        separatorView.backgroundColor = UIColor.separatorColor
        footerView.addSubview(separatorView)
        return footerView
    }
    
    // MARK: - Expand / Collapse Methods
    
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section    = headerView.tag
        //        let theImageView = headerView.viewWithTag(kHeaderSectionTag + section)
        
        let collapsed = !self.sectionNames[section].collapsed
        
        
        //         Toggle collapse
        self.sectionNames[section].collapsed = collapsed
        UIView.animate(withDuration: 0.4, animations: {
            self.theImageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
        })
        tblViewRetailers.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblViewRetailers {
            //self.tblViewRetailers.isUserInteractionEnabled = true
            var detail   = RetailerInformation()
            if(searchActive) {
                
                detail = self.filteredCustomer[indexPath.row]
            }else{
                detail = self.arrayRetailers[indexPath.row]
            }
            
            selectedRetailerID =  detail.retailerId
            
            self.tblViewRetailers.isHidden = true
            self.viewSelectedRetailer.isHidden = false
            self.lblSelectedRetailerName.text = ":  " + detail.retailerFirmName
            self.lblSelectedRetailerMobileNumber.text = ":  " + detail.retailerMobileNumber
            self.lblSelectedRetailerAddress.text = ":  " + detail.officeAddress
//            self.scrollView.setContentOffset(.zero, animated: true)
         
           
            self.tfCrop.resignFirstResponder()
        }else {
            if  tableView == self.crop_dropDownTable {
                self.tblViewRetailers.isUserInteractionEnabled = true
                //get crop id
                if self.cropNamesArray.count>0{
                    let cropDic = self.cropNamesArray.object(at: indexPath.row) as? NSDictionary
                    cropID = cropDic?.value(forKey: "id") as? Int ?? 0
                    self.tfCrop.text = cropDic?.value(forKey: "name") as? String
                    
                    tableView.isHidden = true
                }
                if crop_dropDownTable != nil{
                    tableView.isHidden = true
                }
                crop_dropDownTable.removeFromSuperview()
            }else if tableView == self.mandal_dropDownTable {
                //get crop id
                if self.mandalNamesArray.count>0{
                    let cropDic = self.mandalNamesArray.object(at: indexPath.row) as? String
                    self.tfMandal.text = cropDic
                    self.tfVillage.text = ""
                    
                    tableView.isHidden = true
                }
                if mandal_dropDownTable != nil{
                    tableView.isHidden = true
                }
                filteredVillageNamesArray.removeAll()
                               
                               let filteredArray = arrayVillages.filter{ ($0.mandalName.contains(self.tfMandal.text!)) }
                               print(filteredArray.map({"\($0.mandalName)"}))
                               print(filteredArray)
                               if filteredArray.count > 0{
                                   filteredVillageNamesArray = filteredArray
                               }
                mandal_dropDownTable.removeFromSuperview()
            }else if tableView == self.village_dropDownTable {
                //get crop id
                if self.filteredVillageNamesArray.count>0{
                    let cropDic = self.filteredVillageNamesArray[indexPath.row] as!  villageModelObj
                    self.tfVillage.text = cropDic.name
                    tableView.isHidden = true
                    
                }
//                let filteredArray = totalRetailers.filter{ ($0.officeAddress.contains(self.tfVillage.text!)) }
//                print(filteredArray)
//                if filteredArray.count > 0{
//                    arrayRetailers = filteredArray
//                    self.tblViewRetailers.isHidden = false
//                    self.tblViewRetailers.reloadData()
//                }else {
//                    self.tblViewRetailers.isHidden = true
//                }
                let params_pincode : Parameters = ["mandal" : self.tfMandal.text ?? "" , "village" : self.tfVillage.text ?? "" ]
                
                self.requestToGetgetRetailersInformation(params: params_pincode)
                if village_dropDownTable != nil{
                    tableView.isHidden = true
                }
                village_dropDownTable.removeFromSuperview()
            }else {
                tableView.isHidden = true
            }
        }
    }
    
    @IBAction func imageCaptureAction(_ sender : UIButton)  {
        
        if capturedImage.image  != UIImage(named: "Avatar") {
            let attributedString = NSAttributedString(string: "Choose Option", attributes: [
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20),
                NSAttributedStringKey.foregroundColor : UIColor.orange
            ])
            let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
            alertController.setValue(attributedString, forKey: "attributedMessage")
            let viewImageStr = NSLocalizedString("View_Photo", comment:"" )
            let sendButton = UIAlertAction(title: viewImageStr, style: .default, handler: { (action) -> Void in
                let previewController = ImagePreviewController()
                previewController.selectedImage = self.selectedImage
                self.present(previewController, animated: true, completion: nil)
            })
            let removeImageStr = NSLocalizedString("Remove_Photo", comment:"" )
            let  deleteButton = UIAlertAction(title: removeImageStr, style: .default, handler: { (action) -> Void in
                self.capturedImage.image  = UIImage(named: "Avatar")
            })
            let cancelStr = NSLocalizedString("cancel", comment:"" )
            let  cancelButton = UIAlertAction(title: cancelStr, style: .cancel, handler: { (action) -> Void in
                print("Cancel button tapped")
            })
            alertController.addAction(sendButton)
            alertController.addAction(deleteButton)
            alertController.addAction(cancelButton)
            isCameraOrGaleery = true
            self.navigationController!.present(alertController, animated: true, completion: nil)
        }else {
            let userObj = Constatnts.getUserObject()
            let choose_option_LocStr = NSLocalizedString("choose_option", comment:"" )
            
            let attributedString = NSAttributedString(string: choose_option_LocStr, attributes: [
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20),
                NSAttributedStringKey.foregroundColor : UIColor.orange
            ])
            let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            alertController.setValue(attributedString, forKey: "attributedMessage")
            let camera_LocStr = NSLocalizedString("camera", comment:"" )
            let sendButton = UIAlertAction(title: camera_LocStr, style: .default, handler: { (action) -> Void in
                print("Camera button tapped")
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.camera()
                    // firebase Events
                }
                else{
                    print("not compatible")
                }
            })
              let gallery_LocStr = NSLocalizedString("gallery", comment:"" )
            let  deleteButton = UIAlertAction(title: gallery_LocStr, style: .default, handler: { (action) -> Void in
                print("Gallery button tapped")
                self.photoLibrary()
                //let userObj = Constatnts.getUserObject()
                //let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,CROP:self.cropNameFromCropDiagnosisVC ?? ""]
                //self.registerFirebaseEvents(CD_Crop_Gallery, "", "", "", parameters: firebaseParams as NSDictionary)
            })
            let cancelStr = NSLocalizedString("cancel", comment:"" )
            let  cancelButton = UIAlertAction(title: cancelStr, style: .cancel, handler: { (action) -> Void in
                print("Cancel button tapped")
            })
            alertController.addAction(sendButton)
            alertController.addAction(deleteButton)
            alertController.addAction(cancelButton)
            isCameraOrGaleery = true
            self.navigationController!.present(alertController, animated: true, completion: nil)
        }
    }
    
    //MARK:- Camera Action
    @IBAction func cameraAction(_ sender : UIButton) {
        self.camera()
    }
    
    //MARK: camera
    func camera()
    {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.allowsEditing = true
        myPickerController.sourceType = UIImagePickerControllerSourceType.camera
        self.present(myPickerController, animated: true, completion: nil)
    }
    //MARK: photo library
    func photoLibrary()
    {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.allowsEditing = true
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    //MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //print(info)
        
        if Reachability.isConnectedToNetwork(){
            
            if let image_data = info[UIImagePickerControllerEditedImage] as? UIImage {
                if let data = UIImagePNGRepresentation(image_data) as Data? {
                    let bcf = ByteCountFormatter()
                    bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
                    bcf.countStyle = .file
                    
                }
                
                let resizedImg = resized(image: image_data)
                if let data1 = UIImagePNGRepresentation(resizedImg!) as Data? {
                    //print("There were \(data1.count) bytes")
                    let bcf = ByteCountFormatter()
                    bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
                    bcf.countStyle = .file
                    
                }
                self.selectedImage =  resizedImg!
                self.capturedImage.setImage(self.selectedImage)
                let imageData:Data = UIImagePNGRepresentation(resizedImg!)!
                //  let imageStr = imageData.base64EncodedString()
         
                
                
            }
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        
        
        let heightConstant = CGFloat((self.arrayRetailers.count  * 160)  + 100)
        self.tblViewRetailers.isScrollEnabled = false
        self.tblHgtConstraint.constant = heightConstant + 500
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.tblHgtConstraint.constant +  500)
    }
    
    //MARK:- uploadingWithMultiPartFormData UPLOAD CAPTURE IMAGE FOR DIAGNOSIS
    func uploadingWithMultiPartFormData(_ imgData : UIImage ){
        let userObj = Constatnts.getUserObject()
        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"screen_name": "RetailerInformationViewController","retailerId" : selectedRetailerID] as [String : Any]
        self.registerFirebaseEvents("PV_Bill_upload_retailerId", "", "", "", parameters: firebaseParams as NSDictionary)
        
        //UPDATE
        //self.recordScreenView("UploadEVENT", Capture_Photo)
        
        //   SwiftLoader.show(animated: true)
        //let image = UIImage(named: "profile_icon.png")!
        
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        
        let cid = "\(cropID!)"
        // define parameters
        let parameters  : Parameters = [
            "retailerId": selectedRetailerID,"cropId" : cid , "billNo" : self.tfBillNumber.text ?? "","mandal" : self.tfMandal.text! , "village" : self.tfVillage.text!]

        let billNumber : String = self.tfBillNumber.text ?? ""
        
        print("parameters : %@",parameters)
        var endURL = ""
        
        if let imageData = UIImageJPEGRepresentation(imgData, 1) {
                     endURL = UPLOAD_RETAILERINFO
                    Alamofire.upload(multipartFormData: {(multipartFormData) in
                        // import image to request
                      multipartFormData.append(imageData, withName: "multipartFile", fileName: "image.jpg", mimeType: "image/png")
                        for (key, value) in parameters {
                            multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                        }
                    }, usingThreshold: 60, to: String(format :"%@%@",BASE_URL,endURL), method: .post, headers: headers, encodingCompletion: {(encodeResult) in
                        switch encodeResult {
                        case .success(let upload, _, _):
                            upload.validate().responseJSON { response in
                                //SKActivityIndicator.dismiss()
                                //  SwiftLoader.hide()
                                //
                                //debugPrint(response)
                                print(response)
                                if response.result.error == nil{
                                    if let json = response.result.value{
                                        print(json)
                                        let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                                            if responseStatusCode == STATUS_CODE_200{
                                                let userObj = Constatnts.getUserObject()
                    let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"screen_name" : "RetailerInformationViewController" ] as [String : Any]
                                                                                                         //
            self.registerFirebaseEvents("PV_Bill_Upload_Success", userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "RetailerInformationViewController" , parameters: fireBaseParams as NSDictionary)
                                                
                                                let success_Loc_string = NSLocalizedString("Your_Bill_uploaded_successfully_message", comment: "")
                                                let alertController = UIAlertController(title: NSLocalizedString("alert", comment: ""), message: success_Loc_string, preferredStyle: .alert)
                                                
                                                let backButtonAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: {
                                                    alert -> Void in
                                                    self.navigationController?.popToRootViewController(animated: true)
                                                })
                                                let backButtonAction1 = UIAlertAction(title: NSLocalizedString("booknow", comment: ""), style: .default, handler: {
                                                    alert -> Void in
                                                    let toRequesterController = self.storyboard?.instantiateViewController(withIdentifier: "RequesterViewController") as? RequesterViewController
                                                      
                                                    toRequesterController?.cropID = self.cropID ?? 0
                                                                 self.navigationController?.pushViewController(toRequesterController!, animated: true)
                                                })
                                                alertController.addAction(backButtonAction)
                                                alertController.addAction(backButtonAction1)
                                                self.present(alertController, animated: true, completion: nil)
                                                
                                                
                                            }else if responseStatusCode == STATUS_CODE_601{
                                                Constatnts.logOut()
                                                if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                                    print(msg)
                                                    self.view.makeToast(msg as String)
                                                    //                                    self.errorMessage = msg as String
                                                }
                                            }else if responseStatusCode == INVALID_USER_STATUS_CODE_102{
                                                if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                                    print(msg)
                                                    let alertController = UIAlertController(title: NSLocalizedString("alert", comment: ""), message: msg as String, preferredStyle: .alert)
                                                    
                                                    let backButtonAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .cancel, handler: {
                                                        alert -> Void in
                                                         let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                                                        self.navigationController?.pushViewController(toSelectPayVC!, animated: false)
                                                    })
                                                    
                                                    let backButtonAction1 = UIAlertAction(title: NSLocalizedString("", comment: ""), style: .default, handler: {
                                                        alert -> Void in
                                                        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                                                        self.navigationController?.pushViewController(toSelectPayVC!, animated: false)
                                                    })
                                                    alertController.addAction(backButtonAction)
                                                    self.present(alertController, animated: true, completion: nil)
                                                }
                                                
                                            }else {
                                                if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                                    print(msg)
                                     let userObj = Constatnts.getUserObject()
                                      let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"screen_name" : "RetailerInformationViewController" ] as [String : Any]
                                      self.registerFirebaseEvents("PV_Bill_Upload_something_WentWrong", userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", "RetailerInformationViewController" , parameters: fireBaseParams as NSDictionary)
                                                    self.view.makeToast(msg as String)
                                                    //                                    self.errorMessage = msg as String
                                                }
                                                
                                                //                                self.navigationController?.pushViewController(toDiagnosisVC, animated: true)
                                            }
                                        
                                    }
                                    else{
                                        //  self.view.makeToast((response.result.error?.localizedDescription)!, duration: 1.0, position: .center)
                                        //                        let toDiagnosisVC = self.storyboard?.instantiateViewController(withIdentifier: "DiagnosisViewController") as! DiagnosisViewController
                                        //                        toDiagnosisVC.weatherJson = self.weatherJson
                                        //                        toDiagnosisVC.diseaseReqIdStr = self.diseaseReqIdStr
                                        //                        toDiagnosisVC.libMutArrToDisplay = self.libMutArrToDisplay
                                        //                        toDiagnosisVC.errorMessage = "Disease could not be Identified"
                                        //                        self.isCameraOrGaleery = true
                                        //                        self.navigationController?.pushViewController(toDiagnosisVC, animated: true)
                                        //
                                    }
                                }
                            }
                        case .failure(let encodingError):
                            print(encodingError)
                            PV_Bill_Upload_something_WentWrong
                            self.view.makeToast(encodingError.localizedDescription)
                        }
                    })
                 }else {
                     endURL = UPLOAD_RETAILERINFO_WITHOUTIMAGE
            Alamofire.upload(multipartFormData: {(multipartFormData) in
                // import image to request
                for (key, value) in parameters {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }, usingThreshold: 60, to: String(format :"%@%@",BASE_URL,endURL), method: .post, headers: headers, encodingCompletion: {(encodeResult) in
                switch encodeResult {
                case .success(let upload, _, _):
                    upload.validate().responseJSON { response in
                        //SKActivityIndicator.dismiss()
                        //  SwiftLoader.hide()
                        //
                        //debugPrint(response)
                        print(response)
                        if response.result.error == nil{
                            if let json = response.result.value{
                                print(json)
                                let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                                    if responseStatusCode == STATUS_CODE_200{
                                         let success_Loc_string = NSLocalizedString("Your_Bill_uploaded_successfully_message", comment: "")
                                        let alertController = UIAlertController(title: NSLocalizedString("alert", comment: ""), message: success_Loc_string , preferredStyle: .alert)
                                        
                                        let backButtonAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .cancel, handler: {
                                            alert -> Void in
                                                 
                                        })
                                        let backButtonAction1 = UIAlertAction(title: NSLocalizedString("Register", comment: ""), style: .default, handler: {
                                            alert -> Void in
                                            let toRequesterController = self.storyboard?.instantiateViewController(withIdentifier: "RequesterViewController") as? RequesterViewController
                                              
                                            toRequesterController?.cropID = self.cropID ?? 0
                                                         self.navigationController?.pushViewController(toRequesterController!, animated: true)
                                        })
                                        alertController.addAction(backButtonAction)
                                        alertController.addAction(backButtonAction1)
                                        self.present(alertController, animated: true, completion: nil)
                                        
                                        
                                    }else if responseStatusCode == STATUS_CODE_601{
                                        Constatnts.logOut()
                                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                            print(msg)
                                            self.view.makeToast(msg as String)
                                            //                                    self.errorMessage = msg as String
                                        }
                                    }else if responseStatusCode == INVALID_USER_STATUS_CODE_102{
                                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                            print(msg)
                                            let alertController = UIAlertController(title: NSLocalizedString("alert", comment: ""), message: msg as String, preferredStyle: .alert)
                                            
                                            let backButtonAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .cancel, handler: {
                                                alert -> Void in
                                                 let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                                                self.navigationController?.pushViewController(toSelectPayVC!, animated: false)
                                            })
                                            alertController.addAction(backButtonAction)
                                            self.present(alertController, animated: true, completion: nil)
                                        }
                                        
                                    }else {
                                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                            print(msg)
                                            self.view.makeToast(msg as String)
                                            //                                    self.errorMessage = msg as String
                                        }
                                        
                                        //                                self.navigationController?.pushViewController(toDiagnosisVC, animated: true)
                                    }
                                
                            }
                            else{
                                //  self.view.makeToast((response.result.error?.localizedDescription)!, duration: 1.0, position: .center)
                                //                        let toDiagnosisVC = self.storyboard?.instantiateViewController(withIdentifier: "DiagnosisViewController") as! DiagnosisViewController
                                //                        toDiagnosisVC.weatherJson = self.weatherJson
                                //                        toDiagnosisVC.diseaseReqIdStr = self.diseaseReqIdStr
                                //                        toDiagnosisVC.libMutArrToDisplay = self.libMutArrToDisplay
                                //                        toDiagnosisVC.errorMessage = "Disease could not be Identified"
                                //                        self.isCameraOrGaleery = true
                                //                        self.navigationController?.pushViewController(toDiagnosisVC, animated: true)
                                //
                            }
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    self.view.makeToast(encodingError.localizedDescription)
                }
            })
                 }
        
    }
    //MARK:- resized image
    func resized (image: UIImage) -> UIImage?{
        var actualHeight: Float = Float(image.size.height)
        var actualWidth: Float = Float(image.size.width)
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = 320.0 / 480.0
        if imgRatio != maxRatio {
            if imgRatio < maxRatio {
                imgRatio = 480.0 / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = 480.0
            }
            else {
                imgRatio = 320.0 / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = 320.0
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData:Data = UIImageJPEGRepresentation(img!, 1)!
        UIGraphicsEndImageContext()
        return UIImage(data: imageData)!
    }
    
    @IBAction func submitCapturedBillingDetails( _ sender : UIButton){
        if self.tfCrop.text == "" {
            self.view.makeToast("Please select Crop")
        }
            //        else if self.capturedImage.image == UIImage(named: "Avatar") {
            //            self.view.makeToast("Please Capture the bill")
            //        }
        else if self.lblSelectedRetailerName.text == "" {
            self.view.makeToast("Please Select Retailer")
        }else {
            let alertController = UIAlertController(title: NSLocalizedString("alert", comment: ""), message: NSLocalizedString("submit_data", comment: ""), preferredStyle: .alert)
            let yesButyton = UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: .default, handler: { (action) -> Void in
                print("Camera button tapped")
                self.uploadingWithMultiPartFormData(self.selectedImage)
            })
            let  noButton = UIAlertAction(title: NSLocalizedString("no", comment: ""), style: .cancel, handler: nil)
            
            alertController.addAction(yesButyton)
            alertController.addAction(noButton)
            self.navigationController!.present(alertController, animated: true, completion: nil)
            
        }
    }
}

extension RetailerInformationViewController : UISearchBarDelegate {
    //MARK:- Searchbar method
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            searchActive = false;
        } else {
            searchActive = true;
        }
//        self.tblViewRetailers.isHidden = false
//        self.viewSelectedRetailer.isHidden = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //searchActive = false;
        dismissKeyboard()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if self.doStringContainsNumber(_string: searchText){
            filteredCustomer.removeAll()
            filteredCustomer = arrayRetailers.filter({ (customer) -> Bool in
                let tmp: NSString = customer.retailerMobileNumber as NSString
                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            })
        }else {
            filteredCustomer.removeAll()
        filteredCustomer = arrayRetailers.filter({ (customer) -> Bool in
            let tmp: NSString = customer.retailerFirmName as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        }
        if(filteredCustomer.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tblViewRetailers.reloadData()
    }
    
    func doStringContainsNumber( _string : String) -> Bool{

    let numberRegEx  = ".*[0-9]+.*"
    let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let containsNumber = testCase.evaluate(with: _string)

    return containsNumber
    }
}
//MARK:- UITEXTFIELDDELEGATE METHODS
extension RetailerInformationViewController : UITextFieldDelegate{
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        if textField == self.tfCrop{
            textField.resignFirstResponder()
            if cropNamesArray.count > 0 {
                crop_dropDownTable = UITableView()
                crop_dropDownTable.reloadData()
                self.hideUnhideDropDownTblView(tblView: crop_dropDownTable, hideUnhide: false)
            }
        }else if textField == self.tfMandal{
            textField.resignFirstResponder()
            if mandalNamesArray.count > 0 {
                mandal_dropDownTable = UITableView()
                mandal_dropDownTable.reloadData()
                self.hideUnhideDropDownTblView(tblView: mandal_dropDownTable, hideUnhide: false)
            }
           
        }else if textField == self.tfVillage{
            if self.tfMandal.text != ""{
                textField.resignFirstResponder()
                if filteredVillageNamesArray.count > 0 {
                    village_dropDownTable = UITableView()
                    village_dropDownTable.reloadData()
                    self.hideUnhideDropDownTblView(tblView: village_dropDownTable, hideUnhide: false)
                }
            }else {
                self.view.makeToast("Please select mandal to select Village")
            }
            
        }
        
    }
    
    func filterVillagesBasedOnMandal(mandalName: String){
        
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
        
        if crop_dropDownTable != nil{
            crop_dropDownTable.isHidden = true
        }
        if mandal_dropDownTable != nil{
            mandal_dropDownTable.isHidden = true
        }
        if village_dropDownTable != nil{
            village_dropDownTable.isHidden = true
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
        
        
        if(textField == self.tfCrop){
            textField.resignFirstResponder()
            crop_dropDownTable = UITableView()
            
            loadTable(textField:  self.tfCrop , table : crop_dropDownTable)
            return false
        }else  if(textField == self.tfMandal){
            textField.resignFirstResponder()
            mandal_dropDownTable = UITableView()
            loadTable(textField:  self.tfMandal , table : mandal_dropDownTable)
            return false
        }else  if(textField == self.tfVillage){
            if self.tfMandal.text != ""{
//                textField.resignFirstResponder()
//                filteredVillageNamesArray.removeAll()
//
//                let filteredArray = arrayVillages.filter{ ($0.mandalName.contains(self.tfMandal.text!)) }
//                print(filteredArray.map({"\($0.mandalName)"}))
//                print(filteredArray)
//                if filteredArray.count > 0{
//                    filteredVillageNamesArray = filteredArray
//                }
//                village_dropDownTable = UITableView()
//                    loadTable(textField:  self.tfVillage , table : village_dropDownTable)
//                self.hideUnhideDropDownTblView(tblView: village_dropDownTable, hideUnhide: false)
                textField.resignFirstResponder()
                           village_dropDownTable = UITableView()
                           loadTable(textField:  self.tfVillage , table : village_dropDownTable)
                           return false
            }else {
                self.view.makeToast("Please select mandal to select Village")
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
    
    public func convertToDictionary(text: String) -> Any? {
        
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? Any
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return nil
        
    }
}
struct RetailerInformation {
    var retailerPINCode : String = ""
    var retailerMobileNumber : String = ""
    var retailerFirmName : String = ""
    var retailerId : String = ""
    var officeAddress : String = ""
}
struct villageModelObj {
    var mandalName : String = ""
    var name : String = ""
}


extension UISearchBar {
    var textField1: UITextField? { return value(forKey: "searchField") as? UITextField }
//    let str = NSLocalizedString("Searchby_Farmer_Mobile_Number" , comment : "")
    var placeholderLabel: UILabel? { return textField1?.value(forKey: "gjkl") as? UILabel }
    var icon: UIImageView? { return textField1?.leftView as? UIImageView }
    var iconColor: UIColor? {
        get {
            return icon?.tintColor
        }
        set {
            icon?.image = icon?.image?.withRenderingMode(.alwaysTemplate)
            icon?.tintColor = newValue
        }
    }
}
