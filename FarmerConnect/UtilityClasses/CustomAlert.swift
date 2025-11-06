//
//  CustomAlert.swift
//  CustomAlertSample
//
//  Created by Empover on 14/09/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import SwiftyGif


class CustomAlert: NSObject
{
    class func farmerAssistAlert(_ delegate: UITextFieldDelegate, frame : CGRect, title : NSString, okButtonTitle : NSString,placeHolderText:String,keyboardType:UIKeyboardType) -> AnyObject
    {
        //let height=frame.size.height/3
        //let width = frame.size.width-80
        
        let Height:CGFloat = (33.11 * frame.height/120)
        let width :CGFloat = frame.size.width-40
        let posX :CGFloat = (frame.size.width - width ) / 2
        
        // unowned(unsafe) var delegate: UITextFieldDelegate?
        
        //alert view background
        let alertView_Bg: UIView = UIView (frame: CGRect(x: 0,y: 0 ,width: frame.size.width,height: frame.size.height))
        alertView_Bg.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        
        //let alertView: UIView = UIView (frame: CGRect(x: frame.minX+40,y: (frame.size.height-height)/2 ,width: width,height: height))
        
        let alertView: UIView = UIView (frame: CGRect(x: posX,y: (alertView_Bg.frame.height-Height)/2 ,width: width,height: Height))
        alertView.backgroundColor = UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        alertView.layer.cornerRadius = 10.0
        alertView_Bg.addSubview(alertView)
        
        //top view for title and close button
        let topView: UIView = UIView (frame: CGRect(x: 0,y: 0 ,width: alertView.frame.width,height: ((15 * alertView.frame.height)/60)))
        topView.backgroundColor = App_Theme_Blue_Color//UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 0.8)
        
        //title on top view
        let lblHeading : UILabel = UILabel (frame: CGRect(x: 5,y: 12,width:alertView.frame.width-50,height: ((15 * alertView.frame.height)/100)))
        lblHeading.text = title as String
        lblHeading.textColor = UIColor.white    //UIColor(red: 0.0/255, green: 149.0/255, blue: 159.0/255, alpha: 1)
        lblHeading.textAlignment = NSTextAlignment.center
        lblHeading.font = UIFont.boldSystemFont(ofSize: 17.0)
        topView.addSubview(lblHeading)
        
        //close button on top view
        let closeView : UIButton = UIButton (frame: CGRect(x: alertView.frame.size.width-40,y: 8,width: 30,height: 30))
        closeView.backgroundColor = UIColor.clear//UIColorFromRGB(headerBlueCOlor, alpha: 1)
        closeView.setImage(UIImage(named: "icon_cross.png"), for: UIControlState())
        closeView.setTitle("", for: UIControlState())
        closeView.addTarget(delegate, action: Selector(("alertCloseBtn")), for: UIControlEvents.touchUpInside)
         topView.addSubview(closeView)
        
        alertView.addSubview(topView)
        
        //textField
        let mobileNoTxtFld : UITextField = UITextField (frame: CGRect(x: 30,y: topView.frame.size.height + 30,width: width-60,height: 40))
        mobileNoTxtFld.backgroundColor = UIColor.white
        mobileNoTxtFld.layer.cornerRadius = 5.0
        mobileNoTxtFld.borderWidth = 1.0
        mobileNoTxtFld.borderColor = UIColor.gray
        mobileNoTxtFld.keyboardType = keyboardType
        mobileNoTxtFld.placeholder = placeHolderText
        mobileNoTxtFld.textAlignment = NSTextAlignment.center
        mobileNoTxtFld.delegate =  delegate
        mobileNoTxtFld.tag = 22222
        alertView.addSubview(mobileNoTxtFld)
        
        //submit button
        let btnSubmit : UIButton = UIButton (frame: CGRect(x: (width-120)/2, y: mobileNoTxtFld.frame.maxY+20,width: 120,height: 40))
        btnSubmit.backgroundColor = App_Theme_Blue_Color//UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 0.8)
        btnSubmit.layer.cornerRadius = 5.0
        btnSubmit.setTitle(okButtonTitle as String, for: UIControlState())
        btnSubmit.addTarget(delegate, action: Selector(("alertSubmit")), for: UIControlEvents.touchUpInside)
        
        alertView.addSubview(btnSubmit)
        
        var alertFrame = alertView.frame
        alertFrame.size.height = btnSubmit.frame.maxY + 10
        alertView.frame = alertFrame
        
        alertFrame.origin.y = (frame.size.height - 64 - alertFrame.size.height) / 2
        alertView.frame = alertFrame

        return alertView_Bg
    }
    
    class func alertDistanceInfoPopUpView(_ delegate: AnyObject, frame : CGRect , title : NSString, message : NSString, buttonTitle : String , hideClose : Bool) -> AnyObject
    {
        var Height:CGFloat = (33.11 * frame.height/120)
        var width :CGFloat = frame.size.width-40
        var posX :CGFloat = (frame.size.width - width ) / 2
        var lablHeightPadding :CGFloat = 27
        // unowned(unsafe) var delegate: UITextFieldDelegate?
        
        if hideClose == false
        {
            Height = (33.11 * frame.height/150)
            width = frame.size.width-70
            posX  = (frame.size.width - width ) / 2
            lablHeightPadding = CGFloat(40)
        }
        
        let alertView_Bg: UIView = UIView (frame: CGRect(x: 0,y: 0 ,width: frame.size.width,height: frame.size.height))
        
        alertView_Bg.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        
        let alertView: UIView = UIView (frame: CGRect(x: posX,y: (alertView_Bg.frame.height-Height)/2 ,width: width,height: Height))
        alertView.backgroundColor = UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        alertView.layer.cornerRadius = 10.0
        alertView_Bg.addSubview(alertView)
        
        let CloseBtn_View: UIView;
        
        //        if GRAPHICS.Screen_Height() == 480.0
        //        {
        //            CloseBtn_View = UIView (frame: CGRect(x: alertView.frame.maxX-20,y: alertView.frame.minY - 1 ,width: 50,height: 50))
        //        }
        //
        //        else
        //        {
        
        CloseBtn_View = UIView (frame: CGRect(x: alertView.frame.maxX-42,y: alertView.frame.minY-50 ,width: 50,height: 50))
        //  }
        
        CloseBtn_View.backgroundColor = UIColor.clear
        
        alertView_Bg.addSubview(CloseBtn_View)
        
        let lblHeading : UILabel = UILabel (frame: CGRect(x: 0,y: 5,width: alertView.frame.width,height: ((15 * alertView.frame.height)/100)))
        lblHeading.text = title as String
        lblHeading.textColor = UIColor(red: 34.0/255, green: 119.0/255, blue: 45.0/255, alpha: 0.8)
        // lblHeading.font = GRAPHICS.FONT_BOLD(16)
        lblHeading.textAlignment = NSTextAlignment.center
        alertView.addSubview(lblHeading)
        
        let viewLine : UIView = UIView (frame: CGRect(x: 10,y: lblHeading.frame.maxY+10,width: width-20,height: 1))
        viewLine.backgroundColor = UIColor(red: 56/255, green: 85/255, blue: 128/255, alpha: 1.0)
        alertView.addSubview(viewLine)
        
        
        let closeBtn : UIButton = UIButton (frame: CGRect(x: lblHeading.frame.maxX - 30, y: 0,width: 35,height: 35))
        closeBtn.backgroundColor = UIColor.clear//UIColorFromRGB(headerBlueCOlor, alpha: 1)
        
        closeBtn.setImage(UIImage(named: "CropDetailsDeleteImg"), for: UIControlState())
        closeBtn.setTitle("", for: UIControlState())
        closeBtn.layer.cornerRadius = closeBtn.frame.width/2
        // closeBtn.titleLabel!.font = GRAPHICS.FONT_REGULAR(16)
        closeBtn.addTarget(delegate, action: Selector(("infoAlertClose")), for: UIControlEvents.touchUpInside)
        alertView.addSubview(closeBtn)
        CloseBtn_View.isHidden = hideClose
        closeBtn.isHidden = hideClose
        
        let lbl_Message : UILabel = UILabel (frame: CGRect(x: 5,y: viewLine.frame.maxY+((15 * alertView.frame.height)/100) - 8,width: alertView.frame.width - 10,height: ((lablHeightPadding * alertView.frame.height)/100)))
        lbl_Message.text = message as String
        // lbl_Message.textColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        //lbl_Message.font = GRAPHICS.FONT_REGULAR(15)
        lbl_Message.textColor = UIColor.black    //UIColor(red: 34.0/255, green: 119.0/255, blue: 45.0/255, alpha: 0.8)
        
        lbl_Message.numberOfLines = 0
        lbl_Message.sizeToFit()
        
        var ViewFrame = lbl_Message.frame
        ViewFrame.origin.x = (alertView.frame.width - lbl_Message.frame.width) / 2
        lbl_Message.frame = ViewFrame
        lbl_Message.textAlignment = NSTextAlignment.center
        alertView.addSubview(lbl_Message)
        
        let btnSubmit : UIButton = UIButton (frame: CGRect(x: 0, y: lbl_Message.frame.maxY+((22.5 * alertView.frame.height)/100),width: alertView.frame.size.width,height: 35))
       // btnSubmit.backgroundColor =  UIColor(red: 34.0/255, green: 119.0/255, blue: 45.0/255, alpha: 1.0)
        btnSubmit.backgroundColor = App_Theme_Blue_Color
        //btnSubmit.setBackgroundImage(GRAPHICS.SIGNUP_JOINNOW_NORMAL_IMAGE(), for: UIControlState())
        // btnSubmit.setBackgroundImage(GRAPHICS.SIGNUP_JOINNOW_SELECTED_IMAGE(), for: UIControlState.selected)
        btnSubmit.setTitle(buttonTitle, for: UIControlState())
        // btnSubmit.titleLabel!.font = GRAPHICS.FONT_BOLD(14)
        btnSubmit.addTarget(delegate, action: Selector(("distanceAlertOK")), for: UIControlEvents.touchUpInside)
        alertView.addSubview(btnSubmit)
        
        btnSubmit.isHidden = !hideClose
        
        if hideClose == false
        {
            var alertFrame = alertView.frame
            alertFrame.size.height = lbl_Message.frame.maxY + 25
            alertView.frame = alertFrame
        }
        else
        {
            var alertFrame = alertView.frame
            alertFrame.size.height = btnSubmit.frame.maxY
            alertView.frame = alertFrame
        }
        var alertFrame = alertView.frame
        alertFrame.origin.y = (frame.size.height - 64 - alertFrame.size.height) / 2
        alertView.frame = alertFrame
        
        
        CloseBtn_View.frame =  CGRect(x: alertView.frame.maxX-22,y: alertView.frame.minY-25 ,width: 50,height: 50)
        
        //         closeBtn.frame  =  CGRectMake(10, 10,CGRectGetWidth(CloseBtn_View.frame)-20,CGRectGetHeight(CloseBtn_View.frame)-20)
        
        let tapGestureForClose = UITapGestureRecognizer(target: delegate, action: Selector(("infoAlertClose")))
        closeBtn.addGestureRecognizer(tapGestureForClose)
        
        return alertView_Bg
    }
    
    @objc class func requesterFilterDetailsAlert(_ delegate: UITextFieldDelegate, frame : CGRect,title : NSString ,okButtonTitle : NSString,tag : Int) -> AnyObject
    {
        let Height:CGFloat = (33.11 * frame.height/120)
        let width :CGFloat = frame.size.width-40
        let posX :CGFloat = (frame.size.width - width ) / 2
        
        //alert view background
        let alertView_Bg: UIView = UIView (frame: CGRect(x: 0,y: 0 ,width: frame.size.width,height: frame.size.height))
        alertView_Bg.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        
        let alertView: UIView = UIView (frame: CGRect(x: posX,y: (alertView_Bg.frame.height-Height)/2 ,width: width,height: Height-20))
        alertView.backgroundColor = UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        alertView.layer.cornerRadius = 10.0
        alertView_Bg.addSubview(alertView)
        
        //close button on top view
        let closeView : UIButton = UIButton (frame: CGRect(x: alertView.frame.size.width-40,y: 8,width: 30,height: 30))
        closeView.backgroundColor = UIColor.clear//UIColorFromRGB(headerBlueCOlor, alpha: 1)
        closeView.setImage(UIImage(named: "CropDetailsDeleteImg"), for: UIControlState())
        closeView.setTitle("", for: UIControlState())
        closeView.addTarget(delegate, action: Selector(("alertCloseBtn")), for: UIControlEvents.touchUpInside)
        alertView.addSubview(closeView)
        
        let lblTitle : UILabel = UILabel (frame: CGRect(x: 10,y: alertView.frame.height-130,width: width-20,height: 20))
        lblTitle.text = title as String
        lblTitle.textColor = UIColor.darkGray//UIColor(red: 56/255, green: 85/255, blue: 128/255, alpha: 1.0)
        lblTitle.textAlignment = NSTextAlignment.center
        alertView.addSubview(lblTitle)
        
        //textField
        let mobileNoTxtFld : UITextField = UITextField (frame: CGRect(x: 30,y: alertView.frame.height-100,width: width-60,height: 40))
        mobileNoTxtFld.backgroundColor = UIColor.white
        mobileNoTxtFld.layer.cornerRadius = 5.0
        // mobileNoTxtFld.borderWidth = 1.0
        // mobileNoTxtFld.borderColor = UIColor.gray
        mobileNoTxtFld.keyboardType = .numberPad
        //mobileNoTxtFld.placeholder = "Enter OTP"
        mobileNoTxtFld.textAlignment = NSTextAlignment.center
        mobileNoTxtFld.delegate =  delegate
        mobileNoTxtFld.tag = tag
        alertView.addSubview(mobileNoTxtFld)
        
        //submit button
        let btnSubmit : UIButton = UIButton (frame: CGRect(x: 0, y: mobileNoTxtFld.frame.maxY+20,width: width,height: 40))
        btnSubmit.backgroundColor = App_Theme_Blue_Color//UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 0.8)
        btnSubmit.layer.cornerRadius = 5.0
        btnSubmit.setTitle(okButtonTitle as String, for: UIControlState())
        btnSubmit.addTarget(delegate, action: Selector(("alertSubmitBtn")), for: UIControlEvents.touchUpInside)
        
        alertView.addSubview(btnSubmit)
        
        return alertView_Bg
    }
    
    class func alertOTP(_ delegate: UITextFieldDelegate, frame : CGRect, okButtonTitle : NSString) -> AnyObject
    {
        let Height:CGFloat = (33.11 * frame.height/120)
        let width :CGFloat = frame.size.width-40
        let posX :CGFloat = (frame.size.width - width ) / 2
        
        //alert view background
        let alertView_Bg: UIView = UIView (frame: CGRect(x: 0,y: 0 ,width: frame.size.width,height: frame.size.height))
        alertView_Bg.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
     
        let alertView: UIView = UIView (frame: CGRect(x: posX,y: (alertView_Bg.frame.height-Height)/2 ,width: width,height: Height-20))
        alertView.backgroundColor = UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        alertView.layer.cornerRadius = 10.0
        alertView_Bg.addSubview(alertView)
        
        //close button on top view
        let closeView : UIButton = UIButton (frame: CGRect(x: alertView.frame.size.width-40,y: 8,width: 30,height: 30))
        closeView.backgroundColor = UIColor.clear//UIColorFromRGB(headerBlueCOlor, alpha: 1)
        closeView.setImage(UIImage(named: "CropDetailsDeleteImg"), for: UIControlState())
        closeView.setTitle("", for: UIControlState())
        closeView.addTarget(delegate, action: Selector(("alertOTPCloseBtn")), for: UIControlEvents.touchUpInside)
        alertView.addSubview(closeView)
        
        //textField
        let mobileNoTxtFld : UITextField = UITextField (frame: CGRect(x: 30,y: alertView.frame.height-100,width: width-60,height: 40))
        mobileNoTxtFld.backgroundColor = UIColor.white
        mobileNoTxtFld.layer.cornerRadius = 5.0
        mobileNoTxtFld.borderWidth = 1.0
        mobileNoTxtFld.borderColor = UIColor.gray
        mobileNoTxtFld.keyboardType = .numberPad
        mobileNoTxtFld.placeholder = "Enter OTP"
        mobileNoTxtFld.textAlignment = NSTextAlignment.center
        mobileNoTxtFld.delegate =  delegate
        mobileNoTxtFld.tag = 33333
        alertView.addSubview(mobileNoTxtFld)
        
        //submit button
        let btnSubmit : UIButton = UIButton (frame: CGRect(x: 0, y: mobileNoTxtFld.frame.maxY+20,width: width,height: 40))
        btnSubmit.backgroundColor = App_Theme_Blue_Color//UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 0.8)
        btnSubmit.layer.cornerRadius = 5.0
        btnSubmit.setTitle(okButtonTitle as String, for: UIControlState())
        btnSubmit.addTarget(delegate, action: Selector(("alertOTPSubmit")), for: UIControlEvents.touchUpInside)
        
        alertView.addSubview(btnSubmit)
        
