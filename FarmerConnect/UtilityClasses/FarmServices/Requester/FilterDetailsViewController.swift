//
//  FilterDetailsViewController.swift
//  FarmerConnect
//
//  Created by Empover on 22/12/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps
import GooglePlaces

class FilterDetailsViewController: RequesterBaseViewController {
    
    @IBOutlet weak var txtFldClassification: UITextField!
    
    @IBOutlet weak var txtFldRequestLocation: UITextField!
    
    @IBOutlet weak var serviceAreaSlider: UISlider!
    
    @IBOutlet weak var lblServiceArea: UILabel!
    
    @IBOutlet weak var pricePerHourSlider: UISlider!
    
    @IBOutlet weak var lblPricePerHour: UILabel!
    
    @IBOutlet weak var txtFldFromDate: UITextField!
    
    @IBOutlet weak var txtFldToDate: UITextField!
    
    @IBOutlet weak var txtFldNumOfHours: UITextField!
    
    @IBOutlet weak var classificationLbl: UILabel!
    @IBOutlet weak var requestLocLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var pricePerLbl: UILabel!
    @IBOutlet weak var driverLbl: UILabel!
    @IBOutlet weak var pickAndDropLbl: UILabel!
    @IBOutlet weak var dateRangeLbl: UILabel!
    @IBOutlet weak var noOfHrsLbl: UILabel!
    var getLocationCoordinate:CLLocationCoordinate2D?
    var getLocationAddress:String!
    var alertViewServiceAreaDistance : UIView?
    var alertTxtFldServiceAreaDistance = UITextField()
    var serviceAreaDistanceStr = ""
    
    var alertViewPricePerHour : UIView?
    var alertTxtFldPricePerHour = UITextField()
    var pricePerHourStr = ""
    
    var alertViewNumOfHrs : UIView?
    var alertTxtFldNumOfHrs = UITextField()
    var numOfHoursStr = ""
    
    var rupee = ""
    
    var fromDateView : UIView?
    var toDateView : UIView?
    
    var maximumDate : NSDate?
    
    var toDateStrToSet = ""
    
    @IBOutlet weak var driverChkBox: VKCheckbox!
    
    @IBOutlet weak var pickAndDropChkBox: VKCheckbox!
    
    var isDriverSelected : Bool = true
    var isPickAndDropSelected : Bool = false
    
    var chkBoxValue = ""
    
    var classificationListMutArray = NSMutableArray()
    
    var classificationDropDownTblView = UITableView()
    
    var selectLocation: CLLocationCoordinate2D?
    
    var classificationSelectedIdStr = ""
    
    var filterDetailsHandler:((Dictionary<String,Any>,Bool) -> Void)?
    
    var cancelBlock : (() -> Void)?
    
    var tempDictToDisplayValues = NSDictionary()
    
    //var minServiceHours = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        txtFldRequestLocation.delegate = self
        txtFldRequestLocation.tintColor = UIColor.clear
        
        txtFldClassification.leftViewMode = .always
        txtFldClassification.contentVerticalAlignment = .center
        txtFldClassification.setLeftPaddingPoints(10)
        txtFldClassification.tintColor = UIColor.clear
        
        txtFldClassification.delegate = self
        //classification dropdown tableView
        self.loadDropDownTableView(tableViewDataSource: self, tableViewDelegate: self, tableview: classificationDropDownTblView, textField: txtFldClassification)
        classificationDropDownTblView.dataSource = self
        classificationDropDownTblView.delegate = self
        classificationDropDownTblView.tableFooterView = UIView()
        classificationDropDownTblView.separatorInset = .zero
        
        txtFldFromDate.delegate = self
        txtFldFromDate.tintColor = UIColor.clear
        txtFldToDate.delegate = self
        txtFldToDate.tintColor = UIColor.clear
        txtFldNumOfHours.delegate = self
        txtFldNumOfHours.tintColor = UIColor.clear
        
        let fromDateFormatter: DateFormatter = DateFormatter()
        fromDateFormatter.dateFormat = "dd-MMM-yyyy"
        let currentDateStr = fromDateFormatter.string(from: Date()) as String
        txtFldFromDate.text = currentDateStr
        
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let currentDate: NSDate = NSDate()
        
        let components: NSDateComponents = NSDateComponents()
        components.day = 30//2
        let toDate: NSDate = gregorian.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        
        let toDateFormatter: DateFormatter = DateFormatter()
        toDateFormatter.dateFormat = "dd-MMM-yyyy"
        let toDateStr = fromDateFormatter.string(from:toDate as Date) as String
        txtFldToDate.text = toDateStr
        
