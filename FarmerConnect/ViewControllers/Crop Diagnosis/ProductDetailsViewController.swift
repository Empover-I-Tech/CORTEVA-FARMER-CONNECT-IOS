//
//  ProductDetailsViewController.swift
//  FarmerConnect
//
//  Created by Empover on 02/01/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher


class ProductDetailsViewController: BaseViewController, CollapsibleTableViewHeaderDelegate,UIGestureRecognizerDelegate {

    @IBOutlet weak var buyFromRetailerBtn: UIButton!
    @IBOutlet weak var tblViewProductDetails: UITableView!
    
 
    @IBOutlet weak var lblNoDataAvailable: UILabel!
    
    var idFromLibDetailsVC = NSString()
    var isFromCD_Screen : Bool = false
    var productName : String?
    var mutArrayToDisplayData = NSMutableArray()
    
    var cropDiagnosisDocumentsDirectory = NSString()
    var dictWithDiseaseDetails = NSDictionary()
    
    var detailsObj: DiseasePrescriptions?
    var cellImg = UIImageView()
     var shareButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        cropDiagnosisDocumentsDirectory = appDelegate.getCropDiagnosisFolderPath() as NSString
        
        tblViewProductDetails?.estimatedRowHeight = 200
        tblViewProductDetails?.rowHeight = UITableViewAutomaticDimension
        tblViewProductDetails?.tableFooterView = UIView()
       // tblViewProductDetails.separatorStyle = .none
        
        tblViewProductDetails.dataSource = self
        tblViewProductDetails.delegate = self
        
