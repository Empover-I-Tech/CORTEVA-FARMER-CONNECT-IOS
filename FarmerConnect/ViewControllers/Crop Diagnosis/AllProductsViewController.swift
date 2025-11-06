//
//  AllProductsViewController.swift
//  FarmerConnect
//
//  Created by Empover on 03/01/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher


class AllProductsViewController: BaseViewController {

    @IBOutlet weak var tblViewAllProducts: UITableView!
    
    @IBOutlet weak var lblNoDataAvailable: UILabel!
    
    var mutArrayToDisplayData = NSMutableArray()
     var cropDiagnosisDocumentsDirectory = NSString()
    var shareButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        cropDiagnosisDocumentsDirectory = appDelegate.getCropDiagnosisFolderPath() as NSString
        
        tblViewAllProducts.dataSource = self
        tblViewAllProducts.delegate = self
        tblViewAllProducts.separatorStyle = .none
        tblViewAllProducts.tableFooterView = UIView()
        
        self.shareButton = UIButton(frame: CGRect(x:UIScreen.main.bounds.size.width-42,y: 6,width: 40,height: 40))
        shareButton.backgroundColor =  UIColor.clear
        shareButton.setImage( UIImage(named: "Share"), for: UIControlState())
        shareButton.addTarget(self, action: #selector(AllProductsViewController.shareButtonClick(_:)), for: UIControlEvents.touchUpInside)
        self.topView?.addSubview(shareButton)
        
        lblNoDataAvailable.isHidden = true
        self.recordScreenView("AllProductsViewController", CD_Products)
        let userObj = Constatnts.getUserObject()
              let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "Crop Library Details"]
              self.registerFirebaseEvents(PV_CDI_Crop_All_Products, "", "", "", parameters: firebaseParams as NSDictionary)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 10.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.topView?.isHidden = false
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        self.lblTitle?.text = "All Products"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        mutArrayToDisplayData = appDelegate.getAgroProductsDetailsFromDB("AgroProductMasterEntity")
        //print(mutArrayToDisplayData)
        if mutArrayToDisplayData.count > 0 {
            lblNoDataAvailable.isHidden = true
            self.shareButton.isHidden = false
            
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
        let urlPath = String(format: "%@=%@", Module,CD_All_Products)
        let finalUrl = String(format: "%@%@", deepLinkBaseUrl,urlPath)
        let message = "Crop Diagnosis Products"
        let activityControl = Validations.showShareActivityController(viewController: self, fileUrl: URL(string: finalUrl)!, userName: "", message: message)
        let userObj = Constatnts.getUserObject()
        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "All Products" ]
        self.registerFirebaseEvents(CDI_All_Products_Share, "", "", "", parameters: firebaseParams as NSDictionary)
        self.present(activityControl, animated: true, completion: nil)
    }
    //MARK: checkDiseaseImageFileAvailable
    func checkDiseaseImageFileAvailable(imageURLStr: String) -> String{
        if Validations.validateUrl(urlString: imageURLStr as NSString) == false{
            let docPath = self.getDocumentPath(imageURLStr as NSString)
            let isFileExists = self.checkIfFileExists(atPath: docPath as String)
            if isFileExists == true {
                return docPath as String
            }
            else{
                if Reachability.isConnectedToNetwork() {
                    //let imgURL =  NSURL(string: imageURLStr)
                    self.downloadAssetAndStore(inDocumentsDirectory: imageURLStr as NSString)
                    return imageURLStr
                }
//                else{
//                    self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
//                }
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

extension AllProductsViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mutArrayToDisplayData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblViewAllProducts.dequeueReusableCell(withIdentifier: "AllProductsCell", for: indexPath)
        
        let allProductsCell = mutArrayToDisplayData.object(at: indexPath.row) as? AgroProductMaster
        let outerView = cell.contentView.viewWithTag(203)
        outerView?.layer.cornerRadius = 5.0
        outerView?.clipsToBounds = true
        outerView?.layer.borderWidth = 0.5
        outerView?.layer.borderColor = UIColor.lightGray.cgColor
        
        let cropImg = cell.viewWithTag(200) as! UIImageView
        //cropImg.image = UIImage(named:"image_placeholder.png")  //http://103.24.202.7:9090/CDI/
        //let imgPath = String(format: "%@%@", arguments: ["http://192.168.3.141:8080/CDI/",cropDiagnosisCell?.value(forKey: "imagePath") as! String])
        //let url = NSURL(string:(imgPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
        // NSLog("%@", url!)
        //cropImg.kf.setImage(with: url! as? Resource , placeholder: UIImage(named:"image_placeholder.png"), options:nil , progressBlock: nil, completionHandler: nil)
       // cropImg.downloadedFrom(url: url! as URL, placeHolder: UIImage(named:"image_placeholder.png"))
        
        DispatchQueue.global().async {
            let cropImgURL = self.checkDiseaseImageFileAvailable(imageURLStr: (allProductsCell?.value(forKey: "productImage") as? String)!)
            DispatchQueue.main.async {
                if cropImgURL.hasPrefix("http") || cropImgURL.hasPrefix("https"){
                    //let imageUrl = URL(string: cropImgURL)
                    cropImg.kf.setImage(with: cropImgURL as? Resource , placeholder: UIImage(named:"image_placeholder.png"), options: nil, progressBlock: nil)
                }
                else{
                    cropImg.image = UIImage(contentsOfFile: cropImgURL as String)
                }
            }
        }
        
        let title = cell.viewWithTag(201) as! UILabel
        title.text = allProductsCell?.value(forKey: "productName") as? String
        let subTitle = cell.viewWithTag(202) as! UILabel
        subTitle.isHidden = true
        //subTitle.text = cropDiagnosisCell?.value(forKey: "diseaseScientificName") as? String
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
         let allProductsCell = mutArrayToDisplayData.object(at: indexPath.row) as? AgroProductMaster
        let toProductDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        toProductDetailsVC.idFromLibDetailsVC = (allProductsCell?.value(forKey: "id") as? NSString)!
        let userObj = Constatnts.getUserObject()
        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,PRODUCT_ID:(allProductsCell?.value(forKey: "id") as? NSString)!,PRODUCT_NAME:allProductsCell!.productName!] as [String : Any]
            
        self.registerFirebaseEvents(PV_CDI_Recommended_Products, "", "", "", parameters: firebaseParams as NSDictionary)
        self.navigationController?.pushViewController(toProductDetailsVC, animated: true)
    }
}
