//
//  CPShareScreenView.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 13/04/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import Foundation
import Alamofire
import SDWebImage


class CPShareScreenView: UIView {
    
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var btnEnglish : UIButton!
    @IBOutlet weak var btnLocal : UIButton!
    @IBOutlet weak var viewImages : UIView!
    @IBOutlet weak var viewFAB : UIView!
    
    @IBOutlet weak var cvImages : UICollectionView!
    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var dataTblView: UITableView!
    
    @IBOutlet weak var FABViewHgtCons: NSLayoutConstraint!
    @IBOutlet weak var dosageGridViewHgtCons: NSLayoutConstraint!
    @IBOutlet weak var tableHgtCon: NSLayoutConstraint!
    
    
    var cropName : String  = ""
    var diseaseName : String  = ""
    var productName : String  = ""
    
    
    @IBOutlet weak var lbl_Description : UILabel!
    
    var imgesArray = [String]()
    
    var stateNamesArray = NSMutableArray()
    var cropNamesArray = NSMutableArray()
    var diseaseNameArray = NSMutableArray()
    var productNamesArray = NSMutableArray()
    
    var stateArray = NSArray()
    var cropArray = NSArray()
    var diseaseArray = NSArray()
    var productArray = NSArray()
    
    ///main array to store the FAB data and used to display on tableView
    var mutArrayToDisplay = NSMutableArray()
    var mutDictToStoreDBData = NSMutableDictionary()
    
    var version = NSString()
    
    var a : NSInteger? = 0
    var fabAlertView = UIView()
    
    
    var assetsCountMutArray = NSMutableArray()
    
    /// used to iterate through mutArrToStoreAllAssetsOfFAB while downloading the assets
    var currentIndex:Int = 0
    
    ///This array stores all assets of FAB,and used this array to download the assets.
    var mutArrToStoreAllAssetsOfFAB = NSMutableArray()
    
    var fabDocumentsDirectory = NSString()
    
    var t_count:Int = 0
    var lastCell: StackViewCell = StackViewCell()
    var button_tag:Int = -1
    var jobs = [String]()
    
    @IBOutlet weak var dosageTableTitle : UILabel!
    @IBOutlet weak var dosageTableView : UITableView!
    @IBOutlet weak var dosageItemWidthCons :  NSLayoutConstraint!
    
    var dosageArray = [TableData]()
    var dosageLocArray = [TableData]()
    var numberOfRows  = Int()
    var numberofColumns = Int()
    var dosageTitle : String = ""
    var descriptionStr : String = ""
    
    var advantageEngMessagesArray =  [String]()
    var advantageLocMessagesArray =  [String]()
    var featureEngMessagesArray =  [String]()
    var featureLocMessagesArray =  [String]()
    var benefitsEngMessagesArray =  [String]()
    var benefitsLocMessagesArray =  [String]()
    
    
    var  isEnglishSelected : Bool = true
    var isLocalSelected : Bool = false
    var selectedTab : String = "Features"
    
    var engkeys : String = ""
    var lockeys : String = ""
    
    var stateId : String = ""
    var cropId : String = ""
    var diseaseId : String = ""
    var productId : String = ""
    
    
    var dosageEngTitle : String = ""
    var dosageLocTitle : String = ""
    var descriptionEngStr : String = ""
    var descriptionLocStr : String = ""
    
    static func viewFromNib() -> CPShareScreenView {
           guard let viewFromNib = CPShareScreenView.loadFromNibNamed("CPShareScreenView") else {
               assert(false, "Unknown XIB")
               return CPShareScreenView()
           }
           
           return viewFromNib
       }
       
