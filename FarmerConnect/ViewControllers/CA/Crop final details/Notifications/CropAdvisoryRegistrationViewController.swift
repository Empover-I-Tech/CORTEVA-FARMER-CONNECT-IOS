//
//  CropAdvisoryRegistrationViewController.swift
//  FarmerConnect
//
//  Created by Empover on 20/12/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit
import Alamofire

open class CropAdvisoryRegistrationViewController: BaseViewController {

    @IBOutlet weak var categoryOuterView: UIView!
    
    @IBOutlet weak var stateOuterView: UIView!
    
    @IBOutlet weak var cropOuterView: UIView!
    
    @IBOutlet weak var hybridOuterView: UIView!
    
    @IBOutlet weak var seasonOuterView: UIView!
    
    @IBOutlet weak var dateOfSowingOuterView: UIView!
    
    @IBOutlet weak var acresSowedOuterView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var categoryTxtFld: UITextField!
    
    @IBOutlet weak var stateTxtFld: UITextField!
    
    @IBOutlet weak var cropTxtFld: UITextField!
    
    @IBOutlet weak var hybridNameTxtFld: UITextField!
    
    @IBOutlet weak var seasonTxtFLd: UITextField!
    
    @IBOutlet weak var dateOfSowingTxtFLd: UITextField!
    
    @IBOutlet weak var acresSowedTxtFLd: UITextField!
    
    @IBOutlet weak var lblNoDataAvailable: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    var categoryDropDownTblView = UITableView()
    var stateDropDownTblView = UITableView()
    var cropDropDownTblView = UITableView()
    var hybridNameTblView = UITableView()
    var seasonTblView = UITableView()
    
    var categoryNamesArray = NSMutableArray()
    var stateNamesArray = NSMutableArray()
    var cropNamesArray = NSMutableArray()
    var hybridNameArray = NSMutableArray()
    var seasonNamesArray = NSMutableArray()
    
    var categoryArray = NSArray()
    var stateArray = NSArray()
    var cropArray = NSArray()
    var hybridArray = NSArray()
    var seasonArray = NSArray()
    
    var categoryID = NSString()
    var stateID = NSString()
    var cropID = NSString()
    var hybridID = NSString()
    var seasonID = NSString()
    
    var dobView = UIView()
    
    var seasonStartDateStr: String?
    var seasonEndDateStr: String?
    
    var registrationSuccessAlert: UIView?
    var FinalArray = NSMutableArray()
    
    
    //MARK:- SUBSCRIPTION VARIABLES
    var subscriptionTransperentWindow = UIView()
    var subscriptionBgWindow = UIView()
    var subscription_titleLbl = UIView()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        let acresSowedMaxY = acresSowedOuterView.frame.maxY
         print("acresSowedMaxY: \(acresSowedMaxY)")
        if acresSowedMaxY > screenHeight-40{
            scrollView.isScrollEnabled = true
        }
        else{
            scrollView.isScrollEnabled = false
        }
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CropAdvisoryRegistrationViewController.contentViewTapGestureRecognizer(_:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        contentView.addGestureRecognizer(singleTapGestureRecognizer)
        
        contentView.isHidden = false
        btnSubmit.isHidden = false
        lblNoDataAvailable.isHidden = true
        
        categoryTxtFld.leftViewMode = .always
        categoryTxtFld.contentVerticalAlignment = .center
        categoryTxtFld.setLeftPaddingPoints(10)
        categoryTxtFld.tintColor = UIColor.clear
        
        stateTxtFld.leftViewMode = .always
        stateTxtFld.contentVerticalAlignment = .center
        stateTxtFld.setLeftPaddingPoints(10)
        stateTxtFld.tintColor = UIColor.clear
        
        cropTxtFld.leftViewMode = .always
        cropTxtFld.contentVerticalAlignment = .center
        cropTxtFld.setLeftPaddingPoints(10)
        cropTxtFld.tintColor = UIColor.clear
        
        hybridNameTxtFld.leftViewMode = .always
        hybridNameTxtFld.contentVerticalAlignment = .center
        hybridNameTxtFld.setLeftPaddingPoints(10)
        hybridNameTxtFld.tintColor = UIColor.clear
        
        seasonTxtFLd.leftViewMode = .always
        seasonTxtFLd.contentVerticalAlignment = .center
        seasonTxtFLd.setLeftPaddingPoints(10)
        seasonTxtFLd.tintColor = UIColor.clear
        
        dateOfSowingTxtFLd.leftViewMode = .always
        dateOfSowingTxtFLd.contentVerticalAlignment = .center
        dateOfSowingTxtFLd.setLeftPaddingPoints(10)
        dateOfSowingTxtFLd.tintColor = UIColor.clear
        
        acresSowedTxtFLd.leftViewMode = .always
        acresSowedTxtFLd.contentVerticalAlignment = .center
        acresSowedTxtFLd.setLeftPaddingPoints(10)
        acresSowedTxtFLd.keyboardType = .numberPad
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let currentDateStr = dateFormatter.string(from: Date()) as String
        dateOfSowingTxtFLd.text = currentDateStr
        
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
           
            //category dropdown tableView
            self.loadDropDownTableView(tableViewDataSource: self, tableViewDelegate: self, tableview: categoryDropDownTblView, textField: categoryTxtFld)
            categoryDropDownTblView.dataSource = self
            categoryDropDownTblView.delegate = self

            //state dropdown tableView
            self.loadDropDownTableView(tableViewDataSource: self, tableViewDelegate: self, tableview: stateDropDownTblView, textField: stateTxtFld)
            stateDropDownTblView.dataSource = self
            stateDropDownTblView.delegate = self

            //crop dropdown tableView
            self.loadDropDownTableView(tableViewDataSource: self, tableViewDelegate: self, tableview: cropDropDownTblView, textField: cropTxtFld)
            cropDropDownTblView.dataSource = self
            cropDropDownTblView.delegate = self

            //hybrid dropdown tableView
            self.loadDropDownTableView(tableViewDataSource: self, tableViewDelegate: self, tableview: hybridNameTblView, textField: hybridNameTxtFld)
            hybridNameTblView.dataSource = self
            hybridNameTblView.delegate = self

            //season dropdown tableView
            self.loadDropDownTableView(tableViewDataSource: self, tableViewDelegate: self, tableview: seasonTblView, textField: seasonTxtFLd)
            seasonTblView.dataSource = self
            seasonTblView.delegate = self
            
            let params =  ["data": ""]
            self.requestToGetCropAdvisoryData(Params: params as [String:String])
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
       // self.recordScreenView("CropAdvisoryRegistrationViewControllCrop_Advisori_Registration_newcreen)
        self.registerFirebaseEvents(PV_CA_Registration, "", "", "", parameters: nil)
        self.contentView.isUserInteractionEnabled = true
    }
    
