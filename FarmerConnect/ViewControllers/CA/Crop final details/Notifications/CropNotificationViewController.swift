//
//  CropNotificationViewController.swift
//  FarmerConnect
//
//  Created by Empover on 08/01/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit
import Alamofire

open class CropNotificationViewController: BaseViewController {

    @IBOutlet weak var tblViewCropNotification: UITableView!
    
    @IBOutlet weak var lblNoDataAvailable: UILabel!
    
    var mutArrayToDisplay = NSMutableArray()
    
    var mutArrayCropAdvisoryStages = NSMutableArray()
    
    /// used to iterate through cropAdvisoryStagesArray while downloading the assets
    var currentIndex:Int = 0
    
    var cropAdvisoryDocumentsDirectory = NSString()
    
    /// used third party library AudioPlayer to play the audio files
    var audioPlayer : AudioPlayer?
    
    var isPlaying = false
    
    var selectedStageEnt : CropAdvisoryDetailCell?
    
    var currentIndexPath : NSIndexPath?
    
    override open  func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      //  let appDelegate = UIApplication.shared.delegate as! AppDelegate
        tblViewCropNotification.dataSource = self
        tblViewCropNotification.delegate = self
        tblViewCropNotification.tableFooterView = UIView()
        tblViewCropNotification.separatorStyle = .none
         cropAdvisoryDocumentsDirectory =  "" //appDelegate.getCropAdvisoryFolderPath() as NSString
        
        lblNoDataAvailable.isHidden = true
        self.recordScreenView("CropNotificationViewController", Crop_Advisory_Notifications_Screen)
        self.registerFirebaseEvents(PV_CA_Notifications_Screen, "", "", "", parameters: nil)
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
            
            "eventName": Home_CropAdvisoryNotifications,
            "className":"CropNotificationViewController",
            "moduleName":"CropAdvisory",
            
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
    
    //MARK: requestToGetCropNotifications
    func requestToGetCropNotifications(params : [String:String]){
        
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_CROP_NOTIFICATIONS])
        