        self.shareButton = UIButton(frame: CGRect(x:UIScreen.main.bounds.size.width-42,y: 6,width: 40,height: 40))
        shareButton.backgroundColor =  UIColor.clear
        shareButton.setImage( UIImage(named: "Share"), for: UIControlState())
        shareButton.addTarget(self, action: #selector(ProductDetailsViewController.shareButtonClick(_:)), for: UIControlEvents.touchUpInside)
        self.topView?.addSubview(shareButton)
        
        lblNoDataAvailable.isHidden = true
       
        if isFromCD_Screen == false{
            self.updateUI()
        }else{
            self.getProductDeftailsFromAPI()
        }
        
        self.recordScreenView("ProductDetailsViewController", CD_Products_Details)
        let userObj = Constatnts.getUserObject()
        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "Products Details", "Product_Id" : idFromLibDetailsVC,PRODUCT_NAME:productName ?? ""] as [String : Any]
        self.registerFirebaseEvents(PV_CDI_Product_Details, "", "", "", parameters: firebaseParams as NSDictionary)
    }
    @IBAction func buyFromRetailerBtnAction(_ sender: Any) {
        let rewardsVC = self.storyboard?.instantiateViewController(withIdentifier: "NearByViewController") as? NearByViewController
        rewardsVC?.isFromHome = true
        self.navigationController?.pushViewController(rewardsVC!, animated: true)
    }
    func getProductDeftailsFromAPI(){
     
        SwiftLoader.show(animated: true)
        
        let urlString:String = String(format: "%@%@", arguments: [CDI_BASE_URL,CDI_GETPRODUCTS_DESCRIPTION_BY_PRODUCTID])
        let userObj = Constatnts.getUserObject()
        
        let parameters = ["productId":idFromLibDetailsVC] as NSDictionary
        
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
                            self.dictWithDiseaseDetails  = Constatnts.decryptResult(StrJson: respData as String)
//                            print("Response after decrypting data:\(self.dictWithDiseaseDetails)")
                            self.validateKeysFromApiAndUpdateUI()
                        }else if responseStatusCode == STATUS_CODE_601{
                            Constatnts.logOut()
                            if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                print(msg)
                            }
                        }
                    }
                }
            }
        }

    }
    
    func validateKeysFromApiAndUpdateUI(){

           if dictWithDiseaseDetails.count > 0{
               lblNoDataAvailable.isHidden = true
            self.shareButton.isHidden = false

               self.lblTitle?.text = (dictWithDiseaseDetails.value(forKey: "productName") as! String)
               self.productName = dictWithDiseaseDetails.value(forKey: "productName") as! String ?? ""

               mutArrayToDisplayData.removeAllObjects()
               //let productImageAvailable = Validations.checkKeyNotAvail(detailsObj!, key: "productImage") as! String
               if Validations.isNullString(dictWithDiseaseDetails.value(forKey: "productImage") as! NSString) == false{
                   let textStr = dictWithDiseaseDetails.value(forKey: "productImage") as! String
                   let packagingDescArray = [textStr]
                   let packagingSection = Section(name: "Packaging", items: packagingDescArray as NSArray)
                   mutArrayToDisplayData.add(packagingSection)
                   
                   if(mutArrayToDisplayData.count>0){
                           var sectionData = mutArrayToDisplayData.object(at: 0) as? Section
                           let collapsed = true
                           sectionData?.collapsed = !(collapsed)
                           mutArrayToDisplayData.replaceObject(at: 0, with: sectionData!)
    
                   }
               }
               // let productCharacterAvailable = Validations.checkKeyNotAvail(detailsObj!, key: "character") as! String
               if Validations.isNullString(dictWithDiseaseDetails.value(forKey: "character") as! NSString) == false{
                   let textStr = dictWithDiseaseDetails.value(forKey: "character") as! String
                   let characterDescArray = [textStr]
                   let characterSection = Section(name: "Product Character", items: characterDescArray as NSArray)
                   mutArrayToDisplayData.add(characterSection)
               }
               if Validations.isNullString(dictWithDiseaseDetails.value(forKey: "work") as! NSString) == false{
                   let textStr = dictWithDiseaseDetails.value(forKey: "work") as! String
                   let workDescArray = [textStr]
                   let workSection = Section(name: "How this product works", items: workDescArray as NSArray)
                   mutArrayToDisplayData.add(workSection)
               }
               if Validations.isNullString(dictWithDiseaseDetails.value(forKey: "caution") as! NSString) == false{
                   let textStr = dictWithDiseaseDetails.value(forKey: "caution") as! String
                   let cautionDescArray = [textStr]
                   let cautionSection = Section(name: "Caution during usage", items: cautionDescArray as NSArray)
                   mutArrayToDisplayData.add(cautionSection)
               }
               if Validations.isNullString(dictWithDiseaseDetails.value(forKey: "resultAndEffect") as! NSString) == false{
                   let textStr = dictWithDiseaseDetails.value(forKey: "resultAndEffect") as! String
                   let resultAndEffectDescArray = [textStr]
                   let resultAndEffectSection = Section(name: "Result and effect", items: resultAndEffectDescArray as NSArray)
                   mutArrayToDisplayData.add(resultAndEffectSection)
               }
               if Validations.isNullString(dictWithDiseaseDetails.value(forKey: "cropAndDiseaseNamesForMobile") as! NSString) == false{
                   let textStr = dictWithDiseaseDetails.value(forKey: "cropAndDiseaseNamesForMobile") as! String
                   let relatedHazardsDescArray = textStr.components(separatedBy: ",")
                   let relatedHazardSection = Section(name: "Related Hazards", items: relatedHazardsDescArray as NSArray)
                   mutArrayToDisplayData.add(relatedHazardSection)
               }
               //print(mutArrayToDisplayData)

               self.tblViewProductDetails.reloadData()
           }
           else{
               lblNoDataAvailable.isHidden = false
             self.shareButton.isHidden = true
           }

       }
    
    //MARK : backButtonClick
    override func backButtonClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func shareButtonClick( _ sender: UIButton)
    {
        let urlPath = String(format: "%@=%@&%@=%@", Module,CD_Product_Details,Product_Id,idFromLibDetailsVC)
        let finalUrl = String(format: "%@%@", deepLinkBaseUrl,urlPath)
        let message = String(format: "Crop Diagnosis Product Details  %@", productName ?? "")
        let activityControl = Validations.showShareActivityController(viewController: self, fileUrl: URL(string: finalUrl)!, userName: "", message: message)
        let userObj = Constatnts.getUserObject()
        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,PRODUCT_ID:idFromLibDetailsVC,PRODUCT_NAME:productName ?? ""] as [String : Any]
        self.registerFirebaseEvents(CDI_Product_Details_Share, "", "", "", parameters: firebaseParams as NSDictionary)
        self.present(activityControl, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        buyFromRetailerBtn.setTitle("buyFromRetailer".localized, for: .normal)
        if #available(iOS 10.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.topView?.isHidden = false
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        self.lblTitle?.text = "Crop Diagnosis"
        //self.lblTitle?.text = "Crop Diagnosis"
    }
    
    //MARK : updateUI
    func updateUI(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let retrievedArrFromDB = appDelegate.getAgroProductsDetailsFromDB("AgroProductMasterEntity")
        //print(retrievedArrFromDB)
        
        let dbPredicate = NSPredicate(format: "id = %@",idFromLibDetailsVC)
        let outputFilteredArr = (retrievedArrFromDB).filtered(using: dbPredicate) as NSArray
        if outputFilteredArr.count > 0{
            lblNoDataAvailable.isHidden = true
             self.shareButton.isHidden = false
            let detailsObj = outputFilteredArr.object(at: 0) as? AgroProductMaster
            
            self.lblTitle?.text = detailsObj?.productName as String?
            self.productName = detailsObj?.productName as String? ?? ""
            mutArrayToDisplayData.removeAllObjects()
            //let productImageAvailable = Validations.checkKeyNotAvail(detailsObj!, key: "productImage") as! String
            if Validations.isNullString((detailsObj?.productImage)!) == false{
                let textStr = detailsObj?.value(forKey: "productImage") as! String?
                let packagingDescArray = [textStr]
                let packagingSection = Section(name: "Packaging", items: packagingDescArray as NSArray)
                mutArrayToDisplayData.add(packagingSection)
                if(mutArrayToDisplayData.count>0){
                                   var sectionData = mutArrayToDisplayData.object(at: 0) as? Section
                                   let collapsed = true
                                   sectionData?.collapsed = !(collapsed)
                                   mutArrayToDisplayData.replaceObject(at: 0, with: sectionData!)
                                   
                               }
                
            }
            // let productCharacterAvailable = Validations.checkKeyNotAvail(detailsObj!, key: "character") as! String
            if Validations.isNullString((detailsObj?.character)!) == false{
                let textStr = detailsObj?.value(forKey: "character") as! String?
                let characterDescArray = [textStr]
                let characterSection = Section(name: "Product Character", items: characterDescArray as NSArray)
                mutArrayToDisplayData.add(characterSection)
            }
            if Validations.isNullString((detailsObj?.work)!) == false{
                let textStr = detailsObj?.work as String?
                let workDescArray = [textStr]
                let workSection = Section(name: "How this product works", items: workDescArray as NSArray)
                mutArrayToDisplayData.add(workSection)
            }
            if Validations.isNullString((detailsObj?.caution)!) == false{
                let textStr = detailsObj?.caution as String?
                let cautionDescArray = [textStr]
                let cautionSection = Section(name: "Caution during usage", items: cautionDescArray as NSArray)
                mutArrayToDisplayData.add(cautionSection)
            }
            if Validations.isNullString((detailsObj?.resultAndEffect)!) == false{
                let textStr = detailsObj?.resultAndEffect as String?
                let resultAndEffectDescArray = [textStr]
                let resultAndEffectSection = Section(name: "Result and effect", items: resultAndEffectDescArray as NSArray)
                mutArrayToDisplayData.add(resultAndEffectSection)
            }
            if Validations.isNullString((detailsObj?.cropAndDiseaseNamesForMobile)!) == false{
                let textStr = detailsObj?.cropAndDiseaseNamesForMobile as String?
                let relatedHazardsDescArray = textStr?.components(separatedBy: ",")
                let relatedHazardSection = Section(name: "Related Hazards", items: relatedHazardsDescArray! as NSArray)
                mutArrayToDisplayData.add(relatedHazardSection)
            }
            //print(mutArrayToDisplayData)
        }
        else{
            lblNoDataAvailable.isHidden = false
             self.shareButton.isHidden = true
        }
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
                SwiftLoader.hide()
                //print(response.destinationURL!)
                //print("disease image file saved when clicked")
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

extension ProductDetailsViewController : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mutArrayToDisplayData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        header.backgroundColor = UIColor.white
        let sectionData = mutArrayToDisplayData.object(at: section) as? Section
        header.titleLabel.frame = CGRect(x: 8, y: 8, width: UIScreen.main.bounds.size.width-100 , height: 30)
        header.arrowBtn.frame = CGRect(x: UIScreen.main.bounds.size.width-40, y: 11, width: 20 , height: 20)
        header.contentView.backgroundColor = UIColor.clear// (red: 190.0/255, green: 228.0/255, blue: 208.0/255, alpha: 0.7)
        header.seperatorViewTop.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width , height: 5)
        header.seperatorViewBottom.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width , height: 5)
        header.seperatorViewTop.backgroundColor = UIColor .clear//(red: 245.0/255, green: 245.0/255, blue: 245.0/255, alpha: 1.0)
        header.seperatorViewBottom.backgroundColor = UIColor.clear// (red: 245.0/255, green: 245.0/255, blue: 245.0/255, alpha: 1.0)
        header.titleLabel.text = sectionData?.name
        
        header.bgView.frame = CGRect(x: 4, y: 3, width: UIScreen.main.bounds.size.width - 10 , height: 38)
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier =  "NormalCell"
        
        let titleToCheck = (mutArrayToDisplayData.object(at: indexPath.section) as! Section).name
        
        if titleToCheck == "Packaging"{
            cellIdentifier = "PackagingCell"
        }
         let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        if titleToCheck == "Packaging"{
            self.cellImg = (cell.viewWithTag(101) as? UIImageView)!
            self.cellImg.contentMode = .scaleAspectFit
            //img?.image = UIImage(named:"image_placeholder.png")
         
            if isFromCD_Screen{
                let productImageURL = ((self.mutArrayToDisplayData.object(at: indexPath.section) as! Section).items as NSArray).object(at: 0) as? String
                let imageUrl = URL(string: productImageURL as String? ?? "")

                self.cellImg.kf.setImage(with:imageUrl, placeholder: UIImage(named:"image_placeholder.png"), options: nil, progressBlock: nil)
            }
            else{
                let diseaseImgURL = self.checkDiseaseImageFileAvailable(imageURLStr: (((self.mutArrayToDisplayData.object(at: indexPath.section) as! Section).items as NSArray).object(at: 0) as? String)!)
                DispatchQueue.main.async {
                    if diseaseImgURL?.hasPrefix("http") ?? false || diseaseImgURL?.hasPrefix("https") ?? false{
                        //let imageUrl = URL(string: cropImgURL)
                        self.cellImg.kf.setImage(with: diseaseImgURL as? Resource , placeholder: UIImage(named:"image_placeholder.png"), options: nil, progressBlock: nil)
                    }
                    else{
                        self.cellImg.image = UIImage(contentsOfFile: (diseaseImgURL)!)
                    }
                }
            }
            let tap = UITapGestureRecognizer(target: self, action: #selector(ProductDetailsViewController.productImageViewTapped(_:)))
            tap.delegate = self
            cellImg.isUserInteractionEnabled = true
            cellImg.addGestureRecognizer(tap)
        }
        else {
            let lblTitle = cell.viewWithTag(100) as? UILabel
            lblTitle?.text = ((mutArrayToDisplayData.object(at: indexPath.section) as! Section).items as NSArray).object(at: indexPath.row) as? String
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let titleToCheck = (mutArrayToDisplayData.object(at: indexPath.section) as! Section).name
        if titleToCheck == "Related Hazards"{
            return 40.0
        }
        else{
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let titleToCheck = (mutArrayToDisplayData.object(at: indexPath.section) as! Section).name
        if titleToCheck == "Related Hazards"{
            let str = (((mutArrayToDisplayData.object(at: indexPath.section) as! Section).items as NSArray).object(at: indexPath.row) as? String)?.components(separatedBy: "-")
            let diseaseTypeStr = str![1].trimmingCharacters(in: .whitespacesAndNewlines)
            let cropNameStr = str![0].trimmingCharacters(in: .whitespacesAndNewlines)
            let diseaseNameStr = str![2].trimmingCharacters(in: .whitespacesAndNewlines)
            var diseaseId = ""
            if isFromCD_Screen{
                let diseaseIdArr = (dictWithDiseaseDetails.value(forKey: "diseaseId") as! String).components(separatedBy: ",")
                diseaseId = diseaseIdArr[indexPath.row]
                
            }
            
            let diseasePrescriptionObj = self.retrieveDiseaseDataFromDB(diseaseType: diseaseTypeStr, cropName: cropNameStr, diseaseName: diseaseNameStr)
            let toLibraryDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "LibraryDetailsViewController") as! LibraryDetailsViewController
            toLibraryDetailsVC.diseasePrescriptionsObj = diseasePrescriptionObj
            toLibraryDetailsVC.isFromDiagnosisScreen = isFromCD_Screen
            toLibraryDetailsVC.diseaseId = diseaseId
          
            if isFromCD_Screen {
                if Reachability.isConnectedToNetwork(){
                    self.navigationController?.pushViewController(toLibraryDetailsVC, animated: true)
                }
                else{
                    self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                }
            }else{
                self.navigationController?.pushViewController(toLibraryDetailsVC, animated: true)

            }
        }
    }
    @objc func productImageViewTapped(_ sender: UITapGestureRecognizer) {
        //print("tapped")
        let toCDImageVC = self.storyboard?.instantiateViewController(withIdentifier: "EquipmentImageViewController") as! EquipmentImageViewController
        toCDImageVC.equipImage = self.cellImg.image
        self.navigationController?.present(toCDImageVC, animated: true, completion: nil)
    }
    //MARK: retrieveDiseaseDataFromDB
    func retrieveDiseaseDataFromDB(diseaseType:String, cropName:String, diseaseName:String) -> DiseasePrescriptions?{
        detailsObj = nil
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let retrievedArrFromDB = appDelegate.getDiseasePrescriptionDetailsFromDB("DiseasePrescriptionsEntity")
        //print(retrievedArrFromDB)
        
        let dbPredicate = NSPredicate(format: "diseaseType = %@ AND crop = %@ AND diseaseName = %@",diseaseType,cropName,diseaseName)
        let outputFilteredArr = (retrievedArrFromDB).filtered(using: dbPredicate) as NSArray
        
        if outputFilteredArr.count > 0{
             detailsObj = outputFilteredArr.object(at: 0) as? DiseasePrescriptions
        }
        return detailsObj
    } 
    
    // MARK: - Section Header Delegate
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        var sectionData = mutArrayToDisplayData.object(at: section) as? Section
        let collapsed = sectionData?.collapsed
        sectionData?.collapsed = !(collapsed!)
        mutArrayToDisplayData.replaceObject(at: section, with: sectionData!)
        header.setCollapsedCrop(!(collapsed!))
        tblViewProductDetails.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
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
