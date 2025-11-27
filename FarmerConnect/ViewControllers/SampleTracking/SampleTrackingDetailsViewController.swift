//
//  SampleTrackingDetailsViewController.swift
//  FarmerConnect
//
//  Created by Empover on 24/09/24.
//  Copyright © 2024 ABC. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
//import Acvission
//import AcvissCore
//import ZXingObjC
import Kingfisher
import CoreLocation
import EmpoverCameraScannerSDK

class SampleTrackingDetailsViewController: BaseViewController,FloatRatingViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate,AreaEntryDelegate,CameraScannerDelegate {
    //AcvissionDelegate
    
    var scannerView: CameraScannerView?

    @IBOutlet weak var  globaloDataLbl: UILabel!
    @IBOutlet var RetailerStack: UIStackView!
    @IBOutlet weak var  RetailerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var  RetailerTopView: UIView!
    @IBOutlet weak var  RetailerView: UIView!
    @IBOutlet weak var  RetailerTopImageView: UIImageView!
    @IBOutlet var FarmerStack: UIStackView!
    @IBOutlet weak var  farmerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var  farmerTopView: UIView!
    @IBOutlet weak var  farmerView: UIView!
    @IBOutlet weak var  farmerTopImageView: UIImageView!
    @IBOutlet var PravtktaStack: UIStackView!
    @IBOutlet weak var  PravtktaHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var  PravtktaTopView: UIView!
    @IBOutlet weak var  PravtktaView: UIView!
    @IBOutlet weak var  PravtktaTopImageView: UIImageView!
    @IBOutlet var BigfarmerStack: UIStackView!
    @IBOutlet weak var  BigfarmerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var  BigfarmerTopView: UIView!
    @IBOutlet weak var  BigfarmerView: UIView!
    @IBOutlet weak var  BigfarmerTopImageView: UIImageView!
    
    @IBOutlet weak var editButton: UIButton!
    @IBAction func editButtonAction(_ sender: Any) {
        self.appendEditDataHere()
    }
    var isIAGButtonAction = false
    var isEditButton = false
    var errorMessage = ""
    var paramsDic = NSMutableDictionary()
    var RetailerArray =  [NearByModel]()
    var farmersArray =  [NearByModel]()
    var PravakthaArray =  [NearByModel]()
    var BigfarmersArray =  [NearByModel]()

    var alertController = UIAlertController()
    var selectedCropImage: UIImage!
    var selectedImageData:Data!
    
    var sectionNames = [SectionDetails]()
    @IBOutlet weak var  farmerVSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var  pravktaVSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var  BigfarmerVSpacingConstraint: NSLayoutConstraint!
    
    //Right side Value Lables
    @IBOutlet weak var sampleRequestLbl1: UILabel!
    @IBOutlet weak var sampleRequestLbl2: UILabel!
    @IBOutlet weak var sampleRequestLbl3: UILabel!
    @IBOutlet weak var sampleReportLbl1: UILabel!
    @IBOutlet weak var sampleReportLbl2: UILabel!
    @IBOutlet weak var sampleReportLbl3: UILabel!
    @IBOutlet weak var sampleReportLbl4: UILabel!
    @IBOutlet weak var sampleReportLbl5: UILabel!
    @IBOutlet weak var geoTagLbl1: UILabel!
    @IBOutlet weak var geoTagLbl2: UILabel!
    @IBOutlet weak var geoTagImg: UIImageView!
    @IBOutlet weak var harvestReportLbl1: UILabel!
    @IBOutlet weak var harvestReportLbl2: UILabel!
    @IBOutlet weak var harvestReportLbl3: UILabel!
    @IBOutlet weak var harvestReportLbl4: UILabel!
    @IBOutlet weak var harvestReportLbl5: UILabel!
    @IBOutlet weak var harvestReportLbl6: UILabel!
    @IBOutlet weak var harvestReportLbl7: UILabel!
    
    //Edit Form Views
    
    @IBOutlet weak var retailerEditView: UIView!
    @IBOutlet weak var farmerEditView: UIView!
    @IBOutlet weak var pravtktaEditView: UIView!
    @IBOutlet weak var bigFarmerEditView: UIView!
    
    @IBOutlet weak var retailerEditHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var farmerEditHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pravtktaEditHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bigfarmerEditHeightConstraint: NSLayoutConstraint!
    
    //Ride side Values fields
    
    @IBOutlet weak var sampleRequestYesBtn: UIButton!
    
    @IBAction func sampleRequestYesBtnAction(_ sender: Any) {
        self.sampleRequestYes = !self.sampleRequestYes
        if(self.sampleRequestYes == false){
                   self.sampleRequestYesBtn?.setImage(UIImage(named: "Radio"), for: .normal)
               }
               else{
                   self.sampleRequestYesBtn?.setImage(UIImage(named: "SelectRadioBlue"), for: .normal)
                   self.sampleRequestNoBtn?.setImage(UIImage(named: "Radio"), for: .normal)
                   self.sampleRequestNo = false
                   self.dataSection1Pravakta = "Yes"
               }
    }
    
    @IBOutlet weak var sampleRequestNoBtn: UIButton!
    
    @IBAction func sampleRequestNoBtnAction(_ sender: Any) {
        self.sampleRequestNo = !self.sampleRequestNo
        if(self.sampleRequestNo == false){
                   self.sampleRequestNoBtn?.setImage(UIImage(named: "Radio"), for: .normal)
               }
               else{
                   self.sampleRequestNoBtn?.setImage(UIImage(named: "SelectRadioBlue"), for: .normal)
                   self.sampleRequestYesBtn?.setImage(UIImage(named: "Radio"), for: .normal)
                   self.sampleRequestYes = false
                   self.dataSection1Pravakta = "No"
               }
    }
    @IBOutlet weak var sampleRequestCropTxt: UITextField!
    @IBOutlet weak var sampleRequestHybridTxt: UITextField!
    @IBOutlet weak var sampleReportYesBtn: UIButton!
    
    @IBAction func sampleReportYesBtnAction(_ sender: Any) {
        self.sampleReportYes = !self.sampleReportYes
        if(self.sampleReportYes == false){
                   self.sampleReportYesBtn?.setImage(UIImage(named: "Radio"), for: .normal)
               }
        else{
            self.sampleReportYesBtn?.setImage(UIImage(named: "SelectRadioBlue"), for: .normal)
            self.sampleReportNoBtn?.setImage(UIImage(named: "Radio"), for: .normal)
            self.sampleReportNo = false
            self.dataSection2Pravakta = "Yes"
        }

    }
    
    @IBOutlet weak var sampleReportNoBtn: UIButton!
    
    @IBAction func sampleReportNoBtnAction(_ sender: Any) {
        self.sampleReportNo = !self.sampleReportNo
        if(self.sampleReportNo == false){
                    self.sampleReportNoBtn?.setImage(UIImage(named: "Radio"), for: .normal)
                }
                else{
                    self.sampleReportNoBtn?.setImage(UIImage(named: "SelectRadioBlue"), for: .normal)
                    self.sampleReportYesBtn?.setImage(UIImage(named: "Radio"), for: .normal)
                    self.sampleReportYes = false
                    self.dataSection2Pravakta = "No"
                }
    }
    @IBOutlet weak var sampleReportCropTxt: UITextField!
    
    @IBOutlet weak var sampleReportHybridTxt: UITextField!
    
    @IBOutlet weak var sampleReceivingData: UITextField!
    @IBOutlet weak var sampleReportProductConfirmationTxt: UITextField!
    
    @IBAction func sampleReportScanBtnAction(_ sender: Any) {
        //self.openAcvission()
        self.openEmpoverScanner()
    }
    
    @IBOutlet weak var geoTagReportDateTxt: UITextField!
    
    @IBOutlet weak var geoTagReportGeoTagTxt: UITextField!
    
    
    @IBOutlet weak var geoTagImageView: UIImageView!
    @IBOutlet weak var geoTagUploadCropImgBtn: UIButton!
    
