//
//  TransactionPopOverTableViewCell.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 31/12/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import UIKit

class TransactionPopOverTableViewCell: UITableViewCell {

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblReferrenceId: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

