//
//  RequesterRatingViewController.swift
//  FarmerConnect
//
//  Created by Empover on 10/01/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit
import Alamofire


class RequesterRatingViewController: RequesterBaseViewController {

    @IBOutlet weak var lblFinalRating: UILabel!
    
    @IBOutlet weak var lblRatingsByUser: UILabel!
    
    @IBOutlet weak var progressViewRating1: LinearProgressBar!
    
    @IBOutlet weak var progressViewRating2: LinearProgressBar!
    
    @IBOutlet weak var progressViewRating3: LinearProgressBar!
    
    @IBOutlet weak var progressViewRating4: LinearProgressBar!
    
    @IBOutlet weak var progressViewRating5: LinearProgressBar!
    
    @IBOutlet weak var lblCount1: UILabel!
    
    @IBOutlet weak var lblCount2: UILabel!
    
    @IBOutlet weak var lblCount3: UILabel!
    
    @IBOutlet weak var lblCount4: UILabel!
    
    @IBOutlet weak var lblCount5: UILabel!
    
    @IBOutlet weak var txtFldRatingsType: UITextField!
    
    @IBOutlet weak var tblViewRatings: UITableView!
    
    var maxValue = 0
    
    var arrayToDisplayDataInDropDownTableView = ["Newest First","Positive First","Negative First"]
     var arrayNewestFirst = NSMutableArray()
     var arrayPositive = NSMutableArray()
     var arrayNegative = NSMutableArray()
    
    var finalMutArrayToDisplayData = NSMutableArray()
    
    var jsonDictRatings = NSDictionary()
    
    var ratingsDropDownTblView = UITableView()
    
    var isFromRequesterOrdersVC = false
    var equipmentIDFromRequestOrderVC = ""
    var orders : Order?
    var selectedEquipment : Equipment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        txtFldRatingsType.leftViewMode = .always
        txtFldRatingsType.contentVerticalAlignment = .center
        txtFldRatingsType.setLeftPaddingPoints(10)
        txtFldRatingsType.tintColor = UIColor.clear
        
        txtFldRatingsType.delegate = self
        //ratingsDropDownTblView dropdown tableView
        self.loadDropDownTableView(tableViewDataSource: self, tableViewDelegate: self, tableview: ratingsDropDownTblView, textField: txtFldRatingsType)
        ratingsDropDownTblView.dataSource = self
       ratingsDropDownTblView.delegate = self
        ratingsDropDownTblView.tableFooterView = UIView()
        ratingsDropDownTblView.separatorInset = .zero
        
        tblViewRatings.dataSource = self
        tblViewRatings.delegate = self
        tblViewRatings.tableFooterView = UIView()
        tblViewRatings.separatorInset = .zero
        
        progressViewRating1.barColor = UIColor (red: 153.0/255, green: 153.0/255, blue: 153.0/255, alpha: 1.0)
        progressViewRating2.barColor = UIColor (red: 153.0/255, green: 153.0/255, blue: 153.0/255, alpha: 1.0)
        progressViewRating3.barColor = UIColor (red: 153.0/255, green: 153.0/255, blue: 153.0/255, alpha: 1.0)
        progressViewRating4.barColor = UIColor (red: 153.0/255, green: 153.0/255, blue: 153.0/255, alpha: 1.0)
        progressViewRating5.barColor = UIColor (red: 153.0/255, green: 153.0/255, blue: 153.0/255, alpha: 1.0)
        self.recordScreenView("RequesterRatingViewController", FSR_Ratings_View)
        if isFromRequesterOrdersVC == true{
            if self.orders?.equipmentId != nil{
                self.getEquipmentsDetailsWithEquipmentId(equipment: self.orders?.equipmentId! as String? ?? "")
            }
        }
        else if selectedEquipment != nil{
            self.getEquipmentsDetailsWithEquipmentId(equipment: self.selectedEquipment?.equipmentId! as String? ?? "")
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //var touch: UITouch? = touches.first as? UITouch
        //location is relative to the current view
        // do something with the touched point
        // if touch?.view != yourView {
        ratingsDropDownTblView.isHidden = true
        //}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.topView?.isHidden = false
        self.btnFilter?.isHidden = true
        self.btnCart?.isHidden = true
        self.btnReset?.isHidden = true
        self.lblTitle?.text = ""
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        
        var parameters = ["customerId":Constatnts.getCustomerId()]
        
        if isFromRequesterOrdersVC == true{
            //self.lblTitle?.text = orders.na
            parameters = ["equipmentId":Int(orders?.equipmentId! as String? ?? "")!]
        }
        self.getRequesterRatingsServiceCall(Parameters: parameters)
    }
    
