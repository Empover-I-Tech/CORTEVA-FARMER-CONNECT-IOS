//
//  TicketsViewController.swift
//  Paramarsh
//
//  Created by Empover on 05/02/18.
//  Copyright © 2018 Empover. All rights reserved.
//

import UIKit
import Alamofire

class TicketsViewController: BaseViewController {

    @IBOutlet weak var tblViewTickets: UITableView!
    var selectedDate = NSString()
    var dateView : UIView?
    var mutArrayToDisplay = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tblViewTickets.dataSource = self
        tblViewTickets.delegate = self
        tblViewTickets.tableFooterView = UIView()
        
        let fromDateFormatter: DateFormatter = DateFormatter()
        fromDateFormatter.dateFormat = "dd/MM/yyyy"
        let currentDateStr = fromDateFormatter.string(from: Date()) as String
        selectedDate = currentDateStr as NSString
        let noDataText = NSLocalizedString("no_data_available", comment: "")
        self.addNodetailsFoundLabelFooterToTableView(tableView: self.tblViewTickets, message: noDataText)
        let userObj = Constatnts.getUserObject()
        self.recordScreenView("TicketsViewController", Ticket_Info)
        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,PINCODE:userObj.pincode ?? "",User_First_Name:userObj.firstName!,User_Last_Name:userObj.lastName!] as [String : Any]
        self.registerFirebaseEvents(PV_Ticket_Info, "", "", Ticket_Info, parameters: fireBaseParams as NSDictionary)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
        self.topView?.isHidden = false
        self.lblTitle?.text = NSLocalizedString("tickets", comment: "")  // "Tickets"
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        
        let net = NetworkReachabilityManager(host: "www.google.com")
        let userObj = Constatnts.getUserObject()
        if net?.isReachable == true{
            let urlStr = String(format :"?mobileNumber=%@",userObj.mobileNumber!)
            self.requestToGetTicketData(URLStr: urlStr)
        }
        else{
            //let appDelegate = UIApplication.shared.delegate as! AppDelegate
            self.mutArrayToDisplay.removeAllObjects()
            self.mutArrayToDisplay = ParamarshSingleton.getTicketDetailsFromDB("TicketDetailsEntity")
            //print(self.mutArrayToDisplay)
            if self.mutArrayToDisplay.count > 0 {
                DispatchQueue.main.async {
                    self.tblViewTickets.reloadData()
                }
            }
            else{
                let checkInterNet = NSLocalizedString("no_internet", comment: "")
                self.view.makeToast(checkInterNet)
            }
        }
    }
    
    //MARK: requestToGetTicketData
    func requestToGetTicketData (URLStr : String){
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@%@", arguments: [PARAMARSH_BASE_URL,PARAMARSH_TICKET_DETAILS,URLStr])
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    //let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    if let jsonArray = json as? NSArray{
                        self.mutArrayToDisplay.removeAllObjects()
                        ParamarshSingleton.deleteTicketDetails()
                        for i in (0..<jsonArray.count){
                            let resultDict = jsonArray.object(at: i) as! NSDictionary
                            let ticketObj = TicketDetails (dict: resultDict)
                            ParamarshSingleton.saveTicketDetails(ticketObj)
                            //self.mutArrayToDisplay.add(ticketObj)
                        }
                        self.mutArrayToDisplay = (ParamarshSingleton.getTicketDetailsFromDB("TicketDetailsEntity"))
                        //print(self.mutArrayToDisplay)
                    }
                    DispatchQueue.main.async {
                        self.tblViewTickets.reloadData()
                    }
                }
                else {
                    self.view.makeToast(Alert_Message_201)
                }
                if self.mutArrayToDisplay.count == 0{
                    let noTickets  = NSLocalizedString("no_tickets", comment: "")
                    self.addNodetailsFoundLabelFooterToTableView(tableView: self.tblViewTickets, message:noTickets)
                }
                else{
                    self.tblViewTickets.tableFooterView = UIView()
                }
            }
            else{
                self.view.makeToast((response.result.error?.localizedDescription)!, duration: 1.0, position: .center)
                return
            }
        }
    }
    
    override func backButtonClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func calendarButtonClick(_ sender: Any) {
      self.datePickerView()
    }
    
    func datePickerView(){
        let Height:CGFloat = (44.11 * self.view.frame.height/120)
        let width :CGFloat =  self.view.frame.size.width-40 //-40
        let posX :CGFloat = ( self.view.frame.size.width - width) / 2
        
        dateView = UIView (frame: CGRect(x: posX,y: ( self.view.frame.height-Height)/2 ,width: width,height: Height))
        dateView?.backgroundColor = UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        dateView?.layer.cornerRadius = 10.0
        self.view.addSubview(dateView!)
        
        //dobPicker
        let dobPicker : UIDatePicker = UIDatePicker (frame: CGRect(x: 5,y: 5,width: width-10,height: Height-50))
        dobPicker.backgroundColor = UIColor.white
        dobPicker.layer.cornerRadius = 5.0
        dobPicker.datePickerMode = UIDatePickerMode.date
        if Validations.isNullString(selectedDate) == false{
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateToSetOnPicker = dateFormatter.date(from: selectedDate as String)
            dateFormatter.dateFormat = "yyyy/MM/dd"
            let dateToSetStr = dateFormatter.string(from: dateToSetOnPicker!)
            dobPicker.date = dateFormatter.date(from: dateToSetStr)!
        }
        //dobPicker.maximumDate = NSDate() as Date
        dobPicker.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: .valueChanged)
        dateView?.addSubview(dobPicker)
        
        //cancel button
        let btnCancel : UIButton = UIButton (frame: CGRect(x: 0, y: dobPicker.frame.maxY+5,width: width/2,height: 40))
        btnCancel.backgroundColor = UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 0.8)
        btnCancel.layer.cornerRadius = 5.0
        let cancelStr = NSLocalizedString("cancel", comment: "")
        btnCancel.setTitle(cancelStr, for: UIControlState())
        btnCancel.addTarget(self, action: #selector(TicketsViewController.alertCancel), for: UIControlEvents.touchUpInside)
        dateView?.addSubview(btnCancel)
        
        //submit button
        let btnOK : UIButton = UIButton (frame: CGRect(x: btnCancel.frame.width+5, y: dobPicker.frame.maxY+5,width: width/2-5,height: 40))
        btnOK.backgroundColor = UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 0.8)
        btnOK.layer.cornerRadius = 5.0
         let okStr = NSLocalizedString("ok", comment: "")
        btnOK.setTitle(okStr, for: UIControlState())
        btnOK.addTarget(self, action: #selector(TicketsViewController.alertOK), for: UIControlEvents.touchUpInside)
        dateView?.addSubview(btnOK)
        
        let dobFrame = dateView?.frame
        dateView?.frame.size.height = btnOK.frame.maxY
        dateView?.frame = dobFrame!
        
        dateView?.frame.origin.y = ( self.view.frame.size.height - 64 - (dateView?.frame.size.height)!) / 2
        dateView?.frame = dobFrame!
    }
    
    //MARK: datePickerValueChanged
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        selectedDate = dateFormatter.string(from: sender.date) as NSString
        //print("Selected value \(selectedDate)")
    }
    
    @objc func alertOK(){
        self.retrieveTicketDetailsFromDB(dateStr: selectedDate)
            self.dateView?.removeFromSuperview()
        
        
    }
    
    @objc func alertCancel(){
        self.dateView?.removeFromSuperview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        let fromDateFormatter: DateFormatter = DateFormatter()
        fromDateFormatter.dateFormat = "dd/MM/yyyy"
        let currentDateStr = fromDateFormatter.string(from: Date()) as String
        selectedDate = currentDateStr as NSString
    }
    
    func retrieveTicketDetailsFromDB(dateStr : NSString){
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let retrievedArrFromDB = ParamarshSingleton.getTicketDetailsFromDB("TicketDetailsEntity")
        let dbPredicate = NSPredicate(format: "formattedDate = %@",dateStr)
        let outputFilteredArr = (retrievedArrFromDB).filtered(using: dbPredicate) as NSArray
        self.mutArrayToDisplay.removeAllObjects()
        if outputFilteredArr.count > 0{
            self.mutArrayToDisplay.addObjects(from: outputFilteredArr as! [Any])
        }
        else{
            self.mutArrayToDisplay.removeAllObjects()
            let noTickets = NSLocalizedString("no_tickets", comment: "")
            self.view.makeToast(noTickets) //"There are no tickets for the selected date"
            
        }
         self.tblViewTickets.reloadData()
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

extension TicketsViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mutArrayToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TicketCell"
       // let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        let cell = tblViewTickets.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let ticketDetailsCell = self.mutArrayToDisplay.object(at: indexPath.row) as? TicketDetails
        
        let lblTicket = cell.viewWithTag(100) as? UILabel
        if Validations.isNullString((ticketDetailsCell?.ticketNo)!) == false{
            lblTicket?.text = ticketDetailsCell?.ticketNo as String?
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblViewTickets.deselectRow(at: indexPath, animated: false)
        let ticketDetailsCell = self.mutArrayToDisplay.object(at: indexPath.row) as? TicketDetails
        let storyBoard = UIStoryboard(name: "Paramarsh" , bundle: nil)
        let toTicketDetailsVC = storyBoard.instantiateViewController(withIdentifier: "TicketDetailsViewController") as! TicketDetailsViewController
        toTicketDetailsVC.ticketIDFromTicketsVC = (ticketDetailsCell?.ticketNo)!
        self.navigationController?.pushViewController(toTicketDetailsVC, animated: true)
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
