//
//  MultipuleDaySelection.swift
//  FarmerConnect
//
//  Created by Admin on 03/01/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import GoogleMaps

class MultipuleDaySelection: UIView ,UITextFieldDelegate,GrowingTextViewDelegate,UITextViewDelegate {
    
    @IBOutlet var txtFromSchedule : UITextField?
    @IBOutlet var txtToSchedule : UITextField?
    @IBOutlet var txtPricePerHour : UITextField?
    @IBOutlet var lblMinServiceHours : UILabel?
    @IBOutlet var lblAvailableDates : UILabel?
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var inputContainerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtLocation: NextGrowingTextView!
    @IBOutlet var lblDistance : UILabel?
    @IBOutlet var lblAvailTimings : UILabel?
    @IBOutlet var contentView : UIView?
    @IBOutlet var scrollView : UIScrollView?
    @IBOutlet var lblMultipleProviders : UILabel?
    @IBOutlet var btnMultipleProviders : UIButton?
    let appdelegate = UIApplication.shared.delegate as? AppDelegate

    var fromDateView : UIView?

    var selectedEquipment : Equipment?
    var arrAvailableDates : NSArray?
    var serviceHours : NSInteger?
    var pricePerHour : NSInteger?
    var selecteddate : String?
    var fromTime : String?
    var toTime : String?
    var fromDate : String?
    var toDate : String?
    var delegate : UIViewController?
    var selectedLocation : CLLocationCoordinate2D?
    var activeTextField : UITextField?
    var scheduleDatePicker : UIDatePicker?
    var isFromEdit : Bool = false
    var isFromProvider : Bool = false
    var placeOrder : PlaceOrder?
    var placeOrderAlert : UIView?
    var multipleProvidersAlert : UIView?
    let geocoder = GMSGeocoder()
    var distanceAlert : UIView?
    var cropId : Int = 0
    //var arrAraayTimes = ["12am","1am","2am","3am","4am","5am","6am","7am","8am","9am","10am","11am","12pm","1pm","2pm","3pm","4pm","5pm","6pm","7pm","8pm","9pm","10pm","11pm"]
    //var arrAraayFormattedTimes = ["24:00:00","01:00:00","02:00:00","03:00:00","04:00:00","05:00:00","06:00:00","07:00:00","08:00:00","09:00:00","10:00:00","11:00:00","12:00:00","13:00:00","14:00:00","15:00:00","16:00:00","17:00:00","18:00:00","19:00:00","20:00:00","21:00:00","22:00:00","23:00:00"]
    
    var arrAvailableSlots = NSMutableArray()
    let selectableIndexPaths = NSMutableArray()
    var selectedIndexPaths    = NSMutableArray()
    var fromIndex : NSInteger?
    var toIndex : NSInteger?
    
    var nibName: String {
        return String(describing: type(of: self))
    }
    
    /**
     *  Called when first loading the nib.
     *  Defaults to `[NSBundle bundleForClass:[self class]]`
     *
     *  @return The bundle in which to find the nib.
     */
    var nibBundle: Bundle {
        return Bundle(for: type(of: self))
    }
    
    /**
     *  Use the 2 methods above to instanciate the correct instance of UINib for the view.
     *  You can override this if you need more customization.
     *
     *  @return An instance of UINib
     */
    
    var nib: UINib {
        return UINib(nibName: self.nibName, bundle: self.nibBundle)
    }
    
    class func instanceFromNib() -> MultipuleDaySelection {
        return UINib(nibName: "MultipuleDaySelection", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MultipuleDaySelection
    }
    fileprivate var shouldAwakeFromNib: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        //self.createFromNib()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.shouldAwakeFromNib = false
        self.commonInit()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    func commonInit(){
        let scheduleRightView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 35))
        scheduleRightView.backgroundColor = UIColor.clear
        let btnSchedule = UIButton(type: .custom)
        btnSchedule.frame = CGRect(x: 0, y: 6, width: 20, height: 20)
        btnSchedule.setImage(UIImage(named: "Calader"), for: .normal)
        scheduleRightView.addSubview(btnSchedule)
        txtFromSchedule?.rightView = scheduleRightView
        txtFromSchedule?.rightViewMode = .always
        
