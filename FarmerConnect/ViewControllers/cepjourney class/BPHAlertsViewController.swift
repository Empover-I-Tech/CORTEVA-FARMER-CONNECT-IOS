//
//  BPHAlertsViewController.swift
//  FarmerConnect
//
//  Created by EMPOVER-049 on 08/08/21.
//  Copyright © 2021 ABC. All rights reserved.
//

import UIKit
import Alamofire

extension UIView {
    func dropShadow1(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
class BPHAlertsViewController: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate , UITextFieldDelegate {
    
    @IBOutlet weak var lbl_severityTitle: UILabel!
    @IBOutlet weak var lbl_severityLevel: UILabel!
    @IBOutlet weak var lbl_sgallery: UILabel!
    @IBOutlet weak var lbl_camera: UILabel!

    
    let geocoder = GMSGeocoder()
    @IBOutlet weak var img_choosePest: UIImageView!
    @IBOutlet weak var lbl_captureImg: UILabel!
    @IBOutlet weak var lbl_pestRDiesase: UILabel!
    @IBOutlet weak var View_pestRdiease: UIView!
    @IBOutlet weak var view_pincode: UIView!
    @IBOutlet weak var view_village: UIView!
    @IBOutlet weak var view_othervillage: UIView!
    @IBOutlet weak var view_surveyNo: UIView!
    @IBOutlet weak var view_getCoordinates: UIView!
    @IBOutlet weak var view_captureFields: UIView!
    @IBOutlet weak var view_FieldCeintist: UIView!
    @IBOutlet weak var view_hybrid: UIView!
    @IBOutlet weak var view_plantAge: UIView!
    @IBOutlet weak var view_brand: UIView!
    @IBOutlet weak var view_otherBrand: UIView!
    @IBOutlet weak var view_areaHint: UIView!
    @IBOutlet weak var otherHybrids: UIView!
    @IBOutlet weak var lbl_village: UILabel!
    @IBOutlet weak var lbl_pincode: UILabel!
    @IBOutlet weak var lbl_hybrid: UILabel!
    @IBOutlet weak var lbl_hintbottom: UILabel!
    @IBOutlet weak var lbl_otherBrand: UILabel!
    @IBOutlet weak var lbl_brand: UILabel!
    @IBOutlet weak var lbl_plantAge: UILabel!
    @IBOutlet weak var lbl_otherVillage: UILabel!
    @IBOutlet weak var lbl_currentGeoCordibates: UILabel!
    @IBOutlet weak var lbl_captureFieldArea: UILabel!
    @IBOutlet weak var lbl_fieldScientist: UILabel!
    @IBOutlet weak var lbl_survey_no: UILabel!
    @IBOutlet weak var lbl_otherHybrid: UILabel!
    @IBOutlet weak var lbl_totalAreHInt: UILabel!
    @IBOutlet var lblImagesRedRound : UILabel!
    @IBOutlet weak var txt_otherHybrid: UITextField!
    @IBOutlet weak var txt_pest_diease: UITextField!
    @IBOutlet weak var txt_pincode: UITextField!
    @IBOutlet weak var txt_otherVillage: UITextField!
    @IBOutlet weak var txt_village: UITextField!
    @IBOutlet weak var txt_otherBrand: UITextField!
    @IBOutlet weak var txt_Brand: UITextField!
    @IBOutlet weak var txt_hybrid: UITextField!
    @IBOutlet weak var txt_scientist: UITextField!
    @IBOutlet weak var txt_coordinates: UITextField!
    @IBOutlet weak var txt_plantAge: UITextField!
    @IBOutlet weak var txt_getareaNEW: UITextField!
    @IBOutlet weak var txt_getarea: UIButton!
    @IBOutlet weak var txt_surveyNo: UITextField!
    @IBOutlet weak var submit_btn: UIButton!
    @IBOutlet weak var scrollVw: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var cameraBtn: UIButton!{
        didSet{
            cameraBtn.setImage(UIImage(named: "camera_blue"), for: .normal)
        }
    }
    var pestRdiseaseArry = NSMutableArray()
    var ID_pestRdisesa = 0
    var ID_villageCode = 0
    var ID_brand = 0
    var ID_hybrid = 0

    var villageMaster = NSMutableArray()
    var brandMasterArray = NSMutableArray()
    var hybridMasterArray = NSMutableArray()
    var masterDic = NSMutableDictionary()
    var submitlatlongValues = ""
    var arrayAreaCoordinates = NSMutableArray()
    var submitRecordId = ""
    var cortevaNewsDocumentDirectory = NSString()
    var filePathSavedDB = ""
    var imageURltoServer = ""
    var arrayImagesOnly : NSMutableArray = []
    var boolImagePicked = false
    var isDatamodifed = false
    var  finalImageSave = UIImage()
    var submitSverityString = ""
    var arrImages : NSMutableArray = NSMutableArray()
    var imageLimit = false
    var activeTxtField : UITextField?
    var arrayDiseases = NSMutableArray()
    var arrayPlantAge = NSMutableArray()
    var arraySeverity = NSMutableArray()
    var alertView_Bg: UIView = UIView()
    var validationAlert : UIView?
    var alertController = UIAlertController()
    var tblViewViilage = UITableView()
    var tblViewDieases = UITableView()
    var tblViewPlantAge = UITableView()
    var lastImage = false
    var healthyImageView : UIImageView?
    var mediumImageView : UIImageView?
    var highImageView : UIImageView?
    var lowImageView : UIImageView?
    var isFromSubmit = false
    var lowSeverityBtn: ISRadioButton?
    var mediumSeverityBtn: ISRadioButton?
    var highSeverityBtn: ISRadioButton?
    var healthySeverityBtn: ISRadioButton?
    var txtFldChangesAlert : UIView?
    var  isFromAreaValidation = false
    var severityImageArray = NSMutableArray()
    var selectedTag = -1
    var isDataModified = false
    var villageArray = NSMutableArray()
    @IBOutlet weak var chooseOptionlbl: UILabel!
    @IBOutlet weak var severityCollectionView: UICollectionView!
    @IBOutlet weak var severityWIndow: UIView!
    var isOtherVillage = false
    var unsavedChangesAlert : UIView?
    
    @IBAction func galleryAction(_ sender: Any) {
        
        
        if submitSverityString == "" {
            self.view.makeToast("Please select any type of severity")
            return
        }
        
        self.photoLibrary()
    }
    
    
    //MARK:- VIEW WILL APPEAR
    @IBAction func closeAction(_ sender: Any) {
        severityWIndow.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.topView?.isHidden = false
        self.homeButton?.isHidden = true
        getUserCurrentLocation()
        lblImagesRedRound.isHidden = false
        self.lblTitle?.text = NSLocalizedString("cep_BPH_Alert", comment: "")
        self.lbl_pestRDiesase.text = NSLocalizedString("cep_pestDiesease", comment: "")
        self.lbl_currentGeoCordibates?.text = NSLocalizedString("cep_pest_current_geocoordinates", comment: "")
        let strMsg = String(format:"%@%@", NSLocalizedString("CEP_please_captureImageinfected", comment: ""),"")
        let attributedString = NSMutableAttributedString(string:strMsg)
        let attrs = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 19.0), NSAttributedStringKey.foregroundColor : UIColor .red]
        let gString = NSMutableAttributedString(string:"*", attributes:attrs)
        attributedString.append(gString)
        self.lbl_captureImg?.attributedText = attributedString
        
        let lbl_pestRDiesaseString = NSMutableAttributedString(string:self.lbl_pestRDiesase.text ?? "")
        lbl_pestRDiesaseString.append(gString)
        self.lbl_pestRDiesase.attributedText = lbl_pestRDiesaseString
        self.lbl_plantAge.text = NSLocalizedString("cep_plantAge", comment: "")
        let lbl_PincodeString = NSMutableAttributedString(string:self.lbl_plantAge.text ?? "")
        lbl_PincodeString.append(gString)
        self.lbl_plantAge.attributedText = lbl_PincodeString
        
        let lbl_plantAgetring = NSMutableAttributedString(string:self.lbl_pincode.text ?? "")
        lbl_plantAgetring.append(gString)
        self.lbl_pincode.attributedText = lbl_plantAgetring
        
        
        
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        submit_btn.setTitle(NSLocalizedString("submit", comment: "").uppercased(), for: .normal)
        self.lbl_village.text = NSLocalizedString("village_cep", comment: "")
      
        self.lbl_severityTitle.text = NSLocalizedString("severity_title", comment: "")
        self.lbl_severityLevel.text = NSLocalizedString("severity_level", comment: "")
        self.lbl_sgallery.text = NSLocalizedString("gallery", comment: "")
        self.lbl_camera.text = NSLocalizedString("camera", comment: "")
        self.chooseOptionlbl.text = NSLocalizedString("choose_option", comment: "")
        
        
        
    }
    
