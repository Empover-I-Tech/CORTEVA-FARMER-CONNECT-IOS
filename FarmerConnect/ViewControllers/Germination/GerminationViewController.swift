//
//  GerminationViewController.swift
//  PioneerEmployee
//
//  Created by Empover on 08/08/18.
//  Copyright © 2018 Empover. All rights reserved.
//

import UIKit
import Alamofire

enum SectionTitle: String{
    case pendingAgreement = "Scheme(s) Available"
    case policySubscribed = "Scheme(s) Enrolled"
    case claimStatus = "Scheme(s) Claimed Status"
}

class GerminationViewController: BaseViewController {

    @IBOutlet var tblViewGermination: UITableView?
    var mutArrayToDisplayData = NSMutableArray()
    var outputDict: NSDictionary?
    var isFromHome :Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tblViewGermination?.estimatedRowHeight = 150
        tblViewGermination?.rowHeight = UITableViewAutomaticDimension
        tblViewGermination?.tableFooterView = UIView()
        tblViewGermination?.separatorStyle = .none
        tblViewGermination?.dataSource = self
        tblViewGermination?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 10.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        super.viewWillAppear(true)
        lblTitle?.text = "Germination"
        self.topView?.isHidden = false
        if isFromHome == false {
            self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
        }
        else{
            self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        }
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            GerminationServiceManager.getGerminationList(completionHandler: {(success,responseDict,errorMessage) in
                if success == true{
                   self.parseResponseOutput(respDict: responseDict)
                    DispatchQueue.main.async {
                        self.tblViewGermination?.reloadData()
                    }
                }
            })
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
        
//        let sampleRowsArray = ["Row1","Row2","Row3"]
//        let pendingAgreementSection = GerminationSection(name: SectionTitle.pendingAgreement.rawValue, items: sampleRowsArray as NSArray)
//        mutArrayToDisplayData.add(pendingAgreementSection)
//        
//        let pendingClaimSection = GerminationSection(name: SectionTitle.policySubscribed.rawValue, items: sampleRowsArray as NSArray)
//        mutArrayToDisplayData.add(pendingClaimSection)
//
//        let claimedSection = GerminationSection(name: SectionTitle.claimStatus.rawValue, items: sampleRowsArray as NSArray)
//        mutArrayToDisplayData.add(claimedSection)
    }
    
    //MARK : backButtonClick
    override func backButtonClick(_ sender: UIButton) {
        if isFromHome == false {
            self.findHamburguerViewController()?.showMenuViewController()
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: parseResponseOutput
    func parseResponseOutput(respDict:NSDictionary?){
        //print("respDict :\(respDict ?? NSDictionary())")
        self.mutArrayToDisplayData.removeAllObjects()
        if let pendingAgreementObj = respDict?.value(forKey: "pendingAgreement") as? NSArray{
            if pendingAgreementObj.count > 0{
                let tempPendingArray = NSMutableArray()
                for i in 0..<(pendingAgreementObj.count){
                    let pendingGermination = GerminationList(dict: pendingAgreementObj.object(at: i) as! NSDictionary)
                    tempPendingArray.add(pendingGermination)
                }
                let pendingAgreementSection = GerminationSection(name: SectionTitle.pendingAgreement.rawValue, items: tempPendingArray as NSArray)
                mutArrayToDisplayData.add(pendingAgreementSection)
            }
        }
        if let policySubcribedObj = respDict?.value(forKey: "policySubcribed") as? NSArray{
            if policySubcribedObj.count > 0{
                let tempPolicySubscribedArray = NSMutableArray()
                for i in 0..<(policySubcribedObj.count){
                    let policySubscribedGermination = GerminationPolicySubscribed(dict: policySubcribedObj.object(at: i) as! NSDictionary)
                    tempPolicySubscribedArray.add(policySubscribedGermination)
                }
                let policySubscribedSection = GerminationSection(name: SectionTitle.policySubscribed.rawValue, items: tempPolicySubscribedArray as NSArray)
                mutArrayToDisplayData.add(policySubscribedSection)
            }
        }
        if let policyClaimedStatusObj = respDict?.value(forKey: "policyClaimedStatus") as? NSArray{
            if policyClaimedStatusObj.count > 0{
                let tempClaimedStatusArray = NSMutableArray()
                for i in 0..<(policyClaimedStatusObj.count){
                    let policyClaimedGermination = GerminationPolicySubscribed(dict: policyClaimedStatusObj.object(at: i) as! NSDictionary)
                    tempClaimedStatusArray.add(policyClaimedGermination)
                }
                let policyClaimedSection = GerminationSection(name: SectionTitle.claimStatus.rawValue, items: tempClaimedStatusArray as NSArray)
                mutArrayToDisplayData.add(policyClaimedSection)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func subscribeBtnClick(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint(x:0,y:0), to: tblViewGermination)
        let indexPath = self.tblViewGermination!.indexPathForRow(at: buttonPosition)
        //let sectionData = mutArrayToDisplayData.object(at: (indexPath?.section)!) as? GerminationSection
        //print("selected :\(sectionData?.name ?? ""), row :\(indexPath?.row)")
    
        let titleToCheck = (mutArrayToDisplayData.object(at: (indexPath?.section)!) as! GerminationSection).name
        if titleToCheck == SectionTitle.pendingAgreement.rawValue{
            let pendingDictObj = ((mutArrayToDisplayData.object(at: (indexPath?.section)!) as! GerminationSection).items as NSArray).object(at: (indexPath?.row)!) as? GerminationList
            let germinationAlert = GerminationAlertView(frame: self.view.frame, germination: pendingDictObj!)
            germinationAlert.successHandler = {(status, acres) in
                germinationAlert.removeFromSuperview()
                if status == true{
                    let toGerminationAgreementVC = self.storyboard?.instantiateViewController(withIdentifier: "GerminationAgreementViewController") as? GerminationAgreementViewController
                    toGerminationAgreementVC?.germinationModelObj = pendingDictObj
                    toGerminationAgreementVC?.totalAcres = acres
                    self.navigationController?.pushViewController(toGerminationAgreementVC!, animated: true)
                }
            }
            self.view.addSubview(germinationAlert)
        }
    }
    
    @IBAction func claimBtnClick(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint(x:0,y:0), to: tblViewGermination)
        let indexPath = self.tblViewGermination!.indexPathForRow(at: buttonPosition)
        //let sectionData = mutArrayToDisplayData.object(at: (indexPath?.section)!) as? GerminationSection
        //print("selected :\(sectionData?.name ?? ""), row :\(indexPath?.row)")
    
        let titleToCheck = (mutArrayToDisplayData.object(at: (indexPath?.section)!) as! GerminationSection).name
        if titleToCheck == SectionTitle.policySubscribed.rawValue{
            let policySubscribedDictObj = ((mutArrayToDisplayData.object(at: (indexPath?.section)!) as! GerminationSection).items as NSArray).object(at: (indexPath?.row)!) as? GerminationPolicySubscribed
            let toGerminationClaimPolicyVC = self.storyboard?.instantiateViewController(withIdentifier: "GerminationClaimPolicyViewController") as? GerminationClaimPolicyViewController
            toGerminationClaimPolicyVC?.germinationModelObj = policySubscribedDictObj
            self.navigationController?.pushViewController(toGerminationClaimPolicyVC!, animated: true)
        }
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension GerminationViewController : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.mutArrayToDisplayData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionData = mutArrayToDisplayData.object(at: section) as? GerminationSection
        return (sectionData?.items.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? GerminationHeaderView ?? GerminationHeaderView(reuseIdentifier: "header")
        let sectionData = mutArrayToDisplayData.object(at: section) as? GerminationSection
        header.titleLabel.text = sectionData?.name
        header.section = section
        header.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30)
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier =  "PendingAgreementCell"
       
        let titleToCheck = (mutArrayToDisplayData.object(at: indexPath.section) as! GerminationSection).name
        
        if titleToCheck == SectionTitle.policySubscribed.rawValue{
            cellIdentifier = "PolicySubscribedCell"
        }
        if titleToCheck == SectionTitle.claimStatus.rawValue{
            cellIdentifier = "ClaimStatusCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        if titleToCheck == SectionTitle.pendingAgreement.rawValue{
            let lblYear = cell.viewWithTag(100) as? UILabel
            let lblSeason = cell.viewWithTag(101) as? UILabel
            let lblCrop = cell.viewWithTag(102) as? UILabel
            
            let cellPendingDict = ((mutArrayToDisplayData.object(at: indexPath.section) as! GerminationSection).items as NSArray).object(at: indexPath.row) as? GerminationList
            //print(cellPendingDict!)
            lblYear?.text = cellPendingDict?.year ?? ""
            lblSeason?.text = cellPendingDict?.seasonName ?? ""
            lblCrop?.text = cellPendingDict?.cropName ?? ""
        }
        if titleToCheck == SectionTitle.policySubscribed.rawValue{
            let lblYear = cell.viewWithTag(200) as? UILabel
            let lblSeason = cell.viewWithTag(201) as? UILabel
            let lblCrop = cell.viewWithTag(202) as? UILabel
            let lblTotalMustardAcres = cell.viewWithTag(203) as? UILabel
            let lblTargetAcres = cell.viewWithTag(204) as? UILabel
            
            let cellPolicyDict = ((mutArrayToDisplayData.object(at: indexPath.section) as! GerminationSection).items as NSArray).object(at: indexPath.row) as? GerminationPolicySubscribed
            //print(cellPolicyDict!)
            lblYear?.text = cellPolicyDict?.year ?? ""
            lblSeason?.text = cellPolicyDict?.seasonName ?? ""
            lblCrop?.text = cellPolicyDict?.cropName ?? ""
            lblTotalMustardAcres?.text = cellPolicyDict?.totalAcres ?? ""
            lblTargetAcres?.text = cellPolicyDict?.targetAcres ?? ""
        }
        if titleToCheck == SectionTitle.claimStatus.rawValue{
            let lblTitle = cell.viewWithTag(300) as? UILabel
            let lblTotalNoOfAcres = cell.viewWithTag(301) as? UILabel
            let lblGerminationFailedAcres = cell.viewWithTag(302) as? UILabel
            let lblDateOfSowing = cell.viewWithTag(303) as? UILabel
            let lblStatus = cell.viewWithTag(304) as? UILabel
            
            let cellClaimedDict = ((mutArrayToDisplayData.object(at: indexPath.section) as! GerminationSection).items as NSArray).object(at: indexPath.row) as? GerminationPolicySubscribed
            //print(cellClaimedDict!)
            
            let titleStr = String(format: "%@ - %@ - %@", cellClaimedDict?.year ?? "",cellClaimedDict?.seasonName ?? "",cellClaimedDict?.cropName ?? "")
            lblTitle?.text = titleStr
            lblTotalNoOfAcres?.text = cellClaimedDict?.totalAcres ?? ""
            lblGerminationFailedAcres?.text = cellClaimedDict?.germinationFailedAcres ?? ""
            lblDateOfSowing?.text = cellClaimedDict?.dateOfSowing ?? ""
            lblStatus?.text = cellClaimedDict?.status ?? ""
            //lblStatus?.sizeToFit()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tblViewGermination?.deselectRow(at: indexPath, animated: false)
        //let sectionData = mutArrayToDisplayData.object(at: indexPath.section) as? GerminationSection
        //print("selected :\(sectionData?.name ?? ""), row :\(indexPath.row)")
        let titleToCheck = (mutArrayToDisplayData.object(at: indexPath.section) as! GerminationSection).name
        if titleToCheck == SectionTitle.pendingAgreement.rawValue{
            let pendingDictObj = ((mutArrayToDisplayData.object(at: indexPath.section) as! GerminationSection).items as NSArray).object(at: indexPath.row) as? GerminationList
            let germinationAlert = GerminationAlertView(frame: self.view.frame, germination: pendingDictObj!)
            germinationAlert.successHandler = {(status, acres) in
                germinationAlert.removeFromSuperview()
                if status == true{
                    let toGerminationAgreementVC = self.storyboard?.instantiateViewController(withIdentifier: "GerminationAgreementViewController") as? GerminationAgreementViewController
                    toGerminationAgreementVC?.germinationModelObj = pendingDictObj
                    toGerminationAgreementVC?.totalAcres = acres
                    self.navigationController?.pushViewController(toGerminationAgreementVC!, animated: true)
                }
            }
            self.view.addSubview(germinationAlert)
        }
        if titleToCheck == SectionTitle.policySubscribed.rawValue{
            let policySubscribedDictObj = ((mutArrayToDisplayData.object(at: indexPath.section) as! GerminationSection).items as NSArray).object(at: indexPath.row) as? GerminationPolicySubscribed
            let toGerminationClaimPolicyVC = self.storyboard?.instantiateViewController(withIdentifier: "GerminationClaimPolicyViewController") as? GerminationClaimPolicyViewController
            toGerminationClaimPolicyVC?.germinationModelObj = policySubscribedDictObj
            self.navigationController?.pushViewController(toGerminationClaimPolicyVC!, animated: true)
        }
        if titleToCheck == SectionTitle.claimStatus.rawValue{
//            let policySubscribedDictObj = ((mutArrayToDisplayData.object(at: indexPath.section) as! GerminationSection).items as NSArray).object(at: indexPath.row) as? GerminationPolicySubscribed
//            self.view.makeToast((policySubscribedDictObj?.status)!)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)){
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            cell.preservesSuperviewLayoutMargins = false
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)){
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
}
