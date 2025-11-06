//
//  ActivityCell.swift
//  IOSCharts
//
//  Created by Empover i-Tech Pvt Ltyd on 14/08/19.
//  Copyright © 2019 Empover. All rights reserved.
//

import UIKit

protocol CustomCollectionViewCellDelegate:class {
    func customCell(cell:ActivityCell, didTappedshow button:UIButton,object : FarmerActivitiesModel)
}
class ActivityCell: UICollectionViewCell {
    
    @IBOutlet weak var lblCropName : UILabel!
    @IBOutlet weak var imgActivity : UIImageView!
    @IBOutlet weak var lblActivityName : UILabel!
    @IBOutlet weak var showPopOver : UIButton!
    
    weak var cellDelegate:CustomCollectionViewCellDelegate?
     var arrFarmerTimeLineData : NSArray = NSArray()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func showButtonAction(_ sender: Any) {
        
        let button = sender as! UIButton
        let fcModel : FarmerActivitiesModel = arrFarmerTimeLineData.object(at: button.tag) as! FarmerActivitiesModel
        self.cellDelegate?.customCell(cell: self, didTappedshow: button, object: fcModel)
    }
   
}
