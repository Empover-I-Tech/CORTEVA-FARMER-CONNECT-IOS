//
//  CropsViewController.swift
//  MandisData
//
//  Created by Empover on 29/08/17.
//  Copyright © 2017 Empover. All rights reserved.

import UIKit
import Alamofire

class CropsViewController: BaseViewController {
    
    @IBOutlet weak var cropsTblView: UITableView!
    
    ///mutable array to store/populate the crops data
    var cropsMutArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        let backButton = UIBarButtonItem()
//        backButton.title = "Crops"
//        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        cropsTblView.dataSource = self
        cropsTblView.delegate = self
        cropsTblView.tableFooterView = UIView()
        cropsTblView.separatorColor = UIColor.black
//        self.parseCropsDataFromJsonFile()
         self.getCropsData()
        self.recordScreenView("CropsViewController", Mandi_Crops_List)
        self.registerFirebaseEvents(PV_Mandi_Wise_Crop, "", "", Mandi_Crops_List, parameters: nil)
        let userObj = Constatnts.getUserObject()
        if userObj.userLogsAllPrint == "true"{
        self.saveUserLogEventsDetailsToServer()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.topView?.isHidden = false
        lblTitle?.text = NSLocalizedString("crops", comment: "")
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
    }
    
    override func backButtonClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: parseCropsDataFromJsonFile
    func parseCropsDataFromJsonFile(){
        let path = Bundle.main.path(forResource: "Crops", ofType: "json")
        do{
            let jsonData = try Data (contentsOf: URL(fileURLWithPath: path!), options: NSData.ReadingOptions.mappedIfSafe)
            let jsonResult:NSDictionary = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            let mutArr = (jsonResult.value(forKey: "item") as? NSMutableArray)!
            let cropsArrayObj = NSMutableArray()
            //let topCropsArray = ["Maize","Rice","Millets","Mustard"]
            
            //            for i in (0..<mutArr.count){
            //
            //                var dicObj = [String:String]()
            //
            //               // dicObj.setValue(mutArr.object(at: i), forKey: "name")
            //
            //                dicObj["name"] = mutArr.object(at: i) as? String
            //
            //                //if topCropsArray.contains((mutArr.object(at: i) as? String)!) {
            //
            //                   // dicObj.setValue("1", forKey: "status")
            //
            //                if dicObj["name"] == "Maize" {
            //
            //                    dicObj["status"] = "4"
            //                }
            //                else if dicObj["name"] == "Rice" {
            //
            //                    dicObj["status"] = "3"
            //                }
            //                else if dicObj["name"] == "Millets" {
            //
            //                    dicObj["status"] = "2"
            //                }
            //                else if dicObj["name"] == "Mustard" {
            //
            //                    dicObj["status"] = "1"
            //                }
            //                else{
            //
            //                   // dicObj.setValue("0", forKey: "status")
            //                    dicObj["status"] = "0"
            //                }
            //                cropsMutArray.add(dicObj)
            //            }
            //
            //            let descriptor1: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            //            let sortedResults1 = cropsMutArray.sortedArray(using: [descriptor1])
            //
            //            cropsMutArray = NSMutableArray (array: sortedResults1 as! NSMutableArray)
            //
            //            print("mut arr :\(cropsMutArray)")
            //
            //            let descriptor: NSSortDescriptor = NSSortDescriptor(key: "status", ascending: false)
            //            let sortedResults = cropsMutArray.sortedArray(using: [descriptor])
            //
            //            cropsMutArray = NSMutableArray (array: sortedResults as! NSMutableArray)
            
            //arranging the crops in ascending order
            let sortedCommoditiesArray = mutArr.sorted { ($0 as AnyObject).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
            //cropsArrayObj = sortedCommoditiesArray as! NSMutableArray
            cropsArrayObj.addObjects(from: sortedCommoditiesArray)
            let topCropsArray = ["Maize","Rice","Millets","Mustard"]
            let resultPredicate = NSPredicate(format: "NOT SELF IN %@", topCropsArray)
            //array after removing the top 4 crops from the sorted cropsMutArray
            self.cropsMutArray = NSMutableArray (array: (cropsArrayObj as NSArray).filtered(using: resultPredicate))
            //print("filtered array : \(self.cropsMutArray)")
            if cropsArrayObj.contains("Mustard"){
                self.cropsMutArray.insert("Mustard", at: 0)
            }
            if cropsArrayObj.contains("Millets"){
                self.cropsMutArray.insert("Millets", at: 0)
            }
            if cropsArrayObj.contains("Rice"){
                self.cropsMutArray.insert("Rice", at: 0)
            }
            if cropsArrayObj.contains("Maize"){
                self.cropsMutArray.insert("Maize", at: 0)
            }
            //print("final sorted array :\(self.cropsMutArray)")
            cropsTblView.reloadData()
        }
        catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    func getCropsData(){
        
        SwiftLoader.show(animated: true)
        
        let urlStr = BASE_URL + GET_CROPS
        
        Alamofire.request(urlStr, method: .post, parameters: [:], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print(response)
            SwiftLoader.hide()
            if response.result.value != nil {
                if let json = response.result.value {
                    
                    if Validations.isNullString(((json as! NSDictionary).value(forKey: "response") as! NSString).replacingOccurrences(of: "\\", with: "") as NSString) == false{
                        let respData = ((json as! NSDictionary).value(forKey: "response") as! NSString).replacingOccurrences(of: "\\", with: "")
                        if let tempResult = Constatnts.convertToDictionary(text: respData as String) as NSDictionary?{
                            let dictionResult = tempResult
                            if let arr = dictionResult["mandiPricesCrops"] as? NSArray{
                                if arr.count > 0{
                                    let mutArr = arr//(resultDictionary.value(forKey: "records") as? NSArray)!
                                    let allStatesMutArr = NSMutableArray()
                                    //arranging the crops in ascending order
                                    //                                    let sortedCommoditiesArray = mutArr.sorted { ($0 as AnyObject).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
                                    //                                    //cropsArrayObj = sortedCommoditiesArray as! NSMutableArray
                                    //                                    allStatesMutArr.addObjects(from: sortedCommoditiesArray)
                                    let topCropsArray = ["Maize","Rice","Bajra(Pearl Millet/Cumbu)","Mustard"]
                                    let resultPredicate = NSPredicate(format: "NOT SELF IN %@", topCropsArray)
                                    //array after removing the top 4 crops from the sorted cropsMutArray
                                    self.cropsMutArray = NSMutableArray (array: (allStatesMutArr as NSArray).filtered(using: resultPredicate))
                                    //print("filtered array : \(self.cropsMutArray)")
                                    if allStatesMutArr.contains("Mustard"){
                                        self.cropsMutArray.insert("Mustard", at: 0)
                                    }
                                    if allStatesMutArr.contains("Bajra(Pearl Millet/Cumbu)"){
                                        self.cropsMutArray.insert("Bajra(Pearl Millet/Cumbu)", at: 0)
                                    }
                                    if allStatesMutArr.contains("Rice"){
                                        self.cropsMutArray.insert("Rice", at: 0)
                                    }
                                    if allStatesMutArr.contains("Maize"){
                                        self.cropsMutArray.insert("Maize", at: 0)
                                        
                                    }
                                    
                                    for i in (0..<mutArr.count){
                                        let cityName = (mutArr[i] as! NSDictionary).value(forKey: "name") as! String
                                        allStatesMutArr.add(cityName)
                                        
                                    }
                                    
                                    
                                    let statesNamesSet =  NSSet(array:allStatesMutArr as! [Any])
                                    allStatesMutArr.addObjects(from: statesNamesSet.allObjects)
                                    
                                    print(allStatesMutArr)
                                    self.cropsMutArray.removeAllObjects()
                                    for i in (0..<allStatesMutArr.count){
                                        let dicObj = NSMutableDictionary()
                                        dicObj.setValue(allStatesMutArr.object(at: i), forKey: "name")
                                        dicObj.setValue("0", forKey: "status")
                                        self.cropsMutArray.add(dicObj)
                                    }
                                    let citiesNamesSet =  NSSet(array:(self.cropsMutArray as NSArray) as! [Any])
                                    self.cropsMutArray.removeAllObjects()
                                    self.cropsMutArray.addObjects(from: citiesNamesSet.allObjects)
                                    let descriptor: NSSortDescriptor = NSSortDescriptor(key: "status", ascending: false)
                                    let sortedResults = self.cropsMutArray.sortedArray(using:[descriptor])
                                    self.cropsMutArray.removeAllObjects()
                                    self.cropsMutArray.addObjects(from: sortedResults)
                                    
                                    self.cropsTblView.reloadData()
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

extension CropsViewController :  UITableViewDataSource, UITableViewDelegate{
    //MARK: dropdown tableview datasource & delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cropsMutArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CropsCell"
        //let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        let cell = cropsTblView!.dequeueReusableCell(withIdentifier: cellIdentifier)
        cell?.backgroundColor = UIColor.clear
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        let cropNameLbl : UILabel = cell!.viewWithTag(500) as! UILabel
        let backGroundView : UIView = cell!.viewWithTag(501)!
        backGroundView.backgroundColor = UIColor.clear
        if indexPath.row < 4 {
            //cell?.contentView.superview?.backgroundColor = UIColor (red: 163.0/255, green: 163.0/255, blue: 194.0/255, alpha: 1.0)
            cell?.contentView.superview?.backgroundColor = CommoditiesAndCropsTableCellBackgroundColor
            //cell?.tintColor = UIColor.red
            //backGroundView.backgroundColor = UIColor (red: 209.0, green: 209.0, blue: 224.0, alpha: 1.0)
            //backGroundView.superview?.backgroundColor = UIColor.lightGray
            //cropNameLbl.textColor = UIColor.white
        }
        else{
            cell?.contentView.superview?.backgroundColor = UIColor.clear
            //backGroundView.superview?.backgroundColor = UIColor.clear
            //cropNameLbl.textColor = UIColor.black
        }
        //cropNameLbl.text = (cropsMutArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as? String
          cropNameLbl.text = (cropsMutArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as? String
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
        let toCitiesVC  = self.storyboard?.instantiateViewController(withIdentifier: "CitiesViewController") as! CitiesViewController
        toCitiesVC.isComingFromCropsVC = true
        //toCitiesVC.cropNameStr = (cropsMutArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as? String
//        toCitiesVC.cropNameStr = cropsMutArray.object(at: indexPath.row) as? String
              toCitiesVC.cropNameStr = (cropsMutArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as? String
        self.navigationController?.pushViewController(toCitiesVC, animated: true)
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
        self.registerFirebaseEvents(Mandi_Wise_Crop, "", "", Mandi_Crops_List, parameters: nil)
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
            
            "eventName": By_Crops,
            "className":"CropsViewController",
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
}