    @IBAction func eyeSeverityAction(_ sender: UIButton) {
        
        
        let buttonPosition = sender.convert(CGPoint(x:0,y:0), to: self.severityCollectionView)
        let indexPath = self.severityCollectionView!.indexPathForItem(at: buttonPosition)
        if indexPath != nil {
            showPopUpToSelectSeverity(tag: indexPath?.row ?? 0)
        }
        
    }
    
    @IBAction func severtitySelectionAction(_ sender: Any) {
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadInitialdata()
        localizedStringsSet()
        view_areaHint.isHidden = true
        view_othervillage.isHidden = true
        view_otherBrand.isHidden = true
        otherHybrids.isHidden = true
        severityWIndow.isHidden = true
        let userObj = Constatnts.getUserObject()
        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,]
        self.registerFirebaseEvents(PV_CEP_BPH_Alert, "", "", "", parameters: firebaseParams as NSDictionary)
        
        //UPDATE
        self.recordScreenView("FawSightingActivity", "BPHAlertsViewController")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func mapAction(_ sender: Any) {
    }
    
    
    
    
    //MASTER DOWNLAOD
    
    func parseJsonData(_ data : NSDictionary){
        
        let userObj = Constatnts.getUserObject()
        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,]
        self.registerFirebaseEvents(PV_CEP_master_success, "", "", "", parameters: firebaseParams as NSDictionary)
        //Disease Array
        let diseaseArray = data.object(forKey: "diseaseMaster") as? NSArray ?? []
        pestRdiseaseArry = NSMutableArray(array: diseaseArray)
        
        
        for _ in 0..<diseaseArray.count {
            let dic = diseaseArray.object(at: 0) as? NSDictionary ?? [:]
            txt_pest_diease.text = dic.object(forKey: "name")  as? String ?? ""
            ID_pestRdisesa = dic.object(forKey: "id")  as? Int ?? 0
        }
        
        //Villagelist
        var villageArray1 = data.object(forKey: "villagesList") as? NSArray ?? []
        villageMaster = NSMutableArray(array: villageArray1)
        villageArray  = NSMutableArray(array: villageArray1)
        
        for _ in 0..<villageArray1.count {
            let dic = villageArray1.object(at: 0) as? NSDictionary ?? [:]
            txt_village.text = dic.value(forKey: "name") as? String
            //dic.object(forKey: "name")  as? String ?? ""
            txt_pincode.text = dic.value(forKey: "pincode") as? String
            ID_villageCode = dic.object(forKey: "villageCodeId")  as? Int ?? 0
        }
        
        if(self.txt_pincode.text?.count == 6)
        {
            self.villageArray.removeAllObjects()
            let predicate = NSPredicate(format: "pincode = %@",self.txt_pincode.text ?? "" )
            let outputFilteredArr = (self.villageMaster).filtered(using: predicate) as NSArray
            if outputFilteredArr.count>0{
                //self.villageArray.add(outputFilteredArr)
                villageArray  = NSMutableArray(array: outputFilteredArr)
            }
            
            if self.villageArray.count == 0{
                self.txt_village.text = ""
                let dic = [    "id" : "0",
                               "name" : "Others",
                               "pincode" : self.txt_pincode.text ?? "",
                               "villageCodeId" : "0",
                ]
                self.villageArray.add(dic)
               
            }
        }
        
        //BRAND
        /*    let brandArray = data.object(forKey: "brandMaster") as? NSArray ?? []
         brandMasterArray = NSMutableArray(array: brandArray)
         
         
         for _ in 0..<brandArray.count {
         let dic = brandArray.object(at: 0) as? NSDictionary ?? [:]
         txt_Brand.text = dic.object(forKey: "name")  as? String ?? ""
         ID_brand = dic.object(forKey: "id")  as? Int ?? 0
         }
         
         //HYBRID
         let hybridArray = data.object(forKey: "hybridMaster") as? NSArray ?? []
         hybridMasterArray = NSMutableArray(array: hybridArray)
         
         
         for _ in 0..<hybridArray.count {
         let dic = hybridArray.object(at: 0) as? NSDictionary ?? [:]
         txt_hybrid.text = dic.object(forKey: "name")  as? String ?? ""
         ID_hybrid = dic.object(forKey: "id")  as? Int ?? 0
         }*/
        
        
        let severityArray = data.object(forKey: "fawSeverityImagesMaster") as? NSArray ?? []
        severityImageArray = NSMutableArray()
        
        for i in 0 ..< severityArray.count {
            let dic : NSDictionary = severityArray.object(at: i) as? NSDictionary ?? [:]
            
            if dic.value(forKey: "diseaseName") as? String ?? "" == "BPH"{
                //if dic.value(forKey: "priority") as? String ?? "" == "BPH"{
                severityImageArray.add(dic)

            }
        }
                
