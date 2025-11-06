//
//  PSViewEquipmentViewController.swift
//  FarmerConnect
//
//  Created by Admin on 21/12/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class PSViewEquipmentViewController: ProviderBaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionImages : UICollectionView?
    @IBOutlet var tblequipmentDetails : UITableView?
    @IBOutlet var pagecontrol : UIPageControl?
    @IBOutlet var lblPhotiCount : UILabel?
    @IBOutlet var btnEdit : UIButton?
    @IBOutlet var btnNavigation : UIButton?
    @IBOutlet var btnPrevious : UIButton?
    @IBOutlet var btnNext : UIButton?
    @IBOutlet var lblRating : UILabel?
    @IBOutlet var ratingView : UIView?
    
    var deeplinkParams : NSDictionary?
    var isFromDeeplink : Bool = false
    var selectedEquipment : Equipment?
    var viewEquipment : Equipment?
    var imagesArray = NSMutableArray()
    var navMoreOptionsButton = UIButton()
    var shareButton = UIButton()
    var equipmentDeleteAlert = UIView()
    var equipmentBlockedAlert = UIView()
    var isFromRequester : Bool = false
     var loginAlertView = UIView()
    var isAlertFromSprayService : Bool = false
    var cropId : Int = 0
    
    var arrRequesterTitles = [NSLocalizedString("maker", comment: ""),NSLocalizedString("model", comment: ""),"Price per hour",NSLocalizedString("performance", comment: ""),NSLocalizedString("with_driver", comment: ""),NSLocalizedString("pick_drop", comment: ""),NSLocalizedString("year_manufacture", comment: ""),NSLocalizedString("vehicle_number", comment: ""),NSLocalizedString("service_area_distance_kms", comment: ""),NSLocalizedString("available_timings", comment: ""),NSLocalizedString("minimum_service_hours", comment: ""),NSLocalizedString("description", comment: "")]
    
 //   var arrProviderTitles = ["Maker","Model","Performance","With driver","Pick and drop","Year of manufacture","Service area distance(in kms)","Minimum service(in hours)","Description :"]
   var arrProviderTitles = [NSLocalizedString("maker", comment: ""),NSLocalizedString("model", comment: ""),NSLocalizedString("performance", comment: ""),NSLocalizedString("with_driver", comment: ""),NSLocalizedString("pick_drop", comment: ""),NSLocalizedString("year_manufacture", comment: ""),NSLocalizedString("service_area_distance_kms", comment: ""),NSLocalizedString("minimum_service_hours", comment: ""),NSLocalizedString("description", comment: "")]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblequipmentDetails?.estimatedRowHeight = 30
        tblequipmentDetails?.rowHeight = UITableViewAutomaticDimension
        tblequipmentDetails?.tableFooterView = UIView()
        self.pagecontrol?.hidesForSinglePage = true
        self.collectionImages?.showsHorizontalScrollIndicator = false
        self.tblequipmentDetails?.borderColor = UIColor.lightGray
        self.tblequipmentDetails?.borderWidth = 1.0
       
        navMoreOptionsButton = UIButton(frame: CGRect(x:UIScreen.main.bounds.size.width-42,y: 5,width: 40,height: 40))
        navMoreOptionsButton.backgroundColor =  UIColor.clear
        navMoreOptionsButton.setImage( UIImage(named: "MoreOptions"), for: UIControlState())
        navMoreOptionsButton.addTarget(self, action: #selector(PSViewEquipmentViewController.moreOptionsButtonClick(_:)), for: UIControlEvents.touchUpInside)
        self.topView?.addSubview(navMoreOptionsButton)
        
        btnNavigation?.isHidden = true
        ratingView?.isHidden = true
        let userObj = Constatnts.getUserObject()
        if self.isFromDeeplink == true {
            if let deeplinkTempParams = self.deeplinkParams as NSDictionary? {
                if let ownerId = deeplinkTempParams.value(forKey: Equipment_Owner_Id) as? String{
                    if let equipmentId = deeplinkTempParams.value(forKey: Equipment_Id) as? String{
                        if ownerId != (userObj.customerId as String? ?? ""){
                            self.isFromRequester = true
                        }
                        self.selectedEquipment = Equipment(dict: NSDictionary())
                        self.selectedEquipment?.equipmentId = equipmentId as NSString
                    }
                }
            }
        }
        var shareButtonFrame = CGRect(x:UIScreen.main.bounds.size.width-42,y: 6,width: 40,height: 40)
        if isFromRequester == false {
            shareButtonFrame = CGRect(x:UIScreen.main.bounds.size.width-80,y: 6,width: 40,height: 40)
        }
        shareButton = UIButton(frame: shareButtonFrame)
        shareButton.backgroundColor =  UIColor.clear
        shareButton.setImage( UIImage(named: "Share"), for: UIControlState())
        shareButton.addTarget(self, action: #selector(PSViewEquipmentViewController.shareButtonClick(_:)), for: UIControlEvents.touchUpInside)
        self.topView?.addSubview(shareButton)
        if isFromRequester == true {
            self.shareButton.isHidden = false
            navMoreOptionsButton.isHidden = true
            btnNavigation?.isHidden = false
           let booknowStr = NSLocalizedString("booknow", comment: "")
            btnEdit?.setTitle(booknowStr, for: .normal)
        }
        btnNext?.isHidden = true
        btnPrevious?.isHidden = true
        pagecontrol?.isHidden = true
        self.recordScreenView("PSViewEquipmentViewController", View_Equipment)
        if isFromRequester {
            let fireBaseParams = [MOBILE_NUMBER: userObj.mobileNumber!,USER_ID: userObj.customerId,EQUIPMENT_ID:self.selectedEquipment?.equipmentId ?? ""]
            self.registerFirebaseEvents(PV_FSR_View_Equipment_Full_Details, "", "", "", parameters: fireBaseParams as NSDictionary)
        }
        else{
            let fireBaseParams = [MOBILE_NUMBER: userObj.mobileNumber!,USER_ID: userObj.customerId,EQUIPMENT_ID:self.selectedEquipment?.equipmentId]
            self.registerFirebaseEvents(PV_FSP_View_Equipments, "", "", "", parameters: fireBaseParams as NSDictionary)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 10.0, *) {
            self.automaticallyAdjustsScrollViewInsets = true
        }
        super.viewWillAppear(animated)
        self.showCartButton(false)
        self.hideFilterButton(true)
        self.hideClearButton(true)
        self.topView?.isHidden = false
        self.lblTitle?.text = selectedEquipment?.classification as String?
        if self.selectedEquipment != nil {
            self.getEquipmentsDetailsWithEquipmentId(equipment:selectedEquipment!)
        }
    }
    
    func getEquipmentsDetailsWithEquipmentId(equipment:Equipment){
        let headers : HTTPHeaders = self.getProviderHeaders()
        print(headers)
        SwiftLoader.show(animated: true)
        let urlString = String(format: "%@%@", arguments: [BASE_URL,View_Equipment_Details])
        var equipLocation = "true"
        if isFromRequester == true {
            equipLocation = "false"
        }
        let parameters = ["equipmentId":equipment.equipmentId!,"isProvider": equipLocation] as [String : Any]
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
                       // print("Response after decrypting data:\(decryptData)")
                        if let equipDic = decryptData as NSDictionary?{
                            self.imagesArray.removeAllObjects()
                            self.pagecontrol?.numberOfPages = 0
                            self.pagecontrol?.isHidden = true
                            self.viewEquipment = Equipment(dict: equipDic)
                            if self.isFromDeeplink == true{
                                self.lblTitle?.text = self.viewEquipment?.equipmentClassification as String?
                            }
                            if self.viewEquipment!.arrImageUrls.count > 0{
                                self.imagesArray.addObjects(from: self.viewEquipment!.arrImageUrls as! [Any])
                                self.pagecontrol?.numberOfPages = self.imagesArray.count
                            }
                            self.ratingView?.isHidden = true
                            if self.viewEquipment?.rating?.floatValue ?? 0 > 0{
                                self.ratingView?.isHidden = false
                                self.lblRating?.text = self.viewEquipment?.rating as String?
                            }
                            if self.imagesArray.count == 1{
                                self.btnNext?.isHidden = true
                                self.btnPrevious?.isHidden = true
                            }
                            else if self.imagesArray.count == 2{
                                self.btnPrevious?.isHidden = true
                                self.btnNext?.isHidden = false
                            }
                            else{
                                self.btnNext?.isHidden = false
                                self.btnPrevious?.isHidden = false
                            }
                            self.collectionImages?.reloadData()
                            self.tblequipmentDetails?.reloadData()
                            if self.isFromRequester == false{
                                if (Validations.isNullString(self.viewEquipment?.availableDates ?? "" as NSString) == false || Validations.isNullString(self.viewEquipment?.fullyAvailableDates ?? "" as NSString) == false) && (self.viewEquipment?.isEnabled == true && self.viewEquipment?.isBlocked == false){
                                    self.shareButton.isHidden = false
                                    self.selectedEquipment?.status = "Enabled"
                                }
                                else if self.viewEquipment?.isBlocked == true{
                                    self.equipmentBlockedAlert = CustomAlert.alertInfoPopUpView(self, frame: self.view.frame, title: NSLocalizedString("alert", comment: "") as NSString, message: NSLocalizedString("equipment_blocked_admin", comment: "") as NSString
                                        , buttonTitle: NSLocalizedString("ok", comment: ""), hideClose: true) as! UIView
                                    self.view.addSubview(self.equipmentBlockedAlert)
                                }
                                else{
                                    self.shareButton.isHidden = true
                                    self.selectedEquipment?.status = "Disabled"
                                }
                            }
                            else{
                                if self.viewEquipment?.isBlocked == true{
                                    self.equipmentBlockedAlert = CustomAlert.alertInfoPopUpView(self, frame: self.view.frame, title: NSLocalizedString("alert", comment: "") as NSString, message: NSLocalizedString("equipment_blocked", comment: "") as NSString, buttonTitle: NSLocalizedString("ok", comment: ""), hideClose: true) as! UIView
                                    self.view.addSubview(self.equipmentBlockedAlert)
                                }
                            }
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
    
    func deleteEquipmentFromUserList(){
        if self.selectedEquipment != nil {
            let headers : HTTPHeaders = self.getProviderHeaders()
            print(headers)
            SwiftLoader.show(animated: true)
            let urlString = String(format: "%@%@", arguments: [BASE_URL,Delete_Equipment_Details])
            let parameters = ["equipmentId":selectedEquipment!.equipmentId!] as [String : Any]
            let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
            let params =  ["data" : paramsStr]
            print(params)
            Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                SwiftLoader.hide()
                if response.result.error == nil {
                    if let json = response.result.value {
                       // print("Response :\(json)")
                        let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                        if responseStatusCode == STATUS_CODE_200 || responseStatusCode == CURRENTLY_NO_EQUIPMENTS_AVAILABLE {
                        
                            let res = (json as! NSDictionary).value(forKey: "response")! as? String
                            if res == nil {
                                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                                appDelegate?.window?.makeToast(Equipment_Delete_Successfully)
                                self.navigationController?.popViewController(animated: true)
                            }
                            else{
                                let respData = (json as! NSDictionary).value(forKey: "response") as! String
                                let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                               // print("Response after decrypting data:\(decryptData)")
                                if responseStatusCode == CURRENTLY_NO_EQUIPMENTS_AVAILABLE{
                                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                                    appDelegate?.window?.makeToast(Equipment_Delete_Successfully)
                                }
                                self.navigationController?.popViewController(animated: true)
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
    }
    //MARK: UITableview delegate and datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewEquipment != nil {
            if isFromRequester == true{
                return arrRequesterTitles.count + 1
            }
            return arrProviderTitles.count + 1
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
        var cellIdentifier =  "EquipDetailCell"
        if indexPath.row == 9 && isFromRequester == false {
            cellIdentifier = "HyperLinkCell"
        }
        else if indexPath.row == 12 && isFromRequester == true {
            cellIdentifier = "HyperLinkCell"
        }
        else if indexPath.row == 8 && isFromRequester == false {
            cellIdentifier = "DescriptionCell"
        }
        else if indexPath.row == 11 && isFromRequester == true {
            cellIdentifier = "DescriptionCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let lblTitle = cell.viewWithTag(101) as? UILabel
        let lblValue = cell.viewWithTag(102) as? UILabel
        if isFromRequester == true{
            if indexPath.row < arrRequesterTitles.count {
                if let title = arrRequesterTitles[indexPath.row] as String?{
                    lblTitle?.text = title
                }
            }
        }
        else{
            if indexPath.row < arrProviderTitles.count {
                if let title = arrProviderTitles[indexPath.row] as String?{
                    lblTitle?.text = title
                }
            }
        }
        cell.textLabel?.font = lblValue?.font
        cell.textLabel?.textColor = lblValue?.textColor
        cell.textLabel?.numberOfLines = 6
        switch indexPath.row {
        case 0:
            if isFromRequester == true{
                lblValue?.text = viewEquipment?.maker as String?
            }
            else{
                lblValue?.text = viewEquipment?.maker as String?
            }
            break
        case 1:
            if isFromRequester == true{
                lblValue?.text = viewEquipment?.model as String?
            }
            else{
                lblValue?.text = viewEquipment?.model as String?
            }
            break
        case 2:
            if isFromRequester == true{
                lblValue?.text = viewEquipment?.pricePerHour as String?
            }
            else{
                lblValue?.text = viewEquipment?.performance as String?
            }
            break
        case 3:
            if isFromRequester == true{
                lblValue?.text = viewEquipment?.performance as String?
            }
            else{
                lblValue?.text = viewEquipment?.withDriver as String?
            }
            break
        case 4:
            if isFromRequester == true{
                lblValue?.text = viewEquipment?.withDriver as String?
            }
            else{
                lblValue?.text = viewEquipment?.pickAndDrop as String?
            }
            break
        case 5:
            if isFromRequester == true{
                lblValue?.text = viewEquipment?.pickAndDrop as String?
            }
            else{
                lblValue?.text = viewEquipment?.vehicleYear as String?
            }
            break
        case 6:
            if isFromRequester == true{
                lblValue?.text = viewEquipment?.vehicleYear as String?
            }
            else{
                lblValue?.text = viewEquipment?.maxSerAreaDistProvided as String?
            }
            break
        case 7:
            if isFromRequester == true{
                lblValue?.text = viewEquipment?.equipmentVehicleNumber as String?
            }
            else{
                lblValue?.text = viewEquipment?.minimumServiceHours as String?
            }
            break
        case 8:
            if isFromRequester == true{
                lblValue?.text = viewEquipment?.serviceAreaDistance as String?
            }
            else{
                let lblDescTitle = cell.viewWithTag(106) as? UILabel
                let lblDesc = cell.viewWithTag(107) as? UILabel
                lblDesc?.text = viewEquipment?.equipmentDescription as String?
                lblDescTitle?.text = NSLocalizedString("description", comment: "")//String(format: "Description :")
            }
            break
        case 9:
            if isFromRequester == true{
                lblValue?.text = viewEquipment?.availableTimings as String?
            }
            else{
                let lblAddress = cell.viewWithTag(105) as? UILabel
                lblAddress?.text = String(format: "%@", (viewEquipment?.equipmentLocationName)!)
                /*let lblCancelation = cell.viewWithTag(104) as? ActiveLabel
                if lblCancelation != nil{
                    self.setupActiveLabelClick(cancelationLabel: lblCancelation!)
                }*/
            }
            break
        case 10:
            lblValue?.text = viewEquipment?.minimumServiceHours as String?
            break
        case 11:
            let lblDescTitle = cell.viewWithTag(106) as? UILabel
            let lblDesc = cell.viewWithTag(107) as? UILabel
            lblDesc?.text = viewEquipment?.equipmentDescription as String?
            lblDescTitle?.text = NSLocalizedString("description", comment: "")//String(format: "Description :")
            break
        case 12:
            let lblAddress = cell.viewWithTag(105) as? UILabel
            lblAddress?.text = String(format: "%@", (viewEquipment?.equipmentLocationName)!)
            /*let lblCancelation = cell.viewWithTag(104) as? UIButton
            if lblCancelation != nil{
                self.setupActiveLabelClick(cancelationLabel: lblCancelation!)
            }*/
            break
        default:
            break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func setupActiveLabelClick(cancelationLabel: ActiveLabel){
        let customType = ActiveType.custom(pattern: "\\sCancellation policy\\b")
        
        cancelationLabel.enabledTypes.append(customType)
        cancelationLabel.customColor[customType] = UIColor.blue

        cancelationLabel.customize({(label) in
            label.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                switch type {
                case customType:
                    atts[NSAttributedStringKey.underlineStyle] = isSelected ? NSUnderlineStyle.styleSingle.rawValue : NSUnderlineStyle.styleSingle.rawValue
                    atts[NSAttributedStringKey.foregroundColor] = isSelected ? UIColor(red: 255.0/255.0, green: 153.0/255.0, blue: 0.0/255.0, alpha: 1.0) : UIColor(red: 255.0/255.0, green: 153.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                default: ()
                }
                return atts
            }
            label.handleCustomTap(for: customType, handler: { (message) in
                let net = NetworkReachabilityManager(host: "www.google.com")
                if net?.isReachable == true{
                    if Validations.isNullString((self.selectedEquipment?.cancelationPolicyUrl)!) == false{
                        let cancelPolicyController = self.storyboard?.instantiateViewController(withIdentifier: "LoginPrivacyPolicyViewController") as? LoginPrivacyPolicyViewController
                        cancelPolicyController?.privacyPolicyURLStr = (self.selectedEquipment?.cancelationPolicyUrl!)!
                        cancelPolicyController?.isFromCanellationPolicy = true
                        self.navigationController?.pushViewController(cancelPolicyController!, animated: true)
                    }
                }
                else{
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                    return
                }
            })
            label.customColor[customType] = UIColor.blue
        })
    }
    @IBAction func cancellationPolicyButtonClick(_ sender: UIButton){
        if viewEquipment != nil {
            if Validations.isNullString((self.viewEquipment?.cancelationPolicyUrl)!) == false{
                let cancelPolicyController = self.storyboard?.instantiateViewController(withIdentifier: "LoginPrivacyPolicyViewController") as? LoginPrivacyPolicyViewController
                cancelPolicyController?.privacyPolicyURLStr = (self.viewEquipment?.cancelationPolicyUrl!)!
                cancelPolicyController?.isFromCanellationPolicy = true
                self.navigationController?.pushViewController(cancelPolicyController!, animated: true)
                let userObj = Constatnts.getUserObject()
                let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber,USER_ID:userObj.customerId,EQUIPMENT_ID:self.viewEquipment!.equipmentId!]
                if isFromRequester == true{
                    self.registerFirebaseEvents(FSR_EqupmntView_CancelPolicy, "", "", "", parameters: fireBaseParams as NSDictionary)
                }
                else{
                    self.registerFirebaseEvents(FSP_EqupmntView_CancelPolicy, "", "", "", parameters: fireBaseParams as NSDictionary)
                }
            }
        }
    }
    //MARK: collectionView datasource and delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionImages?.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        let equipmentImage = imagesArray.object(at: indexPath.row) as? NSString
        let imageView = cell?.viewWithTag(100) as? UIImageView
        let imageUrl = URL(string: equipmentImage! as String? ?? "")
        imageView?.kf.setImage(with: imageUrl as Resource?, placeholder: UIImage(named: "image_placeholder.png"), options: nil, progressBlock: nil)
        /*imageView?.kf.setImage(with: imageUrl as Resource!, placeholder: UIImage(), options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
            imageView?.contentMode = .scaleAspectFit
        })*/
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width-2), height: (collectionView.frame.size.height))
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pagecontrol?.currentPage = indexPath.row
        lblPhotiCount?.text = String(format: "%@ : %d / %d",NSLocalizedString("photos", comment: ""), indexPath.row + 1, (self.pagecontrol?.numberOfPages)!)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(1, 1, 1, 1)//top,left,bottom,right
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let collectionCell = collectionView.cellForItem(at: indexPath) as UICollectionViewCell? {
            if let imageView = collectionCell.viewWithTag(100) as? UIImageView{
                let viewEquipImageController = self.storyboard?.instantiateViewController(withIdentifier: "EquipmentImageViewController") as? EquipmentImageViewController
                viewEquipImageController?.equipImage = imageView.image
                self.navigationController?.present(viewEquipImageController!, animated: true, completion: nil)
            }
        }
    }
    //MARK: UIPopOver controller delegate methods
    
    func adaptivePresentationStyle(
        for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    //MARK: ButtonClick Methods
    
    @IBAction func editEquipmentButtonClick(_ sender: UIButton){
        if viewEquipment != nil && isFromRequester == false{
            if self.viewEquipment?.isEnabled == true{
                let userObj = Constatnts.getUserObject()
                let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId,EQUIPMENT_ID: viewEquipment?.equipmentId!]
                self.registerFirebaseEvents(FSP_Edit_Equipment, "", "", "", parameters: fireBaseParams as NSDictionary)
                let addEquipmentController = self.storyboard?.instantiateViewController(withIdentifier: "AddEquipmentViewController") as? AddEquipmentViewController
                addEquipmentController?.isFromEdit = true
                addEquipmentController?.selectedEquipment = viewEquipment
                self.navigationController?.pushViewController(addEquipmentController!, animated: true)
            }
            else{
                self.view.makeToast(NSLocalizedString("equipment_disabled", comment: ""))
            }
        }
        else if viewEquipment != nil && isFromRequester == true{
            if self.viewEquipment?.isBlocked == false && self.viewEquipment?.isEnabled == true {
                if Validations.isNullString(self.viewEquipment?.availableDates ?? "") == false || Validations.isNullString(self.viewEquipment?.fullyAvailableDates ?? "") == false{
                                    if  self.viewEquipment?.equipmentClassificationId == "5" {
                                    if  self.viewEquipment?.sprayRequestDone == true &&  self.viewEquipment?.billUploadDone == true {
                                    if  self.viewEquipment != nil{
                                        if Validations.isNullString(( self.viewEquipment?.equipmentId) ?? "") == false{
                                                    let userObj = Constatnts.getUserObject()
                                                                 let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId,EQUIPMENT_ID: viewEquipment?.equipmentId!]
                                                                 self.registerFirebaseEvents(FSR_Equipment_Full_Book_Now, "", "", "", parameters: fireBaseParams as NSDictionary)
                                                                 let bookEquipmentController = self.storyboard?.instantiateViewController(withIdentifier: "PSBookNowViewController") as? PSBookNowViewController
                                            bookEquipmentController?.cropId = cropId
                                                                 bookEquipmentController?.selectedEquipment = viewEquipment
                                                                 self.navigationController?.pushViewController(bookEquipmentController!, animated: true)
                                        }
                                    }
                                    }else if !(self.viewEquipment?.sprayRequestDone)! {
                                        isAlertFromSprayService = true
                                        
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
                                         
                                    }else if !(self.viewEquipment?.billUploadDone)! {
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
                                    }else {
                                        let userObj = Constatnts.getUserObject()
                                                   let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId,EQUIPMENT_ID: viewEquipment?.equipmentId!]
                                                   self.registerFirebaseEvents(FSR_Equipment_Full_Book_Now, "", "", "", parameters: fireBaseParams as NSDictionary)
                                                   let bookEquipmentController = self.storyboard?.instantiateViewController(withIdentifier: "PSBookNowViewController") as? PSBookNowViewController
                                        bookEquipmentController?.cropId = cropId
                                                   bookEquipmentController?.selectedEquipment = viewEquipment
                                                   self.navigationController?.pushViewController(bookEquipmentController!, animated: true)
                                    }

                    
                }
                else{
                    self.view.makeToast(NSLocalizedString("equipment_not_available", comment: ""))
                }
            }
            else{
                self.view.makeToast(NSLocalizedString("equipment_not_available", comment: ""))
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
   
    
       @IBAction func shareButtonClick( _ sender: UIButton)
    {
        if self.viewEquipment != nil {
            let userObj = Constatnts.getUserObject()
            let urlPath = String(format: "%@=%@&%@=%@&%@=%@&%@=%@", Module,Equipment_View_Details,subModule,planterServices,Equipment_Id,self.viewEquipment?.equipmentId ?? "",Equipment_Owner_Id,self.viewEquipment?.ownerId ?? "")
            let finalUrl = String(format: "%@%@", deepLinkBaseUrl,urlPath)
            let message = String(format: "%@ %@ %@", self.viewEquipment?.maker ?? "",self.viewEquipment?.model ?? "",self.viewEquipment?.equipmentClassification ?? "")
            let activityControl = Validations.showShareActivityController(viewController: self, fileUrl: URL(string: finalUrl)!, userName: "", message: message)
            let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId,EQUIPMENT_ID: viewEquipment?.equipmentId!,Firebase_owner_Id:self.viewEquipment?.ownerId]
            if self.isFromRequester == true{
                self.registerFirebaseEvents(FSR_Equipment_Share, "", "", "", parameters: fireBaseParams as NSDictionary)
            }
            else{
                self.registerFirebaseEvents(FSP_Equipment_Share, "", "", "", parameters: fireBaseParams as NSDictionary)
            }
            self.present(activityControl, animated: true, completion: nil)
        }
    }
    @IBAction func equipmentNavigationButtonClick(_ sender: UIButton){
        if LocationService.sharedInstance.currentLocation != nil && (Validations.isNullString(viewEquipment?.latitude ?? "") == false && Validations.isNullString(viewEquipment?.longitude ?? "") == false){
            let orderCoordinates = CLLocationCoordinate2D(latitude: viewEquipment?.latitude?.doubleValue ?? 0, longitude: viewEquipment?.longitude?.doubleValue ?? 0)
            FarmServicesConstants.getRoutesWithgoogle((LocationService.sharedInstance.currentLocation?.coordinate)!, departMentCoordinates: orderCoordinates)
            self.registerFirebaseEvents(PV_FSR_View_Equipment_Directions, "", "", "", parameters: nil)
        }
    }
    @IBAction func equipmentRatingsButtonClick(_ sender: UIButton){
        if viewEquipment != nil{
            let toRequesterRatingVC = self.storyboard?.instantiateViewController(withIdentifier: "RequesterRatingViewController") as! RequesterRatingViewController
            toRequesterRatingVC.selectedEquipment = self.viewEquipment
            let userObj = Constatnts.getUserObject()
            let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId,EQUIPMENT_ID:self.viewEquipment?.equipmentId]
            if isFromRequester == true{
                self.registerFirebaseEvents(FSR_View_EquipRating, "", "", "", parameters: fireBaseParams as NSDictionary)
            }
            else{
                self.registerFirebaseEvents(FSP_Equipment_View_Rating, "", "", "", parameters: fireBaseParams as NSDictionary)
            }
            self.navigationController?.pushViewController(toRequesterRatingVC, animated: true)
        }
    }
    @IBAction func disableEquipmentButtonClick(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
        if self.selectedEquipment != nil {
            let userObj = Constatnts.getUserObject()
            let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber,USER_ID:userObj.customerId,EQUIPMENT_ID:self.selectedEquipment!.equipmentId!]
            self.registerFirebaseEvents(FSP_Disable_Equipment, "", "", "", parameters: fireBaseParams as NSDictionary)
            let headers : HTTPHeaders = self.getProviderHeaders()
            print(headers)
            SwiftLoader.show(animated: true)
            let urlString = String(format: "%@%@", arguments: [BASE_URL,Disable_Equipment_Details])
            let parameters = ["equipmentId":selectedEquipment!.equipmentId!] as [String : Any]
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
                           // print("Response after decrypting data:\(decryptData)")
                            self.navigationController?.popViewController(animated: true)
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
    }
    @IBAction func deleteEquipmentButtonClick(_ sender: UIButton){
        if self.selectedEquipment != nil{
            self.dismiss(animated: true, completion: nil)
            self.equipmentDeleteAlert = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: NSLocalizedString("alert", comment: "") as NSString, message: String(format: "%@ %@ ?",NSLocalizedString("delete_this_sure", comment: ""),(selectedEquipment?.classification)!) as NSString, okButtonTitle: NSLocalizedString("ok", comment: ""), cancelButtonTitle: NSLocalizedString("cancel", comment: "")) as! UIView
            self.view.addSubview(self.equipmentDeleteAlert)
        }
    }
    @IBAction func previousImageButtonClick(_sender: UIButton){
        if imagesArray.count > 0{
            var visibleRect = CGRect()
            visibleRect.origin = collectionImages!.contentOffset
            visibleRect.size = collectionImages!.bounds.size
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let visibleIndexPath = collectionImages!.indexPathForItem(at: visiblePoint) as IndexPath? {
                if visibleIndexPath.row > 0{
                    if visibleIndexPath.row - 1 >= 0{
                        collectionImages?.scrollToItem(at: IndexPath(row: visibleIndexPath.row - 1, section: 0), at: .left, animated: true)
                        btnNext?.isHidden = false
                        if visibleIndexPath.row - 1 == 0{
                            btnPrevious?.isHidden = true
                        }
                    }
                }
            }
        }
    }
    @IBAction func nextImageButtonClick(_sender: UIButton){
        if imagesArray.count > 0{
            var visibleRect = CGRect()
            visibleRect.origin = collectionImages!.contentOffset
            visibleRect.size = collectionImages!.bounds.size
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let visibleIndexPath = collectionImages!.indexPathForItem(at: visiblePoint) as IndexPath? {
                if visibleIndexPath.row < imagesArray.count - 1{
                    if visibleIndexPath.row + 1 < imagesArray.count{
                        collectionImages?.scrollToItem(at: IndexPath(row: visibleIndexPath.row + 1, section: 0), at: .left, animated: true)
                        btnPrevious?.isHidden = false
                        if visibleIndexPath.row + 1 == imagesArray.count - 1{
                            btnNext?.isHidden = true
                        }
                    }
                }
            }
        }
    }
    @IBAction func enableEquipmentButtonClick(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
        if self.selectedEquipment != nil {
            let userObj = Constatnts.getUserObject()
            let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber,USER_ID:userObj.customerId,EQUIPMENT_ID:self.selectedEquipment!.equipmentId!]
            self.registerFirebaseEvents(FSP_Enable_Equipment, "", "", "", parameters: fireBaseParams as NSDictionary)
            let headers : HTTPHeaders = self.getProviderHeaders()
            print(headers)
            SwiftLoader.show(animated: true)
            let urlString = String(format: "%@%@", arguments: [BASE_URL,Enable_Equipment_Details])
            let parameters = ["equipmentId":selectedEquipment!.equipmentId!] as [String : Any]
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
                            self.navigationController?.popViewController(animated: true)
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
    }
    @IBAction func moreOptionsButtonClick( _ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
        let popoverContent =  UIViewController()
        let btnDisable  = UIButton(type: .custom)
        btnDisable.frame = CGRect(x: 5, y: 20, width: 140, height: 30)
        if self.selectedEquipment?.status != "Disabled" {
            btnDisable.setTitle(NSLocalizedString("disable", comment: ""), for: .normal)
            btnDisable.addTarget(self, action: #selector(PSViewEquipmentViewController.disableEquipmentButtonClick(_:)), for: UIControlEvents.touchUpInside)
        }
        else{
            btnDisable.setTitle(NSLocalizedString("enable", comment: ""), for: .normal)
            btnDisable.addTarget(self, action: #selector(PSViewEquipmentViewController.enableEquipmentButtonClick(_:)), for: UIControlEvents.touchUpInside)
        }
        btnDisable.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        btnDisable.setTitleColor(UIColor.black, for: .normal)
        popoverContent.view.addSubview(btnDisable)
        let lblLine = UILabel(frame: CGRect(x: 3, y: 54, width: 144, height: 1))
        lblLine.backgroundColor = UIColor.black
        lblLine.text = ""
        popoverContent.view.addSubview(lblLine)
        let btnDelete  = UIButton(type: .custom)
        btnDelete.frame = CGRect(x: 5, y: 63, width: 140, height: 30)
        btnDelete.setTitle(NSLocalizedString("delete", comment: ""), for: .normal)
        btnDelete.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        btnDelete.addTarget(self, action: #selector(PSViewEquipmentViewController.deleteEquipmentButtonClick(_:)), for: UIControlEvents.touchUpInside)
        btnDelete.setTitleColor(UIColor.black, for: UIControlState())
        popoverContent.view.addSubview(btnDelete)
        
        popoverContent.modalPresentationStyle = .popover
        popoverContent.preferredContentSize   = CGSize(width: 140, height: 90)
        
        let popoverPresentationViewController = popoverContent.popoverPresentationController!
        popoverPresentationViewController.permittedArrowDirections = UIPopoverArrowDirection.up
        popoverPresentationViewController.delegate = self
        popoverPresentationViewController.sourceRect = CGRect(x: UIScreen.main.bounds.size.width - 85,y: 60,width: 100,height: 0)
        
        popoverPresentationViewController.sourceView = self.view.superview
        self.popoverPresentationController?.backgroundColor = UIColor.white
        self.present(popoverContent, animated: true, completion: nil)
        if #available(iOS 10.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    //MARK: alertYesBtnAction
    /**
     YES button action of the alertView which is displayed to the user
     when already logged in other device
     */
    @objc func alertYesBtnAction(){
        if isAlertFromSprayService == false{
        equipmentDeleteAlert.removeFromSuperview()
        let userObj = Constatnts.getUserObject()
        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId,EQUIPMENT_ID: viewEquipment?.equipmentId!]
        self.registerFirebaseEvents(FSP_Equipment_Delete, "", "", "", parameters: fireBaseParams as NSDictionary)
        self.deleteEquipmentFromUserList()
        }else {
            isAlertFromSprayService = false
            loginAlertView.removeFromSuperview()
                  let SprayServiceVC = self.storyboard?.instantiateViewController(withIdentifier: "SprayServiceViewController") as? SprayServiceViewController
                         self.navigationController?.pushViewController(SprayServiceVC!, animated: true)
        }
    }
    
    @objc func infoAlertSubmit(){
        self.equipmentBlockedAlert.removeFromSuperview()
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: alertNoBtnAction
    /**
     NO button action of the alertView which is displayed to the user
     when already logged in other device
     */
    @objc func alertNoBtnAction(){
        equipmentDeleteAlert.removeFromSuperview()
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
