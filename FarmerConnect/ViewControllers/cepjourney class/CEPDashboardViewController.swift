//
//  CEPDashboardViewController.swift
//  FarmerConnect
//
//  Created by EMPOVER-049 on 31/08/21.
//  Copyright © 2021 ABC. All rights reserved.
//

import UIKit
import Alamofire
class CEPDashboardViewController: BaseViewController {

    @IBOutlet weak var crophealthStack: UIView!
    @IBOutlet weak var profileUpdateStack: UIView!
    var isRHRD = false
    @IBOutlet weak var totalcashbackview: UIView!
    @IBOutlet weak var totalCropHealthView: UIView!
    @IBOutlet weak var totalShareView: UIView!
    @IBOutlet weak var totalReferralsStack: UIView!
    @IBOutlet weak var districtView: UIView!
    @IBOutlet weak var stateView: UIView!
    
    @IBOutlet weak var lblvalue_profileUpdate: UILabel!
    @IBOutlet weak var lblTitle_profileupdate: UILabel!
    @IBOutlet weak var lblTitle_cropHealthUpdate: UILabel!
    @IBOutlet weak var lblvalue_cropHealthUpdate: UILabel!
    
    @IBOutlet weak var lblTitle_totalReferrals: UILabel!
    @IBOutlet weak var lblvalue_TotalReferral: UILabel!
    
    @IBOutlet weak var lblTitle_totalSocialShare: UILabel!
    
    @IBOutlet weak var lblvalue_TotalSocialShare: UILabel!
    
    @IBOutlet weak var lblvalue_totalCropHealth: UILabel!
    @IBOutlet weak var lblTitle_cropHealth: UILabel!
    @IBOutlet weak var lbl_rankInStateTitle: UILabel!
    @IBOutlet weak var lbl_rankInDistrictTitle: UILabel!
    @IBOutlet weak var lbl_rankInState: UILabel!
    @IBOutlet weak var lbl_rankInDistrict: UILabel!
    @IBOutlet weak var bgImg: UIImageView!
    @IBOutlet weak var lblvalue_cashbacktotal: UILabel!
    @IBOutlet weak var lblTitle_totalcashback: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if isRHRD{
            self.lblTitle?.text = NSLocalizedString("cep_Dashboard", comment: "")
            totalCropHealthView.isHidden = true
            totalcashbackview.isHidden = true
            districtView.isHidden = true
            stateView.isHidden = true
            self.lblTitle_profileupdate?.text = NSLocalizedString("cep_profileupdate_dashboard", comment: "")
            self.lblTitle_cropHealthUpdate?.text = NSLocalizedString("rhrd_Dashboard_Totalcoupons", comment: "")
            self.lblTitle_totalReferrals?.text = NSLocalizedString("cep_TotalReferrals_dashboard", comment: "")
            self.lblTitle_totalSocialShare?.text = NSLocalizedString("cep_TotalSocialShare_dashboard", comment: "")
            
        }else{
            self.lblTitle?.text = NSLocalizedString("cep_Dashboard", comment: "")
            self.lblTitle_profileupdate?.text = NSLocalizedString("cep_profileupdate_dashboard", comment: "")
            self.lblTitle_cropHealthUpdate?.text = NSLocalizedString("cep_cropHealth_dashboard", comment: "")
            self.lblTitle_totalReferrals?.text = NSLocalizedString("cep_TotalReferrals_dashboard", comment: "")
            self.lblTitle_totalSocialShare?.text = NSLocalizedString("cep_TotalSocialShare_dashboard", comment: "")
            self.lblTitle_cropHealth?.text = NSLocalizedString("cep_totalCropHealth_dashboard", comment: "")
            self.lblTitle_totalcashback?.text = NSLocalizedString("cep_TotalCashback_dashboard", comment: "")
            self.lbl_rankInDistrictTitle?.text = NSLocalizedString("cep_Rank_inDistrict_dashboard", comment: "")
            self.lbl_rankInStateTitle?.text = NSLocalizedString("cep_Rank _in S_tate_dashboard", comment: "")
            
        }
       
        
      