        if severityImageArray.count>0 {
            severityCollectionView.reloadData()
        }
        for _ in 0..<severityArray.count {
            let dic = severityArray.object(at: 0) as? NSDictionary ?? [:]
            txt_hybrid.text = dic.object(forKey: "name")  as? String ?? ""
            ID_hybrid = dic.object(forKey: "id")  as? Int ?? 0
        }
    }
    
    
    //LOAD MASTER PEST DATA
    func loadInitialdata(){
        let userObj = Constatnts.getUserObject()
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? NSString
        let dict: NSDictionary = [
            "mobileNumber": userObj.mobileNumber! as String,
            "deviceType": "iOS",
            "loginId": userObj.customerId! as String,
            "versionNo": version ?? "",
            "lastUpdatedTime": ""
        ]
        cepJourneySingletonClass.getPestDieaseMaster(dictionary: dict ) { (status, responseDictionary, statusMessage) in
            SwiftLoader.hide()
            if status == true{
                print(responseDictionary)
                let dic = responseDictionary?.value(forKey: "data") as? NSDictionary ?? [:]
                self.parseJsonData(dic)
            }else{
                let userObj = Constatnts.getUserObject()
                let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,]
                self.registerFirebaseEvents(PV_CEP_request_failure, "", "", "", parameters: firebaseParams as NSDictionary)
                self.view.makeToast(statusMessage as String? ?? "")
            }
        }
    }
    
    @IBAction func cameraActionWindow(_ sender: Any) {
        
        if submitSverityString != ""{
            self.camera()
        }else{
            self.view.makeToast("Please Select Severity level to capture Picture")
        }
    }
    
    
    override func backButtonClick(_ sender: UIButton) {
        if self.isDataModified == false{
           
          
                self.unsavedChangesAlert = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: NSLocalizedString("alert", comment: "") as NSString, message: String(format: NSLocalizedString("unsaved_changes_alert", comment: "")) as NSString, okButtonTitle:NSLocalizedString("yes", comment: "") , cancelButtonTitle: NSLocalizedString("no", comment: "")) as? UIView
                self.view.addSubview(self.unsavedChangesAlert!)
            
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    //CAMERA ACTION
    @IBAction func cameraAction(_ sender: Any) {
        if arrImages.count>24{
            imageLimit = true
            showValidationAlertViewWithMessage("You have crossed your image upload limit(25), please submit and do the image capturing again. ")
            
        }else{
            if severityImageArray.count > 0{
            severityWIndow.isHidden = false
            }
        }
    }
    
    
    func showValidationAlertViewWithMessage(_ message: String?){
        if validationAlert != nil {
            validationAlert?.removeFromSuperview()
            validationAlert = nil
        }
        validationAlert = CustomAlert.alertInfoPopUpView(self, frame: self.view.frame, title: "", message: message as NSString? ?? "" as NSString, buttonTitle: "Ok", hideClose: true) as? UIView
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.window?.addSubview(validationAlert!)
    }
    
    
    
    //Image capture
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
    @IBAction func okBtn_Touch_Up_Inside(_ sender: Any) {
        let attributedString = NSAttributedString(string: NSLocalizedString("choose_option", comment: ""), attributes: [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20),
            NSAttributedStringKey.foregroundColor : UIColor.orange
        ])
        alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alertController.setValue(attributedString, forKey: "attributedMessage")
        let sendButton = UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            //print("Camera button tapped")
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.camera()
            }
            else{
                // print("not compatible")
            }
        })
        
        let  deleteButton =  UIAlertAction(title: NSLocalizedString("gallery", comment: ""), style: .default, handler: { (action) -> Void in
            self.photoLibrary()
        })
        let  cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(sendButton)
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    
    
    //    // --------------------------------------------------//
    //    // MARK:-SHOW MULTIPLE IMAGE CAPTURE POP UP
    //    // --------------------------------------------------//
    //    func showPopUpToSelectSeverity(){
    //        let Height:CGFloat = self.view.frame.height/1.8
    //        let width :CGFloat = self.view.frame.width - 10
    //        let posX :CGFloat = 20
    //        let TopTitleHeight = CGFloat(40)
    //        let posXbtn : CGFloat = 5
    //
    //        alertView_Bg = UIView (frame: CGRect(x: 0,y: 0 ,width: self.view.frame.size.width,height: self.view.frame.size.height))
    //        alertView_Bg.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
    //        self.view.addSubview(alertView_Bg)
    //
    //        let alertView: UIView = UIView (frame: CGRect(x: posX,y: 50  ,width: width + 6,height: 350))
    //        alertView.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
    //        alertView.layer.cornerRadius = 10.0
    //        alertView_Bg.addSubview(alertView)
    //
    //        //top view for title
    //        let topView: UIView = UIView (frame: CGRect(x: 0,y: 0 ,width: alertView.frame.width,height: TopTitleHeight ))
    //        topView.backgroundColor = App_Theme_Green_Color
    //        topView.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 10.0, borderColor: UIColor.lightGray, borderWidth: 1)
    //        alertView.addSubview(topView)
    //
    //        //title on top view
    //        let lblHeading : UILabel = UILabel (frame: CGRect(x: 0,y: 4,width:alertView.frame.width,height: TopTitleHeight - 10))
    //        lblHeading.text = "  Severity"
    //        lblHeading.textColor = UIColor.white
    //
    //        lblHeading.textAlignment = NSTextAlignment.left
    //        lblHeading.font = UIFont.boldSystemFont(ofSize: 18.0)
    //        topView.addSubview(lblHeading)
    //
    //        //close button on top view
    //        let closeView : UIButton = UIButton (frame: CGRect(x: alertView.frame.size.width-40,y: 6,width: 30,height: 30))
    //        closeView.backgroundColor = UIColor.clear
    //        closeView.setImage(UIImage(named: "DeleteRed.png"), for: UIControl.State())
    //        closeView.addTarget(self, action: #selector(BPHAlertsViewController.closeView(_:)), for: .touchUpInside)
    //        topView.addSubview(closeView)
    //        alertView.addSubview(topView)
    //
    //        lowSeverityBtn = ISRadioButton(frame: CGRect(x: posXbtn, y: 45, width: alertView.frame.size.width/2 - 35, height: 50))
    //        lowSeverityBtn?.setTitle("Low", for: .normal)
    //        lowSeverityBtn?.setTitleColor(.black, for:.normal)
    //        lowSeverityBtn?.tag = 11
    //        lowSeverityBtn?.addTarget(self, action: #selector(severityButtonClick(_:)), for: .touchUpInside)
    //
    //        alertView.addSubview(lowSeverityBtn ?? ISRadioButton())
    //
    //        lowImageView  = UIImageView(frame: CGRect(x: lowSeverityBtn!.frame.minX + lowSeverityBtn!.frame.size.width - 45 , y: 45, width: 60, height: 60))
    //        lowImageView?.image = UIImage(named: "Low")
    //
    //        alertView.addSubview(lowImageView ?? UIImageView())
    //
    //
    //        mediumSeverityBtn = ISRadioButton(frame: CGRect(x: lowSeverityBtn!.frame.minX + lowSeverityBtn!.frame.size.width + 20, y: 45, width: alertView.frame.size.width/2 - 20, height: 50))
    //        mediumSeverityBtn?.setTitle("Medium", for: .normal)
    //        mediumSeverityBtn?.setTitleColor(.black, for:.normal)
    //        mediumSeverityBtn?.addTarget(self, action: #selector(severityButtonClick(_:)), for: .touchUpInside)
    //        mediumSeverityBtn?.tag = 22
    //        alertView.addSubview(mediumSeverityBtn ?? ISRadioButton())
    //
    //
    //        mediumImageView  = UIImageView(frame: CGRect(x: mediumSeverityBtn!.frame.minX + mediumSeverityBtn!.frame.size.width - 40 , y: 45, width: 60, height: 60))
    //        mediumImageView?.image = UIImage(named: "Medium")
    //        alertView.addSubview(mediumImageView ?? UIImageView())
    //
    //        highSeverityBtn = ISRadioButton(frame: CGRect(x: posXbtn, y: mediumSeverityBtn!.frame.minY + mediumSeverityBtn!.frame.size.height + 35, width: alertView.frame.size.width/2 - 35, height: 50))
    //
    //        highSeverityBtn?.setTitle("High", for: .normal)
    //
    //
    //        highSeverityBtn?.setTitleColor(.black, for:.normal)
    //        highSeverityBtn?.tag = 33
    //        highSeverityBtn?.addTarget(self, action: #selector(severityButtonClick(_:)), for: .touchUpInside)
    //
    //        alertView.addSubview(highSeverityBtn ?? ISRadioButton())
    //
    //        highImageView = UIImageView(frame: CGRect(x: highSeverityBtn!.frame.minX + highSeverityBtn!.frame.size.width - 45 , y: mediumSeverityBtn!.frame.minY + mediumSeverityBtn!.frame.size.height + 35, width: 60, height: 60))
    //        highImageView?.image = UIImage(named: "High")
    //        alertView.addSubview(highImageView ?? UIImageView())
    //
    //        healthySeverityBtn = ISRadioButton(frame: CGRect(x: highSeverityBtn!.frame.minX + highSeverityBtn!.frame.size.width + 20, y: mediumSeverityBtn!.frame.minY + mediumSeverityBtn!.frame.size.height + 35, width: alertView.frame.size.width/2 - 20, height: 50))
    //
    //        healthySeverityBtn?.setTitle("Healthy", for: .normal)
    //        healthySeverityBtn?.setTitleColor(.black, for:.normal)
    //        healthySeverityBtn?.tag = 44
    //        healthySeverityBtn?.addTarget(self, action: #selector(severityButtonClick(_:)), for: .touchUpInside)
    //        alertView.addSubview(healthySeverityBtn ?? ISRadioButton())
    //
    //        healthyImageView = UIImageView(frame: CGRect(x: healthySeverityBtn!.frame.minX + healthySeverityBtn!.frame.size.width - 40 , y: mediumSeverityBtn!.frame.minY + mediumSeverityBtn!.frame.size.height + 35, width: 60, height: 60))
    //        healthyImageView?.image = UIImage(named: "Healthy")
    //        alertView.addSubview(healthyImageView ?? UIImageView())
    //
    //        alertView.bringSubview(toFront: lowSeverityBtn ?? ISRadioButton())
    //        alertView.bringSubview(toFront: mediumSeverityBtn ?? ISRadioButton())
    //        alertView.bringSubview(toFront: highSeverityBtn ?? ISRadioButton())
    //        alertView.bringSubview(toFront: healthySeverityBtn ?? ISRadioButton())
    //
    //        lowSeverityBtn?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
    //
    //        highSeverityBtn?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
    //        mediumSeverityBtn?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
    //        healthySeverityBtn?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
    //
    //        let lblChoose : UILabel = UILabel (frame: CGRect(x: 0,y: healthySeverityBtn!.frame.minY + healthySeverityBtn!.frame.size.height + 35 ,width:alertView.frame.width,height: TopTitleHeight - 10))
    //        lblChoose.text = NSLocalizedString("choose_option", comment: "")
    //        lblChoose.textColor = .black
    //        lblChoose.textAlignment = NSTextAlignment.left
    //        lblChoose.font = UIFont.boldSystemFont(ofSize: 18.0)
    //        alertView.addSubview(lblChoose)
    //
    //        let btnCameraBgView : UIView =  UIView (frame: CGRect(x: 10,y: lblChoose.frame.minY + lblChoose.frame.size.height + 15 ,width:  alertView.frame.size.width/2 - 15 ,height: 70))
    //        btnCameraBgView.dropShadow1()
    //        btnCameraBgView.backgroundColor = .white
    //        btnCameraBgView.layer.cornerRadius = 10.0
    //        alertView.addSubview(btnCameraBgView)
    //
    //        let btnCamera : UIButton = UIButton (frame: CGRect(x: btnCameraBgView.frame.size.width/2 - 30,y: 5 ,width:60,height: 60))
    //        btnCamera.setImage(UIImage(named: "cdi_camera"), for: .normal)
    //        btnCamera.addTarget(self, action: #selector(self.openCameraToTakePhoto(_:)), for: .touchUpInside)
    //        btnCameraBgView.addSubview(btnCamera)
    //
    //        let btnGalleryBgView : UIView =  UIView (frame: CGRect(x: btnCameraBgView.frame.maxX + 5,y: btnCameraBgView.frame.minY ,width:  alertView.frame.size.width/2 - 15 ,height: 70))
    //        btnGalleryBgView.backgroundColor = .white
    //        btnGalleryBgView.dropShadow1()
    //        btnGalleryBgView.layer.cornerRadius = 10.0
    //        alertView.addSubview(btnGalleryBgView)
    //
    //        let btnGallery : UIButton = UIButton (frame: CGRect(x:btnGalleryBgView.frame.size.width/2 - 30,y: 5 ,width:60,height: 60))
    //        btnGallery.setImage(UIImage(named: "cdi_gallery"), for: .normal)
    //        btnGallery.addTarget(self, action: #selector(self.openGalleryAndUploadPhoto(_:)), for: .touchUpInside)
    //        btnGalleryBgView.addSubview(btnGallery)
    //    }
    
    func showPopUpToSelectSeverity(tag : Int){
        let Height:CGFloat = self.view.frame.height/1.8
        let width :CGFloat = self.view.frame.width - 30
        let posX :CGFloat = 20
        let TopTitleHeight = CGFloat(40)
        let posXbtn : CGFloat = 5
        let dic : NSDictionary = severityImageArray.object(at:tag) as? NSDictionary ?? [:]
        alertView_Bg = UIView (frame: CGRect(x: 0,y: 40 ,width: self.view.frame.size.width,height: self.view.frame.size.height))
        alertView_Bg.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        self.view.addSubview(alertView_Bg)
        
        let alertView: UIView = UIView (frame: CGRect(x: posX,y: 50  ,width: width + 6,height: 450))
        alertView.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
        alertView.layer.cornerRadius = 10.0
        alertView_Bg.addSubview(alertView)
        
        //top view for title
        let topView: UIView = UIView (frame: CGRect(x: 0,y: 0 ,width: alertView.frame.width,height: TopTitleHeight ))
        topView.backgroundColor = App_Theme_Blue_Color
        topView.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 10.0, borderColor: UIColor.lightGray, borderWidth: 1)
        alertView.addSubview(topView)
        
        //title on top view
        let lblHeading : UILabel = UILabel (frame: CGRect(x: 0,y: 4,width:alertView.frame.width,height: TopTitleHeight - 10))
        lblHeading.text =  dic.object(forKey: "priority") as? String ?? ""
        lblHeading.textColor = UIColor.white
        
        lblHeading.textAlignment = NSTextAlignment.center
        lblHeading.font = UIFont.boldSystemFont(ofSize: 18.0)
        topView.addSubview(lblHeading)
        
        //close button on top view
        let closeView : UIButton = UIButton (frame: CGRect(x: alertView.frame.size.width-40,y: 6,width: 30,height: 30))
        closeView.backgroundColor = UIColor.clear
        closeView.setImage(UIImage(named: "DeleteRed.png"), for: UIControl.State())
        closeView.addTarget(self, action: #selector(BPHAlertsViewController.closeView(_:)), for: .touchUpInside)
        topView.addSubview(closeView)
//        alertView.addSubview(topView)
        
        
        
        lowImageView  = UIImageView(frame: CGRect(x:0 , y: 45, width: width , height: 100))
        lowImageView?.image = UIImage(named: "Low")
        
        alertView.addSubview(lowImageView ?? UIImageView())
        
        var url1: URL = NSURL() as URL
        let url = URL(string: dic.object(forKey: "fawImageUrl") as? String ?? "") ?? url1
        lowImageView?.downloadedFrom(url:url , placeHolder: UIImage(named:"image_placeholder.png"))
        
        let lbldescription : UILabel = UILabel (frame: CGRect(x: 10,y: lowImageView?.frame.maxY ?? 0,width:alertView.frame.width - 20,height: 120))
        lbldescription.text = dic.object(forKey: "description") as? String ?? ""
        lbldescription.textColor = UIColor.black
        lbldescription.numberOfLines = 0
        lbldescription.textAlignment = NSTextAlignment.left
        // lbldescription.font = UIFont.boldSystemFont(ofSize: 12.0)
        alertView.addSubview(lbldescription)
        
        //close button on top view
        let okView : UIButton = UIButton (frame: CGRect(x: 10,y: alertView.frame.height - 56,width: alertView.frame.width - 20,height: 44))
        okView.backgroundColor = UIColor.blue
        okView.setTitle("OK", for: .normal)
        okView.isUserInteractionEnabled = true
        okView.setTitleColor(.white, for: .normal)
        okView.addTarget(self, action: #selector(BPHAlertsViewController.closeView(_:)), for: .touchUpInside)
        alertView.addSubview(okView)
       // alertView.addSubview(topView)
        self.view.bringSubview(toFront: okView)
        
        
    }
    
    
    
    //UPLOAD TO SERVER
    @IBAction func severityButtonClick(_ sender: UIButton){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        let imagePreviewController = mainStoryboard.instantiateViewController(withIdentifier: "CropDiagnosisImageViewController") as? CropDiagnosisImageViewController
        self.view.endEditing(true)
        if(sender.tag == 11)
        {
            imagePreviewController?.CDImage = lowImageView?.image
            submitSverityString = "Low"
            lowSeverityBtn?.isSelected = true
            mediumSeverityBtn?.isSelected = false
            highSeverityBtn?.isSelected = false
            healthySeverityBtn?.isSelected = false
            
        }
        else  if(sender.tag == 22)
        {
            imagePreviewController?.CDImage = mediumImageView?.image
            submitSverityString = "Medium"
            lowSeverityBtn?.isSelected = false
            mediumSeverityBtn?.isSelected = true
            highSeverityBtn?.isSelected = false
            healthySeverityBtn?.isSelected = false
            
        }
        else if(sender.tag == 33)
        {
            imagePreviewController?.CDImage = highImageView?.image
            submitSverityString = "High"
            lowSeverityBtn?.isSelected = false
            mediumSeverityBtn?.isSelected = false
            highSeverityBtn?.isSelected = true
            healthySeverityBtn?.isSelected = false
            
        }
        else if(sender.tag == 44)
        {
            imagePreviewController?.CDImage = healthyImageView?.image
            submitSverityString = "Healthy"
            
            lowSeverityBtn?.isSelected = false
            mediumSeverityBtn?.isSelected = false
            highSeverityBtn?.isSelected = false
            healthySeverityBtn?.isSelected = true
            
        }
        self.present(imagePreviewController!, animated: true, completion: nil)
    }
    
    
    @objc func openCameraToTakePhoto(_ sender: UIButton){
        
        if submitSverityString == "" {
            self.view.makeToast("Please select any type of severity")
            return
        }
        alertView_Bg.removeFromSuperview()
        self.camera()
        
    }
    
    @objc func closeView(_ sender: UIButton) {
        alertView_Bg.removeFromSuperview()
    }
    
    func convertIntoJSONString(arrayObject: [Any]) -> String? {
        
        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: arrayObject, options: [])
            if  let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                return jsonString as String
            }
            
        } catch let error as NSError {
            print("Array convertIntoJSON - \(error.description)")
        }
        return nil
    }
    
    @objc func openGalleryAndUploadPhoto(_ sender: UIButton){
        
        if submitSverityString == "" {
            self.view.makeToast("Please select any type of severity")
            return
        }
        alertView_Bg.removeFromSuperview()
        self.photoLibrary()
    }
    
    func SubmitData(){
        if validations() == true{
            
            let userObj = Constatnts.getUserObject()
            let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,]
            
            //UPDATE
            self.recordScreenView("BPHAlert", "BPHAlertsViewController")
            
            SwiftLoader.show(animated: true)
            //let image = UIImage(named: "profile_icon.png")!
            
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! NSString
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            let  submittedDateImage = dateFormatter.string(from: Date())
            //    let loginDecodedData = UserDefaults.standard.value(forKey: "LoginDecodedData") as! NSDictionary
            let dateFormatterDPR: DateFormatter = DateFormatter()
            dateFormatterDPR.dateFormat = "yy-MM-dd HH:mm:ss"
            let newDateStr = dateFormatterDPR.string(from: Date())
            
            let currentTime = Constatnts.getCurrentMillis()
            let imgFileName = String(currentTime).replacingOccurrences(of: "-", with: "")
            var drpfileName = String(newDateStr).replacingOccurrences(of: "-", with: "")
            drpfileName = String(drpfileName).replacingOccurrences(of: ":", with: "")
            drpfileName = String(drpfileName).replacingOccurrences(of: " ", with: "")
            drpfileName = String(drpfileName).replacingOccurrences(of: ".", with: "")
            let  reportedId = String(format : "%@_DPR%@",userObj.deviceId! as String,drpfileName)
            
            let headers : HTTPHeaders = [
                "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                "mobileNumber": userObj.mobileNumber! as String,
                "customerId": userObj.customerId! as String,
                "deviceId": userObj.deviceId! as String]
            
            var ImmgJsonString = ""
            if arrImages.count>0{
                ImmgJsonString = (self.convertIntoJSONString(arrayObject : arrImages as? NSMutableArray as! [Any] ?? [] ) as NSString? ?? "[]" as NSString) as String
            }
            
            let dicSubLoop =  [
                "capturedAreaOption": "",
                "diseaseId": ID_pestRdisesa,
                "diseaseName": txt_pest_diease.text,
                "fieldBoundryArea": 0,
                "fieldScientist": "",
                "id": 1,
                "imgsAndSeveritiesJSon": ImmgJsonString,
                "isSync": 1,
                "latlongValues": txt_coordinates.text ?? "",
                "mdrCustomerId": userObj.customerId! as String,
                "mdrMobileNumer": userObj.mobileNumber! as String,
                "otherVillage": txt_otherVillage.text ?? "",
                "phoneManufacturer": "",
                "phoneModel": "",
                "phoneProduct": "",
                "pincode": txt_pincode.text ?? "",
                "plantAge": txt_plantAge.text ?? "",
                "reportedId": reportedId,
                "serverIds": 0,
                "submittedDate": submittedDateImage,
                "surveyNo": "",
                "villageCodeId": ID_villageCode,
                "villageId": ID_villageCode,
                "villageName": "Others"
            ] as [String : Any]
            
            
            let arry = NSMutableArray()
            arry.add(dicSubLoop)
            
            let dic : [String : Any] = [
                "deviceId": userObj.deviceId! as String,
                "deviceType": "iOS",
                "fawSightingList": arry,
                "mobileNumber": userObj.mobileNumber! as String,
                "versionNo": version
            ] as? [String : Any] ?? [:]
            //  }
            
            print(dic)
            
            let urlString:String = String(format: "%@%@", arguments: [BASE_URL,CEP_PEST_SUBMITDATA])
            
            let paramsStr1 = Constatnts.nsobjectToJSON(dic as NSDictionary)
            //        let encryptDestURLStr = Constatnts.encrptInputString(paramStr: String(format: "%@%@", Base_URL_Emp_Java,FAW_SUBMIT_DATA_CAll_v2) as NSString)
            //
            //
            let params =  ["data": paramsStr1]
            print("params %@",params)
            
            
            
            var imageDic = NSMutableArray()
            
            Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON{ (response) in
                print(response)
                if let json = response.result.value {
                    let responseDic = json as? NSDictionary
                    SwiftLoader.hide()
                    
                    
                    let responseStatusCode = responseDic?.value(forKey: "statusCode") as? String
                    if responseStatusCode == "200"{
                        
                        self.registerFirebaseEvents(PV_CEP_profile_update_success, "", "", "", parameters: firebaseParams as NSDictionary)
                        let respData = ((json as! NSDictionary).value(forKey: JAVA_RESPONSE_DATA_KEY) as! NSString).replacingOccurrences(of: "\\", with: "")
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        
                        var outputDict1 = NSArray()
                        
                        outputDict1 = decryptData.object(forKey: "dataUploadResponse") as? NSArray ?? NSArray()
                        
                        /*ServerResponseID*/
                        
                        if outputDict1.count > 0{
                            // print("ImagesMaster :%@",outputDict1.object(at: 0))
                            for i in 0..<outputDict1.count{
                                //SAVE Image TO Local DB
                                var localImageDict  = NSDictionary()
                                localImageDict = outputDict1.object(at: i) as! NSDictionary //as? NSDictionary ?? NSDictionary
                                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                                
                                var serverIDS = localImageDict.value(forKey: "serverIds") as? String ?? ""
                                if let joneId = (Validations.checkKeyNotAvail(localImageDict, key: "serverIds") as? NSInteger){
                                    serverIDS = NSString(format: "%d", joneId) as String
                                }
                                //serverIds
                                
                                var imageUrls = localImageDict.value(forKey: "imageUrls") as? String ?? "" //imageUrls
                                if let joneId = (Validations.checkKeyNotAvail(localImageDict, key: "imageUrls") as? NSInteger){
                                    imageUrls = NSString(format: "%ld", joneId) as String
                                }
                                
                                let arrImagesUrls = imageUrls.components(separatedBy: ",")
                                
                                for i in 0...arrImagesUrls.count - 1 {
                                    let dictSAve : NSDictionary  = ["serverID": serverIDS,"imageUrlPath":arrImagesUrls[i] ,"id" : arrImagesUrls[i]] as  NSDictionary
                                    print(dictSAve)
                                    imageDic.add(dictSAve)
                                    
                                }
                            }
                            self.getImagesFromDB(array : imageDic)
                        }
                        //
                        else{
                            //completionHandler(false,NSDictionary(),decryptData.value(forKey: JAVA_RESPONSE_MESSAGE_KEY) as? String ?? "")
                        }
                    }
                    else{
                        self.registerFirebaseEvents(PV_CEP_profile_update_failure, "", "", "", parameters: firebaseParams as NSDictionary)
                        
                    }
                }
                
            }
        }
    }
    
        
    
    //MARK:- SUBMIT DATA ACTION
    @IBAction func submitACtion(_ sender: Any) {
        if validations() == true{
        isFromSubmit = true
        self.unsavedChangesAlert = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: NSLocalizedString("alert", comment: "") as NSString, message: String(format: NSLocalizedString("You_want_to_submit?", comment: "")) as NSString, okButtonTitle:NSLocalizedString("yes", comment: "") , cancelButtonTitle: NSLocalizedString("no", comment: "")) as? UIView
        self.view.addSubview(self.unsavedChangesAlert!)
        }
       
    }
    
    
    // ------------------------------------ //
    //MARK: getImageFromDocumentsDirectory
    // ------------------------------------ //
    func getImageFromDocumentsDirectory(string : String) -> UIImage{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let cropDiseaseDocumentsDirectory = appDelegate.getNewsFolderPath() as NSString
        let imgFilePath = String(format: "%@/%@.jpg", cropDiseaseDocumentsDirectory,string)
        print("imgFilePath :\(imgFilePath)")
        let fileExists: Bool = FileManager.default.fileExists(atPath: imgFilePath as String)
        if fileExists == true {
            let retrivedImg = UIImage(contentsOfFile: imgFilePath)
            //print("retrived Image: \(retrivedImg ?? UIImage())")
            if retrivedImg != nil{
                return retrivedImg ?? UIImage()
            }
        }
        return UIImage()
    }
    
    // ------------------------------------ //
    //MARK:- GET IMAGES TO UPLOAD FROM DB
    // ------------------------------------ //
    func getImagesFromDB(array : NSMutableArray)//imgId: String, serverId : String
    {
        
        
        if (arrImages.count>0)
        {
            for i in 0..<arrImages.count{
                let arrayImagesdetailsDetails  =  array.object(at: i) as? NSDictionary ?? [:]
                let serverId = arrayImagesdetailsDetails.object(forKey: "serverID") as? String ?? ""
                let imageId = arrayImagesdetailsDetails.object(forKey: "id") as? String ?? ""
                let severity = arrayImagesdetailsDetails.object(forKey: "serverID") as? String ?? ""
                // let severity = arrayImagesdetailsDetails?.severity
                let image = self.getImageFromDocumentsDirectory(string: ((imageId )) as! String )
                
                if(serverId != "" && imageId != "" ){
                    if i == arrImages.count - 1{
                        lastImage = true
                    }
                    
                    self.uploadingWithMultiPartFormData(imgLocal: image, serverID: serverId as String? ?? "", imagId: imageId as String? ?? "", severity : severity as String? ?? "", imgCapture: "")
                }
            }
        }
    }
    
    // ------------------------------------ //
    //MARK : uploadingWithMultiPartFormData
    // ------------------------------------ //
    func uploadingWithMultiPartFormData(imgLocal : UIImage, serverID : String , imagId : String, severity : String , imgCapture : String){
        let imageFFilename = String(format: "%@.jpg",imagId)
        SwiftLoader.show(animated: true)
        let userObj = Constatnts.getUserObject()
        let authToken = userObj.userAuthorizationToken! as String
        //  let loginDecodedData = UserDefaults.standard.value(forKey: "LoginDecodedData") as! NSDictionary
        let headers: HTTPHeaders = [ "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                     "mobileNumber": userObj.mobileNumber! as String,
                                     "customerId": userObj.customerId! as String,
                                     "deviceId": userObj.deviceId! as String]
        // define parameters
        let parameters = [
            "serverId": serverID,
            "mobileNumber":userObj.mobileNumber! as String,
            "imagePath" : imagId,
        ] as NSDictionary
        print("parameters : %@",parameters)
        
        let paramsStr1 = Constatnts.nsobjectToJSON(parameters)
        //print(paramsStr1)
        
        Alamofire.upload(multipartFormData: {(multipartFormData) in
            // import image to request
            if let imageData = UIImageJPEGRepresentation(imgLocal, 1) {
                multipartFormData.append(imageData, withName: "pestImage", fileName: imageFFilename, mimeType: "image/png")
            }
            
            multipartFormData.append(serverID.data(using: String.Encoding.utf8)!, withName: "serverId")
            multipartFormData.append((userObj.mobileNumber! as String).data(using: String.Encoding.utf8)!, withName: "mobileNumber")
            // multipartFormData.append(severity.data(using: String.Encoding.utf8)!, withName: "severity")
            multipartFormData.append(imagId.data(using: String.Encoding.utf8)!, withName: "imagePath")
        }, usingThreshold: 60, to: String(format :"%@%@",BASE_URL,CEP_PEST_UPLOADIMAGE), method: .post, headers: headers, encodingCompletion: {(encodeResult) in
            switch encodeResult {
            case .success(let upload, _, _):
                upload.validate().responseJSON { response in
                    SwiftLoader.hide()
                    print(response)
                    
                    if response.result.error == nil{
                        
                        if let json = response.result.value{
                            print(json)
                            let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                            
                            if responseStatusCode == "200"{
                                self.removeLocalImageFromDocumentsDirectory(imgName: imagId)
                                if self.lastImage == true {
                                    self.lastImage = false
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    appDelegate.window?.makeToast("Data Submitted Successfully")
                                    self.navigationController?.popViewController(animated: true)
                                }
                                if Validations.isNullString(((json as! NSDictionary).value(forKey: "response") as? NSString)?.replacingOccurrences(of: "\\", with: "") as NSString? ?? "") == false{
                                    let respData = ((json as! NSDictionary).value(forKey: "response") as! NSString).replacingOccurrences(of: "\\", with: "")
                                    let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                                    print("decryptData :\(decryptData)")
                                    // self.deleteParticularRowWithImageFileNameFromFAWImageEntity(imgFileName: imagId)
                                    
                                }
                            }
                            else{
                                print((json as! NSDictionary).value(forKey: "message") as? String)
                                return
                            }
                        }
                    }
                    else{
                        print((response.result.error?.localizedDescription))
                        return
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    
    // ------------------------------------------ //
    // MARK: removeLocalImageFromDocumentsDirectory
    // ------------------------------------------ //
    func removeLocalImageFromDocumentsDirectory(imgName: String?){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let imageDocumentsDirectory = appDelegate.getNewsFolderPath() as NSString
        let imgFilePath = String(format: "%@/%@.jpg", imageDocumentsDirectory,imgName!)
        let fileExists: Bool = FileManager.default.fileExists(atPath: imgFilePath as String)
        if fileExists == true{
            let fileManager = FileManager.default
            do {
                try fileManager.removeItem(atPath: imgFilePath as String)
            }
            catch let error as NSError {
                print(error.debugDescription)
            }
        }
    }
    
    
    //MARK:- Localization
    func localizedStringsSet(){
        self.lbl_village.text = NSLocalizedString("village_cep", comment: "")
        self.lbl_pincode.text = NSLocalizedString("pincode", comment: "")
        self.lbl_hybrid.text = NSLocalizedString("hybrid", comment: "")
        self.lbl_hintbottom.text = NSLocalizedString("cep_pestHint", comment: "")
        self.lbl_otherBrand.text = NSLocalizedString("cep_BPH_other", comment: "")
        self.lbl_brand.text = NSLocalizedString("cep_brand_BPH", comment: "")
        self.lbl_otherVillage.text = NSLocalizedString("cep_otherVillage", comment: "")
        self.lbl_currentGeoCordibates.text = NSLocalizedString("cep_pest_current_geocoordinates", comment: "")
        self.lbl_captureFieldArea.text = NSLocalizedString("cep_pest_captureField", comment: "")
        self.lbl_fieldScientist.text = NSLocalizedString("cep_Field_sceintist", comment: "")
        self.lbl_survey_no.text = NSLocalizedString("cep_BPH_SurveyNo", comment: "")
        self.lbl_otherBrand.text = NSLocalizedString("cep_BPH_Alert_other_hybrid", comment: "")
        
        
        self.setLeftPaddingToTextField(txt_pest_diease, 10)
        self.setLeftPaddingToTextField(txt_pincode, 10)
        self.setLeftPaddingToTextField(txt_plantAge, 10)
        
        self.setLeftPaddingToTextField(txt_village, 10)
        self.setLeftPaddingToTextField(txt_otherVillage, 10)
        self.setLeftPaddingToTextField(txt_Brand, 10)
        self.setLeftPaddingToTextField(txt_otherBrand, 10)
        self.setLeftPaddingToTextField(txt_hybrid, 10)
        
        self.setLeftPaddingToTextField(txt_surveyNo, 10)
        self.setLeftPaddingToTextField(txt_scientist, 10)
        self.setLeftPaddingToTextField(txt_getareaNEW, 10)
        self.setLeftPaddingToTextField(txt_coordinates, 10)
        self.setLeftPaddingToTextField(txt_otherBrand, 10)
        
        self.loadDropDownTableView(tableViewDataSource: self, tableViewDelegate: self, tableview: tblViewViilage, textField: txt_village)
        tblViewViilage.dataSource = self
        tblViewViilage.delegate = self
        
        self.loadDropDownTableView(tableViewDataSource: self, tableViewDelegate: self, tableview: tblViewDieases, textField: txt_pest_diease)
        tblViewDieases.dataSource = self
        tblViewDieases.delegate = self
        
        
        
    }
    
    func setLeftPaddingToTextField(_ textField: UITextField, _ padding:CGFloat){
        textField.leftViewMode = .always
        textField.delegate = self
        textField.contentVerticalAlignment = .center
        textField.setLeftPaddingPoints(padding)
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
                    submitlatlongValues = geoLocation
                    txt_coordinates.text = submitlatlongValues
                    
                    self.geocoder.reverseGeocodeCoordinate(coordinates) { response, error in
                        SwiftLoader.hide()
                        if let address = response?.firstResult() {
                            DispatchQueue.main.async {
                                self.txt_pincode.text = address.postalCode
                                // self.getVillagesBasedOnPincode()
                                
                                if(self.txt_pincode.text?.count == 6)
                                {
                                    self.villageArray.removeAllObjects()
                                    let predicate = NSPredicate(format: "pincode = %@",self.txt_pincode.text ?? "" )
                                    let outputFilteredArr = (self.villageMaster).filtered(using: predicate) as NSArray
                                    if outputFilteredArr.count>0{
                                        //self.villageArray.add(outputFilteredArr)
                                        self.villageArray  = NSMutableArray(array: outputFilteredArr)
                                    }
                                    
                                    if self.villageArray.count == 0{
                                        self.txt_village.text = ""
                                        let dic = [    "id" : "0",
                                                       "name" : "Others",
                                                       "pincode" : self.txt_pincode.text ?? "",
                                                       "villageCodeId" : "0",
                                        ]
                                        self.villageArray.add(dic)
                                        
                                    }
                                    self.tblViewViilage.reloadData()
                                }
                                self.view.layoutIfNeeded()
                                self.view.updateConstraintsIfNeeded()
                            }
                        }
                    }
                }
            }
        }
    }
    
    //
    func validations()-> Bool {
        if !boolImagePicked{
            self.view.makeToast("Please Select Image")
            return false
        }
        else if self.txt_pest_diease.text == "" {
            self.view.makeToast("Please Select Pest/Disease")
            return false
        }else if self.txt_pincode.text == "" {
            self.view.makeToast("Please Enter Pincode")
            return false
        }else if self.txt_village.text == "" {
            self.view.makeToast("Please Enter Village")
            return false
        }
        else if self.txt_plantAge.text == "" {
            self.view.makeToast("Please Enter Plant Age")
            return false
        }
        else if self.txt_otherVillage.text == ""  &&  (self.txt_village.text)?.uppercased() == "OTHERS"{
            self.view.makeToast("Please Enter other Village")
            return false
        }
        //        else if self.txt_Brand.text == "" {
        //            self.view.makeToast("Please Enter Brand")
        //            return false
        //        }
        //        else if self.txt_otherBrand.text == "" &&  (self.txt_Brand.text)?.uppercased() == "OTHERS" {
        //            self.view.makeToast("Please enter other brand")
        //            return false
        //        }else if self.txt_hybrid.text == "" {
        //            self.view.makeToast("Please Select Hybrid")
        //            return false
        //        }
        
        
        
        return true
    }
    
    //MARK: getDocumentPath
    func getDocumentPath(_ assetStr: NSString) -> NSString {
        let assetArray = assetStr.components(separatedBy: "/") as NSArray
        let filePath = String(format: "%@/%@", cortevaNewsDocumentDirectory,assetArray.lastObject as! NSString) as NSString
        return filePath
    }
    func SaveImageToLocalPathCheck(images : UIImage) ->String
    {
        let currentTime = Constatnts.getCurrentMillis()
        let imgFileName = String(currentTime).replacingOccurrences(of: "-", with: "")
        submitRecordId = imgFileName
        imageURltoServer = imgFileName
        //Save image to documents
        
        let fileManager = FileManager.default
        let fileName = String(format:"%@.jpg",imgFileName)
        let filePath = String(format: "%@/%@", cortevaNewsDocumentDirectory,fileName)
        print(filePath)
        let imageData = UIImageJPEGRepresentation(images, 0.9)
        fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
        filePathSavedDB = filePath
        return filePath
    }
    
    func saveImageToLocalPath(dictionary : NSMutableDictionary) ->String
    {
        let fileManager = FileManager.default
        
        let fileName = String(format: "%@.jpg", dictionary.value(forKey: "serverId") as? String ?? "")
        let filePath = String(format: "%@/%@", cortevaNewsDocumentDirectory,fileName)
        print(filePath)
        let imageData = UIImageJPEGRepresentation(dictionary.value(forKey: "image") as! UIImage, 0.9)
        fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
        filePathSavedDB = filePath
        return filePath
    }
    
    //MARK: checkIfFileExists
    func checkIfFileExists(atPath strPath: String) -> Bool {
        let fileExists: Bool = FileManager.default.fileExists(atPath: strPath)
        return fileExists
    }
    
    
    //func - (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //  submitSverityString = ""
        self.dismiss(animated: true, completion: nil)
    }
    
    // --------------------------------------------------//
    // MARK:- GET Image captured location
    // --------------------------------------------------//
    func getImageCuurentloaction()->String{
        var geoLocation = ""
        if Validations.checkUserEnabledLocationServiceOrNot(viewController: self as UIViewController,showAlert: true) == true{
            if let currentLocation = LocationService.sharedInstance.currentLocation as CLLocation?{
                if let coordinates = currentLocation.coordinate as CLLocationCoordinate2D?{
                    geoLocation = String(format: "%.2f,%.2f", coordinates.latitude,coordinates.longitude)
                    submitlatlongValues = geoLocation
                    
                    
                }
            }
        }
        return geoLocation
    }
    
    @IBAction func calculateArea(_ sender: Any) {
        
        if txt_getareaNEW.text == ""{
            self.view.endEditing(true)
            let fawVC = self.storyboard?.instantiateViewController(withIdentifier: "FAW_FieldBoundaryViewController") as? FAW_FieldBoundaryViewController
            fawVC?.areaViewObj = self
            fawVC?.delegate = self
            self.navigationController?.pushViewController(fawVC!, animated: true)
        }
        else{
            isFromAreaValidation = true
            self.txtFldChangesAlert = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: "Alert!" as NSString, message: String(format: "Captured field boundaries data will be removed, still you want to continue") as NSString, okButtonTitle: "YES", cancelButtonTitle: "NO") as? UIView
            self.view.addSubview(self.txtFldChangesAlert!)
        }
    }
    
    
    //MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        severityWIndow.isHidden = true
        isDataModified = true
        if (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil {
            img_choosePest.contentMode = .scaleAspectFill
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                self.img_choosePest?.image = image
                boolImagePicked = true
                
                let actualHeight:CGFloat = image.size.height
                let actualWidth:CGFloat = image.size.width
                let imgRatio:CGFloat = actualWidth/actualHeight
                let maxWidth:CGFloat = 1024.0
                let resizedHeight:CGFloat = maxWidth/imgRatio
                let compressionQuality:CGFloat = 0.8
                
                let rect:CGRect = CGRect(x: 0, y: 0, width: maxWidth, height: resizedHeight)
                UIGraphicsBeginImageContext(rect.size)
                image.draw(in: rect)
                let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                let imageData:Data = UIImageJPEGRepresentation(img, compressionQuality)!
                UIGraphicsEndImageContext()
                
                let  finalImage =  UIImage(data: imageData)!
                finalImageSave = finalImage
                isDatamodifed = true
                
                let currentTime = Constatnts.getCurrentMillis()
                let imgFileName = String(currentTime).replacingOccurrences(of: "-", with: "")
                
                if submitRecordId == ""{
                    submitRecordId = String(format:"%@",imgFileName)
                }else{
                    submitRecordId = String(format:"%@,%@",submitRecordId,imgFileName)
                }
                let coordinateSTr = getImageCuurentloaction()
                let dictionary : NSMutableDictionary = NSMutableDictionary()
                
                
                let dateFormatter: DateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                let  submittedDateImage = dateFormatter.string(from: Date())
                
                dictionary.setValue(submitSverityString, forKey: "imageSeverity")
                // dictionary.setValue(finalImageSave, forKey:"image")
                dictionary.setValue(imgFileName, forKey:"imagePath")
                dictionary.setValue(submittedDateImage, forKey:"imgCapturedTime")
                dictionary.setValue(coordinateSTr, forKey:"imgCapuredLatLong")
                dictionary.setValue(imgFileName, forKey:"imageId")
                
                
                let dictionary1 : NSMutableDictionary = NSMutableDictionary()
                dictionary1.setValue(finalImageSave, forKey:"image")
                dictionary1.setValue(imgFileName, forKey:"serverId")
                arrayImagesOnly.add(dictionary1)
                
                arrImages.add(dictionary)
                
                print(dictionary)
                lblImagesRedRound.isHidden = false
                //  lblImagesCount.text = String(format:"Image count : \(arrImages.count)")
                lblImagesRedRound.text = String(format:"\(arrImages.count)")
                lblImagesRedRound.backgroundColor = .red
                submitSverityString = ""
                //                arrImages.append(finalImageSave)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
  
    
    //MARK: alertYesBtnAction
    @objc func alertYesBtnAction(){
        if self.unsavedChangesAlert != nil {
            self.unsavedChangesAlert?.removeFromSuperview()
        }
        if isFromAreaValidation{
            if self.txtFldChangesAlert != nil {
                self.txtFldChangesAlert?.removeFromSuperview()
            }
            isFromAreaValidation = false
            self.view.endEditing(true)
            let fawVC = self.storyboard?.instantiateViewController(withIdentifier: "FAW_FieldBoundaryViewController") as? FAW_FieldBoundaryViewController
            fawVC?.areaViewObj = self
            fawVC?.delegate = self
            self.navigationController?.pushViewController(fawVC!, animated: true)
            
            
        }
        else if isFromSubmit{
            self.SubmitData()
        }
        else{
            isDatamodifed = false
            if self.txtFldChangesAlert != nil {
                self.txtFldChangesAlert?.removeFromSuperview()
            }
            
          
            
            
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    //MARK: alertNoBtnAction
    @objc func alertNoBtnAction(){
        if self.unsavedChangesAlert != nil {
            self.unsavedChangesAlert?.removeFromSuperview()
        }
        isFromAreaValidation = false
        
        isDatamodifed = false
        if txtFldChangesAlert != nil{
            txtFldChangesAlert?.removeFromSuperview()
            txtFldChangesAlert = nil
        }
        
    }
    
    
    
    
}

extension BPHAlertsViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return severityImageArray.count
    }
    
    //  let data = self.filteredCropsforDisplay?[indexPath.item]
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeverityCell", for: indexPath)
        let severityImage = cell.viewWithTag(1) as! UIImageView
        let selectBtn = cell.viewWithTag(2) as! UIButton
        let dic : NSDictionary = severityImageArray.object(at: indexPath.row) as? NSDictionary ?? [:]
        selectBtn.setTitle(dic.object(forKey: "priority") as? String ?? "", for: .normal)
        severityImage.image = UIImage(named:dic.object(forKey: "fawImageUrl") as? String ?? "") ?? UIImage(named: "image_placeholder.png")
        var url1: URL = NSURL() as URL
        let url = URL(string: dic.object(forKey: "fawImageUrl") as? String ?? "") ?? url1
        severityImage.downloadedFrom(url:url , placeHolder: UIImage(named:"image_placeholder.png"))
        severityImage.contentMode = .scaleAspectFill
        selectBtn.setImage(UIImage(named: "radioEmpty"), for: .normal)
        selectBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        var eyebutton = cell.contentView.viewWithTag(3) as! UIButton
        if selectedTag == indexPath.row{
            let dic : NSDictionary = severityImageArray.object(at: selectedTag) as? NSDictionary ?? [:]
            selectBtn.setImage(UIImage(named: "radio"), for: .normal)
            submitSverityString = dic.object(forKey: "priority") as? String ?? ""
        }
        
        return cell
        
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let numberOfSets = CGFloat(self.severityImageArray.count)
        
        let width = collectionView.frame.size.width / 3
        //(collectionView.frame.size.width - (numberOfSets * view.frame.size.width / 15))/numberOfSets
        
        let height = collectionView.frame.size.height / 2
        
        return CGSize(width: width, height: height);
    }
    
    // UICollectionViewDelegateFlowLayout method
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        let cellWidthPadding = collectionView.frame.size.width / 15
        let cellHeightPadding = collectionView.frame.size.height / 4
        return UIEdgeInsets(top: cellHeightPadding,left: cellWidthPadding, bottom: cellHeightPadding,right: cellWidthPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedTag == indexPath.row{
            selectedTag = -1
        }else{
            selectedTag = indexPath.row
        }
        severityCollectionView.reloadData()
    }
    
    
    
}


//MARK:- PROTOCAL DELEGATES
//MARK: - Protocol Delegate Methods
extension BPHAlertsViewController: AreaEntryDelegate{
    
    func getAreaCoordinates(_ cordinates: NSMutableArray) {
        arrayAreaCoordinates = NSMutableArray()
        arrayAreaCoordinates = cordinates
        
        //        print("getAreaCoordinates")
        print(cordinates)
    }
    
    //Step 5 delegate
    func getArea(_ text: String , hintText : String)  {
        print(text)
        lbl_totalAreHInt.textColor = .black
        lbl_totalAreHInt.text = text
        txt_getareaNEW.text = text
        lbl_totalAreHInt.text = String(format: "(Area is %@ in acres)",hintText)
    }
    
}


//MARK:- UITEXTFIELD DELEGATE METHODS
extension BPHAlertsViewController{
    func textFieldDidEndEditing(_ textField: UITextField) {
        isDataModified = true
        if(textField == txt_pincode){
            if(txt_pincode.text?.count == 6)
            {
                villageArray.removeAllObjects()
                let predicate = NSPredicate(format: "pincode = %@",txt_pincode.text ?? "" )
                let outputFilteredArr = (villageMaster).filtered(using: predicate) as NSArray
                
                if outputFilteredArr.count>0{
                    //villageArray.add(outputFilteredArr)
                    villageArray  = NSMutableArray(array: outputFilteredArr)
                }
                
                
                if villageArray.count == 0{
                    txt_village.text = ""
                    let dic = [    "id" : "0",
                                   "name" : "Others",
                                   "pincode" : txt_pincode.text ?? "",
                                   "villageCodeId" : "0",
                    ]
                    villageArray.add(dic)
                }
                tblViewViilage.reloadData()
            }
        }
    }
    
    //MARK: - UITextfield delegate methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        if(arrayDiseases.count == 0 ){
            //  arrayDiseases = appdelegate.getFAWDiseaseFromDB("FAWDiseaseMaster")
            tblViewDieases.reloadData()
        }
        
        if textField == txt_village {
            txt_village.resignFirstResponder()
            tblViewViilage.reloadData()
            if(txt_pincode.text == ""){
                self.view.makeToast("Please Enter pincode")
            }
            else
            {
                self.hideUnhideDropDownTblView(tblView: tblViewViilage, hideUnhide: false)
            }
        }
        else if textField == txt_pest_diease && txt_pest_diease.text != "Others" {
            
            txt_pest_diease.resignFirstResponder()
            tblViewDieases.reloadData()
            if(arrayDiseases.count == 0 ){
                //arrayDiseases = appdelegate.getFAWDiseaseFromDB("FAWDiseaseMaster")
                tblViewDieases.reloadData()
            }
            self.hideUnhideDropDownTblView(tblView: tblViewDieases, hideUnhide: false)
        }
        activeTxtField = textField
    }
    
    //MARK: hideUnhideDropDownTblView
    @objc func hideUnhideDropDownTblView(tblView : UITableView, hideUnhide : Bool){
        tblViewViilage.isHidden = true
        tblViewPlantAge.isHidden = true
        tblViewDieases.isHidden = true
        tblView.isHidden = !hideUnhide
        self.view.bringSubview(toFront: tblView)
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txt_village {
            self.view.endEditing(true)
            activeTxtField = textField
            villageArray.removeAllObjects()
            
            let predicate = NSPredicate(format: "pincode = %@",txt_pincode.text ?? "" )
            let outputFilteredArr = (villageMaster).filtered(using: predicate) as NSArray
            
           // villageArray.add(outputFilteredArr)
            villageArray  = NSMutableArray(array: outputFilteredArr)
            if villageArray.count > 0{
            tblViewViilage.reloadData()
            
            self.hideUnhideDropDownTblView(tblView: tblViewViilage, hideUnhide: tblViewViilage.isHidden)
            return false
            }else{
                return true
            }
        }
        else  if textField == txt_pest_diease {
            if(pestRdiseaseArry.count > 0){
            self.view.endEditing(true)
            activeTxtField = textField
            tblViewDieases.reloadData()
            self.hideUnhideDropDownTblView(tblView: tblViewDieases, hideUnhide: tblViewDieases.isHidden)
            return false
            }else{
                return true
            }
        }
        else{
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txt_village || textField == txt_pincode {//|| textField == plantAge_txtFld
            let newString: String? = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            let validCharSet = CharacterSet(charactersIn: "0123456789").inverted
            let filtered: String = (string.components(separatedBy: validCharSet) as NSArray).componentsJoined(by: "")
            let _char = string.cString(using: String.Encoding.utf8)
            let isBackSpace: Int = Int(strcmp(_char, "\\b"))
            if isBackSpace == -92 {
                // is backspace
                if textField.text?.count == 1 {
                }
                return true
            }
            if (filtered == "") {
            }
            if textField == txt_pincode{
                if (newString?.count)! > 6 && range.length == 0 {
                    return false
                }
                if (newString?.count)! == 6{
                    //print(newString!)
                    return true
                }
            }
            
            /*  if textField == plantAge_txtFld{
             
             if(newString?.count == 1 && newString == "0"){
             return false
             }
             if (newString?.count)! > 3 && range.length == 0 {
             return false
             }
             if (newString?.count)! == 3{
             //print(newString!)
             return true
             }
             }*/
            return (string == filtered)
        }
        return true
    }
    
}

