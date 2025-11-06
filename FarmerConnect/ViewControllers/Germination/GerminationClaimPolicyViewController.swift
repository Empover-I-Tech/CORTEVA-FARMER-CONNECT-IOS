//
//  GerminationClaimPolicyViewController.swift
//  PioneerEmployee
//
//  Created by Empover on 09/08/18.
//  Copyright © 2018 Empover. All rights reserved.
//

import UIKit

class GerminationClaimPolicyViewController: BaseViewController,LocationServiceDelegate {

    @IBOutlet var txtFldYear: UITextField?
    @IBOutlet var txtFldSeason: UITextField?
    @IBOutlet var txtFldCrop: UITextField?
    @IBOutlet var txtFldTotalSowedAcres: UITextField?
    @IBOutlet var txtFldGerminationFailedAcres: UITextField?
    @IBOutlet var txtFldDateOfSowing: UITextField?
    @IBOutlet var txtViewRemarks: UITextView?
    
    var datePickerStartDate: String?
    var startDate: String?
    var sowDateStrToSet = ""
    var germinationModelObj: GerminationPolicySubscribed?
    var dateView : UIView?
    
    let locationService : LocationService = LocationService()
    var coordinatePoints = ""
    var claimSuccessAlert: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        txtFldYear?.delegate = self
        txtFldYear?.setLeftPaddingPoints(5.0)
        txtFldSeason?.delegate = self
        txtFldSeason?.setLeftPaddingPoints(5.0)
        txtFldCrop?.delegate = self
        txtFldCrop?.setLeftPaddingPoints(5.0)
        txtFldTotalSowedAcres?.delegate = self
        txtFldTotalSowedAcres?.setLeftPaddingPoints(5.0)
        txtFldGerminationFailedAcres?.delegate = self
        txtFldGerminationFailedAcres?.setLeftPaddingPoints(5.0)
        txtFldDateOfSowing?.delegate = self
        txtFldDateOfSowing?.setLeftPaddingPoints(5.0)
        txtFldDateOfSowing?.tintColor = UIColor.clear
        txtViewRemarks?.delegate = self
        
        self.txtFldYear?.isUserInteractionEnabled = false
        self.txtFldYear?.textColor = UIColor.lightGray
        self.txtFldSeason?.isUserInteractionEnabled = false
        self.txtFldSeason?.textColor = UIColor.lightGray
        self.txtFldCrop?.isUserInteractionEnabled = false
        self.txtFldCrop?.textColor = UIColor.lightGray
        
        if (!CLLocationManager.locationServicesEnabled() || CLLocationManager.authorizationStatus() == .denied)//location details are optional
        {
            //print("location not enabled")
            coordinatePoints = ""
        }
        else{
            locationService.delegate = self
            locationService.locationManager?.requestLocation()
            guard let currentLocation = LocationService.sharedInstance.currentLocation?.coordinate else {
                return
            }
            //print(currentLocation)
            //print(String(format : "%f",currentLocation.latitude), String(format : "%f",currentLocation.longitude))
            //let latitude = String(format : "%f",currentLocation.latitude)
            //let longitude = String(format : "%f",currentLocation.longitude)
            coordinatePoints = String(format : "%@,%@", String(format : "%f",currentLocation.latitude), String(format : "%f",currentLocation.longitude))
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.topView?.isHidden = false
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        lblTitle?.text = "Claim Policy"
        
        if germinationModelObj != nil{
            self.txtFldYear?.text = germinationModelObj?.year ?? ""
            self.txtFldSeason?.text = germinationModelObj?.seasonName ?? ""
            self.txtFldCrop?.text = germinationModelObj?.cropName ?? ""
            self.txtFldTotalSowedAcres?.text = germinationModelObj?.totalAcres ?? ""
            self.startDate = germinationModelObj?.startDate ?? ""
            
            let currentDateFormatter: DateFormatter = DateFormatter()
            currentDateFormatter.dateFormat = "dd-MM-yyyy"
            let currentDateStr = currentDateFormatter.string(from: Date()) as String
            self.txtFldDateOfSowing?.text = currentDateStr
            sowDateStrToSet = currentDateStr
            
            self.checkStartDateToSetSetOnPicker()
        }
    }
    
