//
//  CEPReferralTableViewCell.swift
//  FarmerConnect
//
//  Created by EMPOVER-049 on 06/08/21.
//  Copyright © 2021 ABC. All rights reserved.
//

import UIKit
protocol DataSourceUpdateDelegate: class {
    func didUpdateDataIn(_ sender: UITableViewCell, with mobile: String?,  name: String?, tagsValue : Int? )
}
class CEPReferralTableViewCell: UITableViewCell,UITextFieldDelegate{
    weak var dataSourceDelegate: DataSourceUpdateDelegate?
    
    @IBOutlet weak var text_mobileNo: UITextField!
    @IBOutlet weak var lbl_mobile: UILabel!
    @IBOutlet weak var text_name: UITextField!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var btn_Delete: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setLeftPaddingToTextField(text_mobileNo, 10)
        self.setLeftPaddingToTextField(text_name, 10)
        // Initialization code
    }
    
    func configureCellWithData(_ mobileNo: String?, name: String?, delegate: DataSourceUpdateDelegate?)
    {
        text_mobileNo.text = mobileNo
        text_mobileNo.delegate = self        
        text_name.text = name
        text_name.delegate = self
        dataSourceDelegate = delegate
    }
    
    override func prepareForReuse() {
        text_mobileNo.text = ""
        text_name.text = ""
        super.prepareForReuse()
    }
    
    
    func setLeftPaddingToTextField(_ textField: UITextField, _ padding:CGFloat){
        textField.leftViewMode = .always
        textField.delegate = self
        textField.contentVerticalAlignment = .center
        textField.setLeftPaddingPoints(padding)
 
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        dataSourceDelegate?.didUpdateDataIn(self, with: text_mobileNo.text ,name : text_name.text, tagsValue : textField.tag  )
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let newString: String? = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
//
//
//        if textField == text_mobileNo {
//
//                let maxLength = 10
//                let currentString: NSString = textField.text! as NSString
//                if currentString == "" && Int(string)! < 6{
//                    return false
//                }
//                let newString: NSString =
//                    currentString.replacingCharacters(in: range, with: string) as NSString
//                return newString.length <= maxLength
//
//            }
//
//
//        return true
//    }
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       if textField == text_name {
        let validCharSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ").inverted
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
        if (textField.text?.count)! >= 90 && range.length == 0 {
            return false
        }
           return (string == filtered)
    }
        else{
                    let newString: String? = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
                    if textField == text_mobileNo {
            
                            let maxLength = 10
                            let currentString: NSString = textField.text! as NSString
                            if currentString == "" && Int(string)! < 6{
                                return false
                            }
                            let newString: NSString =
                                currentString.replacingCharacters(in: range, with: string) as NSString
                            return newString.length <= maxLength
            
                        }
        }
        return true
    }
}
