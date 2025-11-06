//
//  ProviderFilterViewController.swift
//  FarmerConnect
//
//  Created by Empover on 05/01/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit
import Alamofire

class ProviderFilterViewController: ProviderBaseViewController {

    @IBOutlet weak var txtFldFromDate: UITextField!
    
    @IBOutlet weak var txtFldToDate: UITextField!
    
    @IBOutlet weak var txtFldVehicle: UITextField!
    
    @IBOutlet weak var txtFldDistanceSorting: UITextField!
    
    @IBOutlet weak var txtFldBookingHours: UITextField!
    
    @IBOutlet weak var btnApplyFilter: UIButton!
    
    
    var fromDateView : UIView?
    var toDateView : UIView?
    
    var maximumDate : NSDate?
    
    var toDateStrToSet = ""
    
    var tblViewVehicleDropDown = UITableView()
    var tblViewDistanceSorting = UITableView()
    var tblViewBookingHours = UITableView()
    
    var vehicleMutArray = NSMutableArray()
    var eqipmentId = 0
    var distanceSortingArray = ["Low to High","High to Low"]
    var distanceSortingStr = "Low to High"
    var bookingHoursArray = ["High to Low","Low to High"]
    var bookingHoursStr = "High to Low"
    
    var filterDetailsHandler:((Dictionary<String,Any>,Bool) -> Void)?
    
