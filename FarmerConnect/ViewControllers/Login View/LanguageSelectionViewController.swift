//
//  LanguageSelectionViewController.swift
//  FarmerConnect
//
//  Created by Apple on 03/12/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import UIKit
import Alamofire

class LanguageSelectionViewController: BaseViewController {
    //circle-selected
    //circle-unselected
    
    var countriesListMutArray = NSMutableArray()
    var countryDropDownTblView = UITableView()
    var countryIDStr = "4"
    var selectedCountryName = "India"
    
    @IBOutlet weak var countryDropDownTxtFld: UITextField!
    @IBOutlet weak var collectionViewLanguages: UICollectionView!
    @IBOutlet weak var hgtConstraint : NSLayoutConstraint!
    
    var filteredArray = NSArray()
    var arrLanguages = [String]()
    var arrLanguageCodes = [String]()
    
    /// stores devideID and sends to server
    var deviceID = ""
    var activeTxtField : UITextField?
    
    var alertView = UIView()
    var selectedLanguage = ""
    var selectedLanguageCode = ""
    var isFromHome : Bool = false
    
    var languageCellInfo = [CellInfo]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        countryDropDownTxtFld.tintColor = UIColor.clear
        
        self.loadCountriesDropDownTableView()
        
        countryDropDownTblView.dataSource = self
        countryDropDownTblView.delegate = self
        countryDropDownTblView.tableFooterView = UIView()
        countryDropDownTblView.separatorInset = .zero
        
        countryDropDownTxtFld.delegate = self
        
        self.collectionViewLanguages.allowsMultipleSelection = false
        
        self.requestToGetCountriesListData()
        //countryDropDownTblView.isHidden = true
        
        arrLanguages = ["English","हिन्दी","తెలుగు","தமிழ்","ਪੰਜਾਬੀ"]
        arrLanguageCodes = ["en","hi","te","ta","pa"]
        
        let language  = UserDefaults.standard.value(forKey: "selectedLanguage"
            
            
            ) as? String
        // Do any additional setup after loading the view.
               for i in arrLanguageCodes {
                   if i == language {
                       selectedLanguageCode  =  i
                   }
               }
              
        
        for (i,j) in arrLanguages.enumerated() {
            var info = CellInfo()
            info.name = arrLanguages[i]
            info.isSelected = false
            self.languageCellInfo.append(info)
        }
        
        collectionViewLanguages.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
         selectedLanguageCode = appDelegate.selectedLanguage
        
        self.navigationController?.navigationBar.isHidden = true
        
