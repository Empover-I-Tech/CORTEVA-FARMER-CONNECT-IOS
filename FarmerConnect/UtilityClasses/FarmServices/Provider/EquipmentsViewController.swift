//
//  EquipmentsViewController.swift
//  FarmerConnect
//
//  Created by Admin on 19/12/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class EquipmentsViewController: ProviderBaseViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionEquipments : UICollectionView?
    var arrEquipments : NSMutableArray?
    var ordersButton = UIButton()
    var isFromHome = false
    var lblMyOrdersCount : UILabel?
    var rejectEquipmentAlert : UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        arrEquipments = NSMutableArray()
        ordersButton = UIButton(frame: CGRect(x:UIScreen.main.bounds.size.width-45,y: 5,width: 40,height: 40))
        ordersButton.backgroundColor =  UIColor.clear
        ordersButton.setImage( UIImage(named: "Cart"), for: UIControlState())
        ordersButton.addTarget(self, action: #selector(EquipmentsViewController.ordersButtonClick(_:)), for: UIControlEvents.touchUpInside)
        self.topView?.addSubview(ordersButton)
        
        lblMyOrdersCount = UILabel(frame: CGRect(x: UIScreen.main.bounds.size.width - 23, y: 2, width: 22, height: 22))
        lblMyOrdersCount?.font = UIFont.systemFont(ofSize: 11.0)
        lblMyOrdersCount?.textAlignment = .center
        lblMyOrdersCount?.backgroundColor = UIColor(red: 255.0/255.0, green: 176.0/255.0, blue: 14.0/255.0, alpha: 1.0)
        lblMyOrdersCount?.cornerRadius = 11
        lblMyOrdersCount?.isHidden = true
        self.topView?.addSubview(lblMyOrdersCount!)
        self.recordScreenView("EquipmentsViewController", FSP_Equipments)
        self.registerFirebaseEvents(PV_FSP_Equipments, "", "", "", parameters: nil)
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
            
            "eventName": Home_Provider,
            "className":"EquipmentsViewController",
            "moduleName":"Provider",
            
            "healthCardId":"",
            "productId":"",
            "cropId":"",
            "seasonId":"",
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
        if #available(iOS 10.0, *) {
            self.automaticallyAdjustsScrollViewInsets = true
        }
        super.viewWillAppear(animated)
        self.showCartButton(false)
        if isFromHome == false {
            self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
        }
        self.topView?.isHidden = false
        self.lblTitle?.text = NSLocalizedString("provider", comment: "")
        self.lblTitle?.font = UIFont.boldSystemFont(ofSize: 17)
        self.hideFilterButton(true)
        self.hideClearButton(true)
        self.arrEquipments?.removeAllObjects()
        lblMyOrdersCount?.isHidden = true
        self.getUserAddedEquipmentsList()
    }
    
    func getUserAddedEquipmentsList(){
        let headers : HTTPHeaders = self.getProviderHeaders()
        print(headers)
        SwiftLoader.show(animated: true)
        let urlString = String(format: "%@%@", arguments: [BASE_URL,Get_Equipment_List])
        let parameteers = ["customerId":Constatnts.getCustomerId()]
        let paramsStr = Constatnts.nsobjectToJSON(parameteers as NSDictionary)
        let params =  ["data" : paramsStr]
        print(params)
        //let parameters = ["mobileNumber":userObj.mobileNumber,"customerId": loggingUser!.customerId,"deviceId":userObj.deviceId!,"countryId":userObj.countryId.integerValue,"deviceType":"iOS"] as NSDictionary
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        /*if let message = (json as! NSDictionary).value(forKey: "message") as? String {
                            self.view.makeToast(message)
                        }*/
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        if let equipmentsArray = Validations.checkKeyNotAvailForArray(decryptData, key: "equipments") as? NSArray{
                            for index in 0..<equipmentsArray.count{
                                if let equipDic = equipmentsArray.object(at: index) as? NSDictionary{
                                    let equipment = Equipment(dict: equipDic)
                                    self.arrEquipments?.add(equipment)
                                }
                            }
                            self.collectionEquipments?.reloadData()
                        }
                        if let unseenCount = Validations.checkKeyNotAvail(decryptData, key: "unSeenCount") as? Int64{
                            if unseenCount > 0{
                                self.lblMyOrdersCount?.isHidden = false
                                self.lblMyOrdersCount?.text = String(format: "%d", unseenCount)
                            }
                        }
                        if let unseenMessage = Validations.checkKeyNotAvail(decryptData, key: "unSeenMessage") as? String{
                        
                        }
                        //print("Response after decrypting data:\(decryptData)")
                    }
                    else{
                        if let message = (json as! NSDictionary).value(forKey: "message") as? String {
                            self.view.makeToast(message)
                            self.arrEquipments?.removeAllObjects()
                            self.collectionEquipments?.reloadData()
                        }
                    }
                }
            }
            else{
                self.view.makeToast((response.error?.localizedDescription)!)
            }
        }
    }
    
    func editOptionsActionSheet(equipment: Equipment){
        //equipment.equipmentClassification! as String
        let farmServicerActionSheet = UIAlertController(title: NSLocalizedString("manage", comment: ""), message: "", preferredStyle: .alert)
        let viewAction = UIAlertAction(title: NSLocalizedString("equipment", comment: ""), style: .default) { (alertAction) in
            let userObj = Constatnts.getUserObject()
            let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId,EQUIPMENT_ID:equipment.equipmentId]
            self.registerFirebaseEvents(FSP_Equipment, "", "", "", parameters: fireBaseParams as NSDictionary)
            let addEquipmentController = self.storyboard?.instantiateViewController(withIdentifier: "ViewEquipmentViewController") as? ViewEquipmentViewController
            //addEquipmentController?.isFromEdit = true
            addEquipmentController?.selectedEquipment = equipment
            self.navigationController?.pushViewController(addEquipmentController!, animated: true)
        }
        let scheduleAction = UIAlertAction(title: NSLocalizedString("schedule", comment: ""), style: .default) { (alertAction) in
            if equipment.status == "Disabled"{
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.makeToast(Equipment_In_DisableMode)
            }
            else{
                let userObj = Constatnts.getUserObject()
                let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId,EQUIPMENT_ID:equipment.equipmentId]
                self.registerFirebaseEvents(FSP_Schedule, "", "", "", parameters: fireBaseParams as NSDictionary)
                let scheduleCalendarController = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleCalanderViewController") as? ScheduleCalanderViewController
                scheduleCalendarController?.selectedEquipment = equipment
                self.navigationController?.pushViewController(scheduleCalendarController!, animated: true)
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .destructive) { (alertAction) in
            
        }
        farmServicerActionSheet.addAction(viewAction)
        farmServicerActionSheet.addAction(scheduleAction)
        farmServicerActionSheet.addAction(cancelAction)
        self.present(farmServicerActionSheet, animated: true, completion: nil)
    }
    //MARK: collectionView datasource and delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.lblWaterMarlLabel?.isHidden = true
        if arrEquipments?.count == 0 {
            self.lblWaterMarlLabel?.isHidden = false
            lblWaterMarlLabel?.text = No_Equipment_Available
        }
        return arrEquipments!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionEquipments?.dequeueReusableCell(withReuseIdentifier: "EquipmentCell", for: indexPath)
        let equipment = arrEquipments?.object(at: indexPath.row) as? Equipment
        let imageView = cell?.viewWithTag(100) as? UIImageView
        let equipmentName = cell?.viewWithTag(101) as? UILabel
        let equipmentStatus = cell?.viewWithTag(102) as? UILabel
        let imageUrl = URL(string: equipment?.image_url! as String? ?? "")
        imageView?.kf.setImage(with: imageUrl as Resource?, placeholder: UIImage(named: "image_placeholder.png"), options: nil, progressBlock: nil)
        equipmentName?.text = equipment?.classification as String?
        equipmentStatus?.text = equipment?.status as String?
        if equipment?.status == "Pending" || equipment?.status == "Not Scheduled" {
            equipmentStatus?.backgroundColor = UIColor(red: 245.0/255, green: 130.0/255, blue: 33.0/255, alpha: 1.0)
        }
        else if equipment?.status == "Disabled"{
            equipmentStatus?.backgroundColor = UIColor.lightGray
        }
        else if equipment?.status == "Rejected"{
            equipmentStatus?.backgroundColor = UIColor.red
        }
        else if equipment?.status == "Scheduled"{
            equipmentStatus?.backgroundColor = App_Theme_Blue_Color
        }
        else if equipment?.status == "Blocked"{
            equipmentStatus?.backgroundColor = UIColor.red
        }
        else{
            equipmentStatus?.backgroundColor = UIColor.red

        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.size.width/2)-30, height: (collectionView.bounds.size.width/2)-30)
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
        let equipment = arrEquipments?.object(at: indexPath.row) as? Equipment
        if equipment?.status == "Rejected" || equipment?.status == "Blocked"{
            if rejectEquipmentAlert != nil{
                self.rejectEquipmentAlert?.removeFromSuperview()
            }
            self.rejectEquipmentAlert = CustomAlert.alertInfoPopUpView(self, frame: self.view.frame, title: equipment?.status as NSString? ?? "" as NSString, message: equipment?.reason as NSString? ?? "" as NSString, buttonTitle: "OK", hideClose: true) as? UIView
            self.view.addSubview(self.rejectEquipmentAlert!)
        }
        else{
            self.editOptionsActionSheet(equipment: equipment!)
        }
    }
    //MARK: Button Click Action Methods
    
    override func backButtonClick(_ sender: UIButton) {
        if isFromHome == true {
            self.navigationController?.popViewController(animated: true)
        }
        else{
            self.findHamburguerViewController()?.showMenuViewController()
        }
    }
    @IBAction func addEquipmentButtonClick(_ sender: UIButton){
        self.registerFirebaseEvents(FSP_Add_Equipment, "", "", "", parameters: nil)
        let addEquipmentController = self.storyboard?.instantiateViewController(withIdentifier: "AddEquipmentViewController") as? AddEquipmentViewController
        self.navigationController?.pushViewController(addEquipmentController!, animated: true)
    }
    @IBAction func ordersButtonClick(_ sender: UIButton){
        self.registerFirebaseEvents(FSP_Cart_Orders, "", "", "", parameters: nil)
        let myordersSegmentController = self.storyboard?.instantiateViewController(withIdentifier: "MyOrdersSegmentViewController") as? MyOrdersSegmentViewController
        self.navigationController?.pushViewController(myordersSegmentController!, animated: true)
    }
    @objc func infoAlertSubmit(){
        
        if self.rejectEquipmentAlert != nil {
            self.rejectEquipmentAlert?.removeFromSuperview()
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