        return alertView_Bg
    }
    
    class func alertInfoPopUpView(_ delegate: AnyObject, frame : CGRect , title : NSString, message : NSString, buttonTitle : String , hideClose : Bool) -> AnyObject
    {
        var Height:CGFloat = (33.11 * frame.height/120)
        var width :CGFloat = frame.size.width-40
        var posX :CGFloat = (frame.size.width - width ) / 2
        var lablHeightPadding :CGFloat = 27
        // unowned(unsafe) var delegate: UITextFieldDelegate?
        
        if hideClose == false
        {
            Height = (33.11 * frame.height/150)
            width = frame.size.width-70
            posX  = (frame.size.width - width ) / 2
            lablHeightPadding = CGFloat(40)
        }
        
        let alertView_Bg: UIView = UIView (frame: CGRect(x: 0,y: 0 ,width: frame.size.width,height: frame.size.height))
        
        alertView_Bg.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        
        let alertView: UIView = UIView (frame: CGRect(x: posX,y: (alertView_Bg.frame.height-Height)/2 ,width: width,height: Height))
        alertView.backgroundColor = UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        alertView.layer.cornerRadius = 10.0
        alertView_Bg.addSubview(alertView)
        
        let CloseBtn_View: UIView;
        
//        if GRAPHICS.Screen_Height() == 480.0
//        {
//            CloseBtn_View = UIView (frame: CGRect(x: alertView.frame.maxX-20,y: alertView.frame.minY - 1 ,width: 50,height: 50))
//        }
//            
//        else
//        {
        
            CloseBtn_View = UIView (frame: CGRect(x: alertView.frame.maxX-42,y: alertView.frame.minY-50 ,width: 50,height: 50))
      //  }
        
        CloseBtn_View.backgroundColor = UIColor.clear
        
         alertView_Bg.addSubview(CloseBtn_View)
        
        let lblHeading : UILabel = UILabel (frame: CGRect(x: 0,y: 10,width: alertView.frame.width,height: ((15 * alertView.frame.height)/100)))
        lblHeading.text = title as String
        lblHeading.textColor = App_Theme_Blue_Color//UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 1.0)
        lblHeading.font = UIFont.boldSystemFont(ofSize: 16.0)
        lblHeading.numberOfLines = 0
        lblHeading.textAlignment = NSTextAlignment.center
        alertView.addSubview(lblHeading)
        
        let closeBtn : UIButton = UIButton (frame: CGRect(x: lblHeading.frame.maxX - 30, y: 0,width: 35,height: 35))
        closeBtn.backgroundColor = UIColor.clear//UIColorFromRGB(headerBlueCOlor, alpha: 1)
        
        closeBtn.setImage(UIImage(named: "CropDetailsDeleteImg"), for: UIControlState())
        closeBtn.setTitle("", for: UIControlState())
        closeBtn.layer.cornerRadius = closeBtn.frame.width/2
       // closeBtn.titleLabel!.font = GRAPHICS.FONT_REGULAR(16)
        closeBtn.addTarget(delegate, action: Selector(("infoAlertClose")), for: UIControlEvents.touchUpInside)
        alertView.addSubview(closeBtn)
        CloseBtn_View.isHidden = hideClose
        closeBtn.isHidden = hideClose
        
        let lbl_Message : UILabel = UILabel (frame: CGRect(x: 5,y: lblHeading.frame.maxY+((15 * alertView.frame.height)/100) - 8,width: alertView.frame.width - 10,height: ((lablHeightPadding * alertView.frame.height)/100)))
        lbl_Message.text = message as String
        lbl_Message.textColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        //lbl_Message.font = GRAPHICS.FONT_REGULAR(15)
        lbl_Message.numberOfLines = 0
        lbl_Message.sizeToFit()
        
        var ViewFrame = lbl_Message.frame
        ViewFrame.origin.x = (alertView.frame.width - lbl_Message.frame.width) / 2
        lbl_Message.frame = ViewFrame
        lbl_Message.textAlignment = NSTextAlignment.center
        alertView.addSubview(lbl_Message)
        
        let btnSubmit : UIButton = UIButton (frame: CGRect(x: 0, y: lbl_Message.frame.maxY+((22.5 * alertView.frame.height)/100),width: alertView.frame.size.width,height: 40))
        btnSubmit.backgroundColor =  App_Theme_Blue_Color//UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 1.0)
        //btnSubmit.setBackgroundImage(GRAPHICS.SIGNUP_JOINNOW_NORMAL_IMAGE(), for: UIControlState())
       // btnSubmit.setBackgroundImage(GRAPHICS.SIGNUP_JOINNOW_SELECTED_IMAGE(), for: UIControlState.selected)
        btnSubmit.setTitle(buttonTitle, for: UIControlState())
       // btnSubmit.titleLabel!.font = GRAPHICS.FONT_BOLD(14)
        btnSubmit.addTarget(delegate, action: Selector(("infoAlertSubmit")), for: UIControlEvents.touchUpInside)
        alertView.addSubview(btnSubmit)
        
        btnSubmit.isHidden = !hideClose
        
        if hideClose == false
        {
            var alertFrame = alertView.frame
            alertFrame.size.height = lbl_Message.frame.maxY + 25
            alertView.frame = alertFrame
        }
        else
        {
            var alertFrame = alertView.frame
            alertFrame.size.height = btnSubmit.frame.maxY
            alertView.frame = alertFrame
        }
        var alertFrame = alertView.frame
        alertFrame.origin.y = (frame.size.height - 64 - alertFrame.size.height) / 2
        alertView.frame = alertFrame
        
        
        CloseBtn_View.frame =  CGRect(x: alertView.frame.maxX-22,y: alertView.frame.minY-25 ,width: 50,height: 50)

        //         closeBtn.frame  =  CGRectMake(10, 10,CGRectGetWidth(CloseBtn_View.frame)-20,CGRectGetHeight(CloseBtn_View.frame)-20)
        
        let tapGestureForClose = UITapGestureRecognizer(target: delegate, action: Selector(("infoAlertClose")))
        closeBtn.addGestureRecognizer(tapGestureForClose)
        
        return alertView_Bg
    }
    
    class func enterCouponCodeAlertView(_ delegate: UITextFieldDelegate, frame : CGRect,title:NSString ,okTitle : NSString,cancelTitle: NSString,isFirstOk:Bool,okBgColor:UIColor?,cancelBgColor:UIColor?,placeholder:NSString) -> AnyObject
    {
        let Height:CGFloat = (33.11 * frame.height/120)
        let width :CGFloat = frame.size.width-40
        let posX :CGFloat = (frame.size.width - width ) / 2
        
        //alert view background
        let alertView_Bg: UIView = UIView (frame: CGRect(x: 0,y: 0 ,width: frame.size.width,height: frame.size.height))
        alertView_Bg.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        
        let alertView: UIView = UIView (frame: CGRect(x: posX,y: (alertView_Bg.frame.height-Height)/2 ,width: width,height: Height-20))
        alertView.backgroundColor = UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        alertView.layer.cornerRadius = 10.0
        alertView_Bg.addSubview(alertView)
        
        //close button on top view
        let lblAlertTitle = UILabel()
        if Validations.isNullString(title) == false {
            lblAlertTitle.frame = CGRect(x: 5, y: 10, width: width - 10, height: 50)
            lblAlertTitle.text = title as String
            lblAlertTitle.textAlignment = .center
            lblAlertTitle.font = UIFont.boldSystemFont(ofSize: 16.0)
            //lblAlertTitle.sizeToFit()
            alertView.addSubview(lblAlertTitle)
        }
        
        //textField
        let inputTxtFld : UITextField = UITextField (frame: CGRect(x: 30,y: lblAlertTitle.frame.maxY + 10,width: width-60,height: 40))
        inputTxtFld.backgroundColor = UIColor.white
        inputTxtFld.layer.cornerRadius = 5.0
        inputTxtFld.borderWidth = 1.0
        inputTxtFld.borderColor = UIColor.gray
        //inputTxtFld.keyboardType = .default
        inputTxtFld.placeholder = placeholder as String
        inputTxtFld.textAlignment = NSTextAlignment.center
        inputTxtFld.delegate =  delegate
        inputTxtFld.tag = 44444
        alertView.addSubview(inputTxtFld)
        
        //Cancel button
        let cancelButton : UIButton = UIButton (frame: CGRect(x:isFirstOk ? alertView.frame.size.width/2 : 0,y:inputTxtFld.frame.maxY+30,width: alertView.frame.size.width/2,height: 40))
        cancelButton.backgroundColor = UIColor(red: 245.0/255, green: 130.0/255, blue: 33.0/255, alpha: 1.0)
        if cancelBgColor != nil {
            cancelButton.backgroundColor = cancelBgColor
        }
        //cancelButton.setImage(UIImage(named: "CropDetailsDeleteImg"), for: UIControlState())
        cancelButton.setTitle(cancelTitle as String, for: UIControlState())
        cancelButton.addTarget(delegate, action: Selector(("alertCancelButtonAction")), for: UIControlEvents.touchUpInside)
        alertView.addSubview(cancelButton)
        
        //submit button
        let btnSubmit : UIButton = UIButton (frame: CGRect(x: isFirstOk ? 0 : alertView.frame.size.width/2, y: inputTxtFld.frame.maxY+30,width: alertView.frame.size.width/2,height: 40))
        btnSubmit.backgroundColor = App_Theme_Blue_Color//UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 1.0)
        if okBgColor != nil {
            btnSubmit.backgroundColor = okBgColor
        }
        //btnSubmit.layer.cornerRadius = 5.0
        btnSubmit.setTitle(okTitle as String, for: UIControlState())
        btnSubmit.addTarget(delegate, action: Selector(("alertOkButtonAction")), for: UIControlEvents.touchUpInside)
        var alertVierFrame = alertView.frame
        alertVierFrame.size.height = btnSubmit.frame.maxY
        alertView.frame = alertVierFrame
        alertView.addSubview(btnSubmit)
        
        return alertView_Bg
    }
    class func alertNewPopView(_ delegate: AnyObject, frame : CGRect , title : NSString, message : NSString, okButtonTitle : String , cancelButtonTitle : String) -> AnyObject
    {
        let Height:CGFloat = (33.11 * frame.height/120)
        let width :CGFloat = frame.size.width-40
        let posX :CGFloat = (frame.size.width - width ) / 2
        let lablHeightPadding :CGFloat = 27
        
        //alert view background
        let alertView_Bg: UIView = UIView (frame: CGRect(x: 0,y: 0 ,width: frame.size.width,height: frame.size.height))
        alertView_Bg.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        
        //alert view
        let alertView: UIView = UIView (frame: CGRect(x: posX,y: (alertView_Bg.frame.height-Height)/2 ,width: width,height: Height))
        alertView.backgroundColor = UIColor.white //UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        alertView.layer.cornerRadius = 10.0
        alertView_Bg.addSubview(alertView)
        
        //alert Title
        let alertTitleLbl : UILabel = UILabel (frame: CGRect(x: 0,y: 15,width: alertView.frame.width,height: ((15 * alertView.frame.height)/100)))
        alertTitleLbl.text = title as String
        alertTitleLbl.textColor = App_Theme_Blue_Color//UIColor(red: 0.0/255, green: 128.0/255, blue: 43.0/255, alpha: 1)
        //UIColor(red: 0.0/255, green: 149.0/255, blue: 159.0/255, alpha: 1)
        alertTitleLbl.font = UIFont (name: "Lato-Bold", size:15)
        alertTitleLbl.textAlignment = NSTextAlignment.center
        alertView.addSubview(alertTitleLbl)
        
        //alert message
        let alertMessageLbl : UILabel = UILabel (frame: CGRect(x: 5,y: alertTitleLbl.frame.maxY+((15 * alertView.frame.height)/100) - 8,width: alertView.frame.width - 10,height: ((lablHeightPadding * alertView.frame.height)/100)))
        alertMessageLbl.text = message as String
        alertMessageLbl.textColor = UIColor.black//UIColor(red: 0.0/255, green: 128.0/255, blue: 43.0/255, alpha: 1)
        //UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        alertMessageLbl.font = UIFont (name: "Lato-Bold", size:11)
        alertMessageLbl.numberOfLines = 0
        alertMessageLbl.sizeToFit()
        
        var ViewFrame = alertMessageLbl.frame
        ViewFrame.origin.x = (alertView.frame.width - alertMessageLbl.frame.width) / 2
        alertMessageLbl.frame = ViewFrame
        alertMessageLbl.textAlignment = NSTextAlignment.center
        alertView.addSubview(alertMessageLbl)
        
        //let noBtn : UIButton?
        
        if cancelButtonTitle.count>0 {
            
            //NO button
            let noBtn : UIButton  = UIButton (frame: CGRect(x:0 , y: alertMessageLbl.frame.maxY+((20.5 * alertView.frame.height)/100),width: width/2,height: 35))
            noBtn.backgroundColor = App_Theme_Orange_Color//UIColor(red: 255.0/255, green: 179.0/255, blue: 102.0/255, alpha: 0.8)
            noBtn.layer.cornerRadius = 1.0
            //rgb(255, 179, 102)
            noBtn.setTitle(cancelButtonTitle, for: UIControlState())
            noBtn.addTarget(delegate, action: Selector(("popUpNoBtnAction")), for: UIControlEvents.touchUpInside)
            alertView.addSubview(noBtn)
            
            //YES button
            let yesBtn : UIButton = UIButton (frame: CGRect(x: noBtn.frame.size.width+0.1, y: alertMessageLbl.frame.maxY+((20.5 * alertView.frame.height)/100), width: width/2,height: 35))
            yesBtn.backgroundColor = App_Theme_Blue_Color
            //UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 0.8)
            
            yesBtn.layer.cornerRadius = 1.0
            yesBtn.setTitle(okButtonTitle, for: UIControlState())
            yesBtn.addTarget(delegate, action: Selector(("popUpYesBtnAction")), for: UIControlEvents.touchUpInside)
            alertView.addSubview(yesBtn)
            
            var alertFrame = alertView.frame
            alertFrame.size.height = yesBtn.frame.maxY
            alertFrame.size.height = (noBtn.frame.maxY)
            alertView.frame = alertFrame
            
            alertFrame.origin.y = (frame.size.height - 64 - alertFrame.size.height) / 2
            alertView.frame = alertFrame
        }
        else{
            
            //YES button
            let yesBtn : UIButton = UIButton (frame: CGRect(x: 0, y: alertMessageLbl.frame.maxY+((20.5 * alertView.frame.height)/100), width: width,height: 35))
            yesBtn.backgroundColor = App_Theme_Blue_Color
            //rgb(0, 179, 60)
            yesBtn.layer.cornerRadius = 1.0
            yesBtn.setTitle(okButtonTitle, for: UIControlState())
            yesBtn.addTarget(delegate, action: Selector(("alertYesBtnAction")), for: UIControlEvents.touchUpInside)
            alertView.addSubview(yesBtn)
            
            var alertFrame = alertView.frame
            alertFrame.size.height = yesBtn.frame.maxY
            //alertFrame.size.height = (noBtn?.frame.maxY)!
            alertView.frame = alertFrame
            
            alertFrame.origin.y = (frame.size.height - 64 - alertFrame.size.height) / 2
            alertView.frame = alertFrame
            
        }
        return alertView_Bg
    }
    
    class func loginAlertViewNewDesign(_ delegate: AnyObject, image : UIImage, frame : CGRect , title : NSString, message : NSString, okButtonTitle : String , cancelButtonTitle : String) -> AnyObject
    {
        let Height:CGFloat = (33.11 * frame.height/120)
        let width :CGFloat = frame.size.width-40
        let posX :CGFloat = (frame.size.width - width ) / 2
        let lablHeightPadding :CGFloat = 27

        let alertView_Bg: UIView = UIView (frame: CGRect(x: 0,y: 0 ,width: frame.size.width,height: frame.size.height))
        alertView_Bg.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)

        let alertView: UIView = UIView (frame: CGRect(x: posX,y: (alertView_Bg.frame.height-Height)/2 ,width: width,height: Height))
        alertView.backgroundColor = UIColor.white //UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        alertView.layer.cornerRadius = 10.0
        alertView_Bg.addSubview(alertView)
      
        let imgCaution = UIImageView(frame: CGRect(x: alertView.frame.size.width/2 - 45, y: 12, width: 20, height: 20))
        imgCaution.image = image
        imgCaution.contentMode = .scaleAspectFit
        alertView.addSubview(imgCaution)

        let alertTitleLbl : UILabel = UILabel (frame: CGRect(x: alertView.frame.size.width/2 - 45,y: 10,width: 120,height: 25))
        alertTitleLbl.text = title as String
        alertTitleLbl.textColor = App_Theme_Blue_Color//UIColor(red: 0.0/255, green: 128.0/255, blue: 43.0/255, alpha: 1)
        //UIColor(red: 0.0/255, green: 149.0/255, blue: 159.0/255, alpha: 1)
        alertTitleLbl.font = UIFont (name: "Lato-Bold", size:15)
        alertTitleLbl.textAlignment = NSTextAlignment.center
        alertView.addSubview(alertTitleLbl)
        
