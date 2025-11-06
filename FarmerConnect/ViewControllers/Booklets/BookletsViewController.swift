//
//  BookletsViewController.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 30/04/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import QuickLook


class BookletsViewController: BaseViewController,QLPreviewControllerDataSource {
    
    @IBOutlet weak var tblBooklets : UITableView!
    var arrBookletsList = NSMutableArray()
    var index : Int = 0
    var fileNames = [String]()
    lazy var previewItem = NSURL()
    var fileURLs = [URL]()
    var urlString : String = ""
    var isFromShare : Bool = false
    var isFromHome : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            
            let userObj = Constatnts.getUserObject()
            let defaults = UserDefaults.standard
            var lastUpdatedDate = ""
            if defaults.value(forKey: "lastUpdatedOn") != nil{
                lastUpdatedDate = defaults.value(forKey: "lastUpdatedOn") as! String
            }
            let parameters : Parameters = ["mobileNumber":userObj.mobileNumber! as String,"customerId":userObj.customerId! as String ,"appName": AppName ,"lastUpdatedOn":lastUpdatedDate ]
            
            let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
            let params =  ["data" : paramsStr]
            self.recordScreenView("BookNowViewController", FSR_Place_Order)
            let fireBaseParams = [MOBILE_NUMBER: userObj.mobileNumber!,USER_ID: userObj.customerId]
            self.registerFirebaseEvents(PV_Pravakta_Booklet, "", "", "", parameters: fireBaseParams as NSDictionary)
            self.requestToGetBooklets(paramas: params)
            
        }else {
            let appdele = UIApplication.shared.delegate as? AppDelegate
            let arrBooklets =   appdele?.getBookletDetailsFromDB("BookletDetails")
            self.arrBookletsList.removeAllObjects()
            for index in 0..<arrBooklets!.count{
                let bookletsDic = arrBooklets?.object(at: index) as? BookletInfo
                self.arrBookletsList.add(bookletsDic!)
                
            }
            
            
            self.tblBooklets.reloadData()
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
            
            "eventName": Home_PravaktaBooklets,
            "className":"HomeViewController",
            "moduleName": "PravaktaBooklets",
            
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
        self.topView?.isHidden = false
        self.homeButton?.isHidden = true
        self.lblTitle?.text = NSLocalizedString("my_booklets", comment: "")
        
        if isFromHome {
            self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        }else{
            self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
        }
    }
    
    override func backButtonClick(_ sender: UIButton) {
        if isFromHome {
            self.navigationController?.popViewController(animated: true)
        }else{
            self.findHamburguerViewController()?.showMenuViewController()
        }
    }
    
    //MARK: requestToGetEquipmentDetails
    func requestToGetBooklets (paramas : Parameters){
        SwiftLoader.show(animated: true)
        
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_BOOKLETS])
        
        let userObj = Constatnts.getUserObject()
        
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        print(headers)
        
        Alamofire.request(urlString, method: .post, parameters: paramas , encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print(response)
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let fireBaseParams = [MOBILE_NUMBER: userObj.mobileNumber!,USER_ID: userObj.customerId]
                                   self.registerFirebaseEvents(PV_Booklets_Request_Success, "", "", "", parameters: fireBaseParams as NSDictionary)
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        //print("Response after decrypting data:\(decryptData)")
                        if let bookletsArray = Validations.checkKeyNotAvailForArray(decryptData, key: "booklets") as? NSArray{
                            self.arrBookletsList.removeAllObjects()
                            var obj = [BookletInfo]()
                            for index in 0..<bookletsArray.count{
                                if let bookletsDic = bookletsArray.object(at: index) as? NSDictionary{
                                    let booklet = BookletInfo(dict: bookletsDic)
                                    let appdele = UIApplication.shared.delegate as? AppDelegate
                                    appdele?.saveBookletDetails(booklet)
                                    
                                    obj.append(booklet)
                                    
                                    
                                }
                            }
                            // Get sorted array in descending order (largest to the smallest number)
                            let sortedFriends = obj.sorted(by: {  $0.mediaServerRecordId! >  $1.mediaServerRecordId! })
                            print(sortedFriends)
                            for (_,x) in sortedFriends.enumerated() {
                                self.arrBookletsList.add(x)
                            }
                            self.tblBooklets.reloadData()
                        }
                    }
                    else if responseStatusCode == STATUS_CODE_500{
                        let fireBaseParams = [MOBILE_NUMBER: userObj.mobileNumber!,USER_ID: userObj.customerId]
                        self.registerFirebaseEvents(PV_Booklets_Something_went_wrong, "", "", "", parameters: fireBaseParams as NSDictionary)
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        //print("Response after decrypting data:\(decryptData)")
                        self.view.makeToast((json as! NSDictionary).value(forKey: "message") as! String)
                    }
                    else if responseStatusCode == STATUS_CODE_601{
                        Constatnts.logOut()
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    }
                    
                }
            }
        }
    }
    
    @IBAction func  btnShareClicked(_ sender : UIButton){
        let userObj = Constatnts.getUserObject()
        let fireBaseParams = [MOBILE_NUMBER: userObj.mobileNumber!,USER_ID: userObj.customerId]
        
            self.registerFirebaseEvents(PV_Booklets_Share, "", "", "", parameters: fireBaseParams as NSDictionary)
        let index = IndexPath(item: sender.tag, section: 0)
        let details = self.arrBookletsList[index.row] as? BookletInfo
        let details1 = details?.mediaType
        let urlPath = String(format: "%@=%@", Module,PravakthaBooklets)
        let finalUrl = String(format: "%@%@", deepLinkBaseUrl,urlPath)
        let bookletsShareStr = NSLocalizedString("I_have_found_booklets_which_are_very_infomatic",comment: "")
        let message = bookletsShareStr
        
        if details?.mediaType == "jpeg" || details?.mediaType == "jpg" ||  details?.mediaType == "png"{
            
            let cell = self.tblBooklets.cellForRow(at: index) as? BookletCell
            
            let imageShare = (cell?.imgBooklet?.image ?? UIImage(named: "PlaceHolderImage"))!
            let activityControl = Validations.showShareActivityController(viewController: self, fileUrl: URL(string: finalUrl)!, userName: "", message: message,imgUrl :imageShare)
            let userObj = Constatnts.getUserObject()
            //        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,CA_Category:self.selectedNotification!.categoryName!,STATE:self.selectedNotification!.stateName!,CROP:self.selectedNotification!.cropName!,HYBRID:self.selectedNotification!.hybridName ?? "",SEASON:self.selectedNotification!.seasonName!] as [String : Any]
            //        self.registerFirebaseEvents(CA_Share, "", "", "", parameters: firebaseParams as NSDictionary)
            self.present(activityControl, animated: true, completion: nil)
        }else {
         
            self.isFromShare = true
                          // Download file
                          self.urlString = details?.mediaUrl ?? ""
                          self.downloadfile(completion: {(success, fileLocationURL) in
                              
                              if success {
                                  // Set the preview item to display======
                                  self.previewItem = fileLocationURL! as NSURL
                                  let pdfFilePath = fileLocationURL
                                       let pdfData = NSData(contentsOf: pdfFilePath!)
                                       let activityVC = UIActivityViewController(activityItems: [pdfData! , message , "  ",finalUrl], applicationActivities: nil)
                                       self.present(activityVC, animated: true, completion: nil)
                           
                                  
                              }else{
                                  debugPrint("File can't be downloaded")
                              }
                          })
            
        }
        
    }
    
    @IBAction func displayLocalFile(_ sender: UIButton){
        
        let previewController = QLPreviewController()
        // Set the preview item to display
        self.previewItem = self.getPreviewItem(withName: "samplePDf.pdf")
        
        previewController.dataSource = self
        self.present(previewController, animated: true, completion: nil)
        
    }
    
    
    
    
    func getPreviewItem(withName name: String) -> NSURL{
        
        //  Code to diplay file from the app bundle
        let file = name.components(separatedBy: ".")
        let path = Bundle.main.path(forResource: file.first!, ofType: file.last!)
        let url = NSURL(fileURLWithPath: path!)
        
        return url
    }
    
    func downloadfile(completion: @escaping (_ success: Bool,_ fileLocation: URL?) -> Void){
        
        let itemUrl = URL(string: self.urlString)
        
        // then lets create your document folder url
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent("filename.pdf")
        
        // to check if it exists before downloading it
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            debugPrint("The file already exists at path")
            completion(true, destinationUrl)
            
            // if the file doesn't exist
        } else {
            
            // you can use NSURLSession.sharedSession to download the data asynchronously
            URLSession.shared.downloadTask(with: itemUrl!, completionHandler: { (location, response, error) -> Void in
                guard let tempLocation = location, error == nil else { return }
                do {
                    // after downloading your file you need to move it to your destination url
                    try FileManager.default.moveItem(at: tempLocation, to: destinationUrl)
                    print("File moved to documents folder")
                    completion(true, destinationUrl)
                    if self.isFromShare == true{
                    let urlPath = String(format: "%@=%@", Module,PravakthaBooklets)
                    let finalUrl = String(format: "%@%@", deepLinkBaseUrl,urlPath)
                    let message = String(format: "I have found booklets which are very informatic")
                    let pdfData = NSData(contentsOf: destinationUrl)
                    let activityVC = UIActivityViewController(activityItems: [pdfData! , message , "  ",finalUrl], applicationActivities: nil)
                    self.present(activityVC, animated: true, completion: nil)
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                    completion(false, nil)
                }
            }).resume()
        }
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        
        return self.previewItem as QLPreviewItem
    }
    
}






