//
//  SprayOrdersTableViewCell.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 01/09/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import UIKit

class SprayOrdersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblFarmerName : UILabel!
    @IBOutlet weak var lblMobileNumber : UILabel!
    @IBOutlet weak var lblCrop : UILabel!
    @IBOutlet weak var lblNoOfAcres : UILabel!
    @IBOutlet weak var lblAddress : UILabel!
    @IBOutlet weak var btnViewDetails : UIButton!
    @IBOutlet weak var lblStatus : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
