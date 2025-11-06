//
//  CEPContactsViewController.swift
//  FarmerConnect
//
//  Created by Empover on 16/08/21.
//  Copyright © 2021 ABC. All rights reserved.
//

import UIKit
import Contacts
//Step one
protocol selectedContacts: AnyObject {
    func getContact(_ array: NSMutableArray )
   
}


class CEPContactsViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    struct FetchedContact {
        var firstName: String
        var lastName: String
        var telephone: String
    }
    var searchTextField = UITextField()
    var searchButton : UIButton?
    var unsavedChangesAlert : UIView?
    var searchArray = NSMutableArray()
    weak var delegate: selectedContacts?
    @IBOutlet weak var referralTable: UITableView!
    var referralArray = NSMutableArray()
    var selectedArray = NSMutableArray()
    var selectedDicArray = NSMutableArray()
    var phonenumberArray = NSMutableArray()
    var contacts = [FetchedContact]()
    var searchContacts = [FetchedContact]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchTextField.isHidden == true{
       return contacts.count
        }
        else{
            return searchContacts.count
        }
    }
    
    //MARK: alertYesBtnAction
    @objc func alertYesBtnAction(){
    
            self.unsavedChangesAlert?.removeFromSuperview()
            self.navigationController?.popViewController(animated: true)
     
    }
    
    //MARK: alertNoBtnAction
    @objc func alertNoBtnAction(){
       
        if self.unsavedChangesAlert != nil {
            self.unsavedChangesAlert?.removeFromSuperview()
        }
       
    }
    
    @IBAction func submitAction(_ sender: Any) {
        self.delegate?.getContact(selectedDicArray)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func generateImageWithText(text: String) -> UIImage? {
        let image = UIImage(named: "imageWithoutText")!

        let imageView = UIImageView(image: image)
        imageView.backgroundColor = UIColor.clear
        imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = text

        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let imageWithText = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageWithText
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"

        let cell = referralTable.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UITableViewCell
        
         if searchTextField.isHidden == true{
        cell.textLabel?.font = UIFont.init(name: "Helvetica", size: 13.0)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.sizeToFit()
        var mobileLbl = cell.contentView.viewWithTag(2) as! UILabel
        var nameLbl = cell.contentView.viewWithTag(1) as! UILabel
        var checkButton = cell.contentView.viewWithTag(3) as! UIButton
        var titlebtn = cell.contentView.viewWithTag(6) as! UIButton
        nameLbl.text = String(format: "%@ %@",self.contacts[indexPath.row].firstName,self.contacts[indexPath.row].lastName)
        mobileLbl.text = String(format: "%@",self.contacts[indexPath.row].telephone)
        titlebtn.backgroundColor = .random
        let initialsa = nameLbl.text?.initials
        titlebtn.setTitle(initialsa, for: .normal)
        
//        if selectedArray.contains(indexPath.row){
//        checkButton.setImage(UIImage(named: "Selected_Checkbox"), for: .normal)
//        }else{
//            checkButton.setImage(UIImage(named: ""), for: .normal)
//        }
            
            let dic = [ "referralMobileNo": String(format: "%@", mobileLbl.text ?? ""),
                       "referralName": String(format: "%@",nameLbl.text ?? "")]
            
                    if selectedDicArray.contains(dic){
                        checkButton.setImage(UIImage(named: "Selected_Checkbox"), for: .normal)
                    }else{
                        checkButton.setImage(UIImage(named: ""), for: .normal)
                    }
            
            
            
          
         }
         else{
            cell.textLabel?.font = UIFont.init(name: "Helvetica", size: 13.0)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.sizeToFit()
            var mobileLbl = cell.contentView.viewWithTag(2) as! UILabel
            var nameLbl = cell.contentView.viewWithTag(1) as! UILabel
            var checkButton = cell.contentView.viewWithTag(3) as! UIButton
            var titlebtn = cell.contentView.viewWithTag(6) as! UIButton
            nameLbl.text = String(format: "%@ %@",self.searchContacts[indexPath.row].firstName,self.searchContacts[indexPath.row].lastName)
            mobileLbl.text = String(format: "%@",self.searchContacts[indexPath.row].telephone)
            titlebtn.backgroundColor = .random
            let initialsa = nameLbl.text?.initials
            titlebtn.setTitle(initialsa, for: .normal)
            
            
            
            
            let dic = [ "referralMobileNo": String(format: "%@", mobileLbl.text ?? ""),
                       "referralName": String(format: "%@",nameLbl.text ?? "")]
            
                    if selectedDicArray.contains(dic){
                        checkButton.setImage(UIImage(named: "Selected_Checkbox"), for: .normal)
                    }else{
                        checkButton.setImage(UIImage(named: ""), for: .normal)
                    }
            
                   
         }
        
        
        
        return cell
    }
    
    
    override func backButtonClick(_ sender: UIButton) {
     
        if selectedDicArray.count>0 {
            let alertMsgStr = NSLocalizedString("on_back_press_error", comment: "")
            let alertTitleStr = NSLocalizedString("alert", comment: "")
            self.unsavedChangesAlert = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: alertTitleStr as NSString, message: alertMsgStr as NSString, okButtonTitle: YES, cancelButtonTitle: NO) as! UIView
            self.view.addSubview(self.unsavedChangesAlert!)
            
        }else{
            self.navigationController?.popViewController(animated: true)
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.fetchContacts()
        // Do any additional setup after loading the view.
    }
    
    private func fetchContacts() {
        // 1.
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print("failed to request access", error)
                return
            }
            if granted {
                // 2.
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                do {
                    // 3.
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        self.contacts.append(FetchedContact(firstName: contact.givenName, lastName: contact.familyName, telephone: contact.phoneNumbers.first?.value.stringValue ?? ""))
                        self.searchContacts.append(FetchedContact(firstName: contact.givenName, lastName: contact.familyName, telephone: contact.phoneNumbers.first?.value.stringValue ?? ""))
                        
                      
                    })
                } catch let error {
                    print("Failed to enumerate contact", error)
                }
            } else {
                print("access denied")
            }
        }
    }
    
    //MAR:- SHOW MORE BUTTON POP WINDOW
    @objc @IBAction func search(_ sender: AnyObject) {
        self.lblTitle?.text = ""
        searchTextField.isHidden = false
        searchButton?.setImage( UIImage(named: "closeRHRD"), for: UIControlState())
        searchButton?.addTarget(self, action: #selector(CEPContactsViewController.closeSearch(_:)), for: UIControlEvents.touchUpInside)
    }
    
    //MAR:- SHOW MORE BUTTON POP WINDOW
    @objc @IBAction func closeSearch(_ sender: AnyObject) {
        self.lblTitle?.text = NSLocalizedString("cep_Select_Contacts", comment: "")
        searchButton?.setImage( UIImage(named: "Search"), for: UIControlState())
        searchTextField.isHidden = true
        searchButton?.addTarget(self, action: #selector(CEPContactsViewController.search(_:)), for: UIControlEvents.touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.topView?.isHidden = false
        self.homeButton?.isHidden = true
      
        self.lblTitle?.text = NSLocalizedString("cep_Select_Contacts", comment: "")
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        
        searchButton = UIButton()
        searchButton?.frame = CGRect(x:self.topView!.frame.size.width-40,y: 5,width: 44,height: 44)
        searchButton?.backgroundColor =  UIColor.clear
        searchButton?.setImage( UIImage(named: "Search"), for: UIControlState())
        searchButton?.addTarget(self, action: #selector(CEPContactsViewController.search(_:)), for: UIControlEvents.touchUpInside)
        self.topView?.addSubview(searchButton!)
        
        
        searchTextField.frame = CGRect(x:10,y: 5,width: self.view.frame.width - 60,height: 40)
        searchTextField.placeholder = NSLocalizedString("search", comment: "")
        searchTextField.backgroundColor = .white
        searchTextField.layer.cornerRadius = 10.0
        searchTextField.delegate = self
        self.topView?.addSubview(searchTextField)
        searchTextField.isHidden = true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchbyContacts()
       
        
        
    }
    
   
    
    func searchbyContacts(){
        
     searchContacts =    contacts.filter( { $0.firstName.range(of: searchTextField.text ?? "", options: .caseInsensitive) != nil})
        referralTable.reloadData()
//        var contacts = [CNContact]()
//          let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
//          let request = CNContactFetchRequest(keysToFetch: keys)
//
//          let contactStore = CNContactStore()
//          do {
//              try contactStore.enumerateContacts(with: request) {
//                  (contact, stop) in
//                  // Array containing all unified contacts from everywhere
//                  contacts.append(contact)
//              }
//          }
//          catch {
//              print("unable to fetch contacts")
//          }
        print(searchContacts)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchTextField.isHidden == true{
        if selectedArray.contains(indexPath.row){
            selectedArray.remove(indexPath.row)
           
        }
        else{
            selectedArray.add(indexPath.row)
        }
        
        let dic = [
            "referralMobileNo": String(format: "%@",self.contacts[indexPath.row].telephone),
            "referralName": String(format: "%@ %@",self.contacts[indexPath.row].firstName,self.contacts[indexPath.row].lastName)];
        
        if selectedDicArray.contains(dic){
            selectedDicArray.remove(dic)
        }else{
            selectedDicArray.add(dic)
        }
        referralTable.reloadData()
        }
        else{
            let dic = [
                "referralMobileNo": String(format: "%@",self.searchContacts[indexPath.row].telephone),
                "referralName": String(format: "%@ %@",self.searchContacts[indexPath.row].firstName,self.searchContacts[indexPath.row].lastName)];
            
            if selectedDicArray.contains(dic){
                selectedDicArray.remove(dic)
            }else{
                selectedDicArray.add(dic)
            }
            referralTable.reloadData()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                     green: .random(in: 0...1),
                     blue: .random(in: 0...1), alpha: 0.9)
    }
}

extension String {
    var initials: String {
        return self.components(separatedBy: " ").filter { !$0.isEmpty }.reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
    }
}
