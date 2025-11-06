//
//  CropDiagnosisViewController.swift
//  PioneerEmployee
//
//  Created by Empover on 15/11/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import UIKit

class CropDiagnosisViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var toDiagnosisVCBtn: UIButton!
    @IBOutlet weak var cropDiagnosisCollView: UICollectionView!
    
    var cropsArray = NSArray()
    var cropsImagesArray = NSArray()
    var isFromHome : Bool = false
    
    @IBOutlet weak var lblSelectUrCrop: UILabel!
    let tempDiseasesMutArray = NSMutableArray()
    var diseasesMutArray = NSMutableArray()
    
    @IBOutlet weak var selectCropView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cropDiagnosisCollView.dataSource = self
        cropDiagnosisCollView.delegate = self
        
 //        cropsImagesArray = ["CropDiagnosisRiceImg","CropDiagnosisCornImg","CropDiagnosisMilletImg","CropDiagnosisMustardImg"]
        let userObj = Constatnts.getUserObject()
        //print(userObj.showCropDiagnosis!)
        //print(userObj.crop!)
        
        cropsArray = (userObj.crop!).components(separatedBy: ",") as NSArray
        
        if cropsArray.count == 1 {
            lblSelectUrCrop.isHidden = true
        }else{
            lblSelectUrCrop.isHidden = false
        }
        
        //print(cropsArray)
        //cropsArray = ["Rice"]
        //cropsImagesArray = ["CropDiagnosisRiceImg"]
        
        let shareButton = UIButton(frame: CGRect(x:UIScreen.main.bounds.size.width-42,y: 6,width: 40,height: 40))
        shareButton.backgroundColor =  UIColor.clear
        shareButton.setImage( UIImage(named: "Share"), for: UIControlState())
        shareButton.addTarget(self, action: #selector(CropDiagnosisViewController.shareButtonClick(_:)), for: UIControlEvents.touchUpInside)
        //self.topView?.addSubview(shareButton)
        self.recordScreenView("CropDiagnosisViewController", Crop_Diagnosis)
        self.registerFirebaseEvents(PV_Crop_Diagnosis_Home_Screen, "", "", "", parameters: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.topView?.isHidden = false
        lblTitle?.text = NSLocalizedString("crop_diagnostic", comment: "")

        if isFromHome {
            self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        }else{
            self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        diseasesMutArray = appDelegate.getDiseasePrescriptionDetailsFromDB("DiseasePrescriptionsEntity")
        //print(diseasesMutArray)
    }
    
    override func backButtonClick(_ sender: UIButton) {
        if isFromHome{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.findHamburguerViewController()?.showMenuViewController()
        }
    }
    @IBAction func shareButtonClick( _ sender: UIButton)
    {
        let urlPath = String(format: "%@=%@", Module,Crop_Diagnostic)
        let finalUrl = String(format: "%@%@", deepLinkBaseUrl,urlPath)
        let activityControl = Validations.showShareActivityController(viewController: self, fileUrl: URL(string: finalUrl)!, userName: "", message: "")
        self.present(activityControl, animated: true, completion: nil)
    }
    //MARK: collectionView datasource and delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cropsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cell = self.cropDiagnosisCollView.dequeueReusableCell(withReuseIdentifier: "CropDiagnosisCell", for: indexPath)
        
        let cellIdentifier = "CropDiagnosisCell"
        
        cropDiagnosisCollView.register(UINib.init(nibName: "CropDiagnosisCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        let cell : CropDiagnosisCollectionViewCell = cropDiagnosisCollView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CropDiagnosisCollectionViewCell
        
        let cropImgView = cell.contentView.viewWithTag(100) as! UIImageView
        if let cropImage = UIImage(named:cropsArray.object(at: indexPath.row) as! String) as UIImage?{
            cropImgView.image = cropImage
        }
        else{
            cropImgView.image = UIImage(named:"image_placeholder.png")
        }
        let cropNameLbl = cell.contentView.viewWithTag(101) as! UILabel
        cropNameLbl.text = cropsArray.object(at: indexPath.row) as? String
        
        
        return cell
    }
    @IBAction func selectCropTypeToEnterLibrary(_ sender: Any) {
       
        if cropsArray.count > 1{
            let alertController = UIAlertController(title: NSLocalizedString("select_crop", comment: ""), message: "", preferredStyle: .alert)
            
            for index in (0..<cropsArray.count){
                let sendButton = UIAlertAction(title: cropsArray.object(at: index) as? String, style: .default, handler: { (action) -> Void in
                    self.gotoLibraryScreenOfSelectedCrop(selectedCropIndex: index)
                })
                alertController.addAction(sendButton)
                
            }//cancel
            
            let cancelButton = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: { (action) -> Void in
                print("Cancel button tapped")
            })
            
            
            alertController.addAction(cancelButton)
            
            self.navigationController!.present(alertController, animated: true, completion: nil)
        }
        else if cropsArray.count == 1{
            self.gotoLibraryScreenOfSelectedCrop(selectedCropIndex: 0)
        }
        else{
            self.showNormalAlert(title: "", message: NSLocalizedString("no_crops_available", comment: ""))
        }

    }

    func gotoLibraryScreenOfSelectedCrop(selectedCropIndex: Int){
        let cropNameStr = cropsArray.object(at: selectedCropIndex) as? NSString
        //        print(cropNameStr!)
        
        let pestPredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Pests",cropNameStr! as String)
        let pestFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: pestPredicate)
        
        let weedPredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Weeds",cropNameStr! as String)
        let weedFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: weedPredicate)
        
        let diseaseMutArray = NSMutableArray()
        let diseasePredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Disease",cropNameStr! as String)
        let diseaseFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: diseasePredicate)
        diseaseMutArray.addObjects(from: diseaseFilteredArr)
        let fungusPredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Fungal",cropNameStr! as String)
        let fungusFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: fungusPredicate)
        diseaseMutArray.addObjects(from: fungusFilteredArr)
        let bacterialPredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Bacterial",cropNameStr! as String)
        let bacterialFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: bacterialPredicate)
        diseaseMutArray.addObjects(from: bacterialFilteredArr)
        let viralPredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Viral",cropNameStr! as String)
        let viralFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: viralPredicate)
        diseaseMutArray.addObjects(from: viralFilteredArr)
        //print(diseaseMutArray)
        
        let nutritionalDeficiencyMutArray = NSMutableArray()
        let npkPredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","NPK",cropNameStr! as String)
        let npkFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: npkPredicate)
        nutritionalDeficiencyMutArray.addObjects(from: npkFilteredArr)
        let micronutrientsPredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Micronutrients",cropNameStr! as String)
        let micronutrientsFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: micronutrientsPredicate)
        nutritionalDeficiencyMutArray.addObjects(from: micronutrientsFilteredArr)
        
        let othersPredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Others",cropNameStr! as String)
        let othersFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: othersPredicate)
        
        self.tempDiseasesMutArray.removeAllObjects()
        let tempPestMutDict = NSMutableDictionary()
        tempPestMutDict.setValue("Pests", forKey: "title")
        tempPestMutDict.setValue(pestFilteredArr, forKey: "data")
        tempDiseasesMutArray.add(tempPestMutDict)
        
        let tempDiseaseMutDict = NSMutableDictionary()
        tempDiseaseMutDict.setValue("Disease", forKey: "title")
        tempDiseaseMutDict.setValue(diseaseMutArray, forKey: "data")
        tempDiseasesMutArray.add(tempDiseaseMutDict)
        
        let nutritionalDeficiencyMutDict = NSMutableDictionary()
        nutritionalDeficiencyMutDict.setValue("Nutritional Deficiency", forKey: "title")
        nutritionalDeficiencyMutDict.setValue(nutritionalDeficiencyMutArray, forKey: "data")
        tempDiseasesMutArray.add(nutritionalDeficiencyMutDict)
        
        let tempWeedMutDict = NSMutableDictionary()
        tempWeedMutDict.setValue("Weeds", forKey: "title")
        tempWeedMutDict.setValue(weedFilteredArr, forKey: "data")
        tempDiseasesMutArray.add(tempWeedMutDict)
        
        let othersMutDict = NSMutableDictionary()
        othersMutDict.setValue("Others", forKey: "title")
        othersMutDict.setValue(othersFilteredArr, forKey: "data")
        tempDiseasesMutArray.add(othersMutDict)
        
        //print(tempDiseasesMutArray)
        let userObj = Constatnts.getUserObject()
        let cropNameStr1 = cropsArray.object(at: selectedCropIndex) as? NSString
