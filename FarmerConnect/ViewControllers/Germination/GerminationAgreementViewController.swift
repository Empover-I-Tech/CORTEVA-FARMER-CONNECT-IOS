//
//  GerminationAgreementViewController.swift
//  FarmerConnect
//
//  Created by Empover on 23/07/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit
import Alamofire

struct AgreementList : Codable {
    let year: String?
    let mobileNumber: String?
    let cropId: String?
    let seasonId: String?
    let targetAcres: String?
    let totalAcres: String?
    let actualPioneerAcres: String?
    let germinationId: String?
    let assistedBy: String?
    let assistedByMobileNumber: String?
}

struct GerminationFarmersList: Codable {
    //let agreementId: String?
    let germinationFarmersList: [AgreementList]?
}

class GerminationAgreementViewController: BaseViewController {

    @IBOutlet weak var agreeBtn: UIButton!
    
    @IBOutlet weak var acceptCheckbox: VKCheckbox!
    
    @IBOutlet weak var lblPrevDataTitle: UILabel!
    
    @IBOutlet weak var txtFldPrevTargetPioneerHybridAcres: UITextField!
    
    @IBOutlet weak var txtFldPrevActualPioneerHybridAcres: UITextField!
    
    @IBOutlet weak var lblCurrentDataTitle: UILabel!
    
    @IBOutlet weak var txtFldCurrentTotalNoOfAcres: UITextField!
    
    @IBOutlet weak var txtFldCurrentTargetPioneerHybridAcres: UITextField!
    
    @IBOutlet weak var lblAgreement: UILabel!
    
    @IBOutlet weak var agreementChkboxOuterView: UIView!
    
    @IBOutlet var lblCurrentYearTotalCropAcres: UILabel?
    
    var isFromHome :Bool = false
    var isFromGerminationList :Bool = false
    var germinationModelObj: GerminationList?
    var germinationSuccessAlert: UIView?
    var totalAcres:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        txtFldPrevActualPioneerHybridAcres.delegate = self
        txtFldPrevActualPioneerHybridAcres.setLeftPaddingPoints(5.0)
        
        txtFldPrevTargetPioneerHybridAcres.delegate = self
        txtFldPrevTargetPioneerHybridAcres.setLeftPaddingPoints(5.0)
        
        txtFldCurrentTotalNoOfAcres.delegate = self
        txtFldCurrentTotalNoOfAcres.setLeftPaddingPoints(5.0)
        
        txtFldCurrentTargetPioneerHybridAcres.delegate = self
        txtFldCurrentTargetPioneerHybridAcres.setLeftPaddingPoints(5.0)
        
        txtFldCurrentTotalNoOfAcres.text = totalAcres
        txtFldCurrentTotalNoOfAcres.isUserInteractionEnabled = false
        txtFldCurrentTotalNoOfAcres.textColor = UIColor.lightGray
        
        self.acceptCheckbox.borderColor = UIColor.black
        self.acceptCheckbox.cornerRadius = 0.0
        self.acceptCheckbox.backgroundColor = UIColor.white
        self.acceptCheckbox.setOn(false)
        agreeBtn.isEnabled = false
        agreeBtn.backgroundColor = UIColor.lightGray
        
        //print(germinationModelObj!)
        
        lblAgreement.text = germinationModelObj?.germinationText
        let currentCrop = String(format: "Total %@ acres", germinationModelObj?.cropName ?? "crop")
        lblCurrentYearTotalCropAcres?.text = currentCrop
        