//       let userObj = Constatnts.getUserObject()
        let userObj = Constatnts.getUserObject()
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        print(headers)
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
//                if let json = response.result.value {
//                    print(json)
//                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
//                    if responseStatusCode == STATUS_CODE_200{
//                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
//                        let decryptData  = Constants.decryptResult(StrJson: respData as String)
//                        //print("Response after decrypting data:\(decryptData)")
//
//                        if let messageDetailsArray = decryptData.value(forKey: "messageDetails") as? NSArray{
//                            if messageDetailsArray.count > 0 {
//                                self.lblNoDataAvailable.isHidden = true
//                                self.mutArrayToDisplay.removeAllObjects()
//
//                           //     let appDelegate = UIApplication.shared.delegate as? AppDelegate
//                                //appDelegate?.deleteCropAdvisoryDetails()
//                                for i in (0..<messageDetailsArray.count){
//                                    let notificationsDict = messageDetailsArray.object(at: i) as! NSDictionary
//                                    let notificationObj = CropAdvisoryNotifications(dict: notificationsDict)
//                                  //  appDelegate?.saveCropAdvisoryDetails(notificationObj)
//                                    //self.mutArrayToDisplay.add(notificationObj)
//                                }
//                                self.mutArrayToDisplay = (appDelegate?.getCropAdvisoryDetailsFromDB("CropAdvisoryDetails"))!
//                                //print(self.mutArrayToDisplay)
//                                self.mutArrayCropAdvisoryStages.removeAllObjects()
//                                for i in (0..<messageDetailsArray.count){
//                                    let notificationsDict = messageDetailsArray.object(at: i) as! NSDictionary
//                                    let messageListObj = (notificationsDict.value(forKey: "messageList") as! NSArray)
//
//                                    for index in (0..<messageListObj.count){
//                                        let dict = messageListObj.object(at: index) as! NSDictionary
//                                        let audioFileToChk = (Validations.checkKeyNotAvail(dict, key: "voiceFileURL") as?NSString)!
//                                        if Validations.isNullString(audioFileToChk) == false{
//                                            let voiceFile = dict.value(forKey: "voiceFileURL") as? String
//                                            self.mutArrayCropAdvisoryStages.add(voiceFile!)
//                                        }
//                                    }
//                                }
//                                print(self.mutArrayCropAdvisoryStages)
//
//                                DispatchQueue.global(qos: .background).async {
//                                    self.checkCropAdvisoryAssetsToBeDownloaded()
//                                    DispatchQueue.main.async {
//                                        self.tblViewCropNotification.reloadData()
//                                    }
//                                }
//                            }
//                            else{ //Crop Advisory Messages Not Available
//                                self.lblNoDataAvailable.isHidden = false
//                                if let msg = (json as! NSDictionary).value(forKey: "message") as? String{
//                                    self.lblNoDataAvailable.text = msg
//                                }
//                            }
//                        }
//                    }else if responseStatusCode == STATUS_CODE_105{
//                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
//                            self.view.makeToast(msg as String)
//                            self.navigationController?.popViewController(animated: true)
//                        }
//                    }
//                    else if responseStatusCode == STATUS_CODE_601{
//                         Constants.logOut()
//                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
//                            self.view.makeToast(msg as String)
//                        }
//                    }
//                }
            }
            else{
                self.view.makeToast((response.error?.localizedDescription)!)
            }
        }
    }
    
    override open  func viewWillAppear(_ animated: Bool) {
        if #available(iOS 10.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.topView?.isHidden = false
        self.homeButton?.isHidden = true
        self.lblTitle?.text = "Crop Advisory Notifications"
        self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
        
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            let userObj = Constatnts.getUserObject()
            let parameters = ["customerId":userObj.customerId! as String] as NSDictionary
            print(parameters)
            let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
            let params =  ["data" : paramsStr]
            self.requestToGetCropNotifications(params: params as [String:String])
        }
