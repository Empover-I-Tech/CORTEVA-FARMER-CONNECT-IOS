//
//  ProductsListViewController.swift
//  FarmerConnect
//
//  Created by Empover on 04/11/24.
//  Copyright © 2024 ABC. All rights reserved.
//

import UIKit

class RGLProductsListVC: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource{

    var isFromHome : Bool = false
    @IBOutlet weak var productRGLCollectionView: UICollectionView!
    let btnCart =  Custombutton()
    let btnReward =  Custombutton()
    let btnPrice =  Custombutton()
    var loginAlertView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitle?.text = NSLocalizedString("productCatalog", comment: "")
        // Do any additional setup after loading the view.
        btnCart.frame = CGRect(x:UIScreen.main.bounds.size.width-124,y: self.topView!.frame.size.height -  50,width: 45,height: 45)
        btnCart.backgroundColor =  UIColor.clear
        btnCart.setImage( UIImage(named: "Notification"), for: UIControlState())
        btnCart.addTarget(self, action: #selector(self.gotoCartScreen(_:)), for: UIControlEvents.touchUpInside)
        self.topView?.addSubview(btnCart)
        
        btnReward.frame = CGRect(x:UIScreen.main.bounds.size.width-84,y: self.topView!.frame.size.height -  50,width: 45,height: 45)
        btnReward.backgroundColor =  UIColor.clear
        btnReward.setImage( UIImage(named: "Notification"), for: UIControlState())
        btnReward.addTarget(self, action: #selector(self.gotoRewardScreen(_:)), for: UIControlEvents.touchUpInside)
        self.topView?.addSubview(btnReward)
        
        
        btnPrice.frame = CGRect(x:UIScreen.main.bounds.size.width-42,y: self.topView!.frame.size.height -  50,width: 45,height: 45)
        btnPrice.backgroundColor =  UIColor.clear
        btnPrice.setImage( UIImage(named: "Notification"), for: UIControlState())
        btnPrice.addTarget(self, action: #selector(self.gotoPriceScreen(_:)), for: UIControlEvents.touchUpInside)
        self.topView?.addSubview(btnPrice)
    }
    
    @objc func alertYesBtnAction(){
        loginAlertView.removeFromSuperview()
              let SprayServiceVC = self.storyboard?.instantiateViewController(withIdentifier: "SprayServiceViewController") as? SprayServiceViewController
              self.navigationController?.pushViewController(SprayServiceVC!, animated: true)
    }
    
    //MARK: alertNoBtnAction
    /**
     NO button action of the alertView which is displayed to the user
        */
    @objc func alertNoBtnAction(){
        loginAlertView.removeFromSuperview()
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
    
    @objc func gotoPriceScreen (_ sender: UIButton) {
        self.loginAlertView = CustomAlert.alertNewPopView(self, frame: self.view.frame, title:NSLocalizedString("alert", comment: "") as NSString, message: "are you sure" as NSString , okButtonTitle: NSLocalizedString("go_home", comment: ""), cancelButtonTitle: NSLocalizedString("cancel", comment: "")) as! UIView
        self.view.addSubview(self.loginAlertView)
        
//        let toNotificationsVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsViewController") as? NotificationsViewController
//        self.navigationController?.pushViewController(toNotificationsVC!, animated: true)
    }
    @objc func gotoRewardScreen (_ sender: UIButton) {
        
        let toNotificationsVC = self.storyboard?.instantiateViewController(withIdentifier: "RGLRewardsVC") as? RGLRewardsVC
        self.navigationController?.pushViewController(toNotificationsVC!, animated: true)
    }
    @objc func gotoCartScreen (_ sender: UIButton) {
        let toNotificationsVC = self.storyboard?.instantiateViewController(withIdentifier: "RGLOrderViewController") as? RGLOrderViewController
        self.navigationController?.pushViewController(toNotificationsVC!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "ListProductCollectionViewCell"
        
        productRGLCollectionView.register(UINib.init(nibName: "ListProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        let cell : ListProductCollectionViewCell = productRGLCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ListProductCollectionViewCell
        
//        let cropImgView = cell.contentView.viewWithTag(100) as! UIImageView
//        if let cropImage = UIImage(named:cropsArray.object(at: indexPath.row) as! String) as UIImage?{
//            cropImgView.image = cropImage
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.size.width/2)-5, height: (collectionView.bounds.size.width/2)-5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)//top,left,bottom,right
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
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
