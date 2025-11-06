//
//  PlanterViewController.swift
//  FarmerConnect
//
//  Created by Empover i-Tech on 28/03/23.
//  Copyright © 2023 ABC. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class PlanterViewController: BaseViewController,UIScrollViewDelegate {
    @IBOutlet weak var requestTableview : UITableView!
    @IBOutlet weak var contentview : UIView!
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var acceptBtn : UIButton!
    @IBOutlet weak var rejectBtn : UIButton!
    @IBOutlet weak var NodataLbl : UILabel!
    var RequestArray = [PlanterModel]()
    var isFromHome = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NodataLbl.isHidden = false
        self.requestTableview.isHidden = true
        var designationName : String = ""
        var mobile : String = ""
        var userID : String = ""
        if let loginDecodedData = UserDefaults.standard.value(forKey: "LoginDecodedData") as? NSDictionary{
            if let dashboardItemsDic = loginDecodedData.value(forKey: "sideMenuData") as? NSDictionary{
                designationName = Validations.checkKeyNotAvail(dashboardItemsDic, key: "designationName") as? String ?? ""
                mobile = loginDecodedData.value(forKey: "mobileNo") as? String ?? ""
                userID =  loginDecodedData.value(forKey: "customerId") as? String ??  ""
            }
        }
        let firebaseParams = ["Mobile_Number": mobile,"User_Id":userID,"screen_name":"SpreyViewController","designation" : designationName] as [String : Any]
        self.registerFirebaseEvents("PV_spray_List", "", "", "", parameters: firebaseParams as NSDictionary)
        
        // Do any additional setup after loading the view.
    }
    
    func requestToGetSprayList(){
        SwiftLoader.show(animated: true)
        var designationName : String = ""
        var mobile : String = ""
        var userID : String = ""
       
        if let loginDecodedData = UserDefaults.standard.value(forKey: "LoginDecodedData") as? NSDictionary{
            if let dashboardItemsDic = loginDecodedData.value(forKey: "sideMenuData") as? NSDictionary{
                designationName = Validations.checkKeyNotAvail(dashboardItemsDic, key: "designationName") as? String ?? ""
                mobile = loginDecodedData.value(forKey: "mobileNo") as? String ?? ""
                userID =  loginDecodedData.value(forKey: "customerId") as? String ??  ""
            }
        }
        let firebaseParams = ["Mobile_Number": mobile,"User_Id":userID,"screen_name":"SpreyViewController","designation" : designationName] as [String : Any]
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! NSString
        
        
       let urlString = String(format: "%@%@", arguments: [BASE_URL,GET_PLANTER_SERVICES_VENDOR_ORDER_LIST])
      
        let loginDecodedData = UserDefaults.standard.value(forKey: "LoginDecodedData") as! NSDictionary
        let params1 : NSDictionary = ["customerId":loginDecodedData.value(forKey: "customerId") as? String ??  "","deviceId":loginDecodedData.value(forKey: "deviceId") as? String ?? "","deviceType":"iOS","mobileNumber":loginDecodedData.value(forKey: "mobileNo") as? String ?? "","userType":"Farmer","versionName":version,
                                      "status": "0","requestId": "0"]
        
        let paramsStr = Constatnts.nsobjectToJSON(params1 as NSDictionary)
        let params =  ["data" : paramsStr]
        print(params)
        Alamofire.request(urlString, method: .post, parameters :  params , encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    print(response)
                    self.RequestArray.removeAll()
                    let responseStatusCode = (json as? NSDictionary)?.value(forKey: "statusCode") as? String ?? ""
                    if responseStatusCode == "200"{
                        let respData = (json as? NSDictionary)?.value(forKey: "response") as? NSString ?? ""
                        self.registerFirebaseEvents("PV_SprayList_success_Request", "", "", "", parameters: firebaseParams as NSDictionary)
                        if respData != ""{
                            let json : NSDictionary  = Constatnts.decryptResult(StrJson: respData as String)
                           // print("Response after decrypting data:\(json)")
                            let arrayStatus = NSMutableArray()
                            for (key, _) in json {
                                print("\(key)")
                                arrayStatus.add("\(key)")
                            }
                            let bigfarmerArray = json.value(forKey: "sprayDetailsList") as? NSArray
                            if bigfarmerArray?.count ?? 0 > 0 {
                                for i in bigfarmerArray ?? [] {
                                   // let arrTrans = PlanterModel(array: i as [String: Any])
                                    //self.RequestArray.append(arrTrans)
                                }
                            }
                            DispatchQueue.main.async {
                                if  self.RequestArray.count > 0{
                                    self.requestTableview.reloadData()
                                    self.NodataLbl.isHidden = true
                                    self.requestTableview.isHidden = false
                                }
                                else{
                                    self.NodataLbl.isHidden = false
                                    self.requestTableview.isHidden = true
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
                print((response.error?.localizedDescription)!)
                self.registerFirebaseEvents("PV_SprayList_Failure_Request", "", "", "", parameters: firebaseParams as NSDictionary)
                self.view.makeToast((response.error?.localizedDescription)!)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.requestToGetSprayList()
        super.viewWillAppear(true)
        self.topView?.isHidden = false
        lblTitle?.text = "Spray Approvals List"
        if isFromHome == true {
            self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        }
        else{
            self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
        }
        //self.setStatusBarBackgroundColor(color :App_Theme_Blue_Color_new)
       // self.topView?.backgroundColor = App_Theme_Blue_Color_new
        
    }
    
    override func backButtonClick(_ sender: UIButton) {
        
        if self.isFromHome == true {
            self.navigationController?.popViewController(animated: true)
        }
        else{
            self.findHamburguerViewController()?.showMenuViewController()
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.topView?.isHidden = true
      // self.setStatusBarBackgroundColor(color :App_Theme_Blue_Color_new)
       // self.topView?.backgroundColor = App_Theme_Blue_Color_new
    }
    
    
    
    @IBAction func viewDetailsButtonClick(_ sender : UIButton) {
        
        var designationName : String = ""
        var mobile : String = ""
        var userID : String = ""
        if let loginDecodedData = UserDefaults.standard.value(forKey: "LoginDecodedData") as? NSDictionary{
            if let dashboardItemsDic = loginDecodedData.value(forKey: "sideMenuData") as? NSDictionary{
                designationName = Validations.checkKeyNotAvail(dashboardItemsDic, key: "designationName") as? String ?? ""
                mobile = loginDecodedData.value(forKey: "mobileNo") as? String ?? ""
                userID =  loginDecodedData.value(forKey: "customerId") as? String ??  ""
            }
        }
        let firebaseParams = ["Mobile_Number": mobile,"User_Id":userID,"screen_name":"SpreyViewController","designation" : designationName] as [String : Any]
        self.registerFirebaseEvents("PV_sprayView_Details", "", "", "", parameters: firebaseParams as NSDictionary)
        //let spreyController = self.storyboard?.instantiateViewController(withIdentifier: "SpreyApprovalViewController") as? SpreyApprovalViewController
        //spreyController?.sprayObj = [(self.RequestArray[sender.tag] as AnyObject) as! SpreyModel]
        
      //  spreyController?.approvedStatus = (self.RequestArray[sender.tag]).recordStatus
     //   self.navigationController?.pushViewController(spreyController!, animated: true)
    }
    
}
extension PlanterViewController  : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RequestArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let stringCellIdentifier = "SpreyTableViewCell"
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: stringCellIdentifier, for: indexPath) as! PlanterTableViewCell
        
        
        cell.lblfarmerNAme.text = (self.RequestArray[indexPath.row]).farmerName
        cell.lblMobile.text = (self.RequestArray[indexPath.row]).mobileNumber
        //cell.lblCrop.text = (self.RequestArray[indexPath.row] ).crop
        cell.lblNoofAcres.text = (self.RequestArray[indexPath.row] ).noOfAcres
        //cell.lblAddress.text = (self.RequestArray[indexPath.row] ).address
        
        let imgStr = (self.RequestArray[indexPath.row] ).equipmentimgUrl
        let url = URL(string:imgStr )
        
        cell.imgUrl?.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceHolderImage")!, options: SDWebImageOptions.delayPlaceholder, completed: { (img, error, _, ur) in
            if error != nil {
                DispatchQueue.main.async {
                    cell.imgUrl.image =  UIImage(named: "PlaceHolderImage")!
                }
            }else {
                DispatchQueue.main.async {
                    cell.imgUrl.image = img
                }
            }
        })
        
       
        cell.statusView.isHidden = false
        
        if (self.RequestArray[indexPath.row] ).recordStatus == "Approve"{
            cell.ApproveBtn.isHidden = false
            cell.ApproveBtn.setTitle("Approved", for: .normal)
           // cell.ApproveBtn.setTitleColor(App_Theme_Blue_Color_new, for: .normal)
           
        }
        else  if (self.RequestArray[indexPath.row] ).recordStatus == "Reject"{
            cell.ApproveBtn.isHidden = false
            cell.ApproveBtn.setTitle("Rejected", for: .normal)
            cell.ApproveBtn.setTitleColor(UIColor.red, for: .normal)
          
            
        }
        else  if (self.RequestArray[indexPath.row] ).recordStatus == "Completed"{
            cell.ApproveBtn.isHidden = false
            cell.ApproveBtn.setTitle("Completed", for: .normal)
            cell.ApproveBtn.setTitleColor(UIColor.red, for: .normal)
          
            
        }
            //Pending
        else  if (self.RequestArray[indexPath.row] ).recordStatus == "Pending"{
            cell.ApproveBtn.isHidden = false
            cell.ApproveBtn.setTitle("Pending", for: .normal)
            cell.ApproveBtn.setTitleColor(UIColor.orange, for: .normal)
            cell.ApproveBtn.layer.borderColor = UIColor.orange.cgColor
            
        }
            
        else{
            
            if (self.RequestArray[indexPath.row] ).recordStatus != ""{
                cell.ApproveBtn.isHidden = false
                cell.ApproveBtn.setTitle((self.RequestArray[indexPath.row] ).recordStatus, for: .normal)
                cell.ApproveBtn.setTitleColor(UIColor.orange, for: .normal)
               
            }
            else{
                cell.ApproveBtn.isHidden = true
                cell.statusView.isHidden = true
            }
        }
        cell.viewDetailsBtn.tag = indexPath.row
        cell.viewDetailsBtn.addTarget(self, action: #selector(PlanterViewController.viewDetailsButtonClick(_:)), for: .touchUpInside)
        
        if cell.lblAddress.text == ""{
            cell.AddressView.isHidden = true
        }
        else{
            cell.AddressView.isHidden = false
        }
        
        return cell
        
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//       // let Str : String =  (self.RequestArray[indexPath.row] ).address
//        let StrStatus : String =  (self.RequestArray[indexPath.row] ).recordStatus
//        if Str.count == 0 ||  Str.count < 10{
//            if StrStatus != ""{
//                return 165.0
//            }
//            else{
//                return 145.0
//            }
//        }
//        else  if Str.count < 39 && Str.count > 10{
//            if StrStatus != ""{
//                return 180.0
//            }
//            else{
//                return 160.0
//            }
//        }
//        else  if Str.count > 39 && Str.count < 70{
//            if StrStatus != ""{
//                return 210.0
//            }
//            else{
//                return 190.0
//            }
//        }
//
//        else{
//            if StrStatus != ""{
//                return 260.0
//            }
//            else{
//                return 240.0
//            }
//        }
//
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let spreyController = self.storyboard?.instantiateViewController(withIdentifier: "SpreyApprovalViewController") as? SpreyApprovalViewController
//        spreyController?.status = (self.RequestArray[indexPath.row]).recordStatus
//        self.navigationController?.pushViewController(spreyController!, animated: true)
    }
    
}