    @objc func contentViewTapGestureRecognizer(_ tapGesture:UITapGestureRecognizer) {
        view.endEditing(true)
        categoryDropDownTblView.isHidden = true
        stateDropDownTblView.isHidden = true
        cropDropDownTblView.isHidden = true
        hybridNameTblView.isHidden = true
        seasonTblView.isHidden = true
    }
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //var touch: UITouch? = touches.first as? UITouch
        //location is relative to the current view
        // do something with the touched point
        // if touch?.view != yourView {
        categoryDropDownTblView.isHidden = true
        stateDropDownTblView.isHidden = true
        cropDropDownTblView.isHidden = true
        hybridNameTblView.isHidden = true
        seasonTblView.isHidden = true
        //}
    }
    
    override open  func viewWillAppear(_ animated: Bool) {
        self.topView?.isHidden = false
        self.homeButton?.isHidden = true
        self.lblTitle?.text = "Crop Advisory Registration"
        self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
      
    }
    
    override open func backButtonClick(_ sender: UIButton) {
      //  self.findHamburguerViewController()?.showMenuViewController()
    }
    
    func updateDeepLinkParametersToUI(){
        self.categoryDropDownTblView.reloadData()
        self.stateDropDownTblView.reloadData()
        self.cropDropDownTblView.reloadData()
        self.hybridNameTblView.reloadData()
        self.seasonTblView.reloadData()
        self.refreshTextFields()
        
        if let deeplinkTempParams = self.deeplinkParams as NSDictionary? {
            if let categoryId = deeplinkTempParams.value(forKey: User_Category) as? String{
                if let categoryName = self.getFieldNameFromDeepLinkParameterId(categoryId, objectsArray: self.categoryNamesArray) as String?{
                    self.categoryID = categoryId as NSString
                    self.categoryTxtFld.text = categoryName
                }
                else{
                    if let categoryDic = self.categoryArray.lastObject as? NSDictionary{
                        self.categoryID = categoryDic.value(forKey: "id") as? NSString ?? ""
                        self.categoryTxtFld.text = categoryDic.value(forKey: "name") as? String
                        self.filterStatesWithCategory(categoryDic: categoryDic)
                    }
                }
            }
            if let tempStateId = deeplinkTempParams.value(forKey: State_Id) as? String{
                if let stateName = self.getFieldNameFromDeepLinkParameterId(tempStateId, objectsArray: self.stateArray) as String?{
                    self.stateTxtFld.text = stateName
                    self.stateID = tempStateId as NSString
                }
                else{
                    if let stateDic = self.stateArray.lastObject as? NSDictionary{
                        self.stateID = stateDic.value(forKey: "id") as? NSString ?? ""
                        self.stateTxtFld.text = stateDic.value(forKey: "name") as? String
                        if let categoryDic = self.getDropdownValuesDicFromId(self.categoryID as String, objectsArray: self.categoryArray) as NSDictionary?{
                            self.filterCropsWithCategoryAndState(categoryDic: categoryDic, stateDic: stateDic)
                        }
                    }
                }
            }
            if let tempCropId = deeplinkTempParams.value(forKey: Crop_Id) as? String{
                if let cropName = self.getFieldNameFromDeepLinkParameterId(tempCropId, objectsArray: self.cropArray) as String?{
                    self.cropTxtFld.text = cropName
                    self.cropID = tempCropId as NSString
                }
                else{
                    if let cropDic = self.cropArray.lastObject as? NSDictionary{
                        self.cropID = cropDic.value(forKey: "id") as? NSString ?? ""
                        self.cropTxtFld.text = cropDic.value(forKey: "name") as? String
                        if let categoryDic = self.getDropdownValuesDicFromId(self.categoryID as String, objectsArray: self.categoryArray) as NSDictionary?{
                            if let stateDic = self.getDropdownValuesDicFromId(self.stateID as String, objectsArray: self.stateArray) as NSDictionary?{
                                self.filterHybridWithCategoryAndStaeAndCrop(categoryDic: categoryDic, stateDic: stateDic, cropDic: cropDic)
                            }
                        }
                    }
                }
            }
            if let tempHybridId = deeplinkTempParams.value(forKey: Hybrid_Id) as? String{
                if let hybridName = self.getFieldNameFromDeepLinkParameterId(tempHybridId, objectsArray: self.hybridNameArray) as String?{
                    self.hybridNameTxtFld.text = hybridName
                    self.hybridID = tempHybridId as NSString
                }
                else{
                    if let hybridDic = self.hybridArray.lastObject as? NSDictionary{
                        self.hybridID = hybridDic.value(forKey: "id") as? NSString ?? ""
                        self.hybridNameTxtFld.text = hybridDic.value(forKey: "name") as? String
                        if let categoryDic = self.getDropdownValuesDicFromId(self.categoryID as String, objectsArray: self.categoryArray) as NSDictionary?{
                            if let stateDic = self.getDropdownValuesDicFromId(self.stateID as String, objectsArray: self.stateArray) as NSDictionary?{
                                if let cropDic = self.getDropdownValuesDicFromId(self.cropID as String, objectsArray: self.cropArray) as NSDictionary?{
                                    self.filterSeasonWithCategoryAndStaeAndCropAndHybrid(categoryDic: categoryDic, stateDic: stateDic, cropDic: cropDic, hybridDic: hybridDic)
                                }
                            }
                        }
                    }
                }
            }
            if let tempSeasonId = deeplinkTempParams.value(forKey: Season_Id) as? String{
                if let seasonName = self.getFieldNameFromDeepLinkParameterId(tempSeasonId, objectsArray: self.seasonArray) as String?{
                    self.seasonID = tempSeasonId as NSString
                    self.seasonTxtFLd.text = seasonName
                    if seasonArray.count > 0{
                        if let seasonDic = self.getDropdownValuesDicFromId(tempSeasonId, objectsArray: self.seasonArray) as NSDictionary?{
                            self.seasonStartDateStr = seasonDic.value(forKey: "startDate") as? String ?? ""
                            if let startDate = FarmServicesConstants.getDateStringFromDateStringWithShortFormat(serverDate: self.seasonStartDateStr) as String?{
                                self.dateOfSowingTxtFLd.text = startDate
                            }
                            self.seasonEndDateStr = seasonDic.value(forKey: "endDate") as? String ?? ""
                        }
                    }
                }
                else{
                    if let seasonDic = self.seasonArray.lastObject as? NSDictionary{
                        self.seasonID = seasonDic.value(forKey: "id") as? NSString ?? ""
                        self.seasonTxtFLd.text = seasonDic.value(forKey: "name") as? String
                        self.seasonStartDateStr = seasonDic.value(forKey: "startDate") as? String ?? ""
                        if let startDate = FarmServicesConstants.getDateStringFromDateStringWithShortFormat(serverDate: self.seasonStartDateStr) as String?{
                            self.dateOfSowingTxtFLd.text = startDate
                        }
                        self.seasonEndDateStr = seasonDic.value(forKey: "endDate") as? String ?? ""
                    }
                }
            }

            if let startDate = deeplinkTempParams.value(forKey: Season_Start_Date) as? String{
                self.seasonStartDateStr = startDate
                let dateFormatter: DateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.date(from: startDate)
                dateFormatter.dateFormat = "dd-MMM-yyyy"
                let strDateToServer = dateFormatter.string(from: date!)
                self.dateOfSowingTxtFLd.text = strDateToServer
            }
            if let endDate = deeplinkTempParams.value(forKey: Season_End_Date) as? String{
                self.seasonEndDateStr = endDate
            }
        }
    }
    
    func getFieldNameFromDeepLinkParameterId(_ paramId:String, objectsArray:NSArray) -> String?{
        let filterPredicate = NSPredicate(format: "id = %@", paramId)
        let filterArray = objectsArray.filtered(using: filterPredicate) as NSArray?
        if filterArray?.count ?? 0 > 0{
            if let seasonDic = filterArray?.lastObject as? NSDictionary{
                if let categoryName = seasonDic.value(forKey: "name") as? String{
                    return categoryName
                }
            }
        }
        return nil
    }
    func getDropdownValuesDicFromId(_ paramId:String, objectsArray:NSArray) -> NSDictionary?{
        let filterPredicate = NSPredicate(format: "id = %@", paramId)
        let filterArray = objectsArray.filtered(using: filterPredicate) as NSArray?
        if filterArray?.count ?? 0 > 0{
            if let seasonDic = filterArray?.lastObject as? NSDictionary{
                return seasonDic
            }
            else{
                if let seasonDic = objectsArray.lastObject as? NSDictionary{
                    return seasonDic
                }
            }
        }
        else{
            if let seasonDic = objectsArray.lastObject as? NSDictionary{
                return seasonDic
            }
        }
        return nil
    }
    //MARK: dobPickerView
    func dobPickerView(){
        let Height:CGFloat = (44.11 * self.view.frame.height/120)
        let width :CGFloat = self.view.frame.size.width-40 //-40
        let posX :CGFloat = (self.view.frame.size.width - width) / 2
        
        dobView = UIView (frame: CGRect(x: posX,y: (self.view.frame.height-Height)/2 ,width: width,height: Height))
        dobView.backgroundColor = UIColor(red: 244/255, green: 242/255, blue: 242/255, alpha: 1.0)
        dobView.layer.cornerRadius = 10.0
        self.view.addSubview(dobView)
        
        //dobPicker
        let dobPicker : UIDatePicker = UIDatePicker (frame: CGRect(x: 5,y: 5,width: width-10,height: Height-50))
        dobPicker.backgroundColor = UIColor.white
        dobPicker.layer.cornerRadius = 5.0
       // UIDatePicker.ModeickerMode = UIDatePicker.Mode.date
        
        
        if Validations.isNullString(self.seasonStartDateStr! as NSString) == false{
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateToSetOnPicker = dateFormatter.date(from: self.seasonStartDateStr!)
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            let str = dateFormatter.string(from: dateToSetOnPicker!)
            dobPicker.minimumDate = dateFormatter.date(from: str)//NSDate() as Date
            
            let dateToSetStr = dateFormatter.string(from: dateToSetOnPicker!)
            dobPicker.date = dateFormatter.date(from: dateToSetStr)!
            if Validations.isNullString(dateOfSowingTxtFLd.text as NSString? ?? "" as NSString) == false{
                if let selectedDate = dateFormatter.date(from: dateOfSowingTxtFLd.text ?? "") as Date?{
                    dobPicker.date = selectedDate
                }
            }
        }
        else{
            //dobPicker.minimumDate = NSDate() as Date
            
//            let dateFormatter: DateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "dd-MMM-yyyy"
//            let currentDateStr = dateFormatter.string(from: Date()) as String
//            dateOfSowingTxtFLd.text = currentDateStr
        }
        
        if Validations.isNullString(self.seasonEndDateStr! as NSString) == false{
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateToSetOnPicker = dateFormatter.date(from: self.seasonEndDateStr!)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let str = dateFormatter.string(from: dateToSetOnPicker!)
            dobPicker.maximumDate = dateFormatter.date(from: str)//NSDate() as Date
            
            //let dateToSetStr = dateFormatter.string(from: dateToSetOnPicker!)
            //dobPicker.date = dateFormatter.date(from: dateToSetStr)!
        }
        else{
            dobPicker.maximumDate = NSDate() as Date
        }
        
        dobPicker.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: .valueChanged)
        dobView.addSubview(dobPicker)
        
        //submit button
        let btnOK : UIButton = UIButton (frame: CGRect(x: 0, y: dobPicker.frame.maxY+5,width: width,height: 40))
        btnOK.backgroundColor = UIColor(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 0.8)
