//
//  TransactionDetailsPopOverViewController.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 31/12/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import UIKit
import Alamofire


class TransactionDetailsPopOverViewController: BaseViewController {

    @IBOutlet weak var tblViewDetails: UITableView!
    var successTransactions = [TransactionModel]()
    var referenceId : String?
    var amount : String?
    var seadId: Int = 0
    var dsrId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let params : NSMutableDictionary = ["referenceId" : referenceId, "seadProgramId": seadId, "dsrProgramId": dsrId]
        self.requestToGetgetFarmerRewards(params: params )

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.topView?.isHidden = false
        self.homeButton?.isHidden = true
        self.lblTitle?.text = NSLocalizedString("transction_details", comment: "")//"Transaction Details"
        //self.backButton?.setImage(UIImage(named: "delete-white"), for: .normal)
        //self.backButton?.frame = CGRect(x: (self.lblTitle?.frame.size.width)!+5, y: 10, width: 30, height: 30)

//        self.backButton?.isHidden = true
        
    }
    override func backButtonClick(_ sender: UIButton) {
        self.dismiss(animated: true) {
            
        }
    }

    func requestToGetgetFarmerRewards(params : NSMutableDictionary){
        SwiftLoader.show(animated: true)
        let headers = Constatnts.getLoggedInFarmerHeaders()
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_CASHFREE_SUCCESS_TRANSACTION_DETAILS]  ) // // ["http://192.168.3.141:8080/ATP/rest/" ,"cashFreeReward/getCashFreeTransactionPendingRequest_V2"]
        let paramsStr = Constatnts.nsobjectToJSON(params )
        let params =  ["data" : paramsStr]
        print(headers)
        Alamofire.request(urlString, method: .post, parameters :  params , encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        print("Response after decrypting data:\(decryptData)")
                        let userObj = Constatnts.getUserObject()
                        //                         let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"serverID" : self.arrayTransactions[0].serverID ] as [String : Any]
                        //
                        //                          self.registerFirebaseEvents(Reclaim, userObj.mobileNumber as String? ?? "", userObj.customerId as String? ?? "", CashFreeRewards , parameters: fireBaseParams as NSDictionary)
                        
                        if let successTrans = decryptData.value(forKey: "cashFreeTransactionList") as? NSArray {
                            self.successTransactions.removeAll()
                            if successTrans.count > 0 {
                                for i in successTrans {
                                    let arrTrans = TransactionModel()
                                    arrTrans.amount = (i as AnyObject).value(forKey: "amount") as? String ?? ""
                                    arrTrans.beneId = (i as AnyObject).value(forKey: "beneId") as? String ?? ""
                                    arrTrans.cashRewards = (i as AnyObject).value(forKey: "cashRewards") as? String ?? ""
                                    arrTrans.cgUrl = (i as AnyObject).value(forKey: "cgUrl") as? String ?? ""
                                    arrTrans.mobileNumber = (i as AnyObject).value(forKey: "mobileNumber") as? String ?? ""
                                    arrTrans.transferMode = (i as AnyObject).value(forKey: "transferMode") as? String ?? ""
                                    arrTrans.createdOn = (i as AnyObject).value(forKey: "createdOn") as? String ?? ""
                                    arrTrans.status = (i as AnyObject).value(forKey: "status") as? String ?? ""
                                    arrTrans.referenceId = (i as AnyObject).value(forKey: "referenceId") as? String ?? ""
                                    print((i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0)
                                    arrTrans.cashFreeTransactionId = (i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0
                                    arrTrans.transferId = (i as AnyObject).value(forKey: "transferId") as? String ?? ""
                                    arrTrans.id = (i as AnyObject).value(forKey: "id") as? String ?? ""
                                    arrTrans.message = (i as AnyObject).value(forKey: "message") as? String ?? ""
                                    arrTrans.modifiedOn = (i as AnyObject).value(forKey: "modifiedOn") as? String ?? ""
                                    arrTrans.buttonText =  (i as AnyObject).value(forKey: "buttonText") as? String ?? ""
                                    arrTrans.serverRecordId = (i as AnyObject).value(forKey: "serverRecordId") as? String ?? ""
                                    arrTrans.benfTransactionId = (i as AnyObject).value(forKey: "benfTransactionId") as? String ?? ""
                                    arrTrans.productName = (i as AnyObject).value(forKey: "productName") as? String ?? ""
                                    arrTrans.prodSerialNumber = (i as AnyObject).value(forKey: "prodSerialNumber") as? String ?? ""
                                    arrTrans.showView = (i as AnyObject).value(forKey: "showView") as? Bool ?? false
                                    self.successTransactions.append(arrTrans)
                                }
                                
                            }
                            self.tblViewDetails.reloadData()
                        }else if let successTrans = decryptData.value(forKey: "eCouponTransactionList") as? NSArray{
                            self.successTransactions.removeAll()
                            if successTrans.count > 0 {
                                for i in successTrans {
                                    let arrTrans = TransactionModel()
                                    arrTrans.amount = (i as AnyObject).value(forKey: "amount") as? String ?? ""
                                    arrTrans.beneId = (i as AnyObject).value(forKey: "beneId") as? String ?? ""
                                    arrTrans.cashRewards = (i as AnyObject).value(forKey: "cashRewards") as? String ?? ""
                                    arrTrans.cgUrl = (i as AnyObject).value(forKey: "cgUrl") as? String ?? ""
                                    arrTrans.mobileNumber = (i as AnyObject).value(forKey: "mobileNumber") as? String ?? ""
                                    arrTrans.transferMode = (i as AnyObject).value(forKey: "transferMode") as? String ?? ""
                                    arrTrans.createdOn = (i as AnyObject).value(forKey: "createdOn") as? String ?? ""
                                    arrTrans.status = (i as AnyObject).value(forKey: "status") as? String ?? ""
                                    arrTrans.referenceId = (i as AnyObject).value(forKey: "referenceId") as? String ?? ""
                                    print((i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0)
                                    arrTrans.cashFreeTransactionId = (i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0
                                    arrTrans.transferId = (i as AnyObject).value(forKey: "transferId") as? String ?? ""
                                    arrTrans.id = (i as AnyObject).value(forKey: "id") as? String ?? ""
                                    arrTrans.message = (i as AnyObject).value(forKey: "message") as? String ?? ""
                                    arrTrans.modifiedOn = (i as AnyObject).value(forKey: "modifiedOn") as? String ?? ""
                                    arrTrans.buttonText =  (i as AnyObject).value(forKey: "buttonText") as? String ?? ""
                                    arrTrans.serverRecordId = (i as AnyObject).value(forKey: "serverRecordId") as? String ?? ""
                                    arrTrans.benfTransactionId = (i as AnyObject).value(forKey: "benfTransactionId") as? String ?? ""
                                    arrTrans.productName = (i as AnyObject).value(forKey: "productName") as? String ?? ""
                                    arrTrans.prodSerialNumber = (i as AnyObject).value(forKey: "prodSerialNumber") as? String ?? ""
                                    arrTrans.showView = (i as AnyObject).value(forKey: "showView") as? Bool ?? false
                                    self.successTransactions.append(arrTrans)
                                }
                                
                            }
                            self.tblViewDetails.reloadData()
                        }else if  let successTrans = decryptData.value(forKey: "seedTransactionList") as? NSArray{
                            self.successTransactions.removeAll()
                            if successTrans.count > 0 {
                                for i in successTrans {
                                    let arrTrans = TransactionModel()
                                    arrTrans.amount = (i as AnyObject).value(forKey: "amount") as? String ?? ""
                                    arrTrans.beneId = (i as AnyObject).value(forKey: "beneId") as? String ?? ""
                                    arrTrans.cashRewards = (i as AnyObject).value(forKey: "cashRewards") as? String ?? ""
                                    arrTrans.cgUrl = (i as AnyObject).value(forKey: "cgUrl") as? String ?? ""
                                    arrTrans.mobileNumber = (i as AnyObject).value(forKey: "mobileNumber") as? String ?? ""
                                    arrTrans.transferMode = (i as AnyObject).value(forKey: "transferMode") as? String ?? ""
                                    arrTrans.createdOn = (i as AnyObject).value(forKey: "createdOn") as? String ?? ""
                                    arrTrans.status = (i as AnyObject).value(forKey: "status") as? String ?? ""
                                    arrTrans.referenceId = (i as AnyObject).value(forKey: "referenceId") as? String ?? ""
                                    print((i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0)
                                    arrTrans.cashFreeTransactionId = (i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0
                                    arrTrans.transferId = (i as AnyObject).value(forKey: "transferId") as? String ?? ""
                                    arrTrans.id = (i as AnyObject).value(forKey: "id") as? String ?? ""
                                    arrTrans.message = (i as AnyObject).value(forKey: "message") as? String ?? ""
                                    arrTrans.modifiedOn = (i as AnyObject).value(forKey: "modifiedOn") as? String ?? ""
                                    arrTrans.buttonText =  (i as AnyObject).value(forKey: "buttonText") as? String ?? ""
                                    arrTrans.serverRecordId = (i as AnyObject).value(forKey: "serverRecordId") as? String ?? ""
                                    arrTrans.benfTransactionId = (i as AnyObject).value(forKey: "benfTransactionId") as? String ?? ""
                                    arrTrans.productName = (i as AnyObject).value(forKey: "productName") as? String ?? ""
                                    arrTrans.prodSerialNumber = (i as AnyObject).value(forKey: "prodSerialNumber") as? String ?? ""
                                    arrTrans.showView = (i as AnyObject).value(forKey: "showView") as? Bool ?? false
                                    self.successTransactions.append(arrTrans)
                                }
                            }
                            self.tblViewDetails.reloadData()
                        }else if  let successTrans = decryptData.value(forKey: "seedTwoTransactionList") as? NSArray{
                            self.successTransactions.removeAll()
                            if successTrans.count > 0 {
                                for i in successTrans {
                                    let arrTrans = TransactionModel()
                                    arrTrans.amount = (i as AnyObject).value(forKey: "amount") as? String ?? ""
                                    arrTrans.beneId = (i as AnyObject).value(forKey: "beneId") as? String ?? ""
                                    arrTrans.cashRewards = (i as AnyObject).value(forKey: "cashRewards") as? String ?? ""
                                    arrTrans.cgUrl = (i as AnyObject).value(forKey: "cgUrl") as? String ?? ""
                                    arrTrans.mobileNumber = (i as AnyObject).value(forKey: "mobileNumber") as? String ?? ""
                                    arrTrans.transferMode = (i as AnyObject).value(forKey: "transferMode") as? String ?? ""
                                    arrTrans.createdOn = (i as AnyObject).value(forKey: "createdOn") as? String ?? ""
                                    arrTrans.status = (i as AnyObject).value(forKey: "status") as? String ?? ""
                                    arrTrans.referenceId = (i as AnyObject).value(forKey: "referenceId") as? String ?? ""
                                    print((i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0)
                                    arrTrans.cashFreeTransactionId = (i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0
                                    arrTrans.transferId = (i as AnyObject).value(forKey: "transferId") as? String ?? ""
                                    arrTrans.id = (i as AnyObject).value(forKey: "id") as? String ?? ""
                                    arrTrans.message = (i as AnyObject).value(forKey: "message") as? String ?? ""
                                    arrTrans.modifiedOn = (i as AnyObject).value(forKey: "modifiedOn") as? String ?? ""
                                    arrTrans.buttonText =  (i as AnyObject).value(forKey: "buttonText") as? String ?? ""
                                    arrTrans.serverRecordId = (i as AnyObject).value(forKey: "serverRecordId") as? String ?? ""
                                    arrTrans.benfTransactionId = (i as AnyObject).value(forKey: "benfTransactionId") as? String ?? ""
                                    arrTrans.productName = (i as AnyObject).value(forKey: "productName") as? String ?? ""
                                    arrTrans.prodSerialNumber = (i as AnyObject).value(forKey: "prodSerialNumber") as? String ?? ""
                                    arrTrans.showView = (i as AnyObject).value(forKey: "showView") as? Bool ?? false
                                    self.successTransactions.append(arrTrans)
                                }
                        }
                        self.tblViewDetails.reloadData()
                        }else if  let successTrans = decryptData.value(forKey: "dsrTransactionList") as? NSArray{
                            self.successTransactions.removeAll()
                            if successTrans.count > 0 {
                                for i in successTrans {
                                    let arrTrans = TransactionModel()
                                    arrTrans.amount = (i as AnyObject).value(forKey: "amount") as? String ?? ""
                                    arrTrans.beneId = (i as AnyObject).value(forKey: "beneId") as? String ?? ""
                                    arrTrans.cashRewards = (i as AnyObject).value(forKey: "cashRewards") as? String ?? ""
                                    arrTrans.cgUrl = (i as AnyObject).value(forKey: "cgUrl") as? String ?? ""
                                    arrTrans.mobileNumber = (i as AnyObject).value(forKey: "mobileNumber") as? String ?? ""
                                    arrTrans.transferMode = (i as AnyObject).value(forKey: "transferMode") as? String ?? ""
                                    arrTrans.createdOn = (i as AnyObject).value(forKey: "createdOn") as? String ?? ""
                                    arrTrans.status = (i as AnyObject).value(forKey: "status") as? String ?? ""
                                    arrTrans.referenceId = (i as AnyObject).value(forKey: "referenceId") as? String ?? ""
                                    print((i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0)
                                    arrTrans.cashFreeTransactionId = (i as AnyObject).value(forKey: "cashFreeTransactionId") as? Int ?? 0
                                    arrTrans.transferId = (i as AnyObject).value(forKey: "transferId") as? String ?? ""
                                    arrTrans.id = (i as AnyObject).value(forKey: "id") as? String ?? ""
                                    arrTrans.message = (i as AnyObject).value(forKey: "message") as? String ?? ""
                                    arrTrans.modifiedOn = (i as AnyObject).value(forKey: "modifiedOn") as? String ?? ""
                                    arrTrans.buttonText =  (i as AnyObject).value(forKey: "buttonText") as? String ?? ""
                                    arrTrans.serverRecordId = (i as AnyObject).value(forKey: "serverRecordId") as? String ?? ""
                                    arrTrans.benfTransactionId = (i as AnyObject).value(forKey: "benfTransactionId") as? String ?? ""
                                    arrTrans.productName = (i as AnyObject).value(forKey: "productName") as? String ?? ""
                                    arrTrans.prodSerialNumber = (i as AnyObject).value(forKey: "prodSerialNumber") as? String ?? ""
                                    arrTrans.showView = (i as AnyObject).value(forKey: "showView") as? Bool ?? false
                                    self.successTransactions.append(arrTrans)
                                }
                            }
                            self.tblViewDetails.reloadData()
                        }
                    }
                    else if responseStatusCode == STATUS_CODE_601{
                        Constatnts.logOut()
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    }else if responseStatusCode == STATUS_CODE_500{
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast("Please try Again later")
                        }
                    }else if responseStatusCode == STATUS_CODE_105{
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }else   {
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    }
                }
            }
            else{
                self.view.makeToast((response.error?.localizedDescription)!)
            }
        }
    }

}

extension TransactionDetailsPopOverViewController  : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let referenceID = NSLocalizedString("referenceId", comment: "")
        //return String(format:"Reference Id - %@",self.referenceId ?? "0")
        return String(format:"\(referenceID) - %@",self.referenceId ?? "0")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.successTransactions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0;
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
            let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
            header.frame = CGRect(x: 10, y: header.frame.origin.y, width: header.frame.size.width-20, height: 40)
            header.contentView.backgroundColor = App_Theme_Blue_Color
            header.textLabel?.textColor = UIColor.white
            
            header.textLabel?.font = UIFont.systemFont(ofSize: 15.0)
        header.textLabel?.text = header.textLabel?.text?.capitalized
            header.textLabel?.isUserInteractionEnabled = false
            let headerFrame = self.view.frame.size
            
            // header.contentView.addBorder(toSide: .Top, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: header.contentView.frame.size.height-1, height: 1.0)
            header.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: 50)
            // header.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: header.frame.size.width-1, yValue: 0, height: 50)
        let rupee = "\u{20B9} "

        var headerSubTitle = UILabel()
        headerSubTitle = UILabel(frame: CGRect(x:
            headerFrame.width - 120, y: 0, width: 100, height: 50));
        headerSubTitle.isUserInteractionEnabled = false
//        headerSubTitle.text = String(format:"%@ %.2f", rupee, Double(self.amount?) as? CVarArg ?? 0.00)
        let double = Double(amount ?? "0")
        headerSubTitle.text = String(format: "%@ %.2f", rupee, double ?? 0.00 )
        headerSubTitle.textColor = UIColor.white
//        headerSubTitle.tag = kHeaderSectionTag + section
        //headerSubTitle.tag = kHeaderSectionTag + section
        header.addSubview(headerSubTitle)
//        header.addSubview(theImageView)
    
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell =  tblViewDetails.dequeueReusableCell(withIdentifier: "transactionDetailsCell", for: indexPath) as! TransactionPopOverTableViewCell
            let rupee = "\u{20B9} "
        
            cell.lblAmount.text =  rupee + self.successTransactions[indexPath.row].cashRewards
            cell.lblStatus.text = self.successTransactions[indexPath.row].status
            cell.lblReferrenceId.text = self.successTransactions[indexPath.row].prodSerialNumber
            cell.lblProductName.text = self.successTransactions[indexPath.row].productName
        
//            cell.btnReclaim.isHidden = true
//            cell.reclaimHgtConstraint.constant = 0
        
        cell.contentView.addBorder(toSide: .Left, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: 0, yValue: 0, height: cell.contentView.frame.size.height)
        cell.contentView.addBorder(toSide: .Right, withColor: UIColor.lightGray.cgColor, andThickness: 1.0, xValue: cell.contentView.frame.size.height-1, yValue: 0, height: cell.contentView.frame.size.height)
        
            return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        let separatorView = UIView(frame: CGRect(x: tableView.separatorInset.left, y: footerView.frame.height, width: tableView.frame.width - tableView.separatorInset.right - tableView.separatorInset.left, height: 0))
        separatorView.backgroundColor = UIColor.separatorColor
        footerView.addSubview(separatorView)
        return footerView
    }
    
    
}
