//
//  RewardsViewCell.swift
//  FarmerConnect
//
//  Created by Empover on 19/05/21.
//  Copyright © 2021 ABC. All rights reserved.
//

import UIKit

class RGLRewardsViewCell: UITableViewCell {
    

    @IBOutlet weak var orderIdDisplayLbl: UILabel!
    
    @IBOutlet weak var dateDisplayLbl: UILabel!
    @IBOutlet weak var orderQunDisplayLbl: UILabel!
    
    @IBOutlet weak var approvedDisplayLbl: UILabel!
    
    @IBOutlet weak var redeemDisplayLbl: UILabel!
    
    @IBOutlet weak var addRewardDisplaylbl: UILabel!
    
    @IBOutlet weak var orderStatusDisplayLbl: UILabel!
    
    
    
    @IBOutlet weak var orderIdValueLbl: UILabel!
    @IBOutlet weak var dateValueLbl: UILabel!
    @IBOutlet weak var orderQunValueLbl: UILabel!
    @IBOutlet weak var approvedValueLbl: UILabel!
    @IBOutlet weak var redeemValueLbl: UILabel!
    @IBOutlet weak var addRewardValueLbl: UILabel!
    @IBOutlet weak var orderStatusValueLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
