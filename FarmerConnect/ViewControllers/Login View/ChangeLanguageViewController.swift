//
//  ChangeLanguageViewController.swift
//  FarmerConnect
//
//  Created by Apple on 27/11/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import UIKit
import Alamofire

class ChangeLanguageViewController: BaseViewController {
    //circle-selected
    //circle-unselected
    
    @IBOutlet weak var tblViewLanguages: UITableView!
     @IBOutlet weak var btnDone: UIButton!
    var arrLanguages = [String]()
    var alertView = UIView()
    var selectedLanguage = ""
    var selectedLanguageCode = ""
    var selectedLanguageID = ""
    var isFromHome : Bool = false
    var arrLanguageCodes = [String]()
    var languagesListMutArray = NSMutableArray()
    var filteredArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let language  = UserDefaults.standard.value(forKey: "selectedLanguage") as? String
        // Do any additional setup after loading the view.
        
        self.requestToGetLanguagesData()
        /*arrLanguages = ["English","हिन्दी","తెలుగు","தமிழ்","ਪੰਜਾਬੀ"]
         arrLanguageCodes = ["en","hi","te","ta","pa"]*/
    }
    
    func requestToGetLanguagesData(){
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,LOGIN_GET_LANGUAGES_LIST])
        let parameters = ["countryId": 5] as NSDictionary
        let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
        let params =  ["data" : paramsStr]
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        
                        let languagesListArray = decryptData.value(forKey: "languageList") as! NSArray
                        self.languagesListMutArray.removeAllObjects()
                        for i in 0 ..< languagesListArray.count{
                            let languageDict = languagesListArray.object(at: i) as? NSDictionary
                            let langData = Language(dict: languageDict!)
                            self.languagesListMutArray.add(langData)
                        }
                        
                        let predicate = NSPredicate(format: "languageCode == %@",self.selectedLanguageCode)
                        self.filteredArray = (languagesListArray).filtered(using: predicate) as NSArray
                        
                        DispatchQueue.main.async {
                            if self.selectedLanguageCode == "" || self.selectedLanguageCode == nil{
                                let predicate = NSPredicate(format: "languageId == %d",1)
                                let defaultLangArray = (languagesListArray).filtered(using: predicate) as NSArray
                                if let idObj = (self.filteredArray.object(at: 0) as! NSDictionary).value(forKey: "languageId") as? Int {
                                    self.selectedLanguageID = String(format: "%d",idObj) as String
                                }
                                if let codeObj = (self.filteredArray.object(at: 0) as! NSDictionary).value(forKey: "languageCode") as? String {
                                    self.selectedLanguageCode = String(format: "%d",codeObj) as String
                                }
                                if let nameObj = (self.filteredArray.object(at: 0) as! NSDictionary).value(forKey: "languageName") as? Int {
                                    self.selectedLanguage = String(format: "%d",nameObj) as String
                                }
                                
                                //set default language to Appdelegate and userdefaults
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.selectedLanguage =  self.selectedLanguageCode
                                appDelegate.selectedLanguageName = self.selectedLanguage
                                appDelegate.selectedlanguageID = self.selectedLanguageID
                                
                                UserDefaults.standard.set([appDelegate.selectedLanguage], forKey: "AppleLanguages")
                                UserDefaults.standard.synchronize()
                                UserDefaults.standard.set(appDelegate.selectedLanguage , forKey: "selectedLanguage")
                                UserDefaults.standard.synchronize()
                                Bundle.setLanguage(appDelegate.selectedLanguage)
                                
                            }
                            self.tblViewLanguages.separatorColor = .clear
                            self.tblViewLanguages.reloadData()
                        }
                    }
                }
            }
            else{
                self.view.makeToast((response.error?.localizedDescription)!)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        selectedLanguageCode = appDelegate.selectedLanguage
        
        self.lblTitle?.text = Dashboard.CHANGE_LANGUAGE.rawValue
        
        if isFromHome == true{
            self.backButton?.setImage(UIImage(named:"Back"), for: .normal)
        }else{
            self.backButton?.setImage(UIImage(named:"Menu"), for: .normal)
        }
        self.tblViewLanguages.separatorColor = .clear
        self.tblViewLanguages.reloadData()
    }
    
    @IBAction func changeToSelectedLanguage(_ sender: Any) {
        self.showPopUpToSelectLanguage()
    }
    
    override func backButtonClick(_ sender: UIButton) {
        if isFromHome == true{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.findHamburguerViewController()?.showMenuViewController()
        }
    }
    @objc @IBAction func selectLanagugage(_ sender : UIButton){
        sender.setImage(UIImage(named: "circle-selected"), for: .normal)
        self.changeDefaultLanguage(sender.tag)
    }
    
    func changeDefaultLanguage(_ row : Int){
        
        let languageData = languagesListMutArray.object(at: row) as? Language
        if let languageName = languageData?.value(forKey: "languageName") as? String{
            self.selectedLanguage = languageName
        }
        if let languageCode = languageData?.value(forKey: "languageCode") as? String{
            self.selectedLanguageCode = languageCode
        }
        if let languageId = languageData?.value(forKey: "languageId") as? String{
            self.selectedLanguageID = languageId
        }
        if languageData?.languageCode == "en"{
            self.btnDone.setTitle("Done", for: .normal)
        }else if languageData?.languageCode == "hi"{
            self.btnDone.setTitle("पूर्ण", for: .normal)
        }else if languageData?.languageCode == "te"{
            self.btnDone.setTitle("చేయబడింది", for: .normal)
        }else if languageData?.languageCode == "ta"{
            self.btnDone.setTitle("முடிந்தது", for: .normal)
        }else if languageData?.languageCode == "pa"{
            self.btnDone.setTitle("ਹੋ ਗਿਆ", for: .normal)
        }else if languageData?.languageCode == "kn"{
            self.btnDone.setTitle("Done", for: .normal)
        }else if languageData?.languageCode == "bn"{
            self.btnDone.setTitle("Done", for: .normal)
        }else if languageData?.languageCode == "or"{
            self.btnDone.setTitle("Done", for: .normal)
        }
        
        
        
     /*   if arrLanguages[row] == "English" {
            //            message = "Do you want to set English language?"
            //            yes = "YES"
            //            no = "NO"
            //            header = "Alert!"
            selectedLanguageCode = "en"
            selectedLanguage = "English"
            self.btnDone.setTitle("Done", for: .normal)
        }else if arrLanguages[row] == "हिन्दी" {
            //            message = "क्या आप हिंदी भाषा सेट करना चाहते हैं?"
            //            yes = "हाँ"
            //            no = "नहीं"
            //            header = "चेतावनी!"
            selectedLanguageCode = "hi"
            selectedLanguage = "हिन्दी"
            self.btnDone.setTitle("पूर्ण", for: .normal)
            
        }
        else if arrLanguages[row] == "ਪੰਜਾਬੀ" {
            //            message = "ਕੀ ਤੁਸੀਂ ਪੰਜਾਬੀ ਭਾਸ਼ਾ ਸੈਟ ਕਰਨਾ ਚਾਹੁੰਦੇ ਹੋ?"
            //            yes = "ਹਾਂ"
            //            no = "ਨਹੀਂ"
            //            header = "ਚੇਤਾਵਨੀ!"
            selectedLanguageCode = "pa"
            selectedLanguage = "ਪੰਜਾਬੀ"
            self.btnDone.setTitle("ਹੋ ਗਿਆ", for: .normal)
        }
        else if arrLanguages[row] == "తెలుగు" {
            //            message = "మీరు తెలుగు భాషను సెట్ చేయాలనుకుంటున్నారా?"
            //            yes = "అవును"
            //            no = "కాదు"
            //            header = "హెచ్చరిక!"
            selectedLanguageCode = "te"
            selectedLanguage = "తెలుగు"
            self.btnDone.setTitle("చేయబడింది", for: .normal)
            
        }
        else if arrLanguages[row] == "தமிழ்" {
            //            message = "நீங்கள் ஆங்கில மொழியை அமைக்க விரும்புகிறீர்களா?"
            //            yes = "ஆம்"
            //            no = "இல்லை"
            //            header = "எச்சரிக்கை!"
            selectedLanguageCode = "ta"
            selectedLanguage = "தமிழ்"
            self.btnDone.setTitle("முடிந்தது", for: .normal)
        }*/

    }
    
    func showPopUpToSelectLanguage(){
        var message = ""
        var yes = ""
        var no = ""
        var header = ""
        
        if selectedLanguageCode == "en"{
            message = "Do you want to set English language?"
            yes = "YES"
            no = "NO"
            header = "Alert!"
            selectedLanguageCode = "en"
            selectedLanguage = "English"
            
            
        }else if selectedLanguageCode == "hi" {
            message = "क्या आप हिंदी भाषा सेट करना चाहते हैं?"
            yes = "हाँ"
            no = "नहीं"
            header = "चेतावनी!"
            selectedLanguageCode = "hi"
            selectedLanguage = "हिन्दी"
            
        }
        else if selectedLanguageCode == "pa" {
            message = "ਕੀ ਤੁਸੀਂ ਪੰਜਾਬੀ ਭਾਸ਼ਾ ਸੈਟ ਕਰਨਾ ਚਾਹੁੰਦੇ ਹੋ?"
            yes = "ਹਾਂ"
            no = "ਨਹੀਂ"
            header = "ਚੇਤਾਵਨੀ!"
            selectedLanguageCode = "pa"
            selectedLanguage = "ਪੰਜਾਬੀ"
            
        }
        else if selectedLanguageCode == "te" {
            message = "మీరు తెలుగు భాషను సెట్ చేయాలనుకుంటున్నారా?"
            yes = "అవును"
            no = "కాదు"
            header = "హెచ్చరిక!"
            selectedLanguageCode = "te"
            selectedLanguage = "తెలుగు"
            

        }
        else if selectedLanguageCode == "ta" {
            message = "நீங்கள் ஆங்கில மொழியை அமைக்க விரும்புகிறீர்களா?"
            yes = "ஆம்"
            no = "இல்லை"
            header = "எச்சரிக்கை!"
            selectedLanguageCode = "ta"
            selectedLanguage = "தமிழ்"
           
        }
        else if selectedLanguageCode == "kn"{
            message = "ನೀವು ಕನ್ನಡ ಭಾಷೆಯನ್ನು ಹೊಂದಿಸಲು ಬಯಸುವಿರಾ?"
            yes = "ಹೌದು"
            no = "ಇಲ್ಲ"
            header = "ಎಚ್ಚರಿಕೆ !"
        }
        else if selectedLanguageCode == "bn"{
            message = "আপনি কি বাংলা ভাষা সেট করতে চান?"
            yes = "হ্যাঁ"
            no = "না."
            header = "সতর্কতা!"
        }
        else if selectedLanguageCode == "or"{
            message = "ଆପଣ ଓଡ଼ିଆ ଭାଷା ସେଟ କରିବା ପାଇଁ ଚାହୁଁ ଛନ୍ତି କୀ?"
            yes = "ହଁ"
            no = "ନାଁ"
            header = "ସୂଚନା"
        }
        
        self.alertView = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: header as NSString, message: message as NSString, okButtonTitle: yes, cancelButtonTitle: no) as! UIView
        self.view.addSubview(self.alertView)

    }
    
    func changeAppLanguageWithRequested(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.selectedLanguage =  selectedLanguageCode
        appDelegate.selectedlanguageID = self.selectedLanguageID
        appDelegate.selectedLanguageName = self.selectedLanguage
        
        UserDefaults.standard.set([appDelegate.selectedLanguage], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(appDelegate.selectedLanguage , forKey: "selectedLanguage")
        UserDefaults.standard.synchronize()
        
        // Update the language by swaping bundle
        Bundle.setLanguage(appDelegate.selectedLanguage)
        
        // Done to reintantiate the storyboards instantly
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateInitialViewController()

      Bundle.swizzleLocalization()
//        self.alertView.removeFromSuperview()
//        sender.setImage(UIImage(named: "circle-selected"), for: .normal)
    }
    
    //MARK: alertYesBtnAction
    /**
     YES button action of the alertView which is displayed to the user
     
     when already logged in other device
     */
    @objc func alertYesBtnAction(){
        self.changeAppLanguageWithRequested()
    }
    
    //MARK: alertNoBtnAction
    /**
     NO button action of the alertView which is displayed to the user
     when already logged in other device
     */
    @objc func alertNoBtnAction(){
        self.alertView.removeFromSuperview()
    }
}

extension ChangeLanguageViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languagesListMutArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tblViewLanguages.dequeueReusableCell(withIdentifier: "changeLanguage", for: indexPath) as! ChangeLanguageTableViewCell
        let languageCell = languagesListMutArray.object(at: indexPath.row) as? Language
        cell.lblLanguageName.text = languageCell?.value(forKey: "languageName") as? String
        cell.btnSelectRunSelect.tag = indexPath.row
        cell.btnSelectRunSelect.addTarget(self, action: #selector(selectLanagugage(_:)), for: .touchUpInside)
 
        if selectedLanguageCode == languageCell?.value(forKey: "languageCode") as? String {
            cell.btnSelectRunSelect.setImage(UIImage(named: "circle-selected"), for: .normal)
            self.selectedLanguage = languageCell?.value(forKey: "languageName") as! String
            self.selectedLanguageCode = languageCell?.value(forKey: "languageCode") as! String
            self.selectedLanguageID = languageCell?.value(forKey: "languageId") as! String
        }else{
            cell.btnSelectRunSelect.setImage(UIImage(named: "circle-unselected"), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.changeDefaultLanguage(indexPath.row)
        self.tblViewLanguages.separatorColor = .clear
        tableView.reloadData()
        
    }
    
}
