//
//  MandisAndCropsDashboard.swift
//  PioneerEmployee
//
//  Created by Empover on 11/09/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import UIKit
import CoreImage
import Alamofire

class MandisAndCropsDashboard: BaseViewController {
    var isFromHome : Bool = false
    @IBOutlet weak var bymandisLbl: UILabel!
    @IBOutlet weak var bycropsLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblTitle?.text = NSLocalizedString("mandi_prices", comment: "")    //"MANDI_PRICES"
        self.recordScreenView("MandisAndCropsDashboard", Mandi_Prices)
        self.registerFirebaseEvents(PV_Mandi_Prices, "", "", Mandi_Prices, parameters:nil)
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
            
            "eventName": Home_mandiPrices,
            "className":"MandiAndCropsDashboard",
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
        bymandisLbl.text = "bymandis".localized
        bycropsLbl.text = "bycrops".localized
        self.topView?.isHidden = false
        if isFromHome {
            self.backButton?.setImage(UIImage(named: "Back"), for: UIControlState())

        }else{
            self.backButton?.setImage(UIImage(named: "Menu"), for: UIControlState())
        }
    }
    
    override func backButtonClick(_ sender: UIButton) {
        if isFromHome {
            self.navigationController?.popViewController(animated: true)
        }else{
            self.findHamburguerViewController()?.showMenuViewController()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func mandisBtn_Touch_Up_Inside(_ sender: Any) {
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            let toCitiesVC = self.storyboard?.instantiateViewController(withIdentifier: "CitiesViewController") as! CitiesViewController
            toCitiesVC.isComingFromCropsVC = false
            self.navigationController?.pushViewController(toCitiesVC, animated: true)
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
        self.registerFirebaseEvents(By_Mandis, "", "", Mandi_Prices, parameters:nil)
    }
    
    @IBAction func cropsBtn_Touch_Up_Inside(_ sender: Any) {
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
        let toCropsVC = self.storyboard?.instantiateViewController(withIdentifier: "CropsViewController")
        self.navigationController?.pushViewController(toCropsVC!, animated: true)
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
        self.registerFirebaseEvents(By_Crops, "", "", Mandi_Prices, parameters:nil)
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
