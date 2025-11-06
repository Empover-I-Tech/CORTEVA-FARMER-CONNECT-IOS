//
//  FarmerTimeLineVerticalViewController.swift
//  FarmerConnect
//
//  Created by Apple on 16/09/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import UIKit
import Alamofire

protocol PopoverContentControllerDelegate:class {
    func popoverContent(controller:PopOverContentViewController)
}
class FarmerTimeLineVerticalViewController: BaseViewController,UIPopoverPresentationControllerDelegate,SavingViewControllerDelegate {
    
    var delegate: PopoverContentControllerDelegate?
  
    func yearSelected(strText: NSString) {
        year = strText as String
        btnYear?.setTitle(strText as String?, for: .normal)
        self.getFarmerTimeLine()
        
        self.registerFirebaseEvents(Time_LineGraphView_YearSelect, self.farmerMobileNumber ?? "Customer", self.userId ?? "0", "FarmerTimeLineVerticalViewController", parameters: nil)
    }

    
    @IBOutlet weak var tblViewTimeLine : UITableView!
    var farmerMobileNumber : String?
    var arrActivityTimeLine : NSMutableArray = NSMutableArray()
    var farmerName : String?
    var btnYear : UIButton?
    var arrYears : NSMutableArray = NSMutableArray()
    var tblViewYear = UITableView()
    var year = "ALL"
    var userId : String?
    var isFromHome : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFromHome == false {
            self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
        }

        let headers = Constatnts.getLoggedInFarmerHeaders()
        let userObj = Constatnts.getUserObject()
        
        if let customerId = headers["customerId"] as String? {
            userId = customerId
        }
        
        farmerMobileNumber = userObj.mobileNumber as String?
//        let farmerName = userObj.firstName as String?
        
        if let customerId = headers["customerId"] as String? {
            userId = customerId
        }

        let timelineTableViewCellNib = UINib(nibName: "TimelineTableViewCell", bundle: nil)
        self.tblViewTimeLine.register(timelineTableViewCellNib, forCellReuseIdentifier: "cell")
        
        self.tblViewTimeLine.separatorColor = .clear

        self.getFarmerTimeLine()

        self.lblTitle?.text = NSLocalizedString("farmer_Dashboard", comment: "")   // Dashboard.FARMER_DASHBOARD.rawValue
        self.addButtonToNavigationBarToSelectYears()
       
        self.registerFirebaseEvents(Time_LineGraphView_Screen, self.farmerMobileNumber ?? "Customer", self.userId ?? "0", "FarmerTimeLineVerticalViewController", parameters: nil)
     
