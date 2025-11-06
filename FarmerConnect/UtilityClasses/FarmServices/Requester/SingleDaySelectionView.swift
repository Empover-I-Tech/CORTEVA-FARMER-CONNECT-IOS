//
//  SingleDaySelectionView.swift
//  FarmerConnect
//
//  Created by Admin on 02/01/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import GoogleMaps

class SingleDaySelectionView: UIView, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,GrowingTextViewDelegate,UITextViewDelegate {

    @IBOutlet var collectionTimeRange : UICollectionView?
    @IBOutlet var txtSchedule : UITextField?
    @IBOutlet var txtPricePerHour : UITextField?
    @IBOutlet var lblMinServiceHours : UILabel?
    //@IBOutlet var txtLocation : GrowingTextView?
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var inputContainerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtLocation: NextGrowingTextView!
    @IBOutlet var lblDistance : UILabel?
    @IBOutlet var lblSelectedHours : UILabel?
    @IBOutlet var timeSelectionView : UIView?
    @IBOutlet var contentView : UIView?
    @IBOutlet var scrollView : UIScrollView?
    @IBOutlet var lblMultipleProviders : UILabel?
    @IBOutlet var btnMultipleProviders : UIButton?

    let appdelegate = UIApplication.shared.delegate as? AppDelegate
    var selectedEquipment : Equipment?
    var arrAvailableDates : NSArray?
    var serviceHours : NSInteger?
    var pricePerHour : NSInteger?
    var selecteddate : String?
    var fromTime : String?
    var toTime : String?
    var delegate : UIViewController?
    var selectedLocation : CLLocationCoordinate2D?
    var isFromEdit : Bool = false
    var isFromProvider : Bool = false
    var placeOrder : PlaceOrder?
    var placeOrderAlert : UIView?
    var multipleProvidersAlert : UIView?
    var distanceAlert : UIView?
    let geocoder = GMSGeocoder()
    
    var cropId : Int = 0
    var arrAraayTimes = ["12am","1am","2am","3am","4am","5am","6am","7am","8am","9am","10am","11am","12pm","1pm","2pm","3pm","4pm","5pm","6pm","7pm","8pm","9pm","10pm","11pm"]
    //var arrAraayFormattedTimes = ["00:00:00","01:00:00","02:00:00","03:00:00","04:00:00","05:00:00","06:00:00","07:00:00","08:00:00","09:00:00","10:00:00","11:00:00","12:00:00","13:00:00","14:00:00","15:00:00","16:00:00","17:00:00","18:00:00","19:00:00","20:00:00","21:00:00","22:00:00","23:00:00"]
    var arrAraayFormattedTimes = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
    
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
    
    class func instanceFromNib() -> SingleDaySelectionView {
        return UINib(nibName: "SingleDaySelectionView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SingleDaySelectionView
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
        txtSchedule?.tintColor = UIColor.clear
        collectionTimeRange?.register(UINib.init(nibName: "BookNowTimeCell", bundle: nil), forCellWithReuseIdentifier: "TimeCell")
        timeSelectionView?.isHidden = true
        let scheduleRightView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 35))
        scheduleRightView.backgroundColor = UIColor.clear
        let btnSchedule = UIButton(type: .custom)
        btnSchedule.frame = CGRect(x: 0, y: 6, width: 20, height: 20)
        btnSchedule.setImage(UIImage(named: "Calader"), for: .normal)
        scheduleRightView.addSubview(btnSchedule)
        txtSchedule?.rightView = scheduleRightView
        txtSchedule?.rightViewMode = .always
        txtLocation.textView.delegate = self
        txtSchedule?.setLeftPaddingPoints(5)
        //txtPricePerHour?.setLeftPaddingPoints(5)
        let priceLeftView = UILabel(frame:CGRect( x: 0, y: 0, width: 10, height: 35))
        priceLeftView.text = Currency
        priceLeftView.textAlignment = .center
        priceLeftView.font = txtPricePerHour?.font
        txtPricePerHour?.leftView = priceLeftView
        txtPricePerHour?.leftViewMode = .always
        txtPricePerHour?.isUserInteractionEnabled = false

