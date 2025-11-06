//
//  PSNearByEquipmentsViewController.swift
//  FarmerConnect
//
//  Created by Admin on 02/01/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit
import Kingfisher

class PSNearByEquipmentsViewController: RequesterBaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var tblEquipments : UITableView?
    var arrEquipments : NSArray?
    var loginAlertView = UIView()
    var cropID : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setStatusBarBackgroundColor(color :App_Theme_Blue_Color)
        // Do any additional setup after loading the view.
        tblEquipments?.tableFooterView = UIView()
        tblEquipments?.estimatedRowHeight = 160
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 10.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.topView?.isHidden = false
        self.lblTitle?.text = NSLocalizedString("equipment_list", comment: "")     //"Equipment List"
        if arrEquipments?.count == 0{
            self.lblWaterMarlLabel?.isHidden = false
            self.lblWaterMarlLabel?.text = "No Equipments Found."
        }
        else{
            self.lblWaterMarlLabel?.isHidden = true
            self.lblWaterMarlLabel?.text = ""
        }
        self.recordScreenView("PSNearByEquipmentsViewController", FSR_Equipment_List)
        self.registerFirebaseEvents(PV_FSR_Equipment_List, "", "", "", parameters: nil)
        self.setStatusBarBackgroundColor(color :App_Theme_Blue_Color)
    }
    //MARK: UITableview delegate and datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrEquipments != nil {
            return (arrEquipments?.count)!
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier =  "EquipmentCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let equipment = arrEquipments?.object(at: indexPath.row) as? Equipment
        let imgEquipment = cell.viewWithTag(100) as? UIImageView
        let lblServiceArea = cell.viewWithTag(101) as? UILabel
        let lblClassification = cell.viewWithTag(102) as? UILabel
        let lblModel = cell.viewWithTag(107) as? UILabel
        let btnDate1 = cell.viewWithTag(103) as? UIButton
        let btnDate2 = cell.viewWithTag(104) as? UIButton
        let btnDate3 = cell.viewWithTag(105) as? UIButton
        let btnDate4 = cell.viewWithTag(106) as? UIButton
        btnDate1?.backgroundColor = UIColor.red
        btnDate2?.backgroundColor = UIColor.red
        btnDate3?.backgroundColor = UIColor.red
        btnDate4?.backgroundColor = UIColor.red
        
        let imageUrl = URL(string: equipment?.equipImage! as String? ?? "")
        imgEquipment?.kf.setImage(with: imageUrl as Resource?, placeholder: UIImage(named: "image_placeholder.png"), options: nil, progressBlock: nil)
        lblServiceArea?.text = equipment?.serviceAreaDistance as String?
        lblModel?.text = equipment?.model as String?
        lblClassification?.text = equipment?.classification as String?
        var string = equipment?.requestedDates
        string = string?.replacingOccurrences(of: " ", with: "") as NSString?
        if Validations.isNullString(string ?? "") == false{
            if let arrAvailableDates = self.getAvailabledates(equipment!) as NSArray?{
                if let arrAvailable = string?.components(separatedBy: ",") as NSArray?{
                    if arrAvailable.count > 0{
                        if let dateStr = arrAvailable.object(at: 0) as? String{
                            let day = self.getDayOfWeek(today: dateStr)
                            btnDate1?.setTitle(String(format: "%02d", day), for: .normal)
                            if arrAvailableDates.contains(dateStr) == true{
                                btnDate1?.backgroundColor = App_Theme_Blue_Color
                            }
                        }
                    }
                    if arrAvailable.count > 1{
                        if let dateStr = arrAvailable.object(at: 1) as? String{
                            let day = self.getDayOfWeek(today: dateStr)
                            btnDate2?.setTitle(String(format: "%02d", day), for: .normal)
                            if arrAvailableDates.contains(dateStr) == true{
                                btnDate2?.backgroundColor = App_Theme_Blue_Color
                            }
                        }
                    }
                    if arrAvailable.count > 2{
                        if let dateStr = arrAvailable.object(at: 2) as? String{
                            let day = self.getDayOfWeek(today: dateStr)
                            btnDate3?.setTitle(String(format: "%02d", day), for: .normal)
                            if arrAvailableDates.contains(dateStr) == true{
                                btnDate3?.backgroundColor = App_Theme_Blue_Color
                            }
                        }
                    }
                    if arrAvailable.count > 3{
                        if let dateStr = arrAvailable.object(at: 3) as? String{
                            let day = self.getDayOfWeek(today: dateStr)
                            btnDate4?.setTitle(String(format: "%02d", day), for: .normal)
                            if arrAvailableDates.contains(dateStr) == true{
                                btnDate4?.backgroundColor = App_Theme_Blue_Color
                            }
                        }
                    }
                }
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let selectEquipment = arrEquipments?.object(at: indexPath.row) as? Equipment{
            if selectEquipment.equipmentClassificationId == "5" {
                if selectEquipment.sprayRequestDone == true && selectEquipment.billUploadDone == true {
                    let userObj = Constatnts.getUserObject()
                    let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber,USER_ID:userObj.customerId,EQUIPMENT_ID:selectEquipment.equipmentId]
                    self.registerFirebaseEvents(FSR_EquipmentList_BookNow, "", "", "", parameters: firebaseParams as NSDictionary)
                    self.navigateToBookNowController(selectEquipment)
                }
                else if !(selectEquipment.sprayRequestDone)! {
                    let notYetSubscribedMessage = NSLocalizedString("Not_yet_subscribe_to_Spray_servcies_message", comment: "")
                    self.loginAlertView = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: NSLocalizedString("alert", comment: "") as NSString, message: notYetSubscribedMessage as NSString, okButtonTitle: NSLocalizedString("Subscribe", comment: ""), cancelButtonTitle: NSLocalizedString("cancel", comment: "")) as! UIView
                    self.view.addSubview(self.loginAlertView)
                    
                    //                    let alertController = UIAlertController(title: "Alert!", message: "You have not yet subscribe to Spray servcies. Please subscribe to avail.", preferredStyle: .alert)
                    
                    //                          let backButtonAction = UIAlertAction(title: "OK", style: .cancel, handler: {
                    //                              alert -> Void in
                    //                              let SprayServiceVC = self.storyboard?.instantiateViewController(withIdentifier: "SprayServiceViewController") as? SprayServiceViewController
                    //                              self.navigationController?.pushViewController(SprayServiceVC!, animated: true)
                    //                          })
                    //                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    //                          alertController.addAction(backButtonAction)
                    //                         alertController.addAction(cancelAction)
                    //                          self.present(alertController, animated: true, completion: nil)
                    
                }else if !(selectEquipment.billUploadDone)! {
                    let notYetPuchasedMessage =  NSLocalizedString("Not_yet_done_purchase_register", comment: "")
                    self.loginAlertView = CustomAlert.alertNewPopView(self, frame: self.view.frame, title:NSLocalizedString("alert", comment: "") as NSString, message: notYetPuchasedMessage as NSString , okButtonTitle: NSLocalizedString("go_home", comment: ""), cancelButtonTitle: NSLocalizedString("cancel", comment: "")) as! UIView
                    self.view.addSubview(self.loginAlertView)
                    
                    
                    //                    let alertController = UIAlertController(title: "Alert!", message: "You are not yet done purchase register.Please go to home and genunity check to register", preferredStyle: .alert)
                    //
                    //                    let backButtonAction = UIAlertAction(title: "OK", style: .cancel, handler: {
                    //                        alert -> Void in
                    //                        let RetailerInformationVC = self.storyboard?.instantiateViewController(withIdentifier: "RetailerInformationViewController") as? RetailerInformationViewController
                    //                        self.navigationController?.pushViewController(RetailerInformationVC!, animated: true)
                    //                    })
                    //                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    //                    alertController.addAction(backButtonAction)
                    //                    alertController.addAction(cancelAction)
                    //                    self.present(alertController, animated: true, completion: nil)
                    
                }
            } else {
                let userObj = Constatnts.getUserObject()
                let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber,USER_ID:userObj.customerId,EQUIPMENT_ID:selectEquipment.equipmentId!]
                self.registerFirebaseEvents(FSR_Available_Date_selection, "", "", "", parameters: fireBaseParams as NSDictionary)
                let bookNowController = self.storyboard?.instantiateViewController(withIdentifier: "PSBookNowViewController") as? PSBookNowViewController
                bookNowController?.selectedEquipId = selectEquipment.equipmentId as String?
                bookNowController?.cropId = cropID
                bookNowController?.isFromBookingStages = isFromBookingStages
                bookNowController?.isFromProvider = false
                bookNowController?.isFromEditOrder = false
                self.navigationController?.pushViewController(bookNowController!, animated: true)
            }
            
            
        }
    }
    //MARK: popUpNoBtnAction
    @objc func popUpNoBtnAction(){
        loginAlertView.removeFromSuperview()
    }
    //MARK: popUpYesBtnAction

    @objc func popUpYesBtnAction(){
        loginAlertView.removeFromSuperview()
        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
             self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
    }
    @objc func alertYesBtnAction(){
        loginAlertView.removeFromSuperview()
              let SprayServiceVC = self.storyboard?.instantiateViewController(withIdentifier: "SprayServiceViewController") as? SprayServiceViewController
              self.navigationController?.pushViewController(SprayServiceVC!, animated: true)
    }
    
    //MARK: alertNoBtnAction
    /**
     NO button action of the alertView which is displayed to the user
        */
    @objc func alertNoBtnAction(){
        loginAlertView.removeFromSuperview()
    }
    func getAvailabledates(_ equipmentObj: Equipment) -> NSArray?{
        let arrAvailableDates : NSArray?
        var string = equipmentObj.availableDates
        string = string?.replacingOccurrences(of: " ", with: "") as NSString?
        if Validations.isNullString(string ?? "") == false{
            if let arrAvailable = string?.components(separatedBy: ",") as NSArray?{
                arrAvailableDates = arrAvailable
                return arrAvailableDates
            }
        }
        return nil
    }
    func getDayOfWeek(today:String)->Int {
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.date(from: today)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.day, from: todayDate)
        let weekDay = myComponents.day
        return weekDay!
    }
    override func backButtonClick(_ sender: UIButton) {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func bookNowButtonClick(_ sender: UIButton){
        let buttonPosition = sender.convert(CGPoint(x:0,y:0), to: self.tblEquipments)
        let indexPath = self.tblEquipments!.indexPathForRow(at: buttonPosition)
        if indexPath != nil {
            if let selectEquipment = arrEquipments?.object(at: (indexPath?.row)!) as? Equipment{
                let userObj = Constatnts.getUserObject()
                let fireBaseParams = [MOBILE_NUMBER: userObj.mobileNumber!,USER_ID: userObj.customerId ?? "",EQUIPMENT_ID:selectEquipment.equipmentId!] as [String : Any]
                self.registerFirebaseEvents(FSR_Available_Date_selection, "", "", "", parameters: fireBaseParams as NSDictionary)
                self.navigateToBookNowController(selectEquipment)
            }
        }
    }
    
    func navigateToBookNowController(_ selectEquipment: Equipment){
        let bookNowController = self.storyboard?.instantiateViewController(withIdentifier: "PSBookNowViewController") as? PSBookNowViewController
        bookNowController?.selectedEquipId = selectEquipment.equipmentId as String?
        bookNowController?.isFromProvider = false
        bookNowController?.isFromEditOrder = false
        bookNowController?.cropId = cropID
         bookNowController?.isFromBookingStages = isFromBookingStages
        self.navigationController?.pushViewController(bookNowController!, animated: true)
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
