//
//  LibraryViewController.swift
//  FarmerConnect
//
//  Created by Empover on 28/12/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class LibraryViewController: BaseViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var collectionViewHeader: UICollectionView!
    @IBOutlet weak var tableViewToDisplayData: UITableView!
    ///main array to display data on tableView
    var mutArrayToDisplay = NSMutableArray()
    var mutArrayProductMaster = NSMutableArray()
    var a : NSInteger? = 0
    var backBtnTitle = ""
    var weatherJson = ""
    var cropDiagnosisDocumentsDirectory = NSString()
    
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        cropDiagnosisDocumentsDirectory = appDelegate.getCropDiagnosisFolderPath() as NSString
        
        collectionViewHeader.dataSource = self
        collectionViewHeader.delegate = self
        
        tableViewToDisplayData.dataSource = self
        tableViewToDisplayData.delegate = self
        tableViewToDisplayData.separatorStyle = .none
        
        tableViewToDisplayData.tableFooterView = UIView()
        
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(LibraryViewController.swipeLeft))
        leftSwipeGesture.delegate = self
        leftSwipeGesture.direction = .left
        tableViewToDisplayData.addGestureRecognizer(leftSwipeGesture)
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(LibraryViewController.swipeRight))
        rightSwipeGesture.delegate = self
        rightSwipeGesture.direction = .right
        tableViewToDisplayData.addGestureRecognizer(rightSwipeGesture)
        
        if ((mutArrayToDisplay.object(at: a!) as! NSDictionary).value(forKey: "data") as? NSArray)!.count > 0{
            tableViewToDisplayData.tableFooterView = UIView()
        }
        else{
            let noDataText = NSLocalizedString("no_data_available", comment: "")
            self.addNodetailsFoundLabelFooterToTableView(tableView: tableViewToDisplayData, message: noDataText)
        }
        self.recordScreenView("LibraryViewController", CD_Crop_Library)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
           
            let userObj = Constatnts.getUserObject()
                let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "Crop Library", CROP:self.backBtnTitle ] as [String : Any]
                 
                  self.registerFirebaseEvents(CD_CL_Crop_Library_Disease, "", "", "", parameters: firebaseParams as NSDictionary)
        }
    }
    
    //MARK: swipeLeft
    @objc func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        if a != mutArrayToDisplay.count - 1 {
            a = a! + 1
                        let transition = CATransition()
                        transition.type = kCATransitionPush
                        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                        transition.fillMode = kCAFillModeForwards
                        transition.duration = 0.6
                        transition.subtype = kCATransitionFromRight
//                        tableViewToDisplayData.layer.add(transition, forKey: "UITableViewReloadDataAnimationKey")
                  tableViewToDisplayData.reloadData()
                  collectionViewHeader.reloadData()
                  if ((mutArrayToDisplay.object(at: a!) as! NSDictionary).value(forKey: "data") as? NSArray)!.count > 0{
                      tableViewToDisplayData.tableFooterView = UIView()
                  }
                  else{
                     let noDataText = NSLocalizedString("no_data_available", comment: "")
                      self.addNodetailsFoundLabelFooterToTableView(tableView: tableViewToDisplayData, message: noDataText)
                
                  }
            //dataTblView.reloadData()
//            collectionViewHeader.reloadData()
//            let transition = CATransition()
//            transition.type = kCATransitionPush
//            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//            transition.fillMode = kCAFillModeForwards
//            transition.duration = 0.6
//            transition.subtype = kCATransitionFromRight
//            tableViewToDisplayData.layer.add(transition, forKey: "UITableViewReloadDataAnimationKey")
           
            
//            if ((mutArrayToDisplay.object(at: a!) as! NSDictionary).value(forKey: "data") as? NSArray)!.count > 0{
//                tableViewToDisplayData.tableFooterView = UIView()
//            }
//            else{
//                self.addNodetailsFoundLabelFooterToTableView(tableView: tableViewToDisplayData, message: "No Data Available")
//            }
//             tableViewToDisplayData.reloadData()
        }
        else {
        }
        let indexPath1 = IndexPath(item: a!, section: 0)
        collectionViewHeader!.scrollToItem(at: indexPath1, at: .centeredHorizontally, animated: true)
    }
    
    //MARK: swipeRight
    @objc func swipeRight(_ sender: UISwipeGestureRecognizer) {
        if a != 0 {
            a = a! - 1
            //dataTblView.reloadData()
//            collectionViewHeader.reloadData()
//            let transition = CATransition()
//            transition.type = kCATransitionPush
//            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//            transition.fillMode = kCAFillModeForwards
//            transition.duration = 0.6
//            transition.subtype = kCATransitionFromLeft
//            tableViewToDisplayData.layer.add(transition, forKey: "UITableViewReloadDataAnimationKey")
//
//            if ((mutArrayToDisplay.object(at: a!) as! NSDictionary).value(forKey: "data") as? NSArray)!.count > 0{
//                tableViewToDisplayData.tableFooterView = UIView()
//            }
//            else{
//                self.addNodetailsFoundLabelFooterToTableView(tableView: tableViewToDisplayData, message: "No Data Available")
//            }
//              tableViewToDisplayData.reloadData()
            let transition = CATransition()
                        transition.type = kCATransitionPush
                        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                        transition.fillMode = kCAFillModeForwards
                        transition.duration = 0.6
                        transition.subtype = kCATransitionFromLeft
                  tableViewToDisplayData.reloadData()
                  collectionViewHeader.reloadData()
                  if ((mutArrayToDisplay.object(at: a!) as! NSDictionary).value(forKey: "data") as? NSArray)!.count > 0{
                      tableViewToDisplayData.tableFooterView = UIView()
                  }
                  else{
                      let noDataText = NSLocalizedString("no_data_available", comment: "")
                      self.addNodetailsFoundLabelFooterToTableView(tableView: tableViewToDisplayData, message: "No Data Available")
                  }
//            tableViewToDisplayData.layer.add(transition, forKey: "UITableViewReloadDataAnimationKey")

        }
        else {
        }
        let indexPath1 = IndexPath(item: a!, section: 0)
        collectionViewHeader!.scrollToItem(at: indexPath1, at: .centeredHorizontally, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        if #available(iOS 10.0, *) {
        //            self.automaticallyAdjustsScrollViewInsets = false
        //        }
        self.automaticallyAdjustsScrollViewInsets = false
        
        super.viewWillAppear(true)
        self.topView?.isHidden = false
        lblTitle?.text = backBtnTitle
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        self.tableViewToDisplayData.reloadData()
    }
    
    //MARK : backButtonClick
    override func backButtonClick(_ sender: UIButton) {
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.isClickedOnFABDetailsCloseBtn = false
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnAllProducts_Touch_Up_Inside(_ sender: Any) {
        
        let userObj = Constatnts.getUserObject()
               let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "Crop Library"]
               self.registerFirebaseEvents(CD_CL_All_Products, "", "", "", parameters: firebaseParams as NSDictionary)
        
        let toAllProductsVC = self.storyboard?.instantiateViewController(withIdentifier: "AllProductsViewController") as! AllProductsViewController
        self.navigationController?.pushViewController(toAllProductsVC, animated: true)
    }
    
    //MARK: checkDiseaseImageFileAvailable
    func checkDiseaseImageFileAvailable(imageURLStr: String) -> String?{
        if Validations.validateUrl(urlString: imageURLStr as NSString) == false{
            let docPath = self.getDocumentPath(imageURLStr as NSString)
            let isFileExists = self.checkIfFileExists(atPath: docPath as String)
            if isFileExists == true {
                return docPath as String
            }
            else{
                if Reachability.isConnectedToNetwork() {
                    //let imgURL =  NSURL(string: imageURLStr)
                    DispatchQueue.global().async {
                        self.downloadAssetAndStore(inDocumentsDirectory: imageURLStr as NSString)
                    }
                    return imageURLStr
                }

            }
        }
        return imageURLStr
    }
    
    //MARK: getDocumentPath
    func getDocumentPath(_ assetStr: NSString) -> NSString {
        let assetArray = assetStr.components(separatedBy: "/") as NSArray
        let filePath = String(format: "%@/%@", cropDiagnosisDocumentsDirectory,assetArray.lastObject as! NSString) as NSString
        return filePath
    }
    
    //MARK: downloadAssetAndStore
    func downloadAssetAndStore(inDocumentsDirectory assetStr: NSString) {
        //SwiftLoader.show(animated: true)
        let docPath = self.getDocumentPath(assetStr)
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let url = NSURL(fileURLWithPath: docPath as String)
            return (url as URL, [.removePreviousFile])
        }
        Alamofire.download(assetStr as String, to: destination).response { response in
            if response.destinationURL != nil {
                SwiftLoader.hide()
                //print(response.destinationURL!)
                print("disease image file saved when clicked")
            }
        }
    }
    
    //MARK: checkIfFileExists
    func checkIfFileExists(atPath strPath: String) -> Bool {
        let fileExists: Bool = FileManager.default.fileExists(atPath: strPath)
        return fileExists
    }
}