extension BookletsViewController : UITableViewDelegate , UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrBookletsList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookletCell", for: indexPath) as! BookletCell
        let bookletDetails = self.arrBookletsList[indexPath.row] as? BookletInfo
          if bookletDetails?.mediaType == "pdf"{
             cell.imgBooklet?.image = UIImage(named: "pdf")
          }else {
            if bookletDetails?.mediaUrl != ""{
                       let imgStr = bookletDetails?.mediaUrl
                       let url = URL(string:imgStr ?? "PlaceHolderImage")
                       cell.imgBooklet?.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceHolderImage"), options: SDWebImageOptions.refreshCached, completed: { (img, error, _,url) in
                           if error != nil {
                               cell.imgBooklet?.image = UIImage(named: "PlaceHolderImage")
                           }else {
                               cell.imgBooklet?.image = img
                           }
                       })
                       
                   }else {
                       cell.imgBooklet?.image = UIImage(named: "PlaceHolderImage")
                   }
        }
       
        
        cell.lblMediaName.text = bookletDetails?.mediaName
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd-MMM-yyyy"
        
        let date = dateFormatter.date(from: bookletDetails?.createdOn ?? "")!
        
        cell.lblUpdateDate.text = dateFormatterPrint.string(from: date) as String
        cell.btnShare.tag = indexPath.row
        cell.btnShare.addTarget(self, action: #selector(BookletsViewController.btnShareClicked(_:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            let bookletDetails = self.arrBookletsList[indexPath.row] as? BookletInfo
            if bookletDetails?.mediaType == "pdf"{
                 self.isFromShare = false
                // Download file
                self.urlString = bookletDetails?.mediaUrl ?? ""
                self.downloadfile(completion: {(success, fileLocationURL) in
                    
                    if success {
                        // Set the preview item to display======
                        self.previewItem = fileLocationURL! as NSURL
                        // Display file
                        let previewController = QLPreviewController()
                        previewController.dataSource = self
                        previewController.navigationItem.rightBarButtonItem = UIBarButtonItem()
                        
                        self.present(previewController, animated: true, completion: nil)
                    }else{
                        debugPrint("File can't be downloaded")
                    }
                })
            }else {
                let previewController = ImagePreviewController()
                previewController.imgStr = bookletDetails?.mediaUrl ?? ""
                self.present(previewController, animated: true, completion: nil)
            }
        }
        else {
            self.view.makeToast("Please check your internet connection")
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
var filePath: String {
    //manager lets you examine contents of a files and folders in your app.
    let manager = FileManager.default
    
    //returns an array of urls from our documentDirectory and we take the first
    let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
    //print("this is the url path in the document directory \(String(describing: url))")
    
    //creates a new path component and creates a new file called "Data" where we store our data array
    return(url!.appendingPathComponent("Data").path)
}