        //alert message
        let alertMessageLbl : UILabel = UILabel (frame: CGRect(x: 5,y: alertTitleLbl.frame.maxY+((15 * alertView.frame.height)/100) - 8,width: alertView.frame.width - 10,height: ((lablHeightPadding * alertView.frame.height)/100)))
        alertMessageLbl.text = message as String
        alertMessageLbl.textColor = UIColor.black//UIColor(red: 0.0/255, green: 128.0/255, blue: 43.0/255, alpha: 1)
        //UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        alertMessageLbl.font = UIFont (name: "Lato-Bold", size:11)
        alertMessageLbl.numberOfLines = 0
        alertMessageLbl.sizeToFit()
        
        var ViewFrame = alertMessageLbl.frame
        ViewFrame.origin.x = (alertView.frame.width - alertMessageLbl.frame.width) / 2
        alertMessageLbl.frame = ViewFrame
        alertMessageLbl.textAlignment = NSTextAlignment.center
        alertView.addSubview(alertMessageLbl)
        
        //let noBtn : UIButton?
        
        if cancelButtonTitle.count>0 {
            
            //NO button
             let noBtn : UIButton  = UIButton (frame: CGRect(x:0 , y: alertMessageLbl.frame.maxY+((20.5 * alertView.frame.height)/100),width: width/2,height: 35))
            noBtn.backgroundColor = App_Theme_Orange_Color//UIColor(red: 255.0/255, green: 179.0/255, blue: 102.0/255, alpha: 0.8)
            noBtn.layer.cornerRadius = 1.0
            //rgb(255, 179, 102)
            noBtn.setTitle(cancelButtonTitle, for: UIControlState())
            noBtn.addTarget(delegate, action: Selector(("callNoBtn")), for: UIControlEvents.touchUpInside)
            alertView.addSubview(noBtn)
            
            //YES button
            let yesBtn : UIButton = UIButton (frame: CGRect(x: noBtn.frame.size.width+0.1, y: alertMessageLbl.frame.maxY+((20.5 * alertView.frame.height)/100), width: width/2,height: 35))
            yesBtn.backgroundColor = App_Theme_Blue_Color
                //UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 0.8)

            yesBtn.layer.cornerRadius = 1.0
            yesBtn.setTitle(okButtonTitle, for: UIControlState())
            yesBtn.addTarget(delegate, action: Selector(("callYesBtn")), for: UIControlEvents.touchUpInside)
            alertView.addSubview(yesBtn)
            
            var alertFrame = alertView.frame
            alertFrame.size.height = yesBtn.frame.maxY
            alertFrame.size.height = (noBtn.frame.maxY)
            alertView.frame = alertFrame
            
            alertFrame.origin.y = (frame.size.height - 64 - alertFrame.size.height) / 2
            alertView.frame = alertFrame
        }
        else{
            
            //YES button
            let yesBtn : UIButton = UIButton (frame: CGRect(x: 0, y: alertMessageLbl.frame.maxY+((20.5 * alertView.frame.height)/100), width: width,height: 35))
            yesBtn.backgroundColor = App_Theme_Blue_Color
            //rgb(0, 179, 60)
            yesBtn.layer.cornerRadius = 1.0
            yesBtn.setTitle(okButtonTitle, for: UIControlState())
            yesBtn.addTarget(delegate, action: Selector(("callYesBtn")), for: UIControlEvents.touchUpInside)
            alertView.addSubview(yesBtn)
            
            var alertFrame = alertView.frame
            alertFrame.size.height = yesBtn.frame.maxY
            //alertFrame.size.height = (noBtn?.frame.maxY)!
            alertView.frame = alertFrame
            
            alertFrame.origin.y = (frame.size.height - 64 - alertFrame.size.height) / 2
            alertView.frame = alertFrame

        }
        return alertView_Bg
    }
    
    class func alertPopUpViewForMissedCallVerification(_ delegate: AnyObject, frame : CGRect , title : NSString, message : NSString, okButtonTitle : String , cancelButtonTitle : String) -> AnyObject
    {
        let Height:CGFloat = (33.11 * frame.height/120)
        let width :CGFloat = frame.size.width-40
        let posX :CGFloat = (frame.size.width - width ) / 2
        let lablHeightPadding :CGFloat = 27

        //alert view background
        let alertView_Bg: UIView = UIView (frame: CGRect(x: 0,y: 0 ,width: frame.size.width,height: frame.size.height))
        alertView_Bg.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)

        //alert view
        let alertView: UIView = UIView (frame: CGRect(x: posX,y: (alertView_Bg.frame.height-Height)/2 ,width: width,height: Height))
        alertView.backgroundColor = UIColor.white //UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        alertView.layer.cornerRadius = 10.0
        alertView_Bg.addSubview(alertView)
        
        //alert Title
        let alertTitleLbl : UILabel = UILabel (frame: CGRect(x: 0,y: 15,width: alertView.frame.width,height: ((15 * alertView.frame.height)/100)))
        alertTitleLbl.text = title as String
        alertTitleLbl.textColor = App_Theme_Blue_Color//UIColor(red: 0.0/255, green: 128.0/255, blue: 43.0/255, alpha: 1)
        //UIColor(red: 0.0/255, green: 149.0/255, blue: 159.0/255, alpha: 1)
        alertTitleLbl.font = UIFont (name: "Lato-Bold", size:15)
        alertTitleLbl.textAlignment = NSTextAlignment.center
        alertView.addSubview(alertTitleLbl)
        
        //alert message
        let alertMessageLbl : UILabel = UILabel (frame: CGRect(x: 5,y: alertTitleLbl.frame.maxY+((15 * alertView.frame.height)/100) - 8,width: alertView.frame.width - 10,height: ((lablHeightPadding * alertView.frame.height)/100)))
        alertMessageLbl.text = message as String
        alertMessageLbl.textColor = UIColor.black//UIColor(red: 0.0/255, green: 128.0/255, blue: 43.0/255, alpha: 1)
        //UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        alertMessageLbl.font = UIFont (name: "Lato-Bold", size:11)
        alertMessageLbl.numberOfLines = 0
        alertMessageLbl.sizeToFit()
        
        var ViewFrame = alertMessageLbl.frame
        ViewFrame.origin.x = (alertView.frame.width - alertMessageLbl.frame.width) / 2
        alertMessageLbl.frame = ViewFrame
        alertMessageLbl.textAlignment = NSTextAlignment.center
        alertView.addSubview(alertMessageLbl)
        
        //let noBtn : UIButton?
        
        if cancelButtonTitle.count>0 {
            
            //NO button
             let noBtn : UIButton  = UIButton (frame: CGRect(x:0 , y: alertMessageLbl.frame.maxY+((20.5 * alertView.frame.height)/100),width: width/2,height: 35))
            noBtn.backgroundColor = App_Theme_Orange_Color//UIColor(red: 255.0/255, green: 179.0/255, blue: 102.0/255, alpha: 0.8)
            noBtn.layer.cornerRadius = 1.0
            //rgb(255, 179, 102)
            noBtn.setTitle(cancelButtonTitle, for: UIControlState())
            noBtn.addTarget(delegate, action: Selector(("alertNoBtnActionMissedCall")), for: UIControlEvents.touchUpInside)
            alertView.addSubview(noBtn)
            
            //YES button
            let yesBtn : UIButton = UIButton (frame: CGRect(x: noBtn.frame.size.width+0.1, y: alertMessageLbl.frame.maxY+((20.5 * alertView.frame.height)/100), width: width/2,height: 35))
            yesBtn.backgroundColor = App_Theme_Blue_Color
                //UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 0.8)

            yesBtn.layer.cornerRadius = 1.0
            yesBtn.setTitle(okButtonTitle, for: UIControlState())
            yesBtn.addTarget(delegate, action: Selector(("alertYesBtnActionMissedCall")), for: UIControlEvents.touchUpInside)
            alertView.addSubview(yesBtn)
            
            var alertFrame = alertView.frame
            alertFrame.size.height = yesBtn.frame.maxY
            alertFrame.size.height = (noBtn.frame.maxY)
            alertView.frame = alertFrame
            
            alertFrame.origin.y = (frame.size.height - 64 - alertFrame.size.height) / 2
            alertView.frame = alertFrame
        }
        else{
            
            //YES button
            let yesBtn : UIButton = UIButton (frame: CGRect(x: 0, y: alertMessageLbl.frame.maxY+((20.5 * alertView.frame.height)/100), width: width,height: 35))
            yesBtn.backgroundColor = App_Theme_Blue_Color
            //rgb(0, 179, 60)
            yesBtn.layer.cornerRadius = 1.0
            yesBtn.setTitle(okButtonTitle, for: UIControlState())
            yesBtn.addTarget(delegate, action: Selector(("alertYesBtnAction")), for: UIControlEvents.touchUpInside)
            alertView.addSubview(yesBtn)
            
            var alertFrame = alertView.frame
            alertFrame.size.height = yesBtn.frame.maxY
            //alertFrame.size.height = (noBtn?.frame.maxY)!
            alertView.frame = alertFrame
            
            alertFrame.origin.y = (frame.size.height - 64 - alertFrame.size.height) / 2
            alertView.frame = alertFrame

        }
        return alertView_Bg
    }
    
    class func alertPopUpViewMissedCallVerify(_ delegate: AnyObject, frame : CGRect , message : NSString, okButtonTitle : String ) -> AnyObject
    {
        let Height:CGFloat = (33.11 * frame.height/120)
        let width :CGFloat = frame.size.width-40
        let posX :CGFloat = (frame.size.width - width ) / 2
        let lablHeightPadding :CGFloat = 27

        //alert view background
        let alertView_Bg: UIView = UIView (frame: CGRect(x: 0,y: 0 ,width: frame.size.width,height: frame.size.height))
        alertView_Bg.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)

        //alert view
        let alertView: UIView = UIView (frame: CGRect(x: posX,y: (alertView_Bg.frame.height-Height)/2 ,width: width,height: Height))
        alertView.backgroundColor = UIColor.white //UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        alertView.layer.cornerRadius = 10.0
        alertView_Bg.addSubview(alertView)
        
        let btnCancel = UIButton(frame: CGRect(x: alertView.frame.size.width - 10, y: alertView.frame.minY-20, width: 30, height: 30))
        btnCancel.setImage(UIImage(named: "ca_wrong"), for: .normal)
        btnCancel.addTarget(delegate, action: Selector(("alertNoBtnActionMissedCall")), for: UIControlEvents.touchUpInside)
        alertView_Bg.addSubview(btnCancel)

        //alert message
        let alertMessageLbl : UILabel = UILabel (frame: CGRect(x: 5,y: 35 - 8,width: alertView.frame.width - 10,height: ((lablHeightPadding * alertView.frame.height)/100)))
        alertMessageLbl.text = message as String
        alertMessageLbl.textColor = UIColor.black//UIColor(red: 0.0/255, green: 128.0/255, blue: 43.0/255, alpha: 1)
        //UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        alertMessageLbl.font = UIFont (name: "Lato-Bold", size:11)
        alertMessageLbl.numberOfLines = 0
        alertMessageLbl.sizeToFit()
        
        var ViewFrame = alertMessageLbl.frame
        ViewFrame.origin.x = (alertView.frame.width - alertMessageLbl.frame.width) / 2
        alertMessageLbl.frame = ViewFrame
        alertMessageLbl.textAlignment = NSTextAlignment.center
        alertView.addSubview(alertMessageLbl)
        
        
                        
            //YES button
        let yesBtn : UIButton = UIButton(frame: CGRect(x: alertView.frame.size.width/2 - 60, y: alertMessageLbl.frame.maxY+((20.5 * alertView.frame.height)/100), width: 120,height: 40))
            yesBtn.backgroundColor = App_Theme_Blue_Color
                //UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 0.8)

            yesBtn.layer.cornerRadius = 1.0
            yesBtn.setTitle(okButtonTitle, for: UIControlState())
            yesBtn.addTarget(delegate, action: Selector(("alertYesBtnActionMissedCallVerify")), for: UIControlEvents.touchUpInside)
            alertView.addSubview(yesBtn)
            
            var alertFrame = alertView.frame
            alertFrame.size.height = yesBtn.frame.maxY + 20
            alertView.frame = alertFrame
            
            alertFrame.origin.y = (frame.size.height - 64 - alertFrame.size.height) / 2
            alertView.frame = alertFrame
        
        return alertView_Bg
    }


    
    class func alertPopUpView(_ delegate: AnyObject, frame : CGRect , title : NSString, message : NSString, okButtonTitle : String , cancelButtonTitle : String) -> AnyObject
    {
        let Height:CGFloat = (33.11 * frame.height/120)
        let width :CGFloat = frame.size.width-40
        let posX :CGFloat = (frame.size.width - width ) / 2
        let lablHeightPadding :CGFloat = 27

        //alert view background
        let alertView_Bg: UIView = UIView (frame: CGRect(x: 0,y: 0 ,width: frame.size.width,height: frame.size.height))
        alertView_Bg.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)

        //alert view
        let alertView: UIView = UIView (frame: CGRect(x: posX,y: (alertView_Bg.frame.height-Height)/2 ,width: width,height: Height))
        alertView.backgroundColor = UIColor.white //UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        alertView.layer.cornerRadius = 10.0
        alertView_Bg.addSubview(alertView)
        
        //alert Title
        let alertTitleLbl : UILabel = UILabel (frame: CGRect(x: 0,y: 15,width: alertView.frame.width,height: ((15 * alertView.frame.height)/100)))
        alertTitleLbl.text = title as String
        alertTitleLbl.textColor = App_Theme_Blue_Color//UIColor(red: 0.0/255, green: 128.0/255, blue: 43.0/255, alpha: 1)
        //UIColor(red: 0.0/255, green: 149.0/255, blue: 159.0/255, alpha: 1)
        alertTitleLbl.font = UIFont (name: "Lato-Bold", size:15)
        alertTitleLbl.textAlignment = NSTextAlignment.center
        alertView.addSubview(alertTitleLbl)
        
        //alert message
        let alertMessageLbl : UILabel = UILabel (frame: CGRect(x: 5,y: alertTitleLbl.frame.maxY+((15 * alertView.frame.height)/100) - 8,width: alertView.frame.width - 10,height: ((lablHeightPadding * alertView.frame.height)/100)))
        alertMessageLbl.text = message as String
        alertMessageLbl.textColor = UIColor.black//UIColor(red: 0.0/255, green: 128.0/255, blue: 43.0/255, alpha: 1)
        //UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        alertMessageLbl.font = UIFont (name: "Lato-Bold", size:11)
        alertMessageLbl.numberOfLines = 0
        alertMessageLbl.sizeToFit()
        
        var ViewFrame = alertMessageLbl.frame
        ViewFrame.origin.x = (alertView.frame.width - alertMessageLbl.frame.width) / 2
        alertMessageLbl.frame = ViewFrame
        alertMessageLbl.textAlignment = NSTextAlignment.center
        alertView.addSubview(alertMessageLbl)
        
        //let noBtn : UIButton?
        
        if cancelButtonTitle.count>0 {
            
            //NO button
             let noBtn : UIButton  = UIButton (frame: CGRect(x:0 , y: alertMessageLbl.frame.maxY+((20.5 * alertView.frame.height)/100),width: width/2,height: 35))
            noBtn.backgroundColor = App_Theme_Orange_Color//UIColor(red: 255.0/255, green: 179.0/255, blue: 102.0/255, alpha: 0.8)
            noBtn.layer.cornerRadius = 1.0
            //rgb(255, 179, 102)
            noBtn.setTitle(cancelButtonTitle, for: UIControlState())
            noBtn.addTarget(delegate, action: Selector(("alertNoBtnAction")), for: UIControlEvents.touchUpInside)
            alertView.addSubview(noBtn)
            
            //YES button
            let yesBtn : UIButton = UIButton (frame: CGRect(x: noBtn.frame.size.width+0.1, y: alertMessageLbl.frame.maxY+((20.5 * alertView.frame.height)/100), width: width/2,height: 35))
            yesBtn.backgroundColor = App_Theme_Blue_Color
                //UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 0.8)

            yesBtn.layer.cornerRadius = 1.0
            yesBtn.setTitle(okButtonTitle, for: UIControlState())
            yesBtn.addTarget(delegate, action: Selector(("alertYesBtnAction")), for: UIControlEvents.touchUpInside)
            alertView.addSubview(yesBtn)
            
            var alertFrame = alertView.frame
            alertFrame.size.height = yesBtn.frame.maxY
            alertFrame.size.height = (noBtn.frame.maxY)
            alertView.frame = alertFrame
            
            alertFrame.origin.y = (frame.size.height - 64 - alertFrame.size.height) / 2
            alertView.frame = alertFrame
        }
        else{
            
            //YES button
            let yesBtn : UIButton = UIButton (frame: CGRect(x: 0, y: alertMessageLbl.frame.maxY+((20.5 * alertView.frame.height)/100), width: width,height: 35))
            yesBtn.backgroundColor = App_Theme_Blue_Color
            //rgb(0, 179, 60)
            yesBtn.layer.cornerRadius = 1.0
            yesBtn.setTitle(okButtonTitle, for: UIControlState())
            yesBtn.addTarget(delegate, action: Selector(("alertYesBtnAction")), for: UIControlEvents.touchUpInside)
            alertView.addSubview(yesBtn)
            
            var alertFrame = alertView.frame
            alertFrame.size.height = yesBtn.frame.maxY
            //alertFrame.size.height = (noBtn?.frame.maxY)!
            alertView.frame = alertFrame
            
            alertFrame.origin.y = (frame.size.height - 64 - alertFrame.size.height) / 2
            alertView.frame = alertFrame

        }
        return alertView_Bg
    }
    
    class func alertFarmerAssistRegisterProductPopUpView(_ delegate: AnyObject, frame : CGRect , message : NSString, okButtonTitle : String) -> AnyObject
    {
        let Height:CGFloat = (33.11 * frame.height/120)
        let width :CGFloat = frame.size.width-40
        let posX :CGFloat = (frame.size.width - width ) / 2
        let lablHeightPadding :CGFloat = 27
        
        //alert view background
        let alertView_Bg: UIView = UIView (frame: CGRect(x: 0,y: 0 ,width: frame.size.width,height: frame.size.height))
        alertView_Bg.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        
        let alertView: UIView = UIView (frame: CGRect(x: posX,y: (alertView_Bg.frame.height-Height)/2 ,width: width,height: Height))
        alertView.backgroundColor = UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        alertView.layer.cornerRadius = 10.0
        alertView_Bg.addSubview(alertView)

        //alert message
        let alertMessageLbl : UILabel = UILabel (frame: CGRect(x: 5,y: 40+((15 * alertView.frame.height)/100),width: alertView.frame.width - 10,height: ((lablHeightPadding * alertView.frame.height)/100)))
        alertMessageLbl.text = message as String
        alertMessageLbl.textColor = UIColor.black//UIColor(red: 0.0/255, green: 128.0/255, blue: 43.0/255, alpha: 1)
        //UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        alertMessageLbl.font = UIFont (name: "Lato-Bold", size:11)
        alertMessageLbl.numberOfLines = 0
        alertMessageLbl.sizeToFit()
        
        var ViewFrame = alertMessageLbl.frame
        ViewFrame.origin.x = (alertView.frame.width - alertMessageLbl.frame.width) / 2
        alertMessageLbl.frame = ViewFrame
        alertMessageLbl.textAlignment = NSTextAlignment.center
        alertView.addSubview(alertMessageLbl)

        //submit button
        let btnSubmit : UIButton = UIButton (frame: CGRect(x: 0, y: alertView.frame.height - 30,width: width,height: 30))
        btnSubmit.backgroundColor = App_Theme_Blue_Color//UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 0.8)
        btnSubmit.layer.cornerRadius = 5.0
        btnSubmit.setTitle(okButtonTitle as String, for: UIControlState())
        btnSubmit.addTarget(delegate, action: Selector(("alertOK")), for: UIControlEvents.touchUpInside)
        
        alertView.addSubview(btnSubmit)

        return alertView_Bg
    }
    
    class func alertPravaktaFarmerInfoPopUpView(_ delegate: AnyObject, frame : CGRect , title : NSString, farmerMobileNumber : NSString,sharedDate : NSString, okButtonTitle : String) -> AnyObject
    {
        let Height:CGFloat = (33.11 * frame.height/250)
        let width :CGFloat = frame.size.width-40
        let posX :CGFloat = (frame.size.width - width ) / 2
        // let lablHeightPadding :CGFloat = 27
        
        //alert view background
        let alertView_Bg: UIView = UIView (frame: CGRect(x: 0,y: 0 ,width: frame.size.width,height: frame.size.height))
        alertView_Bg.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        
        //alert view
        let alertView: UIView = UIView (frame: CGRect(x: posX,y: (alertView_Bg.frame.height-Height)/2 ,width: width,height: Height))
        alertView.backgroundColor = UIColor.white //UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        alertView.layer.cornerRadius = 10.0
        alertView_Bg.addSubview(alertView)
        
        //alert Title
        let alertTitleLbl : UILabel = UILabel (frame: CGRect(x: 0,y: 15,width: alertView.frame.width,height: 30))
        alertTitleLbl.text = title as String
        alertTitleLbl.textColor = App_Theme_Blue_Color//UIColor(red: 0.0/255, green: 128.0/255, blue: 43.0/255, alpha: 1)
        //UIColor(red: 0.0/255, green: 149.0/255, blue: 159.0/255, alpha: 1)
        alertTitleLbl.font = UIFont (name: "Lato-Bold", size:20)
        alertTitleLbl.textAlignment = NSTextAlignment.center
        alertView.addSubview(alertTitleLbl)
        
        //farmer mobile number
        let farmerMobileNoTitleLbl : UILabel = UILabel (frame: CGRect(x: 10,y: alertTitleLbl.frame.maxY + 10
            ,width: alertView.frame.width/2+5,height: 30))
        farmerMobileNoTitleLbl.text = "Farmer Mobile No :"
        farmerMobileNoTitleLbl.font = UIFont (name: "Lato", size:10)
        farmerMobileNoTitleLbl.textAlignment = NSTextAlignment.left
        alertView.addSubview(farmerMobileNoTitleLbl)
        
        let farmerMobileNoLbl : UILabel = UILabel (frame: CGRect(x: farmerMobileNoTitleLbl.frame.width+20,y: alertTitleLbl.frame.maxY + 10
            ,width: alertView.frame.width/2,height: 30))
        farmerMobileNoLbl.text = farmerMobileNumber as String
        farmerMobileNoLbl.font = UIFont (name: "Lato-Bold", size:12)
        farmerMobileNoLbl.textAlignment = NSTextAlignment.left
        alertView.addSubview(farmerMobileNoLbl)
        
        //shared date
        let sharedDateTitleLbl : UILabel = UILabel (frame: CGRect(x: 10,y: farmerMobileNoTitleLbl.frame.maxY + 15
            ,width: alertView.frame.width/2+5,height: 30))
        sharedDateTitleLbl.text = "Shared Date          :"
        sharedDateTitleLbl.font = UIFont (name: "Lato", size:10)
        sharedDateTitleLbl.textAlignment = NSTextAlignment.left
        alertView.addSubview(sharedDateTitleLbl)
        
        let sharedDateLbl : UILabel = UILabel (frame: CGRect(x: sharedDateTitleLbl.frame.width+20,y: farmerMobileNoTitleLbl.frame.maxY + 15
            ,width: alertView.frame.width/2,height: 30))
        sharedDateLbl.text = sharedDate as String
        sharedDateLbl.font = UIFont (name: "Lato-Bold", size:12)
        sharedDateLbl.textAlignment = NSTextAlignment.left
        alertView.addSubview(sharedDateLbl)
        
        //YES button
        let yesBtn : UIButton = UIButton (frame: CGRect(x: 0, y: sharedDateTitleLbl.frame.maxY+((20.5 * alertView.frame.height)/100), width: width,height: 35))
        yesBtn.backgroundColor = App_Theme_Blue_Color
        //rgb(0, 179, 60)
        yesBtn.layer.cornerRadius = 1.0
        yesBtn.setTitle(okButtonTitle, for: UIControlState())
        yesBtn.addTarget(delegate, action: Selector(("alertOKBtnAction")), for: UIControlEvents.touchUpInside)
        alertView.addSubview(yesBtn)
        
        var alertFrame = alertView.frame
        alertFrame.size.height = yesBtn.frame.maxY
        alertView.frame = alertFrame
        
        alertFrame.origin.y = (frame.size.height - 64 - alertFrame.size.height) / 2
        alertView.frame = alertFrame
        
        return alertView_Bg
    }
    
    class func pravaktaShareAlertPopUpView(_ delegate: UITextFieldDelegate,title : NSString, frame : CGRect, okButtonTitle : NSString) -> AnyObject
    {
        let Height:CGFloat = 250
        let width :CGFloat = frame.size.width-40
        let posX :CGFloat = (frame.size.width - width ) / 2
        
        //alert view background
        let alertView_Bg: UIView = UIView (frame: CGRect(x: 0,y: 0 ,width: frame.size.width,height: frame.size.height))
        alertView_Bg.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        
        let alertView: UIView = UIView (frame: CGRect(x: posX,y: (alertView_Bg.frame.height-Height)/2 ,width: width,height: Height-20))
        alertView.backgroundColor = UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        alertView.layer.cornerRadius = 10.0
        alertView_Bg.addSubview(alertView)
        
        //close button on top view
        let closeView : UIButton = UIButton (frame: CGRect(x: alertView.frame.size.width-40,y: 8,width: 30,height: 30))
        closeView.backgroundColor = UIColor.clear//UIColorFromRGB(headerBlueCOlor, alpha: 1)
        closeView.setImage(UIImage(named: "CropDetailsDeleteImg"), for: UIControlState())
        closeView.setTitle("", for: UIControlState())
        closeView.addTarget(delegate, action: Selector(("alertShareCloseBtn")), for: UIControlEvents.touchUpInside)
        alertView.addSubview(closeView)
        
        //alert Title
        let alertTitleLbl : UILabel = UILabel (frame: CGRect(x: 0,y: 15,width: alertView.frame.width,height: 30))
        alertTitleLbl.text = title as String
        alertTitleLbl.textColor = App_Theme_Blue_Color//UIColor(red: 0.0/255, green: 128.0/255, blue: 43.0/255, alpha: 1)
        //UIColor(red: 0.0/255, green: 149.0/255, blue: 159.0/255, alpha: 1)
        alertTitleLbl.font = UIFont (name: "Lato-Bold", size:20)
        alertTitleLbl.textAlignment = NSTextAlignment.center
        alertView.addSubview(alertTitleLbl)
        
        
        //farmer mobile number
        let farmerMobileNoTitleLbl : UILabel = UILabel (frame: CGRect(x: 10,y: alertTitleLbl.frame.maxY + 10
            ,width: alertView.frame.width/3,height: 30))
        farmerMobileNoTitleLbl.text = "Mobile No :"
        farmerMobileNoTitleLbl.font = UIFont (name: "Lato", size:12)
        farmerMobileNoTitleLbl.textAlignment = NSTextAlignment.left
        alertView.addSubview(farmerMobileNoTitleLbl)
        
        //textField
        let mobileNoTxtFld : UITextField = UITextField (frame: CGRect(x: farmerMobileNoTitleLbl.frame.width+10,y: alertTitleLbl.frame.maxY + 10,width: (alertView.frame.width - farmerMobileNoTitleLbl.frame.width)-20,height: 30))
        mobileNoTxtFld.backgroundColor = UIColor.white
        mobileNoTxtFld.layer.cornerRadius = 5.0
        mobileNoTxtFld.layer.borderWidth = 1.0
        mobileNoTxtFld.layer.borderColor = UIColor.gray.cgColor
        mobileNoTxtFld.keyboardType = .numberPad
        mobileNoTxtFld.placeholder = ""
        mobileNoTxtFld.textAlignment = NSTextAlignment.center
        mobileNoTxtFld.delegate =  delegate
        mobileNoTxtFld.tag = 44444
        alertView.addSubview(mobileNoTxtFld)
        
        //submit button
        let btnSubmit : UIButton = UIButton (frame: CGRect(x: 0, y: mobileNoTxtFld.frame.maxY+((20.5 * alertView.frame.height)/100),width: width,height: 40))
        btnSubmit.backgroundColor = App_Theme_Blue_Color//UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 0.8)
        btnSubmit.layer.cornerRadius = 5.0
        btnSubmit.setTitle(okButtonTitle as String, for: UIControlState())
        btnSubmit.addTarget(delegate, action: Selector(("alertShareBtn")), for: UIControlEvents.touchUpInside)
        
        alertView.addSubview(btnSubmit)
        
        var alertFrame = alertView.frame
        alertFrame.size.height = btnSubmit.frame.maxY
        //alertFrame.size.height = (noBtn?.frame.maxY)!
        alertView.frame = alertFrame
        
        alertFrame.origin.y = (frame.size.height - 64 - alertFrame.size.height) / 2
        alertView.frame = alertFrame
        
        return alertView_Bg
    }
    
    class func sendMultipleProvidersAlertPopUpView(_ delegate: UITextFieldDelegate,title : NSString, frame : CGRect, okButtonTitle : NSString) -> AnyObject
    {
        let Height:CGFloat = (33.11 * frame.height/120)
        let width :CGFloat = frame.size.width-40
        let posX :CGFloat = (frame.size.width - width ) / 2
        
        //alert view background
        let alertView_Bg: UIView = UIView (frame: CGRect(x: 0,y: 0 ,width: frame.size.width,height: frame.size.height))
        alertView_Bg.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        
        let alertView: UIView = UIView (frame: CGRect(x: posX,y: (alertView_Bg.frame.height-Height)/2 ,width: width,height: Height-20))
        alertView.backgroundColor = UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        alertView.layer.cornerRadius = 10.0
        alertView_Bg.addSubview(alertView)
        
        //close button on top view
        let closeView : UIButton = UIButton (frame: CGRect(x: alertView.frame.size.width-35,y: 0,width: 35,height: 35))
        closeView.backgroundColor = UIColor.clear//UIColorFromRGB(headerBlueCOlor, alpha: 1)
        closeView.setImage(UIImage(named: "CropDetailsDeleteImg"), for: UIControlState())
        closeView.setTitle("", for: UIControlState())
        closeView.addTarget(delegate, action: Selector(("sendMultipleProvidersClose")), for: UIControlEvents.touchUpInside)
        alertView.addSubview(closeView)
        
        //alert Title
        let alertTitleLbl : UILabel = UILabel (frame: CGRect(x: 0,y: 15,width: alertView.frame.width,height: 30))
        alertTitleLbl.text = title as String
        alertTitleLbl.textColor = App_Theme_Blue_Color//UIColor(red: 0.0/255, green: 128.0/255, blue: 43.0/255, alpha: 1)
        //UIColor(red: 0.0/255, green: 149.0/255, blue: 159.0/255, alpha: 1)
        alertTitleLbl.font = UIFont.systemFont(ofSize: 18.0)
        alertTitleLbl.textAlignment = NSTextAlignment.center
        alertView.addSubview(alertTitleLbl)
        
        
        //farmer mobile number
        let lblMaximumPrice : UILabel = UILabel (frame: CGRect(x: 10,y: alertTitleLbl.frame.maxY + 10
            ,width: (alertView.frame.width/1.5) - 20,height: 30))
        lblMaximumPrice.text = "Maximum price per hour(₹)"
        lblMaximumPrice.font = UIFont.systemFont(ofSize: 14.0)
        lblMaximumPrice.textAlignment = NSTextAlignment.left
        alertView.addSubview(lblMaximumPrice)
        
        let lblSeaparator1 : UILabel = UILabel (frame: CGRect(x: lblMaximumPrice.frame.maxX,y: lblMaximumPrice.frame.origin.y + 5
            ,width: 20,height: 20))
        lblSeaparator1.text = ":"
        lblSeaparator1.font = UIFont.systemFont(ofSize: 14.0)
        lblSeaparator1.textAlignment = NSTextAlignment.center
        alertView.addSubview(lblSeaparator1)
        
        //textField
        let priceTxtFld : UITextField = UITextField (frame: CGRect(x: lblSeaparator1.frame.maxX,y: lblMaximumPrice.frame.origin.y, width: alertView.frame.size.width - (lblMaximumPrice.frame.size.width + 45),height: 30))
        priceTxtFld.backgroundColor = UIColor.white
        priceTxtFld.layer.cornerRadius = 5.0
        priceTxtFld.layer.borderWidth = 1.0
        priceTxtFld.layer.borderColor = UIColor.gray.cgColor
        priceTxtFld.keyboardType = .numberPad
        priceTxtFld.placeholder = ""
        priceTxtFld.textAlignment = NSTextAlignment.center
        priceTxtFld.delegate =  delegate
        priceTxtFld.tag = 55555
        alertView.addSubview(priceTxtFld)
        
        let lblDistance : UILabel = UILabel (frame: CGRect(x: 10,y: priceTxtFld.frame.maxY + 10
            ,width: lblMaximumPrice.frame.size.width,height: 30))
        lblDistance.text = "Maximum distance(km)"
        lblDistance.font = UIFont.systemFont(ofSize: 14.0)
        lblDistance.textAlignment = NSTextAlignment.left
        alertView.addSubview(lblDistance)
        
        let lblSeaparator2 : UILabel = UILabel (frame: CGRect(x: lblDistance.frame.maxX,y: lblDistance.frame.origin.y + 5
            ,width: 20,height: 20))
        lblSeaparator2.text = ":"
        lblSeaparator2.font = UIFont.systemFont(ofSize: 14.0)
        lblSeaparator2.textAlignment = NSTextAlignment.center
        alertView.addSubview(lblSeaparator2)
        //textField
        let distanceTxtFld : UITextField = UITextField (frame: CGRect(x: lblSeaparator2.frame.maxX,y: lblDistance.frame.origin.y, width: priceTxtFld.frame.size.width,height: 30))
        distanceTxtFld.backgroundColor = UIColor.white
        distanceTxtFld.layer.cornerRadius = 5.0
        distanceTxtFld.layer.borderWidth = 1.0
        distanceTxtFld.layer.borderColor = UIColor.gray.cgColor
        distanceTxtFld.keyboardType = .numberPad
        distanceTxtFld.placeholder = ""
        distanceTxtFld.textAlignment = NSTextAlignment.center
        distanceTxtFld.delegate =  delegate
        distanceTxtFld.tag = 66666
        alertView.addSubview(distanceTxtFld)
        
        //submit button
        let btnSubmit : UIButton = UIButton (frame: CGRect(x: 0, y: distanceTxtFld.frame.maxY+((20.5 * alertView.frame.height)/100),width: width,height: 40))
        btnSubmit.backgroundColor = App_Theme_Blue_Color//UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 0.8)
        btnSubmit.layer.cornerRadius = 5.0
        btnSubmit.setTitle(okButtonTitle as String, for: UIControlState())
        btnSubmit.addTarget(delegate, action: Selector(("multipleProvidersOk")), for: UIControlEvents.touchUpInside)
        
        alertView.addSubview(btnSubmit)
        
        var alertFrame = alertView.frame
        alertFrame.size.height = btnSubmit.frame.maxY
        //alertFrame.size.height = (noBtn?.frame.maxY)!
        alertView.frame = alertFrame
        
        alertFrame.origin.y = (frame.size.height - 64 - alertFrame.size.height) / 2
        alertView.frame = alertFrame
        
        return alertView_Bg
    }
    
    class func orderCancelAndRejectPopup(_ delegate: UITextViewDelegate,title : NSString, frame : CGRect, okButtonTitle : NSString) -> AnyObject
    {
        let Height:CGFloat = (33.11 * frame.height/140)
        let width :CGFloat = frame.size.width-40
        let posX :CGFloat = (frame.size.width - width ) / 2
        
        //alert view background
        let alertView_Bg: UIView = UIView (frame: CGRect(x: 0,y: 0 ,width: frame.size.width,height: frame.size.height))
        alertView_Bg.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        
        let alertView: UIView = UIView (frame: CGRect(x: posX,y: (alertView_Bg.frame.height-Height)/2 ,width: width,height: Height-20))
        alertView.backgroundColor = UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        alertView.layer.cornerRadius = 10.0
        alertView_Bg.addSubview(alertView)
        
        //close button on top view
        let closeView : UIButton = UIButton (frame: CGRect(x: alertView.frame.size.width-35,y: 0,width: 35,height: 35))
        closeView.backgroundColor = UIColor.clear//UIColorFromRGB(headerBlueCOlor, alpha: 1)
        closeView.setImage(UIImage(named: "CropDetailsDeleteImg"), for: UIControlState())
        closeView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 7, right: 0)
        closeView.setTitle("", for: UIControlState())
        closeView.addTarget(delegate, action: Selector(("cancelAndrejectCloseButton")), for: UIControlEvents.touchUpInside)
        alertView.addSubview(closeView)
        
        //alert Title
        let alertTitleLbl : UILabel = UILabel (frame: CGRect(x: 0,y: 15,width: alertView.frame.width,height: 30))
        alertTitleLbl.text = title as String
        alertTitleLbl.textColor = App_Theme_Blue_Color//UIColor(red: 0.0/255, green: 128.0/255, blue: 43.0/255, alpha: 1)
        //UIColor(red: 0.0/255, green: 149.0/255, blue: 159.0/255, alpha: 1)
        alertTitleLbl.font = UIFont.systemFont(ofSize: 18.0)
        alertTitleLbl.textAlignment = NSTextAlignment.center
        alertView.addSubview(alertTitleLbl)
        
        //textField
        let txtReason = UITextView(frame: CGRect(x: 10,y: alertTitleLbl.frame.maxY + 10, width: alertView.frame.size.width - 20,height: 100))
        txtReason.backgroundColor = UIColor.white
        txtReason.font = UIFont.systemFont(ofSize: 15.0)
        txtReason.layer.cornerRadius = 5.0
        txtReason.layer.borderWidth = 1.0
        txtReason.layer.borderColor = UIColor.gray.cgColor
        txtReason.delegate =  delegate
        txtReason.tag = 77777
        alertView.addSubview(txtReason)
        
        //submit button
        let btnSubmit : UIButton = UIButton (frame: CGRect(x: 0, y: txtReason.frame.maxY+((20.5 * alertView.frame.height)/100),width: width,height: 40))
        btnSubmit.backgroundColor = App_Theme_Blue_Color//UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 0.8)
        btnSubmit.layer.cornerRadius = 5.0
        btnSubmit.setTitle(okButtonTitle as String, for: UIControlState())
        btnSubmit.addTarget(delegate, action: Selector(("cancelAndrejectOkButton")), for: UIControlEvents.touchUpInside)
        
        alertView.addSubview(btnSubmit)
        
        var alertFrame = alertView.frame
        alertFrame.size.height = btnSubmit.frame.maxY
        //alertFrame.size.height = (noBtn?.frame.maxY)!
        alertView.frame = alertFrame
        
        alertFrame.origin.y = (frame.size.height - 64 - alertFrame.size.height) / 2
        alertView.frame = alertFrame
        
        return alertView_Bg
    }
    class func genunityCheckResultPopup(_ delegate: AnyObject, frame : CGRect , title : NSString, message : NSString, buttonTitle1 : NSString ,  buttonTitle2 : NSString  , imgCorteva: UIImage ,statusLogo:UIImage,hideClose : Bool,rewardMessage : NSString,rewardMessage1 : NSString,showEncashBtn : Bool,prodSerialNo : NSString,cashBackMsg: NSString,productName: NSString,enableSprayService :  Bool ) -> AnyObject
    {
        var Height:CGFloat = (33.11 * frame.height/120)
        var width :CGFloat = frame.size.width-40
        var posX :CGFloat = (frame.size.width - width ) / 2
        var lablHeightPadding :CGFloat = 27
        // unowned(unsafe) var delegate: UITextFieldDelegate?
        
        if hideClose == false
        {
            Height = (33.11 * frame.height/150)
            width = frame.size.width-70
            posX  = (frame.size.width - width ) / 2
            lablHeightPadding = CGFloat(40)
        }
        
        let alertView_Bg: UIView = UIView (frame: CGRect(x: 0,y: 0 ,width: frame.size.width,height: frame.size.height))
        
        alertView_Bg.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        
        let alertView: UIView = UIView (frame: CGRect(x: posX,y: (alertView_Bg.frame.height-Height)/2 ,width: width,height: Height))
        alertView.backgroundColor = UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        alertView.layer.cornerRadius = 10.0
        alertView_Bg.addSubview(alertView)
        
//        let CloseBtn_View: UIView;
        
        //        if GRAPHICS.Screen_Height() == 480.0
        //        {
        //            CloseBtn_View = UIView (frame: CGRect(x: alertView.frame.maxX-20,y: alertView.frame.minY - 1 ,width: 50,height: 50))
        //        }
        //
        //        else
        //        {
        
//        CloseBtn_View = UIView (frame: CGRect(x: alertView.frame.maxX-25,y: alertView.frame.minY-25 ,width: 50,height: 50))
//        //  }
//
//        CloseBtn_View.backgroundColor = UIColor.clear
//
//        alertView_Bg.addSubview(CloseBtn_View)
        
        let lblHeading : UILabel = UILabel (frame: CGRect(x: 0,y: 0,width: alertView.frame.width,height: ((15 * alertView.frame.height)/100) + 10))
        lblHeading.text = title as String
        lblHeading.textColor = .white//UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 1.0)
        lblHeading.font = UIFont.boldSystemFont(ofSize: 16.0)
        lblHeading.numberOfLines = 0
        lblHeading.backgroundColor = App_Theme_Blue_Color
        lblHeading.textAlignment = NSTextAlignment.center
        alertView.addSubview(lblHeading)
        
//        let closeBtn : UIButton = UIButton (frame: CGRect(x: lblHeading.frame.maxX - 30, y: 0,width: 35,height: 35))
//        closeBtn.backgroundColor = UIColor.clear//UIColorFromRGB(headerBlueCOlor, alpha: 1)
//
//        closeBtn.setImage(UIImage(named: "CropDetailsDeleteImg"), for: UIControlState())
//        closeBtn.setTitle("", for: UIControlState())
//        closeBtn.layer.cornerRadius = closeBtn.frame.width/2
//        // closeBtn.titleLabel!.font = GRAPHICS.FONT_REGULAR(16)
//        closeBtn.addTarget(delegate, action: Selector(("infoAlertClose")), for: UIControlEvents.touchUpInside)
//        alertView.addSubview(closeBtn)
////        CloseBtn_View.isHidden = false
//        closeBtn.isHidden = hideClose
        
//        let imgStatus = UIImageView(frame: CGRect(x: (alertView.frame.width - 60)/2, y: lblHeading.frame.maxY + 8, width: 60, height: 60))
        let imgStatus = UIImageView(frame: CGRect(x: 20, y: lblHeading.frame.maxY + 8, width: 50, height: 50))
        imgStatus.image = statusLogo
        imgStatus.contentMode = .scaleAspectFit
        alertView.addSubview(imgStatus)
        
//        let lbl_Message : UILabel = UILabel (frame: CGRect(x: 5,y: imgStatus.frame.maxY+((15 * alertView.frame.height)/100) - 5,width: alertView.frame.width - 10,height: ((lablHeightPadding * alertView.frame.height)/100)))
        let lbl_Message : UILabel = UILabel (frame: CGRect(x: imgStatus.frame.size.width+30,y: lblHeading.frame.maxY+12,width: alertView.frame.size.width - imgStatus.frame.size.width - 20,height: 60))
        lbl_Message.text = String(format:"%@", message as String)
        lbl_Message.textColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        lbl_Message.lineBreakMode = .byTruncatingTail
        lbl_Message.numberOfLines = 0
        lbl_Message.sizeToFit()
        lbl_Message.font = UIFont.systemFont(ofSize: 15.0)

        var ViewFrame = lbl_Message.frame
       // ViewFrame.origin.x = (alertView.frame.width - lbl_Message.frame.width) / 2
        //lbl_Message.frame = ViewFrame
        lbl_Message.textAlignment = NSTextAlignment.center
        alertView.addSubview(lbl_Message)
        
       // let lbl_Message1 : UILabel = UILabel (frame: CGRect(x: 5,y: imgStatus.frame.maxY+((15 * alertView.frame.height)/100) - 5,width: alertView.frame.width - 10,height: ((lablHeightPadding * alertView.frame.height)/100)))
        let lbl_Message1 : UILabel = UILabel (frame: CGRect(x: 5,y: lbl_Message.frame.maxY + 5 ,width: alertView.frame.width - 10,height: ((lablHeightPadding * alertView.frame.height)/100)))
        if productName as String != "" {
            // lbl_Message1.text = String(format:"Serial number : %@ \nProduct Name : %@",prodSerialNo as String, productName as String)
            //Removed serial no as it is not coming in android teja told to remove
            lbl_Message1.text = String(format:"Product Name : %@", productName as String)
        }else {
             //lbl_Message1.text = String(format:"Serial number : %@",prodSerialNo as String)
        }
       
        lbl_Message1.textColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        lbl_Message1.numberOfLines = 0
        lbl_Message1.sizeToFit()
        lbl_Message1.font = UIFont.systemFont(ofSize: 15.0)
        
        var ViewFrame1 = lbl_Message1.frame
        ViewFrame1.origin.x = (alertView.frame.width - lbl_Message1.frame.width) / 2
        lbl_Message1.frame = ViewFrame1
        if productName == "" && prodSerialNo == ""{
            let yAxis = CGFloat(imgStatus.frame.maxY+((15 * alertView.frame.height)/100) - 5)
            lbl_Message1.frame = CGRect(x: 5,y: yAxis,width: alertView.frame.width - 10,height: 0)
        }
        lbl_Message1.textAlignment = NSTextAlignment.center
        alertView.addSubview(lbl_Message1)

        let imgViewCortevaLogo = UIImageView(frame: CGRect(x: (alertView.frame.width - 140)/2, y: lbl_Message1.frame.maxY + 8, width: 140, height: 60))
        imgViewCortevaLogo.image = imgCorteva
        imgViewCortevaLogo.contentMode = .scaleAspectFit
        alertView.addSubview(imgViewCortevaLogo)
        
        let lbl_RewardMessage : UIButton = UIButton()
        lbl_RewardMessage.frame = CGRect(x: 15,y: imgViewCortevaLogo.frame.maxY + 20 - 15,width: alertView.frame.width - 30,height: ((lablHeightPadding * alertView.frame.height)/100))
        
        
        //lbl_Message.font = GRAPHICS.FONT_REGULAR(15)
        if buttonTitle1  != "Redeem Now" && enableSprayService == true{
//            DispatchQueue.main.async(execute: {
//UIButton.animate(withDuration: 0.2,
//animations: {
//lbl_RewardMessage.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)
//},
//completion: { finish in
//UIButton.animate(withDuration: 0.2, animations: {
//lbl_RewardMessage.transform = CGAffineTransform.identity
//})
//})
//                UIButton.animate(withDuration: 10.0, delay: 0.5, options: ([.allowUserInteraction , .repeat ]), animations: {() -> Void in
//                     lbl_RewardMessage.isUserInteractionEnabled = true
//                    lbl_RewardMessage.transform = CGAffineTransform.identity
//                    lbl_RewardMessage.center = CGPoint(x: 0 - lbl_RewardMessage.bounds.size.width / 2, y: lbl_RewardMessage.center.y)
//
//                }, completion:  nil)
//
//            })
            lbl_RewardMessage.setTitle("You are eligible for spray services.Please click Here to avail!", for: .normal)
            lbl_RewardMessage.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
            lbl_RewardMessage.setTitleColor(App_Theme_Blue_Color, for: .normal)
            lbl_RewardMessage.isUserInteractionEnabled = true
            lbl_RewardMessage.isHighlighted = true
            lbl_RewardMessage.addTarget(delegate, action: Selector(("infoSprayServices")), for: UIControlEvents.touchUpInside)
        }else {
            lbl_RewardMessage.setTitle(rewardMessage as String, for: .normal)
            lbl_RewardMessage.setTitleColor(UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8), for: .normal)
            lbl_RewardMessage.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
            lbl_RewardMessage.isUserInteractionEnabled = false
        }
        
        lbl_RewardMessage.titleLabel?.lineBreakMode = .byWordWrapping
        lbl_RewardMessage.titleLabel?.numberOfLines = 0
       