        //collectionTimeRange?.register(EquipDateCollectionViewCell.self, forCellWithReuseIdentifier: "EquipDateCell")
        if self.selectedEquipment != nil {
            lblMinServiceHours?.text = String(format:"%@ hour(s)",selectedEquipment?.minimumServiceHours as String? ?? "")
            txtPricePerHour?.text = String(format:"%@",selectedEquipment?.pricePerHour as String? ?? "")
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
            print(params)
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
                            //self.navigationController?.popViewController(animated: true)
                            if let minimumHours = Validations.checkKeyNotAvail(decryptData, key: "minimumServiceHours") as? NSInteger{
                                self.serviceHours = minimumHours
//                                self.lblDistance?.text = String(format:"%d kms",minimumHours)
                            }
                            if let price = Validations.checkKeyNotAvail(decryptData, key: "pricePerHour") as? NSInteger{
                                self.pricePerHour = price
                                self.txtPricePerHour?.text = String(format:"%d",price)
                                self.placeOrder?.pricePerHour = String(format:"%d",price) as NSString
                            }
                            if let arrAvailableHours = Validations.checkKeyNotAvailForArray(decryptData, key: "availableHours") as? NSArray{
                                self.timeSelectionView?.isHidden = false
                                self.generateAvaialableTimeSlotsFromServerData(arrAvailableHours: arrAvailableHours)
                                if self.arrAvailableSlots.count > 0{
                                    for index in 0..<self.arrAraayFormattedTimes.count {
                                        let compStr = self.arrAraayFormattedTimes[index] as String
                                        if self.arrAvailableSlots.contains(compStr){
                                            self.selectableIndexPaths.add(index)
                                        }
                                    }
                                }
                                self.collectionTimeRange?.reloadData()
                                self.updateDataToUiComponents()
                                self.placeOrder?.fromDate = selectedDate as NSString
                            }
                            else{
                                if let message = (json as! NSDictionary).value(forKey: "message") as? String {
                                    self.makeToast(message)
                                }
                            }
                        }
                        else if responseStatusCode == STATUS_CODE_601{
                            Constatnts.logOut()
                            if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                self.makeToast(msg as String)
                            }
                        }
                    }
                    else{
                        self.makeToast((response.error?.localizedDescription)!)
                    }
                }
            }
        }
    }
    
    func placeOrderForSingleDayServiceCall() -> NSDictionary?{
        if self.validationgOrderDetails() == true {
            if selectedEquipment != nil{
                let userObj = Constatnts.getUserObject()
                let paramsDic = NSMutableDictionary()
                var getSelectedFromTime = placeOrder!.startTime as String?
                var getSelectedToTime = placeOrder!.endTime as String?
                getSelectedFromTime = (getSelectedFromTime ?? "00") + ":00:00"
                getSelectedToTime = (getSelectedToTime ?? "00") + ":00:00"
                paramsDic.setValue(selectedEquipment!.equipmentId as String?, forKey:"equipmentId" )
                paramsDic.setValue(userObj.customerId as String?, forKey: "requestedUserId")
                paramsDic.setValue(placeOrder!.latitude as String?, forKey: "latitude")
                paramsDic.setValue(placeOrder!.longitude as String?, forKey:"longitude" )
                paramsDic.setValue(placeOrder!.locationName as String?, forKey:"locationName" )
                paramsDic.setValue(placeOrder!.fromDate as String?, forKey:"date" )
                paramsDic.setValue(placeOrder!.noOfHoursRequired as String?, forKey:"noOfHoursRequired" )
                paramsDic.setValue(getSelectedFromTime as String?, forKey: "startTime")
                paramsDic.setValue(getSelectedToTime as String?, forKey: "endTime")
                paramsDic.setValue(placeOrder!.pricePerHour as String?, forKey: "pricePerHour")
                paramsDic.setValue(cropId, forKey: "cropId")
                paramsDic.setValue(true, forKey: "singleDaySelected")
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
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH"
        let currentDateTimeStr = dateFormatter.string(from: currentDate)
        let currentDateTime = dateFormatter.date(from: currentDateTimeStr)
        if placeOrder != nil && selectedEquipment != nil{
            if Validations.isNullString(placeOrder?.fromDate as NSString? ?? "" as NSString) == true{
                placeOrderAlert = CustomAlert.alertInfoPopUpView(self, frame: UIScreen.main.bounds, title: ALERT as NSString, message: Schedule_Date_Not_Empty as NSString, buttonTitle: OK, hideClose: true) as? UIView
                self.appdelegate?.window?.addSubview(placeOrderAlert!)
                return false
            }
            else if Validations.isNullString(placeOrder?.startTime as NSString? ?? "" as NSString) == true{
                placeOrderAlert = CustomAlert.alertInfoPopUpView(self, frame: UIScreen.main.bounds, title: ALERT as NSString, message: Minimum_Service_Hours_Required as NSString, buttonTitle: OK, hideClose: true) as? UIView
                self.appdelegate?.window?.addSubview(placeOrderAlert!)
                return false
            }
            else if Validations.isNullString(placeOrder?.endTime as NSString? ?? "" as NSString) == true{
                placeOrderAlert = CustomAlert.alertInfoPopUpView(self, frame: UIScreen.main.bounds, title: ALERT as NSString, message: Minimum_Service_Hours_Required as NSString, buttonTitle: OK , hideClose: true) as? UIView
                self.appdelegate?.window?.addSubview(placeOrderAlert!)
                return false
            }
            else if (placeOrder?.noOfHoursRequired?.integerValue ?? 0 == 0)||(placeOrder?.noOfHoursRequired?.integerValue ?? 0 < selectedEquipment?.minimumServiceHours?.integerValue ?? 0){
                placeOrderAlert = CustomAlert.alertInfoPopUpView(self, frame: UIScreen.main.bounds, title: ALERT as NSString, message: Minimum_Service_Hours_Required as NSString, buttonTitle: OK , hideClose: true) as? UIView
                self.appdelegate?.window?.addSubview(placeOrderAlert!)
                return false
            }
            else if Validations.isNullString(placeOrder?.locationName as NSString? ?? "" as NSString) == true{
                placeOrderAlert = CustomAlert.alertInfoPopUpView(self, frame: UIScreen.main.bounds, title: ALERT as NSString, message: Request_Location_Not_Empty as NSString, buttonTitle: OK, hideClose: true) as? UIView
                self.appdelegate?.window?.addSubview(placeOrderAlert!)
                return false
            }
            else if Validations.isNullString(placeOrder?.latitude as NSString? ?? "" as NSString) == true || Validations.isNullString(placeOrder?.longitude as NSString? ?? "" as NSString) == true{
                placeOrderAlert = CustomAlert.alertInfoPopUpView(self, frame: UIScreen.main.bounds, title: ALERT as NSString, message: Request_Location_Not_Empty as NSString , buttonTitle: OK, hideClose: true) as? UIView
                self.appdelegate?.window?.addSubview(placeOrderAlert!)
                return false
            }
            else if Validations.isNullString((placeOrder?.startTime)!) == false && Validations.isNullString((placeOrder?.fromDate)!) == false{
                let fromDateStr = String(format: "%@ %@", placeOrder?.fromDate ?? "",placeOrder?.startTime ?? "")
                if let fromDateTime = dateFormatter.date(from: fromDateStr) as Date?{
                    if currentDateTime!.compare(fromDateTime) != .orderedAscending {
                        placeOrderAlert = CustomAlert.alertInfoPopUpView(self, frame: UIScreen.main.bounds, title: ALERT as NSString, message: Start_Time_Greater_To_Current as NSString, buttonTitle: OK , hideClose: true) as? UIView
                        self.appdelegate?.window?.addSubview(placeOrderAlert!)
                        return false
                    }
                    else{
                        return true
                    }
                }
            }
            else{
                return true
            }
        }
        else{
            return false
        }
        return false
    }
    func updateDataToUiComponents(){
        if self.selectedEquipment != nil {
            lblMinServiceHours?.text = String(format:"%@ hour(s)",selectedEquipment?.minimumServiceHours as String? ?? "")
            if selectedEquipment?.pricePerHour != nil{
                txtPricePerHour?.text = String(format:"%@",selectedEquipment?.pricePerHour as String? ?? "")
            }
            txtPricePerHour?.isUserInteractionEnabled = false
            lblDistance?.text = String(format:"%@ kms",selectedEquipment?.serviceAreaDistance as String? ?? "")
            if isFromProvider == true{
                txtPricePerHour?.text = String(format:"%@",placeOrder?.pricePerHour as String? ?? "")
                txtPricePerHour?.isUserInteractionEnabled = true
                btnMultipleProviders?.isUserInteractionEnabled = false
                self.txtSchedule?.isUserInteractionEnabled = false
                self.txtPricePerHour?.borderStyle = .line
                //self.timeSelectionView?.isHidden = false
            }
        }
        if isFromEdit == true || isFromProvider == true{
            if placeOrder != nil{
                if Validations.isNullString(placeOrder?.pricePerHour ?? "") == false{
                    txtPricePerHour?.text = String(format:"%@",placeOrder?.pricePerHour as String? ?? "")
                }
                txtLocation?.textView.text = placeOrder?.locationName as String?
                if Validations.isNullString(placeOrder?.distance as NSString? ?? "" as NSString) == false{
                    self.lblDistance?.text = String(format:"%@ kms",placeOrder?.distance as String? ?? "")
                }
                /*if let minDate = FarmServicesConstants.getDateFromDateString(dateStr: placeOrder?.fromDate as String!) as NSDate?{
                    if let fromDate = FarmServicesConstants.getDateStringFromDateWithShortMonth(serverDate: minDate as Date) as String?{
                        txtSchedule?.text = fromDate
                        //self.getTimeSlotsForSelectedDay(placeOrder!.fromDate as String!)
                    }
                }*/
                if placeOrder?.startTime != nil{
                    if let fromInd = arrAraayFormattedTimes.index(of: (placeOrder?.startTime)! as String){
                        self.fromIndex = fromInd
                    }
                }
                if placeOrder?.endTime != nil{
                    if let toInd = arrAraayFormattedTimes.index(of: (placeOrder?.endTime)! as String){
                        if toInd < arrAraayFormattedTimes.count{
                            if self.toIndex == 0{
                                self.toIndex = arrAraayFormattedTimes.count
                            }
                            else{
                                self.toIndex = toInd - 1
                            }
                        }
                    }
                }
                self.createSelectionRangeArrayFromIndexes()
                self.collectionTimeRange?.reloadData()
                placeOrder?.multipleProviderCheck = false
                placeOrder?.multipleProviderPrice = ""
                placeOrder?.multipleProviderDistance = ""
                if isFromProvider == true{
                    btnMultipleProviders?.isHidden = true
                    lblMultipleProviders?.isHidden = true
                }
            }
        }
        else{
            if isFromProvider == false{
                placeOrder = PlaceOrder(dict: NSDictionary())
                placeOrder?.singleDaySelected = true
                placeOrder?.equipmentId = selectedEquipment?.equipmentId
                placeOrder?.pricePerHour = selectedEquipment?.pricePerHour
                //placeOrder?.latitude = selectedEquipment?.latitude
                //placeOrder?.longitude = selectedEquipment?.longitude
                //placeOrder?.locationName = selectedEquipment?.locationName
            }
        }
        if Validations.isNullString(placeOrder?.locationName as NSString? ?? "" as NSString) == true{
            if self.selectedLocation == nil{
                if LocationService.sharedInstance.currentLocation?.coordinate != nil{
                    let tempCurrentLocation = LocationService.sharedInstance.currentLocation?.coordinate
                    if tempCurrentLocation != nil {
                        self.selectedLocation = tempCurrentLocation
                        placeOrder?.latitude = NSString(string: String(format: "%f", (tempCurrentLocation?.latitude)!))
                        placeOrder?.longitude = NSString(string: String(format: "%f", (tempCurrentLocation?.longitude)!))
                        if Validations.isNullString(LocationService.sharedInstance.currentAddress ?? "") == false{
                            self.txtLocation.textView.text = LocationService.sharedInstance.currentAddress as String?
                            placeOrder?.locationName = LocationService.sharedInstance.currentAddress
                        }
                        self.reverseGeocodeCoordinate(coordinate: tempCurrentLocation!)
                    }
                }
            }
        }
        if #available(iOS 11.0, *) {
            let offset = CGPoint(x: -((scrollView?.adjustedContentInset.left)!), y: -((scrollView?.adjustedContentInset.top)!))
            scrollView?.setContentOffset(offset, animated: true)
            
        } else {
            let offset = CGPoint(x: -((scrollView?.contentInset.left)!), y: -((scrollView?.contentInset.top)!))
            scrollView?.setContentOffset(offset, animated: true)
        }
        self.heightConstraint.constant = (self.timeSelectionView?.frame.maxY)! + 20
        self.layoutIfNeeded()
        self.updateConstraintsIfNeeded()
        self.scrollView?.contentSize = CGSize(width: (self.scrollView?.frame.size.width)!, height: (timeSelectionView?.frame.maxY)! + 40)
        self.updateScrollViewContentSize()
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
    
    func updateScrollViewContentSize(){
        if delegate != nil {
            if let bookNowController = delegate as? BookNowViewController{
                bookNowController.viewWillLayoutSubviews()
            }
        }
    }
    func loadTimeSlotsToCollectionView(arrAvailTimes: NSArray){
        self.generateAvaialableTimeSlotsFromServerData(arrAvailableHours: arrAvailableSlots)
        if self.arrAvailableSlots.count > 0{
            for index in 0..<self.arrAraayFormattedTimes.count {
                let compStr = self.arrAraayFormattedTimes[index] as String
                if self.arrAvailableSlots.contains(compStr){
                    self.selectableIndexPaths.add(index)
                }
            }
        }
        print(self.selectableIndexPaths)
        self.collectionTimeRange?.reloadData()
    }
func generateAvaialableTimeSlotsFromServerData(arrAvailableHours: NSArray){
    if arrAvailableHours.count > 0{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let arrTempAvailableSlots = NSMutableArray()
        for index in 0..<arrAvailableHours.count{
            if let rangeString = arrAvailableHours.object(at: index) as? String{
                if Validations.isNullString(rangeString as NSString ) == false{
                    var availString = rangeString
                    availString = (availString.replacingOccurrences(of: " ", with: "") as NSString?) as String? ?? ""
                    let arrFullAvailable = availString.components(separatedBy: ",") as NSArray?
                    if arrFullAvailable != nil{
                        if arrFullAvailable!.count > 1{
                            if let strFromTime = arrFullAvailable?.object(at: 0) as? String,
                                let strToTime = arrFullAvailable?.object(at: 1) as? String{
                                
                                let fromArrayString = strFromTime.components(separatedBy: ":") as NSArray?
                                let toArrayString = strToTime.components(separatedBy: ":") as NSArray?
                                
                                var fromString = fromArrayString?.object(at: 0) as? String
                                var toString = toArrayString?.object(at: 0) as? String
                                
                                
                                fromString = fromString! .trimmingCharacters(in: NSCharacterSet .whitespacesAndNewlines)
                                toString = toString! .trimmingCharacters(in: NSCharacterSet .whitespacesAndNewlines)
                                if fromString == "24"{
                                    fromString = "00"
                                }
                                if (fromString!.count > 0 ) && toString!.count > 0{
                                    if let fromDate = dateFormatter.date(from: fromString!), let toDate = dateFormatter.date(from: toString!){
                                        var dateComponents = DateComponents()
                                        dateComponents.hour = 1;
                                        var toTempDate = fromDate
                                        arrTempAvailableSlots.add(fromString!)
                                        while toTempDate < toDate{
                                            if let tomorrow = Calendar.current.date(byAdding: .hour, value: 1, to: toTempDate) as Date?{
                                                toTempDate = tomorrow
                                                let availString = dateFormatter.string(from: tomorrow)
                                                arrTempAvailableSlots.add(availString)
                                            }
                                            else{
                                                break
                                            }
                                        }
                                        if arrTempAvailableSlots.count > 1{
                                            arrTempAvailableSlots.removeLastObject()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        if arrTempAvailableSlots.count > 0{
            self.arrAvailableSlots = arrTempAvailableSlots
        }
    }
}
    func clearAllDate(){
        txtSchedule?.text = ""
        lblSelectedHours?.text = ""
        selecteddate = nil
        fromIndex = nil
        toIndex = nil
        fromTime = nil
        toTime = nil
        placeOrder = nil
        arrAvailableSlots.removeAllObjects()
        selectableIndexPaths.removeAllObjects()
        selectedIndexPaths.removeAllObjects()
        timeSelectionView?.isHidden = true
    }
    
    
    @IBAction func btnDistance_Touch_Up_Inside(_ sender: Any) {
        if distanceAlert != nil{
            distanceAlert?.removeFromSuperview()
        }
        let distanceStr = NSLocalizedString("distance_label", comment: "")
        distanceAlert = CustomAlert.alertDistanceInfoPopUpView(self, frame: UIScreen.main.bounds, title: distanceStr as NSString, message: DISTANCE_ALERT_MESSAGE as NSString, buttonTitle: OK , hideClose: true) as? UIView
        self.appdelegate?.window?.addSubview(distanceAlert!)
    }
    
    @objc func distanceAlertOK(){
        if distanceAlert != nil{
            distanceAlert?.removeFromSuperview()
        }
    }
    
    //MARK: collectionView datasource and delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrAraayTimes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionTimeRange?.dequeueReusableCell(withReuseIdentifier: "TimeCell", for: indexPath) as? BookNowTimeCell
        let topLabel = cell?.viewWithTag(100) as? UILabel
        let topImage = cell?.viewWithTag(103) as? UIImageView
        let bgButton = cell?.viewWithTag(101) as? UIButton
        let bottomLabel = cell?.viewWithTag(102) as? UILabel
        let bottomImage = cell?.viewWithTag(104) as? UIImageView
        bgButton?.borderColor = UIColor.black
        bgButton?.borderWidth = 1.0
        topImage?.isHidden = false
        bottomImage?.isHidden = false
        
        bgButton?.addTarget(self, action: #selector(SingleDaySelectionView.timeSlotButtonClick(_:)), for: .touchUpInside)
        if indexPath.row % 2 == 1 {
            topLabel?.isHidden = true
            topImage?.isHidden = true
            bottomLabel?.isHidden = false
            bottomLabel?.text = arrAraayTimes[indexPath.row]
        }
        else{
            topLabel?.isHidden = false
            bottomLabel?.isHidden = true
            bottomImage?.isHidden = true
            topLabel?.text = arrAraayTimes[indexPath.row]
        }
        if selectableIndexPaths.contains(indexPath.row) {
            cell?.isOutofRange = false
        }
        else{
            cell?.isOutofRange = true
        }
        cell?.isSelected = selectedIndexPaths.contains(indexPath.row)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: (collectionView.frame.size.width/12), height: 68)
        //print(cellSize)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)//top,left,bottom,right
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.updateSelectedIndexPathsRange(indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath) as? BookNowTimeCell
        if cell?.isOutofRange == false {
            return true
        }
        return false
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let index = selectedIndexPaths.index(of: indexPath.row) as NSInteger?{
            selectedIndexPaths.remove(index)
        }
        self.collectionTimeRange?.reloadData()
    }
    //MARK: UITextfield Delegate Methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtSchedule {
            if arrAvailableDates == nil{
                return false
            }
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtSchedule {
            if arrAvailableDates != nil{
                if delegate != nil && self.arrAvailableDates!.count > 0{
                    let bookCalanderController = self.delegate?.storyboard?.instantiateViewController(withIdentifier: "BookNowCalanderViewController") as? BookNowCalanderViewController
                    bookCalanderController?.arrAvailability = NSMutableArray(array: self.arrAvailableDates!)
                    bookCalanderController?.dateSelectionCompletionBlock = {(selectedDateStr, selectedDate) in
                        if selectedDate != nil || selectedDateStr != nil{
                            if selectedDateStr != nil{
                                let placeorder = self.placeOrder
                                self.clearAllDate()
                                if self.isFromEdit == true{
                                    placeorder?.startTime = ""
                                    placeorder?.endTime = ""
                                    placeorder?.fromDate = ""
                                    self.placeOrder = placeorder
                                }
                                self.selecteddate = selectedDateStr
                                self.placeOrder?.fromDate = selectedDateStr as NSString?
                                let selecDate = FarmServicesConstants.getDateFromDateString(dateStr: selectedDateStr!)
                                let formattedDate = FarmServicesConstants.getDateStringFromDateWithShortMonth(serverDate: selecDate as Date?)
                                self.txtSchedule?.text = formattedDate as String?
                                self.getTimeSlotsForSelectedDay(selectedDateStr!)
                            }
                        }
                    }
                    self.endEditing(true)
                    self.txtSchedule?.resignFirstResponder()
                    self.delegate?.navigationController?.pushViewController(bookCalanderController!, animated: true)
                }
            }
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
        if isFromProvider == false {
            self.pickLocationFromSelectLocationScreen()
        }
        textView.resignFirstResponder()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        
    }
    @IBAction func timeSlotButtonClick(_ sender: UIButton){
        if let collectionCell = sender.superview?.superview as? BookNowTimeCell{
            if collectionCell.isOutofRange == false{
                if let indexPath = self.collectionTimeRange?.indexPath(for: collectionCell) as IndexPath?{
                    self.updateSelectedIndexPathsRange(indexPath)
                }
            }
        }
    }
    @IBAction func editLocationButtonClick(_ sender: UIButton){
        if isFromProvider == false {
            self.pickLocationFromSelectLocationScreen()
        }
    }
    @IBAction func sendMultipleProvidersButtonClick(_ sender : UIButton){
        btnMultipleProviders?.isSelected  = !(btnMultipleProviders?.isSelected)!
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH"
        let currentDateTimeStr = dateFormatter.string(from: currentDate)
        let currentDateTime = dateFormatter.date(from: currentDateTimeStr)
        if btnMultipleProviders?.isSelected == true {
            btnMultipleProviders?.isSelected = false
            if placeOrder != nil{
                if Validations.isNullString((placeOrder?.startTime)!) == true || (placeOrder?.noOfHoursRequired?.integerValue ?? 0 == 0){
                    if placeOrderAlert != nil{
                        placeOrderAlert?.removeFromSuperview()
                    }
                    placeOrderAlert = CustomAlert.alertInfoPopUpView(self, frame: UIScreen.main.bounds, title: ALERT as NSString, message: Please_Select_No_Of_Hours as NSString, buttonTitle: OK, hideClose: true) as? UIView
                    self.appdelegate?.window?.addSubview(placeOrderAlert!)
                }
                else if placeOrder?.noOfHoursRequired?.integerValue ?? 0 < selectedEquipment?.minimumServiceHours?.integerValue ?? 0 {
                    if placeOrderAlert != nil{
                        placeOrderAlert?.removeFromSuperview()
                    }
                    placeOrderAlert = CustomAlert.alertInfoPopUpView(self, frame: UIScreen.main.bounds, title: ALERT as NSString, message: Minimum_Service_Hours_Required as NSString, buttonTitle: OK, hideClose: true) as? UIView
                    self.appdelegate?.window?.addSubview(placeOrderAlert!)
                }
                else if Validations.isNullString((placeOrder?.startTime)!) == false && Validations.isNullString((placeOrder?.fromDate)!) == false{
                    let fromDateStr = String(format: "%@ %@", placeOrder?.fromDate ?? "",placeOrder?.startTime ?? "")
                    if let fromDateTime = dateFormatter.date(from: fromDateStr) as Date?{
                        if currentDateTime!.compare(fromDateTime) == .orderedAscending {
                            self.multipleProvidersAlert = CustomAlert.sendMultipleProvidersAlertPopUpView(self, title: "Multiple request configuration", frame: UIScreen.main.bounds, okButtonTitle: OK as NSString) as? UIView
                            let txtPricePerHour = multipleProvidersAlert?.viewWithTag(55555) as? UITextField
                            let txtMaxDistance = multipleProvidersAlert?.viewWithTag(66666) as? UITextField
                            if txtPricePerHour != nil && txtMaxDistance != nil{
                                txtPricePerHour?.text = selectedEquipment!.pricePerHour as String?
                                //txtMaxDistance?.text = selectedEquipment!.maxSerAreaDistProvided as String!
                                txtMaxDistance?.text = lblDistance?.text?.replacingOccurrences(of: "kms", with: "")
                                if isFromEdit == true && placeOrder?.multipleProviderCheck == true{
                                    if Validations.isNullString(placeOrder?.multipleProviderPrice ?? "") == false && Validations.isNullString(placeOrder?.multipleProviderDistance ?? "") == false{
                                        txtPricePerHour?.text = placeOrder?.multipleProviderPrice as String?
                                        txtMaxDistance?.text = placeOrder?.multipleProviderDistance as String?
                                    }
                                    else{
                                        txtPricePerHour?.text = placeOrder!.pricePerHour as String?
                                        txtMaxDistance?.text = placeOrder?.multipleProviderDistance as String?
                                    }
                                }

                            }
                            self.appdelegate?.window?.addSubview(multipleProvidersAlert!)
                        }
                        else {
                            if placeOrderAlert != nil{
                                placeOrderAlert?.removeFromSuperview()
                            }
                            placeOrderAlert = CustomAlert.alertInfoPopUpView(self, frame: UIScreen.main.bounds, title: ALERT as NSString, message: Start_Time_Greater_To_Current as NSString, buttonTitle: OK , hideClose: true) as? UIView
                            self.appdelegate?.window?.addSubview(placeOrderAlert!)
                        }
                    }
                }
            }
        }
        else{
            placeOrder?.multipleProviderDistance = ""
            placeOrder?.multipleProviderPrice = ""
            placeOrder?.multipleProviderCheck = false
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
                    self.calculateDistanceBetweenLocations()
                    self.heightConstraint.constant = (self.timeSelectionView?.frame.maxY)! + 20
                    self.layoutIfNeeded()
                    self.updateConstraintsIfNeeded()
                    self.scrollView?.contentSize = CGSize(width: (self.scrollView?.frame.size.width)!, height: (self.timeSelectionView?.frame.maxY)! + 40)
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
    func updateSelectedIndexPathsRange(_ indexPath: IndexPath){
        if fromIndex == nil {
            fromIndex = indexPath.row
        }
        if toIndex == nil {
            toIndex = indexPath.row
        }
        if fromIndex != nil && toIndex != nil {
            if indexPath.row < fromIndex!{
                fromIndex = indexPath.row
            }
            if indexPath.row > toIndex!{
                toIndex = indexPath.row
            }
            if selectedIndexPaths.contains(indexPath.row) == true{
                if let index = selectedIndexPaths.index(of: indexPath.row) as NSInteger?{
                    let range = NSRange(location: index, length: selectedIndexPaths.count - index)
                    if index == 0{
                        selectedIndexPaths.removeObject(at: index)
                    }
                    else{
                        selectedIndexPaths.removeObjects(in: range)
                    }
                }
                if selectedIndexPaths.count > 0{
                    fromIndex = selectedIndexPaths.firstObject as! NSInteger?
                    toIndex = selectedIndexPaths.lastObject as! NSInteger?
                }
                else{
                    fromIndex = nil
                    toIndex = nil
                }
            }
        }
        selectedIndexPaths.removeAllObjects()
        self.createSelectionRangeArrayFromIndexes()
        self.collectionTimeRange?.reloadData()
    }
    func createSelectionRangeArrayFromIndexes(){
        if fromIndex != nil && toIndex != nil {
            for index in fromIndex!...toIndex!{
                if selectedIndexPaths.contains(index){
                    selectedIndexPaths.remove(index)
                }
                selectedIndexPaths.add(index)
            }
            if fromIndex! < arrAraayFormattedTimes.count{
                let fromTime = arrAraayFormattedTimes[fromIndex!]
                placeOrder?.startTime = fromTime as NSString
                self.fromTime = FarmServicesConstants.amAppend(dateStr: fromTime) ?? ""
            }
            if toIndex! < arrAraayFormattedTimes.count{
                if (toIndex! + 1) < arrAraayFormattedTimes.count{
                    let toTime = arrAraayFormattedTimes[toIndex! + 1]////////////
                    placeOrder?.endTime = toTime as NSString?
                    self.toTime = FarmServicesConstants.amAppend(dateStr: toTime) ?? ""
                }
                else if (toIndex! + 1) == arrAraayFormattedTimes.count{
                    let toTime = arrAraayFormattedTimes[0]////////////
                    placeOrder?.endTime = toTime as NSString?
                    self.toTime = FarmServicesConstants.amAppend(dateStr: toTime) ?? ""
                }
            }
            let timeStr = String(format: "%d hour(s)[%@ - %@]",selectedIndexPaths.count,self.fromTime ?? "",self.toTime ?? "")
            lblSelectedHours?.text = timeStr
            placeOrder?.noOfHoursRequired = String(format: "%d", selectedIndexPaths.count) as NSString
        }
        else{
            lblSelectedHours?.text = ""
            placeOrder?.noOfHoursRequired = "0"
            placeOrder?.startTime = ""
            placeOrder?.endTime = ""
        }
    }
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
