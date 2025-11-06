//
//  CropAdvisoryCropController.swift
//  CropAdvisoryFramework
//
//  Created by Apple on 04/12/19.
//  Copyright © 2019 Empover iTech Pvt Ltd. All rights reserved.
//

import UIKit

open class CropAdvisoryCropController: BaseViewController {
    
    var isFromHome = false
    @IBOutlet weak var cropTableView = UITableView()
    var categoryCropArray = NSMutableArray()
    var userObjDic = NSMutableDictionary()
    
    //MARK:- VIEW DID LOAD
    override open func viewDidLoad() {
        
        let defaults = UserDefaults.standard
        //defaults.set(decryptData , forKey: "OTPResponseData")
        defaults.set(false, forKey: "Landscape")
        defaults.synchronize()
        
        super.viewDidLoad()
        
//        CoreDataManager.shared.addLogEvent(UserID: userObjDic.value(forKey: "customerId")  as? String ?? "", mobileNumber: userObjDic.value(forKey: "mobileNumber")  as? String ?? "", screenName: "CropAdvisoryCropController", eventName: "CropPhaseLifeCycle_Load", eventType: "PageLoad",captureTime:self.getCurrentDateAndTime(), currentLocation: self.userObjDic.value(forKey: "geoLocation")  as? String ?? "0.0,0.0", moduleType: "CropAdvisory")
//
      let parameters  = ["capturedtime" : self.getCurrentDateAndTime() , "currentLocation" :  self.userObjDic.value(forKey: "geoLocation")  as? String ?? "" ,"eventName" :  "CropPhaseLifeCycle_Load" , "moduleType" : "CropAdvisory","deviceType" : "iOS" , "Mobile_Number" : self.userObjDic.value(forKey: "mobileNumber")  as? String ?? "" ,"screen_name" :  "CropAdvisoryCropController" , "User_Id" :  self.userObjDic.value(forKey: "customerId")  as? String ?? ""]
                                                                                                                                     
        self.registerFirebaseEvents("CropPhaseLifeCycle_Load", "", "", "CropAdvisoryCropController", parameters: parameters as NSDictionary)
        
        
        cropTableView?.reloadData()
        
    }
    override func getCurrentDateAndTime()-> String{
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = df.string(from: date)
        return dateString
    }

    override open func viewWillAppear(_ animated: Bool) {
        
        let defaults = UserDefaults.standard
        //defaults.set(decryptData , forKey: "OTPResponseData")
        defaults.set(false, forKey: "Landscape")
        defaults.synchronize()
        
        self.topView?.isHidden = false
        self.homeButton?.isHidden = true
        self.lblTitle?.text = "Crop Advisory"
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        forceOrientationPortrait()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //  self.topView?.isHidden = true
    }
    
}

//MARK:Tableview datasource & delegate methods
extension CropAdvisoryCropController :  UITableViewDataSource, UITableViewDelegate{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == cropTableView {
            return categoryCropArray.count
        }
        else{
            return 0
        }
    }
    
    override open var prefersStatusBarHidden: Bool {
        return false
    }
    
    @objc func forceOrientationPortrait() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .portrait
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    
    public  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SubscriptionCropCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SubscriptionCropCellTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.cropImage.layer.cornerRadius = 1.0
        cell.cropImage.layer.borderColor = UIColor.blue.cgColor
        cell.cropImage.layer.borderWidth =  2.0
        
        let dic : CropControllerBO = categoryCropArray.object(at: indexPath.row) as! CropControllerBO
        
        let Str = String(format:"%@ %@",dic.cropType ?? "" ,dic.cropName ?? "" )
        let url = URL(string:dic.cropImageUrl as String? ?? "" as String)
  
         cell.cropImage.kf.setImage(with : url, placeholder: UIImage(named:"image_placeholder.png"))
        
        
       // cell.cropImage.kf.setImage(with: url , placeholder: UIImage(named:"image_placeholder.png"), options: nil, progressBlock: nil, completionHandler: nil)
        cell.croptitle.text = Str
        return cell
    }
    
    public  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//       CoreDataManager.shared.addLogEvent(UserID: userObjDic.value(forKey: "customerId")  as? String ?? "", mobileNumber: userObjDic.value(forKey: "mobileNumber")  as? String ?? "", screenName: "CropAdvisoryCropController", eventName: "CropPhaseLifeCycle_Click", eventType: "Click",captureTime:self.getCurrentDateAndTime(), currentLocation: "0.0,0.0", moduleType: "CropAdvisory")
//
        let parameters  = ["capturedtime" : self.getCurrentDateAndTime() , "currentLocation" :  self.userObjDic.value(forKey: "geoLocation")  as? String ?? "" ,"eventName" :  "CropPhaseLifeCycle_Click" , "moduleType" : "CropAdvisory","deviceType" : "iOS" , "Mobile_Number" : self.userObjDic.value(forKey: "mobileNumber")  as? String ?? "" ,"screen_name" :  "CropAdvisoryCropController" , "User_Id" :  self.userObjDic.value(forKey: "customerId")  as? String ?? ""]
                                                                                                                                           
        self.registerFirebaseEvents("CropPhaseLifeCycle_Click", "", "", "CropAdvisoryCropController", parameters: parameters as NSDictionary)
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        let dic : CropControllerBO = categoryCropArray.object(at: indexPath.row) as! CropControllerBO
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.myOrientation = .landscape
        
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "Landscape")
        defaults.synchronize()

        
        let   viewContro : SubscriptionGrowthDurationViewController  =  BaseClass.loadViewgrowth() as! SubscriptionGrowthDurationViewController
        viewContro.cropTypeId = dic.cropTypeID ?? "0"
        viewContro.cropID = dic.cropID ?? "0"
        viewContro.userObj1 = userObjDic
        self.navigationController?.pushViewController(viewContro, animated: true)
    }
    
    public   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
        
    }
    
    public   func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
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
    
}
extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
  }
}
