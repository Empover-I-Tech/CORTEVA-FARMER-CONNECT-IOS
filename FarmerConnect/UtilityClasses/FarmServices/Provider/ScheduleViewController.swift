//
//  ScheduleViewController.swift
//  FarmerConnect
//
//  Created by Admin on 21/12/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class ScheduleViewController: ProviderBaseViewController,GrowingTextViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate {

    
    @IBOutlet var lblScheduleDates : UILabel?
    @IBOutlet var txtPricePerHour : UITextField?
    @IBOutlet var txtFromTime : UITextField?
    @IBOutlet var txtToTime : UITextField?
    @IBOutlet var txtLocation : GrowingTextView?

    
    var selectedEquipment : Equipment?
    var isFromEdit : Bool = false
    var selectedSchedule : Schedule?
    var arrScheduledDates : NSMutableArray?
    var minimuServiceHours : NSString?
    var selectedLocation : CLLocationCoordinate2D?
    var availbleFromTimePicker = UIDatePicker()
    var availbleToTimePicker = UIDatePicker()
    var fromTimePicker = UIPickerView()
    var toTimePicker = UIPickerView()
    let arrTimeHours  = ["01","02","03","04","05","06","07","08","09","10","11","12"]
    let arrTimeSession  = ["AM","PM"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.updateSelectedScheduleDetailsToUiComponents()
        txtLocation?.contentInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 30)
        availbleFromTimePicker.datePickerMode = .time
        availbleFromTimePicker.minuteInterval = 30
        if Validations.isNullString(self.minimuServiceHours ?? "") == false {
            if self.minimuServiceHours!.integerValue > 0 {
                availbleFromTimePicker.minuteInterval = 30
            }
        }
        availbleToTimePicker.datePickerMode = .time
        availbleToTimePicker.minuteInterval = 30
        if Validations.isNullString(self.minimuServiceHours ?? "") == false {
            if self.minimuServiceHours!.integerValue > 0 {
                availbleToTimePicker.minuteInterval = 30
            }
        }
        //txtToTime?.inputView = availbleToTimePicker
        //txtFromTime?.inputView = availbleFromTimePicker
        availbleFromTimePicker.addTarget(self, action: #selector(ScheduleViewController.fromTimeDiveChanged(sender:)), for: .valueChanged)
        availbleToTimePicker.addTarget(self, action: #selector(ScheduleViewController.toTimeDiveChanged(sender:)), for: .valueChanged)
        
        let priceLeftView = UILabel(frame:CGRect( x: 0, y: 0, width: 25, height: 35))
        priceLeftView.text = Currency
        priceLeftView.textAlignment = .center
        priceLeftView.font = UIFont.systemFont(ofSize: 18.0)
        txtPricePerHour?.leftView = priceLeftView
        txtPricePerHour?.leftViewMode = .always
        
        let fromRightView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 35))
        fromRightView.backgroundColor = UIColor.clear
        let fromTime = UIButton(type: .custom)
        fromTime.frame = CGRect(x: 0, y: 6, width: 20, height: 20)
        fromTime.setImage(UIImage(named: "Clock"), for: .normal)
        fromTime.addTarget(self, action: #selector(ScheduleViewController.fromRightButtonClick(_:)), for: .touchUpInside)
        fromRightView.addSubview(fromTime)
        //fromTime.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        //fromTime.contentMode = .scaleAspectFit
        txtFromTime?.rightView = fromRightView
        txtFromTime?.rightViewMode = .always
        if UIScreen.main.bounds.size.width == 320{
            txtFromTime?.font = UIFont.systemFont(ofSize: 10.0)
            txtToTime?.font = UIFont.systemFont(ofSize: 10.0)
        }
      
        let toRightView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 35))
        toRightView.backgroundColor = UIColor.clear
        let toTime = UIButton(type: .custom)
        toTime.frame = CGRect(x: 0, y: 6, width: 20, height: 20)
        toTime.setImage(UIImage(named: "Clock"), for: .normal)
        toTime.addTarget(self, action: #selector(ScheduleViewController.toRightButtonClick(_:)), for: .touchUpInside)
        toRightView.addSubview(toTime)
        //toTime.contentMode = .scaleAspectFit
        txtToTime?.rightView = toRightView
        txtToTime?.rightViewMode = .always
        
        fromTimePicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 200))
        fromTimePicker.delegate = self;
        fromTimePicker.dataSource = self
        txtFromTime?.inputView = fromTimePicker
        txtFromTime?.setLeftPaddingPoints(5)
        
        toTimePicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 200))
        toTimePicker.delegate = self;
        toTimePicker.dataSource = self
        txtToTime?.inputView = toTimePicker
        txtToTime?.setLeftPaddingPoints(5)
        self.recordScreenView("ScheduleViewController", Schedule_Equipment)
        if isFromEdit == true {
            self.registerFirebaseEvents(PV_FSP_Update_Schedule, "", "", "", parameters: nil)
        }
        else{
            self.registerFirebaseEvents(PV_FSP_Schedule_Equipment, "", "", "", parameters: nil)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showCartButton(false)
        self.topView?.isHidden = false
        if self.isFromEdit == true {
            
            self.lblTitle?.text = NSLocalizedString("update_schedule", comment: "")
        }
        else{
            self.lblTitle?.text = NSLocalizedString("update_schedule", comment: "")
        }
    }
    
    func updateSelectedScheduleDetailsToUiComponents(){
        if isFromEdit == true && selectedSchedule != nil{
            if Validations.isNullString(selectedSchedule!.latitude ?? "") == false && Validations.isNullString(selectedSchedule!.longitude ?? "") == false{
                selectedLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(selectedSchedule!.latitude!.floatValue), longitude: CLLocationDegrees(selectedSchedule!.longitude!.floatValue))
            }
            txtPricePerHour?.text = selectedSchedule?.pricePerHour as String?
            txtLocation?.text = selectedSchedule?.locationName as String?
            txtLocation?.sizeToFit()
            txtFromTime?.text = FarmServicesConstants.amAppend(dateStr:selectedSchedule?.fromTime as String? ?? "") as String?
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            let fromTime = formatter.date(from: (txtFromTime?.text)!)
            let calendar = NSCalendar.current
            var components = calendar.dateComponents([.hour,.minute], from: fromTime!)
            var hours = components.hour
            fromTimePicker.selectRow( 0, inComponent: 1, animated: true)
            if hours! > 12{
                hours! = hours! - 12
                if hours! > 0{
                    toTimePicker.selectRow(1 , inComponent: 1, animated: true)
                }
            }
            if hours! < arrTimeHours.count {
                fromTimePicker.selectRow(hours!, inComponent: 0, animated: true)
            }
            txtToTime?.text = FarmServicesConstants.amAppend(dateStr:selectedSchedule?.toTime as String? ?? "") as String?
            let toTime = formatter.date(from: (txtToTime?.text)!)
            components = calendar.dateComponents([.hour,.minute], from: toTime!)
            hours = components.hour
            toTimePicker.selectRow(0 , inComponent: 1, animated: true)
            if hours! > 12{
                hours! = hours! - 12
                if hours! > 0{
                    toTimePicker.selectRow(1 , inComponent: 1, animated: true)
                }
            }
            if hours! < arrTimeHours.count {
                toTimePicker.selectRow(hours!, inComponent: 0, animated: true)
            }
            lblScheduleDates?.text = selectedSchedule?.date as String?
            lblScheduleDates?.sizeToFit()
        }
        else{
            if arrScheduledDates != nil{
                var scheduledDates = ""
                for index in 0..<arrScheduledDates!.count{
                    if let dateStr = arrScheduledDates?.object(at: index) as? String{
                        if let formattedDate = FarmServicesConstants.getDateStringFromDateStringWithShortFormat(serverDate: dateStr) as NSString?{
                            if index == 0{
                                scheduledDates = formattedDate as String? ?? ""
                            }
                            else{
                                scheduledDates = scheduledDates.appendingFormat(", %@", formattedDate as String? ?? "")
                            }
                        }
                    }
                }
                lblScheduleDates?.text = scheduledDates
                lblScheduleDates?.sizeToFit()
            }
        }
    }
    
    func updateScheduleDetails(schedule: Schedule){
        if self.selectedEquipment != nil {
            let userObj = Constatnts.getUserObject()
            let headers : HTTPHeaders = self.getProviderHeaders()
            //print(headers)
            SwiftLoader.show(animated: true)
            let urlString = String(format: "%@%@", arguments: [BASE_URL,Update_Equipment_Availability])
            let scheduleDic = ["equipmentAvailabilityId":schedule.equipmentAvailabilityId!,"locationName": schedule.locationName!,"latitude":schedule.latitude!.doubleValue,"longitude":schedule.longitude!.doubleValue,"fromTime":schedule.fromTime!,"toTime":schedule.toTime!,"pricePerHour":schedule.pricePerHour!,"date":schedule.date!,"isBooked":schedule.isBooked!] as [String : Any]
            let scheduleArray = NSArray(object: scheduleDic)
            let parameters = ["customerId": userObj.customerId!,"equipmentId":self.selectedEquipment!.equipmentId!,"schedule":scheduleArray] as [String : Any]
            print(parameters)
            let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
            let params =  ["data" : paramsStr]
            Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                SwiftLoader.hide()
                if response.result.error == nil {
                    if let json = response.result.value {
                       // print("Response :\(json)")
                        let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                        if responseStatusCode == STATUS_CODE_200{
                            let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                            let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                            //print("Response after decrypting data:\(decryptData)")
                            let appDelegate = UIApplication.shared.delegate as? AppDelegate
                            appDelegate?.window?.makeToast(Updated_Equipment_Successfully)
                            self.navigationController?.popViewController(animated: true)
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
    }
    
    func addScheduleDetails(arrSchedules: NSMutableArray){
        let userObj = Constatnts.getUserObject()
        if arrSchedules.count > 0 {
            let schedulesArray = NSMutableArray()
            for index in 0..<arrSchedules.count{
                if let schedule = arrSchedules.object(at: index) as? Schedule{
                    let scheduleDic = ["locationName": schedule.locationName!,"latitude":schedule.latitude!.doubleValue,"longitude":schedule.longitude!.doubleValue,"fromTime":schedule.fromTime!,"toTime":schedule.toTime!,"pricePerHour":schedule.pricePerHour!,"date":schedule.date!,"isBooked":false] as [String : Any]
                    schedulesArray.add(scheduleDic)
                }
            }
            if schedulesArray.count > 0{
                let headers : HTTPHeaders = self.getProviderHeaders()
                //print(headers)
                SwiftLoader.show(animated: true)
                let urlString = String(format: "%@%@", arguments: [BASE_URL,Add_Equipment_Availability])
                //let scheduleDic = ["locationName": schedule.locationName!,"latitude":schedule.latitude!.doubleValue,"longitude":schedule.longitude!.doubleValue,"fromTime":schedule.fromTime!,"toTime":schedule.toTime!,"pricePerHour":schedule.pricePerHour!,"date":schedule.date!,"isBooked":false] as [String : Any]
                //let scheduleArray = NSArray(object: scheduleDic)
                let parameters = ["customerId": userObj.customerId!,"equipmentId":self.selectedEquipment!.equipmentId!,"schedule":schedulesArray] as [String : Any]
                print(parameters)
                let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
                let params =  ["data" : paramsStr]
                Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                    //SwiftLoader.hide()
                    if response.result.error == nil {
                        if let json = response.result.value {
                            //print("Response :\(json)")
                            let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                            if responseStatusCode == STATUS_CODE_200{
                                let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                                let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                               // print("Response after decrypting data:\(decryptData)")
                                SwiftLoader.hide()
                                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                                appDelegate?.window?.makeToast(Scheduled_Equipment_Successfully)
                                self.navigationController?.popViewController(animated: true)
                                /*arrSchedules.remove(schedule)
                                DispatchQueue.main.async {
                                    if arrSchedules.count > 0{
                                        self.addScheduleDetails(arrSchedules: arrSchedules)
                                    }
                                    else{
                                        SwiftLoader.hide()
                                        let appDelegate = UIApplication.shared.delegate as? AppDelegate
                                        appDelegate?.window?.makeToast("Equipment scheduled successfully.")
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                }*/
                            }
                            else{
                                if let message = (json as! NSDictionary).value(forKey: "message") as? String {
                                    self.view.makeToast(message)
                                    SwiftLoader.hide()
                                }
                            }
                        }
                    }
                    else{
                        self.view.makeToast((response.error?.localizedDescription)!)
                    }
                }
            }
        }

    }
    //MARK: Button Click Methods
    
    @objc func fromTimeDiveChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.timeStyle = .short
        txtFromTime?.text = formatter.string(from: sender.date)
    }
    @objc func toTimeDiveChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.timeStyle = .short
        txtToTime?.text = formatter.string(from: sender.date)
        self.checkFromAndToDateOrdering()
    }
    @IBAction func fromRightButtonClick(_ sender: UIButton){
        self.view.endEditing(true)
        txtFromTime?.becomeFirstResponder()
    }
    
    @IBAction func toRightButtonClick(_ sender: UIButton){
        self.view.endEditing(true)
        txtToTime?.becomeFirstResponder()
    }
    @IBAction func saveButtonClick(_ snder: UIButton){
        self.view.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        if Validations.isNullString(txtPricePerHour?.text! as NSString? ?? "" as NSString){
            self.view.makeToast(Please_Enter_Price)
        }
        else if Validations.isNullString(txtFromTime?.text! as NSString? ?? "" as NSString){
            self.view.makeToast(Please_Enter_Schedule_From_Time)
        }
        else if Validations.isNullString(txtToTime?.text! as NSString? ?? "" as NSString){
            self.view.makeToast(Please_Enter_Schedule_To_Time)
        }
        else if Validations.isNullString(txtLocation?.text! as NSString? ?? "" as NSString) || selectedLocation == nil{
            self.view.makeToast(Please_Select_Equip_Location)
        }
        else{
            let fromTimeDate = formatter.date(from: (txtFromTime?.text)!)
            let toTimeDate = formatter.date(from: (txtToTime?.text)!)
            if fromTimeDate?.compare(toTimeDate!) == .orderedDescending || fromTimeDate?.compare(toTimeDate!) == .orderedSame{
                self.view.makeToast(From_To_Time_Alert)
            }
            else{
                if isFromEdit && selectedSchedule != nil {
                    formatter.dateFormat = "HH:mm:ss"
                    let fromTime = formatter.string(from: fromTimeDate!)
                    let toTime = formatter.string(from: toTimeDate!)
                    selectedSchedule?.fromTime = fromTime as NSString
                    selectedSchedule?.toTime = toTime as NSString
                    selectedSchedule?.pricePerHour = txtPricePerHour?.text as NSString?
                    selectedSchedule?.locationName = txtLocation?.text as String? as NSString?
                    selectedSchedule?.latitude = String(format: "%f", (selectedLocation?.latitude)!) as NSString
                    selectedSchedule?.longitude = String(format: "%f", (selectedLocation?.longitude)!) as NSString
                    let userObj = Constatnts.getUserObject()
                    let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,EQUIPMENT_ID:selectedEquipment!.equipmentId!,From_Time:fromTime,To_Time:toTime,PricePerHour:txtPricePerHour!.text!,DATE:selectedSchedule!.date!,EQUIPMENT_CLASSIFICATION:selectedEquipment?.equipmentClassification ?? ""] as [String : Any]
                    self.registerFirebaseEvents(FSP_Update_Schedule, "", "", "", parameters: fireBaseParams as NSDictionary)
                    self.updateScheduleDetails(schedule: selectedSchedule!)
                }
                else{
                    formatter.dateFormat = "HH:mm:ss"
                    let fromTime = formatter.string(from: fromTimeDate!)
                    let toTime = formatter.string(from: toTimeDate!)
                    self.createScheduleModelesForSelectedDates(fromTime: fromTime, toTime: toTime)
                }
            }
        }

    }
    
    func createScheduleModelesForSelectedDates(fromTime:String,toTime:String){
        if arrScheduledDates != nil {
            let arrSchedules = NSMutableArray()
            for index in 0..<arrScheduledDates!.count{
                if let date = arrScheduledDates?.object(at: index) as? NSString{
                    let schedule = Schedule(dict: NSDictionary())
                    schedule.date = date
                    schedule.pricePerHour = txtPricePerHour?.text as NSString?
                    schedule.fromTime = fromTime as NSString?
                    schedule.toTime = toTime as NSString?
                    schedule.latitude = String(format: "%f", (selectedLocation?.latitude)!) as NSString
                    schedule.longitude = String(format: "%f", (selectedLocation?.longitude)!) as NSString
                    schedule.locationName = self.txtLocation?.text as NSString?
                    schedule.isBooked = false
                    schedule.minimumServiceHours = self.minimuServiceHours
                    arrSchedules.add(schedule)
                    let userObj = Constatnts.getUserObject()
                    let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,EQUIPMENT_ID:selectedEquipment!.equipmentId!,From_Time:fromTime,To_Time:toTime,PricePerHour:txtPricePerHour!.text!,DATE:schedule.date!,EQUIPMENT_CLASSIFICATION:selectedEquipment?.equipmentClassification ?? ""] as [String : Any]
                    self.registerFirebaseEvents(FSP_Save_Schedule, "", "", "", parameters: fireBaseParams as NSDictionary)
                }
            }
            self.addScheduleDetails(arrSchedules: arrSchedules)
        }
    }
    @IBAction func pickupLocationButtonClick( _ sender: UIButton){
        let selectLocationController = self.storyboard?.instantiateViewController(withIdentifier: "SelectLocationViewController") as? SelectLocationViewController
        if isFromEdit == true && selectedLocation != nil{
            selectLocationController?.selectLocation = selectedLocation
        }
        selectLocationController?.addressCompletionBlock = {(selectedlocation ,address,postalCode,isFromAddress,fromHomeNav) in
            if Validations.isNullString(address as NSString) == false{
                self.txtLocation?.text = address
                self.txtLocation?.resignFirstResponder()
                self.selectedLocation = selectedlocation
                selectLocationController?.navigationController?.popViewController(animated: true)
                UIView.animate(withDuration: 0.1) {
                    self.view.endEditing(true)
                }
                self.view.endEditing(true)
            }
        }
        self.navigationController?.pushViewController(selectLocationController!, animated: true)
    }
    // DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return arrTimeHours.count
        case 1:
            return arrTimeSession.count
        default:
            return 0
        }
    }
    
    // Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return arrTimeHours[row]
        case 1:
            return arrTimeSession[row]
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    //MARK: UITextField Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtFromTime{
            if Validations.isNullString(txtFromTime?.text as NSString? ?? "" as NSString) == false{
                let formatter = DateFormatter()
                formatter.dateFormat = "h:mm a"
                //let fromTime = formatter.date(from: (txtFromTime?.text)!)
                //availbleFromTimePicker.setDate(fromTime!, animated: true)
                txtToTime?.text = ""
            }
        }
        else if textField == txtToTime{
            if Validations.isNullString(txtToTime?.text as NSString? ?? "" as NSString) == false{
                //let formatter = DateFormatter()
                //formatter.dateFormat = "h:mm a"
                //let toTime = formatter.date(from: (self.txtToTime?.text)!)
                //self.availbleToTimePicker.setDate(toTime!, animated: true)
            }

        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtFromTime{
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            let timeIndex = fromTimePicker.selectedRow(inComponent: 0)
            let sessionIndex = fromTimePicker.selectedRow(inComponent: 1)
            txtFromTime?.text = String(format:"%@:00 %@",arrTimeHours[timeIndex],arrTimeSession[sessionIndex])//formatter.string(from: availbleFromTimePicker.date)
            let fromTime = formatter.date(from: (txtFromTime?.text)!)
            if fromTime != nil{
                availbleFromTimePicker.setDate(fromTime!, animated: true)
                txtToTime?.text = ""
                toTimePicker.selectRow(timeIndex, inComponent: 0, animated: true)
                toTimePicker.selectRow(sessionIndex, inComponent: 1, animated: true)
            }
        }
        else if textField == txtToTime{
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            //txtToTime?.text = formatter.string(from: availbleToTimePicker.date)
            let timeIndex = toTimePicker.selectedRow(inComponent: 0)
            let sessionIndex = toTimePicker.selectedRow(inComponent: 1)
            txtToTime?.text = String(format:"%@:00 %@",arrTimeHours[timeIndex],arrTimeSession[sessionIndex])
            self.checkFromAndToDateOrdering()
        }
    }
    
    func checkFromAndToDateOrdering(){
        if Validations.isNullString(txtToTime?.text as NSString? ?? "" as NSString) == false && Validations.isNullString(txtFromTime?.text as NSString? ?? "" as NSString) == false{
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            let fromTimeDate = formatter.date(from: (txtFromTime?.text)!)
            let toTimeDate = formatter.date(from: (txtToTime?.text)!)
            if fromTimeDate?.compare(toTimeDate!) == .orderedDescending || fromTimeDate?.compare(toTimeDate!) == .orderedSame{
                txtToTime?.text = ""
                self.view.makeToast(From_To_Time_Alert, duration: 2.0, position: self.view.center)
            }
            else{
                let timeIndex = toTimePicker.selectedRow(inComponent: 0)
                let sessionIndex = toTimePicker.selectedRow(inComponent: 1)
                txtToTime?.text = String(format:"%@:00 %@",arrTimeHours[timeIndex],arrTimeSession[sessionIndex])
            }
        }
    }
    //MARK: GrowingTextView Delagate Methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
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
