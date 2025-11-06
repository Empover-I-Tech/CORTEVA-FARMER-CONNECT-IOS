//
//  RHRDProfileupdateViewController.swift
//  FarmerConnect
//
//  Created by Empover on 09/09/21.
//  Copyright © 2021 ABC. All rights reserved.
//



import UIKit
import Alamofire
import GoogleMaps
import GooglePlaces



class RHRDProfileupdateViewController: BaseViewController,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var selectLocation: CLLocationCoordinate2D?
    let geocoder = GMSGeocoder()
    var currentLocation : CLLocationCoordinate2D?
    var alertController = UIAlertController()
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    
    @IBOutlet weak var EveryYearBtn: UIButton!
    @IBOutlet weak var firstTimeBtn: UIButton!
    
    @IBOutlet weak var stateTextfield: UITextField!
    @IBOutlet weak var btnCloudy: UIButton!
    @IBOutlet weak var btnWell: UIButton!
    @IBOutlet weak var btnCanal: UIButton!
    @IBOutlet weak var lblLine: UILabel!
    @IBOutlet weak var imgRainy: UIImageView!
    @IBOutlet weak var imgWell: UIImageView!
    @IBOutlet weak var imgCanal: UIImageView!
    @IBOutlet weak var btnAddCrops: UIButton!
    @IBOutlet weak var updateProfileHeigthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblRainfed: UILabel!
    @IBOutlet weak var lblIrrigated: UILabel!
    @IBOutlet weak var lbl_oftenUse: UILabel!//
    @IBOutlet weak var viewSeasonCultivatedHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewIrrigationHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblSeasonsHint: UILabel!
    @IBOutlet weak var btnCompaniesView: UIButton!
    @IBOutlet weak var btnSeasonsView: UIButton!
    @IBOutlet weak var btnIrrigationView: UIButton!
    @IBOutlet weak var btnCropsView: UIButton!
    @IBOutlet weak var txtMobileRvillage: UITextField!
    @IBOutlet weak var lblMobileRvillage: UILabel!
    @IBOutlet weak var txtPincodeRemail: UITextField!
    
    @IBOutlet weak var lblEmailRpincode: UILabel!
    @IBOutlet weak var updateProfileView: UIView!
    //  @IBOutlet weak var optInView: UIView!
    var activeTextField : UITextField = UITextField()
    @IBOutlet weak var viewCompaniesCollectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewCompaniesCollection: UIView!
    @IBOutlet weak var viewCompaniesHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewCompanies: UIView!
    @IBOutlet weak var collectionViewCompaniesHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrolView: UIScrollView!
    @IBOutlet weak var tblViewCropsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tblViewCrops: UITableView!
    var isDataChanged : Bool = false
    var tblViewSelectCrops : UITableView = UITableView()
    var loginAlertView = UIView()
    @IBOutlet weak var btnOptInWhatsup: UIButton!
    var optInWhatsApp : Bool = false
    
    @IBOutlet weak var viewCropsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewCropsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewCrops: UICollectionView!
    @IBOutlet weak var viewCrops: UIView!
    @IBOutlet weak var txtTotalCropAcres: UITextField!
    @IBOutlet weak var txtPincodeField :  UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var ExceptionalCropHealthBtn: UIButton!
    @IBOutlet weak var EnhancedFloweringBtn: UIButton!
    @IBOutlet weak var QualityOfChilliBtn: UIButton!
    @IBOutlet weak var lbl_DelegateMost: UILabel!
    
    @IBOutlet weak var txtSelectCompaniesPatronized: UITextField!
    @IBOutlet weak var collectionViewCompanies: UICollectionView!
    @IBOutlet weak var viewSeasonsCultivated: UIView!
    @IBOutlet weak var viewIrrigation: UIView!
    @IBOutlet weak var collectionViewCultivatedSeasons: UICollectionView!
    var tblViewCompanies : UITableView = UITableView()
    var cropAcresAreas : NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    var selectedLocation : CLLocationCoordinate2D?
    var mobileNumberFromLoginVCStr = NSString()
    var countryFromLoginVCStr = NSString()
    var countryCodeFromLoginVCStr = NSString()
    var countryIdFromLoginVCStr = NSString()
    var isFromEditProfile : Bool?
    var arrCrops : NSMutableArray = NSMutableArray()
    var arrSelectedCrops : NSMutableArray = NSMutableArray()
    
    var arrCompanies : NSMutableArray = NSMutableArray()
    var arrSelectedCompanies : NSMutableArray = NSMutableArray()
    var arrSelectedCompanyIds : NSMutableArray = NSMutableArray()
    var isEverySelected = "isEverySelected"
    var cornValue : NSString = "0"
    var riceValue : NSString = "0"
    var cottonValue : NSString = "0"
    var musterdValue : NSString = "0"
    var milletValue : NSString = "0"
    var soyabeanValue : NSString = "0"
    var deligateValue : NSString = "0"
    var knowDelegateAbout = ""
    var companiesSelected : NSString = ""
    var irrigationsSelected : NSString = ""
    var cultivatedSeasonsSelected : NSString = ""
    var subIrrigationsSelected : NSString = ""
    var pincode : NSString = "0"
    var stateName : NSString = ""
    var districtName : NSString = ""
    var mobileNumber : NSString = ""
    var region : NSString = ""
    var villageLocation : NSString = ""
    var unsavedChangesAlert : UIView?
    var arrIrrigatedTypesSelected : NSMutableArray = NSMutableArray()
    var arrIrrigatedSubTypesSelected : NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var profileImageview: UIImageView!
    var arrIrrigations : NSMutableArray = NSMutableArray()
    var arrSelectedIrrigations : NSMutableArray = NSMutableArray()
    var arrCultivatedSeasons : NSMutableArray = NSMutableArray()
    var arrSelectedCultivatedSeasons : NSMutableArray = NSMutableArray()
    var isFromUpdate : Bool?
    @IBOutlet weak var enterCrop_textfielf: UITextField!
    @IBOutlet weak var firstNamelbl: UILabel!
    @IBOutlet weak var LastNamelbl: UILabel!
    @IBOutlet weak var emailNamelbl: UILabel!
    @IBOutlet weak var mobileNamelbl: UILabel!
    @IBOutlet weak var pincodeNamelbl: UILabel!
    @IBOutlet weak var stateNamelbl: UILabel!
    @IBOutlet weak var lblAcresPaddy: UILabel!
    var yieldOfPaddy = "No"
    var isPExalonKharifused = "No"
    var loaderView : UIView?
    var selectedDelegateMost = NSMutableArray()
    
    @IBAction func DelegateMostAction(_ sender: UIButton) {
        isDataChanged = true
        //knowDelegateAbout
        if sender.tag == 1000{
            knowDelegateAbout = "Exceptional crop health"
            if  ExceptionalCropHealthBtn.image(for: .normal) == (UIImage(named: "CheckboxEmpty")){
                ExceptionalCropHealthBtn.setImage(UIImage(named: "rhrdcheck3"), for: .normal)
            }
            else{
                ExceptionalCropHealthBtn.setImage(UIImage(named: "CheckboxEmpty"), for: .normal)
            }
            
            if selectedDelegateMost.contains("Exceptional crop health") {
                selectedDelegateMost.remove("Exceptional crop health")
            }
            else{
                selectedDelegateMost.add("Exceptional crop health")
            }
            
        }
        else if sender.tag == 1001{
            knowDelegateAbout = "Enhanced flowering and fruiting"
            
            if  EnhancedFloweringBtn.image(for: .normal) == (UIImage(named: "CheckboxEmpty")){
                EnhancedFloweringBtn.setImage(UIImage(named: "rhrdcheck3"), for: .normal)
            }
            else{
                EnhancedFloweringBtn.setImage(UIImage(named: "CheckboxEmpty"), for: .normal)
            }
            
            if selectedDelegateMost.contains("Enhanced flowering and fruiting") {
                selectedDelegateMost.remove("Enhanced flowering and fruiting")
            }
            else{
                selectedDelegateMost.add("Enhanced flowering and fruiting")
            }
        }
        else  if sender.tag == 1002{
            knowDelegateAbout = "Quality of the Chilli"
            
            if  QualityOfChilliBtn.image(for: .normal) == (UIImage(named: "CheckboxEmpty")){
                QualityOfChilliBtn.setImage(UIImage(named: "rhrdcheck3"), for: .normal)
            }
            else{
                QualityOfChilliBtn.setImage(UIImage(named: "CheckboxEmpty"), for: .normal)
            }
            
            if selectedDelegateMost.contains("Quality of the Chilli") {
                selectedDelegateMost.remove("Quality of the Chilli")
            }
            else{
                selectedDelegateMost.add("Quality of the Chilli")
            }
        }
        
        knowDelegateAbout = selectedDelegateMost.componentsJoined(by: ",")
        print(knowDelegateAbout)
        
    }
    @IBAction func cameraorGaleryAction(_ sender: Any) {
        let userObj = Constatnts.getUserObject()
        // let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,CROP:cropNameFromCropDiagnosisVC ?? ""]
        //        self.registerFirebaseEvents(CDI_Capture_Photo_Hint_OK, "", "", "", parameters: firebaseParams as NSDictionary)
        let attributedString = NSAttributedString(string: NSLocalizedString("choose_option", comment: ""), attributes: [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20),
            NSAttributedStringKey.foregroundColor : UIColor.orange
        ])
        alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alertController.setValue(attributedString, forKey: "attributedMessage")
        let sendButton = UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            print("Camera button tapped")
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.camera()
                //let userObj = Constatnts.getUserObject()
                //let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,CROP:self.cropNameFromCropDiagnosisVC ?? ""]
                //self.registerFirebaseEvents(CD_Crop_Camera, "", "", "", parameters: firebaseParams as NSDictionary)
            }
            else{
                print("not compatible")
            }
        })
        
        let  deleteButton = UIAlertAction(title: NSLocalizedString("gallery", comment: ""), style: .default, handler: { (action) -> Void in
            print("Gallery button tapped")
            self.photoLibrary()
            //let userObj = Constatnts.getUserObject()
            //let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,CROP:self.cropNameFromCropDiagnosisVC ?? ""]
            //self.registerFirebaseEvents(CD_Crop_Gallery, "", "", "", parameters: firebaseParams as NSDictionary)
        })
        let  cancelButton = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        alertController.addAction(sendButton)
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        self.navigationController!.present(alertController, animated: true, completion: nil)
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
    
    // Camera Action
    
    @IBAction func cameraAction(_ sender : UIButton) {
        self.camera()
    }
    // Gallery Button Action
    @IBAction func galleryAction(_ sender : UIButton) {
        self.photoLibrary()
    }
    //MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //print(info)
        
        
        if let image_data = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImageview.image = image_data
        }
        
        
        if Reachability.isConnectedToNetwork(){
            if let image_data = info[UIImagePickerControllerEditedImage] as? UIImage {
                profileImageview.image = image_data
                
                if let data = UIImagePNGRepresentation(image_data) as Data? {
                    let bcf = ByteCountFormatter()
                    bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
                    bcf.countStyle = .file
                    let string = bcf.string(fromByteCount: Int64(data.count))
                }
                
                let resizedImg = resized(image: image_data)
                
                if let data1 = UIImagePNGRepresentation(resizedImg!) as Data? {
                    let bcf = ByteCountFormatter()
                    bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
                    bcf.countStyle = .file
                    let string = bcf.string(fromByteCount: Int64(data1.count))
                }
                let imageData:Data = UIImagePNGRepresentation(resizedImg!)!
                let imageStr = imageData.base64EncodedString()
            }
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                dismiss(animated: false) { [self] in
                    self.profileImageview.image = image
                    
                }
            }
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: resized image
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        let userObj = Constatnts.getUserObject()
        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "RHRDProfileupdateViewController"]
        // self.registerFirebaseEvents(CEP_Capture_Photo_Cancel, "", "", "", parameters: firebaseParams as NSDictionary)
        self.dismiss(animated: true, completion: nil)
    }
    
   
    //MARK:- OFTEN USE DELEGATE
    @IBAction func oftenusedelegateAction(_ sender : UIButton){
        isDataChanged = true
        if sender.tag == 300 {
            isEverySelected = "Every Year"
            EveryYearBtn.setImage(UIImage(named: "radio"), for: .normal)
            firstTimeBtn.setImage(UIImage(named: "radioEmpty"), for: .normal)
            //radioEmpty
        }
        else  if sender.tag == 400 {
            isEverySelected = "First Time"
            EveryYearBtn.setImage(UIImage(named: "radioEmpty"), for: .normal)
            firstTimeBtn.setImage(UIImage(named: "radio"), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLeftPaddingToTextField(txtFirstName, 10)
        self.setLeftPaddingToTextField(txtMobileRvillage, 10)
        self.setLeftPaddingToTextField(txtPincodeRemail, 10)
        self.setLeftPaddingToTextField(txtLastName, 10)
        self.setLeftPaddingToTextField(enterCrop_textfielf, 10)
        self.setLeftPaddingToTextField(stateTextfield, 10)
        self.setLeftPaddingToTextField(txtPincodeField, 10)
        
        submitBtn.addTarget(self, action: #selector(submitBtn_Touch_Up_Inside), for: .touchUpInside)
        self.view.bringSubview(toFront: submitBtn)
        
        
        firstNamelbl.text = NSLocalizedString("first_name", comment: "")//
        LastNamelbl.text = NSLocalizedString("last_name", comment: "")
        pincodeNamelbl.text = NSLocalizedString("pincode", comment: "")
        stateNamelbl.text = NSLocalizedString("state", comment: "")  //
        lblAcresPaddy.text = NSLocalizedString("RHRD_How_many_Chilli_Acres", comment: "")  //
        ExceptionalCropHealthBtn.setTitle(NSLocalizedString("RHRD_ExceptionalCrop_health", comment: ""), for: .normal)
        EnhancedFloweringBtn.setTitle(NSLocalizedString("RHRD_Enhanced_Flowering", comment: ""), for: .normal)
        QualityOfChilliBtn.setTitle(NSLocalizedString("RHRD_Quality_of_the_Chilli", comment: ""), for: .normal)
        lbl_DelegateMost.text = NSLocalizedString("RHRD_What_do_know_delegate_most", comment: "")  //
        lbl_oftenUse.text = NSLocalizedString("RHRD_How_often_use_Deleagte", comment: "")
        EveryYearBtn.setTitle(NSLocalizedString("RHRD_use_Every_year", comment: ""), for: .normal)
        firstTimeBtn.setTitle(NSLocalizedString("RHRD_use_first_year", comment: ""), for: .normal)
        txtPincodeRemail.delegate = self
        isFromUpdate = true
        self.renderUpdateScreen()
    }
    
    
    @objc func addRowToTableViewToAddCrops(_ sender : UIButton){}
    func changeHiddenStatusOfCrops(isHidden : Bool){ }
    func changeHiddenStatusOfCompanies(isHidden : Bool){ }
    func changeHiddenStatusOfSeasons(isHidden : Bool){ }
    func changeHiddenStatusOfIrrigations(isHidden : Bool){ }
    
    @objc func hideOrShowCropsView(_ sender : UIButton){
        var isHidden = false
        if sender.currentImage == UIImage(named: "minus") {
            isHidden = true
        }
        else{
            isHidden = false
        }
        var size = 0
        if arrSelectedCrops.count == 0 {
            size = 52
        }
        self.view.updateConstraints()
        self.changeHiddenStatusOfCrops(isHidden: isHidden)
        self.changeHiddenStatusOfSeasons(isHidden: true)
        self.changeHiddenStatusOfCompanies(isHidden: true)
        self.changeHiddenStatusOfIrrigations(isHidden: true)
    }
    
    @objc func hideOrShowIrrigationsView(_ sender : UIButton){
        var isHidden = false
        if sender.currentImage == UIImage(named: "minus") {
            isHidden = true
        }
        else{
            isHidden = false
        }
        self.changeHiddenStatusOfIrrigations(isHidden: isHidden)
        self.changeHiddenStatusOfCrops(isHidden: true)
        self.changeHiddenStatusOfSeasons(isHidden: true)
        self.changeHiddenStatusOfCompanies(isHidden: true)
        
    }
    
    @objc func hideOrShowCompaniesView(_ sender : UIButton){
        var isHidden = false
        if sender.currentImage == UIImage(named: "minus") {
            isHidden = true
        }
        else{
            isHidden = false
        }
        self.changeHiddenStatusOfCompanies(isHidden: isHidden)
        self.changeHiddenStatusOfIrrigations(isHidden: true)
        self.changeHiddenStatusOfCrops(isHidden: true)
        self.changeHiddenStatusOfSeasons(isHidden: true)
        
    }
    
    func checkRemianingTextFieldsValidationsAndGetValuesFromTableView() -> Bool{
        
        for i in 0..<self.arrSelectedCrops.count {
            let indexPath = IndexPath(row: i, section: 0)
            if let cell: cropsTableViewCell = self.tblViewCrops.cellForRow(at: indexPath) as? cropsTableViewCell{
                
                if cell.txtCropName.text == "Corn"{
                    cornValue = cell.txtCropValue.text as NSString? ?? ""
                }else if cell.txtCropName.text == "Rice"{
                    riceValue = cell.txtCropValue.text as NSString? ?? ""
                }else if cell.txtCropName.text == "Millet"{
                    milletValue = cell.txtCropValue.text as NSString? ?? ""
                }else if cell.txtCropName.text == "Mustard"{
                    musterdValue = cell.txtCropValue.text as NSString? ?? ""
                }else if cell.txtCropName.text == "Soyabean"{
                    soyabeanValue = cell.txtCropValue.text as NSString? ?? ""
                }else if cell.txtCropName.text == "Cotton"{
                    cottonValue = cell.txtCropValue.text as NSString? ?? ""
                }else if cell.txtCropName.text == "Deligate"{
                    deligateValue = cell.txtCropValue.text as NSString? ?? ""
                }
                
                if cell.txtCropName.text == ""{
                    let selectCropMsg = NSLocalizedString("select_crop", comment: "")
                    self.view.makeToast(selectCropMsg)
                    return false
                }
                if cell.txtCropValue.text == ""{
                    self.view.makeToast(String(format: "Enter %@ value", cell.txtCropName.text ?? "Crop"))
                    return false
                }
                
                if cornValue == "0" || riceValue == "0" || milletValue == "0" || musterdValue ==  "0" || soyabeanValue == "0" || cottonValue == "0" {
                    self.view.makeToast("Crop Value Cannot Be 0")
                    return false
                    
                }
            }
        }
        
        var totalValue = cornValue.intValue + riceValue.intValue + musterdValue.intValue
        totalValue = totalValue + cottonValue.intValue + milletValue.intValue + soyabeanValue.intValue + deligateValue.intValue
        
        let totalCrops = Int(txtTotalCropAcres.text!)
        
        if totalCrops != nil {
            if Int(totalValue) > totalCrops ?? 0 {
                self.view.makeToast(Total_Crop_Acres_Sum)
                return false
            }
        }
        else if totalCrops == nil && totalValue > 0 {
            self.view.makeToast(Please_Enter_Total_Crop)
            return false
        }
        irrigationsSelected = arrIrrigatedTypesSelected.componentsJoined(by: ",") as NSString
        subIrrigationsSelected = arrIrrigatedSubTypesSelected.componentsJoined(by: ",") as NSString
        if arrSelectedCultivatedSeasons.count > 0 {
            cultivatedSeasonsSelected = arrSelectedCultivatedSeasons.componentsJoined(by: ",") as NSString
        }
        
        if arrSelectedCompanyIds.count > 0 {
            let orderedSet : NSOrderedSet = NSOrderedSet(array: arrSelectedCompanyIds as! [Any])
            let arrayWithoutDuplicates : NSArray = orderedSet.array as NSArray
            companiesSelected = arrayWithoutDuplicates.componentsJoined(by: ",") as NSString
        }
        return true
    }
    
    @objc func hideOrShowSeasonsView(_ sender : UIButton){
        var isHidden = false
        if sender.currentImage == UIImage(named: "minus") {
            isHidden = true
        }
        else{
            isHidden = false
        }
        self.changeHiddenStatusOfSeasons(isHidden: isHidden)
        self.changeHiddenStatusOfIrrigations(isHidden: true)
        self.changeHiddenStatusOfCrops(isHidden: true)
        self.changeHiddenStatusOfCompanies(isHidden: true)
        
    }
    
    // ---------------------------------//
    // MARK:- GET CURRENT LOACTION
    // ---------------------------------//
    func getUserCurrentLocation(){
        var geoLocation = ""
        if Validations.checkUserEnabledLocationServiceOrNot(viewController: self as UIViewController,showAlert: true) == true{
            if let currentLocation = LocationService.sharedInstance.currentLocation as CLLocation?{
                if let coordinates = currentLocation.coordinate as CLLocationCoordinate2D?{
                    geoLocation = String(format: "%f,%f", coordinates.latitude,coordinates.longitude)
                    self.geocoder.reverseGeocodeCoordinate(coordinates) { response, error in
                        SwiftLoader.hide()
                        if let address = response?.firstResult() {
                            DispatchQueue.main.async {
                                self.txtPincodeField.text = address.postalCode
                                // self.getVillagesBasedOnPincode()
                                self.view.layoutIfNeeded()
                                self.view.updateConstraintsIfNeeded()
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MAR:- SUBMIT BTN ACTION
    @objc func submitBtn_Touch_Up_Inside() {
        if Validations.isNullString(txtFirstName.text! as NSString) {
            self.view.makeToast(Please_Enter_First_Name)
            return
        }
        else if Validations.isNullString(txtLastName.text! as NSString) {
            self.view.makeToast(Please_Enter_Last_Name)
            return
        }
        else if enterCrop_textfielf.text == "" {
            self.view.makeToast(NSLocalizedString("RHRD_How_many_Chilli_Acres", comment: ""))
            return
        }
        if Validations.isNullString(txtMobileRvillage.text! as NSString ) || self.selectedLocation == nil || txtMobileRvillage.text == "" {
            self.view.makeToast(Select_Village_Your_Location)
            return
        }
        let currentTime = Constatnts.getCurrentMillis()
        let imgFileName = String(currentTime).replacingOccurrences(of: "-", with: "")
        let strSubmitted = String(format:"%@.jpg",imgFileName)
        let deviceID = UIDevice.current.identifierForVendor!.uuidString.replacingOccurrences(of: "-", with: "") as String
        let geoLocation = String(format: "%f,%f", self.selectedLocation?.latitude ?? "",self.selectedLocation?.longitude ?? "")
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            
            if isFromUpdate == true{
                let userObj = Constatnts.getUserObject()
                let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,]
                self.registerFirebaseEvents(PV_CEP_Update_Profile_Submit, "", "", "", parameters: firebaseParams as NSDictionary)
                self.recordScreenView("CEPProfileActivity", "RHRDProfileupdateViewController")
                
                
                let dic : NSDictionary = [
                    "cepFlag" : false, "rhrdFlag": true,
                    "countryId" : self.countryIdFromLoginVCStr,
                    "deviceId" : deviceID,
                    "emailId" :  txtPincodeRemail.text ?? "",
                    "firstName" : txtFirstName.text ?? "",
                    "geolocation" : geoLocation,
                    "lastName" : txtLastName.text,
                    "mobileNumber" : txtMobileRvillage.text ?? "",
                    "optInWhatsApp" : false,
                    "pexalonKharifSeason" : isPExalonKharifused,
                    "pincode" : txtPincodeField.text ,
                    "chillyAcres" : enterCrop_textfielf.text ?? "",
                    "stateName" : stateTextfield.text ?? "",
                    "imagePath" : strSubmitted,
                    "useDelegate": isEverySelected,
                    "knowDelegateAbout": knowDelegateAbout,
                ]
                let paramsDic = NSMutableDictionary(dictionary: dic)
                paramsDic.setValue(userObj.deviceToken as? String ?? "", forKey: "deviceToken")
                let paramsStr = Constatnts.nsobjectToJSON(paramsDic as NSDictionary)
                let params =  ["data" : paramsStr]
                print(params)
                let net = NetworkReachabilityManager(host: "www.google.com")
                if net?.isReachable == true{
                    uploadingWithMultiPartFormData(paramsStr, imgFileName: imgFileName)
                }
                
            }
            else{
                let parameters = ["mobileNumber":self.mobileNumberFromLoginVCStr, "countryId":self.countryIdFromLoginVCStr,"firstName": txtFirstName.text!,"lastName": txtLastName.text!,"pincode": txtPincodeRemail.text!,"stateName": "","districtName": "","region": "","emailId": "","deviceId": deviceID,"deviceToken": "","totalCropAcres": "","villageLocation":txtMobileRvillage.text!,"geolocation":geoLocation,"cornCropAcres":"","riceCropAcres":"","milletCropAcres":"","mustardCropAcres":"","soyabeanCropAcres": "","cottonCropAcres":"","season":"","irrigation":"","company":"","deviceType":"iOS","optInWhatsApp" : self.optInWhatsApp] as NSDictionary
                
                let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
                let params =  ["data" : paramsStr]
                print(params)
            }
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
    }
    
    //MARK:- uploadingWithMultiPartFormData UPLOAD CAPTURE IMAGE FOR
    func uploadingWithMultiPartFormData( _ str : String, imgFileName : String){
        let userObj = Constatnts.getUserObject()
        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,]
        //   self.registerFirebaseEvents(CDI_Peat_Integration_Request, "", "", "", parameters: firebaseParams as NSDictionary)
        
        //UPDATE
        //self.recordScreenView("UploadEVENT", Capture_Photo)
        
        SwiftLoader.show(animated: true)
        //let image = UIImage(named: "profile_icon.png")!
        
        let params = ["data" : str]
        //let paramsStr = Constatnts.nsobjectToJSON(params as NSDictionary)
        let data = NSKeyedArchiver.archivedData(withRootObject: params)
        
        var stringAPI = ""
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(params) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
                stringAPI = jsonString
            }
        }
        
        print(data)
        
        let currentTime = Constatnts.getCurrentMillis()
        //  let imgFileName = String(currentTime).replacingOccurrences(of: "-", with: "")
        let strSubmitted = String(format:"%@.jpg",imgFileName)
        
        let headers: HTTPHeaders = [
            "userAuthorizationToken": userObj.userAuthorizationToken! as String,
            "mobileNumber": userObj.mobileNumber! as String,
            "customerId": userObj.customerId! as String,
            "deviceId": userObj.deviceId! as String]
        
        Alamofire.upload(multipartFormData: {(multipartFormData) in
            multipartFormData.append(stringAPI.data(using: String.Encoding.utf8)!, withName: "encodedData")
            
            //  DispatchQueue.main.async {
            if let imageData = UIImageJPEGRepresentation(self.profileImageview.image ?? UIImage(), 1) {
                multipartFormData.append(imageData, withName: "multipartFile", fileName: strSubmitted, mimeType: "image/png")
            }
        }, usingThreshold: 60, to: String(format :"%@%@",BASE_URL,User_Profile_Update_Data), method: .post, headers: headers, encodingCompletion: {(encodeResult) in
            switch encodeResult {
            case .success(let upload, _, _):
                upload.validate().responseJSON { response in
                    self.loaderView?.removeFromSuperview()
                    SwiftLoader.hide()
                    
                    print(response)
                    if response.result.error == nil{
                        if let json = response.result.value{
                            print(json)
                            let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                            if responseStatusCode == STATUS_CODE_200{
                                self.registerFirebaseEvents(PV_CEP_profile_update_success, "", "", "", parameters: firebaseParams as NSDictionary)
                                if Validations.isNullString(((json as! NSDictionary).value(forKey: "response") as! NSString).replacingOccurrences(of: "\\", with: "") as NSString) == false{
                                    let respData = ((json as! NSDictionary).value(forKey: "response") as! NSString).replacingOccurrences(of: "\\", with: "")
                                    let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                                    print("decryptData :\(decryptData)")
                                    userObj.updateUserProfileData(dict: decryptData)
                                    Constatnts.setUserToUserDefaults(user: userObj)
                                    let okStr = NSLocalizedString("ok", comment: "")
                                    let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString)
                                    self.unsavedChangesAlert = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: NSLocalizedString("alert", comment: "") as NSString, message: msg ?? "", okButtonTitle:NSLocalizedString("ok", comment: "") , cancelButtonTitle: "") as? UIView
                                    self.view.addSubview(self.unsavedChangesAlert!)
                                    
                                }
                            }else if responseStatusCode == STATUS_CODE_601{
                                Constatnts.logOut()
                                if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                    print(msg)
                                    self.view.makeToast(msg as String)
                                }
                            }else {}
                        }
                    }
                    else{
                        self.registerFirebaseEvents(PV_CEP_profile_update_failure, "", "", "", parameters: firebaseParams as NSDictionary)
                        self.view.makeToast(response.result.error?.localizedDescription ?? "")
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                self.registerFirebaseEvents(PV_CEP_profile_update_failure, "", "", "", parameters: firebaseParams as NSDictionary)
                self.view.makeToast(encodingError.localizedDescription)
            }
        })
    }
    
    @objc func alertYesBtnAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func requestToGetRegister (registerParams : [String:String]){
        
        let headers : HTTPHeaders =  ["authKey" : AUTHKEY_NEWUSER , "methodName" : METHODNAME_NEWUSER ,"sharedWith" : SHAREWITH  ]
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,REGISTER_USER])
        Alamofire.request(urlString, method: .post, parameters: registerParams, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        //print("Response after decrypting data:\(decryptData)")
                        let userObj = User(dict: decryptData)
                        userObj.countryId = self.countryFromLoginVCStr
                        let date = Date()
                        let dateFormatterGet = DateFormatter()
                        dateFormatterGet.dateFormat = "yyyy-MM-dd"
                        UserDefaults.standard.set(dateFormatterGet.string(from: date), forKey: "userRegisteredDate")
                        let toOTPVC = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController
                        toOTPVC?.loggingUser = userObj
                        toOTPVC?.isFromLogin = false
                        toOTPVC?.countryCodeStr = self.countryFromLoginVCStr as String
                        self.navigationController?.pushViewController(toOTPVC!, animated: true)
                    }
                }
            }
        }
    }
    
    func disableMandatoryFieldsForUpdateProfile(_ textField: UITextField, isEnable:Bool){
        textField.isUserInteractionEnabled = isEnable
        textField.textColor = UIColor.lightGray
    }
    
    func assignDataToFields(){
        let userObj = Constatnts.getUserObject()
        enterCrop_textfielf.text = userObj.chillyAcres as String? ?? ""
        let imageUrl = URL(string: (userObj.imagePath) as? String ?? "")
        self.profileImageview.downloadedFrom(url:imageUrl ?? NSURL() as URL , placeHolder: UIImage(named:"cepProfile"))
        self.profileImageview.contentMode = .scaleToFill
        
      
        
        
        txtFirstName.text = userObj.firstName as String? ?? ""
        txtLastName.text = userObj.lastName as String? ?? ""
        txtMobileRvillage.text = userObj.mobileNumber as String? ?? ""
        self.disableMandatoryFieldsForUpdateProfile(txtMobileRvillage, isEnable: false)
        
        if userObj.knowDelegateAbout != ""{
            knowDelegateAbout = userObj.knowDelegateAbout as String? ?? ""
            selectedDelegateMost = NSMutableArray()
            
            let theString = NSString(string: knowDelegateAbout)
            let components = theString.components(separatedBy: ",")
            
            let arr : NSArray = NSArray(object: userObj.knowDelegateAbout ?? "")
            if components.count>0{
                selectedDelegateMost.addObjects(from: components)
            }
            if components.contains("Exceptional crop health") || arr.contains("Exceptional Crop Health"){
                ExceptionalCropHealthBtn.setImage(UIImage(named: "rhrdcheck3"), for: .normal)
            }
            if components.contains("Enhanced flowering and fruiting"){
                EnhancedFloweringBtn.setImage(UIImage(named: "rhrdcheck3"), for: .normal)
            }
            if components.contains("Quality of the Chilli"){
                QualityOfChilliBtn.setImage(UIImage(named: "rhrdcheck3"), for: .normal)
            }
            
        }
        
        
        if (userObj.useDelegate) == "Every Year" || (userObj.useDelegate) == "Every year" {
            isEverySelected = "Every Year"
            EveryYearBtn.setImage(UIImage(named: "radio"), for: .normal)
            firstTimeBtn.setImage(UIImage(named: "radioEmpty"), for: .normal)
            //radioEmpty
        }
        else  {
            isEverySelected = "First Time"
            EveryYearBtn.setImage(UIImage(named: "radioEmpty"), for: .normal)
            firstTimeBtn.setImage(UIImage(named: "radio"), for: .normal)
            
        }
        
        txtPincodeRemail.text = userObj.emailId as String? ?? ""
        self.countryIdFromLoginVCStr = userObj.countryId!
        // self.txtTotalCropAcres.text = userObj.totalCropAcress as String? ?? ""
        
        cornValue  = userObj.corn as NSString? ?? "0"
        riceValue  = userObj.rice as NSString? ?? "0"
        milletValue = userObj.millet as NSString? ?? "0"
        musterdValue = userObj.mustard as NSString? ?? "0"
        soyabeanValue = userObj.soyabean as NSString? ?? "0"
        cottonValue = userObj.cotton as NSString? ?? "0"
        pincode = userObj.pincode as NSString? ?? "0"
        stateName = userObj.stateName as NSString? ?? "0"
        stateTextfield.text  = stateName as String
        districtName = userObj.districtName as NSString? ?? "0"
        region = userObj.regionName as NSString? ?? "0"
        villageLocation = userObj.villageLocation as NSString? ?? ""
        
        if Validations.isNullString(userObj.geolocation ?? "") == false{
            if let geoArray = userObj.geolocation?.components(separatedBy: ",") as NSArray?{
                if geoArray.count > 1{
                    let latitude = geoArray.object(at: 0) as? NSString
                    let longitude = geoArray.object(at: 1) as? NSString
                    self.selectedLocation = CLLocationCoordinate2D(latitude: (latitude?.doubleValue)!, longitude: (longitude?.doubleValue)!)
                }
            }
        }
        
        if Validations.isNullString(userObj.companiesId ?? "") == false{
            // arrSelectedCompanyIds
            if let companyArray = userObj.companiesId?.components(separatedBy: ",") as NSArray?{
                if companyArray.count > 1{
                    self.arrSelectedCompanyIds.addObjects(from: companyArray as! [Any])
                }
            }
        }
        
        
    }
    func reloadIrrigationsData(){ }
    
    func getCropsMasterDataFromServer(){
        SwiftLoader.show(animated: true)
        let userObj = Constatnts.getUserObject()
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_CROPS_MASTERDATA])
        Alamofire.request(urlString, method: .post, parameters: ["data" : ""], encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        //print("Response after decrypting data:\(decryptData)")
                        let countryListArray = decryptData.value(forKey: "cropsImageList") as! NSArray
                        self.arrCrops.removeAllObjects()
                        for i in 0 ..< countryListArray.count{
                            if let companyDict = countryListArray.object(at: i) as? NSDictionary{
                                let cellData = CropsData(dict: companyDict )
                                if cellData.name != "Deligate"{
                                    self.arrCrops.add(cellData)
                                }
                            }
                        }
                        self.collectionViewCrops.reloadData()
                    }
                }
            }
        }
    }
    
    func renderUpdateScreen(){
        txtMobileRvillage?.rightView = nil
        txtPincodeRemail.keyboardType = .emailAddress
        scrolView.isScrollEnabled = true
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        self.submitBtn.setTitle(NSLocalizedString("RHRD_UPDATE", comment: ""), for: .normal)
        emailNamelbl.text = NSLocalizedString("email_optional", comment: "")
        mobileNamelbl.text = NSLocalizedString("mobile_no", comment: "")
        
        self.lblTitle?.text = NSLocalizedString("rhrd_Enroll_and_get_luckydraw", comment: "")
        self.assignDataToFields()
        self.requestToGetUserProfileMasterData()
        if arrSelectedCrops.count == 0 {
            arrSelectedCrops.add("")
            self.reloadCropsData()
        }
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RHRDProfileupdateViewController.contentViewTapGestureRecognizer(_:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        
    }
    
    @objc func btnCanalClicked(){ }
    @objc func btnWellClicked(){}
    @objc func btnCloudyClicked(){}
    
    @objc func contentViewTapGestureRecognizer(_ tapGesture:UITapGestureRecognizer) {
        view.endEditing(true)
        tblViewCompanies.isHidden = true
        tblViewSelectCrops.isHidden = true
    }
    
    func requestToGetUserProfileMasterData(){
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,User_Profile_Master_Data])
        Alamofire.request(urlString, method: .post, parameters: ["data" : ""], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    print("Response :\(json)")
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
                        
                        let sortedArray = self.arrCompanies.sorted{($0 as! CellData).name < ($1 as! CellData).name}
                        self.arrCompanies.removeAllObjects()
                        self.arrCompanies.addObjects(from: sortedArray)
                        
                    }
                }
            }
        }
    }
    func loadCompaniesDataToDropDown(){ }
    
    @objc func btnIrrigatedClicked(){ }
    
    @objc func btnRainfedClicked(){ }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
        getUserCurrentLocation()
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        let userObj = Constatnts.getUserObject()
        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,]
        self.registerFirebaseEvents(PV_CEP_Update_Profile, "", "", "", parameters: firebaseParams as NSDictionary)
        self.recordScreenView("CEPProfileActivity", "RHRDProfileupdateViewController")
        
    }
    override func backButtonClick(_ sender: UIButton) {
        if isDataChanged {
            let alertMsgStr = NSLocalizedString("on_back_press_error", comment: "")
            let alertTitleStr = NSLocalizedString("alert", comment: "")
            self.loginAlertView = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: alertTitleStr as NSString, message: alertMsgStr as NSString, okButtonTitle: YES, cancelButtonTitle: NO) as! UIView
            self.view.addSubview(self.loginAlertView)
            
        }else{
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    @objc func alertNoBtnAction(){
        loginAlertView.removeFromSuperview()
    }
    
    func setLeftPaddingToTextField(_ textField: UITextField, _ padding:CGFloat){
        textField.leftViewMode = .always
        textField.delegate = self
        textField.contentVerticalAlignment = .center
        textField.setLeftPaddingPoints(padding)
    }
    
    func navigateToGoogleLocationSearchController(){
        let selectLocationController = self.storyboard?.instantiateViewController(withIdentifier: "SelectLocationViewController") as? SelectLocationViewController
        if self.selectedLocation != nil{
            selectLocationController?.selectLocation = self.selectedLocation
        }
        selectLocationController?.addressCompletionBlock = {(selectedlocation ,address,postalCode,isFromAddress,fromHomeNav) in
            if Validations.isNullString(address as NSString) == false{
                self.txtMobileRvillage?.text = address
                self.txtMobileRvillage?.resignFirstResponder()
                self.selectedLocation = selectedlocation
                self.txtPincodeRemail.text = postalCode
                self.sendPincodeToServer(str: postalCode)
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
    
    //MARK: hideUnhideDropDownTblView
    func hideUnhideDropDownTblView(tblView : UITableView, hideUnhide : Bool){
        tblView.isHidden = hideUnhide
    }
    
    //MARK: Text field delegate methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.isDataChanged = true
        
        if textField == txtMobileRvillage {
            self.navigateToGoogleLocationSearchController()
            self.view.endEditing(true)
            return false
        }
        else if textField == txtSelectCompaniesPatronized {
            self.view.endEditing(true)
            
            
            tblViewCompanies.delegate = self
            tblViewCompanies.dataSource = self
            tblViewCompanies.reloadData()
            self.hideUnhideDropDownTblView(tblView: tblViewCompanies, hideUnhide: false)
            
            return false
        }else if textField == txtTotalCropAcres{
            return true
            
        }
        else if textField == txtFirstName{
            return true
            
        }else if textField == txtLastName {
            return true
        }
        else if textField == txtPincodeRemail{
            return true
        }
        else if textField.tag == 101{
            activeTextField = UITextField()
            activeTextField = textField
            tblViewSelectCrops = UITableView()
            
            self.loadDropDownTableView(tableViewDataSource: self, tableViewDelegate: self, tableview: tblViewSelectCrops, textField: textField)
            tblViewSelectCrops.delegate = self
            tblViewSelectCrops.dataSource = self
            self.hideUnhideDropDownTblView(tblView: tblViewSelectCrops, hideUnhide: false)
            tblViewSelectCrops.reloadData()
            return false
        }else{
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString: String? = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        if textField == txtPincodeRemail && isFromUpdate! == false{
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
                self.sendPincodeToServer(str: newString!)
                
                return true
            }
            return (string == filtered)
        }
        
       
        
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtPincodeRemail {
            if isFromUpdate! == false{
                if txtPincodeRemail.text!.count < 6{
                    self.view.makeToast(Pincode_Characters_Limit)
                }
            }
        }else if textField == txtTotalCropAcres{
            
        }else if textField == txtFirstName{
            
        }else if textField == txtLastName{
            
        }else if textField == txtMobileRvillage{
            
        }
        else {
            if arrSelectedCrops.count > 0 {
                let cropName = arrSelectedCrops.object(at: textField.tag) as? String
                if cropName == "Corn"{
                    cornValue = textField.text as NSString? ?? ""
                }else if cropName == "Rice"{
                    riceValue = textField.text as NSString? ?? ""
                }else if cropName == "Millet"{
                    milletValue = textField.text as NSString? ?? ""
                }else if cropName == "Mustard"{
                    musterdValue = textField.text as NSString? ?? ""
                }else if cropName == "Soyabean"{
                    soyabeanValue = textField.text as NSString? ?? ""
                }else if cropName == "Cotton"{
                    cottonValue = textField.text as NSString? ?? ""
                }else if cropName == "Deligate"{
                    deligateValue = textField.text as NSString? ?? ""
                }
            }
        }
    }
    
    
    
    func sendPincodeToServer(str: String){
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                self.view.endEditing(true)
            })
            let parameters = ["pincode":str, "countryId":self.countryIdFromLoginVCStr] as NSDictionary
            let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
            let params =  ["data" : paramsStr]
            print(params)
            self.requestToGetLocationData(params: params as [String:String])
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
    }
    
    func requestToGetLocationData (params : [String:String]){
        SwiftLoader.show(animated: true)
        
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_LOCATION_FROM_PINCODE])
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        self.submitBtn.isUserInteractionEnabled = true
                        let defaults = UserDefaults.standard
                        defaults.set(decryptData, forKey: "PincodeData")
                        defaults.synchronize()
                        
                    }
                    else if responseStatusCode == STATUS_CODE_124{
                        if let message = (json as! NSDictionary).value(forKey: "message") as? NSString{
                            self.view.makeToast(message as String)
                        }
                    }
                    else{
                        if let message = (json as! NSDictionary).value(forKey: "message") as? NSString{
                            self.view.makeToast(message as String)
                        }
                    }
                }
            }
        }
    }
    
    
    
    override func viewDidLayoutSubviews() {
        viewHeightConstraint.constant = 1200
        self.scrolView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 1200)
    }
    
    func checkCollectionViewCompaniesSize(){ }
    
    // -------------------------------------------------------------------//
    //MARK:- NOT REQUIRED METHODS
    //MARK: collectionView datasource and delegate methods
    // -------------------------------------------------------------------//
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewCrops{
            return arrCrops.count
        }else if collectionView == collectionViewCultivatedSeasons {
            return arrCultivatedSeasons.count
        }
        else if collectionView == collectionViewCompanies {
            return arrSelectedCompanies.count
        }
        else{
            return arrIrrigations.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewCrops{
            let cell = self.collectionViewCrops.dequeueReusableCell(withReuseIdentifier: "cropsCell", for: indexPath)
            
            let dashboardImg = cell.contentView.viewWithTag(101) as! UIImageView
            
            let titleLbl = cell.contentView.viewWithTag(102) as! UILabel
            
            let cellData = arrCrops.object(at: indexPath.row) as? CropsData
            print(cellData?.name)
            titleLbl.text = cellData?.name
            
            let imageUrl = URL(string: (cellData?.image)!)!
            
            dashboardImg.downloadedFrom(url:imageUrl , placeHolder: UIImage(named:"image_placeholder.png"))
            dashboardImg.contentMode = .scaleToFill
            if arrSelectedCrops.contains(cellData?.name){
                dashboardImg.borderColor = App_Theme_Blue_Color
                dashboardImg.cornerRadius = 4.0
                dashboardImg.borderWidth = 1.0
            }else{
                dashboardImg.borderColor = UIColor(red: 230.0/255.0, green: 238.0/255.0, blue: 252.0/255.0, alpha: 1.0)
                dashboardImg.cornerRadius = 4.0
                dashboardImg.borderWidth = 1.0
            }
            
            return cell
        }
        else if collectionView == collectionViewCultivatedSeasons{        //cultivationsCell
            
            let cell = self.collectionViewCultivatedSeasons.dequeueReusableCell(withReuseIdentifier: "cultivationsCell", for: indexPath)
            
            let dashboardImg = cell.contentView.viewWithTag(101) as! UIImageView
            
            dashboardImg.image = UIImage(named:arrCultivatedSeasons.object(at: indexPath.row) as! String)
            
            let titleLbl = cell.contentView.viewWithTag(102) as! UILabel
            titleLbl.text = arrCultivatedSeasons.object(at: indexPath.row) as? String
            
            
            if arrSelectedCultivatedSeasons.contains(arrCultivatedSeasons.object(at: indexPath.row)){
                dashboardImg.borderColor = App_Theme_Blue_Color
                dashboardImg.cornerRadius = 4.0
                dashboardImg.borderWidth = 1.0
            }else{
                dashboardImg.borderColor = UIColor(red: 230.0/255.0, green: 238.0/255.0, blue: 252.0/255.0, alpha: 1.0)
                dashboardImg.cornerRadius = 4.0
                dashboardImg.borderWidth = 1.0
            }
            
            return cell
            
        }
        else {
            let cell = self.collectionViewCompanies.dequeueReusableCell(withReuseIdentifier: "companiesCell", for: indexPath)
            
            let titleLbl = cell.contentView.viewWithTag(102) as! UILabel
            let cellData = arrSelectedCompanies.object(at: indexPath.row) as? CellData
            if cellData == nil {
                titleLbl.text = arrSelectedCompanies.object(at: indexPath.row) as! String
                
            }else{
                print(cellData?.name)
                titleLbl.text = cellData?.name
            }
            
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collectionViewCompanies {
            return CGSize(width: collectionViewCompanies.frame.size.width/3-15, height: 45);
        }else{
            return CGSize(width: 70, height: 70);
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == collectionViewCompanies {
            return UIEdgeInsetsMake(0, 0, 0, 0)
        }else{
            return UIEdgeInsetsMake(5, 5, 5, 5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == collectionViewCompanies {
            return 2
        }else{
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == collectionViewCompanies {
            return 2
        }else{
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.isDataChanged = true
        if collectionView == collectionViewCompanies {
            //            arrCompanies.add(arrSelectedCompanies.object(at: indexPath.item))
            arrSelectedCompanies.removeObject(at: indexPath.item)
            arrSelectedCompanyIds.removeObject(at: indexPath.item)
            
            self.reloadCompaniesData()
        }
        
        else if collectionView == collectionViewCultivatedSeasons{
            if arrSelectedCultivatedSeasons.contains(arrCultivatedSeasons.object(at: indexPath.row)) {
                arrSelectedCultivatedSeasons.remove(arrCultivatedSeasons.object(at: indexPath.row))
            }else{
                arrSelectedCultivatedSeasons.add(arrCultivatedSeasons.object(at: indexPath.row))
            }
            
            self.collectionViewCultivatedSeasons.reloadData()
        }
    }
    func reloadCompaniesData(){
        self.checkCollectionViewCompaniesSize()
        collectionViewCompanies.reloadData()
        tblViewCompanies.reloadData()
    }
    
    func reloadCropsData(){
        var size = 0
        if arrSelectedCrops.count == 0 {
            size = 52
        }
    }
    
    //MARK: Tableview data source and delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblViewCompanies {
            return arrCompanies.count
        }else if tableView == tblViewSelectCrops{
            return arrCrops.count
        }
        else{
            return arrSelectedCrops.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblViewCompanies{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13.0)
            
            let cellData = arrCompanies.object(at: indexPath.row) as? CellData
            cell.textLabel?.text = cellData?.name
            if arrSelectedCompanies.contains(cellData?.name){
                arrSelectedCompanyIds.add(cellData?.dataId)
            }
            return cell
        }
        else if tableView == tblViewSelectCrops {
            let cellIdentifier = "Cell"
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13.0)
            
            let cellData = arrCrops.object(at: indexPath.row) as? CropsData
            print(cellData?.name)
            cell.textLabel?.text = cellData?.name
            
            return cell
        }
        else{
            
            let cellIdentifier = "crops"
            let cropsCell = self.tblViewCrops.dequeueReusableCell(withIdentifier: cellIdentifier) as! cropsTableViewCell?
            cropsCell?.btnRemoveRow.isHidden = false
            cropsCell?.btnRemoveRow.tag = indexPath.row
            //   cropsCell?.btnRemoveRow.addTarget(self, action: #selector(removeRowFromCropsCell(_:)), for: .touchUpInside)
            
            let downBtn = UIButton(type: .custom)
            downBtn.frame = CGRect(x: -20, y: 0, width: 15, height: 15)
            downBtn.setImage(UIImage(named:"DropDown-1"), for:.normal)
            
            cropsCell?.txtCropName.text = arrSelectedCrops.object(at: indexPath.row) as! NSString as String
            if cropsCell?.txtCropName.text == "Corn"{
                cropsCell?.txtCropValue.text = cornValue as String?
            }else if cropsCell?.txtCropName.text == "Rice" {
                cropsCell?.txtCropValue.text = riceValue as String?
            }else if cropsCell?.txtCropName.text == "Millet"{
                cropsCell?.txtCropValue.text = milletValue as String?
                
            }else if cropsCell?.txtCropName.text == "Mustard"{
                cropsCell?.txtCropValue.text = musterdValue as String?
                
            }else if cropsCell?.txtCropName.text == "Cotton"{
                cropsCell?.txtCropValue.text = cottonValue as String?
            }
            else if cropsCell?.txtCropName.text == "Soyabean" {
                cropsCell?.txtCropValue.text = soyabeanValue as String?
                
            }else if cropsCell?.txtCropName.text == "Deligate"{
                cropsCell?.txtCropValue.text = deligateValue as String?
            }
            else{
                cropsCell?.txtCropValue.text = ""
            }
            cropsCell?.txtCropName?.rightView = downBtn
            cropsCell?.txtCropName?.rightViewMode = .always
            cropsCell?.txtCropName?.contentMode = .center
            cropsCell?.txtCropName?.delegate = self
            cropsCell?.txtCropValue.tag = indexPath.row
            cropsCell?.txtCropValue?.delegate = self
            tableView.separatorColor = .clear
            return cropsCell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.isDataChanged = true
        if tableView == tblViewCompanies {
            self.hideUnhideDropDownTblView(tblView: tblViewCompanies, hideUnhide: true)
            
            let cellData = arrCompanies.object(at: indexPath.row) as? CellData
            if arrSelectedCompanies.contains(cellData?.name){
                self.view.makeToast("Already selected")
            }
            else{
                arrSelectedCompanies.add(cellData?.name)
                if !arrSelectedCompanyIds.contains(cellData?.dataId){
                    arrSelectedCompanyIds.add(cellData?.dataId)
                }
                self.checkCollectionViewCompaniesSize()
            }
        }
        
        else if tableView == tblViewSelectCrops{
            //            cell.textLabel?.text = arrCrops.object(at: indexPath.row) as? String
            let cellIdentifier = "crops"
            let cellData = arrCrops.object(at: indexPath.row) as? CropsData
            
            if arrSelectedCrops.contains(cellData?.name){
                self.view.makeToast("Already selected")
                return
            }
            arrSelectedCrops.remove(activeTextField.text)
            activeTextField.text = cellData?.name
            arrSelectedCrops.add(cellData?.name)
            self.hideUnhideDropDownTblView(tblView: tblViewSelectCrops, hideUnhide: true)
            collectionViewCrops.reloadData()
        }
        
    }
    // -------------------------------------------------------------------// // -------------------------------------------------------------------//
}


