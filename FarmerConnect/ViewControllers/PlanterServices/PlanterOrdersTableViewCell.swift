//
//  PlanterOrdersTableViewCell.swift
//  FarmerConnect
//
//  Created by Empover i-Tech on 29/03/23.
//  Copyright © 2023 ABC. All rights reserved.
//

import UIKit

class PlanterOrdersTableViewCell: UITableViewCell {
    @IBOutlet weak var lblFarmerName : UILabel!
    @IBOutlet weak var lblMobileNumber : UILabel!
    @IBOutlet weak var lblCrop : UILabel!
    @IBOutlet weak var lblNoOfAcres : UILabel!
    @IBOutlet weak var lblAddress : UILabel!
    @IBOutlet weak var btnViewDetails : UIButton!
    @IBOutlet weak var lblStatus : UILabel!
    @IBOutlet weak var lblDateAndTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
