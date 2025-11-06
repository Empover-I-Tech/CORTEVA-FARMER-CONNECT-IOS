//
//  BookNowViewController.swift
//  FarmerConnect
//
//  Created by Admin on 29/12/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit
import Alamofire

class BookNowViewController: RequesterBaseViewController{

    @IBOutlet var btnSingleDay : ISRadioButton?
    @IBOutlet var btnMultipleDay : ISRadioButton?
    //@IBOutlet var collectionTimeRange : UICollectionView?
    @IBOutlet var lblClassificationName : UILabel?
    //@IBOutlet var txtSchedule : UITextField?
    //@IBOutlet var lblPricePerHour : UILabel?
    //@IBOutlet var lblMinServiceHours : UILabel?
    @IBOutlet var singleDayView : SingleDaySelectionView?
    @IBOutlet var multipleDayView : MultipuleDaySelection?
    @IBOutlet var bookingTypeView : UIView?

     var loginAlertView = UIView()
    var arrAvailableDates : NSArray?
    var arrFullAvailableDates : NSArray?
    var isFromEditOrder = false
    var isFromProvider = false
    var order : Order?
    var placedOrder : PlaceOrder?
    var selectedEquipId : String?
    var cropId : Int = 0
    //var arrAraayTimes = ["12am","1am","2am","3am","4am","5am","6am","7am","8am","9am","10am","11am","12pm","1pm","2pm","3pm","4pm","5pm","6pm","7pm","8pm","9pm","10pm","11pm"]
    //var arrAraayFormattedTimes = ["24:00:00","01:00:00","02:00:00","03:00:00","04:00:00","05:00:00","06:00:00","07:00:00","08:00:00","09:00:00","10:00:00","11:00:00","12:00:00","13:00:00","14:00:00","15:00:00","16:00:00","17:00:00","18:00:00","19:00:00","20:00:00","21:00:00","22:00:00","23:00:00"]
    
    //var arrAvailableSlots = NSMutableArray()
    //let selectableIndexPaths = NSMutableArray()
    //var selectedIndexPaths    = NSMutableArray()
    //var fromIndex : NSInteger?
    //var toIndex : NSInteger?

    var selectedEquipment : Equipment?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.selectedEquipment != nil {
            lblClassificationName?.text = String(format: "%@-%@", (self.selectedEquipment?.equipmentClassification)!,(self.selectedEquipment?.model)!)
        }

        btnSingleDay?.isSelected = true
        if selectedEquipment != nil {
            self.getAvailableAndFullAvailableDatesFromEquipment()
        }
        else if selectedEquipId != nil{
            self.getEquipmentsDetailsWithEquipmentId(equipmentId: self.selectedEquipId!)
        }
        singleDayView = SingleDaySelectionView.instanceFromNib()
        singleDayView?.frame = CGRect(x: 0, y: 140, width: (UIScreen.main.bounds.size.width), height: UIScreen.main.bounds.size.height - 185)
        singleDayView?.selectedEquipment = self.selectedEquipment
        singleDayView?.arrAvailableDates = self.arrAvailableDates
        singleDayView?.cropId  = cropId
        singleDayView?.delegate = self
        singleDayView?.layoutIfNeeded()
        singleDayView?.updateConstraintsIfNeeded()
        self.view?.addSubview(singleDayView!)
        
