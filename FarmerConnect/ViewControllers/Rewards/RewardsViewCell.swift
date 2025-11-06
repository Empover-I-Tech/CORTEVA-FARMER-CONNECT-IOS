//
//  RewardsViewCell.swift
//  FarmerConnect
//
//  Created by Empover on 19/05/21.
//  Copyright © 2021 ABC. All rights reserved.
//

import UIKit

class RewardsViewCell: UITableViewCell {
    
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
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
