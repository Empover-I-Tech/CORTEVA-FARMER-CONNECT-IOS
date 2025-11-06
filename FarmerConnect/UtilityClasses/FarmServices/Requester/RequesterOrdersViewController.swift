//
//  RequesterOrdersViewController.swift
//  FarmerConnect
//
//  Created by Admin on 05/01/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import Kingfisher

class RequesterOrdersViewController: RequesterBaseViewController,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate {
    @IBOutlet var tblMyOrdes : UITableView?
    var arrMyOrders : NSMutableArray?
    var selectedOrder : Order?
    var cancelReasonAlert : UIView?
    var acceptCounterProposalAlert : UIView?
    var cropID : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tblMyOrdes?.tableFooterView = UIView()
        tblMyOrdes?.estimatedRowHeight = 380
        arrMyOrders = NSMutableArray()
        if self.arrMyOrders?.count == 0{
            self.lblWaterMarlLabel?.text = No_Orders_Found
            self.lblWaterMarlLabel?.isHidden = false
        }
        let refreshButton = UIButton(type: .custom)
        refreshButton.frame = CGRect(x: (self.topView?.frame.size.width)! - 45, y: 5, width: 40, height: 40)
        refreshButton.addTarget(self, action: #selector(RequesterOrdersViewController.refreshMyOrdersButtonClick(_:)), for: .touchUpInside)
        refreshButton.setImage(UIImage(named: "RefreshWhite"), for: .normal)
        self.topView?.addSubview(refreshButton)
        self.recordScreenView("RequesterOrdersViewController", FSR_Filter)
        self.registerFirebaseEvents(PV_FSR_Requester_Orders, "", "", "", parameters: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 10.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        super.viewWillAppear(animated)
        self.topView?.isHidden = false
        self.lblTitle?.text = NSLocalizedString("orders", comment: "")
        self.getRequesterPendingOrdersListServiceCall()
    }
    
    func getRequesterPendingOrdersListServiceCall(){
        let headers : HTTPHeaders = self.getProviderHeaders()
        print(headers)
        SwiftLoader.show(animated: true)
        let urlString = String(format: "%@%@", arguments: [BASE_URL,Get_Requester_Orders_List])
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
                        if let pendingRequestsArray = Validations.checkKeyNotAvailForArray(decryptData, key: "ordersList") as? NSArray{
                            self.arrMyOrders?.removeAllObjects()
                            for index in 0..<pendingRequestsArray.count{
                                if let reqDic = pendingRequestsArray.object(at: index) as? NSDictionary{
                                    let order = Order(dict: reqDic)
                                    self.arrMyOrders?.add(order)
                                }
                            }
                        }
                        if self.arrMyOrders?.count == 0{
                            self.lblWaterMarlLabel?.text = No_Orders_Found
                            self.lblWaterMarlLabel?.isHidden = false
                        }
                        else{
                            self.lblWaterMarlLabel?.isHidden = true
                        }
                        self.tblMyOrdes?.reloadData()
                        //print("Response after decrypting data:\(decryptData)")
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
    func cancelOrderServiceCall(_ orderId : String,reason: String){
        let headers : HTTPHeaders = self.getProviderHeaders()
        
        print(headers)
        SwiftLoader.show(animated: true)
        let urlString = String(format: "%@%@", arguments: [BASE_URL,Requester_Cancel_Booking])
        let parameteers = ["equipmentTransactionId":orderId,"reason":reason]
        let paramsStr = Constatnts.nsobjectToJSON(parameteers as NSDictionary)
        let params =  ["data" : paramsStr]
        print(params)
        //let parameters = ["mobileNumber":userObj.mobileNumber,"customerId": loggingUser!.customerId,"deviceId":userObj.deviceId!,"countryId":userObj.countryId.integerValue,"deviceType":"iOS"] as NSDictionary
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            self.selectedOrder = nil
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        if let message = (json as! NSDictionary).value(forKey: "message") as? String {
                            self.view.makeToast(message)
                        }
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        self.getRequesterPendingOrdersListServiceCall()
                        //print("Response after decrypting data:\(decryptData)")
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
    func acceptCounterProposalServiceCall(_ orderId : String){
        let headers : HTTPHeaders = self.getProviderHeaders()
        print(headers)
        SwiftLoader.show(animated: true)
        let urlString = String(format: "%@%@", arguments: [BASE_URL,Accept_Counter_Proposal])
        let parameteers = ["equipmentTransactionId":orderId]
        let paramsStr = Constatnts.nsobjectToJSON(parameteers as NSDictionary)
        let params =  ["data" : paramsStr]
        print(params)
        //let parameters = ["mobileNumber":userObj.mobileNumber,"customerId": loggingUser!.customerId,"deviceId":userObj.deviceId!,"countryId":userObj.countryId.integerValue,"deviceType":"iOS"] as NSDictionary
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            self.selectedOrder = nil
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        /*let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        if let message = (json as! NSDictionary).value(forKey: "message") as? String {
                            self.view.makeToast(message)
                        }
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                       // print("Response after decrypting data:\(decryptData)")*/
                        self.getRequesterPendingOrdersListServiceCall()
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
    func relodData(){
        if arrMyOrders?.count == 0 {
            self.tblMyOrdes?.tableFooterView = UIView()
        }
        self.tblMyOrdes?.reloadData()
    }
    //MARK: UITableview delegate and datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrMyOrders?.count == 0{
            //self.addNoDetailsFoundLabelFotterToTableView(tableView: tblMyOrdes!, message: "No Orders Found")
        }
        return arrMyOrders?.count ?? 0
    }
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return UITableViewAutomaticDimension
     }*/
    
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
        var cellIdentifier =  "OrderCell"
        let order = arrMyOrders?.object(at: indexPath.row) as? Order
        if order?.singleDaySelected == false{
            cellIdentifier =  "MultiOrderCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let equipImage = cell.viewWithTag(100) as? UIImageView
        let lblModel = cell.viewWithTag(101) as? UILabel
        let lblTotalPrice = cell.viewWithTag(102) as? UILabel
        let lblBookedDate = cell.viewWithTag(103) as? UILabel
        let lblStartTime = cell.viewWithTag(104) as? UILabel
        let lblEndTime = cell.viewWithTag(105) as? UILabel
        let lblDistance = cell.viewWithTag(106) as? UILabel
        let lblBookedHours = cell.viewWithTag(107) as? UILabel
        let lblPricePerHour = cell.viewWithTag(108) as? UILabel
        let lblRequestedBy = cell.viewWithTag(109) as? UILabel
        let lblContactNo = cell.viewWithTag(110) as? UILabel
        let lblFromLocation = cell.viewWithTag(111) as? UILabel
        let lblToLocation = cell.viewWithTag(112) as? UILabel
        let lblStatus = cell.viewWithTag(116) as? UILabel
        let ratingView = cell.viewWithTag(117) as UIView?
        let lblRating = cell.viewWithTag(118) as? UILabel
        let lblToDate = cell.viewWithTag(119) as? UILabel
        let lblStatusTitle = cell.viewWithTag(120) as? UILabel
        let btnConfirm = cell.viewWithTag(121) as? UIButton
        let btnProposeChange = cell.viewWithTag(113) as? UIButton
         //let btnRating = cell.viewWithTag(122) as? UIButton
        btnProposeChange?.isHidden = true
        ratingView?.isHidden = true
        let btnReject = cell.viewWithTag(115) as? UIButton
        btnConfirm?.isHidden = true
        lblStatusTitle?.isHidden  = false
        lblStatus?.isHidden = false
        
        let imageUrl = URL(string: (order?.imageView ?? "") as String)
        equipImage?.kf.setImage(with: imageUrl as? Resource!, placeholder: UIImage(named: "image_placeholder.png"), options: nil, progressBlock: nil)
        
//        (with: imageUrl as Resource!, placeholder: UIImage(named: "image_placeholder.png"), options: nil, progressBlock: nil)
        lblModel?.text = order?.model as String!
        lblTotalPrice?.text = String(format:"%@",order?.totalPrice as String!)
        if order?.singleDaySelected == true{
            lblBookedDate?.text = String(format:": %@",order?.bookedDate as String!)
        }
        else{
            lblBookedDate?.text = String(format:": %@",order?.fromDate as String!)
            lblToDate?.text = String(format:": %@",order?.toDate as String!)
        }
        lblStartTime?.text = String(format:": %@",order?.startTime as String!)
        if Validations.isNullString(FarmServicesConstants.amAppend(dateStr: order?.startTime as String!) as NSString? ?? "" as NSString) == false{
            lblStartTime?.text = String(format:": %@",FarmServicesConstants.amAppend(dateStr: order?.startTime as String!)!)
        }
        lblEndTime?.text = String(format:": %@",order?.endTime as String!)
        if Validations.isNullString(FarmServicesConstants.amAppend(dateStr: order?.endTime as String!) as NSString? ?? "" as NSString) == false{
            lblEndTime?.text = String(format:": %@",FarmServicesConstants.amAppend(dateStr: order?.endTime as String!)!)
        }
        lblDistance?.text = String(format:": %@",order?.distance as String!)
        lblBookedHours?.text = String(format:": %@",order?.noOfHours as String!)
        lblPricePerHour?.text = String(format:": %@",order?.pricePerHour as String!)
        lblRequestedBy?.text = String(format:": %@",order?.providedBy as String!)
        lblContactNo?.text = String(format:": %@",order?.contactNo as String!)
        lblFromLocation?.text = String(format:"%@",order?.fromLocation as String!)
        lblToLocation?.text = String(format:"%@",order?.toLocation as String!)
        let status = order?.secondaryStatus as String!
        if  status?.lowercased() == "cancel" {
              btnReject?.setTitle(CANCEL, for: .normal)
        }else  if  status?.lowercased() == "reject" {
            btnReject?.setTitle(REJECT, for: .normal)
        }
      
        lblStatus?.text = order?.status as String!
        
        if Validations.isNullString(order?.rating ?? "") == false {
            if order!.rating!.floatValue > 0 {
                ratingView?.isHidden = false
                lblRating?.text =  order?.rating as String!
            }
        }
        if order?.secondaryStatus == "Cancel" {
            btnReject?.titleLabel?.textColor = UIColor.red
            btnReject?.isHidden = false
        }
        if order?.status == "Pending" {
            lblStatus?.textColor = UIColor.orange
            btnProposeChange?.isHidden = false
            if order?.eligibleForCounterRequest?.boolValue == false{
                btnProposeChange?.isHidden = true
                btnConfirm?.isHidden = false
                lblStatusTitle?.isHidden  = true
                lblStatus?.isHidden = true
            }
        }
        else if order?.status == "Cancelled" || order?.status == "Rejected"{
            lblStatus?.textColor = UIColor.red
            btnProposeChange?.isHidden = true
            btnReject?.isHidden = true
        }
        else if order?.status == "Accepted"{
            lblStatus?.textColor = App_Theme_Blue_Color
            btnProposeChange?.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    //MARK: UIButton Click Action Methods
    @IBAction func refreshMyOrdersButtonClick(_ sender: UIButton){
        self.registerFirebaseEvents(FSR_Orders_Refresh, "", "", "", parameters: nil)
        self.getRequesterPendingOrdersListServiceCall()
    }
    @IBAction func proposeChangesButtonClick(_ sender: UIButton){
        let buttonPosition = sender.convert(CGPoint(x:0,y:0), to: self.tblMyOrdes)
        let indexPath = self.tblMyOrdes!.indexPathForRow(at: buttonPosition)
        if indexPath != nil {
            if let order = arrMyOrders?.object(at: indexPath!.row) as? Order{
                let bookNowController = self.storyboard?.instantiateViewController(withIdentifier: "BookNowViewController") as? BookNowViewController
                bookNowController?.isFromProvider = false
                bookNowController?.isFromEditOrder = true
                bookNowController?.order = order
                bookNowController?.selectedEquipId = order.equipmentId as String?
                bookNowController?.cropId = cropID
                let userObj = Constatnts.getUserObject()
                let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId,ORDER_ID: order.equipmentTransactionId!,EQUIPMENT_ID:order.equipmentId]
                self.registerFirebaseEvents(FSR_Edit_Order, "", "", "", parameters: fireBaseParams as NSDictionary)
                if let parent = self.parent as? CAPSPageMenu
                {
                    let viewController = parent.view.superview?.parentViewController
                    viewController?.navigationController?.pushViewController(bookNowController!, animated: false)
                }
                else{
                    self.navigationController?.pushViewController(bookNowController!, animated: true)
                }
            }
        }
    }
    @IBAction func callToRequesterButtonClick(_ sender: UIButton){
        let buttonPosition = sender.convert(CGPoint(x:0,y:0), to: self.tblMyOrdes)
        let indexPath = self.tblMyOrdes!.indexPathForRow(at: buttonPosition)
        if indexPath != nil {
            if let order = arrMyOrders?.object(at: indexPath!.row) as? Order{
                if let mobilNumer = order.contactNo as String?{
                    let callUrl = String(format:"tel://%@", mobilNumer)
                    if let url = URL(string: callUrl), UIApplication.shared.canOpenURL(url) {
                        let userObj = Constatnts.getUserObject()
                        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId,ORDER_ID: order.equipmentTransactionId!,EQUIPMENT_ID:order.equipmentId]
                        self.registerFirebaseEvents(FSR_Orders_Call, "", "", "", parameters: fireBaseParams as NSDictionary)
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(url)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }
            }
        }
    }
    @IBAction func cancelOrderButtonClick(_ sender: UIButton){
        let buttonPosition = sender.convert(CGPoint(x:0,y:0), to: self.tblMyOrdes)
        let indexPath = self.tblMyOrdes!.indexPathForRow(at: buttonPosition)
        if indexPath != nil {
            if let order = arrMyOrders?.object(at: indexPath!.row) as? Order{
                if cancelReasonAlert != nil{
                    cancelReasonAlert?.removeFromSuperview()
                    cancelReasonAlert = nil
                }
                cancelReasonAlert = CustomAlert.orderCancelAndRejectPopup(self, title: Order_Cancel_Alert_Title as NSString, frame: UIScreen.main.bounds, okButtonTitle: OK as NSString) as? UIView
                let appdelegate = UIApplication.shared.delegate as? AppDelegate
                appdelegate?.window?.addSubview(cancelReasonAlert!)
                self.selectedOrder = order
            }
        }
    }
    @IBAction func acceptCounterProposalButtonClick(_ sender: UIButton){
        let buttonPosition = sender.convert(CGPoint(x:0,y:0), to: self.tblMyOrdes)
        let indexPath = self.tblMyOrdes!.indexPathForRow(at: buttonPosition)
        self.selectedOrder = nil
        if indexPath != nil {
            if let order = arrMyOrders?.object(at: indexPath!.row) as? Order{
                if acceptCounterProposalAlert != nil{
                    acceptCounterProposalAlert?.removeFromSuperview()
                    acceptCounterProposalAlert = nil
                }
                var counterMessage  = ""
                let userObj = Constatnts.getUserObject()
                let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId,ORDER_ID: selectedOrder?.equipmentTransactionId!,EQUIPMENT_ID:order.equipmentId]
                self.registerFirebaseEvents(FSR_Orders_Propose_Changes_Edit, "", "", "", parameters: fireBaseParams as NSDictionary)
                if order.singleDaySelected == true{
                    counterMessage = counterMessage.appendingFormat("Booked date: %@\n", order.bookedDate as String!)
                    if let beforeStartTime = FarmServicesConstants.amAppend(dateStr: order.requestedStartTimeBeforeCounterRequest as String!) ,let beforeToTime = FarmServicesConstants.amAppend(dateStr: order.requestedEndTimeBeforeCounterRequest as String!){
                        counterMessage = counterMessage.appendingFormat("Requested Time: %@ to %@\n",beforeStartTime,beforeToTime)

                    }
                    if let proposedStartTime = FarmServicesConstants.amAppend(dateStr: order.startTime as String!) ,let proposedToTime = FarmServicesConstants.amAppend(dateStr: order.endTime as String!){
                        counterMessage = counterMessage.appendingFormat("Provider Proposed Time: %@ to %@\n", proposedStartTime,proposedToTime)
                        
                    }
                    if Validations.isNullString(order.pricePerHour ?? "") == false{
                        counterMessage = counterMessage.appendingFormat("Price per hour at the time of booking: %@\n",order.priceBeforeCounterRequest as String!)
                    }
                    if Validations.isNullString(order.pricePerHour ?? "") == false{
                        counterMessage = counterMessage.appendingFormat("Price per hour proposed by provider: %@\n",order.pricePerHour as String!)
                    }
                }
                else{
                    if let beforeStartDate = FarmServicesConstants.getDateStringFromDateStringWithShortFormat(serverDate: order.requestedForDateBeforeCounterRequest as String?) ,let beforeEndDate = FarmServicesConstants.getDateStringFromDateStringWithShortFormat(serverDate: order.requestedToDateBeforeCounterRequest as String?){
                        counterMessage = counterMessage.appendingFormat("Booked Dates: %@ to %@\n", beforeStartDate,beforeEndDate)
                    }
                    if let proposeStartDate = FarmServicesConstants.getDateStringFromDateStringWithShortFormat(serverDate: order.fromDate as String?) ,let proposeEndDate = FarmServicesConstants.getDateStringFromDateStringWithShortFormat(serverDate: order.toDate as String?){
                        counterMessage = counterMessage.appendingFormat("Proposed Dates: %@ to %@\n",proposeStartDate,proposeEndDate)
                    }
                    if Validations.isNullString(order.pricePerHour ?? "") == false{
                        counterMessage = counterMessage.appendingFormat("Price per hour at the time of booking: %@\n",order.priceBeforeCounterRequest as String!)
                    }
                    if Validations.isNullString(order.pricePerHour ?? "") == false{
                        counterMessage = counterMessage.appendingFormat("Price per hour proposed by provider: %@\n",order.pricePerHour as String!)
                    }
                }
                if Validations .isNullString(counterMessage as NSString) == false{
                    acceptCounterProposalAlert = CustomAlert.alertInfoPopUpView(self, frame: UIScreen.main.bounds, title: "Confirm Counter Request", message: counterMessage as NSString, buttonTitle: CONFIRM, hideClose: true) as? UIView
                    let appdelegate = UIApplication.shared.delegate as? AppDelegate
                    appdelegate?.window?.addSubview(acceptCounterProposalAlert!)
                    self.selectedOrder = order
                }
            }
        }
    }
    @IBAction func cancellationPolicyButtonClick(_ sender: UIButton){
        let buttonPosition = sender.convert(CGPoint(x:0,y:0), to: self.tblMyOrdes)
        let indexPath = self.tblMyOrdes!.indexPathForRow(at: buttonPosition)
        if indexPath != nil {
            if let order = arrMyOrders?.object(at: indexPath!.row) as? Order{
                let userObj = Constatnts.getUserObject()
                let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId,ORDER_ID: order.equipmentTransactionId!,EQUIPMENT_ID:order.equipmentId]
                self.registerFirebaseEvents(FSR_Cancellation_Policy, "", "", "", parameters: fireBaseParams as NSDictionary)
                let cancelPolicyController = self.storyboard?.instantiateViewController(withIdentifier: "LoginPrivacyPolicyViewController") as? LoginPrivacyPolicyViewController
                cancelPolicyController?.privacyPolicyURLStr = order.cancellationPolicyURL!
                cancelPolicyController?.isFromCanellationPolicy = true
                self.navigationController?.pushViewController(cancelPolicyController!, animated: true)
            }
        }
    }
    @IBAction func navigateToOrderButtonClick(_ sender: UIButton){
        let buttonPosition = sender.convert(CGPoint(x:0,y:0), to: self.tblMyOrdes)
        let indexPath = self.tblMyOrdes!.indexPathForRow(at: buttonPosition)
        if indexPath != nil {
            if let order = arrMyOrders?.object(at: indexPath!.row) as? Order{
                if LocationService.sharedInstance.currentLocation != nil && (Validations.isNullString(order.latitude ?? "") == false && Validations.isNullString(order.longitude ?? "") == false){
                    let orderCoordinates = CLLocationCoordinate2D(latitude: order.latitude?.doubleValue ?? 0, longitude: order.longitude?.doubleValue ?? 0)
                    FarmServicesConstants.getRoutesWithgoogle((LocationService.sharedInstance.currentLocation?.coordinate)!, departMentCoordinates: orderCoordinates)
                    self.registerFirebaseEvents(PV_FSR_View_Equipment_Directions, "", "", "", parameters: nil)
                }
            }
        }
    }
    
