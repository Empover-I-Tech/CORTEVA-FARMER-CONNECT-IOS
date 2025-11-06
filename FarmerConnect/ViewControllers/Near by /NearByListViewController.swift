//
//  NearByListViewController.swift
//  PioneerEmployee
//
//  Created by Empover on 12/08/20.
//  Copyright © 2020 Empover. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class NearByListViewController: BaseViewController {
    
    @IBOutlet weak var  globaloDataLbl: UILabel!
    @IBOutlet weak var nearListFaremer : UITableView!
    @IBOutlet var FarmerStack: UIStackView!
    @IBOutlet weak var  farmerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var  farmerTopView: UIView!
    @IBOutlet weak var  farmerView: UIView!
    @IBOutlet weak var  farmerTopImageView: UIImageView!
    @IBOutlet weak var  farmerNoDataLbl: UILabel!
    @IBOutlet weak var RetailerList : UITableView!
    @IBOutlet var RetailerStack: UIStackView!
    @IBOutlet weak var  RetailerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var  RetailerTopView: UIView!
    @IBOutlet weak var  RetailerView: UIView!
    @IBOutlet weak var  RetailerTopImageView: UIImageView!
    @IBOutlet weak var  RetailerNoDataLbl: UILabel!
    @IBOutlet weak var PravtktaList : UITableView!
    @IBOutlet var PravtktaStack: UIStackView!
    @IBOutlet weak var  PravtktaHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var  PravtktaTopView: UIView!
    @IBOutlet weak var  PravtktaView: UIView!
    @IBOutlet weak var  PravtktaTopImageView: UIImageView!
    @IBOutlet weak var  PravtktaNoDataLbl: UILabel!
    @IBOutlet weak var BigfarmerList : UITableView!
    @IBOutlet var BigfarmerStack: UIStackView!
    @IBOutlet weak var  BigfarmerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var  BigfarmerTopView: UIView!
    @IBOutlet weak var  BigfarmerView: UIView!
    @IBOutlet weak var  BigfarmerTopImageView: UIImageView!
    @IBOutlet weak var  BigfarmerNoDataLbl: UILabel!
    
    
    
    var paramsDic = NSMutableDictionary()
    var farmersArray =  [NearByModel]()
    var BigfarmersArray =  [NearByModel]()
    var RetailerArray =  [NearByModel]()
    var PravakthaArray =  [NearByModel]()
    
    var sectionNames = [SectionDetails]()
    let kHeaderSectionTag: Int = 6900;
    var theImageView = UIImageView()
    @IBOutlet weak var  farmerVSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var  pravktaVSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var  BigfarmerVSpacingConstraint: NSLayoutConstraint!
    
    var minRecord = "0"
    var modelType = "nearBy"
    var allString = "null"
    var farmerString = "null"
    var retailerString = "null"
    var bigFarmerStr = "null"
    var Pravaktastr = "null"
    
    
    var isDataLoading = false
    var isFromCount  : Bool = false
    var activitabele = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func stackHeightSetInitial(){
        farmerHeightConstraint.constant    = 50.0
        PravtktaHeightConstraint.constant  = 0.0
        BigfarmerHeightConstraint.constant = 0.0
        RetailerHeightConstraint.constant  = 0.0
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.topView?.isHidden = false
        self.lblTitle?.text = "Near By"
        self.setStatusBarBackgroundColor(color :App_Theme_Blue_Color)
        self.topView?.backgroundColor = App_Theme_Blue_Color
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        
//        PV_NearByList_success_Request
        let userObj = Constatnts.getUserObject()
        let firebaseParams = ["Mobile_Number": userObj.mobileNumber!,"User_Id":userObj.customerId!,"screen_name":"NearByListViewController"] as [String : Any]
               self.registerFirebaseEvents("Near_by_List", "", "", "", parameters: firebaseParams as NSDictionary)
        
        requestToGetgetlist(params: paramsDic)
        allString      =  paramsDic.value(forKey: "actALL") as? String ?? "null"
        farmerString   =  paramsDic.value(forKey: "actByFar") as? String ?? "null"
        retailerString =  paramsDic.value(forKey: "actByRet") as? String ?? "null"
        bigFarmerStr   =  paramsDic.value(forKey: "actBigFarmer") as? String ?? "null"
        Pravaktastr    =  paramsDic.value(forKey: "actPravakta") as? String ?? "null"
        
        self.stackHeightSetInitial()
        globaloDataLbl.isHidden = true
        FarmerStack.isHidden    = true
        RetailerStack.isHidden  = true
        BigfarmerStack.isHidden = true
        PravtktaStack.isHidden  = true

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.setStatusBarBackgroundColor(color :App_Theme_Blue_Color)
        self.topView?.isHidden = true
    }
    
    func requestToGetgetlist(params : NSMutableDictionary){
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL_NEARBY,GET_NEARBY_LOCAL_DATA]  )
        let paramsStr = Constatnts.nsobjectToJSON(params)
        let params =  ["data" : paramsStr]
        
        print(params)
        globaloDataLbl.isHidden = true
        Alamofire.request(urlString, method: .post, parameters :  params , encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    
                    print(response)
                    let responseStatusCode = (json as? NSDictionary)?.value(forKey: "statusCode") as? String ?? ""
                    if responseStatusCode == "200"{
                        let respData = (json as? NSDictionary)?.value(forKey: "response") as? NSString ?? ""
                        PV_NearByList_success_Request
                        if respData != ""{
                            let json : NSDictionary  = Constatnts.decryptResult(StrJson: respData as String)
                            print("Response after decrypting data:\(json)")
                            
                            let arrayStatus = NSMutableArray()
                            for (key, _) in json {
                                print("\(key)")
                                arrayStatus.add("\(key)")
                            }
                            
                            let claimTrans = json.value(forKey: "retailersDetailsList") as? NSArray
                            if claimTrans?.count ?? 0 > 0 {
                                for i in claimTrans ?? [] {
                                    let arrTrans = NearByModel()
                                    arrTrans.distance = (i as AnyObject).value(forKey:"distance") as? String ?? ""
                                    arrTrans.custName = (i as AnyObject).value(forKey:"custName") as? String ?? ""
                                    arrTrans.custMobileNumber = (i as AnyObject).value(forKey:"custMobileNumber") as? String ?? ""
                                    arrTrans.crop = (i as AnyObject).value(forKey:"crop") as? String ?? ""
                                    arrTrans.activity = (i as AnyObject).value(forKey:"activity") as? String ?? ""
                                    arrTrans.territory = (i as AnyObject).value(forKey:"territory") as? String ?? ""
                                    arrTrans.pincode = (i as AnyObject).value(forKey:"pincode") as? String ?? ""
                                    arrTrans.imgUrl = (i as AnyObject).value(forKey:"imgUrl") as? String ?? ""
                                    self.RetailerArray.append(arrTrans)
                                }
                            }
                            
                            let bigfarmerArray = json.value(forKey: "bigFarmersDetailsList") as? NSArray
                            if bigfarmerArray?.count ?? 0 > 0 {
                                for i in bigfarmerArray ?? [] {
                                    let arrTrans = NearByModel()
                                    arrTrans.distance = (i as AnyObject).value(forKey:"distance") as? String ?? ""
                                    arrTrans.custName = (i as AnyObject).value(forKey:"custName") as? String ?? ""
                                    arrTrans.custMobileNumber = (i as AnyObject).value(forKey:"custMobileNumber") as? String ?? ""
                                    arrTrans.crop = (i as AnyObject).value(forKey:"crop") as? String ?? ""
                                    arrTrans.activity = (i as AnyObject).value(forKey:"activity") as? String ?? ""
                                    arrTrans.territory = (i as AnyObject).value(forKey:"territory") as? String ?? ""
                                    arrTrans.pincode = (i as AnyObject).value(forKey:"pincode") as? String ?? ""
                                    arrTrans.imgUrl = (i as AnyObject).value(forKey:"imgUrl") as? String ?? ""
                                    self.BigfarmersArray.append(arrTrans)
                                    
                                }
                            }
                            let pravaktaTrans = json.value(forKey: "pravakthaDetailsList") as? NSArray
                            if pravaktaTrans?.count ?? 0 > 0 {
                                for i in pravaktaTrans ?? [] {
                                    let arrTrans = NearByModel()
                                    arrTrans.distance = (i as AnyObject).value(forKey:"distance") as? String ?? ""
                                    arrTrans.custName = (i as AnyObject).value(forKey:"custName") as? String ?? ""
                                    arrTrans.custMobileNumber = (i as AnyObject).value(forKey:"custMobileNumber") as? String ?? ""
                                    arrTrans.territory = (i as AnyObject).value(forKey:"territory") as? String ?? ""
                                    arrTrans.crop = (i as AnyObject).value(forKey:"crop") as? String ?? ""
                                    arrTrans.activity = (i as AnyObject).value(forKey:"activity") as? String ?? ""
                                    arrTrans.pincode = (i as AnyObject).value(forKey:"pincode") as? String ?? ""
                                    arrTrans.imgUrl = (i as AnyObject).value(forKey:"imgUrl") as? String ?? ""
                                    self.PravakthaArray.append(arrTrans)
                                }
                            }
                            
                            let farmerDeailsTrans = json.value(forKey: "farmersDetailsList") as? NSArray
                            if farmerDeailsTrans?.count ?? 0 > 0 {
                                for i in farmerDeailsTrans ?? [] {
                                    let arrTrans = NearByModel()
                                    arrTrans.distance = (i as AnyObject).value(forKey:"distance") as? String ?? ""
                                    arrTrans.custName = (i as AnyObject).value(forKey:"custName") as? String ?? ""
                                    arrTrans.custMobileNumber = (i as AnyObject).value(forKey:"custMobileNumber") as? String ?? ""
                                    arrTrans.crop = (i as AnyObject).value(forKey:"crop") as? String ?? ""
                                    arrTrans.activity = (i as AnyObject).value(forKey:"activity") as? String ?? ""
                                    arrTrans.territory = (i as AnyObject).value(forKey:"territory") as? String ?? ""
                                    arrTrans.pincode = (i as AnyObject).value(forKey:"pincode") as? String ?? ""
                                    arrTrans.imgUrl = (i as AnyObject).value(forKey:"imgUrl") as? String ?? ""
                                    self.farmersArray.append(arrTrans)
                                }
                            }
                            
                            var secDetails = SectionDetails()
                            self.sectionNames.removeAll()
                            for i in arrayStatus {
                                let status = (i as? String)!
                                if status.lowercased() == "farmersdetailslist" && self.farmersArray.count > 0
                                    || status.lowercased() == "bigfarmersdetailslist" && self.BigfarmersArray.count > 0 || status.lowercased() == "retailersdetailslist" && self.RetailerArray.count > 0 || status.lowercased() == "pravakthadetailslist" && self.PravakthaArray.count > 0
                                {
                                    var transType = ""
                                    if status.lowercased() == "farmersdetailslist" {
                                        transType = "FARMERS"
                                    }else if status.lowercased() == "retailersdetailslist" {
                                        transType = "RETAILERS"
                                    }else if status.lowercased() == "bigfarmersdetailslist" {
                                        transType = "BIG FARMERS"
                                    }
                                    else if status.lowercased() == "pravakthadetailslist" {
                                        transType = "PRAVAKTHA"
                                    }
                                    secDetails.itemName  = transType
                                    secDetails.collapsed = false
                                    self.sectionNames.append(secDetails)
                                }
                            }
                            var SpacingConsta : CGFloat = 0.0
                            self.farmerVSpacingConstraint.constant = SpacingConsta
                            self.pravktaVSpacingConstraint.constant = SpacingConsta - 50.0
                            self.BigfarmerVSpacingConstraint.constant = SpacingConsta - 60.0
                            
                            
                            DispatchQueue.main.async {
                                if self.farmersArray.count == 0 && self.RetailerArray.count == 0  && self.BigfarmersArray.count == 0 && self.PravakthaArray.count == 0   {
                                    self.FarmerStack.isHidden = true
                                    self.RetailerStack.isHidden = true
                                    self.BigfarmerStack.isHidden = true
                                    self.PravtktaStack.isHidden = true
                                    self.globaloDataLbl.isHidden = false
                                    
                                }
                                if  self.RetailerArray.count > 0{
                                    self.RetailerStack.isHidden = false
                                    SpacingConsta += 2.0
                                    
                                    if self.farmersArray.count == 0  && self.BigfarmersArray.count == 0 {
                                        self.RetailerView.isHidden = false
                                        let heightConstant : CGFloat   = self.view.frame.height - 45
                                        self.RetailerHeightConstraint.constant = heightConstant
                                        self.retailerString = "Retailer"
                                        self.modelType = "Retailer"
                                        self.RetailerTopImageView.image = UIImage(named: "downroundIcon")
                                        self.RetailerList.reloadData()
                                    }
                                    
                                }
                                if  self.farmersArray.count > 0{
                                    self.FarmerStack.isHidden = false
                                    self.farmerVSpacingConstraint.constant = SpacingConsta
                                    SpacingConsta += 0.0
                                    
                                }
                                
                                if  self.PravakthaArray.count > 0{
                                    self.PravtktaStack.isHidden = false
                                    if self.farmersArray.count == 0 && self.RetailerArray.count == 0  && self.PravakthaArray.count == 0{
                                        self.pravktaVSpacingConstraint.constant = SpacingConsta - 20
                                    }
                                    else{
                                        self.pravktaVSpacingConstraint.constant = SpacingConsta
                                    }
                                    
                                    SpacingConsta += 0.0
                                }
                                
                                if self.BigfarmersArray.count > 0 {
                                    self.BigfarmerStack.isHidden = false
                                    if self.farmersArray.count == 0 && self.RetailerArray.count == 0  && self.PravakthaArray.count == 0{
                                        self.BigfarmerVSpacingConstraint.constant =  SpacingConsta - 50.0
                                    }
                                    else{
                                        self.BigfarmerVSpacingConstraint.constant = SpacingConsta
                                    }
                                    SpacingConsta += 0.0
                                }
                                
                            }
                            
                        }
                        else{
                            self.globaloDataLbl.isHidden = false
                            self.globaloDataLbl.text = (json as? NSDictionary)?.value(forKey: "message") as? NSString as String? ?? "" as String
                            self.view.makeToast((json as? NSDictionary)?.value(forKey: "message") as? NSString as String? ?? "" as String)
                        }
                    }
                    else if responseStatusCode == "601"{
                        Constatnts.logOut()
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    }
                }
            }
            else{
                self.FarmerStack.isHidden = true
                self.RetailerStack.isHidden = true
                self.BigfarmerStack.isHidden = true
                self.PravtktaStack.isHidden = true
                self.view.makeToast((response.error?.localizedDescription)!)
            }
        }
    }
    func requestToGetgetlistRetailer(params : NSMutableDictionary){
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL_NEARBY,GET_NEARBY_LOCAL_DATA]  )
        let paramsStr = Constatnts.nsobjectToJSON(params)
        let params =  ["data" : paramsStr]
        print(params)
        Alamofire.request(urlString, method: .post, parameters :  params , encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    
                    print(response)
                    let responseStatusCode = (json as? NSDictionary)?.value(forKey: "statusCode") as? String ?? ""
                    if responseStatusCode == "200"{
                        let respData = (json as? NSDictionary)?.value(forKey: "response") as? NSString ?? ""
                        
                        if respData != ""{
                            let json : NSDictionary  = Constatnts.decryptResult(StrJson: respData as String)
                            print("Response after decrypting data:\(json)")
                            
                            let arrayStatus = NSMutableArray()
                            for (key, _) in json {
                                print("\(key)")
                                arrayStatus.add("\(key)")
                            }
                            let claimTrans = json.value(forKey: "retailersDetailsList") as? NSArray
                            if claimTrans?.count ?? 0 > 0 {
                                for i in claimTrans ?? [] {
                                    let arrTrans = NearByModel()
                                    arrTrans.distance = (i as AnyObject).value(forKey:"distance") as? String ?? ""
                                    arrTrans.custName = (i as AnyObject).value(forKey:"custName") as? String ?? ""
                                    arrTrans.custMobileNumber = (i as AnyObject).value(forKey:"custMobileNumber") as? String ?? ""
                                    arrTrans.crop = (i as AnyObject).value(forKey:"crop") as? String ?? ""
                                    arrTrans.activity = (i as AnyObject).value(forKey:"activity") as? String ?? ""
                                    arrTrans.territory = (i as AnyObject).value(forKey:"territory") as? String ?? ""
                                    arrTrans.pincode = (i as AnyObject).value(forKey:"pincode") as? String ?? ""
                                    arrTrans.imgUrl = (i as AnyObject).value(forKey:"imgUrl") as? String ?? ""
                                    self.RetailerArray.append(arrTrans)
                                }
                            }
                            
                            var secDetails = SectionDetails()
                            for i in arrayStatus {
                                let status = (i as? String)!
                                if status.lowercased() == "farmersdetailslist" && self.farmersArray.count > 0 || status.lowercased() == "bigfarmersdetailslist" && self.BigfarmersArray.count > 0 || status.lowercased() == "retailersdetailslist" && self.RetailerArray.count > 0 || status.lowercased() == "pravakthadetailslist" && self.PravakthaArray.count > 0 {
                                    var transType = ""
                                    if status.lowercased() == "farmersdetailslist" {
                                        transType = "Farmers List"
                                    }else if status.lowercased() == "retailersdetailslist" {
                                        transType = "Retailer List"
                                    }else if status.lowercased() == "bigfarmersdetailslist" {
                                        transType = "Big Farmer List"
                                    }
                                    else if status.lowercased() == "pravakthadetailslist" {
                                        transType = "Pravakta List"
                                    }
                                    secDetails.itemName  = transType
                                    secDetails.collapsed = false
                                    self.sectionNames.append(secDetails)
                                }
                            }
                            
                            DispatchQueue.main.async {
                                if  self.RetailerArray.count > 0{
                                    self.RetailerList.reloadData()
                                }
                            }
                        }
                    }
                }
            }
            else{
                self.FarmerStack.isHidden = true
                self.view.makeToast((response.error?.localizedDescription)!)
            }
        }
    }
    
    func requestToGetgetlistbigFarmer(params : NSMutableDictionary){
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL_NEARBY,GET_NEARBY_LOCAL_DATA]  )
        let paramsStr = Constatnts.nsobjectToJSON(params)
        let params =  ["data" : paramsStr]
        print(params)
        Alamofire.request(urlString, method: .post, parameters :  params , encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    print(response)
                    let responseStatusCode = (json as? NSDictionary)?.value(forKey: "statusCode") as? String ?? ""
                    if responseStatusCode == "200"{
                        let respData = (json as? NSDictionary)?.value(forKey: "response") as? NSString ?? ""
                        
                        if respData != ""{
                            let json : NSDictionary  = Constatnts.decryptResult(StrJson: respData as String)
                            print("Response after decrypting data:\(json)")
                            let arrayStatus = NSMutableArray()
                            for (key, _) in json {
                                print("\(key)")
                                arrayStatus.add("\(key)")
                            }
                            let bigfarmerArray = json.value(forKey: "bigFarmersDetailsList") as? NSArray
                            if bigfarmerArray?.count ?? 0 > 0 {
                                for i in bigfarmerArray ?? [] {
                                    let arrTrans = NearByModel()
                                    arrTrans.distance = (i as AnyObject).value(forKey:"distance") as? String ?? ""
                                    arrTrans.custName = (i as AnyObject).value(forKey:"custName") as? String ?? ""
                                    arrTrans.custMobileNumber = (i as AnyObject).value(forKey:"custMobileNumber") as? String ?? ""
                                    arrTrans.territory = (i as AnyObject).value(forKey:"territory") as? String ?? ""
                                    arrTrans.crop = (i as AnyObject).value(forKey:"crop") as? String ?? ""
                                    arrTrans.activity = (i as AnyObject).value(forKey:"activity") as? String ?? ""
                                    arrTrans.pincode = (i as AnyObject).value(forKey:"pincode") as? String ?? ""
                                    arrTrans.imgUrl = (i as AnyObject).value(forKey:"imgUrl") as? String ?? ""
                                    self.BigfarmersArray.append(arrTrans)
                                }
                            }
                            var secDetails = SectionDetails()
                            
                            for i in arrayStatus {
                                let status = (i as? String)!
                                if status.lowercased() == "farmersdetailslist" && self.farmersArray.count > 0 || status.lowercased() == "bigfarmersdetailslist" && self.BigfarmersArray.count > 0 || status.lowercased() == "retailersdetailslist" && self.RetailerArray.count > 0 || status.lowercased() == "pravakthadetailslist" && self.PravakthaArray.count > 0 {
                                    var transType = ""
                                    if status.lowercased() == "farmersdetailslist" {
                                        transType = "Farmers List"
                                    }else if status.lowercased() == "retailersdetailslist" {
                                        transType = "Retailer List"
                                    }else if status.lowercased() == "bigfarmersdetailslist" {
                                        transType = "Big Farmer List"
                                    }
                                    else if status.lowercased() == "pravakthadetailslist" {
                                        transType = "Pravakta List"
                                    }
                                    secDetails.itemName  = transType
                                    secDetails.collapsed = false
                                    self.sectionNames.append(secDetails)
                                }
                            }
                            DispatchQueue.main.async {
                                if  self.BigfarmersArray.count > 0{
                                    self.BigfarmerList.reloadData()
                                }
                            }
                        }
                    }
                    else if responseStatusCode == "601"{
                        Constatnts.logOut()
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    }
                }
            }
            else{
                self.FarmerStack.isHidden = true
                self.view.makeToast((response.error?.localizedDescription)!)
            }
        }
    }
    
    func requestToGetgetlistPravkta(params : NSMutableDictionary){
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL_NEARBY,GET_NEARBY_LOCAL_DATA]  )
        let paramsStr = Constatnts.nsobjectToJSON(params)
        let params =  ["data" : paramsStr]
        print(params)
        Alamofire.request(urlString, method: .post, parameters :  params , encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    print(response)
                    let responseStatusCode = (json as? NSDictionary)?.value(forKey: "statusCode") as? String ?? ""
                    if responseStatusCode == "200"{
                        let respData = (json as? NSDictionary)?.value(forKey: "response") as? NSString ?? ""
                        
                        if respData != ""{
                            let json : NSDictionary  = Constatnts.decryptResult(StrJson: respData as String)
                            print("Response after decrypting data:\(json)")
                            
                            let arrayStatus = NSMutableArray()
                            for (key, _) in json {
                                print("\(key)")
                                arrayStatus.add("\(key)")
                            }
                            let pravaktaTrans = json.value(forKey: "pravakthaDetailsList") as? NSArray
                            if pravaktaTrans?.count ?? 0 > 0 {
                                for i in pravaktaTrans ?? [] {
                                    let arrTrans = NearByModel()
                                    arrTrans.distance = (i as AnyObject).value(forKey:"distance") as? String ?? ""
                                    arrTrans.custName = (i as AnyObject).value(forKey:"custName") as? String ?? ""
                                    arrTrans.custMobileNumber = (i as AnyObject).value(forKey:"custMobileNumber") as? String ?? ""
                                    arrTrans.crop = (i as AnyObject).value(forKey:"crop") as? String ?? ""
                                    arrTrans.activity = (i as AnyObject).value(forKey:"activity") as? String ?? ""
                                    arrTrans.territory = (i as AnyObject).value(forKey:"territory") as? String ?? ""
                                    arrTrans.pincode = (i as AnyObject).value(forKey:"pincode") as? String ?? ""
                                    arrTrans.imgUrl = (i as AnyObject).value(forKey:"imgUrl") as? String ?? ""
                                    self.PravakthaArray.append(arrTrans)
                                }
                            }
                            var secDetails = SectionDetails()
                            
                            for i in arrayStatus {
                                let status = (i as? String)!
                                if status.lowercased() == "farmersdetailslist" && self.farmersArray.count > 0 || status.lowercased() == "bigfarmersdetailslist" && self.BigfarmersArray.count > 0 || status.lowercased() == "retailersdetailslist" && self.RetailerArray.count > 0 || status.lowercased() == "pravakthadetailslist" && self.PravakthaArray.count > 0 {
                                    var transType = ""
                                    if status.lowercased() == "farmersdetailslist" {
                                        transType = "Farmers List"
                                    }else if status.lowercased() == "retailersdetailslist" {
                                        transType = "Retailer List"
                                    }else if status.lowercased() == "bigfarmersdetailslist" {
                                        transType = "Big Farmer List"
                                    }
                                    else if status.lowercased() == "pravakthadetailslist" {
                                        transType = "Pravakta List"
                                    }
                                    secDetails.itemName  = transType
                                    secDetails.collapsed = false
                                    self.sectionNames.append(secDetails)
                                }
                            }
                            
                            DispatchQueue.main.async {
                                if  self.farmersArray.count > 0{
                                    self.nearListFaremer.reloadData()
                                }
                            }
                        }
                        else{
                            self.globaloDataLbl.isHidden = false
                            self.globaloDataLbl.text = (json as? NSDictionary)?.value(forKey: "message") as? NSString as String? ?? "" as String
                            self.view.makeToast((json as? NSDictionary)?.value(forKey: "message") as? NSString as String? ?? "" as String)
                        }
                    }
                }
            }
            else{
                self.FarmerStack.isHidden = true
                self.view.makeToast((response.error?.localizedDescription)!)
            }
        }
    }
    
    func initialStringSetValues(){
        farmerString   = "null"
        retailerString = "null"
        bigFarmerStr   = "null"
        Pravaktastr    = "null"
        allString      = "null"
        
    }
    
    @IBAction func statutoryActionArrow(_ sender: Any) {
        self.initialStringSetValues()
        self.stackHeightSetInitial()
        switch (sender as AnyObject).tag {
        case 100:
            
            RetailerView.isHidden = !RetailerView.isHidden
            if RetailerView.isHidden == true{
                RetailerTopImageView.image = UIImage(named: "upArrow-1")
            }
            else{
                var heightConstant : CGFloat   = self.view.frame.height - 80
                var hieghtconst : CGFloat =  CGFloat(RetailerArray.count) * 158.0
                //                 if self.RetailerArray[indexPath.row].pincode == "" && self.RetailerArray[indexPath.row].territory == "" {
                //                }
                if hieghtconst < heightConstant{
                    heightConstant = CGFloat(hieghtconst)
                }
                RetailerHeightConstraint.constant = heightConstant
                retailerString = "Retailer"
                modelType = "Retailer"
                RetailerTopImageView.image = UIImage(named: "downroundIcon")
                RetailerList.reloadData()
            }
            
        case 101:
            
            farmerView.isHidden = !farmerView.isHidden
            if farmerView.isHidden == true{
                farmerTopImageView.image = UIImage(named: "upArrow-1")
            }
            else{
                var heightConstant : CGFloat   = self.view.frame.height - 140
                let hieghtconst : CGFloat =  CGFloat(farmersArray.count) * 170.0
                if hieghtconst < heightConstant{
                    heightConstant = CGFloat(hieghtconst)
                }
                farmerHeightConstraint.constant = heightConstant
                farmerTopImageView.image = UIImage(named: "downroundIcon")
                farmerString = "Farmer"
                modelType = "Farmer"
                nearListFaremer.reloadData()
            }
        case 102:
            
            PravtktaView.isHidden = !PravtktaView.isHidden
            if PravtktaView.isHidden == true{
                PravtktaTopImageView.image = UIImage(named: "upArrow-1")
            }
            else{
                var heightConstant : CGFloat   = self.view.frame.height - 180
                let hieghtconst : CGFloat =  CGFloat(PravakthaArray.count) * 170.0
                if hieghtconst < heightConstant{
                    heightConstant = CGFloat(hieghtconst)
                }
                PravtktaHeightConstraint.constant = heightConstant
                PravtktaTopImageView.image = UIImage(named: "downroundIcon")
                Pravaktastr = "Pravakta"
                modelType = "Pravakta"
                PravtktaList.reloadData()
            }
        case 103:
            
            BigfarmerView.isHidden = !BigfarmerView.isHidden
            if BigfarmerView.isHidden == true{
                BigfarmerTopImageView.image = UIImage(named: "upArrow-1")
            }
            else{
                var heightConstant : CGFloat   = self.view.frame.height - 200
                let hieghtconst : CGFloat =  CGFloat(BigfarmersArray.count) * 170.0
                if hieghtconst < heightConstant{
                    heightConstant = CGFloat(hieghtconst)
                }
                BigfarmerHeightConstraint.constant = heightConstant
                BigfarmerTopImageView.image = UIImage(named: "downroundIcon")
                bigFarmerStr = "BigFarmer"
                modelType = "BigFarmer"
                BigfarmerList.reloadData()
            }
            
            
        default: break
        }
        self.view.layoutIfNeeded()
        self.view.updateConstraintsIfNeeded()
    }
    
}

