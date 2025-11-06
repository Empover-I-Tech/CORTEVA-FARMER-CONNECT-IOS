//
//  LibraryDetailsViewController.swift
//  FarmerConnect
//
//  Created by Empover on 29/12/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

//protocol OptionalType {
//    associatedtype Wrapped
//    var optional: Wrapped? { get }
//}
//
//extension Optional: OptionalType {
//    var optional: Wrapped? { return self }
//}
//
//extension Sequence where Iterator.Element: OptionalType {
//    func removeNils() -> [Iterator.Element.Wrapped] {
//        return self.flatMap { $0.optional }
//    }
//}

class LibraryDetailsViewController: BaseViewController, CollapsibleTableViewHeaderDelegate,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var cropImgView: UIImageView!
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    
    @IBOutlet weak var lblHeaderSubTitle: UILabel!
    
    @IBOutlet weak var imgDiseaseType: UIImageView!
    
    @IBOutlet weak var lblDiseaseType: UILabel!
    
    @IBOutlet weak var imgHosts: UIImageView!
    
    @IBOutlet weak var lblHosts: UILabel!
    
    @IBOutlet weak var tblViewLibraryDetails: UITableView!
    
    @IBOutlet weak var lblNoDataAvailable: UILabel!
    
    @IBOutlet weak var imgDiseaseDetected : UIImageView!
    @IBOutlet weak var lblDiseaseDetected : UILabel!
    
    
    var diseasePrescriptionsObj : DiseasePrescriptions?
    
    var mutArrayToDisplay = NSMutableArray()
    
    var mutArrayToDisplayData = NSMutableArray()
    
    var mutArrayToDisplayRelatedProductsData = NSMutableArray()
    
    var diseaseId : String = ""
    var diseaseRequestId : String = "0"
    var diseaseName : String = ""
    var cropName : String = ""

    @IBOutlet weak var relatedProductsView: UIView!
    
    @IBOutlet weak var relatedProductsCollectionView: UICollectionView!
    
    var cropDiagnosisDocumentsDirectory = NSString()
    
    var isFromDiagnosisScreen : Bool = false
    
    var shareButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        cropDiagnosisDocumentsDirectory = appDelegate.getCropDiagnosisFolderPath() as NSString
        
        lblNoDataAvailable.isHidden = true
        
        tblViewLibraryDetails?.estimatedRowHeight = 30
        tblViewLibraryDetails?.rowHeight = UITableViewAutomaticDimension
        // tblViewLibraryDetails?.tableFooterView = UIView()
        tblViewLibraryDetails.separatorStyle = .none
        
        tblViewLibraryDetails.dataSource = self
        tblViewLibraryDetails.delegate = self
        
        relatedProductsCollectionView.dataSource = self
        relatedProductsCollectionView.delegate = self
        
        print(UIScreen.main.bounds.size.width)
        if self.isFromDeeplink == true {
            if let deeplinkTempParams = self.deeplinkParams as NSDictionary? {
                self.GetDiseaseDetailsFromServer()
                }
            }
        
        relatedProductsView.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LibraryDetailsViewController.cdImageViewTapped(_:)))
        tap.delegate = self
        cropImgView.isUserInteractionEnabled = true
        cropImgView.addGestureRecognizer(tap)
        
        self.recordScreenView("LibraryDetailsViewController", CD_Crop_Library_Details)
        
        let userObj = Constatnts.getUserObject()
              let firebaseParams1 = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "Crop Library", "Crop" : diseasePrescriptionsObj?.crop, "Disease_Name" : diseasePrescriptionsObj?.diseaseName]
              self.registerFirebaseEvents(CD_CL_Library_Disease_Details, "", "", "", parameters: firebaseParams1 as NSDictionary)
        
       
        var firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "Crop Library" ,DISEASE_NAME:diseasePrescriptionsObj?.diseaseName,CROP:diseasePrescriptionsObj?.crop]
        if isFromDiagnosisScreen {
            firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,DISEASE_NAME:self.diseaseName as NSString,CROP:cropName as NSString,Screen_Name_Param: "Crop Library" ] as [String : Optional<NSString>]
        }
        
             
              self.registerFirebaseEvents(CD_CL_Crop_Library_Disease, "", "", "", parameters: firebaseParams as NSDictionary)
        
        self.lblTitle?.frame = CGRect(x:65,y: 10,width: UIScreen.main.bounds.size.width-110,height: 35)
        self.shareButton = UIButton(frame: CGRect(x:UIScreen.main.bounds.size.width-42,y: 6,width: 40,height: 40))
        shareButton.backgroundColor =  UIColor.clear
        shareButton.setImage( UIImage(named: "Share"), for: UIControlState())
        shareButton.addTarget(self, action: #selector(LibraryDetailsViewController.shareButtonClick(_:)), for: UIControlEvents.touchUpInside)
        self.topView?.addSubview(shareButton)
        
        if isFromDiagnosisScreen{
            self.GetDiseaseDetailsFromServer()
        }else{
            self.loadLibraryDetailsFromDB()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if #available(iOS 10.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
//        }
        super.viewWillAppear(true)
        
        self.topView?.isHidden = false
        
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        lblTitle?.text = "Crop Diagnosis"
        self.cropImgView.contentMode = .scaleAspectFit
        // cropImgView.image = UIImage(named:"image_placeholder.png")
        //        let imgPath = String(format: "%@", arguments: [diseasePrescriptionsObj?.value(forKey: "diseaseImageFile") as! String])
        //        let url = NSURL(string:(imgPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
        //        cropImgView.downloadedFrom(url: url! as URL, placeHolder: UIImage(named:"image_placeholder.png"))
        
    }
    
    func GetDiseaseDetailsFromServer(){
        
        SwiftLoader.show(animated: true)
        
        let urlString:String = String(format: "%@%@", arguments: [CDI_BASE_URL,CDI_CROP_DIAGNOSIS_GETDISEASE_PRODUCT_DESC])
        let userObj = Constatnts.getUserObject()
        
        let parameters = ["diseaseId":diseaseId, "diseaseRequestId":diseaseRequestId] as NSDictionary
        print("\(parameters)")
        let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
        let params =  ["data" : paramsStr]
        
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            //SKActivityIndicator.dismiss()
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print(json)
                    if let responseStatusCode = (json as! NSDictionary).value(forKey: JAVA_STATUS_CODE_KEY) as? String{
                        if responseStatusCode == STATUS_CODE_200{
                            let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                           let decryptedData  = Constatnts.decryptResult(StrJson: respData as String)
//                            print("Response after decrypting data:\(decryptedData)")
                            self.validateKeysFromAPI(dictWithDiseaseDetails: decryptedData)
                        }else if responseStatusCode == STATUS_CODE_601{
                            Constatnts.logOut()
                            if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                print(msg)
                            }
                        }
                        else {
                            self.tblViewLibraryDetails.isHidden = true
                            self.lblNoDataAvailable.isHidden = false
                            self.shareButton.isHidden = true
//                            self.shareButton.imageView?.image =  self.shareButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
//                            self.shareButton.imageView?.image?.withTintColor(UIColor.white)
                            

                        }
                    }
                    else {
                        self.tblViewLibraryDetails.isHidden = true
                        self.lblNoDataAvailable.isHidden = false
                         self.shareButton.isHidden = true
                        
                        
                    }

                }
                else {
                     SwiftLoader.hide()
                    self.tblViewLibraryDetails.isHidden = true
                    self.lblNoDataAvailable.isHidden = false
                     self.shareButton.isHidden = true
                    
                }

            }
            else {
                 SwiftLoader.hide()
                self.tblViewLibraryDetails.isHidden = true
                self.lblNoDataAvailable.isHidden = false
                
            }

        }
        
    }
    
    func validateKeysFromAPI(dictWithDiseaseDetails : NSDictionary){
        
        self.tblViewLibraryDetails.isHidden = false
        lblNoDataAvailable.isHidden = true
        
        if dictWithDiseaseDetails != nil{
            let diseaseImgURL = dictWithDiseaseDetails.value(forKey: "diseaseImageFile") as! String

            let imageUrl = URL(string: diseaseImgURL as String? ?? "")
            self.cropImgView.kf.setImage(with: imageUrl , placeholder: UIImage(named:"image_placeholder.png"), options: nil, progressBlock: nil)
            
            lblHeaderTitle.text = dictWithDiseaseDetails.value(forKey: "diseaseName") as? String
            lblHeaderSubTitle.text = dictWithDiseaseDetails.value(forKey: "diseaseBiologicalName") as? String
            lblDiseaseType.text = dictWithDiseaseDetails.value(forKey: "diseaseType") as? String
            if dictWithDiseaseDetails.value(forKey: "recognized") as? String == "True"{
                self.imgDiseaseDetected.isHidden = false
                self.lblDiseaseDetected.isHidden = false
            }else {
                self.imgDiseaseDetected.isHidden = true
                self.lblDiseaseDetected.isHidden = true
                
            }
            imgDiseaseType.image = UIImage(named:"DiseaseType")
            lblHosts.text =  String(format:"Hosts : %@",(dictWithDiseaseDetails.value(forKey: "hosts") as? String)!)
            imgHosts.image = UIImage(named:"Host")
            
            let cropNameStr = dictWithDiseaseDetails.value(forKey: "crop") as? String
            
            let navBarTitle = String(format:"%@-%@-%@",cropNameStr!,lblDiseaseType.text!,lblHeaderTitle.text!)
            lblTitle?.text = navBarTitle
            
            mutArrayToDisplayData.removeAllObjects()
            if dictWithDiseaseDetails["inANutshell"] != nil {
                
                if Validations.isNullString(dictWithDiseaseDetails.value(forKey: "inANutshell") as! NSString) == false{
                    let textStr = (dictWithDiseaseDetails.value(forKey: "inANutshell") as? String)?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "")
                    // list = list.filter { $0 != nil }
                    // let nutShellArray = textStr?.components(separatedBy: ".").flatMap({ $0 })
                    let arr = (textStr?.components(separatedBy: "."))!
                    // let arr = nutShellArray.removeNils()
                    let nutShellMutArray = NSMutableArray()
                    for index in (0..<arr.count){
                        if Validations.isNullString(arr[index] as NSString) == false{
                            nutShellMutArray.add(arr[index])
                        }
                    }
                    
                    let inANutShellSection = Section(name: "In a NutShell", items: nutShellMutArray as NSArray)
                    mutArrayToDisplayData.add(inANutShellSection)
                }
            }
            if dictWithDiseaseDetails["hazadDescription"] != nil {
                if Validations.isNullString(dictWithDiseaseDetails.value(forKey: "hazadDescription") as! NSString) == false{
                    let textStr = dictWithDiseaseDetails.value(forKey: "hazadDescription") as? String
                    let hazardDescArray = [textStr]
                    let hazardSection = Section(name: "Hazard Description", items: hazardDescArray as NSArray)
                    mutArrayToDisplayData.add(hazardSection)
                }
            }
            if dictWithDiseaseDetails["symptoms"] != nil {
                
                if Validations.isNullString(dictWithDiseaseDetails.value(forKey: "symptoms") as! NSString) == false{
                    let textStr = dictWithDiseaseDetails.value(forKey: "symptoms") as? String
                    let symptomsDescArray = [textStr]
                    let symptomsSection = Section(name: "Symptoms", items: symptomsDescArray as NSArray)
                    mutArrayToDisplayData.add(symptomsSection)
                }
            }
            if dictWithDiseaseDetails["trigger"] != nil {
                
                if Validations.isNullString(dictWithDiseaseDetails.value(forKey: "trigger") as! NSString) == false{
                    let textStr = dictWithDiseaseDetails.value(forKey: "trigger") as? String
                    let triggerDescArray = [textStr]
                    let triggerSection = Section(name: "Trigger", items: triggerDescArray as NSArray)
                    mutArrayToDisplayData.add(triggerSection)
                }
            }
            if dictWithDiseaseDetails["preventiveMeasures"] != nil {
                
                if Validations.isNullString(dictWithDiseaseDetails.value(forKey: "preventiveMeasures") as! NSString) == false{
                    let textStr = (dictWithDiseaseDetails.value(forKey: "preventiveMeasures") as? String)?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "")
                    let arr = (textStr?.components(separatedBy: "."))!
                    // let arr = nutShellArray.removeNils()
                    let preventiveMeasuresDescArray = NSMutableArray()
                    for index in (0..<arr.count){
                        if Validations.isNullString(arr[index] as NSString) == false{
                            preventiveMeasuresDescArray.add(arr[index])
                        }
                    }
                    let preventiveMeasuresSection = Section(name: "Preventive Measures", items: preventiveMeasuresDescArray as NSArray)
                    mutArrayToDisplayData.add(preventiveMeasuresSection)
                }
            }
            if dictWithDiseaseDetails["biologicalControl"] != nil {
                
                if Validations.isNullString(dictWithDiseaseDetails.value(forKey: "biologicalControl") as! NSString) == false{
                    let textStr = dictWithDiseaseDetails.value(forKey: "biologicalControl") as? String
                    let bioControlDescArray = [textStr]
                    let bioControlSection = Section(name: "Biological Control", items: bioControlDescArray as NSArray)
                    mutArrayToDisplayData.add(bioControlSection)
                }
            }
            if dictWithDiseaseDetails["chemicalControl"] != nil {
                
                if Validations.isNullString(dictWithDiseaseDetails.value(forKey: "chemicalControl") as! NSString) == false{
                    let textStr = dictWithDiseaseDetails.value(forKey: "chemicalControl") as? String
                    let chemicalControlDescArray = [textStr]
                    let chemicalControlSection = Section(name: "Chemical Control", items: chemicalControlDescArray as NSArray)
                    mutArrayToDisplayData.add(chemicalControlSection)
                }
            }
            //print(mutArrayToDisplayData)
            if dictWithDiseaseDetails["productMapping"] != nil {
                
                self.mutArrayToDisplayRelatedProductsData.removeAllObjects()
                if Validations.isNullString(dictWithDiseaseDetails.value(forKey: "productMapping") as! NSString) == false{
                    let textStr = dictWithDiseaseDetails.value(forKey: "productMapping") as? String
                    print("\(dictWithDiseaseDetails)")
                    let productMapping = textStr?.components(separatedBy: ",")
                    for i in (0..<(productMapping?.count)!){
                        let productImgStr = dictWithDiseaseDetails.value(forKey: "productMappingImage") as? String
                        let productMappingImg = productImgStr?.components(separatedBy: ",")
                        
                        let productMutDict = NSMutableDictionary()
                        productMutDict.setValue(productMapping?[i], forKey: "id")
                        productMutDict.setValue(productMappingImg?[i], forKey: "ProductImage")
                        self.mutArrayToDisplayRelatedProductsData.add(productMutDict)
                    }
                    //print(self.mutArrayToDisplayRelatedProductsData)
                    
                    if self.mutArrayToDisplayRelatedProductsData.count > 0 {
                        self.relatedProductsView.isHidden = false
                        DispatchQueue.main.async {
                            self.relatedProductsCollectionView.reloadData()
                        }
                    }
                    else{
                        self.relatedProductsView.isHidden = true
                    }
                }
                else{
                    relatedProductsView.isHidden = true
                }
               
            }
             self.tblViewLibraryDetails.reloadData()
        }
        else{
            self.tblViewLibraryDetails.isHidden = true
            lblNoDataAvailable.isHidden = false
        }
        
    }
    
    func loadLibraryDetailsFromDB(){
        if diseasePrescriptionsObj != nil{
            self.tblViewLibraryDetails.isHidden = false
            lblNoDataAvailable.isHidden = true
            let diseaseImgURL = self.checkDiseaseImageFileAvailable(imageURLStr: self.diseasePrescriptionsObj?.value(forKey: "diseaseImageFile") as! String)
            //print(diseaseImgURL)
            DispatchQueue.main.async {
                if diseaseImgURL?.hasPrefix("http") ?? false || diseaseImgURL?.hasPrefix("https") ?? false{
                    //let imageUrl = URL(string: cropImgURL)
                    self.cropImgView.kf.setImage(with: diseaseImgURL as? Resource , placeholder: UIImage(named:"image_placeholder.png"), options: nil, progressBlock: nil)
                }
                else{
                    self.cropImgView.image = UIImage(contentsOfFile: (diseaseImgURL)!)
                }
                //self.cropImgView.kf.setImage(with: diseaseImgURL as? Resource , placeholder: UIImage(named:"image_placeholder.png"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            lblHeaderTitle.text = diseasePrescriptionsObj?.value(forKey: "diseaseName") as? String
            lblHeaderSubTitle.text = diseasePrescriptionsObj?.value(forKey: "diseaseBiologicalName") as? String
            lblDiseaseType.text = diseasePrescriptionsObj?.value(forKey: "diseaseType") as? String
            imgDiseaseType.image = UIImage(named:"DiseaseType")
            lblHosts.text =  String(format:"Hosts : %@",(diseasePrescriptionsObj?.value(forKey: "hosts") as? String)!)
            imgHosts.image = UIImage(named:"Host")
            self.lblDiseaseDetected.isHidden = true
            self.imgDiseaseDetected.isHidden = true
            
            let cropNameStr = diseasePrescriptionsObj?.value(forKey: "crop") as? String
            
            let navBarTitle = String(format:"%@-%@-%@",cropNameStr!,lblDiseaseType.text!,lblHeaderTitle.text!)
            lblTitle?.text = navBarTitle
            
            mutArrayToDisplayData.removeAllObjects()
            
            if Validations.isNullString(diseasePrescriptionsObj?.value(forKey: "inANutshell") as! NSString) == false{
                let textStr = (diseasePrescriptionsObj?.value(forKey: "inANutshell") as? String)?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "")
                // list = list.filter { $0 != nil }
                // let nutShellArray = textStr?.components(separatedBy: ".").flatMap({ $0 })
                let arr = (textStr?.components(separatedBy: "."))!
                // let arr = nutShellArray.removeNils()
                let nutShellMutArray = NSMutableArray()
                for index in (0..<arr.count){
                    if Validations.isNullString(arr[index] as NSString) == false{
                        nutShellMutArray.add(arr[index])
                    }
                }
                
                let inANutShellSection = Section(name: "In a NutShell", items: nutShellMutArray as NSArray)
                mutArrayToDisplayData.add(inANutShellSection)
            }
            if Validations.isNullString(diseasePrescriptionsObj?.value(forKey: "hazadDescription") as! NSString) == false{
                let textStr = diseasePrescriptionsObj?.value(forKey: "hazadDescription") as? String
                let hazardDescArray = [textStr]
                let hazardSection = Section(name: "Hazard Description", items: hazardDescArray as NSArray)
                mutArrayToDisplayData.add(hazardSection)
            }
            if Validations.isNullString(diseasePrescriptionsObj?.value(forKey: "symptoms") as! NSString) == false{
                let textStr = diseasePrescriptionsObj?.value(forKey: "symptoms") as? String
                let symptomsDescArray = [textStr]
                let symptomsSection = Section(name: "Symptoms", items: symptomsDescArray as NSArray)
                mutArrayToDisplayData.add(symptomsSection)
            }
            if Validations.isNullString(diseasePrescriptionsObj?.value(forKey: "trigger") as! NSString) == false{
                let textStr = diseasePrescriptionsObj?.value(forKey: "trigger") as? String
                let triggerDescArray = [textStr]
                let triggerSection = Section(name: "Trigger", items: triggerDescArray as NSArray)
                mutArrayToDisplayData.add(triggerSection)
            }
            if Validations.isNullString(diseasePrescriptionsObj?.value(forKey: "preventiveMeasures") as! NSString) == false{
                let textStr = (diseasePrescriptionsObj?.value(forKey: "preventiveMeasures") as? String)?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "")
                let arr = (textStr?.components(separatedBy: "."))!
                // let arr = nutShellArray.removeNils()
                let preventiveMeasuresDescArray = NSMutableArray()
                for index in (0..<arr.count){
                    if Validations.isNullString(arr[index] as NSString) == false{
                        preventiveMeasuresDescArray.add(arr[index])
                    }
                }
                let preventiveMeasuresSection = Section(name: "Preventive Measures", items: preventiveMeasuresDescArray as NSArray)
                mutArrayToDisplayData.add(preventiveMeasuresSection)
            }
            if Validations.isNullString(diseasePrescriptionsObj?.value(forKey: "biologicalControl") as! NSString) == false{
                let textStr = diseasePrescriptionsObj?.value(forKey: "biologicalControl") as? String
                let bioControlDescArray = [textStr]
                let bioControlSection = Section(name: "Biological Control", items: bioControlDescArray as NSArray)
                mutArrayToDisplayData.add(bioControlSection)
            }
            if Validations.isNullString(diseasePrescriptionsObj?.value(forKey: "chemicalControl") as! NSString) == false{
                let textStr = diseasePrescriptionsObj?.value(forKey: "chemicalControl") as? String
                let chemicalControlDescArray = [textStr]
                let chemicalControlSection = Section(name: "Chemical Control", items: chemicalControlDescArray as NSArray)
                mutArrayToDisplayData.add(chemicalControlSection)
            }
            //print(mutArrayToDisplayData)
            
            self.mutArrayToDisplayRelatedProductsData.removeAllObjects()
            if Validations.isNullString(diseasePrescriptionsObj?.value(forKey: "productMapping") as! NSString) == false{
                let textStr = diseasePrescriptionsObj?.value(forKey: "productMapping") as? String
                let productMapping = textStr?.components(separatedBy: ",")
                for i in (0..<(productMapping?.count)!){
                    let productImgStr = diseasePrescriptionsObj?.value(forKey: "productMappingImage") as? String
                    let productMappingImg = productImgStr?.components(separatedBy: ",")
                    
                    let productMutDict = NSMutableDictionary()
                    productMutDict.setValue(productMapping?[i], forKey: "id")
                    productMutDict.setValue(productMappingImg?[i], forKey: "ProductImage")
                    self.mutArrayToDisplayRelatedProductsData.add(productMutDict)
                }
                //print(self.mutArrayToDisplayRelatedProductsData)
                
                if self.mutArrayToDisplayRelatedProductsData.count > 0 {
                    self.relatedProductsView.isHidden = false
                    DispatchQueue.main.async {
                        self.relatedProductsCollectionView.reloadData()
                    }
                }
                else{
                    self.relatedProductsView.isHidden = true
                }
            }
            else{
                relatedProductsView.isHidden = true
            }
        }
        else{
            self.tblViewLibraryDetails.isHidden = true
            lblNoDataAvailable.isHidden = false
        }
        
    }
    //MARK : backButtonClick
    override func backButtonClick(_ sender: UIButton) {
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.isClickedOnFABDetailsCloseBtn = false
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func shareButtonClick( _ sender: UIButton)
    {
        var diseaseID  = ""
        var diseaseName = ""
        if isFromDiagnosisScreen == true {
            diseaseID = diseaseId
            diseaseName = self.diseaseName
        }else {
            diseaseID = diseasePrescriptionsObj?.diseaseId as String? ?? ""
            diseaseName = diseasePrescriptionsObj?.diseaseName as String? ?? ""
        }
        let urlPath = String(format: "%@=%@&%@=%@", Module,Disease_Details,Disease_Id, diseaseID)
        let finalUrl = String(format: "%@%@", deepLinkBaseUrl,urlPath)
        let message = String(format: "Crop Diagnosis for  %@", diseaseName )
        let activityControl = Validations.showShareActivityController(viewController: self, fileUrl: URL(string: finalUrl)!, userName: "", message: message)
        self.present(activityControl, animated: true, completion: nil)
    }
    @objc func cdImageViewTapped(_ sender: UITapGestureRecognizer) {
        //print("tapped")
        let toCDImageVC = self.storyboard?.instantiateViewController(withIdentifier: "EquipmentImageViewController") as! EquipmentImageViewController
        toCDImageVC.equipImage = cropImgView.image
        self.navigationController?.present(toCDImageVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: checkDiseaseImageFileAvailable
    func checkDiseaseImageFileAvailable(imageURLStr: String) -> String?{
        if Validations.validateUrl(urlString: imageURLStr as NSString) == false{
            let docPath = self.getDocumentPath(imageURLStr as NSString)
            let isFileExists = self.checkIfFileExists(atPath: docPath as String)
            if isFileExists == true {
                return docPath as String
            }
            else{
                if Reachability.isConnectedToNetwork() {
                    //let imgURL =  NSURL(string: imageURLStr)
                    DispatchQueue.global().async {
                        self.downloadAssetAndStore(inDocumentsDirectory: imageURLStr as NSString)
                    }
                    return imageURLStr
                }
                else{
                    self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                }
            }
        }
        return imageURLStr
    }
    
    //MARK: getDocumentPath
    func getDocumentPath(_ assetStr: NSString) -> NSString {
        let assetArray = assetStr.components(separatedBy: "/") as NSArray
        let filePath = String(format: "%@/%@", cropDiagnosisDocumentsDirectory,assetArray.lastObject as! NSString) as NSString
        return filePath
    }
    
    //MARK: downloadAssetAndStore
    func downloadAssetAndStore(inDocumentsDirectory assetStr: NSString) {
        //SwiftLoader.show(animated: true)
        let docPath = self.getDocumentPath(assetStr)
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let url = NSURL(fileURLWithPath: docPath as String)
            return (url as URL, [.removePreviousFile])
        }
        Alamofire.download(assetStr as String, to: destination).response { response in
            if response.destinationURL != nil {
                //print(response.destinationURL!)
                print("disease image file saved when clicked")
            }
        }
    }
    
    //MARK: checkIfFileExists
    func checkIfFileExists(atPath strPath: String) -> Bool {
        let fileExists: Bool = FileManager.default.fileExists(atPath: strPath)
        return fileExists
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

extension LibraryDetailsViewController : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mutArrayToDisplayData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        header.backgroundColor = UIColor.clear
        let sectionData = mutArrayToDisplayData.object(at: section) as? Section
        header.titleLabel.frame = CGRect(x: 15, y: 8, width: UIScreen.main.bounds.size.width-100 , height: 30)
        header.arrowBtn.frame = CGRect(x: UIScreen.main.bounds.size.width-40, y: 11, width: 20 , height: 20)
        header.contentView.backgroundColor = UIColor.clear// (red: 190.0/255, green: 228.0/255, blue: 208.0/255, alpha: 0.7)
        header.seperatorViewTop.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width , height: 5)
        header.seperatorViewBottom.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width , height: 5)
        header.seperatorViewTop.backgroundColor = UIColor.clear// (red: 242.0/255, green: 242.0/255, blue: 242.0/255, alpha: 0.5)
        header.seperatorViewBottom.backgroundColor = UIColor.clear// (red: 242.0/255, green: 242.0/255, blue: 242.0/255, alpha: 0.5)
        header.titleLabel.text = sectionData?.name
        
         header.bgView.frame = CGRect(x: 4, y: 4, width: UIScreen.main.bounds.size.width - 10 , height: 36)
         header.bgView.backgroundColor = UIColor.white//(red: 237.0/255, green: 247.0/255, blue: 255.0/255, alpha: 0.7)
         header.bgView.dropViewShadow()
         header.bgView.layer.cornerRadius = 5.0
         header.bgView.layer.borderWidth = 0.5
        header.bgView.layer.borderColor = UIColor.clear.cgColor
        //header.titleLabel.font = UIFont (name: "Lato-Bold", size:15)
        header.setCollapsedCrop((sectionData?.collapsed)!)
        header.section = section
        header.delegate = self
        
        header.arrowBtn.rotate((sectionData?.collapsed)! ? -.pi : 0.0)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionData = mutArrayToDisplayData.object(at: section) as? Section
        if sectionData?.collapsed == true{
            return 0
        }
        return (sectionData?.items.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42.0
    }
    
    //    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        return 50.0
    //    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier =  "NormalCell"
        
        let titleToCheck = (mutArrayToDisplayData.object(at: indexPath.section) as! Section).name
        
        if titleToCheck == "In a NutShell" || titleToCheck == "Preventive Measures"{
            cellIdentifier = "PMNutshellCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        if titleToCheck == "In a NutShell" || titleToCheck == "Preventive Measures"{
            
            let img = cell.viewWithTag(200) as? UIImageView
            let lblTitle = cell.viewWithTag(201) as? UILabel
            img?.image = UIImage(named:"Leaf")
            lblTitle?.text = ((mutArrayToDisplayData.object(at: indexPath.section) as! Section).items as NSArray).object(at: indexPath.row) as? String
            
            // let trimmedstr = str?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //            if let firstChar = trimmedstr?.characters.first {
            //                if [",", ".", "-"].contains(firstChar) {
            //                    let newstr = trimmedstr?.characters.dropFirst()
            //                    print(newstr)
            //                     lblTitle?.text = newstr
            //                }
            //                else{
            //                     lblTitle?.text = str
            //                }
            //            }
        }
        else{
            let lblTitle = cell.viewWithTag(100) as? UILabel
            lblTitle?.text = ((mutArrayToDisplayData.object(at: indexPath.section) as! Section).items as NSArray).object(at: 0) as? String
        }
        return cell
    }
    
    // MARK: - Section Header Delegate
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        var sectionData = mutArrayToDisplayData.object(at: section) as? Section
        let collapsed = sectionData?.collapsed
        sectionData?.collapsed = !(collapsed!)
        mutArrayToDisplayData.replaceObject(at: section, with: sectionData!)
        header.setCollapsedCrop(!(collapsed!))
        tblViewLibraryDetails.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
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

