//
//  CitiesViewController.swift
//  PioneerEmployee
//
//  Created by Empover on 11/09/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class CitiesViewController: BaseViewController , CLLocationManagerDelegate{

    //string to store city name
    var cityNameFromPinCodeOrLatLong : String = ""
    
    //string to store crop name
    var cropNameStr  : String!
    
    var isComingFromCropsVC : Bool = false
    
    //final cities array to populate in tableView
    var citiesArray = NSMutableArray()
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    
    @IBOutlet weak var noCitiesToDisplayLbl: UILabel!
    
    @IBOutlet weak var citiesTblView: UITableView!

    @IBOutlet weak var titleHgtCons: NSLayoutConstraint!
     var selectLocation: CLLocationCoordinate2D?
     let geocoder = GMSGeocoder()
    var logEvent = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        noCitiesToDisplayLbl.isHidden = true
        if isComingFromCropsVC == false {
            self.locationManager = CLLocationManager()
            if CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager?.requestWhenInUseAuthorization()
            }
            if CLLocationManager.locationServicesEnabled() {
                locationManager?.delegate = self
                locationManager?.desiredAccuracy = kCLLocationAccuracyBest
                //locationManager?.distanceFilter = 50
                locationManager?.startUpdatingLocation()
            }
            NotificationCenter.default.addObserver(self, selector: #selector(ViewController.viewWillAppear(_:)), name: Notification.Name("UpdateLatLong"), object: nil)
            self.recordScreenView("CitiesViewController", Mandi_States_List)
            self.registerFirebaseEvents(PV_Mandi_Wise_State_List, "", "", Mandi_States_List, parameters:nil)
            self.logEvent = PV_Mandi_Wise_State_List
        }
        else{
            //let urlStr = String.init(format: "%@&filters[commodity]=%@&fields=state&limit=100&sort[id]=asc", Main_URL,cropNameStr.replacingOccurrences(of: " ", with: "%20"))
//            let urlStr = String.init(format: "%@&filters[commodity]=%@&fields=state&limit=100", Main_URL,cropNameStr.replacingOccurrences(of: " ", with: "%20"))
            self.getStatesFromCrops()
            self.recordScreenView("CitiesViewController", Mandi_States_List)
            let userObj = Constatnts.getUserObject()
            let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Commodity:cropNameStr.replacingOccurrences(of: " ", with: "%20")] as [String : Any]
            self.registerFirebaseEvents(PV_Crop_Wise_States, "", "", Mandi_States_List, parameters:fireBaseParams as NSDictionary)
            self.logEvent = PV_Crop_Wise_States
        }
        
        //lat,long
        //Uttar pradesh: 26.8467, 80.9462
        //west bengal:22.9868, 87.8550
        //telangana: 17.3850, 78.4836
        //tamilnadu: 11.1271, 78.6569
        //punjab: 31.1471, 75.3412
        //orissa: 20.9517, 85.0985
        
        // self.parseCitiesDataFromJsonFile()
        citiesTblView.dataSource = self
        citiesTblView.delegate = self
        citiesTblView.tableFooterView = UIView()
        citiesTblView.separatorColor = UIColor.black
        
        // Uttar pradesh: 226001
        //west bengal: 700001
        //telangana: 500039
        //tamilnadu: 600001
        //uttarakhand : 248001
        //punjab: 143001
        //orissa: 751001
        //meghalaya: 793001
        
        //group.enter()
        //self.getCityNameUsingPinCode(pin: "700001")
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
            
            "eventName": self.logEvent,
            "className":"CitiesViewController",
            "moduleName":"mandiPrices",
            
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
    
    override func backButtonClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("viewWillAppear")
        self.topView?.isHidden = false
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
       
        if isComingFromCropsVC == false {
            self.titleHgtCons.constant = 0
            lblTitle?.text = NSLocalizedString("states", comment: "")  //MANDIS
            if CLLocationManager.locationServicesEnabled() {
                locationManager?.delegate = self
                locationManager?.desiredAccuracy = kCLLocationAccuracyBest
                //locationManager?.distanceFilter = 50
                locationManager?.startUpdatingLocation()
                switch(CLLocationManager.authorizationStatus()) {
                case .notDetermined, .restricted, .denied:
                    print("No access")
                    cityNameFromPinCodeOrLatLong = ""
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    currentLocation = locationManager?.location
                }
                 self.getCitiesFromCrops()
               // self.parseCitiesDataFromJsonFile()
            }
            else {
                print("Location services are not enabled")
                cityNameFromPinCodeOrLatLong = ""
                 self.getCitiesFromCrops()
               // self.parseCitiesDataFromJsonFile()
            }
        }
        else{
            self.titleHgtCons.constant = 30
              self.getStatesFromCrops()
            lblTitle?.text = cropNameStr
        }
    }

    //MARK: location manager delegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager?.stopUpdatingLocation()
        locationManager?.delegate = nil
        var latestLocation = locations.last
        if latestLocation == nil {
            latestLocation = locationManager?.location
        }
        let latitude = String(format: "%.4f", latestLocation!.coordinate.latitude)
        let longitude = String(format: "%.4f", latestLocation!.coordinate.longitude)
        print("Latitude: \(latitude)")
        print("Longitude: \(longitude)")
        self.getCityNameUsingLatLong(latitude: String(latitude), longitude: String(longitude))
    }
    
    //MARK: parseCitiesDataFromJsonFile
    func parseCitiesDataFromJsonFile(){
        let path = Bundle.main.path(forResource: "Cities", ofType: "json")
        do{
            let jsonData = try Data (contentsOf: URL(fileURLWithPath: path!), options: NSData.ReadingOptions.mappedIfSafe)
            let jsonResult:NSDictionary = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            let mutArr = (jsonResult.value(forKey: "Cities") as? NSMutableArray)!
            print("cities result :\(mutArr)")
            citiesArray.removeAllObjects()
            for i in (0..<mutArr.count){
                let dicObj = NSMutableDictionary()
                dicObj.setValue(mutArr.object(at: i), forKey: "name")
                let cityNameCount =   self.cityNameFromPinCodeOrLatLong.count
                if cityNameCount > 0 {
                    if mutArr.object(at: i) as? String == self.cityNameFromPinCodeOrLatLong {
                        dicObj.setValue("1", forKey: "status")
                    }
                    else{
                        dicObj.setValue("0", forKey: "status")
                    }
                    citiesArray.add(dicObj)
                }
                else{
                    dicObj.setValue("0", forKey: "status")
                    citiesArray.add(dicObj)
                }
            }
            
            //sorting the cities array based on status key
            let descriptor: NSSortDescriptor = NSSortDescriptor(key: "status", ascending: false)
            let sortedResults = citiesArray.sortedArray(using: [descriptor])
            citiesArray.removeAllObjects()
            citiesArray.addObjects(from: sortedResults)
           // citiesArray = NSMutableArray (array: sortedResults as! NSMutableArray)
            print("mut arr :\(citiesArray)")
            DispatchQueue.main.async {
                self.citiesTblView.reloadData()
            }
        }
        catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    
    //MARK: cityNameUsingLatLong
    func getCityNameUsingLatLong(latitude: String, longitude: String){
        SwiftLoader.show(animated: true)
        //get cityname by passing lat, long
        let lat = Double(latitude)
        let lan = Double(longitude)
        self.selectLocation = CLLocationCoordinate2D(latitude: lat! , longitude: lan!)
        
        self.geocoder.reverseGeocodeCoordinate(self.selectLocation!) { response, error in
            SwiftLoader.hide()
            if let address = response?.firstResult() {
                DispatchQueue.main.async {
                    
                    let lines = address.lines
                    print(lines)
                    print(address.subLocality)
                    print(address.administrativeArea)
                    print(address)
                    self.cityNameFromPinCodeOrLatLong = address.administrativeArea ?? ""
                    
                    if self.isComingFromCropsVC == false {
                        self.getCitiesFromCrops()
                    }else {
                        self.getStatesFromCrops()
                    }
                }}
        }
        
          let strURL = String(format : "https://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&key=AIzaSyCsVl8HKz5Fh6PxE11gHtJzQwDjf8xYMAE",latitude,longitude)
//        let strURL = String(format: "https://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&key=%@", latitude,longitude,Google_API_Key)
        //let strURL = String(format: "https://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@", latitude,longitude)
        
//        Alamofire.request(strURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON {
//            response in
//            SwiftLoader.hide()
//            if response.result.error == nil {
//                if let json = response.result.value {
//                   // print("JSON: \(json)")
//                    let resultDictionary = json as! NSDictionary
//                    // let resultsArr = resultDictionary.value(forKey: "results") as! NSArray
//                    let resultsArr = Validations.checkKeyNotAvailForArray(resultDictionary, key: "results") as? NSArray
//                    if resultsArr != nil{
//                        if resultsArr!.count > 0{
//                            let resultArrFstComp = resultsArr!.object(at: 0) as! NSDictionary
//                            let addressComponentsArr = resultArrFstComp.value(forKey: "address_components") as! NSArray
//                            //city name with predicate
//                            let resultPredicate = NSPredicate(format: "SELF.types CONTAINS %@", "administrative_area_level_1")
//                            let filteredArr = (addressComponentsArr as NSArray).filtered(using: resultPredicate)
//                            let cityName = (filteredArr[0] as! NSDictionary).value(forKey: "long_name") as! String
//                            //print("city name: \(cityName)")
//                            self.cityNameFromPinCodeOrLatLong = cityName
////                            self.parseCitiesDataFromJsonFile()
//                            if self.isComingFromCropsVC == false {
//                                self.getCitiesFromCrops()
//                            }else {
//                                self.getStatesFromCrops()
//                            }
//                        }
//
//                    }
//
//                }
//            }
//            else{
//                self.view.makeToast((response.result.error?.localizedDescription)!, duration: 1.0, position: .center)
//                return
//            }
//        }
        
        
        
        
    }
    
    //MARK: getCityNameUsingPinCode
    func getCityNameUsingPinCode(pin : String){
        //        SwiftLoader.show(animated: true)
        //get city name by passing pin code
        let strURL = String(format: "http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", pin)
        Alamofire.request(strURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON {
            response in
             SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                   print("JSON: \(json)")
                    let resultDictionary = json as! NSDictionary
                    let resultsArr = resultDictionary.value(forKey: "results") as! NSArray
                    let resultArrFstComp = resultsArr.object(at: 0) as! NSDictionary
                    let addressComponentsArr = resultArrFstComp.value(forKey: "address_components") as! NSArray
                   
                    //city name with predicate
                    let resultPredicate = NSPredicate(format: "SELF.types CONTAINS %@", "administrative_area_level_1")
                    let filteredArr = (addressComponentsArr as NSArray).filtered(using: resultPredicate)
                    let cityName = (filteredArr[0] as! NSDictionary).value(forKey: "long_name") as! String
                    print("city name: \(cityName)")
                    self.cityNameFromPinCodeOrLatLong = cityName
                }
            }
            else{
                self.view.makeToast((response.result.error?.localizedDescription)!, duration: 1.0, position: .center)
                return
            }
        }
    }
    
    //MARK: getCitiesFromCrops
    func getCitiesFromCrops (urlStr : String){
        SwiftLoader.show(animated: true)
        Alamofire.request(urlStr, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON {
            response in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    let resultDictionary = json as! NSDictionary
                    //print("JSON: \(resultDictionary)")
                    //                    guard let status = resultDictionary.value(forKey: "records") as? NSArray else{
                    //                        return
                    //                    }
                    // if status == true{
                    
                    if let arr = resultDictionary.value(forKey: "records") as? NSArray{
                        if arr.count > 0{
                            self.noCitiesToDisplayLbl.isHidden = true
                            //print("JSON: \(resultDictionary.value(forKey: "records") as! NSArray)")
                            let mutArr = arr//(resultDictionary.value(forKey: "records") as? NSArray)!
                            let allStatesMutArr = NSMutableArray()
                            for i in (0..<mutArr.count){
                                let cityName = (mutArr[i] as! NSDictionary).value(forKey: "state") as! String
                                allStatesMutArr.add(cityName)
                            }
                            
                            //print("all states array : \(allStatesMutArr)")
                            //allStatesMutArr = NSMutableArray (array: Constatnts.uniqueElementsFrom(array: (allStatesMutArr) as! [String]) as! NSMutableArray)
                            let statesNamesSet =  NSSet(array:allStatesMutArr as! [Any])
                            allStatesMutArr.addObjects(from: statesNamesSet.allObjects)
                            //let sortedArr = self.stateNamesArray.sorted(by: { ($0 as! String) < ($1 as! String) })
                            // self.stateNamesArray.removeAllObjects()
                            //self.stateNamesArray.addObjects(from: sortedArr)
                            print(allStatesMutArr)
                            //print("cities array without duplicates: \(allStatesMutArr)")
                            self.citiesArray.removeAllObjects()
                            for i in (0..<allStatesMutArr.count){
                                let dicObj = NSMutableDictionary()
                                dicObj.setValue(allStatesMutArr.object(at: i), forKey: "name")
                                dicObj.setValue("0", forKey: "status")
                                self.citiesArray.add(dicObj)
                            }
                            let citiesNamesSet =  NSSet(array:(self.citiesArray as NSArray) as! [Any])
                            self.citiesArray.removeAllObjects()
                            self.citiesArray.addObjects(from: citiesNamesSet.allObjects)
                            let descriptor: NSSortDescriptor = NSSortDescriptor(key: "status", ascending: false)
                            let sortedResults = self.citiesArray.sortedArray(using:[descriptor])
                            self.citiesArray.removeAllObjects()
                            self.citiesArray.addObjects(from: sortedResults)
                            //self.citiesArray = NSMutableArray (array: sortedResults as! NSMutableArray)
                            //print("mut arr :\(self.citiesArray)")
                            self.citiesTblView.reloadData()
                        }
                        else{
                            self.noCitiesToDisplayLbl.isHidden = false
                        }
                    }
                    else{
                        self.noCitiesToDisplayLbl.isHidden = false
                    }
                }
                else{
                    self.noCitiesToDisplayLbl.isHidden = false
                }
            }
            else{
                self.view.makeToast((response.result.error?.localizedDescription)!, duration: 1.0, position: .center)
                return
            }
        }
    }
    
    func getCitiesFromCrops (){
        
        SwiftLoader.show(animated: true)
        
        let urlStr = BASE_URL + Main_URL
        
        Alamofire.request(urlStr, method: .post, parameters: [:], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print(response)
            SwiftLoader.hide()
            if response.result.value != nil {
                if let json = response.result.value {
                    
                    if Validations.isNullString(((json as! NSDictionary).value(forKey: "response") as! NSString).replacingOccurrences(of: "\\", with: "") as NSString) == false{
                        let respData = ((json as! NSDictionary).value(forKey: "response") as! NSString).replacingOccurrences(of: "\\", with: "")
                        if let tempResult = Constatnts.convertToDictionary(text: respData as String) as NSDictionary?{
                            let dictionResult = tempResult
                            if let arr = dictionResult["mandiPricesStates"] as? NSArray{
                                if arr.count > 0{
                                    self.noCitiesToDisplayLbl.isHidden = true
                                    let mutArr = arr//(resultDictionary.value(forKey: "records") as? NSArray)!
                                    let allStatesMutArr = NSMutableArray()
                                    
                                    for i in (0..<mutArr.count){
                                        let cityName = (mutArr[i] as! NSDictionary).value(forKey: "name") as! String
                                        allStatesMutArr.add(cityName)
                                    }
                                    
                                    
                                    let statesNamesSet =  NSSet(array:allStatesMutArr as! [Any])
                                    allStatesMutArr.addObjects(from: statesNamesSet.allObjects)
                                    
                                    print(allStatesMutArr)
                                    
                                    self.citiesArray.removeAllObjects()
                                    
                                    for i in (0..<allStatesMutArr.count){
                                        let dicObj = NSMutableDictionary()
                                        if allStatesMutArr.object(at: i) as? String  == self.cityNameFromPinCodeOrLatLong {
                                            self.citiesArray.insert(dicObj, at: 0)
                                        }
                                        dicObj.setValue(allStatesMutArr.object(at: i), forKey: "name")
                                        dicObj.setValue("0", forKey: "status")
                                        self.citiesArray.add(dicObj)
                                    }
                                    
                                    let citiesNamesSet =  NSSet(array:(self.citiesArray as NSArray) as! [Any])
                                    self.citiesArray.removeAllObjects()
                                    self.citiesArray.addObjects(from: citiesNamesSet.allObjects)
                                    let descriptor: NSSortDescriptor = NSSortDescriptor(key: "status", ascending: false)
                                    let sortedResults = self.citiesArray.sortedArray(using:[descriptor])
                                    self.citiesArray.removeAllObjects()
                                    self.citiesArray.addObjects(from: sortedResults)
                                    
                                    self.citiesTblView.reloadData()
                                }
                            }
                        }
                        
                    }
                    
                }
            }
            
        }
    }
    
    func getStatesFromCrops (){
        
        SwiftLoader.show(animated: true)
        let userObj = Constatnts.getUserObject()
        let urlStr = BASE_URL + GET_STATES_BY_CROP
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        
        
        
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! NSString
        let  parameters = ["deviceType":"iOS","empId":userObj.customerId! as String,"mobileNumber":userObj.mobileNumber! as String,"versionName":version , "commodity": self.cropNameStr]  as? NSDictionary
        
        let paramsStr = Constatnts.encryptInputParams(parameters: parameters!)
        let params =  ["data": paramsStr] as Dictionary
        
        
        
        Alamofire.request(urlStr, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response)
            SwiftLoader.hide()
            if response.result.value != nil {
                if let json = response.result.value {
                    
                    if Validations.isNullString(((json as! NSDictionary).value(forKey: "response") as! NSString).replacingOccurrences(of: "\\", with: "") as NSString) == false{
                        let respData = ((json as! NSDictionary).value(forKey: "response") as! NSString).replacingOccurrences(of: "\\", with: "")
                        if let tempResult = Constatnts.convertToDictionary(text: respData as String) as NSDictionary?{
                            let dictionResult = tempResult
                            if let arr = dictionResult["mandiPricesCommodites"] as? NSArray{
                                if arr.count > 0{
                                    self.noCitiesToDisplayLbl.isHidden = true
                                    let mutArr = arr//(resultDictionary.value(forKey: "records") as? NSArray)!
                                    let allStatesMutArr = NSMutableArray()
                                    
                                    for i in (0..<mutArr.count){
                                        let cityName = (mutArr[i] as! NSDictionary).value(forKey: "state") as! String
                                        allStatesMutArr.add(cityName)
                                    }
                                    
                                    
                                    let statesNamesSet =  NSSet(array:allStatesMutArr as! [Any])
                                    allStatesMutArr.addObjects(from: statesNamesSet.allObjects)
                                    
                                    print(allStatesMutArr)
                                    self.citiesArray.removeAllObjects()
                                    for i in (0..<allStatesMutArr.count){
                                        let dicObj = NSMutableDictionary()
                                        
                                        if allStatesMutArr.object(at: i) as? String  == self.cityNameFromPinCodeOrLatLong {
                                            self.citiesArray.insert(dicObj, at: 0)
                                        }
                                        
                                        dicObj.setValue(allStatesMutArr.object(at: i), forKey: "state")
                                        dicObj.setValue("0", forKey: "status")
                                        self.citiesArray.add(dicObj)
                                    }
                                    let citiesNamesSet =  NSSet(array:(self.citiesArray as NSArray) as! [Any])
                                    self.citiesArray.removeAllObjects()
                                    self.citiesArray.addObjects(from: citiesNamesSet.allObjects)
                                    self.citiesTblView.reloadData()
                                }
                            }
                        }
                        
                    }
                    
                }
            }
            
        }
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