//        else{
//            //let appDelegate = UIApplication.shared.delegate as? AppDelegate
//            if let notifArrayObj = appDelegate?.getCropAdvisoryDetailsFromDB("CropAdvisoryDetails"){
//                if notifArrayObj.count > 0{
//                    self.lblNoDataAvailable.isHidden = true
//                    self.mutArrayToDisplay.removeAllObjects()
//                    self.mutArrayToDisplay = notifArrayObj
//                    DispatchQueue.main.async {
//                        self.tblViewCropNotification.reloadData()
//                    }
//                }
//                else{
//                    self.lblNoDataAvailable.isHidden = false
//                    self.lblNoDataAvailable.text = "Crop Advisory Messages Not Available"
//                }
//            }
//            else{
//                self.lblNoDataAvailable.isHidden = false
//                self.lblNoDataAvailable.text = "Crop Advisory Messages Not Available"
//            }
//        }
    }
    
    override func backButtonClick(_ sender: UIButton) {
        self.findHamburguerViewController()?.showMenuViewController()
    }
    
    //MARK: checkCropAdvisoryAssetsToBeDownloaded
    func checkCropAdvisoryAssetsToBeDownloaded(){
        if currentIndex < self.mutArrayCropAdvisoryStages.count {
            let assetStr = self.mutArrayCropAdvisoryStages.object(at: currentIndex)
            self.downloadAssetAndStore(inDocumentsDirectory: assetStr as! NSString)
            currentIndex+=1
            self.checkCropAdvisoryAssetsToBeDownloaded()
        }
    }
    
    //MARK: getDocumentPath
    /**
     get the CroAdvisoryAssets Folder path of Documents directory
     - Parameter assetStr: NSString
     - Returns: NSString
     */
    func getDocumentPath(_ assetStr: NSString) -> NSString {
        let assetArr = assetStr.components(separatedBy: "/") as NSArray
        let filePath = String(format: "%@/%@", cropAdvisoryDocumentsDirectory,assetArr.lastObject as! NSString) as NSString
        return filePath
    }
    
    //MARK: checkIfFileExists
    func checkIfFileExists(atPath strPath: String) -> Bool {
        let fileExists: Bool = FileManager.default.fileExists(atPath: strPath)
        return fileExists
    }
    
    //MARK: downloadAssetAndStore
    func downloadAssetAndStore(inDocumentsDirectory assetStr: NSString) {
        let docPath = self.getDocumentPath(assetStr)
        let isFileExists = self.checkIfFileExists(atPath: docPath as String)
        if isFileExists == false {
            print(assetStr)
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                let url = NSURL(fileURLWithPath: docPath as String)
                return (url as URL, [.removePreviousFile])
            }
            //let urlToDownload = String(format:"%@", dictDocument.value(forKey: "voiceFileName") as! String)
            //print("download started :\(urlToDownload)")
            Alamofire.download(assetStr as String, to: destination).response { response in
                if response.destinationURL != nil {
                    print(response.destinationURL!)
                }
                else{
                }
            }
        }
        else{
            print("asset available")
        }
    }

    override open func didReceiveMemoryWarning() {
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

extension CropNotificationViewController : UITableViewDataSource, UITableViewDelegate{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mutArrayToDisplay.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblViewCropNotification.dequeueReusableCell(withIdentifier: "CropNotificationCell", for: indexPath)
        let notificationsCell = self.mutArrayToDisplay.object(at: indexPath.row) as? CropAdvisoryNotifications
        
        let cropName = cell.viewWithTag(100) as! UILabel
        let hybridName = cell.viewWithTag(101) as! UILabel
        let seasonName = cell.viewWithTag(102) as! UILabel
        let sowingDate = cell.viewWithTag(103) as! UILabel
        let sentOn = cell.viewWithTag(104) as! UILabel?
        let notificationMsg = cell.viewWithTag(105) as! UILabel
        
        cropName.text = notificationsCell?.cropName as String?
        hybridName.text = notificationsCell?.hybridName as String?
        seasonName.text = notificationsCell?.seasonName as String?
        sowingDate.text = notificationsCell?.sowingDate as String?
        
        let msgArray = notificationsCell?.messageList?.object(at: 0) as! NSArray
        if let sentOnStr = (msgArray.object(at: 0) as! NSDictionary).value(forKey: "sentOn") as? NSString{
            let dateArr = sentOnStr.components(separatedBy: " ") as NSArray
            let dateObj2 = dateArr.object(at: 0)
            //print(dateObj2)
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd-MMM-yyyy"
            if Validations.isNullString(dateObj2 as! NSString) == false{
                let date: NSDate? = dateFormatterGet.date(from: dateObj2 as! String)! as NSDate
                //print(dateFormatterPrint.string(from: date! as Date))
                sentOn?.text = dateFormatterPrint.string(from: date! as Date)
            }
        }
        notificationMsg.text = ((msgArray.object(at: 0) as! NSDictionary).value(forKey: "message") as! String)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
         let notificationsCell = self.mutArrayToDisplay.object(at: indexPath.row) as? CropAdvisoryNotifications
         //let msgArray = notificationsCell?.messageList
        let title = String(format:"%@ - %@",(notificationsCell?.cropName)!,(notificationsCell?.hybridName)!)
        let toCropNotifDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "CropNotificationDetailsViewController") as! CropNotificationDetailsViewController
        //toCropNotifDetailsVC.arrayFromCropNotifVC = msgArray!
        toCropNotifDetailsVC.selectedNotification = notificationsCell
        toCropNotifDetailsVC.navBarTitleStr = title
        self.navigationController?.pushViewController(toCropNotifDetailsVC, animated: true)
    }
}
