//
//  NumberOfAcresViewController.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 07/10/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import UIKit
protocol SelectedNumberOfAcresValueDelegate : class {
    func numberOfAcresValue(_ value : String)
}
class NumberOfAcresViewController: UIViewController {
    
    weak var delegate : SelectedNumberOfAcresValueDelegate?
    @IBOutlet weak var tfNumberOfAcres : UITextField!
    var cropID : Int?
    var noOfScans : Int?
    var noOfAcres : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfNumberOfAcres.text = "\(self.noOfAcres ?? 0)"
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitAction(_ sender : UIButton){
        if tfNumberOfAcres.text == "" {
            self.view.makeToast("Please Enter number Of Acres")
        }else {
            let appdele = UIApplication.shared.delegate as? AppDelegate
            appdele?.isOpennedGenuinityCheckFromOffers = true
            let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
            toSelectPayVC?.cropId =  cropID ?? 0
            toSelectPayVC?.noOfScans  = noOfScans ?? 0
            toSelectPayVC?.noOfAcres  = Int(tfNumberOfAcres.text!) ?? 0
            toSelectPayVC?.isFromSprayServiceScanner = true
            self.navigationController?.pushViewController(toSelectPayVC!, animated: false)
            removeAnimate()
        }
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
        });
    }
    
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
            
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    

}
