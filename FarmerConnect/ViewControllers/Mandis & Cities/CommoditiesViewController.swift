//
//  CommoditiesViewController.swift
//  MandisData
//
//  Created by Empover on 28/08/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import UIKit
import Alamofire

class CommoditiesViewController: BaseViewController {

    ///to store state name
    var stateNameStr : String!
    
    ///to store market name
    var marketNameStr : String!
    
    var commoditiesFilteredArray = NSMutableArray()
    
    /***/
    //var commonCommoditiesFilteredArray = NSMutableArray()
    
    var count : NSInteger = 0
    
    @IBOutlet weak var noCommoditiesToDisplayLbl: UILabel!
    
    @IBOutlet weak var commoditiesTblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        noCommoditiesToDisplayLbl.isHidden = true
        
        commoditiesTblView.dataSource = self
        commoditiesTblView.delegate = self
        
        commoditiesTblView.tableFooterView = UIView()
        commoditiesTblView.separatorColor = UIColor.black

        //let urlStr = String.init(format: "%@&filters[state]=%@&filters[market]=%@&Offset=0&fields=commodity&limit=100&sort[id]=asc", Main_URL,stateNameStr.replacingOccurrences(of: " ", with: "%20"),marketNameStr.replacingOccurrences(of: " ", with: "%20"))
//        let urlStr = String.init(format: "%@&filters[state]=%@&filters[market]=%@&Offset=0&fields=commodity&limit=100", Main_URL,stateNameStr.replacingOccurrences(of: " ", with: "%20"),marketNameStr.replacingOccurrences(of: " ", with: "%20"))
        //print("url :\(urlStr)")
        self.getCommoditiesFromCityAndMarket()
        self.recordScreenView("CommodiesListViewController", Commodity_Crops_List)
        let userObj = Constatnts.getUserObject()
        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,STATE:stateNameStr,Market:marketNameStr] as [String : Any]
        self.registerFirebaseEvents(PV_Crops_Wise_Commodity_List, "", "", Commodity_Crops_List, parameters: fireBaseParams as NSDictionary)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.topView?.isHidden = false
      lblTitle?.text =  stateNameStr + "-" + marketNameStr
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
    }

    override func backButtonClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: getCommoditiesFromCityAndMarket
    func getCommoditiesFromCityAndMarket (){
        
        let urlStr = BASE_URL + GET_COMMODITIES
        
        let userObj = Constatnts.getUserObject()
       
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! NSString
        
        let  parameters = ["deviceType":"iOS","empId":userObj.customerId! as String,"mobileNumber":userObj.mobileNumber! as String ,"state": self.stateNameStr,"versionName":version ,"market": self.marketNameStr]  as? NSDictionary
        
        let paramsStr = Constatnts.encryptInputParams(parameters: parameters!)
        let params =  ["data": paramsStr] as Dictionary
        
        print(params)
        
        
        SwiftLoader.show(animated: true)
        Alamofire.request(urlStr, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    
                    if Validations.isNullString(((json as! NSDictionary).value(forKey: "response") as! NSString).replacingOccurrences(of: "\\", with: "") as NSString) == false{
                        let respData = ((json as! NSDictionary).value(forKey: "response") as! NSString).replacingOccurrences(of: "\\", with: "")
                        if let tempResult = Constatnts.convertToDictionary(text: respData as String) as NSDictionary?{
                            print(respData)
                            
                            let dictionResult = tempResult
                            if let arr = dictionResult.value(forKey: "mandiPricesCommoditesByStateNMarket") as? NSArray{
                                if arr.count > 0{
                                    
                                    self.noCommoditiesToDisplayLbl.isHidden = true
                                    let commoditiesArray = NSMutableArray()
                                    //print("JSON: \(resultDictionary.value(forKey: "records") as! NSArray)")
                                    let recordsMutArray = arr
                                    for i in (0..<recordsMutArray.count){
                                        //let marketsDic = recordsMutArray.object(at: i) as! NSDictionary
                                        let stateName = (recordsMutArray[i] as! NSDictionary).value(forKey: "commodity")
                                        commoditiesArray.add(stateName as! String)
                                    }
                                    //print("commodities array : \(commoditiesArray)")
                                    
                                    // commoditiesArray = Constatnts.uniqueElementsFrom(array: commoditiesArray as! [String]) as! NSMutableArray
                                    
                                    let commoditiesNamesSet =  NSSet(array:commoditiesArray as! [Any])
                                    commoditiesArray.removeAllObjects()
                                    //print("commodities array without duplicates: \(commoditiesArray)")
                                    
                                    let sortedCommoditiesArray = commoditiesNamesSet.allObjects.sorted {($0 as AnyObject).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending}
                                    commoditiesArray.addObjects(from: sortedCommoditiesArray)
                                    //commoditiesArray = sortedCommoditiesArray as! NSMutableArray
                                    let topCropsArray = ["Maize","Rice","Bajra(Pearl Millet/Cumbu)","Mustard"]
                                    let resultPredicate = NSPredicate(format: "NOT SELF IN %@", topCropsArray)
                                    self.commoditiesFilteredArray = NSMutableArray (array: (commoditiesArray as NSArray).filtered(using: resultPredicate))
                                    //let resultPredicate1 = NSPredicate(format: "SELF IN %@", topCropsArray)
                                    //self.commonCommoditiesFilteredArray = NSMutableArray (array: (commoditiesArray as NSArray).filtered(using: resultPredicate1))
                                    //print("filtered array : \(self.commoditiesFilteredArray)")
                                    // print("filtered array1 : \(self.commonCommoditiesFilteredArray)")
                                    if commoditiesArray.contains("Mustard"){
                                        self.count+=1
                                        self.commoditiesFilteredArray.insert("Mustard", at: 0)
                                    }
                                    if commoditiesArray.contains("Bajra(Pearl Millet/Cumbu)"){
                                        self.count+=1
                                        self.commoditiesFilteredArray.insert("Bajra(Pearl Millet/Cumbu)", at: 0)
                                    }
                                    if commoditiesArray.contains("Rice"){
                                        self.count+=1
                                        self.commoditiesFilteredArray.insert("Rice", at: 0)
                                    }
                                    if commoditiesArray.contains("Maize"){
                                        self.count+=1
                                        self.commoditiesFilteredArray.insert("Maize", at: 0)
                                    }
                                    //print("final sorted array :\(self.commoditiesFilteredArray)")
                                    DispatchQueue.main.async {
                                        self.commoditiesTblView.reloadData()
                                    }
                                }
                                else{
                                    self.noCommoditiesToDisplayLbl.isHidden = false
                                }
                            }
                            else{
                                self.noCommoditiesToDisplayLbl.isHidden = false
                            }
                        }
                    }
                    else{
                        self.view.makeToast((response.result.error?.localizedDescription)!, duration: 1.0, position: .center)
                        return
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

extension CommoditiesViewController :  UITableViewDataSource, UITableViewDelegate{
    //MARK: dropdown tableview datasource & delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commoditiesFilteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CommoditiesCell"
        //let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        let cell = commoditiesTblView.dequeueReusableCell(withIdentifier: cellIdentifier)
        //cell?.backgroundColor = UIColor.clear
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        let cropNameLbl : UILabel = cell!.viewWithTag(300) as! UILabel
        if indexPath.row < self.count {
            //cell?.contentView.superview?.backgroundColor = UIColor (red: 163.0/255, green: 163.0/255, blue: 194.0/255, alpha: 1.0)
            cell?.contentView.superview?.backgroundColor = CommoditiesAndCropsTableCellBackgroundColor
            cell?.tintColor = UIColor.black
            //cropNameLbl.textColor = UIColor.white
        }
        else{
            cell?.contentView.superview?.backgroundColor = UIColor.clear
            // cropNameLbl.textColor = UIColor.black
        }
        //cropNameLbl.text = (commoditiesFilteredArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as? String
        cropNameLbl.text = commoditiesFilteredArray.object(at: indexPath.row) as? String
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
        let toCommodityDetailsVC  = self.storyboard?.instantiateViewController(withIdentifier: "CommodityDetailsViewController") as! CommodityDetailsViewController
        toCommodityDetailsVC.isComingFromCitiesVC = false
        toCommodityDetailsVC.marketNameStr = marketNameStr
        toCommodityDetailsVC.stateNameStr = stateNameStr
        //toCommodityDetailsVC.commodityNameStr = (commoditiesFilteredArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as? String
        //toCommodityDetailsVC.commodityNameStr = String(format: "%@ - %@", marketNameStr,(commoditiesFilteredArray.object(at: indexPath.row) as? String)!)
        toCommodityDetailsVC.commodityNameStr = commoditiesFilteredArray.object(at: indexPath.row) as? String
        self.navigationController?.pushViewController(toCommodityDetailsVC, animated: true)
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
        let userObj = Constatnts.getUserObject()
        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Commodity:commoditiesFilteredArray.object(at: indexPath.row) as? String ?? ""] as [String : Any]
        self.registerFirebaseEvents(Crop_Commodity, "", "", PV_Crops_Wise_Commodity_List, parameters: fireBaseParams as NSDictionary)
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
