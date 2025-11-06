//
//  MyOrdersViewController.swift
//  FarmerConnect
//
//  Created by Admin on 27/12/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit
import Alamofire

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

class MyOrdersSegmentViewController: ProviderBaseViewController,CAPSPageMenuDelegate {

    var segmentMenu : CAPSPageMenu?
    var viewConstrollers = ["PendingRequestsViewController","PendingOrdersViewController","PastOrdersViewController"]
    var arrTitles = [NSLocalizedString("pending_request", comment:""),NSLocalizedString("pending_orders", comment: ""),NSLocalizedString("past_orders", comment: "")]
    var currentViewController : UIViewController?
    var arrPendingOrders = NSMutableArray()
    var arrPendingRequests = NSMutableArray()
    var arrPastOrders = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(2.0),
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.clear),
            .bottomMenuHairlineColor(UIColor.clear),
            .selectionIndicatorColor(App_Theme_Orange_Color),
            .menuMargin(10.0),
            .menuHeight(60.0),
            .selectedMenuItemLabelColor(UIColor.white),
            .unselectedMenuItemLabelColor(UIColor.white),
            .menuItemFont(UIFont.systemFont(ofSize: UIScreen.main.bounds.size.width == 320 ? 13:15)),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorRoundEdges(true),
            .selectionIndicatorHeight(3.0),
            .menuItemSeparatorPercentageHeight(10.0),
            .menuItemWidthBasedOnTitleTextWidth(false),
            .titleTextSizeBasedOnMenuItemWidth(false)
        ]
        let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        segmentMenu = CAPSPageMenu(viewControllers: viewConstrollers, titles: arrTitles, images: [], selectImages: [], frame: CGRect(x: 0.0, y: topBarHeight, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        segmentMenu?.delegate = self
        segmentMenu?.moveToPage(0)
        currentViewController = segmentMenu?.viewControllerForPage(0)
        self.view.addSubview(segmentMenu!.view)
        let refreshButton = UIButton(type: .custom)
        refreshButton.frame = CGRect(x: (self.topView?.frame.size.width)! - 50, y: 5, width: 40, height: 40)
        refreshButton.addTarget(self, action: #selector(MyOrdersSegmentViewController.refreshMyOrdersButtonClick(_:)), for: .touchUpInside)
        refreshButton.setImage(UIImage(named: "RefreshWhite"), for: .normal)
        self.topView?.addSubview(refreshButton)
        self.recordScreenView("MyOrdersSegmentViewController", FSP_Orders)
        self.registerFirebaseEvents(PV_FSP_Orders, "", "", "", parameters: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 10.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        super.viewWillAppear(animated)
        self.topView?.isHidden = false
        self.hideFilterButton(true)
        self.hideClearButton(true)
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        
        self.lblTitle?.text = NSLocalizedString("my_orders", comment: "")
        let parameters = ["customerId":Constatnts.getCustomerId()]
        
        self.getProviderPendingOrdersListServiceCall(Parameters: parameters)
    }
    
    override func backButtonClick(_ sender: UIButton) {
       self.navigationController?.popViewController(animated: true)
    }
    
    override func filterButtonClick(_ sender: UIButton) {
        self.registerFirebaseEvents(FSP_Orders_Filter, "", "", "", parameters: nil)
        let toFilterVC = self.storyboard?.instantiateViewController(withIdentifier: "ProviderFilterViewController") as! ProviderFilterViewController
        toFilterVC.filterDetailsHandler = {(dataDict,isFromFilterVC) in
            //print(dataDict)
            self.getProviderPendingOrdersListServiceCall(Parameters: dataDict)
        }
        
        self.navigationController?.pushViewController(toFilterVC, animated: true)
    }
    
    func getProviderPendingOrdersListServiceCall(Parameters: [String:Any]){
        let headers : HTTPHeaders = self.getProviderHeaders()
        //print(headers)
        SwiftLoader.show(animated: true)
        let urlString = String(format: "%@%@", arguments: [BASE_URL,Get_Provider_Orers_List])
//        let parameteers = ["customerId":Constatnts.getCustomerId()]
        let paramsStr = Constatnts.nsobjectToJSON(Parameters as NSDictionary)
        let params =  ["data" : paramsStr]
        //print(params)
        //let parameters = ["mobileNumber":userObj.mobileNumber,"customerId": loggingUser!.customerId,"deviceId":userObj.deviceId!,"countryId":userObj.countryId.integerValue,"deviceType":"iOS"] as NSDictionary
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        /*if let message = (json as! NSDictionary).value(forKey: "message") as? String {
                         self.view.makeToast(message)
                         }*/
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        if let pendingRequestsArray = Validations.checkKeyNotAvailForArray(decryptData, key: "pendingRequest") as? NSArray{
                            self.arrPendingRequests.removeAllObjects()
                            for index in 0..<pendingRequestsArray.count{
                                if let reqDic = pendingRequestsArray.object(at: index) as? NSDictionary{
                                    let order = Order(dict: reqDic)
                                    self.arrPendingRequests.add(order)
                                }
                            }
                        }
                        if let pendingOrdersArray = Validations.checkKeyNotAvailForArray(decryptData, key: "pendingOrders") as? NSArray{
                            self.arrPendingOrders.removeAllObjects()
                            for index in 0..<pendingOrdersArray.count{
                                if let reqDic = pendingOrdersArray.object(at: index) as? NSDictionary{
                                    let order = Order(dict: reqDic)
                                    self.arrPendingOrders.add(order)
                                }
                            }
                        }
                        if let pastOrdersArray = Validations.checkKeyNotAvailForArray(decryptData, key: "pastOrders") as? NSArray{
                            self.arrPastOrders.removeAllObjects()
                            for index in 0..<pastOrdersArray.count{
                                if let reqDic = pastOrdersArray.object(at: index) as? NSDictionary{
                                    let order = Order(dict: reqDic)
                                    self.arrPastOrders.add(order)
                                }
                            }
                        }
                        //print("Response after decrypting data:\(decryptData)")
                        self.refreshOrdersListWhileChangePage()
                    }
                    else{
                        self.refreshOrdersListWhileChangePage()
                        if let message = (json as! NSDictionary).value(forKey: "message") as? String {
                            self.view.makeToast(message)
                        }
                    }
                }
            }
            else{
                self.view.makeToast((response.error?.localizedDescription)!)
            }
        }
    }
    
    @IBAction func refreshMyOrdersButtonClick(_ sender: UIButton){
        self.registerFirebaseEvents(FSP_Orders_Refresh, "", "", "", parameters: nil)
        let parameters = ["customerId":Constatnts.getCustomerId()]
        self.getProviderPendingOrdersListServiceCall(Parameters: parameters)
    }
    func refreshOrdersListWhileChangePage(){
        if let pendingRequestController = self.currentViewController as? PendingRequestsViewController{
            pendingRequestController.arrPendingRequsts = self.arrPendingRequests
            pendingRequestController.relodData()
            self.registerFirebaseEvents(FSP_Pending_Requests, "", "", "", parameters: nil)
            
        }
        else if let pendingOrdersController = self.currentViewController as? PendingOrdersViewController{
            pendingOrdersController.arrPendingOrders = self.arrPendingOrders
            pendingOrdersController.relodData()
            self.registerFirebaseEvents(FSP_Pending_Orders, "", "", "", parameters: nil)
        }
        else if let pastOrdersController = self.currentViewController as? PastOrdersViewController{
            pastOrdersController.arrPastOrders = self.arrPastOrders
            pastOrdersController.relodData()
            self.registerFirebaseEvents(FSP_Past_Orders, "", "", "", parameters: nil)
        }
    }
    func changeTopMenuButtonsBasedOnIndex(_ index : NSInteger) {
        
        switch index {
        case 0 :
            
            break
        case 1 :
            
            break
        case 2 :
            
            break
        case 3 :
            
            break
            
            
        default : break
            
        }
        
    }
    //MARK: CAPageMenu Delegate methods
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        //print("did move to page")
        currentViewController = controller
        currentViewController?.viewWillAppear(true)
        self.refreshOrdersListWhileChangePage()
        //searchCompletionBlock = nil
        //self.changeTopMenuButtonsBasedOnIndex(index)
    }
    
    func willMoveToPage(_ controller: UIViewController, index: Int) {
        //print("will move to page")
        //print(controller)
        //self.changeTopMenuButtonsBasedOnIndex(index)
        //currentViewController = controller
        //currentViewController?.viewWillAppear(true)
        //self.refreshOrdersListWhileChangePage()
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