    var cancelBlock : (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        txtFldFromDate.delegate = self
        txtFldFromDate.tintColor = UIColor.clear
        txtFldFromDate.leftViewMode = .always
        txtFldFromDate.contentVerticalAlignment = .center
        txtFldFromDate.setLeftPaddingPoints(10)
        
        txtFldToDate.delegate = self
        txtFldToDate.tintColor = UIColor.clear
        txtFldToDate.leftViewMode = .always
        txtFldToDate.contentVerticalAlignment = .center
        txtFldToDate.setLeftPaddingPoints(10)
        
        txtFldVehicle.delegate = self
        txtFldVehicle.leftViewMode = .always
        txtFldVehicle.contentVerticalAlignment = .center
        txtFldVehicle.setLeftPaddingPoints(10)
        txtFldVehicle.tintColor = UIColor.clear
        
        txtFldDistanceSorting.delegate = self
        txtFldDistanceSorting.leftViewMode = .always
        txtFldDistanceSorting.contentVerticalAlignment = .center
        txtFldDistanceSorting.setLeftPaddingPoints(10)
        txtFldDistanceSorting.tintColor = UIColor.clear
        
        txtFldBookingHours.delegate = self
        txtFldBookingHours.leftViewMode = .always
        txtFldBookingHours.contentVerticalAlignment = .center
        txtFldBookingHours.setLeftPaddingPoints(10)
        txtFldBookingHours.tintColor = UIColor.clear
        
        btnApplyFilter.isHidden = true
        
        //vehicle dropdown tableView
        self.loadDropDownTableView(tableViewDataSource: self, tableViewDelegate: self, tableview: tblViewVehicleDropDown, textField: txtFldVehicle)
        tblViewVehicleDropDown.dataSource = self
        tblViewVehicleDropDown.delegate = self
        
        //booking hours dropdown tableView
        self.loadDropDownTableView(tableViewDataSource: self, tableViewDelegate: self, tableview: tblViewBookingHours, textField: txtFldBookingHours)
        tblViewBookingHours.dataSource = self
        tblViewBookingHours.delegate = self
        
        //distance sorting dropdown tableView
        self.loadDropDownTableView(tableViewDataSource: self, tableViewDelegate: self, tableview: tblViewDistanceSorting, textField: txtFldDistanceSorting)
        tblViewDistanceSorting.dataSource = self
        tblViewDistanceSorting.delegate = self
        
        txtFldBookingHours.text = bookingHoursStr
        txtFldDistanceSorting.text = distanceSortingStr
        
        let fromDateFormatter: DateFormatter = DateFormatter()
        fromDateFormatter.dateFormat = "dd-MMM-yyyy"
        let currentDateStr = fromDateFormatter.string(from: Date()) as String
        txtFldFromDate.text = currentDateStr
        
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let currentDate: NSDate = NSDate()
        
        let components: NSDateComponents = NSDateComponents()
        components.day = 2
        let toDate: NSDate = gregorian.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        
        let toDateFormatter: DateFormatter = DateFormatter()
        toDateFormatter.dateFormat = "dd-MMM-yyyy"
        let toDateStr = fromDateFormatter.string(from:toDate as Date) as String
        txtFldToDate.text = toDateStr
        
        let maxDateComponents: NSDateComponents = NSDateComponents()
        maxDateComponents.day = 20
        let maxDate: NSDate = gregorian.date(byAdding: maxDateComponents as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        maximumDate = maxDate
        self.recordScreenView("ProviderFilterViewController", FSP_Filter)
        self.registerFirebaseEvents(PV_FSP_Orders_Filter, "", "", "", parameters: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //var touch: UITouch? = touches.first as? UITouch
        //location is relative to the current view
        // do something with the touched point
        // if touch?.view != yourView {
        tblViewVehicleDropDown.isHidden = true
        tblViewBookingHours.isHidden = true
        tblViewDistanceSorting.isHidden = true
        //}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.topView?.isHidden = false
        self.hideFilterButton(true)
        self.hideClearButton(false)
        
        lblTitle?.text = NSLocalizedString("filter", comment: "")
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            let userObj = Constatnts.getUserObject()
            let parameters = ["customerId":userObj.customerId! as String] as NSDictionary
            print(parameters)
            let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
            let params =  ["data" : paramsStr]
            print(params)
            self.requestToGetClassificationData(params: params as [String:String])
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
    }
    
    //MARK: requestToGetClassificationData
    func requestToGetClassificationData(params: [String:String]){
        
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,Provider_Filter_Equipment_Classification])
        
        let userObj = Constatnts.getUserObject()
        
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        print(headers)
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        //print("Response after decrypting data:\(decryptData)")
                       
                        if let tempClassificationArray = decryptData.value(forKey: "equipmentsList") as? NSArray{
                            if tempClassificationArray.count > 0{
                                self.btnApplyFilter.isHidden = false
                                let classificationArray = NSMutableArray()
                                
                                classificationArray.addObjects(from: tempClassificationArray as! [Any])
                                let selectTempDict = NSMutableDictionary()
                                selectTempDict.setValue("Select", forKey: "equipmentName")
                                classificationArray.insert(selectTempDict, at: 0)
                                
                                self.vehicleMutArray.removeAllObjects()
                                for i in 0 ..< classificationArray.count{
                                    let classificationDict = classificationArray.object(at: i) as? NSDictionary
                                    //let classificationData = Classifications(dict: classificationDict!)
                                    self.vehicleMutArray.add(classificationDict!)
                                }
                                
                                //print(self.vehicleMutArray)
                                
                                DispatchQueue.main.async {
                                    if let classificationDic = self.vehicleMutArray.firstObject as? NSDictionary{
                                        self.txtFldVehicle.text = classificationDic.value(forKey: "equipmentName") as? String
                                    }
                                    self.tblViewVehicleDropDown.reloadData()
                                }
                            }
                            else{
                                self.btnApplyFilter.isHidden = true
                            }
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
    
    
    override func backButtonClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func clearButtonClick(_ sender: UIButton) {
        self.registerFirebaseEvents(FSP_Order_Filter_Clear, "", "", "", parameters: nil)
         self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnFromDate_Touch_Up_Inside(_ sender: Any) {
        self.fromDatePickerView()
    }
    
    @IBAction func toDate_Touch_Up_Inside(_ sender: Any) {
       self.toDatePickerView()
    }
    
    
    @IBAction func btnApplyFilter_Touch_Up_Inside(_ sender: Any) {
   
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            var fromDate = txtFldFromDate.text ?? ""
            if let tempFromDate = FarmServicesConstants.getDateFromDateStringWithShortFormat(serverDate: txtFldFromDate.text){
                fromDate = FarmServicesConstants.getDateStringFromDate(serverDate: tempFromDate) as String? ?? txtFldFromDate.text!
            }
            var toDate = txtFldToDate.text ?? ""
            if let tempToDate = FarmServicesConstants.getDateFromDateStringWithShortFormat(serverDate: txtFldToDate.text){
                toDate = FarmServicesConstants.getDateStringFromDate(serverDate: tempToDate) as String? ?? txtFldToDate.text!
            }
            let parameters = ["vehicleId":Int(eqipmentId), "fromDate":fromDate,"toDate":toDate,"distanceSorting":distanceSortingStr,"bookingHoursSorting":bookingHoursStr,"applyFilter":true] as [String : Any]
            //print(parameters)
           // let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
           // let params =  ["data" : paramsStr]
            //print(params)
            let userObj = Constatnts.getUserObject()
            let fireBaseParams = [MOBILE_NUMBER: userObj.mobileNumber!,USER_ID: userObj.customerId ?? "",Distance_Sorting:distanceSortingStr,NoOf_Booking_hrs_Sorting:bookingHoursStr,From_Date:fromDate,To_Date:toDate] as [String : Any]
            self.registerFirebaseEvents(FSP_Order_Filter_ApplyFilter, "", "", "", parameters: fireBaseParams as NSDictionary)
            if filterDetailsHandler != nil{
                filterDetailsHandler!(parameters,true)
            }
            self.navigationController?.popViewController(animated: true)
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
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
        
        components.day = 20
        let maxDate: NSDate = gregorian.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        dobPicker.maximumDate = maxDate as Date
        maximumDate = maxDate
        
        dobPicker.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: .valueChanged)
        fromDateView?.addSubview(dobPicker)
        
        //submit button
        let btnOK : UIButton = UIButton (frame: CGRect(x: 0, y: dobPicker.frame.maxY+5,width: width,height: 40))
        btnOK.backgroundColor = UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 0.8)
        btnOK.layer.cornerRadius = 5.0
        btnOK.setTitle("OK", for: UIControlState())
        btnOK.addTarget(self, action: #selector(ProviderFilterViewController.alertOK), for: UIControlEvents.touchUpInside)
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
        btnOK.setTitle("OK", for: UIControlState())
        btnOK.addTarget(self, action: #selector(ProviderFilterViewController.alertOK), for: UIControlEvents.touchUpInside)
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

extension ProviderFilterViewController : UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == txtFldVehicle {
            
            tblViewVehicleDropDown.isHidden = true
        }
        else if textField == txtFldBookingHours {
            tblViewBookingHours.isHidden = true
        }
        else  {
            tblViewDistanceSorting.isHidden = true
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtFldFromDate{
            tblViewVehicleDropDown.isHidden = true
            tblViewBookingHours.isHidden = true
            tblViewDistanceSorting.isHidden = true
            txtFldFromDate.resignFirstResponder()
            self.fromDatePickerView()
        }
        else if textField == txtFldToDate{
            tblViewVehicleDropDown.isHidden = true
            tblViewBookingHours.isHidden = true
            tblViewDistanceSorting.isHidden = true
            txtFldToDate.resignFirstResponder()
            self.toDatePickerView()
        }
        else if textField == txtFldVehicle{
            txtFldVehicle.resignFirstResponder()
            tblViewVehicleDropDown.isHidden = false
            tblViewVehicleDropDown.reloadData()
            tblViewBookingHours.isHidden = true
            tblViewDistanceSorting.isHidden = true
        }
        else if textField == txtFldDistanceSorting{
            txtFldDistanceSorting.resignFirstResponder()
            tblViewVehicleDropDown.isHidden = true
            tblViewBookingHours.isHidden = true
            tblViewDistanceSorting.isHidden = false
            tblViewDistanceSorting.reloadData()
        }
        else{
            txtFldBookingHours.resignFirstResponder()
            tblViewVehicleDropDown.isHidden = true
            tblViewBookingHours.isHidden = false
            tblViewBookingHours.reloadData()
            tblViewDistanceSorting.isHidden = true
        }
    }
}

extension ProviderFilterViewController :  UITableViewDataSource, UITableViewDelegate{
    //MARK: dropdown tableview datasource & delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblViewVehicleDropDown {
            return vehicleMutArray.count
        }
        else if tableView == tblViewBookingHours {
            return bookingHoursArray.count
        }
        else {
            return distanceSortingArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 14.0)
        
        if tableView == tblViewVehicleDropDown {
            if let vehicleStr = (self.vehicleMutArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "equipmentName") as? String{
                cell.textLabel?.text = vehicleStr
            }
        }
        else if tableView == tblViewBookingHours {
            if Validations.isNullString(self.bookingHoursArray[indexPath.row] as NSString) == false{
                cell.textLabel?.text = self.bookingHoursArray[indexPath.row]
            }
        }
        else {
            if Validations.isNullString(self.distanceSortingArray[indexPath.row] as NSString) == false{
            cell.textLabel?.text = self.distanceSortingArray[indexPath.row]
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblViewVehicleDropDown {
            tblViewVehicleDropDown.isHidden = true
            txtFldVehicle.text = (self.vehicleMutArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "equipmentName") as? String
            if txtFldVehicle.text == "Select"{
                eqipmentId = 0
            }
            else{
                eqipmentId = (self.vehicleMutArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "equipmentId")
                    as! Int
            }
        }
        else if tableView == tblViewBookingHours {
            tblViewBookingHours.isHidden = true
            bookingHoursStr = self.bookingHoursArray[indexPath.row]
            txtFldBookingHours.text = bookingHoursStr
        }
        else  {
            tblViewDistanceSorting.isHidden = true
            distanceSortingStr = self.distanceSortingArray[indexPath.row]
            txtFldDistanceSorting.text = distanceSortingStr
        }
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
}
