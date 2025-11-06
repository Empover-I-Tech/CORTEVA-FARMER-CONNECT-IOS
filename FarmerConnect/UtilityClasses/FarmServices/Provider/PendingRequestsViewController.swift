//
//  PendingRequestsViewController.swift
//  FarmerConnect
//
//  Created by Admin on 27/12/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import Kingfisher

class PendingRequestsViewController: ProviderBaseViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {

    @IBOutlet var tblPendingRequests : UITableView?
    var arrPendingRequsts : NSArray?
    var selectedOrder : Order?
    var cancelReasonAlert : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblPendingRequests?.tableFooterView = UIView()
        tblPendingRequests?.estimatedRowHeight = 400
        if arrPendingRequsts?.count == 0 {
            self.lblWaterMarlLabel?.text = No_Orders_Found
            self.lblWaterMarlLabel?.isHidden = false
        }
        self.recordScreenView("PendingRequestsViewController", FSP_Pending_Requests_Screen)
        self.registerFirebaseEvents(PV_FSP_Pending_Requests_Tab, "", "", "", parameters: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var lblWaterFrame = self.lblWaterMarlLabel?.frame
        lblWaterFrame?.size.height = UIScreen.main.bounds.size.height - 95
        lblWaterMarlLabel?.frame = lblWaterFrame!
        self.relodData()
    }
    
