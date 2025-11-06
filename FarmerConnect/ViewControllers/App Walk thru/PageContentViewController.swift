//
//  PageContentViewController.swift
//  FarmerConnect
//
//  Created by Empover i-Tech Pvt Ltyd on 29/04/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class PageContentViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
        var arrItems : NSMutableArray = NSMutableArray()
    
    @IBOutlet var pagedControl: UIPageControl!
    @IBOutlet var collectionViewe: UICollectionView!
    
    var isFromHome : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let net = NetworkReachabilityManager(host: "www.google.com")
       
        pagedControl.isHidden = true
        
        if net?.isReachable == true {
            self.getOnbBoardingScreensFromServer()
        }else{
            self.displayOnBoardImagesWhenNoNetwork()
        }
        
        self.navigationController?.navigationBar.isHidden = true
        
        pagedControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)

    }
    
    func getOnbBoardingScreensFromServer() {
        
        SwiftLoader.show(animated: true)
        
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_ON_BOARD_SCREENS])
        let parameters = ["deviceType":Device_Type]
        
        Alamofire.request(urlString, method: .post, parameters:parameters , encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                    if responseStatusCode == STATUS_CODE_200{
                        if (json as! NSDictionary).value(forKey: "response") as? String ?? "" != "" {
                            let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                            let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                            
                            if let arrObjects = decryptData.value(forKey: "OnBoardDataList") as? [Any]{
                                
                                self.arrItems.removeAllObjects()
                                self.arrItems.addObjects(from: arrObjects)
                                
                                print("the object areee",self.arrItems)
                                
                                self.collectionViewe.delegate = self
                                self.collectionViewe.dataSource = self
                                
                                self.pagedControl.isHidden = false
                                self.pagedControl.numberOfPages = self.arrItems.count
                                
                            }
                            else{
                                self.displayOnBoardImagesWhenNoNetwork()
                            }
                        }
                        else{
                            self.displayOnBoardImagesWhenNoNetwork()
                        }
                    }
                    else{
                        self.displayOnBoardImagesWhenNoNetwork()
                    }
                }
                else{
                    self.displayOnBoardImagesWhenNoNetwork()
                }
            }
        }
    }
    
    func displayOnBoardImagesWhenNoNetwork() {
        
        let dict1 : NSMutableDictionary = NSMutableDictionary()
        dict1.setValue("Crop Advisory", forKey: "title")
        dict1.setValue("Crop Advisory is a holistic tool that reminds you about all the steps necessary for highest yields and best quality of your farm produce.", forKey: "description")
        dict1.setValue("walk_thru1", forKey: "Image")
        
//        let dict2 : NSMutableDictionary = NSMutableDictionary()
//        dict2.setValue("Buy Products", forKey: "title")
//        dict2.setValue("Get our exclusive products online.", forKey: "description")
//        dict2.setValue("walk_thru2", forKey: "Image")
//        
//        let dict3 : NSMutableDictionary = NSMutableDictionary()
//        dict3.setValue("Crop Diagnosis", forKey: "title")
//        dict3.setValue("Are your plants healthy? Take a picture of your crop with smart phone. Corteva will analyze it and provide insights with in seconds.", forKey: "description")
//        dict3.setValue("walk_thru3", forKey: "Image")
        
        let dict6 : NSMutableDictionary = NSMutableDictionary()
        dict6.setValue("Customer Service", forKey: "title")
        dict6.setValue("User can raise the issues and will be escalate to respective employees to resolve the raised issue.", forKey: "description")
        dict6.setValue("walk_thru6", forKey: "Image")
        
//        let dict5 : NSMutableDictionary = NSMutableDictionary()
//        dict5.setValue("Rent Equipment", forKey: "title")
//        dict5.setValue("Book an equipment on rent from other farmers/owners.", forKey: "description")
//        dict5.setValue("walk_thru5", forKey: "Image")
//        
//        let dict4 : NSMutableDictionary = NSMutableDictionary()
//        dict4.setValue("Rent Out Equipment", forKey: "title")
//        dict4.setValue("Farmer can provide their equipment on rental basis to other farmers.", forKey: "description")
//        dict4.setValue("walk_thru4", forKey: "Image")
        
        arrItems.removeAllObjects()
        
        arrItems.add(dict1)
       // arrItems.add(dict2)
       // arrItems.add(dict3)
       // arrItems.add(dict4)
       // arrItems.add(dict5)
        arrItems.add(dict6)
        
        collectionViewe.delegate = self
        collectionViewe.dataSource = self
        
        pagedControl.isHidden = false
        pagedControl.numberOfPages = arrItems.count
        
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    @objc func changePage(sender: AnyObject) -> () {
        let x = pagedControl.currentPage
        
        let indexPath = IndexPath(item: x, section: 0)

        collectionViewe.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
    }

    @objc func btnSkipOrGetStartedClicked(_ sender : UIButton) {
        UserDefaults.standard.set(true, forKey: "isWalkThruShown")
        UserDefaults.standard.synchronize()
      
        UIApplication.shared.isStatusBarHidden = false
        
        if isFromHome == true {
            self.navigationController?.popViewController(animated: true)
            return
        }
        if let isLogin = UserDefaults.standard.value(forKey: "login") as? Bool{

            if isLogin == true{
                guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else{ return }
                self.navigationController?.pushViewController(viewController, animated: true)
            }else{
                //NavigationViewController
                guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? ViewController else{ return }
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        else{
            //NavigationViewController
            guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? ViewController else { return}
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    //MARK: collectionView datasource and delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = self.collectionViewe.dequeueReusableCell(withReuseIdentifier: "pagedHeader", for: indexPath)
            let dictNews = arrItems.object(at: indexPath.row) as? NSDictionary
            
            let dashboardImg = cell.contentView.viewWithTag(100) as! UIImageView
     
        let imagePlaceholderName : String = String(format: "walk_thru%d", indexPath.row+1)
        
//            dashboardImg.image = UIImage(named:dictNews?.object(forKey: "Image") as! String)
            dashboardImg.kf.setImage(with: dictNews?.object(forKey: "imageUrl") as? Resource , placeholder: UIImage(named:imagePlaceholderName), options: nil, progressBlock: nil)
        
        let lblTitle = cell.contentView.viewWithTag(101) as! UILabel
            let lblDesc = cell.contentView.viewWithTag(102) as! UILabel
            
            lblTitle.text = dictNews?.object(forKey: "title") as? String
            lblDesc.text =  dictNews?.object(forKey: "description") as? String
        
            let btnGetStarted = cell.contentView.viewWithTag(103) as! UIButton
        
            let btnSkip = cell.contentView.viewWithTag(104) as! UIButton

        if indexPath.row == arrItems.count - 1 {
            btnSkip.isHidden = true
            btnGetStarted.isHidden = false
            
            if isFromHome == true {
                btnGetStarted.setTitle("Go To Home", for: UIControlState.normal)
            }

            btnGetStarted.addTarget(self, action: #selector(self.btnSkipOrGetStartedClicked(_:)), for: UIControlEvents.touchUpInside)

        }else{
            btnSkip.isHidden = false
            btnGetStarted.isHidden = true
            btnSkip.addTarget(self, action: #selector(self.btnSkipOrGetStartedClicked(_:)), for: UIControlEvents.touchUpInside)

        }
            return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //        return UIEdgeInsetsMake(15, 10, 10, 10)//top,left,bottom,right
        
            return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pagedControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

}