extension CitiesViewController :  UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CitiesCell"
        //let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        let cell = citiesTblView!.dequeueReusableCell(withIdentifier: cellIdentifier)
        cell?.backgroundColor = UIColor.clear
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        let cityNameLbl : UILabel = cell!.viewWithTag(100) as! UILabel
        if indexPath.row == 0 && isComingFromCropsVC == false {
            cell?.contentView.superview?.backgroundColor = CommoditiesAndCropsTableCellBackgroundColor
        }
        if isComingFromCropsVC == false {
            cityNameLbl.text = (citiesArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as? String
        }else {
            cityNameLbl.text = (citiesArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "state") as? String
        }
//        cityNameLbl.text = (citiesArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as? String
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            if isComingFromCropsVC == false {
                let toMandisVC  = self.storyboard?.instantiateViewController(withIdentifier: "MandisViewController") as! MandisViewController
                toMandisVC.stateNameStr = (citiesArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as? String
                self.navigationController?.pushViewController(toMandisVC, animated: true)
            }
            else{
                let toCropDetailsVC  = self.storyboard?.instantiateViewController(withIdentifier: "CommodityDetailsViewController") as! CommodityDetailsViewController
                toCropDetailsVC.isComingFromCitiesVC = true
//                toCropDetailsVC.stateNameStr = (citiesArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as? String
                toCropDetailsVC.stateNameStr =   (citiesArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "state") as? String // (citiesArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "state") as? String
                toCropDetailsVC.commodityNameStr = cropNameStr
                self.navigationController?.pushViewController(toCropDetailsVC, animated: true)
            }
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
        let userObj = Constatnts.getUserObject()
        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,STATE:(citiesArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") ?? ""]
        self.registerFirebaseEvents(Mandi_State, "", "", Mandi_States_List, parameters:fireBaseParams as NSDictionary)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