//        lbl_RewardMessage.sizeToFit()
   
        var ViewRewardFrame = lbl_RewardMessage.frame
        ViewRewardFrame.origin.x = (alertView.frame.width - lbl_RewardMessage.frame.width) / 2
        lbl_RewardMessage.frame = ViewRewardFrame
        lbl_RewardMessage.titleLabel?.textAlignment = NSTextAlignment.center
      
     
        alertView.addSubview(lbl_RewardMessage)

       
        let lbl_RewardMessage1 : UILabel = UILabel()
        lbl_RewardMessage1.frame = CGRect(x: 5,y: lbl_RewardMessage.frame.maxY+((15 * alertView.frame.height)/100) - 15,width: alertView.frame.width - 10,height: ((lablHeightPadding * alertView.frame.height)/100) + 20)
        lbl_RewardMessage1.text = rewardMessage1 as String
        lbl_RewardMessage1.textColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        lbl_RewardMessage1.font = UIFont.systemFont(ofSize: 15.0)
        lbl_RewardMessage1.numberOfLines = 0
        lbl_RewardMessage1.sizeToFit()
        
        var ViewRewardFrame1 = lbl_RewardMessage1.frame
        ViewRewardFrame1.origin.x = (alertView.frame.width - lbl_RewardMessage1.frame.width) / 2
        lbl_RewardMessage1.frame = ViewRewardFrame1
        lbl_RewardMessage1.textAlignment = NSTextAlignment.left
        alertView.addSubview(lbl_RewardMessage1)
        
             let lblCashReward : UILabel = UILabel()
           lblCashReward.frame = CGRect(x: 0,y: lbl_RewardMessage1.frame.maxY+((15 * alertView.frame.height)/100) - 15,width: alertView.frame.size.width ,height: 35)
        lblCashReward.text = cashBackMsg as String
        lblCashReward.textColor =   .white
        lblCashReward.backgroundColor = App_Theme_Orange_Color
        lblCashReward.font = UIFont.systemFont(ofSize: 15.0)
        lblCashReward.numberOfLines = 0
        lblCashReward.textAlignment = .center
        if cashBackMsg.length == 0{
            lblCashReward.frame = CGRect(x: 0,y: lbl_RewardMessage1.frame.maxY+((15 * alertView.frame.height)/100) - 15,width: alertView.frame.size.width ,height: 0)
        }
        alertView.addSubview(lblCashReward)
        
        
       
        let viewButtons : UIView = UIView()
        viewButtons.frame = CGRect(x: 0, y: lblCashReward.frame.maxY,width: alertView.frame.size.width,height: 40)
        viewButtons.backgroundColor =  App_Theme_Blue_Color
        alertView.addSubview(viewButtons)
        
        let btnSubmit : UIButton = UIButton()
        btnSubmit.frame = CGRect(x: 0, y: 0,width: viewButtons.frame.size.width/2,height: 40)
        btnSubmit.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        viewButtons.addSubview(btnSubmit)
        
        let btnSubmit1 : UIButton = UIButton()
        btnSubmit1.frame = CGRect(x:  viewButtons.frame.size.width/2, y: 0,width: viewButtons.frame.size.width/2,height: 40)
        btnSubmit1.backgroundColor =  App_Theme_Blue_Color
        btnSubmit1.titleLabel?.textColor = UIColor.green
        btnSubmit1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        viewButtons.addSubview(btnSubmit1)
        alertView.cornerRadius = 10
        alertView.clipsToBounds = true
     
        if buttonTitle1  == "Redeem Now"{
             btnSubmit.backgroundColor = App_Theme_Green_Light_Color
            //btnSubmit.setTitle(buttonTitle1 as String, for: .normal)
            btnSubmit.setTitle(NSLocalizedString("Redeem_now", comment: ""), for: .normal)
            //btnSubmit1.setTitle(buttonTitle2 as String, for: .normal)
            btnSubmit1.setTitle(NSLocalizedString("Scan_More", comment: ""), for: .normal)
            
            
            btnSubmit.addTarget(delegate, action: Selector(("infoAlertSubmit")), for: UIControlEvents.touchUpInside)
            btnSubmit1.addTarget(delegate, action: Selector(("infoAlertScanMore")), for: UIControlEvents.touchUpInside)
            if rewardMessage1 == "" {
                viewButtons.frame = CGRect(x: 0, y: lblCashReward.frame.maxY,width: alertView.frame.size.width,height: 40)
            }
            if rewardMessage == "" && rewardMessage1 == ""{
                lblCashReward.frame = CGRect(x: 0, y: imgViewCortevaLogo.frame.maxY+5,width: alertView.frame.size.width,height: 40)
            }
            viewButtons.frame = CGRect(x: 0, y: lblCashReward.frame.maxY,width: alertView.frame.size.width,height: 40)
        }
        else{
           
             btnSubmit.backgroundColor = App_Theme_Orange_Light_Color
            if buttonTitle1 == "" {
                 //btnSubmit.setTitle("Done" as String, for: .normal)
                btnSubmit.setTitle(NSLocalizedString("done", comment: ""), for: .normal)
            }else {
            btnSubmit.setTitle(buttonTitle1 as String, for: .normal)
            }
            if buttonTitle2 == "" {
                //btnSubmit1.setTitle("Scan More" as String, for: .normal)
                btnSubmit1.setTitle(NSLocalizedString("Scan_More", comment: ""), for: .normal)
            }else {
                  btnSubmit1.setTitle(buttonTitle2 as String, for: .normal)
            }
            btnSubmit.setTitle(NSLocalizedString("done", comment: ""), for: .normal)
            btnSubmit1.setTitle(NSLocalizedString("Scan_More", comment: ""), for: .normal)
            
            btnSubmit.addTarget(delegate, action: Selector(("infoAlertSubmit")), for: UIControlEvents.touchUpInside)
            btnSubmit1.addTarget(delegate, action: Selector(("infoAlertScanMore")), for: UIControlEvents.touchUpInside)
            if rewardMessage1 == "" {
                viewButtons.frame = CGRect(x: 0, y: lbl_RewardMessage.frame.maxY+55,width: alertView.frame.size.width,height: 40)
            }
            if rewardMessage == "" && rewardMessage1 == ""{
                viewButtons.frame = CGRect(x: 0, y: imgViewCortevaLogo.frame.maxY+55,width: alertView.frame.size.width,height: 40)
            }
            lblCashReward.isHidden = true
        }
        
