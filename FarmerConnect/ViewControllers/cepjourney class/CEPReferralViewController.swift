//
//  CEPReferralViewController.swift
//  FarmerConnect
//
//  Created by EMPOVER-049 on 06/08/21.
//  Copyright © 2021 ABC. All rights reserved.
//

import UIKit

class CEPReferralViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,DataSourceUpdateDelegate {
    func didUpdateDataIn(_ sender: UITableViewCell, with mobile: String?, name: String?,tagsValue : Int?) {
        //        data[referralTable.indexPath(for: sender)!] = text
        
        let dic = [
            "referralMobileNo": mobile,
            "referralName": name];
        referralArray.replaceObject(at: tagsValue ?? 0, with: dic)
        
        print(mobile,name,sender.tag,tagsValue)
    }
    
    @IBOutlet weak var referralTable: UITableView!
    var isRHRD = false
    @IBOutlet weak var addBtnTopconstraint: NSLayoutConstraint!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var mobilLbl: UILabel!
    @IBOutlet weak var bgImg: UIImageView!
    var referralArray = NSMutableArray()
    var unsavedChangesAlert : UIView?
    var submissioAlert : UIView?
    var  IsDataSubmitted = false
    var data = [IndexPath : String]()
  var isDataChanged = false
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return referralArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celIDentifier = "cepRefCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: celIDentifier, for: indexPath) as! CEPReferralTableViewCell
        let cellData = data[indexPath]
        cell.text_mobileNo.tag = indexPath.row
        cell.text_name.tag = indexPath.row
        