        let toRightView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 35))
        toRightView.backgroundColor = UIColor.clear
        let btnToSchedule = UIButton(type: .custom)
        btnToSchedule.frame = CGRect(x: 0, y: 6, width: 20, height: 20)
        btnToSchedule.setImage(UIImage(named: "Calader"), for: .normal)
        toRightView.addSubview(btnToSchedule)
        txtToSchedule?.rightView = toRightView
        txtToSchedule?.rightViewMode = .always
        txtToSchedule?.setLeftPaddingPoints(5)
        txtFromSchedule?.setLeftPaddingPoints(5)
        txtLocation.textView.delegate = self
        //collectionTimeRange?.register(EquipDateCollectionViewCell.self, forCellWithReuseIdentifier: "EquipDateCell")
        if self.selectedEquipment != nil {
            lblMinServiceHours?.text = selectedEquipment?.minimumServiceHours as String?
            txtPricePerHour?.text = selectedEquipment?.pricePerHour as String?
        }
        let priceLeftView = UILabel(frame:CGRect( x: 0, y: 0, width: 10, height: 35))
        priceLeftView.text = Currency
        priceLeftView.textAlignment = .center
        priceLeftView.font = txtPricePerHour?.font
        txtPricePerHour?.leftView = priceLeftView
        txtPricePerHour?.leftViewMode = .always

    }
    
    //MARK: fromDatePickerView
    func fromAndToDatePickerView(){
        if delegate != nil && selectedEquipment != nil{
            
            let Height:CGFloat = UIScreen.main.bounds.size.height
            let width :CGFloat = UIScreen.main.bounds.size.width //-40
            //let posX :CGFloat = (delegate!.view.frame.size.width - width) / 2
            
            fromDateView = UIView (frame: CGRect(x: 0,y: 0 ,width: width,height: Height))
            fromDateView?.backgroundColor = UIColor.black.withAlphaComponent(0.44)
            fromDateView?.layer.cornerRadius = 10.0
            appdelegate?.window?.addSubview(fromDateView!)
            
            //dobPicker
            scheduleDatePicker = UIDatePicker (frame: CGRect(x: 5,y: (Height-200)/2,width: width-10,height: 200))
            scheduleDatePicker?.backgroundColor = UIColor.white
            scheduleDatePicker?.layer.cornerRadius = 5.0
            scheduleDatePicker?.datePickerMode = UIDatePickerMode.date
            scheduleDatePicker?.minimumDate = Date()
            let minDate = FarmServicesConstants.getDateFromDateString(dateStr: selectedEquipment?.startDate as String? ?? "")
            scheduleDatePicker?.minimumDate = minDate as Date?
            
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            if activeTextField == txtToSchedule{
                if Validations.isNullString(txtFromSchedule?.text as NSString? ?? "" as NSString) == false{
                    if let tempDate = dateFormatter.date(from: (txtFromSchedule?.text!)!) as Date?{
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let dateToSetStr = dateFormatter.string(from: tempDate)
                        scheduleDatePicker?.minimumDate = tempDate
                        scheduleDatePicker?.date = dateFormatter.date(from: dateToSetStr)!
                    }
                }
            }
            let maxDate = FarmServicesConstants.getDateFromDateString(dateStr: selectedEquipment?.endDate as String? ?? "")
            scheduleDatePicker?.maximumDate = maxDate as Date?
            
            //scheduleDatePicker?.addTarget(self, action: #selector(MultipuleDaySelection.datePickerValueChanged(_:)), for: .valueChanged)
            fromDateView?.addSubview(scheduleDatePicker!)
            
            let closeView : UIButton = UIButton (frame: CGRect(x: scheduleDatePicker!.frame.maxX-25,y: scheduleDatePicker!.frame.minY - 16,width: 35,height: 35))
            closeView.backgroundColor = UIColor.clear//UIColorFromRGB(headerBlueCOlor, alpha: 1)
            closeView.setImage(UIImage(named: "CropDetailsDeleteImg"), for: UIControlState())
            closeView.setTitle("", for: UIControlState())
            closeView.addTarget(self, action: #selector(MultipuleDaySelection.closeDatePicerViewButtonClick(_:)), for: .touchUpInside)
            fromDateView?.addSubview(closeView)
            //submit button
            let btnOK : UIButton = UIButton (frame: CGRect(x: 5, y: scheduleDatePicker!.frame.maxY,width: width-10,height: 40))
            btnOK.backgroundColor = UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 1.0)
            btnOK.layer.cornerRadius = 5.0
            btnOK.setTitle(OK, for: UIControlState())
            btnOK.addTarget(self, action: #selector(MultipuleDaySelection.alertOK), for: UIControlEvents.touchUpInside)
            fromDateView?.addSubview(btnOK)
            
            let dobFrame = fromDateView?.frame
            fromDateView?.frame.size.height = btnOK.frame.maxY
            fromDateView?.frame = dobFrame!
            
            fromDateView?.frame.origin.y = (delegate!.view.frame.size.height - 64 - (fromDateView?.frame.size.height)!) / 2
            fromDateView?.frame = dobFrame!
        }
    }
    
    @IBAction func closeDatePicerViewButtonClick(_ sender: UIButton){
        if fromDateView != nil {
            fromDateView?.removeFromSuperview()
            fromDateView = nil
        }
    }
    @objc func alertOK(){
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let scheduleFrom = scheduleDatePicker?.date
        let selecteddateStr = FarmServicesConstants.getDateStringFromDate(serverDate: scheduleFrom)
        if arrAvailableDates != nil{
            if  arrAvailableDates!.contains(selecteddateStr!) {
                if activeTextField == txtFromSchedule{
                    txtToSchedule?.text = ""
                    let scheduleDateStr = FarmServicesConstants.getDateStringFromDateWithShortMonth(serverDate: scheduleFrom)
                    txtFromSchedule?.text = scheduleDateStr as String?
                    fromDate = selecteddateStr as String?
                    placeOrder?.fromDate = fromDate as NSString?
                    placeOrder?.toDate = nil
                    self.fromDateView?.removeFromSuperview()
                    self.fromDateView = nil
                    activeTextField?.resignFirstResponder()
                    activeTextField = nil
                }
                if activeTextField == txtToSchedule{
                    if let fromDateStr = txtFromSchedule?.text as String?{
                        if let fromDate = FarmServicesConstants.getDateFromDateStringWithShortFormat(serverDate: fromDateStr) as Date?{
                            if fromDate.compare(scheduleFrom!) == .orderedDescending{
                                txtToSchedule?.text = ""
                                self.fromDateView?.removeFromSuperview()
                                self.fromDateView = nil
                                activeTextField?.resignFirstResponder()
                                activeTextField = nil
                                self.makeToast(To_Date_Greater_To_From)
                                return
                            }
                        }
                    }
                    let scheduleDateStr = FarmServicesConstants.getDateStringFromDateWithShortMonth(serverDate: scheduleFrom)
                    txtToSchedule?.text = scheduleDateStr as String?
                    toDate = selecteddateStr as String?
                    placeOrder?.toDate = selecteddateStr
                    self.fromDateView?.removeFromSuperview()
                    self.fromDateView = nil
                    activeTextField?.resignFirstResponder()
                    activeTextField = nil
                }
            }
            else{
                fromDateView?.makeToast(Please_Select_Available_Date)
            }
        }
        else{
            fromDateView?.makeToast(Please_Select_Available_Date)
        }

    }
    func getTimeSlotsForSelectedDay(_ selectedDate: String){
        if self.selectedEquipment != nil {
            let userObj = Constatnts.getUserObject()
            let headers : HTTPHeaders = ["userAuthorizationToken": userObj.userAuthorizationToken! as String,"mobileNumber":userObj.mobileNumber! as String,"customerId": userObj.customerId! as String,"deviceToken":userObj.deviceToken as String,"deviceId":userObj.deviceId! as String];
            SwiftLoader.show(animated: true)
            let urlString = String(format: "%@%@", arguments: [BASE_URL,Equipment_DateWise_Availability])
            let parameters = ["equipmentId":selectedEquipment!.equipmentId!,"selectedDate":selectedDate] as [String : Any]
            let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
            let params =  ["data" : paramsStr]
            //print(params)
            Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                SwiftLoader.hide()
                if response.result.error == nil {
                    if let json = response.result.value {
                        //print("Response :\(json)")
                        let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                        if responseStatusCode == STATUS_CODE_200{
                            let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                            let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                           // print("Response after decrypting data:\(decryptData)")
                            //self.navigationController?.popViewController(animated: true)
                            
                        }
                        else{
                            if let message = (json as! NSDictionary).value(forKey: "message") as? String {
                                self.makeToast(message)
                            }
                        }
                    }
                }
                else{
                    self.makeToast((response.error?.localizedDescription)!)
                }
            }
        }
    }
    func placeOrderForMultiDayServiceCall() -> NSDictionary?{
        if self.validationgOrderDetails() == true {
            if selectedEquipment != nil{
                let userObj = Constatnts.getUserObject()
                let paramsDic = NSMutableDictionary()
                paramsDic.setValue(selectedEquipment!.equipmentId as String?, forKey:"equipmentId" )
                paramsDic.setValue(userObj.customerId as String?, forKey: "requestedUserId")
                paramsDic.setValue(placeOrder!.latitude as String?, forKey: "latitude")
                paramsDic.setValue(placeOrder!.longitude as String?, forKey:"longitude" )
                paramsDic.setValue(placeOrder!.locationName as String?, forKey:"locationName" )
                paramsDic.setValue(cropId, forKey: "cropId")
                let dateStr = String(format:"%@,%@",placeOrder!.fromDate! ,placeOrder!.toDate! )
                paramsDic.setValue(dateStr, forKey:"date" )
                //paramsDic.setValue(placeOrder!.noOfHoursRequired as String!, forKey:"noOfHoursRequired" )
                //paramsDic.setValue(placeOrder!.startTime as String!, forKey: "startTime")
                //paramsDic.setValue(placeOrder!.endTime as String!, forKey: "endTime")
                paramsDic.setValue(placeOrder!.pricePerHour as String?, forKey: "pricePerHour")
                paramsDic.setValue(false, forKey: "singleDaySelected")
                if btnMultipleProviders?.isSelected == true && placeOrder?.multipleProviderCheck ?? false == true{
                    paramsDic.setValue(true, forKey: "multipleProviderCheck")
                    paramsDic.setValue(placeOrder!.multipleProviderPrice, forKey: "multipleProviderPrice")
                    paramsDic.setValue(placeOrder!.multipleProviderDistance, forKey: "multipleProviderDistance")
                }
                else{
                    paramsDic.setValue(false, forKey: "multipleProviderCheck")
                }
                if (isFromEdit == true || isFromProvider == true) && placeOrder?.equipmentTransactionId != nil{
                    paramsDic.setValue(placeOrder!.equipmentTransactionId, forKey: "equipmentTransactionId")
                }
                if isFromProvider == true && placeOrder?.counterRequest ?? false == true{
                    paramsDic.setValue(true, forKey: "counterRequest")
                }
                else if isFromEdit == true{
                    paramsDic.setValue(false, forKey: "counterRequest")
                }
                return paramsDic
            }
            else{
                return nil
            }
        }
        else{
            return nil
        }
    }
    
    func validationgOrderDetails() -> Bool{
        if placeOrderAlert != nil{
            placeOrderAlert?.removeFromSuperview()
        }
        
        if placeOrder != nil && selectedEquipment != nil{
            if Validations.isNullString(placeOrder?.fromDate as NSString? ?? "" as NSString) == true || Validations.isNullString(txtFromSchedule?.text as NSString? ?? "" as NSString) == true{
                placeOrderAlert = CustomAlert.alertInfoPopUpView(self, frame: UIScreen.main.bounds, title: NSLocalizedString("alert", comment: "") as NSString, message: Please_Select_From_Date as NSString, buttonTitle: OK, hideClose: true) as? UIView
                self.appdelegate?.window?.addSubview(placeOrderAlert!)
                return false
            }
            else if Validations.isNullString(placeOrder?.toDate as NSString? ?? "" as NSString) == true || Validations.isNullString(txtToSchedule?.text as NSString? ?? "" as NSString) == true{
                placeOrderAlert = CustomAlert.alertInfoPopUpView(self, frame: UIScreen.main.bounds, title: NSLocalizedString("alert", comment: "") as NSString, message: Please_Select_To_Date as NSString, buttonTitle: NSLocalizedString("ok", comment: ""), hideClose: true) as? UIView
                self.appdelegate?.window?.addSubview(placeOrderAlert!)
                return false
            }
            /*else if Validations.isNullString(placeOrder?.startTime as NSString? ?? "" as NSString) == true{
                placeOrderAlert = CustomAlert.alertInfoPopUpView(self, frame: UIScreen.main.bounds, title: "Alert", message: "Required service hours should be more than or equal to minimum service hours.", buttonTitle: "OK", hideClose: true) as? UIView
                self.appdelegate?.window?.addSubview(placeOrderAlert!)
                return false
            }
            else if Validations.isNullString(placeOrder?.endTime as NSString? ?? "" as NSString) == true{
                placeOrderAlert = CustomAlert.alertInfoPopUpView(self, frame: UIScreen.main.bounds, title: "Alert", message: "Required service hours should be more than or equal to minimum service hours.", buttonTitle: "OK", hideClose: true) as? UIView
                self.appdelegate?.window?.addSubview(placeOrderAlert!)
                return false
            }*/
            else if Validations.isNullString(placeOrder?.locationName as NSString? ?? "" as NSString) == true{
                placeOrderAlert = CustomAlert.alertInfoPopUpView(self, frame: UIScreen.main.bounds, title: NSLocalizedString("alert", comment: "") as NSString, message: Please_Select_Location as NSString, buttonTitle: NSLocalizedString("ok", comment: ""), hideClose: true) as? UIView
                self.appdelegate?.window?.addSubview(placeOrderAlert!)
                return false
            }
            else if Validations.isNullString(placeOrder?.latitude as NSString? ?? "" as NSString) == true || Validations.isNullString(placeOrder?.longitude as NSString? ?? "" as NSString) == true{
                placeOrderAlert = CustomAlert.alertInfoPopUpView(self, frame: UIScreen.main.bounds, title: NSLocalizedString("alert", comment: "") as NSString, message: Please_Select_Location as NSString, buttonTitle: NSLocalizedString("ok", comment: ""), hideClose: true) as? UIView
                self.appdelegate?.window?.addSubview(placeOrderAlert!)
                return false
            }
            /*else if (placeOrder?.noOfHoursRequired?.integerValue ?? 0 == 0)||(placeOrder?.noOfHoursRequired?.integerValue ?? 0 < selectedEquipment?.minimumServiceHours?.integerValue ?? 0){
                placeOrderAlert = CustomAlert.alertInfoPopUpView(self, frame: UIScreen.main.bounds, title: "Alert", message: "Required service hours should be more than or equal to minimum service hours.", buttonTitle: "OK", hideClose: true) as? UIView
                self.appdelegate?.window?.addSubview(placeOrderAlert!)
                return false
            }*/
            else{
                return true
            }
        }
        else{
            return false
        }
    }
    func updateDataToUiComponents(){
        if self.selectedEquipment != nil {
            lblMinServiceHours?.text = selectedEquipment?.minimumServiceHours as String?
            txtPricePerHour?.text = selectedEquipment?.pricePerHour as String?
            //txtLocation?.textView.text = selectedEquipment?.locationName as String!
            lblAvailTimings?.text = selectedEquipment?.availableTimings as String?
            lblDistance?.text = selectedEquipment?.serviceAreaDistance as String?
            if isFromProvider == true{
                txtPricePerHour?.text = placeOrder?.pricePerHour as String?
                txtPricePerHour?.isUserInteractionEnabled = true
                txtPricePerHour?.setLeftPaddingPoints(5)
                btnMultipleProviders?.isUserInteractionEnabled = false
                self.txtLocation?.isUserInteractionEnabled = false
                self.txtPricePerHour?.borderStyle = .line
                //self.timeSelectionView?.isHidden = false
            }
            var availableDates = "Available dates : "
            if arrAvailableDates != nil{
                for index in 0..<arrAvailableDates!.count{
                    if let dateStr = arrAvailableDates!.object(at: index) as? String{
                        if let fromDate = FarmServicesConstants.getDateFromDateString(dateStr: dateStr) as NSDate?{
                            if let availDateStr = FarmServicesConstants.getDateStringFromDateWithShortMonth(serverDate: fromDate as Date) as String?{
                                if index == 0{
                                   availableDates = availableDates.appendingFormat("%@",availDateStr )
                                }
                                else{
                                    availableDates = availableDates.appendingFormat(",%@",availDateStr )
                                }
                            }
                        }
                    }
                }
            }
            lblAvailableDates?.text = availableDates
            lblAvailableDates?.sizeToFit()
            self.layoutIfNeeded()
            self.updateConstraintsIfNeeded()
            if let minDate = FarmServicesConstants.getDateFromDateString(dateStr: selectedEquipment?.startDate as String? ?? "") as NSDate?{
                if let fromDate = FarmServicesConstants.getDateStringFromDateWithShortMonth(serverDate: minDate as Date) as String?{
                    txtFromSchedule?.text = fromDate

                }
            }
        }
        if isFromEdit == true || isFromProvider == true {
            if placeOrder != nil{
                if let minDate = FarmServicesConstants.getDateFromDateString(dateStr: placeOrder?.fromDate as String? ?? "") as NSDate?{
                    if let fromDate = FarmServicesConstants.getDateStringFromDateWithShortMonth(serverDate: minDate as Date) as String?{
                        txtFromSchedule?.text = fromDate
                    }
                }
                if let maxDate = FarmServicesConstants.getDateFromDateString(dateStr: placeOrder?.toDate as String? ?? "") as NSDate?{
                    if let toDate = FarmServicesConstants.getDateStringFromDateWithShortMonth(serverDate: maxDate as Date) as String?{
                        txtToSchedule?.text = toDate
                    }
                }
                placeOrder?.multipleProviderCheck = false
                placeOrder?.multipleProviderPrice = ""
                placeOrder?.multipleProviderDistance = ""
                if isFromProvider == true{
                    btnMultipleProviders?.isHidden = true
                    lblMultipleProviders?.isHidden = true
                }
                txtLocation.textView.text = placeOrder?.locationName as String?
                if Validations.isNullString(placeOrder?.distance as NSString? ?? "" as NSString) == false{
                    self.lblDistance?.text = String(format:"%@ kms",placeOrder?.distance as String? ?? "")
                }
            }
        }
        else{
            placeOrder = PlaceOrder(dict: NSDictionary())
            placeOrder?.singleDaySelected = false
            placeOrder?.equipmentId = selectedEquipment?.equipmentId
            placeOrder?.pricePerHour = selectedEquipment?.pricePerHour
            //placeOrder?.latitude = selectedEquipment?.latitude
            //placeOrder?.longitude = selectedEquipment?.longitude
            //placeOrder?.locationName = selectedEquipment?.locationName
            placeOrder?.fromDate = selectedEquipment?.startDate
        }
        if Validations.isNullString(placeOrder?.locationName as NSString? ?? "" as NSString) == true{
            if self.selectedLocation == nil{
                if LocationService.sharedInstance.currentLocation?.coordinate != nil{
                    let tempCurrentLocation = LocationService.sharedInstance.currentLocation?.coordinate
                    if tempCurrentLocation != nil {
                        self.selectedLocation = tempCurrentLocation
                        placeOrder?.latitude = NSString(string: String(format: "%f", (tempCurrentLocation?.latitude)!))
                        placeOrder?.longitude =  NSString(string: String(format: "%f", (tempCurrentLocation?.longitude)!))
                        if Validations.isNullString(LocationService.sharedInstance.currentAddress ?? "") == false{
                            self.txtLocation.textView.text = LocationService.sharedInstance.currentAddress as String?
                        }
                        self.reverseGeocodeCoordinate(coordinate: tempCurrentLocation!)
                    }
                }
            }
        }
        self.heightConstraint.constant = (self.contentView?.frame.maxY)! + 20
        self.layoutIfNeeded()
        self.updateConstraintsIfNeeded()
        self.scrollView?.contentSize = CGSize(width: (self.scrollView?.frame.size.width)!, height: (self.contentView?.frame.maxY)! + 40)
        self.updateScrollViewContentSize()
    }
    func updateScrollViewContentSize(){
        if delegate != nil {
            if let bookNowController = delegate as? BookNowViewController{
                bookNowController.viewWillLayoutSubviews()
            }
        }
    }

    func clearAllDate(){
        txtFromSchedule?.text = ""
        txtToSchedule?.text = ""
        selecteddate = nil
        fromIndex = nil
        toIndex = nil
        fromTime = nil
        toTime = nil
        fromDate = nil
        toDate = nil
        self.placeOrder = nil
        btnMultipleProviders?.isSelected = false
        arrAvailableSlots.removeAllObjects()
        selectableIndexPaths.removeAllObjects()
        selectedIndexPaths.removeAllObjects()
    }
    func calculateDistanceBetweenLocations(){
        
        //My location
        let myLocation = CLLocation(latitude: (self.selectedLocation?.latitude)!, longitude: (self.selectedLocation?.longitude)!)
        print(myLocation)
        //equipment location
        if let equipmentLocation = CLLocation(latitude: ((self.selectedEquipment?.equipmentLatitude)?.doubleValue)!, longitude: ((self.selectedEquipment?.equipmentLongitude)?.doubleValue)!) as CLLocation?{
            //print(equipmentLocation)
            let distance = myLocation.distance(from: equipmentLocation) / 1000
            print(distance)
            var percentVal = distance
            let num : Float = Float((percentVal).roundToPlaces(places: 2))
            let roundedValue = ((num * 100) / 100).rounded()
            var roundedInt = Int(roundedValue)
            if roundedInt < 1{
                roundedInt = 1
            }
            //print(roundedValue)
            self.lblDistance?.text = String(format:"%d kms",roundedInt)
        }

    }
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                
                // 3
                //print("Location \(address.coordinate)!)")
                let lines = address.lines
                self.selectedLocation = coordinate
                if self.selectedLocation != nil{
                    self.calculateDistanceBetweenLocations()
                }
                self.txtLocation?.textView.text = lines?.joined(separator: ",")
                if self.placeOrder != nil{
                    self.placeOrder?.latitude = String(format: "%f", coordinate.latitude) as NSString
                    self.placeOrder?.longitude = String(format: "%f", coordinate.longitude) as NSString
                    self.placeOrder?.locationName = self.txtLocation.textView.text as NSString?
                }
            }
        }
    }
    @IBAction func btnDistance_Touch_Up_Inside(_ sender: Any) {
        if distanceAlert != nil{
            distanceAlert?.removeFromSuperview()
        }
        distanceAlert = CustomAlert.alertDistanceInfoPopUpView(self, frame: UIScreen.main.bounds, title: NSLocalizedString("distance_label", comment: "") as NSString, message: DISTANCE_ALERT_MESSAGE as NSString, buttonTitle: OK, hideClose: true) as? UIView
        self.appdelegate?.window?.addSubview(distanceAlert!)
    }
    
    @objc func distanceAlertOK(){
        if distanceAlert != nil{
            distanceAlert?.removeFromSuperview()
        }
    }
    @IBAction func sendMultipleProvidersButtonClick(_ sender : UIButton){
        btnMultipleProviders?.isSelected  = !(btnMultipleProviders?.isSelected)!
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDateTimeStr = dateFormatter.string(from: currentDate)
        let currentDateTime = dateFormatter.date(from: currentDateTimeStr)
        if btnMultipleProviders?.isSelected == true {
            btnMultipleProviders?.isSelected = false
            if placeOrder != nil{
                if Validations.isNullString(placeOrder?.fromDate as NSString? ?? "" as NSString) == true{
                    placeOrderAlert = CustomAlert.alertInfoPopUpView(self, frame: UIScreen.main.bounds, title: ALERT as NSString, message: Please_Select_From_Date as NSString, buttonTitle: OK, hideClose: true) as? UIView
                    self.appdelegate?.window?.addSubview(placeOrderAlert!)
                }
                else if Validations.isNullString(placeOrder?.toDate as NSString? ?? "" as NSString) == true{
                    placeOrderAlert = CustomAlert.alertInfoPopUpView(self, frame: UIScreen.main.bounds, title: ALERT as NSString, message: Please_Select_To_Date as NSString, buttonTitle: OK, hideClose: true) as? UIView
                    self.appdelegate?.window?.addSubview(placeOrderAlert!)
                }
                else{
                    self.multipleProvidersAlert = CustomAlert.sendMultipleProvidersAlertPopUpView(self, title: "Multiple request configuration", frame: UIScreen.main.bounds, okButtonTitle: OK as NSString) as? UIView
                    let txtPricePerHour = multipleProvidersAlert?.viewWithTag(55555) as? UITextField
                    let txtMaxDistance = multipleProvidersAlert?.viewWithTag(66666) as? UITextField
                    if txtPricePerHour != nil && txtMaxDistance != nil{
                        txtPricePerHour?.text = selectedEquipment!.pricePerHour as String?
                        //txtMaxDistance?.text = selectedEquipment!.maxSerAreaDistProvided as String!
                        txtMaxDistance?.text = lblDistance?.text?.replacingOccurrences(of: "kms", with: "")
                    }
                    self.appdelegate?.window?.addSubview(multipleProvidersAlert!)
                }
            }
        }
        else{
            placeOrder?.multipleProviderDistance = ""
            placeOrder?.multipleProviderPrice = ""
            placeOrder?.multipleProviderCheck = false
        }
    }
    //MARK: UITextfield Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtFromSchedule || textField == txtToSchedule{
            activeTextField = textField
            fromAndToDatePickerView()
            self.endEditing(true)
            textField.resignFirstResponder()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if isFromProvider == true && textField == txtPricePerHour{
            placeOrder?.pricePerHour = txtPricePerHour?.text as NSString?
            placeOrder?.pricePerHour = placeOrder?.pricePerHour?.replacingOccurrences(of: Currency, with: "") as NSString?
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //MARK: Growing TextView Delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if isFromProvider == false{
            self.pickLocationFromSelectLocationScreen()
        }
        textView.resignFirstResponder()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        
    }

    @IBAction func editLocationButtonClick(_ sender: UIButton){
        if isFromProvider == false {
            self.pickLocationFromSelectLocationScreen()
        }
    }
    func pickLocationFromSelectLocationScreen(){
        if delegate != nil && self.selectedEquipment != nil{
            let selectLocationController = self.delegate?.storyboard?.instantiateViewController(withIdentifier: "SelectLocationViewController") as? SelectLocationViewController
            if selectedLocation != nil{
                selectLocationController?.selectLocation = self.selectedLocation
            }
            else if isFromEdit == true && placeOrder != nil{
                if Validations.isNullString(placeOrder?.latitude as NSString? ?? "" as NSString) == false || Validations.isNullString(placeOrder?.longitude as NSString? ?? "" as NSString) == false{
                    let orderLocation = CLLocationCoordinate2D(latitude: placeOrder!.latitude!.doubleValue, longitude: placeOrder!.longitude!.doubleValue) as CLLocationCoordinate2D?
                    if orderLocation != nil{
                        selectLocationController?.selectLocation = orderLocation
                    }
                }
            }
            /*else{
             if selectedEquipment?.longitude != nil && selectedEquipment?.latitude != nil{
             if let selectLocation = CLLocationCoordinate2D(latitude: (selectedEquipment?.latitude?.doubleValue)!, longitude: (selectedEquipment?.longitude?.doubleValue)!) as CLLocationCoordinate2D?{
             selectLocationController?.selectLocation = selectLocation
             }
             }
             }*/
            selectLocationController?.addressCompletionBlock = {(selectedlocation ,address,postalCode,isFromAddress,fromHomeNav) in
                if Validations.isNullString(address as NSString) == false{
                    self.txtLocation?.textView.text = address
                    self.txtLocation?.textView.resignFirstResponder()
                    self.selectedLocation = selectedlocation
                    self.placeOrder?.locationName = address as NSString
                    self.placeOrder?.latitude = NSString(string: String(format:"%f",selectedlocation.latitude))
                    self.placeOrder?.longitude = NSString(string: String(format:"%f",selectedlocation.longitude))
                    self.heightConstraint.constant = (self.contentView?.frame.maxY)! + 20
                    self.calculateDistanceBetweenLocations()
                    self.layoutIfNeeded()
                    self.updateConstraintsIfNeeded()
                    self.scrollView?.contentSize = CGSize(width: (self.scrollView?.frame.size.width)!, height: (self.contentView?.frame.maxY)! + 40)
                    UIView.animate(withDuration: 0.1) {
                        self.endEditing(true)
                    }
                    self.endEditing(true)
                }
                selectLocationController?.navigationController?.popViewController(animated: true)
            }
            self.endEditing(true)
            self.txtLocation.textView.resignFirstResponder()
            self.delegate?.navigationController?.pushViewController(selectLocationController!, animated: true)
        }
    }
    //MARK: Custom Alert Delegate Methods
    @objc func infoAlertSubmit(){
        if self.placeOrderAlert != nil {
            self.placeOrderAlert?.removeFromSuperview()
        }
        if self.multipleProvidersAlert != nil {
            self.multipleProvidersAlert?.removeFromSuperview()
        }
    }
    @objc func sendMultipleProvidersClose()
    {
        if self.placeOrderAlert != nil {
            self.placeOrderAlert?.removeFromSuperview()
        }
        if self.multipleProvidersAlert != nil {
            self.multipleProvidersAlert?.removeFromSuperview()
        }
        btnMultipleProviders?.isSelected = false
        placeOrder?.multipleProviderCheck = false
        placeOrder?.multipleProviderPrice = nil
        placeOrder?.multipleProviderDistance = nil
        self.endEditing(true)
    }
    @objc func multipleProvidersOk()
    {
        if self.placeOrderAlert != nil {
            self.placeOrderAlert?.removeFromSuperview()
        }
        self.endEditing(true)
        if self.multipleProvidersAlert != nil {
            let txtPricePerHour = multipleProvidersAlert?.viewWithTag(55555) as? UITextField
            let txtMaxDistance = multipleProvidersAlert?.viewWithTag(66666) as? UITextField
            if txtPricePerHour != nil && txtMaxDistance != nil{
                if Validations.isNullString(txtPricePerHour?.text as NSString? ?? "" as NSString) == true{
                    appdelegate?.window?.makeToast(Price_Per_Hour_Empty)
                }
                else if NSString(string: String(format:"%@",(txtPricePerHour?.text)!)).integerValue == 0{
                    appdelegate?.window?.makeToast(Price_Should_Not_Zero)
                }
                else if Validations.isNullString(txtMaxDistance?.text as NSString? ?? "" as NSString) == true{
                    appdelegate?.window?.makeToast(Max_Distance_Empty)
                }
                else if NSString(string: String(format:"%@",(txtMaxDistance?.text)!)).integerValue == 0{
                    appdelegate?.window?.makeToast(Distance_Not_Equal_To_Zero)
                }
                else{
                    placeOrder?.multipleProviderDistance = txtMaxDistance?.text as NSString?
                    placeOrder?.multipleProviderPrice = txtPricePerHour?.text as NSString?
                    placeOrder?.multipleProviderCheck = true
                    self.btnMultipleProviders?.isSelected = true
                    self.multipleProvidersAlert?.removeFromSuperview()
                }
            }
            //self.multipleProvidersAlert?.removeFromSuperview()
        }
    }
}