        let maxDateComponents: NSDateComponents = NSDateComponents()
        maxDateComponents.day = 45//20
        let maxDate: NSDate = gregorian.date(byAdding: maxDateComponents as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        maximumDate = maxDate
        
        self.driverChkBox.backgroundColor = UIColor.green
        self.pickAndDropChkBox.backgroundColor = UIColor.white
         self.driverChkBox.setOn(true)
        self.chkBoxValue = "Driver"
        self.isDriverSelected = true
        
        driverChkBox.checkboxValueChangedBlock = {
            isOn in
            print("Chkbox1 checkbox is \(isOn ? "ON" : "OFF")")
            if isOn == true{
                self.isDriverSelected = true
                self.isPickAndDropSelected = false
                self.pickAndDropChkBox.setOn(false)
                self.driverChkBox.backgroundColor = UIColor.green
                self.pickAndDropChkBox.backgroundColor = UIColor.white
                self.chkBoxValue = "Driver"
            }
            else{
                self.isDriverSelected = false
                self.chkBoxValue = ""
                self.driverChkBox.backgroundColor = UIColor.white
            }
        }
        
        pickAndDropChkBox.checkboxValueChangedBlock = {
            isOn in
            print("Chkbox2 checkbox is \(isOn ? "ON" : "OFF")")
            if isOn == true{
                self.isDriverSelected = false
                self.isPickAndDropSelected = true
                self.driverChkBox.setOn(false)
                self.pickAndDropChkBox.backgroundColor = UIColor.green
                self.driverChkBox.backgroundColor = UIColor.white
                self.chkBoxValue = "Pick and Drop"
            }
            else{
                self.isPickAndDropSelected = false
                self.chkBoxValue = ""
                self.pickAndDropChkBox.backgroundColor = UIColor.white
            }
        }
        
        serviceAreaSlider.minimumValue = 0
        serviceAreaSlider.maximumValue = 1000
        serviceAreaSlider.value = 100.0
        pricePerHourSlider.minimumValue = 0
        pricePerHourSlider.maximumValue = 5000
        pricePerHourSlider.value = 500.0
        self.recordScreenView("FilterDetailsViewController", FSR_Filter)
        self.registerFirebaseEvents(PV_FSR_Filter_Screen, "", "", "", parameters: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        classificationDropDownTblView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        classificationLbl.text = "classification".localized
        requestLocLbl.text = "request_location".localized
        distanceLbl.text = "distance_label".localized
        pricePerLbl.text = "price_rs".localized
        driverLbl.text = "driver_m".localized
        pickAndDropLbl.text = "pick_drop".localized
        dateRangeLbl.text = "date_range".localized
        noOfHrsLbl.text = "no_of_hours_required".localized
        
        self.topView?.isHidden = false
        self.btnFilter?.isHidden = true
        self.btnCart?.isHidden = true
        self.btnReset?.isHidden = true
        self.lblTitle?.text = NSLocalizedString("filter", comment: "")
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.tempDictToSaveReqDetails != nil{
            tempDictToDisplayValues = appDelegate.tempDictToSaveReqDetails!
            if Validations.isNullString(tempDictToDisplayValues.value(forKey: "location") as! NSString) == false{
                
                let tempServiceArea = tempDictToDisplayValues.value(forKey: "distance") as! Int
                lblServiceArea.text = String(format:"%d km",tempServiceArea)
                serviceAreaDistanceStr = lblServiceArea.text!
                serviceAreaSlider.value = (lblServiceArea.text! as NSString).floatValue
                
                let tempPrice = tempDictToDisplayValues.value(forKey: "price") as! Int
                lblPricePerHour.text = String(format:"%d km",tempPrice)
                pricePerHourStr = lblPricePerHour.text!
                pricePerHourSlider.value = (lblPricePerHour.text! as NSString).floatValue
                
                let tempWithDriver = tempDictToDisplayValues.value(forKey: "withDriver") as! Bool
                self.driverChkBox.setOn(tempWithDriver)
                
                let tempPickAndDrop = tempDictToDisplayValues.value(forKey: "pickAndDrop") as! Bool
                self.pickAndDropChkBox.setOn(tempPickAndDrop)
                
                if let tempFromDate = tempDictToDisplayValues.value(forKey: "fromDate") as? String{
                    if let fromdate = FarmServicesConstants.getDateStringFromDateStringWithShortFormat(serverDate: tempFromDate) as String?{
                        txtFldFromDate.text = fromdate
                    }
                }
                if let tempToDate = tempDictToDisplayValues.value(forKey: "toDate") as? String{
                    if let todate = FarmServicesConstants.getDateStringFromDateStringWithShortFormat(serverDate: tempToDate) as String?{
                        txtFldToDate.text = todate
                    }
                }
                
                let tempNoOfHours = tempDictToDisplayValues.value(forKey: "noOfHours") as! Int
                txtFldNumOfHours.text = String(format:"%d",tempNoOfHours)
                numOfHoursStr = txtFldNumOfHours.text!
                
                print(appDelegate.tempClassificationMutArray)
                self.classificationListMutArray = appDelegate.tempClassificationMutArray
                
               let tempClassificationId = tempDictToDisplayValues.value(forKey: "equipmentClassification") as! Int
                
                if tempClassificationId == 0{
                    let classificationObj = self.classificationListMutArray.object(at: 0) as? Classifications
                    txtFldClassification.text = classificationObj?.value(forKey: "name") as? String
                    classificationSelectedIdStr = ""
                }
                else{
                    
                    let predicate = NSPredicate(format: "id == %@",String(tempClassificationId))
                    let filteredArray = (self.classificationListMutArray).filtered(using: predicate) as NSArray
                    //print(filteredArray)
                    
                    let classificationObj = filteredArray.object(at: 0) as? Classifications
                    txtFldClassification.text = classificationObj?.value(forKey: "name") as? String
                    
                    if let classificationSelectedId = (classificationObj?.value(forKey: "id") as? String){
                        classificationSelectedIdStr = classificationSelectedId
                    }
                }
                
                self.classificationDropDownTblView.reloadData()
                
                if Validations.isNullString(appDelegate.previousLocationStr as NSString) == false{
                    txtFldRequestLocation.text = appDelegate.previousLocationStr
                    print(appDelegate.prevLocCoordinates!)
                    self.selectLocation = appDelegate.prevLocCoordinates
                }
            }
        }
        else{
            lblServiceArea.text = String(format:"%@ km","500")
            serviceAreaSlider.minimumValue = 1
            serviceAreaDistanceStr = "500"
            
            rupee = "\u{20B9}"
            
            lblPricePerHour.text = String(format:"%@ %@",rupee,"1000")
            pricePerHourSlider.value = 1000.0
            pricePerHourStr = "1000"
            
            txtFldNumOfHours.text = "0"
            
            let net = NetworkReachabilityManager(host: "www.google.com")
            if net?.isReachable == true{
                self.requestToGetClassifications()
            }
            else{
                //self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                serviceAreaSlider.maximumValue = 1000
                pricePerHourSlider.maximumValue = 5000
            }
        }
        
        if Validations.isNullString(appDelegate.previousLocationStr as NSString) == false{
            txtFldRequestLocation.text = appDelegate.previousLocationStr
            print(appDelegate.prevLocCoordinates!)
            self.selectLocation = appDelegate.prevLocCoordinates
        }
        else{
           // appDelegate.prevLocCoordinates = selectedlocation
            self.selectLocation = getLocationCoordinate
           // self.selectLocation = appDelegate.prevLocCoordinates
            txtFldRequestLocation.text = getLocationAddress
        }
    }
    
    override func backButtonClick(_ sender: UIButton) {
        if cancelBlock != nil {
            cancelBlock!()
        }
         self.navigationController?.popViewController(animated: true)
    }
    
    override func resetButtonClick(_ sender: UIButton) {
        print("reset button clicked")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.tempDictToSaveReqDetails = nil
        
        let fromDateFormatter: DateFormatter = DateFormatter()
        fromDateFormatter.dateFormat = "dd-MMM-yyyy"
        let currentDateStr = fromDateFormatter.string(from: Date()) as String
        txtFldFromDate.text = currentDateStr
        
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let currentDate: NSDate = NSDate()
        
        let components: NSDateComponents = NSDateComponents()
        components.day = 30//2
        let toDate: NSDate = gregorian.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        
        let toDateFormatter: DateFormatter = DateFormatter()
        toDateFormatter.dateFormat = "dd-MMM-yyyy"
        let toDateStr = fromDateFormatter.string(from:toDate as Date) as String
        txtFldToDate.text = toDateStr
        
        let maxDateComponents: NSDateComponents = NSDateComponents()
        maxDateComponents.day = 45//20
        let maxDate: NSDate = gregorian.date(byAdding: maxDateComponents as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        maximumDate = maxDate
        
        self.driverChkBox.backgroundColor = UIColor.green
        self.pickAndDropChkBox.backgroundColor = UIColor.white
        self.driverChkBox.setOn(true)
        self.chkBoxValue = "Driver"
        self.isDriverSelected = true
        
        driverChkBox.checkboxValueChangedBlock = {
            isOn in
           // print("Chkbox1 checkbox is \(isOn ? "ON" : "OFF")")
            if isOn == true{
                self.isDriverSelected = true
                self.isPickAndDropSelected = false
                self.pickAndDropChkBox.setOn(false)
                self.driverChkBox.backgroundColor = UIColor.green
                self.pickAndDropChkBox.backgroundColor = UIColor.white
                
                self.chkBoxValue = "Driver"
            }
            else{
                self.isDriverSelected = false
                self.chkBoxValue = ""
                self.driverChkBox.backgroundColor = UIColor.white
            }
        }
        
        pickAndDropChkBox.checkboxValueChangedBlock = {
            isOn in
           // print("Chkbox2 checkbox is \(isOn ? "ON" : "OFF")")
            if isOn == true{
                self.isDriverSelected = false
                self.isPickAndDropSelected = true
                self.driverChkBox.setOn(false)
                self.pickAndDropChkBox.backgroundColor = UIColor.green
                self.driverChkBox.backgroundColor = UIColor.white
                self.chkBoxValue = "Pick and Drop"
            }
            else{
                self.isPickAndDropSelected = false
                self.chkBoxValue = ""
                self.pickAndDropChkBox.backgroundColor = UIColor.white
            }
        }
        
        lblServiceArea.text = String(format:"%@ km","1")
        serviceAreaSlider.minimumValue = 1
        serviceAreaDistanceStr = "1"
        
        rupee = "\u{20B9}"
        
        lblPricePerHour.text = String(format:"%@ %@",rupee,"1000")
        pricePerHourSlider.value = 1000.0
        pricePerHourSlider.maximumValue = 1000.0
        serviceAreaSlider.maximumValue = 500.0
        serviceAreaSlider.value = 3.0
        pricePerHourStr = "1000"
        txtFldNumOfHours.text = "0"
        
        if Validations.isNullString(txtFldRequestLocation.text! as NSString) == true{
            if self.selectLocation == nil{
                if LocationService.sharedInstance.currentLocation?.coordinate != nil{
                    let tempCurrentLocation = LocationService.sharedInstance.currentLocation?.coordinate
                    if tempCurrentLocation != nil {
                        self.selectLocation = tempCurrentLocation
                    }
                }
            }
        }
        
//        let parameters = ["latitude":Double((self.selectLocation?.latitude)!),"longitude":Double((self.selectLocation?.longitude)!),"location":txtFldRequestLocation.text!,"distance":(serviceAreaDistanceStr as NSString).integerValue,"price":(pricePerHourStr as NSString).integerValue,"withDriver":isDriverSelected,"pickAndDrop":isPickAndDropSelected,"fromDate":txtFldFromDate.text!,"toDate":txtFldToDate.text!,"fromTime":"","toTime":"","equipmentClassification":(classificationSelectedIdStr as NSString).integerValue,"noOfHours":txtFldNumOfHours.text!,"applyFilter":true,"maxPrice":Int(pricePerHourSlider.maximumValue),"maxDistance":Int(serviceAreaSlider.maximumValue)] as [String : Any]
//
         let parameters = ["latitude":Double((self.selectLocation?.latitude)!), "longitude":Double((self.selectLocation?.longitude)!),"distance":100,"price":500,"withDriver":true,"pickAndDrop":false,"applyFilter":false] as [String : Any]
        
        if self.filterDetailsHandler != nil {
            filterDetailsHandler!(parameters,false)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: requestToGetClassifications
    func requestToGetClassifications(){
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_REQUESTER_CLASSIFICATIONS])
        
        let userObj = Constatnts.getUserObject()
        
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        
        Alamofire.request(urlString, method: .post, parameters: ["data" : ""], encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                       // print("Response after decrypting data:\(decryptData)")
                        
                        let classificationArray = NSMutableArray()
                        let tempClassificationArray = decryptData.value(forKey: "equipmentClassification") as! NSArray
                        classificationArray.addObjects(from: tempClassificationArray as! [Any])
                        let selectTempDict = NSMutableDictionary()
                        selectTempDict.setValue(NSLocalizedString("select", comment: ""), forKey: "name")
                        classificationArray.insert(selectTempDict, at: 0)
                        
                        if let maxPriceObj = decryptData.value(forKey: "maxPrice") as? Int {
                            let maxPrice = String(format: "%d",maxPriceObj) as NSString
                            let value = Float(maxPriceObj)
                            if value  > 5000{
                                self.pricePerHourSlider.maximumValue = Float(maxPriceObj)
                            }
                            print(maxPrice)
                        }
                        else{
                            
                            self.pricePerHourSlider.maximumValue = 5000
                        }
                        
                        if let maxDistanceObj = decryptData.value(forKey: "maxDistance") as? Int {
                            let maxDistance = String(format: "%d",maxDistanceObj) as NSString
                            print(maxDistance)
                            let value = Float(maxDistanceObj)
                            if value  > 100{
                                self.serviceAreaSlider.maximumValue = Float(maxDistanceObj)
                            }
                        }
                        else{
                            self.serviceAreaSlider.maximumValue = 1000
                        }
                        
                        self.classificationListMutArray.removeAllObjects()
                        for i in 0 ..< classificationArray.count{
                            let classificationDict = classificationArray.object(at: i) as? NSDictionary
                            let classificationData = Classifications(dict: classificationDict!)
                            self.classificationListMutArray.add(classificationData)
                        }
                       
                        print(self.classificationListMutArray)
                        
//                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                        //appDelegate.tempClassificationMutArray.removeAllObjects()
//                        appDelegate.tempClassificationMutArray = self.classificationListMutArray
                        
                        DispatchQueue.main.async {
                            if let classificationDic = classificationArray.firstObject as? NSDictionary{
                                self.txtFldClassification.text = classificationDic.value(forKey: "name") as? String
                            }
                            self.classificationDropDownTblView.reloadData()
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
        }
    }
    
    @IBAction func serviceAreaSlider_Value_Changed(_ sender: Any) {
        lblServiceArea.text = String(format: "%d km",Int(serviceAreaSlider.value))
        serviceAreaDistanceStr = String(format: "%d",Int(serviceAreaSlider.value))
    }
    
    @IBAction func pricePerHourSlider_Value_Changed(_ sender: Any) {
       lblPricePerHour.text = String(format: "%@ %d",rupee,Int(pricePerHourSlider.value))
        pricePerHourStr = String(format: "%d",Int(pricePerHourSlider.value))
    }
    
    @IBAction func btnRequestLocation_Touch_Up_Inside(_ sender: Any) {
       self.navigateToGoogleLocationSearchController()
    }
    
    @IBAction func btnServiceArea_Touch_Up_Inside(_ sender: Any) {
        self.alertViewServiceAreaDistance = CustomAlert.requesterFilterDetailsAlert(self, frame: self.view.frame,title: "Distance", okButtonTitle: "OK",tag : 11) as? UIView
        self.view.addSubview(self.alertViewServiceAreaDistance!)
        self.view.bringSubview(toFront: self.alertViewServiceAreaDistance!)
        
        if alertViewServiceAreaDistance != nil{
            alertTxtFldServiceAreaDistance = alertViewServiceAreaDistance?.viewWithTag(11) as! UITextField
            alertTxtFldServiceAreaDistance.placeholder = "Enter distance in kms"
            alertTxtFldServiceAreaDistance.text = serviceAreaDistanceStr
        }
    }
    
    @IBAction func btnPricePerHour_Touch_Up_Inside(_ sender: Any) {
        self.alertViewPricePerHour = CustomAlert.requesterFilterDetailsAlert(self, frame: self.view.frame,title: "Price", okButtonTitle: "OK",tag : 12) as? UIView
        self.view.addSubview(self.alertViewPricePerHour!)
        self.view.bringSubview(toFront: self.alertViewPricePerHour!)
        
        if alertViewPricePerHour != nil{
            alertTxtFldPricePerHour = alertViewPricePerHour?.viewWithTag(12) as! UITextField
            alertTxtFldPricePerHour.placeholder = "Enter price in rupees"
            alertTxtFldPricePerHour.text = pricePerHourStr
        }
    }
    
    @IBAction func btnFromDate_Touch_Up_Inside(_ sender: Any) {
      self.fromDatePickerView()
    }
    
    @IBAction func btnToDate_Touch_Up_Inside(_ sender: Any) {
      self.toDatePickerView()
    }
    
    //MARK: fromDatePickerView
    func fromDatePickerView(){
        let Height:CGFloat = (44.11 * self.view.frame.height/120)
        let width :CGFloat = self.view.frame.size.width-40 //-40
        let posX :CGFloat = (self.view.frame.size.width - width) / 2
        
        fromDateView = UIView (frame: CGRect(x: posX,y: (self.view.frame.height-Height)/2 ,width: width,height: Height))
        fromDateView?.backgroundColor = UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        fromDateView?.layer.cornerRadius = 10.0
        self.view.addSubview(fromDateView!)
        
        //dobPicker
        let dobPicker : UIDatePicker = UIDatePicker (frame: CGRect(x: 5,y: 5,width: width-10,height: Height-50))
        dobPicker.backgroundColor = UIColor.white
        dobPicker.layer.cornerRadius = 5.0
        dobPicker.datePickerMode = UIDatePickerMode.date
        dobPicker.minimumDate = NSDate() as Date
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let tempDate = dateFormatter.date(from: txtFldFromDate.text!)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateToSetStr = dateFormatter.string(from: tempDate!)
        
        dobPicker.date = dateFormatter.date(from: dateToSetStr)!
        
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let currentDate: NSDate = NSDate()
        let components: NSDateComponents = NSDateComponents()

        components.day = 45//20
        let maxDate: NSDate = gregorian.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        dobPicker.maximumDate = maxDate as Date
        maximumDate = maxDate
        
        dobPicker.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: .valueChanged)
        fromDateView?.addSubview(dobPicker)
        
        //submit button
        let btnOK : UIButton = UIButton (frame: CGRect(x: 0, y: dobPicker.frame.maxY+5,width: width,height: 40))
        btnOK.backgroundColor = UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 0.8)
        btnOK.layer.cornerRadius = 5.0
        btnOK.setTitle(OK, for: UIControlState())
        btnOK.addTarget(self, action: #selector(FilterDetailsViewController.alertOK), for: UIControlEvents.touchUpInside)
        fromDateView?.addSubview(btnOK)
        
        let dobFrame = fromDateView?.frame
        fromDateView?.frame.size.height = btnOK.frame.maxY
        fromDateView?.frame = dobFrame!
        
        fromDateView?.frame.origin.y = (self.view.frame.size.height - 64 - (fromDateView?.frame.size.height)!) / 2
        fromDateView?.frame = dobFrame!
    }
    
    //MARK: toDatePickerView
    func toDatePickerView(){
        let Height:CGFloat = (44.11 * self.view.frame.height/120)
        let width :CGFloat = self.view.frame.size.width-40 //-40
        let posX :CGFloat = (self.view.frame.size.width - width) / 2
        
        toDateView = UIView (frame: CGRect(x: posX,y: (self.view.frame.height-Height)/2 ,width: width,height: Height))
        toDateView?.backgroundColor = UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        toDateView?.layer.cornerRadius = 10.0
        self.view.addSubview(toDateView!)
        
        //dobPicker
        let dobPicker : UIDatePicker = UIDatePicker (frame: CGRect(x: 5,y: 5,width: width-10,height: Height-50))
        dobPicker.backgroundColor = UIColor.white
        dobPicker.layer.cornerRadius = 5.0
        dobPicker.datePickerMode = UIDatePickerMode.date
        
        if Validations.isNullString(txtFldToDate.text! as NSString) == false{
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            let minDate = dateFormatter.date(from: txtFldFromDate.text!)
            let dateToSetOnPicker = dateFormatter.date(from: txtFldToDate.text!)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let str = dateFormatter.string(from: minDate!)
            dobPicker.minimumDate = dateFormatter.date(from: str)//NSDate() as Date
            
            let dateToSetStr = dateFormatter.string(from: dateToSetOnPicker!)
            dobPicker.date = dateFormatter.date(from: dateToSetStr)!
        }
        else{
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            let minDate = dateFormatter.date(from: txtFldFromDate.text!)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let str = dateFormatter.string(from: minDate!)
            
            dobPicker.minimumDate = dateFormatter.date(from: str)//NSDate() as Date
            
            let dateFormatter1: DateFormatter = DateFormatter()
            dateFormatter1.dateFormat = "dd-MMM-yyyy"
            let selectedDate = dateFormatter1.string(from: minDate!) as NSString
            
            toDateStrToSet = selectedDate as String
        }
        dobPicker.maximumDate = maximumDate as Date?
        
        dobPicker.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: .valueChanged)
        toDateView?.addSubview(dobPicker)
        
        //submit button
        let btnOK : UIButton = UIButton (frame: CGRect(x: 0, y: dobPicker.frame.maxY+5,width: width,height: 40))
        btnOK.backgroundColor = UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 0.8)
        btnOK.layer.cornerRadius = 5.0
        btnOK.setTitle(OK, for: UIControlState())
        btnOK.addTarget(self, action: #selector(FilterDetailsViewController.alertOK), for: UIControlEvents.touchUpInside)
        toDateView?.addSubview(btnOK)
        
        let dobFrame = toDateView?.frame
        toDateView?.frame.size.height = btnOK.frame.maxY
        toDateView?.frame = dobFrame!
        
        toDateView?.frame.origin.y = (self.view.frame.size.height - 64 - (toDateView?.frame.size.height)!) / 2
        toDateView?.frame = dobFrame!
    }
    
    //MARK: datePickerValueChanged
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
         if fromDateView != nil{
            toDateStrToSet = ""
            txtFldToDate.text = ""
            print(sender.date)
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            let selectedDate = dateFormatter.string(from: sender.date) as NSString
            print("Selected value \(selectedDate)")
            txtFldFromDate.text = selectedDate as String
        }
        if toDateView != nil{
            toDateStrToSet = ""
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            let selectedDate = dateFormatter.string(from: sender.date) as NSString
            print("Selected value \(selectedDate)")
            txtFldToDate.text = selectedDate as String
        }
    }
    
