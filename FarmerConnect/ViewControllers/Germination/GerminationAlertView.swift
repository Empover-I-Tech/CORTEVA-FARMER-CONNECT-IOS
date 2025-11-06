//
//  GerminationAlertView.swift
//  FarmerConnect
//
//  Created by Empover on 28/07/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit

class GerminationAlertView: UIView, UITextFieldDelegate {

    var germinationCropAcresAlertView : UIView?
    var txtFldCropAcres = UITextField()
    var germinationObj: GerminationList?
    var successHandler :((_ status:Bool,_ acres:String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.alertView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    convenience init(frame: CGRect,germination:GerminationList){
        self.init(frame: frame)
        self.germinationObj = germination
        self.alertView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtFldCropAcres.resignFirstResponder()
    }
    
    func alertView(){
        let titleStr = String(format: "Enter total %@ acres", (germinationObj?.cropName)!)
        self.germinationCropAcresAlertView = CustomAlert.farmerAssistAlert(self, frame: self.frame, title: titleStr as NSString, okButtonTitle: "Submit",placeHolderText:titleStr,keyboardType:.numberPad) as? UIView
        self.addSubview(self.germinationCropAcresAlertView!)
        self.bringSubview(toFront: germinationCropAcresAlertView!)
    }
    
    //MARK: farmer assist alertCloseBtn
    @objc func alertCloseBtn(){
        self.removeFromSuperview()
        if germinationCropAcresAlertView != nil{
            germinationCropAcresAlertView?.removeFromSuperview()
            germinationCropAcresAlertView = nil
        }
    }
    
    @objc func alertSubmit() {
        if germinationCropAcresAlertView != nil{
            txtFldCropAcres = germinationCropAcresAlertView?.viewWithTag(22222) as! UITextField
            txtFldCropAcres.delegate = self
            let enteredTxtFldAcres = (self.txtFldCropAcres.text! as NSString).floatValue
            let minAcres = (self.germinationObj?.minimumAcres as NSString? ?? "1" as NSString).floatValue
            //let maxAcres = (self.germinationObj?.maximumAcres as NSString? ?? "1" as NSString).floatValue
            self.txtFldCropAcres.resignFirstResponder()
            if Validations.isNullString(txtFldCropAcres.text! as NSString) == true{
                let toastMsg = String(format:"Please enter %@ acres.",(germinationObj?.cropName)!)
                self.makeToast(toastMsg)
            }
            else if enteredTxtFldAcres < minAcres{
                let toastMsg = String(format:Germination_Acerage_Qualification_Fail_Msg,germinationObj?.cropName ?? "")
                self.makeToast(toastMsg, duration: 5.0, position: .bottom)
            }
            else{
                if self.successHandler != nil{
                    self.successHandler!(true,self.txtFldCropAcres.text!)
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 22222 {
            let validCharSet = CharacterSet(charactersIn: "0123456789.").inverted
            let filtered: String = (string.components(separatedBy: validCharSet) as NSArray).componentsJoined(by: "")
            let _char = string.cString(using: String.Encoding.utf8)
            let isBackSpace: Int = Int(strcmp(_char, "\\b"))
            
            if isBackSpace == -92 {
                // is backspace
                //print("backspace")
                if textField.text?.count == 1 {
                    print("textField is empty")
                }
                return true
            }
            if (filtered == "") {
                //print("invalid characters")
            }
            if (textField.text?.count)! >= 8 && range.length == 0 {
                //print("exceeded")
                return false
            }
            return (string == filtered)
        }
        return true
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