        multipleDayView = MultipuleDaySelection.instanceFromNib()
        multipleDayView?.frame = CGRect(x: 0, y: 140, width: (UIScreen.main.bounds.size.width), height: UIScreen.main.bounds.size.height - 185)
        multipleDayView?.selectedEquipment = self.selectedEquipment
        multipleDayView?.arrAvailableDates = self.arrFullAvailableDates
         multipleDayView?.cropId = self.cropId
        multipleDayView?.delegate = self
        multipleDayView?.isHidden = true
        multipleDayView?.layoutIfNeeded()
        multipleDayView?.updateConstraintsIfNeeded()
        self.view?.addSubview(multipleDayView!)
        if isFromProvider == true{
            bookingTypeView?.cornerRadius = 5.0
            bookingTypeView?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
            btnSingleDay?.isUserInteractionEnabled = false
            btnMultipleDay?.isUserInteractionEnabled = false
        }
        self.recordScreenView("BookletsViewController", FSR_Place_Order)
        let userObj = Constatnts.getUserObject()
        let fireBaseParams = [MOBILE_NUMBER: userObj.mobileNumber!,USER_ID: userObj.customerId,EQUIPMENT_ID:self.selectedEquipment?.equipmentId]
        self.registerFirebaseEvents(PV_FSR_Place_Order, "", "", "", parameters: fireBaseParams as NSDictionary)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.topView?.isHidden = false
        let placeOrderStr = NSLocalizedString("place_order", comment: "")
        self.lblTitle?.text = placeOrderStr
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //scrollView?.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: (singleDayView?.frame.size.height)! + 20)
       // print(scrollView!.contentSize)
    }
    
    func getAvailableAndFullAvailableDatesFromEquipment(){
        if selectedEquipment != nil {
            var string = selectedEquipment?.availableDates
            string = string?.replacingOccurrences(of: " ", with: "") as NSString?
            if Validations.isNullString(string ?? "") == false{
                if let arrAvailable = string?.components(separatedBy: ",") as NSArray?{
                    if arrAvailable.count > 0{
                        arrAvailableDates = arrAvailable
                        if isFromEditOrder == false && isFromProvider == false{
                            if singleDayView != nil{
                                singleDayView?.arrAvailableDates = arrAvailableDates
                                singleDayView?.cropId = cropId
                                singleDayView?.selectedEquipment = self.selectedEquipment
                            }
                        }
                    }
                }
            }
            var fullString = selectedEquipment?.fullyAvailableDates
            fullString = fullString?.replacingOccurrences(of: " ", with: "") as NSString?
            if Validations.isNullString(fullString ?? "") == false{
                if let arrFullAvailable = fullString?.components(separatedBy: ",") as NSArray?{
                    if arrFullAvailable.count > 0{
                        arrFullAvailableDates = arrFullAvailable
                        if isFromEditOrder == false && isFromProvider == false{
                            if multipleDayView != nil{
                                multipleDayView?.arrAvailableDates = arrFullAvailableDates
                                 multipleDayView?.cropId = cropId
                                multipleDayView?.selectedEquipment = self.selectedEquipment
                            }
                        }
                    }
                }
            }
        }
    }
    func getEquipmentsDetailsWithEquipmentId(equipmentId:String){
        let headers : HTTPHeaders = self.getProviderHeaders()
        print(headers)
        SwiftLoader.show(animated: true)
        let urlString = String(format: "%@%@", arguments: [BASE_URL,View_Equipment_Details])
        let equipLocation = "false"
        let parameters = ["equipmentId":equipmentId,"isProvider": equipLocation , "cropId" : cropId] as [String : Any]
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
                                self.lblClassificationName?.text = String(format: "%@-%@", (self.selectedEquipment?.equipmentClassification)!,(self.selectedEquipment?.model)!)
                            }
                            self.getAvailableAndFullAvailableDatesFromEquipment()
                            self.updateOrderDetailsToBookingScreens()
                        }
                    }
                    else if responseStatusCode == STATUS_CODE_601{
                        Constatnts.logOut()
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    }
                    else{
                        if let message = (json as! NSDictionary).value(forKey: "message") as? String {
                            self.view.makeToast(message)
                        }
                    }
                }
            }
            else{
                self.view.makeToast((response.error?.localizedDescription)!)
            }
        }
    }
    func checkValidationsForPlacingOrderForEquipment(){
        if btnSingleDay?.isSelected == true && singleDayView?.placeOrder != nil{
            if let paramsDic = self.singleDayView?.placeOrderForSingleDayServiceCall() as NSDictionary?{
                if self.selectedEquipment != nil {
                    let userObj = Constatnts.getUserObject()
                    let fireBaseParams = [MOBILE_NUMBER: userObj.mobileNumber!,USER_ID: userObj.customerId ?? "",EQUIPMENT_ID:self.selectedEquipment!.equipmentId!,SEND_SAME_REQUEST_TO_MULTIPLE_PROVIDERS:paramsDic.value(forKey: "multipleProviderCheck")!,SINGLE_MULTIPLE_DAY:paramsDic.value(forKey: "singleDaySelected")!,DATE:paramsDic.value(forKey: "date")!] as [String : Any]
                    self.registerFirebaseEvents(FSR_Place_Order_Confirm, "", "", "", parameters: fireBaseParams as NSDictionary)
                    self.placingOrderServiceCall(paramsDic)
                }
            }
        }
        else if btnMultipleDay?.isSelected == true && multipleDayView?.placeOrder != nil{
            if let paramsDic = self.multipleDayView?.placeOrderForMultiDayServiceCall() as NSDictionary?{
                if self.selectedEquipment != nil {
                    self.placingOrderServiceCall(paramsDic)
                }
            }
        }
    }
    
    func placingOrderServiceCall(_ paramsDic: NSDictionary?){
        if paramsDic != nil{
            let userObj = Constatnts.getUserObject()
            let headers : HTTPHeaders = ["userAuthorizationToken": userObj.userAuthorizationToken! as String,"mobileNumber":userObj.mobileNumber! as String,"customerId": userObj.customerId! as String,"deviceToken":userObj.deviceToken as String,"deviceId":userObj.deviceId! as String]
            SwiftLoader.show(animated: true)
            var urlString = String(format: "%@%@", arguments: [BASE_URL,Placing_Fresh_Oredr])
            if isFromProvider == true || isFromEditOrder == true{
                urlString = String(format: "%@%@", arguments: [BASE_URL,Edit_Placed_Order])
            }
            let paramsStr = Constatnts.nsobjectToJSON(paramsDic!)
            let params =  ["data" : paramsStr]
            print(params)
            Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                SwiftLoader.hide()
                if response.result.error == nil {
                    if let json = response.result.value {
                        //print("Response :\(json)")
                        let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                        if responseStatusCode == STATUS_CODE_200{
                            if let message  = (json as! NSDictionary).value(forKey: "message") as? String{
                                let appdelegate = UIApplication.shared.delegate as? AppDelegate
                                appdelegate?.window?.makeToast(message)
                                if self.isFromBookingStages == true {
                                    let feedbackController = self.storyboard?.instantiateViewController(withIdentifier: "SprayServicesStagesViewController") as? SprayServicesStagesViewController
                                    feedbackController?.isFromRequestor = true
                                    self.navigationController?.pushViewController(feedbackController!, animated: true)
                                }else {
                                self.navigationController?.popViewController(animated: true)
                                }
                            }
                            //self.navigationController?.popViewController(animated: true)
                        }
                    }
                    else{
                        self.view.makeToast((response.error?.localizedDescription)!)
                    }
                }
            }
        }
    }
    func getPlaceOrderObjectFromOrder() -> PlaceOrder?{
        if (isFromProvider == true || isFromEditOrder == true) && order != nil{
            let placeOrder = PlaceOrder(dict: NSDictionary())
            placeOrder.counterRequest = true
            placeOrder.equipmentTransactionId = order?.equipmentTransactionId
            placeOrder.noOfHoursRequired = order?.noOfHours
            placeOrder.fromDate = order?.fromDate
            placeOrder.toDate = order?.toDate
            placeOrder.startTime = order?.startTime
            placeOrder.endTime = order?.endTime
            placeOrder.multipleProviderCheck = order?.multipleProviderCheck
            placeOrder.multipleProviderPrice = order?.multipleProviderPrice
            placeOrder.multipleProviderDistance = order?.multipleProviderDistance
            placeOrder.latitude = order?.latitude
            placeOrder.longitude = order?.longitude
            placeOrder.locationName = order?.locationName
            if isFromEditOrder == true{
                placeOrder.locationName = order?.toLocation
            }
            else if isFromProvider == true{
                placeOrder.locationName = order?.fromLocation
            }
            placeOrder.pricePerHour = order?.pricePerHour
            placeOrder.counterRequest = true
            placeOrder.singleDaySelected = order?.singleDaySelected
            placeOrder.equipmentId = order?.equipmentId
            return placeOrder
        }
        return nil

    }
    func updateOrderDetailsToBookingScreens(){
        if (isFromProvider == true || isFromEditOrder == true) && order != nil{
            let placeOrder = PlaceOrder(dict: NSDictionary())
            placeOrder.counterRequest = true
            placeOrder.equipmentTransactionId = order?.equipmentTransactionId
            placeOrder.noOfHoursRequired = order?.noOfHours
            placeOrder.fromDate = order?.fromDate
            if self.order?.singleDaySelected == true{
                placeOrder.fromDate = order?.bookedDate
            }
            placeOrder.toDate = order?.toDate
            placeOrder.startTime = order?.startTime
            placeOrder.endTime = order?.endTime
            placeOrder.multipleProviderCheck = order?.multipleProviderCheck
            placeOrder.multipleProviderPrice = order?.multipleProviderPrice
            placeOrder.multipleProviderDistance = order?.multipleProviderDistance
            placeOrder.latitude = order?.latitude
            placeOrder.longitude = order?.longitude
            placeOrder.locationName = order?.locationName
            placeOrder.distance = order?.distance
            if isFromEditOrder == true{
                placeOrder.locationName = order?.toLocation
            }
            else if isFromProvider == true{
                placeOrder.locationName = order?.fromLocation
            }
            placeOrder.pricePerHour = order?.pricePerHour
            placeOrder.counterRequest = true
            placeOrder.singleDaySelected = order?.singleDaySelected
            placeOrder.equipmentId = order?.equipmentId
            if self.order?.singleDaySelected == true{
                placeOrder.fromDate = order?.bookedDate
                self.singleDayView?.isHidden = false
                self.multipleDayView?.isHidden = true
                self.singleDayView?.isFromProvider = self.isFromProvider
                self.singleDayView?.isFromEdit = self.isFromEditOrder
                self.singleDayView?.selectedEquipment = self.selectedEquipment
                self.singleDayView?.clearAllDate()
                self.singleDayView?.placeOrder = placeOrder
                self.singleDayView?.cropId = cropId
                self.singleDayView?.updateDataToUiComponents()
                if isFromEditOrder == true || isFromProvider == true{
                    singleDayView?.arrAvailableDates = self.arrAvailableDates
                    multipleDayView?.selectedEquipment = self.selectedEquipment
                }
                if let minDate = FarmServicesConstants.getDateFromDateString(dateStr: placeOrder.fromDate as String!) as NSDate?{
                    if let fromDate = FarmServicesConstants.getDateStringFromDateWithShortMonth(serverDate: minDate as Date) as String?{
                        self.singleDayView?.txtSchedule?.text = fromDate
                        self.singleDayView?.getTimeSlotsForSelectedDay(placeOrder.fromDate as String!)
                    }
                }
                btnSingleDay?.isSelected = true
            }
            else if self.order?.singleDaySelected == false{
                self.singleDayView?.isHidden = true
                self.multipleDayView?.isHidden = false
                self.multipleDayView?.isFromProvider = self.isFromProvider
                self.multipleDayView?.isFromEdit = self.isFromEditOrder
                self.multipleDayView?.selectedEquipment = self.selectedEquipment
                self.multipleDayView?.clearAllDate()
                self.multipleDayView?.placeOrder = placeOrder
                multipleDayView?.arrAvailableDates = self.arrFullAvailableDates
                self.multipleDayView?.updateDataToUiComponents()
                if isFromEditOrder == true || isFromProvider == true{
                    //multipleDayView?.arrAvailableDates = self.arrFullAvailableDates
                    singleDayView?.selectedEquipment = self.selectedEquipment
                }
                btnMultipleDay?.isSelected = true
            }
        }
    }
    //MARK: UIPopOver controller del
    @IBAction func singledayButtonClick(_ sender: ISRadioButton){
        multipleDayView?.isHidden = true
        multipleDayView?.clearAllDate()
        if singleDayView != nil {
            singleDayView?.frame = CGRect(x: 0, y: 140, width: (UIScreen.main.bounds.size.width), height: UIScreen.main.bounds.size.height - 185)
            singleDayView?.isHidden = false
            singleDayView?.clearAllDate()
            if isFromEditOrder == true{
                let placeorder = self.getPlaceOrderObjectFromOrder()
                if placeorder != nil{
                    placeorder?.startTime = ""
                    placeorder?.endTime = ""
                    placeorder?.fromDate = ""
                    singleDayView?.placeOrder = placeorder
                }
            }
            singleDayView?.arrAvailableDates = self.arrAvailableDates
            self.singleDayView?.cropId = cropId
            singleDayView?.updateDataToUiComponents()
        }
    }
    
    @IBAction func multipledayButtonClick(_ sender: ISRadioButton){
        singleDayView?.isHidden = true
        singleDayView?.clearAllDate()
        if multipleDayView != nil {
            multipleDayView?.frame = CGRect(x: 0, y: 140, width: (UIScreen.main.bounds.size.width), height: UIScreen.main.bounds.size.height - 185)
            multipleDayView?.isHidden = false
            multipleDayView?.clearAllDate()
            if isFromEditOrder == true{
                let placeorder = self.getPlaceOrderObjectFromOrder()
                if placeorder != nil{
                    placeorder?.startTime = ""
                    placeorder?.endTime = ""
                    placeorder?.fromDate = ""
                    placeorder?.toDate = ""
                    multipleDayView?.placeOrder = placeorder
                }
            }
            multipleDayView?.arrAvailableDates = self.arrFullAvailableDates
            multipleDayView?.cropId = cropId
            multipleDayView?.updateDataToUiComponents()
        }
    }
    @IBAction func confirmBookingButtonClick(_ sender: UIButton){
        if self.selectedEquipment?.equipmentClassificationId == "5" {
            if self.selectedEquipment?.sprayRequestDone == true && self.selectedEquipment?.billUploadDone == true {
        if btnSingleDay?.isSelected == true{
            if isFromEditOrder == true{
                if singleDayView != nil{
                    self.checkValidationsForPlacingOrderForEquipment()
                }
            }
            else{
                if singleDayView != nil{
                    self.checkValidationsForPlacingOrderForEquipment()
                }
            }
        }
        else if btnMultipleDay?.isSelected == true{
            if isFromEditOrder == true{
                if multipleDayView != nil{
                    self.checkValidationsForPlacingOrderForEquipment()
                }
            }
            else{
                if multipleDayView != nil{
                    self.checkValidationsForPlacingOrderForEquipment()
                }
            }
        }
            }else if !(self.selectedEquipment?.sprayRequestDone)! {
                       let notYetSubscribedMessage = NSLocalizedString("Not_yet_subscribe_to_Spray_servcies_message", comment: "")
                                         self.loginAlertView = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: NSLocalizedString("alert", comment: "") as NSString, message: notYetSubscribedMessage as NSString, okButtonTitle: NSLocalizedString("Subscribe", comment: ""), cancelButtonTitle: NSLocalizedString("cancel", comment: "")) as! UIView
                                         self.view.addSubview(self.loginAlertView)
            }else if !(self.selectedEquipment?.billUploadDone)! {
                let notYetPuchasedMessage =  NSLocalizedString("Not_yet_done_purchase_register", comment: "")
                           self.loginAlertView = CustomAlert.alertNewPopView(self, frame: self.view.frame, title:NSLocalizedString("alert", comment: "") as NSString, message: notYetPuchasedMessage as NSString , okButtonTitle: NSLocalizedString("go_home", comment: ""), cancelButtonTitle: NSLocalizedString("cancel", comment: "")) as! UIView
                           self.view.addSubview(self.loginAlertView)
                           
             }

        }else {
            if btnSingleDay?.isSelected == true{
                       if isFromEditOrder == true{
                           if singleDayView != nil{
                               self.checkValidationsForPlacingOrderForEquipment()
                           }
                       }
                       else{
                           if singleDayView != nil{
                               self.checkValidationsForPlacingOrderForEquipment()
                           }
                       }
                   }
                   else if btnMultipleDay?.isSelected == true{
                       if isFromEditOrder == true{
                           if multipleDayView != nil{
                               self.checkValidationsForPlacingOrderForEquipment()
                           }
                       }
                       else{
                           if multipleDayView != nil{
                               self.checkValidationsForPlacingOrderForEquipment()
                           }
                       }
                   }
        }
    }
    @IBAction func cancelButtonClick(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
