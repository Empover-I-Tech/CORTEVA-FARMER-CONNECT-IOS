//
//  CommodityDetailsViewController.swift
//  MandisData
//
//  Created by Empover on 28/08/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import UIKit
import Alamofire

class CommodityDetailsViewController: BaseViewController {
    
    var stateNameStr : String!
    
    var marketNameStr : String!
    
    var commodityNameStr : String!
    
    var commoditiesDetailsArray = NSArray()
    
    var isComingFromCitiesVC : Bool = false
    
    //var marketLblCount : NSInteger = 0
    
    //var commodityLblCount : NSInteger = 0
    
    @IBOutlet weak var noCommodityDetailsToDisplayLbl: UILabel!
    
    @IBOutlet weak var commodityDetailsTblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        commodityDetailsTblView.dataSource = self
        commodityDetailsTblView.delegate = self
        commodityDetailsTblView.tableFooterView = UIView()
        commodityDetailsTblView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        commodityDetailsTblView.rowHeight = UITableViewAutomaticDimension
        commodityDetailsTblView.estimatedRowHeight = 250
        
        noCommodityDetailsToDisplayLbl.isHidden = true
        if isComingFromCitiesVC == false {
//            let backButton = UIBarButtonItem()
//            backButton.title = commodityNameStr
//            self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
            //let urlStr = String.init(format: "%@&filters[state]=%@&filters[market]=%@&filters[commodity]=%@&offset=0&limit=100&sort[id]=asc", Main_URL,stateNameStr.replacingOccurrences(of: " ", with: "%20"),marketNameStr.replacingOccurrences(of: " ", with: "%20"),commodityNameStr.replacingOccurrences(of: " ", with: "%20"))
//            let urlStr = String.init(format: "%@&filters[state]=%@&filters[market]=%@&filters[commodity]=%@&offset=0&limit=100", Main_URL,stateNameStr.replacingOccurrences(of: " ", with: "%20"),marketNameStr.replacingOccurrences(of: " ", with: "%20"),commodityNameStr.replacingOccurrences(of: " ", with: "%20"))
            //print("url :\(urlStr)")
             self.getCommodityDetailsFromCityAndMarketAndCommodity()
        }
        else{
//            let backButton = UIBarButtonItem()
//            backButton.title = stateNameStr
//            self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
//            let urlStr = String.init(format: "%@&filters[state]=%@&filters[commodity]=%@&offset=0&limit=100", Main_URL,stateNameStr.replacingOccurrences(of: " ", with: "%20"),commodityNameStr.replacingOccurrences(of: " ", with: "%20"))
            //print("url :\(urlStr)")
 self.getCommodityDetailsFromCityAndMarketAndCommodity()
        }
        self.recordScreenView("CommodityDetailsViewController", Commodity_Details)
        let userObj = Constatnts.getUserObject()
        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Commodity:commodityNameStr] as [String : Any]
        self.registerFirebaseEvents(PV_Mandi_Commodity_Details, "", "", Commodity_Details, parameters: fireBaseParams as NSDictionary)
        
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
            "marketName":self.marketNameStr,
            "commodity":self.commodityNameStr,
            
            "eventName": PV_Mandi_Commodity_Details,
            "className":"CommodityCetailsViewController",
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //commodityDetailsTblView.layoutSubviews()
        self.topView?.isHidden = false
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        if isComingFromCitiesVC == false {
            lblTitle?.text = String(format: "%@ - %@", marketNameStr,commodityNameStr)  //commodityNameStr
        }
        else{
            lblTitle?.text = String(format: "%@ - %@", stateNameStr,commodityNameStr)//stateNameStr
        }
    }
    
    //MARK: getCommodityDetailsFromCityAndMarketAndCommodity
    func getCommodityDetailsFromCityAndMarketAndCommodity (){
        
        let userObj = Constatnts.getUserObject()
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! NSString
        
        var urlStr = ""
        var parameters : NSDictionary?
        
        if isComingFromCitiesVC == false {
            
            urlStr = BASE_URL + GET_COMMODITIES_PRICES
            parameters  = [ "deviceType":"iOS","empId":userObj.customerId! as String,"mobileNumber":userObj.mobileNumber! as String,"state": self.stateNameStr,"versionName":version ,"market": self.marketNameStr ,"commodity":self.commodityNameStr]  as? NSDictionary
        }else {
            urlStr = BASE_URL + GET_PRICES_BY_COMMODITIES_STATE
            
            parameters  = [ "deviceType":"iOS","empId":userObj.customerId! as String,"mobileNumber":userObj.mobileNumber! as String ,"state": self.stateNameStr,"versionName":version  ,"commodity":self.commodityNameStr]  as? NSDictionary
        }
        
        
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
                            if let arr = dictionResult.value(forKey: "mandiPricesByStateAndMarketAndCommodities") as? NSArray{
                                
                                self.noCommodityDetailsToDisplayLbl.isHidden = true
                                self.commoditiesDetailsArray = arr//resultDictionary.value(forKey: "records") as! NSArray
                                print("JSON: \(self.commoditiesDetailsArray)")
                                DispatchQueue.main.async {
                                    self.commodityDetailsTblView.reloadData()
                                }
                            }
                            else{
                                self.noCommodityDetailsToDisplayLbl.isHidden = false
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

extension CommodityDetailsViewController :  UITableViewDataSource, UITableViewDelegate{
    //MARK: dropdown tableview datasource & delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commoditiesDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CommodityDetailsCell"
        let cell = commodityDetailsTblView.dequeueReusableCell(withIdentifier: cellIdentifier)
        //cell?.backgroundColor = UIColor.clear
        let arrivalDateLbl : UILabel = cell!.viewWithTag(400) as! UILabel
        let commodityLbl : UILabel = cell!.viewWithTag(401) as! UILabel
        let districtLbl : UILabel = cell!.viewWithTag(402) as! UILabel
        let marketLbl : UILabel = cell!.viewWithTag(403) as! UILabel
        let maxPriceLbl : UILabel = cell!.viewWithTag(404) as! UILabel
        let minPriceLbl : UILabel = cell!.viewWithTag(405) as! UILabel
        let modalPriceLbl : UILabel = cell!.viewWithTag(406) as! UILabel
        let stateLbl : UILabel = cell!.viewWithTag(407) as! UILabel
        let varietyLbl : UILabel = cell!.viewWithTag(408) as! UILabel
        
        let outerView : UIView = cell!.viewWithTag(409)!
        //outerView.backgroundColor = UIColor.lightText
        outerView.layer.borderWidth = 0.2
        outerView.layer.cornerRadius = 5.0
        outerView.layer.borderColor = UIColor.lightGray.cgColor
        outerView.layer.masksToBounds = false
        //outerView.layer.shadowOffset = CGSize.init(width: 0.2, height: 0.2)
        //outerView.layer.shadowRadius = 0.3
        //outerView.layer.shadowOpacity = 0.5
        //outerView.alpha = 0.7
        
        if let arrivalDate = (commoditiesDetailsArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "lastUpdateTime") as? String{
            let arrivalDateArr = arrivalDate.components(separatedBy: "T")
            if arrivalDateArr.count > 0{
                arrivalDateLbl.text = arrivalDateArr[0]
            }
        }
        //arrivalDateLbl.text = (commoditiesDetailsArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "arrival_date") as? String ?? "-"
        commodityLbl.text = (commoditiesDetailsArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "commodity") as? String ?? "-"
        // commodityLblCount = (commodityLbl.text?.characters.count)!
        // print("commodity Lbl count :\(commodityLblCount)")
        districtLbl.text = (commoditiesDetailsArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "district") as? String ?? "-"
        marketLbl.text = (commoditiesDetailsArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "market") as? String ?? "-"
        //marketLblCount = (marketLbl.text?.characters.count)!
        //maxPriceLbl.text = (commoditiesDetailsArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "max_price") as? String
        if let maxPrice = (commoditiesDetailsArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "max_price") as? Int {
            maxPriceLbl.text = String(format: "%d",maxPrice)
        }
        else{
            maxPriceLbl.text = (commoditiesDetailsArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "max_price") as? String ?? "-"
        }
        //minPriceLbl.text = (commoditiesDetailsArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "min_price") as? String ?? "-"
        if let minPrice = (commoditiesDetailsArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "min_price") as? Int {
            minPriceLbl.text = String(format: "%d",minPrice)
        }
        else{
            minPriceLbl.text = (commoditiesDetailsArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "min_price") as? String ?? "-"
        }
        //modalPriceLbl.text = (commoditiesDetailsArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "modal_price") as? String ?? "-"
        if let modalPrice = (commoditiesDetailsArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "modal_price") as? Int {
            modalPriceLbl.text = String(format: "%d",modalPrice)
        }
        else{
            modalPriceLbl.text = (commoditiesDetailsArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "modal_price") as? String ?? "-"
        }
        stateLbl.text = (commoditiesDetailsArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "state") as? String ?? "-"
        varietyLbl.text = (commoditiesDetailsArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "variety") as? String ?? "-"
        
        return cell!
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //
    //        print("market Lbl count :\(marketLblCount)")
    //        print("commodity Lbl count :\(commodityLblCount)")
    //
    //        if marketLblCount < 27 && commodityLblCount < 27{
    //
    //        return 295
    //        }
    //
    //        return 310
    //    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return UITableViewAutomaticDimension
    //    }
    
    //func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //    return 400
    //}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //
    //        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)){
    //            cell.separatorInset = UIEdgeInsets.zero
    //        }
    //        if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
    //            cell.preservesSuperviewLayoutMargins = false
    //        }
    //        if cell.responds(to: #selector(setter: UIView.layoutMargins)){
    //            cell.layoutMargins = UIEdgeInsets.zero
    //        }
    //    }
}
