//
//  ReportsCell.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 21/09/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import UIKit

class ReportsCell: UITableViewCell {
    
    @IBOutlet weak var lblPincode : UILabel!
    @IBOutlet weak var lblProductName : UILabel!
    @IBOutlet weak var lblSerialNo : UILabel!
    @IBOutlet weak var lblDateOfScan : UILabel!
    @IBOutlet weak var lblMessage : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