extension NearByListViewController  : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == RetailerList{
            return RetailerArray.count
        }
        if tableView == nearListFaremer{
            return farmersArray.count
        }
        if tableView == PravtktaList{
            return PravakthaArray.count
        }
        if tableView == BigfarmerList{
            return BigfarmersArray.count
        }
            
        else{
            return 0
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightVal:CGFloat = 150.0
        if tableView == RetailerList{
            if self.RetailerArray[indexPath.row].pincode != "" && self.RetailerArray[indexPath.row].territory != "" {
                if self.RetailerArray[indexPath.row].crop != "" || self.RetailerArray[indexPath.row].activity != "" {
                    return 200.0
                }
                else{
                    return heightVal
                }
                
            }
            else   if (self.RetailerArray[indexPath.row].pincode != "" && self.RetailerArray[indexPath.row].territory == "") || (self.RetailerArray[indexPath.row].pincode == "" && self.RetailerArray[indexPath.row].territory != "") {
                
                if self.RetailerArray[indexPath.row].crop != "" || self.RetailerArray[indexPath.row].activity != "" {
                    return 170.0
                }
                else{
                    return 120
                }
                
            }
            else{
                return 105
            }
        }
        else if  tableView == nearListFaremer{
            if self.farmersArray[indexPath.row].pincode != "" && self.farmersArray[indexPath.row].territory != "" {
                if self.farmersArray[indexPath.row].crop != "" || self.farmersArray[indexPath.row].activity != "" {
                    return 190.0
                }
                else{
                    return heightVal
                }
            }
            else   if (self.farmersArray[indexPath.row].pincode != "" && self.farmersArray[indexPath.row].territory == "") || (self.farmersArray[indexPath.row].pincode == "" && self.farmersArray[indexPath.row].territory != "") {
                if self.farmersArray[indexPath.row].crop != "" || self.farmersArray[indexPath.row].activity != "" {
                    return 170.0
                }
                else{
                    return 120.0
                }
            }
            else{
                return 105
            }
        }
        else if  tableView == PravtktaList{
            if self.PravakthaArray[indexPath.row].pincode != "" && self.PravakthaArray[indexPath.row].territory != "" {
                if self.PravakthaArray[indexPath.row].crop != "" || self.PravakthaArray[indexPath.row].activity != "" {
                    return 190.0
                }
                else{
                    return heightVal
                }
            } else   if (self.PravakthaArray[indexPath.row].pincode != "" && self.PravakthaArray[indexPath.row].territory == "") || (self.farmersArray[indexPath.row].pincode == "" && self.PravakthaArray[indexPath.row].territory != "") {
                if self.PravakthaArray[indexPath.row].crop != "" || self.PravakthaArray[indexPath.row].activity != "" {
                    return 170.0
                }
                else{
                    return 120.0
                }
            }
            else{
                return 105
            }
        }
        else if  tableView == BigfarmerList{
            if self.BigfarmersArray[indexPath.row].pincode != "" && self.BigfarmersArray[indexPath.row].territory != "" {
                
                if self.BigfarmersArray[indexPath.row].crop != "" || self.BigfarmersArray[indexPath.row].activity != "" {
                    return 190.0
                }
                else{
                    return heightVal
                }
            } else   if (self.BigfarmersArray[indexPath.row].pincode != "" && self.BigfarmersArray[indexPath.row].territory == "") || (self.BigfarmersArray[indexPath.row].pincode == "" && self.BigfarmersArray[indexPath.row].territory != "") {
                if self.BigfarmersArray[indexPath.row].crop != "" || self.BigfarmersArray[indexPath.row].activity != "" {
                    return 170.0
                }
                else{
                    return 120.0
                }
            }
                
                
            else{
                return 105
            }
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var stringCellIdentifier = "NearMeTableViewCell"
        if tableView == RetailerList{
            stringCellIdentifier = "NearMeTableViewCell"
        }
        else if  tableView == nearListFaremer{
            stringCellIdentifier = "NearMeTableViewCell1"
        }
        else if  tableView == PravtktaList{
            stringCellIdentifier = "NearMeTableViewCell2"
        }
        else if  tableView == BigfarmerList{
            stringCellIdentifier = "NearMeTableViewCell3"
        }
        
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: stringCellIdentifier, for: indexPath) as! NearMeTableViewCell
        
        if tableView == RetailerList{
            cell.lblDistance.text = self.RetailerArray[indexPath.row].distance
            cell.lblFirmname.text = self.RetailerArray[indexPath.row].custName
            cell.lblmobileNo.text = self.RetailerArray[indexPath.row].custMobileNumber
            cell.lblterritory.text = self.RetailerArray[indexPath.row].territory
            cell.lblpincode.text = self.RetailerArray[indexPath.row].pincode
            cell.lblCrop.text = self.RetailerArray[indexPath.row].crop
            cell.lblActivity.text = self.RetailerArray[indexPath.row].activity
            cell.btnCall.isHidden = false
            cell.btnCall.tag = indexPath.row
            cell.btnCall.addTarget(self, action: #selector(NearByListViewController.navigationToDailPad(_:)), for: .touchUpInside)
            let imgStr = self.RetailerArray[indexPath.row].imgUrl
            let url = URL(string:imgStr )
            cell.imgUrl?.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceHolderImage"), options: SDWebImageOptions.refreshCached, completed: { (img, error, _,url) in
                if error != nil {
                    cell.imgUrl?.image = img
                }
            })
        }
        else  if tableView == nearListFaremer{
            cell.lblDistance.text = self.farmersArray[indexPath.row].distance
            cell.lblFirmname.text = self.farmersArray[indexPath.row].custName
            cell.lblmobileNo.text = self.farmersArray[indexPath.row].custMobileNumber
            cell.lblterritory.text = self.farmersArray[indexPath.row].territory
            cell.lblpincode.text = self.farmersArray[indexPath.row].pincode
            cell.lblCrop.text = self.farmersArray[indexPath.row].crop
            cell.lblActivity.text = self.farmersArray[indexPath.row].activity
            cell.btnCall.isHidden = true
            let imgStr = self.farmersArray[indexPath.row].imgUrl
            let url = URL(string:imgStr )
            cell.imgUrl?.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceHolderImage"), options: SDWebImageOptions.refreshCached, completed: { (img, error, _,url) in
                if error != nil {
                    cell.imgUrl?.image = img
                }
            })
            
        }
        else   if tableView == PravtktaList{
            //  let cell =  PravtktaList.dequeueReusableCell(withIdentifier: "NearMeTableViewCell2", for: indexPath) as! NearMeTableViewCell
            
            cell.lblDistance.text = self.PravakthaArray[indexPath.row].distance
            cell.lblFirmname.text = self.PravakthaArray[indexPath.row].custName
            cell.lblmobileNo.text = self.PravakthaArray[indexPath.row].custMobileNumber
            cell.lblterritory.text = self.PravakthaArray[indexPath.row].territory
            cell.lblpincode.text = self.PravakthaArray[indexPath.row].pincode
            cell.lblCrop.text = self.PravakthaArray[indexPath.row].crop
            cell.lblActivity.text = self.PravakthaArray[indexPath.row].activity
            let imgStr = self.PravakthaArray[indexPath.row].imgUrl
            cell.btnCall.isHidden = true
            let url = URL(string:imgStr )
            cell.imgUrl?.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceHolderImage"), options: SDWebImageOptions.refreshCached, completed: { (img, error, _,url) in
                if error != nil {
                    cell.imgUrl?.image = img
                }
            })
            
        }
        else     if  tableView == BigfarmerList{
            cell.lblDistance.text = self.BigfarmersArray[indexPath.row].distance
            cell.lblFirmname.text = self.BigfarmersArray[indexPath.row].custName
            cell.lblmobileNo.text = self.BigfarmersArray[indexPath.row].custMobileNumber
            cell.lblterritory.text = self.BigfarmersArray[indexPath.row].territory
            cell.lblpincode.text = self.BigfarmersArray[indexPath.row].pincode
            cell.lblCrop.text = self.BigfarmersArray[indexPath.row].crop
            cell.lblActivity.text = self.BigfarmersArray[indexPath.row].activity
            let imgStr = self.BigfarmersArray[indexPath.row].imgUrl
            cell.btnCall.isHidden = true
            let url = URL(string:imgStr )
            cell.imgUrl?.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceHolderImage"), options: SDWebImageOptions.refreshCached, completed: { (img, error, _,url) in
                if error != nil {
                    cell.imgUrl?.image = img
                }
            })
            
        }
        
        
        if cell.lblDistance.text == ""{
            cell.distanceView.isHidden = true
        }
        if cell.lblFirmname.text == ""{
            cell.firmViewView.isHidden = true
        }
        if cell.lblmobileNo.text == ""{
            cell.mobilenoView.isHidden = true
        }
        if cell.lblterritory.text == ""{
            cell.territoryView.isHidden = true
        }
        if cell.lblpincode.text == ""{
            cell.pincodeView.isHidden = true
        }
        if cell.lblCrop.text == ""{
            cell.cropView.isHidden = true
        }
        
        if cell.lblActivity.text == ""{
            cell.activityView.isHidden = true
        }
        
        
        
        return cell
    }
    
    // MARK: - Expand / Collapse Methods
    
    //2.00
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section    = headerView.tag
        self.sectionNames[section].collapsed = !self.sectionNames[section].collapsed
        let collapsed = !self.sectionNames[section].collapsed
        nearListFaremer?.reloadSections(NSIndexSet(index: section) as IndexSet, with: .none)
    }
    
    @IBAction func navigationToDailPad(_ sender : UIButton) {
         if  let custMobileNumber = self.RetailerArray[sender.tag].custMobileNumber as String?{
                let userObj = Constatnts.getUserObject()
                let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId]
                self.registerFirebaseEvents(NEARBY_Call_Retailer, "", "", "", parameters: fireBaseParams as NSDictionary)
                let callUrl = String(format:"tel://%@", custMobileNumber)
                if let url = URL(string: callUrl), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        
    }
    func NavigationToPaymentSelection() {
        // self.reInitiatePaymentTransactionForRecord(0)
    }
}



