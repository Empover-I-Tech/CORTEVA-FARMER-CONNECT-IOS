//
//  ParamarshProfileViewController.swift
//  FarmerConnect
//
//  Created by Empover on 19/03/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit
import Alamofire

class ParamarshProfileViewController: BaseViewController {

    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblMobileNumber: UILabel!
    
    @IBOutlet weak var privacyPolicyLbl: ActiveLabel!
    
    var isFromSideMenu = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let privacyStr = NSLocalizedString("privacy_policy", comment: "")
        let customType = ActiveType.custom(pattern: privacyStr)
        
        privacyPolicyLbl.enabledTypes.append(customType)
        
        privacyPolicyLbl?.customize({(label) in
            label.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                switch type {
                case customType:
                    atts[NSAttributedStringKey.underlineStyle] = isSelected ? NSUnderlineStyle.styleSingle.rawValue : NSUnderlineStyle.styleSingle.rawValue
                    atts[NSAttributedStringKey.foregroundColor] = isSelected ? UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0) : UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                default: ()
                }
                return atts
            }
            label.handleCustomTap(for: customType, handler: { (message) in
                // print("clicked")
                let net = NetworkReachabilityManager(host: "www.google.com")
                if net?.isReachable == true{
                    self.findHamburguerViewController()?.hideMenuViewControllerWithCompletion(nil)
                    let storyBoard = UIStoryboard(name: "Main" , bundle: nil)
                    let toPrivacyPolicyWebViewVC = storyBoard.instantiateViewController(withIdentifier: "LoginPrivacyPolicyViewController") as! LoginPrivacyPolicyViewController
                    toPrivacyPolicyWebViewVC.privacyPolicyURLStr = PRIVACY_POLICY_URL as NSString
                    self.present(toPrivacyPolicyWebViewVC, animated: true, completion: nil)
                }
                else{
                    //self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE, duration: 1.0, position: .center)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                    return
                }
            })
            label.customColor[customType] = UIColor.white
        })
            
        let userObj = Constatnts.getUserObject()

                
        ParamarshSingleton.requestToGetMasterData()
        self.recordScreenView("ParamarshProfileViewController", Paramarsh_Profile)
       
        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber,USER_ID:userObj.customerId,PINCODE:userObj.pincode,User_First_Name:userObj.firstName,User_Last_Name:userObj.lastName]
        self.registerFirebaseEvents(PV_Paramarsh_Profile, "", "", Paramarsh_Profile, parameters: fireBaseParams as NSDictionary)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //self.navigationController?.navigationBar.isHidden = false
        self.topView?.isHidden = false
        self.lblTitle?.text = NSLocalizedString("paramarsh", comment: "")       // "Paramarsh"
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        if isFromSideMenu == true{
            self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
        }
        let userObj = Constatnts.getUserObject()
        lblName.text = String(format:"%@ %@",userObj.firstName!,userObj.lastName!)
        lblMobileNumber.text = String(format:"%@",userObj.mobileNumber!)
    }
    
    override func backButtonClick(_ sender: UIButton) {
        if isFromSideMenu == true{
            self.findHamburguerViewController()?.showMenuViewController()
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func viewTicketsButtonClick(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Paramarsh" , bundle: nil)
        let toViewTicketsVC = storyBoard.instantiateViewController(withIdentifier: "TicketsViewController") as! TicketsViewController
        let net = NetworkReachabilityManager(host: "www.google.com")
        let userObj = Constatnts.getUserObject()
        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber,USER_ID:userObj.customerId,PINCODE:userObj.pincode,User_First_Name:userObj.firstName,User_Last_Name:userObj.lastName]
        self.registerFirebaseEvents(View_Tickets, "", "", Paramarsh_Profile, parameters: fireBaseParams as NSDictionary)
        if net?.isReachable == true{
            self.navigationController?.pushViewController(toViewTicketsVC, animated: true)
        }
        else{
            let resultArray = ParamarshSingleton.getTicketDetailsFromDB("TicketDetailsEntity")
            print(resultArray)
            if resultArray.count > 0 {
                self.navigationController?.pushViewController(toViewTicketsVC, animated: true)
            }
            else{
                self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
            }
        }
    }
    
    @IBAction func raiseTicketButtonClick(_ sender: Any) {
        let userObj = Constatnts.getUserObject()
        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber,USER_ID:userObj.customerId,PINCODE:userObj.pincode,User_First_Name:userObj.firstName,User_Last_Name:userObj.lastName]
        self.registerFirebaseEvents(Raise_Tickets, "", "", Paramarsh_Profile, parameters: fireBaseParams as NSDictionary)
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            let storyBoard = UIStoryboard(name: "Paramarsh" , bundle: nil)
            let toRaiseTicketVC = storyBoard.instantiateViewController(withIdentifier: "RaiseTicketViewController") as! RaiseTicketViewController
            self.navigationController?.pushViewController(toRaiseTicketVC, animated: true)
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