    //MARK : backButtonClick
    override func backButtonClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: checkStartDateToSetSetOnPicker
    func checkStartDateToSetSetOnPicker(){
        let startDateFormatter: DateFormatter = DateFormatter()
        startDateFormatter.dateFormat = "dd-MM-yyyy"
        //let startDateStr = "06-Aug-2018"
        let startDateObj = startDateFormatter.date(from: self.startDate!)
        //print(startDateObj!)
        
        //let fromDateFormatter: DateFormatter = DateFormatter()
        //fromDateFormatter.dateFormat = "dd-MM-yyyy"
        //let currentDateToCheck = fromDateFormatter.string(from: Date()) as String
        //print(currentDateToCheck)
        //let currentDateObj = fromDateFormatter.date(from: currentDateToCheck)
        //print(currentDateObj!)
        
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let currentDate: NSDate = NSDate()
        
        let components: NSDateComponents = NSDateComponents()
        components.day = -10
        let toDate: NSDate = gregorian.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        
        let toDateFormatter: DateFormatter = DateFormatter()
        toDateFormatter.dateFormat = "dd-MM-yyyy"
        let toDateStr = toDateFormatter.string(from:toDate as Date) as String
        //print(toDateStr)
        let toDateObj = toDateFormatter.date(from: toDateStr)
        print(toDateObj!)
        
        if startDateObj == toDateObj {
            //print("same")
            datePickerStartDate = self.startDate
        }
        else if startDateObj! < toDateObj!{
            //print("less")
            datePickerStartDate = toDateStr
        }
        else if startDateObj! > toDateObj!{
            //print("greater")
            datePickerStartDate = self.startDate
        }
    }
    
    //MARK: fromDatePickerView
    func sowingDatePickerView(){
        let Height:CGFloat = (44.11 * self.view.frame.height/120)
        let width :CGFloat = self.view.frame.size.width-40 //-40
        let posX :CGFloat = (self.view.frame.size.width - width) / 2
        
        dateView = UIView (frame: CGRect(x: posX,y: (self.view.frame.height-Height)/2 ,width: width,height: Height))
        dateView?.backgroundColor = UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        dateView?.layer.cornerRadius = 10.0
        self.view.addSubview(dateView!)
        
        //datePicker
        let datePicker : UIDatePicker = UIDatePicker (frame: CGRect(x: 5,y: 5,width: width-10,height: Height-50))
        datePicker.backgroundColor = UIColor.white
        datePicker.layer.cornerRadius = 5.0
        datePicker.datePickerMode = UIDatePickerMode.date
        
        if Validations.isNullString(sowDateStrToSet as NSString) == false{
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let minDate = dateFormatter.date(from: sowDateStrToSet)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let str = dateFormatter.string(from: minDate!)
            datePicker.date = dateFormatter.date(from: str)!
        }
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let minDate = dateFormatter.date(from: datePickerStartDate!)
        let str = dateFormatter.string(from: minDate!)
        datePicker.minimumDate = dateFormatter.date(from: str)
        
        datePicker.maximumDate = NSDate() as Date

        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: .valueChanged)
        dateView?.addSubview(datePicker)
        