    @IBAction func ratingBtnClick_Touch_Up_Inside(_ sender: UIButton) {
  
        let buttonPosition = sender.convert(CGPoint(x:0,y:0), to: self.tblMyOrdes)
        let indexPath = self.tblMyOrdes!.indexPathForRow(at: buttonPosition)
        if indexPath != nil {
            if let order = arrMyOrders?.object(at: indexPath!.row) as? Order{
                let userObj = Constatnts.getUserObject()
                let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId,ORDER_ID: selectedOrder?.equipmentTransactionId!,EQUIPMENT_ID:selectedOrder?.equipmentId]
                self.registerFirebaseEvents(FSR_Orders_Equipment_Rating, "", "", "", parameters: fireBaseParams as NSDictionary)
                print(order.equipmentId!)
                
                let toratingsVC = self.storyboard?.instantiateViewController(withIdentifier: "RequesterRatingViewController") as! RequesterRatingViewController
                toratingsVC.isFromRequesterOrdersVC = true
                toratingsVC.orders = order
                //toratingsVC.equipmentIDFromRequestOrderVC = order.equipmentId! as String
                self.navigationController?.pushViewController(toratingsVC, animated: true)
                
            }
        }
    }
    
    @objc func cancelAndrejectCloseButton(){
        if self.cancelReasonAlert != nil {
            self.cancelReasonAlert?.removeFromSuperview()
            self.cancelReasonAlert = nil
        }
        if self.acceptCounterProposalAlert != nil {
            self.acceptCounterProposalAlert?.removeFromSuperview()
        }
        self.selectedOrder = nil
    }
    
    @objc func cancelAndrejectOkButton(){
        if self.cancelReasonAlert != nil {
            let txtReason = cancelReasonAlert?.viewWithTag(77777) as? UITextView
            if txtReason != nil{
                txtReason?.resignFirstResponder()
                let string = txtReason!.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as NSString
                let appdelegate = UIApplication.shared.delegate as? AppDelegate
                if Validations.isNullString(string) == true{
                    appdelegate?.window?.makeToast(Cancel_Reason_Char_Limit)
                }
                else if string.length < 16{
                    appdelegate?.window?.makeToast(Cancel_Reason_Char_Limit)
                }
                else{
                    if self.selectedOrder != nil{
                        let userObj = Constatnts.getUserObject()
                        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,ORDER_ID: selectedOrder!.equipmentTransactionId!,EQUIPMENT_ID:selectedOrder!.equipmentId ?? "",REJECT_EQUIPMENT_REASON:txtReason!.text] as [String : Any]
                        self.registerFirebaseEvents(FSR_Orders_Cancel_Order, "", "", "", parameters: fireBaseParams as NSDictionary)
                        self.cancelOrderServiceCall(self.selectedOrder!.equipmentTransactionId as String? ?? "", reason: (txtReason?.text)!)
                    }
                    self.cancelReasonAlert?.removeFromSuperview()
                    self.cancelReasonAlert = nil
                }
            }
        }
    }
    @objc func infoAlertSubmit(){
        if selectedOrder != nil {
            if selectedOrder?.status == "Pending" && selectedOrder?.eligibleForCounterRequest?.boolValue == false{
                if Validations.isNullString(selectedOrder?.equipmentTransactionId ?? "") == false{
                    if selectedOrder?.equipmentTransactionId?.integerValue != 0{
                        if self.acceptCounterProposalAlert != nil {
                            self.acceptCounterProposalAlert?.removeFromSuperview()
                        }
                        let userObj = Constatnts.getUserObject()
                        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId,ORDER_ID: selectedOrder?.equipmentTransactionId!,EQUIPMENT_ID:selectedOrder?.equipmentId]
                        self.registerFirebaseEvents(FSR_Orders_Accept_Order, "", "", "", parameters: fireBaseParams as NSDictionary)
                        self.acceptCounterProposalServiceCall(selectedOrder?.equipmentTransactionId as String!)
                    }
                }
            }
        }
        if self.cancelReasonAlert != nil {
            self.cancelReasonAlert?.removeFromSuperview()
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