    override func backButtonClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getRequesterRatingsServiceCall(Parameters: [String:Any]){
        let headers : HTTPHeaders = self.getProviderHeaders()
        print(headers)
        SwiftLoader.show(animated: true)
        var urlString = String(format: "%@%@", arguments: [BASE_URL,GET_REQUESTER_RATINGS])
        if isFromRequesterOrdersVC == true{
            urlString = String(format: "%@%@", arguments: [BASE_URL,GET_EQUIPMENT_RATINGS])
        }
        
        let paramsStr = Constatnts.nsobjectToJSON(Parameters as NSDictionary)
        let params =  ["data" : paramsStr]
        print(params)
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                       // print(decryptData)
//
//                        do {
//                            let outputDict = try JSONSerialization.data(withJSONObject: decryptData, options: JSONSerialization.WritingOptions.prettyPrinted)
//                            let jsonSTr = NSString(data: outputDict, encoding: String.Encoding.utf8.rawValue)! as String
//                            print(jsonSTr)
//                        }
//                        catch{
//
//                        }
                        self.jsonDictRatings = decryptData
                        
                        if let ratings = self.jsonDictRatings.value(forKey: "ratings") as? Int {
                            print(ratings)
                            self.txtFldRatingsType.text = self.arrayToDisplayDataInDropDownTableView[0]
                            self.finalMutArrayToDisplayData = self.arrayNewestFirst
                            self.tblViewRatings.reloadData()
                        }
                        else{
                            self.arrayNewestFirst.addObjects(from: decryptData.value(forKey: "ratings") as! [Any])
                            self.arrayPositive.addObjects(from: decryptData.value(forKey: "positiveRating") as! [Any])
                            self.arrayNegative.addObjects(from: decryptData.value(forKey: "negativeRating") as! [Any])
                            
                            self.updateUI()
                        }
                    }
                    else if responseStatusCode == STATUS_CODE_601{
                        Constatnts.logOut()
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    }
                }
            }
            else{
                self.view.makeToast((response.error?.localizedDescription)!)
            }
        }
    }
    
    func getEquipmentsDetailsWithEquipmentId(equipment:String){
        let headers : HTTPHeaders = self.getProviderHeaders()
        print(headers)
        SwiftLoader.show(animated: true)
        let urlString = String(format: "%@%@", arguments: [BASE_URL,View_Equipment_Details])
       
        let parameters = ["equipmentId":equipment,"isProvider": "false"] as [String : Any]
        let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
        let params =  ["data" : paramsStr]
        print(params)
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        //print("Response after decrypting data:\(decryptData)")
                        if let equipDic = decryptData as NSDictionary?{
                            self.selectedEquipment = Equipment(dict: equipDic)
                            if self.selectedEquipment != nil {
                                self.lblTitle?.text = String(format: "%@-%@", (self.selectedEquipment?.equipmentClassification)!,(self.selectedEquipment?.model)!)
                            }
                        }
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
    
    func updateUI(){
        
        if let finalRating = self.jsonDictRatings.value(forKey: "totalRating") as? String {
            lblFinalRating.text = finalRating
        }
        
        if let finalRating1 = self.jsonDictRatings.value(forKey: "totalRating") as? Float {
            lblFinalRating.text = String(format:"%.1f",finalRating1)
        }
        
       // lblFinalRating.text = String(format:"%.1f",(self.jsonDictRatings.value(forKey: "totalRating") as? Float)!)
        lblRatingsByUser.text = String(format:"Ratings by user : %d",(self.jsonDictRatings.value(forKey: "ratingsByUsers") as? Int)!)
        
        let rate1 = self.jsonDictRatings.value(forKey: "rate1")! as! Int
        let rate2 = self.jsonDictRatings.value(forKey: "rate2")! as! Int
        let rate3 = self.jsonDictRatings.value(forKey: "rate3")! as! Int
        let rate4 = self.jsonDictRatings.value(forKey: "rate4")! as! Int
        let rate5 = self.jsonDictRatings.value(forKey: "rate5")! as! Int
        
        lblCount1.text = String(format:"%d",rate1)
        lblCount2.text = String(format:"%d",rate2)
        lblCount3.text = String(format:"%d",rate3)
        lblCount4.text = String(format:"%d",rate4)
        lblCount5.text = String(format:"%d",rate5)
        
        if maxValue < rate1 {
            maxValue = rate1
        }
        
        if maxValue < rate2 {
            maxValue = rate2
        }
        if maxValue < rate3 {
            maxValue = rate3
        }
        if maxValue < rate4 {
            maxValue = rate4
        }
        if maxValue < rate5 {
            maxValue = rate5
        }
        
        progressViewRating1.maximumProgressValue = CGFloat(maxValue)
        progressViewRating2.maximumProgressValue = CGFloat(maxValue)
        progressViewRating3.maximumProgressValue = CGFloat(maxValue)
        progressViewRating4.maximumProgressValue = CGFloat(maxValue)
        progressViewRating5.maximumProgressValue = CGFloat(maxValue)
        
        progressViewRating1.progressValue = CGFloat(rate1)
        progressViewRating2.progressValue = CGFloat(rate2)
        progressViewRating3.progressValue = CGFloat(rate3)
        progressViewRating4.progressValue = CGFloat(rate4)
        progressViewRating5.progressValue = CGFloat(rate5)
        
        if progressViewRating1.progressValue > 0{
            progressViewRating1.barColor = UIColor (red: 255.0/255, green: 0.0/255, blue: 0.0/255, alpha: 1.0)
        }
        if progressViewRating2.progressValue > 0{
            progressViewRating2.barColor = UIColor (red: 255.0/255, green: 126.0/255, blue: 31.0/255, alpha: 1.0)
        }
        if progressViewRating3.progressValue > 0{
            progressViewRating3.barColor = UIColor (red: 34.0/255, green: 119.0/255, blue: 34.0/255, alpha: 1.0)
        }
        if progressViewRating4.progressValue > 0{
            progressViewRating4.barColor = UIColor (red: 34.0/255, green: 119.0/255, blue: 34.0/255, alpha: 1.0)
        }
        if progressViewRating5.progressValue > 0{
            progressViewRating5.barColor = UIColor (red: 34.0/255, green: 119.0/255, blue: 34.0/255, alpha: 1.0)
        }
        
        txtFldRatingsType.text = self.arrayToDisplayDataInDropDownTableView[0]
        
        self.finalMutArrayToDisplayData = self.arrayNewestFirst
        
        self.tblViewRatings.reloadData()
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

extension RequesterRatingViewController : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        ratingsDropDownTblView.isHidden = true
        if textField == txtFldRatingsType{
            txtFldRatingsType.resignFirstResponder()
             ratingsDropDownTblView.isHidden = false
        }
    }
}

