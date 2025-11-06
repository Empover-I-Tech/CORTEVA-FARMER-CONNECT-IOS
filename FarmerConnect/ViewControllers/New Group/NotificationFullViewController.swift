//
//  NotificationFullViewController.swift
//  PioneerEmployee
//
//  Created by Empover-i-Tech on 08/06/20.
//  Copyright © 2020 Empover. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyGif

class NotificationFullViewController: BaseViewController , UITextViewDelegate , UIScrollViewDelegate ,SwiftyGifDelegate{
    
    
    //    @IBOutlet var popUPView: UIView!
    //    @IBOutlet var OkButton: UIButton!
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var  messageView: UITextView!
    @IBOutlet var  imgNotification: UIImageView!
      @IBOutlet var  viewNotification: UIView!
    //  weak var cellClickDelegate: sendData!
    var alertMessage : String = ""
    var imagURL : String  = ""
    @IBOutlet var  imgConstraint: NSLayoutConstraint!
    
    var desc : String? = nil
    
    let btnNotification =  UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgNotification.delegate = self
        btnNotification.frame = CGRect(x:UIScreen.main.bounds.size.width-50,y: 10,width: 30,height: 30)
         btnNotification.backgroundColor =  UIColor.clear
         btnNotification.setImage( UIImage(named: "FullScreen"), for: UIControlState())
         btnNotification.addTarget(self, action: #selector(self.notificationsButtonClick(_:)), for: UIControlEvents.touchUpInside)
         
        if imagURL != ""{
                  self.topView?.addSubview(btnNotification)
                  imgNotification.isHidden = false
            viewNotification.isHidden = false
              }else {
                  btnNotification.isHidden = true
                  imgNotification.isHidden = true
            viewNotification.isHidden = true
              }
        if imagURL != ""{
            let imgStr = imagURL
            let url = URL(string:imgStr)
            if (imgStr.contains("gif")) {
                self.playPauseButton.isHidden = false
                imgNotification.setGifFromURL(url!)
            }else {
                SwiftLoader.show(animated: true)
                self.playPauseButton.isHidden = true
                imgNotification.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceHolderImage")!, options: SDWebImageOptions.refreshCached, completed: { (img, error, _, ur) in
                    if error != nil {
                        SwiftLoader.hide()
                        self.imgNotification.image =  UIImage(named: "PlaceHolderImage")!
                    }else {
                        SwiftLoader.hide()
                        self.imgNotification.image = img
                    }
                })
            }
        }else {
            self.playPauseButton.isHidden = true
        }
        
        
        // Do any additional setup after loading the view.
//        self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
        self.messageView.dataDetectorTypes = .all
        
        self.messageView.backgroundColor = UIColor.clear
        self.messageView.isOpaque = false
        self.messageView.isEditable = false
        self.messageView.isScrollEnabled = true
        self.messageView.font = UIFont(name: "OpenSans-Regular", size: CGFloat(16.0))
        self.messageView.text = alertMessage
        self.showAnimate()
        
    }
    
      
    
      override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         //  UserDefaults.standard.set(false, forKey: "PeetDontShow")
        
         self.topView?.isHidden = false
         lblTitle?.text = "Notifications"
         self.topView?.backgroundColor = App_Theme_Blue_Color
         
        let btnNotification = UIButton()
            btnNotification.frame = CGRect(x:UIScreen.main.bounds.size.width - 50,y: 10,width: 30,height: 30)
            btnNotification.backgroundColor =  UIColor.clear
            btnNotification.addTarget(self, action: #selector(self.notificationsButtonClick(_:)), for: UIControlEvents.touchUpInside)
            self.topView?.addSubview(btnNotification)
        
        
      
        
      
//      self.notificationButton?.isHidden = false
//           self.notificationButton?.setImage(UIImage(named: "FullScreen"), for: UIControlState())
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        
        
    }
    override func backButtonClick(_ sender: UIButton) {
      
        self.navigationController?.popViewController(animated: true)
      }
    func description(_ desc :String) {
        //self.cellClickDelegate.description(desc)
    }
    
    @objc  func notificationsButtonClick(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.myOrientation = .landscape
                    let notificationDetailsVC = NotificationDetailsPopUpViewController()
        notificationDetailsVC.alertMessage = alertMessage
               notificationDetailsVC.imagURL = imagURL
                    let navController = UINavigationController(rootViewController: notificationDetailsVC)
                    self.navigationController?.present(navController, animated: true, completion: nil)
      
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
    
    
    
    func gifURLDidFinish(sender: UIImageView) {
        
        SwiftLoader.hide()
    }
    
    func gifURLDidFail(sender: UIImageView) {
        
        SwiftLoader.hide()
    }
    
    func gifDidStart(sender: UIImageView) {
        
        //SwiftLoader.show(animated: true)
    }
    
    func gifDidLoop(sender: UIImageView) {
        SwiftLoader.hide()
    }
    
    func gifDidStop(sender: UIImageView) {
        SwiftLoader.hide()
    }
    
    func removeAnimate() {
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
    @IBAction func OkAction(_ sender: Any) {
        self.removeAnimate()
    }
    
    @IBAction func playPauseAction(_ sender: UIButton) {
        if playPauseButton.imageView?.image == UIImage(named: "playWhite") {
            self.imgNotification.startAnimatingGif()
            playPauseButton.setImage(UIImage(named: "pauseWhite"), for: .normal)
            
        }else {
            self.imgNotification.stopAnimatingGif()
            playPauseButton.setImage(UIImage(named: "playWhite"), for: .normal)
            
        }
        
    }
    
    
}
