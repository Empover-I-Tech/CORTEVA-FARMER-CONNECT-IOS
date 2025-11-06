//
//  RaiseTicketViewController.swift
//  FarmerConnect
//
//  Created by Empover on 19/03/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit
import Alamofire

class RaiseTicketViewController: BaseViewController , UITextViewDelegate{
    
    @IBOutlet weak var txtFldIssueType: UITextField!
    
    @IBOutlet weak var txtfldCrop: UITextField!
    
    @IBOutlet weak var txtFldHybrid: UITextField!
    
    @IBOutlet weak var txtFldLotNumber: UITextField!
    
    @IBOutlet weak var txtFldDamage: UITextField!
    
    @IBOutlet weak var txtFldPincode: UITextField!
    
    @IBOutlet weak var txtViewDescription: UITextView!
    
    @IBOutlet weak var txtFldFarmerName: UITextField!
    
    @IBOutlet weak var txtFldFarmerMobileNumber: UITextField!
    
    var cropDropDownTblView = UITableView()
    var hybridNameTblView = UITableView()
    var issueTypeDropDownTblView = UITableView()
    
    var cropID = NSString()
    var hybridID = NSString()
    
    var hybridMasterArray = NSMutableArray()
    var cropMasterArray = NSMutableArray()
    
    var cropArray = NSArray()
    var hybridArray = NSMutableArray()
    
    var issueTypeArray = [String]()
    var issueTypeID = 0
    var unsavedChangesAlert : UIView?
    
    var activeTxtField : UITextField?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.updateTextFieldPadding()
        
        txtfldCrop.delegate = self
        txtFldHybrid.delegate = self
        txtFldPincode.delegate = self
        txtFldIssueType.delegate = self
        txtFldFarmerName.delegate = self
        txtFldFarmerMobileNumber.delegate = self
        txtFldLotNumber.delegate = self
        txtFldDamage.delegate = self
        txtViewDescription.delegate = self
        
        self.txtFldLotNumber.placeholder = NSLocalizedString("lot_no_hint", comment: "")
        self.txtFldDamage.placeholder = NSLocalizedString("damge_hint", comment: "")
        self.txtViewDescription.text = NSLocalizedString("descr_hint", comment: "")
        self.txtViewDescription.textColor = UIColor.lightGray
        
        let selectStr = NSLocalizedString("select", comment: "")
        issueTypeArray = [selectStr ,"Complaint","Query","Feedback"]
        
        //crop dropdown tableView
        self.loadDropDownTableView(tableViewDataSource: self, tableViewDelegate: self, tableview: cropDropDownTblView, textField: txtfldCrop)
        cropDropDownTblView.dataSource = self
        cropDropDownTblView.delegate = self
        
        //hybrid dropdown tableView
        self.loadDropDownTableView(tableViewDataSource: self, tableViewDelegate: self, tableview: hybridNameTblView, textField: txtFldHybrid)
        hybridNameTblView.dataSource = self
        hybridNameTblView.delegate = self
        
