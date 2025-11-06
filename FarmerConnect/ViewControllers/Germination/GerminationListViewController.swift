//
//  GerminationListViewController.swift
//  FarmerConnect
//
//  Created by Empover on 24/07/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit
import Alamofire

class GerminationListViewController: BaseViewController {

    @IBOutlet weak var tblViewGermination: UITableView!
    var germinationList: GerminationList?
    var isFromHome :Bool = false
    var germinationListArray:NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tblViewGermination.dataSource = self
        tblViewGermination.delegate = self
        tblViewGermination.tableFooterView = UIView()
        tblViewGermination.separatorStyle = .none
        print(germinationListArray!)
        
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
            
            "eventName": Home_Germination,
            "className":"GerminationAgreementViewController",
            "moduleName":"Germination",
            
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
        if #available(iOS 10.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.topView?.isHidden = false
        lblTitle?.text = "Germination"
        if isFromHome == false {
            self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
        }
        else{
            self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        }
    }
    
    override func backButtonClick(_ sender: UIButton) {
        if isFromHome == false {
            self.findHamburguerViewController()?.showMenuViewController()
        }
        else{
            self.navigationController?.popViewController(animated: true)
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

extension GerminationListViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.germinationListArray?.count)! > 0{
            return (self.germinationListArray?.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblViewGermination.dequeueReusableCell(withIdentifier: "GerminationListCell", for: indexPath)
        let germinationCell = self.germinationListArray?.object(at: indexPath.row) as? GerminationList
        
        let lblYear = cell.viewWithTag(100) as! UILabel
        let lblSeason = cell.viewWithTag(101) as! UILabel
        let lblCrop = cell.viewWithTag(102) as! UILabel
        let lblStatus = cell.viewWithTag(103) as! UILabel
        
        lblYear.text = germinationCell?.year
        lblSeason.text = germinationCell?.seasonName
        lblCrop.text = germinationCell?.cropName
        lblStatus.text = germinationCell?.status
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let germinationCell = self.germinationListArray?.object(at: indexPath.row) as? GerminationList
        if germinationCell?.status == STATUS_AGREEMENT_PENDING{
            let toGerminationVC = self.storyboard?.instantiateViewController(withIdentifier: "GerminationAgreementViewController") as? GerminationAgreementViewController
            toGerminationVC?.isFromHome = true
            toGerminationVC?.germinationModelObj = germinationCell
            self.navigationController?.pushViewController(toGerminationVC!, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 146.0
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
