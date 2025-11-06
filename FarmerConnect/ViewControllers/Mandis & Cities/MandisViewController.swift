//
//  MandisViewController.swift
//  MandisData
//
//  Created by Empover on 28/08/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import UIKit
import Alamofire

class MandisViewController: BaseViewController {

    ///string to store state name
    var stateNameStr : String!
    
    ///final markets array to populate the data in tableView
    var marketsArray = NSMutableArray()
    var offset : NSInteger = 0
    var count : NSInteger = 0
    
    @IBOutlet weak var noMandisToDisplayLbl: UILabel!
    
    @IBOutlet weak var marketsTblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        marketsTblView.dataSource = self
        marketsTblView.delegate = self
        marketsTblView.tableFooterView = UIView()
        marketsTblView.separatorColor = UIColor.black
        
        let backButton = UIBarButtonItem()
        backButton.title = stateNameStr
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        noMandisToDisplayLbl.isHidden = true
        //let urlStr = String.init(format: "%@&filters[state]=%@&Offset=%d&fields=market&limit=100&sort[id]=asc", Main_URL,stateNameStr.replacingOccurrences(of: " ", with: "%20"),offset)
//        let urlStr = String.init(format: "%@&filters[state]=%@&Offset=%d&fields=market&limit=100", Main_URL,stateNameStr.replacingOccurrences(of: " ", with: "%20"),offset)
        //print("url :\(urlStr)")
    //    self.getMarketsFromCity(urlStr: urlStr)
         self.getMarketsFromCity()
        self.recordScreenView("MandisViewController", Mandis_List)
        let userObj = Constatnts.getUserObject()
        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,STATE:stateNameStr] as [String : Any]
        self.registerFirebaseEvents(PV_Mandis_List, "", "", Mandis_List, parameters:fireBaseParams as NSDictionary)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.topView?.isHidden = false
        lblTitle?.text = stateNameStr
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
    }
    
    override func backButtonClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: getMarketsFromCity
    /**
     Get Markets data from the state selected in CitiesVC
     */
    func getMarketsFromCity (){
        
        let urlStr = BASE_URL + GET_MANDIES
        
        let userObj = Constatnts.getUserObject()
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! NSString
        
           let  parameters = ["deviceType":"iOS","empId":userObj.customerId! as String,"mobileNumber":userObj.mobileNumber! as String,"state": self.stateNameStr,"versionName":version] as? NSDictionary
 
        let headers = Constatnts.getLoggedInFarmerHeaders()
//        let paramsStr = Constatnts.nsobjectToJSON(parameters as! NSDictionary)
       
        
     
        
        let paramsStr = Constatnts.encryptInputParams(parameters: parameters!)
         let params =  ["data" : paramsStr]
        
        print(params)
        
        SwiftLoader.show(animated: true)
        Alamofire.request(urlStr, method: .post, parameters: params , encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    if Validations.isNullString(((json as! NSDictionary).value(forKey: "response") as! NSString).replacingOccurrences(of: "\\", with: "") as NSString) == false{
                        let respData = ((json as! NSDictionary).value(forKey: "response") as! NSString).replacingOccurrences(of: "\\", with: "")
                        if let tempResult = Constatnts.convertToDictionary(text: respData as String) as NSDictionary?{
                            print(respData)
                            
                            let dictionResult = tempResult
                            if let arr = dictionResult["mandiPricesMarkets"] as? NSArray{
                                if arr.count > 0{
                                    self.noMandisToDisplayLbl.isHidden = true
                                    //print("JSON: \(resultDictionary.value(forKey: "records") as! NSArray)")
                                    //                            self.count = dictionResult.value(forKey: "count") as! NSInteger
                                    let recordsArray = arr//resultDictionary.value(forKey: "records") as! NSArray
                                    let marketsNewMutArray = NSMutableArray()
                                    
                                    for i in (0..<recordsArray.count){
                                        let marketName = (recordsArray[i] as! NSDictionary).value(forKey: "market") as! String
                                        self.marketsArray.add(marketName)
                                        if self.offset > 0{
                                            marketsNewMutArray.add(marketName)
                                        }
                                    }
                                    
                                    let marketsNamesSet =  NSSet(array:self.marketsArray as! [Any])
                                    self.marketsArray.removeAllObjects()
                                    
                                    //sorting the array in ascending order
                                    let sortedMarketsArray = marketsNamesSet.allObjects.sorted { ($0 as AnyObject).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
                                    self.marketsArray.addObjects(from: sortedMarketsArray)
                                    
                                    //storing the data in the new array
                                    if self.offset > 0{
                                        // marketsNewMutArray = NSMutableArray (array: Constatnts.uniqueElementsFrom(array: (marketsNewMutArray ) as! [String]) as! NSMutableArray)
                                        let marketsNamesSet =  NSSet(array:marketsNewMutArray as! [Any])
                                        marketsNewMutArray.removeAllObjects()
                                        marketsNewMutArray.addObjects(from: marketsNamesSet.allObjects)
                                        //print("marketsNewMutArray :\(marketsNewMutArray)")
                                    }
                                    if self.containSameElements(firstArray: self.marketsArray as! [String], secondArray: marketsNewMutArray as! [String]) == true{
                                        //print("contains same elements in both array's")
                                    }
                                    else {
                                        self.marketsTblView.reloadData()
                                    }
                                }
                                else{
                                    if self.marketsArray.count == 0{
                                        self.noMandisToDisplayLbl.isHidden = false
                                    }
                                }
                            } else{
                                if self.marketsArray.count == 0{
                                    self.noMandisToDisplayLbl.isHidden = false
                                }
                            }
                        }
                        
                    }
                }
            }
            else{
                self.view.makeToast((response.result.error?.localizedDescription)!, duration: 1.0, position: .center)
                return
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

extension MandisViewController :  UITableViewDataSource, UITableViewDelegate{
    //MARK: dropdown tableview datasource & delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marketsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MarketsCell"
        //let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        let cell = marketsTblView.dequeueReusableCell(withIdentifier: cellIdentifier)
        cell?.backgroundColor = UIColor.clear
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        let marketNameLbl : UILabel = cell!.viewWithTag(200) as! UILabel
        marketNameLbl.text = marketsArray.object(at: indexPath.row) as? String
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
        let toCommoditiesVC  = self.storyboard?.instantiateViewController(withIdentifier: "CommoditiesViewController") as! CommoditiesViewController
        toCommoditiesVC.marketNameStr = marketsArray.object(at: indexPath.row) as? String
        toCommoditiesVC.stateNameStr = stateNameStr
            let userObj = Constatnts.getUserObject()
            let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,STATE:stateNameStr,Market:toCommoditiesVC.marketNameStr] as [String : Any]
            self.registerFirebaseEvents(Mandi_State_Market, "", "", Mandis_List, parameters: fireBaseParams as NSDictionary)
        self.navigationController?.pushViewController(toCommoditiesVC, animated: true)
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
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
        print("indexpath row :\(indexPath.row)")
        if indexPath.row == marketsArray.count - 2 {
            if self.count >= 100 {
                offset+=1
                //print("offset value :\(offset)")//&sort[id]=asc
                let urlStr = String.init(format: "%@&filters[state]=%@&Offset=%d&fields=market&limit=100", Main_URL,stateNameStr.replacingOccurrences(of: " ", with: "%20"),offset)
               // print("url :\(urlStr)")
                self.getMarketsFromCity()
            }
        }
    }
}

extension MandisViewController {
    func containSameElements( firstArray: [String], secondArray: [String]) -> Bool {
        var secondArray = secondArray
        var firstArray = firstArray
        if firstArray.count != secondArray.count {
            return false
        }
        else {
            firstArray.sort()
            secondArray.sort()
            return firstArray == secondArray
        }
    }
}