//MARK:- UITABLEVIEW DELEGATE AND DATASOURCE METHODS
extension BPHAlertsViewController : UITableViewDelegate, UITableViewDataSource{
    // ----------------------------------------------- //
    //Mark: - UITableviewDatasource methods
    //MARK: UITableView Delegate And Datasource Methods
    // ----------------------------------------------- //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblViewViilage{
            return villageArray.count
        }
        if tableView == tblViewDieases{
            return pestRdiseaseArry.count
        }
        if tableView == tblViewPlantAge{
            return arrayPlantAge.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        cell.textLabel?.font = UIFont.init(name: "Helvetica", size: 13.0)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.sizeToFit()
        if tableView == tblViewViilage{
            if(villageArray.count > 0){
                let dbObjj  = self.villageArray.object(at: indexPath.row) as? NSDictionary ?? [:]
                cell.textLabel?.text = dbObjj.value(forKey: "name")  as? String
                
            }
//            if(villageArray.count > 0){
//
//                let getArray = self.villageArray.object(at: indexPath.row) as? NSDictionary ?? [:]
//                let getfilterString:String = (getArray as AnyObject).value(forKey: "name")  as? String ?? "nil"
//
//                if(getfilterString == "nil"){
//                    let getArray:NSArray =  villageArray[indexPath.row] as! NSArray
//
//                    if (getArray as AnyObject).count > 0 {
//                        for i in getArray {
//                            cell.textLabel?.text =  (i as AnyObject).value(forKey: "name")  as? String
//                        }
//                    }
//                }else{
//                    cell.textLabel?.text = getfilterString
//                }
//
//            }
        }
        else if tableView == tblViewDieases{
            if(pestRdiseaseArry.count > 0){
                let dbObjj  = self.pestRdiseaseArry.object(at: indexPath.row) as? NSDictionary ?? [:]
                cell.textLabel?.text = dbObjj.value(forKey: "name")  as? String
            }
        }
        else if tableView == tblViewPlantAge{
            if(arrayPlantAge.count > 0){
                cell.textLabel?.text = arrayPlantAge.object(at: indexPath.row) as? String  ?? ""
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == tblViewViilage {
            let dbObjj  = self.villageArray.object(at: indexPath.row) as? NSDictionary ?? [:]
            txt_village?.text  = dbObjj.value(forKey: "name")  as? String
            
            ID_villageCode = dbObjj.value(forKey: "villageCodeId")  as? Int ?? 0
            if txt_village?.text == "Others" {
                isOtherVillage = true
                
                view_othervillage.isHidden = false
            }else {
                isOtherVillage = false
                
                view_othervillage.isHidden = true
            }
        }
        
        if tableView == tblViewDieases {
            if(arrayDiseases.count > 0){
                
                let dbObjj  =  self.arrayDiseases.object(at: indexPath.row) as? NSDictionary ?? [:]
                txt_pest_diease?.text = dbObjj.value(forKey: "name")  as? String
                ID_pestRdisesa = dbObjj.value(forKey: "id")  as? Int ?? 0
            }
            
            
        }
        if tableView == tblViewPlantAge {
            txt_plantAge?.text = arrayPlantAge.object(at: indexPath.row) as? String  ?? ""
        }
        tableView.isHidden = true
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
}