        cell.text_name.placeholder = NSLocalizedString("ENTER_FARMER_NAME", comment: "")
        cell.text_mobileNo.placeholder = NSLocalizedString("ENTER_FARMER_NAME_Mobile", comment: "")
        cell.btn_Delete.tag = indexPath.row
        cell.lbl_name.text = NSLocalizedString("name", comment: "")
        cell.lbl_mobile.text = NSLocalizedString("mobile", comment: "")
        let dic : NSDictionary = referralArray.object(at: indexPath.row) as? NSDictionary ?? [:]
        cell.text_mobileNo.text = dic.object(forKey: "referralMobileNo") as? String ?? ""
        cell.text_name.text  = dic.object(forKey: "referralName") as? String ?? ""
        cell.configureCellWithData( cell.text_mobileNo.text, name : cell.text_name.text, delegate: self)
        return cell
    }
    
    
    
    @IBOutlet weak var referralTableheightConstraint: NSLayoutConstraint!
    @IBAction func submitAction(_ sender: Any) {
       
        if isRHRD{
            SubmitdataRHRD()
            
        }
        else{
        Submitdata()
        }
        
    }
    
    //MARK: alertYesBtnAction
    @objc func alertYesBtnAction(){
       
        if isDataChanged{
            if self.unsavedChangesAlert != nil {
                self.unsavedChangesAlert?.removeFromSuperview()
            }
            self.navigationController?.popViewController(animated: true)
            isDataChanged = false
        }
     else   if   IsDataSubmitted {
            self.submissioAlert?.removeFromSuperview()
            self.navigationController?.popViewController(animated: true)
        }
        else{
       
        let userObj = Constatnts.getUserObject()
        let referralArryAPI = NSMutableArray()
        for i in 0..<referralArray.count{
            let dic : NSDictionary = referralArray.object(at: i) as? NSDictionary ?? [:]
            if (dic.object(forKey: "referralMobileNo") as? String ?? "") != "" && dic.object(forKey: "referralName") as? String ?? "" != "" {
                
                referralArryAPI.add(dic)
            }
        }
        if isRHRD{
           
            let dict: NSDictionary = [
                "farmerId": userObj.customerId! as String,
                "referralMobileNumbers": referralArryAPI
            ]
            
            cepJourneySingletonClass.submitReferralDetailsRHRD(dictionary: dict ) { (status, responseDictionary, statusMessage) in
                SwiftLoader.hide()
                if status == true{
                    let userObj = Constatnts.getUserObject()
                    let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,]
                    self.registerFirebaseEvents(PV_CEP_Referral_Success, "", "", "", parameters: firebaseParams as NSDictionary)
                    
                    //UPDATE
                    self.recordScreenView("RHRDReferFarmerActivity", "CEPReferralViewController")
                    print(responseDictionary ?? [:])
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    let strMsg = String(format : "%@",statusMessage as String? ?? "")
                   // appDelegate?.window?.makeToast(statusMessage as String? ?? "")
                    self.IsDataSubmitted = true
                    self.submissioAlert = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: "" , message: strMsg as NSString, okButtonTitle:NSLocalizedString("ok", comment: "") , cancelButtonTitle: "") as? UIView
                    
                  
                    self.view.addSubview(self.submissioAlert!)
                    
                    
                }else{
                   
                    self.view.makeToast(statusMessage as String? ?? "")
                }
            }
            
        }
        else{
            let dict: NSDictionary = [
                "farmerId": userObj.customerId! as String,
                "referralMobileNumbers": referralArryAPI
            ]
            
            cepJourneySingletonClass.submitReferralDetails(dictionary: dict ) { (status, responseDictionary, statusMessage) in
                SwiftLoader.hide()
                if status == true{
                    let userObj = Constatnts.getUserObject()
                    let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,]
                    self.registerFirebaseEvents(PV_CEP_Referral_Success, "", "", "", parameters: firebaseParams as NSDictionary)
                    
                    //UPDATE
                    self.recordScreenView("CEPReferFarmerActivity", "CEPReferralViewController")
                    print(responseDictionary ?? [:])
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    let strMsg = String(format : "%@",statusMessage as String? ?? "")
                   // appDelegate?.window?.makeToast(statusMessage as String? ?? "")
                    self.IsDataSubmitted = true
                    self.submissioAlert = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: "" , message: strMsg as NSString, okButtonTitle:NSLocalizedString("ok", comment: "") , cancelButtonTitle: "") as? UIView
                    
                  
                    self.view.addSubview(self.submissioAlert!)
                    
                }else{
                    self.view.makeToast(statusMessage as String? ?? "")
                }
            }
        }
        }
    }
    
    //MARK: alertNoBtnAction
    @objc func alertNoBtnAction(){
        isDataChanged = false
        IsDataSubmitted = false
        if IsDataSubmitted {
            
            self.submissioAlert?.removeFromSuperview()
           
        }
        else{
        if self.unsavedChangesAlert != nil {
            self.unsavedChangesAlert?.removeFromSuperview()
        }
        }
       
        
    }
    
    
    @IBAction func DeleteAction(_ sender: UIButton) {
        if referralArray.count == 1{
            self.view.makeToast(NSLocalizedString("RHRD_DELETE_Refr_CONFIRMATION", comment: ""))
        }else{
        referralArray.removeObject(at: sender.tag)
        referralTable.reloadData()
        }
    }
    
    @IBAction func addNumberAction(_ sender: Any) {
        if referralArray.count>0{
            let dic : NSDictionary = referralArray.lastObject as? NSDictionary ?? [:]
            if   dic["referralName"] as? String == ""{
                self.view.makeToast(NSLocalizedString("RHRD_Enter_FarmerName", comment: ""))
                return
            }
            else if dic["referralMobileNo"] as? String == "" {
                self.view.makeToast(NSLocalizedString("RHRD_farmer_mobile", comment: ""))
                return
            }
        }
        let dic = [
            "referralMobileNo": "",
            "referralName": ""];
        referralArray.insert(dic, at: referralArray.count )
        referralTable.reloadData()
    }
    
    @IBAction func choosecontact(_ sender: Any) {
        
        let vcnavController = self.storyboard?.instantiateViewController(withIdentifier: "CEPContactsViewController") as? CEPContactsViewController
        vcnavController?.delegate = self
        self.navigationController?.pushViewController(vcnavController!, animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let dic = [
            "referralMobileNo": "",
            "referralName": ""];
        referralArray.add(dic)
        
        referralTable.reloadData()
        let userObj = Constatnts.getUserObject()
        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,]
        self.registerFirebaseEvents(PV_CEP_Referral, "", "", "", parameters: firebaseParams as NSDictionary)
        
        //UPDATE
        self.recordScreenView("CEPReferFarmerActivity", "CEPReferralViewController")
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.topView?.isHidden = false
        self.homeButton?.isHidden = true
        if isRHRD{
            self.bgImg.image = UIImage(named: "rhrd_referd")
            self.lblTitle?.text  = NSLocalizedString("rhrd_Refer_and_get_luckydraw", comment: "")
        }
        else{
        self.lblTitle?.text = NSLocalizedString("cep_Referral", comment: "")
        }
        submitBtn.setTitle(NSLocalizedString("cep_Share", comment: ""), for: .normal)
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
    }
    
    
    func Submitdata(){
        
        let userObj = Constatnts.getUserObject()
        let referralArryAPI = NSMutableArray()
        for i in 0..<referralArray.count{
            let dic : NSDictionary = referralArray.object(at: i) as? NSDictionary ?? [:]
            if (dic.object(forKey: "referralMobileNo") as? String ?? "") != "" && dic.object(forKey: "referralName") as? String ?? "" != "" {
                
                referralArryAPI.add(dic)
            }
        }
        
        if referralArryAPI.count > 0{
           
            self.unsavedChangesAlert = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: NSLocalizedString("alert", comment: "") as NSString, message: String(format: NSLocalizedString("RHRD_Refer_Submission_Confirm", comment: "")) as NSString, okButtonTitle:NSLocalizedString("yes", comment: "") , cancelButtonTitle: NSLocalizedString("no", comment: "")) as? UIView
            self.view.addSubview(self.unsavedChangesAlert!)
        }
        else {
            self.view.makeToast(NSLocalizedString("RHRD_farmer_mobile_name", comment: ""))
        }
    }
    
    override func backButtonClick(_ sender: UIButton) {
        isDataChanged = true
        if isDataChanged {
            let alertMsgStr = NSLocalizedString("on_back_press_error", comment: "")
            let alertTitleStr = NSLocalizedString("alert", comment: "")
            self.unsavedChangesAlert = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: alertTitleStr as NSString, message: alertMsgStr as NSString, okButtonTitle: YES, cancelButtonTitle: NO) as! UIView
            self.view.addSubview(self.unsavedChangesAlert!)
            
        }else{
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    func SubmitdataRHRD(){
        
        let userObj = Constatnts.getUserObject()
        let referralArryAPI = NSMutableArray()
        for i in 0..<referralArray.count{
            let dic : NSDictionary = referralArray.object(at: i) as? NSDictionary ?? [:]
            if (dic.object(forKey: "referralMobileNo") as? String ?? "") != "" && dic.object(forKey: "referralName") as? String ?? "" != "" {
                
                referralArryAPI.add(dic)
            }
        }
        
        if referralArryAPI.count > 0{

            self.unsavedChangesAlert = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: NSLocalizedString("alert", comment: "") as NSString, message: String(format: NSLocalizedString("RHRD_Refer_Submission_Confirm", comment: "")) as NSString, okButtonTitle:NSLocalizedString("yes", comment: "") , cancelButtonTitle: NSLocalizedString("no", comment: "")) as? UIView
            self.view.addSubview(self.unsavedChangesAlert!)
        }
        else {
            self.view.makeToast(NSLocalizedString("RHRD_farmer_mobile_name", comment: ""))
        }
    }
    
}



//MARK:- PROTOCAL DELEGATES
//MARK: - Protocol Delegate Methods
extension CEPReferralViewController: selectedContacts{
    
    func getContact(_ array: NSMutableArray) {
        print("==================")
        print(array)
        
        if array.count>0{
        let dic = [
            "referralMobileNo": "",
            "referralName": ""];
        if referralArray.contains(dic){
            referralArray.remove(dic)
        }
        
        for i in 0..<array.count{
            if referralArray.contains(array.object(at: i)){
                
            }else{
                referralArray.add(array.object(at: i))
            }
        }
        referralTable.reloadData()
        }
    }
}
