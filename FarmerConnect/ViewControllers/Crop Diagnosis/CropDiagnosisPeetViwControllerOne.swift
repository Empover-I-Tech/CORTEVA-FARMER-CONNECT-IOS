//
//  CropDiagnosisPeetViwControllerOne.swift
//  FarmerConnect
//
//  Created by Apple on 05/12/19.
//  Copyright © 2019 ABC. All rights reserved.
//


import UIKit
import CoreLocation
import  Alamofire

class CropDiagnosisPeetViwControllerOne: BaseViewController,UITableViewDelegate,UITableViewDataSource,LocationServiceDelegate {
    
    
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
    
    @IBOutlet weak var humidityLbl: UILabel!
    //WEather Outlets
    
    
    var todayWeatherRequest = "weather?lat=%@&lon=%@&APPID=%@"
    var forecastWeatherRequest = "forecast/daily?lat=%@&lon=%@&cnt=6&APPID=%@"
    let locationService : LocationService = LocationService()
    var featureDaysArray = NSMutableArray()
    var weatherJsonStr = ""
    @IBOutlet weak var temperatureImg: UIImageView!
    
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_Health.isHidden = true
        
        weatherView.dropViewShadow()
        view_HealthCheck.dropViewShadow()
        view_library.dropViewShadow()
        let userObj = Constatnts.getUserObject()
        
        cropsArray = (userObj.crop!).components(separatedBy: ",") as NSArray
        
