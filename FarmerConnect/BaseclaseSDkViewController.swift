//
//  BaseclaseSDkViewController.swift
//  FarmerConnect
//
//  Created by Apple on 17/12/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import UIKit
class BaseclaseSDkViewController: BaseViewController{
    
    
    var isFromSideMenu = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.topView?.isHidden = false
        
        if isFromSideMenu {
            self.findHamburguerViewController()?.showMenuViewController()
            let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
            self.navigationController?.pushViewController(toSelectPayVC!, animated: false)
            
        }
        else{
            navigateToSDK()
            isFromSideMenu = true
        }
            
        //print(diseasesMutArray)
    }
    
    override func backButtonClick(_ sender: UIButton) {
        
        
        self.navigationController?.popViewController(animated: false)
        if isFromSideMenu == true{
            self.navigationController?.popViewController(animated: true)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func navigateToSDK(){
        lblTitle?.text = "Crop Advisory"
        self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
        
        let userObj1 : User =  Constatnts.getUserObject()
        let diction = NSMutableDictionary()
        diction.setValue(userObj1.deviceToken, forKey: "deviceToken")
        diction.setValue(userObj1.userAuthorizationToken, forKey: "userAuthorizationToken")
        diction.setValue(userObj1.mobileNumber, forKey: "mobileNumber")
        diction.setValue(userObj1.customerId, forKey: "customerId")
        diction.setValue(userObj1.deviceId, forKey: "deviceId")
        
        diction.setValue(userObj1.emailId, forKey: "emailId")
        diction.setValue(userObj1.countryId, forKey: "countryId")
        
        diction.setValue(userObj1.customerTypeId, forKey: "customerTypeId")
        diction.setValue(userObj1.customerTypeName, forKey: "customerTypeName")
        
        diction.setValue(userObj1.firstName, forKey: "firstName")
        diction.setValue(userObj1.lastName, forKey: "lastName")
        diction.setValue(userObj1.pincode, forKey: "pincode")
        diction.setValue(userObj1.regionName, forKey: "regionName")
        diction.setValue(userObj1.geolocation, forKey: "geolocation")
        
        let view =    BaseClass.loadViewFilter(userObj: diction)
        self.navigationController?.pushViewController(view, animated: true)
    }
 
}
