//
//  CropDiagnosis_ViewController.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 26/12/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import UIKit
import CoreLocation
import  Alamofire

class CropDiagnosis_ViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource,LocationServiceDelegate {
    var cropsArray = NSArray()
    var cropsImagesArray = NSArray()
    let tempDiseasesMutArray = NSMutableArray()
    var diseasesMutArray = NSMutableArray()
    var uploadedArray = NSMutableArray()
    //MARK:- NEW CONTROLS
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var lbl_WeatherNameTemp: UILabel!
    @IBOutlet weak var lbl_Health: UILabel!
    @IBOutlet weak var lbl_Degrees: UILabel!
    @IBOutlet weak var lbl_SunriseDetails: UILabel!
    @IBOutlet weak var lbl_TempDescription: UILabel!
    @IBOutlet weak var view_HealthCheck: UIView!
    @IBOutlet weak var btn_HealthCheck: UIButton!
    
    @IBAction func Action_library(_ sender: Any) {
    }
    
    @IBOutlet weak var view_library: UIView!
    
    @IBOutlet weak var CDI_Tableview: UITableView!
    @IBOutlet weak var humudityImg: UIImageView!
    
     @IBOutlet weak var cv_Weather: UICollectionView!
    
    @IBOutlet weak var humidityLbl: UILabel!
    
      @IBOutlet weak var viewBorder: UIView!
     @IBOutlet weak var imgHealthCheck: UIImageView!
    @IBOutlet weak var imgLibraryBook: UIImageView!
    @IBOutlet weak var imgPlant: UIImageView!
      @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var healthCheckFlipButton: UIImageView!
    
    //WEather Outlets
    
    
    var todayWeatherRequest = "weather?lat=%@&lon=%@&APPID=%@"
    var forecastWeatherRequest = "forecast/daily?lat=%@&lon=%@&cnt=6&APPID=%@"
    let locationService : LocationService = LocationService()
    var featureDaysArray = NSMutableArray()
    var weatherJsonStr = ""
    @IBOutlet weak var temperatureImg: UIImageView!
    
    
    var weatherSeasonName : String = ""
    var weatherImageURL : String = ""
    var cityName : String = ""
    var weatherTemp  : String = ""
    var tempInDegrees : String = ""
    var isFromHome = false
    //Crops TableView
    var tvCropsList  =  UITableView()
    @IBOutlet weak var btnClose: UIButton!
    var alertView : UIView?
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
//        lbl_Health.isHidden = true
        
//        weatherView.dropViewShadow()
//        view_HealthCheck.dropViewShadow()
//        view_library.dropViewShadow()
        let userObj = Constatnts.getUserObject()
        
        cropsArray = (userObj.crop!).components(separatedBy: ",") as NSArray
        