extension LibraryDetailsViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.mutArrayToDisplayRelatedProductsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier: String = "RelatedProductsCell"
        let cell: UICollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        let imgView = cell?.viewWithTag(100) as! UIImageView
        imgView.contentMode = .scaleAspectFit
        let buyRetailerBtn = cell?.viewWithTag(101) as! UIButton
      
        cell?.backgroundColor = .white
        cell?.backgroundView?.dropViewShadow()
     
        cell?.layer.cornerRadius = 5.0
        buyRetailerBtn.setTitle("buyFromRetailer".localized, for: .normal)
        buyRetailerBtn.addTarget(self, action: #selector(LibraryDetailsViewController.buyFromRetailerButtonClick(_:)), for: .touchUpInside)
        if isFromDiagnosisScreen{
            let productImageURL = ((self.mutArrayToDisplayRelatedProductsData.object(at: indexPath.row) as! NSDictionary).value(forKey: "ProductImage") as! String)

            let imageUrl = URL(string: productImageURL as String? ?? "")
            imgView.kf.setImage(with: imageUrl , placeholder: UIImage(named:"image_placeholder.png"), options: nil, progressBlock: nil)

        }else{
            let productImgURL = self.checkDiseaseImageFileAvailable(imageURLStr: (self.mutArrayToDisplayRelatedProductsData.object(at: indexPath.row) as! NSDictionary).value(forKey: "ProductImage") as! String)
            DispatchQueue.main.async {
                if productImgURL?.hasPrefix("http") ?? false || productImgURL?.hasPrefix("https") ?? false{
                    //let imageUrl = URL(string: cropImgURL)
                    imgView.kf.setImage(with: productImgURL as? Resource , placeholder: UIImage(named:"image_placeholder.png"), options: nil, progressBlock: nil)
                }
                else{
                    imgView.image = UIImage(contentsOfFile: (productImgURL)!)
                }
                //imgView.kf.setImage(with: productImgURL as? Resource , placeholder: UIImage(named:"image_placeholder.png"), options: nil, progressBlock: nil, completionHandler: nil)
            }

        }
       
        return cell!
    }
    @IBAction func buyFromRetailerButtonClick(_ sender: UIButton){
        let rewardsVC = self.storyboard?.instantiateViewController(withIdentifier: "NearByViewController") as? NearByViewController
        rewardsVC?.isFromHome = true
        self.navigationController?.pushViewController(rewardsVC!, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let toProductDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        let productId = ((self.mutArrayToDisplayRelatedProductsData.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as? NSString)!
        toProductDetailsVC.idFromLibDetailsVC = productId
        toProductDetailsVC.isFromCD_Screen = isFromDiagnosisScreen
        let userObj = Constatnts.getUserObject()
        var firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,DISEASE_NAME:diseasePrescriptionsObj?.diseaseName,CROP:diseasePrescriptionsObj?.crop,PRODUCT_ID:productId]
        if isFromDiagnosisScreen {
            firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,DISEASE_NAME:self.diseaseName as NSString,CROP:cropName as NSString,PRODUCT_ID:productId] as [String : Optional<NSString>]
        }
        self.registerFirebaseEvents(CD_CL_Related_Product_Details, "", "", "", parameters: firebaseParams as NSDictionary)
        if isFromDiagnosisScreen {
            if Reachability.isConnectedToNetwork(){
                self.navigationController?.pushViewController(toProductDetailsVC, animated: true)
            }
            else{
                self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
            }

        }else{
            self.navigationController?.pushViewController(toProductDetailsVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 5, 10, 10)//top,left,bottom,right
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