    @IBAction func geoTagUploadCropImgBtnAction(_ sender: Any) {
        self.camera()
//        let userObj = Constatnts.getUserObject()
//        let attributedString = NSAttributedString(string: NSLocalizedString("choose_option", comment: ""), attributes: [
//            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20),
//            NSAttributedStringKey.foregroundColor : UIColor.orange
//        ])
//        alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
//        alertController.setValue(attributedString, forKey: "attributedMessage")
//        let cameraButton = UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
//            print("Camera button tapped")
//            if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                self.camera()
//            }
//            else{
//                print("not compatible")
//            }
//        })
//        
//        let  galleryButton = UIAlertAction(title: NSLocalizedString("gallery", comment: ""), style: .default, handler: { (action) -> Void in
//            print("Gallery button tapped")
//            self.photoLibrary()
//        })
//        let  cancelButton = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (action) -> Void in
//            print("Cancel button tapped")
//        })
//        alertController.addAction(cameraButton)
//        alertController.addAction(galleryButton)
//        alertController.addAction(cancelButton)
//        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    

    @IBOutlet weak var iagUserValueLbl: UILabel!
    @IBOutlet weak var iagUserIDTxt: UITextField!
    
    @IBOutlet weak var iagInfoLbl: UILabel!
    @IBAction func iagInfoBtnAction(_ sender: Any) {
        if(isIAGButtonAction ==  false){
            isIAGButtonAction = true
            self.iagInfoLbl.isHidden = false
        }
        else{
            isIAGButtonAction = false
            self.iagInfoLbl.isHidden = true
        }
        
    }
    @IBOutlet weak var harvestReportDateOfHarvestingTxt: UITextField!
    
    @IBOutlet weak var harvestReportYieldTxt: UITextField!
    
    @IBOutlet weak var harvestReportMandiTxt: UITextField!
    
    @IBOutlet weak var ratingView: FloatRatingView!
    
    @IBOutlet weak var harvestReportTopFabTxt: UITextField!
    
    @IBOutlet weak var harvestReportWillGrowYesBtn: UIButton!
    
    @IBAction func harvestReportWillGrowYesBtnAction(_ sender: Any) {
        self.harvestReportWillGrowYes = !self.harvestReportWillGrowYes
        if(self.harvestReportWillGrowYes == false){
                   self.harvestReportWillGrowYesBtn?.setImage(UIImage(named: "Radio"), for: .normal)
               }
               else{
                   self.harvestReportWillGrowYesBtn?.setImage(UIImage(named: "SelectRadioBlue"), for: .normal)
                   self.harvestReportWillGrowNoBtn?.setImage(UIImage(named: "Radio"), for: .normal)
                   self.harvestReportWillGrowNo = false
                   self.dataSection4WillGrow = "Yes"
               }
    }
    
    @IBOutlet weak var harvestReportWillGrowNoBtn: UIButton!
    @IBAction func harvestReportWillGrowNoBtnAction(_ sender: Any) {
        self.harvestReportWillGrowNo = !self.harvestReportWillGrowNo
        if(self.harvestReportWillGrowNo == false){
                   self.harvestReportWillGrowNoBtn?.setImage(UIImage(named: "Radio"), for: .normal)
               }
               else{
                   self.harvestReportWillGrowNoBtn?.setImage(UIImage(named: "SelectRadioBlue"), for: .normal)
                   self.harvestReportWillGrowYesBtn?.setImage(UIImage(named: "Radio"), for: .normal)
                   self.harvestReportWillGrowYes = false
                   self.dataSection4WillGrow = "No"
               }

    }
    
    @IBOutlet weak var harvestReportWillRecommendYesBtn: UIButton!
    
    @IBAction func harvestReportWillRecommendYesBtnAction(_ sender: Any) {
        harvestReportWillRecommendYes = !harvestReportWillRecommendYes
        if(harvestReportWillRecommendYes == false){
            self.harvestReportWillRecommendYesBtn?.setImage(UIImage(named: "Radio"), for: .normal)
               }
               else{
                   self.harvestReportWillRecommendYesBtn?.setImage(UIImage(named: "SelectRadioBlue"), for: .normal)
                   self.harvestReportWillRecommendNoBtn?.setImage(UIImage(named: "Radio"), for: .normal)
                   self.harvestReportWillRecommendNo = false
                   self.dataSection4WillRecommend = "Yes"
               }
    }
    
    @IBOutlet weak var harvestReportWillRecommendNoBtn: UIButton!
    
    @IBAction func harvestReportWillRecommendNoBtnAction(_ sender: Any) {
        harvestReportWillRecommendNo = !harvestReportWillRecommendNo
        if(harvestReportWillRecommendNo == false){
                self.harvestReportWillRecommendNoBtn?.setImage(UIImage(named: "Radio"), for: .normal)
                }
                else{
                self.harvestReportWillRecommendNoBtn?.setImage(UIImage(named: "SelectRadioBlue"), for: .normal)
                self.harvestReportWillRecommendYesBtn?.setImage(UIImage(named: "Radio"), for: .normal)
                    self.harvestReportWillRecommendYes = false
                    self.dataSection4WillRecommend = "No"
                }
    }
    @IBOutlet weak var submitBtn: UIButton!
    @IBAction func submitBtnAction(_ sender: Any) {
        if(self.dataStatus == NSLocalizedString("sampleRequest", comment: "")){
            if(iagUserIDTxt.text == ""){
                self.view.makeToast("Please Enter IAG UserID")
                return
            }
            else if(iagUserIDTxt.text!.count < 3){
                self.view.makeToast("Please Enter Minimum 3 Digits")
                return
            }
            else if(dataSection1Pravakta == ""){
                self.view.makeToast("Please Select Pravakta")
                return
            }
            else if(sampleRequestCropTxt.text == ""){
                self.view.makeToast("Please Select Crop")
                return
            }
            else if(sampleRequestHybridTxt.text == ""){
                self.view.makeToast("Please Select Hybrid")
                return
            }
            else{
                let net = NetworkReachabilityManager(host: "www.google.com")
                if net?.isReachable == true{
                    self.uploadingWithMultiPartFormData()
                    return
                }
                else{
                let checkInterNet = NSLocalizedString("no_internet", comment: "")
                self.view.makeToast(checkInterNet)
                }
            }
        }
        else if(self.dataStatus == NSLocalizedString("sampleReport", comment: "")){
            if(dataSection2Pravakta == ""){
                self.view.makeToast("Please Select Have you received this sample free of cost")
                return
            }
//            else if(sampleReportCropTxt.text == ""){
//                self.view.makeToast("Please Select Crop")
//                return
//            }
//            else if(sampleReportHybridTxt.text == ""){
//                self.view.makeToast("Please Select Hybrid")
//                return
//            }
            else if(sampleReceivingData.text == ""){
                self.view.makeToast("Please Select Sample receiving date")
                return
            }
            else if(sampleReportProductConfirmationTxt.text == ""){
                self.view.makeToast("Please Scan Product Confirmation")
                return
            }
            else{
                let net = NetworkReachabilityManager(host: "www.google.com")
                if net?.isReachable == true{
                    self.uploadingWithMultiPartFormData()
                    return
                }
                else{
                let checkInterNet = NSLocalizedString("no_internet", comment: "")
                self.view.makeToast(checkInterNet)
                }
            }
        }
        else if(self.dataStatus == NSLocalizedString("geoTag", comment: "")){
            if(geoTagReportDateTxt.text == ""){
                self.view.makeToast("Please Select Report date of sowing")
                return
            }
            else if(geoTagReportGeoTagTxt.text == ""){
                self.view.makeToast("Please Select Geo tag location")
                return
            }
//            else if(ImageNameSending == ""){
//                self.view.makeToast("Please Upload Crop Image")
//                return
//            }
            else{
                let net = NetworkReachabilityManager(host: "www.google.com")
                if net?.isReachable == true{
                    self.uploadingWithMultiPartFormData()
                    return
                }
                else{
                let checkInterNet = NSLocalizedString("no_internet", comment: "")
                self.view.makeToast(checkInterNet)
                }
            }
        }
        else if(self.dataStatus == NSLocalizedString("performanceReport", comment: "")){
            if(harvestReportDateOfHarvestingTxt.text == ""){
                self.view.makeToast("Please Select Date of Harvesting")
                return
            }
            else if(harvestReportYieldTxt.text == ""){
                self.view.makeToast("Please Enter Yield Qt/ac")
                return
            }
            else if(harvestReportMandiTxt.text == ""){
                self.view.makeToast("Please Enter Mandi price")
                return
            }
            else if(dataSection4HybridRating == 0.0){
                self.view.makeToast("Please Select Hybrid Rating")
                return
            }
            else if(harvestReportTopFabTxt.text == ""){
                self.view.makeToast("Please Select Top 3 Fab selection")
                return
            }
            else if(dataSection4WillGrow == ""){
                self.view.makeToast("Please Select Will you grow next year")
                return
            }
            else if(dataSection4WillRecommend == ""){
                self.view.makeToast("Please Select will you recommend to others")
                return
            }
            else{
                let net = NetworkReachabilityManager(host: "www.google.com")
                if net?.isReachable == true{
                    self.uploadingWithMultiPartFormData()
                    return
                }
                else{
                let checkInterNet = NSLocalizedString("no_internet", comment: "")
                self.view.makeToast(checkInterNet)
                }
            }
        }
    }

    var dataObj: NSDictionary?
    
    var getCropListArray: NSArray?
    var getHybridListArray: NSArray?
    var getTopFabListArray: NSArray?
    
    var sampleReportYes = false
    var sampleReportNo = false
    
    var sampleRequestYes = false
    var sampleRequestNo = false
   
    var harvestReportWillGrowYes = false
    var harvestReportWillGrowNo = false
    
    var harvestReportWillRecommendYes = false
    var harvestReportWillRecommendNo = false
    
    //Section Value Variables
    var dataSection1Pravakta:String = ""
//    var dataSection1Crop:String = ""
//    var dataSection1Hybrid:String = ""
    
    var dataSection2Pravakta:String = ""
//    var dataSection2Crop:String = ""
//    var dataSection2Hybrid:String = ""
//    var dataSection2SampleReceiving:String = ""
//    var dataSection2ProductConfirmation:String = ""
    
 //   var dataSection3DateOfSowing:String = ""
    var dataSection3ReortGeoTag:String = ""
 //   var dataSection3UploadImage:String = ""
    
//    var dataSection4DateOfHarvesting:String = ""
//    var dataSection4Yield:String = ""
//    var dataSection4Mandi:String = ""
    var dataSection4HybridRating:Double = 0.0
//    var dataSection4TopFab:String = ""
    var dataSection4WillGrow:String = ""
    var dataSection4WillRecommend:String = ""
    var dataStatus:String = ""
    
    var statusIS:String = ""
    
    var cropDropDownTblView = UITableView()
    var hybridNameTblView = UITableView()
    var reportCropDropDownTblView = UITableView()
    var reportHybridNameTblView = UITableView()
    var topFabTblView = UITableView()
    
    var cropID = ""
    var hybridID = ""
    
    var reportCropID = ""
    var reportHybridID = ""
    var topFabID = ""
    
    var cropArray = NSArray()
    var hybridArray = NSArray()
    var reportCropArray = NSArray()
    var reportHybridArray = NSArray()
    var originalReportHybridArray = NSArray()
    var topFabArray = NSArray()
    
    var arrTopFabList:NSArray = []
    var getServerId = 0
    
    var statusMsgAlert : UIView?
    var moduleType = ""
    
    var saveScanResult = [String: String]()
    var saveJsonString = ""
    var dictEncashResponse : NSDictionary?
    var scanResponseAcviss : NSDictionary?

    var fromDateView : UIView?
    var maximumDate : NSDate?
    
    var ImageNameSending = ""
    var originalSelectedDate = ""
    
    var selectLocation: CLLocationCoordinate2D?
    var currentLocation : CLLocationCoordinate2D?
    
    var arrayAreaCoordinates = NSMutableArray()
    
    
    
    func getAreaCoordinates(_ cordinates: NSMutableArray) {
        arrayAreaCoordinates = NSMutableArray()
        arrayAreaCoordinates = cordinates
        
        //        print("getAreaCoordinates")
        print("cordinates here is",cordinates)

//        let array: NSMutableArray = cordinates
//        let stringValue = array.compactMap { $0 as? String }.joined(separator: ", ") // "Hello, World"
//        print("gggghhhh",stringValue)
//        

        //getCurrentLOC
        currentLocation = LocationService.sharedInstance.currentLocation?.coordinate
        if self.selectLocation == nil{
            if Validations.checkUserEnabledLocationServiceOrNot(viewController: self as UIViewController,showAlert: true) == true{
                if LocationService.sharedInstance.currentLocation?.coordinate != nil{
                    let tempCurrentLocation = LocationService.sharedInstance.currentLocation?.coordinate
                    if tempCurrentLocation != nil {
                        self.selectLocation = tempCurrentLocation
                    }
                    else{
                        self.selectLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
                    }
                }
            }
            else{
                self.selectLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
            }
            print("what is selectLoication",self.selectLocation!)
            var Lat:String = String(Double((self.selectLocation?.latitude)!))
            var Long:String = String(Double((self.selectLocation?.longitude)!))
            dataSection3ReortGeoTag = Lat + "," + Long
        }
    }
    
    //Step 5 delegate
    func getArea(_ text: String , hintText : String)  {
        print("area here is",text)
        self.geoTagReportGeoTagTxt.text = text
//        lbl_totalAreHInt.textColor = .black
//        lbl_totalAreHInt.text = text
//        txt_getareaNEW.text = text
//        lbl_totalAreHInt.text = String(format: "(Area is %@ in acres)",hintText)
    }
    
    
    override func viewDidLoad() {
        hideKeyboardWhenTappedAround()
        super.viewDidLoad()
        self.iagUserIDTxt.keyboardType = .numberPad
        self.iagUserIDTxt.delegate = self
        self.sampleRequestCropTxt.delegate = self
        
        RetailerTopView.isHidden = true
        farmerTopView.isHidden = true
        PravtktaTopView.isHidden = true
        BigfarmerTopView.isHidden = true
        
        RetailerView.isHidden = true
        farmerView.isHidden = true
        PravtktaView.isHidden = true
        BigfarmerView.isHidden = true
        
        retailerEditView.isHidden = true
        farmerEditView.isHidden = true
        pravtktaEditView.isHidden = true
        bigFarmerEditView.isHidden = true
        
        editButton.isHidden = true

        print("selected list data",self.dataObj!)
        print("selected list data count",self.dataObj!.count)
        
        print("crop list data",self.getCropListArray!)
        print("hybrid list data",self.getHybridListArray!)

        self.moduleType = "Sample Tracking"
    
        
        
        self.stackHeightSetInitial()
        globaloDataLbl.isHidden = true
 
    
        self.sampleRequestNoBtn?.setImage(UIImage(named: "Radio"), for: .normal)
        self.sampleRequestYesBtn?.setImage(UIImage(named: "Radio"), for: .normal)
        self.sampleReportNoBtn?.setImage(UIImage(named: "Radio"), for: .normal)
        self.sampleReportYesBtn?.setImage(UIImage(named: "Radio"), for: .normal)
        self.harvestReportWillGrowNoBtn?.setImage(UIImage(named: "Radio"), for: .normal)
        self.harvestReportWillGrowYesBtn?.setImage(UIImage(named: "Radio"), for: .normal)
        self.harvestReportWillRecommendNoBtn?.setImage(UIImage(named: "Radio"), for: .normal)
        self.harvestReportWillRecommendYesBtn?.setImage(UIImage(named: "Radio"), for: .normal)
                
        self.geoTagImageView.setImage(UIImage(named: "PlaceHolderImage")!)
        
        ratingView?.delegate = self
        ratingView?.type = .wholeRatings
        ratingView?.minRating = 0
        
        //updateStarColors(for: ratingView, rating: Float(ratingView.rating))
        
        self.cropArray = getCropListArray!
        self.hybridArray = getHybridListArray!
        self.reportCropArray = getCropListArray!
        self.reportHybridArray = getHybridListArray!
        self.originalReportHybridArray = getHybridListArray!
  
        
        print("crop list data222",self.cropArray)
        print("hybrid list data333",self.hybridArray)
        
        //crop dropdown tableView
        self.loadDropDownTableView(tableViewDataSource: self, tableViewDelegate: self, tableview: cropDropDownTblView, textField: sampleRequestCropTxt)
        cropDropDownTblView.dataSource = self
        cropDropDownTblView.delegate = self
        
        //hybrid dropdown tableView
        self.loadDropDownTableView(tableViewDataSource: self, tableViewDelegate: self, tableview: hybridNameTblView, textField: sampleRequestHybridTxt)
        hybridNameTblView.dataSource = self
        hybridNameTblView.delegate = self
        
        
        //report crop dropdown tableView
        self.loadDropDownTableView(tableViewDataSource: self, tableViewDelegate: self, tableview: reportCropDropDownTblView, textField: sampleReportCropTxt)
        reportCropDropDownTblView.dataSource = self
        reportCropDropDownTblView.delegate = self
        
        //report hybrid dropdown tableView
        self.loadDropDownTableView(tableViewDataSource: self, tableViewDelegate: self, tableview: reportHybridNameTblView, textField: sampleReportHybridTxt)
        reportHybridNameTblView.dataSource = self
        reportHybridNameTblView.delegate = self
        
        //top fab dropdown tableView
        self.loadDropDownTableView(tableViewDataSource: self, tableViewDelegate: self, tableview: topFabTblView, textField: harvestReportTopFabTxt)
        topFabTblView.dataSource = self
        topFabTblView.delegate = self
        
    }
    func appendEditDataHere(){
        
                    statusIS = NSLocalizedString("newRequest", comment: "")
                    dataStatus = NSLocalizedString("sampleRequest", comment: "")
                    print("123***456***",self.statusIS )
                    print("123***456***789",self.dataStatus )
                    dataSection1Pravakta = ""
                    dataSection2Pravakta = ""
                    dataSection4HybridRating = 0.0
                    dataSection4WillGrow = ""
                    dataSection4WillRecommend = ""
        
                    getServerId = 0
        
            RetailerTopView.isHidden = false
            retailerEditView.isHidden = false

        retailerEditHeightConstraint.constant = 240
        RetailerTopImageView.image = UIImage(named: "downroundIcon")
        
        farmerTopView.isHidden = true
        PravtktaTopView.isHidden = true
        BigfarmerTopView.isHidden = true
        
        RetailerView.isHidden = true
        farmerView.isHidden = true
        PravtktaView.isHidden = true
        BigfarmerView.isHidden = true

        farmerEditView.isHidden = true
        pravtktaEditView.isHidden = true
        bigFarmerEditView.isHidden = true
            
            //self.dataStatus = NSLocalizedString("sampleReport", comment: "")
        
            iagUserIDTxt.text = self.dataObj?.value(forKey: "mdoMdrActualUserId") as? String
            dataSection1Pravakta = self.dataObj?.value(forKey: "isPravaktha") as! String
            sampleRequestCropTxt.text = self.dataObj?.value(forKey: "cropName") as? String
            sampleRequestHybridTxt.text = self.dataObj?.value(forKey: "hybridName") as? String
            hybridID = String(describing: self.dataObj!.value(forKey: "hybridId")!)
            cropID = String(describing: self.dataObj!.value(forKey: "cropId")!)
        if(dataSection1Pravakta == "Yes"){
            self.sampleRequestYesBtn?.setImage(UIImage(named: "SelectRadioBlue"), for: .normal)
            self.sampleRequestNoBtn?.setImage(UIImage(named: "Radio"), for: .normal)
        }
        else{
            self.sampleRequestNoBtn?.setImage(UIImage(named: "SelectRadioBlue"), for: .normal)
            self.sampleRequestYesBtn?.setImage(UIImage(named: "Radio"), for: .normal)
        }
        
    }
    func appendNewDataHere() {
        
        self.statusIS = NSLocalizedString("newRequest", comment: "")
        self.dataStatus = NSLocalizedString("sampleRequest", comment: "")
        print("123***456***",self.statusIS )
        
        self.dataSection1Pravakta = ""
        self.dataSection2Pravakta = ""
        self.dataSection4HybridRating = 0.0
        self.dataSection4WillGrow = ""
        self.dataSection4WillRecommend = ""
        
        self.stackHeightSetInitial()
        RetailerTopView.isHidden = false
        retailerEditView.isHidden = false
        retailerEditHeightConstraint.constant = 240
        RetailerTopImageView.image = UIImage(named: "downroundIcon")
        
        getServerId = 0

    }
    
    func appendDataHere(){
        print("123***",self.dataObj!)
        
        self.statusIS = self.dataObj?.value(forKey: "status") as! String
        print("123***456***",self.statusIS)
        
        getServerId = self.dataObj?.value(forKey: "serverId") as! Int
        print("123***456***999",self.getServerId)
        
        self.getTopFabListArray = dataObj!["top3Fablists"] as? NSArray
        print("topfab list data",self.getTopFabListArray!)
        self.topFabArray = getTopFabListArray!

        if(NSLocalizedString("sampleRequest", comment: "") == self.statusIS){
            RetailerTopView.isHidden = false
            farmerTopView.isHidden = false
            
            RetailerView.isHidden = false
            farmerEditView.isHidden = false
            
            editButton.isHidden = false
            
            RetailerHeightConstraint.constant = 130
            RetailerTopImageView.image = UIImage(named: "downroundIcon")
            
            farmerEditHeightConstraint.constant =  250 //heightConstant
            farmerTopImageView.image = UIImage(named: "downroundIcon")

            
            self.dataStatus = NSLocalizedString("sampleReport", comment: "")
            
            self.iagUserValueLbl.text = self.dataObj?.value(forKey: "mdoMdrActualUserId") as? String
            self.sampleRequestLbl1.text = self.dataObj?.value(forKey: "isPravaktha") as? String
            self.sampleRequestLbl2.text = self.dataObj?.value(forKey: "cropName") as? String
            self.sampleRequestLbl3.text = self.dataObj?.value(forKey: "hybridName") as? String
            
            iagUserIDTxt.text = self.dataObj?.value(forKey: "mdoMdrActualUserId") as? String
            dataSection1Pravakta = self.dataObj?.value(forKey: "isPravaktha") as! String
            sampleRequestCropTxt.text = self.dataObj?.value(forKey: "cropName") as? String
            sampleRequestHybridTxt.text = self.dataObj?.value(forKey: "hybridName") as? String
            hybridID = String(describing: self.dataObj!.value(forKey: "hybridId")!)
            cropID = String(describing: self.dataObj!.value(forKey: "cropId")!)
            
        }
        else if(NSLocalizedString("sampleReport", comment: "") == self.statusIS){
            RetailerTopView.isHidden = false
            farmerTopView.isHidden = false
            PravtktaTopView.isHidden = false
            
            RetailerView.isHidden = false
            farmerView.isHidden = false
            pravtktaEditView.isHidden = false
            
            RetailerHeightConstraint.constant = 130
            RetailerTopImageView.image = UIImage(named: "downroundIcon")
            
            farmerHeightConstraint.constant =  170 //heightConstant
            farmerTopImageView.image = UIImage(named: "downroundIcon")
            
            pravtktaEditHeightConstraint.constant =  330
            PravtktaTopImageView.image = UIImage(named: "downroundIcon")

        
            self.dataStatus = NSLocalizedString("geoTag", comment: "")
            
            self.iagUserValueLbl.text = self.dataObj?.value(forKey: "mdoMdrActualUserId") as? String
            self.sampleRequestLbl1.text = self.dataObj?.value(forKey: "isPravaktha") as? String
            self.sampleRequestLbl2.text = self.dataObj?.value(forKey: "cropName") as? String
            self.sampleRequestLbl3.text = self.dataObj?.value(forKey: "hybridName") as? String
            hybridID = String(describing: self.dataObj!.value(forKey: "hybridId")!)
            cropID = String(describing: self.dataObj!.value(forKey: "cropId")!)
            
      
            self.sampleReportLbl1.text = self.dataObj?.value(forKey: "sampleReceived") as? String
            self.sampleReportLbl2.text = self.dataObj?.value(forKey: "cropName") as? String
            self.sampleReportLbl3.text = self.dataObj?.value(forKey: "hybridName") as? String
            self.sampleReportLbl4.text = self.dataObj?.value(forKey: "sampleRecevingDate") as? String
            self.sampleReportLbl5.text = self.dataObj?.value(forKey: "productConfirmationKey") as? String
//            reportHybridID = String(describing: self.dataObj?.value(forKey: "reportHybridId")!)
//            reportCropID = String(describing: self.dataObj?.value(forKey: "reportCropId")!)
            
            iagUserIDTxt.text = self.dataObj?.value(forKey: "mdoMdrActualUserId") as? String
            dataSection1Pravakta = self.dataObj?.value(forKey: "isPravaktha") as! String
            sampleRequestCropTxt.text = self.dataObj?.value(forKey: "cropName") as? String
            sampleRequestHybridTxt.text = self.dataObj?.value(forKey: "hybridName") as? String
            
            dataSection2Pravakta = self.dataObj?.value(forKey: "sampleReceived") as! String
            sampleReportCropTxt.text = self.dataObj?.value(forKey: "cropName") as? String
            sampleReportHybridTxt.text = self.dataObj?.value(forKey: "hybridName") as? String
            sampleReceivingData.text = self.dataObj?.value(forKey: "sampleRecevingDate") as? String
            sampleReportProductConfirmationTxt.text = self.dataObj?.value(forKey: "productConfirmationKey") as? String
        }
        else if(NSLocalizedString("geoTag", comment: "") == self.statusIS){
            RetailerTopView.isHidden = false
            farmerTopView.isHidden = false
            PravtktaTopView.isHidden = false
            BigfarmerTopView.isHidden = false
            
                    RetailerView.isHidden = false
                    farmerView.isHidden = false
                    PravtktaView.isHidden = false
                    bigFarmerEditView.isHidden = false
            
            RetailerHeightConstraint.constant = 130
            RetailerTopImageView.image = UIImage(named: "downroundIcon")
            
            farmerHeightConstraint.constant =  170 //heightConstant
            farmerTopImageView.image = UIImage(named: "downroundIcon")
            
            PravtktaHeightConstraint.constant =  260
            PravtktaTopImageView.image = UIImage(named: "downroundIcon")
            
            bigfarmerEditHeightConstraint.constant = 500
            BigfarmerTopImageView.image = UIImage(named: "downroundIcon")
            
            
            self.dataStatus = NSLocalizedString("performanceReport", comment: "")
            
            self.iagUserValueLbl.text = self.dataObj?.value(forKey: "mdoMdrActualUserId") as? String
            self.sampleRequestLbl1.text = self.dataObj?.value(forKey: "isPravaktha") as? String
            self.sampleRequestLbl2.text = self.dataObj?.value(forKey: "cropName") as? String
            self.sampleRequestLbl3.text = self.dataObj?.value(forKey: "hybridName") as? String
            hybridID = String(describing: self.dataObj!.value(forKey: "hybridId")!)
            cropID = String(describing: self.dataObj!.value(forKey: "cropId")!)
            
            self.sampleReportLbl1.text = self.dataObj?.value(forKey: "sampleReceived") as? String
            self.sampleReportLbl2.text = self.dataObj?.value(forKey: "cropName") as? String
            self.sampleReportLbl3.text = self.dataObj?.value(forKey: "hybridName") as? String
            self.sampleReportLbl4.text = self.dataObj?.value(forKey: "sampleRecevingDate") as? String
            self.sampleReportLbl5.text = self.dataObj?.value(forKey: "productConfirmationKey") as? String
            
            self.geoTagLbl1.text = self.dataObj?.value(forKey: "dateOfShowing") as? String
            self.geoTagLbl2.text = self.dataObj?.value(forKey: "geoTAg") as? String

            print("what image is coming",self.dataObj?.value(forKey: "cropUploadImage")! ?? "")
            let productImgURL = self.dataObj?.value(forKey: "cropUploadImage") as? String
            self.ImageNameSending = self.dataObj?.value(forKey: "cropUploadImage") as! String

            if productImgURL != "" {
                DispatchQueue.main.async {
                    if productImgURL!.hasPrefix("http") || productImgURL!.hasPrefix("https") {
                        let imageUrl = URL(string: productImgURL!)
                        self.geoTagImg?.kf.setImage(with: imageUrl! as Resource, placeholder: UIImage(named: "image_placeholder.png"), options: nil, progressBlock: nil)
                    }
                    else{
                        self.geoTagImg.image = UIImage(named: "image_placeholder")
                    }
                }
            }
            
            iagUserIDTxt.text = self.dataObj?.value(forKey: "mdoMdrActualUserId") as? String
            dataSection1Pravakta = self.dataObj?.value(forKey: "isPravaktha") as! String
            sampleRequestCropTxt.text = self.dataObj?.value(forKey: "cropName") as? String
            sampleRequestHybridTxt.text = self.dataObj?.value(forKey: "hybridName") as? String
            
            dataSection2Pravakta = self.dataObj?.value(forKey: "sampleReceived") as! String
            sampleReportCropTxt.text = self.dataObj?.value(forKey: "cropName") as? String
            sampleReportHybridTxt.text = self.dataObj?.value(forKey: "hybridName") as? String
            sampleReceivingData.text = self.dataObj?.value(forKey: "sampleRecevingDate") as? String
            sampleReportProductConfirmationTxt.text = self.dataObj?.value(forKey: "productConfirmationKey") as? String
            
            geoTagReportDateTxt.text = self.dataObj?.value(forKey: "dateOfShowing") as? String
            geoTagReportGeoTagTxt.text = self.dataObj?.value(forKey: "geoTAg") as? String
            
        }
        else if(NSLocalizedString("performanceReport", comment: "") == self.statusIS){
            RetailerTopView.isHidden = false
            farmerTopView.isHidden = false
            PravtktaTopView.isHidden = false
            BigfarmerTopView.isHidden = false
            
            
            RetailerView.isHidden = false
            farmerView.isHidden = false
            PravtktaView.isHidden = false
            BigfarmerView.isHidden = false
    
    RetailerHeightConstraint.constant = 130
    RetailerTopImageView.image = UIImage(named: "downroundIcon")
    
    farmerHeightConstraint.constant =  170 //heightConstant
    farmerTopImageView.image = UIImage(named: "downroundIcon")
    
    PravtktaHeightConstraint.constant =  260
    PravtktaTopImageView.image = UIImage(named: "downroundIcon")
    
    BigfarmerHeightConstraint.constant = 250
    BigfarmerTopImageView.image = UIImage(named: "downroundIcon")
            
            self.dataStatus = "Finish"
            
            self.iagUserValueLbl.text = self.dataObj?.value(forKey: "mdoMdrActualUserId") as? String
            self.sampleRequestLbl1.text = self.dataObj?.value(forKey: "isPravaktha") as? String
            self.sampleRequestLbl2.text = self.dataObj?.value(forKey: "cropName") as? String
            self.sampleRequestLbl3.text = self.dataObj?.value(forKey: "hybridName") as? String
            hybridID = String(describing: self.dataObj!.value(forKey: "hybridId")!)
            cropID = String(describing: self.dataObj!.value(forKey: "cropId")!)
            
            self.sampleReportLbl1.text = self.dataObj?.value(forKey: "sampleReceived") as? String
            self.sampleReportLbl2.text = self.dataObj?.value(forKey: "cropName") as? String
            self.sampleReportLbl3.text = self.dataObj?.value(forKey: "hybridName") as? String
            self.sampleReportLbl4.text = self.dataObj?.value(forKey: "sampleRecevingDate") as? String
            self.sampleReportLbl5.text = self.dataObj?.value(forKey: "productConfirmationKey") as? String
            self.geoTagLbl1.text = self.dataObj?.value(forKey: "dateOfShowing") as? String
            self.geoTagLbl2.text = self.dataObj?.value(forKey: "geoTAg") as? String
            print("what image is coming",self.dataObj?.value(forKey: "cropUploadImage")! ?? "")
            let productImgURL = self.dataObj?.value(forKey: "cropUploadImage") as? String
            self.ImageNameSending = self.dataObj?.value(forKey: "cropUploadImage") as! String

            self.harvestReportLbl1.text = self.dataObj?.value(forKey: "dateOfHarvesting") as? String
            self.harvestReportLbl2.text = self.dataObj?.value(forKey: "yieldPerAcre") as? String
            self.harvestReportLbl3.text = self.dataObj?.value(forKey: "pricePerQt") as? String
            self.harvestReportLbl4.text = self.dataObj?.value(forKey: "rating") as? String
            self.harvestReportLbl5.text = self.dataObj?.value(forKey: "top3FabSelection") as? String
            self.harvestReportLbl6.text = self.dataObj?.value(forKey: "growNextYear") as? String
            self.harvestReportLbl7.text = self.dataObj?.value(forKey: "recommendedToOthers") as? String
            
            if productImgURL != "" {
                DispatchQueue.main.async {
                    if productImgURL!.hasPrefix("http") || productImgURL!.hasPrefix("https") {
                        let imageUrl = URL(string: productImgURL!)
                        self.geoTagImg?.kf.setImage(with: imageUrl! as Resource, placeholder: UIImage(named: "image_placeholder.png"), options: nil, progressBlock: nil)
                    }
                    else{
                        self.geoTagImg.image = UIImage(named: "image_placeholder")
                    }
                }
            }
            
        }
    }
    
    func stackHeightSetInitial(){
        RetailerHeightConstraint.constant  = 0
        farmerHeightConstraint.constant    = 0
        PravtktaHeightConstraint.constant  = 0
        BigfarmerHeightConstraint.constant = 0
        
        retailerEditHeightConstraint.constant  = 0
        farmerEditHeightConstraint.constant    = 0
        pravtktaEditHeightConstraint.constant  = 0
        bigfarmerEditHeightConstraint.constant = 0
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.iagInfoLbl.isHidden = true
        if(self.dataObj?.count == 0){
            self.appendNewDataHere()
        }else{
            self.appendDataHere()
        }
    
        
        super.viewWillAppear(true)
        self.topView?.isHidden = false
        self.lblTitle?.text = NSLocalizedString("sampleTracking", comment: "")
        self.setStatusBarBackgroundColor(color :App_Theme_Blue_Color)
        self.topView?.backgroundColor = App_Theme_Blue_Color
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        
        self.geoTagUploadCropImgBtn.setTitle("", for: .normal)
        self.editButton.setTitle("", for: .normal)
        
        
        if(self.dataStatus == "Finish"){
            submitBtn.isHidden = true
        }

    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.topView?.isHidden = true
    }
    
    
//    func openAcvission(){
        ///Note: Make sure correct values are present in Acviss-Credentials.plist
        ///Acvission Integration: Step 2: Instantiate VisionViewController from Acvission
        ///
//        let userObj = Constatnts.getUserObject()
//        let userId = userObj.customerId as! String
//        let mobileNum = userObj.mobileNumber! as String
//        let usr =  AcvissCoreCertify.User.init(
//                        linkedId: userId,
//                        token: "",
//                        mobile:(countryCode: "", number: mobileNum),
//                        fullName: "",
//                        email: ""
//                    )
//        let regularExpression = ["^([hH]{1}[tT]{2}[pP]{1}[sS]{1}:\\/\\/[cC]{1}[oO]{1}[iI]{1}[dD]{1}.[iI]{1}[nN]{1}\\/)","https:\\/\\/roots-cpm.ecubix.com\\/?.*","http:\\/\\/6\\.ivcs\\.ai\\/?.*"]
//        let acvission_configuration = Acvission.Configuration.init(
//            environment: .Production,
//            language: .English,
//            user: usr,
//            mode: Acvission.ScannerMode.Default,
//            regex: regularExpression,
//            scanMultiple: false,
//            enableCustomerSupportButton: true,
//            //type: Acvission.ScannerMode.OnlyVerify,
//            enableReportInvalid: false,
//            enableAudioInstructions: false,
//            enableBlurredFocus: true,
//            enableBackButton: false
//        )
//        Acvission.shared.instantiate(
//            with: acvission_configuration,
//            over: self,
//            style: .Show,
//            delegate: self
//        )
//    }
//    func onVerificationCompletion(raw: [String : Any], responseCode: ResponseCodeShared) {
//        print(" onVericationCompletion33: ==>")
//       // print(result as Any)
//        
//        if statusMsgAlert != nil{
//            self.statusMsgAlert?.removeFromSuperview()
//        }
//    
//        if raw != nil{
//            
//            let rawResult = raw as Dictionary
//            var message = ""
//            var ststusLogo = UIImage(named: "GenuinityFailure")
//            let userObj = Constatnts.getUserObject()
//            
//            let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!, USER_ID:userObj.customerId!, Genunity_Status_Code:responseCode.rawValue, Product_Deatils:rawResult["product_details"] ?? "",Serial_Number:rawResult["serial_number"] ?? ""] as [String : Any]
//            
//            if responseCode.rawValue == Genunity_Status_Code_100{
//
//            }
//            else if responseCode.rawValue == Genunity_Status_Code_101 || responseCode.rawValue as? Int == Genunity_Status_Code_102{
//
//            }
//            else if responseCode.rawValue == Genunity_Status_Code_103{
//
//            }
//            else if responseCode.rawValue == Genunity_Status_Code_104{ //External
//
//            }
//            else if responseCode.rawValue == Genunity_Status_Code_105 { //AttemptsError
//
//            }
//            else{
//                message = rawResult["message"] as? String ?? ""
//            }
//            
//            let paramsStr = try! JSONSerialization.data(withJSONObject: rawResult["data"] ?? "", options: .prettyPrinted)
//            
//            let jsonString = NSString(data: paramsStr, encoding: String.Encoding.utf8.rawValue)! as String
//            print("String result12    \(jsonString)")
//            
//        
//            Singleton.submitScannedAcvissBarcodeResultDataToServerNewSampleTracking(scanResult: raw as Dictionary, completeResponse: jsonString, selectedLabel: "", moduleType: self.moduleType, responseCode: responseCode.rawValue) { (status, responseDictionary, statusMessage) in
//            
//                if status == true{
//                    self.dictEncashResponse = NSDictionary()
//                    print(responseDictionary)
//                    
//                    self.dictEncashResponse = responseDictionary ?? NSDictionary()
//                    self.scanResponseAcviss = responseDictionary ?? NSDictionary()
//                    
//                }else{
//                    self.view.makeToast(statusMessage ?? "Oops! Some thing went wrong. Please try again.")
//                }
//            }
//        }
//    }
    
    ///Only detected code's value for Generic or Regex Match
//    func onDetectionOfExemptedCode(_ exemptedCodeDetails: ExemptedCode) {
//        
//        if statusMsgAlert != nil{
//            self.statusMsgAlert?.removeFromSuperview()
//        }
//        let regularExpression = ["^([hH]{1}[tT]{2}[pP]{1}[sS]{1}:\\/\\/[cC]{1}[oO]{1}[iI]{1}[dD]{1}.[iI]{1}[nN]{1}\\/)","https:\\/\\/roots-cpm.ecubix.com\\/?.*","http:\\/\\/6\\.ivcs\\.ai\\/?.*"]
//        let checkForRegexMatch = regularExpression.filter{$0 == exemptedCodeDetails.matchedRegEx}
//        if checkForRegexMatch.count > 0{
//            let parameters = ["barCodeScannedValue":exemptedCodeDetails.barCodeScannedValue,"matchedRegEx":exemptedCodeDetails.matchedRegEx,"message":exemptedCodeDetails.message]
//            let scanResult = parameters as Dictionary
//            self.saveScanResult = parameters as Dictionary
//            let paramsStr = try! JSONSerialization.data(withJSONObject: scanResult, options: .prettyPrinted)
//            let jsonString = NSString(data: paramsStr, encoding: String.Encoding.utf8.rawValue)! as String
//            self.saveJsonString = NSString(data: paramsStr, encoding: String.Encoding.utf8.rawValue)! as String
//            NSLog("the acviss jsonString RESPONSE:", jsonString)
//            DispatchQueue.main.async {
//               // self.navigationController?.popViewController(animated: true)
//            }
//            Singleton.submitScannedAcvissBarcodeResultDataToServerNewSampleTracking(scanResult: scanResult as Dictionary, completeResponse: jsonString, selectedLabel: "", moduleType: self.moduleType, responseCode: 0) { (status, responseDictionary, statusMessage) in
//               // NSLog("the acviss Resp:", jsonString)
//                if status == true{
//                    self.dictEncashResponse = NSDictionary()
//                    self.dictEncashResponse = responseDictionary ?? NSDictionary()
//                    self.scanResponseAcviss = responseDictionary ?? NSDictionary()
//        
//                    self.sampleReportProductConfirmationTxt.text = self.dictEncashResponse?.value(forKey: "prodSerialNumber") as? String
//                    
//                }else{
//                    self.view.makeToast(statusMessage ?? "Oops! Some thing went wrong. Please try again.")
//                }
//            }
//        }
//    }
    
    ///Multiple Scans
//    func onVerificationCompletion(results: [(model: LabelData?, raw: [String : Any])]) {
//        print("onVerificationCompletion:===>")
//    }
 
    //MARK: - Empover Scanner
    func openEmpoverScanner(){
        let regexPatterns = [
            "^([hH]{1}[tT]{2}[pP]{1}[sS]{1}:\\/\\/[cC]{1}[oO]{1}[iI]{1}[dD]{1}\\.[iI]{1}[nN]{1}\\/)",
            "^([hH]{1}[tT]{2}[pP]{1}[sS]{1}:\\/\\/[uU]{1}[aA]{1}[tT]{1}\\.[fF]{1}[aA]{1}[rR]{1}[mM]{1}[eE]{1}[rR]{1}[cC]{1}[oO]{1}[nN]{2}[eE]{1}[cC]{1}[tT]{1}\\.[iI]{1}[nN]{1}\\/)",
            "^([hH]{1}[tT]{2}[pP]{1}[sS]{1}:\\/\\/[fF]{1}[aA]{1}[rR]{1}[mM]{1}[eE]{1}[rR]{1}[cC]{1}[oO]{1}[nN]{2}[eE]{1}[cC]{1}[tT]{1}\\.[iI]{1}[nN]{1}\\/)",
            "^[A-Z0-9]{8}$",
            "^www\\.checko\\.ai\\/\\?i=[A-Z0-9]{8}$",
            "^([a-zA-Z0-9]*)_[0-9]{10}_[a-z0-9A-Z]*_[0-9]*",
            "https:\\/\\/roots-cpm\\.ecubix\\.com\\/?.*",
            "http:\\/\\/6\\.ivcs\\.ai\\/?.*",
            "^sv1[A-Za-z0-9]{21,22}$",
            "^[A-Za-z]v1.*$",
            "(?i)^[A-Z0-9].*"
        ]
        let userObj = Constatnts.getUserObject()
        let userId = userObj.customerId! as String
        let mobileNum = userObj.mobileNumber! as String
        
        let getUserID = userId
        var getAuthId = ""
        var getToken = ""
        var getProjectId = ""
        var getEnvironment: ScannerConfiguration.Environment = .test
        var getProjectName = ""
        var getLanguage = ""
        
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        if BASE_URL == "https://pioneeractivity.com/rest/" {
            print("Its is PROD")
         getAuthId = "TYC67PL25OKMINBVCXS"
         getToken = "QAZCWSX25EDCIRFV12TGB45YHNUJMKLOPIUYTREWQASDFGH"
         getProjectId = "com.pioneer.india.directsales"
         getEnvironment = .production
         getProjectName = "Corteva Farmer Connect"
         getLanguage = "en"
        }
        else{
            print("Its is UAT")
         getAuthId = "ABCDE125FGHIJKLMN"
         getToken = "XQZCRTY25PLMINW8947ASD12KQWERTYUXMNBVCXZPOIUYTRE"
         getProjectId = "PROJ1004"
         getEnvironment = .test
         getProjectName = "Farmer Connect"
         getLanguage = "en"

        }
        print("getUserID iss: \(getUserID)")
         

        let user = ScannerUser(linkedId: getUserID, authId: getAuthId, token: getToken, fullName: "", email: "", deviceType: "IOS", projectId: getProjectId, projectName: getProjectName, userId: getUserID, mobileNumber: mobileNum)
        
        let config = ScannerConfiguration(regexPatterns: regexPatterns, environment: getEnvironment, user: user, scanMultiple: false, scannerType: "DEFAULT", referralCode: "", language: getLanguage)
        
        let scannerVC = ScannerViewController(config: config, delegate: self) // 'self' must conform to CameraScannerDelegate
        scannerVC.modalPresentationStyle = .fullScreen
        present(scannerVC, animated: true, completion: nil)
    }
    func didDetectQRCode(_ code: String) {
        print("Empover Scanner Detected QR Code: \(code)")
    }
    
    func didFailWithError(_ error: any Error) {
        print("Empover Scanner Error: \(error.localizedDescription)")
    }
    
    func didTapBackButton() {
        scannerView?.stopScanning()
        scannerView?.removeFromSuperview()
        scannerView = nil
        dismiss(animated: true)
    }
    
    func didReceiveAPIResponse(_ response: [String : Any]) {
        print("API Response: \(response)")
        scannerView?.stopScanning()
        DispatchQueue.main.async {
            let exemptedCodeDetails = response["exemptedCode"] as? EmpoverCameraScannerSDK.ExemptedCode
            print("Scanned value:", exemptedCodeDetails!.message)
            print("Scanned matchedRegEx value:", exemptedCodeDetails!.matchedRegEx)
            self.scannerView?.stopScanning()
            self.scannerView?.removeFromSuperview()
            self.scannerView = nil
            self.dismiss(animated: true)
            
            if self.statusMsgAlert != nil{
                        self.statusMsgAlert?.removeFromSuperview()
                    }
                    let regularExpression = [
                        "^([hH]{1}[tT]{2}[pP]{1}[sS]{1}:\\/\\/[cC]{1}[oO]{1}[iI]{1}[dD]{1}\\.[iI]{1}[nN]{1}\\/)",
                                                  "^([hH]{1}[tT]{2}[pP]{1}[sS]{1}:\\/\\/[uU]{1}[aA]{1}[tT]{1}\\.[fF]{1}[aA]{1}[rR]{1}[mM]{1}[eE]{1}[rR]{1}[cC]{1}[oO]{1}[nN]{2}[eE]{1}[cC]{1}[tT]{1}\\.[iI]{1}[nN]{1}\\/)",
                                                  "^([hH]{1}[tT]{2}[pP]{1}[sS]{1}:\\/\\/[fF]{1}[aA]{1}[rR]{1}[mM]{1}[eE]{1}[rR]{1}[cC]{1}[oO]{1}[nN]{2}[eE]{1}[cC]{1}[tT]{1}\\.[iI]{1}[nN]{1}\\/)",
                                                  "^[A-Z0-9]{8}$",
                                                  "^www\\.checko\\.ai\\/\\?i=[A-Z0-9]{8}$",
                                                  "^([a-zA-Z0-9]*)_[0-9]{10}_[a-z0-9A-Z]*_[0-9]*",
                                                  "https:\\/\\/roots-cpm\\.ecubix\\.com\\/?.*",
                                                  "http:\\/\\/6\\.ivcs\\.ai\\/?.*",
                                                  "^sv1[A-Za-z0-9]{21,22}$",
                                                  "^[A-Za-z]v1.*$",
                                                  "(?i)^[A-Z0-9].*"
                    ]
//            let server = exemptedCodeDetails?.matchedRegEx ?? ""
//            let checkForRegexMatch = regularExpression.filter {
//                $0.replacingOccurrences(of: "\\.", with: ".") == server.replacingOccurrences(of: "\\.", with: ".")
//            }
                  //  if checkForRegexMatch.count > 0{
                        let parameters = ["barCodeScannedValue":exemptedCodeDetails!.barCodeScannedValue,"matchedRegEx":exemptedCodeDetails!.matchedRegEx,"message":exemptedCodeDetails!.message]
                        let scanResult = parameters as Dictionary
                        self.saveScanResult = parameters as Dictionary
                        let paramsStr = try! JSONSerialization.data(withJSONObject: scanResult, options: .prettyPrinted)
                        let jsonString = NSString(data: paramsStr, encoding: String.Encoding.utf8.rawValue)! as String
                        self.saveJsonString = NSString(data: paramsStr, encoding: String.Encoding.utf8.rawValue)! as String
                        NSLog("the acviss jsonString RESPONSE:", jsonString)
                        DispatchQueue.main.async {
                           // self.navigationController?.popViewController(animated: true)
                        }
                        Singleton.submitScannedAcvissBarcodeResultDataToServerNewSampleTracking(scanResult: scanResult as Dictionary, completeResponse: jsonString, selectedLabel: "", moduleType: self.moduleType, responseCode: 0) { (status, responseDictionary, statusMessage) in
                           // NSLog("the acviss Resp:", jsonString)
                            if status == true{
                                self.dictEncashResponse = NSDictionary()
                                self.dictEncashResponse = responseDictionary ?? NSDictionary()
                                self.scanResponseAcviss = responseDictionary ?? NSDictionary()
            
                                self.sampleReportProductConfirmationTxt.text = self.dictEncashResponse?.value(forKey: "prodSerialNumber") as? String
            
                            }else{
                                self.view.makeToast(statusMessage ?? "Oops! Some thing went wrong. Please try again.")
                            }
                        }
                    //}
                }
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        //liveLabel.text = String(format: "%.2f", self.floatRatingView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        
        if self.ratingView!.rating >= Double(1.0) && self.ratingView!.rating <= Double(3.9) {
            self.ratingView?.fullImage = UIImage(named: "StarRed")
            dataSection4HybridRating = self.ratingView!.rating
        }else if self.ratingView!.rating >= Double(4.0) && self.ratingView!.rating <= Double(7.9) {
            self.ratingView?.fullImage = UIImage(named: "StarOrange")
            dataSection4HybridRating = self.ratingView!.rating
        }else if self.ratingView!.rating >= Double(8.0) {
            self.ratingView?.fullImage = UIImage(named: "StarGreen")
            dataSection4HybridRating = self.ratingView!.rating
        }
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
        
        if let image_data = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedCropImage = image_data
        }

        if Reachability.isConnectedToNetwork(){
            if let image_data = info[UIImagePickerControllerEditedImage] as? UIImage {
                selectedCropImage = image_data

                self.geoTagImageView.setImage(self.selectedCropImage)
                let currentTime = Constatnts.getCurrentMillis()
                let imgFileName = String(currentTime).replacingOccurrences(of: "-", with: "")
                self.ImageNameSending = String(format:"%@.jpg",imgFileName)
                
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
                self.selectedImageData = UIImagePNGRepresentation(resizedImg!)!
                let imageStr = imageData.base64EncodedString()
                
            }
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                dismiss(animated: false) { [self] in
                    self.selectedCropImage = image
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
        self.dismiss(animated: true, completion: nil)
    }
    
    func openCalender(fromSection: String){
        self.fromDatePickerView(fromSection: fromSection)
    }

    func fromDatePickerView(fromSection: String){
        let Height:CGFloat = (44.11 * self.view.frame.height/120)
        let width :CGFloat = self.view.frame.size.width-40 //-40
        let posX :CGFloat = (self.view.frame.size.width - width) / 2
        
        fromDateView = UIView (frame: CGRect(x: posX,y: (self.view.frame.height-Height)/2 ,width: width,height: Height))
        fromDateView?.backgroundColor = UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        fromDateView?.layer.cornerRadius = 10.0
        self.view.backgroundColor = UIColor.lightGray
        self.view.alpha = 0.7
        self.view.addSubview(fromDateView!)
        let dobPicker : UIDatePicker = UIDatePicker (frame: CGRect(x: 5,y: 5,width: width-10,height: Height-50))
        dobPicker.backgroundColor = UIColor.white
        dobPicker.layer.cornerRadius = 5.0
        dobPicker.datePickerMode = UIDatePickerMode.date
        dobPicker.maximumDate = NSDate() as Date
        
        if(self.dataStatus == NSLocalizedString("geoTag", comment: "")){
            if(sampleReceivingData.text != ""){
                let dateFormatter1: DateFormatter = DateFormatter()
                dateFormatter1.dateFormat = "dd-MMM-yyyy"
                let minDate = dateFormatter1.date(from: sampleReceivingData.text!)
                dateFormatter1.dateFormat = "yyyy-MM-dd"
                let str = dateFormatter1.string(from: minDate!)
                dobPicker.minimumDate = dateFormatter1.date(from: str)//NSDate() as Date
            }
        }
        else{
                    let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
                    calendar.timeZone = NSTimeZone(name: "UTC")! as TimeZone
                    let components: NSDateComponents = NSDateComponents()
                    components.calendar = calendar as Calendar
                    let minDate: NSDate = calendar.date(byAdding: components as DateComponents, to: Date(), options: NSCalendar.Options(rawValue: 0))! as NSDate
                    print("minDate: \(minDate)")

        }
        

        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let  curDate  = Date()
        
        
//
        self.originalSelectedDate = fromSection as String

        let dateToSetStr = dateFormatter.string(from: curDate)
        dobPicker.date = dateFormatter.date(from: dateToSetStr)!

        if(self.originalSelectedDate == NSLocalizedString("sampleReport", comment: "")){
            self.sampleReceivingData.text = dateToSetStr as String
        }
        else if(self.originalSelectedDate == NSLocalizedString("geoTag", comment: "")){
            self.geoTagReportDateTxt.text = dateToSetStr as String
        }
        else if(self.originalSelectedDate == NSLocalizedString("performanceReport", comment: "")){
            self.harvestReportDateOfHarvestingTxt.text = dateToSetStr as String
        }
        dobPicker.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: .valueChanged)
        
        fromDateView?.addSubview(dobPicker)
        
        let btnOK : UIButton = UIButton (frame: CGRect(x: 0, y: dobPicker.frame.maxY+5,width: width,height: 40))
        btnOK.backgroundColor = UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 0.8)
        btnOK.layer.cornerRadius = 5.0
        btnOK.setTitle("OK", for: UIControlState())
        btnOK.addTarget(self, action: #selector(SampleTrackingDetailsViewController.alertOK), for: UIControlEvents.touchUpInside)
        fromDateView?.addSubview(btnOK)
        
        let dobFrame = fromDateView?.frame
        fromDateView?.frame.size.height = btnOK.frame.maxY
        fromDateView?.frame = dobFrame!
        
        fromDateView?.frame.origin.y = (self.view.frame.size.height - 64 - (fromDateView?.frame.size.height)!) / 2
        fromDateView?.frame = dobFrame!
    }
    
    func getLocationDetails(){
                let userObj = Constatnts.getUserObject()
                let attributedString = NSAttributedString(string: NSLocalizedString("choose_option", comment: ""), attributes: [
                    NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20),
                    NSAttributedStringKey.foregroundColor : UIColor.orange
                ])
                alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
                alertController.setValue(attributedString, forKey: "attributedMessage")
                let currentLocationButton = UIAlertAction(title: "Current Location", style: .default, handler: { (action) -> Void in
                    print("Current Loc button tapped")
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        self.getCurrentLocation()
                    }
                    else{
                        print("not compatible")
                    }
                })
        
