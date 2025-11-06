//
//  ProviderBaseViewController.swift
//  FarmerConnect
//
//  Created by Admin on 19/12/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit
import Alamofire

class ProviderBaseViewController: UIViewController {

    var topView : UIView?
    var backButton : UIButton?
    var homeButton : UIButton?
    var topImageView : UIImageView?
    var btnCart : UIButton?
    var lblCouponCount : UILabel?
    var lblWaterMarlLabel : UILabel?
    var btnFilter : UIButton?
    var btnClear : UIButton?
    
    /// custom Title (label) of Navigation bar
    var lblTitle : UILabel?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true
        
        self.topView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        self.topView?.backgroundColor = App_Theme_Blue_Color
        
        topView?.layer.borderWidth = 0.2
        topView?.layer.cornerRadius = 1.0
        topView?.layer.borderColor = UIColor.lightGray.cgColor
        topView?.layer.masksToBounds = false
        topView?.layer.shadowOffset = CGSize.init(width: 0.2, height: 0.2)
        topView?.layer.shadowRadius = 0.3
        topView?.layer.shadowOpacity = 0.5
        
        self.backButton = UIButton(type: .custom)
        self.backButton?.frame = CGRect(x: 2, y: 5, width: 45, height: 45)
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        self.backButton?.addTarget(self, action: #selector(ProviderBaseViewController.backButtonClick(_:)), for: .touchUpInside)
        topView?.addSubview(backButton!)
        
        self.lblTitle = UILabel(frame: CGRect(x: 65, y: 10, width: topView!.frame.size.width - 55, height: 35))
        self.lblTitle?.textColor = UIColor.white    //UIColor(red:34.0/255.0, green:119.0/255.0, blue:45.0/255.0, alpha:1.0)
        self.lblTitle?.font = UIFont.boldSystemFont(ofSize: 20)//UIFont(name: "HelveticaNeueBold", size: 18.0)
        topView?.addSubview(lblTitle!)
        
        self.btnCart = UIButton(type: .custom)
        self.btnCart?.frame = CGRect(x: (lblTitle?.frame.size.width)!+5, y: 5, width: 30, height: 40)
        self.btnCart?.setImage(UIImage(named:"Cart"), for: .normal)
        self.btnCart?.addTarget(self, action: #selector(ProviderBaseViewController.homeButtonClick(_:)), for: .touchUpInside)
        btnCart?.isHidden = true
        //topView?.addSubview(btnCart!)
        
        self.btnFilter = UIButton(type: .custom)
        self.btnFilter?.frame = CGRect(x: (topView?.frame.size.width)!-50, y: 15, width: 25, height: 25)
        self.btnFilter?.setImage(UIImage(named:"Filter"), for: UIControlState())
        self.btnFilter?.addTarget(self, action: #selector(ProviderBaseViewController.filterButtonClick(_:)), for: .touchUpInside)
        topView?.addSubview(btnFilter!)
        
        self.btnClear = UIButton(type: .custom)
        self.btnClear?.frame = CGRect(x: (topView?.frame.size.width)!-100 , y: 15, width: 80, height: 30)
        
        self.btnClear?.setTitle(NSLocalizedString("clear", comment: ""), for: .normal)
        self.btnClear?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        //self.btnReset?.setImage(UIImage(named:"FabDetailsPdfIcon"), for: UIControlState())
        self.btnClear?.addTarget(self, action: #selector(ProviderBaseViewController.clearButtonClick(_:)), for: .touchUpInside)
        topView?.addSubview(btnClear!)
        
        self.lblWaterMarlLabel = UILabel(frame: CGRect(x: 10, y: 25, width: self.view.frame.size.width - 20, height: self.view.frame.size.height))
        self.lblWaterMarlLabel?.textColor = UIColor.gray.withAlphaComponent(0.95)
        self.lblWaterMarlLabel?.textAlignment = .center
        self.lblWaterMarlLabel?.numberOfLines = 0
        self.lblWaterMarlLabel?.font = UIFont.systemFont(ofSize: 16)
        self.lblWaterMarlLabel?.isHidden = true
        self.view.addSubview(lblWaterMarlLabel!)
        
        self.navigationController?.navigationBar.addSubview(topView!)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        btnCart?.isHidden = true
        btnFilter?.isHidden = true
        btnClear?.isHidden = true
        self.topView?.isHidden = false
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.topView?.isHidden = true
    }
    
    func hideFilterButton(_ show: Bool){
        self.btnFilter?.isHidden = show
    }
    
    func hideClearButton(_ show: Bool){
        self.btnClear?.isHidden = show
    }
    
    @objc func filterButtonClick(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func clearButtonClick(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func showBackButton(_ show: Bool){
        if (!show) {
            self.btnCart?.frame = CGRect(x: (lblTitle?.frame.size.width)!+5, y: 10, width: 30, height: 30)
        }
        else{
            topImageView!.frame = CGRect(x: 0, y: 5, width: topView!.frame.size.width, height: 45);
        }
    }
    
    func showCartButton(_ show: Bool){
        self.btnCart?.frame = CGRect(x: (lblTitle?.frame.size.width)!+5, y: 10, width: 30, height: 30)
        self.btnCart?.isHidden = show
    }
    /**
     This method is used to enable dropdown for the textfields
     */
    func loadDropDownTableView(tableViewDataSource: UITableViewDataSource,tableViewDelegate:UITableViewDelegate,tableview:UITableView,textField:UITextField){
        
        tableview.isScrollEnabled = true
        tableview.isHidden = true
        tableview.layer.borderWidth = 0.5
        tableview.layer.borderColor = UIColor.gray.cgColor
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.tableFooterView = UIView()
        tableview.dataSource = tableViewDataSource
        tableview.delegate = tableViewDelegate
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.view.addSubview(tableview)
        
        let xConstraint = NSLayoutConstraint.init(item: tableview, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem:textField , attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0) as NSLayoutConstraint
        let yConstraint = NSLayoutConstraint.init(item: tableview, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem:textField , attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0) as NSLayoutConstraint
        let widthConstraint = NSLayoutConstraint.init(item: tableview, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem:textField , attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0.0) as NSLayoutConstraint
        let heightConstraint = NSLayoutConstraint.init(item: tableview, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem:textField , attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 120) as NSLayoutConstraint //height constant : 120
        
        self.view.addConstraints([xConstraint,yConstraint,widthConstraint,heightConstraint])
    }
    func getProviderHeaders() -> HTTPHeaders{
        let userObj = Constatnts.getUserObject()
        let headers : HTTPHeaders = ["userAuthorizationToken": userObj.userAuthorizationToken! as String,"mobileNumber":userObj.mobileNumber! as String,"customerId": userObj.customerId! as String,"deviceToken":userObj.deviceToken as String,"deviceId":userObj.deviceId! as String]
        return headers
    }
    @objc func backButtonClick(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func homeButtonClick(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func addNoDetailsFoundLabelFotterToTableView(tableView: UITableView,message: String){
        let tableFooterView = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.maxX, height: 60))
        tableFooterView.text = message
        tableFooterView.sizeToFit()
        tableFooterView.font = UIFont.systemFont(ofSize: 15.0)
        tableFooterView.textAlignment = NSTextAlignment.center
        tableView.tableFooterView = tableFooterView
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

