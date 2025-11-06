//
//  TransactionDetailsTableViewCell.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 26/09/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import UIKit

class TransactionDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblAmount : UILabel!
    @IBOutlet weak var lblStatus : UILabel!
    @IBOutlet weak var lblCreatedOn : UILabel!
    @IBOutlet weak var lblReferenceID : UILabel!
    @IBOutlet weak var btnReclaim : UIButton!
    @IBOutlet weak var lblStatusKey: UILabel!
    
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblAmountKey : UILabel!
    @IBOutlet weak var lblRefIDKey : UILabel!
    @IBOutlet weak var lblDateKey: UILabel!
    
    @IBOutlet weak var btnMoreDetails: UIButton!
    @IBOutlet weak var reclaimHgtConstraint : NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