        countryDropDownTxtFld.text = "India"
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        countryDropDownTblView.isHidden = true
    }
    
    //MARK: loadCountriesDropDownTableView
    func loadCountriesDropDownTableView(){
        
        countryDropDownTblView.dataSource = self
        countryDropDownTblView.delegate = self
        countryDropDownTblView.isScrollEnabled = true
        countryDropDownTblView.isHidden = true
        //dropDownTableView.layer.cornerRadius = 5.0
        countryDropDownTblView.layer.borderWidth = 0.5
        //cityDropDownTableView.cellLayoutMarginsFollowReadableWidth = false
        countryDropDownTblView.layer.borderColor = UIColor.gray.cgColor
        countryDropDownTblView.translatesAutoresizingMaskIntoConstraints = false
        countryDropDownTblView.tableFooterView = UIView()
        
        self.view.addSubview(countryDropDownTblView)
        
        let xConstraint = NSLayoutConstraint.init(item: countryDropDownTblView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem:countryDropDownTxtFld , attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0) as NSLayoutConstraint
        let yConstraint = NSLayoutConstraint.init(item: countryDropDownTblView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem:countryDropDownTxtFld , attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0) as NSLayoutConstraint
        let widthConstraint = NSLayoutConstraint.init(item: countryDropDownTblView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem:countryDropDownTxtFld , attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0.0) as NSLayoutConstraint
        let heightConstraint = NSLayoutConstraint.init(item: countryDropDownTblView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem:countryDropDownTxtFld , attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 120.0) as NSLayoutConstraint
        
        self.view.addConstraints([xConstraint,yConstraint,widthConstraint,heightConstraint])
    }
    
    //MARK: requestToGetCountriesData
    func requestToGetCountriesListData(){
        
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,LOGIN_GET_COUNTRIES_LIST])
        
        Alamofire.request(urlString, method: .post, parameters: ["data" : ""], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        //print("Response after decrypting data:\(decryptData)")
                        
                        let countryListArray = decryptData.value(forKey: "countryList") as! NSArray
                        self.countriesListMutArray.removeAllObjects()
                        for i in 0 ..< countryListArray.count{
                            let countriesDict = countryListArray.object(at: i) as? NSDictionary
                            let countryData = Country(dict: countriesDict!)
                            self.countriesListMutArray.add(countryData)
                        }
                        //print(self.countriesListMutArray)
                        
                        let predicate = NSPredicate(format: "countryName == [cd] %@","India")
                        self.filteredArray = (countryListArray).filtered(using: predicate) as NSArray
                        //print(self.filteredArray)
                        
                        DispatchQueue.main.async {
                            
                            if let idObj = (self.filteredArray.object(at: 0) as! NSDictionary).value(forKey: "id") as? Int {
                                self.countryIDStr = String(format: "%d",idObj) as String
                            }
                            
                            self.countryDropDownTblView.reloadData()
                        }
                        
                    }
                }
            }
        }
    }
    
    func changeDefaultLanguage(_ row : Int){
        if arrLanguages[row] == "English" {
            selectedLanguageCode = "en"
            selectedLanguage = "English"
        }else if arrLanguages[row] == "हिन्दी" {
            selectedLanguageCode = "hi"
            selectedLanguage = "हिन्दी"
        }
        else if arrLanguages[row] == "ਪੰਜਾਬੀ" {
            selectedLanguageCode = "pa"
            selectedLanguage = "ਪੰਜਾਬੀ"
        }
        else if arrLanguages[row] == "తెలుగు" {
            selectedLanguageCode = "te"
            selectedLanguage = "తెలుగు"
            
        }
        else if arrLanguages[row] == "தமிழ்" {
            selectedLanguageCode = "ta"
            selectedLanguage = "தமிழ்"
        }
        self.selectedlanguageDidChange()
    }
    
    func selectedlanguageDidChange(){
        
        if selectedLanguage == "English" {
            
            selectedLanguageCode = "en"
            selectedLanguage = "English"
        }else if selectedLanguage == "हिन्दी" {
            selectedLanguageCode = "hi"
            selectedLanguage = "हिन्दी"
        }
        else if selectedLanguage == "ਪੰਜਾਬੀ" {
            selectedLanguageCode = "pa"
            selectedLanguage = "ਪੰਜਾਬੀ"
        }
        else if selectedLanguage == "తెలుగు" {
            selectedLanguageCode = "te"
            selectedLanguage = "తెలుగు"
            
        }
        else if selectedLanguage == "தமிழ்" {
            
            selectedLanguageCode = "ta"
            selectedLanguage = "தமிழ்"
        }
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.selectedLanguage =  selectedLanguageCode
        appDelegate.selectedLanguageName = selectedLanguage
        
        UserDefaults.standard.set([appDelegate.selectedLanguage], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(appDelegate.selectedLanguage , forKey: "selectedLanguage")
             UserDefaults.standard.synchronize()
        
        // Update the language by swaping bundle
        Bundle.setLanguage(appDelegate.selectedLanguage)
        
        // Done to reintantiate the storyboards instantly
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateInitialViewController()
        
       
    }
    
    @IBAction func navigatingToLoginScreen(_ Sender : UIButton) {
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? ViewController
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
}
extension LanguageSelectionViewController  : UITextFieldDelegate {
    //MARK: textfield delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        countryDropDownTblView.isHidden = true
        //  activeTxtField?.resignFirstResponder()
        if textField == countryDropDownTxtFld{
            self.view.endEditing(true)
            countryDropDownTblView.isHidden = false
            activeTxtField = textField
            return false
        }
        
        return true
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        countryDropDownTblView.isHidden = true
        //    activeTxtField?.resignFirstResponder()
        if textField == countryDropDownTxtFld{
            self.view.endEditing(true)
            countryDropDownTblView.isHidden = false
        }
        activeTxtField = textField
    }
    
}
extension LanguageSelectionViewController : UITableViewDelegate , UITableViewDataSource {
    //MARK: dropdown tableview datasource & delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesListMutArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 14.0)
        let countryCell = countriesListMutArray.object(at: indexPath.row) as? Country
        cell.textLabel?.text = countryCell?.value(forKey: "countryName") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let countryCell = countriesListMutArray.object(at: indexPath.row) as? Country
        countryDropDownTxtFld.text = countryCell?.value(forKey: "countryName") as? String ?? "India"
        //        countryCodeTxtFld.text = countryCell?.value(forKey: "countryCode") as? String ?? ""
        countryIDStr = (countryCell?.value(forKey: "countryId") as? String)!
        if countryIDStr == "5" {
            self.collectionViewLanguages.isUserInteractionEnabled = true
            self.arrLanguages.removeAll()
            self.arrLanguageCodes.removeAll()
           arrLanguages = ["English","हिन्दी","తెలుగు","தமிழ்","ਪੰਜਾਬੀ"]
           arrLanguageCodes = ["en","hi","te","ta","pa"]
           hgtConstraint.constant = 110
            
        }else {
            self.collectionViewLanguages.isUserInteractionEnabled = false
            self.arrLanguages.removeAll()
                       self.arrLanguages.append("English")
                       self.arrLanguageCodes.removeAll()
                       self.arrLanguageCodes.append("en")
                        hgtConstraint.constant = 50
          selectedLanguageCode = "en"
          selectedLanguage = "English"
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.selectedLanguage =  selectedLanguageCode
            appDelegate.selectedLanguageName = selectedLanguage
        }
        self.languageCellInfo.removeAll()
        for (i,j) in arrLanguages.enumerated() {
                   var info = CellInfo()
                   info.name = arrLanguages[i]
                   info.isSelected = false
                   self.languageCellInfo.append(info)
               }
      