    @objc func alertOK(){
        if fromDateView != nil{
            txtFldToDate.text = ""
            self.fromDateView?.removeFromSuperview()
            self.fromDateView = nil
        }
        if toDateView != nil{
            if Validations.isNullString(toDateStrToSet as NSString) == false{
                txtFldToDate.text = toDateStrToSet
            }
            self.toDateView?.removeFromSuperview()
            self.toDateView = nil
        }
    }
    
    @IBAction func btnNumOfHours_Touch_Up_Inside(_ sender: Any) {
        self.alertViewNumOfHrs = CustomAlert.requesterFilterDetailsAlert(self, frame: self.view.frame,title: "No. of hours required", okButtonTitle: "OK",tag : 13) as? UIView
        self.view.addSubview(self.alertViewNumOfHrs!)
        self.view.bringSubview(toFront: self.alertViewNumOfHrs!)
        
        if alertViewNumOfHrs != nil{
            alertTxtFldNumOfHrs = alertViewNumOfHrs?.viewWithTag(13) as! UITextField
            alertTxtFldNumOfHrs.placeholder = Please_Enter_No_Of_Hours
            alertTxtFldNumOfHrs.text = txtFldNumOfHours.text
        }
    }
    
//    @IBAction func btnDriver_Touch_Up_Inside(_ sender: Any) {
//
//
//    }
//
//    @IBAction func btnPickAndDrop_Touch_Up_Inside(_ sender: Any) {
//
//
//    }
    
