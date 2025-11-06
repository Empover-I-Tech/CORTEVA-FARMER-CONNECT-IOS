//
//  SampleTrackingViewController.swift
//  FarmerConnect
//
//  Created by Empover on 24/09/24.
//  Copyright © 2024 ABC. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class SampleTrackingListViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate {


    @IBOutlet weak var sampleTrackingListCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var raiseRequestBtn: UIButton!
    @IBOutlet weak var requestHistoryLbl: UILabel!
    
    var searchActive : Bool = false
    var originalArrHistoryList:NSArray = []
    var arrHistoryList:NSArray = []
    var filteredCustomer:NSArray = []
    var arrHybridList:NSArray = []
    var arrCropList:NSArray = []
    
    struct Crop {
        let cropId: Int
        let cropName: String
        let cropUploadImage: String
        let dateOfHarvesting: String
        let dateOfShowing: String?
        let geoTAg: String?
        let growNextYear: String?
        let hybridId: Int
        let hybridName: String?
        let isPravaktha: String
        let mobileSubmitDateTime: String
        let pricePerQt: String
        let productConfirmationKey: Int?
        let rating: String?
        let recommendedToOthers: String
        let requestedDate: String
        let sampleReceived: String
        let sampleRecevingDate: String?
        let serverId: Int
        let status: String
        let top3FabSelection: String?
        let top3Fablists: [[String: Any]]
        let yieldPerAcre: Int?
    }

    let cropsData: [[String: Any]] = []

    var crops: [Crop] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        // Do any additional setup after loading the view.
        
    }
    override func backButtonClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getSampleTrackingList()
        
        self.lblTitle?.text = NSLocalizedString("sampleTracking", comment: "")
        self.setStatusBarBackgroundColor(color :App_Theme_Blue_Color)
        self.topView?.backgroundColor = App_Theme_Blue_Color
        
        requestHistoryLbl.text = NSLocalizedString("requestsHistory", comment: "")
        raiseRequestBtn?.titleLabel?.text = NSLocalizedString("raiseANewRequest", comment: "")
        self.searchBar.textField?.returnKeyType = .done
        self.searchBar.textField?.enablesReturnKeyAutomatically = false
        
        self.topView?.isHidden = false
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.topView?.isHidden = true
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func getSampleTrackingList(){
        SwiftLoader.show(animated: true)
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_SAMPLE_TRACKING_LIST])
        let userObj1 : User =  Constatnts.getUserObject()
        let  headers : HTTPHeaders  = ["deviceToken": userObj1.deviceToken as String ,
                                       "userAuthorizationToken": userObj1.userAuthorizationToken! as String ,
                                       "mobileNumber": userObj1.mobileNumber! as String,
                                       "customerId": userObj1.customerId! as String,
                                       "deviceId": userObj1.deviceId! as String]
        let userId = userObj1.customerId!
        let dataString = "{\"userId\":\(userId)}"
        let parameters = ["data": dataString]
        
        print("the urlString is",urlString)
        print("the headers is",headers)
        print("the params isssk",parameters)

        Alamofire.request(urlString, method: .post, parameters: parameters as? Parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                
            SwiftLoader.hide()
            if response.result.error == nil {
                print("the response is",response)
                if let json = response.result.value {
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                    print("the responseStatusCode is",responseStatusCode)
                    if responseStatusCode == STATUS_CODE_200{
                        
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
    
                        print("Response after decrypting data000:\(respData)")
                        let dict = self.convertToDictionary(text: respData as String)
                        print("Response after decrypting data:\(dict!)")
                        
                        self.arrHistoryList = dict!["historyList"] as! NSArray
                        print("Response after arrHistoryList data:\(self.arrHistoryList)")
                        
                        self.originalArrHistoryList = dict!["historyList"] as! NSArray
                        print("Response after originalArrHistoryList data:\(self.arrHistoryList)")
                        
                        self.arrHybridList = dict!["hybridList"] as! NSArray
                        print("Response after arrHybridList data:\(self.arrHybridList)")
                        
                        self.arrCropList = dict!["cropList"] as! NSArray
                        print("Response after arrCropList data:\(self.arrCropList)")

                        self.sampleTrackingListCollectionView.reloadData()
                        
//                        if let historyList = dict!["historyList"] as? [[String: Any]] {
//                            // Now you can work with historyList as an array of dictionaries
//                            for entry in historyList {
//                                if let cropName = entry["cropName"] as? String,
//                                   let dateOfHarvesting = entry["dateOfHarvesting"] as? String {
//                                    print("Crop: \(cropName), Harvesting Date: \(dateOfHarvesting)")
//                                }
//                            }
//                        } else {
//                            print("Could not cast historyList to [[String: Any]].")
//                        }
                          
                    }else if responseStatusCode == STATUS_CODE_105{
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
    
    @IBAction func raiseRequestBtnAction(_ sender: Any) {
        let selectLableVC = self.storyboard?.instantiateViewController(withIdentifier: "SampleTrackingDetailsViewController") as? SampleTrackingDetailsViewController
        selectLableVC?.dataObj = [:]
        selectLableVC?.getCropListArray = self.arrCropList
        selectLableVC?.getHybridListArray = self.arrHybridList
        self.navigationController?.pushViewController(selectLableVC!, animated: true)
    }
    
    
    
    //MARK: collectionView datasource and delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if(searchActive) {
//            return filteredCustomer.count
//        }
//        //return (self.arrHistoryList.count)
//        
//        else if arrHistoryList.count != 0 {
//            return arrHistoryList.count;
//        }
//        return 0;
        return arrHistoryList.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SampleTrackingListCollectionViewCell
        
        //listCell.cropImage.image = ""
       // listCell.cropImage?.image = UIImage(named: assetsCountMutArray.object(at: indexPath.row) as! String)
        
       // let cellData = arrHistoryList.object(at: indexPath.row) as? SampleTrackingData
        //print("dddd111",cellData?.crop)
        //print("dddd111",arrHistoryList.object(at: indexPath.row) as? SampleTrackingData)
        
       // let imageUrl = URL(string: (cellData?.image)!)!
        
        
        listCell.cropDisplayLbl.text = NSLocalizedString("crop", comment: "")
        listCell.hybridDisplayLbl.text = NSLocalizedString("hybrid", comment: "")
        listCell.requestedDateDisplayLbl.text = NSLocalizedString("Requested_Date", comment: "")
        listCell.statusDisplayLbl.text = NSLocalizedString("status", comment: "")
        
        let productImgURL = (arrHistoryList.object(at: indexPath.row) as! NSDictionary).value(forKey: "cropUploadImage") as? String

        if productImgURL != "" {
            DispatchQueue.main.async {
                if productImgURL!.hasPrefix("http") || productImgURL!.hasPrefix("https") {
                    let imageUrl = URL(string: productImgURL!)
                    listCell.cropImage?.kf.setImage(with: imageUrl! as Resource, placeholder: UIImage(named: "image_placeholder.png"), options: nil, progressBlock: nil)
                }
                else{
                    listCell.cropImage.image = UIImage(named: "image_placeholder")
                }
            }
        }
        
        listCell.cropValueLbl.text = (arrHistoryList.object(at: indexPath.row) as! NSDictionary).value(forKey: "cropName") as? String
        listCell.hybridValueLbl.text = (arrHistoryList.object(at: indexPath.row) as! NSDictionary).value(forKey: "hybridName") as? String
        listCell.requestedDateValueLbl.text = (arrHistoryList.object(at: indexPath.row) as! NSDictionary).value(forKey: "mobileSubmitDateTime") as? String
        listCell.statusValueLbl.text = (arrHistoryList.object(at: indexPath.row) as! NSDictionary).value(forKey: "status") as? String
        
        return listCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var filterData:[Any] = arrHistoryList as! [Any]
        print("what is coming here345",filterData)
        
        let itemSelected = arrHistoryList.object(at: indexPath.row)
        print("selected full object",itemSelected)
        
        let selectLableVC = self.storyboard?.instantiateViewController(withIdentifier: "SampleTrackingDetailsViewController") as? SampleTrackingDetailsViewController
        selectLableVC?.dataObj = itemSelected as? NSDictionary
        selectLableVC?.getCropListArray = self.arrCropList
        selectLableVC?.getHybridListArray = self.arrHybridList
        self.navigationController?.pushViewController(selectLableVC!, animated: true)
        
        
       // let equipment = arrHistoryList.object(at: indexPath.row) as? Equipment
//        if equipment?.status == "Rejected" || equipment?.status == "Blocked"{
//            if rejectEquipmentAlert != nil{
//                self.rejectEquipmentAlert?.removeFromSuperview()
//            }
//            self.rejectEquipmentAlert = CustomAlert.alertInfoPopUpView(self, frame: self.view.frame, title: equipment?.status as NSString? ?? "" as NSString, message: equipment?.reason as NSString? ?? "" as NSString, buttonTitle: "OK", hideClose: true) as? UIView
//            self.view.addSubview(self.rejectEquipmentAlert!)
//        }
//        else{
//            self.editOptionsActionSheet(equipment: equipment!)
//        }
    }
    
    //MARK:- Searchbar method
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        if searchBar.text == "" {
            searchActive = false;
        } else {
            searchActive = true;
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel button clicked")
        searchActive = false;
        self.arrHistoryList = self.originalArrHistoryList
        self.sampleTrackingListCollectionView.reloadData()
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        dismissKeyboard()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        let filterData:[[String: Any]] = originalArrHistoryList as! [[String: Any]]
        print("mmmmmmmhhhh",filterData)
        
        let cropNameToFilter = searchText

        let filteredData = filterData.filter { dict in
            if let cropName = dict["cropName"] as? String {
                return cropName == cropNameToFilter
            }
            return false
        }

        print("dddd998",filteredData)
        print("dddd998kk",filteredData.count)
//        print("what is entered here",searchText)
//        print("what is coming here",self.arrHistoryList)
        

        
        if(filteredData.count == 0){
            searchActive = true;
            arrHistoryList = originalArrHistoryList as NSArray
        } else {
            searchActive = true;
            arrHistoryList = filteredData as NSArray
        }
        self.sampleTrackingListCollectionView.reloadData()
        
     
    }
    
    func doStringContainsNumber( _string : String) -> Bool{

    let numberRegEx  = ".*[0-9]+.*"
    let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let containsNumber = testCase.evaluate(with: _string)

    return containsNumber
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