        collectionViewLanguages.reloadData()
        countryDropDownTblView.isHidden = true
        activeTxtField?.resignFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.view.endEditing(true)
        }
    }
}
extension LanguageSelectionViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.languageCellInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionViewLanguages.dequeueReusableCell(withReuseIdentifier: "languageCell", for: indexPath) as! LanguageCell
        
        cell.lblLanguage.text = self.languageCellInfo[indexPath.item].name
//        cell.selectionButton.tag = indexPath.item
//        cell.selectionButton.addTarget(self, action: #selector(selectLanagugage(_:)), for: .touchUpInside)
        print(appDelegate.selectedLanguage)
        print(self.languageCellInfo[indexPath.item].name)
        cell.selectionButton.isUserInteractionEnabled = false
        if countryIDStr != "5" && appDelegate.selectedLanguage == self.arrLanguageCodes[indexPath.item] {
                   cell.selectionButton.setImage(UIImage(named: "circle-selected"), for: .normal)
               }
        else {
            if  appDelegate.selectedLanguage == self.arrLanguageCodes[indexPath.item] && countryIDStr == "5" {
            cell.selectionButton.setImage(UIImage(named: "circle-selected"), for: .normal)
            
        }else {
            self.languageCellInfo[indexPath.item].isSelected = false
            cell.selectionButton.setImage(UIImage(named: "circle-unselected"), for: .normal)
            
        }
        }
        cell.contentView.backgroundColor = UIColor.white
        
        return cell
    }
    @objc @IBAction func selectLanagugage(_ sender : UIButton){
        if sender.imageView?.image == UIImage(named: "circle-selected") {
             sender.setImage(UIImage(named: "circle-unselected"), for: .normal)
        }else {
             sender.setImage(UIImage(named: "circle-selected"), for: .normal)
        }
       
        self.changeDefaultLanguage(sender.tag)
        self.collectionViewLanguages.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.changeDefaultLanguage(indexPath.row)
       self.collectionViewLanguages.reloadData()
      
   
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: collectionView.bounds.size.width/3-5, height: 45);
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //        return UIEdgeInsetsMake(15, 10, 10, 10)//top,left,bottom,right
        return UIEdgeInsetsMake(5, 5, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0//10
    }
    
    
}
struct CellInfo {
    var name : String  = ""
    var id : String = ""
    var isSelected  : Bool = false
}

//public extension UITextField {
//
//     private func getKeyboardLanguage() -> String? {
//             return "en" // here you can choose keyboard any way you need
//         }
//
//         override var textInputMode: UITextInputMode? {
//             if let language = getKeyboardLanguage() {
//                 for tim in UITextInputMode.activeInputModes {
//                     if tim.primaryLanguage!.contains(language) {
//                         return tim
//                     }
//                 }
//             }
//             return super.textInputMode
//         }
//
//   }
//