                let  walkButton = UIAlertAction(title: NSLocalizedString("Walk Through", comment: ""), style: .default, handler: { (action) -> Void in
                    print("Walk button tapped")
                    self.getWalkLocationMap()
                })
                let  cancelButton = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (action) -> Void in
                    print("Cancel button tapped")
                })
                alertController.addAction(currentLocationButton)
                alertController.addAction(walkButton)
                alertController.addAction(cancelButton)
                self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SampleTrackingListViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc override func dismissKeyboard() {
        view.endEditing(true)
     }
    
    func getCurrentLocation(){
        currentLocation = LocationService.sharedInstance.currentLocation?.coordinate
//        if self.selectLocation == nil{
            if Validations.checkUserEnabledLocationServiceOrNot(viewController: self as UIViewController,showAlert: true) == true{
                if LocationService.sharedInstance.currentLocation?.coordinate != nil{
                    let tempCurrentLocation = LocationService.sharedInstance.currentLocation?.coordinate
                    if tempCurrentLocation != nil {
                        self.selectLocation = tempCurrentLocation
                    }
                    else{
                        self.selectLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
                    }
                }
//            }
//            else{
//                self.selectLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
//            }
            print("what is selectLoication",self.selectLocation!)
//            Double((self.selectLocation?.latitude)!)
//            Double((self.selectLocation?.longitude)!)
            var Lat:String = String(Double((self.selectLocation?.latitude)!))
            var Long:String = String(Double((self.selectLocation?.longitude)!))
            self.geoTagReportGeoTagTxt.text = Lat + "," + Long
            dataSection3ReortGeoTag = Lat + "," + Long
        }
    }
    func getWalkLocationMap(){
        let fawVC = self.storyboard?.instantiateViewController(withIdentifier: "FAW_FieldBoundaryViewController") as? FAW_FieldBoundaryViewController
        fawVC?.areaViewObjSample = self
        fawVC?.delegate = self
        self.navigationController?.pushViewController(fawVC!, animated: true)
    }

    
    //MARK:- datePickerValueChanged
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let selectedDate = dateFormatter.string(from: sender.date) as NSString
        //print("Selected value \(selectedDate)")
        
        if(self.originalSelectedDate == NSLocalizedString("sampleReport", comment: "")){
            self.sampleReceivingData.text = selectedDate as String
        }
        else if(self.originalSelectedDate == NSLocalizedString("geoTag", comment: "")){
            self.geoTagReportDateTxt.text = selectedDate as String
        }
        else if(self.originalSelectedDate == NSLocalizedString("performanceReport", comment: "")){
            self.harvestReportDateOfHarvestingTxt.text = selectedDate as String
        }
        
        self.view.isUserInteractionEnabled = true
        self.fromDateView?.removeFromSuperview()
        
    }
    
    //REMOVE SOWING PICKER VIEW
    @objc func alertOK(){
          self.view.isUserInteractionEnabled = true
        self.fromDateView?.removeFromSuperview()
    }
    
    
    //MARK: GrowingTextView Delagate Methods
    
    //MARK: UITextField Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == iagUserIDTxt{
            //iagUserIDTxt.resignFirstResponder()
            print("its 00")
            view.endEditing(true)
            self.RetailerView.endEditing(true)
            self.retailerEditView.endEditing(true)
            self.sampleRequestCropTxt.becomeFirstResponder()
        }
         if textField == sampleRequestCropTxt {
            cropDropDownTblView.isHidden = true
        }
        else if textField == sampleRequestHybridTxt {
            hybridNameTblView.isHidden = true
        }
        else if textField == sampleReportCropTxt {
            reportCropDropDownTblView.isHidden = true
        }
        else if textField == sampleReportHybridTxt {
            reportHybridNameTblView.isHidden = true
        }
        else if textField == sampleReceivingData {

        }
        else if textField == sampleReportProductConfirmationTxt {

        }
        else if textField == harvestReportTopFabTxt {
            topFabTblView.isHidden = true
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == sampleRequestCropTxt {
            self.view.endEditing(true)
            self.RetailerView.endEditing(true)
            self.retailerEditView.endEditing(true)
                self.sampleRequestCropTxt.resignFirstResponder()
                self.cropDropDownTblView.isHidden = false
                self.hybridNameTblView.isHidden = true
       }
       else if textField == sampleRequestHybridTxt {
           self.RetailerView.endEditing(true)
           self.retailerEditView.endEditing(true)
               self.sampleRequestHybridTxt.resignFirstResponder()
               self.hybridNameTblView.isHidden = false
               self.cropDropDownTblView.isHidden = true
       }
        else if textField == sampleReportCropTxt {
            sampleReportCropTxt.resignFirstResponder()
           reportCropDropDownTblView.isHidden = false
           reportHybridNameTblView.isHidden = true
       }
       else if textField == sampleReportHybridTxt {
           sampleReportHybridTxt.resignFirstResponder()
           reportHybridNameTblView.isHidden = false
           reportCropDropDownTblView.isHidden = true
       }
        else if textField == sampleReceivingData {
            sampleReceivingData.resignFirstResponder()
            self.openCalender(fromSection: NSLocalizedString("sampleReport", comment: ""))
        }
        else if textField == sampleReportProductConfirmationTxt {
           // sampleReportProductConfirmationTxt.resignFirstResponder()
        }
        else if textField == geoTagReportDateTxt {
            geoTagReportDateTxt.resignFirstResponder()
            self.openCalender(fromSection: NSLocalizedString("geoTag", comment: ""))
        }
        else if textField == geoTagReportGeoTagTxt{
            geoTagReportGeoTagTxt.resignFirstResponder()
            self.getLocationDetails()
        }
        else if textField == harvestReportDateOfHarvestingTxt {
            harvestReportDateOfHarvestingTxt.resignFirstResponder()
            self.openCalender(fromSection: NSLocalizedString("performanceReport", comment: ""))
        }
        else if textField == harvestReportTopFabTxt {
            harvestReportTopFabTxt.resignFirstResponder()
            topFabTblView.isHidden = false
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == iagUserIDTxt{
            print("its 0")
            view.endEditing(true)
            self.RetailerView.endEditing(true)
            self.retailerEditView.endEditing(true)
        }
        if textField == sampleRequestCropTxt{
            print("its 1")
            view.endEditing(true)
            self.RetailerView.endEditing(true)
            self.retailerEditView.endEditing(true)

        }
        else if textField == sampleRequestHybridTxt{
            print("its 2")
            view.endEditing(true)
            self.RetailerView.endEditing(true)
            self.retailerEditView.endEditing(true)

        }
        else if textField == sampleReportCropTxt{
            print("its 3")

        }
        else if textField == sampleReportHybridTxt{
            print("its 4")

        }
        else if textField == sampleReceivingData{
            print("its 5")

        }
        else if textField == sampleReportProductConfirmationTxt{
            print("its 6")

        }
        else if textField == harvestReportTopFabTxt{
            print("its 7")

        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.iagUserIDTxt{
        let maxLength = 8
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString

        return newString.length <= maxLength
        }
        else if textField == self.harvestReportYieldTxt{
        let maxLength = 5
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString

        return newString.length <= maxLength
        }
        else if textField == self.harvestReportMandiTxt{
        let maxLength = 10
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString

        return newString.length <= maxLength
        }

        return true
    }

    
    @IBAction func statutoryActionArrow(_ sender: Any) {
        //self.stackHeightSetInitial()
        switch (sender as AnyObject).tag {
        case 100:
            if(NSLocalizedString("sampleRequest", comment: "") == self.statusIS || NSLocalizedString("sampleReport", comment: "") == self.statusIS || NSLocalizedString("geoTag", comment: "") == self.statusIS || NSLocalizedString("performanceReport", comment: "") == self.statusIS){
                RetailerView.isHidden = !RetailerView.isHidden
                if RetailerView.isHidden == true{
                    RetailerTopImageView.image = UIImage(named: "upArrow-1")
                    RetailerHeightConstraint.constant = 0
                }
                else{
                    RetailerHeightConstraint.constant = 130
                    RetailerTopImageView.image = UIImage(named: "downroundIcon")
                }
            }
            else{
                retailerEditView.isHidden = !retailerEditView.isHidden
                if retailerEditView.isHidden == true{
                    RetailerTopImageView.image = UIImage(named: "upArrow-1")
                    retailerEditHeightConstraint.constant = 0
                }
                else{
                    retailerEditHeightConstraint.constant = 240
                    RetailerTopImageView.image = UIImage(named: "downroundIcon")
                }
            }
            
        case 101:
            if(NSLocalizedString("sampleReport", comment: "") == self.statusIS || NSLocalizedString("geoTag", comment: "") == self.statusIS || NSLocalizedString("performanceReport", comment: "") == self.statusIS){
                farmerView.isHidden = !farmerView.isHidden
                if farmerView.isHidden == true{
                    farmerTopImageView.image = UIImage(named: "upArrow-1")
                    farmerHeightConstraint.constant = 0
                }
                else{
                    farmerHeightConstraint.constant =  170 //heightConstant
                    farmerTopImageView.image = UIImage(named: "downroundIcon")
                }
            }
            else{
                farmerEditView.isHidden = !farmerEditView.isHidden
                if farmerEditView.isHidden == true{
                    farmerTopImageView.image = UIImage(named: "upArrow-1")
                    farmerEditHeightConstraint.constant = 0
                }
                else{
                    farmerEditHeightConstraint.constant =  250 //heightConstant
                    farmerTopImageView.image = UIImage(named: "downroundIcon")
                }
            }
            
        case 102:
            if(NSLocalizedString("geoTag", comment: "") == self.statusIS ||  NSLocalizedString("performanceReport", comment: "") == self.statusIS){
                PravtktaView.isHidden = !PravtktaView.isHidden
                if PravtktaView.isHidden == true{
                    PravtktaTopImageView.image = UIImage(named: "upArrow-1")
                    PravtktaHeightConstraint.constant = 0
                }
                else{
                    PravtktaHeightConstraint.constant =  260
                    PravtktaTopImageView.image = UIImage(named: "downroundIcon")
                }
            }
            else{
                pravtktaEditView.isHidden = !pravtktaEditView.isHidden
                if pravtktaEditView.isHidden == true{
                    PravtktaTopImageView.image = UIImage(named: "upArrow-1")
                    pravtktaEditHeightConstraint.constant = 0
                }
                else{
                    pravtktaEditHeightConstraint.constant =  330
                    PravtktaTopImageView.image = UIImage(named: "downroundIcon")
                }
            }
            
        case 103:
            if(NSLocalizedString("performanceReport", comment: "") == self.statusIS){
                BigfarmerView.isHidden = !BigfarmerView.isHidden
                if BigfarmerView.isHidden == true{
                    BigfarmerTopImageView.image = UIImage(named: "upArrow-1")
                    BigfarmerHeightConstraint.constant = 0
                }
                else{
                    BigfarmerHeightConstraint.constant = 250
                    BigfarmerTopImageView.image = UIImage(named: "downroundIcon")
                }
            }
            else{
  
                bigFarmerEditView.isHidden = !bigFarmerEditView.isHidden
                if bigFarmerEditView.isHidden == true{
                    BigfarmerTopImageView.image = UIImage(named: "upArrow-1")
                    bigfarmerEditHeightConstraint.constant = 0
                }
                else{
                    bigfarmerEditHeightConstraint.constant = 500
                    BigfarmerTopImageView.image = UIImage(named: "downroundIcon")
                }
            }
            
        default: break
        }
        self.view.layoutIfNeeded()
        self.view.updateConstraintsIfNeeded()
    }
    
    func getCurrentDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Specify the desired format
        let currentDate = Date() // Get the current date and time
        return dateFormatter.string(from: currentDate) // Format the date and return it as a string
    }
    
    func uploadingWithMultiPartFormData(){
        SwiftLoader.show(animated: true)
        let userObj = Constatnts.getUserObject()
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String,"userType": "Farmer"]
        
        let userId = userObj.customerId!
        
        let formattedDate = getCurrentDateTime()
        print("11111nandu",formattedDate)
        
        let originalData: [String: Any] = [
            "data": [
                "sampleRecevingDate": self.sampleReceivingData.text!,
                "userId": userId,
                "status": self.dataStatus,
                "geoTAg": self.dataSection3ReortGeoTag,
                "productConfirmationKey": self.sampleReportProductConfirmationTxt.text!,
                "dateOfHarvesting": self.harvestReportDateOfHarvestingTxt.text!,
                "dateOfShowing": self.geoTagReportDateTxt.text!,
                "serverId": self.getServerId,
                "growNextYear": self.dataSection4WillGrow,
                "reportHybridId":self.reportHybridID,
                "cropId": self.cropID,
                "pricePerQt": self.harvestReportMandiTxt.text!,
                "hybridId": self.hybridID,
                "recommendedToOthers": self.dataSection4WillRecommend,
                "cropUploadImage": ImageNameSending,
                "yieldPerAcre": self.harvestReportYieldTxt.text!,
                "rating": self.dataSection4HybridRating,
                "reportCropId": self.reportCropID,
                "mobileSubmitDateTime": formattedDate,
                "cropName":self.sampleRequestCropTxt.text!,
                "hybridName":self.sampleRequestHybridTxt.text!,
                "reportCropName":self.sampleReportCropTxt.text!,
                "reportHybridName":self.sampleReportHybridTxt.text!,
                "isPravaktha":self.dataSection1Pravakta,
                "sampleReceived":self.dataSection2Pravakta,
                "top3FabId":self.topFabID,
                "top3FabName":self.harvestReportTopFabTxt.text!,
                "customerTypeName":userObj.customerTypeName!,
                "mdoMdrActualUserId":self.iagUserIDTxt.text!,
            ]
        ]
        print("the main finial",originalData)
        var stringAPI = ""
        if let dataDict = originalData["data"] as? [String: Any] {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dataDict, options: [])
                
                // Convert JSON data to string
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    // Create final dictionary
                    let finalData: [String: Any] = ["data": jsonString]
                    
                    // Print the final JSON structure
                    let finalJsonData = try JSONSerialization.data(withJSONObject: finalData, options: .prettyPrinted)
                    if let finalJsonString = String(data: finalJsonData, encoding: .utf8) {
                        print("the main finial",finalJsonString)
                        stringAPI = finalJsonString
                    }
                }
            } catch {
                print("Error serializing JSON: \(error)")
            }
        }
        
        Alamofire.upload(multipartFormData: {(multipartFormData) in
            multipartFormData.append(stringAPI.data(using: String.Encoding.utf8)!, withName: "encodedData")
            
            if let imageData = UIImageJPEGRepresentation(self.geoTagImageView.image ?? UIImage(), 1) {
                multipartFormData.append(imageData, withName: "multipartFile", fileName: self.ImageNameSending, mimeType: "image/png")
            }
        }, usingThreshold: UInt64.init(), to: String(format :"%@%@",BASE_URL,POST_SAMPLE_TRACKING_SAVE_REQUEST), method: .post, headers: headers, encodingCompletion: {(encodeResult) in
            
            print("url:%@%@",BASE_URL,POST_SAMPLE_TRACKING_SAVE_REQUEST)
            print("headers:",headers)
            print("encodeRes:",encodeResult)
            switch encodeResult {
            case .success(let upload, _, _):
                upload.validate().responseJSON { response in
                    SwiftLoader.hide()
                    print("response11:",response)
                    if response.result.error == nil{
                        if let json = response.result.value{
                            print(json)
                            let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                            if responseStatusCode == STATUS_CODE_200{
  
                                if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                    self.view.makeToast(msg as String)
                                 }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000), execute: {
                                    self.navigationController?.popViewController(animated: true)
                                })
                               

                            }else if responseStatusCode == STATUS_CODE_601{
                                Constatnts.logOut()
                                if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                    print(msg)
                                    self.errorMessage = msg as String
                                    self.view.makeToast(msg as String)
                                }
                            }else {
                                if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                    print(msg)
                                self.errorMessage = msg as String
                                self.view.makeToast(msg as String)
                              }
                            }
                        }
                    }
                    else{
                        
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                self.view.makeToast(encodingError.localizedDescription)
            }
        })
    }
    
}