        let shareButton = UIButton(frame: CGRect(x:UIScreen.main.bounds.size.width-42,y: 6,width: 40,height: 40))
        shareButton.backgroundColor =  UIColor.clear
        shareButton.setImage( UIImage(named: "Share"), for: UIControlState())
        shareButton.addTarget(self, action: #selector(CropDiagnosisPeetViwControllerOne.shareButtonClick(_:)), for: UIControlEvents.touchUpInside)
        //self.topView?.addSubview(shareButton)
        self.recordScreenView("CropDiagnosisPeetViwControllerOne", Crop_Diagnosis)
        self.registerFirebaseEvents(PV_Crop_Diagnosis_Home_Screen, "", "", "", parameters: nil)
//        let nib = UINib(nibName: "CDIDiseaseCell", bundle: nil)
//        self.CDI_Tableview.register(nib, forCellReuseIdentifier: "CDIDiseaseCell")
//        self.view_HealthCheck.animateBorderColor(toColor: UIColor.systemBlue, duration: 0.3)
        //LOAD PREVIOUSLY UPLOADED DATA Master
//        self.viewBorder.roundCorners(corners: [.topRight,.bottomRight], radius: 55)
//        self.imgHealthCheck.rotate()
        let nib = UINib(nibName: "DiseaseCell", bundle: nil)
        self.CDI_Tableview.register(nib, forCellReuseIdentifier: "diseaseCell")
        self.lblRewardAmount?.numberOfLines = 0
     // Load animated images
        
        var camImages: [UIImage] = [
               UIImage(named: "cam-gif_0000")!,
               UIImage(named: "cam-gif_0001")!,
               UIImage(named: "cam-gif_0002")!,
               UIImage(named: "cam-gif_0003")!,
               UIImage(named: "cam-gif_0004")!,
               UIImage(named: "cam-gif_0005")!,
               UIImage(named: "cam-gif_0006")!,
               UIImage(named: "cam-gif_0007")!,
               UIImage(named: "cam-gif_0008")!,
               UIImage(named: "cam-gif_0009")!,
               UIImage(named: "cam-gif_0010")!,
               UIImage(named: "cam-gif_0011")!,
               UIImage(named: "cam-gif_0012")!,
               UIImage(named: "cam-gif_0013")!,
               UIImage(named: "cam-gif_0014")!,
               UIImage(named: "cam-gif_0015")!,
           ]
           var bookImages: [UIImage] = [
               UIImage(named: "book-gif_0000")!,
               UIImage(named: "book-gif_0001")!,
               UIImage(named: "book-gif_0002")!,
               UIImage(named: "book-gif_0003")!,
               UIImage(named: "book-gif_0004")!,
               UIImage(named: "book-gif_0005")!,
               UIImage(named: "book-gif_0006")!,
               UIImage(named: "book-gif_0007")!,
               UIImage(named: "book-gif_0008")!,
               UIImage(named: "book-gif_0009")!,
               UIImage(named: "book-gif_0010")!,
               UIImage(named: "book-gif_0011")!,
               UIImage(named: "book-gif_0012")!,
               UIImage(named: "book-gif_0013")!,
               UIImage(named: "book-gif_0014")!,
               UIImage(named: "book-gif_0015")!,
           ]
           var plantImages: [UIImage] = [
            UIImage(named: "plant-new-2_0000")!,
            UIImage(named: "plant-new-2_0001")!,
            UIImage(named: "plant-new-2_0002")!,
            UIImage(named: "plant-new-2_0003")!,
            UIImage(named: "plant-new-2_0004")!,
            UIImage(named: "plant-new-2_0005")!,
            UIImage(named: "plant-new-2_0006")!,
            UIImage(named: "plant-new-2_0007")!,
            UIImage(named: "plant-new-2_0008")!,
            UIImage(named: "plant-new-2_0009")!,
            UIImage(named: "plant-new-2_0010")!,
            UIImage(named: "plant-new-2_0011")!,
            UIImage(named: "plant-new-2_0012")!,
            UIImage(named: "plant-new-2_0013")!,
            UIImage(named: "plant-new-2_0014")!,
            UIImage(named: "plant-new-2_0015")!,
            UIImage(named: "plant-new-2_0016")!,
            UIImage(named: "plant-new-2_0017")!,
            UIImage(named: "plant-new-2_0018")!,
            UIImage(named: "plant-new-2_0019")!,
            UIImage(named: "plant-new-2_0020")!,
            UIImage(named: "plant-new-2_0021")!,
            UIImage(named: "plant-new-2_0022")!,
            UIImage(named: "plant-new-2_0023")!,
            UIImage(named: "plant-new-2_0024")!,
            UIImage(named: "plant-new-2_0025")!,
            UIImage(named: "plant-new-2_0026")!,
            UIImage(named: "plant-new-2_0027")!,
            UIImage(named: "plant-new-2_0028")!,
            UIImage(named: "plant-new-2_0029")!,
           ]
                
        
        imgHealthCheck.image = UIImage.animatedImage(with: camImages, duration: 1)
        imgHealthCheck.animationRepeatCount = -1
        
        imgLibraryBook.image = UIImage.animatedImage(with: bookImages, duration: 1)
        imgLibraryBook.animationRepeatCount = -1

        imgPlant.image = UIImage.animatedImage(with: plantImages, duration: 2)
        imgPlant.animationRepeatCount = -1
        
        self.healthCheckFlipButton.image = UIImage.animatedImage(with: camImages, duration: 1)
        self.healthCheckFlipButton.animationRepeatCount = -1
      
        self.tvCropsList.delegate = self
        self.tvCropsList.dataSource = self
        
        let nib1 = UINib(nibName: "CropCell", bundle: nil)
    
        self.tvCropsList.register(nib1, forCellReuseIdentifier: "cropCell")
        
       
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
            
            "eventName": Home_cropDiagnostic,
            "className":"CropDiagnosis_ViewController",
            "moduleName":"cropDiagnostic",
            
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
        super.viewWillAppear(true)
        self.topView?.isHidden = false
        lblTitle?.text = NSLocalizedString("crop_diagnostic", comment: "")
        
        self.cv_Weather.isHidden = true
        if isFromHome == false {
            self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
        }

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        diseasesMutArray = appDelegate.getDiseasePrescriptionDetailsFromDB("DiseasePrescriptionsEntity")
        //print(diseasesMutArray)
//        self.refreshTodayWeatherData()
        self.loadLabelsData()
    }
    