//        btnOK.layer.cornerRadius = 5.0
//        UIControl.State("OK", for: UIControl.State())
//      //  btnOK.addTarget(self, action: #selector(CropAdvisoryRegistrationViUIControl.EventertOK), for: UIControlEvents.touchUpInside)
//        dobView.addSubview(btnOK)
        
        let dobFrame = dobView.frame
        dobView.frame.size.height = btnOK.frame.maxY
        dobView.frame = dobFrame
        
        dobView.frame.origin.y = (self.view.frame.size.height - 64 - dobView.frame.size.height) / 2
        dobView.frame = dobFrame
    }
    
    //MARK: datePickerValueChanged
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let selectedDate = dateFormatter.string(from: sender.date) as NSString
        //print("Selected value \(selectedDate)")
        self.dateOfSowingTxtFLd.text = selectedDate as String
    }
    
    @objc func alertOK(){
        self.dobView.removeFromSuperview()
    }
    
    //MARK: requestToGetCropAdvisoryData
    /**
     This method is used to get the crop advisory data from server
     - Parameter Params: [String:String]
     */
    func requestToGetCropAdvisoryData (Params : [String:String]){
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_CROP_ADVISORY_DATA])
       
        let userObj = Constatnts.getUserObject()
        
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        print(headers)
        Alamofire.request(urlString, method: .post, parameters: Params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                print(response)
                if let json = response.result.value {
                     let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                       // print("Response after decrypting data:\(decryptData)")
                        
                        if let categoriesArray = decryptData.value(forKey: "categoryMaster") as? NSArray{
                            let categoryNamesSet =  NSSet(array:categoriesArray as! [Any])
                            self.categoryArray = categoryNamesSet.allObjects as NSArray
                            //self.categoryNamesArray.addObjects(from: categoriesArray as! [Any])
                            self.categoryNamesArray.addObjects(from: categoryNamesSet.allObjects)
                        }
                        if let statesArray = decryptData.value(forKey: "stateCodeMaster") as? NSArray{
                            let statesNamesSet =  NSSet(array:statesArray as! [Any])
                            self.stateArray = statesNamesSet.allObjects as NSArray
                            self.stateNamesArray.addObjects(from: statesNamesSet.allObjects)
                        }
                        if let cropsArray = decryptData.value(forKey: "cropMaster") as? NSArray{
                            let cropsNamesSet =  NSSet(array:cropsArray as! [Any])
                            self.cropArray = cropsNamesSet.allObjects as NSArray
                            self.cropNamesArray.addObjects(from: cropsNamesSet.allObjects)
                        }
                        if let hybridsArray = decryptData.value(forKey: "hybridMaster") as? NSArray{
                            let hybridNamesSet =  NSSet(array:hybridsArray as! [Any])
                            self.hybridArray = hybridNamesSet.allObjects as NSArray
                            self.hybridNameArray.addObjects(from: hybridNamesSet.allObjects)
                        }
                        if let seasonsArray = decryptData.value(forKey: "seasonMaster") as? NSArray{
                            let seasonNamesSet =  NSSet(array: seasonsArray as! [Any])
                            self.seasonArray = seasonNamesSet.allObjects as NSArray
                            self.seasonNamesArray.addObjects(from: seasonNamesSet.allObjects)
                        }
                        DispatchQueue.main.async {
                            if self.isFromDeeplink == true{
                                self.updateDeepLinkParametersToUI()
                            }
                            else{
                                self.updateUI()
                            }
                        }
                    }
                    else if responseStatusCode == CROP_ADVISORY_NOT_AVAILABLE_151{
                        self.contentView.isHidden = true
                        self.btnSubmit.isHidden = true
                        self.lblNoDataAvailable.isHidden = false
                        self.lblNoDataAvailable.text = (json as! NSDictionary).value(forKey: "message") as? String
                    } else if responseStatusCode == STATUS_CODE_105{
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    else if responseStatusCode == STATUS_CODE_601{
                         Constatnts.logOut()
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
    
    //MARK: UpdateUI
    /**
     This method is used to reload all the tableViews and textFields data
     */
    func updateUI(){
        self.categoryDropDownTblView.reloadData()
        self.stateDropDownTblView.reloadData()
        self.cropDropDownTblView.reloadData()
        self.hybridNameTblView.reloadData()
        self.seasonTblView.reloadData()
        self.refreshTextFields()
        
        if let startDate = self.seasonNamesArray.object(at: 0) as? NSDictionary{
            self.seasonStartDateStr = startDate.value(forKey: "startDate") as? String
            if let startDate = FarmServicesConstants.getDateStringFromDateStringWithShortFormat(serverDate: self.seasonStartDateStr) as String?{
                self.dateOfSowingTxtFLd.text = startDate
            }
        }
        if let endDate = self.seasonNamesArray.object(at: 0) as? NSDictionary{
            self.seasonEndDateStr = endDate.value(forKey: "endDate") as? String
        }
    }

    //MARK: filterStatesWithCategory
    /**
     This method is used to filter the States Array with categoryID
     - Parameter categoryDic: NSDictionary?
     */
    func filterStatesWithCategory(categoryDic: NSDictionary?){
        if categoryDic != nil {
            categoryID = categoryDic!.value(forKey: "id") as! String as NSString
            //state
            let statePredicate = NSPredicate(format: "categoryId = %@",categoryID)
            let stateFilteredArr = (self.stateArray).filtered(using: statePredicate) as NSArray
            //print("state data array : \(stateFilteredArr)")
            self.stateNamesArray.removeAllObjects()
            self.stateNamesArray.addObjects(from: stateFilteredArr as! [Any])
            self.stateDropDownTblView.reloadData()
            //get state id
            if stateFilteredArr.count > 0{
                if let stateDic = stateFilteredArr.firstObject as? NSDictionary{
                    stateTxtFld.text = stateDic.value(forKey: "name") as? String
                    stateID = stateDic.value(forKey: "id") as! String as NSString
                    self.filterCropsWithCategoryAndState(categoryDic: categoryDic, stateDic: stateDic)
                }
            }
        }
    }
    
    //MARK: filterCropsWithCategoryAndState
    /**
     This method is used to filter the Crops Array with categoryID and stateID
     - Parameter categoryDic: NSDictionary?
     - Parameter stateDic: NSDictionary?
     */
    func filterCropsWithCategoryAndState(categoryDic: NSDictionary?, stateDic: NSDictionary?){
        if categoryDic != nil && stateDic != nil {
            categoryID = categoryDic!.value(forKey: "id") as! String as NSString
            stateID = stateDic!.value(forKey: "id") as! String as NSString
            let cropPredicate = NSPredicate(format: "(categoryId == %@) AND (stateId == %@)",categoryID,stateID)
            let cropFilteredArr = (self.cropArray).filtered(using: cropPredicate) as NSArray
            if cropFilteredArr.count > 0{
                if let cropDic = cropFilteredArr.firstObject as? NSDictionary{
                    // print("crop data array : \(cropFilteredArr)")
                    self.cropNamesArray.removeAllObjects()
                    self.cropNamesArray.addObjects(from: cropFilteredArr as! [Any])
                    // print(self.cropNamesArray)
                    self.cropDropDownTblView.reloadData()
                    //get crop id
                    cropTxtFld.text = cropDic.value(forKey: "name") as? String
                    cropID = cropDic.value(forKey: "id") as! String as NSString
                    self.filterHybridWithCategoryAndStaeAndCrop(categoryDic: categoryDic, stateDic: stateDic, cropDic: cropDic)
                }
            }
        }
    }
    
    //MARK: filterHybridWithCategoryAndStaeAndCrop
    /**
     This method is used to filter the Hybrids Array with categoryID,stateID and cropID
     - Parameter categoryDic: NSDictionary?
     - Parameter stateDic: NSDictionary?
     - Parameter cropDic: NSDictionary?
     */
    func filterHybridWithCategoryAndStaeAndCrop(categoryDic: NSDictionary?, stateDic: NSDictionary?,cropDic: NSDictionary?){
        if categoryDic != nil && stateDic != nil && cropDic != nil {
            categoryID = categoryDic!.value(forKey: "id") as! String as NSString
            stateID = stateDic!.value(forKey: "id") as! String as NSString
            cropID = cropDic!.value(forKey: "id") as! String as NSString
            let hybridPredicate = NSPredicate(format: "(categoryId == %@) AND (stateId == %@) AND (cropId == %@)",categoryID,stateID,cropID)
            let hybridFilterArray = self.hybridArray.filtered(using: hybridPredicate)
            if hybridFilterArray.count > 0{
                self.hybridNameArray.removeAllObjects()
                self.hybridNameArray.addObjects(from: hybridFilterArray)
                if let hybridDic = hybridNameArray.firstObject as? NSDictionary{
                    self.hybridNameTxtFld.text = hybridDic.value(forKey: "name") as? String
                    hybridID = hybridDic.value(forKey: "id") as! String as NSString
                    self.hybridNameTblView.reloadData()
                    self.filterSeasonWithCategoryAndStaeAndCropAndHybrid(categoryDic: categoryDic, stateDic: stateDic, cropDic: cropDic, hybridDic: hybridDic)
                }
            }
        }
    }
    
    //MARK: filterSeasonWithCategoryAndStaeAndCropAndHybrid
    /**
     This method is used to filter the Hybrids Array with categoryID,stateID,cropID and hybridID
     - Parameter categoryDic: NSDictionary?
     - Parameter stateDic: NSDictionary?
     - Parameter cropDic: NSDictionary?
     - Parameter hybridDic: NSDictionary?
     */
    func filterSeasonWithCategoryAndStaeAndCropAndHybrid(categoryDic: NSDictionary?, stateDic: NSDictionary?,cropDic: NSDictionary?,hybridDic: NSDictionary?){
        if categoryDic != nil && stateDic != nil && cropDic != nil && hybridDic != nil {
            categoryID = categoryDic!.value(forKey: "id") as! String as NSString
            stateID = stateDic!.value(forKey: "id") as! String as NSString
            cropID = cropDic!.value(forKey: "id") as! String as NSString
            hybridID = hybridDic!.value(forKey: "id") as! String as NSString
            let seasonPredicate = NSPredicate(format: "(categoryId == %@) AND (stateId == %@) AND (cropId == %@) AND (hybridId == %@)",categoryID,stateID,cropID,hybridID)
            let seasonFilteredArr = (self.seasonArray).filtered(using: seasonPredicate)
            // print("season data array : \(seasonFilteredArr)")
            if seasonFilteredArr.count>0 {
                self.seasonNamesArray.removeAllObjects()
                self.seasonNamesArray.addObjects(from: seasonFilteredArr)
                // print(self.seasonNamesArray)
                self.seasonTblView.reloadData()
                if let seasonDic = seasonFilteredArr.first as? NSDictionary{
                    seasonTxtFLd.text = seasonDic.value(forKey: "name") as? String
                    seasonID = seasonDic.value(forKey: "id") as! String as NSString
                    self.seasonStartDateStr = seasonDic.value(forKey: "startDate") as? String ?? ""
                    if let startDate = FarmServicesConstants.getDateStringFromDateStringWithShortFormat(serverDate: self.seasonStartDateStr) as String?{
                        self.dateOfSowingTxtFLd.text = startDate
                    }
                    self.seasonEndDateStr = seasonDic.value(forKey: "endDate") as? String ?? ""
                }
            }
            }
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitBtn_Touch_Up_Inside(_ sender: Any) {
       let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
//            if Validations.isNullString(acresSowedTxtFLd.text! as NSString) {
//                self.view.makeToast(Please_Enter_Acres_Sowed)
//                return
//            }
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            let date = dateFormatter.date(from: self.dateOfSowingTxtFLd.text!)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let strDateToServer = dateFormatter.string(from: date!)
            print(strDateToServer)
            let userObj = Constatnts.getUserObject()
          /*  let parameters = ["customerId":userObj.customerId! as String,
                              "category":categoryID as String,
                              "state":stateID as String,
                              "crop":cropID as String,
                              "hybrid":hybridID as String,
                              "season":seasonID as String,
                              "sowingDate":strDateToServer,
                              "acressowed":acresSowedTxtFLd.text!] as NSDictionary*/
            
            let parameters = [ "category":categoryID as String,
                              "state":stateID as String,
                              "crop":cropID as String,
                              "hybrid":hybridID as String
                             ] as NSDictionary
            print(parameters)
            let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
            let params =  ["data" : paramsStr]
            print(params)
            
//            //getListOfCropsCA
//            BaseClass.submitCropFilterUserData(dic : parameters as NSDictionary) { (status, responseArray,message) in
//                if status == true{
//                    self.FinalArray.removeAllObjects()
//                    let dicP = responseArray?.object(forKey: "crops") as? NSArray ?? []
//
//                    self.FinalArray = NSMutableArray(array:dicP )
//                    print(dicP)
//                    if( self.FinalArray.count>0){
//
//                        let toCropSelected = self.storyboard?.instantiateViewController(withIdentifier: "CropAdvisoryCropController") as? CropAdvisoryCropController
//                        toCropSelected?.categoryCropArray = self.FinalArray
//                        self.navigationController?.pushViewController(toCropSelected!, animated: true)
//                    }
////                    let arrayResponse = responseArray?.object(forKey: "rootsUserDataList") as? NSArray ?? []
////                    for i in 0..<arrayResponse.count{
////                        let dic = arrayResponse.object(at: i) as? NSDictionary ?? [:]
////                        let dicObj = RootsUserDataEmpBO(dict: dic)
////                        self.FinalArray.addObjects(from: [dicObj])
////                    }
//
//
//
//                    print("final array :%@",self.FinalArray)
//                }
//                else{
//
//                }
//
//           // self.requestToRegisterCropAdvisoryData(params: params as [String:String])
//         /*   let fireBaseParams = [MOBILE_NUMBER : userObj.mobileNumber!,USER_ID : userObj.customerId!,CROP:cropTxtFld.text!,SEASON:seasonTxtFLd.text!,HYBRID:hybridNameTxtFld.text!,STATE: stateTxtFld.text!,ACERS_SOWED:acresSowedTxtFLd.text!] as [String : Any]
//            self.registerFirebaseEvents(CA_Submit, "", "", "", parameters: fireBaseParams as NSDictionary)*/
//        }
//
        
        
        
      
        
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
    }
    
    //MARK: requestToRegisterCropAdvisoryData
    func requestToRegisterCropAdvisoryData(params: [String:String]){
        
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,REGISTER_CROP_ADVISORY_DATA])
        
        let userObj = Constatnts.getUserObject()
        
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        print(headers)
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    if let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String{
                        if responseStatusCode == STATUS_CODE_200{
                            //                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                            //                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                            //                        print("Response after decrypting data:\(decryptData)")
                            
                            //self.view.makeToast((json as! NSDictionary).value(forKey: "message") as! String)
                            if let successMsg = (json as! NSDictionary).value(forKey: "message") as? String{
                                if self.registrationSuccessAlert != nil{
                                    self.registrationSuccessAlert?.removeFromSuperview()
                                }
                                self.registrationSuccessAlert = CustomAlert.alertInfoPopUpView(self, frame: self.view.frame, title: "Congratulations",message:successMsg as NSString, buttonTitle: "OK", hideClose: true) as? UIView
                                self.view.addSubview(self.registrationSuccessAlert!)
                            }
                        }
                        else if responseStatusCode == CROP_ADVISORY_NOT_AVAILABLE_151{
                            self.view.makeToast((json as! NSDictionary).value(forKey: "message") as! String)
                        }
                        else if responseStatusCode == STATUS_CODE_105{
                            self.view.makeToast((json as! NSDictionary).value(forKey: "message") as! String)
                            self.navigationController?.popViewController(animated: true)
                        }
                        else if responseStatusCode == STATUS_CODE_601{
                            Constatnts.logOut()
                            if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                self.view.makeToast(msg as String)
                            }
                        }
                        else{
                            self.view.makeToast((json as! NSDictionary).value(forKey: "message") as! String)
                        }
                    }
                }
            }
            else{
                self.view.makeToast((response.error?.localizedDescription)!)
            }
        }
    }
    
    @objc func infoAlertSubmit(){
        if self.registrationSuccessAlert != nil {
            self.registrationSuccessAlert?.removeFromSuperview()
            self.registrationSuccessAlert = nil
            if let startDate = self.seasonNamesArray.object(at: 0) as? NSDictionary{
                self.seasonStartDateStr = startDate.value(forKey: "startDate") as? String
                if let startDate = FarmServicesConstants.getDateStringFromDateStringWithShortFormat(serverDate: self.seasonStartDateStr) as String?{
                    self.dateOfSowingTxtFLd.text = startDate
                }
            }
            self.acresSowedTxtFLd.text = ""
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

extension CropAdvisoryRegistrationViewController :  UITableViewDataSource, UITableViewDelegate{
    //MARK: dropdown tableview datasopublic urce & delegate methods
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == categoryDropDownTblView {
            return categoryNamesArray.count
        }
        else if tableView == stateDropDownTblView {
            return stateNamesArray.count
        }
        else if tableView == cropDropDownTblView {
            return cropNamesArray.count
        }
        else if tableView == hybridNameTblView {
            return hybridNameArray.count
        }
        else{
            return seasonNamesArray.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellIdentifier)
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 14.0)
        if tableView == categoryDropDownTblView {
            let categoryDic = categoryNamesArray.object(at: indexPath.row) as? NSDictionary
            cell.textLabel?.text = categoryDic?.value(forKey: "name") as? String
        }
        else if tableView == stateDropDownTblView {
            let stateyDic = stateNamesArray.object(at: indexPath.row) as? NSDictionary
            cell.textLabel?.text = stateyDic?.value(forKey: "name") as? String
        }
        else if tableView == cropDropDownTblView {
            let stateDic = cropNamesArray.object(at: indexPath.row) as? NSDictionary
            cell.textLabel?.text = stateDic?.value(forKey: "name") as? String
        }
        else if tableView == hybridNameTblView {
            let hybridDic = hybridNameArray.object(at: indexPath.row) as? NSDictionary
            cell.textLabel?.text = hybridDic?.value(forKey: "name") as? String
        }
        else{
            let seasonDic = seasonNamesArray.object(at: indexPath.row) as? NSDictionary
            cell.textLabel?.text = seasonDic?.value(forKey: "name") as? String
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        if tableView == categoryDropDownTblView {
            let categoryDic = self.categoryNamesArray.object(at: indexPath.row) as? NSDictionary
            categoryID = categoryDic!.value(forKey: "id") as! String as NSString
            categoryTxtFld.text = categoryDic?.value(forKey: "name") as? String
            self.filterStatesWithCategory(categoryDic: categoryDic)
            categoryDropDownTblView.isHidden = true
            categoryTxtFld.resignFirstResponder()
        }
        else if tableView == stateDropDownTblView {
            let stateDic = self.stateNamesArray.object(at: indexPath.row) as? NSDictionary
            stateID = stateDic!.value(forKey: "id") as! String as NSString
            stateTxtFld.text = stateDic?.value(forKey: "name") as? String
            
            let categoryPredicate = NSPredicate(format: "name = %@",categoryTxtFld.text!)
            let categoryFilterArray = (self.categoryNamesArray).filtered(using: categoryPredicate) as NSArray
            let categoryDic = categoryFilterArray.firstObject as? NSDictionary
            
            self.filterCropsWithCategoryAndState(categoryDic: categoryDic, stateDic: stateDic)
            stateDropDownTblView.isHidden = true
            stateTxtFld.resignFirstResponder()
        }
        else if tableView == cropDropDownTblView {
            //get crop id
            let cropDic = self.cropNamesArray.object(at: indexPath.row) as? NSDictionary
            cropID = cropDic!.value(forKey: "id") as! String as NSString
            cropTxtFld.text = cropDic?.value(forKey: "name") as? String
            
            let categoryPredicate = NSPredicate(format: "name = %@",categoryTxtFld.text!)
            let categoryFilterArray = (self.categoryNamesArray).filtered(using: categoryPredicate) as NSArray
            let categoryDic = categoryFilterArray.firstObject as? NSDictionary
            
            let statePredicate = NSPredicate(format: "name = %@",stateTxtFld.text!)
            let statesFilterArray = (self.stateNamesArray).filtered(using: statePredicate) as NSArray
            let stateDic = statesFilterArray.firstObject as? NSDictionary
            
            self.filterHybridWithCategoryAndStaeAndCrop(categoryDic: categoryDic, stateDic: stateDic, cropDic: cropDic)
            cropDropDownTblView.isHidden = true
            cropTxtFld.resignFirstResponder()
        }
        else if tableView == hybridNameTblView {
            
            let hybridDic = self.hybridNameArray.object(at: indexPath.row) as? NSDictionary
            hybridID = hybridDic!.value(forKey: "id") as! String as NSString
            hybridNameTxtFld.text = hybridDic?.value(forKey: "name") as? String
            
            let categoryPredicate = NSPredicate(format: "name = %@",categoryTxtFld.text!)
            let categoryFilterArray = (self.categoryNamesArray).filtered(using: categoryPredicate) as NSArray
            let categoryDic = categoryFilterArray.firstObject as? NSDictionary
            
            let statePredicate = NSPredicate(format: "name = %@",stateTxtFld.text!)
            let statesFilterArray = (self.stateNamesArray).filtered(using: statePredicate) as NSArray
            let stateDic = statesFilterArray.firstObject as? NSDictionary
            
            let cropPredicate = NSPredicate(format: "name = %@",cropTxtFld.text!)
            let cropsFilterArray = (self.cropNamesArray).filtered(using: cropPredicate) as NSArray
            let cropDic = cropsFilterArray.firstObject as? NSDictionary
            
            self.filterSeasonWithCategoryAndStaeAndCropAndHybrid(categoryDic: categoryDic, stateDic: stateDic, cropDic: cropDic, hybridDic: hybridDic)
            hybridNameTblView.isHidden = true
            hybridNameTxtFld.resignFirstResponder()
        }
        else{
            if let seasonDic = self.seasonNamesArray.object(at: indexPath.row) as? NSDictionary{
                seasonID = seasonDic.value(forKey: "id") as! String as NSString
                seasonTxtFLd.text = seasonDic.value(forKey: "name") as? String
                seasonTblView.isHidden = true
                seasonTxtFLd.resignFirstResponder()
                self.seasonStartDateStr = seasonDic.value(forKey: "startDate") as? String ?? ""
                if let startDate = FarmServicesConstants.getDateStringFromDateStringWithShortFormat(serverDate: self.seasonStartDateStr) as String?{
                    self.dateOfSowingTxtFLd.text = startDate
                }
                self.seasonEndDateStr = seasonDic.value(forKey: "endDate") as? String ?? ""
            }
        }
        self.view.endEditing(true)
    }
    
  public  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 30
    }
    
  public  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
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
    
    //MARK: refreshTextFields
    func refreshTextFields(){
        if let categoryDic = categoryNamesArray.firstObject as? NSDictionary{
            categoryTxtFld.text = categoryDic.value(forKey: "name") as? String
            categoryID = categoryDic.value(forKey: "id") as! String as NSString
            //print("category data array : \(categoryNamesArray)")
            self.filterStatesWithCategory(categoryDic: categoryDic)
        }
    }
}