        if isRHRD{
            loadInitalDataRHRD()
            self.bgImg.image = UIImage(named: "rhrd_referd")
        }
        else{
            loadInitalData()
        }

        
        // Do any additional setup after loading the view.
    }
    //CEP_DASHBOARDMORE_API
    
    func loadInitalData(){
        let userObj = Constatnts.getUserObject()
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? NSString
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let  submittedDateImage = dateFormatter.string(from: Date())
        
        
        let dict: NSDictionary = [
            "mobileNumber": userObj.mobileNumber! as String,
            "deviceType": "iOS",
            "loginId": userObj.customerId! as String,
            "versionNo": version ?? "",
            "lastUpdatedTime": submittedDateImage
        ]
        cepJourneySingletonClass.getCEPDashboardMore(dictionary: dict ?? NSDictionary()) { (status, responseDictionary, statusMessage) in
            SwiftLoader.hide()
            if status == true{
                print(responseDictionary)

                let dic = CEPDashboardBO(dict: responseDictionary ?? [:])
                
                self.lblvalue_profileUpdate.text = responseDictionary?.value(forKey: "profileUpdate") as? String ?? ""
                self.lblvalue_cropHealthUpdate.text = responseDictionary?.value(forKey: "cropHealthUpdate") as? String ?? ""
                if self.lblvalue_cropHealthUpdate.text == ""{
                    self.lblvalue_cropHealthUpdate.text = String(format:"%i",responseDictionary?.value(forKey: "cropHealthUpdate") as? Int ?? 0)
                }
                self.lblvalue_TotalReferral.text = responseDictionary?.value(forKey: "totalReferrals") as? String ?? ""
                if self.lblvalue_TotalReferral.text == ""{
                    self.lblvalue_TotalReferral.text = String(format:"%i",responseDictionary?.value(forKey: "totalReferrals") as? Int ?? 0)
                }
                self.lblvalue_TotalSocialShare.text = responseDictionary?.value(forKey: "totalSocialShare") as? String ?? ""
                if self.lblvalue_TotalSocialShare.text == ""{
                    self.lblvalue_TotalSocialShare.text = String(format:"%i",responseDictionary?.value(forKey: "totalSocialShare") as? Int ?? 0)
                }
                self.lblvalue_totalCropHealth.text = responseDictionary?.value(forKey: "totalCropHealth") as? String ?? ""
                if self.lblvalue_totalCropHealth.text == ""{
                    self.lblvalue_totalCropHealth.text = String(format:"%i",responseDictionary?.value(forKey: "totalCropHealth") as? Int ?? 0)
                }
                self.lblvalue_cashbacktotal.text = responseDictionary?.value(forKey: "totalCashback") as? String ?? ""
                if self.lblvalue_cashbacktotal.text == ""{
                    self.lblvalue_cashbacktotal.text = String(format:"%i",responseDictionary?.value(forKey: "totalCashback") as? Int ?? 0)
                }
                self.lbl_rankInDistrict.text = responseDictionary?.value(forKey: "rankinDistrict") as? String ?? ""
                if self.lbl_rankInDistrict.text == ""{
                    self.lbl_rankInDistrict.text = String(format:"%i",responseDictionary?.value(forKey: "rankinDistrict") as? Int ?? 0)
                }
                self.lbl_rankInState.text = responseDictionary?.value(forKey: "rankinState") as? String ?? ""
                if self.lbl_rankInState.text == ""{
                    self.lbl_rankInState.text = String(format:"%i",responseDictionary?.value(forKey: "rankinState") as? Int ?? 0)
                }
                if responseDictionary?.value(forKey: "profileUpdateVisible") as? Bool == false{
                    self.profileUpdateStack.isHidden = true
                }
                if responseDictionary?.value(forKey: "totalCashbackVisible") as? Bool == false{
                    self.totalcashbackview.isHidden = true
                }
                if responseDictionary?.value(forKey: "totalReferralsVisible") as? Bool == false{
                    self.totalReferralsStack.isHidden = true
                }
                if responseDictionary?.value(forKey: "totalSocialShareVisible") as? Bool == false{
                    self.totalShareView.isHidden = true
                }
                if responseDictionary?.value(forKey: "cropHealthUpdateVisible") as? Bool == false{
                    self.crophealthStack.isHidden = true
                }
                if responseDictionary?.value(forKey: "totalCropHealthVisible") as? Bool == false{
                    self.totalCropHealthView.isHidden = true
                }
                if responseDictionary?.value(forKey: "rankinDistrictVisible") as? Bool == false{
                    self.districtView.isHidden = true
                }
                if responseDictionary?.value(forKey: "rankinStateVisible") as? Bool == false{
                    self.stateView.isHidden = true
                }
            
                
            }else{
                self.view.makeToast(statusMessage as String? ?? "")
            }
        }
    }
    
    func loadInitalDataRHRD(){
        let userObj = Constatnts.getUserObject()
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? NSString
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let  submittedDateImage = dateFormatter.string(from: Date())
        
        
        let dict: NSDictionary = [
            "mobileNumber": userObj.mobileNumber! as String,
            "deviceType": "iOS",
            "loginId": userObj.customerId! as String,
            "versionNo": version ?? "",
            "lastUpdatedTime": submittedDateImage
        ]
        cepJourneySingletonClass.getRHRDDashboardMore(dictionary: dict ?? NSDictionary()) { (status, responseDictionary, statusMessage) in
            SwiftLoader.hide()
            if status == true{
                print(responseDictionary)

                let dic = CEPDashboardBO(dict: responseDictionary ?? [:])
                
                self.lblvalue_profileUpdate.text = responseDictionary?.value(forKey: "profileUpdate") as? String ?? ""
                self.lblvalue_cropHealthUpdate.text = responseDictionary?.value(forKey: "cropHealthUpdate") as? String ?? ""
                if self.lblvalue_cropHealthUpdate.text == ""{
                    self.lblvalue_cropHealthUpdate.text = String(format:"%i",responseDictionary?.value(forKey: "cropHealthUpdate") as? Int ?? 0)
                }
                self.lblvalue_TotalReferral.text = responseDictionary?.value(forKey: "totalReferrals") as? String ?? ""
                if self.lblvalue_TotalReferral.text == ""{
                    self.lblvalue_TotalReferral.text = String(format:"%i",responseDictionary?.value(forKey: "totalReferrals") as? Int ?? 0)
                }
                self.lblvalue_TotalSocialShare.text = responseDictionary?.value(forKey: "totalSocialShare") as? String ?? ""
                if self.lblvalue_TotalSocialShare.text == ""{
                    self.lblvalue_TotalSocialShare.text = String(format:"%i",responseDictionary?.value(forKey: "totalSocialShare") as? Int ?? 0)
                }
                self.lblvalue_totalCropHealth.text = responseDictionary?.value(forKey: "totalCropHealth") as? String ?? ""
                if self.lblvalue_totalCropHealth.text == ""{
                    self.lblvalue_totalCropHealth.text = String(format:"%i",responseDictionary?.value(forKey: "totalCropHealth") as? Int ?? 0)
                }
                self.lblvalue_cashbacktotal.text = responseDictionary?.value(forKey: "totalCashback") as? String ?? ""
                if self.lblvalue_cashbacktotal.text == ""{
                    self.lblvalue_cashbacktotal.text = String(format:"%i",responseDictionary?.value(forKey: "totalCashback") as? Int ?? 0)
                }
                self.lbl_rankInDistrict.text = responseDictionary?.value(forKey: "rankinDistrict") as? String ?? ""
                if self.lbl_rankInDistrict.text == ""{
                    self.lbl_rankInDistrict.text = String(format:"%i",responseDictionary?.value(forKey: "rankinDistrict") as? Int ?? 0)
                }
                self.lbl_rankInState.text = responseDictionary?.value(forKey: "rankinState") as? String ?? ""
                if self.lbl_rankInState.text == ""{
                    self.lbl_rankInState.text = String(format:"%i",responseDictionary?.value(forKey: "rankinState") as? Int ?? 0)
                }
            }else{
                self.view.makeToast(statusMessage as String? ?? "")
            }
        }
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