extension NearByListViewController : UIScrollViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
    
    func requestToGetgetlistFarmer(params : NSMutableDictionary){
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL_NEARBY,GET_NEARBY_LOCAL_DATA]  )
        let paramsStr = Constatnts.nsobjectToJSON(params)
        let params =  ["data" : paramsStr]
        print(params)
        Alamofire.request(urlString, method: .post, parameters :  params , encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    print(response)
                    let responseStatusCode = (json as? NSDictionary)?.value(forKey: "statusCode") as? String ?? ""
                    if responseStatusCode == "200"{
                        let respData = (json as? NSDictionary)?.value(forKey: "response") as? NSString ?? ""
                        
                        if respData != ""{
                            let json : NSDictionary  = Constatnts.decryptResult(StrJson: respData as String)
                            print("Response after decrypting data:\(json)")
                            
                            let arrayStatus = NSMutableArray()
                            for (key, _) in json {
                                print("\(key)")
                                arrayStatus.add("\(key)")
                            }
                            let userObj = Constatnts.getUserObject()
                            let firebaseParams = ["Mobile_Number": userObj.mobileNumber!,"User_Id":userObj.customerId!,"screen_name":"NearByListViewController"] as [String : Any]
                                   self.registerFirebaseEvents("PV_NearByList_success_Request", "", "", "", parameters: firebaseParams as NSDictionary)
                            
                            let farmerDeailsTrans = json.value(forKey: "farmersDetailsList") as? NSArray
                            if farmerDeailsTrans?.count ?? 0 > 0 {
                                for i in farmerDeailsTrans ?? [] {
                                    let arrTrans = NearByModel()
                                    arrTrans.distance = (i as AnyObject).value(forKey:"distance") as? String ?? ""
                                    arrTrans.custName = (i as AnyObject).value(forKey:"custName") as? String ?? ""
                                    arrTrans.custMobileNumber = (i as AnyObject).value(forKey:"custMobileNumber") as? String ?? ""
                                    arrTrans.territory = (i as AnyObject).value(forKey:"territory") as? String ?? ""
                                    arrTrans.pincode = (i as AnyObject).value(forKey:"pincode") as? String ?? ""
                                    arrTrans.imgUrl = (i as AnyObject).value(forKey:"imgUrl") as? String ?? ""
                                    self.farmersArray.append(arrTrans)
                                }
                            }
                            var secDetails = SectionDetails()
                            for i in arrayStatus {
                                let status = (i as? String)!
                                if status.lowercased() == "farmersdetailslist" && self.farmersArray.count > 0 || status.lowercased() == "bigfarmersdetailslist" && self.BigfarmersArray.count > 0 || status.lowercased() == "retailersdetailslist" && self.RetailerArray.count > 0 || status.lowercased() == "pravakthadetailslist" && self.PravakthaArray.count > 0 {
                                    var transType = ""
                                    if status.lowercased() == "farmersdetailslist" {
                                        transType = "Farmers List"
                                    }else if status.lowercased() == "retailersdetailslist" {
                                        transType = "Retailer List"
                                    }else if status.lowercased() == "bigfarmersdetailslist" {
                                        transType = "Big Farmer List"
                                    }
                                    else if status.lowercased() == "pravakthadetailslist" {
                                        transType = "Pravakta List"
                                    }
                                    secDetails.itemName  = transType
                                    secDetails.collapsed = false
                                    self.sectionNames.append(secDetails)
                                }
                            }
                            DispatchQueue.main.async {
                                if  self.farmersArray.count > 0{
                                    self.nearListFaremer.reloadData()
                                }
                            }
                        }
                        else{
                            self.globaloDataLbl.isHidden = false
                            self.globaloDataLbl.text = (json as? NSDictionary)?.value(forKey: "message") as? NSString as String? ?? "" as String
                            self.view.makeToast((json as? NSDictionary)?.value(forKey: "message") as? NSString as String? ?? "" as String)
                        }
                    }
                }
            }
            else{
                let userObj = Constatnts.getUserObject()
                              let firebaseParams = ["Mobile_Number": userObj.mobileNumber!,"User_Id":userObj.customerId!,"screen_name":"NearByListViewController"] as [String : Any]
                                     self.registerFirebaseEvents("PV_NearByList_Failure_Request", "", "", "", parameters: firebaseParams as NSDictionary)
                self.FarmerStack.isHidden = true
                self.view.makeToast((response.error?.localizedDescription)!)
            }
        }
    }
    
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
        if(retailerString == "Retailer"){
            if ((RetailerList.contentOffset.y + RetailerList.frame.size.height) >= RetailerList.contentSize.height)
            {
                if !isDataLoading{
                    isDataLoading = true
                    let  minRecord1 = RetailerArray.count + 1
                    minRecord = String(format: "%i", minRecord1)
                    farmerString = "null"
                    let finalParamsDic = NSMutableDictionary()
                    if  isFromCount == false {
                        let dic : NSMutableDictionary = self.loadPagination(minRecord, Type: "Retailer")
                        finalParamsDic.addEntries(from: dic as? [AnyHashable : Any]  ?? [:])
                        
                    }else {
                        
                        let dic : NSMutableDictionary = self.loadPagination(minRecord, Type: "Retailer")
                        finalParamsDic.addEntries(from: dic as? [AnyHashable : Any]  ?? [:])
                    }
                    requestToGetgetlistRetailer(params: finalParamsDic)
                }
            }
        }
        else if farmerString == "Farmer"{
            if ((nearListFaremer.contentOffset.y + nearListFaremer.frame.size.height) >= nearListFaremer.contentSize.height)
            {
                if !isDataLoading{
                    isDataLoading = true
                    let  minRecord1 = farmersArray.count + 1
                    minRecord = String(format: "%i", minRecord1)
                    farmerString = "Farmer"
                    let finalParamsDic = NSMutableDictionary()
                    if  isFromCount == false {
                        
                        let dic : NSMutableDictionary = self.loadPagination(minRecord, Type: "Farmer")
                        finalParamsDic.addEntries(from: dic as? [AnyHashable : Any]  ?? [:])
                        
                    }else {
                        let dic : NSMutableDictionary = self.loadPagination(minRecord, Type: "Farmer")
                        finalParamsDic.addEntries(from: dic as? [AnyHashable : Any]  ?? [:])
                    }
                    requestToGetgetlistFarmer(params: finalParamsDic)
                }
            }
        }
        else if Pravaktastr == "Pravakta"{
            if ((PravtktaList.contentOffset.y + PravtktaList.frame.size.height) >= PravtktaList.contentSize.height)
            {
                if !isDataLoading{
                    isDataLoading = true
                    let  minRecord1 = PravakthaArray.count + 1
                    minRecord = String(format: "%i", minRecord1)
                    let finalParamsDic = NSMutableDictionary()
                    
                    if  isFromCount == false {
                        let dic : NSMutableDictionary = self.loadPagination(minRecord, Type: "Pravakta")
                        finalParamsDic.addEntries(from: dic as? [AnyHashable : Any]  ?? [:])
                        
                    }else {
                        let dic : NSMutableDictionary = self.loadPagination(minRecord, Type: "Pravakta")
                        finalParamsDic.addEntries(from: dic as? [AnyHashable : Any]  ?? [:])
                    }
                    requestToGetgetlistbigFarmer(params: finalParamsDic)
                }
            }
        }
        else if bigFarmerStr == "BigFarmer"{
            if ((BigfarmerList.contentOffset.y + BigfarmerList.frame.size.height) >= BigfarmerList.contentSize.height)
            {
                if !isDataLoading{
                    isDataLoading = true
                    let  minRecord1 = BigfarmersArray.count + 1
                    minRecord = String(format: "%i", minRecord1)
                    let finalParamsDic = NSMutableDictionary()
                    if  isFromCount == false {
                        let dic : NSMutableDictionary = self.loadPagination(minRecord, Type: "BigFarmer")
                        finalParamsDic.addEntries(from: dic as? [AnyHashable : Any]  ?? [:])
                        
                    }else {
                        let dic : NSMutableDictionary = self.loadPagination(minRecord, Type: "BigFarmer")
                        finalParamsDic.addEntries(from: dic as? [AnyHashable : Any]  ?? [:])
                    }
                    requestToGetgetlistbigFarmer(params: finalParamsDic)
                }
            }
        }
        
    }
    
    func loadPagination(_ minrecord : String, Type : String) -> NSMutableDictionary{
        let diNew  : NSMutableDictionary = [ "actAGRO": paramsDic.value(forKey: "actAGRO") as? String ?? "null",
                                             "actALL": allString,
                                             "actActivities": paramsDic.value(forKey: "actActivities") as? String ?? "null",
                                             "actBigFarmer": bigFarmerStr,
                                             "actByFar": farmerString,
                                             "actByRet": retailerString,
                                             "actOSA": paramsDic.value(forKey: "actOSA") as? String ?? "null",
                                             "actPDA": paramsDic.value(forKey: "actPDA") as? String ?? "null",
                                             "actPSA": paramsDic.value(forKey: "actPSA") as? String ?? "null",
                                             "actPravakta": Pravaktastr,
                                             "distance": paramsDic.value(forKey: "distance") as? String ?? "null",
                                             "latitude": paramsDic.value(forKey: "latitude") as? String ?? "null",
                                             "longitude": paramsDic.value(forKey: "longitude") as? String ?? "null",
                                             "minRecord": minrecord,
                                             "mobileNumber": paramsDic.value(forKey: "mobileNumber")as? String ?? "null"  ,
                                             "modelType": modelType,
                                             "userType": paramsDic.value(forKey: "userType") as? String ?? "null"]
        
        return diNew
    }
}


