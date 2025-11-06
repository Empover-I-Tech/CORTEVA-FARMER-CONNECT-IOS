//
//  FarmerTimelineLandscapeViewController.swift
//  PioneerEmployee
//
//  Created by Admin on 22/08/19.
//  Copyright © 2019 Empover. All rights reserved.
//

import UIKit

class FarmerTimelineLandscapeViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIPopoverPresentationControllerDelegate,SavingViewControllerDelegate {
    
    @IBOutlet weak var timeLineCollectionView: UICollectionView!
    var farmerMobileNumber : String?
    var arrActivityTimeLine : NSMutableArray = NSMutableArray()
    var farmerName : String?
    var btnYear : UIButton?
    var arrYears : NSMutableArray = NSMutableArray()
    var tblViewYear = UITableView()
    var year = "ALL"
    var userId : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let headers = Constatnts.getLoggedInFarmerHeaders()
        
        if let customerId = headers["customerId"] as String? {
            userId = customerId
        }

        self.topView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.height, height: 55)
       
        if self.arrActivityTimeLine.count == 0 && self.arrYears.count == 0{
            getFarmerTimeLine()
        }else{
            self.timeLineCollectionView.reloadData()
        }
//        AppUtility.lockOrientation(.landscape)
        AppUtility.lockOrientation(.landscape, andRotateTo: .landscapeRight)

//        forcelandscapeLeft()
        self.addButtonToNavigationBarToSelectYears()
     
        self.registerFirebaseEvents(Time_LineGraphView_Screen, self.farmerMobileNumber ?? "Customer", self.userId ?? "0", "FarmerTimelineLandscapeViewController", parameters: nil)
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
                    
                    self.timeLineCollectionView.reloadData()
                }
            }else{
                self.view.makeToast("No records found")
            }
        }

    }
    
    func yearSelected(strText: NSString) {
        year = strText as String
        btnYear?.setTitle(strText as String?, for: .normal)
        self.getFarmerTimeLine()
        self.registerFirebaseEvents(Time_LineGraphView_YearSelect, self.farmerMobileNumber ?? "Customer", self.userId ?? "0", "FarmerTimelineLandscapeViewController", parameters: nil)

    }
    
    func addButtonToNavigationBarToSelectYears(){
        btnYear = UIButton(type: .custom)
        btnYear?.frame = CGRect(x: (topView?.frame.size.width)! - 100, y: 10, width: 90, height: 35)
        topView?.addSubview(btnYear ?? UIButton())
        
        btnYear?.addTarget(self, action: #selector(FarmerTimelineLandscapeViewController.yearsBtnClick(_:)), for: .touchUpInside)
        btnYear?.setImage(UIImage(named: "arrow_down_white"), for: .normal)
        btnYear?.imageEdgeInsets = UIEdgeInsets(top: 0,left: 70,bottom: 2,right: 2)
        btnYear?.titleEdgeInsets = UIEdgeInsets(top: 0,left: -30,bottom: 0,right: 34)

        btnYear?.setTitle("ALL", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.lblTitle?.text = Dashboard.FARMER_DASHBOARD.rawValue
        self.topView?.backgroundColor = App_Theme_Blue_Color

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        AppUtility.lockOrientation(.portrait)
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)

//        forceOrientationPortrait()
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

    @objc func hideUnhideDropDownTblView(tblView : UITableView, hideUnhide : Bool){
        tblView.isHidden = !hideUnhide
        self.view.bringSubview(toFront: tblView)
    }

    @objc func forcelandscapeLeft() {
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    @objc func forceOrientationPortrait() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .portrait
        appDelegate.isTimeLine = false

        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }

    //MARK: UICollectionView Delegate and Datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrActivityTimeLine.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:FarmerTimeLineLandscapeCollectionViewCell = self.timeLineCollectionView!.dequeueReusableCell(withReuseIdentifier: "timeLineActivitiesCell", for: indexPath) as! FarmerTimeLineLandscapeCollectionViewCell
        
        let farmObj = arrActivityTimeLine.object(at: indexPath.row) as? FarmerActivityTimeLineModel
        
        cell.lblDate.text = farmObj?.activityMonth as String?
        cell.arrFarmerTimeLineData = farmObj?.arrActivities ?? NSMutableArray()
       
        cell.cellDelegate = self

        DispatchQueue.main.async {
            cell.itemsCollectionView.reloadData()
        }

        return cell
            
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == timeLineCollectionView{
            return CGSize(width: 150, height: collectionView.bounds.size.height)
        }else{
            return CGSize(width: 150, height: 150)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsetsMake(0, 0, 0, 0)//top,left,bottom,right
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
    }
    
    func showPopoverFrom(cell:FarmerTimeLineItemsCollectionViewCell, forButton button:UIButton,object: FarmerActivitiesModel) {
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
           
            self.registerFirebaseEvents(Time_LineGraphView_ToolTip, self.farmerMobileNumber ?? "Customer", self.userId ?? "0", "FarmerTimelineLandscapeViewController", parameters: nil)

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
    func popoverContent(controller: PopOverContentViewController) {
        
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    override var shouldAutorotate: Bool {
        return true
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FarmerTimelineLandscapeViewController:CustomTableCellDelegate {
    func customCell(cell: FarmerTimeLineItemsCollectionViewCell, didTappedshow button: UIButton,object : FarmerActivitiesModel) {
        self.showPopoverFrom(cell: cell, forButton: button,object: object)
    }
}
