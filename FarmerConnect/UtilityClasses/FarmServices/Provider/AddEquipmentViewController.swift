//
//  AddEquipmentViewController.swift
//  FarmerConnect
//
//  Created by Admin on 19/12/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import Kingfisher

class AddEquipmentViewController: ProviderBaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var txtClassification : UITextField?
    @IBOutlet var txtModel : UITextField?
    @IBOutlet var txtMaker : UITextField?
    @IBOutlet var txtLocation : UITextField?
    @IBOutlet var txtPerformance : UITextField?
    @IBOutlet var txtVehicleYear : UITextField?
    @IBOutlet var txtServiceAreaDistance : UITextField?
    @IBOutlet var txtAvailableFromTiming : UITextField?
    @IBOutlet var txtAvailableToTimings : UITextField?
    @IBOutlet var txtMinimumService : UITextField?
    @IBOutlet var txtVehicleNumber : UITextField?
    @IBOutlet var txtDescription : UITextView?
    @IBOutlet var collectionImages : UICollectionView?
    @IBOutlet var btnClearImage : UIButton?
    @IBOutlet var btnSelectImage : UIButton?
    @IBOutlet var btnWithDriver : ISRadioButton?
    @IBOutlet var btnPickAnddrop : ISRadioButton?
    @IBOutlet var imgSelectedGalleryPic : UIImageView?
    @IBOutlet var scrollContentView : UIView?
    @IBOutlet var scrollView : UIScrollView?
    
    @IBOutlet weak var classifiedLbl: UILabel!
    @IBOutlet weak var makerlbl: UILabel!
    @IBOutlet weak var modelLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var performanceLbl: UILabel!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var vehicleLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var miniServiceLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    var arrEquipmentImages = NSMutableArray()
    var arrEquipmentDeletedImages = NSMutableArray()
    var arrEquipmentServerImages = NSMutableArray()
    var arrVehicleYears = NSMutableArray()
    var arrClassifications = NSMutableArray()
    var tblVehicleYear = UITableView()
    var tblClassifications = UITableView()
    var selectedImageIndex = 0
    var selectedClassification : EquipmentClassicfication?
    var equipmentLocation : CLLocationCoordinate2D?
    var isFromEdit : Bool = false
    var selectedEquipment : Equipment?
    var addEquipmentAlert : UIView?
    var unsavedChangesAlert : UIView?
    //var editEquipment : Equipment?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let today = Date()
        //var dateArray = [String]()
        for i in 0...14{
            let tomorrow = Calendar.current.date(byAdding: .year, value: -(i), to: today)
            let date = DateFormatter()
            date.dateFormat = "yyyy"
            let stringDate : String = date.string(from: tomorrow!)
            //today = tomorrow!
            arrVehicleYears.add(stringDate)
        }
        let selectStr = NSLocalizedString("select", comment: "")
        arrVehicleYears.insert(selectStr, at: 0)
        print(arrVehicleYears)
        
        txtClassification?.tintColor = UIColor.clear
        txtVehicleYear?.tintColor = UIColor.clear
        txtLocation?.tintColor = UIColor.clear
        //Adding VehicleYears Dropdown
        self.loadDropDownTableView(tableViewDataSource: self, tableViewDelegate: self, tableview: tblVehicleYear, textField: txtVehicleYear!)
        self.loadDropDownTableView(tableViewDataSource: self, tableViewDelegate: self, tableview: tblClassifications, textField: txtClassification!)
        self.getEquipmentsMasterData()
        if isFromEdit == true && selectedEquipment != nil{
            self.updateEquipmentsDetailsToAllFields(equipment: selectedEquipment!)
        }
        let classificationBtn = UIButton(type: .custom)
        classificationBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        classificationBtn.setImage(UIImage(named:"DropDown-1"), for:.normal)
        classificationBtn.addTarget(self, action: #selector(AddEquipmentViewController.classificationButtonClick(_:)), for: .touchUpInside)
        txtClassification?.rightView = classificationBtn
        txtClassification?.rightViewMode = .always
        
        
        let yearBtn = UIButton(type: .custom)
        yearBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        yearBtn.setImage(UIImage(named:"DropDown-1"), for:.normal)
        yearBtn.addTarget(self, action: #selector(AddEquipmentViewController.vehicleYearButtonClick(_:)), for: .touchUpInside)
        txtVehicleYear?.rightView = yearBtn
        txtVehicleYear?.rightViewMode = .always
        
//        let locationBtn = UIButton(type: .custom)
//        locationBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//        locationBtn.setImage(UIImage(named:"MappinRed"), for:.normal)
//        txtLocation?.rightView = locationBtn
//        txtLocation?.rightViewMode = .always
        self.recordScreenView("AddEquipmentViewController", Add_Equipment)
        self.registerFirebaseEvents(PV_FSP_Add_Equipment, "", "", "", parameters: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 10.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        classifiedLbl.text = "classification".localized
        makerlbl.text = "maker".localized
        modelLbl.text = "model".localized
        locationLbl.text = "location".localized
        performanceLbl.text = "performance".localized
        yearLbl.text = "year_manufacture".localized
        descriptionLbl.text = "description".localized
        vehicleLbl.text = "vehicle_number".localized
        distanceLbl.text = "distance_label".localized
        miniServiceLbl.text = "minimum_service".localized
        
        saveBtn.setTitle("save".localized, for: .normal)
    
        
        super.viewWillAppear(animated)
        self.showCartButton(false)
        self.topView?.isHidden = false
        self.lblTitle?.text = NSLocalizedString("add_equipment", comment: "")
        self.hideClearButton(true)
        self.hideFilterButton(true)
        if isFromEdit == true {
            self.lblTitle?.text = NSLocalizedString("edit_equipment", comment: "")
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.scrollView?.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: (scrollContentView?.frame.maxY)!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tblVehicleYear.isHidden = true
        tblClassifications.isHidden = true

    }
    func getEquipmentsMasterData(){
        let userObj = Constatnts.getUserObject()
        let headers : HTTPHeaders = ["userAuthorizationToken": userObj.userAuthorizationToken! as String,"mobileNumber":userObj.mobileNumber! as String,"customerId": userObj.customerId! as String,"deviceToken":userObj.deviceToken as String,"deviceId":userObj.deviceId! as String]
        
        SwiftLoader.show(animated: true)
        let urlString = String(format: "%@%@", arguments: [BASE_URL,Equipment_Classification])
        //let parameters = ["mobileNumber":userObj.mobileNumber,"customerId": loggingUser!.customerId,"deviceId":userObj.deviceId!,"countryId":userObj.countryId.integerValue,"deviceType":"iOS"] as NSDictionary
        Alamofire.request(urlString, method: .post, parameters: ["data" : ""], encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        let arrEquipmentClass = Validations.checkKeyNotAvailForArray(decryptData, key: "equipmentClassification")
                        let arraEquipClass:NSArray = arrEquipmentClass as! NSArray
                        for j in 0..<arraEquipClass.count{
                            if let equipDic = arraEquipClass.object(at: j) as? NSDictionary{
                                let equipment = EquipmentClassicfication(dict: equipDic)
                                self.arrClassifications.add(equipment)
                            }
                        }
                        let tempEqquip = EquipmentClassicfication(dict: NSDictionary())
                        tempEqquip.classificationId = "0"
                        tempEqquip.minimumServiceHours = "0"
                        self.arrClassifications.insert(tempEqquip, at: 0)
                        tempEqquip.name = "Select"
                        if self.isFromEdit == true && self.selectedEquipment != nil{
                            let classPredicate = NSPredicate(format: "name == %@", (self.selectedEquipment!.equipmentClassification)!)
                            let filterResult = self.arrClassifications.filtered(using: classPredicate)
                            if filterResult.count > 0{
                                self.selectedClassification = filterResult.first as? EquipmentClassicfication
                            }
                        }
                        self.tblClassifications.reloadData()
                        //print("Response after decrypting data:\(decryptData)")
                    }
                    else if responseStatusCode == STATUS_CODE_601{
                        Constatnts.logOut()
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    }
                    else{
                        if let message = (json as! NSDictionary).value(forKey: "message") as? String {
                            self.view.makeToast(message)
                        }
                    }
                }
            }
            else{
                self.view.makeToast((response.error?.localizedDescription)!)
            }
        }
    }
    
    func updateEquipmentsDetailsToAllFields(equipment:Equipment){
        txtClassification?.text = selectedEquipment?.equipmentClassification as String!
        txtClassification?.textColor = UIColor.lightGray
        txtClassification?.isUserInteractionEnabled = false
        txtModel?.text = selectedEquipment?.model as String!
        txtMaker?.text = selectedEquipment?.maker as String!
        txtPerformance?.text = selectedEquipment?.performance as String!
        txtLocation?.text = selectedEquipment?.equipmentLocationName as String!
        txtDescription?.text = selectedEquipment?.equipmentDescription2 as String!
        txtServiceAreaDistance?.text = selectedEquipment?.maxSerAreaDistProvided as String!
        txtVehicleYear?.text = selectedEquipment?.vehicleYear as String!
        txtVehicleNumber?.text = selectedEquipment?.equipmentVehicleNumber as String!
        txtMinimumService?.text = selectedEquipment?.minimumServiceHours as String!
        if selectedEquipment?.equipmentLatitude != nil && selectedEquipment?.equipmentLongitude != nil{
            equipmentLocation = CLLocationCoordinate2D(latitude: (selectedEquipment?.equipmentLatitude!.doubleValue)!, longitude: (selectedEquipment?.equipmentLongitude!.doubleValue)!)
        }
        if selectedEquipment?.pickAndDrop == "Yes" {
            btnPickAnddrop?.isSelected = true
            btnWithDriver?.isSelected = false
        }
        else if selectedEquipment?.withDriver == "Yes"{
            btnWithDriver?.isSelected = true
            btnPickAnddrop?.isSelected = false
        }
        if selectedEquipment!.arrImageUrls.count > 0 {
            arrEquipmentImages.addObjects(from: selectedEquipment?.arrImageUrls as! [Any])
        }
        selectedImageIndex = 0
        collectionImages?.reloadData()
    }
    //MARK: UICollectionView Datasource and Delegate methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrEquipmentImages.count == 0 {
            self.lblWaterMarlLabel?.isHidden = false
            lblWaterMarlLabel?.text = "No equipments are added by you."
        }
        self.lblWaterMarlLabel?.isHidden = true
        return arrEquipmentImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionImages?.dequeueReusableCell(withReuseIdentifier: "EquipmentImage", for: indexPath)
        let imageView = cell?.viewWithTag(100) as? UIImageView
        if let image = arrEquipmentImages.object(at: indexPath.row) as? UIImage{
            imageView?.image = image
        }
        else if let imageUrlStr = arrEquipmentImages.object(at: indexPath.row) as? NSString{
            let imageUrl = URL(string: imageUrlStr as String!)
            imageView?.kf.setImage(with: imageUrl as? Resource!, placeholder: UIImage(named: "image_placeholder.png"), options: nil, progressBlock: nil)
//            (with: imageUrl as Resource!, placeholder: UIImage(named: "image_placeholder.png"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        if selectedImageIndex == indexPath.row {
            imgSelectedGalleryPic?.image = imageView?.image
            btnClearImage?.isHidden = false
            btnClearImage?.tag = indexPath.row
        }
        
        return cell!
    }
    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.size.width/2)-30, height: (collectionView.bounds.size.width/2)-30)
    }*/
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)//top,left,bottom,right
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as UICollectionViewCell!
        if let image = arrEquipmentImages.object(at: indexPath.row) as? UIImage{
            imgSelectedGalleryPic?.image = image
        }
        if let imageUrl = arrEquipmentImages.object(at: indexPath.row) as? NSString {
            print(imageUrl)
            let imageView = cell?.viewWithTag(100) as? UIImageView
            imgSelectedGalleryPic?.image = imageView?.image
        }
        btnClearImage?.tag = indexPath.row
        selectedImageIndex = indexPath.row
        collectionImages?.reloadData()
    }
    
    func addEquipmentServiceCall(parameters: NSDictionary){
        //let userObj = Constatnts.getUserObject()
        let headers : HTTPHeaders = self.getProviderHeaders()
        print(headers)
        SwiftLoader.show(animated: true)
        let urlString = String(format: "%@%@", arguments: [BASE_URL,Add_Equipments])
        let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
        let params =  ["data" : paramsStr]
        print(params)
        //let parameters = ["mobileNumber":userObj.mobileNumber,"customerId": loggingUser!.customerId,"deviceId":userObj.deviceId!,"countryId":userObj.countryId.integerValue,"deviceType":"iOS"] as NSDictionary
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        if let message = (json as! NSDictionary).value(forKey: "message") as? String {
                            let appdelegate = UIApplication.shared.delegate as? AppDelegate
                            appdelegate?.window?.makeToast(message)
                            //self.view.makeToast(message)
                        }
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        if let equipmentId = decryptData.value(forKey: "equipmentId") as? Int{
                            AppDelegate.uploadEquipmentProfileImages(images: self.arrEquipmentImages, equipmentIdId: String(format: "%d",equipmentId), userId: "")
                        }
                        //print("Response after decrypting data:\(decryptData)")
                        self.navigationController?.popViewController(animated: true)
                    }
                    else if responseStatusCode == STATUS_CODE_601{
                        Constatnts.logOut()
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    }
                    else{
                        if let message = (json as! NSDictionary).value(forKey: "message") as? String {
                            self.view.makeToast(message)
                        }
                    }
                }
            }
            else{
                self.view.makeToast((response.error?.localizedDescription)!)
            }
        }
    }
    
    func updateEquipmentDetailsServiceCall(parameters:NSDictionary){
        let headers : HTTPHeaders = self.getProviderHeaders()
        print(headers)
        SwiftLoader.show(animated: true)
        let urlString = String(format: "%@%@", arguments: [BASE_URL,Edit_Equipment_Details])
        let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
        let params =  ["data" : paramsStr]
        print(params)
        //let parameters = ["mobileNumber":userObj.mobileNumber,"customerId": loggingUser!.customerId,"deviceId":userObj.deviceId!,"countryId":userObj.countryId.integerValue,"deviceType":"iOS"] as NSDictionary
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        if let equipmentId = decryptData.value(forKey: "equipmentId") as? Int{
                            AppDelegate.uploadEquipmentProfileImages(images: self.arrEquipmentImages, equipmentIdId: String(format: "%d",equipmentId), userId: "")
                        }
                        /*if let message = (json as! NSDictionary).value(forKey: "message") as? String {
                            let appdelegate = UIApplication.shared.delegate as? AppDelegate
                            appdelegate?.window?.makeToast(message)
                            //self.view.makeToast(message)
                        }*/
                        self.navigationController?.popViewController(animated: true)
                        //print("Response after decrypting data:\(decryptData)")
                    }
                    else if responseStatusCode == STATUS_CODE_601{
                        Constatnts.logOut()
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    }
                    else{
                        if let message = (json as! NSDictionary).value(forKey: "message") as? String {
                            self.view.makeToast(message)
                        }
                    }
                }
            }
            else{
                self.view.makeToast((response.error?.localizedDescription)!)
            }
        }
    }
    func checkForEquipmentUnSavedChangesAlet() -> Bool{
        if (arrEquipmentImages.count != 0 ||  txtClassification?.text != NSLocalizedString("select", comment: "")  || selectedClassification != nil || Validations.isNullString(txtMaker?.text as NSString!) == false || Validations.isNullString(txtModel?.text as NSString!) == false || Validations.isNullString(txtLocation?.text as NSString!) == false || equipmentLocation != nil || txtVehicleYear?.text != NSLocalizedString("select", comment: "") || Validations.isNullString(txtServiceAreaDistance?.text as NSString!) == false || Validations.isNullString(txtMinimumService?.text as NSString!) == false || Validations.isNullString(txtDescription?.text as NSString!) == false) {
            return true
        }
        return false
    }
    //MARK: UITableview delegate and datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblVehicleYear{
            return arrVehicleYears.count
        }
        else if tableView == tblClassifications{
            return arrClassifications.count
        }
        return 0
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.textAlignment = .center
        if tableView == tblVehicleYear{
            if let yearStr = arrVehicleYears.object(at: indexPath.row) as? String{
                cell.textLabel?.text = yearStr
            }
        }
        else if tableView == tblClassifications{
            let classification = arrClassifications.object(at: indexPath.row) as? EquipmentClassicfication
            cell.textLabel?.text = classification?.name as String!
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblVehicleYear{
            if let yearStr = arrVehicleYears.object(at: indexPath.row) as? String{
                txtVehicleYear?.text = yearStr
                txtVehicleYear?.resignFirstResponder()
            }
        }
        else if tableView == tblClassifications{
            let classification = arrClassifications.object(at: indexPath.row) as? EquipmentClassicfication
            selectedClassification = classification
            txtClassification?.text = classification?.name as String!
            txtMinimumService?.text = classification?.minimumServiceHours as String!
            txtClassification?.resignFirstResponder()
            txtMinimumService?.resignFirstResponder()

        }
        tableView.isHidden = true
        self.view.endEditing(true)
    }
    //MARK: UIButton click action methods
    @IBAction func clearGalleryPicButtonClick(_ sender: UIButton){
        if arrEquipmentImages.count > 0{
            if let deletedUrl = arrEquipmentImages.object(at: sender.tag) as? NSString {
                arrEquipmentDeletedImages.add(deletedUrl)
            }
            arrEquipmentImages.removeObject(at: sender.tag)
            if(arrEquipmentImages.count == 0){
                imgSelectedGalleryPic?.image = UIImage(named: "upload-ur-logo")
                btnClearImage?.tag = 0
                selectedImageIndex = 0
                btnClearImage?.isHidden = true
            }
            else{
                if let imageUrl = arrEquipmentImages.object(at: 0) as? NSString{
                    let index = arrEquipmentImages.index(of: imageUrl)
                    selectedImageIndex = index
                    btnClearImage?.tag = index
                }
                else if let imageSelect = arrEquipmentImages.object(at: 0) as? UIImage{
                    let index = arrEquipmentImages.index(of: imageSelect)
                    selectedImageIndex = index
                    btnClearImage?.tag = index
                }
            }
            collectionImages?.reloadData()
        }
    }
    @IBAction func selectVehiclePicButtonClick(_ sender: UIButton){
        if arrEquipmentImages.count < 3 {
            self.registerFirebaseEvents(FSP_Equipment_Image_selection, "", "", "", parameters: nil)
            let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
            {
                UIAlertAction in
                self.openCamera()
                
            }
            let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default)
            {
                UIAlertAction in
                self.openGallary()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
            {
                UIAlertAction in
                
            }
            // Add the actions
            
            alert.addAction(cameraAction)
            alert.addAction(gallaryAction)
            alert.addAction(cancelAction)
            // Present the controller
            self.present(alert, animated: true, completion: nil)
            
        }
        else{
            self.view.makeToast(Equipment_Images_Max_Select)
        }
    }
    @IBAction func withDriverButtonClick(_ sender: UIButton){
        
    }
    @IBAction func pickAndDropButtonClick(_ sender: UIButton){
        
    }
    @IBAction func classificationButtonClick(_ sender: UIButton){
        self.view.endEditing(true)
        self.txtClassification?.becomeFirstResponder()
    }
    @IBAction func vehicleYearButtonClick(_ sender: UIButton){
        self.view.endEditing(true)
        self.txtVehicleYear?.becomeFirstResponder()
    }
    @IBAction func locationButtonClick(_ sender: UIButton){
        self.view.endEditing(true)
        self.registerFirebaseEvents(FSP_Equipment_Location, "", "", "", parameters: nil)
        self.txtLocation?.becomeFirstResponder()
    }
    override func backButtonClick(_ sender: UIButton) {
        if self.isFromEdit == false{
            if self.checkForEquipmentUnSavedChangesAlet() == true{
                if addEquipmentAlert != nil{
                    self.addEquipmentAlert?.removeFromSuperview()
                }
                self.unsavedChangesAlert = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: NSLocalizedString("alert", comment: "") as NSString, message: String(format: NSLocalizedString("unsaved_changes_alert", comment: "")) as NSString, okButtonTitle:NSLocalizedString("yes", comment: "") , cancelButtonTitle: NSLocalizedString("no", comment: "")) as? UIView
                self.view.addSubview(self.unsavedChangesAlert!)
            }
            else{
                self.navigationController?.popViewController(animated: true)
            }
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func saveEquipmentButtonClick(_ sender: UIButton){
        //AppDelegate.uploadEquipmentProfileImages(images: arrEquipmentImages, equipmentIdId: "12", userId: "")
        if addEquipmentAlert != nil{
            addEquipmentAlert?.removeFromSuperview()
        }
        if arrEquipmentImages.count == 0{
            addEquipmentAlert = CustomAlert.alertInfoPopUpView(self, frame: self.view.frame, title: NSLocalizedString("alert", comment: "") as NSString, message: NSLocalizedString("select_equipment_image", comment: "") as NSString, buttonTitle: NSLocalizedString("ok", comment: "") , hideClose: true) as? UIView
            self.view.addSubview(addEquipmentAlert!)
        }
        else if Validations.isNullString(txtClassification?.text as NSString? ?? "") == true || txtClassification?.text == NSLocalizedString("select", comment: "") || selectedClassification == nil {
            addEquipmentAlert = CustomAlert.alertInfoPopUpView(self, frame: self.view.frame, title: NSLocalizedString("alert", comment: "") as NSString, message: NSLocalizedString("select_equipment_classification", comment: "") as NSString, buttonTitle: NSLocalizedString("ok", comment: ""), hideClose: true) as? UIView
            self.view.addSubview(addEquipmentAlert!)
        }
        else if Validations.isNullString(txtClassification?.text as NSString? ?? "") == true || txtClassification?.text == NSLocalizedString("select", comment: "")  || selectedClassification?.name == NSLocalizedString("select", comment: "") as NSString || selectedClassification?.minimumServiceHours?.integerValue == 0 {
            addEquipmentAlert = CustomAlert.alertInfoPopUpView(self, frame: self.view.frame, title: NSLocalizedString("alert", comment: "") as NSString, message: NSLocalizedString("select_equipment_classification", comment: "") as NSString, buttonTitle: NSLocalizedString("ok", comment: ""), hideClose: true) as? UIView
            self.view.addSubview(addEquipmentAlert!)
        }
        else if Validations.isNullString(txtMaker?.text as NSString? ?? "") == true{
            addEquipmentAlert = CustomAlert.alertInfoPopUpView(self, frame: self.view.frame, title: NSLocalizedString("alert", comment: "") as NSString, message: NSLocalizedString("maker_not_empty", comment: "") as NSString, buttonTitle: NSLocalizedString("ok", comment: ""), hideClose: true) as? UIView
            self.view.addSubview(addEquipmentAlert!)
        }
        else if Validations.isNullString(txtModel?.text as NSString? ?? "") == true{
            addEquipmentAlert = CustomAlert.alertInfoPopUpView(self, frame: self.view.frame, title: NSLocalizedString("alert", comment: "") as NSString, message: NSLocalizedString("model_not_empty", comment: "") as NSString, buttonTitle: NSLocalizedString("ok", comment: ""), hideClose: true) as? UIView
            self.view.addSubview(addEquipmentAlert!)
        }
        else if Validations.isNullString(txtLocation?.text as NSString? ?? "") == true || equipmentLocation == nil{
            addEquipmentAlert = CustomAlert.alertInfoPopUpView(self, frame: self.view.frame, title: NSLocalizedString("alert", comment: "") as NSString, message: NSLocalizedString("location_not_empty", comment: "") as NSString, buttonTitle: NSLocalizedString("ok", comment: ""), hideClose: true) as? UIView
            self.view.addSubview(addEquipmentAlert!)
        }
        else if Validations.isNullString(txtVehicleYear?.text as NSString? ?? "") == true || txtVehicleYear?.text == NSLocalizedString("select", comment: "") {
            addEquipmentAlert = CustomAlert.alertInfoPopUpView(self, frame: self.view.frame, title: NSLocalizedString("alert", comment: "") as NSString, message: NSLocalizedString("select_year_manufacture", comment: "") as NSString, buttonTitle: NSLocalizedString("ok", comment: ""), hideClose: true) as? UIView
            self.view.addSubview(addEquipmentAlert!)
        }
        else if Validations.isNullString(txtServiceAreaDistance?.text as NSString? ?? "") == true{
            addEquipmentAlert = CustomAlert.alertInfoPopUpView(self, frame: self.view.frame, title: NSLocalizedString("alert", comment: "") as NSString, message: NSLocalizedString("service_area_distance_not_empty", comment: "") as NSString, buttonTitle: NSLocalizedString("ok", comment: ""), hideClose: true) as? UIView
            self.view.addSubview(addEquipmentAlert!)
        }
        else if Validations.isNullString(txtMinimumService?.text as NSString? ?? "") == true{
            addEquipmentAlert = CustomAlert.alertInfoPopUpView(self, frame: self.view.frame, title: NSLocalizedString("alert", comment: "") as NSString, message: NSLocalizedString("min_service_area", comment: "") as NSString, buttonTitle: NSLocalizedString("ok", comment: ""), hideClose: true) as? UIView
            self.view.addSubview(addEquipmentAlert!)
        }
        else if Validations.isNullString(txtDescription?.text as NSString? ?? "") == true{
            addEquipmentAlert = CustomAlert.alertInfoPopUpView(self, frame: self.view.frame, title: NSLocalizedString("alert", comment: "") as NSString, message: NSLocalizedString("desc_not_empty", comment: "") as NSString, buttonTitle: NSLocalizedString("ok", comment: ""), hideClose: true) as? UIView
            self.view.addSubview(addEquipmentAlert!)
        }
        else{
            let minimumServiceHours = txtMinimumService!.text! as NSString
            let latitude = String(format: "%f", (equipmentLocation?.latitude)!)
            let longitude = String(format: "%f", (equipmentLocation?.longitude)!)
            let classificationId = selectedClassification!.classificationId!.integerValue
            var deletedImages = ""
            var equipmentId : NSString = ""
            if isFromEdit == true{
                for index in 0..<arrEquipmentDeletedImages.count{
                    if let deletedUrl = arrEquipmentDeletedImages.object(at: index) as? NSString{
                        if index == 0{
                            deletedImages = deletedUrl as String
                        }
                        else{
                            deletedImages = String(format : "%@,%@",deletedImages,deletedUrl)
                        }
                    }
                }
                equipmentId = (selectedEquipment?.equipmentId)!
            }
            let parameters = ["customerId":Constatnts.getCustomerId(),"latitude":latitude,"longitude":longitude,"equipmentClassification":classificationId,"model":txtModel!.text!,"performance":txtPerformance!.text!,"vehicleYear":txtVehicleYear!.text!,"serviceAreaDistance":txtServiceAreaDistance!.text!,"pickAndDrop":btnPickAnddrop!.isSelected,"withDriver":btnWithDriver!.isSelected,"minimumServiceHours":minimumServiceHours.integerValue,"equipmentDescription":txtDescription!.text!,"equipmentVehicleNumber":txtVehicleNumber!.text!,"locationName":txtLocation!.text!,"maker":txtMaker!.text!,"equipmentId":equipmentId,"deletedImages": deletedImages] as [String : Any]
            //print(parameters)
            if isFromEdit == true{
                if Validations.isNullString(equipmentId) == false && equipmentId.integerValue > 0{
                    self.updateEquipmentDetailsServiceCall(parameters: parameters as NSDictionary)
                    let userObj = Constatnts.getUserObject()
                    let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber,USER_ID:userObj.customerId,EQUIPMENT_ID:equipmentId,Maker:txtMaker!.text!,EquipmentClassificatnId :txtClassification!.text!,Manufacture_Year:parameters["vehicleYear"],PickAndDrop:parameters["pickAndDrop"],ServiceAreaDistance:parameters["serviceAreaDistance"],MinimumServiceHours: parameters["minimumServiceHours"],Equipment_Description: parameters["equipmentDescription"],VehicleNumber: parameters["equipmentVehicleNumber"],EQUIPMENT_CLASSIFICATION:txtClassification?.text!,Model:txtModel!.text!]
                    self.registerFirebaseEvents(FSP_Edit_Equipment, "", "", "", parameters: fireBaseParams as NSDictionary)
                }
            }
            else{
                self.addEquipmentServiceCall(parameters: parameters as NSDictionary)
                let userObj = Constatnts.getUserObject()
                let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber,USER_ID:userObj.customerId,Maker:txtMaker!.text!,EquipmentClassificatnId :txtClassification!.text!,Manufacture_Year:parameters["vehicleYear"],PickAndDrop:parameters["pickAndDrop"],ServiceAreaDistance:parameters["serviceAreaDistance"],MinimumServiceHours: parameters["minimumServiceHours"],Equipment_Description: parameters["equipmentDescription"],VehicleNumber: parameters["equipmentVehicleNumber"],EQUIPMENT_CLASSIFICATION:txtClassification?.text!,Model:txtModel!.text!]
                self.registerFirebaseEvents(FSP_Add_Equipment_Save, "", "", "", parameters: fireBaseParams as NSDictionary)
            }
        }
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            let picker:UIImagePickerController?=UIImagePickerController()
            picker?.delegate = self
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            self.present(picker!, animated: true, completion: nil)
        }
        else
        {
            openGallary()
        }
    }
    func openGallary()
    {
        let picker:UIImagePickerController?=UIImagePickerController()
        picker?.delegate = self
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker!, animated: true, completion: nil)
        
    }
    func navigateToGoogleLocationSearchController(){
        let selectLocationController = self.storyboard?.instantiateViewController(withIdentifier: "SelectLocationViewController") as? SelectLocationViewController
        if isFromEdit == true && equipmentLocation != nil{
            selectLocationController?.selectLocation = equipmentLocation
        }
        selectLocationController?.addressCompletionBlock = {(selectedlocation ,address,postalCode,isFromAddress,fromHomeNav) in
            if Validations.isNullString(address as NSString) == false{
                self.txtLocation?.text = address
                self.txtLocation?.resignFirstResponder()
                self.equipmentLocation = selectedlocation
                self.dismiss(animated: true, completion: nil)
                UIView.animate(withDuration: 0.1) {
                    self.view.endEditing(true)
                }
                self.view.endEditing(true)
            }
            selectLocationController?.navigationController?.popViewController(animated: true)
        }
        self.registerFirebaseEvents(PV_FSP_Fetch_Equipment_Location, "", "", "", parameters: nil)
        self.navigationController?.pushViewController(selectLocationController!, animated: true)
        /*let addressSearchViewController = GoogleSearchViewController()
        addressSearchViewController.isFromAddress = true
        addressSearchViewController.addressCompletionBlock = {(selectedlocation ,address,isFromAddress,fromHomeNav,viewBounds) in
            if Validations.isNullString(address as NSString) == false{
                self.txtLocation?.text = address
                self.txtLocation?.resignFirstResponder()
                self.equipmentLocation = selectedlocation
                self.dismiss(animated: true, completion: nil)
                UIView.animate(withDuration: 0.1) {
                    self.view.endEditing(true)
                }
                self.view.endEditing(true)
            }
        }
        let navController = UINavigationController(rootViewController: addressSearchViewController)
        navController.navigationBar.tintColor = self.navigationController?.navigationBar.tintColor
        navController.navigationBar.barTintColor = self.navigationController?.navigationBar.tintColor
        //self.present(navController, animated: true, completion: nil)
        self.present(navController, animated: true) {
        }*/
    }
    //MARK: UITextfields Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tblClassifications.isHidden = true
        tblVehicleYear.isHidden = true
        if textField == txtVehicleYear {
            tblVehicleYear.reloadData()
            tblVehicleYear.isHidden = false
            txtVehicleYear?.textAlignment = .center
            textField.resignFirstResponder()
            self.view.endEditing(true)
            IQKeyboardManager.sharedManager().resignFirstResponder()
        }
        else if textField == txtClassification{
            tblClassifications.reloadData()
            tblClassifications.isHidden = false
            txtClassification?.textAlignment = .center
            textField.resignFirstResponder()
            self.view.endEditing(true)
            IQKeyboardManager.sharedManager().resignFirstResponder()
        }
        else if textField == txtLocation{
            textField.resignFirstResponder()
            self.view.endEditing(true)
            IQKeyboardManager.sharedManager().resignFirstResponder()
            self.navigateToGoogleLocationSearchController()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        _ = textField.resignFirstResponder()
        return true
    }
    //MARK: UIActionSheet Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            if arrEquipmentImages.count < 3{
                arrEquipmentImages.add(pickedImage)
            }
            else{
                self.view.makeToast(Equipment_Images_Max_Limit_Reached)
            }
            collectionImages?.reloadData()
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: alertYesBtnAction
    /**
     YES button action of the alertView which is displayed to the user
     when already logged in other device
     */
    @objc func alertYesBtnAction(){
        if self.addEquipmentAlert != nil {
            self.addEquipmentAlert?.removeFromSuperview()
        }
        if self.unsavedChangesAlert != nil {
            self.unsavedChangesAlert?.removeFromSuperview()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func infoAlertSubmit(){
        if self.addEquipmentAlert != nil {
            self.addEquipmentAlert?.removeFromSuperview()
        }
        if self.unsavedChangesAlert != nil {
            self.unsavedChangesAlert?.removeFromSuperview()
        }
    }
    //MARK: alertNoBtnAction
    /**
     NO button action of the alertView which is displayed to the user
     when already logged in other device
     */
    @objc func alertNoBtnAction(){
        unsavedChangesAlert?.removeFromSuperview()
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