    override func viewDidLayoutSubviews() {
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: self.CDI_Tableview.frame.origin.y+self.CDI_Tableview.contentSize.height+40)
    }
    
    //MARK:- GET WEATHER DETAILS
    func refreshTodayWeatherData(){
        if let prevLocation = CLLocationManager().location as CLLocation?{
            self.getCurrentDayWeatherReportServiceCall(String(format : "%f",prevLocation.coordinate.latitude), String(format : "%f",prevLocation.coordinate.longitude))
            self.getForecastDayWeatherReportServiceCall(String(format : "%f",prevLocation.coordinate.latitude), String(format : "%f",prevLocation.coordinate.longitude))
        }
        if (!CLLocationManager.locationServicesEnabled() || CLLocationManager.authorizationStatus() == .denied)
        {
            let alert : UIAlertController = UIAlertController(title: "Location access", message: "In order to be notified, please open this app's settings and enable location access", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url as URL)
                }
            }
            alert.addAction(openAction)
            self.present(alert, animated: true, completion: nil)
        }
        else{
            locationService.delegate = self
            locationService.locationManager?.requestLocation()
            guard let currentLocation = LocationService.sharedInstance.currentLocation?.coordinate else {
                return
            }
            self.getCurrentDayWeatherReportServiceCall(String(format : "%f",currentLocation.latitude), String(format : "%f",currentLocation.longitude))
            self.getForecastDayWeatherReportServiceCall(String(format : "%f",currentLocation.latitude), String(format : "%f",currentLocation.longitude))
        }
    }
    
    
    //MARK:- GET CUURENT TEMP AND WEATHER DETAILS
    func getCurrentDayWeatherReportServiceCall(_ latitude: String?, _ longitude:String?){
        SwiftLoader.show(animated: true)
        let currentDayTempUrl = String(format: "%@%@", Base_Url,String(format: todayWeatherRequest, latitude ?? 0.0, longitude ?? 0.0, APP_ID))
        Alamofire.request(currentDayTempUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            SwiftLoader.hide()
            //  print("Result:\(String(describing: response.result.value))")
            let responseDic = response.result.value as? NSDictionary
            if response.result.error == nil{
                let todayWeather = Weather(dict: responseDic!)
                let jsonData = try? JSONSerialization.data(withJSONObject: responseDic ?? [:], options: [])
                self.weatherJsonStr  = String(data: jsonData ?? Data(), encoding: .utf8) ?? ""
               // self.lbl_Degrees.text =  String(format: "%@°C", Constatnts.getTemparatureFromValue(tempDouble: todayWeather.maxTemparature))
                // let lblCurrentLocation  =  todayWeather.cityName as String!

            //    self.lbl_SunriseDetails.text = String(format: "%@ %@","Sunset",((todayWeather.sunriseTime)! * 1000).dateFromMilliseconds(format: "hh:mm a"))
                let lblCurrentDayHumidity = String(format: "%d%%", todayWeather.humidity!)
               // self.lbl_TempDescription.text = String(format: "%@ ",todayWeather.w_description as String? ?? "")//
              //  self.humidityLbl.text = lblCurrentDayHumidity

                let imageUrl = String(format: "%@%@.png", Weather_Image_Url,(todayWeather.w_icon)!)
                let date = Date()
                let monthStr = date.monthAsString()
                let dateStrr = date.dateAsString()
                let dateStr = String(format: "%@ %@" ,dateStrr,monthStr)
               // self.lbl_WeatherNameTemp.text = String(format: "%@, %@", todayWeather.cityName ?? "",dateStr                                                              )
//                self.weatherTemp = String(format: "%@ ",todayWeather.w_description as String? ?? "")
//                self.weatherImageURL = imageUrl
//                self.weatherSeasonName = lblCurrentDayHumidity
//                self.cityName = String(format: "%@", todayWeather.cityName ?? "")
//                self.temperatureImg.downloadImageFrom(link: imageUrl, contentMode: .scaleToFill)
                 self.cv_Weather.reloadData()
            }
        }
    }
    
    func getForecastDayWeatherReportServiceCall(_ latitude: String?, _ longitude:String?){
        SwiftLoader.show(animated: true)
        let currentDayTempUrl = String(format: "%@%@", Base_Url,String(format: forecastWeatherRequest, latitude ?? 0.0, longitude ?? 0.0, APP_ID))
        // print(currentDayTempUrl)
        Alamofire.request(currentDayTempUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            SwiftLoader.hide()
            // print("Result:\(String(describing: response.result.value))")
            let responseDic = response.result.value as? NSDictionary
            if response.result.error == nil{
                if let dayListArray = Validations.checkKeyNotAvailForArray(responseDic!, key: "list") as? NSArray{
                    if dayListArray.count > 1{
                        self.featureDaysArray.removeAllObjects()
                        if let todayWeatherDic = dayListArray.object(at: 0) as? NSDictionary{
                            let todayWeather = Weather(dict: todayWeatherDic)
//                            self.lbl_Degrees.text = String(format: "%@°C",Constatnts.getTemparatureFromValue(tempDouble: todayWeather.maxTemparature))
                            self.tempInDegrees = String(format: "%@°C",Constatnts.getTemparatureFromValue(tempDouble: todayWeather.maxTemparature))
                            self.lblRewardAmount?.text = String(format: "%@°C",Constatnts.getTemparatureFromValue(tempDouble: todayWeather.maxTemparature)) + "  " + self.cityName
                        }
                    }
                }
            }
            //self.loadLabelsData()
        }
    }
    
    func loadLabelsData(){
        //CDI_GET_FARMERPLOADED_DISEASE
        
        if uploadedArray.count>0{
            uploadedArray.removeAllObjects()
        }
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [CDI_BASE_URL,CDI_GET_FARMERPLOADED_DISEASE])
        let userObj = Constatnts.getUserObject()
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String,"userType": "Farmer"]
        
        Alamofire.request(urlString, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            //SKActivityIndicator.dismiss()
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    print(json)
                    if let responseStatusCode = (json as! NSDictionary).value(forKey: JAVA_STATUS_CODE_KEY) as? String{
                        if responseStatusCode == STATUS_CODE_200{
                            let respData = (json as? NSDictionary)?.value(forKey: "response") as? NSString ?? ""
                            let decryptedData  = Constatnts.decryptResult(StrJson: respData as String)
                            print("Response after decrypting data:\(decryptedData)")
                             self.refreshTodayWeatherData()
                            var array = decryptedData.object(forKey: "cropDiagnosisResponseDTO") as? NSArray ?? []
                            
                            for i in 0..<array.count{
                                let dic : PeetUploadedRecordsBO  = PeetUploadedRecordsBO(dict: array.object(at: i) as? NSDictionary ?? [:])
                                self.uploadedArray.add(dic)
                            }
                            if self.uploadedArray.count == 0{
                                self.viewBorder.isHidden = true
                                self.CDI_Tableview.isHidden = true
                            }else{
                                self.viewBorder.isHidden = false
                                self.CDI_Tableview.isHidden = false
                            }
                            
                            self.CDI_Tableview.reloadData()

                        }else if responseStatusCode == STATUS_CODE_601{
                            Constatnts.logOut()
                            if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                print(msg)
                            }
                        }
                        else {
                             self.refreshTodayWeatherData()
                            
                            if self.uploadedArray.count == 0{
                                self.viewBorder.isHidden = true
                                self.CDI_Tableview.isHidden = true
                            }else{
                                self.viewBorder.isHidden = false
                                self.CDI_Tableview.isHidden = false
                            }

                            //                                self.tblViewLibraryDetails.isHidden = true
                            //                                self.lblNoDataAvailable.isHidden = false
                        }
                    }
                    else {
                         self.refreshTodayWeatherData()
                        //                            self.tblViewLibraryDetails.isHidden = true
                        //                            self.lblNoDataAvailable.isHidden = false
                    }
                    
                }
                else {
                     self.refreshTodayWeatherData()
                    SwiftLoader.hide()
                    //                        self.tblViewLibraryDetails.isHidden = true
                    //                        self.lblNoDataAvailable.isHidden = false
                }
                
            }
            else {
                 self.refreshTodayWeatherData()
                SwiftLoader.hide()
                //                    self.tblViewLibraryDetails.isHidden = true
                //                    self.lblNoDataAvailable.isHidden = false
            }
            
        }
        
    }
    
    
    override func backButtonClick(_ sender: UIButton) {
        if isFromHome {
            self.navigationController?.popViewController(animated: true)
        }else{
            self.findHamburguerViewController()?.showMenuViewController()
        }
    }
    
    //MARK:- SHARE BUTTON CLICK
    @IBAction func shareButtonClick( _ sender: UIButton)
    {
        let urlPath = String(format: "%@=%@", Module,Crop_Diagnostic)
        let finalUrl = String(format: "%@%@", deepLinkBaseUrl,urlPath)
        let activityControl = Validations.showShareActivityController(viewController: self, fileUrl: URL(string: finalUrl)!, userName: "", message: "")
        self.present(activityControl, animated: true, completion: nil)
    }
   
    @IBAction func selectCropTypeToEnterLibrary(_ sender: Any) {
        if cropsArray.count > 1{
            let alertController = UIAlertController(title: "Select Crop", message: "", preferredStyle: .actionSheet)
            
            for index in (0..<cropsArray.count){
                let sendButton = UIAlertAction(title: cropsArray.object(at: index) as? String, style: .default, handler: { (action) -> Void in
                    self.gotoLibraryScreenOfSelectedCrop(selectedCropIndex: index)
                })
                alertController.addAction(sendButton)
            }
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
                print("Cancel button tapped")
            })
            alertController.addAction(cancelButton)
            self.navigationController!.present(alertController, animated: true, completion: nil)
        }
        else if cropsArray.count == 1{
            self.gotoLibraryScreenOfSelectedCrop(selectedCropIndex: 0)
        }
        else{
            self.showNormalAlert(title: "", message: "No crops available")
        }
    }
    
    func gotoLibraryScreenOfSelectedCrop(selectedCropIndex: Int){
        let cropNameStr = cropsArray.object(at: selectedCropIndex) as? NSString
        let pestPredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Pests",cropNameStr! as String)
        let pestFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: pestPredicate)
        
        let weedPredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Weeds",cropNameStr! as String)
        let weedFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: weedPredicate)
        
        let diseaseMutArray = NSMutableArray()
        let diseasePredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Disease",cropNameStr! as String)
        let diseaseFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: diseasePredicate)
        diseaseMutArray.addObjects(from: diseaseFilteredArr)
        let fungusPredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Fungal",cropNameStr! as String)
        let fungusFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: fungusPredicate)
        diseaseMutArray.addObjects(from: fungusFilteredArr)
        let bacterialPredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Bacterial",cropNameStr! as String)
        let bacterialFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: bacterialPredicate)
        diseaseMutArray.addObjects(from: bacterialFilteredArr)
        let viralPredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Viral",cropNameStr! as String)
        let viralFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: viralPredicate)
        diseaseMutArray.addObjects(from: viralFilteredArr)
        //print(diseaseMutArray)
        
        let nutritionalDeficiencyMutArray = NSMutableArray()
        let npkPredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","NPK",cropNameStr! as String)
        let npkFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: npkPredicate)
        nutritionalDeficiencyMutArray.addObjects(from: npkFilteredArr)
        let micronutrientsPredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Micronutrients",cropNameStr! as String)
        let micronutrientsFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: micronutrientsPredicate)
        nutritionalDeficiencyMutArray.addObjects(from: micronutrientsFilteredArr)
        
        let othersPredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Others",cropNameStr! as String)
        let othersFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: othersPredicate)
        
        self.tempDiseasesMutArray.removeAllObjects()
        let tempPestMutDict = NSMutableDictionary()
        tempPestMutDict.setValue("Pests", forKey: "title")
        tempPestMutDict.setValue(pestFilteredArr, forKey: "data")
        tempDiseasesMutArray.add(tempPestMutDict)
        
        let tempDiseaseMutDict = NSMutableDictionary()
        tempDiseaseMutDict.setValue("Disease", forKey: "title")
        tempDiseaseMutDict.setValue(diseaseMutArray, forKey: "data")
        tempDiseasesMutArray.add(tempDiseaseMutDict)
        
        let nutritionalDeficiencyMutDict = NSMutableDictionary()
        nutritionalDeficiencyMutDict.setValue("Nutritional Deficiency", forKey: "title")
        nutritionalDeficiencyMutDict.setValue(nutritionalDeficiencyMutArray, forKey: "data")
        tempDiseasesMutArray.add(nutritionalDeficiencyMutDict)
        
        let tempWeedMutDict = NSMutableDictionary()
        tempWeedMutDict.setValue("Weeds", forKey: "title")
        tempWeedMutDict.setValue(weedFilteredArr, forKey: "data")
        tempDiseasesMutArray.add(tempWeedMutDict)
        
        let othersMutDict = NSMutableDictionary()
        othersMutDict.setValue("Others", forKey: "title")
        othersMutDict.setValue(othersFilteredArr, forKey: "data")
        tempDiseasesMutArray.add(othersMutDict)
        
        //print(tempDiseasesMutArray)
        let userObj = Constatnts.getUserObject()
        let cropNameStr1 = cropsArray.object(at: selectedCropIndex) as? NSString
        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,CROP:cropNameStr1!]
        self.registerFirebaseEvents(CD_Crop_Library_Click, "", "", "", parameters: firebaseParams as NSDictionary)
        let toLibraryVC = self.storyboard?.instantiateViewController(withIdentifier: "LibraryViewController") as! LibraryViewController
        toLibraryVC.mutArrayToDisplay = self.tempDiseasesMutArray
        toLibraryVC.weatherJson = weatherJsonStr
        toLibraryVC.backBtnTitle = cropNameStr! as String
        self.navigationController?.pushViewController(toLibraryVC, animated: true)
        
    }
    
    @IBAction func Action_HealthCheck(_ sender: Any) {
//        let toCapturePhotoVC = self.storyboard?.instantiateViewController(withIdentifier: "CapturePhotoViewController") as! CapturePhotoViewController
//        toCapturePhotoVC.cropNameFromCropDiagnosisVC = ""
//        toCapturePhotoVC.weatherJson = weatherJsonStr
//        self.navigationController?.pushViewController(toCapturePhotoVC, animated: true)
        let toCapturePhotoVC = self.storyboard?.instantiateViewController(withIdentifier: "HealthCheckViewController") as!  HealthCheckViewController
            toCapturePhotoVC.cropNameFromCropDiagnosisVC = ""
            toCapturePhotoVC.weatherJson = weatherJsonStr
            toCapturePhotoVC.isCameraOrGaleery = false
            self.navigationController?.pushViewController(toCapturePhotoVC, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btn_library(_ sender: Any) {
//        if cropsArray.count > 1{
//            let alertController = UIAlertController(title: "Select Crop", message: "", preferredStyle: .actionSheet)
//            for index in (0..<cropsArray.count){
//                let sendButton = UIAlertAction(title: cropsArray.object(at: index) as? String, style: .default, handler: { (action) -> Void in
//                    self.gotoLibraryScreenOfSelectedCrop(selectedCropIndex: index)
//                })
//                let image1 = UIImage()
//               var image2 =  image1.imageWithSize(scaledToSize: CGSize(width: 30, height: 30))
//
//                let crop = cropsArray.object(at: index) as? String
//                if crop?.lowercased() == "rice" {
//                    image2 = UIImage(named: "cd_Rice")!
//                }else if crop?.lowercased() == "corn" {
//                    image2 = UIImage(named: "cd_Corn")!
//                }else if  crop?.lowercased() == "chilli" {
//                    image2 = UIImage(named: "cd_Chilli")!
//                }else if crop?.lowercased() == "soybean" {
//                    image2 = UIImage(named: "cd_Soya")!
//                }else if crop?.lowercased() == "cotton" {
//                    image2 = UIImage(named: "cd_Cotton")!
//                }
//
//                sendButton.setValue(image1.withRenderingMode(.alwaysOriginal), forKey: "image")
//                alertController.addAction(sendButton)
//
//            }
//
//            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
//                print("Cancel button tapped")
//            })
//
//
//            alertController.addAction(cancelButton)
//            self.navigationController!.present(alertController, animated: true, completion: nil)
//        }
//        else if cropsArray.count == 1{
//            self.gotoLibraryScreenOfSelectedCrop(selectedCropIndex: 0)
//        }
//        else{
//            self.showNormalAlert(title: "", message: "No crops available")
//        }
        
        if cropsArray.count > 1{
//             let alertView_Bg: UIView = UIView (frame: CGRect(x: 0,y: 0 ,width: frame.size.width,height: frame.size.height))
            self.alertView = CustomAlert.cropsListPopup(self, frame: self.view.frame, tvCrops: tvCropsList,tblHeight : CGFloat(self.cropsArray.count)*CGFloat(40.0)) as? UIView
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.window?.rootViewController?.view.addSubview( self.alertView!)
             self.tvCropsList.reloadData()
        } else if cropsArray.count == 1{
            self.gotoLibraryScreenOfSelectedCrop(selectedCropIndex: 0)
        }
        else{
            self.showNormalAlert(title: "", message: "No crops available")
        }
    }
    
    @objc func infoCloseButton() {
        if alertView != nil {
            self.alertView?.removeFromSuperview()
        }
    }
}

extension CropDiagnosis_ViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.CDI_Tableview {
        return uploadedArray.count
        }else {
            return self.cropsArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.CDI_Tableview {
            let cell = CDI_Tableview.dequeueReusableCell(withIdentifier: "diseaseCell", for: indexPath) as! DiseaseCell
            //        cell.bgImg.dropimagehadow()
            
            let dicObj : PeetUploadedRecordsBO = uploadedArray.object(at: indexPath.row) as! PeetUploadedRecordsBO
            
            let imageUrl = String(format: "%@", dicObj.imagePath ?? "")
            cell.img_diesease.downloadImageFrom(link: imageUrl, contentMode: .scaleToFill)
            cell.lbl_diseaseNAme.text = dicObj.diseaseName as String? ?? "" as String
            cell.lbl_DiseaseSubmittedDate.text = dicObj.diseaseDate as String? ?? "" as String
            cell.lbl_scientificName.text = dicObj.scientificNAme as String? ?? "" as String
            let strPercentrag = String(format : "%@%%",dicObj.probability as String? ?? "" as String)
            cell.setProgressView(strPercentrag)
            cell.btn_ImagesCount.setTitle(dicObj.diseaseTypeImageCount as String? ?? "" as String, for: .normal)
            let cropImgURL = String(format: "%@", dicObj.diseaseTypeImgUrl ?? "")
            cell.imgDisease.downloadImageFrom(link: cropImgURL, contentMode: .scaleAspectFit)
            
            return cell
        }
        else {
            let cropCell = tvCropsList.dequeueReusableCell(withIdentifier: "cropCell") as! CropCell
            cropCell.lblCrop.text = cropsArray.object(at: indexPath.row) as? String
            let crop = cropsArray.object(at: indexPath.row) as? String
            
            if crop?.lowercased() == "rice" {
                cropCell.imgCrop.image = UIImage(named: "cd_Rice")
            }else if crop?.lowercased() == "corn" {
                cropCell.imgCrop.image  = UIImage(named: "cd_Corn")
            }else if  crop?.lowercased() == "chilli" {
                cropCell.imgCrop.image  = UIImage(named: "cd_chilli")
            }else if crop?.lowercased() == "soybean" {
                cropCell.imgCrop.image  = UIImage(named: "cd_Soya")
            }else if crop?.lowercased() == "cotton" {
                cropCell.imgCrop.image  = UIImage(named: "cd_Cotton")
            }
            
            return cropCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == CDI_Tableview {
             return 135
        }else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == CDI_Tableview {
        tableView.deselectRow(at: indexPath, animated: true)
        let dicObj : PeetUploadedRecordsBO = uploadedArray.object(at: indexPath.row) as! PeetUploadedRecordsBO
        // GetDiseaseDetailsFromServer
        
        let toLibraryVC = self.storyboard?.instantiateViewController(withIdentifier: "LibraryDetailsViewController") as! LibraryDetailsViewController
        toLibraryVC.isFromDiagnosisScreen = true
        // toLibraryVC.weatherJson = weatherJsonStr
        toLibraryVC.diseaseId = dicObj.diseaseId as String? ?? "" as String
        toLibraryVC.diseaseRequestId = dicObj.diseaseRequestId as String? ?? "" as String
        self.navigationController?.pushViewController(toLibraryVC, animated: true)
        }else {
            self.alertView?.removeFromSuperview()
            self.gotoLibraryScreenOfSelectedCrop(selectedCropIndex: indexPath.row)
        }
    }
}


//MARK:- UICOLLECTIONVIEW DELEGATE SOURCE
//extension CropDiagnosis_ViewController{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//           if cropsArray.count > 1{
//               return CGSize(width: collectionView.bounds.size.width/2-15, height: collectionView.bounds.size.width/2-35)//150
//           }
//           return CGSize(width: collectionView.bounds.size.width-15, height: collectionView.bounds.size.width-60)//150
//       }
//
//       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//           return UIEdgeInsetsMake(10, 10, 10, 10)//top,left,bottom,right
//       }
//
//       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//           return 10
//       }
//
//       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//           return 10
//       }
//
//       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//           let toCapturePhotoVC = self.storyboard?.instantiateViewController(withIdentifier: "CapturePhotoViewController") as! CapturePhotoViewController
//           toCapturePhotoVC.cropNameFromCropDiagnosisVC = cropsArray.object(at: indexPath.row) as? NSString
//           self.navigationController?.pushViewController(toCapturePhotoVC, animated: true)
//       }
//
//}


extension CropDiagnosis_ViewController {
    //MARK: Location service delegate methods
    func tracingLocation(_ currentLocation: CLLocation) {
        self.getCurrentDayWeatherReportServiceCall(String(format : "%f",currentLocation.coordinate.latitude), String(format : "%f",currentLocation.coordinate.longitude))
        self.getForecastDayWeatherReportServiceCall(String(format : "%f",currentLocation.coordinate.latitude), String(format : "%f",currentLocation.coordinate.longitude))
        locationService.stopUpdatingLocation()
    }
    
    func tracingLocationDidFailWithError(_ error: NSError) {
    }
}
extension CropDiagnosis_ViewController : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as! WeatherCollectionViewCell
//        cell.lblWeatherTemp.text =  String(format: "%@°C", Constatnts.getTemparatureFromValue(tempDouble: todayWeather.maxTemparature))
                     // let lblCurrentLocation  =  todayWeather.cityName as String!
                     
//                     cell.lbl_SunriseDetails.text = String(format: "%@ %@","Sunset",((todayWeather.sunriseTime)! * 1000).dateFromMilliseconds(format: "hh:mm a"))
//                     let lblCurrentDayHumidity = String(format: "%d%%", todayWeather.humidity!)
//                     cell.lblWeatherTemp.text = String(format: "%@ ",todayWeather.w_description as String? ?? "")
//                     cell.lblSeason.text = lblCurrentDayHumidity
//
//                     let imageUrl = String(format: "%@%@.png", Weather_Image_Url,(todayWeather.w_icon)!)
//                     let date = Date()
//                     let monthStr = date.monthAsString()
//                     let dateStrr = date.dateAsString()
//                     let dateStr = String(format: "%@ %@" ,dateStrr,monthStr)
//                     cell.lblSubTitle.text = String(format: "%@, %@", todayWeather.cityName ?? "",dateStr                                                              )
//                     cell.imgWeather.downloadImageFrom(link: imageUrl, contentMode: .scaleToFill)
        let colorTop =  UIColor(red: 0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        let colorBottom = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)

      let gradientLayer = CAGradientLayer()
      gradientLayer.colors = [colorTop, colorBottom]
      gradientLayer.locations = [0.0, 1.0]
      gradientLayer.frame = self.view.bounds

        cell.viewBg.layer.insertSublayer(gradientLayer, at:0)
        cell.lblTempInDegrees.text = self.tempInDegrees
        cell.lblWeatherTemp.text    = self.cityName
        cell.lblSeason.text = self.weatherSeasonName
        cell.lblSubTitle.text = self.cityName
        cell.lblWeatherTemp.text =  self.weatherTemp
        cell.imgWeather.downloadImageFrom(link: self.weatherImageURL, contentMode: .scaleToFill)
        cell.btnWeatherReport.addTarget(self, action: #selector(weatherReportScreenNavigation(_:)), for: .touchUpInside)
        return cell
    }
    
   @objc func weatherReportScreenNavigation(_ sender : UIButton) {
        let toWeatherVC = self.storyboard?.instantiateViewController(withIdentifier: "WeatherReportViewController") as? WeatherReportViewController
    UserDefaults.standard.set(true, forKey: "isFromHome")
    UserDefaults.standard.synchronize()
    
    toWeatherVC?.isFromHome = true
        self.navigationController?.pushViewController(toWeatherVC!, animated: true)
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                  return CGSize(width: collectionView.frame.size.width , height: 145 )//150

          }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let toWeatherVC = self.storyboard?.instantiateViewController(withIdentifier: "WeatherReportViewController") as? WeatherReportViewController
        UserDefaults.standard.set(true, forKey: "isFromHome")
        UserDefaults.standard.synchronize()
        toWeatherVC?.isFromHome = true
        self.navigationController?.pushViewController(toWeatherVC!, animated: true)
    }
    
//     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//               return UIEdgeInsetsMake(10, 10, 10, 10)//top,left,bottom,right
//           }
    
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}


extension UIButton{
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 2
        rotation.isCumulative = true
        rotation.repeatCount = .infinity
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}
extension UIImage {

    func imageWithSize(scaledToSize newSize: CGSize) -> UIImage {
   
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 20, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

}
