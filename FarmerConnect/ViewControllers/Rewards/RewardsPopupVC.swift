//
//  RewardsPopupVC.swift
//  FarmerConnect
//
//  Created by Empover on 20/05/21.
//  Copyright © 2021 ABC. All rights reserved.
//

import UIKit

protocol RewardsPopUpProtocol: class{
    func requestServerForRewardData(selectedLable: String, data: NSDictionary)
}
class RewardsPopupVC: BaseViewController, UITableViewDataSource, UITableViewDelegate {
   
    var dictEncashResponse : NSDictionary?
    var labelsArray: [String] = []
    
    var selectedLabel = ""
    var windowTitle = ""
    
    var delegate:RewardsPopUpProtocol?
    var tblViewRewardsDropdown = UITableView()
    var confirmationPopup = UIView()
    
    @IBOutlet weak var titlelable: UILabel!
    @IBOutlet weak var selectTextField: UITextField!
    
    @IBAction func labelButtonClicked(_ sender: UIButton ){
        if tblViewRewardsDropdown.isHidden == true {
            tblViewRewardsDropdown.isHidden = !tblViewRewardsDropdown.isHidden
            self.view.bringSubview(toFront: tblViewRewardsDropdown)
            tblViewRewardsDropdown.reloadData()
        }
        else{
            tblViewRewardsDropdown.isHidden = !tblViewRewardsDropdown.isHidden
        }
    }
    @IBAction func cancelBtnClicked(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func submitBtnClicked(_ sender: UIButton){
        if self.selectedLabel.isEmpty{
            self.view.makeToast("Please select a Label")
            return
        }
        let title = NSLocalizedString("confirm", comment: "")
        let cropDetail = dictEncashResponse?.value(forKey: "cofirmData") as! String
        let serialnumber = dictEncashResponse?.value(forKey: "prodSerialNumber") as! String
        let messageStrng = "\(NSLocalizedString("Please_Confirm_the_Below_Details", comment: "")) \n \(String(describing: cropDetail)) \n  \(NSLocalizedString("serial_no", comment: "")) : \(String(describing: serialnumber)) \n \(NSLocalizedString("Label_No", comment: "")) : \(selectedLabel) \n \n \(NSLocalizedString("Do_You_Want_To_Proceed", comment: ""))"
        let NSLocalizedMSgString = NSLocalizedString("\(messageStrng)", comment: "")
        
        self.confirmationPopup = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: NSLocalizedString("\(title)", comment: "") as! NSString, message: (NSLocalizedMSgString as! NSString), okButtonTitle: NSLocalizedString("yes", comment: ""), cancelButtonTitle: NSLocalizedString("no", comment: "")) as! UIView
        self.view.addSubview(self.confirmationPopup)
    }
    
    @objc func alertNoBtnAction(){
        if self.confirmationPopup != nil {
        self.confirmationPopup.removeFromSuperview()
        }
    }
    
    @objc func alertYesBtnAction(){
        if self.confirmationPopup != nil {
            self.confirmationPopup.removeFromSuperview()
        }
        if delegate != nil{
            delegate?.requestServerForRewardData(selectedLable: selectedLabel, data: dictEncashResponse!)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.loadDropDownTableView(tableViewDataSource: self, tableViewDelegate: self, tableview: tblViewRewardsDropdown, textField: selectTextField)
        tblViewRewardsDropdown.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tblViewRewardsDropdown.delegate = self
        tblViewRewardsDropdown.dataSource = self
        tblViewRewardsDropdown.estimatedRowHeight = 30
        
        self.titlelable.text = self.windowTitle
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelsArray.count+1 ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13.0)
        if indexPath.row == 0{
            cell.textLabel?.text = "Select Label"
        }else{
            cell.textLabel?.text = labelsArray[indexPath.row-1]
            }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            selectTextField.text = "Select Label"
            selectedLabel = ""
        }else{
            selectTextField.text = labelsArray[indexPath.row-1]
            selectedLabel = labelsArray[indexPath.row-1]
        }
        tableView.isHidden = true
        self.view.endEditing(true)
    }
}
extension RewardsPopupVC: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if tblViewRewardsDropdown.isHidden == true {
            tblViewRewardsDropdown.isHidden = !tblViewRewardsDropdown.isHidden
            self.view.bringSubview(toFront: tblViewRewardsDropdown)
            tblViewRewardsDropdown.reloadData()
        }
        else{
            tblViewRewardsDropdown.isHidden = !tblViewRewardsDropdown.isHidden
        }
    }
    
}