    @IBAction func btnApplyFilter_Touch_Up_Inside(_ sender: Any) {
        print("Driver : \(isDriverSelected) , PickAndDrop : \(isPickAndDropSelected)")
        
        let price = (pricePerHourStr as NSString).integerValue
        
        if Validations.isNullString(txtFldRequestLocation.text! as NSString) == true{
            self.view.makeToast(Please_Enter_Location)
            return
        }
        if Validations.isNullString(txtFldToDate.text! as NSString) == true{
            self.view.makeToast(Please_Select_To_Date_PlaceHolder)
            return
        }
        if price == 0{
            self.view.makeToast(Price_Not_Zero)
            return
        }
        
//        if Validations.isNullString(classificationSelectedIdStr as NSString) == false{
//            let numOfHrs = (txtFldNumOfHours.text! as NSString).integerValue
//            let minHrsOfEquip = (minServiceHours as NSString).integerValue
//
//            if numOfHrs < minHrsOfEquip{
//                self.view.makeToast("num of hrs should not be less than min service hrs")
//                return
//            }
//        }
        var fromDate = txtFldFromDate.text ?? ""
        if let tempFromDate = FarmServicesConstants.getDateFromDateStringWithShortFormat(serverDate: txtFldFromDate.text){
            fromDate = FarmServicesConstants.getDateStringFromDate(serverDate: tempFromDate) as String? ?? txtFldFromDate.text!
        }
        var toDate = txtFldToDate.text ?? ""
        if let tempToDate = FarmServicesConstants.getDateFromDateStringWithShortFormat(serverDate: txtFldToDate.text){
            toDate = FarmServicesConstants.getDateStringFromDate(serverDate: tempToDate) as String? ?? txtFldToDate.text!
        }
        let parameters = ["latitude":Double((self.selectLocation?.latitude)!),"longitude":Double((self.selectLocation?.longitude)!),"location":txtFldRequestLocation.text!,"distance":(serviceAreaDistanceStr as NSString).integerValue,"price":(pricePerHourStr as NSString).integerValue,"withDriver":isDriverSelected,"pickAndDrop":isPickAndDropSelected,"fromDate":fromDate,"toDate":toDate,"fromTime":"","toTime":"","equipmentClassification":(classificationSelectedIdStr as NSString).integerValue,"noOfHours":(txtFldNumOfHours.text! as NSString).integerValue,"applyFilter":true,"maxPrice":Int(pricePerHourSlider.maximumValue),"maxDistance":Int(serviceAreaSlider.maximumValue)] as [String : Any]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.tempDictToSaveReqDetails = parameters as NSDictionary
        appDelegate.tempClassificationMutArray = self.classificationListMutArray
        
        if self.filterDetailsHandler != nil {
            filterDetailsHandler!(parameters,true)
        }
        let userObj = Constatnts.getUserObject()
        let fireBaseParams = [MOBILE_NUMBER: userObj.mobileNumber!,USER_ID: userObj.customerId ?? "",EquipmentClassificatnId:classificationSelectedIdStr,ServiceAreaDistance:serviceAreaDistanceStr,PricePerHour:pricePerHourStr,PickAndDrop:isPickAndDropSelected,NoofHoursRequired:txtFldNumOfHours.text!,From_Date:fromDate,To_Date:toDate,EQUIPMENT_CLASSIFICATION:txtFldClassification!.text!] as [String : Any]
        self.registerFirebaseEvents(FSR_Apply_Filter, "", "", "", parameters: fireBaseParams as NSDictionary)
         self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: alert view button methods
    @objc func alertSubmitBtn(){
        if alertViewServiceAreaDistance != nil{
            alertTxtFldServiceAreaDistance = alertViewServiceAreaDistance?.viewWithTag(11) as! UITextField
           // alertTxtFldServiceAreaDistance.delegate = self
            print(alertTxtFldServiceAreaDistance.text!)
            if Validations.isNullString(alertTxtFldServiceAreaDistance.text! as NSString) == true {
                self.view.makeToast("Enter Distance", duration: 1.0, position: .center)
                return
            }
            else{
                serviceAreaDistanceStr = alertTxtFldServiceAreaDistance.text!
                lblServiceArea.text = String(format:"%@ km",alertTxtFldServiceAreaDistance.text!)
                let value = Float(serviceAreaDistanceStr)!
                if value > serviceAreaSlider.maximumValue {
                    serviceAreaSlider.maximumValue = value
                }
                alertViewServiceAreaDistance?.removeFromSuperview()
            }
        }
        if alertViewPricePerHour != nil{
            alertTxtFldPricePerHour = alertViewPricePerHour?.viewWithTag(12) as! UITextField
            // alertTxtFldServiceAreaDistance.delegate = self
            print(alertTxtFldPricePerHour.text!)
            if Validations.isNullString(alertTxtFldPricePerHour.text! as NSString) == true {
                self.view.makeToast("Enter Price", duration: 1.0, position: .center)
                return
            }
            else{
                pricePerHourStr = alertTxtFldPricePerHour.text!
                lblPricePerHour.text = String(format:"%@ %@",rupee,alertTxtFldPricePerHour.text!)
                let value = Float(alertTxtFldPricePerHour.text!)!
                if value > pricePerHourSlider.maximumValue {
                    pricePerHourSlider.maximumValue = value
                }
                pricePerHourSlider.value = Float(alertTxtFldPricePerHour.text!)!
                alertViewPricePerHour?.removeFromSuperview()
            }
        }
        if alertViewNumOfHrs != nil{
            alertTxtFldNumOfHrs = alertViewNumOfHrs?.viewWithTag(13) as! UITextField
            // alertTxtFldServiceAreaDistance.delegate = self
            print(alertTxtFldNumOfHrs.text!)
            if Validations.isNullString(alertTxtFldNumOfHrs.text! as NSString) == true {
                self.view.makeToast("Enter Hours", duration: 1.0, position: .center)
                return
            }
            else{
                numOfHoursStr = alertTxtFldNumOfHrs.text!
                txtFldNumOfHours.text = alertTxtFldNumOfHrs.text!
                alertViewNumOfHrs?.removeFromSuperview()
            }
        }
    }
    
    @objc func alertCloseBtn(){
        if alertViewServiceAreaDistance != nil{
            alertTxtFldServiceAreaDistance.resignFirstResponder()
            alertViewServiceAreaDistance?.removeFromSuperview()
            alertViewServiceAreaDistance = nil
        }
        if alertViewPricePerHour != nil{
            alertTxtFldPricePerHour.resignFirstResponder()
            alertViewPricePerHour?.removeFromSuperview()
            alertViewPricePerHour = nil
        }
        if alertViewNumOfHrs != nil{
            alertTxtFldNumOfHrs.resignFirstResponder()
            alertViewNumOfHrs?.removeFromSuperview()
            alertViewNumOfHrs = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func navigateToGoogleLocationSearchController(){
        let addressSearchViewController = GoogleSearchViewController()
        addressSearchViewController.isFromAddress = true
        addressSearchViewController.addressCompletionBlock = {(selectedlocation ,address,isFromAddress,fromHomeNav,viewBounds) in
            if Validations.isNullString(address as NSString) == false{
                self.txtFldRequestLocation?.text = address
                self.txtFldRequestLocation?.resignFirstResponder()
                
                print(selectedlocation)
                
                self.selectLocation = selectedlocation
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.previousLocationStr = address
                appDelegate.prevLocCoordinates = selectedlocation
                
                self.dismiss(animated: true, completion: nil)
                UIView.animate(withDuration: 0.1) {
                    self.view.endEditing(true)
                }
                self.view.endEditing(true)
            }
        }
        self.registerFirebaseEvents(PV_FSR_Location, "", "", "", parameters: nil)
        let navController = UINavigationController(rootViewController: addressSearchViewController)
        navController.navigationBar.tintColor = self.navigationController?.navigationBar.tintColor
        navController.navigationBar.barTintColor = self.navigationController?.navigationBar.tintColor
        //self.present(navController, animated: true, completion: nil)
        self.present(navController, animated: true) {
        }
    }
    
    //MARK: sendRequestToGetEquipmentDetails
    func sendRequestToGetEquipmentDetails(){
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
//            let parameters = ["latitude":Double((self.selectLocation?.latitude)!), "longitude":Double((self.selectLocation?.longitude)!),"location": txtFldRequestLocation.text!,"distance": Int(serviceAreaDistanceStr) ?? 3,"price": Int(pricePerHourStr) ?? 500,"withDriver":true,"pickAndDrop":false,"fromDate":txtFldFromDate.text!,"toDate":txtFldToDate.text!,"fromTime":"","toTime":"","equipmentClassification":1,"noOfHours":Int(txtFldNumOfHours.text!) ?? 0,"applyFilter":true,"maxPrice":Int(pricePerHourStr) ?? 500,"maxDistance":Int(pricePerHourStr) ?? 500] as NSDictionary
//            let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
//            let params =  ["data" : paramsStr]
//            print(params)
//            self.requestToGetFilterDetails(equipmentParams:params as [String:String])
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
    }
    
    //MARK: requestToGetFilterDetails
    func requestToGetFilterDetails (equipmentParams : [String:String]){
        SwiftLoader.show(animated: true)
        
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_EQUIPMENT_LIST])
        
        let userObj = Constatnts.getUserObject()
        
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        print(headers)
        
        Alamofire.request(urlString, method: .post, parameters: equipmentParams, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        //print("Response after decrypting data:\(decryptData)")
                    }
                }
            }
        }
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