//MARK:- UICOLLECTIONVIEW DELEGATES
extension LibraryViewController :  UICollectionViewDataSource, UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.mutArrayToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier: String = "HeaderCell"
        let cell: UICollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        let lbl1: UILabel? = (cell?.contentView.viewWithTag(100) as? UILabel)
        lbl1?.text = (mutArrayToDisplay.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
        lbl1?.textColor = UIColor.white
        let selectedView: UIView? = (cell?.contentView.viewWithTag(101))
        if indexPath.row == a {
            selectedView?.isHidden = false
            //cell?.contentView.backgroundColor = UIColor (red: 255.0/255, green: 214.0/255, blue: 51.0/255, alpha: 1.0)
            cell?.contentView.backgroundColor = App_Theme_Orange_Color
        }
        else {
            selectedView?.isHidden = true
            cell?.contentView.backgroundColor = App_Theme_Blue_Color
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        a! = indexPath.row
        tableViewToDisplayData.reloadData()
        collectionViewHeader.reloadData()
        if ((mutArrayToDisplay.object(at: a!) as! NSDictionary).value(forKey: "data") as? NSArray)!.count > 0{
            tableViewToDisplayData.tableFooterView = UIView()
        }
        else{
            self.addNodetailsFoundLabelFooterToTableView(tableView: tableViewToDisplayData, message: "No Data Available")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let size = ((mutArrayToDisplay.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! NSString).size(withAttributes: nil)
        if (mutArrayToDisplay.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! NSString == "Nutritional Deficiency"{
            //self.collViewCellWidthConstraint.constant = 150
            return CGSize(width: 170, height: 40)
        }
        return CGSize(width: 130, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 1, 1, -10)//top,left,bottom,right
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}


//MARK:- UITABLEVIEW DELEGATE METHODS
extension LibraryViewController :  UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((mutArrayToDisplay.object(at: a!) as! NSDictionary).value(forKey: "data") as? NSArray)!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DiagnosisCell"
        //let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        let cell : UITableViewCell = tableViewToDisplayData.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let cropArray = (mutArrayToDisplay.object(at: a!) as! NSDictionary).value(forKey: "data") as? NSArray
        
        let cropDiagnosisCell = cropArray?.object(at: indexPath.row) as? DiseasePrescriptions
        
        let outerView = cell.contentView.viewWithTag(203)
        outerView?.layer.cornerRadius = 5.0
        outerView?.clipsToBounds = true
        outerView?.layer.borderWidth = 0.5
        outerView?.layer.borderColor = UIColor.lightGray.cgColor
        outerView?.dropViewShadow()
        
        let cropImg = cell.viewWithTag(200) as! UIImageView
        cropImg.contentMode = .scaleAspectFit
        //        cropImg.image = UIImage(named:"image_placeholder.png")  //http://103.24.202.7:9090/CDI/
        //        let imgPath = String(format: "%@", arguments: [cropDiagnosisCell?.value(forKey: "diseaseImageFile") as! String])
        //        let url = NSURL(string:(imgPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
        //        cropImg.downloadedFrom(url: url! as URL, placeHolder: UIImage(named:"image_placeholder.png"))
        
        let productImgURL = self.checkDiseaseImageFileAvailable(imageURLStr: cropDiagnosisCell?.value(forKey: "diseaseImageFile") as! String)
        
        DispatchQueue.main.async {
            if productImgURL?.hasPrefix("http") ?? false || productImgURL?.hasPrefix("https") ?? false{
                //let imageUrl = URL(string: cropImgURL)
                cropImg.kf.setImage(with: productImgURL as? Resource , placeholder: UIImage(named:"image_placeholder.png"), options: nil, progressBlock: nil)
            }
            else{
                cropImg.contentMode = .scaleAspectFit
                cropImg.image = UIImage(contentsOfFile: (productImgURL)!)
            }
        }
        
        let title = cell.viewWithTag(201) as! UILabel
        title.text = cropDiagnosisCell?.value(forKey: "diseaseName") as? String
        let subTitle = cell.viewWithTag(202) as! UILabel
        subTitle.text = cropDiagnosisCell?.value(forKey: "diseaseBiologicalName") as? String
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 14.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cropArray = (mutArrayToDisplay.object(at: a!) as! NSDictionary).value(forKey: "data") as? NSArray
        
        let cropDict = cropArray?.object(at: indexPath.row) as? DiseasePrescriptions
        
        let userObj = Constatnts.getUserObject()
        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,"Disease_Name":cropDict?.diseaseName ?? ""] as [String : Any]
        self.registerFirebaseEvents(CD_CL_Crop_Library_Disease, "", "", "", parameters: firebaseParams as NSDictionary)
        //print(cropDict!)
        let toLibraryDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "LibraryDetailsViewController") as! LibraryDetailsViewController
        toLibraryDetailsVC.diseasePrescriptionsObj = cropDict
        toLibraryDetailsVC.isFromDiagnosisScreen = false
        self.navigationController?.pushViewController(toLibraryDetailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
    
    //     func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //
    //        let footerView = UIView(frame: CGRect.init(x: 0, y: tableView.frame.size.height-50, width: tableView.frame.size.width, height: 40))
    //        footerView.backgroundColor = UIColor.gray
    //
    //        return footerView
    //    }
    //
    //     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        return 40.0
    //    }
}



