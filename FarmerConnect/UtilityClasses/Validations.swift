//
//  Validations.swift
//  PioneerEmployee
//
//  Created by Empover on 11/09/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class Validations: NSObject {

    class func checkKeyNotAvail( _ dict: NSDictionary, key:String) -> AnyObject
    {
        if let val = dict[key]
        {
            if val is String
            {
                return val as AnyObject
            }
            else if val is Double{
                return val as AnyObject
            }
            else if val is Int64{
                return val as AnyObject
            }
            else if val is Float{
                return val as AnyObject
            }
            else if val is Bool{
                return val as AnyObject
            }
            return "" as AnyObject
        }
        else {
            
            return "" as AnyObject
        }
    }
    
    /*class func isNullString(_ string :NSString) -> Bool
     {
     var tempStr = string
     if string.isKind(of: NSNull.self) == false {
     tempStr = string.trimmingCharacters(in: CharacterSet.whitespaces) as NSString
     }
     if tempStr.length == 0 || tempStr.isEqual(to: "") || tempStr.isEqual(to: "(null)") || tempStr.isEqual(to: "<null>") || tempStr.isEqual(NSNull) {
     return true
     }
     else{
     return false
     }
     }*/
    
    
    class func checkDateKeyNotAvail( _ dict: NSDictionary, key:String) -> AnyObject
    {
        if let val = dict[key]
        {
            if val is Date
            {
                return val as AnyObject
            }
            return Date() as AnyObject
        }
        else {
            
            return Date() as AnyObject
        }
    }
    
    
    class func checkKeyNotAvailForArray( _ dict: NSDictionary, key:String) -> AnyObject
    {
        if let val = dict[key]
        {
            if val is NSArray
            {
                return val as AnyObject
            }
            return NSArray()
        }
        else
        {
            return NSArray()
        }
    }
    
    class func checkKeyNotAvailForDictionary( _ dict: NSDictionary, key:String) -> AnyObject
    {
        if let val = dict[key]
        {
            if val is NSDictionary
            {
                return val as AnyObject
            }
            return NSDictionary()
        }
        else
        {
            return NSDictionary()
        }
    }

    class func isNullString(_ string : NSString) -> Bool {
        var string = string
        if(!(string.isKind(of: NSNull.self))){
            string = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as NSString
        }
        
        if(string == NSNull() || string.length == 0 || string.isEqual(to: "") || string.isEqual(to: "(null)") || string.isEqual(to: "<null>")){
            return true
        }
        return false
    }
    class func showShareActivityController(viewController: UIViewController,fileUrl: URL,userName:String,message: String) -> UIActivityViewController{
        
        // set up activity view controller
        let msgString = message //"FarmerConnect"//String(format: "Listen to %@'s story on Yawo",userName)
        //let msgString = String(format: "Listen to %@'s story on",userName)
        //let imgUrl = "http://www.xtory.co/images/app/Home-sample3-200x200-Final.png"
        
        let shareContent : NSArray = NSArray(objects: fileUrl,msgString)
        let activityViewController = UIActivityViewController(activityItems: shareContent as! [Any], applicationActivities: nil)
        activityViewController.setValue(msgString, forKey: "Subject")
        //activityViewController.
        activityViewController.popoverPresentationController?.sourceView = viewController.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        //activityViewController.excludedActivityTypes = [ UIActivityType.mail, UIActivityType.postToVimeo, UIActivityType.postToWeibo, UIActivityType.postToFlickr, UIActivityType.postToTencentWeibo, UIActivityType.message, UIActivityType.saveToCameraRoll, UIActivityType.print, UIActivityType.copyToPasteboard,UIActivityType.assignToContact, UIActivityType.addToReadingList, UIActivityType.airDrop]
        return activityViewController;
    }
    class func showShareActivityController(viewController: UIViewController,fileUrl: URL,userName:String,message: String,imgUrl : UIImage) -> UIActivityViewController{
        
        // set up activity view controller
        let msgString = message //"FarmerConnect"//String(format: "Listen to %@'s story on Yawo",userName)
        //let msgString = String(format: "Listen to %@'s story on",userName)
        //let imgUrl = "http://www.xtory.co/images/app/Home-sample3-200x200-Final.png"
        
        let shareContent : NSArray = NSArray(objects: msgString,fileUrl,imgUrl)
        let activityViewController = UIActivityViewController(activityItems: shareContent as! [Any], applicationActivities: nil)
        activityViewController.setValue(msgString, forKey: "Subject")
        //activityViewController.
        activityViewController.popoverPresentationController?.sourceView = viewController.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        //activityViewController.excludedActivityTypes = [ UIActivityType.mail, UIActivityType.postToVimeo, UIActivityType.postToWeibo, UIActivityType.postToFlickr, UIActivityType.postToTencentWeibo, UIActivityType.message, UIActivityType.saveToCameraRoll, UIActivityType.print, UIActivityType.copyToPasteboard,UIActivityType.assignToContact, UIActivityType.addToReadingList, UIActivityType.airDrop]
        return activityViewController;
    }
    class func showModalAlertView(_ alertTitle:NSString, _ message : NSString,cancelTitle : NSString,okTitle : NSString, cancelHandler:@escaping (_ alertControl : UIAlertController) -> Void, okHandler:@escaping (_ alertControl : UIAlertController) -> Void) -> UIAlertController{
        var title = ""
        if Validations.isNullString(alertTitle) == false {
            title = alertTitle as String
        }
        let alertView : UIAlertController = UIAlertController(title: title, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        //alertView.view.tag=100
        let okAction : UIAlertAction = UIAlertAction(title: okTitle as String, style: UIAlertActionStyle.default) { (action) -> Void in
            okHandler(alertView)
        }
        alertView.addAction(okAction)
        let cancelAction : UIAlertAction = UIAlertAction(title: cancelTitle as String, style: UIAlertActionStyle.cancel) { (action) -> Void in
            cancelHandler(alertView)
        }
        
        alertView.addAction(cancelAction)
        return alertView
    }
    
    class func checkUserEnabledLocationServiceOrNot(viewController: UIViewController, showAlert: Bool) -> Bool{
        if (!CLLocationManager.locationServicesEnabled() || CLLocationManager.authorizationStatus() == .denied)
        {
            if showAlert == true {
                let alert : UIAlertController = UIAlertController(title: "Location access", message: "In order to be notified, please open this app's settings and enable location access", preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                
                let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                    if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url as URL, options: [:], completionHandler: { (status) in
                                
                            })
                        } else {
                            // Fallback on earlier versions
                            UIApplication.shared.openURL(url as URL)
                        }
                    }
                }
                alert.addAction(openAction)
                viewController.present(alert, animated: true, completion: nil)
            }
            return false
        }
        return true
    }
    class func isValidEmailAddress(_ emailString:String) -> Bool
    {
        //let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailString)
    }
    class func validateUrl (urlString: NSString) -> Bool {
        let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: urlString)
    }
}