//        self.registerFirebaseEvents(CD_Crop_Library_Click, "", "", "", parameters: firebaseParams as NSDictionary)
       
        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "Crop Diagnosis Home Page","Crop" : cropNameStr1!]
        
        self.registerFirebaseEvents(CD_Crop_Library, "", "", "", parameters: firebaseParams as NSDictionary)
        
        let toLibraryVC = self.storyboard?.instantiateViewController(withIdentifier: "LibraryViewController") as! LibraryViewController
        toLibraryVC.mutArrayToDisplay = self.tempDiseasesMutArray
        toLibraryVC.backBtnTitle = cropNameStr! as String
        self.navigationController?.pushViewController(toLibraryVC, animated: true)
        
    }
/*
    //MARK: cropDiagnosisBtn Button
    @IBAction func cropDiagnosisBtn (sender : UIButton){
        let buttonPosition = sender.convert(CGPoint(x:0,y:0), to: cropDiagnosisCollView)
        let indexPath = self.cropDiagnosisCollView.indexPathForItem(at: buttonPosition)
        let cropNameStr = cropsArray.object(at: (indexPath?.row)!) as? NSString
        //print(cropNameStr!)
        
        let pestPredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Pests",cropNameStr! as String)
        let pestFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: pestPredicate)
        
        let weedPredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Weeds",cropNameStr! as String)
        let weedFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: weedPredicate)
        
        let diseaseMutArray = NSMutableArray()
        let diseasePredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Disease",cropNameStr! as String)
        let diseaseFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: diseasePredicate)
        diseaseMutArray.addObjects(from: diseaseFilteredArr)
        let fungusPredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Fungal",cropNameStr! as String)
        let fungusFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: fungusPredicate)
        diseaseMutArray.addObjects(from: fungusFilteredArr)
        let bacterialPredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Bacterial",cropNameStr! as String)
        let bacterialFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: bacterialPredicate)
        diseaseMutArray.addObjects(from: bacterialFilteredArr)
        let viralPredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Viral",cropNameStr! as String)
        let viralFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: viralPredicate)
        diseaseMutArray.addObjects(from: viralFilteredArr)
        //print(diseaseMutArray)
        
        let nutritionalDeficiencyMutArray = NSMutableArray()
        let npkPredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","NPK",cropNameStr! as String)
        let npkFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: npkPredicate)
        nutritionalDeficiencyMutArray.addObjects(from: npkFilteredArr)
        let micronutrientsPredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Micronutrients",cropNameStr! as String)
        let micronutrientsFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: micronutrientsPredicate)
        nutritionalDeficiencyMutArray.addObjects(from: micronutrientsFilteredArr)
        
        let othersPredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Others",cropNameStr! as String)
        let othersFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: othersPredicate)
        
        self.tempDiseasesMutArray.removeAllObjects()
        let tempPestMutDict = NSMutableDictionary()
        tempPestMutDict.setValue("Pests", forKey: "title")
        tempPestMutDict.setValue(pestFilteredArr, forKey: "data")
        tempDiseasesMutArray.add(tempPestMutDict)
        
        let tempDiseaseMutDict = NSMutableDictionary()
        tempDiseaseMutDict.setValue("Disease", forKey: "title")
        tempDiseaseMutDict.setValue(diseaseMutArray, forKey: "data")
        tempDiseasesMutArray.add(tempDiseaseMutDict)
        
        let nutritionalDeficiencyMutDict = NSMutableDictionary()
        nutritionalDeficiencyMutDict.setValue("Nutritional Deficiency", forKey: "title")
        nutritionalDeficiencyMutDict.setValue(nutritionalDeficiencyMutArray, forKey: "data")
        tempDiseasesMutArray.add(nutritionalDeficiencyMutDict)
        
        let tempWeedMutDict = NSMutableDictionary()
        tempWeedMutDict.setValue("Weeds", forKey: "title")
        tempWeedMutDict.setValue(weedFilteredArr, forKey: "data")
        tempDiseasesMutArray.add(tempWeedMutDict)
        
        let othersMutDict = NSMutableDictionary()
        othersMutDict.setValue("Others", forKey: "title")
        othersMutDict.setValue(othersFilteredArr, forKey: "data")
        tempDiseasesMutArray.add(othersMutDict)
        
        //print(tempDiseasesMutArray)
        let userObj = Constatnts.getUserObject()
        let cropNameStr1 = cropsArray.object(at: (indexPath?.row)!) as? NSString
        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,CROP:cropNameStr1!]
        self.registerFirebaseEvents(CD_Crop_Library_Click, "", "", "", parameters: firebaseParams as NSDictionary)
        let toLibraryVC = self.storyboard?.instantiateViewController(withIdentifier: "LibraryViewController") as! LibraryViewController
        toLibraryVC.mutArrayToDisplay = self.tempDiseasesMutArray
        toLibraryVC.backBtnTitle = cropNameStr! as String
        self.navigationController?.pushViewController(toLibraryVC, animated: true)
    }
    
    */
    /*@objc func cropDiagnosisBtn (sender : UIButton){
        let buttonPosition = sender.convert(CGPoint(x:0,y:0), to: cropDiagnosisCollView)
        let indexPath = self.cropDiagnosisCollView.indexPathForItem(at: buttonPosition)
        let cropNameStr = cropsArray.object(at: (indexPath?.row)!) as? NSString
        print(cropNameStr!)
        
        let pestPredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Pest",cropNameStr! as String)
        let pestFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: pestPredicate)
        
        let weedPredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Weed",cropNameStr! as String)
        let weedFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: weedPredicate)
        
        let diseasePredicate = NSPredicate(format: "SELF.diseaseType =[cd] %@ AND SELF.crop =[cd] %@","Disease",cropNameStr! as String)
        let diseaseFilteredArr = (self.diseasesMutArray as NSArray).filtered(using: diseasePredicate)
        
        self.tempDiseasesMutArray.removeAllObjects()
        let tempPestMutDict = NSMutableDictionary()
        tempPestMutDict.setValue("Pest", forKey: "title")
        tempPestMutDict.setValue(pestFilteredArr, forKey: "data")
        tempDiseasesMutArray.add(tempPestMutDict)
        
        let tempWeedMutDict = NSMutableDictionary()
        tempWeedMutDict.setValue("Weed", forKey: "title")
        tempWeedMutDict.setValue(weedFilteredArr, forKey: "data")
        tempDiseasesMutArray.add(tempWeedMutDict)
        
        let tempDiseaseMutDict = NSMutableDictionary()
        tempDiseaseMutDict.setValue("Disease", forKey: "title")
        tempDiseaseMutDict.setValue(diseaseFilteredArr, forKey: "data")
        tempDiseasesMutArray.add(tempDiseaseMutDict)
        print(tempDiseasesMutArray)
        let toLibraryVC = self.storyboard?.instantiateViewController(withIdentifier: "LibraryViewController") as! LibraryViewController
        toLibraryVC.mutArrayToDisplay = self.tempDiseasesMutArray
        toLibraryVC.backBtnTitle = cropNameStr! as String
        self.navigationController?.pushViewController(toLibraryVC, animated: true)
    }*/
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if cropsArray.count > 1{
            return CGSize(width: collectionView.bounds.size.width/2-15, height: collectionView.bounds.size.width/2-35)//150
        }
        return CGSize(width: collectionView.bounds.size.width-15, height: collectionView.bounds.size.width-60)//150
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)//top,left,bottom,right
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let toCapturePhotoVC = self.storyboard?.instantiateViewController(withIdentifier: "CapturePhotoViewController") as! CapturePhotoViewController
        toCapturePhotoVC.cropNameFromCropDiagnosisVC = cropsArray.object(at: indexPath.row) as? NSString
        self.navigationController?.pushViewController(toCapturePhotoVC, animated: true)
    }
    
//    @IBAction func toDiagnosisVCBtn_Touch_Up_Inside(_ sender: Any) {
//
//    }
    
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