extension FilterDetailsViewController :  UITableViewDataSource, UITableViewDelegate{
    //MARK: dropdown tableview datasource & delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classificationListMutArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 14.0)
        let classificationCell = classificationListMutArray.object(at: indexPath.row) as? Classifications
        cell.textLabel?.text = classificationCell?.value(forKey: "name") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let classificationCell = classificationListMutArray.object(at: indexPath.row) as? Classifications
        txtFldClassification.text = classificationCell?.value(forKey: "name") as? String
        if let classificationSelectedId = (classificationCell?.value(forKey: "id") as? String){
             classificationSelectedIdStr = classificationSelectedId
        }
        else{
            classificationSelectedIdStr = ""
        }
        //minServiceHours = (classificationCell?.value(forKey: "minimumServiceHours") as? String)!
        classificationDropDownTblView.isHidden = true
    }
}

extension FilterDetailsViewController : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       // classificationDropDownTblView.isHidden = true
        if textField == txtFldFromDate{
            txtFldFromDate.resignFirstResponder()
            self.fromDatePickerView()
        }
        else if textField == txtFldToDate{
            txtFldToDate.resignFirstResponder()
            self.toDatePickerView()
        }
        else if textField == txtFldNumOfHours{
            txtFldNumOfHours.resignFirstResponder()
            
            self.alertViewNumOfHrs = CustomAlert.requesterFilterDetailsAlert(self, frame: self.view.frame,title: Enter_Number_Of_Hours as NSString, okButtonTitle: "OK",tag : 13) as? UIView
            self.view.addSubview(self.alertViewNumOfHrs!)
            self.view.bringSubview(toFront: self.alertViewNumOfHrs!)
            
            if alertViewNumOfHrs != nil{
                alertTxtFldNumOfHrs = alertViewNumOfHrs?.viewWithTag(13) as! UITextField
                alertTxtFldNumOfHrs.placeholder = Please_Enter_No_Of_Hours
                alertTxtFldNumOfHrs.text = txtFldNumOfHours.text
            }
        }
        else if textField == txtFldRequestLocation{
            txtFldRequestLocation.resignFirstResponder()
            //self.view.endEditing(true)
            //IQKeyboardManager.sharedManager().resignFirstResponder()
            self.navigateToGoogleLocationSearchController()
        }
        else if textField == txtFldClassification{
            txtFldClassification.resignFirstResponder()
            classificationDropDownTblView.isHidden = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 11 {
            let validCharSet = CharacterSet(charactersIn: "0123456789").inverted
            let filtered: String = (string.components(separatedBy: validCharSet) as NSArray).componentsJoined(by: "")
            let _char = string.cString(using: String.Encoding.utf8)
            let isBackSpace: Int = Int(strcmp(_char, "\\b"))
            if isBackSpace == -92 {
                // is backspace
                print("backspace")
                if textField.text?.count == 1 {
                    print("textField is empty")
                }
                return true
            }
            if (filtered == "") {
                print("invalid characters")
            }
            if (textField.text?.count)! >= 3 && range.length == 0 {
                print("exceeded")
                return false
            }
            return (string == filtered)
        }
        else if textField.tag == 12 {
            let validCharSet = CharacterSet(charactersIn: "0123456789").inverted
            let filtered: String = (string.components(separatedBy: validCharSet) as NSArray).componentsJoined(by: "")
            let _char = string.cString(using: String.Encoding.utf8)
            let isBackSpace: Int = Int(strcmp(_char, "\\b"))
            if isBackSpace == -92 {
                // is backspace
                print("backspace")
                if textField.text?.count == 1 {
                    print("textField is empty")
                }
                return true
            }
            if (filtered == "") {
                print("invalid characters")
            }
            if (textField.text?.count)! >= 4 && range.length == 0 {
                print("exceeded")
                return false
            }
            return (string == filtered)
        }
        else if textField.tag == 13 {
            let validCharSet = CharacterSet(charactersIn: "0123456789").inverted
            let filtered: String = (string.components(separatedBy: validCharSet) as NSArray).componentsJoined(by: "")
            let _char = string.cString(using: String.Encoding.utf8)
            let isBackSpace: Int = Int(strcmp(_char, "\\b"))
            if isBackSpace == -92 {
                // is backspace
                print("backspace")
                if textField.text?.count == 1 {
                    print("textField is empty")
                }
                return true
            }
            if (filtered == "") {
                print("invalid characters")
            }
            if (textField.text?.count)! >= 4 && range.length == 0 {
                print("exceeded")
                return false
            }
            return (string == filtered)
        }
        return true
    }
}
