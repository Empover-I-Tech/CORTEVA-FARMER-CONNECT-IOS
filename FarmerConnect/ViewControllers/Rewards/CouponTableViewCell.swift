//
//  CouponTableViewCell.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 22/08/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import UIKit

class CouponTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblCouponCode : UILabel!
    @IBOutlet weak var lblProgram : UILabel!
    @IBOutlet weak var lblProgram2 : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