       override func awakeFromNib() {
           super.awakeFromNib()
           self.cvImages.dataSource = self
           self.cvImages.delegate = self
        
           self.cvImages.register(UINib(nibName:"ImageCollectionViewCell", bundle: nil),
                       forCellWithReuseIdentifier:"cvImage")
        self.cvImages.reloadData()
       }
}
extension CPShareScreenView : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView ==  self.cvImages{
            return self.imgesArray.count
        }else {
            return 3
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.cvImages {
            let cell  = self.cvImages.dequeueReusableCell(withReuseIdentifier: "cvImage", for: indexPath) as! ImageCollectionViewCell
           
                DispatchQueue.main.async{
                      cell.imageHybrid?.image = UIImage(named: "image_placeholder.png")!
                }
            
            
            if self.imgesArray.count == 1 {
                cell.btnPrevious.isHidden = true
                cell.btnNext.isHidden = true
            }else {
                cell.btnPrevious.isHidden = false
                cell.btnNext.isHidden = false
            }
            cell.btnNext.tag = indexPath.row
            cell.btnPrevious.tag = indexPath.row
            cell.btnNext.addTarget(self, action: #selector(CropProtectionDetailsViewController.btnNextAction(_:)), for: .touchUpInside)
            cell.btnPrevious.addTarget(self, action: #selector(CropProtectionDetailsViewController.btnPreviousAction(_:)), for: .touchUpInside)
            return cell
        }else {
            let cellIdentifier: String = "HeaderCell"
            let cell: UICollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            let lbl1: UILabel? = (cell?.contentView.viewWithTag(100) as? UILabel)
            
            ///This temp variable is used to display headers for the collectionView till we get the response from the server.(instead of displaying blank titles)
            let tempTitleArr = [NSLocalizedString("features", comment: ""),NSLocalizedString("advantages", comment: ""),NSLocalizedString("benifits", comment: "")] as NSArray
            if mutArrayToDisplay.count > 0 {
                
                let typeStr =  ((mutArrayToDisplay.object(at: indexPath.row) as! NSDictionary).value(forKey: "Title") as? String)
                
                if  typeStr?.lowercased() == "features" {
                    lbl1?.text = "Features"
                }else if typeStr?.lowercased() == "advantages"{
                    lbl1?.text = NSLocalizedString("advantages", comment: "")
                }else if typeStr?.lowercased() == "benefits" {
                    lbl1?.text = NSLocalizedString("benifits", comment: "")
                }
            }
            else{
                lbl1?.text = tempTitleArr.object(at: indexPath.row) as? String
            }
            lbl1?.textColor = UIColor.white
            let selectedView: UIView? = (cell?.contentView.viewWithTag(101))
            if indexPath.row == a {
                selectedView?.isHidden = false
                cell?.contentView.backgroundColor = App_Theme_Orange_Color//UIColor (red: 255.0/255, green: 214.0/255, blue: 51.0/255, alpha: 1.0)
            }
            else {
                selectedView?.isHidden = true
                cell?.contentView.backgroundColor = App_Theme_Blue_Color
            }
            return cell!
        }
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.cvImages{
            return CGSize(width: collectionView.bounds.size.width , height: collectionView.bounds.size.height-30)
        }else if collectionView == headerCollectionView {
            return CGSize(width: collectionView.bounds.size.width/3, height: 40)
        }else{
            return CGSize(width: collectionView.bounds.size.width/CGFloat(assetsCountMutArray.count), height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == headerCollectionView {
            self.selectedTab  = (((mutArrayToDisplay.object(at: indexPath.row) as! NSDictionary).value(forKey: "Title") as? String)!)
            a! = indexPath.row
            self.headerCollectionView.reloadData{
                 self.dataTblView.reloadData()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(1, 1, 1, -10)//top,left,bottom,right
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    
    @IBAction func btnNextAction(_ sender : UIButton) {
        let visibleItems: NSArray = self.cvImages.indexPathsForVisibleItems as NSArray? ?? []
        if(visibleItems.count>0){
            let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
            let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
            if nextItem.row < imgesArray.count {
                self.cvImages.scrollToItem(at: nextItem, at: .right, animated: false)
            }
        }
    }
    
    @IBAction func btnPreviousAction(_ sender: Any) {
        let visibleItems: NSArray = self.cvImages.indexPathsForVisibleItems as NSArray? ?? []
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item - 1, section: 0)
        if nextItem.row < imgesArray.count && nextItem.row >= 0{
            self.cvImages.scrollToItem(at: nextItem, at: .left, animated: false)
        }
    }
    
    }


extension CPShareScreenView :  UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == dosageTableView {
               return 40
        }else {
        if indexPath.row == button_tag {
            return 200
        } else {
            return 60
        }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dosageTableView {
            if self.isEnglishSelected == true {
            if self.dosageArray.count > 0 {
                return self.dosageArray.count
            }else {
            return 0
            }
            }else {
                if self.dosageLocArray.count > 0 {
                    return self.dosageLocArray.count
                }else {
                return 0
                }
            }
        }else {
            if mutArrayToDisplay.count > 0 {
                engkeys  = "englishMsg"
                lockeys = "localMsg"
          
            if isEnglishSelected  == true {
                let engMessagesArr =  ((mutArrayToDisplay.object(at: a!) as! NSDictionary).value(forKey: engkeys)) as! NSArray
                return engMessagesArr.count
            }else {
                let engMessagesArr =  ((mutArrayToDisplay.object(at: a!) as! NSDictionary).value(forKey: lockeys)) as! NSArray
                return engMessagesArr.count
            }
            }else {
                return 0
            }
            }
            
        }
        
    
    @IBAction func englishLanguageSelectionButton(_ sender : UIButton) {
        let img = UIImage(named: "radioEmpty")?.withRenderingMode(.alwaysTemplate)
        let img1 = UIImage(named: "radio")?.withRenderingMode(.alwaysTemplate)
        if #available(iOS 13.0, *) {
            img?.withTintColor(.blue)
            img1?.withTintColor(.blue)
        } else {
            btnEnglish.tintColor = UIColor.blue
            btnLocal.tintColor = UIColor.darkGray
        }
        btnEnglish.titleLabel?.textColor = UIColor.darkGray
         btnLocal.titleLabel?.textColor = UIColor.darkGray
        
        btnEnglish.setImage(img1, for: .normal)
        btnLocal.setImage(img, for: .normal)
        
         self.lbl_Description?.text =  "Description :  " +  descriptionEngStr
        
        self.dosageTableTitle.text = " " + dosageEngTitle
        
        self.isEnglishSelected = true
         self.isLocalSelected = false
        self.dataTblView.reloadData()
        self.dosageTableView.reloadData()
    }
    @IBAction func localLanguageSelectionButton(_ sender : UIButton) {
         let img = UIImage(named: "radioEmpty")?.withRenderingMode(.alwaysTemplate)
          let img1 = UIImage(named: "radio")?.withRenderingMode(.alwaysTemplate)
        if #available(iOS 13.0, *) {
            img?.withTintColor(.blue)
            img1?.withTintColor(.blue)
        } else {
            btnEnglish.tintColor = UIColor.darkGray
            btnLocal.tintColor = UIColor.blue
        }
        btnEnglish.titleLabel?.textColor = UIColor.darkGray
         btnLocal.titleLabel?.textColor = UIColor.darkGray
        
        self.lbl_Description?.text = "Description :  " + descriptionLocStr
  
  
        self.dosageTableTitle.text = " " +  dosageLocTitle
        
        btnEnglish.setImage(img, for: .normal)
        btnLocal.setImage(img1, for: .normal)
        self.isEnglishSelected = false
        self.isLocalSelected = true
         self.dataTblView.reloadData()
        self.dosageTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView ==  dosageTableView {
             let cell = tableView.dequeueReusableCell(withIdentifier: "dosageCell", for: indexPath) as! DosageCell
             cell.dosageItemCollectionView.isScrollEnabled = false
            DispatchQueue.main.async {
                var dataInfo = TableData()
                if self.isEnglishSelected == true {
                    dataInfo.columnOne = self.dosageArray[indexPath.row].columnOne
                                   dataInfo.columnTwo = self.dosageArray[indexPath.row].columnTwo
                                    dataInfo.columnThree = self.dosageArray[indexPath.row].columnThree
                                    dataInfo.columnFour = self.dosageArray[indexPath.row].columnFour
                }else {
                    dataInfo.columnOne = self.dosageLocArray[indexPath.row].columnOne
                                   dataInfo.columnTwo = self.dosageLocArray[indexPath.row].columnTwo
                                    dataInfo.columnThree = self.dosageLocArray[indexPath.row].columnThree
                                    dataInfo.columnFour = self.dosageLocArray[indexPath.row].columnFour
                }
            
                 var arrItems = [String]()
                if dataInfo.columnOne != "" {
                     arrItems.append(dataInfo.columnOne)
                }
               if dataInfo.columnTwo != "" {
                   arrItems.append( dataInfo.columnTwo)
               }
                if dataInfo.columnThree != "" {
                                 arrItems.append(dataInfo.columnThree)
                             }
                if dataInfo.columnFour != "" {
                                              arrItems.append(dataInfo.columnFour)
                                         }
               
                 cell.arrDosageItems  = arrItems
                cell.dosageItemCollectionView.reloadData()
                self.dosageItemWidthCons.constant  = cell.dosageItemCollectionView.contentSize.width
            }
            return cell
        }
        else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StackViewCell", for: indexPath) as! StackViewCell
        
            if isEnglishSelected  == true {
                let engmessages =  ((mutArrayToDisplay.object(at: a!) as! NSDictionary).value(forKey: engkeys)) as! NSArray
                let engMsg = engmessages[indexPath.row] as? String
                cell.open.setTitle(engMsg , for: .normal)
                let txt =  "\(cell.open.titleLabel?.getTruncatingText(originalString: engMsg ?? "", newEllipsis: " MORE", maxLines: 2) ?? "")"
                
                let txt1 = txt.replacingOccurrences(of: "MORE", with: "")
                cell.textView.text = engMsg?.replacingOccurrences(of: txt1, with: "")
            }else {
                let engmessages =  ((mutArrayToDisplay.object(at: a!) as! NSDictionary).value(forKey: lockeys)) as! NSArray
                let engMsg = engmessages[indexPath.row] as? String
               

                cell.open.setTitle(engMsg , for: .normal)
                let txt =  "\(cell.open.titleLabel?.getTruncatingText(originalString: engMsg ?? "", newEllipsis: " MORE", maxLines: 2) ?? "")"
                let txt1 = txt.replacingOccurrences(of: "MORE", with: "")
                             cell.textView.text = engMsg?.replacingOccurrences(of: txt1, with: "")
            }
            cell.open.titleLabel?.numberOfLines = 2
             
           let lines =  self.numberOfLines(textView: cell.textView)
            
            if lines >= 2 {
                let img = UIImage(named: "downArrow")
                cell.open.setImage(img, for: .normal)
                cell.open.semanticContentAttribute = .forceRightToLeft
               
            }
           
        //cell.open.titleLabel?.numberOfLines = 2
//            button_tag = -1
        cell.openView.backgroundColor = UIColor.white
            if !cell.cellExists &&  lines >= 2{
            cell.stuffView.backgroundColor =  UIColor.white
                   cell.tag = indexPath.row
            t_count += 1
            cell.cellExists = true
            }
        UIView.animate(withDuration: 0) {
            cell.contentView.layoutIfNeeded()
        }
            if ((indexPath.row) % 2) == 0 {
                cell.open.backgroundColor = UIColor(red:193.0/255.0, green: 198.0/255.0, blue: 242.0/255.0, alpha: 1.0)
            }else {
                cell.open.backgroundColor = UIColor(red: 225.0/255.0, green: 229.0/255.0, blue: 249.0/255.0, alpha: 1.0)
            }
        return cell
        }
    }
    func numberOfLines(textView: UITextView) -> Int {
        let layoutManager = textView.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var lineRange: NSRange = NSMakeRange(0, 1)
        var index = 0
        var numberOfLines = 0

        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        return numberOfLines
    }
    
    
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let  cell = dataTblView.cellForRow(at:indexPath) as! StackViewCell
        
          let lines =  self.numberOfLines(textView: cell.textView)
        if lines >= 2 {
          
            self.dataTblView.beginUpdates()
        
            let previousCellTag = button_tag
            
            if lastCell.cellExists {
                self.lastCell.animate(duration: 0.2, c: {
                    cell.contentView.layoutIfNeeded()
                })
                
                if indexPath.row == button_tag {
                    button_tag = -1
                    lastCell = StackViewCell()
                }
            }
            
            if indexPath.row != previousCellTag {
                button_tag = indexPath.row
                print(IndexPath(row: button_tag, section: 0))
                lastCell = dataTblView.cellForRow(at: IndexPath(row: button_tag, section: 0)) as! StackViewCell
//                self.dataTblView.reloadRows(at: [indexPath], with: .fade)
                
                self.lastCell.animate(duration: 0.2, c: {
                   cell.contentView.layoutIfNeeded()
                })
            
            }
            
            self.dataTblView.endUpdates()
            DispatchQueue.main.async{
            self.dataTblView.isScrollEnabled = false
                self.tableHgtCon.constant = self.dataTblView.contentSize.height  + 20
                self.FABViewHgtCons.constant =  self.tableHgtCon.constant
                 self.dataTblView.updateConstraints()
            }
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
