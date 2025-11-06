//
//  PopOverContentViewController.swift
//  PioneerEmployee
//
//  Created by Admin on 28/08/19.
//  Copyright © 2019 Empover. All rights reserved.
//

import UIKit

class PopOverContentViewController: UIViewController {
    
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblDateOfOrder: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblHybrid: UILabel!
    @IBOutlet weak var lblProduct: UILabel!
    
    var farmerDetails : FarmerActivitiesModel?
    var farmerActivities : FarmerInternalActivitesInMonth?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.lblType.text = farmerDetails?.activityType as String?
        
        if self.lblType.text == "Farmer Connect" {
            self.lblProduct.text = farmerActivities?.activitylblProduct as String?
            self.lblQuantity.text = farmerActivities?.activitylblHybrid as String?
            self.lblDateOfOrder.text = farmerActivities?.activitylblSeason as String?
            self.lblHybrid.text = farmerActivities?.activitylblCrop as String?
        }
        else if self.lblType.text == "Genunity Check" {
            self.lblProduct.text = farmerActivities?.activitylblDate as String?
            self.lblDateOfOrder.text =  farmerActivities?.activitylblCrop as String?
//            self.lblQuantity.text = farmerActivities?.activitylblHybrid as String?

        }
        else if self.lblType.text == "Crop Advisory" {
            self.lblProduct.text = farmerActivities?.activitylblCrop as String?
            self.lblQuantity.text = farmerActivities?.activitylblHybrid as String?
            self.lblDateOfOrder.text = farmerActivities?.activitylblDate as String?
            self.lblHybrid.text = farmerActivities?.activitylblAcres as String?
        }
        else if self.lblType.text == "Crop Diagnostics" {
            self.lblProduct.text = farmerActivities?.activitylblCrop as String?
            self.lblQuantity.text = farmerActivities?.activitylblSeason as String?
            self.lblDateOfOrder.text = farmerActivities?.activitylblUnderCrop as String?
            self.lblHybrid.text = farmerActivities?.activitylblAcres as String?
        }
        else if self.lblType.text == "Germination" {
            self.lblProduct.text = farmerActivities?.activitylblCrop as String?
            self.lblQuantity.text = farmerActivities?.activitylblSeason as String?
            self.lblDateOfOrder.text = farmerActivities?.activitylblUnderCrop as String?
            self.lblHybrid.text = farmerActivities?.activitylblAcres as String?
        }
        else if self.lblType.text == "Soil Healthcard" {
            self.lblProduct.text = farmerActivities?.activityId as String?
            self.lblQuantity.text = farmerActivities?.activitylblCrop as String?
            self.lblDateOfOrder.text = farmerActivities?.activitylblUnderCrop as String?
            self.lblHybrid.text = farmerActivities?.activitylblAcres as String?
        }
        else if self.lblType.text == "PDA" || self.lblType.text == "PSA" || self.lblType.text == "OSA" || self.lblType.text == "Agronomy" {
            self.lblProduct.text = farmerActivities?.activitylblSeason as String?
            self.lblQuantity.text = farmerActivities?.activitylblProduct as String?
            self.lblDateOfOrder.text = farmerActivities?.activitylblUnderCrop as String?
            self.lblHybrid.text = farmerActivities?.activitylblHybrid as String?
        }
        else if self.lblType.text == "Bought Products" {
            self.lblProduct.text = farmerActivities?.activitylblCrop as String?
            self.lblQuantity.text = farmerActivities?.activitylblProduct as String?
            self.lblDateOfOrder.text = farmerActivities?.activitylblDate as String?
            self.lblHybrid.text = farmerActivities?.activitylblAcres as String?
        }
        else if self.lblType.text == "Village Farmer Profiling" {
            self.lblProduct.text = farmerActivities?.activityId as String?
            self.lblQuantity.text = farmerActivities?.activitylblAcres as String?
            self.lblDateOfOrder.text = farmerActivities?.activitylblQuantity as String?
        }
        else if self.lblType.text == "Big Farmer" {
            self.lblProduct.text = farmerActivities?.activitylblCrop as String?
            self.lblHybrid.text = farmerActivities?.activitylblProduct as String?
            self.lblDateOfOrder.text = farmerActivities?.activitylblAcres as String?
            self.lblQuantity.text = farmerActivities?.activitylblQuantity as String?
        }
        else if self.lblType.text == "Pravaktha" || self.lblType.text == "Farmer Segmentation" || self.lblType.text == "Purchase Intension" {
            self.lblProduct.text = farmerActivities?.activitylblCrop as String?
            self.lblHybrid.text = farmerActivities?.activitylblProduct as String?
            self.lblDateOfOrder.text = farmerActivities?.activitylblAcres as String?
            self.lblQuantity.text = farmerActivities?.activitylblQuantity as String?
        }
        else if self.lblType.text == "Rice Next" {
            self.lblProduct.text = farmerActivities?.activitylblCrop as String?
            self.lblHybrid.text = farmerActivities?.activitylblProduct as String?
            self.lblDateOfOrder.text = farmerActivities?.activitylblHybrid as String?
            self.lblQuantity.text = farmerActivities?.activitylblQuantity as String?
        }
        else if self.lblType.text?.contains("Farm Services") ?? false {
            self.lblDateOfOrder.text = farmerActivities?.activityId as String?
        }
        else if self.lblType.text == "Paramarsh" {
            self.lblProduct.text = String(format : "Crop : %@", farmerActivities?.activityCrop as String? ?? "N/A" )
            self.lblHybrid.text = String(format : "Hybrid : %@",farmerActivities?.activityHybrid as String? ?? "N/A")
            self.lblDateOfOrder.text = String(format : "Last Issued Date : %@",farmerActivities?.activityLastIssuedDate as String? ?? "N/A")
            self.lblQuantity.text = String(format : "Resolved By : %@",farmerActivities?.activityResolvedBy as String? ?? "N/A")
        }
        else if self.lblType.text == "Crop Diagnostics" {
            self.lblProduct.text = String(format : " %@", farmerActivities?.activityCrop as String? ?? "N/A" )
            self.lblQuantity.text = String(format : " %@",farmerActivities?.activityLastIssuedDate as String? ?? "N/A")
        }
    }
}