        //issue type dropdown tableView
        self.loadDropDownTableView(tableViewDataSource: self, tableViewDelegate: self, tableview: issueTypeDropDownTblView, textField: txtFldIssueType)
        issueTypeDropDownTblView.dataSource = self
        issueTypeDropDownTblView.delegate = self
        self.recordScreenView("RaiseTicketViewController", Rise_Ticket)
        let userObj = Constatnts.getUserObject()
        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber,USER_ID:userObj.customerId,PINCODE:userObj.pincode,User_First_Name:userObj.firstName,User_Last_Name:userObj.lastName]
        self.registerFirebaseEvents(PV_Rise_Ticket, "", "", Rise_Ticket, parameters: fireBaseParams as NSDictionary)
    }
    
    //MARK: updateTextFieldPadding
    func updateTextFieldPadding(){
        self.addPaddingToTextField(txtFld: txtFldIssueType)
        self.addPaddingToTextField(txtFld: txtfldCrop)
        self.addPaddingToTextField(txtFld: txtFldHybrid)
        self.addPaddingToTextField(txtFld: txtFldLotNumber)
        self.addPaddingToTextField(txtFld: txtFldDamage)
        self.addPaddingToTextField(txtFld: txtFldPincode)
        self.addPaddingToTextField(txtFld: txtFldFarmerName)
        self.addPaddingToTextField(txtFld: txtFldFarmerMobileNumber)
        
        let userObj = Constatnts.getUserObject()
        txtFldFarmerName.text = String(format:"%@ %@",userObj.firstName!,userObj.lastName!)
        txtFldFarmerMobileNumber.text = String(format:"%@",userObj.mobileNumber!)
        txtFldPincode.text = userObj.pincode! as String
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //self.navigationController?.navigationBar.isHidden = false
        self.topView?.isHidden = false
        self.lblTitle?.text =  NSLocalizedString("ticket_raise", comment: "") //"Raise Ticket"
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        
        DispatchQueue.global().async {
            if let arrObj = UserDefaults.standard.value(forKey: "cropMaster") as? NSData {
                self.cropMasterArray.removeAllObjects()
                let cropMasterArr = NSKeyedUnarchiver.unarchiveObject(with: arrObj as Data) as? NSArray
                let cropsNamesSet =  NSSet(array:cropMasterArr as! [Any])
                self.cropArray = cropsNamesSet.allObjects as NSArray
                self.cropMasterArray.addObjects(from: cropsNamesSet.allObjects)
                let selectTempDict = NSMutableDictionary()
                let selectStr = NSLocalizedString("select", comment: "")
                selectTempDict.setValue(selectStr, forKey: "name")
                selectTempDict.setValue(-1, forKey: "id")
                self.cropMasterArray.insert(selectTempDict, at: 0)
                 //print(self.cropMasterArray)
            }
            if let arrObj = UserDefaults.standard.value(forKey: "hybridMaster") as? NSData {
                self.hybridMasterArray.removeAllObjects()
                self.hybridArray.removeAllObjects()
                let hybridMasterArr = NSKeyedUnarchiver.unarchiveObject(with: arrObj as Data) as? NSArray
                let hybridNamesSet =  NSSet(array:hybridMasterArr as! [Any])
                // self.hybridArray = hybridNamesSet.allObjects as NSArray
                self.hybridMasterArray.addObjects(from: hybridNamesSet.allObjects)
                let selectTempDict = NSMutableDictionary()
                 let selectStr = NSLocalizedString("select", comment: "")
                selectTempDict.setValue(selectStr, forKey: "name")
                selectTempDict.setValue(-1, forKey: "id")
                self.hybridMasterArray.insert(selectTempDict, at: 0)
                self.hybridArray.addObjects(from: self.hybridMasterArray as! [Any])
                 //print(self.hybridMasterArray)
            }
        }
        DispatchQueue.main.async {
            self.updateUI()
        }
    }
    
    func updateUI(){
        txtFldHybrid.text = ""
        txtFldHybrid.isEnabled = false
        self.cropDropDownTblView.reloadData()
        self.hybridNameTblView.reloadData()
    }
    
    override func backButtonClick(_ sender: UIButton) {
        if self.checkForUnSavedChangesAlert() == true{
            let extMSg = NSLocalizedString("form_exit_msg", comment: "")
            let yesStr = NSLocalizedString("yes", comment: "")
            let noStr = NSLocalizedString("no", comment: "")
            
            self.unsavedChangesAlert = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: "" as NSString, message: String(format: extMSg) as NSString, okButtonTitle: yesStr, cancelButtonTitle: noStr) as? UIView
            self.view.addSubview(self.unsavedChangesAlert!)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }

    //MARK: alertYesBtnAction
    @objc func alertYesBtnAction(){
        if self.unsavedChangesAlert != nil {
            self.unsavedChangesAlert?.removeFromSuperview()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: alertNoBtnAction
    @objc func alertNoBtnAction(){
        unsavedChangesAlert?.removeFromSuperview()
    }
    
    func checkForUnSavedChangesAlert() -> Bool{
        //Validations.isNullString(txtFldFarmerName.text! as NSString) == false || Validations.isNullString(txtFldFarmerMobileNumber.text! as NSString) == false ||Validations.isNullString(txtFldPincode.text! as NSString) == false ||
        if (txtFldIssueType.text != NSLocalizedString("select", comment: "") || txtfldCrop.text != NSLocalizedString("select", comment: "") || Validations.isNullString(txtFldHybrid.text! as NSString) == false || Validations.isNullString(txtFldLotNumber.text! as NSString) == false || Validations.isNullString(txtFldDamage.text! as NSString) == false || Validations.isNullString(txtViewDescription.text! as NSString) == false) {
            return true
        }
        return false
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
    
    //MARK: filterHybridWithCrop
    func filterHybridWithCrop(cropDic: NSDictionary?){
        if cropDic != nil {
            cropID = String(cropDic!.value(forKey: "id") as! Int) as NSString
            //hybrid
            let hybridPredicate = NSPredicate(format: "cropId = %d",cropID.intValue)
            let hybridFilteredArr = (self.hybridArray).filtered(using: hybridPredicate) as NSArray
            //print("hybrid filtered data array : \(hybridFilteredArr)")
            self.hybridMasterArray.removeAllObjects()
            self.hybridMasterArray.addObjects(from: hybridFilteredArr as! [Any])
            self.hybridNameTblView.reloadData()
            //get hybrid id
            if hybridFilteredArr.count > 0{
                txtFldHybrid.isEnabled = true
                if let hybridDic = hybridFilteredArr.firstObject as? NSDictionary{
                    //txtFldHybrid.text = hybridDic.value(forKey: "name") as? String
                    txtFldHybrid.text = (self.hybridArray.firstObject as? NSDictionary)?.value(forKey: "name") as? String
                    hybridID = String(hybridDic.value(forKey: "id") as! Int) as NSString
                }
            }
            else{
                txtFldHybrid.text = ""
                txtFldHybrid.isEnabled = false
                let noHybridsText = NSLocalizedString("noHybrid", comment: "")
                self.view.makeToast(noHybridsText)
            }
        }
    }
    
    //MARK: hideUnhideDropDownTblView
    func hideUnhideDropDownTblView(tblView : UITableView, hideUnhide : Bool){
        issueTypeDropDownTblView.isHidden = true
        cropDropDownTblView.isHidden = true
        hybridNameTblView.isHidden = true
        tblView.isHidden = hideUnhide
    }
    
    @IBAction func clearButtonClick(_ sender: Any) {
        self.view.endEditing(true)
        txtFldIssueType.text = issueTypeArray[0]
        let cropDic = cropMasterArray.object(at:0) as? NSDictionary
        txtfldCrop.text = cropDic?.value(forKey: "name") as? String
        txtFldHybrid.text = ""
        txtFldHybrid.isEnabled = false
        txtFldLotNumber.text = ""
        txtFldDamage.text = ""
        txtViewDescription.text = ""
        issueTypeID = 0
        cropID = ""
        hybridID = ""
    }
    
    @IBAction func submitButtonClick(_ sender: Any) {
        //print("issueTypeID : \(issueTypeID) , cropID : \(cropID) , hybridID : \(hybridID)")
        
        if txtFldIssueType.text == NSLocalizedString("select", comment: ""){
            self.view.makeToast("Please select issue type")
            return
        }
        else if txtfldCrop.text == NSLocalizedString("select", comment: ""){
            self.view.makeToast("Please select Crop type")
            return
        }
        else if txtFldHybrid.text == NSLocalizedString("select", comment: ""){
            self.view.makeToast("Please select Hybrid type")
            return
        }
        else if Validations.isNullString(txtFldLotNumber.text! as NSString) == true{
            self.view.makeToast("Lot Number should not be empty")
            return
        }
        else if Validations.isNullString(txtFldDamage.text! as NSString) == true{
            self.view.makeToast("Damage Percentage should not be empty")
            return
        }
        else if txtFldPincode.text == NSLocalizedString("select", comment: ""){
            self.view.makeToast("Please select Pincode")
            return
        }
        else if Validations.isNullString(txtViewDescription.text! as NSString) == true{
            self.view.makeToast("Please enter Description")
            return
        }
        let raiseTicketParams = ["id":Constatnts.getCurrentMillis(),"name":txtFldFarmerName.text!,"pincode":txtFldPincode.text!,"description":txtViewDescription.text!,"issueType":String(issueTypeID),"crop":cropID,"hybrid":hybridID,"lotNo":txtFldLotNumber.text!,"damagePerc":txtFldDamage.text!,"isUserExist":true,"mobileNo":txtFldFarmerMobileNumber.text!,"isSentToServer":false] as [String : Any]
         //print(raiseTicketParams)
        let userObj = Constatnts.getUserObject()
        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,PINCODE:userObj.pincode ?? "",User_First_Name:userObj.firstName!,User_Last_Name:userObj.lastName!,CROP:txtfldCrop.text!,HYBRID:txtFldHybrid.text!] as [String : Any]
        self.registerFirebaseEvents(Customer_Support_Submit, "", "", Rise_Ticket, parameters: fireBaseParams as NSDictionary)
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            let raiseTicketObj = RaiseTicket(dict:raiseTicketParams as NSDictionary)
            ParamarshSingleton.saveRaiseTicketDetails(raiseTicketObj)
            ParamarshSingleton.sendPendingTicketsToServer()
            
            ParamarshSingleton.successHandler = {(success) -> Void in
                if success == true{
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
    }
}

extension RaiseTicketViewController :  UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == cropDropDownTblView {
            return cropMasterArray.count
        }
        else if tableView == hybridNameTblView {
            return hybridMasterArray.count
        }
        else{
            return issueTypeArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 14.0)
        
        if tableView == cropDropDownTblView {
            let cropDic = cropMasterArray.object(at: indexPath.row) as? NSDictionary
            cell.textLabel?.text = cropDic?.value(forKey: "name") as? String
        }
        else if tableView == hybridNameTblView {
            let hybridDic = hybridMasterArray.object(at: indexPath.row) as? NSDictionary
            cell.textLabel?.text = hybridDic?.value(forKey: "name") as? String
        }
        else if tableView == issueTypeDropDownTblView{
            cell.textLabel?.text = issueTypeArray[indexPath.row] as String
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.hideUnhideDropDownTblView(tblView: tableView, hideUnhide: true)
        if tableView == cropDropDownTblView {
            //get crop id
            let cropDic = self.cropMasterArray.object(at: indexPath.row) as? NSDictionary
            cropID = String(cropDic!.value(forKey: "id") as! Int) as NSString
            txtfldCrop.text = cropDic?.value(forKey: "name") as? String
            
            if txtfldCrop.text == NSLocalizedString("select", comment: ""){
                txtFldHybrid.text = ""
                txtFldHybrid.isEnabled = false
            }
            else{
                txtFldHybrid.isEnabled = true
                self.filterHybridWithCrop(cropDic: cropDic)
            }
            //cropDropDownTblView.isHidden = true
            txtfldCrop.resignFirstResponder()
        }
        else if tableView == hybridNameTblView{
            let hybridDic = self.hybridMasterArray.object(at: indexPath.row) as? NSDictionary
            hybridID = String(hybridDic!.value(forKey: "id") as! Int) as NSString
            txtFldHybrid.text = hybridDic?.value(forKey: "name") as? String
            //hybridNameTblView.isHidden = true
            txtFldHybrid.resignFirstResponder()
        }
            //        else if tableView == pincodeDropDownTblView{
            //            let pincodeDic = self.pincodeMasterArray.object(at: indexPath.row) as? NSDictionary
            //            //            pincodeID = String(pincodeDic!.value(forKey: "id") as! Int) as NSString
            //            pincodeID = pincodeDic!.value(forKey: "id") as! Int
            //            txtFldPincode.text = pincodeDic?.value(forKey: "name") as? String
            //            //pincodeDropDownTblView.isHidden = true
            //            txtFldPincode.resignFirstResponder()
            //        }
        else{
            // issueTypeDropDownTblView.isHidden = true
            txtFldIssueType.text = issueTypeArray[indexPath.row] as String
            issueTypeID = indexPath.row
        }
        activeTxtField?.resignFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.view.endEditing(true)
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

extension RaiseTicketViewController : UITextFieldDelegate{
    //MARK: textfield delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        if textField == txtfldCrop {
            cropDropDownTblView.isHidden = true
        }
        else if textField == txtFldHybrid {
            cropDropDownTblView.isHidden = true
            hybridNameTblView.isHidden = true
        }
        else{
            cropDropDownTblView.isHidden = true
            hybridNameTblView.isHidden = true
            issueTypeDropDownTblView.isHidden = true
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //self.activeTxtField?.resignFirstResponder()
        if textField == txtfldCrop {
            self.view.endEditing(true)
            activeTxtField = textField
            cropDropDownTblView.reloadData()
            self.hideUnhideDropDownTblView(tblView: cropDropDownTblView, hideUnhide: false)
            return false
        }
        else if textField == txtFldHybrid {
            self.view.endEditing(true)
            activeTxtField = textField
            hybridNameTblView.reloadData()
            self.hideUnhideDropDownTblView(tblView: hybridNameTblView, hideUnhide: false)
            return false
        }
        else if textField == txtFldIssueType{
            self.view.endEditing(true)
            activeTxtField = textField
            issueTypeDropDownTblView.reloadData()
            self.hideUnhideDropDownTblView(tblView: issueTypeDropDownTblView, hideUnhide: false)
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //textField.resignFirstResponder()
        //activeTxtField?.resignFirstResponder()
        //self.view.endEditing(true)
        if textField == txtfldCrop {
            txtfldCrop.resignFirstResponder()
            cropDropDownTblView.reloadData()
            self.hideUnhideDropDownTblView(tblView: cropDropDownTblView, hideUnhide: false)
        }
        else if textField == txtFldHybrid {
            txtFldHybrid.resignFirstResponder()
            hybridNameTblView.reloadData()
            self.hideUnhideDropDownTblView(tblView: hybridNameTblView, hideUnhide: false)
        }
        else if textField == txtFldIssueType{
            txtFldIssueType.resignFirstResponder()
            issueTypeDropDownTblView.reloadData()
            self.hideUnhideDropDownTblView(tblView: issueTypeDropDownTblView, hideUnhide: false)
        }
        else{
            issueTypeDropDownTblView.isHidden = true
            cropDropDownTblView.isHidden = true
            hybridNameTblView.isHidden = true
        }
        activeTxtField = textField
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == txtViewDescription {
        if textView.textColor == UIColor.lightGray {
            txtViewDescription.text = ""
            txtViewDescription.textColor = UIColor.black
        }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFldFarmerMobileNumber{
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
            if (textField.text?.count)! >= 10 && range.length == 0 {
                return false
            }
            return (string == filtered)
        }
        else if textField == txtFldLotNumber{
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
            //            if (textField.text?.count)! >= 10 && range.length == 0 {
            //                return false
            //            }
            return (string == filtered)
        }
        else if textField == txtFldDamage{
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
            //            if (textField.text?.count)! >= 10 && range.length == 0 {
            //                return false
            //            }
            return (string == filtered)
        }
        return true
    }
}
