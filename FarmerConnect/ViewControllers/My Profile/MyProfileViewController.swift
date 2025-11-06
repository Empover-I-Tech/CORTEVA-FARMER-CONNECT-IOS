
//
//  MyProfileViewController.swift
//  FarmerConnect
//
//  Created by Empover on 04/01/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit
import Alamofire


class MyProfileViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblProfile: UITableView!
    //@IBOutlet weak var contentViewHeightContraint: NSLayoutConstraint?
    var arrProfile : NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tblProfile.estimatedRowHeight = 45
        tblProfile.tableFooterView = UIView()
        tblProfile?.rowHeight = UITableViewAutomaticDimension
        if #available(iOS 10.0, *) {
            //self.automaticallyAdjustsScrollViewInsets = true
        }
        self.recordScreenView("MyProfileViewController", Profile_Screen)
        self.registerFirebaseEvents(PV_Profile, "", "", "", parameters: nil)
    }
    
    func updateNewProfileDataOfUser(_ userObj:User){
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if #available(iOS 10.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.navigationController?.navigationBar.isHidden = false
        self.topView?.isHidden = false
        self.lblTitle?.text = NSLocalizedString("my_profile", comment: "")
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        let userObj = Constatnts.getUserObject()
        
        arrProfile.removeAllObjects()
        
        arrProfile.add(String(format: "%@ - %@",NSLocalizedString("user_type_only", comment: ""),userObj.customerTypeName ?? ""))
        arrProfile.add(String(format: "%@ - %@",NSLocalizedString("first_name", comment: ""),userObj.firstName ?? ""))
        arrProfile.add(String(format: "%@ - %@",NSLocalizedString("last_name", comment: ""),userObj.lastName ?? ""))
        arrProfile.add(String(format: "%@ - %@",NSLocalizedString("mobile_no", comment: ""),userObj.mobileNumber ?? ""))
       
        if Validations.isNullString(userObj.emailId ?? "") == false  {
            arrProfile.add(String(format: "%@ - %@",NSLocalizedString("email_address", comment: ""),userObj.emailId ?? ""))
        }
        if Validations.isNullString(userObj.regionName ?? "") == false{
            arrProfile.add(String(format: "%@ - %@",NSLocalizedString("region", comment: ""),userObj.regionName ?? ""))
        }
        if Validations.isNullString(userObj.stateName ?? "") == false  {
            arrProfile.add(String(format: "%@ - %@",NSLocalizedString("state", comment: ""),userObj.stateName ?? ""))
        }
        if Validations.isNullString(userObj.districtName ?? "") == false{
            arrProfile.add(String(format: "%@ - %@",NSLocalizedString("district", comment: ""),userObj.districtName ?? ""))
        }
        if Validations.isNullString(userObj.pincode ?? "") == false  {
            arrProfile.add(String(format: "%@ - %@",NSLocalizedString("pincode", comment: ""),userObj.pincode ?? ""))
        }
        if Validations.isNullString(userObj.villageLocation ?? "") == false{
            arrProfile.add(String(format: "%@ - %@",NSLocalizedString("village_location", comment: ""),userObj.villageLocation ?? ""))
        }
        if Validations.isNullString(userObj.totalCropAcress ?? "") == false  {
            arrProfile.add(String(format: "%@ - %@",NSLocalizedString("total_crop_acres", comment: ""),userObj.totalCropAcress ?? ""))
        }
        if Validations.isNullString(userObj.corn ?? "") == false{
            arrProfile.add(String(format: "%@ - %@",NSLocalizedString("corn", comment: ""),userObj.corn ?? ""))
        }
        if Validations.isNullString(userObj.rice ?? "") == false{
            arrProfile.add(String(format: "%@ - %@",NSLocalizedString("rice", comment: ""),userObj.rice ?? ""))
        }
        if Validations.isNullString(userObj.millet ?? "") == false  {
            arrProfile.add(String(format: "%@ - %@",NSLocalizedString("millet", comment: ""),userObj.millet ?? ""))
        }
        if Validations.isNullString(userObj.mustard ?? "") == false{
            arrProfile.add(String(format: "%@ - %@",NSLocalizedString("mustard", comment: ""),userObj.mustard ?? ""))
        }
        if Validations.isNullString(userObj.soyabean ?? "") == false  {
            arrProfile.add(String(format: "%@ - %@",NSLocalizedString("soyabean", comment: ""),userObj.soyabean ?? ""))
        }
        if Validations.isNullString(userObj.cotton ?? "") == false{
            arrProfile.add(String(format: "%@ - %@",NSLocalizedString("cotton", comment: ""),userObj.cotton ?? ""))
        }
        if Validations.isNullString(userObj.subIrrigationTypes ?? "") == false{
            arrProfile.add(String(format: "%@ - %@",NSLocalizedString("types_irrigation", comment: ""),userObj.subIrrigationTypes ?? ""))
        }
        if Validations.isNullString(userObj.seasons ?? "") == false  {
            arrProfile.add(String(format: "%@ - %@",NSLocalizedString("seasons_cultivated", comment: ""),userObj.seasons ?? ""))
        }//
        if Validations.isNullString(userObj.companies ?? "") == false{
            arrProfile.add(String(format: "%@ - %@",NSLocalizedString("companies_patronized", comment: ""),userObj.companies ?? ""))
        }
        
        self.tblProfile.reloadData()
    }
    
    //MARK: UITableViewController Delegate and DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProfile.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let strName = arrProfile.object(at: indexPath.row) as? String
        let arrCells = strName?.components(separatedBy: " - ")
        
        if arrCells?[0] == "Types Of Irrigation" || arrCells?[0] == "Season Cultivated"{
            return 60
        }else{
            return UITableViewAutomaticDimension
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let strName = arrProfile.object(at: indexPath.row) as? String
        let arrCells = strName?.components(separatedBy: " - ")
       
        if arrCells?[0] == "Types Of Irrigation" || arrCells?[0] == "Season Cultivated"{
            let cellIdentifier = "seasonsCell"
            let cell = self.tblProfile.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            
            let arrNames = arrCells?[1].components(separatedBy: ",")
          
            let lblTitles = cell.viewWithTag(100) as? UILabel
            let img1 = cell.viewWithTag(101) as? UIImageView
            let lblName1 = cell.viewWithTag(102) as? UILabel
            let img2 = cell.viewWithTag(103) as? UIImageView
            let lblName2 = cell.viewWithTag(104) as? UILabel
            let img3 = cell.viewWithTag(105) as? UIImageView
            let lblName3 = cell.viewWithTag(106) as? UILabel
            let img4 = cell.viewWithTag(107) as? UIImageView
            let lblName4 = cell.viewWithTag(108) as? UILabel
            
            lblTitles?.text = arrCells?[0]

            let count = arrNames?.count
            
            if count == 1{
                img1?.image = UIImage(named: arrNames?[0] ?? "")
                lblName1?.text = arrNames?[0]
                img2?.isHidden = true
                lblName2?.isHidden = true
                img3?.isHidden = true
                lblName3?.isHidden = true
                img4?.isHidden = true
                lblName4?.isHidden = true
            }
            if count == 2{
                img1?.image = UIImage(named: arrNames?[0] ?? "")
                lblName1?.text = arrNames?[0]
                img2?.image = UIImage(named: arrNames?[1] ?? "")
                lblName2?.text = arrNames?[1]
                img3?.isHidden = true
                lblName3?.isHidden = true
                img4?.isHidden = true
                lblName4?.isHidden = true
            }
            if count == 3{
                
                lblName1?.text = arrNames?[0]
                lblName2?.text = arrNames?[1]
                lblName3?.text = arrNames?[2]
                
                if arrNames?[0]  == "Rainfed" {
                    img1?.image = UIImage(named: "RAINY")
                }else {
                   img1?.image = UIImage(named: arrNames?[0] ?? "")
                }
                if arrNames?[1]  == "Rainfed" {
                    img2?.image = UIImage(named: "RAINY")
                }else {
                    img2?.image = UIImage(named: arrNames?[1] ?? "")
                }
                if arrNames?[2]  == "Rainfed" {
                    img3?.image = UIImage(named: "RAINY")
                }else {
                    img3?.image = UIImage(named: arrNames?[2] ?? "")
                }
               
                
                img2?.isHidden = false
                lblName2?.isHidden = false
                img3?.isHidden = false
                lblName3?.isHidden = false
                img4?.isHidden = true
                lblName4?.isHidden = true
            }
            if count == 4{
              
                img1?.image = UIImage(named: arrNames?[0] ?? "")
                lblName1?.text = arrNames?[0]
                img2?.image = UIImage(named: arrNames?[1] ?? "")
                lblName2?.text = arrNames?[1]
                img3?.image = UIImage(named: arrNames?[2] ?? "")
                lblName3?.text = arrNames?[2]
                img3?.isHidden = false
                lblName3?.isHidden = false
                img4?.image = UIImage(named: arrNames?[3] ?? "")
                lblName4?.text = arrNames?[3]
                img4?.isHidden = false
                lblName4?.isHidden = false
            }
            return cell
        }else{
            let cellIdentifier = "ProfileCell"
            let cell = self.tblProfile.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            let lblTitle = cell.viewWithTag(100) as? UILabel
            let lblName = cell.viewWithTag(101) as? UILabel
            lblTitle?.text = arrCells?[0]
            lblName?.text = arrCells?[1]
            
            lblName?.sizeToFit()
            return cell
        }
    }
    
    override func backButtonClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func editProfileButtonClick(_ sender: UIButton){
        
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            let editProfileController = self.storyboard?.instantiateViewController(withIdentifier: "NewRegisterationViewController") as? NewRegisterationViewController
            editProfileController?.isFromUpdate = true
            self.navigationController?.pushViewController(editProfileController!, animated: true)
            self.registerFirebaseEvents(Edit_Profile, "", "", Profile_Screen, parameters: nil)
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
            return
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