extension SampleTrackingDetailsViewController :  UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == cropDropDownTblView {
            return cropArray.count
        }
        else if tableView == hybridNameTblView {
            return hybridArray.count
        }
        else if tableView == reportCropDropDownTblView {
            return reportCropArray.count
        }
        else if tableView == reportHybridNameTblView {
            return reportHybridArray.count
        }
        else if tableView == topFabTblView {
            return topFabArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 14.0)
       
        if tableView == cropDropDownTblView {
            let cropDic = cropArray.object(at: indexPath.row) as? NSDictionary
            cell.textLabel?.text = cropDic?.value(forKey: "name") as? String
        }
        else if tableView == hybridNameTblView {
            let hybridDic = hybridArray.object(at: indexPath.row) as? NSDictionary
            cell.textLabel?.text = hybridDic?.value(forKey: "hybridName") as? String
        }
        else if tableView == reportCropDropDownTblView {
            let cropDic = reportCropArray.object(at: indexPath.row) as? NSDictionary
            cell.textLabel?.text = cropDic?.value(forKey: "name") as? String
        }
        else if tableView == reportHybridNameTblView {
            let hybridDic = reportHybridArray.object(at: indexPath.row) as? NSDictionary
            cell.textLabel?.text = hybridDic?.value(forKey: "hybridName") as? String
        }
        else if tableView == topFabTblView {
            let hybridDic = topFabArray.object(at: indexPath.row) as? NSDictionary
            cell.textLabel?.text = hybridDic?.value(forKey: "name") as? String
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

         if tableView == cropDropDownTblView {
            let cropDic = self.cropArray.object(at: indexPath.row) as? NSDictionary
             cropID = (cropDic!.value(forKey: "id") as! NSString) as String
             sampleRequestCropTxt.text = cropDic?.value(forKey: "name") as? String
        
             self.filterHybridsWithCropAndState(cropDic: cropDic)
              cropDropDownTblView.isHidden = true
             sampleRequestCropTxt.resignFirstResponder()
             self.sampleRequestHybridTxt.text = ""
        }
        else if tableView == hybridNameTblView {
            let hybridDic = self.hybridArray.object(at: indexPath.row) as? NSDictionary
            hybridID =  String(describing: hybridDic!.value(forKey: "id")!)
            sampleRequestHybridTxt.text = hybridDic?.value(forKey: "hybridName") as? String
            hybridNameTblView.isHidden = true
            sampleRequestHybridTxt.resignFirstResponder()
        }
        else if tableView == reportCropDropDownTblView {
           let cropDic = self.reportCropArray.object(at: indexPath.row) as? NSDictionary
            reportCropID = (cropDic!.value(forKey: "id") as! NSString) as String
            sampleReportCropTxt.text = cropDic?.value(forKey: "name") as? String
       
            self.reportfilterHybridsWithCropAndState(cropDic: cropDic)
            reportCropDropDownTblView.isHidden = true
            sampleReportCropTxt.resignFirstResponder()
            self.sampleReportHybridTxt.text = ""
       }
       else if tableView == reportHybridNameTblView {
           let hybridDic = self.reportHybridArray.object(at: indexPath.row) as? NSDictionary
           reportHybridID =  String(describing: hybridDic!.value(forKey: "id")!)
           sampleReportHybridTxt.text = hybridDic?.value(forKey: "hybridName") as? String
           reportHybridNameTblView.isHidden = true
           sampleReportHybridTxt.resignFirstResponder()
       }
        else if tableView == topFabTblView {
            let topFabDic = self.topFabArray.object(at: indexPath.row) as? NSDictionary
            topFabID =  String(describing: topFabDic!.value(forKey: "id"))
            harvestReportTopFabTxt.text = topFabDic?.value(forKey: "name") as? String
            topFabTblView.isHidden = true
            harvestReportTopFabTxt.resignFirstResponder()
        }

        self.view.endEditing(true)
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
    
    func filterHybridsWithCropAndState(cropDic: NSDictionary?){
        if cropDic != nil{
            cropID = (cropDic!.value(forKey: "id") as! String as NSString) as String
            //let filteredHybrids = hybridArray.filter { hybrid in
            let filterCropId:Int = Int(cropID)!
            hybridArray = (originalReportHybridArray as! [[String: Any]]).filter { hybrid in
                if let cropId = hybrid["cropId"] as? Int {
                    return cropId == filterCropId
                }
                return false
            } as NSArray
            print("ddddd",hybridArray)
            self.hybridNameTblView.reloadData()
            
         }
     }
    
    func reportfilterHybridsWithCropAndState(cropDic: NSDictionary?){
        if cropDic != nil{
            reportCropID = (cropDic!.value(forKey: "id") as! String as NSString) as String
            //let filteredHybrids = hybridArray.filter { hybrid in
            let filterCropId:Int = Int(reportCropID)!
            reportHybridArray = (originalReportHybridArray as! [[String: Any]]).filter { hybrid in
                if let cropId = hybrid["cropId"] as? Int {
                    return cropId == filterCropId
                }
                return false
            } as NSArray
            print("dddkkk",reportHybridArray)
            self.reportHybridNameTblView.reloadData()
            
         }
     }
}
 