        /*lblAgreement.text = """
        Will attempt to recover by breaking constraint
<NSLayoutConstraint:0x600000486ea0 UILabel:0x7fb69dc89c90'Status'.height == 20   (active)>
        2018-07-25 10:58:54.899615+0530 FarmerConnect[2271:229306] [MC] Loaded MobileCoreServices.framework
"""*/
        lblAgreement.sizeToFit()
        acceptCheckbox.checkboxValueChangedBlock = {
            isOn in
            //print("acceptCheckbox is \(isOn ? "True" : "False")")
            self.txtFldCurrentTotalNoOfAcres.resignFirstResponder()
            self.txtFldCurrentTargetPioneerHybridAcres.resignFirstResponder()
            self.txtFldPrevActualPioneerHybridAcres.resignFirstResponder()
            self.txtFldPrevTargetPioneerHybridAcres.resignFirstResponder()
            if isOn == true{
                self.acceptCheckbox.color = App_Theme_Blue_Color
                self.acceptCheckbox.backgroundColor = UIColor.white
                self.agreeBtn.isEnabled = true
                self.agreeBtn.backgroundColor = App_Theme_Blue_Color
            }
            else{
                self.acceptCheckbox.backgroundColor = UIColor.white
                self.agreeBtn.isEnabled = false
                self.agreeBtn.backgroundColor = UIColor.lightGray
            }
        }
        let userObj = Constatnts.getUserObject()
        if userObj.userLogsAllPrint == "true"{
        self.saveUserLogEventsDetailsToServer()
        }
    }
    func saveUserLogEventsDetailsToServer(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMddHHmmss" //"dd/MM/yyyy HH:mm:ss"
        var todaysDate = dateFormatter.string(from: Date())
        let userObj = Constatnts.getUserObject()
        
        let dict: NSDictionary = ["userModuleUsageLogs":[[
            "mobileNumber": userObj.mobileNumber,
            "deviceId": userObj.deviceId,
            "deviceType": "iOS",
            "customerId": userObj.customerId,
            "logTimeStamp": todaysDate as? NSString,
            "pincode": userObj.pincode,
            "districtLoggedin":userObj.districtName,
            "stateLoggedin":userObj.stateName,
            "stateName": userObj.stateName,
            "marketName":"",
            "commodity":"",
            
            "eventName": Home_Agreement,
            "className":"GerminationAgreementViewController",
            "moduleName":"Germination",
            
            "healthCardId":"",
            "productId":"",
            "cropId":"",
            "seasonId":"",
            "otherParams":"",
            "isOnlineRecord": "true"]] as? [NSDictionary]
        ]
        
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            userLogEventsSingletonClass.sendUserLogEventsDetailsToServer(dictionary: dict ?? NSDictionary()){ (status, statusMessage) in
                if status == true{
                }else{
                    self.view.makeToast(statusMessage as String? ?? "")
                }
            }
        }else{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let userLogEvents = dict["userModuleUsageLogs"] as! [NSDictionary]
                for eachLogEvent in userLogEvents {
                var userLogEvent: UserLogEvents = UserLogEvents(dict: eachLogEvent)
                userLogEvent.isOnlineRecord = "false"
                appDelegate.saveUserLogEventsModulewise(userLogEvent)
                }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.topView?.isHidden = false
        lblTitle?.text = "Germination"
//        if isFromHome == true {
//            self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
//        }
//        else{
            self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        //}
        
        let currentYear = germinationModelObj?.year
        let currentYearCropName = germinationModelObj?.cropName
        let currentYearSeasonName = germinationModelObj?.seasonName
        let prevYear = germinationModelObj?.prevYear
        
        let currentYearTitle = String(format:"%@ - %@ - %@",currentYear!,currentYearSeasonName! ,currentYearCropName!)
        self.lblCurrentDataTitle.text = currentYearTitle
        
        let prevYearTitle = String(format:"%@ - %@ - %@",prevYear!,currentYearSeasonName! ,currentYearCropName!)
        self.lblPrevDataTitle.text = prevYearTitle
    }
    
    override func backButtonClick(_ sender: UIButton) {
//        if isFromHome == true {
//            self.findHamburguerViewController()?.showMenuViewController()
//        }
//        else{
            self.navigationController?.popViewController(animated: true)
       // }
    }
    
    @IBAction func agreeButtonClick(_ sender: Any) {
        self.view.endEditing(true)
//        if Validations.isNullString(self.txtFldPrevTargetPioneerHybridAcres.text! as NSString) == false || Validations.isNullString(self.txtFldPrevActualPioneerHybridAcres.text! as NSString) == false{
//            if Validations.isNullString(self.txtFldPrevTargetPioneerHybridAcres.text! as NSString) == true{
//                self.view.makeToast("Please enter Previous year target pioneer hybrid acres.")
//                return
//            }
//            if Validations.isNullString(self.txtFldPrevActualPioneerHybridAcres.text! as NSString) == true{
//                self.view.makeToast("Please enter Previous year actual pioneer hybrid acres.")
//                return
//            }
//        }
        if Validations.isNullString(self.txtFldCurrentTotalNoOfAcres.text! as NSString) == true{
            let msg = String(format:"Please enter Current year total %@ acres.",self.germinationModelObj?.cropName ?? "total number of")
            self.view.makeToast(msg)
            return
        }
        let totalAcres = (self.txtFldCurrentTotalNoOfAcres.text! as NSString).floatValue
        if totalAcres == 0{
            self.view.makeToast("Current year total number of acres should not be zero(0).")
            return
        }
        if Validations.isNullString(self.txtFldCurrentTargetPioneerHybridAcres.text! as NSString) == true{
            self.view.makeToast("Please enter Current year target pioneer hybrid acres.")
            return
        }
        let targetAcres = (self.txtFldCurrentTargetPioneerHybridAcres.text! as NSString).floatValue
        if targetAcres == 0{
            self.view.makeToast("Current year target pioneer hybrid acres should not be zero(0).")
            return
        }
        if targetAcres > totalAcres{
            self.view.makeToast("Target acres should be less than total acres.")
            return
        }
        if self.acceptCheckbox.isOn() == false{
            self.view.makeToast("Please accept agreement.")
            return
        }
        let userObj = Constatnts.getUserObject()
        let currentYearAgreementListObj = AgreementList(year: germinationModelObj?.year, mobileNumber: userObj.mobileNumber! as String, cropId: germinationModelObj?.cropId, seasonId: germinationModelObj?.seasonId, targetAcres: self.txtFldCurrentTargetPioneerHybridAcres.text, totalAcres: self.txtFldCurrentTotalNoOfAcres.text, actualPioneerAcres: "",germinationId:germinationModelObj?.germinationId,assistedBy:"Farmer",assistedByMobileNumber:userObj.mobileNumber! as String)
        
        let prevYearAgreementListObj = AgreementList(year: germinationModelObj?.prevYear, mobileNumber: userObj.mobileNumber! as String, cropId: germinationModelObj?.cropId, seasonId: germinationModelObj?.seasonId, targetAcres: self.txtFldCurrentTargetPioneerHybridAcres.text, totalAcres: "", actualPioneerAcres: self.txtFldPrevActualPioneerHybridAcres.text,germinationId:"",assistedBy:"Farmer",assistedByMobileNumber:userObj.mobileNumber! as String)
        
        let germinationFarmersListObj = GerminationFarmersList(germinationFarmersList: [currentYearAgreementListObj,prevYearAgreementListObj])
        
        let encoder = JSONEncoder()
        do{
        let dataObj = try encoder.encode(germinationFarmersListObj)
            let outputStr = String(data: dataObj, encoding: .utf8)
            //print(outputStr!)
            if let data = outputStr?.data(using: String.Encoding.utf8) {
                do {
                    if let outputDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary{
                        print(outputDict)
                        GerminationServiceManager.submitGerminationAgreement(params: outputDict, completionHandler: { (success, message) in
                            if success == true{
                                //print("success")
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                                appDelegate.window?.makeToast(String(format: Germination_Enrolled_Success_Msg, self.germinationModelObj?.cropName ?? ""), duration: 5.0, position: .bottom)
//                                self.navigationController?.popViewController(animated: true)
                                let successMsg = String(format: Germination_Enrolled_Success_Msg, self.germinationModelObj?.cropName ?? "")
                                if self.germinationSuccessAlert != nil{
                                    self.germinationSuccessAlert?.removeFromSuperview()
                                }
                                self.germinationSuccessAlert = CustomAlert.alertInfoPopUpView(self, frame: self.view.frame, title: "Congratulations",message:successMsg as NSString, buttonTitle: "OK", hideClose: true) as? UIView
                                appDelegate.window?.addSubview(self.germinationSuccessAlert!)
//                                for controller in self.navigationController!.viewControllers as Array {
//                                    if controller.isKind(of: HomeViewController.self) {
//                                        self.navigationController!.popToViewController(controller, animated: true)
//                                        break
//                                    }
//                                }
                            }
                            else{
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.window?.makeToast(message ?? "")
                            }
                        })
                    }
                }
                catch{
                    
                }
            }
        }
        catch{
            
        }
    }
    
    @objc func infoAlertSubmit(){
        if self.germinationSuccessAlert != nil {
            self.germinationSuccessAlert?.removeFromSuperview()
            self.navigationController?.popViewController(animated: true)
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

extension GerminationAgreementViewController : UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtFldPrevActualPioneerHybridAcres.resignFirstResponder()
        self.txtFldPrevTargetPioneerHybridAcres.resignFirstResponder()
        self.txtFldCurrentTotalNoOfAcres.resignFirstResponder()
        self.txtFldCurrentTargetPioneerHybridAcres.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let validCharSet = CharacterSet(charactersIn: "0123456789.").inverted
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
        if (textField.text?.count)! >= 8 && range.length == 0 {
            return false
        }
        return (string == filtered)
    }
}
