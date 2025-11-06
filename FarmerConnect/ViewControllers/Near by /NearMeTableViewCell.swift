//
//  NearMeTableViewCell.swift
//  PioneerEmployee
//
//  Created by Empover on 12/08/20.
//  Copyright © 2020 Empover. All rights reserved.
//

import UIKit

class NearMeTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDistance : UILabel!
    @IBOutlet weak var lblFirmname : UILabel!
    @IBOutlet weak var lblmobileNo : UILabel!
    @IBOutlet weak var lblterritory : UILabel!
    @IBOutlet weak var lblActivity : UILabel!
    @IBOutlet weak var lblCrop : UILabel!
    @IBOutlet weak var imgUrl : UIImageView!
    @IBOutlet weak var bgView : UIView!
    @IBOutlet weak var btnCall : UIButton!
    
    @IBOutlet weak var distanceView : UIView!
    @IBOutlet weak var firmViewView : UIView!
    @IBOutlet weak var mobilenoView : UIView!
    @IBOutlet weak var territoryView : UIView!
    @IBOutlet weak var pincodeView : UIView!
    @IBOutlet weak var activityView : UIView!
    @IBOutlet weak var cropView : UIView!
    
    
    
    @IBOutlet weak var lblpincode: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 5.0
        bgView.layer.borderColor = UIColor.gray.cgColor
        bgView.layer.borderWidth = 0.8
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
