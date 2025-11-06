//
//  RegisterViewController.swift
//  PioneerFarmerConnect
//
//  Created by Empover on 19/12/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import UIKit
import Alamofire

@objc public class CellData : NSObject{
    @objc var name: String
    @objc var isSelected: Bool
    @objc var dataId : String
    
    public init(name: String, selected: Bool = true) {
        self.name = name
        self.isSelected = selected
        self.dataId = "0"
    }
}
class RegisterViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var userTypeTxtFld: UITextField!
    @IBOutlet weak var firstNameTxtFld: UITextField!
    @IBOutlet weak var lastNameTxtFld: UITextField!
    @IBOutlet weak var countryTxtFld: UITextField!
    @IBOutlet weak var mobileNumberTxtFld: UITextField!
    @IBOutlet weak var emailIdTxtFLd: UITextField!
    //@IBOutlet weak var aadharNoTxtFLd: UITextField!
    @IBOutlet weak var pincodeTxtFld: UITextField!
    @IBOutlet weak var regionTxtFld: UITextField!
    @IBOutlet weak var stateTxtFld: UITextField!
    @IBOutlet weak var districtTxtFld: UITextField!
    @IBOutlet weak var villageLocationTxtFld: UITextField!
    @IBOutlet weak var totalCropAcresTxtFld: UITextField!
    @IBOutlet weak var cornAcresTxtFld: UITextField!
    @IBOutlet weak var riceAcresTxtFld: UITextField!
    @IBOutlet weak var milletAcresTxtFld: UITextField!
    @IBOutlet weak var musterdTxtFld: UITextField!
    @IBOutlet weak var privacyPolicyLbl: ActiveLabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var tblCropsAndCompanies: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tblCropsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!

    var mobileNumberFromLoginVCStr = NSString()
    var countryFromLoginVCStr = NSString()
    var countryCodeFromLoginVCStr = NSString()
    var countryIdFromLoginVCStr = NSString()
    var updatedPincodeString = ""
    var isFromEditProfile : Bool = false
    var arrIrrigations : NSMutableArray = NSMutableArray()
    var arrSeasons : NSMutableArray = NSMutableArray()
    var arrCompanies : NSMutableArray = NSMutableArray()
    var selectedLocation : CLLocationCoordinate2D?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setLeftPaddingToTextField(userTypeTxtFld, 10)
        self.setLeftPaddingToTextField(firstNameTxtFld, 10)
        self.setLeftPaddingToTextField(lastNameTxtFld, 10)
        self.setLeftPaddingToTextField(totalCropAcresTxtFld, 10)
        self.setLeftPaddingToTextField(emailIdTxtFLd, 10)
        self.setLeftPaddingToTextField(countryTxtFld, 10)
        self.setLeftPaddingToTextField(mobileNumberTxtFld, 10)
        self.setLeftPaddingToTextField(regionTxtFld, 10)
        self.setLeftPaddingToTextField(stateTxtFld, 10)
        self.setLeftPaddingToTextField(districtTxtFld, 10)
        self.setLeftPaddingToTextField(pincodeTxtFld, 10)
        self.setLeftPaddingToTextField(villageLocationTxtFld, 10)
        self.setLeftPaddingToTextField(cornAcresTxtFld, 10)
        self.setLeftPaddingToTextField(riceAcresTxtFld, 10)
        self.setLeftPaddingToTextField(milletAcresTxtFld, 10)
        self.setLeftPaddingToTextField(musterdTxtFld, 10)
        //self.setLeftPaddingToTextField(aadharNoTxtFLd, 10)
        tblCropsAndCompanies.tableFooterView = UIView()
        tblCropsAndCompanies.estimatedRowHeight = 40
        tblCropsAndCompanies.separatorStyle = .none
        let userObj = Constatnts.getUserObject()
        for seasonName in arrSeasonTypes {
            var isSelected = false
            if userObj.arrSeasons != nil{
                if userObj.arrSeasons!.contains(seasonName.uppercased()){
                    isSelected = true
                }
            }
            let cellData = CellData(name: seasonName as String? ?? "", selected: isSelected)
            arrSeasons.add(cellData)
        }
        for irrigationName in arrIrrigationTypes {
            var isSelected = false
            if userObj.arrIrrigations != nil{
                if userObj.arrIrrigations!.contains(irrigationName){
                    isSelected = true
                }
            }
            let cellData = CellData(name: irrigationName as String? ?? "", selected: isSelected)
            arrIrrigations.add(cellData)
        }
        if isFromEditProfile == true {
            self.updateUserProfileDataToUiComponents()
        }
        submitBtn.isUserInteractionEnabled = false
        submitBtn.backgroundColor = App_Theme_Blue_Color//UIColor(red: 104.0/255.0, green: 104.0/255.0, blue: 104.0/255.0, alpha: 1)
        
        pincodeTxtFld.delegate = self
        
        let customType = ActiveType.custom(pattern: "Privacy Policy")
        
        privacyPolicyLbl.enabledTypes.append(customType)
        
        privacyPolicyLbl?.customize({(label) in
            label.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                switch type {
                case customType:
                    atts[NSAttributedStringKey.underlineStyle] = isSelected ? NSUnderlineStyle.styleSingle.rawValue : NSUnderlineStyle.styleSingle.rawValue
                    atts[NSAttributedStringKey.foregroundColor] = isSelected ? UIColor(red: 255.0/255.0, green: 153.0/255.0, blue: 0.0/255.0, alpha: 1.0) : UIColor(red: 255.0/255.0, green: 153.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                default: ()
                }
                return atts
            }
            label.handleCustomTap(for: customType, handler: { (message) in
                // print("clicked")
                let net = NetworkReachabilityManager(host: "www.google.com")
                if net?.isReachable == true{
                    self.findHamburguerViewController()?.hideMenuViewControllerWithCompletion(nil)
                    let toPrivacyPolicyWebViewVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginPrivacyPolicyViewController") as! LoginPrivacyPolicyViewController
                    toPrivacyPolicyWebViewVC.privacyPolicyURLStr = PRIVACY_POLICY_URL as NSString
                    self.present(toPrivacyPolicyWebViewVC, animated: true, completion: nil)
                }
                else{
                    //self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE, duration: 1.0, position: .center)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                    return
                }
            })
            label.customColor[customType] = UIColor.white
        })
        self.requestToGetUserProfileMasterData()
        if isFromEditProfile == true {
            self.requestToGetCountriesListData()
            self.recordScreenView("RegisterViewController", Update_Profile)
            self.registerFirebaseEvents(PV_Update_Profile, mobileNumberFromLoginVCStr as String, "", "", parameters: nil)
        }
        else{
            self.recordScreenView("RegisterViewController", Register_Screen)
            self.registerFirebaseEvents(PV_Registration, "", "", "", parameters: nil)
        }
        if #available(iOS 10.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        let locationBtn = UIButton(type: .custom)
        locationBtn.frame = CGRect(x: 0, y: 0, width: 25, height: 35)
        locationBtn.setImage(UIImage(named:"LocationGray"), for:.normal)
        villageLocationTxtFld?.rightView = locationBtn
        villageLocationTxtFld?.rightViewMode = .always
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
        self.topView?.isHidden = false
        self.lblTitle?.text = "Registration"
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        userTypeTxtFld.text = "Farmer"
        if isFromEditProfile == true {
            self.lblTitle?.text = "Update Profile"
            if Validations.isNullString(stateTxtFld.text as NSString? ?? "") == false && Validations.isNullString(districtTxtFld.text as NSString? ?? "") == false &&  Validations.isNullString(regionTxtFld.text as NSString? ?? "") == false{
                self.submitBtn.isUserInteractionEnabled = true
                self.submitBtn.backgroundColor = App_Theme_Blue_Color//UIColor(red: 0.0/255.0, green: 163.0/255.0, blue: 81.0/255.0, alpha: 1)
            }
        }
        else{
            countryTxtFld.text = countryFromLoginVCStr as String
            mobileNumberTxtFld.text = mobileNumberFromLoginVCStr as String
        }
        self.updateTableViewHeightAndScrollViewHeight()
    }
    
    func updateUserProfileDataToUiComponents(){
        let userObj = Constatnts.getUserObject()
        userTypeTxtFld.text = userObj.customerTypeName as String? ?? ""
        self.disableMandatoryFieldsForUpdateProfile(userTypeTxtFld, isEnable: false)
        firstNameTxtFld.text = userObj.firstName as String? ?? ""
        lastNameTxtFld.text = userObj.lastName as String? ?? ""
        mobileNumberTxtFld.text = userObj.mobileNumber as String? ?? ""
        self.disableMandatoryFieldsForUpdateProfile(mobileNumberTxtFld, isEnable: false)
        emailIdTxtFLd.text = userObj.emailId as String? ?? ""
        //self.aadharNumberValidation(aadharNoTxtFLd, fieldText: userObj.aadhaarNumber as String? ?? "")
        pincodeTxtFld.text = userObj.pincode as String? ?? ""
        self.disableMandatoryFieldsForUpdateProfile(pincodeTxtFld, isEnable: false)
        stateTxtFld.text = userObj.stateName as String? ?? ""
        self.disableMandatoryFieldsForUpdateProfile(stateTxtFld, isEnable: false)
        regionTxtFld.text = userObj.regionName as String? ?? ""
        self.disableMandatoryFieldsForUpdateProfile(regionTxtFld, isEnable: false)
        districtTxtFld.text = userObj.districtName as String?
        self.disableMandatoryFieldsForUpdateProfile(districtTxtFld, isEnable: false)
        self.countryIdFromLoginVCStr = userObj.countryId!
        self.totalCropAcresTxtFld.text = userObj.totalCropAcress as String? ?? ""
        self.cornAcresTxtFld.text = userObj.corn as String?
        self.riceAcresTxtFld.text = userObj.rice as String?
        self.milletAcresTxtFld.text = userObj.millet as String?
        self.musterdTxtFld.text = userObj.mustard as String?
        self.villageLocationTxtFld.text = userObj.villageLocation as String?
        if Validations.isNullString(userObj.geolocation ?? "") == false{
            if let geoArray = userObj.geolocation?.components(separatedBy: ",") as NSArray?{
                if geoArray.count > 1{
                    let latitude = geoArray.object(at: 0) as? NSString
                    let longitude = geoArray.object(at: 1) as? NSString
                    self.selectedLocation = CLLocationCoordinate2D(latitude: (latitude?.doubleValue)!, longitude: (longitude?.doubleValue)!)
                }
            }
        }
        self.submitBtn.setTitle(NSLocalizedString("update", comment: ""), for: .normal)
        if Validations.isNullString(stateTxtFld.text as NSString? ?? "") == false && Validations.isNullString(districtTxtFld.text as NSString? ?? "") == false &&  Validations.isNullString(regionTxtFld.text as NSString? ?? "") == false{
            self.submitBtn.isUserInteractionEnabled = true
           // self.submitBtn.backgroundColor = UIColor(red: 0.0/255.0, green: 163.0/255.0, blue: 81.0/255.0, alpha: 1)
            self.submitBtn.backgroundColor = App_Theme_Blue_Color
        }
    }
    func disableMandatoryFieldsForUpdateProfile(_ textField: UITextField, isEnable:Bool){
        textField.isUserInteractionEnabled = isEnable
        textField.textColor = UIColor.lightGray
    }
    func setLeftPaddingToTextField(_ textField: UITextField, _ padding:CGFloat){
        textField.leftViewMode = .always
        textField.delegate = self
        textField.contentVerticalAlignment = .center
        textField.setLeftPaddingPoints(padding)
        if textField == countryTxtFld {
            textField.tintColor = UIColor.clear
        }
        
    }
    override func backButtonClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func sendPincodeToServer(){
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                self.view.endEditing(true)
            })
            let parameters = ["pincode":updatedPincodeString, "countryId":self.countryIdFromLoginVCStr] as NSDictionary
            let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
            let params =  ["data" : paramsStr]
            print(params)
            self.requestToGetLocationData(params: params as [String:String])
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
    }
    //MARK: requestToGetCountriesData
    func requestToGetCountriesListData(){
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,LOGIN_GET_COUNTRIES_LIST])
        
        Alamofire.request(urlString, method: .post, parameters: ["data" : ""], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        //print("Response after decrypting data:\(decryptData)")
                        
                        let countryListArray = decryptData.value(forKey: "countryList") as! NSArray
                        let countriesListMutArray = NSMutableArray()
                       countriesListMutArray.removeAllObjects()
                        for i in 0 ..< countryListArray.count{
                            let countriesDict = countryListArray.object(at: i) as? NSDictionary
                            let countryData = Country(dict: countriesDict!)
                            countriesListMutArray.add(countryData)
                        }
                        //print(self.countriesListMutArray)
                        let userObj = Constatnts.getUserObject()
                        let predicate = NSPredicate(format: "countryId == %@",userObj.countryId!)
                        let filteredArray = countriesListMutArray.filtered(using: predicate) as NSArray?
                        if filteredArray != nil{
                            if filteredArray!.count > 0{
                                let country = filteredArray?.firstObject as? Country
                                self.countryTxtFld.text = country?.countryName as String?
                                self.disableMandatoryFieldsForUpdateProfile(self.countryTxtFld, isEnable: false)
                            }
                        }
                        //print(self.filteredArray)
                    }
                }
            }
        }
    }
    func requestToGetUserProfileMasterData(){
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,User_Profile_Master_Data])
        
        Alamofire.request(urlString, method: .post, parameters: ["data" : ""], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        //print("Response after decrypting data:\(decryptData)")
                        let countryListArray = decryptData.value(forKey: "companyList") as! NSArray
                        self.arrCompanies.removeAllObjects()
                        let userObj = Constatnts.getUserObject()
                        for i in 0 ..< countryListArray.count{
                            if let companyDict = countryListArray.object(at: i) as? NSDictionary{
                                if let name  = Validations.checkKeyNotAvail(companyDict, key: "name") as? String{
                                    let cellData = CellData(name: name, selected: false)
                                    if userObj.arrCompanies != nil{
                                        if (userObj.arrCompanies?.contains(name))!{
                                            cellData.isSelected = true
                                        }
                                    }
                                    if let id  = Validations.checkKeyNotAvail(companyDict, key: "id") as? Int64{
                                        cellData.dataId = String(format: "%d", id)
                                    }
                                    self.arrCompanies.add(cellData)
                                }
                            }
                        }
                        self.tblCropsAndCompanies.reloadData()
                        self.updateTableViewHeightAndScrollViewHeight()
                    }
                }
            }
        }
    }
    func requestToGetLocationData (params : [String:String]){
        SwiftLoader.show(animated: true)
        
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_LOCATION_FROM_PINCODE])
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                   // print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                       // print("Response after decrypting data:\(decryptData)")
                        
                        let defaults = UserDefaults.standard
                        defaults.set(decryptData, forKey: "PincodeData")
                        defaults.synchronize()
                        
                        DispatchQueue.main.async {
                            self.regionTxtFld.text = decryptData.value(forKeyPath: "regionName") as? String
                            self.stateTxtFld.text = decryptData.value(forKeyPath: "stateName") as? String
                            self.districtTxtFld.text = decryptData.value(forKeyPath: "districtName") as? String

                            self.submitBtn.isUserInteractionEnabled = true
                            self.submitBtn.backgroundColor = UIColor(red: 0.0/255.0, green: 163.0/255.0, blue: 81.0/255.0, alpha: 1)
                        }
                    }
                    else if responseStatusCode == STATUS_CODE_124{
                        if let message = (json as! NSDictionary).value(forKey: "message") as? NSString{
                            let appdelegate = UIApplication.shared.delegate as? AppDelegate
                            appdelegate?.window?.makeToast(message as String)
                        }
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitBtn_Touch_Up_Inside(_ sender: Any) {
        let totalAcres = NSString(string: totalCropAcresTxtFld.text ?? "0")
        var cornAcres = NSString(string: cornAcresTxtFld.text ?? "0")
        var riceAcres = NSString(string: riceAcresTxtFld.text ?? "0")
        var milletAcres = NSString(string: milletAcresTxtFld.text ?? "0")
        var musterdAcres = NSString(string: musterdTxtFld.text ?? "0")
        let seasonsPredicate = NSPredicate(format: "isSelected == true")
        let selectedSeasons = arrSeasons.filtered(using: seasonsPredicate) as NSArray?
        var seasons = ""
        if selectedSeasons != nil{
            if let seasonNamesArray = selectedSeasons?.value(forKeyPath: #keyPath(CellData.name)) as? [String] {
                seasons = seasonNamesArray.joined(separator: ",")
            }
        }
        let irrigationPredicate = NSPredicate(format: "isSelected == true")
        let selectedIrrigations = arrIrrigations.filtered(using: irrigationPredicate) as NSArray?
        var irrigations = ""
        if selectedIrrigations != nil{
            if let irrigationNamesArray = selectedIrrigations?.value(forKeyPath: #keyPath(CellData.name)) as? [String] {
                irrigations = irrigationNamesArray.joined(separator: ",")
            }
        }
        
        let companiesPredicate = NSPredicate(format: "isSelected == true")
        let selectedCompanies = arrCompanies.filtered(using: companiesPredicate) as NSArray?
        var companies = ""
        if selectedCompanies != nil{
            if let companiesNamesArray = selectedCompanies?.value(forKeyPath: #keyPath(CellData.dataId)) as? [String] {
                companies = companiesNamesArray.joined(separator: ",")
            }
        }
        
        if Validations.isNullString(firstNameTxtFld.text! as NSString) {
            self.view.makeToast(Please_Enter_First_Name)
            return
        }
        else if Validations.isNullString(lastNameTxtFld.text! as NSString) {
            self.view.makeToast(Please_Enter_Last_Name)
            return
        }
        else if Validations.isNullString(countryTxtFld.text! as NSString) || Validations.isNullString(self.countryIdFromLoginVCStr) {
            //self.view.makeToast(Please_Enter_Last_Name)
            return
        }
        else if Validations.isValidEmailAddress(emailIdTxtFLd.text ?? "") == false && Validations.isNullString(emailIdTxtFLd.text! as NSString) == false{
            self.view.makeToast(Please_Enter_EmailId)
            return
        }
        /*else if aadharNoTxtFLd.text?.count ?? 0 > 0 && aadharNoTxtFLd.text?.count ?? 0 < 14 {
            self.view.makeToast(Aadhar_Number)
            return
        }*/
        else if Validations.isNullString(villageLocationTxtFld.text! as NSString ) && self.selectedLocation == nil {
            self.view.makeToast(Select_Village_Your_Location)
            return
        }
        else if Validations.isNullString(totalCropAcresTxtFld.text! as NSString) {
            self.view.makeToast(Please_Enter_Total_Crop)
            return
        }
        else if totalAcres.integerValue < 1{
            self.view.makeToast(Total_Crop_Acres)
            return
        }
        else if cornAcres.integerValue < 1 && riceAcres.integerValue < 1 && milletAcres.integerValue < 1 && musterdAcres.integerValue < 1{
            self.view.makeToast(Valid_Crop_Acres)
            return
        }
        else if (cornAcres.integerValue+riceAcres.integerValue+milletAcres.integerValue+musterdAcres.integerValue) > totalAcres.integerValue {
            self.view.makeToast(Total_Crop_Acres_Sum)
            return
        }
        else if Validations.isNullString(irrigations as NSString){
            self.view.makeToast(Select_Any_Irrigation)
            return
        }
        else if Validations.isNullString(seasons as NSString){
            self.view.makeToast(Select_Any_Season)
            return
        }
        else if Validations.isNullString(companies as NSString){
            self.view.makeToast(Select_Any_Company)
            return
        }
        if Validations.isNullString(musterdAcres as NSString){
            musterdAcres = "0"
        }
        if Validations.isNullString(milletAcres as NSString){
            milletAcres = "0"
        }
        if Validations.isNullString(riceAcres as NSString){
            riceAcres = "0"
        }
        if Validations.isNullString(cornAcres as NSString){
            cornAcres = "0"
        }
        let deviceID = UIDevice.current.identifierForVendor!.uuidString.replacingOccurrences(of: "-", with: "") as String
        let geoLocation = String(format: "%f,%f", self.selectedLocation?.latitude ?? "",self.selectedLocation?.longitude ?? "")
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            //let parameters = ["mobileNumber":mobileNumberTxtFld.text!, "countryId":self.countryIdFromLoginVCStr,"firstName": firstNameTxtFld.text!,"lastName": lastNameTxtFld.text!,"pincode": pincodeTxtFld.text!,"stateName": stateTxtFld.text!,"districtName": districtTxtFld.text!,"region": regionTxtFld.text!,"emailId": emailIdTxtFLd.text!,"deviceId": deviceID,"deviceToken": "","totalCropAcres": totalCropAcresTxtFld.text!,"villageLocation":villageLocationTxtFld.text!,"geolocation":geoLocation,"cornCropAcres":cornAcres,"riceCropAcres":riceAcres,"milletCropAcres":milletAcres,"mustardCropAcres":musterdAcres,"season":seasons,"irrigation":irrigations,"company":companies,"aadhaarNumber":aadharNoTxtFLd.text!.replacingOccurrences(of: "-", with: ""),"deviceType":"iOS"] as NSDictionary
            let userData: User = Constatnts.getUserObject()
            let parameters = ["mobileNumber":mobileNumberTxtFld.text!, "countryId":self.countryIdFromLoginVCStr,"firstName": firstNameTxtFld.text!,"lastName": lastNameTxtFld.text!,"pincode": pincodeTxtFld.text!,"stateName": stateTxtFld.text!,"districtName": districtTxtFld.text!,"region": regionTxtFld.text!,"emailId": emailIdTxtFLd.text!,"deviceId": deviceID,"deviceToken": "","totalCropAcres": totalCropAcresTxtFld.text!,"villageLocation":villageLocationTxtFld.text!,"geolocation":geoLocation,"cornCropAcres":cornAcres,"riceCropAcres":riceAcres,"milletCropAcres":milletAcres,"mustardCropAcres":musterdAcres,"season":seasons,"irrigation":irrigations,"company":companies,"deviceType":"iOS","referrer":userData.deepLinkingString,"customerType" : "Farmer"] as NSDictionary

            if isFromEditProfile == true{
                let userObj = Constatnts.getUserObject()
                let paramsDic = NSMutableDictionary(dictionary: parameters)
                //paramsDic.setValue(userObj.customerId, forKey: "customerId")
                paramsDic.setValue(userObj.deviceToken, forKey: "deviceToken")
                let paramsStr = Constatnts.nsobjectToJSON(paramsDic as NSDictionary)
                let params =  ["data" : paramsStr]
                self.requestToUpdateUserProfile(params: params)
                self.registerFirebaseEvents(Update_Profile_Submit, "", "", "", parameters: nil)
            }
            else{
                let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
                let params =  ["data" : paramsStr]
                print(params)
                self.requestToGetRegister(registerParams: params as [String:String])
                self.registerFirebaseEvents(Registration_Submit, "", "", "", parameters: nil)
            }
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
    }
    @IBAction func locationButtonClick(_ sender: UIButton){
        self.view.endEditing(true)
        self.villageLocationTxtFld?.becomeFirstResponder()
    }
    func requestToGetRegister (registerParams : [String:String]){
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,REGISTER_USER])
        Alamofire.request(urlString, method: .post, parameters: registerParams, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                         self.registerFirebaseEvents(Registration_Success, "", "", "", parameters: nil)
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        //print("Response after decrypting data:\(decryptData)")
                        let userObj = User(dict: decryptData)
                        userObj.countryId = self.countryIdFromLoginVCStr
                       let toOTPVC = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController
                        toOTPVC?.loggingUser = userObj
                        toOTPVC?.isFromLogin = false
                        toOTPVC?.countryCodeStr = self.countryCodeFromLoginVCStr as String
                        self.navigationController?.pushViewController(toOTPVC!, animated: true)
                    }else if responseStatusCode == STATUS_CODE_601{
                       self.registerFirebaseEvents(Registration_Failure, "", "", "", parameters: nil)
                        Constatnts.logOut()
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    }
                }
            }
        }
    }
    
    func requestToUpdateUserProfile (params : [String:String]){
        SwiftLoader.show(animated: true)
        let userObj = Constatnts.getUserObject()
        
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,User_Profile_Update_Data])
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                         self.registerFirebaseEvents(Profile_update_success, "", "", "", parameters: nil)
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                       // print("Response after decrypting data:\(decryptData)")
                        //userObj.countryId = self.countryIdFromLoginVCStr
                        userObj.updateUserProfileData(dict: decryptData)
                        Constatnts.setUserToUserDefaults(user: userObj)
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            UIApplication.shared.keyWindow?.makeToast(msg as String)
                        }
                        self.navigationController?.popViewController(animated: true)
                    }
                    else if responseStatusCode == STATUS_CODE_601{
                       self.registerFirebaseEvents(Profile_update_failure, "", "", "", parameters: nil)
                        Constatnts.logOut()
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    }
                }
            }
        }
    }
    //MARK: UITableViewController Delegate and DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return arrIrrigations.count
        case 1:
            return arrSeasons.count
        case 2:
            return arrCompanies.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Type of Irrigation"
        }
        else if section == 1{
            return "Seasons Cultivated"
        }
        else if section == 2{
            return "Companies Patronized"
        }
        else{
            return ""
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ProfileCell"
        let cell = self.tblCropsAndCompanies.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let lblTitle = cell.viewWithTag(101) as? UILabel
        lblTitle?.font = UIFont.systemFont(ofSize: 15)
        let btnCheckBox = cell.viewWithTag(100) as? UIButton
        btnCheckBox?.isSelected = false
        btnCheckBox?.isUserInteractionEnabled = false
        cell.selectionStyle = .none
        if indexPath.section == 0 {
            let cellData = arrIrrigations.object(at: indexPath.row) as? CellData
            btnCheckBox?.isSelected = cellData!.isSelected
            lblTitle?.text = cellData?.name
        }
        else if indexPath.section == 1 {
            let cellData = arrSeasons.object(at: indexPath.row) as? CellData
            btnCheckBox?.isSelected = cellData!.isSelected
            lblTitle?.text = cellData?.name
        }
        else if indexPath.section == 2 {
            let cellData = arrCompanies.object(at: indexPath.row) as? CellData
            btnCheckBox?.isSelected = cellData!.isSelected
            lblTitle?.text = cellData?.name
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if let cellData = arrIrrigations.object(at: indexPath.row) as? CellData{
                cellData.isSelected = !cellData.isSelected
                arrIrrigations.removeObject(at: indexPath.row)
                arrIrrigations.insert(cellData, at: indexPath.row)
                self.tblCropsAndCompanies.reloadData()
            }
            break
        case 1:
            if let cellData = arrSeasons.object(at: indexPath.row) as? CellData{
                cellData.isSelected = !cellData.isSelected
                arrSeasons.removeObject(at: indexPath.row)
                arrSeasons.insert(cellData, at: indexPath.row)
                self.tblCropsAndCompanies.reloadData()
            }
            break
        case 2:
            if let cellData = arrCompanies.object(at: indexPath.row) as? CellData{
                cellData.isSelected = !cellData.isSelected
                arrCompanies.removeObject(at: indexPath.row)
                arrCompanies.insert(cellData, at: indexPath.row)
                self.tblCropsAndCompanies.reloadData()
            }
            break
        default:
            break
        }
    }
    func updateTableViewHeightAndScrollViewHeight(){
        self.tblCropsAndCompanies?.reloadData()
        self.tblCropsAndCompanies?.layoutIfNeeded()
        self.tblCropsHeightConstraint?.constant = min((self.tblCropsAndCompanies?.frame.size.width)!, (self.tblCropsAndCompanies?.contentSize.height)!)
        self.contentHeightConstraint?.constant = (730 + ((self.tblCropsAndCompanies?.contentSize.height)!))
        self.tblCropsAndCompanies?.layoutIfNeeded()
        self.view.layoutIfNeeded()
        self.view.updateConstraintsIfNeeded()
        self.scrollView?.contentSize = CGSize(width: (self.scrollView?.frame.size.width)!, height: (self.contentView?.frame.maxY)!  + 10)
    }
    func navigateToGoogleLocationSearchController(){
        let selectLocationController = self.storyboard?.instantiateViewController(withIdentifier: "SelectLocationViewController") as? SelectLocationViewController
        if self.selectedLocation != nil{
            selectLocationController?.selectLocation = self.selectedLocation
        }
        selectLocationController?.addressCompletionBlock = {(selectedlocation ,address,postalCode,isFromAddress,fromHomeNav) in
            if Validations.isNullString(address as NSString) == false{
                self.villageLocationTxtFld?.text = address
                self.villageLocationTxtFld?.resignFirstResponder()
                self.selectedLocation = selectedlocation
                self.dismiss(animated: true, completion: nil)
                UIView.animate(withDuration: 0.1) {
                    self.view.endEditing(true)
                }
                self.view.endEditing(true)
            }
            selectLocationController?.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(selectLocationController!, animated: true)
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


extension RegisterViewController : UITextFieldDelegate{
    //MARK: textfield delegate methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == villageLocationTxtFld {
            self.navigateToGoogleLocationSearchController()
            self.view.endEditing(true)
            return false
        }
        else if textField == userTypeTxtFld {
            self.view.endEditing(true)
            return false
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString: String? = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        if textField == pincodeTxtFld{
            let validCharSet = CharacterSet(charactersIn: "0123456789").inverted
            let filtered: String = (string.components(separatedBy: validCharSet) as NSArray).componentsJoined(by: "")
            let _char = string.cString(using: String.Encoding.utf8)
            let isBackSpace: Int = Int(strcmp(_char, "\\b"))
            if isBackSpace == -92 {
                // is backspace
                if textField.text?.count == 1 {
                }
                //print(newString?.count)
                if (newString?.count)! < 6{
                    regionTxtFld.text = ""
                    stateTxtFld.text = ""
                    districtTxtFld.text = ""
                    submitBtn.isUserInteractionEnabled = false
                    submitBtn.backgroundColor = UIColor(red: 104.0/255.0, green: 104.0/255.0, blue: 104.0/255.0, alpha: 1)
                }
                return true
            }
            if (filtered == "") {
            }
            if (newString?.count)! > 6 && range.length == 0 {
                return false
            }
            
            if (newString?.count)! == 6{
                print(newString!)
                updatedPincodeString = newString!
                self.sendPincodeToServer()
                return true
            }
            return (string == filtered)
        }
        /*else if textField == aadharNoTxtFLd{
            if newString?.count ?? 0 > 14{
                return false
            }
            self.aadharNumberValidation(textField,fieldText:newString ?? "")
            return false
        }*/
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField ==  pincodeTxtFld{
            if pincodeTxtFld.text!.count < 6{
                self.view.makeToast(Pincode_Characters_Limit)
            }
        }
    }
    func aadharNumberValidation(_ sender: UITextField, fieldText: String) {
        let validCharSet = CharacterSet(charactersIn: "0123456789-").inverted
        var text: String = (fieldText.components(separatedBy: validCharSet) as NSArray).componentsJoined(by: "")
        //var text: String = fieldText//sender.text!
        // Strip out all spaces
        text = text.replacingOccurrences(of: "-", with: "")
        // Truncate to 16 characters
        if text.count != 0 && text.count > 11 {
            if let aIndex = ((text as NSString?)?.substring(to: 12)) {
                text = aIndex
            }
        }
        // Insert spaces
        /*if text.count > 12 {
            text = (text as NSString).replacingCharacters(in: NSRange(location: 12, length: 0), with: "-")
        }*/
        if text.count > 8 {
            text = (text as NSString).replacingCharacters(in: NSRange(location: 8, length: 0), with: "-")
        }
        if text.count > 4 {
            text = (text as NSString).replacingCharacters(in: NSRange(location: 4, length: 0), with: "-")
        }
        sender.text = text
    }
}