//        viewButtons.isHidden = !hideClose

        if hideClose == false
        {
            var alertFrame = alertView.frame
            alertFrame.size.height = viewButtons.frame.maxY + 25
            alertView.frame = alertFrame
        }
        else
        {
            var alertFrame = alertView.frame
            alertFrame.size.height = viewButtons.frame.maxY
            alertView.frame = alertFrame
        }
        var alertFrame = alertView.frame
        alertFrame.origin.y = (frame.size.height - alertFrame.size.height) / 2
        alertView.frame = alertFrame
        
        let flipButton = UIButton(frame: CGRect(x: alertView.frame.width-35, y: 5, width: 25, height: 25))
        flipButton.layer.cornerRadius = 15
        flipButton.backgroundColor = UIColor.red
        flipButton.setImage(UIImage(named: "icon_cross.png"), for: .normal)
        flipButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        flipButton.addTarget(delegate, action: Selector(("infoCloseButton")), for: .touchUpInside)
        flipButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        alertView.addSubview(flipButton)
        
//         let CloseBtn_View : UIView = UIView()
//        CloseBtn_View.frame =  CGRect(x: alertView_Bg.frame.maxX-50,y: -50 ,width: 50,height: 50)
//        CloseBtn_View.backgroundColor = UIColor.red
//         CloseBtn_View.cornerRadius =  25
//        CloseBtn_View.clipsToBounds = true
        
        //         closeBtn.frame  =  CGRectMake(10, 10,CGRectGetWidth(CloseBtn_View.frame)-20,CGRectGetHeight(CloseBtn_View.frame)-20)
        
