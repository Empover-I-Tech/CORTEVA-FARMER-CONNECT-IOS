//
//  ScheduleCalanderViewController.swift
//  FarmerConnect
//
//  Created by Admin on 22/12/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit
import Alamofire

class ScheduleCalanderViewController: ProviderBaseViewController,CalendarViewDelegate,CalendarViewDataSource,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var calendarView : CalendarView?
    @IBOutlet var scrollView : UIScrollView?
    @IBOutlet var scrollContent : UIView?
    @IBOutlet var scheduleDetailView : UIView?
    @IBOutlet var tblSchedule : UITableView?
    @IBOutlet var btnProceed : UIButton?
    @IBOutlet var scheduleViewHeightContraint : NSLayoutConstraint?
    @IBOutlet var contentViewHeightContraint : NSLayoutConstraint?

    var selectedSchedule : Schedule?
    var selectedEquipment : Equipment?
    var minimumServiceHours : NSString?
    var arrScheduledAvailability = NSMutableArray()
    var arrAvailability = NSMutableArray()
    var btnDone : UIButton?
    var scheduleDeleteAlert = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        CalendarView.Style.CellShape = .Round
        CalendarView.Style.CellColorDefault = UIColor.clear
        //CalendarView.Style.CellColorToday = UIColor(red:1.00, green:0.84, blue:0.64, alpha:1.00)
        CalendarView.Style.CellBorderColor = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        CalendarView.Style.CellEventColor = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        CalendarView.Style.HeaderTextColor = UIColor.gray
        CalendarView.Style.CellTextColorDefault = UIColor.black
        //CalendarView.Style.CellTextColorToday = UIColor(red:0.31, green:0.44, blue:0.47, alpha:1.00)
        
        calendarView?.dataSource = self
        calendarView?.delegate = self
        calendarView?.direction = .horizontal
        
        //calendarView.backgroundColor = UIColor(red:0.31, green:0.44, blue:0.47, alpha:1.00)
        calendarView?.isRanged = true
        calendarView?.fromDate = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 20, to: Date())
        calendarView?.toDate = tomorrow!
        //calendarView.endDateCache = tomorrow!
        calendarView?.reloadData()
        scheduleDetailView?.isHidden = true
        self.btnProceed?.isHidden = false
        btnDone = UIButton(type: .custom)
        btnDone?.frame = CGRect(x: (self.topView?.frame.size.width)! - 55, y: 5, width: 50, height: 45)
        btnDone?.setTitle(NSLocalizedString("done", comment: ""), for: .normal)
        btnDone?.titleLabel?.textColor = UIColor.white
        btnDone?.addTarget(self, action: #selector(ScheduleCalanderViewController.doneButtonClick(_:)), for: .touchUpInside)
        self.topView?.addSubview(btnDone!)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showCartButton(false)
        self.topView?.isHidden = false
        self.lblTitle?.text = NSLocalizedString("schedule_equipment", comment: "")
        self.scheduleDetailView?.isHidden = true
        self.btnProceed?.isHidden = false
        self.arrAvailability.removeAllObjects()
        self.calendarView?.reloadData()
        self.calendarView?.selectedIndexPaths.removeAll()
        self.calendarView?.selectedDates.removeAll()
        scrollView?.contentSize = CGSize(width: self.view.frame.size.width, height: UIScreen.main.bounds.size.height - 70)
        if self.selectedEquipment != nil {
            self.getEquipmentScheduleDetailsWithEquipmentId(equipment: self.selectedEquipment!)
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.scheduleDetailView?.isHidden == true {
            scrollView?.contentSize = CGSize(width: self.view.frame.size.width, height: UIScreen.main.bounds.size.height - 70)
        }
        else{
            scrollView?.contentSize = CGSize(width: self.view.frame.size.width, height: 780)
        }
    }
    func getEquipmentScheduleDetailsWithEquipmentId(equipment:Equipment){
        let headers : HTTPHeaders = self.getProviderHeaders()
        print(headers)
        SwiftLoader.show(animated: true)
        let urlString = String(format: "%@%@", arguments: [BASE_URL,View_Equipment_Availability])
        let parameters = ["equipmentId":equipment.equipmentId!] as [String : Any]
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
                        let availabilityArray = Validations.checkKeyNotAvailForArray(decryptData, key: "equipmentAvailabiltyDetails")
                        if availabilityArray.count > 0{
                            self.arrScheduledAvailability.removeAllObjects()
//                            for index in 0..<availabilityArray.count{
//                                if let availDic = availabilityArray.object(at: index) as? NSDictionary{
//                                    let availability = Schedule(dict: availDic)
//                                    if let minServiceHours = Validations.checkKeyNotAvail(decryptData, key: "minimumServiceHours") as? Int64 {
//                                        availability.minimumServiceHours = String(format:"%d",minServiceHours) as NSString
//                                        self.minimumServiceHours = String(format:"%d",minServiceHours) as NSString
//                                    }
//                                    self.arrScheduledAvailability.add(availability)
//                                }
//                            }
                            self.scheduleDetailView?.isHidden = true
                            self.btnProceed?.isHidden = false
                            self.scrollView?.contentSize = CGSize(width: self.view.frame.size.width, height: UIScreen.main.bounds.size.height - 70)
                            if self.arrScheduledAvailability.count > 0{
                                self.calendarView?.scheduledDates = self.arrScheduledAvailability
                                self.calendarView?.reloadData()
                            }
                        }
                        else{
                            if let minServiceHours = Validations.checkKeyNotAvail(decryptData, key: "minimumServiceHours") as? Int64 {
                                self.minimumServiceHours = String(format:"%d",minServiceHours) as NSString
                            }
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
    
    func deleteAvailabilitySchedule(){
        if self.selectedSchedule != nil && self.selectedEquipment != nil{
            let headers : HTTPHeaders = self.getProviderHeaders()
            print(headers)
            SwiftLoader.show(animated: true)
            let urlString = String(format: "%@%@", arguments: [BASE_URL,Delete_Equipment_Availability])
            let parameters = ["equipmentAvailabilityId":self.selectedSchedule!.equipmentAvailabilityId!,"equipmentId":self.selectedEquipment!.equipmentId!,"delete": true] as [String : Any]
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
                           // print("Response after decrypting data:\(decryptData)")
                            self.scheduleDetailView?.isHidden = true
                            self.btnProceed?.isHidden = false
                            self.scrollView?.contentSize = CGSize(width: self.view.frame.size.width, height: UIScreen.main.bounds.size.height - 70)
                            self.getEquipmentScheduleDetailsWithEquipmentId(equipment: self.selectedEquipment!)
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
    // MARK : KDCalendarDataSource
    
    func startDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = 0
        let today = Date()
        let threeMonthsAgo = self.calendarView?.calendar.date(byAdding: dateComponents, to: today)!
        return threeMonthsAgo!
    }
    
    func endDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = 20;
        let tomorrow = Calendar.current.date(byAdding: .day, value: 20, to: Date())
        let twoYearsFromNow = self.calendarView?.calendar.date(byAdding: dateComponents, to: tomorrow!)!
        return twoYearsFromNow!
        
    }
    
    // MARK : KDCalendarDelegate
    
    func calendar(_ calendar: CalendarView, didSelectDate date : Date, withEvents events: [CalendarEvent]) {
        let compareDateStr = FarmServicesConstants.getDateStringFromDate(serverDate: date)
        if compareDateStr != nil{
            if self.arrScheduledAvailability.count > 0{
                if Validations.isNullString(compareDateStr!) == false {
                    let comparePredicate = NSPredicate(format: "date == %@", compareDateStr!)
                    let compareArray = arrScheduledAvailability.filtered(using: comparePredicate) as NSArray
                    if compareArray.count > 0{
                        if let schedule = compareArray.object(at: 0) as? Schedule{
                            self.selectedSchedule = schedule
                            self.scheduleDetailView?.isHidden = false
                            self.btnProceed?.isHidden = true
                            self.tblSchedule?.reloadData()
                            scrollView?.contentSize = CGSize(width: self.view.frame.size.width, height: 725)
                            self.view.layoutIfNeeded()
                            self.view.updateConstraintsIfNeeded()
                            // Get visible cells and sum up their heights
                        }
                    }
                    else{
                        if arrAvailability.contains(compareDateStr!){
                            arrAvailability.remove(compareDateStr!)
                        }
                        else{
                            arrAvailability.add(compareDateStr!)
                        }
                    }
                }
            }
            else{
                if Validations.isNullString(compareDateStr!) == false {
                    if arrAvailability.contains(compareDateStr!){
                        arrAvailability.remove(compareDateStr!)
                    }
                    else{
                        arrAvailability.add(compareDateStr!)
                    }
                }
            }
        }
        /*print("Did Select: \(date) with \(events.count) events")
        for event in events {
            print("\t\"\(event.title)\" - Starting at:\(event.startDate)")
        }*/
    }
    
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
        let compareDateStr = FarmServicesConstants.getDateStringFromDate(serverDate: date)
        if compareDateStr != nil{
            if Validations.isNullString(compareDateStr!) == false {
                if arrAvailability.contains(compareDateStr!){
                    arrAvailability.remove(compareDateStr!)
                }
            }
        }
        
    }
    func calendar(_ calendar: CalendarView, didScrollToMonth date : Date) {
        
        //self.datePicker.setDate(date, animated: true)
    }
    
    
    //MARK: UITableview delegate and datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedSchedule != nil {
            return 5
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
        let cellIdentifier =  "ScheduleCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let lblTitle = cell.viewWithTag(101) as? UILabel
        let lblValue = cell.viewWithTag(102) as? UILabel
        cell.textLabel?.font = lblValue?.font
        cell.textLabel?.textColor = lblValue?.textColor
        cell.textLabel?.numberOfLines = 6
        switch indexPath.row {
        case 0:
            lblTitle?.text = "Price per hour"
            lblValue?.text = selectedSchedule?.pricePerHour as String!
            break
        case 1:
            lblTitle?.text = "Date"
            lblValue?.text = selectedSchedule?.date as String!
            if let formattedDate = FarmServicesConstants.getDateStringFromDateStringWithNormalFormat(serverDate: selectedSchedule?.date as String!) as NSString?{
                lblValue?.text = formattedDate as String
            }
            break
        case 2:
            lblTitle?.text = "From time"
            lblValue?.text = FarmServicesConstants.amAppend(dateStr: selectedSchedule?.fromTime as String!)
            break
        case 3:
            lblTitle?.text = "To time"
            lblValue?.text = FarmServicesConstants.amAppend(dateStr: selectedSchedule?.toTime as String!)
            break
        case 4:
            lblTitle?.text = "Location"
            lblValue?.text = selectedSchedule?.locationName as String!
            break
        default:
            break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func setupActiveLabelClick(cancelationLabel: ActiveLabel){
        let customType = ActiveType.custom(pattern: "Cancellation policy")
        
        cancelationLabel.enabledTypes.append(customType)
        
        cancelationLabel.customize({(label) in
            label.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                switch type {
                case customType:
                    atts[NSAttributedStringKey.underlineStyle] = isSelected ? NSUnderlineStyle.styleSingle.rawValue : NSUnderlineStyle.styleSingle.rawValue
                    atts[NSAttributedStringKey.foregroundColor] = isSelected ? UIColor(red: 255.0/255.0, green: 153.0/255.0, blue: 0.0/255.0, alpha: 1.0) : UIColor(red: 255.0/255.0, green: 153.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                default: ()
                }
                return atts
            }
            label.handleCustomTap(for: customType, handler: { (message) in
                let net = NetworkReachabilityManager(host: "www.google.com")
                if net?.isReachable == true{
                    
                }
                else{
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                    return
                }
            })
            label.customColor[customType] = UIColor.white
        })
    }
    // MARK : Events
    
    @IBAction func closeScheduleDetailButtonClick(_ sender: UIButton){
        self.scheduleDetailView?.isHidden = true
        self.scrollView?.contentSize = CGSize(width: self.view.frame.size.width, height: UIScreen.main.bounds.size.height - 70)
        self.btnProceed?.isHidden = false
        self.view.layoutIfNeeded()
        self.view.updateConstraintsIfNeeded()
    }
    @IBAction func deleteScheduleButtonClick(_ sender: UIButton){
        if self.selectedSchedule != nil {
            self.scheduleDeleteAlert = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: "Alert" as NSString, message: String(format: Schedule_Delete_Message,self.selectedSchedule!.date!) as NSString, okButtonTitle: "DELETE", cancelButtonTitle: "CANCEL") as! UIView
            self.view.addSubview(self.scheduleDeleteAlert)
        }
    }
    @IBAction func editScheduleButtonClick(_ sender: UIButton){
        if selectedEquipment != nil {
            let userObj = Constatnts.getUserObject()
            let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,EQUIPMENT_ID:selectedEquipment!.equipmentId!] as [String : Any]
            self.registerFirebaseEvents(FSP_Edit_Schedule, "", "", "", parameters: fireBaseParams as NSDictionary)
            let scheduleController = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleViewController") as? ScheduleViewController
            //scheduleController?.arrScheduledDates = arrAvailability
            scheduleController?.isFromEdit = true
            scheduleController?.selectedSchedule = selectedSchedule
            scheduleController?.selectedEquipment = self.selectedEquipment
            scheduleController?.minimuServiceHours = self.selectedSchedule?.minimumServiceHours
            self.navigationController?.pushViewController(scheduleController!, animated: true)
        }
    }
    @IBAction func doneButtonClick(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
        let userObj = Constatnts.getUserObject()
        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,EQUIPMENT_ID:selectedEquipment!.equipmentId!] as [String : Any]
        self.registerFirebaseEvents(FSP_Schedule_Equip_Done, "", "", "", parameters: fireBaseParams as NSDictionary)
        self.deleteAvailabilitySchedule()
        
    }
    @IBAction func proceedButtonClick(_ sender: UIButton){
        if self.arrAvailability.count > 0 {
            let scheduleController = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleViewController") as? ScheduleViewController
            scheduleController?.isFromEdit = false
            scheduleController?.arrScheduledDates = arrAvailability
            scheduleController?.selectedEquipment = self.selectedEquipment
            scheduleController?.minimuServiceHours = self.minimumServiceHours
            let userObj = Constatnts.getUserObject()
            let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,EQUIPMENT_ID:selectedEquipment!.equipmentId!] as [String : Any]
            self.registerFirebaseEvents(FSP_Schedule_Equip_Proceed, "", "", "", parameters: fireBaseParams as NSDictionary)
            self.navigationController?.pushViewController(scheduleController!, animated: true)
            //selectedEquipment.
        }
        else{
            self.view.makeToast(Select_Date)
        }
    }
    @IBAction func goToPreviousMonth(_ sender: Any) {
        self.calendarView!.goToPreviousMonth()
    }
    @IBAction func goToNextMonth(_ sender: Any) {
        self.calendarView!.goToNextMonth()
        
    }
    
    //MARK: alertYesBtnAction
    /**
     YES button action of the alertView which is displayed to the user
     when already logged in other device
     */
    @objc func alertYesBtnAction(){
        scheduleDeleteAlert.removeFromSuperview()
        let userObj = Constatnts.getUserObject()
        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,EQUIPMENT_ID:selectedEquipment!.equipmentId!] as [String : Any]
        self.registerFirebaseEvents(FSP_Delete_Schedule, "", "", "", parameters: fireBaseParams as NSDictionary)
        self.deleteAvailabilitySchedule()
    }
    
    //MARK: alertNoBtnAction
    /**
     NO button action of the alertView which is displayed to the user
     when already logged in other device
     */
    @objc func alertNoBtnAction(){
        scheduleDeleteAlert.removeFromSuperview()
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
