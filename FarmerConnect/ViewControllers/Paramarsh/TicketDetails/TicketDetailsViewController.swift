//
//  TicketDetailsViewController.swift
//  Paramarsh
//
//  Created by Empover on 05/02/18.
//  Copyright © 2018 Empover. All rights reserved.
//

import UIKit

class TicketDetailsViewController: BaseViewController {
    
    @IBOutlet weak var tblViewTicketDetails: UITableView!
    
    var ticketIDFromTicketsVC = NSString()
    var mutArrayToDisplay = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tblViewTicketDetails.dataSource = self
        tblViewTicketDetails.delegate = self
        tblViewTicketDetails.tableFooterView = UIView()
        tblViewTicketDetails.separatorStyle = UITableViewCellSeparatorStyle.none
        tblViewTicketDetails.rowHeight = UITableViewAutomaticDimension
        tblViewTicketDetails.estimatedRowHeight = 50
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 10.0, *) {
            self.automaticallyAdjustsScrollViewInsets = true
        }
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
        self.topView?.isHidden = false
        self.lblTitle?.text = "Ticket Data"
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        self.retrieveTicketDetailsFromDB()
    }
    
    func retrieveTicketDetailsFromDB(){
        let retrievedArrFromDB = ParamarshSingleton.getTicketDetailsFromDB("TicketDetailsEntity")
        let dbPredicate = NSPredicate(format: "ticketNo = %@",ticketIDFromTicketsVC)
        let outputFilteredArr = (retrievedArrFromDB).filtered(using: dbPredicate) as NSArray
        if outputFilteredArr.count > 0{
            let ticketObj = outputFilteredArr.object(at: 0) as? TicketDetails
            self.mutArrayToDisplay.add(ticketObj!)
            //print(self.mutArrayToDisplay)
            tblViewTicketDetails.reloadData()
        }
    }
    
    override func backButtonClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension TicketDetailsViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TicketDetailsCell"
        // let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        let cell = tblViewTicketDetails.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let ticketDetailsCell = self.mutArrayToDisplay.object(at: 0) as? TicketDetails
        
        let lblTitle = cell.viewWithTag(100) as? UILabel
        let lbldetails = cell.viewWithTag(101) as? UILabel
        
        switch (indexPath.row) {
        case 0:
            lblTitle?.text = NSLocalizedString("ticket_no", comment: "")  // "Ticket No."
            lbldetails?.text = ticketDetailsCell?.ticketNo as String?
            break
        case 1:
            lblTitle?.text = NSLocalizedString("issue_type", comment: "") //"Issue Type"
            lbldetails?.text = ticketDetailsCell?.issueType as String?
            break
        case 2:
            lblTitle?.text = NSLocalizedString("name", comment: "") //"Name"
            lbldetails?.text = ticketDetailsCell?.name as String?
            break
        case 3:
            lblTitle?.text = NSLocalizedString("mobile", comment: "") //"Mobile No."
            lbldetails?.text = ticketDetailsCell?.mobileNo as String?
            break
        case 4:
            lblTitle?.text = NSLocalizedString("crop", comment: "") //"Crop"
            lbldetails?.text = ticketDetailsCell?.crop as String?
            break
        case 5:
            lblTitle?.text = NSLocalizedString("hybrid", comment: "") //"Hybrid"
            lbldetails?.text = ticketDetailsCell?.hybrid as String?
            break
        case 6:
            lblTitle?.text = NSLocalizedString("lot_no", comment: "") //"Lot No."
            lbldetails?.text = ticketDetailsCell?.lotNo as String?
            break
        case 7:
            lblTitle?.text = NSLocalizedString("damage", comment: "") //"Damage (%)"
            lbldetails?.text = ticketDetailsCell?.damagePerc as String?
            break
        case 8:
            lblTitle?.text = NSLocalizedString("district", comment: "") //"District"
            lbldetails?.text = ticketDetailsCell?.district as String?
            break
        case 9:
            lblTitle?.text = NSLocalizedString("pincode", comment: "") //"Pincode"
            lbldetails?.text = ticketDetailsCell?.pincode as String?
            break
        case 10:
            lblTitle?.text = NSLocalizedString("descr", comment: "") // "Description"
            lbldetails?.text = ticketDetailsCell?.descriptionStr as String?
            break
        case 11:
            lblTitle?.text = NSLocalizedString("created_date", comment: "") //"Created Date"
            lbldetails?.text = ticketDetailsCell?.formattedDate
            break
        case 12:
            lblTitle?.text = NSLocalizedString("updated_date", comment: "")  //"Updated Date"
            lbldetails?.text = ticketDetailsCell?.formattedUpdatedDate
            break
        case 13:
            lblTitle?.text = NSLocalizedString("status", comment: "") //"Status"
            lbldetails?.text = ticketDetailsCell?.status as String?
            break
        default:
            break
        }
        lbldetails?.sizeToFit()
        return cell
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