//        let tapGestureForClose = UITapGestureRecognizer(target: delegate, action: Selector(("infoAlertClose")))
////        closeBtn.addGestureRecognizer(tapGestureForClose)
        alertView.cornerRadius = 10
        alertView.clipsToBounds = true
        return alertView_Bg
    }
    
    class func genunityCheckNewResultPopup(_ delegate: AnyObject, value: Bool, reatilerTableView : UITableView , selectedRetailerName: NSString,frame : CGRect , title : NSString, message : NSString, buttonTitle1 : NSString ,  buttonTitle2 : NSString  , imgCorteva: UIImage ,statusLogo:UIImage,hideClose : Bool,rewardMessage : NSString,rewardMessage1 : NSString,showEncashBtn : Bool,prodSerialNo : NSString,cashBackMsg: NSString,productName: NSString,enableSprayService :  Bool, retailerList: NSArray ) -> AnyObject
    {

        var Height:CGFloat = (33.11 * frame.height/120)
        var width :CGFloat = frame.size.width-40
        var posX :CGFloat = (frame.size.width - width ) / 2
        var lablHeightPadding :CGFloat = 27
        // unowned(unsafe) var delegate: UITextFieldDelegate?
        
        if hideClose == false
        {
            Height = (33.11 * frame.height/150)
            width = frame.size.width-70
            posX  = (frame.size.width - width ) / 2
            lablHeightPadding = CGFloat(40)
        }
        
        let alertView_Bg: UIView = UIView (frame: CGRect(x: 0,y: 0 ,width: frame.size.width,height: frame.size.height))
        
        alertView_Bg.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        
      
            let alertView: UIView = UIView (frame: CGRect(x: posX,y: (alertView_Bg.frame.height-Height)/2 ,width: width,height: Height))
            alertView.backgroundColor = UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
            alertView.layer.cornerRadius = 10.0
            alertView_Bg.addSubview(alertView)
   
        

//       if(value == true){
//           let searchView: UIView = UIView (frame: CGRect(x: posX,y: 0 ,width: width,height:frame.size.height ))
//        searchView.backgroundColor = UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
//        searchView.layer.cornerRadius = 10.0
//        alertView_Bg.addSubview(searchView)
//           
//           let flipButton = UIButton(frame: CGRect(x: alertView.frame.width-35, y: 5, width: 25, height: 25))
//           flipButton.layer.cornerRadius = 15
//           flipButton.backgroundColor = UIColor.red
//           flipButton.setImage(UIImage(named: "icon_cross.png"), for: .normal)
//           flipButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//           flipButton.addTarget(delegate, action: Selector(("infoCloseButton")), for: .touchUpInside)
//           flipButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
//           alertView.addSubview(flipButton)
//       }
        
        let lblHeading : UILabel = UILabel (frame: CGRect(x: 0,y: 0,width: alertView.frame.width,height: ((15 * alertView.frame.height)/100) + 10))
        lblHeading.text = title as String
        lblHeading.textColor = .white//UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 1.0)
        lblHeading.font = UIFont.boldSystemFont(ofSize: 16.0)
        lblHeading.numberOfLines = 0
        lblHeading.backgroundColor = App_Theme_Blue_Color
        lblHeading.textAlignment = NSTextAlignment.center
        alertView.addSubview(lblHeading)
        
        let imgStatus = UIImageView(frame: CGRect(x: 20, y: lblHeading.frame.maxY + 8, width: 50, height: 50))
        imgStatus.image = statusLogo
        imgStatus.contentMode = .scaleAspectFit
        alertView.addSubview(imgStatus)
        
        let lbl_Message : UILabel = UILabel (frame: CGRect(x: imgStatus.frame.size.width+30,y: lblHeading.frame.maxY+12,width: alertView.frame.size.width - imgStatus.frame.size.width - 20,height: 60))
        lbl_Message.text = String(format:"%@", message as String)
        lbl_Message.textColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        lbl_Message.lineBreakMode = .byTruncatingTail
        lbl_Message.numberOfLines = 0
        lbl_Message.sizeToFit()
        lbl_Message.font = UIFont.systemFont(ofSize: 15.0)

        var ViewFrame = lbl_Message.frame
        lbl_Message.textAlignment = NSTextAlignment.center
        alertView.addSubview(lbl_Message)
        
        let lbl_Message1 : UILabel = UILabel (frame: CGRect(x: 5,y: lbl_Message.frame.maxY + 5 ,width: alertView.frame.width - 10,height: ((lablHeightPadding * alertView.frame.height)/100)))
        if productName as String != "" {
             lbl_Message1.text = String(format:"Serial number : %@ \nProduct Name : %@",prodSerialNo as String, productName as String)
        }else {
             lbl_Message1.text = String(format:"Serial number : %@",prodSerialNo as String)
        }
       
        lbl_Message1.textColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        lbl_Message1.numberOfLines = 0
        lbl_Message1.sizeToFit()
        lbl_Message1.font = UIFont.systemFont(ofSize: 15.0)
        
        var ViewFrame1 = lbl_Message1.frame
        ViewFrame1.origin.x = (alertView.frame.width - lbl_Message1.frame.width) / 2
        lbl_Message1.frame = ViewFrame1
        if productName == "" && prodSerialNo == ""{
            let yAxis = CGFloat(imgStatus.frame.maxY+((15 * alertView.frame.height)/100) - 5)
            lbl_Message1.frame = CGRect(x: 5,y: yAxis,width: alertView.frame.width - 10,height: 0)
        }
        lbl_Message1.textAlignment = NSTextAlignment.center
        alertView.addSubview(lbl_Message1)

        let imgViewCortevaLogo = UIImageView(frame: CGRect(x: (alertView.frame.width - 140)/2, y: lbl_Message1.frame.maxY + 8, width: 140, height: 60))
        imgViewCortevaLogo.image = imgCorteva
        imgViewCortevaLogo.contentMode = .scaleAspectFit
        alertView.addSubview(imgViewCortevaLogo)
        
        let selectRetailerTxtFld : UITextField = UITextField (frame:  CGRect(x:16, y: imgViewCortevaLogo.frame.maxY + 10, width: alertView.frame.width - 30, height: 40))
               selectRetailerTxtFld.backgroundColor = UIColor.white
               selectRetailerTxtFld.layer.cornerRadius = 5.0
               selectRetailerTxtFld.layer.borderWidth = 1.0
               selectRetailerTxtFld.layer.borderColor = UIColor.gray.cgColor
               selectRetailerTxtFld.keyboardType = .numberPad
               selectRetailerTxtFld.placeholder = NSLocalizedString("selectRetailer", comment: "")
               selectRetailerTxtFld.text = String(selectedRetailerName)
               selectRetailerTxtFld.textAlignment = NSTextAlignment.left
               selectRetailerTxtFld.delegate =  delegate as? UITextFieldDelegate
               selectRetailerTxtFld.tag = 88888
        
               let paddingRight = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: selectRetailerTxtFld.frame.height))
               selectRetailerTxtFld.rightView = paddingRight
               selectRetailerTxtFld.rightViewMode = .always
    
               let paddingLeft = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: selectRetailerTxtFld.frame.height))
               selectRetailerTxtFld.leftView = paddingLeft
               selectRetailerTxtFld.leftViewMode = .always
               alertView.addSubview(selectRetailerTxtFld)
        
               let imgStatus1 = UIImageView(frame: CGRect(x: (selectRetailerTxtFld.frame.width)-10, y: imgViewCortevaLogo.frame.maxY + 22, width: 20, height: 20))
               imgStatus1.image = UIImage(named: "DropDown-1")
               imgStatus1.contentMode = .scaleAspectFit
               alertView.addSubview(imgStatus1)
        

               let textFieldlbl : UILabel = UILabel (frame: CGRect(x:16 ,y: selectRetailerTxtFld.frame.maxY + 10 ,width:100, height: 40))
               textFieldlbl.text = NSLocalizedString("retailerID", comment: "")
               textFieldlbl.textColor = UIColor.black
               textFieldlbl.font = UIFont.boldSystemFont(ofSize: 16.0)
               textFieldlbl.numberOfLines = 0
               textFieldlbl.textAlignment = NSTextAlignment.left
               alertView.addSubview(textFieldlbl)
               
               //textField
               let retailerIDTxtFld : UITextField = UITextField (frame:  CGRect(x: (textFieldlbl.frame.width)+10, y: selectRetailerTxtFld.frame.maxY + 10, width: alertView.frame.width - textFieldlbl.frame.width - 30, height: 40))
               retailerIDTxtFld.backgroundColor = UIColor.white
               retailerIDTxtFld.layer.cornerRadius = 5.0
               retailerIDTxtFld.layer.borderWidth = 1.0
               retailerIDTxtFld.layer.borderColor = UIColor.gray.cgColor
               retailerIDTxtFld.keyboardType = .numberPad
              let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: retailerIDTxtFld.frame.height))
              retailerIDTxtFld.leftView = paddingView1
              retailerIDTxtFld.leftViewMode = .always
              retailerIDTxtFld.isSecureTextEntry = true
               retailerIDTxtFld.placeholder = NSLocalizedString("retailerCodeEnter", comment: "")
               retailerIDTxtFld.textAlignment = NSTextAlignment.left
               retailerIDTxtFld.delegate =  delegate as? UITextFieldDelegate
               retailerIDTxtFld.tag = 99999
               alertView.addSubview(retailerIDTxtFld)
        
        let lbl_RewardMessage : UIButton = UIButton()
        lbl_RewardMessage.frame = CGRect(x: 15,y: retailerIDTxtFld.frame.maxY + 20 - 15,width: alertView.frame.width - 30,height: ((lablHeightPadding * alertView.frame.height)/100))

        if buttonTitle1  != "Redeem Now" && enableSprayService == true{

            lbl_RewardMessage.setTitle("You are eligible for spray services.Please click Here to avail!", for: .normal)
            lbl_RewardMessage.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
            lbl_RewardMessage.setTitleColor(App_Theme_Blue_Color, for: .normal)
            lbl_RewardMessage.isUserInteractionEnabled = true
            lbl_RewardMessage.isHighlighted = true
            lbl_RewardMessage.addTarget(delegate, action: Selector(("infoSprayServices")), for: UIControlEvents.touchUpInside)
        }else {
            lbl_RewardMessage.setTitle(rewardMessage as String, for: .normal)
            lbl_RewardMessage.setTitleColor(UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8), for: .normal)
            lbl_RewardMessage.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
            lbl_RewardMessage.isUserInteractionEnabled = false
        }
        
        lbl_RewardMessage.titleLabel?.lineBreakMode = .byWordWrapping
        lbl_RewardMessage.titleLabel?.numberOfLines = 0
       
        var ViewRewardFrame = lbl_RewardMessage.frame
        ViewRewardFrame.origin.x = (alertView.frame.width - lbl_RewardMessage.frame.width) / 2
        lbl_RewardMessage.frame = ViewRewardFrame
        lbl_RewardMessage.titleLabel?.textAlignment = NSTextAlignment.center
           
        alertView.addSubview(lbl_RewardMessage)

        let lbl_RewardMessage1 : UILabel = UILabel()
        lbl_RewardMessage1.frame = CGRect(x: 5,y: lbl_RewardMessage.frame.maxY+((15 * alertView.frame.height)/100) - 15,width: alertView.frame.width - 10,height: ((lablHeightPadding * alertView.frame.height)/100) + 20)
        lbl_RewardMessage1.text = rewardMessage1 as String
        lbl_RewardMessage1.textColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        lbl_RewardMessage1.font = UIFont.systemFont(ofSize: 15.0)
        lbl_RewardMessage1.numberOfLines = 0
        lbl_RewardMessage1.sizeToFit()
        
        var ViewRewardFrame1 = lbl_RewardMessage1.frame
        ViewRewardFrame1.origin.x = (alertView.frame.width - lbl_RewardMessage1.frame.width) / 2
        lbl_RewardMessage1.frame = ViewRewardFrame1
        lbl_RewardMessage1.textAlignment = NSTextAlignment.left
        alertView.addSubview(lbl_RewardMessage1)
        
             let lblCashReward : UILabel = UILabel()
           lblCashReward.frame = CGRect(x: 0,y: lbl_RewardMessage1.frame.maxY+((15 * alertView.frame.height)/100) - 15,width: alertView.frame.size.width ,height: 35)
        lblCashReward.text = cashBackMsg as String
        lblCashReward.textColor =   .white
        lblCashReward.backgroundColor = App_Theme_Orange_Color
        lblCashReward.font = UIFont.systemFont(ofSize: 15.0)
        lblCashReward.numberOfLines = 0
        lblCashReward.textAlignment = .center
        if cashBackMsg.length == 0{
            lblCashReward.frame = CGRect(x: 0,y: lbl_RewardMessage1.frame.maxY+((15 * alertView.frame.height)/100) - 15,width: alertView.frame.size.width ,height: 0)
        }
        alertView.addSubview(lblCashReward)
        
        
        let viewButtons : UIView = UIView()
        viewButtons.frame = CGRect(x: 0, y: lblCashReward.frame.maxY,width: alertView.frame.size.width,height: 40)
        viewButtons.backgroundColor =  App_Theme_Blue_Color
        alertView.addSubview(viewButtons)
        
        let btnSubmit : UIButton = UIButton()
        let btnSubmit1 : UIButton = UIButton()
        
        print("what is in buttonTitle1", buttonTitle1 as String)
        print("what is in buttonTitle2", buttonTitle2 as String)
        print("what is in retailerList", retailerList as Array)
        
        if(buttonTitle1 as String == NSLocalizedString("submit", comment: "")){
           
            btnSubmit.frame = CGRect(x: 0, y: 0,width: viewButtons.frame.size.width/1,height: 40)
            btnSubmit.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            viewButtons.addSubview(btnSubmit)

        }
        else{
            btnSubmit.frame = CGRect(x: 0, y: 0,width: viewButtons.frame.size.width/2,height: 40)
            btnSubmit.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            viewButtons.addSubview(btnSubmit)
            
            
            btnSubmit1.frame = CGRect(x:  viewButtons.frame.size.width/2, y: 0,width: viewButtons.frame.size.width/2,height: 40)
            btnSubmit1.backgroundColor =  App_Theme_Blue_Color
            btnSubmit1.titleLabel?.textColor = UIColor.green
            btnSubmit1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            
            viewButtons.addSubview(btnSubmit1)
        }
        
       
        alertView.cornerRadius = 10
        alertView.clipsToBounds = true
        
        if buttonTitle1 as String  == NSLocalizedString("Redeem_now", comment: ""){
             btnSubmit.backgroundColor = App_Theme_Green_Light_Color
            //btnSubmit.setTitle(buttonTitle1 as String, for: .normal)
            btnSubmit.setTitle(NSLocalizedString("Redeem_now", comment: ""), for: .normal)
            //btnSubmit1.setTitle(buttonTitle2 as String, for: .normal)
            btnSubmit1.setTitle(NSLocalizedString("Scan_More", comment: ""), for: .normal)
            
            btnSubmit.addTarget(delegate, action: Selector(("infoAlertSubmit")), for: UIControlEvents.touchUpInside)
            btnSubmit1.addTarget(delegate, action: Selector(("infoAlertScanMore")), for: UIControlEvents.touchUpInside)
            if rewardMessage1 == "" {
                viewButtons.frame = CGRect(x: 0, y: lblCashReward.frame.maxY,width: alertView.frame.size.width,height: 40)
            }
            if rewardMessage == "" && rewardMessage1 == ""{
                lblCashReward.frame = CGRect(x: 0, y: retailerIDTxtFld.frame.maxY+5,width: alertView.frame.size.width,height: 40)
            }
            viewButtons.frame = CGRect(x: 0, y: lblCashReward.frame.maxY,width: alertView.frame.size.width,height: 40)
        }
        else if (buttonTitle1 as String  == NSLocalizedString("submit", comment: "")){
           
            btnSubmit.backgroundColor = App_Theme_Green_Light_Color
            btnSubmit.setTitle(NSLocalizedString("SubmitCAP", comment: ""), for: .normal)
     
            btnSubmit.addTarget(delegate, action: Selector(("infoAlertSubmit")), for: UIControlEvents.touchUpInside)
            if rewardMessage1 == "" {
                viewButtons.frame = CGRect(x: 0, y: lbl_RewardMessage.frame.maxY+55,width: alertView.frame.size.width,height: 40)
            }
            if rewardMessage == "" && rewardMessage1 == ""{
                viewButtons.frame = CGRect(x: 0, y: retailerIDTxtFld.frame.maxY+10,width: alertView.frame.size.width,height: 40)
            }
            lblCashReward.isHidden = true
        }
        else{
           
             btnSubmit.backgroundColor = App_Theme_Orange_Light_Color
            if buttonTitle1 == "" {
                 //btnSubmit.setTitle("Done" as String, for: .normal)
                btnSubmit.setTitle(NSLocalizedString("done", comment: ""), for: .normal)
            }else {
            btnSubmit.setTitle(buttonTitle1 as String, for: .normal)
            }
            if buttonTitle2 == "" {
                //btnSubmit1.setTitle("Scan More" as String, for: .normal)
                btnSubmit1.setTitle(NSLocalizedString("Scan_More", comment: ""), for: .normal)
            }else {
                  btnSubmit1.setTitle(buttonTitle2 as String, for: .normal)
            }
            btnSubmit.setTitle(NSLocalizedString("done", comment: ""), for: .normal)
            btnSubmit1.setTitle(NSLocalizedString("Scan_More", comment: ""), for: .normal)
            
            btnSubmit.addTarget(delegate, action: Selector(("infoAlertSubmit")), for: UIControlEvents.touchUpInside)
            btnSubmit1.addTarget(delegate, action: Selector(("infoAlertScanMore")), for: UIControlEvents.touchUpInside)
            if rewardMessage1 == "" {
                viewButtons.frame = CGRect(x: 0, y: lbl_RewardMessage.frame.maxY+55,width: alertView.frame.size.width,height: 40)
            }
            if rewardMessage == "" && rewardMessage1 == ""{
                viewButtons.frame = CGRect(x: 0, y: imgViewCortevaLogo.frame.maxY+55,width: alertView.frame.size.width,height: 40)
            }
            lblCashReward.isHidden = true
        }
        
        print("what is coming in value",value)
        if(value == false){
            
            let searchRetailerTxtFld : UITextField = UITextField (frame:  CGRect(x:16, y: selectRetailerTxtFld.frame.maxY, width: selectRetailerTxtFld.frame.width, height: 40))
            searchRetailerTxtFld.backgroundColor = UIColor.white
            searchRetailerTxtFld.layer.cornerRadius = 5.0
            searchRetailerTxtFld.keyboardType = .default
            searchRetailerTxtFld.placeholder = NSLocalizedString("searchRetailer", comment: "")
            searchRetailerTxtFld.textAlignment = NSTextAlignment.left
            searchRetailerTxtFld.delegate =  delegate as? UITextFieldDelegate
            searchRetailerTxtFld.tag = 1010
//            let downBtn3 = UIButton(type: .custom)
//            downBtn3.frame = CGRect(x: 20, y: 0, width: 15, height: 15)
//            downBtn3.setImage(UIImage(named:"Search"), for:.normal)
//            selectRetailerTxtFld.rightView = downBtn3
//            selectRetailerTxtFld.rightViewMode = .always
//            selectRetailerTxtFld.contentMode = .center
            
            let paddingLeft = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: searchRetailerTxtFld.frame.height))
            searchRetailerTxtFld.leftView = paddingLeft
            searchRetailerTxtFld.leftViewMode = .always
            
            let paddingRight = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: searchRetailerTxtFld.frame.height))
            searchRetailerTxtFld.rightView = paddingRight
            searchRetailerTxtFld.rightViewMode = .always
            
            alertView.addSubview(searchRetailerTxtFld)
            
            