        //submit button
        let btnOK : UIButton = UIButton (frame: CGRect(x: 0, y: datePicker.frame.maxY+5,width: width,height: 40))
        btnOK.backgroundColor = UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 0.8)
        btnOK.layer.cornerRadius = 5.0
        btnOK.setTitle("OK", for: UIControlState())
        btnOK.addTarget(self, action: #selector(GerminationClaimPolicyViewController.alertOK), for: UIControlEvents.touchUpInside)
        dateView?.addSubview(btnOK)
        
        let dateViewFrame = dateView?.frame
        dateView?.frame.size.height = btnOK.frame.maxY
        dateView?.frame = dateViewFrame!
        
        dateView?.frame.origin.y = (self.view.frame.size.height - 64 - (dateView?.frame.size.height)!) / 2
        dateView?.frame = dateViewFrame!
    }
    
    //MARK: datePickerValueChanged
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        if dateView != nil{
            sowDateStrToSet = ""
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let selectedDate = dateFormatter.string(from: sender.date) as NSString
            //print("Selected value \(selectedDate)")
            txtFldDateOfSowing?.text = selectedDate as String
            sowDateStrToSet = selectedDate as String
        }
    }
    
    @objc func alertOK(){
        if dateView != nil{
            if Validations.isNullString(sowDateStrToSet as NSString) == false{
                self.txtFldDateOfSowing?.text = sowDateStrToSet
            }
            self.dateView?.removeFromSuperview()
            self.dateView = nil
        }
    }
    
    //MARK: Location service delegate methods
    func tracingLocation(_ currentLocation: CLLocation) {
        //print(String(format : "%f",currentLocation.coordinate.latitude), String(format : "%f",currentLocation.coordinate.longitude))
        locationService.stopUpdatingLocation()
    }
    
    func tracingLocationDidFailWithError(_ error: NSError) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        self.view.endEditing(true)
        let validationStatus = self.validations()
        if validationStatus == false{
            return
        }
        let paramsToServer = self.getParamsToSendToServer()
        GerminationServiceManager.submitGerminationClaim(params: paramsToServer, completionHandler: { (success, message) in
            if success == true{
                //print("success")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                //appDelegate.window?.makeToast(Germination_Claimed_Success_Msg, duration: 5.0, position: .bottom)
                //self.navigationController?.popViewController(animated: true)
                if self.claimSuccessAlert != nil{
                    self.claimSuccessAlert?.removeFromSuperview()
                }
                self.claimSuccessAlert = CustomAlert.alertInfoPopUpView(self, frame: self.view.frame, title: "Congratulations",message:message! as NSString, buttonTitle: "OK", hideClose: true) as? UIView
                appDelegate.window?.addSubview(self.claimSuccessAlert!)
            }
            else{
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.makeToast(message ?? "")
            }
        })
    }
    
    @objc func infoAlertSubmit(){
        if self.claimSuccessAlert != nil {
            self.claimSuccessAlert?.removeFromSuperview()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: validations
    func validations() -> Bool{
        var status = true
        if Validations.isNullString((self.txtFldTotalSowedAcres?.text! as NSString?)!) == true{
            self.view.makeToast("Please enter Total sowed acres.")
            status = false
            return status
        }
        let totalSowedAcres = (self.txtFldTotalSowedAcres?.text! as NSString?)?.floatValue
        if totalSowedAcres == 0{
            self.view.makeToast("Total sowed acres should not be zero(0).")
            status = false
            return status
        }
        if Validations.isNullString((self.txtFldGerminationFailedAcres?.text! as NSString?)!) == true{
            self.view.makeToast("Please enter Germination failed acres.")
            status = false
            return status
        }
        let germinationFailedAcres = (self.txtFldGerminationFailedAcres?.text! as NSString?)?.floatValue
        if germinationFailedAcres == 0{
            self.view.makeToast("Germination failed acres should not be zero(0).")
            status = false
            return status
        }
        if germinationFailedAcres ?? 0 > totalSowedAcres ?? 0{
            self.view.makeToast("Germination failed acres should be less than Total sowed acres.")
            status = false
            return status
        }
        return status
    }
    
    //MARK: getParamsToSendToServer
    func getParamsToSendToServer() -> NSMutableDictionary{
        let claimDictToServer = NSMutableDictionary()
        let mutArrayToServer = NSMutableArray()
        let claimPolicyDict = NSMutableDictionary()
        claimPolicyDict.setValue(txtFldGerminationFailedAcres?.text, forKey: "germinationFailedAcres")
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let sowDate = dateFormatter.date(from: (txtFldDateOfSowing?.text)!)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let sowDateToServer = dateFormatter.string(from: sowDate!)
        //print(sowDateToServer)
        claimPolicyDict.setValue(sowDateToServer, forKey: "dateOfSowing")
        claimPolicyDict.setValue(txtViewRemarks?.text, forKey: "remarks")
        claimPolicyDict.setValue(germinationModelObj?.germinationFarmerDataId, forKey: "germinationFarmerDataId")
        claimPolicyDict.setValue(coordinatePoints, forKey: "geoLocation")
        mutArrayToServer.add(claimPolicyDict)
        claimDictToServer.setValue(mutArrayToServer, forKey: "germinationFarmerClaimData")
        //print(claimDictToServer)
        return claimDictToServer
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

extension GerminationClaimPolicyViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtFldYear?.resignFirstResponder()
        self.txtFldSeason?.resignFirstResponder()
        self.txtFldCrop?.resignFirstResponder()
        self.txtFldTotalSowedAcres?.resignFirstResponder()
        self.txtFldGerminationFailedAcres?.resignFirstResponder()
        self.txtFldDateOfSowing?.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtFldDateOfSowing{
            self.txtFldDateOfSowing?.resignFirstResponder()
            self.sowingDatePickerView()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.txtFldGerminationFailedAcres {
            let validCharSet = CharacterSet(charactersIn: "0123456789. ").inverted
            let filtered: String = (string.components(separatedBy: validCharSet) as NSArray).componentsJoined(by: "")
            let _char = string.cString(using: String.Encoding.utf8)
            let isBackSpace: Int = Int(strcmp(_char, "\\b"))
            if isBackSpace == -92 {
                // is backspace
                //print("backspace")
                if textField.text?.count == 1 {
                    // print("textField is empty")
                }
                return true
            }
            if (filtered == "") {
                //print("invalid characters")
            }
            if (textField.text?.count)! >= 6 && range.length == 0 {
                //print("exceeded")
                return false
            }
            return (string == filtered)
        }
        else if textField == self.txtFldTotalSowedAcres {
            let validCharSet = CharacterSet(charactersIn: "0123456789. ").inverted
            let filtered: String = (string.components(separatedBy: validCharSet) as NSArray).componentsJoined(by: "")
            let _char = string.cString(using: String.Encoding.utf8)
            let isBackSpace: Int = Int(strcmp(_char, "\\b"))
            if isBackSpace == -92 {
                // is backspace
                //print("backspace")
                if textField.text?.count == 1 {
                    // print("textField is empty")
                }
                return true
            }
            if (filtered == "") {
                //print("invalid characters")
            }
            if (textField.text?.count)! >= 6 && range.length == 0 {
                //print("exceeded")
                return false
            }
            return (string == filtered)
        }
        return true
    }
}

extension GerminationClaimPolicyViewController : UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (textView.text?.count)! >= 250 && range.length == 0 {
            //print("exceeded")
            return false
        }
        return true
    }
}
