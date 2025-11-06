//
//  CropsHomeViewController.swift
//  FarmerConnect
//
//  Created by Admin on 12/02/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class CalculatorHomeViewController: BaseViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var cropCalLbl: UILabel!
    @IBOutlet var collectionCrops : UICollectionView?
    var arrCrops : NSArray = ([["Image":"Corn","Crop":"Corn"],["Image":"Rice","Crop":"Rice"],["Image":"Millet","Crop":"Millet"],["Image":"Mustard","Crop":"Mustard"]] as NSArray?)!
    var isFromHome : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.recordScreenView("CalculatorHomeViewController", Select_Calculator)
        self.registerFirebaseEvents(PV_Select_Calculator, "", "", Select_Calculator, parameters: nil)
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
            
            "eventName": Home_Calculator,
            "className":"CalculatorhomeViewController",
            "moduleName":"Calculator",
            
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

        cropCalLbl.text = "select_your_crop".localized
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.topView?.isHidden = false
        self.lblTitle?.text = NSLocalizedString("crop_calculator", comment: "")
        if isFromHome == false {
            self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
        }
    }
    
    //MARK: collectionView datasource and delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCrops.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width-15)/2, height: (collectionView.frame.size.width-15)/2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5)//top,left,bottom,right
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cell = self.cropDiagnosisCollView.dequeueReusableCell(withReuseIdentifier: "CropDiagnosisCell", for: indexPath)
        
        let cellIdentifier = "CropCalculatorCell"
        
        let cell = collectionCrops?.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        let cropDic = arrCrops.object(at: indexPath.row) as? NSDictionary
        let cropImg = cell?.contentView.viewWithTag(100) as! UIImageView
        cropImg.image = UIImage(named:cropDic?.value(forKey: "Image") as! String)
        let cropNameLbl = cell?.contentView.viewWithTag(101) as! UILabel
        let cropName = cropDic?.value(forKey: "Crop") as? String
        
        if cropName?.lowercased() == "corn"{
            cropNameLbl.text = NSLocalizedString("corn", comment: "")
        }else if cropName?.lowercased() == "millet"{
            cropNameLbl.text = NSLocalizedString("millet", comment: "")
        }else if cropName?.lowercased() == "rice"{
            cropNameLbl.text = NSLocalizedString("rice", comment: "")
        }else if cropName?.lowercased() == "mustard"{
            cropNameLbl.text = NSLocalizedString("mustard", comment: "")
        }
            
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cropDic = arrCrops.object(at: indexPath.row) as? NSDictionary
        let calculatorController = CropCalcViewController(nibName: "CropCalcViewController", bundle: nil)
        calculatorController.selectedCrop = cropDic?.value(forKey: "Crop") as? String
        let userObj = Constatnts.getUserObject()
        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,PINCODE:userObj.pincode ?? "",CROP:calculatorController.selectedCrop!] as [String : Any]
        self.registerFirebaseEvents(Select_Calculator_Crop, "", "", Select_Calculator, parameters: fireBaseParams as NSDictionary)
        self.navigationController?.pushViewController(calculatorController, animated: true)
    }
    
    override func backButtonClick(_ sender: UIButton) {
        if isFromHome == true {
            self.navigationController?.popViewController(animated: true)
        }
        else{
            self.findHamburguerViewController()?.showMenuViewController()
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