        if userObj.userLogsAllPrint == "true"{
        self.saveUserLogEventsDetailsToServer()
        }
    }
    
    func saveUserLogEventsDetailsToServer(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMddHHmmss" //"dd/MM/yyyy HH:mm:ss"
        var todaysDate = dateFormatter.string(from: Date())
        let userObj = Constatnts.getUserObject()
        
        let dict: NSDictionary = ["userModuleUsageLogs":[[
            "mobileNumber": userObj.mobileNumber,
            "deviceId": userObj.deviceId,
            "deviceType": "iOS",
            "customerId": userObj.customerId,
            "logTimeStamp": todaysDate as? NSString,
            "pincode": userObj.pincode,
            "districtLoggedin":userObj.districtName,
            "stateLoggedin":userObj.stateName,
            "stateName": userObj.stateName,
            "marketName":"",
            "commodity":"",
            
            "eventName": Home_MyTimeLine,
            "className":"FarmerTimeLineVerticalViewController",
            "moduleName":"MyTimeLine",
            
            "healthCardId":"",
            "productId":"",
            "cropId":"",
            "seasonId":"",
            "otherParams":"",
            "isOnlineRecord": "true"]] as? [NSDictionary]
        ]
        
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            userLogEventsSingletonClass.sendUserLogEventsDetailsToServer(dictionary: dict ?? NSDictionary()){ (status, statusMessage) in
                if status == true{
                }else{
                    self.view.makeToast(statusMessage as String? ?? "")
                }
            }
        }else{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let userLogEvents = dict["userModuleUsageLogs"] as! [NSDictionary]
                for eachLogEvent in userLogEvents {
                var userLogEvent: UserLogEvents = UserLogEvents(dict: eachLogEvent)
                userLogEvent.isOnlineRecord = "false"
                appDelegate.saveUserLogEventsModulewise(userLogEvent)
                }
        }
        
    }
    override func backButtonClick(_ sender: UIButton) {
        if isFromHome == true {
            self.navigationController?.popViewController(animated: true)
        }
        else{
            self.findHamburguerViewController()?.showMenuViewController()
        }
    }

    @IBAction func gotoHorizontalTimeLine(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .landscape

        let farmerDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "FarmerTimelineLandscapeViewController") as? FarmerTimelineLandscapeViewController
        farmerDetailsVC?.farmerMobileNumber = farmerMobileNumber
        farmerDetailsVC?.farmerName = farmerName
        farmerDetailsVC?.arrYears = arrYears
        farmerDetailsVC?.arrActivityTimeLine = arrActivityTimeLine
        self.navigationController?.pushViewController(farmerDetailsVC!, animated: true)
        
    }

    func addButtonToNavigationBarToSelectYears(){
        btnYear = UIButton(type: .custom)
        btnYear?.frame = CGRect(x: (topView?.frame.size.width)! - 100, y: 10, width: 90, height: 35)
        topView?.addSubview(btnYear ?? UIButton())
        
        btnYear?.addTarget(self, action: #selector(FarmerTimeLineVerticalViewController.yearsBtnClick(_:)), for: .touchUpInside)
        btnYear?.setImage(UIImage(named: "arrow_down_white"), for: .normal)
        btnYear?.imageEdgeInsets = UIEdgeInsets(top: 0,left: 70,bottom: 2,right: 2)
        btnYear?.titleEdgeInsets = UIEdgeInsets(top: 0,left: -10,bottom: 0,right: 20)
        
        btnYear?.setTitle("ALL", for: .normal)
        
    }
    
    @objc func yearsBtnClick(_ sender : UIButton){
        let popoverContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PropOverTableDropDownViewController") as? PropOverTableDropDownViewController
        //        popoverContent!.broughtProductInfo = self.broughtProductInfo[button.tag]
        let nav = UINavigationController(rootViewController: popoverContent!)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        nav.navigationBar.isHidden = true
        popoverContent!.preferredContentSize = CGSize(width : 120,height : 120)
        popover!.delegate = self
        popover!.sourceView = self.view
        popoverContent?.arrYears = self.arrYears
        popoverContent?.delegate = self
        popover!.sourceRect = self.btnYear!.frame
        popoverContent?.view.backgroundColor = UIColor.white
        self.present(nav, animated: true, completion: nil)
        
    }

    func showPopoverFrom(cell:TimelineTableViewCell, forButton button:UIButton,object: FarmerActivitiesModel) {
        if object.arrActivityInfo.count > 0 {
            let farmerActivities : FarmerInternalActivitesInMonth = object.arrActivityInfo.object(at: 0) as! FarmerInternalActivitesInMonth
            let popoverContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopOverContentViewController") as? PopOverContentViewController
            //        popoverContent!.broughtProductInfo = self.broughtProductInfo[button.tag]
            let nav = UINavigationController(rootViewController: popoverContent!)
            nav.modalPresentationStyle = UIModalPresentationStyle.popover
            let popover = nav.popoverPresentationController
            nav.navigationBar.isHidden = true
            popoverContent!.preferredContentSize = CGSize(width : 350,height : 200)
            popover!.delegate = self
            popoverContent?.farmerDetails = object
            popoverContent?.farmerActivities = farmerActivities
            
            popover!.sourceView = cell.contentView
            popover!.sourceRect = button.frame
            popoverContent?.view.backgroundColor = UIColor.white
            self.present(nav, animated: true, completion: nil)
            
        }
        else{
            self.view.makeToast("Activity details not found!")
        }
    }

    func getFarmerTimeLine(){
        let dict = ["mobileNumber": farmerMobileNumber, "year": year]
        
        FarmerDashBoardSingleton.getFarmerDashboardActivitiesTimeLine(dictParameter: dict as NSDictionary) { (status, dictResponse, message) in
            if status == true{
                if dictResponse != nil{
                    let arrYTD = dictResponse?.object(forKey: "ytd") as? NSArray
                    if arrYTD?.count != 0 && arrYTD != nil {
                        self.arrActivityTimeLine.removeAllObjects()

                        for i in 0...(arrYTD?.count ?? 0) - 1 {
                            let dict = arrYTD?.object(at: i) as? NSDictionary
                            let farmersObj : FarmerActivityTimeLineModel = FarmerActivityTimeLineModel(dict: dict ?? NSDictionary())
                            self.arrActivityTimeLine.add(farmersObj)
                        }
                    }
                    
                    let arrDummyYears = dictResponse?.object(forKey: "years") as? NSArray
                    
                    if arrDummyYears != nil || arrDummyYears?.count == 0 {
                        self.arrYears.removeAllObjects()
                        self.arrYears.addObjects(from: arrDummyYears as! [Any])
                    }
                    self.tblViewTimeLine.reloadData()
                }
            }else{
                self.navigationController?.popViewController(animated: true)
                self.view.makeToast("No records found")
            }
        }
    }
    
    func  showPopoverFrom(cell:ActivityCell, forButton button:UIButton,object: FarmerActivitiesModel) {
        if object.arrActivityInfo.count > 0 {
            let farmerActivities : FarmerInternalActivitesInMonth = object.arrActivityInfo.object(at: 0) as! FarmerInternalActivitesInMonth
            let popoverContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopOverContentViewController") as? PopOverContentViewController
            //        popoverContent!.broughtProductInfo = self.broughtProductInfo[button.tag]
            let nav = UINavigationController(rootViewController: popoverContent!)
            nav.modalPresentationStyle = UIModalPresentationStyle.popover
            let popover = nav.popoverPresentationController
            nav.navigationBar.isHidden = true
            popoverContent!.preferredContentSize = CGSize(width : 350,height : 200)
            popover!.delegate = self
            popoverContent?.farmerDetails = object
            popoverContent?.farmerActivities = farmerActivities
            
            popover!.sourceView = cell.contentView
            popover!.sourceRect = button.frame
            popoverContent?.view.backgroundColor = UIColor.white
            self.present(nav, animated: true, completion: nil)
        }
        else{
            self.view.makeToast("Activity details not found!")
        }
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
  
    
}
extension FarmerTimeLineVerticalViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrActivityTimeLine.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TimelineTableViewCell
        cell.timelinePoint = .init(diameter: 20, lineWidth: 4, color: UIColor.orange, filled: false)
        cell.timelinePoint.position = CGPoint(x: 20, y: 20)
        let farmObj = arrActivityTimeLine.object(at: indexPath.row) as? FarmerActivityTimeLineModel

        cell.lblDate.text = farmObj?.activityMonth as String?
        cell.arrFarmerTimeLineData = farmObj?.arrActivities ?? NSMutableArray()
        cell.cellDelegate = self 
       
        DispatchQueue.main.async {
            cell.cvContents.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}
extension FarmerTimeLineVerticalViewController:CustomCollectionViewCellDelegate {
    func customCell(cell: ActivityCell, didTappedshow button: UIButton,object : FarmerActivitiesModel) {
        self.registerFirebaseEvents(Time_LineGraphView_ToolTip, self.farmerMobileNumber ?? "Customer", self.userId ?? "0", "FarmerTimeLineVerticalViewController", parameters: nil)

        self.showPopoverFrom(cell: cell, forButton: button,object: object)
    }
}