        let shareButton = UIButton(frame: CGRect(x:UIScreen.main.bounds.size.width-42,y: 6,width: 40,height: 40))
        shareButton.backgroundColor =  UIColor.clear
        shareButton.setImage( UIImage(named: "Share"), for: UIControlState())
        shareButton.addTarget(self, action: #selector(CropDiagnosisPeetViwControllerOne.shareButtonClick(_:)), for: UIControlEvents.touchUpInside)
        //self.topView?.addSubview(shareButton)
        self.recordScreenView("CropDiagnosisPeetViwControllerOne", Crop_Diagnosis)
        self.registerFirebaseEvents(PV_Crop_Diagnosis_Home_Screen, "", "", "", parameters: nil)
        self.view_HealthCheck.animateBorderColor(toColor: UIColor.systemBlue, duration: 0.3)
        //LOAD PREVIOUSLY UPLOADED DATA Master
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.topView?.isHidden = false
        lblTitle?.text = "Crop Diagnosis"
        self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        diseasesMutArray = appDelegate.getDiseasePrescriptionDetailsFromDB("DiseasePrescriptionsEntity")
        //print(diseasesMutArray)
        
        loadLabelsData()
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
                self.lbl_Degrees.text =  String(format: "%@°C", Constatnts.getTemparatureFromValue(tempDouble: todayWeather.maxTemparature))
                // let lblCurrentLocation  =  todayWeather.cityName as String!
                
                self.lbl_SunriseDetails.text = String(format: "%@ %@","Sunset",((todayWeather.sunriseTime)! * 1000).dateFromMilliseconds(format: "hh:mm a"))
                let lblCurrentDayHumidity = String(format: "%d%%", todayWeather.humidity!)
                self.lbl_TempDescription.text = String(format: "%@ ",todayWeather.w_description as String? ?? "")
                self.humidityLbl.text = lblCurrentDayHumidity
                
                let imageUrl = String(format: "%@%@.png", Weather_Image_Url,(todayWeather.w_icon)!)
                let date = Date()
                let monthStr = date.monthAsString()
                let dateStrr = date.dateAsString()
                let dateStr = String(format: "%@ %@" ,dateStrr,monthStr)
                self.lbl_WeatherNameTemp.text = String(format: "%@, %@", todayWeather.cityName ?? "",dateStr                                                              )
                self.temperatureImg.downloadImageFrom(link: imageUrl, contentMode: .scaleToFill)
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
                            self.lbl_Degrees.text = String(format: "%@°C",Constatnts.getTemparatureFromValue(tempDouble: todayWeather.maxTemparature))
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
                            self.CDI_Tableview.reloadData()
                            if self.uploadedArray.count>0{
                                self.lbl_Health.isHidden = false
                            }
                        }else if responseStatusCode == STATUS_CODE_601{
                            Constatnts.logOut()
                            if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                print(msg)
                            }
                        }
                        else {
                             self.refreshTodayWeatherData()
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
        self.findHamburguerViewController()?.showMenuViewController()
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
            let alertController = UIAlertController(title: "Select Crop", message: "", preferredStyle: .alert)
            
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
        let toCapturePhotoVC = self.storyboard?.instantiateViewController(withIdentifier: "CapturePhotoViewController") as! CapturePhotoViewController
        toCapturePhotoVC.cropNameFromCropDiagnosisVC = ""
        toCapturePhotoVC.weatherJson = weatherJsonStr
        self.navigationController?.pushViewController(toCapturePhotoVC, animated: true)
        
    }
    
    
   

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btn_library(_ sender: Any) {
        if cropsArray.count > 1{
            let alertController = UIAlertController(title: "Select Crop", message: "", preferredStyle: .alert)
            
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
}

extension CropDiagnosisPeetViwControllerOne{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uploadedArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CDI_Tableview.dequeueReusableCell(withIdentifier: "CDIDiseaseCell", for: indexPath) as! CDIDiseaseCell
        cell.bgImg.dropimagehadow()
        
        let dicObj : PeetUploadedRecordsBO = uploadedArray.object(at: indexPath.row) as! PeetUploadedRecordsBO
        
        let imageUrl = String(format: "%@", dicObj.imagePath ?? "")
        cell.img_diesease.downloadImageFrom(link: imageUrl, contentMode: .scaleToFill)
        cell.lbl_diseaseNAme.text = dicObj.diseaseName as String? ?? "" as String
        cell.lbl_DiseaseSubmittedDate.text = dicObj.diseaseDate as String? ?? "" as String
        cell.lbl_scientificName.text = dicObj.scientificNAme as String? ?? "" as String
        // cell.lbl_scientificName.text = dicObj.diseaseName ?? ""
        let strPercentrag = String(format : "%@%%",dicObj.probability as String? ?? "" as String)
        cell.btn_percentage.setTitle(strPercentrag, for: .normal)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dicObj : PeetUploadedRecordsBO = uploadedArray.object(at: indexPath.row) as! PeetUploadedRecordsBO
        // GetDiseaseDetailsFromServer
        
        let toLibraryVC = self.storyboard?.instantiateViewController(withIdentifier: "LibraryDetailsViewController") as! LibraryDetailsViewController
        toLibraryVC.isFromDiagnosisScreen = true
        // toLibraryVC.weatherJson = weatherJsonStr
        toLibraryVC.diseaseId = dicObj.diseaseId as String? ?? "" as String
        toLibraryVC.diseaseRequestId = dicObj.diseaseRequestId as String? ?? "" as String
        
        
        self.navigationController?.pushViewController(toLibraryVC, animated: true)
        
    }
    
    /*  func GetDiseaseDetailsFromServer(dicObj : PeetUploadedRecordsBO ){
     
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
     }
     else {
     self.tblViewLibraryDetails.isHidden = true
     self.lblNoDataAvailable.isHidden = false
     
     }
     }
     else {
     self.tblViewLibraryDetails.isHidden = true
     self.lblNoDataAvailable.isHidden = false
     
     }
     
     }
     else {
     SwiftLoader.hide()
     self.tblViewLibraryDetails.isHidden = true
     self.lblNoDataAvailable.isHidden = false
     
     }
     
     }
     else {
     SwiftLoader.hide()
     self.tblViewLibraryDetails.isHidden = true
     self.lblNoDataAvailable.isHidden = false
     
     }
     
     }*/
    
}


//MARK:- UICOLLECTIONVIEW DELEGATE SOURCE
extension CropDiagnosisPeetViwControllerOne{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           if cropsArray.count > 1{
               return CGSize(width: collectionView.bounds.size.width/2-15, height: collectionView.bounds.size.width/2-35)//150
           }
           return CGSize(width: collectionView.bounds.size.width-15, height: collectionView.bounds.size.width-60)//150
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsetsMake(10, 10, 10, 10)//top,left,bottom,right
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 10
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 10
       }
       
       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           let toCapturePhotoVC = self.storyboard?.instantiateViewController(withIdentifier: "CapturePhotoViewController") as! CapturePhotoViewController
           toCapturePhotoVC.cropNameFromCropDiagnosisVC = cropsArray.object(at: indexPath.row) as? NSString
           self.navigationController?.pushViewController(toCapturePhotoVC, animated: true)
       }
       
}