//            let imgStatus1 = UIImageView(frame: CGRect(x: (selectRetailerTxtFld.frame.width)-10, y: imgViewCortevaLogo.frame.maxY + 22, width: 20, height: 20))
            
            let searchButton : UIButton = UIButton()
            searchButton.frame = CGRect(x: (searchRetailerTxtFld.frame.width)-45, y: searchRetailerTxtFld.frame.maxY-40 ,width: 60,height: 40)
            searchButton.backgroundColor =  App_Theme_Blue_Color
            searchButton.setTitle(NSLocalizedString("capSearch", comment: ""), for: .normal)
            searchButton.titleLabel?.textColor = UIColor.black
            searchButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            searchButton.borderWidth = 0.5
            searchButton.borderColor = UIColor.green
            searchButton.cornerRadius = 4
            searchButton.addTarget(delegate, action: Selector(("searchButtonClick")), for: UIControlEvents.touchUpInside)
            alertView.addSubview(searchButton)
            
        
            let tblView = UITableView(frame: CGRect(x: 16,y: searchButton.frame.maxY ,width: searchRetailerTxtFld.frame.width,height: 220))
            tblView.delegate = delegate as? UITableViewDelegate
            tblView.dataSource = delegate as? UITableViewDataSource
            tblView.isScrollEnabled = true
            tblView.backgroundColor = UIColor.white
            tblView.isHidden = value
            alertView.addSubview(tblView)
        }

        if hideClose == false
        {
            var alertFrame = alertView.frame
            alertFrame.size.height = viewButtons.frame.maxY + 25
            alertView.frame = alertFrame
        }
        else if(value == false){
            print("coming to --123")
            var alertFrame = alertView.frame
            alertFrame.size.height = viewButtons.frame.maxY + 180
            alertView.frame = alertFrame
        }
        else
        {
            var alertFrame = alertView.frame
            alertFrame.size.height = viewButtons.frame.maxY
            alertView.frame = alertFrame
        }
        var alertFrame = alertView.frame
        alertFrame.origin.y = (frame.size.height - alertFrame.size.height) / 2
        alertView.frame = alertFrame
        
        let flipButton = UIButton(frame: CGRect(x: alertView.frame.width-35, y: 5, width: 25, height: 25))
        flipButton.layer.cornerRadius = 15
        flipButton.backgroundColor = UIColor.red
        flipButton.setImage(UIImage(named: "icon_cross.png"), for: .normal)
        flipButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        flipButton.addTarget(delegate, action: Selector(("infoCloseButton")), for: .touchUpInside)
        flipButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        alertView.addSubview(flipButton)
        
        alertView.cornerRadius = 10
        alertView.clipsToBounds = true
        return alertView_Bg
    }
    
    class func WhatsAppOptInPopup(_ delegate: AnyObject, frame : CGRect , title : NSString, message : NSString, buttonTitle1 : NSString ,  buttonTitle2 : NSString ,hideClose : Bool) -> AnyObject
        {
            var Height:CGFloat = (33.11 * frame.height/120)
            var width :CGFloat = frame.size.width-40
            var posX :CGFloat = (frame.size.width - width ) / 2
            var lablHeightPadding :CGFloat = 27
            // unowned(unsafe) var delegate: UITextFieldDelegate?   
            
            if hideClose == false
            {
                Height = (33.11 * frame.height/150)
                width = frame.size.width-70
                posX  = (frame.size.width - width ) / 2
                lablHeightPadding = CGFloat(40)
            }
            
            let alertView_Bg: UIView = UIView (frame: CGRect(x: 0,y: 0 ,width: frame.size.width,height: frame.size.height))
            
            alertView_Bg.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
            
            let alertView: UIView = UIView (frame: CGRect(x: posX,y: (alertView_Bg.frame.height-Height)/2 ,width: width,height: Height))
            alertView.backgroundColor = UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
            alertView.layer.cornerRadius = 10.0
            alertView_Bg.addSubview(alertView)
            
   
            
            let lblHeading : UILabel = UILabel (frame: CGRect(x: 0,y: 0,width: alertView.frame.width,height: ((15 * alertView.frame.height)/100) + 10))
            lblHeading.text = title as String
            lblHeading.textColor = .white//UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 1.0)
            lblHeading.font = UIFont.boldSystemFont(ofSize: 16.0)
            lblHeading.numberOfLines = 0
            lblHeading.backgroundColor = App_Theme_Blue_Color
            lblHeading.textAlignment = NSTextAlignment.center
            alertView.addSubview(lblHeading)
   
            let lbl_Message : UILabel = UILabel (frame: CGRect(x: lblHeading.frame.size.width+30,y: lblHeading.frame.maxY+12,width: alertView.frame.size.width - 20,height: 100))
            lbl_Message.text = String(format:"%@", message as String)
            lbl_Message.textColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
            lbl_Message.numberOfLines = 4
          
            lbl_Message.font = UIFont.systemFont(ofSize: 15.0)

            var ViewFrame = lbl_Message.frame
            ViewFrame.origin.x = (alertView.frame.width - lbl_Message.frame.width) / 2
            lbl_Message.frame = ViewFrame
            lbl_Message.textAlignment = NSTextAlignment.center
            alertView.addSubview(lbl_Message)
            
            let viewButtons : UIView = UIView()
            viewButtons.frame = CGRect(x: 0, y: lbl_Message.frame.maxY,width: alertView.frame.size.width,height: 40)
            viewButtons.backgroundColor =  App_Theme_Blue_Color
            alertView.addSubview(viewButtons)
            
            let btnSubmit : UIButton = UIButton()
            btnSubmit.frame = CGRect(x: 0, y: 0,width: viewButtons.frame.size.width/2,height: 40)
            btnSubmit.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            viewButtons.addSubview(btnSubmit)
            
            let btnSubmit1 : UIButton = UIButton()
            btnSubmit1.frame = CGRect(x:  viewButtons.frame.size.width/2, y: 0,width: viewButtons.frame.size.width/2,height: 40)
            btnSubmit1.backgroundColor =  App_Theme_Blue_Color
            btnSubmit1.titleLabel?.textColor = UIColor.green
            btnSubmit1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            
            viewButtons.addSubview(btnSubmit1)
            alertView.cornerRadius = 10
            alertView.clipsToBounds = true
         
          
                 btnSubmit.backgroundColor = App_Theme_Orange_Color
                if buttonTitle1 == "" {
                     btnSubmit.setTitle("Done" as String, for: .normal)
                }else {
                btnSubmit.setTitle(buttonTitle1 as String, for: .normal)
                }
                if buttonTitle2 == "" {
                    btnSubmit1.setTitle("Scan More" as String, for: .normal)
                }else {
                      btnSubmit1.setTitle(buttonTitle2 as String, for: .normal)
                }
                
                btnSubmit.addTarget(delegate, action: Selector(("alertMaybeLaterButton")), for: UIControlEvents.touchUpInside)
                btnSubmit1.addTarget(delegate, action: Selector(("alertOptInButton")), for: UIControlEvents.touchUpInside)
                    viewButtons.frame = CGRect(x: 0, y: lbl_Message.frame.maxY+5,width: alertView.frame.size.width,height: 40)

            if hideClose == false
            {
                var alertFrame = alertView.frame
                alertFrame.size.height = viewButtons.frame.maxY + 25
                alertView.frame = alertFrame
            }
            else
            {
                var alertFrame = alertView.frame
                alertFrame.size.height = viewButtons.frame.maxY
                alertView.frame = alertFrame
            }
            var alertFrame = alertView.frame
            alertFrame.origin.y = (frame.size.height - alertFrame.size.height) / 2
            alertView.frame = alertFrame
            
            let flipButton = UIButton(frame: CGRect(x: alertView.frame.width-35, y: 5, width: 25, height: 25))
            flipButton.layer.cornerRadius = 15
            flipButton.backgroundColor = UIColor.red
            flipButton.setImage(UIImage(named: "icon_cross.png"), for: .normal)
            flipButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            flipButton.addTarget(delegate, action: Selector(("infoCloseButtonOptIn")), for: .touchUpInside)
            flipButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
            alertView.addSubview(flipButton)
            
   
            alertView.cornerRadius = 10
            alertView.clipsToBounds = true
            return alertView_Bg
        }
    class func NotificationSelectionPopup(_ delegate: AnyObject, frame : CGRect , title : NSString,image: NSString, message : NSString, buttonTitle1 : NSString ,_ delegate1: SwiftyGifDelegate ) -> AnyObject
         {
            let Height:CGFloat = (33.11 * frame.height/120)
             var width :CGFloat = frame.size.width-40
             var posX :CGFloat = (frame.size.width - width ) / 2
             var lablHeightPadding :CGFloat = 27
             // unowned(unsafe) var delegate: UITextFieldDelegate?
             
             
              let alertView_Bg: UIView = UIView (frame: CGRect(x: 0,y: 0 ,width: frame.size.width,height: frame.size.height))
             
             alertView_Bg.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
             
             let alertView: UIView = UIView (frame: CGRect(x: posX,y: (alertView_Bg.frame.height-Height)/2 ,width: width,height: Height-20))
             alertView.backgroundColor = UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
             alertView.layer.cornerRadius = 10.0
             alertView_Bg.addSubview(alertView)
             
    
             
             let lblHeading : UILabel = UILabel (frame: CGRect(x: 0,y: 0,width: alertView.frame.width,height: ((15 * alertView.frame.height)/100) + 10))
             lblHeading.text = title as String
             lblHeading.textColor = .white//UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 1.0)
             lblHeading.font = UIFont.boldSystemFont(ofSize: 16.0)
             lblHeading.numberOfLines = 0
             lblHeading.backgroundColor = App_Theme_Blue_Color
             lblHeading.textAlignment = NSTextAlignment.center
             alertView.addSubview(lblHeading)
            
            
              let imageNotification : UIImageView = UIImageView (frame: CGRect(x: lblHeading.frame.size.width+30,y: lblHeading.frame.maxY+12,width: alertView.frame.size.width - 20,height: 150))
               let viewButtons : UIView = UIView()
             
            if image != ""{
                let imgStr = image
                let url = URL(string:imgStr as String  )
                if (imgStr.contains("gif")) {
                    let btnPausePlay : UIButton = UIButton (frame: CGRect(x: imageNotification.center.x,y: imageNotification.center.y,width: 25,height: 25))
                    btnPausePlay.setImage(UIImage(named: "VideoIcon"), for: .normal)
                    imageNotification.addSubview(btnPausePlay)
                    btnPausePlay.addTarget(self, action:#selector(self.pauseandPlayButton(_:)), for: .touchUpInside)
                    imageNotification.delegate = delegate1
                          imageNotification.setGifFromURL(url!)
                }else {
                    SwiftLoader.show(animated: true)
                        imageNotification.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceHolderImage")!, options: SDWebImageOptions.refreshCached, completed: { (img, error, _, ur) in
                            if error != nil {
                                 SwiftLoader.hide()
                                imageNotification.image =  UIImage(named: "PlaceHolderImage")!
                            }else {
                                 SwiftLoader.hide()
                                imageNotification.image = img
                            }
                        })
                }
                    
                  var ViewFrame = imageNotification.frame
                  ViewFrame.origin.x = (alertView.frame.width - imageNotification.frame.width) / 2
                  imageNotification.frame = ViewFrame
                  alertView.addSubview(imageNotification)
                
                
                let lbl_Message : UILabel = UILabel (frame: CGRect(x: imageNotification.frame.size.width+30,y: imageNotification.frame.maxY+12,width: alertView.frame.size.width - 20,height: 100))
                lbl_Message.text = String(format:"%@", message as String)
                  lbl_Message.textColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
                  lbl_Message.numberOfLines = 0
                
                  lbl_Message.font = UIFont.systemFont(ofSize: 15.0)

                var ViewFrame1 = lbl_Message.frame
                  ViewFrame1.origin.x = (alertView.frame.width - lbl_Message.frame.width) / 2
                  lbl_Message.frame = ViewFrame1
                  lbl_Message.textAlignment = NSTextAlignment.center
                  alertView.addSubview(lbl_Message)
                viewButtons.frame = CGRect(x: 0, y: lbl_Message.frame.maxY+10,width: alertView.frame.size.width,height: 40)
                viewButtons.backgroundColor =  UIColor.clear
                              alertView.addSubview(viewButtons)
                
                let btnSubmit : UIButton = UIButton()
                           btnSubmit.frame = CGRect(x: 0, y: 0,width: viewButtons.frame.size.width,height: 40)
                           btnSubmit.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
                           viewButtons.addSubview(btnSubmit)
                                btnSubmit.backgroundColor = App_Theme_Blue_Color
                         
                            
                                    btnSubmit.setTitle("OK" as String, for: .normal)
                               
                 btnSubmit.titleLabel?.textColor = UIColor.white
                               
                               btnSubmit.addTarget(delegate, action: Selector(("infoOkButtonOptIn")), for: UIControlEvents.touchUpInside)
                                   viewButtons.frame = CGRect(x: 0, y: lbl_Message.frame.maxY+5,width: alertView.frame.size.width,height: 40)

                               var alertFrame = alertView.frame
                               alertFrame.size.height = viewButtons.frame.maxY
                               alertView.frame = alertFrame
                          
                          
                           alertView.cornerRadius = 10
                           alertView.clipsToBounds = true
            }else {
                 let lbl_Message : UILabel = UILabel (frame: CGRect(x: lblHeading.frame.size.width+30,y: lblHeading.frame.maxY+12,width: alertView.frame.size.width - 20,height: 100))
                  lbl_Message.text = String(format:"%@", message as String)
                  lbl_Message.textColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
                  lbl_Message.numberOfLines = 0
                
                  lbl_Message.font = UIFont.systemFont(ofSize: 15.0)

                  var ViewFrame = lbl_Message.frame
                  ViewFrame.origin.x = (alertView.frame.width - lbl_Message.frame.width) / 2
                  lbl_Message.frame = ViewFrame
                  lbl_Message.textAlignment = NSTextAlignment.center
                  alertView.addSubview(lbl_Message)
                viewButtons.frame = CGRect(x: 0, y: lbl_Message.frame.maxY+10,width: alertView.frame.size.width,height: 40)
                viewButtons.backgroundColor =  UIColor.red
                              alertView.addSubview(viewButtons)
                
                
                let btnSubmit : UIButton = UIButton()
                           btnSubmit.frame = CGRect(x: 0, y: 0,width: viewButtons.frame.size.width,height: 40)
                           btnSubmit.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
                           viewButtons.addSubview(btnSubmit)
                                btnSubmit.backgroundColor = App_Theme_Blue_Color
                        btnSubmit.setTitle("OK" as String, for: .normal)
                btnSubmit.titleLabel?.textColor = UIColor.white
                               
                               btnSubmit.addTarget(delegate, action: Selector(("infoOkButtonOptIn")), for: UIControlEvents.touchUpInside)
                                   viewButtons.frame = CGRect(x: 0, y: lbl_Message.frame.maxY+5,width: alertView.frame.size.width,height: 40)

                               var alertFrame = alertView.frame
                               alertFrame.size.height = viewButtons.frame.maxY
                               alertView.frame = alertFrame
                          
                          
                           alertView.cornerRadius = 10
                           alertView.clipsToBounds = true
            }
            
   
             return alertView_Bg
         }
    
     @objc func pauseandPlayButton(_ sender : UIButton) {
           sender.setImage(UIImage(named: "VideoPauseIcon"), for: .normal)
     
       }
    func gifDidStart(sender: UIImageView) {
        sender.startAnimating()
       }
    
        func gifURLDidFinish(sender: UIImageView) {
            SwiftLoader.hide()
              }
                 func gifURLDidFail(sender: UIImageView) {
                           sender.stopAnimating()
                       }
    class func cropsListPopup(_ delegate: AnyObject, frame : CGRect , tvCrops : UITableView ,tblHeight : CGFloat ) -> AnyObject
    {
        var Height:CGFloat = (50 * frame.height/120)
        var width :CGFloat = frame.size.width-40
        var posX :CGFloat = (frame.size.width - width ) / 2
        var lablHeightPadding :CGFloat = 27
        // unowned(unsafe) var delegate: UITextFieldDelegate?
        
     
        
        let alertView_Bg: UIView = UIView (frame: CGRect(x: 0,y: 0 ,width: frame.size.width,height: frame.size.height))
        
        alertView_Bg.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        
        let alertView: UIView = UIView (frame: CGRect(x: posX,y: (alertView_Bg.frame.height-Height)/2 ,width: width,height: Height))
        alertView.backgroundColor = UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        alertView.layer.cornerRadius = 10.0
        alertView_Bg.addSubview(alertView)
        
        let CloseBtn_View: UIView;
       
        CloseBtn_View = UIView (frame: CGRect(x: alertView.frame.maxX-42,y: alertView.frame.minY-50 ,width: 50,height: 50))
     
        CloseBtn_View.backgroundColor = UIColor.clear
        
        alertView_Bg.addSubview(CloseBtn_View)
        
        let lblHeading : UILabel = UILabel (frame: CGRect(x: 0,y: 0,width: alertView.frame.width,height: ((15 * alertView.frame.height)/100) + 10))
        lblHeading.text = "Select Crop" as String
        lblHeading.textColor = .white//UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 1.0)
        lblHeading.font = UIFont.boldSystemFont(ofSize: 16.0)
        lblHeading.numberOfLines = 0
        lblHeading.backgroundColor = App_Theme_Blue_Color
        lblHeading.textAlignment = NSTextAlignment.center
        alertView.addSubview(lblHeading)
        
        let tblView = UITableView(frame: CGRect(x: 0,y: lblHeading.frame.maxY  ,width: alertView.frame.width,height:tblHeight  ))
        tblView.delegate = delegate as? UITableViewDelegate
        tblView.dataSource = delegate as? UITableViewDataSource
        tblView.isScrollEnabled = false
        alertView.addSubview(tblView)
        
        let closeBtn : UIButton = UIButton (frame: CGRect(x: lblHeading.frame.maxX - 40, y: 0,width: 40,height: 40))
        closeBtn.backgroundColor = UIColor.clear//UIColorFromRGB(headerBlueCOlor, alpha: 1)
        
        closeBtn.setImage(UIImage(named: "CropDetailsDeleteImg"), for: UIControlState())
        closeBtn.setTitle("", for: UIControlState())
//        closeBtn.layer.cornerRadius = closeBtn.frame.width/2
        // closeBtn.titleLabel!.font = GRAPHICS.FONT_REGULAR(16)
        closeBtn.addTarget(delegate, action: Selector(("infoCloseButton")), for: UIControlEvents.touchUpInside)
        alertView.addSubview(closeBtn)
                
        var alertFrame = alertView.frame
        alertFrame.origin.y = (frame.size.height - alertFrame.size.height) / 2
        alertView.frame = alertFrame
        
        
//        CloseBtn_View.frame =  CGRect(x: alertView.frame.maxX-22,y: alertView.frame.minY-25 ,width: 50,height: 50)
        
        
        //         closeBtn.frame  =  CGRectMake(10, 10,CGRectGetWidth(CloseBtn_View.frame)-20,CGRectGetHeight(CloseBtn_View.frame)-20)
        
//        let tapGestureForClose = UITapGestureRecognizer(target: delegate, action: Selector(("infoAlertClose")))
//        closeBtn.addGestureRecognizer(tapGestureForClose)
        alertView.cornerRadius = 10
        alertView.clipsToBounds = true
        return alertView_Bg
    }
    
    class func loadingGifPopup(_ delegate: AnyObject, frame : CGRect , imgLoader : UIImage , loaderImgs : [UIImage]  ) -> AnyObject
        {
            var Height:CGFloat = (50 * frame.height/120)
            var width :CGFloat = frame.size.width-40
            var posX :CGFloat = (frame.size.width - width ) / 2
            var lablHeightPadding :CGFloat = 27
            // unowned(unsafe) var delegate: UITextFieldDelegate?
            
         
            
            let alertView_Bg: UIView = UIView (frame: CGRect(x: 0,y: 0 ,width: frame.size.width,height: frame.size.height))
            
            alertView_Bg.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
            
            let alertView: UIView = UIView (frame: CGRect(x: posX,y: (alertView_Bg.frame.height-Height)/2 ,width: width,height: Height))
          //  alertView.backgroundColor = UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
            alertView.layer.cornerRadius = 10.0
            alertView.backgroundColor = UIColor.clear
            alertView_Bg.addSubview(alertView)
            
           
            let imgView = UIImageView(frame: CGRect(x: (alertView.frame.width)/2-50 ,y: ((15 * alertView.frame.height)/100)  ,width: 100 ,height:100  ))
            imgView.contentMode = .scaleAspectFit
//             let jeremyGif = UIImage.gifImageWithName("loader")
          //  imgView.image = UIImage.gif(name: "loader")  //animatedImage(with: loaderImgs, duration: 4)
            imgView.backgroundColor = UIColor.clear
//            imgView.animationRepeatCount = -1
            alertView.addSubview(imgView)
            
            let lblHeading : UILabel = UILabel (frame: CGRect(x: 0,y: imgView.frame.maxY + 20 ,width: alertView.frame.width,height: ((15 * alertView.frame.height)/100) + 10))
                        lblHeading.text = "Finding Crop ...." as String
                        lblHeading.textColor = .white//UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 1.0)
                        lblHeading.font = UIFont.boldSystemFont(ofSize: 16.0)
                        lblHeading.numberOfLines = 0
//                        lblHeading.backgroundColor = App_Theme_Blue_Color
                        lblHeading.textAlignment = NSTextAlignment.center
                        alertView.addSubview(lblHeading)
            
            var alertFrame = alertView.frame
            alertFrame.origin.y = (frame.size.height - alertFrame.size.height) / 2
            alertView.frame = alertFrame

            alertView.cornerRadius = 10
            alertView.clipsToBounds = true
            return alertView_Bg
        }
    class func whatsappAlertPopUpView(_ delegate: AnyObject, frame : CGRect, message : NSString, cancelButtonTitle : String , okButtonTitle : String) -> AnyObject
    {
        let Height:CGFloat = (33.11 * frame.height/120)
        let width :CGFloat = frame.size.width-40
        let posX :CGFloat = (frame.size.width - width ) / 2
        let lablHeightPadding :CGFloat = 27

        //alert view background
        let alertView_Bg: UIView = UIView (frame: CGRect(x: 0,y: 0 ,width: frame.size.width,height: frame.size.height))
        alertView_Bg.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)

        //alert view
        let alertView: UIView = UIView (frame: CGRect(x: posX,y: (alertView_Bg.frame.height-Height)/2 ,width: width,height: Height))
        alertView.backgroundColor = UIColor.white //UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        alertView.layer.cornerRadius = 10.0
        alertView_Bg.addSubview(alertView)
        
        
        //alert message
        let alertMessageLbl : UILabel = UILabel (frame: CGRect(x: 5,y: 12,width: alertView.frame.width - 10,height: ((lablHeightPadding * alertView.frame.height)/100)))
        alertMessageLbl.text = message as String
        alertMessageLbl.textColor = UIColor.black//UIColor(red: 0.0/255, green: 128.0/255, blue: 43.0/255, alpha: 1)
        //UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        alertMessageLbl.font = UIFont (name: "Lato-Bold", size:11)
        alertMessageLbl.numberOfLines = 0
        alertMessageLbl.sizeToFit()
        
        var ViewFrame = alertMessageLbl.frame
        ViewFrame.origin.x = (alertView.frame.width - alertMessageLbl.frame.width) / 2
        alertMessageLbl.frame = ViewFrame
        alertMessageLbl.textAlignment = NSTextAlignment.center
        alertView.addSubview(alertMessageLbl)
        
        //let noBtn : UIButton?
        
            //NO button
             let noBtn : UIButton  = UIButton (frame: CGRect(x:0 , y: alertMessageLbl.frame.maxY+((20.5 * alertView.frame.height)/100),width: width/2,height: 35))
            noBtn.backgroundColor = App_Theme_Orange_Color//UIColor(red: 255.0/255, green: 179.0/255, blue: 102.0/255, alpha: 0.8)
            noBtn.layer.cornerRadius = 1.0
            //rgb(255, 179, 102)
            noBtn.setTitle(cancelButtonTitle, for: UIControlState())
            noBtn.addTarget(delegate, action: Selector(("alertCancelAction")), for: UIControlEvents.touchUpInside)
            alertView.addSubview(noBtn)
            
            //YES button
            let yesBtn : UIButton = UIButton (frame: CGRect(x: noBtn.frame.size.width+0.1, y: alertMessageLbl.frame.maxY+((20.5 * alertView.frame.height)/100), width: width/2,height: 35))
            yesBtn.backgroundColor = App_Theme_Blue_Color
                //UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 0.8)

            yesBtn.layer.cornerRadius = 1.0
            yesBtn.setTitle(okButtonTitle, for: UIControlState())
            yesBtn.addTarget(delegate, action: Selector(("alertSubmitAction")), for: UIControlEvents.touchUpInside)
            alertView.addSubview(yesBtn)
            
            var alertFrame = alertView.frame
            alertFrame.size.height = yesBtn.frame.maxY
            alertFrame.size.height = (noBtn.frame.maxY)
            alertView.frame = alertFrame
            
            alertFrame.origin.y = (frame.size.height - 64 - alertFrame.size.height) / 2
            alertView.frame = alertFrame
        return alertView_Bg
    }
    
}
class CustomSlider: UISlider {

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 5.0))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }

}
extension UIButton {
     //UIButton properties
//     func btnMultipleLines() {
//         button.titleLabel?.numberOfLines = 0
//         titleLabel?.lineBreakMode = .byWordWrapping
//         titleLabel?.textAlignment = .center
//     }
}