extension CropAdvisoryRegistrationViewController : UITextFieldDelegate{
    //MARK: texpublic tfield delegate methods
 public   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == categoryTxtFld {
            categoryDropDownTblView.isHidden = true
        }
        else if textField == stateTxtFld {
            stateDropDownTblView.isHidden = true
        }
        else if textField == cropTxtFld {
            cropDropDownTblView.isHidden = true
        }
        else if textField == hybridNameTxtFld {
            hybridNameTblView.isHidden = true
        }
        else if textField == seasonTxtFLd{
            seasonTblView.isHidden = true
        }
         return true
    }
    
 public  func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == categoryTxtFld {
            categoryTxtFld.resignFirstResponder()
            categoryDropDownTblView.isHidden = false
            stateDropDownTblView.isHidden = true
            cropDropDownTblView.isHidden = true
            hybridNameTblView.isHidden = true
            seasonTblView.isHidden = true
        }
        else if textField == stateTxtFld {
            stateTxtFld.resignFirstResponder()
            stateDropDownTblView.isHidden = false
            categoryDropDownTblView.isHidden = true
            cropDropDownTblView.isHidden = true
            hybridNameTblView.isHidden = true
            seasonTblView.isHidden = true
        }
        else if textField == cropTxtFld {
            cropTxtFld.resignFirstResponder()
            cropDropDownTblView.isHidden = false
            categoryDropDownTblView.isHidden = true
            stateDropDownTblView.isHidden = true
            hybridNameTblView.isHidden = true
            seasonTblView.isHidden = true
        }
        else if textField == hybridNameTxtFld {
            hybridNameTxtFld.resignFirstResponder()
            hybridNameTblView.isHidden = false
            categoryDropDownTblView.isHidden = true
            cropDropDownTblView.isHidden = true
            stateDropDownTblView.isHidden = true
            seasonTblView.isHidden = true
        }
        else if textField == seasonTxtFLd{
            seasonTxtFLd.resignFirstResponder()
            seasonTblView.isHidden = false
            categoryDropDownTblView.isHidden = true
            cropDropDownTblView.isHidden = true
            hybridNameTblView.isHidden = true
            stateDropDownTblView.isHidden = true
        }
         else if textField == dateOfSowingTxtFLd{
            dateOfSowingTxtFLd.resignFirstResponder()
            dobPickerView()
            seasonTblView.isHidden = true
            categoryDropDownTblView.isHidden = true
            cropDropDownTblView.isHidden = true
            hybridNameTblView.isHidden = true
            stateDropDownTblView.isHidden = true
        }
        else{
            seasonTblView.isHidden = true
            categoryDropDownTblView.isHidden = true
            cropDropDownTblView.isHidden = true
            hybridNameTblView.isHidden = true
            stateDropDownTblView.isHidden = true
        }
    }
}

extension  CropAdvisoryRegistrationViewController{
    
    
    
}
