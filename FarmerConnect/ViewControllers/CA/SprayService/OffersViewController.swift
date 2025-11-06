//
//  OffersViewController.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 22/09/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import UIKit
//import UQScannerFramework

class OffersViewController: BaseViewController{// UQScannerDelegate
   /* func onScanCompletion(result: UQScanResult) {
        
    }*/
    
    
    @IBOutlet weak var cashbackButton : UIButton!
    @IBOutlet weak var sprayServicesButton : UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let userObj = Constatnts.getUserObject()
        
        if userObj.subscribedSprayServices == "true" {
            self.cashbackButton.isHidden = false
             self.sprayServicesButton.isHidden = false
        }else {
            self.cashbackButton.isHidden = true
             self.sprayServicesButton.isHidden = false
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //self.navigationController?.navigationBar.isHidden = false
        self.topView?.isHidden = false
        self.lblTitle?.text = NSLocalizedString("Offers", comment: "")     // "Paramarsh"
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        
  
    }
    override func backButtonClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCashbacks(_ sender : UIButton) {
        let rewardsVC = self.storyboard?.instantiateViewController(withIdentifier: "RewardsViewController") as? RewardsViewController
               self.navigationController?.pushViewController(rewardsVC!, animated: true)
    }

    @IBAction func btnSprayServices(_ sender : UIButton) {
        let userobj = Constatnts.getUserObject()
        if userobj.subscribedSprayServices == "true" {
            let appdele = UIApplication.shared.delegate as? AppDelegate
            appdele?.isOpennedGenuinityCheckFromOffers = true
        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
            
        self.navigationController?.pushViewController(toSelectPayVC!, animated: false)
        }else {
           let sprayServiceVC = self.storyboard?.instantiateViewController(withIdentifier: "SprayServiceViewController") as? SprayServiceViewController
           self.navigationController?.pushViewController(sprayServiceVC!, animated: true)
        }
       }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