extension CropDiagnosisPeetViwControllerOne {
    //MARK: Location service delegate methods
    func tracingLocation(_ currentLocation: CLLocation) {
        self.getCurrentDayWeatherReportServiceCall(String(format : "%f",currentLocation.coordinate.latitude), String(format : "%f",currentLocation.coordinate.longitude))
        self.getForecastDayWeatherReportServiceCall(String(format : "%f",currentLocation.coordinate.latitude), String(format : "%f",currentLocation.coordinate.longitude))
        locationService.stopUpdatingLocation()
    }
    
    func tracingLocationDidFailWithError(_ error: NSError) {
    }
}

extension Date {
    func monthAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMM")
        return df.string(from: self)
    }
    
    func dateAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("dd")
        return df.string(from: self)
    }
}


extension UIView {
     func animateBorderColor(toColor: UIColor, duration: Double) {
        let animation:CABasicAnimation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = layer.borderColor
        animation.toValue = UIColor.orange.cgColor
        animation.duration = duration
        animation.repeatCount = .infinity
        layer.add(animation, forKey: "color and width")
      }
    }


/*
 //MARK: cropDiagnosisBtn Button
 @IBAction func cropDiagnosisBtn (sender : UIButton){
 let buttonPosition = sender.convert(CGPoint(x:0,y:0), to: cropDiagnosisCollView)
 let indexPath = self.cropDiagnosisCollView.indexPathForItem(at: buttonPosition)
 let cropNameStr = cropsArray.object(at: (indexPath?.row)!) as? NSString
 //print(cropNameStr!)
 
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
 let cropNameStr1 = cropsArray.object(at: (indexPath?.row)!) as? NSString
 let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,CROP:cropNameStr1!]
 self.registerFirebaseEvents(CD_Crop_Library_Click, "", "", "", parameters: firebaseParams as NSDictionary)
 let toLibraryVC = self.storyboard?.instantiateViewController(withIdentifier: "LibraryViewController") as! LibraryViewController
 toLibraryVC.mutArrayToDisplay = self.tempDiseasesMutArray
 toLibraryVC.backBtnTitle = cropNameStr! as String
 self.navigationController?.pushViewController(toLibraryVC, animated: true)
 }
 
 */
/*@objc func cropDiagnosisBtn (sender : UIButton){
 let buttonPosition = sender.convert(CGPoint(x:0,y:0), to: cropDiagnosisCollView)
 let indexPath = self.cropDiagnosisCollView.indexPathForItem(at: buttonPosition)
 let cropNameStr = cropsArray.object(at: (indexPath?.row)!) as? NSString
 print(cropNameStr!)
 
 let pestPredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Pest",cropNameStr! as String)
 let pestFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: pestPredicate)
 
 let weedPredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Weed",cropNameStr! as String)
 let weedFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: weedPredicate)
 
 let diseasePredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Disease",cropNameStr! as String)
 let diseaseFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: diseasePredicate)
 
 self.tempDiseasesMutArray.removeAllObjects()
 let tempPestMutDict = NSMutableDictionary()
 tempPestMutDict.setValue("Pest", forKey: "title")
 tempPestMutDict.setValue(pestFilteredArr, forKey: "data")
 tempDiseasesMutArray.add(tempPestMutDict)
 
 let tempWeedMutDict = NSMutableDictionary()
 tempWeedMutDict.setValue("Weed", forKey: "title")
 tempWeedMutDict.setValue(weedFilteredArr, forKey: "data")
 tempDiseasesMutArray.add(tempWeedMutDict)
 
 let tempDiseaseMutDict = NSMutableDictionary()
 tempDiseaseMutDict.setValue("Disease", forKey: "title")
 tempDiseaseMutDict.setValue(diseaseFilteredArr, forKey: "data")
 tempDiseasesMutArray.add(tempDiseaseMutDict)
 print(tempDiseasesMutArray)
 let toLibraryVC = self.storyboard?.instantiateViewController(withIdentifier: "LibraryViewController") as! LibraryViewController
 toLibraryVC.mutArrayToDisplay = self.tempDiseasesMutArray
 toLibraryVC.backBtnTitle = cropNameStr! as String
 self.navigationController?.pushViewController(toLibraryVC, animated: true)
 }*/