    func rejectOrderServiceCall(_ orderId : String,reason: String){
        let headers : HTTPHeaders = self.getProviderHeaders()
        print(headers)
        SwiftLoader.show(animated: true)
        let urlString = String(format: "%@%@", arguments: [BASE_URL,Provider_Reject_Booking])
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
                        if let parent = self.parent as? CAPSPageMenu
                        {
                            if let viewController = parent.view.superview?.parentViewController as? MyOrdersSegmentViewController{
                                let parameters = ["customerId":Constatnts.getCustomerId()]
                                viewController.getProviderPendingOrdersListServiceCall(Parameters: parameters)
                            }
                        }
                        //print("Response after decrypting data:\(decryptData)")
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
    func confirmOrderServiceCall(_ orderId : String){
        let headers : HTTPHeaders = self.getProviderHeaders()
        print(headers)
        SwiftLoader.show(animated: true)
        let urlString = String(format: "%@%@", arguments: [BASE_URL,Provider_Confirm_Booking])
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
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        if let message = (json as! NSDictionary).value(forKey: "message") as? String {
                            self.view.makeToast(message)
                        }
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        if let parent = self.parent as? CAPSPageMenu
                        {
                            if let viewController = parent.view.superview?.parentViewController as? MyOrdersSegmentViewController{
                                let parameters = ["customerId":Constatnts.getCustomerId()]
                                viewController.getProviderPendingOrdersListServiceCall(Parameters: parameters)
                            }
                        }
                        //print("Response after decrypting data:\(decryptData)")
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
        if arrPendingRequsts?.count == 0{
            self.lblWaterMarlLabel?.isHidden = false
            self.lblWaterMarlLabel?.text = No_Orders_Found
        }
        else{
            self.lblWaterMarlLabel?.isHidden = true
            self.lblWaterMarlLabel?.text = ""
            self.tblPendingRequests?.tableFooterView = UIView()
        }
        self.tblPendingRequests?.reloadData()
    }
    //MARK: UITableview delegate and datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPendingRequsts?.count ?? 0
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
        let order = arrPendingRequsts?.object(at: indexPath.row) as? Order
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
        let btnProposeChange = cell.viewWithTag(113) as? UIButton
        let lblToDate = cell.viewWithTag(119) as? UILabel
        //let btnNavigate = cell.viewWithTag(114) as? UIButton
        let btnReject = cell.viewWithTag(115) as? UIButton
        let btnConfirm = cell.viewWithTag(116) as? UIButton
        let ratingView = cell.viewWithTag(117) as UIView?
        let lblRating = cell.viewWithTag(118) as? UILabel
        ratingView?.isHidden = true
        btnProposeChange?.isHidden = true
        //let btnCancelPolicy = cell.viewWithTag(117) as? UIButton
        
        let imageUrl = URL(string: (order?.equipImage ?? "") as String)
        equipImage?.kf.setImage(with: imageUrl as Resource!, placeholder: UIImage(named: "image_placeholder.png"), options: nil, progressBlock: nil)
        lblModel?.text = order?.model as String!
        lblTotalPrice?.text = String(format:"%@",order?.totalPrice as String!)
        lblBookedDate?.text = String(format:": %@",order?.bookedDate as String!)
        if order?.singleDaySelected == true{
            lblBookedDate?.text = String(format:": %@",order?.bookedDate as String!)
        }
        else{
            lblBookedDate?.text = String(format:": %@",order?.fromDate as String!)
            lblToDate?.text = String(format:": %@",order?.toDate as String!)
        }
        lblStartTime?.text = String(format:": %@",order?.startTime as String!)
        if Validations.isNullString(FarmServicesConstants.amAppend(dateStr: order?.startTime as String!) as NSString!) == false{
            lblStartTime?.text = String(format:": %@",FarmServicesConstants.amAppend(dateStr: order?.startTime as String!)!)
        }
        lblEndTime?.text = String(format:": %@",order?.endTime as String!)
        if Validations.isNullString(FarmServicesConstants.amAppend(dateStr: order?.endTime as String!) as NSString!) == false{
            lblEndTime?.text = String(format:": %@",FarmServicesConstants.amAppend(dateStr: order?.endTime as String!)!)
        }
        lblDistance?.text = String(format:": %@",order?.distance as String!)
        lblBookedHours?.text = String(format:": %@",order?.noOfHours as String!)
        lblPricePerHour?.text = String(format:": %@",order?.pricePerHour as String!)
        lblRequestedBy?.text = String(format:": %@",order?.requestBy as String!)
        lblContactNo?.text = String(format:": %@",order?.contactNo as String!)
        lblFromLocation?.text = String(format:"%@",order?.fromLocation as String!)
        lblToLocation?.text = String(format:"%@",order?.toLocation as String!)
        if Validations.isNullString(order?.rating ?? "") == false {
            if order!.rating!.floatValue > 0 {
                ratingView?.isHidden = false
                lblRating?.text =  order?.rating as String!
            }
        }
        btnConfirm?.isHidden = true
        btnReject?.isHidden = true
        let rejectStr = NSLocalizedString("reject", comment: "")
         let cancelStr = NSLocalizedString("cancel", comment: "")
        let confirmStr = NSLocalizedString("confirm", comment: "")
        
        
        if order?.secondaryStatus == "Reject" {
            btnReject?.setTitle(REJECT, for: .normal)
            btnReject?.isHidden = false
        }
        else if order?.secondaryStatus == "Cancel" {
            btnReject?.setTitle(CANCEL, for: .normal)
            btnReject?.isHidden = false
        }
        if order?.status == "Pending" {
            btnConfirm?.setTitle(CONFIRM, for: .normal)
            btnConfirm?.isHidden = false
        }
        else if order?.status == "Accepted"{
            
        }
        if order?.eligibleForCounterRequest?.integerValue ?? 0 > 0 {
            btnProposeChange?.isHidden = false
        }
        else{
            btnConfirm?.isHidden = true
            btnReject?.setTitle(CANCEL, for: .normal)
            btnReject?.isHidden = false
        }

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    //MARK: UIButton Click Action Methods
    @IBAction func proposeChangesButtonClick(_ sender: UIButton){
        let buttonPosition = sender.convert(CGPoint(x:0,y:0), to: self.tblPendingRequests)
        let indexPath = self.tblPendingRequests!.indexPathForRow(at: buttonPosition)
        if indexPath != nil {
            if let order = arrPendingRequsts?.object(at: indexPath!.row) as? Order{
                let bookNowController = self.storyboard?.instantiateViewController(withIdentifier: "BookNowViewController") as? BookNowViewController
                bookNowController?.isFromProvider = true
                bookNowController?.order = order
                bookNowController?.selectedEquipId = order.equipmentId as String!
                let userObj = Constatnts.getUserObject()
                let fireBaseParams = [MOBILE_NUMBER: userObj.mobileNumber!,USER_ID: userObj.customerId,EQUIPMENT_ID:order.equipmentId,ORDER_ID:order.equipmentTransactionId]
                self.registerFirebaseEvents(FSP_Propose_Change, "", "", "", parameters: fireBaseParams as NSDictionary)
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
    @IBAction func rejectOrderButtonClick(_ sender: UIButton){
        let buttonPosition = sender.convert(CGPoint(x:0,y:0), to: self.tblPendingRequests)
        let indexPath = self.tblPendingRequests!.indexPathForRow(at: buttonPosition)
        if indexPath != nil {
            if let order = arrPendingRequsts?.object(at: indexPath!.row) as? Order{
                if cancelReasonAlert != nil{
                    cancelReasonAlert?.removeFromSuperview()
                    cancelReasonAlert = nil
                }
                cancelReasonAlert = CustomAlert.orderCancelAndRejectPopup(self, title: Order_Reject_Alert_Title as NSString, frame: UIScreen.main.bounds, okButtonTitle: "OK") as? UIView
                let appdelegate = UIApplication.shared.delegate as? AppDelegate
                appdelegate?.window?.addSubview(cancelReasonAlert!)
                self.selectedOrder = order
            }
        }
    }
    @IBAction func confirmOrderButtonClick(_ sender: UIButton){
        let buttonPosition = sender.convert(CGPoint(x:0,y:0), to: self.tblPendingRequests)
        let indexPath = self.tblPendingRequests!.indexPathForRow(at: buttonPosition)
        if indexPath != nil {
            if let order = arrPendingRequsts?.object(at: indexPath!.row) as? Order{
                self.confirmOrderServiceCall(order.equipmentTransactionId as String!)
                let userObj = Constatnts.getUserObject()
                let fireBaseParams = [MOBILE_NUMBER: userObj.mobileNumber!,USER_ID: userObj.customerId,EQUIPMENT_ID:order.equipmentId,ORDER_ID:order.equipmentTransactionId]
                self.registerFirebaseEvents(FSP_Accept_Order, "", "", "", parameters: fireBaseParams as NSDictionary)
            }
        }
    }
    @IBAction func callToRequesterButtonClick(_ sender: UIButton){
        let buttonPosition = sender.convert(CGPoint(x:0,y:0), to: self.tblPendingRequests)
        let indexPath = self.tblPendingRequests!.indexPathForRow(at: buttonPosition)
        if indexPath != nil {
            if let order = arrPendingRequsts?.object(at: indexPath!.row) as? Order{
                if let mobilNumer = order.contactNo as String?{
                    let userObj = Constatnts.getUserObject()
                    let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId,ORDER_ID: order.equipmentTransactionId!,EQUIPMENT_ID:order.equipmentId]
                    self.registerFirebaseEvents(FSP_Call_Requester, "", "", "", parameters: fireBaseParams as NSDictionary)
                    let callUrl = String(format:"tel://%@", mobilNumer)
                    if let url = URL(string: callUrl), UIApplication.shared.canOpenURL(url) {
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
    @IBAction func cancellationPolicyButtonClick(_ sender: UIButton){
        let buttonPosition = sender.convert(CGPoint(x:0,y:0), to: self.tblPendingRequests)
        let indexPath = self.tblPendingRequests!.indexPathForRow(at: buttonPosition)
        if indexPath != nil {
            if let order = arrPendingRequsts?.object(at: indexPath!.row) as? Order{
                let userObj = Constatnts.getUserObject()
                let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId,ORDER_ID:order.equipmentTransactionId!,EQUIPMENT_ID:order.equipmentId]
                self.registerFirebaseEvents(FSP_Cancellation_Policy, "", "", "", parameters: fireBaseParams as NSDictionary)
                let cancelPolicyController = self.storyboard?.instantiateViewController(withIdentifier: "LoginPrivacyPolicyViewController") as? LoginPrivacyPolicyViewController
                cancelPolicyController?.privacyPolicyURLStr = order.cancellationPolicyURL!
                cancelPolicyController?.isFromCanellationPolicy = true
                if let parent = self.parent as? CAPSPageMenu
                {
                    let viewController = parent.view.superview?.parentViewController
                    viewController?.navigationController?.pushViewController(cancelPolicyController!, animated: false)
                }
                else{
                    self.navigationController?.pushViewController(cancelPolicyController!, animated: true)
                }
            }
        }
    }
    @objc func cancelAndrejectCloseButton(){
        if self.cancelReasonAlert != nil {
            self.cancelReasonAlert?.removeFromSuperview()
            self.cancelReasonAlert = nil
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
                    let userObj = Constatnts.getUserObject()
                    let fireBaseParams = [MOBILE_NUMBER: userObj.mobileNumber!,USER_ID: userObj.customerId!,EQUIPMENT_ID:self.selectedOrder!.equipmentId!,ORDER_ID:self.selectedOrder!.equipmentTransactionId!,REJECT_EQUIPMENT_REASON : txtReason!.text!] as [String : Any]
                    self.registerFirebaseEvents(FSP_Reject_Order, "", "", "", parameters: fireBaseParams as NSDictionary)
                    if self.selectedOrder != nil{
                        self.rejectOrderServiceCall(self.selectedOrder!.equipmentTransactionId as String? ?? "", reason: (txtReason?.text)!)
                    }
                    self.cancelReasonAlert?.removeFromSuperview()
                    self.cancelReasonAlert = nil
                }
            }
        }
    }
    @IBAction func navigateToOrderButtonClick(_ sender: UIButton){
        let buttonPosition = sender.convert(CGPoint(x:0,y:0), to: self.tblPendingRequests)
        let indexPath = self.tblPendingRequests!.indexPathForRow(at: buttonPosition)
        if indexPath != nil {
            if let order = arrPendingRequsts?.object(at: indexPath!.row) as? Order{
                if LocationService.sharedInstance.currentLocation != nil && (Validations.isNullString(order.latitude ?? "") == false && Validations.isNullString(order.longitude ?? "") == false){
                    let orderCoordinates = CLLocationCoordinate2D(latitude: order.latitude?.doubleValue ?? 0, longitude: order.longitude?.doubleValue ?? 0)
                    FarmServicesConstants.getRoutesWithgoogle((LocationService.sharedInstance.currentLocation?.coordinate)!, departMentCoordinates: orderCoordinates)
                    let userObj = Constatnts.getUserObject()
                    let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId,ORDER_ID: order.equipmentTransactionId!,EQUIPMENT_ID:order.equipmentId]
                    self.registerFirebaseEvents(FSP_NavigateToRequester_Location, "", "", "", parameters: fireBaseParams as NSDictionary)
                }
            }
        }
    }
    @IBAction func equipmentRatingButtonClick(_ sender: UIButton) {
        
        let buttonPosition = sender.convert(CGPoint(x:0,y:0), to: self.tblPendingRequests)
        let indexPath = self.tblPendingRequests!.indexPathForRow(at: buttonPosition)
        if indexPath != nil {
            if let order = arrPendingRequsts?.object(at: indexPath!.row) as? Order{
                let toratingsVC = self.storyboard?.instantiateViewController(withIdentifier: "RequesterRatingViewController") as! RequesterRatingViewController
                toratingsVC.isFromRequesterOrdersVC = true
                toratingsVC.orders = order
                let userObj = Constatnts.getUserObject()
                let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId,ORDER_ID: order.equipmentTransactionId!,EQUIPMENT_ID:order.equipmentId]
                self.registerFirebaseEvents(FSP_Orders_Equipment_Rating, "", "", "", parameters: fireBaseParams as NSDictionary)
                if let parent = self.parent as? CAPSPageMenu
                {
                    let viewController = parent.view.superview?.parentViewController
                    viewController?.navigationController?.pushViewController(toratingsVC, animated: false)
                }
                else{
                    self.navigationController?.pushViewController(toratingsVC, animated: true)
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
