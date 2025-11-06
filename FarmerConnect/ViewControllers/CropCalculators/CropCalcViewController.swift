//
//  CropCalcViewController.swift
//  FarmerConnect
//
//  Created by Admin on 12/02/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit
import Alamofire

class CropCalcViewController: BaseViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var scrollView: UIScrollView?
    @IBOutlet var contentView : UIView?
    @IBOutlet var cropsView : UIView?
    @IBOutlet var calculateView : UIView?
    @IBOutlet var contentViewHeightConstraint : NSLayoutConstraint?
    @IBOutlet var cropViewTopConstraint : NSLayoutConstraint?
    @IBOutlet var calculateViewTopConstraint : NSLayoutConstraint?
    @IBOutlet var yearViewTopConstraint : NSLayoutConstraint?
    @IBOutlet var txtPreviousYear: UITextField?
    @IBOutlet var txtYear: UITextField?
    @IBOutlet var txtPlanningAcres: UITextField?
    @IBOutlet var txtLandPreparation: UITextField?
    @IBOutlet var txtSeedCost: UITextField?
    @IBOutlet var txtSeedRate: UITextField?
    @IBOutlet var txtTotalSeedCost: UITextField?
    @IBOutlet var txtLabourCost: UITextField?
    @IBOutlet var txtNoOfLabours: UITextField?
    @IBOutlet var txtTotalLabourCost: UITextField?
    @IBOutlet var txtIrrigationCost: UITextField?
    @IBOutlet var txtNoOfIrrigations: UITextField?
    @IBOutlet var txtTotalIrrigationCost: UITextField?
    @IBOutlet var txtFertiliserCost: UITextField?
    @IBOutlet var txtPesticideCost: UITextField?
    @IBOutlet var txtOtherMiscellaneousCost: UITextField!
    @IBOutlet var txtTotalInputCost: UITextField?
    @IBOutlet var txtGrainYieldCost: UITextField?
    @IBOutlet var txtMechHarvestCost: UITextField?
    @IBOutlet var txtStrawYield: UITextField?
    @IBOutlet var txtCommercialGrainPrice: UITextField?
    @IBOutlet var txtCommercialFooderPrice: UITextField?
    @IBOutlet var txtTotalIncome: UITextField?
    @IBOutlet var txtNetProfit: UITextField?
    @IBOutlet var lblTotalSeed: UILabel?
    @IBOutlet var lblTotalLabour: UILabel?
    @IBOutlet var lblTotalIrrigation: UILabel?
    @IBOutlet var lblTotalInput: UILabel?
    @IBOutlet var lblTotalIncome: UILabel?
    @IBOutlet var lblNetProfit: UILabel?
    @IBOutlet var btnSubmit: UIButton?
    @IBOutlet var btnPrevYear: UIButton?
    
    var showAlertView : UIView = UIView()
    
    var tblPrevYears : UITableView = UITableView()
    var currentYear : NSString?
    var selectedCrop: String?
    var arrCropsMasterData = NSMutableArray()
    var arrPreviousYears = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = true
        txtYear?.textColor = UIColor.gray
        txtYear?.isUserInteractionEnabled = false
        btnPrevYear?.isHidden = true
        let classificationBtn = UIButton(type: .custom)
        classificationBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        classificationBtn.setImage(UIImage(named:"DropDown"), for:.normal)
        classificationBtn.addTarget(self, action: #selector(CropCalcViewController.selectYearButtonClick(_:)), for: .touchUpInside)
        txtPreviousYear?.rightView = classificationBtn
        txtPreviousYear?.rightViewMode = .always
        txtPreviousYear?.text = Select_Year
        self.updateCropCostValuesWithLatestYearToUiComponents()
        self.loadDropDownTableView(tableViewDataSource: self, tableViewDelegate: self, tableview: tblPrevYears, textField: txtPreviousYear!)
        tblPrevYears.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tblPrevYears.delegate = self
        tblPrevYears.dataSource = self
        self.getCurrentYearFromTodaysDate()
        scrollView?.isHidden = true
        if #available(iOS 10.0, *) {
            self.automaticallyAdjustsScrollViewInsets = true
            yearViewTopConstraint?.constant = 74
            self.view.layoutIfNeeded()
            self.view.updateConstraintsIfNeeded()
        }
        if #available(iOS 11.0, *) {
            self.automaticallyAdjustsScrollViewInsets = true
            yearViewTopConstraint?.constant = 14
            self.view.layoutIfNeeded()
            self.view.updateConstraintsIfNeeded()
        }
        self.recordScreenView("CropCalcViewController", Crop_Calculator)
        let userObj = Constatnts.getUserObject()
        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,PINCODE:userObj.pincode ?? "",CROP:self.selectedCrop!] as [String : Any]
        self.registerFirebaseEvents(PV_Crop_Calculator, "", "", Crop_Calculator, parameters: fireBaseParams as NSDictionary)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.topView?.isHidden = false
        self.lblTitle?.text = String(format: "%@ - %@", selectedCrop!, NSLocalizedString("calculator", comment: ""))
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        self.requestToGetCropCalculatorMasterData()

    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if selectedCrop != "Millet" && selectedCrop != "Mustard"{
            cropsView?.isHidden = true
            cropViewTopConstraint?.constant = -75
            contentViewHeightConstraint?.constant = 875
            self.contentView?.layoutIfNeeded()
            self.contentView?.updateConstraintsIfNeeded()
            scrollView?.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 875)
            self.view.layoutIfNeeded()
            self.view.updateConstraintsIfNeeded()
        }
        else{
            scrollView?.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 960)
            self.view.layoutIfNeeded()
            self.view.updateConstraintsIfNeeded()
        }
    }
    
    func getCurrentYearFromTodaysDate(){
        let today = Date()
        //var dateArray = [String]()
        let tomorrow = Calendar.current.date(byAdding: .year, value: 0, to: today)
        let date = DateFormatter()
        date.dateFormat = "yyyy"
        let stringDate : String = date.string(from: tomorrow!)
        currentYear = NSString(string: stringDate)
        txtYear?.text = currentYear as String!
    }
    func getPreviousYearsFromMasterData(){
        let filterYerars = NSPredicate(format: "cropName == %@",self.selectedCrop!)
        if let arrYears = Singleton.getYearsFromMasterDataFromCropCalculatonsWithPredicate("CropCalculatorEntity", predicate: filterYerars) as NSArray?{
            if arrYears.count > 0{
                arrPreviousYears.removeAllObjects()
                if let catNamesArray = arrYears.value(forKeyPath: #keyPath(CropCalculatorEntity.year)) as? [String] {
                    //print(catNamesArray) // prints [1, 2, 4]
                    self.arrPreviousYears.addObjects(from: NSSet(array: catNamesArray).allObjects)
                }
                arrPreviousYears.insert(Select_Year, at: 0)
            }
        }
        else{
            arrPreviousYears.insert(Select_Year, at: 0)
        }
        tblPrevYears.reloadData()
    }
    func requestToGetCropCalculatorMasterData(){
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,Get_Crop_Calculator_Master])
        //lastUpdatedTime
        let userObj = Constatnts.getUserObject()
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        let parameteers = ["lastUpdatedTime":UserDefaults.standard.value(forKey: "lastUpdatedTime") ?? ""]
        let paramsStr = Constatnts.nsobjectToJSON(parameteers as NSDictionary)
        let params =  ["data" : paramsStr]
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        //print("Response after decrypting data:\(decryptData)")
                        let countryListArray = decryptData.value(forKey: "cropCalculatorMasterList") as! NSArray
                        //self.arrCompanies.removeAllObjects()
                        let appdelegate = UIApplication.shared.delegate as? AppDelegate
                        for i in 0 ..< countryListArray.count{
                            if let companyDict = countryListArray.object(at: i) as? NSDictionary{
                                let cropData = CropCalculator(dict: companyDict)
                                if cropData.status == "INSERT" || cropData.status == "UPDATE"{
                                    appdelegate?.saveCropCalculationDetails(cropData)
                                }
                                else if cropData.status == "DELETE"{
                                    if let filterPredicate = NSPredicate(format: "year == %@ && cropName == %@",cropData.year,cropData.cropName) as NSPredicate?{
                                        Singleton.deleteSyncedCropCaliculationDetails(predicate: filterPredicate)
                                    }
                                }
                            }
                        }
                        self.updateCropCostValuesWithLatestYearToUiComponents()
                        self.getPreviousYearsFromMasterData()
                        if let lastSyncedOn = decryptData.value(forKey: "lastSyncedOn") as? NSString{
                            UserDefaults.standard.set(lastSyncedOn, forKey: "lastUpdatedTime")
                        }

                    }
                }
            }
        }
    }
    func calculateTheTotalAmountForSelectedAcres(){
        let cropTotalSeedCost = NSString(string: txtSeedCost?.text ?? "0").integerValue * NSString(string: txtSeedRate?.text ?? "0").integerValue
        txtTotalSeedCost?.text = String(format: "%d", cropTotalSeedCost)
        let labourTotalCost = NSString(string: txtLabourCost?.text ?? "0").integerValue * NSString(string: txtNoOfLabours?.text ?? "0").integerValue
        txtTotalLabourCost?.text = String(format: "%d", labourTotalCost)
        let irrigationTotalCost = NSString(string: txtIrrigationCost?.text ?? "0").integerValue * NSString(string: txtNoOfIrrigations?.text ?? "0").integerValue
        txtTotalIrrigationCost?.text = String(format: "%d", irrigationTotalCost)
        let totalInputCost =  NSString(string: txtLandPreparation?.text ?? "0").integerValue + NSString(string: txtPesticideCost?.text ?? "0").integerValue + NSString(string: txtFertiliserCost?.text ?? "0").integerValue + NSString(string: txtOtherMiscellaneousCost?.text ?? "0").integerValue + cropTotalSeedCost + labourTotalCost + irrigationTotalCost
        txtTotalInputCost?.text = String(format: "%d", totalInputCost)
        var totalIncome = 0
        if selectedCrop != "Millet" && selectedCrop != "Mustard"{
            totalIncome = (NSString(string: txtGrainYieldCost?.text ?? "0").integerValue * NSString(string: txtCommercialGrainPrice?.text ?? "0").integerValue) + (NSString(string: txtFertiliserCost?.text ?? "0").integerValue)
            txtTotalIncome?.text = String(format: "%d", totalIncome)
        }
        else{
            totalIncome = (NSString(string: txtGrainYieldCost?.text ?? "0").integerValue * NSString(string: txtCommercialGrainPrice?.text ?? "0").integerValue) + (NSString(string: txtStrawYield?.text ?? "0").integerValue * NSString(string: txtCommercialFooderPrice?.text ?? "0").integerValue)
            txtTotalIncome?.text = String(format: "%d", totalIncome)
        }
        txtNetProfit?.backgroundColor = UIColor(red: 255.0/255.0, green: 204.0/255.0, blue: 1.0/255.0, alpha: 1.0)
        txtTotalIncome?.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 2.0/255.0, alpha: 1.0)
        txtTotalInputCost?.backgroundColor = UIColor(red: 255.0/255.0, green: 204.0/255.0, blue: 1.0/255.0, alpha: 1.0)
        txtTotalIrrigationCost?.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        txtTotalLabourCost?.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        txtTotalSeedCost?.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 153.0/255.0, alpha: 1.0)

        let netProfit = totalIncome - totalInputCost
        txtNetProfit?.text = String(format: "%d", netProfit)

    }
    func updateCropCostValuesWithLatestYearToUiComponents(){
        self.clearAllTheTextFields()
        //let filterCropAndYerar = NSPredicate(format: "year == %@ && cropName == %@", currentYear!,self.selectedCrop!)
        let filterArray = Singleton.getLastYearMasterDataFromCropCalculations("CropCalculatorEntity", self.selectedCrop!)
        if filterArray?.count ?? 0 > 0{
            if let cropData = filterArray?.object(at: 0) as? CropCalculatorEntity{
                txtSeedCost?.text = cropData.seedCost as String?
                //txtPlanningAcres?.text = cropData.planningAcers as String?
                txtSeedRate?.text = cropData.seedRate as String?
                txtLandPreparation?.text = cropData.landPreparation as String?
                txtLabourCost?.text = cropData.labourCost as String?
                txtNoOfLabours?.text = cropData.totalNoOfLabours as String?
                //txtMechHarvestCost?.text = cropData. as String?
                txtIrrigationCost?.text = cropData.costPerIrrigation as String?
                txtNoOfIrrigations?.text = cropData.noOfIrrigations as String?
                txtFertiliserCost?.text = cropData.fertiliserCost as String?
                txtPesticideCost?.text = cropData.pesticidesCost as String?
                txtGrainYieldCost?.text = cropData.grainYield as String?
                txtCommercialGrainPrice?.text = cropData.commercialGrainPrice as String?
                if selectedCrop == "Millet" || selectedCrop == "Mustard"{
                    txtStrawYield?.text = cropData.strawYield as String?
                    txtCommercialFooderPrice?.text = cropData.commercialFooderPrice as String?
                }
                self.calculateTheTotalAmountForSelectedAcres()
            }
        }
    }
    func updateCropCostValuesToUiComponents(_ year:String){
        calculateView?.isHidden = true
        calculateViewTopConstraint?.constant = -125
        let clearStr = NSLocalizedString("clear", comment: "")
        btnSubmit?.setTitle(clearStr, for: .normal)
        btnSubmit?.backgroundColor = App_Theme_Orange_Color
        scrollView?.isHidden = false
        self.view.layoutIfNeeded()
        self.view.updateConstraintsIfNeeded()
        self.clearAllTheTextFields()
        let filterCropAndYerar = NSPredicate(format: "year == %@ && cropName == %@", year,self.selectedCrop!)
        let filterArray = Singleton.getMasterDataFromCropCalculatonsWithPredicate("CropCalculatorEntity", predicate: filterCropAndYerar)
        if filterArray?.count ?? 0 > 0{
            if let cropData = filterArray?.object(at: 0) as? CropCalculatorEntity{
                txtSeedCost?.text = cropData.seedCost as String?
                txtPlanningAcres?.text = cropData.planningAcers as String?
                txtSeedRate?.text = cropData.seedRate as String?
                txtLandPreparation?.text = cropData.landPreparation as String?
                txtLabourCost?.text = cropData.labourCost as String?
                txtNoOfLabours?.text = cropData.totalNoOfLabours as String?
                //txtMechHarvestCost?.text = cropData. as String?
                txtIrrigationCost?.text = cropData.costPerIrrigation as String?
                txtNoOfIrrigations?.text = cropData.noOfIrrigations as String?
                txtFertiliserCost?.text = cropData.fertiliserCost as String?
                txtPesticideCost?.text = cropData.pesticidesCost as String?
                txtGrainYieldCost?.text = cropData.grainYield as String?
                txtCommercialGrainPrice?.text = cropData.commercialGrainPrice as String?
                if selectedCrop == "Millet" || selectedCrop == "Mustard"{
                    txtStrawYield?.text = cropData.strawYield as String?
                    txtCommercialFooderPrice?.text = cropData.commercialFooderPrice as String?
                }
                self.calculateTheTotalAmountForSelectedAcres()
                self.disableAndEnableTextField(false)
                btnSubmit?.isHidden = false
            }
        }
    }
    @IBAction func selectYearButtonClick(_ sender: UIButton){
        self.view.endEditing(true)
        self.tblPrevYears.isHidden = !self.tblPrevYears.isHidden
    }
    @IBAction func previousYearButtonClick(_ sender: UIButton){
        if let currentYr = currentYear?.integerValue as NSInteger? {
            if currentYr > 0{
                currentYear = NSString(format: "%d", currentYr - 1)
                //txtYear?.text = self.currentYear as String!
                //self.updateCropCostValuesToUiComponents()
                self.disableAndEnableTextField(false)
            }
        }
    }
    
    @IBAction func calculateButtonClick(_ sender: UIButton){
        self.getCurrentYearFromTodaysDate()
        //self.updateCropCostValuesToUiComponents()
        if Validations.isNullString(txtPlanningAcres?.text as NSString? ?? "" as NSString) == true{
            self.view.makeToast(Enter_Planning_Acers)
            return
        }
        else{
            scrollView?.isHidden = false
            self.updateCropCostValuesWithLatestYearToUiComponents()
        }
        self.disableAndEnableTextField(true)
        self.updateCropCostValuesWithLatestYearToUiComponents()
        if let currentYr = currentYear?.integerValue as NSInteger? {
            if currentYr > 0{
                let prevTitle = NSString(format: "%d Crop Caliculation", currentYr - 1)
                btnPrevYear?.setTitle(prevTitle as String, for: .normal)
            }
        }
        let userObj = Constatnts.getUserObject()
        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,PINCODE:userObj.pincode ?? "",CROP:self.selectedCrop!,Planing_Acer:txtPlanningAcres!.text!] as [String : Any]
        self.registerFirebaseEvents(Calculate, "", "", Crop_Calculator, parameters: fireBaseParams as NSDictionary)
    }
    @IBAction func submitButtonClick(_ sender: UIButton){
        if btnSubmit?.titleLabel?.text == NSLocalizedString("submit", comment: "") {
            
            self.showAlertView = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: NSLocalizedString("alert", comment: "") as NSString, message:NSLocalizedString("submit_data", comment: "") as NSString , okButtonTitle: NSLocalizedString("yes", comment: ""), cancelButtonTitle: NSLocalizedString("no", comment: "")) as! UIView
            self.view.addSubview(self.showAlertView)

        }
        else{
            
            btnSubmit?.setTitle(NSLocalizedString("submit", comment: ""), for: .normal)
            btnSubmit?.backgroundColor = App_Theme_Blue_Color
            self.hideCropCaliculationView()

        }
      
        let userObj = Constatnts.getUserObject()
        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,PINCODE:userObj.pincode ?? "",CROP:self.selectedCrop!,Planing_Acer:txtPlanningAcres!.text!,Total_Income:txtTotalIncome!.text!,NetProfit:txtNetProfit!.text!] as [String : Any]
        self.registerFirebaseEvents(Crop_Calculator_Submit, "", "", Crop_Calculator, parameters: fireBaseParams as NSDictionary)
    }
    
    //MARK: alertYesBtnAction
    /**
     YES button action of the alertView which is displayed to the user
     when already logged in other device
     */
    @objc func alertYesBtnAction(){
        showAlertView.removeFromSuperview()
        if self.inputFieldsValidation() == true{
            self.saveCropCalculatedDataToDB()
        }
    }
    
    //MARK: alertNoBtnAction
    /**
     NO button action of the alertView which is displayed to the user
     when already logged in other device
     */
    @objc func alertNoBtnAction(){
        showAlertView.removeFromSuperview()
    }
    
    func hideCropCaliculationView(){
        calculateView?.isHidden = false
        calculateViewTopConstraint?.constant = 6
        scrollView?.isHidden = true
        self.view.layoutIfNeeded()
        self.view.updateConstraintsIfNeeded()
        txtPreviousYear?.text = Select_Year
        self.disableAndEnableTextField(true)
    }
    func saveCropCalculatedDataToDB(){
        let userObj = Constatnts.getUserObject()
        let cropCalcObj = CropCalculator(dict: NSDictionary())
        cropCalcObj.year = txtYear?.text as NSString!
        cropCalcObj.landPreparation = txtLandPreparation?.text as NSString!
        cropCalcObj.seedCost = txtSeedCost?.text as NSString!
        cropCalcObj.seedRate = txtSeedRate?.text as NSString!
        cropCalcObj.labourCost = txtLabourCost?.text as NSString?  ?? ""
        cropCalcObj.totalNoOfLabourersReq = txtNoOfLabours?.text as NSString? ?? ""
        //cropCalcObj.mechanicalHarvestCost = txtme?.text as NSString!
        cropCalcObj.costPerIrrigation = txtIrrigationCost?.text as NSString? ?? ""
        cropCalcObj.noOfIrrigations = txtNoOfIrrigations?.text as NSString? ?? ""
        cropCalcObj.fertilizerCost = txtFertiliserCost?.text as NSString? ?? ""
        cropCalcObj.pesticideCost = txtPesticideCost?.text as NSString? ?? ""
        cropCalcObj.grainYield = txtGrainYieldCost?.text as NSString? ?? ""
        cropCalcObj.commercialGrainPrice = txtCommercialGrainPrice?.text as NSString? ?? ""
        cropCalcObj.strawYield = txtStrawYield?.text as NSString? ?? ""
        cropCalcObj.commercialFodderPrice = txtCommercialFooderPrice?.text as NSString? ?? ""
        cropCalcObj.cropName = self.selectedCrop as NSString? ?? ""
        cropCalcObj.plannedAcers = txtPlanningAcres?.text as NSString? ?? ""
        cropCalcObj.status = "1"
        if LocationService.sharedInstance.currentLocation != nil {
            if let currentCoordinates = LocationService.sharedInstance.currentLocation?.coordinate as CLLocationCoordinate2D?{
                cropCalcObj.geoLocation = NSString(format: "%f,%f", currentCoordinates.latitude,currentCoordinates.longitude)
            }
        }
        let randomNo :UInt32 = arc4random_uniform(10000)
        let mobileId = String(format: "%@_%d_%d", userObj.customerId!,Constatnts.getCurrentMillis(),randomNo)
        cropCalcObj.mobileId = mobileId as NSString
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.saveCropCalculationDetails(cropCalcObj)
        Singleton.syncingPendigCropCalculationsToServer()
        self.txtPlanningAcres?.text = ""
        self.clearAllTheTextFields()
        btnSubmit?.setTitle(NSLocalizedString("submit", comment: ""), for: .normal)
        btnSubmit?.backgroundColor = App_Theme_Blue_Color
        self.hideCropCaliculationView()
        self.navigationController?.popViewController(animated: true)
    }
    func disableAndEnableTextField(_ isEnable: Bool){
        txtLandPreparation?.isUserInteractionEnabled = isEnable
        txtSeedRate?.isUserInteractionEnabled = isEnable
        txtSeedCost?.isUserInteractionEnabled = isEnable
        txtLabourCost?.isUserInteractionEnabled = isEnable
        txtNoOfLabours?.isUserInteractionEnabled = isEnable
        txtMechHarvestCost?.isUserInteractionEnabled = isEnable
        txtIrrigationCost?.isUserInteractionEnabled = isEnable
        txtNoOfIrrigations?.isUserInteractionEnabled = isEnable
        txtFertiliserCost?.isUserInteractionEnabled = isEnable
        txtPesticideCost?.isUserInteractionEnabled = isEnable
        txtGrainYieldCost?.isUserInteractionEnabled = isEnable
        txtCommercialGrainPrice?.isUserInteractionEnabled = isEnable
        txtStrawYield?.isUserInteractionEnabled = isEnable
        txtCommercialFooderPrice?.isUserInteractionEnabled = isEnable
        btnSubmit?.isHidden = !isEnable
        self.updateTextFieldTextColorsBasedOnInteraction()
    }
    func clearAllTheTextFields(){
        txtLandPreparation?.text = ""
        txtSeedRate?.text = ""
        txtSeedCost?.text = ""
        txtLabourCost?.text = ""
        txtNoOfLabours?.text = ""
        txtMechHarvestCost?.text = ""
        txtIrrigationCost?.text = ""
        txtNoOfIrrigations?.text = ""
        txtFertiliserCost?.text = ""
        txtPesticideCost?.text = ""
        txtGrainYieldCost?.text = ""
        txtCommercialGrainPrice?.text = ""
        txtStrawYield?.text = ""
        txtCommercialFooderPrice?.text = ""
        txtTotalSeedCost?.text = ""
        txtTotalLabourCost?.text = ""
        txtTotalIrrigationCost?.text = ""
        txtTotalIncome?.text = ""
        txtTotalInputCost?.text = ""
        txtNetProfit?.text = ""

    }
    func updateTextFieldTextColorsBasedOnInteraction(){
        txtLandPreparation?.textColor = (txtLandPreparation?.isUserInteractionEnabled)! ? UIColor.black : UIColor.gray
        txtSeedRate?.textColor = (txtSeedRate?.isUserInteractionEnabled)! ? UIColor.black : UIColor.gray
        txtSeedCost?.textColor = (txtSeedCost?.isUserInteractionEnabled)! ? UIColor.black : UIColor.gray
        txtLabourCost?.textColor = (txtLabourCost?.isUserInteractionEnabled)! ? UIColor.black : UIColor.gray
        txtNoOfLabours?.textColor = (txtNoOfLabours?.isUserInteractionEnabled)! ? UIColor.black : UIColor.gray
        txtMechHarvestCost?.textColor = (txtMechHarvestCost?.isUserInteractionEnabled)! ? UIColor.black : UIColor.gray
        txtIrrigationCost?.textColor = (txtIrrigationCost?.isUserInteractionEnabled)! ? UIColor.black : UIColor.gray
        txtNoOfIrrigations?.textColor = (txtNoOfIrrigations?.isUserInteractionEnabled)! ? UIColor.black : UIColor.gray
        txtFertiliserCost?.textColor = (txtFertiliserCost?.isUserInteractionEnabled)! ? UIColor.black : UIColor.gray
        txtPesticideCost?.textColor = (txtPesticideCost?.isUserInteractionEnabled)! ? UIColor.black : UIColor.gray
        txtGrainYieldCost?.textColor = (txtGrainYieldCost?.isUserInteractionEnabled)! ? UIColor.black : UIColor.gray
        txtCommercialGrainPrice?.textColor = (txtCommercialGrainPrice?.isUserInteractionEnabled)! ? UIColor.black : UIColor.gray
        txtStrawYield?.textColor = (txtStrawYield?.isUserInteractionEnabled)! ? UIColor.black : UIColor.gray
        txtCommercialFooderPrice?.textColor = (txtCommercialFooderPrice?.isUserInteractionEnabled)! ? UIColor.black : UIColor.gray
    }
    func inputFieldsValidation() -> Bool{
        var isValid = false
        if Validations.isNullString(txtYear?.text as NSString? ?? "" as NSString) == true{
            isValid = false
        }
        else if Validations.isNullString(txtPlanningAcres?.text as NSString? ?? "" as NSString) == true{
            self.view.makeToast(Enter_Planning_Acers)
            isValid = false
        }
        else if Validations.isNullString(txtLandPreparation?.text as NSString? ?? "" as NSString) == true{
            self.view.makeToast(Enter_Land_Preparation)
            isValid = false
        }
        else if Validations.isNullString(txtSeedCost?.text as NSString? ?? "" as NSString) == true{
            self.view.makeToast(Enter_Seed_Cost)
            isValid = false
        }
        else if Validations.isNullString(txtSeedCost?.text as NSString? ?? "" as NSString) == true{
            self.view.makeToast(Enter_Seed_rate)
            isValid = false
        }
        else if Validations.isNullString(txtTotalSeedCost?.text as NSString? ?? "" as NSString) == true{
            isValid = false
        }
        else if Validations.isNullString(txtLabourCost?.text as NSString? ?? "" as NSString) == true{
            self.view.makeToast(Enter_Labour_Cost)
            isValid = false
        }
        else if Validations.isNullString(txtNoOfLabours?.text as NSString? ?? "" as NSString) == true{
            self.view.makeToast(Enter_NoOf_Labours_Count)
            isValid = false
        }
        else if Validations.isNullString(txtTotalLabourCost?.text as NSString? ?? "" as NSString) == true{
            isValid = false
        }
        else if Validations.isNullString(txtIrrigationCost?.text as NSString? ?? "" as NSString) == true{
            self.view.makeToast(Enter_Irrigation_Cost)
            isValid = false
        }
        else if Validations.isNullString(txtNoOfIrrigations?.text as NSString? ?? "" as NSString) == true{
            self.view.makeToast(Enter_NoOf_Irrigations)
            isValid = false
        }
        else if Validations.isNullString(txtTotalIrrigationCost?.text as NSString? ?? "" as NSString) == true{
            isValid = false
        }
        else if Validations.isNullString(txtFertiliserCost?.text as NSString? ?? "" as NSString) == true{
            self.view.makeToast(Enter_Fertiliser_Cost)
            isValid = false
        }
        else if Validations.isNullString(txtPesticideCost?.text as NSString? ?? "" as NSString) == true{
            self.view.makeToast(Enter_Pestiside_Cost)
            isValid = false
        }
        else if Validations.isNullString(txtTotalInputCost?.text as NSString? ?? "" as NSString) == true{
            isValid = false
        }
        else if Validations.isNullString(txtGrainYieldCost?.text as NSString? ?? "" as NSString) == true{
            self.view.makeToast(Enter_Commercial_Grain_Yield)
            isValid = false
        }
        else if Validations.isNullString(txtCommercialGrainPrice?.text as NSString? ?? "" as NSString) == true{
            self.view.makeToast(Enter_Commercial_Grain_Price)
            isValid = false
        }
        else if Validations.isNullString(txtTotalIncome?.text as NSString? ?? "" as NSString) == true{
            isValid = false
        }
        if selectedCrop == "Millet" || selectedCrop == "Mustard"{
            if Validations.isNullString(txtStrawYield?.text as NSString? ?? "" as NSString) == true{
                self.view.makeToast(Enter_Straw_Yield)
                isValid = false
            }
            else if Validations.isNullString(txtCommercialFooderPrice?.text as NSString? ?? "" as NSString) == true{
                self.view.makeToast(Enter_Commercial_Fooder_Price)
                isValid = false
            }
        }
        else{
            isValid = true
        }
        return isValid
    }
    //MARK: UITableview delegate and datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblPrevYears{
            return arrPreviousYears.count
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
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13.0)
        //cell.textLabel?.textAlignment = .center
        if tableView == tblPrevYears{
            if let yearStr = arrPreviousYears.object(at: indexPath.row) as? String{
                cell.textLabel?.text = yearStr
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblPrevYears{
            if let selectedyear = arrPreviousYears.object(at: indexPath.row) as? String{
                txtPreviousYear?.text = selectedyear
                if selectedyear != Select_Year{
                    self.updateCropCostValuesToUiComponents(selectedyear)
                }
            }
        }
        tableView.isHidden = true
        self.view.endEditing(true)
    }

    //MARK: UITextfield Delegate Methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtYear || textField == txtTotalSeedCost || textField == txtTotalLabourCost || textField == txtTotalIrrigationCost || textField == txtTotalInputCost || textField == txtTotalIncome || textField == txtNetProfit || textField == txtPreviousYear  {
            return false
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.calculateTheTotalAmountForSelectedAcres()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        /*let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
         let components = string.components(separatedBy: inverseSet)
         let filtered = components.joined(separator: "")
         if filtered == string {
         return true
         } else {
         if string == "." {
         let countdots = textField.text!.components(separatedBy:".").count - 1
         if countdots == 0 {
         return true
         }else{
         if countdots > 0 && string == "." {
         return false
         } else {
         return true
         }
         }
         }else{
         return false
         }
         }*/
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        self.calculateTheTotalAmountForSelectedAcres()
        
        return string == numberFiltered
        
        //return true
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
