//
//  FABImagesViewController.swift
//  PioneerEmployee
//
//  Created by Empover on 04/10/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher


class FABImagesViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {

    ///mutable array used to store all the image paths
    var imagesArr = NSMutableArray()
    
    /// array used to store image tags
    var imageTagsArr = NSArray()
    
    var currentIndex : Int = 0
    
    var assetDictFromFABDetailsVC : NSDictionary?
    
    var fabDocumentsDirectory = NSString()
    
    //var used at the time of downloading assets
    var currentIndexDoc:Int = 0
    
    var imagesArrToCheckInDocDir = NSArray()
    
    @IBOutlet weak var forwardBtn: UIButton!
    
    @IBOutlet weak var imgCollView: UICollectionView!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var imageTagsLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        fabDocumentsDirectory = appDelegate.getFABFolderPath() as NSString
        //print(fabDocumentsDirectory)
        
        imgCollView.dataSource = self
        imgCollView.delegate = self
        imgCollView.showsHorizontalScrollIndicator = false
        
        //imagesArr = ["1.png","2.png","3.png"]
        imagesArrToCheckInDocDir = (assetDictFromFABDetailsVC?.value(forKey: "images") as! NSString).components(separatedBy: "#") as NSArray
        imageTagsArr = (assetDictFromFABDetailsVC?.value(forKey: "imageTags") as! NSString).components(separatedBy: "#") as NSArray
        //imageView.image = UIImage(named: imagesArr.object(at: currentIndex) as! String)
        
        self.checkAssetsToBeDownloaded()
        if imagesArrToCheckInDocDir.count>1 {
            backBtn.isHidden = true
            forwardBtn.isHidden = false
        }
        else{
            backBtn.isHidden = true
            forwardBtn.isHidden = true
        }
        imageTagsLbl.text = imageTagsArr.object(at: currentIndex) as? String
    }
    
    //MARK: checkAssetsToBeDownloaded
    func checkAssetsToBeDownloaded(){
        if currentIndexDoc < imagesArrToCheckInDocDir.count {
            let assetStr = imagesArrToCheckInDocDir.object(at: currentIndexDoc)
            self.downloadAssetAndStore(inDocumentsDirectory: assetStr as! NSString)
            currentIndexDoc+=1
            self.checkAssetsToBeDownloaded()
        }
    }
    
    //MARK: getDocumentPath
    func getDocumentPath(_ assetStr: NSString) -> NSString {
        let assetArray = assetStr.components(separatedBy: "/") as NSArray
        let filePath = String(format: "%@/%@", fabDocumentsDirectory,assetArray.lastObject as! NSString) as NSString
        return filePath
    }
    
    //MARK: checkIfFileExists
    func checkIfFileExists(atPath strPath: String) -> Bool {
        let fileExists: Bool = FileManager.default.fileExists(atPath: strPath)
        return fileExists
    }
    
    //MARK: downloadAssetAndStore
    func downloadAssetAndStore(inDocumentsDirectory assetStr: NSString) {
        let docPath = self.getDocumentPath(assetStr)
        let isFileExists = self.checkIfFileExists(atPath: docPath as String)
        if isFileExists == false {
            if Reachability.isConnectedToNetwork() {
                SwiftLoader.show(animated: true)
                let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                    let url = NSURL(fileURLWithPath: docPath as String)
                    return (url as URL, [.removePreviousFile])
                }
                Alamofire.download(assetStr as String, to: destination).response { response in
                   SwiftLoader.hide()
                    if response.destinationURL != nil {
                       //print(response.destinationURL!)
                        self.imagesArr.add(docPath)
                    }
                    else{
                        self.imagesArr.add(docPath)
                       // self.imgCollView.reloadData()
                    }
                }
            }
        }
        else{
            imagesArr.add(docPath)
        }
        self.imgCollView.reloadData()
    }
    
    @IBAction func forwardBtn(_ sender: Any) {
        backBtn.isHidden = false
        currentIndex+=1
        //imageView.image = UIImage(named: imagesArr.object(at: currentIndex) as! String)
        if currentIndex == imagesArr.count-1 {
            forwardBtn.isHidden = true
        }
        let visibleItems: NSArray = self.imgCollView!.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
        self.imgCollView?.scrollToItem(at: nextItem, at: .right, animated: true)
        imageTagsLbl.text = imageTagsArr.object(at: currentIndex) as? String
    }
    
    @IBAction func backBtn(_ sender: Any) {
        forwardBtn.isHidden = false
        currentIndex-=1
        // imageView.image = UIImage(named: imagesArr.object(at: currentIndex) as! String)
        if currentIndex == 0 {
            backBtn.isHidden = true
        }
        let visibleItems: NSArray = self.imgCollView!.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item - 1, section: 0)
        self.imgCollView?.scrollToItem(at: nextItem, at: .left, animated: true)
        imageTagsLbl.text = imageTagsArr.object(at: currentIndex) as? String
    }
    
    @IBAction func closeBtn_Touch_Up_Inside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        
//        super.viewWillAppear(true)
//        
//        self.topView?.isHidden = false
//        
//        lblTitle?.text = "FAB Details"
//        
//        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
//        
//        //self.refreshTextFields()
//    }
//    
//    override func backButtonClick(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imgCollView.dequeueReusableCell(withReuseIdentifier: "ImgCell", for: indexPath) as UICollectionViewCell
        let img : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        //load from doc directory
        if imagesArr.count > 0 {
           img.image = UIImage(named: imagesArr.object(at: indexPath.row) as! String)
//            let url = NSURL(string:imagesArr.object(at: indexPath.row) as! String)
//            img.kf.setImage(with: url! as? Resource , placeholder: UIImage(named:"image_placeholder.png"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        else{
            let url = NSURL(string:imagesArrToCheckInDocDir.object(at: indexPath.row) as! String)
            img.kf.setImage(with: url! as? Resource , placeholder: UIImage(named:"image_placeholder.png"), options: nil, progressBlock: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //307-width
        return CGSize(width: imgCollView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth: Float = Float(imgCollView.frame.size.width)+8 //307
        let currentOffset: Float = Float(scrollView.contentOffset.x)
        let targetOffset: Float = Float(targetContentOffset.pointee.x)
        var newTargetOffset: Float = 0
        if targetOffset > currentOffset {
            newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth
        }
        else {
            newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth
        }
        if newTargetOffset < 0 {
            newTargetOffset = 0
        }
        else if (newTargetOffset > Float(scrollView.contentSize.width)){
            newTargetOffset = Float(Float(scrollView.contentSize.width))
        }
        targetContentOffset.pointee.x = CGFloat(currentOffset)
        scrollView.setContentOffset(CGPoint(x: CGFloat(newTargetOffset), y: scrollView.contentOffset.y), animated: true)
        
        //        let visibleItems: NSArray = self.imgCollView!.indexPathsForVisibleItems as NSArray
        //        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        
        let index = newTargetOffset / pageWidth;
        currentIndex = Int(index)
        imageTagsLbl.text = imageTagsArr.object(at: currentIndex) as? String
        if currentIndex > 0 && imagesArr.count > 1 {
            backBtn.isHidden = false
        }
        if currentIndex == 0 && imagesArr.count > 1 {
            backBtn.isHidden = true
        }
        if currentIndex == imagesArr.count-1 {
            forwardBtn.isHidden = true
        }
        else{
            forwardBtn.isHidden = false
        }
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