extension RequesterRatingViewController : UITableViewDataSource , UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ratingsDropDownTblView{
            return self.arrayToDisplayDataInDropDownTableView.count
        }
        return self.finalMutArrayToDisplayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == ratingsDropDownTblView{
            let cell = ratingsDropDownTblView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
            cell.textLabel?.text = self.arrayToDisplayDataInDropDownTableView[indexPath.row]
            return cell
        }
        else{
            let cell = tblViewRatings.dequeueReusableCell(withIdentifier: "RatingsCell", for: indexPath)
            
            let lblRating = cell.viewWithTag(100) as? UILabel
            let lblRatingGivenBy = cell.viewWithTag(101) as? UILabel
            let lblComments = cell.viewWithTag(102) as? UILabel
            
            lblRating?.text = String(format:"%.1f",(self.finalMutArrayToDisplayData.object(at: indexPath.row) as! NSDictionary).value(forKey: "rating") as! Float)
            
            lblRatingGivenBy?.text = (self.finalMutArrayToDisplayData.object(at: indexPath.row) as! NSDictionary).value(forKey: "ratingBy") as? String
            lblComments?.text = (self.finalMutArrayToDisplayData.object(at: indexPath.row) as! NSDictionary).value(forKey: "comments") as? String

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == ratingsDropDownTblView{
            txtFldRatingsType.text = self.arrayToDisplayDataInDropDownTableView[indexPath.row]
            if indexPath.row == 0{
                 self.finalMutArrayToDisplayData = self.arrayNewestFirst
            }
            else if indexPath.row == 1{
                 self.finalMutArrayToDisplayData = self.arrayPositive
            }
            else{
                 self.finalMutArrayToDisplayData = self.arrayNegative
            }
            ratingsDropDownTblView.isHidden = true
            self.tblViewRatings.reloadData()
            self.reloadFooter()
        }
    }
    
    func reloadFooter(){
        
        if self.finalMutArrayToDisplayData.count > 0{
            tblViewRatings.tableFooterView = UIView()
        }
        else{
            self.addNodetailsFoundLabelFooterToTableView(tableView: tblViewRatings, message: "No reviews available")
        }
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
