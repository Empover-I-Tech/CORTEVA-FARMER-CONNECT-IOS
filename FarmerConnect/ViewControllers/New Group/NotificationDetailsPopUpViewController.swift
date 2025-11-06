//
//  NotificationDetailsPopUpViewController.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 19/05/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyGif


class NotificationDetailsPopUpViewController: UIViewController, UITextViewDelegate , UIScrollViewDelegate ,SwiftyGifDelegate{
    
    @IBOutlet var popUPView: UIView!
    @IBOutlet var OkButton: UIButton!
     @IBOutlet var playPauseButton: UIButton!
    
    @IBOutlet var lblHeaderText: UILabel!
    @IBOutlet var  scrollView : UIScrollView!
    
    @IBOutlet var  messageView: UITextView!
    @IBOutlet var  imgNotification: UIImageView!
  //  weak var cellClickDelegate: sendData!
    var alertMessage : String = ""
    var imagURL : String  = ""
    @IBOutlet var  imgConstraint: NSLayoutConstraint!
    
    var desc : String? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgNotification.delegate = self
        if imagURL != ""{
//            self.imgConstraint.constant =  350
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
             self.imgNotification.isHidden = false
        }else {
               self.playPauseButton.isHidden = true
//             self.imgConstraint.constant =  0
            self.imgNotification.isHidden = true
        }
       
        
        // Do any additional setup after loading the view.
//        self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
//        self.messageView.dataDetectorTypes = .all
//
//        self.messageView.backgroundColor = UIColor.clear
//        self.messageView.isOpaque = false
//        self.messageView.isEditable = false
//        self.messageView.isScrollEnabled = true
//        self.messageView.font = UIFont(name: "OpenSans-Regular", size: CGFloat(16.0))
//        self.messageView.text = alertMessage
        self.showAnimate()
     
    }
    
    func description(_ desc :String) {
        //self.cellClickDelegate.description(desc)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
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
//
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView == self.messageView {
//            self.scrollView.setContentOffset(CGPoint(x: 0, y: self.popUPView.frame.origin.y), animated: false)
//        }
//    }
//    func textViewDidEndEditing(_ textView: UITextView) {
//        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
//    }
    
    func gifURLDidFinish(sender: UIImageView) {
      
         SwiftLoader.hide()
    }

    func gifURLDidFail(sender: UIImageView) {
      
        SwiftLoader.hide()
    }

    func gifDidStart(sender: UIImageView) {
       
       SwiftLoader.show(animated: true)
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
    @IBAction func backAction(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
              appDelegate.myOrientation = .portrait
         self.navigationController?.navigationBar.isHidden = false
        self.dismiss(animated: true, completion: nil)
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
